--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]



local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_biome({
	name = "arctic",
	node_top = "default:dirt_with_snow",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	amplification = 0.8,
	node_riverbed = "default:clay",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	node_water_top = "default:ice",
	depth_water_top = 10,
	vertical_blend = 1,
--	node_river_water = "default:water_source",
	y_max = 40,
	y_min = 2,
    heat_point = 10,
    humidity_point = 53,
})

--[[minetest.register_decoration({
	name = "awuuwa_biomes_fungi_forest:fungi_tree_high_1",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter", "awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
    fill_ratio = 0.01,
	biomes = {"awuuwa_biomes_fungi_forest"},
--	y_max = 100,
--	y_min = 1,
	schematic = modpath .. "/schematics/fungi_tree_high_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random"
})]]

minetest.register_decoration({
	name = "awuuwa_biomes_lotsofsnow:snowpillar9",
	deco_type = "schematic",
	place_on = {"default:dirt_with_snow"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"arctic"},
	y_max = 31000,
	y_min = 1,
	schematic = modpath .. "/schematics/pillars/snow9.mts",
	flags = "place_center_x, place_center_z",
})
minetest.register_decoration({
	name = "awuuwa_biomes_lotsofsnow:snowpillar10",
	deco_type = "schematic",
	place_on = {"default:dirt_with_snow"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"arctic"},
	y_max = 31000,
	y_min = 1,
	schematic = modpath .. "/schematics/pillars/snow10.mts",
	flags = "place_center_x, place_center_z",
})
minetest.register_decoration({
	name = "awuuwa_biomes_lotsofsnow:snowpillar8",
	deco_type = "schematic",
	place_on = {"default:dirt_with_snow"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"arctic"},
	y_max = 31000,
	y_min = 1,
	schematic = modpath .. "/schematics/pillars/snow8.mts",
	flags = "place_center_x, place_center_z",
})
minetest.register_decoration({
	name = "awuuwa_biomes_lotsofsnow:snowpillar7",
	deco_type = "schematic",
	place_on = {"default:dirt_with_snow"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"arctic"},
	y_max = 31000,
	y_min = 1,
	schematic = modpath .. "/schematics/pillars/snow7.mts",
	flags = "place_center_x, place_center_z",
})
