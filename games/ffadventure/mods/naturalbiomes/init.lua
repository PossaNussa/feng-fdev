--This creates the naturalbiomes object.
naturalbiomes = {}

--This creates the naturalbiomes.settings object, and fills it with either the menu selected choices as defined in settingtypes.txt, or default values, (In this case, false).
naturalbiomes.settings = {
	clear_biomes			= minetest.settings:get_bool("naturalbiomes.clear_biomes") or false,
	clear_decos			= minetest.settings:get_bool("naturalbiomes.clear_decos") or false,
	clear_ores			= minetest.settings:get_bool("naturalbiomes.clear_ores") or false,
}

if naturalbiomes.settings.clear_biomes then
	minetest.clear_registered_biomes()
end
if naturalbiomes.settings.clear_decos then
	minetest.clear_registered_decorations()
end
if naturalbiomes.settings.clear_ores then
	minetest.clear_registered_ores()
end

local modname = "naturalbiomes"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("naturalbiomes") or
		dofile(path .. "intllib.lua")


-- biomes

dofile(path .. "wetsavanna.lua") --
--dofile(path .. "alderswamp.lua") --
dofile(path .. "alpine.lua") --
--dofile(path .. "bambooforest.lua") --
dofile(path .. "palmbeach.lua") --
dofile(path .. "outback.lua") --
dofile(path .. "mediterranean.lua") --
dofile(path .. "crafting.lua") --
dofile(path .. "heath.lua") --
dofile(path .. "dye.lua") --
dofile(path .. "bushland.lua") --
--dofile(path .. "leafdecay.lua") --
dofile(path .. "hunger.lua") --

-- Tag all naturalbiomes tall grasses / beach grasses with group:grass so they
-- count as tall grass in game-wide recipes (e.g. green wool from 2x2 grass,
-- string from a diagonal grass pair). Without this they register only as
-- generic flora and those recipes silently reject them.
for name, def in pairs(minetest.registered_nodes) do
	if name:sub(1, 14) == "naturalbiomes:" and name:find("grass")
			and def.groups and def.groups.flora and not def.groups.grass then
		local new_groups = table.copy(def.groups)
		new_groups.grass = 1
		minetest.override_item(name, {groups = new_groups})
	end
end



