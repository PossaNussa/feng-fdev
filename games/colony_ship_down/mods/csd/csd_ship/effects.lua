-- What the ship's systems look like. Low systems show around the crew:
--   Power        lights flicker
--   Life Support haze hangs in the air
--   Hydroponics  plants wilt
--   Comms        wall screens turn to static
--   Hull         sparks and steam from the walls
-- (Navigation slows the star drift outside, see stars.lua.)
-- Effects only run near players, so they cost nothing in empty parts of the ship.

if not core.get_modpath("csd_tasks") then return end

local S = csd_ship.S
local LOW = 35

core.register_node("csd_ship:plant_wilted", {
	description = S("Wilted Ship Fern"),
	drawtype = "plantlike",
	tiles = {"csd_ship_plant_wilted.png"},
	inventory_image = "csd_ship_plant_wilted.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {type = "fixed", fixed = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3}},
	groups = {snappy = 3, csd_ship = 1, not_in_creative_inventory = 1},
	drop = "csd_ship:plant",
	is_ground_content = false,
})

do
	local def = {}
	for k, v in pairs(core.registered_nodes["csd_ship:screen"]) do
		if k ~= "name" and k ~= "type" and k ~= "mod_origin" then def[k] = type(v) == "table" and table.copy(v) or v end
	end
	def.description = S("Wall Screen (Static)")
	def.tiles[6] = {name = "csd_ship_screen_static.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.4}}
	def.groups = {cracky = 3, csd_ship = 1, not_in_creative_inventory = 1}
	def.drop = "csd_ship:screen"
	core.register_node("csd_ship:screen_static", def)
end

local function low(id) return csd_tasks.get_system(id) < LOW end

-- Node pairs that swap with a system: {system, healthy node, failing node}
local SWAPS = {
	{"hydroponics", "csd_ship:plant", "csd_ship:plant_wilted"},
	{"comms", "csd_ship:screen", "csd_ship:screen_static"},
}

local function sync_nodes(pos)
	local r = vector.new(14, 6, 14)
	for _, sw in ipairs(SWAPS) do
		local from, to = sw[3], sw[2] -- recovering: failing -> healthy
		if low(sw[1]) then from, to = sw[2], sw[3] end
		local found = core.find_nodes_in_area(vector.subtract(pos, r), vector.add(pos, r), {from})
		for _, p in ipairs(found) do
			local n = core.get_node(p)
			core.swap_node(p, {name = to, param2 = n.param2})
		end
	end
end

local function flicker(pos)
	local lights = core.find_nodes_in_area(vector.offset(pos, -12, -3, -12), vector.offset(pos, 12, 8, 12), {"csd_ship:light"})
	if #lights == 0 then return end
	local power = csd_tasks.get_system("power")
	local n = power < 15 and 4 or 1
	for _ = 1, n do
		local p = lights[math.random(#lights)]
		core.swap_node(p, {name = "csd_ship:light_off"})
		core.after(0.15 + math.random() * 0.4, function()
			local node = core.get_node_or_nil(p)
			if node and node.name == "csd_ship:light_off" and csd_ship.lighting_mode == "normal" then
				core.swap_node(p, {name = "csd_ship:light"})
			end
		end)
	end
end

local function haze(player)
	local amount = math.floor(40 * csd_core.particle_level(player:get_player_name()))
	if amount < 1 then return end
	core.add_particlespawner({
		amount = amount, time = 2, playername = player:get_player_name(),
		pos = {min = vector.offset(player:get_pos(), -6, 0, -6), max = vector.offset(player:get_pos(), 6, 4, 6)},
		vel = {min = vector.new(-0.1, -0.05, -0.1), max = vector.new(0.1, 0.1, 0.1)},
		exptime = {min = 2, max = 4}, size = {min = 2, max = 5}, texture = "csd_ship_haze.png",
	})
end

local function hull_damage(pos)
	local walls = core.find_nodes_in_area(vector.offset(pos, -8, 0, -8), vector.offset(pos, 8, 4, 8),
		{"csd_ship:wall", "csd_ship:wall_pipes", "csd_ship:hull"})
	if #walls == 0 then return end
	local p = walls[math.random(#walls)]
	core.add_particlespawner({
		amount = 20, time = 0.4, pos = p,
		vel = {min = vector.new(-2, -1, -2), max = vector.new(2, 2, 2)}, acc = vector.new(0, -8, 0),
		exptime = 0.6, size = 0.8, glow = 14, texture = "csd_ship_spark.png",
	})
	core.add_particlespawner({
		amount = 15, time = 1.5, pos = p,
		vel = {min = vector.new(-0.4, 0.5, -0.4), max = vector.new(0.4, 1.2, 0.4)},
		exptime = 2, size = {min = 3, max = 6}, texture = "csd_ship_steam.png",
	})
	core.sound_play("csd_events_impact", {pos = p, gain = 0.15, max_hear_distance = 12, pitch = 1.6}, true)
end

local t_fast, t_slow = 0, 0
core.register_globalstep(function(dtime)
	t_fast = t_fast + dtime
	t_slow = t_slow + dtime
	local fast = t_fast >= 1.5
	local slow = t_slow >= 5
	if fast then t_fast = 0 end
	if slow then t_slow = 0 end
	if not (fast or slow) then return end
	for _, player in ipairs(core.get_connected_players()) do
		local pos = vector.round(player:get_pos())
		if csd_ship.room_at(pos) or csd_ship.deck_at(pos) then
			if fast then
				if low("power") and csd_ship.lighting_mode == "normal" and math.random() < 0.6 then flicker(pos) end
				if low("hull") and math.random() < 0.3 then hull_damage(pos) end
			end
			if slow then
				sync_nodes(pos)
				if low("life_support") then haze(player) end
			end
		end
	end
end)
