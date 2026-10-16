-- Real seats: right-click a seat node to sit (you're attached to it, with the
-- sit animation, until you jump or sneak to stand up).
--
-- Any node can be a seat: give it `_csd_seat = {height = 0.05}` (seat surface
-- relative to the node centre) and `on_rightclick = csd_core.sit_on_node`.
-- Seats face away from their backrest: the node's facedir points at the back
-- (or, with `reverse = true`, the way the sitter faces).

local S = core.get_translator("csd_core")

local sitting = {}  -- name -> {ent = ObjectRef, key = pos string, physics = table}
local occupied = {} -- pos string -> name

core.register_entity("csd_core:seat", {
	initial_properties = {
		physical = false,
		pointable = false,
		-- Visible but fully transparent: a hidden parent would hide whoever sits on it.
		visual = "sprite",
		textures = {"blank.png"},
		visual_size = {x = 1, y = 1},
		is_visible = true,
		static_save = false,
	},
})

local function set_anim(player, anim)
	if core.global_exists("player_api") and player_api.set_animation then
		player_api.set_animation(player, anim, 30)
	end
end

function csd_core.stand_up(player)
	local name = player:get_player_name()
	local s = sitting[name]
	if not s then return end
	sitting[name] = nil
	occupied[s.key] = nil
	player:set_detach()
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	if core.global_exists("player_api") then
		player_api.player_attached[name] = false
	end
	set_anim(player, "stand")
	if s.ent then s.ent:remove() end
	-- Step off the seat, onto the floor in front of it.
	player:set_pos(vector.add(s.pos, vector.multiply(s.front, 0.8)))
end

function csd_core.is_sitting(name)
	return sitting[name] ~= nil
end

-- yaw_dir: the direction the sitter faces
function csd_core.sit(player, seat_pos, yaw_dir, node_pos)
	local name = player:get_player_name()
	if sitting[name] then csd_core.stand_up(player) end
	local key = core.pos_to_string(node_pos or vector.round(seat_pos))
	if occupied[key] then
		core.chat_send_player(name, S("Someone is already sitting there."))
		return false
	end
	local ent = core.add_entity(seat_pos, "csd_core:seat")
	if not ent then return false end
	local yaw = core.dir_to_yaw(yaw_dir)
	ent:set_yaw(yaw)
	player:set_attach(ent, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player:set_look_horizontal(yaw)
	player:set_eye_offset({x = 0, y = -6, z = 1}, {x = 0, y = -4, z = 0})
	if core.global_exists("player_api") then
		player_api.player_attached[name] = true
	end
	set_anim(player, "sit")
	sitting[name] = {ent = ent, key = key, pos = node_pos or vector.round(seat_pos), front = yaw_dir}
	occupied[key] = name
	return true
end

function csd_core.sit_on_node(pos, node, clicker, itemstack)
	if not clicker or not clicker:is_player() then return itemstack end
	local def = core.registered_nodes[node.name]
	local seat = def and def._csd_seat or {}
	if vector.distance(clicker:get_pos(), pos) > 3 then return itemstack end
	local back = def.paramtype2 == "facedir" and core.facedir_to_dir(node.param2 % 32) or vector.new(0, 0, 1)
	if seat.reverse then back = vector.multiply(back, -1) end -- facedir points the way you face
	local front = vector.multiply(back, -1)
	-- The sit animation is made for sitting on the ground, so lift the seat
	-- point by about half a node to put you on the seat, not the floor.
	local seat_pos = vector.offset(pos, 0, (seat.height or 0) + 0.45, 0)
	csd_core.sit(clicker, vector.add(seat_pos, vector.multiply(back, seat.back or 0.05)), front, pos)
	return itemstack
end

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	for name, s in pairs(sitting) do
		local player = core.get_player_by_name(name)
		if not player or not s.ent:get_pos() then
			sitting[name] = nil
			occupied[s.key] = nil
		else
			local ctrl = player:get_player_control()
			if ctrl.jump or ctrl.sneak then
				csd_core.stand_up(player)
			elseif timer > 1 then
				set_anim(player, "sit") -- keep it (other mods may reset animations)
			end
		end
	end
	if timer > 1 then timer = 0 end
end)

local function cleanup(player)
	if sitting[player:get_player_name()] then csd_core.stand_up(player) end
end
core.register_on_leaveplayer(cleanup)
core.register_on_dieplayer(cleanup)

core.register_on_shutdown(function()
	for _, player in ipairs(core.get_connected_players()) do cleanup(player) end
end)
