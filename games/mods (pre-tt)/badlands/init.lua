minetest.register_node("badlands:red_sand", {
	description = "Red Sand",
	tiles = {"default_sand.png^[colorize:sienna:130^[colorize:red:30"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("badlands:red_sandstone", {
	description = "Red Sandstone",
	tiles = {"default_sandstone.png^[colorize:sienna:175^[colorize:red:40"},
	groups = {crumbly = 1, cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("badlands:red_sandstone_brick", {
	description = "Red Sandstone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_sandstone_brick.png^[colorize:sienna:175^[colorize:red:40"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("badlands:red_sandstone_block", {
	description = "Red Sandstone Block",
	tiles = {"default_sandstone_block.png^[colorize:sienna:175^[colorize:red:40"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "badlands:red_sandstone",
	recipe = {
		{"badlands:red_sand", "badlands:red_sand"},
		{"badlands:red_sand", "badlands:red_sand"},
	}
})

minetest.register_craft({
	output = "badlands:red_sand 4",
	recipe = {
		{"badlands:red_sandstone"},
	}
})

minetest.register_craft({
	output = "badlands:red_sandstone_brick 4",
	recipe = {
		{"badlands:red_sandstone", "badlands:red_sandstone"},
		{"badlands:red_sandstone", "badlands:red_sandstone"},
	}
})

minetest.register_craft({
	output = "badlands:red_sandstone_block 9",
	recipe = {
		{"badlands:red_sandstone", "badlands:red_sandstone", "badlands:red_sandstone"},
		{"badlands:red_sandstone", "badlands:red_sandstone", "badlands:red_sandstone"},
		{"badlands:red_sandstone", "badlands:red_sandstone", "badlands:red_sandstone"},
	}
})


minetest.register_biome({
	name = "badlands_plains",
	node_top = "badlands:red_sand",
	depth_top = 1,
	node_filler = "badlands:red_sand",
	depth_filler = 1,
	node_stone = "default:stone",
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_dungeon = "bakedclay:orange",
	node_dungeon_stair = "stairs:stair_bakedclay_orange",
	y_max = 30,
	y_min = -255,
	vertical_blend = 2,
	heat_point = 83,
	humidity_point = 2,
})

minetest.register_biome({
	name = "badlands",
	node_stone = "default:stone",
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_dungeon = "bakedclay:orange",
	node_dungeon_stair = "stairs:stair_bakedclay_orange",
	y_max = 31000,
	y_min = 30,
	heat_point = 83,
	humidity_point = 2,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_gold",
	wherein        = "default:stone",
	clust_scarcity = 9 * 9 * 9,
	clust_num_ores = 8,
	clust_size     = 4,
	y_max          = -10,
	y_min          = -64,
	biomes = {"badlands", "badlands_plains"},
	})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:orange",
	wherein         = {"default:stone", "default:silver_sandstone", "default:dirt", "default:silver_sand", "default:stone_with_coal", "default:gravel"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	fill_ratio = 10,
	biomes = {"badlands", "badlands_plains"},
})

for i = 0, 4 do

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:natural",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 28 + i * 50,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 2,
	biomes = {"badlands", "badlands_plains"},
})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:red",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 23 + i * 8,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 2,
	biomes = {"badlands", "badlands_plains"},
})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:yellow",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 19 + i * 16,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 1,
	biomes = {"badlands", "badlands_plains"},
})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:brown",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 17 + i * 5,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 1,
	biomes = {"badlands", "badlands_plains"},
})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:dark_grey",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 16 + i * 12,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 1,
	biomes = {"badlands", "badlands_plains"},
})

minetest.register_ore({
	ore_type        = "stratum",
	ore             = "bakedclay:grey",
	wherein         = {"bakedclay:orange"},
	clust_scarcity  = 1,
	y_max           = 31000,
	y_min           = -10,
	noise_params    = {
		offset = 14 + i * 30,
		scale = 16,
		spread = {x = 128, y = 128, z = 128},
		seed = 90122,
		octaves = 1,
	},
	stratum_thickness = 1,
	biomes = {"badlands", "badlands_plains"},
})

end



--MINETEST GAME DESERT DECORATIONS--

	-- Large cactus

	minetest.register_decoration({
		name = "badlands:large_cactus",
		deco_type = "schematic",
		place_on = {"badlands:red_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"badlands_plains"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/large_cactus.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Cactus

	minetest.register_decoration({
		name = "badlands:cactus",
		deco_type = "simple",
		place_on = {"badlands:red_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"badlands_plains"},
		y_max = 31000,
		y_min = 4,
		decoration = "default:cactus",
		height = 2,
		height_max = 5,
	})


	-- Cacti

	minetest.register_decoration({
		name = "badlands:cactus",
		deco_type = "simple",
		place_on = {"badlands:red_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.012,
			scale = 0.024,
			spread = {x = 100, y = 100, z = 100},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:cactus",
		height = 3,
	        height_max = 4,
	})

	-- Dry shrubs

	minetest.register_decoration({
		name = "badlands:dry_shrub",
		deco_type = "simple",
		place_on = {"badlands:red_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.035,
			spread = {x = 100, y = 100, z = 100},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:dry_shrub",
		param2 = 4,
	})