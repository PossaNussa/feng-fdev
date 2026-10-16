-- [MOD] Angled Walls [angledwalls] [2.0]
--
-- Angled placement: any ordinary block placed while you stand at an angle goes
-- down at that angle.  Originally a fixed list of hand-registered angled wall
-- nodes by TumeniNodes.

local modpath = core.get_modpath("angledwalls")

angledwalls = {}

dofile(modpath .. "/angledwalls.lua") -- legacy hand-registration API
dofile(modpath .. "/api.lua")         -- shapes and per-block variants
dofile(modpath .. "/autogen.lua")     -- variants for every block in the game
dofile(modpath .. "/place.lua")       -- the gameplay feature itself

-- Decorative node families that are not part of angled placement.
dofile(modpath .. "/angledglass.lua")
dofile(modpath .. "/adoors.lua")
dofile(modpath .. "/slopedwalls.lua")

-- bakedclay.lua and quartz.lua are no longer loaded: those blocks are covered by
-- autogeneration like everything else.  The files are kept in case you want the
-- old hand-registered nodes back.
