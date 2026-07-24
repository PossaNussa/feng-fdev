-- function recipes easy
local function pf_other_mods_recipes (item_output,item_recipe_1,item_recipe_2)
core.register_craft({
   -- type = "shaped",
    output = item_output,
    recipe = {
        {"","",""},
        {item_recipe_2,item_recipe_2,item_recipe_2},
        {item_recipe_1,item_recipe_1,item_recipe_1}
    }
})
end

-- animalia
if core.get_modpath("animalia") then 
pf_other_mods_recipes ("pixelfurniture:chicken_on_a_board","group:wood","animalia:poultry_cooked")
end
-- Mobs Animals
if core.get_modpath("mobs_animal") then 
pf_other_mods_recipes ("pixelfurniture:chicken_on_a_board","group:wood","mobs:chicken_cooked")
end
-- Better Minetest
if core.get_modpath("btmt") then 
pf_other_mods_recipes ("pixelfurniture:chicken_on_a_board","group:wood","btmt:chicken_cooked")
end
-- MCL mobs
if core.get_modpath("mobs_mc") then 
pf_other_mods_recipes ("pixelfurniture:chicken_on_a_board","group:wood","mcl_mobitems:chicken")

end
-- Farmings
if core.get_modpath("mcl_farming") then 
pf_other_mods_recipes ("pixelfurniture:bread_on_a_board","group:wood","mcl_farming:bread")
end

if core.get_modpath("farming") then 
pf_other_mods_recipes ("pixelfurniture:bread_on_a_board","group:wood","farming:bread")
end
