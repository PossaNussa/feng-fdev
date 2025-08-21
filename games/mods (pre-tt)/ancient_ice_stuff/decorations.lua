minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"dirt_with_grass"},
    sidelen = 9,
    fill_ratio = 0.00003,
    biomes = {"grassland"},
    y_max = 200,
    y_min = 1,
    schematic = minetest.get_modpath("ancient_ice_stuff") .. "/schematics/tomb_ruin.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})
