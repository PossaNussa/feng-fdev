local S = minetest.get_translator("variety")

	minetest.register_biome({
		name = "darkforest",
		node_top = "variety:darkforest_dirt_with_grass",
		depth_top = 1,
        node_filler = "default:dirt",
        depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:stone_brick",
		node_dungeon_alt = "default:cobblestone",
		y_max = 31000,
		y_min = 1,
		heat_point = 100,
		humidity_point = 115,
	})

minetest.register_decoration({
    name = "variety:darkforest_tree_1",
    deco_type = "schematic",
    place_on = {"variety:darkforest_dirt_with_grass"},
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.040365,
    biomes = {"darkforest"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/darkforest_tree_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:darkforest_log",
    deco_type = "schematic",
    place_on = {"variety:darkforest_dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.001265,
    biomes = {"darkforest"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/darkforest_log_1.mts",
	flags = "force_placement",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:darkforest_bush",
    deco_type = "schematic",
    place_on = {"variety:darkforest_dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.004265,
    biomes = {"darkforest"},
    y_max = 31000,
    y_min = 1,
    schematic = minetest.get_modpath("variety").."/schematics/darkforest_bush_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:darkforest_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.06,
	biomes = {"darkforest"},
	decoration = {
		"flowers:mushroom_brown", "flowers:mushroom_red",
        "fireflies:firefly",
	}
})

minetest.register_decoration({
    name = "variety:darkforest_boulder1",
    deco_type = "schematic",
    place_on = {"variety:darkforest_dirt_with_grass"},
    place_offset_y = -2,
    sidelen = 16,
    fill_ratio = 0.0045565,
    biomes = {"darkforest"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/darkforest_boulder1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"variety:darkforest_dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.35,
	biomes = {"darkforest"},
	decoration = {
		"variety:darkforest_grass_5", "variety:darkforest_grass_4",
        "variety:darkforest_big_grass",
	}
})


---------------------------------------------
-------------BLOCKS
---------------------------------------------

minetest.register_node("variety:darkforest_big_grass", {
	description = S("Dark Forest Tall Grass"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 1.8,
	tiles = {"darkforest_big_grass.png"},
	inventory_image = "darkforest_big_grass.png",
	wield_image = "darkforest_big_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, junglegrass = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.5, 6 / 16},
	},
})

minetest.register_node("variety:darkforest_dirt_with_grass", {
	description = S("Dirt With Dark Grass"),
	tiles = {"darkforest_grass.png", "default_dirt.png",
		{name = "default_dirt.png^darkforest_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_dirt_footstep", gain = 0.25},
	}),
})

minetest.register_node("variety:darkforest_tree", {
	description = S("Dark Tree"),
	tiles = {"darkforest_tree_top.png", "darkforest_tree_top.png",
		"darkforest_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("variety:darkforest_wood", {
	description = S("Dark Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"darkforest_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("variety:darkforest_leaves", {
	description = S("Dark Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"darkforest_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:darkforest_sapling"}, rarity = 20},
			{items = {"variety:darkforest_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("variety:darkforest_sapling", {
	description = S("Dark Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"darkforest_trees.png"},
	inventory_image = "darkforest_trees.png",
	wield_image = "darkforest_trees.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_darkforest_tree,
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
			"variety:darkforest_sapling",
			{x = -1, y = 0, z = -1}, 
			{x = 1, y = 3, z = 1},
			2 
		)

		return itemstack
	end,
})

local function grow_new_darkforest_tree(pos)
	if not default.can_grow(pos) then
			minetest.get_node_timer(pos):start(math.random(300, 1500))
		return
	end

	minetest.remove_node(pos)

	local random_tree = "darkforest_tree_" .. math.random(1, 1) .. ".mts"
	minetest.place_schematic({x = pos.x - 4, y = pos.y, z = pos.z - 4}, minetest.get_modpath("variety") .. "/schematics/" .. random_tree, "0", nil, false)
end


if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"variety:darkforest_sapling", grow_new_darkforest_tree, "soil"},
	})
end

	default.register_leafdecay({
		trunks = {"variety:darkforest_tree"},
		leaves = {"variety:darkforest_leaves"},
		radius = 3,
	})

	stairs.register_stair_and_slab("darkforest_wood", "variety:darkforest_wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"darkforest_wood.png"},
		S("Dark Wood Stair"),
		S("Dark Wood Slab"),
		default.node_sound_wood_defaults())

default.register_mesepost("variety:mese_post_light_dark_wood", {
	description = S("Dark Wood Mese Post Light"),
	texture = "darkforest_wood.png",
	material = "variety:darkforest_wood",
})

doors.register_fencegate("variety:gate_darkforest", {
	description = S("Dark Wood Fence Gate"),
	texture = "darkforest_wood_fence.png",
	material = "variety:darkforest_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})

	default.register_fence("variety:fence_darkforest_wood", {
		description = S("Dark Wood Fence"),
		texture = "darkforest_wood_fence.png",
		inventory_image = "default_fence_overlay.png^darkforest_wood_fence.png^" ..
					"default_fence_overlay.png^[makealpha:255,126,126",
		wield_image = "default_fence_overlay.png^darkforest_wood_fence.png^" ..
					"default_fence_overlay.png^[makealpha:255,126,126",
		material = "variety:darkforest_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

	default.register_fence_rail("variety:fence_rail_darkforest_wood", {
		description = S("Dark Wood Fence Rail"),
		texture = "darkforest_wood_fence.png",
		inventory_image = "default_fence_rail_overlay.png^darkforest_wood_fence.png^" ..
					"default_fence_rail_overlay.png^[makealpha:255,126,126",
		wield_image = "default_fence_rail_overlay.png^darkforest_wood_fence.png^" ..
					"default_fence_rail_overlay.png^[makealpha:255,126,126",
		material = "variety:darkforest_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

	minetest.register_node("variety:darkforest_grass_5", {
		description = S("Dark Grass"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"darkforest_grass_5.png"},
		inventory_image = "darkforest_grass_5.png",
		wield_image = "darkforest_grass_5.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1, flammable = 1},
		max_items = 1,
			items = {
				{items = {"farming:seed_wheat"}, rarity = 5},
				{items = {"variety:darkforest_grass_5"}},
			},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
		},

		on_place = function(itemstack, placer, pointed_thing)
			-- place a random grass node
			local stack = ItemStack("variety:darkforest_grass_" .. math.random(4,5))
			local ret = minetest.item_place(stack, placer, pointed_thing)
			return ItemStack("variety:darkforest_grass_5 " ..
				itemstack:get_count() - (1 - ret:get_count()))
		end,
	})

for i = 4, 5 do
	minetest.register_node("variety:darkforest_grass_" .. i, {
		description = S("Dark Grass"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"darkforest_grass_" .. i .. ".png"},
		inventory_image = "darkforest_grass_" .. i .. ".png",
		wield_image = "darkforest_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drop = "variety:darkforest_grass_4",
		groups = {snappy = 3, flora = 1, attached_node = 1,
			not_in_creative_inventory = 1, grass = 1, flammable = 1},
			max_items = 1,
		items = {
			{items = {"farming:seed_wheat"}, rarity = 5},
			{items = {"variety:darkforest_grass_4"}},
		},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -3 / 16, 6 / 16},
		},
	})
end


---------------------------------------------
-------------CRAFTS
---------------------------------------------
minetest.register_craft({
	output = "variety:darkforest_wood 4",
	recipe = {
		{"variety:darkforest_tree"},
	}
})

