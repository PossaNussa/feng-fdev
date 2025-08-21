-- IndustrialTest
-- Copyright (C) 2023 mrkubax10

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

if industrialtest.mtgAvailable then
	industrialtest.registerMetal("uranium","Uranium",3)
	minetest.register_ore({
		ore_type="scatter",
		ore="industrialtest:stone_with_uranium",
		wherein="default:stone",
		clust_scarcity=7*7*7,
		clust_num_ores=3,
		clust_size=3,
		y_max=-128,
		y_min=-31000
	})
elseif industrialtest.mclAvailable then
	industrialtest.registerMetal("uranium","Uranium",4,4,4,4,5,5)
	local stonelike={"mcl_core:stone","mcl_core:diorite","mcl_core:andesite","mcl_core:granite"}
	minetest.register_ore({
		ore_type="scatter",
		ore="industrialtest:stone_with_uranium",
		wherein=stonelike,
		clust_scarcity=7*7*7,
		clust_num_ores=3,
		clust_size=3,
		y_max=mcl_worlds.layer_to_y(20),
		y_min=mcl_vars.mg_overworld_min
	})
	minetest.register_ore({
		ore_type="scatter",
		ore="industrialtest:deepslate_with_uranium",
		wherein={"mcl_deepslate:deepslate","mcl_deepslate:tuff"},
		clust_scarcity=7*7*7,
		clust_num_ores=3,
		clust_size=3,
		y_max=mcl_worlds.layer_to_y(15),
		y_min=mcl_vars.mg_overworld_min
	})
end
