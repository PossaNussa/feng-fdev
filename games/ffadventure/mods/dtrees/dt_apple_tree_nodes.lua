-- dynamic_trees/dt_apple_tree_nodes.lua

-- This Is Where The Dynamic Apple Tree Nodes Are Registered

-- Apple Tree Sapling
minetest.register_node("dynamic_trees:apple_tree_sapling", {
	description = ("Apple Tree Sapling"),
	tiles = {"dt_apple_sapling.png"},
	inventory_image = "dt_apple_sapling.png",
	wield_image = "dt_apple_sapling.png",
	drawtype = "plantlike",
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {dt_apple_sapling = 1, snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	drop = "dynamic_trees:apple_tree_sapling",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- The Nodes That Make Up The Trunk Of The Tree
-- The Apple Tree Nodes That Have "Base" In Their Name Are The
-- Base Of The Tree And Control How Large A Tree Will Grow
-- Apple Tree Main Trunk Base 2 x 2
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_2x2", {
	description = ("Apple Tree Main Trunk Base 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
})

-- Apple Tree Main Trunk Base 4 x 4
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_4x4", {
	description = ("Apple Tree Main Trunk Base 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}
})

-- Apple Tree Main Trunk Base 6 x 6
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_6x6", {
	description = ("Apple Tree Main Trunk Base 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875}
})

-- Apple Tree Main Trunk Base 8 x 8
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_8x8", {
	description = ("Apple Tree Main Trunk Base 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
})

-- Apple Tree Main Trunk Base 10 x 10
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_10x10", {
	description = ("Apple Tree Main Trunk Base 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125}
})

-- Apple Tree Main Trunk Base 12 x 12
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_12x12", {
	description = ("Apple Tree Main Trunk Base 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Apple Tree Main Trunk Base 14 x 14
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_14x14", {
	description = ("Apple Tree Main Trunk Base 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375}
})

-- Apple Tree Main Trunk 16 x 16
minetest.register_node("dynamic_trees:apple_tree_main_trunk_base_16x16", {
	description = ("Apple Tree Main Trunk Base 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
})

-- This Is The Rest Of The Tree Growth Above The Main Trunk Base
-- They Don't Reach 16 x 16 And Rely On The Nodes Below Them
-- To Know When To Grow
-- Apple Tree Main Trunk 2 x 2
minetest.register_node("dynamic_trees:apple_tree_main_trunk_2x2", {
	description = ("Apple Tree Main Trunk 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
})

-- Apple Tree Main Trunk 4 x 4
minetest.register_node("dynamic_trees:apple_tree_main_trunk_4x4", {
	description = ("Apple Tree Main Trunk 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}
})

-- Apple Tree Main Trunk 6 x 6
minetest.register_node("dynamic_trees:apple_tree_main_trunk_6x6", {
	description = ("Apple Tree Main Trunk 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875}
})

-- Apple Tree Main Trunk 8 x 8
minetest.register_node("dynamic_trees:apple_tree_main_trunk_8x8", {
	description = ("Apple Tree Main Trunk 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
})

-- Apple Tree Main Trunk 10 x 10
minetest.register_node("dynamic_trees:apple_tree_main_trunk_10x10", {
	description = ("Apple Tree Main Trunk 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125}
})

-- Apple Tree Main Trunk 12 x 12
minetest.register_node("dynamic_trees:apple_tree_main_trunk_12x12", {
	description = ("Apple Tree Main Trunk 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Apple Tree Main Trunk 14 x 14
minetest.register_node("dynamic_trees:apple_tree_main_trunk_14x14", {
	description = ("Apple Tree Main Trunk 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375}
})


-- North Facing Nodes
-- Apple Tree Fork Trunk 2 x 2
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_2x2", {
	description = ("Apple Tree Fork North 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, 0.0625, 0.0625, 0.0625, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 4 x 4
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_4x4", {
	description = ("Apple Tree Fork North 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, 0.125, 0.125, 0.125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 6 x 6
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_6x6", {
	description = ("Apple Tree Fork North 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, 0.1875, 0.1875, 0.1875, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 8 x 8
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_8x8", {
	description = ("Apple Tree Fork North 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, 0.25, 0.25, 0.25, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 10 x 10
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_10x10", {
	description = ("Apple Tree Fork North 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, 0.3125, 0.3125, 0.3125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 12 x 12
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_12x12", {
	description = ("Apple Tree Fork North 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 14 x 14
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_fork_north_14x14", {
	description = ("Apple Tree Fork North 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
			{-0.4375, -0.4375, 0.4375, 0.4375, 0.4375, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 2 x 2
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_2x2", {
	description = ("Apple Tree Arm North 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 4 x 4
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_4x4", {
	description = ("Apple Tree Arm North 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.125, -0.5, 0.125, 0.125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 6 x 6
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_6x6", {
	description = ("Apple Tree Arm North 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, -0.5, 0.1875, 0.1875, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 8 x 8
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_8x8", {
	description = ("Apple Tree Arm North 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.5, 0.25, 0.25, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 10 x 10
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_10x10", {
	description = ("Apple Tree Arm North 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.3125, -0.5, 0.3125, 0.3125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 12 x 12
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_arm_north_12x12", {
	description = ("Apple Tree Arm North 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 2 x 2
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_elbow_north_2x2", {
	description = ("Apple Tree Elbow North 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, 0.0625, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 4 x 4
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_elbow_north_4x4", {
	description = ("Apple Tree Elbow North 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, 0.125, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, -0.5, 0.125, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 6 x 6
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_elbow_north_6x6", {
	description = ("Apple Tree Elbow North 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, 0.1875, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, -0.5, 0.1875, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 8 x 8
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_elbow_north_8x8", {
	description = ("Apple Tree Elbow North 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.25, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, -0.5, 0.25, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 10 x 10
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:apple_tree_elbow_north_10x10", {
	description = ("Apple Tree Elbow North 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, -0.5, 0.3125, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- South Facing Nodes
-- Apple Tree Fork Trunk 2 x 2
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_2x2", {
	description = ("Apple Tree Fork South 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, -0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 4 x 4
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_4x4", {
	description = ("Apple Tree Fork South 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, -0.5, 0.125, 0.125, -0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 6 x 6
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_6x6", {
	description = ("Apple Tree Fork South 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, -0.5, 0.1875, 0.1875, -0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 8 x 8
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_8x8", {
	description = ("Apple Tree Fork South 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, -0.5, 0.25, 0.25, -0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 10 x 10
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_10x10", {
	description = ("Apple Tree Fork South 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, -0.5, 0.3125, 0.3125, -0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 12 x 12
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_12x12", {
	description = ("Apple Tree Fork South 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 14 x 14
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_fork_south_14x14", {
	description = ("Apple Tree Fork South 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
			{-0.4375, -0.4375, -0.5, 0.4375, 0.4375, -0.4375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 2 x 2
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_2x2", {
	description = ("Apple Tree Arm South 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 4 x 4
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_4x4", {
	description = ("Apple Tree Arm South 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.125, -0.5, 0.125, 0.125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 6 x 6
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_6x6", {
	description = ("Apple Tree Arm South 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, -0.5, 0.1875, 0.1875, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 8 x 8
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_8x8", {
	description = ("Apple Tree Arm South 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.5, 0.25, 0.25, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 10 x 10
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_10x10", {
	description = ("Apple Tree Arm South 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.3125, -0.5, 0.3125, 0.3125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 12 x 12
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_arm_south_12x12", {
	description = ("Apple Tree Arm South 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 2 x 2
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_elbow_south_2x2", {
	description = ("Apple Tree Elbow South 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, 0.0625, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.0625, 0.0625, 0.0625, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 4 x 4
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_elbow_south_4x4", {
	description = ("Apple Tree Elbow South 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, 0.125, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, -0.125, 0.125, 0.125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 6 x 6
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_elbow_south_6x6", {
	description = ("Apple Tree Elbow South 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, 0.1875, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, -0.1875, 0.1875, 0.1875, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 8 x 8
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_elbow_south_8x8", {
	description = ("Apple Tree Elbow South 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.25, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 10 x 10
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:apple_tree_elbow_south_10x10", {
	description = ("Apple Tree Elbow South 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, 0.3125, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, -0.3125, 0.3125, 0.3125, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- East Facing Nodes
-- Apple Tree Fork Trunk 2 x 2
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_2x2", {
	description = ("Apple Tree Fork East 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{0.0625, -0.0625, -0.0625, 0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 4 x 4
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_4x4", {
	description = ("Apple Tree Fork East 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
			{0.125, -0.125, -0.125, 0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 6 x 6
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_6x6", {
	description = ("Apple Tree Fork East 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{0.1875, -0.1875, -0.1875, 0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 8 x 8
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_8x8", {
	description = ("Apple Tree Fork East 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			{0.25, -0.25, -0.25, 0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 10 x 10
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_10x10", {
	description = ("Apple Tree Fork East 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
			{0.3125, -0.3125, -0.3125, 0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 12 x 12
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_12x12", {
	description = ("Apple Tree Fork East 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 14 x 14
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_fork_east_14x14", {
	description = ("Apple Tree Fork East 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
			{0.4375, -0.4375, -0.4375, 0.5, 0.4375, 0.4375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 2 x 2
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_2x2", {
	description = ("Apple Tree Arm East 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.0625, -0.0625, 0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 4 x 4
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_4x4", {
	description = ("Apple Tree Arm East 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.125, -0.125, 0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 6 x 6
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_6x6", {
	description = ("Apple Tree Arm East 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.1875, -0.1875, 0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 8 x 8
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_8x8", {
	description = ("Apple Tree Arm East 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.25, -0.25, 0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 10 x 10
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_10x10", {
	description = ("Apple Tree Arm East 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.3125, -0.3125, 0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 12 x 12
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_arm_east_12x12", {
	description = ("Apple Tree Arm East 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 2 x 2
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_east_2x2", {
	description = ("Apple Tree Elbow East 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.0625, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.0625, -0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 4 x 4
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_east_4x4", {
	description = ("Apple Tree Elbow East 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.125, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, -0.125, -0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 6 x 6
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_east_6x6", {
	description = ("Apple Tree Elbow East 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, -0.1875, -0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 8 x 8
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_east_8x8", {
	description = ("Apple Tree Elbow East 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, -0.25, -0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 10 x 10
-- This Faces East Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_east_10x10", {
	description = ("Apple Tree Elbow East 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.3125, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, -0.3125, -0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- West Facing Nodes
-- Apple Tree Fork Trunk 2 x 2
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_2x2", {
	description = ("Apple Tree Fork West 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.0625, -0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 4 x 4
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_4x4", {
	description = ("Apple Tree Fork West 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
			{-0.125, -0.125, -0.125, -0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 6 x 6
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_6x6", {
	description = ("Apple Tree Fork West 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.1875, -0.1875, -0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 8 x 8
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_8x8", {
	description = ("Apple Tree Fork West 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			{-0.25, -0.25, -0.25, -0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 10 x 10
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_10x10", {
	description = ("Apple Tree Fork West 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.3125, -0.3125, -0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 12 x 12
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_12x12", {
	description = ("Apple Tree Fork West 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Fork Trunk 14 x 14
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_fork_west_14x14", {
	description = ("Apple Tree Fork West 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, 0.5, 0.4375},
			{-0.4375, -0.4375, -0.4375, -0.5, 0.4375, 0.4375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 2 x 2
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_2x2", {
	description = ("Apple Tree Arm West 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.0625, -0.0625, 0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 4 x 4
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_4x4", {
	description = ("Apple Tree Arm West 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.125, -0.125, 0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 6 x 6
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_6x6", {
	description = ("Apple Tree Arm West 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.1875, -0.1875, 0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 8 x 8
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_8x8", {
	description = ("Apple Tree Arm West 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.25, -0.25, 0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 10 x 10
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_10x10", {
	description = ("Apple Tree Arm West 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.3125, -0.3125, 0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Arm Trunk 12 x 12
-- This Faces West Or -X
minetest.register_node("dynamic_trees:apple_tree_arm_west_12x12", {
	description = ("Apple Tree Arm West 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 2 x 2
-- This Faces West Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_west_2x2", {
	description = ("Apple Tree Elbow West 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.0625, -0.0625, 0.0625, 0.5, 0.0625},
			{0.0625, -0.0625, -0.0625, 0.5, 0.0625, 0.0625},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 4 x 4
-- This Faces West Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_west_4x4", {
	description = ("Apple Tree Elbow West 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.125, -0.125, 0.125, 0.5, 0.125},
			{0.125, -0.125, -0.125, 0.5, 0.125, 0.125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 6 x 6
-- This Faces West Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_west_6x6", {
	description = ("Apple Tree Elbow West 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, -0.1875, 0.1875, 0.5, 0.1875},
			{0.1875, -0.1875, -0.1875, 0.5, 0.1875, 0.1875},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 8 x 8
-- This Faces West Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_west_8x8", {
	description = ("Apple Tree Elbow West 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.25, -0.25, 0.25, 0.5, 0.25},
			{0.25, -0.25, -0.25, 0.5, 0.25, 0.25},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Apple Tree Elbow Trunk 10 x 10
-- This Faces West Or +X
minetest.register_node("dynamic_trees:apple_tree_elbow_west_10x10", {
	description = ("Apple Tree Elbow West 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.3125, -0.3125, 0.3125, 0.5, 0.3125},
			{0.3125, -0.3125, -0.3125, 0.5, 0.3125, 0.3125},
		}
	},
	tiles = {
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png",
		"dt_apple_tree_bark.png"
	},
	groups = {dynamic_tree_apple = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:tree 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- These Are The Nodes That Make Up The Leaves Of The Tree Filling It Out
-- Apple Tree Canopy Base
minetest.register_node("dynamic_trees:apple_tree_canopy_base", {
	description = ("Apple Tree Canopy Base"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_leaves.png"
	},
	groups = {dt_apple_leaves = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1, not_in_creative_inventory = 1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"dynamic_trees:apple_tree_sapling"},
				rarity = 20,
			},
			{
				items = {"default:leaves"},
				rarity = 5,
			},
			{
				items = {"default:stick"},
				rarity = 10,
			},
			{
				items = {"default:apple"},
				rarity = 20,
			}
		}
	},
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_leaves_defaults(),
	collision_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
})

-- Apple Tree Canopy 1
minetest.register_node("dynamic_trees:apple_tree_canopy_1", {
	description = ("Apple Tree Canopy 1"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
	tiles = {
		"dt_apple_tree_leaves.png"
	},
	groups = {dt_apple_leaves = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1, not_in_creative_inventory = 1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"dynamic_trees:apple_tree_sapling"},
				rarity = 20,
			},
			{
				items = {"default:leaves"},
				rarity = 5,
			},
			{
				items = {"default:stick"},
				rarity = 10,
			},
			{
				items = {"default:apple"},
				rarity = 20,
			}
		}
	},
	waving = 1,
	paramtype = "light",
	param2 = 0,
	sunlight_propagates = true,
	sounds = default.node_sound_leaves_defaults(),
	collision_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
})

-- The Apple That Is Used On The DT Apple Tree
minetest.register_node("dynamic_trees:apple", {
	description = ("DT Apple"),
	tiles = {"dt_apple.png"},
	inventory_image = "dt_apple.png",
	wield_image = "dt_apple.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 1, not_in_creative_inventory = 1},
	drop = "default:apple",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})