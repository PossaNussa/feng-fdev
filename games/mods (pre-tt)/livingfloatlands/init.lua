--This creates the livingfloatlands object.
naturalbiomes = {}

local modname = "livingfloatlands"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("livingfloatlands") or
		dofile(path .. "intllib.lua")

mobs.intllib = S


-- Animals
--dofile(path .. "carnotaurus.lua") -- 
--dofile(path .. "nigersaurus.lua") -- 
--dofile(path .. "deinotherium.lua") -- 
--dofile(path .. "mammooth.lua") -- 
dofile(path .. "gastornis.lua") -- 
--dofile(path .. "woollyrhino.lua") -- 
--dofile(path .. "velociraptor.lua") -- 
--dofile(path .. "triceratops.lua") -- 
--dofile(path .. "smilodon.lua") -- 
dofile(path .. "parasaurolophus.lua") -- 
--dofile(path .. "gigantopithecus.lua") -- 
--dofile(path .. "wildhorse.lua") -- 
--dofile(path .. "entelodon.lua") -- 
dofile(path .. "oviraptor.lua") -- 
--dofile(path .. "stegosaurus.lua") -- 
dofile(path .. "ankylosaurus.lua") -- 
--dofile(path .. "lycaenops.lua") -- 
--dofile(path .. "tyrannosaurus.lua") -- 
dofile(path .. "cavebear.lua") -- 
dofile(path .. "rhamphorhynchus.lua") -- 
--dofile(path .. "coldsteppe.lua") -- 
--dofile(path .. "paleodesert.lua") -- 
--dofile(path .. "giantforest.lua") -- 
--dofile(path .. "coldgiantforest.lua") -- 
--dofile(path .. "paleojungle.lua") -- 
dofile(path .. "dye.lua") -- 
dofile(path .. "crafting.lua") -- 
--dofile(path .. "leafdecay.lua") -- 
dofile(path .. "hunger.lua") -- 




print (S("[MOD] Mobs Redo Animals loaded"))
