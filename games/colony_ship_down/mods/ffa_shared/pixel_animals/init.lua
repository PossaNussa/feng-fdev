local path = minetest.get_modpath("pixel_animals")

pixel_animals = {}

-- MOBS : ============================================
dofile(path.."/pxa_mobs/bear.lua")
dofile(path.."/pxa_mobs/capybara.lua")
dofile(path.."/pxa_mobs/crocodile.lua")
dofile(path.."/pxa_mobs/crow.lua")
dofile(path.."/pxa_mobs/Raccoon.lua")
dofile(path.."/pxa_mobs/skunk.lua") 
dofile(path.."/pxa_mobs/tiger.lua")
dofile(path.."/pxa_mobs/Ostrich.lua") 
dofile(path.."/pxa_mobs/shark.lua") 
dofile(path.."/pxa_mobs/catfish.lua")
-- AINDA EM TESTE MODELOS gltf
dofile(path.."/pxa_mobs/Leafcutter_Ant.lua") 
dofile(path.."/pxa_mobs/moose.lua") 
dofile(path.."/pxa_mobs/vulture.lua") 
dofile(path.."/pxa_mobs/Hyenas.lua") 
dofile(path.."/pxa_mobs/jellyfishing.lua") 
dofile(path.."/pxa_mobs/Marmot.lua")
dofile(path.."/pxa_mobs/Seagull.lua")
dofile(path.."/pxa_mobs/Hummingbird.lua")
dofile(path.."/pxa_mobs/rattlesnake.lua")
dofile(path.."/pxa_mobs/hedgehogs.lua")
dofile(path.."/pxa_mobs/seals.lua")
dofile(path.."/pxa_mobs/snails.lua")
dofile(path.."/pxa_mobs/squirrels.lua")
dofile(path.."/pxa_mobs/elephant.lua")

---- Sups: ===========================================
if not minetest.get_modpath("mobs_mc") and not minetest.get_modpath("animalia") then
dofile(path.."/pxa_mobs/bat.lua")
end

if not minetest.get_modpath("mobs_mc") then
dofile(path.."/pxa_mobs/frog.lua")
end

if not minetest.get_modpath("animalia") then
dofile(path.."/pxa_mobs/Turkey.lua")
end

--- MTG ARMOR
if core.get_modpath("3d_armor") then 
dofile(path.."/pxa_armors/pxa_mtg_armors.lua")
end

--- MCL ARMOR
if core.get_modpath("mcl_armor") then
dofile(path.."/pxa_armors/pxa_mcl_armors.lua")
end

-- Hunger NG : ---------------------------------------------
if core.get_modpath("hunger_ng") ~= nil then

hunger_ng.add_hunger_data('pixel_animals:catfish_raw', {
   satiates = 1.0,
})

hunger_ng.add_hunger_data('pixel_animals:catfish_cooked', {
   satiates = 7.0,
})

end







