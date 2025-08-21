minetest.register_node("rotting_wood:rotten_tree", {
	description = "Rotten Apple Tree",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {
		"rotting_wood_rotten_tree_top.png",
		"rotting_wood_rotten_tree_top.png",
		"rotting_wood_rotten_tree.png",
		"rotting_wood_rotten_tree.png",
		"rotting_wood_rotten_tree.png",
		"rotting_wood_rotten_tree.png"
	},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_wood", {
	description = "Rotten Apple Wood Planks",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {"rotting_wood_rotten_wood.png"},
	sounds = default.node_sound_gravel_defaults(),
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_aspen_tree", {
	description = "Rotten Aspen Tree",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {
		"rotting_wood_rotten_aspen_tree_top.png",
		"rotting_wood_rotten_aspen_tree_top.png",
		"rotting_wood_rotten_aspen_tree.png",
		"rotting_wood_rotten_aspen_tree.png",
		"rotting_wood_rotten_aspen_tree.png",
		"rotting_wood_rotten_aspen_tree.png"
	},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_aspen_wood", {
	description = "Rotten Aspen Wood Planks",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {"rotting_wood_rotten_aspen_wood.png"},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_pine_tree", {
	description = "Rotten Pine Tree",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {
		"rotting_wood_rotten_pine_tree_top.png",
		"rotting_wood_rotten_pine_tree_top.png",
		"rotting_wood_rotten_pine_tree.png",
		"rotting_wood_rotten_pine_tree.png",
		"rotting_wood_rotten_pine_tree.png",
		"rotting_wood_rotten_pine_tree.png"
	},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_pine_wood", {
	description = "Rotten Pine Wood Planks",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {"rotting_wood_rotten_pine_wood.png"},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_acacia_tree", {
	description = "Rotten Acacia Tree",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {
		"rotting_wood_rotten_acacia_tree_top.png",
		"rotting_wood_rotten_acacia_tree_top.png",
		"rotting_wood_rotten_acacia_tree.png",
		"rotting_wood_rotten_acacia_tree.png",
		"rotting_wood_rotten_acacia_tree.png",
		"rotting_wood_rotten_acacia_tree.png"
	},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_acacia_wood", {
	description = "Rotten Acacia Wood Planks",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {"rotting_wood_rotten_acacia_wood.png"},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_jungletree", {
	description = "Rotten Jungletree",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {
		"rotting_wood_rotten_jungletree_top.png",
		"rotting_wood_rotten_jungletree_top.png",
		"rotting_wood_rotten_jungletree.png",
		"rotting_wood_rotten_jungletree.png",
		"rotting_wood_rotten_jungletree.png",
		"rotting_wood_rotten_jungletree.png"
	},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})

minetest.register_node("rotting_wood:rotten_junglewood", {
	description = "Rotten Junglewood Planks",
	groups = {crumbly = 1, choppy = 1, falling_node = 1},
	tiles = {"rotting_wood_rotten_junglewood.png"},
	sounds = default.node_sound_gravel_defaults(),
	on_place = minetest.rotate_node,
	paramtype2 = "facedir"
})
