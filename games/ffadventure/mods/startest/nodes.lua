minetest.register_node("startest:dense_space_crystal_ore", {
    description = "Dense Space Crystal Ore",
    tiles = {"dense_space_crystal_ore.png"},
    groups = {cracky=1, stone=1},
    drop = "startest:dense_space_crystal 2"
})

minetest.register_node("startest:space_crystal_ore", {
    description = "Space Crystal Ore",
    tiles = {"space_crystal_ore.png"},
    groups = {cracky=1, stone=1},
    drop = "startest:space_crystal 2"
})

minetest.register_node("startest:space_crystal_spike", {
	description ="Space Crystal Spike",
	drawtype = "plantlike",
	visual_scale = 1.69,
	tiles = {"space_crystal_spike.png"},
	inventory_image = "space_crystal_spike.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:space_crystal 1"
})

minetest.register_node("startest:space_crystal_single_spike", {
	description ="Space Crystal Single Spike",
	drawtype = "plantlike",
	visual_scale = 1.4,
	tiles = {"space_crystal_spike2.png"},
	inventory_image = "space_crystal_spike2.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:space_crystal 1"
})

minetest.register_node("startest:space_crystal_pointed_spike", {
	description ="Space Crystal Pointed Spike",
	drawtype = "plantlike",
	visual_scale = 1.4,
	tiles = {"space_crystal_spike3.png"},
	inventory_image = "space_crystal_spike3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:space_crystal 1"
})

minetest.register_node("startest:dense_space_crystal_spike", {
	description ="Dense Space Crystal Spike",
	drawtype = "plantlike",
	visual_scale = 1.69,
	tiles = {"dense_space_crystal_spike.png"},
	inventory_image = "dense_space_crystal_spike.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:dense_space_crystal 1"
})

minetest.register_node("startest:dense_space_crystal_single_spike", {
	description ="Dense Space Crystal Single Spike",
	drawtype = "plantlike",
	visual_scale = 1.4,
	tiles = {"dense_space_crystal_spike2.png"},
	inventory_image = "dense_space_crystal_spike2.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:dense_space_crystal 1"
})

minetest.register_node("startest:dense_space_crystal_pointed_spike", {
	description ="Dense Space Crystal Pointed Spike",
	drawtype = "plantlike",
	visual_scale = 1.4,
	tiles = {"dense_space_crystal_spike3.png"},
	inventory_image = "dense_space_crystal_spike3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {cracky = 3, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
    drop = "startest:dense_space_crystal 1"
})

minetest.register_node("startest:cracked_stone", {
    description = "Cracked Stone",
    tiles = {"cracked_stone.png", "default_stone.png", "default_stone.png", "default_stone.png", "default_stone.png", "default_stone.png"},
    groups = {cracky=1, stone=1},
    drop = "default:cobble"
})

minetest.register_node("startest:monster_block", {
    description = "Monster Block",
    tiles = {"monster_block.png"},
    groups = {crumbly=1, stone=1},
    drop = "startest:monster_block"
})