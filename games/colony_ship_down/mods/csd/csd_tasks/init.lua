-- Colony Ship Down tasks.
--
--   systems.lua    ship systems (power, life support, ...) that slowly wear down
--   stations.lua   task station nodes and the registry of where they are
--   minigame.lua   the mini-game session framework (formspecs that update)
--   minigames.lua  the mini-games themselves
--   tasks.lua      task definitions, per-player task lists, the HUD
--   awards.lua     awards, when the awards mod is present

csd_tasks = {}
csd_tasks.S = core.get_translator("csd_tasks")

local path = core.get_modpath("csd_tasks")
dofile(path .. "/systems.lua")
dofile(path .. "/items.lua")
dofile(path .. "/stations.lua")
dofile(path .. "/minigame.lua")
dofile(path .. "/minigames.lua")
dofile(path .. "/tasks.lua")
if core.get_modpath("awards") then
	dofile(path .. "/awards.lua")
end
