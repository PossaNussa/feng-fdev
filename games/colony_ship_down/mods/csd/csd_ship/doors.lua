-- Vertical sliding doors: a 2-tall panel that slides up into the wall above.
--
-- Each half has three looks - full, upper half, none - and opening steps
-- through (2,2) (1,2) (0,2) (0,1) (0,0) quickly, so the panel visibly rises.
-- Neighbouring door columns in the same wall open together (wide doorways).
-- Doors into a claimed room only open for its owner (and builders), and
-- close themselves after a few seconds.

local S = csd_ship.S

local STATES = {{2, 2}, {1, 2}, {0, 2}, {0, 1}, {0, 0}} -- {bottom, top} panel coverage
local STEP_TIME = 0.08
local AUTO_CLOSE = 6

local function bname(c) return c == 2 and "csd_ship:door" or ("csd_ship:door_b" .. c) end
local function tname(c) return "csd_ship:door_t" .. c end

-- panel spans X, thin along Z (facedir rotates it)
local function panel_box(c)
	if c == 2 then return {-0.5, -0.5, -0.12, 0.5, 0.5, 0.12} end
	if c == 1 then return {-0.5, 0, -0.12, 0.5, 0.5, 0.12} end
	return nil
end

local FRAME = {-0.5, 0.46, -0.14, 0.5, 0.5, 0.14} -- a lip to click when fully open

local function on_rightclick(pos, node, clicker)
	if clicker and clicker:is_player() then csd_ship.toggle_door(pos, clicker) end
end

local function register_half(name, c, top)
	local box = panel_box(c)
	core.register_node(name, {
		description = S("Sliding Door"),
		drawtype = "nodebox",
		node_box = {type = "fixed", fixed = box or FRAME},
		selection_box = {type = "fixed", fixed = box or {-0.5, -0.5, -0.12, 0.5, 0.5, 0.12}},
		collision_box = {type = "fixed", fixed = box or FRAME},
		walkable = box ~= nil,
		tiles = {"csd_ship_door_edge.png", "csd_ship_door_edge.png", "csd_ship_door_edge.png",
			"csd_ship_door_edge.png", top and "csd_ship_door_top.png" or "csd_ship_door_bottom.png",
			top and "csd_ship_door_top.png" or "csd_ship_door_bottom.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		inventory_image = "csd_ship_door_inv.png",
		wield_image = "csd_ship_door_inv.png",
		drop = "csd_ship:door",
		groups = {cracky = 2, csd_ship = 1, csd_door = 1, not_in_creative_inventory = (name ~= "csd_ship:door") and 1 or nil},
		is_ground_content = false,
		on_rightclick = on_rightclick,
		on_timer = function(p) csd_ship.close_door_auto(p) end,
	})
end

for _, c in ipairs({2, 1, 0}) do
	register_half(bname(c), c, false)
	register_half(tname(c), c, true)
end

-- Placing a door puts both halves.
core.override_item("csd_ship:door", {
	on_place = function(itemstack, placer, pointed)
		if pointed.type ~= "node" then return itemstack end
		local up = vector.offset(pointed.above, 0, 1, 0)
		local udef = core.registered_nodes[core.get_node(up).name]
		if not (udef and udef.buildable_to) or (placer and core.is_protected(up, placer:get_player_name())) then
			return itemstack
		end
		local dir = placer and placer:get_look_dir() or vector.new(0, 0, 1)
		local p2 = math.abs(dir.x) > math.abs(dir.z) and 1 or 0
		return core.item_place(itemstack, placer, pointed, p2)
	end,
	after_place_node = function(pos)
		local node = core.get_node(pos)
		core.set_node(vector.offset(pos, 0, 1, 0), {name = tname(2), param2 = node.param2})
	end,
	after_destruct = function(pos)
		local up = vector.offset(pos, 0, 1, 0)
		if core.get_item_group(core.get_node(up).name, "csd_door") > 0 then core.remove_node(up) end
	end,
})

-- Door anatomy ---------------------------------------------------------------

local function is_door(name) return core.get_item_group(name, "csd_door") > 0 end
local function is_top(name) return name:find("^csd_ship:door_t") ~= nil end

local function bottom_of(pos)
	local n = core.get_node(pos)
	if is_top(n.name) then return vector.offset(pos, 0, -1, 0) end
	return pos
end

local function state_index(bpos)
	local b, t = core.get_node(bpos).name, core.get_node(vector.offset(bpos, 0, 1, 0)).name
	for i, s in ipairs(STATES) do
		if bname(s[1]) == b and tname(s[2]) == t then return i end
	end
	return 1
end

-- All door columns in a row (same wall), starting from one bottom position.
local function columns(bpos)
	local node = core.get_node(bpos)
	local along = (node.param2 % 4 == 1 or node.param2 % 4 == 3) and vector.new(0, 0, 1) or vector.new(1, 0, 0)
	local out = {bpos}
	for _, sgn in ipairs({1, -1}) do
		for k = 1, 4 do
			local p = vector.add(bpos, vector.multiply(along, k * sgn))
			if is_door(core.get_node(p).name) and not is_top(core.get_node(p).name) then
				out[#out + 1] = p
			else
				break
			end
		end
	end
	return out
end

local function set_state(bpos, i)
	local node = core.get_node(bpos)
	core.swap_node(bpos, {name = bname(STATES[i][1]), param2 = node.param2})
	core.swap_node(vector.offset(bpos, 0, 1, 0), {name = tname(STATES[i][2]), param2 = node.param2})
end

local function animate(cols, from, to)
	local step = to > from and 1 or -1
	local k = 0
	for i = from + step, to, step do
		k = k + 1
		core.after(k * STEP_TIME, function()
			for _, p in ipairs(cols) do
				if is_door(core.get_node(p).name) then set_state(p, i) end
			end
		end)
	end
end

-- Who may open: the owner of a claimed room on either side (or anyone).
local function may_open(bpos, player)
	local name = player:get_player_name()
	if csd_core.is_builder(name) then return true end
	local node = core.get_node(bpos)
	local front = core.facedir_to_dir(node.param2 % 32)
	for _, sgn in ipairs({1, -1}) do
		local owner = csd_ship.claim_owner_at and csd_ship.claim_owner_at(vector.add(bpos, vector.multiply(front, sgn)))
		if owner and owner ~= name then return false, owner end
	end
	return true
end

function csd_ship.toggle_door(pos, player)
	local bpos = bottom_of(pos)
	local cols = columns(bpos)
	local i = state_index(bpos)
	if i == 1 then
		local ok, owner = may_open(bpos, player)
		if not ok then
			core.chat_send_player(player:get_player_name(), S("Locked - this is @1's room.", owner))
			core.sound_play("csd_tasks_click", {pos = bpos, gain = 0.5, pitch = 0.5}, true)
			return
		end
		animate(cols, 1, #STATES)
		core.get_node_timer(bpos):start(AUTO_CLOSE)
	else
		animate(cols, i, 1)
	end
	core.sound_play("csd_sfx_door", {pos = bpos, gain = 0.5, max_hear_distance = 12}, true)
end

function csd_ship.close_door_auto(pos)
	local bpos = bottom_of(pos)
	if state_index(bpos) == 1 then return end
	-- someone standing in the doorway? wait a bit longer
	for _, obj in ipairs(core.get_objects_inside_radius(vector.offset(bpos, 0, 0.5, 0), 1.2)) do
		if obj:is_player() then
			core.get_node_timer(bpos):start(2)
			return
		end
	end
	animate(columns(bpos), state_index(bpos), 1)
	core.sound_play("csd_sfx_door", {pos = bpos, gain = 0.5, max_hear_distance = 12}, true)
end

-- Generator helper: a closed door filling (x, y..y+1, z), panel along X or Z.
function csd_ship.place_door(b, x, y, z, along_z)
	local p2 = along_z and 1 or 0
	b:set(x, y, z, "csd_ship:door", p2)
	b:set(x, y + 1, z, tname(2), p2)
end
