local S = minetest.get_translator("variety")
---------------------------------------------
-------------MAPGENS
---------------------------------------------
minetest.register_decoration({
    name = "variety:rock_1",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.010265,
    biomes = {"japanese_forest"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/rock_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})


minetest.register_decoration({
    name = "variety:japanese_bush",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.005265,
    biomes = {"japanese_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/japanese_bush.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:japanese_log",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.005265,
    biomes = {"japanese_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/japanese_log.mts",
	flags = "force_placement",
	rotation = "random",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:japanese_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.5,
	biomes = {"japanese_forest"},
	decoration = {
		"default:grass_1", "default:grass_2",
		"default:grass_3", "default:grass_4",
		"default:grass_5",
	}
})



---------------------------------------------
-------------BLOCKS
---------------------------------------------
minetest.register_node("variety:japanese_leaves_1", {
	description = S("Japanese Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"japanese_leaves_1.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:japanese_sapling"}, rarity = 20},
			{items = {"variety:japanese_leaves_1"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("variety:japanese_leaves_2", {
	description = S("Japanese Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"japanese_leaves_2.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:japanese_sapling"}, rarity = 20},
			{items = {"variety:japanese_leaves_2"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("variety:japanese_leaves_3", {
	description = S("Japanese Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"japanese_leaves_3.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:japanese_sapling"}, rarity = 20},
			{items = {"variety:japanese_leaves_3"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("variety:tatami_simple", {
	description = S("Japanese Carpet"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"tatami_simple.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("variety:japanese_tatami", {
	description = S("Japanese Carpet"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"tatami.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("variety:japanese_dirt_with_grass", {
	description = S("Dirt With Japanese Grass"),
	tiles = {"japaneseforest_japanese_grass.png", "default_dirt.png",
		{name = "default_dirt.png^japaneseforest_japanese_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})




