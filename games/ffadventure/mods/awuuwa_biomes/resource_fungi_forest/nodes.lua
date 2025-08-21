--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local MODNAME = minetest.get_current_modname()
local MODPATH = minetest.get_modpath(MODNAME)
local S = minetest.get_translator(MODNAME)


minetest.register_node("awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass", {
	description = S("dirt_with_fungi_forest_grass^[colorize:green:40"),
	tiles = {"awuuwa_biomes_dirt_with_fungi_forest_grass.png^[colorize:green:40", "default_dirt.png",
		{name = "default_dirt.png^awuuwa_biomes_dirt_with_fungi_forest_grass_side.png^[colorize:green:40",
		tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
	soil = {
		base = "awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.register_node("awuuwa_biomes_resource_fungi_forest:fungi_forest_leaves", {
	description = S("Fungi Tree Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"awuuwa_biomes_fungi_forest_leaves.png^[colorize:green:40"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"awuuwa_biomes_resource_fungi_forest:fungi_tree_sapling"}, rarity = 20},
			{items = {"awuuwa_biomes_resource_fungi_forest:fungi_forest_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})


minetest.register_node("awuuwa_biomes_resource_fungi_forest:fungi_tree_sapling", {
	description = S("Balsa Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_fungi_forest_sapling.png"},
	inventory_image = "awuuwa_biomes_fungi_forest_sapling.png",
	wield_image = "awuuwa_biomes_fungi_forest_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("awuuwa_biomes_resource_fungi_forest:vine", {
	description = S("Fungi Forest Vine"),
	drawtype = "signlike",
	tiles = {"awuuwa_biomes_fungi_forest_leaves.png^[colorize:green:40"},
	inventory_image = "awuuwa_biomes_fungi_forest_leaves.png",
	wield_image = "awuuwa_biomes_fungi_forest_leaves.png",
	waving = 1,
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted"
	},
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_leaves_defaults()
})




minetest.register_node("awuuwa_biomes_resource_fungi_forest:flower_1", {
	description = S("Fungi Forest Flower 1"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_fungi_forest_flower_1.png"},
	inventory_image = "awuuwa_biomes_fungi_forest_flower_1.png",
	wield_image = "awuuwa_biomes_fungi_forest_flower_1.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),
})
