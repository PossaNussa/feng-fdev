-- creaturemob
--
-- One mob runtime, two front-ends.
--
-- `mods/mobs` and `mods/creatura` are reduced to content mods (items, crafts,
-- textures, sounds) and both APIs are served from here, so nothing that depends
-- on either has to change. See README.md for the rationale and the compatibility
-- guarantees.

local path = core.get_modpath("creaturemob")

creaturemob = {
	version = "20260730",
	path = path
}

-- Core: front-end agnostic. Load order matters -- scheduler reads sensors,
-- pathfind reads world.
creaturemob.motion = dofile(path .. "/core/motion.lua")
creaturemob.world = dofile(path .. "/core/world.lua")
creaturemob.sensors = dofile(path .. "/core/sensors.lua")
creaturemob.scheduler = dofile(path .. "/core/scheduler.lua")
creaturemob.pathfind = dofile(path .. "/core/pathfind.lua")
-- navigate wraps pathfind, so it has to come after it
creaturemob.navigate = dofile(path .. "/core/navigate.lua")
creaturemob.spawn = dofile(path .. "/core/spawn.lua")

-- Front-ends. creatura first: livingslimes wraps
-- creatura.default_water_physics at load time and needs the symbol to already
-- exist, and the mobs façade probes for creatura when classifying attack targets.
dofile(path .. "/compat/creatura.lua")
dofile(path .. "/compat/mobs.lua")
dofile(path .. "/compat/mount.lua")
