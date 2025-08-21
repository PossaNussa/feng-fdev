-- banishers/init.lua
-- Adds straight and diagonal banisters for stairs railings.
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

banisters = {
	version = "1.0",
}
banisters.intllib = minetest.get_translator and minetest.get_translator("banisters")

local path = minetest.get_modpath("banisters")
dofile(minetest.get_modpath("banisters") .. "/nodes.lua")
dofile(minetest.get_modpath("banisters") .. "/register.lua")
