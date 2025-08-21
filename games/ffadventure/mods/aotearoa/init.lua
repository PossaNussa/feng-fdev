-- Definitions made by this mod that other mods can use too.
aotearoa = {}
local path = minetest.get_modpath("aotearoa")

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

-- Load files.
dofile(path .. "/nodes.lua")
dofile(path .. "/schematics.lua")
dofile(path .. "/ores.lua")
dofile(path .. "/mapgen.lua")

if default_loaded then
	dofile(path .. "/schematic_decos_default.lua")
	dofile(path .. "/simple_decos_default.lua")
elseif zero_loaded then
	dofile(path .. "/schematic_decos_zero.lua")
	dofile(path .. "/simple_decos_zero.lua")
end
dofile(path .. "/spawn_aquatic.lua")
dofile(path .. "/trees.lua")
dofile(path .. "/crafting.lua")

-- Green shovel
if not minetest.get_modpath("ethereal") then
	dofile(path .. "/green_shovel.lua")
end

-- Use immersive sounds, if possible.
if minetest.get_modpath("ambience") then
	dofile(path .. "/ambience.lua")
end

minetest.log("action", "[Aotearoa] Successfully loaded.")


----------------------
-- Intro world creation (the geneaology of creation).
-- Seeds to make up for removing default/zero sources.