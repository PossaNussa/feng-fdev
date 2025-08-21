--[[
     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 
]]




local MODNAME = minetest.get_current_modname()
local MODPATH = minetest.get_modpath(MODNAME)
local S = minetest.get_translator(MODNAME)


minetest.register_abm({
	label = "awuuwa Biomes Fungi Tree Sapling Growing",
	nodenames = {"awuuwa_biomes_resource_fungi_forest:fungi_tree_sapling"},
	interval = 20,
	chance = 20,
	catch_up = false,
	action = function(pos, node)
		local path = MODPATH .. "/schematics/fungi_tree_high_1.mts"
		minetest.place_schematic(pos - vector.new(0, 2, 0), path, "0", nil, true, "place_center_x, place_center_z")
	end,
})

