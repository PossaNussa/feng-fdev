minetest.register_node("stardust:stone_with_stardust", {
    description = "Stardust Ore",
    tiles = {"default_stone.png^stardust_mineral_stardust.png"},
    is_ground_content = true,
    groups = {cracky = 3},
    drop = "stardust:stardust",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("stardust:stardust", {
    description = "Stardust",
    inventory_image = "stardust_stardust.png",
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "stardust:stone_with_stardust",
    wherein = "default:stone",
    clust_scarcity = 15*15*15,
    clust_num_ores = 1,
    clust_size = 1,
    y_min = 64,
    y_max = 80,
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "stardust:stone_with_stardust",
    wherein = "default:stone",
    clust_scarcity = 12*12*12,
    clust_num_ores = 1,
    clust_size = 1,
    y_min = 80,
    y_max = 96,
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "stardust:stone_with_stardust",
    wherein = "default:stone",
    clust_scarcity = 10*10*10,
    clust_num_ores = 1,
    clust_size = 1,
    y_min = 96,
    y_max = 120,
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "stardust:stone_with_stardust",
    wherein = "default:stone",
    clust_scarcity = 8*8*8,
    clust_num_ores = 1,
    clust_size = 1,
    y_min = 120,
    y_max = 150,
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "stardust:stone_with_stardust",
    wherein = "default:stone",
    clust_scarcity = 6*6*6,
    clust_num_ores = 1,
    clust_size = 1,
    y_min = 150,
    y_max = 31000,
})

if minetest.get_modpath("terumet") then
    terumet.register_ore_cutting("stardust:stone_with_stardust")
    
    local crys_star = terumet.register_crystal({
        suffix = "star",
        color = "#152585",
        name = "Crystallized Stardust",
        cooking_result = "stardust:stardust"
    })
    
    terumet.register_vulcan_result("stardust:stone_with_stardust", crys_star)
end

if minetest.get_modpath("lucky_block") then
    lucky_block:add_blocks({
        {"dro", "stardust:stardust", 3}
    })
end
