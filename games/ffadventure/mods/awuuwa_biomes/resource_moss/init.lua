--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local S = minetest.get_translator(MODNAME)

minetest.register_node("awuuwa_biomes_resource_moss:stone_with_moss", {
	description = S("Stone with Moss"),
	tiles = {"default_moss.png", "default_stone.png",
		{name = "default_stone.png^default_moss_side.png",
			tileable_vertical = false}},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})

minetest.register_node("awuuwa_biomes_resource_moss:dirt_with_moss", {
	description = S("Dirt with Moss"),
	tiles = {"default_moss.png", "default_dirt.png",
		{name = "default_dirt.png^default_moss_side.png",
			tileable_vertical = false}},
	groups = {cracky = 3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})
