-- Cryopods: 2-tall pods (like a door) with a sleeper behind frosted glass.
--
-- Right-click a free pod to make it yours (one each); right-click your pod to
-- climb in. Jump or sneak to step out. Log out inside it and you wake there;
-- die and you respawn in front of it.

local S = csd_ship.S

local function front_dir(param2)
	-- The glass front is the -Z face, i.e. opposite the facedir direction.
	return vector.multiply(core.facedir_to_dir(param2 % 32), -1)
end

local function bottom_of(pos, node)
	if node.name == "csd_ship:cryo_pod_top" then return vector.offset(pos, 0, -1, 0) end
	return pos
end

local function pod_infotext(owner)
	if owner == "" then return S("Cryopod (free - right-click to make it yours)") end
	return S("@1's cryopod", owner)
end

local function pod_def(top)
	local front = top and "csd_ship_cryo2_front_top.png" or "csd_ship_cryo2_front_bottom.png"
	return {
		description = S("Cryopod"),
		drawtype = "nodebox",
		node_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}}},
		tiles = {"csd_ship_cryo2_top.png", "csd_ship_cryo2_top.png", "csd_ship_cryo2_side.png",
			"csd_ship_cryo2_side.png", "csd_ship_cryo2_side.png", front},
		use_texture_alpha = "blend",
		paramtype = "light",
		paramtype2 = "facedir",
		light_source = 5,
		light_colour = "#88ddff",
		sunlight_propagates = true,
		inventory_image = "csd_ship_cryo2_inv.png",
		wield_image = "csd_ship_cryo2_inv.png",
		groups = {cracky = 2, csd_ship = 1, csd_cryopod = 1, not_in_creative_inventory = top and 1 or nil},
		drop = "csd_ship:cryo_pod",
		is_ground_content = false,
	}
end

local bottom = pod_def(false)
bottom.on_place = function(itemstack, placer, pointed)
	-- needs room for the top half
	local above = pointed.above
	local up = vector.offset(above, 0, 1, 0)
	local unode = core.get_node(up)
	local udef = core.registered_nodes[unode.name]
	if not (udef and udef.buildable_to) or (placer and core.is_protected(up, placer:get_player_name())) then
		return itemstack
	end
	return core.item_place(itemstack, placer, pointed)
end
bottom.after_place_node = function(pos)
	local node = core.get_node(pos)
	core.set_node(vector.offset(pos, 0, 1, 0), {name = "csd_ship:cryo_pod_top", param2 = node.param2})
	core.get_meta(pos):set_string("infotext", pod_infotext(""))
end
bottom.after_destruct = function(pos)
	local up = vector.offset(pos, 0, 1, 0)
	if core.get_node(up).name == "csd_ship:cryo_pod_top" then core.remove_node(up) end
end
core.register_node("csd_ship:cryo_pod", bottom)

local top = pod_def(true)
top.after_destruct = function(pos)
	local down = vector.offset(pos, 0, -1, 0)
	if core.get_node(down).name == "csd_ship:cryo_pod" then core.remove_node(down) end
end
core.register_node("csd_ship:cryo_pod_top", top)

------------------------------------------------------------------------------
-- Ownership and sleeping
------------------------------------------------------------------------------

local in_pod = {} -- name -> {ent, pos, hud}

local function my_pod(player)
	local s = player:get_meta():get_string("csd_ship:pod")
	if s == "" then return nil end
	local pos = core.string_to_pos(s)
	local node = pos and core.get_node_or_nil(pos)
	-- unloaded: trust the record; loaded: check it's still a pod and still ours
	if node and (node.name ~= "csd_ship:cryo_pod" or core.get_meta(pos):get_string("owner") ~= player:get_player_name()) then
		player:get_meta():set_string("csd_ship:pod", "")
		return nil
	end
	return pos
end

local function step_out(player)
	local name = player:get_player_name()
	local s = in_pod[name]
	if not s then return end
	in_pod[name] = nil
	player:set_detach()
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	if s.hud then player:hud_remove(s.hud) end
	if core.global_exists("player_api") then player_api.player_attached[name] = false end
	if s.ent then s.ent:remove() end
	local node = core.get_node(s.pos)
	player:set_pos(vector.add(s.pos, vector.multiply(front_dir(node.param2), 1)))
	player:get_meta():set_string("csd_ship:asleep", "")
end

local function climb_in(player, pos)
	local name = player:get_player_name()
	if in_pod[name] then step_out(player) end
	local node = core.get_node(pos)
	local ent = core.add_entity(vector.offset(pos, 0, -0.5, 0), "csd_core:seat")
	if not ent then return end
	ent:set_yaw(core.dir_to_yaw(front_dir(node.param2)))
	player:set_attach(ent, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player:set_look_horizontal(core.dir_to_yaw(front_dir(node.param2)))
	player:set_eye_offset({x = 0, y = 0, z = 3}, {x = 0, y = 0, z = 0})
	if core.global_exists("player_api") then
		player_api.player_attached[name] = true
		player_api.set_animation(player, "stand")
	end
	local hud = player:hud_add({
		type = "image", position = {x = 0.5, y = 0.5}, alignment = {x = 0, y = 0},
		scale = {x = -100, y = -100}, text = "csd_ship_cryo_frost.png", z_index = -20,
	})
	in_pod[name] = {ent = ent, pos = pos, hud = hud}
	player:get_meta():set_string("csd_ship:asleep", "1")
end

local function on_rightclick(pos, node, clicker)
	if not clicker or not clicker:is_player() then return end
	pos = bottom_of(pos, node)
	local name = clicker:get_player_name()
	local meta = core.get_meta(pos)
	local owner = meta:get_string("owner")
	if owner ~= "" and owner ~= name then
		core.chat_send_player(name, S("This cryopod belongs to @1.", owner))
		return
	end
	if owner == "" then
		-- release the old one, take this one
		local old = my_pod(clicker)
		if old and core.get_node_or_nil(old) then
			core.get_meta(old):set_string("owner", "")
			core.get_meta(old):set_string("infotext", pod_infotext(""))
		end
		meta:set_string("owner", name)
		meta:set_string("infotext", pod_infotext(name))
		clicker:get_meta():set_string("csd_ship:pod", core.pos_to_string(pos))
		core.chat_send_player(name, S("This cryopod is yours now. You'll respawn here, and if you log out inside it you'll wake up here. Right-click again to climb in."))
		return
	end
	climb_in(clicker, pos)
	core.chat_send_player(name, S("You settle into your cryopod. Log out any time - jump to step out."))
end

core.override_item("csd_ship:cryo_pod", {on_rightclick = on_rightclick})
core.override_item("csd_ship:cryo_pod_top", {on_rightclick = on_rightclick})

core.register_globalstep(function()
	for name, s in pairs(in_pod) do
		local player = core.get_player_by_name(name)
		if player and not player:get_attach() then
			-- detached some other way (teleport, another mod): tidy up
			if s.hud then player:hud_remove(s.hud) end
			player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
			if core.global_exists("player_api") then player_api.player_attached[name] = false end
			if s.ent then s.ent:remove() end
			in_pod[name] = nil
		elseif player then
			local c = player:get_player_control()
			if c.jump or c.sneak then step_out(player) end
		else
			in_pod[name] = nil
		end
	end
end)

core.register_on_leaveplayer(function(player)
	local s = in_pod[player:get_player_name()]
	if s then
		-- stay "asleep" so we wake up here next time
		if s.ent then s.ent:remove() end
		in_pod[player:get_player_name()] = nil
	end
end)

core.register_on_joinplayer(function(player)
	if player:get_meta():get_string("csd_ship:asleep") ~= "1" then return end
	core.after(1.5, function()
		if not player:is_player() then return end
		local pos = my_pod(player)
		if pos then
			-- make sure the block is there before climbing back in
			core.load_area(pos)
			climb_in(player, pos)
			core.chat_send_player(player:get_player_name(), S("You wake up in your cryopod. Jump to step out."))
		else
			player:get_meta():set_string("csd_ship:asleep", "")
		end
	end)
end)

csd_core.register_home_provider(function(player)
	local pos = my_pod(player)
	if not pos then return nil end
	core.load_area(pos)
	local node = core.get_node(pos)
	if node.name ~= "csd_ship:cryo_pod" then return nil end
	return vector.add(pos, front_dir(node.param2))
end)

core.register_on_dieplayer(function(player)
	if in_pod[player:get_player_name()] then step_out(player) end
end)

-- Generator helper: a pod with its glass facing `facing` (unit vector).
function csd_ship.place_cryopod(b, x, y, z, facing)
	local p2 = core.dir_to_facedir(vector.multiply(facing, -1))
	b:set(x, y, z, "csd_ship:cryo_pod", p2)
	b:set(x, y + 1, z, "csd_ship:cryo_pod_top", p2)
	b:meta(x, y, z, {infotext = pod_infotext("")})
end
