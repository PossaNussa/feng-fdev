local S = minetest.get_translator("variety")
if minetest.get_modpath("moreblocks") then
---------------------------------------------
-------------MOREBLOCKS TROPICAL RAINFOREST
---------------------------------------------

	stairsplus:register_all("tropical_rainforest_wood", "wood", "variety:tropical_rainforest_wood", {
		description = S("Tropical Rainforest Wood"),
		tiles = {"tropical_rainforest_wood.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("tropical_rainforest_tree", "wood", "variety:tropical_rainforest_tree", {
		description = S("Tropical Rainforest Tree"),
	tiles = {"tropical_rainforest_tree_top.png", "tropical_rainforest_tree_top.png",
		"tropical_rainforest_tree.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS MEADOW
---------------------------------------------

	stairsplus:register_all("redwood_tree", "tree", "variety:redwood_tree", {
		description = S("Redwood Tree"),
	tiles = {"redwood_tree.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("redwood", "stone", "variety:redwood", {
		description = S("Redwood"),
	tiles = {"redwood.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})
---------------------------------------------
-------------MOREBLOCKS MEADOW
---------------------------------------------

	stairsplus:register_all("meadow_tree", "wood", "variety:meadow_tree", {
		description = S("meadow Tree"),
	tiles = {"meadow_tree.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("meadow", "wood", "variety:meadow_wood", {
		description = S("meadow wood"),
	tiles = {"meadow_wood.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS JAPANESE FOREST
---------------------------------------------

	stairsplus:register_all("japanese_wood", "wood", "variety:japanese_wood", {
		description = S("Japanese Wood"),
		tiles = {"japanese_wood.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("tatami_simple", "wood", "variety:tatami_simple", {
		description = S("Tatami simple Wood"),
		tiles = {"tatami_simple.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("tatami", "wood", "variety:japanese_tatami", {
		description = S("Japanese Tatami"),
		tiles = {"tatami.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("japanese_lamp", "wood", "variety:japanese_lamp", {
		description = S("Japanese Lamp"),
		tiles = {"japanese_lamp.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	    sounds = default.node_sound_glass_defaults(),
	})

	stairsplus:register_all("japanese_tree", "wood", "variety:japanese_tree", {
		description = S("japanese Tree"),
	tiles = {"japanese_tree_top.png", "japanese_tree_top.png",
		"japanese_tree.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS FROST LAND
---------------------------------------------

	stairsplus:register_all("frost_land_wood", "wood", "variety:frost_land_wood", {
		description = S("Frost Land Wood"),
		tiles = {"frost_land_wood.png"},
      	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("frost_land_tree", "tree", "variety:frost_land_tree", {
		description = S("Frost Land Tree"),
	tiles = {"frost_land_tree_top.png", "frost_land_tree_top.png",
		"frost_land_tree.png"},
      	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS DARKFOREST
---------------------------------------------

	stairsplus:register_all("darkforest_wood", "wood", "variety:darkforest_wood", {
		description = S("Darkforest Wood"),
		tiles = {"darkforest_wood.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("darkforest_tree", "wood", "variety:darkforest_tree", {
		description = S("Darkforest Tree"),
	tiles = {"darkforest_tree_top.png", "darkforest_tree_top.png",
		"darkforest_tree.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS DORWINION
---------------------------------------------

	stairsplus:register_all("dorwinion_brick", "stone", "variety:dorwinion_brick", {
		description = S("Dorwinion Brick"),
	tiles = {"dorwinion_brick.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("dorwinion", "stone", "variety:dorwinion", {
		description = S("Dorwinion"),
	tiles = {"dorwinion.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("dorwinion_carved", "stone", "variety:dorwinion_carved", {
		description = S("Dorwinion Carved"),
	tiles = {"dorwinion_carved.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("dorwinion_brick_cracked", "stone", "variety:dorwinion_brick_cracked", {
		description = S("Dorwinion Brick Cracked"),
	tiles = {"dorwinion_brick_cracked.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("dorwinion_brick_with_flowers", "stone", "variety:dorwinion_brick_with_flowers", {
		description = S("Dorwinion Brick With Flowers"),
	tiles = {"dorwinion_brick_with_flowers.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("dorwinion_brick_with_moss", "stone", "variety:dorwinion_brick_with_moss", {
		description = S("Dorwinion Brick With Moss"),
	tiles = {"dorwinion_brick_with_moss.png"},
	groups = {cracky = 2, flammable = 2, stone = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS BAOBAB
---------------------------------------------

	stairsplus:register_all("baobab_tree", "wood", "variiety:baobab_tree", {
		description = S("Baobab Tree"),
	tiles = {"baobab_tree_top.png", "baobab_tree_top.png",
		"baobab_tree.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("baobab_wood", "wood", "variiety:baobab_wood", {
		description = S("Baobab Wood"),
	tiles = {"baobab_wood.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

-----------------------------------------
-------------MOREBLOCKS CHERRY
---------------------------------------------

	stairsplus:register_all("cherry_wood", "wood", "variety:cherry_wood", {
		description = S("Cherry Wood"),
		tiles = {"cherry_wood.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("cherry_tree", "wood", "variety:cherry_tree", {
		description = S("Cherry Tree"),
	tiles = {"cherry_tree_top.png", "cherry_tree_top.png",
		"cherry_tree.png"},
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	    sounds = default.node_sound_wood_defaults(),
	})


---------------------------------------------
-------------MOREBLOCKS BAMBOO FOREST
---------------------------------------------

	stairsplus:register_all("bamboo_wood", "wood", "variety:bamboo_wood", {
		description = S("Bamboo Wood"),
		tiles = {"bamboo_wood.png"},
      	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("bamboo_glass", "glass", "variety:bamboo_glass", {
		description = S("Bamboo Glass"),
		tiles = {"bamboo_glass.png"},
    	groups = {cracky = 3, oddly_breakable_by_hand = 3},
    	sounds = default.node_sound_glass_defaults(),
	})

	stairsplus:register_all("bamboo_block", "wood", "variety:bamboo_block", {
		description = S("Bamboo Block"),
		tiles = {"bamboo_block.png"},
	    groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("granite", "stone", "variety:granite", {
		description = S("Granite"),
		tiles = {"granite.png"},
	groups = {cracky = 3, stone = 2, level = 1},
	    sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("granite_block", "stone", "variety:granite_block", {
		description = S("Granite Block"),
		tiles = {"granite_block.png"},
	groups = {cracky = 3, stone = 2, level = 1},
	    sounds = default.node_sound_stone_defaults(),
	})

	stairsplus:register_all("granite_brick", "stone", "variety:granite_brick", {
		description = S("Granite Brick"),
		tiles = {"granite_brick.png"},
	groups = {cracky = 3, stone = 2, level = 1},
	    sounds = default.node_sound_stone_defaults(),
	})

---------------------------------------------
-------------MOREBLOCKS AUTUMN FOREST
---------------------------------------------

	stairsplus:register_all("autumn_forest_wood", "wood", "variety:autumn_forest_wood", {
		description = S("Autumn Forest Wood"),
		tiles = {"autumn_forest_wood.png"},
      	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})

	stairsplus:register_all("autumn_forest_tree", "tree", "variety:autumn_forest_tree", {
		description = S("Autumn Forest Tree"),
	tiles = {"autumn_forest_tree_top.png", "autumn_forest_tree_top.png",
		"autumn_forest_tree.png"},
      	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	    sounds = default.node_sound_wood_defaults(),
	})
end
