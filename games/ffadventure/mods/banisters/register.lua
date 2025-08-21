-- banishers/register.lua
-- Do the actual registerations
--[[
	Banishers: Adds straight and diagonal banisters for stairs railings.
    Copyright (C) 2022  Álex Romeo Echo <re5@disroot.org>
	Copyright (C) 2024  1F616EMO <root@1f616emo.xyz>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

if minetest.get_modpath("default") then
	banisters.register("wood", "default_wood.png", "default:wood")
	banisters.register("acacia", "default_acacia_wood.png", "default:acacia_wood")
	banisters.register("aspen", "default_aspen_wood.png", "default:aspen_wood")
	banisters.register("junglewood", "default_junglewood.png", "default:junglewood")
	banisters.register("pine", "default_pine_wood.png", "default:pine_wood")
	banisters.register("stone", "default_stone.png", "default:stone")
	banisters.register("desertstone", "default_desert_stone.png", "default:desert_stone")
	banisters.register("sandstone", "default_sandstone.png", "default:sandstone")
	banisters.register("desert_sandstone", "default_desert_sandstone.png", "default:desert_sandstone")
	banisters.register("silver_sandstone", "default_silver_sandstone.png", "default:silver_sandstone")
end

if minetest.get_modpath("ethereal") then
	banisters.register("bamboo", "ethereal_bamboo_floor.png", "ethereal:bamboo_block")
	banisters.register("banana", "ethereal_banana_wood.png", "ethereal:banana_wood")
	banisters.register("birch", "moretrees_birch_wood.png", "ethereal:birch_wood")
	banisters.register("frost", "ethereal_frost_wood.png", "ethereal:frost_wood")
	banisters.register("olive", "ethereal_olive_wood.png", "ethereal:olive_wood")
	banisters.register("palm", "moretrees_palm_wood.png", "ethereal:palm_wood")
	banisters.register("redwood", "ethereal_redwood_wood.png", "ethereal:redwood_wood")
	banisters.register("sakura", "ethereal_sakura_wood.png", "ethereal:sakura_wood")
	banisters.register("willow", "ethereal_willow_wood.png", "ethereal:willow_wood")
	banisters.register("yellow", "ethereal_yellow_wood.png", "ethereal:yellow_wood")
end

if minetest.get_modpath("maple") then
	banisters.register("maple", "maple_wood.png", "maple:maple_wood")
end
