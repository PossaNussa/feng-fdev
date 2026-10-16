-- creaturemob :: creatura/legacy_spawn.lua
--
-- Restores the pre-2025 semantics of `creatura.register_mob_spawn`.
--
-- Upstream deprecated that function and reduced it to a shim forwarding to
-- register_abm_spawn(). That is not a like-for-like translation:
--
--   old: ONE probe per player per `creatura_spawn_step` seconds, then a
--        1-in-`chance` roll. Rate is independent of the world.
--   new: a real ABM on `nodes`. It fires for EVERY matching node in EVERY
--        active mapblock, every `interval` seconds, each with a 1-in-`chance`
--        roll. Rate scales with how common the node is.
--
-- draconis registers `draconis:jungle_wyvern` with `chance = 16` and
-- `nodes = {"group:leaves"}`. As a probe that is one roll per player per 15 s.
-- As an ABM it is tens of thousands of rolls per interval in any forest — which
-- is exactly the wyvern flood this file exists to stop.
--
-- There is a second, larger fact. The old globalstep spawner was guarded by
--
--     if #creatura.registered_mob_spawns < 1 then return end
--
-- and that table is keyed by mob name, so `#` on it is always 0. The guard was
-- always true and the spawner never ran once. Every mob registered through
-- `register_mob_spawn` has therefore never spawned naturally, in any version of
-- this game.
--
-- So the behaviour-preserving choice is to record the registration and spawn
-- nothing. The corrected globalstep spawner is here too, behind an opt-in
-- setting, because "it was broken" is a reason to offer the feature, not a
-- reason to enable it behind the player's back.

local S_LEGACY = minetest.settings:get_bool("creatura_legacy_globalstep_spawning") == true

local abs, min, max, random = math.abs, math.min, math.max, math.random
local vec_dist = vector.distance

local function vec_raise(v, n)
	return {x = v.x, y = v.y + n, z = v.z}
end

----------------------------------------------------------------------
-- Registration
----------------------------------------------------------------------

-- Records the spawn definition and nothing else. `registered_mob_spawns` is
-- read directly by consumer mods (draconis among them), so it must stay
-- populated even though upstream's shim stopped filling it in.

function creatura.register_mob_spawn(name, def)

	creatura.registered_mob_spawns[name] = {
		chance = def.chance or 5,
		min_height = def.min_height or 0,
		max_height = def.max_height or 128,
		min_time = def.min_time or 0,
		max_time = def.max_time or 24000,
		min_light = def.min_light or 6,
		max_light = def.max_light or 15,
		min_group = def.min_group or 1,
		max_group = def.max_group or 4,
		nodes = def.nodes or nil,
		biomes = def.biomes or nil,
		spawn_cluster = def.spawn_cluster or false,
		spawn_on_gen = def.spawn_on_gen or false,
		spawn_in_nodes = def.spawn_in_nodes or false,
		spawn_cap = def.spawn_cap or 5,
		send_debug = def.send_debug or false
	}
end

if not S_LEGACY then return end

----------------------------------------------------------------------
-- Opt-in: the globalstep spawner, with the counting bug fixed
----------------------------------------------------------------------

local walkable_nodes

minetest.register_on_mods_loaded(function()
	walkable_nodes = {}

	for name, def in pairs(minetest.registered_nodes) do
		if name ~= "air" and name ~= "ignore" and def.walkable then
			walkable_nodes[#walkable_nodes + 1] = name
		end
	end
end)

local function table_contains(tbl, val)
	for _, v in pairs(tbl) do
		if v == val then return true end
	end
	return false
end

-- Replaces `#creatura.registered_mob_spawns`, which was always 0.
local function any_registered()
	return next(creatura.registered_mob_spawns) ~= nil
end

local function get_spawnable_mobs(pos)

	local data = minetest.get_biome_data(pos) ; if not data then return end

	local biome = minetest.get_biome_name(data.biome) ; if not biome then return end

	local mobs = {}

	for mob, spawn in pairs(creatura.registered_mob_spawns) do
		if (spawn.biomes and table_contains(spawn.biomes, biome)) or spawn.nodes then
			if not spawn.spawn_in_nodes then mobs[#mobs + 1] = mob end
		end
	end

	return mobs
end

local min_spawn_radius = 32
local max_spawn_radius = 128

local function execute_spawns(player)

	local pos = player:get_pos() ; if not pos then return end

	local centre = {
		x = pos.x + random(-max_spawn_radius, max_spawn_radius),
		y = pos.y,
		z = pos.z + random(-max_spawn_radius, max_spawn_radius)
	}

	local spawnable = get_spawnable_mobs(centre)
	if not spawnable or #spawnable == 0 then return end

	local mob = spawnable[random(#spawnable)]
	local spawn = creatura.registered_mob_spawns[mob]

	if not spawn or random(spawn.chance or 2) > 1 then return end

	-- spawn cap
	local object_count = 0

	for _, object in ipairs(minetest.get_objects_inside_radius(pos, max_spawn_radius)) do
		local ent = creatura.is_alive(object) and not object:is_player()
				and object:get_luaentity()

		if ent and ent.name == mob then object_count = object_count + 1 end
	end

	if object_count >= spawn.spawn_cap then return end

	local index_func = spawn.spawn_in_nodes
			and minetest.find_nodes_in_area or minetest.find_nodes_in_area_under_air

	local spawn_on = spawn.nodes or walkable_nodes
	if type(spawn_on) == "string" then spawn_on = {spawn_on} end
	if not spawn_on then return end

	local found = index_func(vec_raise(centre, -max_spawn_radius),
			vec_raise(centre, max_spawn_radius), spawn_on)

	local spawn_pos = found and found[1] ; if not spawn_pos then return end

	local dist = vec_dist(pos, spawn_pos)
	if dist < min_spawn_radius or dist > max_spawn_radius then return end
	if spawn_pos.y > spawn.max_height or spawn_pos.y < spawn.min_height then return end

	if not spawn.spawn_in_nodes then spawn_pos = vec_raise(spawn_pos, 1) end

	local tod = (minetest.get_timeofday() or 0) * 24000
	local bounds_in = tod >= spawn.min_time and tod <= spawn.max_time
	local bounds_ex = tod >= spawn.max_time or tod <= spawn.min_time

	if (spawn.max_time > spawn.min_time and not bounds_in)
	or (spawn.min_time > spawn.max_time and not bounds_ex) then return end

	local light = minetest.get_node_light(spawn_pos) or 7
	if light > spawn.max_light or light < spawn.min_light then return end

	local mob_def = minetest.registered_entities[mob] ; if not mob_def then return end
	local box = mob_def.collisionbox or {-0.5, 0, -0.5, 0.5, 1, 0.5}

	if not creatura.is_pos_moveable(spawn_pos, box[4], max(0, box[5] - box[2])) then
		return
	end

	local group_size = min(spawn.spawn_cap - object_count,
			random(spawn.min_group or 1, spawn.max_group or 1))

	if group_size < 1 then return end

	-- The spawn marker defers the actual add_entity to an ABM, so the mob only
	-- appears once the area is genuinely active.
	if spawn.spawn_cluster then

		minetest.add_node(spawn_pos, {name = "creatura:spawn_node"})

		local meta = minetest.get_meta(spawn_pos)
		meta:set_string("mob", mob)
		meta:set_int("cluster", group_size)
	else
		for _ = 1, group_size do

			local p = creatura.get_ground_level({
				x = spawn_pos.x + random(-3, 3),
				y = spawn_pos.y,
				z = spawn_pos.z + random(-3, 3)}, 4)

			minetest.add_node(p, {name = "creatura:spawn_node"})
			minetest.get_meta(p):set_string("mob", mob)
		end
	end

	if spawn.send_debug then
		minetest.chat_send_all(mob .. " spawned at " .. minetest.pos_to_string(spawn_pos))
	end
end

local spawn_step = tonumber(minetest.settings:get("creatura_spawn_step")) or 15
local spawn_tick = 0

minetest.register_globalstep(function(dtime)

	if not any_registered() then return end

	spawn_tick = spawn_tick - dtime

	if spawn_tick > 0 then return end

	spawn_tick = spawn_step

	for _, player in ipairs(minetest.get_connected_players()) do
		execute_spawns(player)
	end
end)

-- Marker consumer. The mapgen block in spawning.lua registers an identical ABM,
-- so only claim the node when that block is inactive -- otherwise a marker
-- would be spawned twice.

if minetest.settings:get_bool("creatura_mapgen_spawning") ~= true then

	minetest.register_abm({
		label = "Creatura Spawning (legacy)",
		nodenames = {"creatura:spawn_node"},
		interval = tonumber(minetest.settings:get("creatura_spawn_interval")) or 10,
		chance = 1,
		action = function(pos)

			local meta = minetest.get_meta(pos)
			local name = meta:get_string("mob") or ""

			if name == "" then minetest.remove_node(pos) return end

			local amount = meta:get_int("cluster")
			local obj

			for _ = 1, max(1, amount) do
				obj = minetest.add_entity(pos, name)
			end

			minetest.log("action", "[creaturemob] legacy spawn: " .. max(1, amount)
					.. " " .. name .. " at " .. minetest.pos_to_string(pos))

			minetest.remove_node(pos)

			local on_spawns = obj and creatura.registered_on_spawns[name]

			if on_spawns then
				for i = 1, #on_spawns do
					on_spawns[i](obj:get_luaentity(), pos)
					if not obj:get_yaw() then break end
				end
			end
		end
	})
end
