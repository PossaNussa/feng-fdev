local modpath = minetest.get_modpath("foodblocks")

local api = dofile(modpath.."/api.lua")
-- External API
foodblocks = api

if minetest.get_modpath("farming") 
	and minetest.global_exists("farming")
then
	dofile(modpath.."/farming.lua")
elseif minetest.get_modpath("mcl_farming") then
	dofile(modpath.."/mcl_farming.lua")
else
	error([[
No compatible farming mod found! Please install one of the compatible mods:
Farming from Minetest Game, farming_redo by Tenplus1, farming_undo by Felfa or
mcl_farming from Mineclone2.]])
end
