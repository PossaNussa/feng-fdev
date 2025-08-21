local S = minetest.get_translator("variety")
---------------------------------------------
-------------MAPGENS
---------------------------------------------
minetest.register_biome({
    name = "cypress",
    node_top = "variety:japanese_dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 4,
		node_riverbed = "default:sand",
		depth_riverbed = 3,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
    y_max = 32,
    y_min = 1,
		heat_point = 70,
		humidity_point = 80,
})

minetest.register_decoration({
    name = "variety:cypress_1",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass", "default:dirt_with_rainforest_litter"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.011365,
    biomes = {"cypress", "rainforest_swamp"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/cypress_tree_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
	replacements = {
        {"default:aspen_tree", "variety:cypress_tree"},
		},
})

minetest.register_decoration({
    name = "variety:cypress_2",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass", "default:dirt_with_rainforest_litter"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.011365,
    biomes = {"cypress", "rainforest_swamp"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/cypress_tree_2.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
	replacements = {
        {"default:aspen_tree", "variety:cypress_tree"},
		},
})

minetest.register_decoration({
    name = "variety:cypress_3",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass", "default:dirt_with_rainforest_litter"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.011365,
    biomes = {"cypress"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/cypress_tree_3.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
	replacements = {
        {"default:aspen_tree", "variety:cypress_tree"},
		},
})

minetest.register_decoration({
    name = "variety:cypress_bush_1",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.005365,
    biomes = {"cypress"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/cypress_bush_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:cypress_log_1",
    deco_type = "schematic",
    place_on = {"variety:japanese_dirt_with_grass"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.005365,
    biomes = {"cypress"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/cypress_log_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
	replacements = {
        {"default:aspen_tree", "variety:cypress_tree"},
		},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:japanese_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.25,
	biomes = {"cypress"},
	decoration = {
		"default:grass_1", "default:grass_2",
		"default:grass_3", "default:grass_4",
		"default:grass_5",
	}
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:japanese_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.15,
	biomes = {"cypress"},
	decoration = {
		"flowers:rose", "flowers:dandelion_white",
		"flowers:tulip", "flowers:chrysanthemum_green",
		"flowers:viola", "flowers:dandelion_yellow",
		"flowers:geranium", "flowers:mushroom_brown",
	}
})



---------------------------------------------
-------------BLOCKS
---------------------------------------------


minetest.register_node("variety:cypress_tree", {
	description = S("Cypress Tree"),
	tiles = {"baldcypress_trunk_top.png", "baldcypress_trunk.png",
		"baldcypress_trunk.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})


minetest.register_node("variety:cypress_wood", {
	description = S("Cypress Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"baldcypress_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("variety:cypress_leaves_1", {
	description = S("Cypress Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"cypress_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:cypress_sapling"}, rarity = 20},
			{items = {"variety:cypress_leaves_1"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("variety:cypress_leaves_2", {
	description = S("Cypress Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"cypress_leaves_2.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:cypress_sapling"}, rarity = 20},
			{items = {"variety:cypress_leaves_2"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

	default.register_leafdecay({
		trunks = {"default:aspen_tree"},
		leaves = {"variety:cypress_leaves_1", "variety:cypress_leaves_2"},
		radius = 3,
	})


	stairs.register_stair_and_slab("cypress_wood", "variety:cypress_wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"baldcypress_wood.png"},
		S("Cypress Wood Stair"),
		S("Cypress Wood Slab"),
		default.node_sound_wood_defaults())

default.register_mesepost("variety:mese_post_light_baldcypress_wood", {
	description = S("Cypress Wood Mese Post Light"),
	texture = "baldcypress_wood.png",
	material = "variety:cypress_wood",
})

doors.register_fencegate("variety:gate_cypress", {
	description = S("baldcypress Wood Fence Gate"),
	texture = "baldcypress_wood.png",
	material = "variety:cypress_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})

	default.register_fence("variety:fence_cypress_wood", {
		description = S("Cypress Wood Fence"),
		texture = "baldcypress_wood.png",
		material = "variety:cypress_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

	default.register_fence_rail("variety:fence_rail_cypress_wood", {
		description = S("Cypress Wood Fence Rail"),
		texture = "baldcypress_wood.png",
		material = "variety:cypress_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

minetest.register_node("variety:cypress_sapling", {
	description = S("Cypress Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"bcsapling.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_baldcypress_tree,
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 5 / 16, 2 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2, attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"variety:cypress_sapling",
			{x = -1, y = 0, z = -1}, -- minp, maxp to be checked, relative to sapling pos
			{x = 1, y = 3, z = 1},
			2 -- maximum interval of interior volume check
		)

		return itemstack
	end,
})

local function grow_new_baldcypress_tree(pos)
	if not default.can_grow(pos) then
		-- Essayer un peu plus tard
			minetest.get_node_timer(pos):start(math.random(300, 1500))
		return
	end

	minetest.remove_node(pos)

	local random_tree = "tree_" .. math.random(1, 2) .. ".mts"
	minetest.place_schematic({x = pos.x - 4, y = pos.y, z = pos.z - 4}, minetest.get_modpath("variety") .. "/schematics/" .. random_tree, "0", nil, false)
end


if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"variety:cypress_sapling", grow_new_baldcypress_tree, "soil"},
	})
end

minetest.register_craft({
	output = "variety:cypress_wood 4",
	recipe = {
		{"variety:cypress_tree"},
	}
})
