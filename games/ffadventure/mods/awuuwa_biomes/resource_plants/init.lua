--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local S = minetest.get_translator(MODNAME)





minetest.register_node("awuuwa_biomes_resource_plants:pasture_grass", {
	description = S("Pasture Grass"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_pasture_grass.png"},
	inventory_image = "awuuwa_biomes_pasture_grass.png",
	wield_image = "awuuwa_biomes_pasture_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("awuuwa_biomes_resource_plants:prairie_grass", {
	description = S("Prairie Grass"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_prairie_grass.png"},
	inventory_image = "awuuwa_biomes_prairie_grass.png",
	wield_image = "awuuwa_biomes_prairie_grass.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("awuuwa_biomes_resource_plants:plant", {
	description = S("Generic Plant"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_plant.png"},
	inventory_image = "awuuwa_biomes_plant.png",
	wield_image = "awuuwa_biomes_plant.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("awuuwa_biomes_resource_plants:tallgrass_dark", {
	description = S("Tall grass dark"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_tall_grass_dark.png"},
	inventory_image = "awuuwa_biomes_tall_grass_dark.png",
	wield_image = "awuuwa_biomes_tall_grass_dark.png",
	paramtype = "light",
	visual_scale = 2,
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 1, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})

--if minetest.settings:get_bool("awuuwa_biomes_settings.enable_generic_vegetation") == true then
minetest.register_node("awuuwa_biomes_resource_plants:vegetation", {
	description = S("Generic Vegetation"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_vegetation.png"},
	inventory_image = "awuuwa_biomes_vegetation.png",
	wield_image = "awuuwa_biomes_vegetation.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})
--end
minetest.register_node("awuuwa_biomes_resource_plants:vegetation_3", {
	description = S("Generic Vegetation 3"),
	drawtype = "plantlike",
	tiles = {"awuuwa_biomes_vegetation_3.png"},
	inventory_image = "awuuwa_biomes_vegetation_3.png",
	wield_image = "awuuwa_biomes_vegetation_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("awuuwa_biomes_resource_plants:leaves_floor", {
	description = S("Leaves On the Ground"),
	drawtype = "signlike",
	tiles = {"awuuwa_biomes_leaves_on_the_ground.png"},
	inventory_image = "awuuwa_biomes_leaves_on_the_ground.png",
	wield_image = "awuuwa_biomes_leaves_on_the_ground.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
--	sounds = default.node_sound_leaves_defaults(),
})
