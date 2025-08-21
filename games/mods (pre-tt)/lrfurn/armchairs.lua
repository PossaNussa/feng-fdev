-- lrfurn/armchairs.lua
-- Armchairs
--[[
    Living Room Furniture by thefamilygrog66 and 1F616EMO
    is marked with CC0 1.0. To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local S = minetest.get_translator("lrfurn")

local armchairs_list = {
	{ S("Red Armchair"),    "red" },
	{ S("Orange Armchair"), "orange" },
	{ S("Yellow Armchair"), "yellow" },
	{ S("Green Armchair"),  "green" },
	{ S("Blue Armchair"),   "blue" },
	{ S("Violet Armchair"), "violet" },
	{ S("Black Armchair"),  "black" },
	{ S("Grey Armchair"),   "grey" },
	{ S("White Armchair"),  "white" },
}

for i in ipairs(armchairs_list) do
	local armchairdesc = armchairs_list[i][1]
	local colour = armchairs_list[i][2]

	minetest.register_node("lrfurn:armchair_" .. colour, {
		description = armchairdesc,
		drawtype = "nodebox",
		tiles = { "lrfurn_armchair_top_" .. colour .. ".png", "lrfurn_coffeetable_back.png", "lrfurn_sofa_left_side_" .. colour .. ".png", "lrfurn_sofa_right_side_" .. colour .. ".png", "lrfurn_sofa_back_" .. colour .. ".png", "lrfurn_armchair_front_" .. colour .. ".png" },
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
				{ -0.4375, -0.5,   0.375,   -0.375,  -0.375, 0.4375 },
				{ 0.375,   -0.5,   0.375,   0.4375,  -0.375, 0.4375 },

				--base/cushion
				{ -0.5,    -0.375, -0.5,    0.5,     0,      0.5 },

				--back
				{ -0.5,    0,      0.3125,  0.5,     0.5,    0.5 },

				--arms
				{ -0.5,    0,      -0.5,    -0.3125, 0.25,   0.3125 },
				{ 0.3125,  0,      -0.5,    0.5,     0.25,   0.3125 },
			}
		},
		use_texture_alpha = "opaque",

		on_rightclick = lrfurn.sofa_click,
	})

	minetest.register_craft({
		output = "lrfurn:armchair_" .. colour,
		recipe = {
			{ "wool:" .. colour,  "", "", },
			{ "stairs:slab_wood", "", "", },
			{ "default:stick",    "", "", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:armchair_" .. colour,
		recipe = {
			{ "wool:" .. colour,      "", "", },
			{ "moreblocks:slab_wood", "", "", },
			{ "default:stick",        "", "", }
		}
	})

	minetest.register_craft({
		output = "lrfurn:armchair_" .. colour,
		recipe = {
			{ "wool:" .. colour, "", "", },
			{ "group:wood_slab", "", "", },
			{ "default:stick",   "", "", }
		}
	})
end

if minetest.settings:get("log_mods") then
	minetest.log("action", "armchairs loaded")
end
