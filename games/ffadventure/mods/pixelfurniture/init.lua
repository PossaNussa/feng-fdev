local path = core.get_modpath("pixelfurniture")

pixelfurniture = {}

dofile(path.."/src/pf_libs/api_pf.lua")
dofile(path.."/src/pf_libs/api_pf_blocks.lua")

dofile(path.."/src/pf_furnitures/pfunitures.lua")
dofile(path.."/src/pf_furnitures/pfunitures_Curtain.lua")
dofile(path.."/src/pf_furnitures/pfurnitures_upholstered_chair.lua")
dofile(path.."/src/pf_furnitures/pfurnitures_sofa_chair.lua")
dofile(path.."/src/pf_furnitures/pf_new_blocks.lua")

-- With other mods :
dofile(path.."/src/pf_recipes/pf_recipes_mods.lua")

if core.get_modpath("default") then
    dofile(path.."/src/pf_recipes/mtg_recipes.lua")
    dofile(path.."/src/pf_recipes/mtg_recipes_others.lua")
    dofile(path.."/src/pf_recipes/pf_sofa_recipes.lua")
elseif core.get_modpath("mcl_core") then
    dofile(path.."/src/pf_recipes/mcl_recipes.lua")
    dofile(path.."/src/pf_recipes/mcl_recipes_others.lua")
    dofile(path.."/src/pf_recipes/pf_sofa_recipes.lua")
end


