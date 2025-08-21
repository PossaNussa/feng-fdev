--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]



local modpath = minetest.get_modpath(minetest.get_current_modname())
local fungiforestresourcemodpath = minetest.get_modpath("awuuwa_biomes_resource_fungi_forest")
local mushroomsresourcemodpath = minetest.get_modpath("awuuwa_biomes_resource_mushrooms")

local whatdirtweusing = "awuuwa_biomes_resource_mushrooms:brown_mushroom"

if minetest.get_modpath("default") then
whatdirtweusing = "default:dirt"
end

minetest.register_biome({
	name = "balsa_woods",
	node_top = "awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass",
	depth_top = 1,
	node_filler = whatdirtweusing,
	depth_filler = 3,
	node_riverbed = whatdirtweusing,
	depth_riverbed = 2,
--	node_cave_liquid = "default:water_source",
--    node_dungeon = "awuuwa_biomes_resource_mushrooms:brown_mushroom",
  --  node_dungeon_alt = "awuuwa_biomes_resource_mushrooms:red_mushroom",
	vertical_blend = 1,
--	node_river_water = "default:water_source",
	y_max = 40,
	y_min = 5,
    heat_point = 20,
    humidity_point = 60,
})


minetest.register_decoration({
    deco_type = "simple",
    place_on = {"default:water_source"},
    sidelen = 16,
    fill_ratio = 0.15,
    biomes = {"balsa_woods"},
    decoration = "flowers:waterlily_waving",
})


minetest.register_decoration({
	name = "awuuwa_biomes_fungi_forest:fungi_tree_high_1",
	deco_type = "schematic",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
    fill_ratio = 0.01,
	biomes = {"balsa_woods"},
--	y_max = 100,
--	y_min = 1,
	schematic = fungiforestresourcemodpath .. "/schematics/fungi_tree_high_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random"
})

minetest.register_decoration({
	name = "awuuwa_biomes_fungi_forest:fungi_tree_med_1",
	deco_type = "schematic",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
    fill_ratio = 0.01,
	biomes = {"balsa_woods"},
--	y_max = 100,
--	y_min = 1,
	schematic = fungiforestresourcemodpath .. "/schematics/fungi_tree_med_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random"
})

minetest.register_decoration({
	name = "awuuwa_biomes_fungi_forest:fungi_tree_big_1",
	deco_type = "schematic",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
    fill_ratio = 0.003,
	biomes = {"balsa_woods"},
--	y_max = 100,
--	y_min = 1,
	schematic = fungiforestresourcemodpath .. "/schematics/fungi_tree_big_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random"
})


--[[minetest.register_decoration({
	name = "awuuwa_biomes_fungi_forest:alternative",
	deco_type = "simple",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.5,
		scale = 0.4,
        spread = {x = 50, y = 50, z = 50},
		seed = 21,
		octaves = 2,
		persist = 0.11,
	},
	biomes = {"awuuwa_biomes_fungi_forest"},
	height = 1,
	y_min = 1,
	y_max = 31000,
	place_offset_y = -1,
	fill_ratio = 0.1,
	decoration = "default:dirt_with_rainforest_litter",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})]]


if minetest.get_modpath("default") then
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
	fill_ratio = 0.15,
	biomes = {"balsa_woods"},
	decoration = {
		"default:junglegrass", "default:fern_2", "default:fern_3",
	}
})
end
if minetest.get_modpath("flowers") then
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"awuuwa_biomes_resource_fungi_forest:dirt_with_fungi_forest_grass"},
	sidelen = 16,
	fill_ratio = 0.45,
	biomes = {"balsa_woods"},
	decoration = {
		"flowers:mushroom_brown", "flowers:mushroom_red",
	}
})
end
