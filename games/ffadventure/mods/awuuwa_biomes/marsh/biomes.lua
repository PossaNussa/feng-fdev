--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]



local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_biome({
	name = "marsh",
	node_top = "default:dirt",
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
	y_max = -1,
	y_min = -255,
    heat_point = 35,--80
    humidity_point = 73,
--[[
    heat_point = 80,
    humidity_point = 98,
]]
})

--[[minetest.register_biome({
	name = "swamp_under",
	node_cave_liquid = {"awuuwa_biomes_marsh:swamp_water_source", "default:lava_source"},
    node_dungeon = "awuuwa_biomes_marsh:purple_thing",
    node_dungeon_alt = "awuuwa_biomes_marsh:purple_thing",
	node_stone = "awuuwa_biomes_marsh:foundationrock",
	y_max = 10,
	y_min = 1,
    heat_point = 45,
    humidity_point = 45,
})]]


--[[	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:glassi",
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
    fill_ratio = 0.25,
		biomes = {"awuuwa_biomes_marsh"},
		y_max = 0,
		y_min = -100,
		flags = "force_placement",
		schematic = modpath .. "/schematics/glasspillar.mts",
	})

	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:glass2",
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
    fill_ratio = 0.25,
		biomes = {"awuuwa_biomes_marsh"},
		y_max = -5,
		y_min = -100,
		flags = "force_placement",
		schematic = modpath .. "/schematics/glass2.mts",
	})]]



for i = 1, 13 do
	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:thing" .. i,
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
    fill_ratio = 0.5,--.3
		biomes = {"marsh"},
		y_max = -i + 2,
		y_min = -i + 2,
		flags = "force_placement",
		schematic = modpath .. "/schematics/pillars/dirtwithgrass" .. i .. ".mts",
	})
end
for i = 2, 14 do
	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:thing2" .. i,
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
    fill_ratio = 0.5,--.25
		biomes = {"marsh"},
		y_max = -i + 2,
		y_min = -i + 2,
		flags = "force_placement",
		schematic = modpath .. "/schematics/pillars/dirtwithtallgrass" .. i .. ".mts",
	})
end

for i = 2, 14 do
	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:thing3" .. i,
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
    fill_ratio = 0.09,
		biomes = {"marsh"},
		y_max = -i + 2,
		y_min = -i + 2,
		flags = "force_placement",
		schematic = modpath .. "/schematics/pillars/dirtwithjunglegrass" .. i .. ".mts",
	})
end

minetest.register_decoration({
	name = "awuuwa_biomes_marsh:waterlily",
    deco_type = "simple",
    place_on = {"default:water_source"},
    sidelen = 16,
    fill_ratio = 0.25,
	y_max = 1,
	y_min = -1,
	flags = "force_placement",
    biomes = {"marsh"},
    decoration = "flowers:waterlily_waving",
})

--[[minetest.register_decoration({
    deco_type = "simple",
    place_on = {"default:water_source"},
    sidelen = 16,
    fill_ratio = 0.25,
	y_max = 1,
	y_min = -1,
    biomes = {"awuuwa_biomes_marsh"},
    decoration = "default:dirt",
})


minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt", "default:water_source"},
	sidelen = 16,
	fill_ratio = 0.15,
	y_max = 1,
	y_min = -1,
	biomes = {"awuuwa_biomes_marsh"},
	decoration = {
		"default:junglegrass", "default:fern_2", "default:fern_3",
	}
})]]

--[[
	minetest.register_decoration({
		name = "awuuwa_biomes_marsh:waterlily2",
		deco_type = "simple",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.12,
			scale = 0.3,
			spread = {x = 200, y = 200, z = 200},
			seed = 33,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"awuuwa_biomes_marsh"},
		y_max = 0,
		y_min = 0,
		decoration = "flowers:waterlily_waving",
		param2 = 0,
		param2_max = 3,
		place_offset_y = 1,
	})


minetest.register_decoration({
	name = "awuuwa_biomes_marsh:fern",
	deco_type = "simple",
	place_on = {"default:dirt", "default:dirt_with_grass", "water_source"},
	sidelen = 16,
	fill_ratio = 1.0,
	y_max = 1,
	y_min = 0,
	place_offset_y = 1,
	biomes = {"awuuwa_biomes_marsh"},
	flags = "force_placement",
	decoration = {
		"default:fern_1", "default:fern_2", "default:fern_3",
	}
})]]
