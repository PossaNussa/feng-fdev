-- dynamic_trees/dt_cactus_nodes.lua

-- This Is Where The Dynamic Cactus Nodes Are Registered

-- Cactus Seedling
minetest.register_node("dynamic_trees:cactus_seedling", {
	description = ("Large Cactus Seedling"),
	tiles = {"dt_cactus_seedling.png"},
	inventory_image = "dt_cactus_seedling.png",
	wield_image = "dt_cactus_seedling.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {dt_cactus_seedling = 1, snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	drop = "dynamic_trees:cactus_seedling",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- The Nodes That Make Up The Trunk Of The Tree
-- The Cactus Nodes That Have "Base" In Their Name Are The
-- Base Of The Tree And Control How Large A Tree Will Grow
-- Cactus Main Trunk Base 2 x 2
minetest.register_node("dynamic_trees:cactus_main_trunk_base_2x2", {
	description = ("Cactus Main Trunk Base 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 4 x 4
minetest.register_node("dynamic_trees:cactus_main_trunk_base_4x4", {
	description = ("Cactus Main Trunk Base 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 6 x 6
minetest.register_node("dynamic_trees:cactus_main_trunk_base_6x6", {
	description = ("Cactus Main Trunk Base 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 8 x 8
minetest.register_node("dynamic_trees:cactus_main_trunk_base_8x8", {
	description = ("Cactus Main Trunk Base 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 10 x 10
minetest.register_node("dynamic_trees:cactus_main_trunk_base_10x10", {
	description = ("Cactus Main Trunk Base 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 12 x 12
minetest.register_node("dynamic_trees:cactus_main_trunk_base_12x12", {
	description = ("Cactus Main Trunk Base 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk Base 14 x 14
minetest.register_node("dynamic_trees:cactus_main_trunk_base_14x14", {
	description = ("Cactus Main Trunk Base 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 16 x 16
minetest.register_node("dynamic_trees:cactus_main_trunk_base_16x16", {
	description = ("Cactus Main Trunk Base 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
})

-- This Is The Rest Of The Tree Growth Above The Main Trunk Base
-- They Don't Reach 16 x 16 By Themselves And Rely On The Nodes Below Them
-- To Know When To Grow
-- Cactus Main Trunk 2 x 2
minetest.register_node("dynamic_trees:cactus_main_trunk_2x2", {
	description = ("Cactus Main Trunk 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 4 x 4
minetest.register_node("dynamic_trees:cactus_main_trunk_4x4", {
	description = ("Cactus Main Trunk 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 6 x 6
minetest.register_node("dynamic_trees:cactus_main_trunk_6x6", {
	description = ("Cactus Main Trunk 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 8 x 8
minetest.register_node("dynamic_trees:cactus_main_trunk_8x8", {
	description = ("Cactus Main Trunk 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 10 x 10
minetest.register_node("dynamic_trees:cactus_main_trunk_10x10", {
	description = ("Cactus Main Trunk 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 12 x 12
minetest.register_node("dynamic_trees:cactus_main_trunk_12x12", {
	description = ("Cactus Main Trunk 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 14 x 14
minetest.register_node("dynamic_trees:cactus_main_trunk_14x14", {
	description = ("Cactus Main Trunk 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- Cactus Main Trunk 16 x 16
minetest.register_node("dynamic_trees:cactus_main_trunk_16x16", {
	description = ("Cactus Main Trunk 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults(),
	collision_box = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
})

-- North Facing Nodes
-- Cactus Fork Trunk 2 x 2
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_2x2", {
	description = ("Cactus Fork North 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 4 x 4
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_4x4", {
	description = ("Cactus Fork North 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 6 x 6
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_6x6", {
	description = ("Cactus Fork North 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 8 x 8
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_8x8", {
	description = ("Cactus Fork North 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 10 x 10
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_10x10", {
	description = ("Cactus Fork North 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 12 x 12
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_12x12", {
	description = ("Cactus Fork North 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 14 x 14
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_14x14", {
	description = ("Cactus Fork North 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 16 x 16
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_fork_north_16x16", {
	description = ("Cactus Fork North 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, 0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 2 x 2
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_2x2", {
	description = ("Cactus Elbow North 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 4 x 4
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_4x4", {
	description = ("Cactus Elbow North 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 6 x 6
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_6x6", {
	description = ("Cactus Elbow North 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 8 x 8
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_8x8", {
	description = ("Cactus Elbow North 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 10 x 10
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_10x10", {
	description = ("Cactus Elbow North 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 12 x 12
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_12x12", {
	description = ("Cactus Elbow North 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 14 x 14
-- This Faces North Or +Z
minetest.register_node("dynamic_trees:cactus_elbow_north_14x14", {
	description = ("Cactus Elbow North 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- South Facing Nodes
-- Cactus Fork Trunk 2 x 2
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_2x2", {
	description = ("Cactus Fork South 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 4 x 4
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_4x4", {
	description = ("Cactus Fork South 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 6 x 6
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_6x6", {
	description = ("Cactus Fork South 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 8 x 8
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_8x8", {
	description = ("Cactus Fork South 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 10 x 10
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_10x10", {
	description = ("Cactus Fork South 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 12 x 12
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_12x12", {
	description = ("Cactus Fork South 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 14 x 14
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_14x14", {
	description = ("Cactus Fork South 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 16 x 16
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_fork_south_16x16", {
	description = ("Cactus Fork South 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.5, 0.375, 0.375, -0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 2 x 2
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_2x2", {
	description = ("Cactus Elbow South 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 4 x 4
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_4x4", {
	description = ("Cactus Elbow South 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 6 x 6
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_6x6", {
	description = ("Cactus Elbow South 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 8 x 8
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_8x8", {
	description = ("Cactus Elbow South 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 10 x 10
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_10x10", {
	description = ("Cactus Elbow South 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 12 x 12
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_12x12", {
	description = ("Cactus Elbow South 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 14 x 14
-- This Faces South Or -Z
minetest.register_node("dynamic_trees:cactus_elbow_south_14x14", {
	description = ("Cactus Elbow South 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, 0.375, 0.375, 0.5},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- East Facing Nodes
-- Cactus Fork Trunk 2 x 2
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_2x2", {
	description = ("Cactus Fork East 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 4 x 4
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_4x4", {
	description = ("Cactus Fork East 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 6 x 6
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_6x6", {
	description = ("Cactus Fork East 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 8 x 8
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_8x8", {
	description = ("Cactus Fork East 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 10 x 10
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_10x10", {
	description = ("Cactus Fork East 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 12 x 12
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_12x12", {
	description = ("Cactus Fork East 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 14 x 14
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_14x14", {
	description = ("Cactus Fork East 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 16 x 16
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_fork_east_16x16", {
	description = ("Cactus Fork East 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 2 x 2
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_2x2", {
	description = ("Cactus Elbow East 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 4 x 4
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_4x4", {
	description = ("Cactus Elbow East 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 6 x 6
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_6x6", {
	description = ("Cactus Elbow East 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 8 x 8
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_8x8", {
	description = ("Cactus Elbow East 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 10 x 10
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_10x10", {
	description = ("Cactus Elbow East 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 12 x 12
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_12x12", {
	description = ("Cactus Elbow East 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 14 x 14
-- This Faces East Or +X
minetest.register_node("dynamic_trees:cactus_elbow_east_14x14", {
	description = ("Cactus Elbow East 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- West Facing Nodes
-- Cactus Fork Trunk 2 x 2
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_2x2", {
	description = ("Cactus Fork West 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 4 x 4
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_4x4", {
	description = ("Cactus Fork West 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 6 x 6
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_6x6", {
	description = ("Cactus Fork West 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 8 x 8
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_8x8", {
	description = ("Cactus Fork West 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 10 x 10
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_10x10", {
	description = ("Cactus Fork West 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 12 x 12
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_12x12", {
	description = ("Cactus Fork West 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 14 x 14
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_14x14", {
	description = ("Cactus Fork West 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Fork Trunk 16 x 16
-- This Faces West Or -X
minetest.register_node("dynamic_trees:cactus_fork_west_16x16", {
	description = ("Cactus Fork West 16x16"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			{-0.375, -0.375, -0.375, -0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 2 x 2
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_2x2", {
	description = ("Cactus Elbow West 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 4 x 4
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_4x4", {
	description = ("Cactus Elbow West 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 6 x 6
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_6x6", {
	description = ("Cactus Elbow West 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 8 x 8
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_8x8", {
	description = ("Cactus Elbow West 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 10 x 10
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_10x10", {
	description = ("Cactus Elbow West 10x10"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 12 x 12
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_12x12", {
	description = ("Cactus Elbow West 12x12"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 3",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Cactus Elbow Trunk 14 x 14
-- This Faces West Or +X
minetest.register_node("dynamic_trees:cactus_elbow_west_14x14", {
	description = ("Cactus Elbow West 14x14"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.375, -0.375, 0.375, 0.5, 0.375},
			{0.375, -0.375, -0.375, 0.5, 0.375, 0.375},
		}
	},
	tiles = {
		"dt_cactus_top.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png",
		"dt_cactus_side.png"
	},
	groups = {dynamic_tree_cactus = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
	drop = "default:cactus 4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})