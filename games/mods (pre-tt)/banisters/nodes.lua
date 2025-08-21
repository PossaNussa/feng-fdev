-- banishers/nodes.lua
-- Node registeration functiosn
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

local S = banisters.intllib

-- Chooses banister side according to yaw direction.
-- (Code snippet taken from display_modpack by pyrollo).
function banisters.on_place_side(itemstack, placer, pointed_thing)
	local name = itemstack:get_name()
	local ndef = minetest.registered_nodes[name]

	local bdir = {
		x = pointed_thing.under.x - pointed_thing.above.x,
		y = pointed_thing.under.y - pointed_thing.above.y,
		z = pointed_thing.under.z - pointed_thing.above.z
	}
	local pdir = placer:get_look_dir()

	local ndir, test

	if ndef.paramtype2 == "facedir" then
		if bdir.x == 0 and bdir.z == 0 then
			-- Ceiling or floor pointed (facedir chosen from player dir)
			ndir = minetest.dir_to_facedir({ x = pdir.x, y = 0, z = pdir.z })
			return minetest.item_place(itemstack, placer, pointed_thing, ndir)
		else
			-- Wall pointed
			ndir = minetest.dir_to_facedir(bdir)
		end

		test = { [0] = -pdir.x, pdir.z, pdir.x, -pdir.z }
	end

	-- Horizontal banisters will become diagonal if they're placed diagonally.
	if name:sub(-4) == "ntal" then
		if test[ndir] > 0.5 then
			itemstack:set_name(name:sub(1, -11) .. "diagonal_left")
		elseif test[ndir] < -0.5 then
			itemstack:set_name(name:sub(1, -11) .. "diagonal_right")
		end
		itemstack = minetest.item_place(itemstack, placer, pointed_thing, ndir)
		itemstack:set_name(name)

		return itemstack
	else
		return minetest.item_place(itemstack, placer, pointed_thing, ndir)
	end
end

-- Node register function
function banisters.register(tech_name, texture, orig_node)
	local types = {
		"_horizontal",
		"_diagonal_left",
		"_diagonal_right"
	}

	local styles = {
		"basic",
		"fancy"
	}

	for i, s in pairs(styles) do
		for j, t in pairs(types) do
			local itemstring = string.format("banisters:%s_%s%s", tech_name, s, t)

			-- nodeboxes taken from VanessaE's homedecor
			local cbox = {
				type = "fixed",
				fixed = { -9 / 16, -3 / 16, 5 / 16, 9 / 16, 24 / 16, 8 / 16 }
			}

			local g = { snappy = 3, not_in_creative_inventory = 1 }
			local name = minetest.registered_nodes[orig_node].description or tech_name
			local desc = nil

			if t == "_horizontal" then
				cbox.fixed = { -8 / 16, -8 / 16, 5 / 16, 8 / 16, 8 / 16, 8 / 16 }
				g = { snappy = 3 }

				if s == "basic" then
					desc = S("Basic @1 banister", name)
					minetest.register_craft({
						output = string.format("banisters:%s_basic_horizontal 3", tech_name),
						recipe = {
							{ orig_node,     orig_node, orig_node },
							{ 'group:stick', '',        'group:stick' }
						}
					})
				elseif s == "fancy" then
					desc = S("Fancy @1 banister", name)
					minetest.register_craft({
						output = string.format("banisters:%s_fancy_horizontal 3", tech_name),
						recipe = {
							{ orig_node,     orig_node,     orig_node },
							{ 'group:stick', 'group:stick', 'group:stick' }
						}
					})
				end
			end


			minetest.register_node(itemstring, {
				description = desc,
				drawtype = "mesh",
				selection_box = cbox,
				collision_box = cbox,
				paramtype = "light",
				paramtype2 = "facedir",
				on_place = banisters.on_place_side,
				groups = g,
				drawtype = "mesh",
				mesh = s .. t .. ".obj",
				tiles = minetest.registered_nodes[orig_node].tiles,
				drop = string.format("banisters:%s_%s_horizontal", tech_name, s)
			})
		end
	end
end
