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

--- /petcall : bring your pets back to you
dofile(path.."/petcall.lua")

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


