--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]



local modpath = minetest.get_modpath(minetest.get_current_modname())
local sprucetreemodpath = minetest.get_modpath("spruce_tree")

minetest.register_biome({
	name = "awuuwa_biomes_shield",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	amplification = 1.5,
	depth_filler = 3,
	node_riverbed = "default:dirt",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	vertical_blend = 1,
--	node_river_water = "default:water_source",
	y_max = 160,
	y_min = 9,
    heat_point = 8,
    humidity_point = 50,
--[[
    heat_point = 80,
    humidity_point = 98,
]]
})


minetest.register_decoration({
	name = "awuuwa_biomes_shield:spruce_tree1",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},--, "default:dirt_with_coniferous_litter", "default:dirt"
	sidelen = 16,
	fill_ratio = .0015,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = sprucetreemodpath .. "/schematics/sprucetree1.mts",
	flags = "place_center_x, place_center_z",
})

minetest.register_decoration({
	name = "awuuwa_biomes_shield:spruce_tree2",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},--, "default:dirt_with_coniferous_litter", "default:dirt"
	sidelen = 16,
	fill_ratio = .004,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = sprucetreemodpath .. "/schematics/sprucetree2.mts",
	flags = "place_center_x, place_center_z",
})
minetest.register_decoration({
	name = "awuuwa_biomes_shield:spruce_tree3",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},--, "default:dirt_with_coniferous_litter", "default:dirt"
	sidelen = 16,
	fill_ratio = .005,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = sprucetreemodpath .. "/schematics/sprucetree3.mts",
	flags = "place_center_x, place_center_z",
})


minetest.register_decoration({
	name = "awuuwa_biomes_shield:spruce_tree4",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},--, "default:dirt_with_coniferous_litter", "default:dirt"
	sidelen = 16,
	fill_ratio = .004,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = sprucetreemodpath .. "/schematics/sprucetree4.mts",
	flags = "place_center_x, place_center_z",
})

minetest.register_decoration({
	name = "awuuwa_biomes_shield:spruce_tree0",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt"},--, "default:dirt_with_coniferous_litter", "default:dirt"
	sidelen = 16,
	fill_ratio = .001,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = minetest.get_modpath("spruce_tree") .. "/schematics/spruce_tree.mts",
	flags = "place_center_x, place_center_z",
})





minetest.register_decoration({
	name = "awuuwa_biomes_shield:small_pine_tree",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = .0001,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 0,
	schematic = minetest.get_modpath("default") .. "/schematics/small_pine_tree.mts",
	flags = "place_center_x, place_center_z",
})


minetest.register_decoration({
	name = "awuuwa_biomes_shield:bush",
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "swamp:dirt_with_swamp_grass"},
	sidelen = 16,
	fill_ratio = 0.1,
	biomes = {"awuuwa_biomes_shield"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("default") .. "/schematics/pine_bush.mts",
	flags = "place_center_x, place_center_z",
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.15,
	biomes = {"awuuwa_biomes_shield"},
	decoration = {
		"default:fern_1",
	}
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.15,
	biomes = {"awuuwa_biomes_shield"},
	decoration = {
		"awuuwa_biomes_resource_plants:plant",
	}
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.003,
	biomes = {"awuuwa_biomes_shield"},
	decoration = {
		"awuuwa_biomes_resource_moss:stone_with_moss",
	}
})

for i = 1, 5 do
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.09,
	biomes = {"awuuwa_biomes_shield"},
	decoration = {
		"default:grass_" .. 5 - i,
	}
})
end
