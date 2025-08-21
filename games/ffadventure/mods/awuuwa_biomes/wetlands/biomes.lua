--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_biome({
	name = "awuuwa_biomes_wetlands",
	node_top = "swamp:dirt_with_swamp_grass",
	depth_top = 1,
	node_filler = "default:mud",
	depth_filler = 3,
	node_riverbed = "default:mud",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	vertical_blend = 1,
--	node_river_water = "default:water_source",
	y_max = 31,
	y_min = 1,
    heat_point = 35,
    humidity_point = 80,
})


	minetest.register_decoration({
		name = "awuuwa_biomes_wetlands:tree1",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
		sidelen = 16,
		fill_ratio = 0.05,
		biomes = {"awuuwa_biomes_wetlands"},
		y_max = 31000,
		y_min = 0,
		schematic = modpath .. "/schematics/wetlandstree1.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random"
	})

	minetest.register_decoration({
		name = "awuuwa_biomes_wetlands:bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
		sidelen = 16,
		fill_ratio = 0.1,
		biomes = {"awuuwa_biomes_wetlands"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/bush.mts",
		flags = "place_center_x, place_center_z",
	})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"awuuwa_biomes_wetlands"},
	decoration = {
		"awuuwa_biomes_resource_plants:tallgrass_dark"
	}
})


--[[for i = 1, 5 do
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"awuuwa_biomes_wetlands"},
	decoration = {
		"default:grass_" .. i,
	}
})
end


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
	sidelen = 16,
	fill_ratio = 1.0,
	biomes = {"awuuwa_biomes_wetlands"},
	decoration = {
		"flowers:rose", "flowers:tulip", "flowers:dandelion_yellow", "flowers:geranium", "flowers:viola", "flowers:dandelion_white"
	}
})
]]

