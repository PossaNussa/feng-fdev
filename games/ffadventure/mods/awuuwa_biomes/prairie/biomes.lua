--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_biome({
	name = "awuuwa_biomes_prairie",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:dirt",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	vertical_blend = 1,
--	node_river_water = "default:water_source",
	y_max = 40,
	y_min = 1,
	heat_point = 45,
	humidity_point = 28,
})


	minetest.register_decoration({
		name = "awuuwa_biomes_prairie:bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"awuuwa_biomes_prairie"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/bush.mts",
		flags = "place_center_x, place_center_z",
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
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"awuuwa_biomes_prairie"},
	decoration = {
		"awuuwa_biomes_resource_plants:prairie_grass",
	}
})

for i = 1, 5 do
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.25,
	biomes = {"awuuwa_biomes_prairie"},
	decoration = {
		"default:grass_" .. i,
	}
})
end
