-- lrfurn/longsofas.lua
-- Long Sofas
--[[
    Living Room Furniture by thefamilygrog66 and 1F616EMO
    is marked with CC0 1.0. To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local S = minetest.get_translator("lrfurn")

local longsofas_list = {
	{ S("Red Long Sofa"),    "red" },
	{ S("Orange Long Sofa"), "orange" },
	{ S("Yellow Long Sofa"), "yellow" },
	{ S("Green Long Sofa"),  "green" },
	{ S("Blue Long Sofa"),   "blue" },
	{ S("Violet Long Sofa"), "violet" },
	{ S("Black Long Sofa"),  "black" },
	{ S("Grey Long Sofa"),   "grey" },
	{ S("White Long Sofa"),  "white" },
}

for i in ipairs(longsofas_list) do
	local longsofadesc = longsofas_list[i][1]
	local colour = longsofas_list[i][2]

	minetest.register_node("lrfurn:longsofa_right_" .. colour, {
		description = longsofadesc,
		drawtype = "nodebox",
		tiles = {
			"lrfurn_sofa_right_top_" .. colour .. ".png",
			"lrfurn_coffeetable_back.png",
			"lrfurn_sofa_right_front_" .. colour .. ".png",
			"lrfurn_sofa_back_" .. colour .. ".png",
			"lrfurn_sofa_left_side_" .. colour .. ".png",
			"lrfurn_sofa_right_side_" .. colour .. ".png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		stack_max = 1,
		groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
				--legs
				{ -0.4375, -0.5,   -0.4375, -0.375,  -0.375, -0.375 },
				{ 0.375,   -0.5,   -0.4375, 0.4375,  -0.375, -0.375 },

				--base/cushion
				{ -0.5,    -0.375, -0.5,    0.5,     0,      0.5 },

				--back
				{ -0.5,    0,      -0.5,    -0.3125, 0.5,    0.5 },

				--arm
				{ -0.3125, 0,      -0.5,    0.5,     0.25,   -0.3125 },
			}
		},
		use_texture_alpha = "opaque",

		on_construct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local pos2 = vector.add(pos, direction)
			local pos3 = vector.add(pos2, direction)

			if minetest.get_node(pos2).name == "air" then
				minetest.set_node(pos2, {
					name = "lrfurn:longsofa_middle_" .. colour,
					param2 = node.param2
				})

				if minetest.get_node(pos3).name == "air" then
					minetest.set_node(pos3, {
						name = "lrfurn:longsofa_left_" .. colour,
						param2 = node.param2
					})
				end
			end
		end,
		on_destruct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local pos2 = vector.add(pos, direction)
			local pos3 = vector.add(pos2, direction)

			if minetest.get_node(pos2).name == "lrfurn:longsofa_middle_" .. colour then
				minetest.swap_node(pos2, { name = "air" })
				minetest.check_for_falling(pos2)
			end

			if minetest.get_node(pos3).name == "lrfurn:longsofa_left_" .. colour then
				minetest.swap_node(pos3, { name = "air" })
				minetest.check_for_falling(pos3)
			end
		end,
		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_node("lrfurn:longsofa_middle_" .. colour, {
		drawtype = "nodebox",
		tiles = {
			"lrfurn_longsofa_middle_top_" .. colour .. ".png",
			"lrfurn_coffeetable_back.png",
			"lrfurn_longsofa_middle_front_" .. colour .. ".png",
			"lrfurn_sofa_back_" .. colour .. ".png",
			"lrfurn_sofa_left_side_" .. colour .. ".png",
			"lrfurn_sofa_right_side_" .. colour .. ".png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
				--legs
				{ -0.4375, -0.5,   -0.03125, -0.375,  -0.375, 0.03125 },
				{ 0.375,   -0.5,   -0.03125, 0.4375,  -0.375, 0.03125 },

				--base/cushion
				{ -0.5,    -0.375, -0.5,     0.5,     0,      0.5 },

				--back
				{ -0.5,    0,      -0.5,     -0.3125, 0.5,    0.5 },
			}
		},
		use_texture_alpha = "opaque",

		drop = "lrfurn:longsofa_right_" .. colour,
		on_destruct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local root_pos = vector.subtract(pos, direction)

			minetest.swap_node(pos, { name = "air" })

			if minetest.get_node(root_pos).name == "lrfurn:longsofa_right_" .. colour then
				minetest.remove_node(root_pos)
				minetest.check_for_falling(root_pos)
			end
		end,
		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_node("lrfurn:longsofa_left_" .. colour, {
		drawtype = "nodebox",
		tiles = {
			"lrfurn_sofa_left_top_" .. colour .. ".png",
			"lrfurn_coffeetable_back.png",
			"lrfurn_sofa_left_front_" .. colour .. ".png",
			"lrfurn_sofa_back_" .. colour .. ".png",
			"lrfurn_sofa_left_side_" .. colour .. ".png",
			"lrfurn_sofa_right_side_" .. colour .. ".png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = { snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3 },
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = {
				--legs
				{ -0.4375, -0.5,   0.375,  -0.375,  -0.375, 0.4375 },
				{ 0.375,   -0.5,   0.375,  0.4375,  -0.375, 0.4375 },

				--base/cushion
				{ -0.5,    -0.375, -0.5,   0.5,     0,      0.5 },

				--back
				{ -0.5,    0,      -0.5,   -0.3125, 0.5,    0.5 },

				--arm
				{ -0.3125, 0,      0.3125, 0.5,     0.25,   0.5 },
			}
		},
		use_texture_alpha = "opaque",

		drop = "lrfurn:longsofa_right_" .. colour,
		on_destruct = function(pos)
			local node = minetest.get_node(pos)
			local direction = vector.multiply(minetest.facedir_to_dir(node.param2), 2)
			local root_pos = vector.subtract(pos, direction)

			minetest.swap_node(pos, { name = "air" })

			if minetest.get_node(root_pos).name == "lrfurn:longsofa_right_" .. colour then
				minetest.remove_node(root_pos)
				minetest.check_for_falling(root_pos)
			end
		end,
		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_alias("lrfurn:longsofa_" .. colour, "lrfurn:longsofa_right_" .. colour)

	minetest.register_craft({
		output = "lrfurn:longsofa_" .. colour,
		recipe = {
			{ "wool:" .. colour,  "wool:" .. colour,  "wool:" .. colour, },
			{ "stairs:slab_wood", "stairs:slab_wood", "stairs:slab_wood", },
			{ "default:stick",    "default:stick",    "default:stick", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:longsofa_" .. colour,
		recipe = {
			{ "wool:" .. colour,      "wool:" .. colour,      "wool:" .. colour, },
			{ "moreblocks:slab_wood", "moreblocks:slab_wood", "moreblocks:slab_wood", },
			{ "default:stick",        "default:stick",        "default:stick", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:longsofa_" .. colour,
		recipe = {
			{ "wool:" .. colour, "wool:" .. colour, "wool:" .. colour, },
			{ "group:wood_slab", "group:wood_slab", "group:wood_slab", },
			{ "default:stick",   "default:stick",   "default:stick", }
		}
	})
end

if minetest.settings:get("log_mods") then
	minetest.log("action", "long sofas loaded")
end
