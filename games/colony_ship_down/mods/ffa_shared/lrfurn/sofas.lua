-- lrfurn/sofas.lua
-- Sofas
--[[
    Living Room Furniture by thefamilygrog66 and 1F616EMO
    is marked with CC0 1.0. To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local S = minetest.get_translator("lrfurn")

local sofas_list = {
	{ S("Red Sofa"),    "red" },
	{ S("Orange Sofa"), "orange" },
	{ S("Yellow Sofa"), "yellow" },
	{ S("Green Sofa"),  "green" },
	{ S("Blue Sofa"),   "blue" },
	{ S("Violet Sofa"), "violet" },
	{ S("Black Sofa"),  "black" },
	{ S("Grey Sofa"),   "grey" },
	{ S("White Sofa"),  "white" },
}

for i in ipairs(sofas_list) do
	local sofadesc = sofas_list[i][1]
	local colour = sofas_list[i][2]

	minetest.register_node("lrfurn:sofa_right_" .. colour, {
		description = sofadesc,
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

		drop = "lrfurn:sofa_right_" .. colour,
		on_construct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local pos2 = vector.add(pos, direction)

			if minetest.get_node(pos2).name == "air" then
				minetest.set_node(pos2, {
					name = "lrfurn:sofa_left_" .. colour,
					param2 = node.param2
				})
			end
		end,
		on_destruct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local pos2 = vector.add(pos, direction)

			if minetest.get_node(pos2).name == "lrfurn:sofa_left_" .. colour then
				minetest.remove_node(pos2)
				minetest.check_for_falling(pos2)
			end
		end,
		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_node("lrfurn:sofa_left_" .. colour, {
		drawtype = "nodebox",
		tiles = { "lrfurn_sofa_left_top_" .. colour .. ".png", "lrfurn_coffeetable_back.png", "lrfurn_sofa_left_front_" .. colour .. ".png", "lrfurn_sofa_back_" .. colour .. ".png", "lrfurn_sofa_left_side_" .. colour .. ".png", "lrfurn_sofa_right_side_" .. colour .. ".png" },
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

		drop = "lrfurn:sofa_right_" .. colour,
		on_destruct = function(pos)
			local node = minetest.get_node(pos)
			local direction = minetest.facedir_to_dir(node.param2)
			local root_pos = vector.subtract(pos, direction)

			minetest.swap_node(pos, { name = "air" })

			if minetest.get_node(root_pos).name == "lrfurn:sofa_right_" .. colour then
				minetest.remove_node(root_pos)
				minetest.check_for_falling(root_pos)
			end
		end,
		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_alias("lrfurn:sofa_" .. colour, "lrfurn:sofa_right_" .. colour)

	minetest.register_craft({
		output = "lrfurn:sofa_" .. colour,
		recipe = {
			{ "wool:" .. colour,  "wool:" .. colour,  "", },
			{ "stairs:slab_wood", "stairs:slab_wood", "", },
			{ "default:stick",    "default:stick",    "", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:sofa_" .. colour,
		recipe = {
			{ "wool:" .. colour,      "wool:" .. colour,      "", },
			{ "moreblocks:slab_wood", "moreblocks:slab_wood", "", },
			{ "default:stick",        "default:stick",        "", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:sofa_" .. colour,
		recipe = {
			{ "wool:" .. colour, "wool:" .. colour, "", },
			{ "group:wood_slab", "group:wood_slab", "", },
			{ "default:stick",   "default:stick",   "", }
		}
	})
end

if minetest.settings:get("log_mods") then
	minetest.log("action", "sofas loaded")
end
