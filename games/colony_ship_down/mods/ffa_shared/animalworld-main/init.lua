
-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("animalworld") or
		dofile(path .. "intllib.lua")

mobs.intllib = S

-- Check for custom mob spawn file
mobs.custom_spawn_animalworld = false


-- Animals
dofile(path .. "hare.lua") -- 
dofile(path .. "manatee.lua") -- 
dofile(path .. "camel.lua") -- 
dofile(path .. "elephant.lua") -- 
dofile(path .. "carp.lua") -- 
dofile(path .. "kangaroo.lua") -- 
dofile(path .. "hippo.lua") -- 
dofile(path .. "shark.lua") -- 
dofile(path .. "nandu.lua") -- 
dofile(path .. "crab.lua") --
dofile(path .. "anteater.lua") --
dofile(path .. "vulture.lua") --
dofile(path .. "toucan.lua") --
dofile(path .. "lobster.lua") --
dofile(path .. "squid.lua") --
dofile(path .. "kobra.lua") --
dofile(path .. "ant.lua") --
dofile(path .. "termite.lua") --
dofile(path .. "snail.lua") --
dofile(path .. "locust.lua") --
dofile(path .. "dragonfly.lua") --
dofile(path .. "nymph.lua") --
dofile(path .. "scorpion.lua") --
dofile(path .. "seahorse.lua") --
dofile(path .. "trophies.lua") --
dofile(path .. "tundravegetation.lua") --
dofile(path .. "muskox.lua") --
dofile(path .. "beluga.lua") --
dofile(path .. "monkey.lua") --
dofile(path .. "zebra.lua") --
dofile(path .. "indianrhino.lua") --
dofile(path .. "giraffe.lua") --
dofile(path .. "koala.lua") --
dofile(path .. "echidna.lua") --
dofile(path .. "mosquito.lua") --
dofile(path .. "beaver.lua") --
dofile(path .. "marmot.lua") --
dofile(path .. "hermitcrab.lua") --
dofile(path .. "parrot.lua") --
dofile(path .. "stingray.lua") --
dofile(path .. "blackgrouse.lua") --
dofile(path .. "roadrunner.lua") --
dofile(path .. "concretecrafting.lua") --
dofile(path .. "robin.lua") --
dofile(path .. "orangutan.lua") --
dofile(path .. "hunger.lua") --



-- Load custom spawning
if mobs.custom_spawn_animalworld then
	dofile(path .. "spawn.lua")
end




print (S("[MOD] Mobs Redo Animals loaded"))
