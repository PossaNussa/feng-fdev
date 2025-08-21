minetest.register_node(":stardust:stellar_block", {
    description = "Stellar Block",
    tiles = {"stardust_stellar_block.png"},
    groups = {cracky = 1, level = 3},
    light_source = 10,
    paramtype2 = "facedir",
    on_blast = function() end,
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_craftitem(":stardust:stellar_ingot", {
    description = "Stellar Ingot",
    inventory_image = "stardust_stellar_ingot.png",
})

minetest.register_craft({
    output = "stardust:stellar_block",
    recipe = {
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
    }
})

minetest.register_craft({
    output = "stardust:stellar_ingot 9",
    recipe = {{"stardust:stellar_block"}}
})

if minetest.get_modpath("ethereal") then

    minetest.register_craft({
        type = "shapeless",
        output = "stardust:stellar_ingot",
        recipe = {
            "stardust:stardust", "stardust:stardust", "default:mese_crystal", "default:diamond", "ethereal:fire_dust"
        }
    })

else

    minetest.register_craft({
        type = "shapeless",
        output = "stardust:stellar_ingot",
        recipe = {
            "stardust:stardust", "stardust:stardust", "default:mese_crystal", "default:diamond"
        }
    })

end

if minetest.get_modpath("stairs") then
    stairs.register_stair_and_slab("stellar_block", "stardust:stellar_block",
    {cracky = 1, level = 3},
    {"stardust_stellar_block.png"},
    "Stellar Block Stair",
    "Stellar Block Slab",
    default.node_sound_glass_defaults())
    
    local stellar_stairs = {"stairs:slab_stellar_block", "stairs:stair_stellar_block", "stairs:stair_inner_stellar_block", "stairs:stair_outer_stellar_block"}
    
    for _,stair in ipairs(stellar_stairs) do
        minetest.override_item(stair, {on_blast = function() end})
    end
end

if minetest.get_modpath("terumet") then
    terumet.register_repair_material("stardust:stellar_ingot", 225)
end

if minetest.get_modpath("lucky_block") then
    lucky_block:add_blocks({
            {"dro", "stardust:stellar_ingot", 2},
            {"nod", "stardust:stellar_block", 0},
        }
    )
end
