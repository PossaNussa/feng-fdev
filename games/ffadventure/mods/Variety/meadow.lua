local S = minetest.get_translator("variety")
---------------------------------------------
-------------MAPGENS
---------------------------------------------

	minetest.register_biome({
		name = "meadow",
		node_top = "variety:meadow_dirt_with_grass",
		depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 140,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:limestonebrick",
		node_dungeon_alt = "default:granitebrick",
		y_max = 31000,
		y_min = 1,
		heat_point = 60,
		humidity_point = 30,
	})
	

	minetest.register_decoration({
		name = "butterflies:butterfly",
		deco_type = "simple",
		place_on = {"variety:meadow_dirt_with_grass", "default:dirt_with_dry_grass"},
		place_offset_y = 2,
		sidelen = 80,
		fill_ratio = 0.005,
		biomes = {"prairie", "meadow"},
		y_max = 31000,
		y_min = 1,
		decoration = {
			"butterflies:butterfly_white",
			"butterflies:butterfly_red",
			"butterflies:butterfly_violet"
		},
		spawn_by = "group:flower",
		num_spawn_by = 1
	})

	-- restart butterfly timers
	minetest.register_lbm({
		name = ":butterflies:butterfly_timer",
		nodenames = {
			"butterflies:butterfly_white", "butterflies:butterfly_red",
			"butterflies:butterfly_violet"
		},
		run_at_every_load = true,

		action = function(pos)
			minetest.get_node_timer(pos):start(5)
		end
	})


	
minetest.register_decoration({
	deco_type = "simple",
	place_on = {
		"variety:meadow_dirt_with_grass", "default:dirt_with_dry_grass"
	},
	sidelen = 16,
	biomes = { "meadow", "prairie"},
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7133,
		octaves = 3,
		persist = 0.6
	},
	y_min = 10,
	y_max = 90,
	decoration = "bakedclay:delphinium"
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {
		"variety:meadow_dirt_with_grass", "default:dirt_with_dry_grass"
	},
	sidelen = 16,
    biomes = {"meadow", "prairie"},
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7134,
		octaves = 3,
		persist = 0.6
	},
	y_min = 15,
	y_max = 90,
	decoration = "bakedclay:thistle"
})


	minetest.register_decoration({
		name = "fireflies:firefly_low",
		deco_type = "simple",
		place_on = {
			"default:dirt_with_dry_grass",
			"variety:meadow_dirt_with_grass",
		},
		place_offset_y = 2,
		sidelen = 80,
		fill_ratio = 0.0005,
		biomes = {
			"deciduous_forest", "grassytwo", "coniferous_forest", "junglee", "swamp"},
		y_max = 31000,
		y_min = -1,
		decoration = "fireflies:hidden_firefly"
	})

	-- restart firefly timers
	minetest.register_lbm({
		name = ":fireflies:firefly_timer",
		nodenames = {"fireflies:firefly", "fireflies:hidden_firefly"},
		run_at_every_load = true,

		action = function(pos)
			minetest.get_node_timer(pos):start(5)
		end
	})

minetest.register_decoration({
    name = "variety:meadow_rock",
    deco_type = "schematic",
    place_on = {"variety:meadow_dirt_with_grass"},
    place_offset_y = -2,
    sidelen = 16,
    fill_ratio = 0.002265,
    biomes = {"meadow"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/meadow_rock.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:meadow_rock_2",
    deco_type = "schematic",
    place_on = {"variety:meadow_dirt_with_grass"},
    place_offset_y = -2,
    sidelen = 16,
    fill_ratio = 0.000765,
    biomes = {"meadow"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/meadow_rock_2.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:meadow_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.06,
	biomes = {"meadow"},
	decoration = {
		"default:grass_1", "default:grass_2",
		"default:grass_3", "default:grass_4",
		"default:grass_5",
	}
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:meadow_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.06,
	biomes = {"meadow"},
	decoration = {
		"flowers:dandelion_white", "flowers:viola",
		"flowers:dandelion_yellow",
		"flowers:chrysanthemum_green",
	}
})

---------------------------------------------
-------------BLOCKS
---------------------------------------------

minetest.register_node("variety:meadow_dirt_with_grass", {
	description = S("Dirt With Meadow Grass"),
	tiles = {"meadow_grass.png", "default_dirt.png",
		{name = "default_dirt.png^meadow_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_dirt_footstep", gain = 0.25},
	}),
})


		footprints.register_trample_node("variety:meadow_dirt_with_grass", {
		trampled_node_name = "footprints:meadow_dirt_with_grass",
		trampled_node_def_override = {description = S("Meadow Grass with Footprint"),},
		hard_pack_node_name = "footprints:trail",
		footprint_opacity = 96,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})
