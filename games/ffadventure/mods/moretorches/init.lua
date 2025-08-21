--This creates the moretorches object.
moretorches = {}

--This creates the moretorches.settings object, and fills it with either the menu selected choices as defined in settingtypes.txt, or default values, (In this case, false).
moretorches.settings = {
	clear_biomes			= minetest.settings:get_bool("moretorches.clear_biomes") or false,
	clear_decos			= minetest.settings:get_bool("moretorches.clear_decos") or false,
	clear_ores			= minetest.settings:get_bool("moretorches.clear_ores") or false,
}

if moretorches.settings.clear_biomes then
	minetest.clear_registered_biomes()
end
if moretorches.settings.clear_decos then
	minetest.clear_registered_decorations()
end
if moretorches.settings.clear_ores then
	minetest.clear_registered_ores()
end

local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- plants
dofile(path .. "mtgtorches.lua") -- 
dofile(path .. "livingjungletorches.lua") -- 
dofile(path .. "livingdeserttorches.lua") -- 
dofile(path .. "livingfloatlandstorches.lua") -- 
dofile(path .. "naturalbiomestorches.lua") -- 
dofile(path .. "crafting.lua") -- 





