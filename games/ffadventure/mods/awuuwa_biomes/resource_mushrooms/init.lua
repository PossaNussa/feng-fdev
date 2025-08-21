--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local S = minetest.get_translator(MODNAME)

minetest.register_node("awuuwa_biomes_resource_mushrooms:brown_mushroom", {
	description = S("brown mushroom block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"awuuwa_biomes_brown_mushroom.png"},
	is_ground_content = false,
	groups = {crumbly = 3}
})

minetest.register_node("awuuwa_biomes_resource_mushrooms:red_mushroom", {
	description = S("red mushroom block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"awuuwa_biomes_red_mushroom.png"},
	is_ground_content = false,
	groups = {crumbly = 3}
})

minetest.register_node("awuuwa_biomes_resource_mushrooms:mushroom_stem", {
	description = S("mushroom stem block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"awuuwa_biomes_mushroom_stem.png"},
	is_ground_content = false,
	groups = {crumbly = 3}
})

