-- dynamic_trees/dt_bamboo_nodes.lua


-- Bamboo Shoot
minetest.register_node("dynamic_trees:bamboo_shoot", {
	description = ("Bamboo Shoot"),
	tiles = {"dt_bamboo_shoot.png"},
	inventory_image = "dt_bamboo_shoot.png",
	wield_image = "dt_bamboo_shoot.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_sapling = 1, snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	drop = "dynamic_trees:bamboo_shoot",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 1 Base
minetest.register_node("dynamic_trees:bamboo_canopy_1_base", {
	description = ("Bamboo Canopy 1 Base"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "plantlike",
	visual_scale = 1.5,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_1_base",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 1 Top
minetest.register_node("dynamic_trees:bamboo_canopy_1_top", {
	description = ("Bamboo Canopy 1 Top"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0},
			{0, -0.5, -0.5, 0, 0.5, 0.5}
		}
	},
	visual_scale = 1.5,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_1_top",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})


-- Bamboo Canopy 2 Base
minetest.register_node("dynamic_trees:bamboo_canopy_2_base", {
	description = ("Bamboo Canopy 2 Base"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "nodebox",
	drawtype = "plantlike",
	visual_scale = 2,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_2_base",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 2 Top
minetest.register_node("dynamic_trees:bamboo_canopy_2_top", {
	description = ("Bamboo Canopy 2 Top"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0},
			{0, -0.5, -0.5, 0, 0.5, 0.5}
		}
	},
	visual_scale = 2,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_2_top",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 3 Base
minetest.register_node("dynamic_trees:bamboo_canopy_3_base", {
	description = ("Bamboo Canopy 3 Base"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0},
			{0, -0.5, -0.5, 0, 0.5, 0.5}
		}
	},
	visual_scale = 2.5,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_3_base",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 3 Top
minetest.register_node("dynamic_trees:bamboo_canopy_3_top", {
	description = ("Bamboo Canopy 3 Top"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "plantlike",
	visual_scale = 2.5,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_3_top",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 4 Base
minetest.register_node("dynamic_trees:bamboo_canopy_4_base", {
	description = ("Bamboo Canopy 4 Base"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0, 0.5, 0.5, 0},
			{0, -0.5, -0.5, 0, 0.5, 0.5}
		}
	},
	visual_scale = 3,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_4_base",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo Canopy 4 Top
minetest.register_node("dynamic_trees:bamboo_canopy_4_top", {
	description = ("Bamboo Canopy 4 Top"),
	tiles = {"dt_bamboo_leaves.png"},
	inventory_image = "dt_bamboo_leaves.png",
	wield_image = "dt_bamboo_leaves.png",
	drawtype = "plantlike",
	visual_scale = 3,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {dt_bamboo_leaves = 1, attached_node = 1, leaf_decay = 3, snappy = 3, flammable = 2, leaves = 1},
	drop = "dynamic_trees:bamboo_canopy_4_top",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, -1 / 16, 4 / 16},
	},
})

-- Bamboo 2x2 Base
minetest.register_node("dynamic_trees:bamboo_2x2_base", {
	description = ("Bamboo 2x2 Base"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
		}
	},
	tiles = {
		"dt_bamboo_top_small_medium.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1,
	flammable = 2, not_in_creative_inventory = 1},
	drop = "dynamic_trees:bamboo_2x2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 2x2
minetest.register_node("dynamic_trees:bamboo_2x2", {
	description = ("Bamboo 2x2"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
		}
	},
	tiles = {
		"dt_bamboo_top_small_medium.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	drop = "dynamic_trees:bamboo_2x2",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 4x4 Base
minetest.register_node("dynamic_trees:bamboo_4x4_base", {
	description = ("Bamboo 4x4 Base"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}
		}
	},
	tiles = {
		"dt_bamboo_top_small_medium.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1,
	flammable = 2, not_in_creative_inventory = 1},
	drop = "dynamic_trees:bamboo_4x4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 4x4
minetest.register_node("dynamic_trees:bamboo_4x4", {
	description = ("Bamboo 4x4"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}
		}
	},
	tiles = {
		"dt_bamboo_top_small_medium.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	drop = "dynamic_trees:bamboo_4x4",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 6x6 Base
minetest.register_node("dynamic_trees:bamboo_6x6_base", {
	description = ("Bamboo 6x6 Base"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875}
		}
	},
	tiles = {
		"dt_bamboo_top_large.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1,
	flammable = 2, not_in_creative_inventory = 1},
	drop = "dynamic_trees:bamboo_6x6",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 6x6
minetest.register_node("dynamic_trees:bamboo_6x6", {
	description = ("Bamboo 6x6"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875}
		}
	},
	tiles = {
		"dt_bamboo_top_large.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	drop = "dynamic_trees:bamboo_6x6",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 8x8 Base
minetest.register_node("dynamic_trees:bamboo_8x8_base", {
	description = ("Bamboo 8x8 Base"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
		}
	},
	tiles = {
		"dt_bamboo_top_huge.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1,
	flammable = 2, not_in_creative_inventory = 1},
	drop = "dynamic_trees:bamboo_8x8",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})

-- Bamboo 8x8
minetest.register_node("dynamic_trees:bamboo_8x8", {
	description = ("Bamboo 8x8"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
		}
	},
	tiles = {
		"dt_bamboo_top_huge.png",
		"dt_bamboo_trunk.png",
		"dt_bamboo_trunk.png"
	},
	groups = {dynamic_tree_bamboo = 1, attached_node = 1, tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	drop = "dynamic_trees:bamboo_8x8",
	paramtype = "light",
	sunlight_propagates = true,
	sounds = default.node_sound_wood_defaults()
})