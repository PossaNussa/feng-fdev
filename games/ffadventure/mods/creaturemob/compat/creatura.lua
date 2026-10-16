-- creaturemob :: compat/creatura.lua
--
-- Serves the full `creatura.*` API.
--
-- The engine here is upstream creatura (Dec 2025), which is roughly two years
-- newer than the copy this game was running. That is a straight win for
-- everything except four API changes that would have broken animalia, draconis
-- and livingslimes -- those are shimmed at the bottom of this file rather than
-- pushed onto the consumer mods.
--
-- The mob step loop itself lives in creatura/mob_meta.lua, vendored alongside
-- this file and rewired onto creaturemob.motion. Grep it for "creaturemob:" to
-- see every deviation from upstream.

local path = creaturemob.path
local world = creaturemob.world

creatura = {}

dofile(path .. "/creatura/api.lua")
dofile(path .. "/creatura/pathfinder_deprecated.lua")

-- The time-sliced A*/Theta* pathfinder lives in core, shared with the Mobs Redo
-- front-end (which used to do a blocking core.find_path() instead).
creatura.pathfinder = creaturemob.pathfind

dofile(path .. "/creatura/methods.lua")
dofile(path .. "/creatura/mob_meta.lua")
dofile(path .. "/creatura/boids.lua")
dofile(path .. "/creatura/spawning.lua")

-- Overrides upstream's register_mob_spawn shim, which silently changed a
-- once-per-player probe into a per-node ABM. See the file header.
dofile(path .. "/creatura/legacy_spawn.lua")

----------------------------------------------------------------------
-- Point the world queries at the shared, bug-fixed implementations
--
-- creatura's own get_node_def() wrote `walkable = false` onto the live
-- core.registered_nodes entry for any node shorter than 0.26 -- so a single
-- pathfinding query permanently redefined default:snow for the whole game.
-- is_pos_moveable() scanned a box around 2*pos rather than pos. Both are fixed
-- in core/world.lua; alias rather than duplicate.
----------------------------------------------------------------------

creatura.get_node_height_from_def = world.get_node_height_from_def
creatura.get_node_def = world.get_node_def
creatura.get_ground_level = world.get_ground_level
creatura.is_pos_moveable = world.is_pos_moveable
creatura.is_blocked = world.is_blocked
creatura.fast_ray_sight = world.fast_ray_sight
creatura.sensor_floor = world.sensor_floor
creatura.sensor_ceil = world.sensor_ceil
creatura.get_nearby_player = world.get_nearby_player
creatura.get_nearby_players = world.get_nearby_players
creatura.get_nearby_object = world.get_nearby_object
creatura.get_nearby_objects = world.get_nearby_objects
creatura.get_nearby_entity = world.get_nearby_object
creatura.get_nearby_entities = world.get_nearby_objects
creatura.is_valid = creaturemob.is_valid
creatura.is_alive = creaturemob.is_alive

----------------------------------------------------------------------
-- Backwards compatibility
----------------------------------------------------------------------

-- 1. Movement method renamed upstream.
--    Nothing in this game calls the old name today, but third-party creatura
--    mobs do, and re-registering an existing function costs nothing.

creatura.register_movement_method("creatura:theta_pathfind",
		creatura.registered_movement_methods["creatura:pathfind_theta"])

-- 2. `get_next_move` / `get_next_move_3d` were deleted upstream.
--    Restored from the previous release; see creatura/legacy_moves.lua.
--    Loaded here, after the aliases above, so they pick up the fixed
--    get_node_def / is_pos_moveable rather than the buggy originals.

dofile(path .. "/creatura/legacy_moves.lua")

-- 3. Liquid physics fields were renamed.
--
--    `bouyancy_multiplier` and `hydrodynamics_multiplier` became
--    `liquid_submergence` and `liquid_drag`. Left alone, animalia's tropical
--    fish and frogs (which set bouyancy_multiplier = 0 to stay submerged) would
--    have become dead keys and those mobs would float to the surface.
--
--    A multiplier of 0 meant "no buoyancy at all", which in the new model is
--    full submergence.

local register_mob = creatura.register_mob

function creatura.register_mob(name, def)

	if def.bouyancy_multiplier ~= nil and def.liquid_submergence == nil then
		def.liquid_submergence = (def.bouyancy_multiplier == 0)
				and 1 or (0.25 / math.max(def.bouyancy_multiplier, 0.01))

		if def.liquid_submergence > 1 then def.liquid_submergence = 1 end
	end

	if def.hydrodynamics_multiplier ~= nil and def.liquid_drag == nil then
		def.liquid_drag = def.hydrodynamics_multiplier
	end

	return register_mob(name, def)
end

-- 4. `block_protected` vs `block_protected_spawn`.
--    doc.txt documents the first, the code reads the second. Accept both.

local register_abm_spawn = creatura.register_abm_spawn

function creatura.register_abm_spawn(mob, def)

	if def.block_protected ~= nil and def.block_protected_spawn == nil then
		def.block_protected_spawn = def.block_protected
	end

	return register_abm_spawn(mob, def)
end

-- Note on the marker field: creatura mobs carry `_creatura_mob`, never
-- `_cmi_is_mob`. That is load-bearing -- waterdragon rewrites on_punch for every
-- registered entity carrying `_cmi_is_mob`, and stamping it here would silently
-- attach waterdragon's punch handler to every animalia and draconis mob.
