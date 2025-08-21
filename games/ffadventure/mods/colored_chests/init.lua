local S = minetest.get_translator("colored_chests")
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
colored_chests = {}
dofile(modpath .."/api.lua")

colored_chests.chest.register_chest("colored_chests:white_chest", {
	description = S("White") .." ".. S("Chest"),
	tiles = {
		"colored_chests_white_top.png",
		"colored_chests_white_top.png",
		"colored_chests_white_side.png",
		"colored_chests_white_side.png",
		"colored_chests_white_front.png",
		"colored_chests_white_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_white_chest", {
	description = S("Locked") .." ".. S("White") .." ".. S("Chest"),
	tiles = {
		"colored_chests_white_top.png",
		"colored_chests_white_top.png",
		"colored_chests_white_side.png",
		"colored_chests_white_side.png",
		"colored_chests_white_lock.png",
		"colored_chests_white_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_white_chest",
	recipe = {"colored_chests:white_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:red_chest", {
	description = S("Red") .." ".. S("Chest"),
	tiles = {
		"colored_chests_red_top.png",
		"colored_chests_red_top.png",
		"colored_chests_red_side.png",
		"colored_chests_red_side.png",
		"colored_chests_red_front.png",
		"colored_chests_red_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_red_chest", {
	description = S("Locked") .." ".. S("Red") .." ".. S("Chest"),
	tiles = {
		"colored_chests_red_top.png",
		"colored_chests_red_top.png",
		"colored_chests_red_side.png",
		"colored_chests_red_side.png",
		"colored_chests_red_lock.png",
		"colored_chests_red_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_red_chest",
	recipe = {"colored_chests:red_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:darkred_chest", {
	description = S("Dark red") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkred_top.png",
		"colored_chests_darkred_top.png",
		"colored_chests_darkred_side.png",
		"colored_chests_darkred_side.png",
		"colored_chests_darkred_front.png",
		"colored_chests_darkred_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_darkred_chest", {
	description = S("Locked") .." ".. S("Dark red") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkred_top.png",
		"colored_chests_darkred_top.png",
		"colored_chests_darkred_side.png",
		"colored_chests_darkred_side.png",
		"colored_chests_darkred_lock.png",
		"colored_chests_darkred_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_darkred_chest",
	recipe = {"colored_chests:darkred_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:orange_chest", {
	description = S("Orange") .." ".. S("Chest"),
	tiles = {
		"colored_chests_orange_top.png",
		"colored_chests_orange_top.png",
		"colored_chests_orange_side.png",
		"colored_chests_orange_side.png",
		"colored_chests_orange_front.png",
		"colored_chests_orange_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_orange_chest", {
	description = S("Locked") .." ".. S("Orange") .." ".. S("Chest"),
	tiles = {
		"colored_chests_orange_top.png",
		"colored_chests_orange_top.png",
		"colored_chests_orange_side.png",
		"colored_chests_orange_side.png",
		"colored_chests_orange_lock.png",
		"colored_chests_orange_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_orange_chest",
	recipe = {"colored_chests:orange_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:yellow_chest", {
	description = S("Yellow") .." ".. S("Chest"),
	tiles = {
		"colored_chests_yellow_top.png",
		"colored_chests_yellow_top.png",
		"colored_chests_yellow_side.png",
		"colored_chests_yellow_side.png",
		"colored_chests_yellow_front.png",
		"colored_chests_yellow_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_yellow_chest", {
	description = S("Locked") .." ".. S("Yellow") .." ".. S("Chest"),
	tiles = {
		"colored_chests_yellow_top.png",
		"colored_chests_yellow_top.png",
		"colored_chests_yellow_side.png",
		"colored_chests_yellow_side.png",
		"colored_chests_yellow_lock.png",
		"colored_chests_yellow_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_yellow_chest",
	recipe = {"colored_chests:yellow_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:green_chest", {
	description = S("Green") .." ".. S("Chest"),
	tiles = {
		"colored_chests_green_top.png",
		"colored_chests_green_top.png",
		"colored_chests_green_side.png",
		"colored_chests_green_side.png",
		"colored_chests_green_front.png",
		"colored_chests_green_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_green_chest", {
	description = S("Locked") .." ".. S("Green") .." ".. S("Chest"),
	tiles = {
		"colored_chests_green_top.png",
		"colored_chests_green_top.png",
		"colored_chests_green_side.png",
		"colored_chests_green_side.png",
		"colored_chests_green_lock.png",
		"colored_chests_green_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_green_chest",
	recipe = {"colored_chests:green_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:darkgreen_chest", {
	description = S("Dark green") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkgreen_top.png",
		"colored_chests_darkgreen_top.png",
		"colored_chests_darkgreen_side.png",
		"colored_chests_darkgreen_side.png",
		"colored_chests_darkgreen_front.png",
		"colored_chests_darkgreen_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_darkgreen_chest", {
	description = S("Locked") .." ".. S("Dark green") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkgreen_top.png",
		"colored_chests_darkgreen_top.png",
		"colored_chests_darkgreen_side.png",
		"colored_chests_darkgreen_side.png",
		"colored_chests_darkgreen_lock.png",
		"colored_chests_darkgreen_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_darkgreen_chest",
	recipe = {"colored_chests:darkgreen_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:cyan_chest", {
	description = S("Cyan") .." ".. S("Chest"),
	tiles = {
		"colored_chests_cyan_top.png",
		"colored_chests_cyan_top.png",
		"colored_chests_cyan_side.png",
		"colored_chests_cyan_side.png",
		"colored_chests_cyan_front.png",
		"colored_chests_cyan_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_cyan_chest", {
	description = S("Locked") .." ".. S("Cyan") .." ".. S("Chest"),
	tiles = {
		"colored_chests_cyan_top.png",
		"colored_chests_cyan_top.png",
		"colored_chests_cyan_side.png",
		"colored_chests_cyan_side.png",
		"colored_chests_cyan_lock.png",
		"colored_chests_cyan_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_cyan_chest",
	recipe = {"colored_chests:cyan_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:blue_chest", {
	description = S("Blue") .." ".. S("Chest"),
	tiles = {
		"colored_chests_blue_top.png",
		"colored_chests_blue_top.png",
		"colored_chests_blue_side.png",
		"colored_chests_blue_side.png",
		"colored_chests_blue_front.png",
		"colored_chests_blue_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_blue_chest", {
	description = S("Locked") .." ".. S("Blue") .." ".. S("Chest"),
	tiles = {
		"colored_chests_blue_top.png",
		"colored_chests_blue_top.png",
		"colored_chests_blue_side.png",
		"colored_chests_blue_side.png",
		"colored_chests_blue_lock.png",
		"colored_chests_blue_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_blue_chest",
	recipe = {"colored_chests:blue_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:darkblue_chest", {
	description = S("Dark blue") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkblue_top.png",
		"colored_chests_darkblue_top.png",
		"colored_chests_darkblue_side.png",
		"colored_chests_darkblue_side.png",
		"colored_chests_darkblue_front.png",
		"colored_chests_darkblue_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_darkblue_chest", {
	description = S("Locked") .." ".. S("Dark blue") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkblue_top.png",
		"colored_chests_darkblue_top.png",
		"colored_chests_darkblue_side.png",
		"colored_chests_darkblue_side.png",
		"colored_chests_darkblue_lock.png",
		"colored_chests_darkblue_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_darkblue_chest",
	recipe = {"colored_chests:darkblue_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:violet_chest", {
	description = S("Violet") .." ".. S("Chest"),
	tiles = {
		"colored_chests_violet_top.png",
		"colored_chests_violet_top.png",
		"colored_chests_violet_side.png",
		"colored_chests_violet_side.png",
		"colored_chests_violet_front.png",
		"colored_chests_violet_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_violet_chest", {
	description = S("Locked") .." ".. S("Violet") .." ".. S("Chest"),
	tiles = {
		"colored_chests_violet_top.png",
		"colored_chests_violet_top.png",
		"colored_chests_violet_side.png",
		"colored_chests_violet_side.png",
		"colored_chests_violet_lock.png",
		"colored_chests_violet_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_violet_chest",
	recipe = {"colored_chests:violet_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:pink_chest", {
	description = S("Pink") .." ".. S("Chest"),
	tiles = {
		"colored_chests_pink_top.png",
		"colored_chests_pink_top.png",
		"colored_chests_pink_side.png",
		"colored_chests_pink_side.png",
		"colored_chests_pink_front.png",
		"colored_chests_pink_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_pink_chest", {
	description = S("Locked") .." ".. S("Pink") .." ".. S("Chest"),
	tiles = {
		"colored_chests_pink_top.png",
		"colored_chests_pink_top.png",
		"colored_chests_pink_side.png",
		"colored_chests_pink_side.png",
		"colored_chests_pink_lock.png",
		"colored_chests_pink_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_pink_chest",
	recipe = {"colored_chests:pink_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:magenta_chest", {
	description = S("Magenta") .." ".. S("Chest"),
	tiles = {
		"colored_chests_magenta_top.png",
		"colored_chests_magenta_top.png",
		"colored_chests_magenta_side.png",
		"colored_chests_magenta_side.png",
		"colored_chests_magenta_front.png",
		"colored_chests_magenta_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_magenta_chest", {
	description = S("Locked") .." ".. S("Magenta") .." ".. S("Chest"),
	tiles = {
		"colored_chests_magenta_top.png",
		"colored_chests_magenta_top.png",
		"colored_chests_magenta_side.png",
		"colored_chests_magenta_side.png",
		"colored_chests_magenta_lock.png",
		"colored_chests_magenta_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_magenta_chest",
	recipe = {"colored_chests:magenta_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:black_chest", {
	description = S("Black") .." ".. S("Chest"),
	tiles = {
		"colored_chests_black_top.png",
		"colored_chests_black_top.png",
		"colored_chests_black_side.png",
		"colored_chests_black_side.png",
		"colored_chests_black_front.png",
		"colored_chests_black_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_black_chest", {
	description = S("Locked") .." ".. S("Black") .." ".. S("Chest"),
	tiles = {
		"colored_chests_black_top.png",
		"colored_chests_black_top.png",
		"colored_chests_black_side.png",
		"colored_chests_black_side.png",
		"colored_chests_black_lock.png",
		"colored_chests_black_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_black_chest",
	recipe = {"colored_chests:black_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:darkgrey_chest", {
	description = S("Dark grey") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkgrey_top.png",
		"colored_chests_darkgrey_top.png",
		"colored_chests_darkgrey_side.png",
		"colored_chests_darkgrey_side.png",
		"colored_chests_darkgrey_front.png",
		"colored_chests_darkgrey_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_darkgrey_chest", {
	description = S("Locked") .." ".. S("Dark grey") .." ".. S("Chest"),
	tiles = {
		"colored_chests_darkgrey_top.png",
		"colored_chests_darkgrey_top.png",
		"colored_chests_darkgrey_side.png",
		"colored_chests_darkgrey_side.png",
		"colored_chests_darkgrey_lock.png",
		"colored_chests_darkgrey_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_darkgrey_chest",
	recipe = {"colored_chests:darkgrey_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:grey_chest", {
	description = S("Grey") .." ".. S("Chest"),
	tiles = {
		"colored_chests_grey_top.png",
		"colored_chests_grey_top.png",
		"colored_chests_grey_side.png",
		"colored_chests_grey_side.png",
		"colored_chests_grey_front.png",
		"colored_chests_grey_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_grey_chest", {
	description = S("Locked") .." ".. S("Grey") .." ".. S("Chest"),
	tiles = {
		"colored_chests_grey_top.png",
		"colored_chests_grey_top.png",
		"colored_chests_grey_side.png",
		"colored_chests_grey_side.png",
		"colored_chests_grey_lock.png",
		"colored_chests_grey_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_grey_chest",
	recipe = {"colored_chests:grey_chest", "default:steel_ingot"},
})
colored_chests.chest.register_chest("colored_chests:brown_chest", {
	description = S("Brown") .." ".. S("Chest"),
	tiles = {
		"colored_chests_brown_top.png",
		"colored_chests_brown_top.png",
		"colored_chests_brown_side.png",
		"colored_chests_brown_side.png",
		"colored_chests_brown_front.png",
		"colored_chests_brown_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
})
colored_chests.chest.register_chest("colored_chests:locked_brown_chest", {
	description = S("Locked") .." ".. S("Brown") .." ".. S("Chest"),
	tiles = {
		"colored_chests_brown_top.png",
		"colored_chests_brown_top.png",
		"colored_chests_brown_side.png",
		"colored_chests_brown_side.png",
		"colored_chests_brown_lock.png",
		"colored_chests_brown_inside.png"
	},
	sounds = default.node_sound_wood_defaults(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
    protected = true,
})
minetest.register_craft( {
	type = "shapeless",
	output = "colored_chests:locked_brown_chest",
	recipe = {"colored_chests:brown_chest", "default:steel_ingot"},
})
minetest.register_craft({
	output = "colored_chests:white_chest",
	recipe = {
		{"dye:white", "dye:white", "dye:white"},
		{"dye:white", "default:chest", "dye:white"},
		{"dye:white", "dye:white", "dye:white"},
	}
})
minetest.register_craft({
	output = "colored_chests:red_chest",
	recipe = {
		{"dye:red", "dye:red", "dye:red"},
		{"dye:red", "default:chest", "dye:red"},
		{"dye:red", "dye:red", "dye:red"},
	}
})
minetest.register_craft({
	output = "colored_chests:darkred_chest",
	recipe = {
		{"dye:red", "dye:red", "dye:red"},
		{"dye:red", "colored_chests:red_chest", "dye:red"},
		{"dye:red", "dye:red", "dye:red"},
	}
})
minetest.register_craft({
	output = "colored_chests:orange_chest",
	recipe = {
		{"dye:orange", "dye:orange", "dye:orange"},
		{"dye:orange", "default:chest", "dye:orange"},
		{"dye:orange", "dye:orange", "dye:orange"},
	}
})
minetest.register_craft({
	output = "colored_chests:yellow_chest",
	recipe = {
		{"dye:yellow", "dye:yellow", "dye:yellow"},
		{"dye:yellow", "default:chest", "dye:yellow"},
		{"dye:yellow", "dye:yellow", "dye:yellow"},
	}
})
minetest.register_craft({
	output = "colored_chests:green_chest",
	recipe = {
		{"dye:green", "dye:green", "dye:green"},
		{"dye:green", "default:chest", "dye:green"},
		{"dye:green", "dye:green", "dye:green"},
	}
})
minetest.register_craft({
	output = "colored_chests:darkgreen_chest",
	recipe = {
		{"dye:dark_green", "dye:dark_green", "dye:dark_green"},
		{"dye:dark_green", "default:chest", "dye:dark_green"},
		{"dye:dark_green", "dye:dark_green", "dye:dark_green"},
	}
})
minetest.register_craft({
	output = "colored_chests:cyan_chest",
	recipe = {
		{"dye:cyan", "dye:cyan", "dye:cyan"},
		{"dye:cyan", "default:chest", "dye:cyan"},
		{"dye:cyan", "dye:cyan", "dye:cyan"},
	}
})
minetest.register_craft({
	output = "colored_chests:blue_chest",
	recipe = {
		{"dye:blue", "dye:blue", "dye:blue"},
		{"dye:blue", "default:chest", "dye:blue"},
		{"dye:blue", "dye:blue", "dye:blue"},
	}
})
minetest.register_craft({
	output = "colored_chests:darkblue_chest",
	recipe = {
		{"dye:blue", "dye:blue", "dye:blue"},
		{"dye:blue", "colored_chests:blue_chest", "dye:blue"},
		{"dye:blue", "dye:blue", "dye:blue"},
	}
})
minetest.register_craft({
	output = "colored_chests:violet_chest",
	recipe = {
		{"dye:violet", "dye:violet", "dye:violet"},
		{"dye:violet", "default:chest", "dye:violet"},
		{"dye:violet", "dye:violet", "dye:violet"},
	}
})
minetest.register_craft({
	output = "colored_chests:magenta_chest",
	recipe = {
		{"dye:magenta", "dye:magenta", "dye:magenta"},
		{"dye:magenta", "default:chest", "dye:magenta"},
		{"dye:magenta", "dye:magenta", "dye:magenta"},
	}
})
minetest.register_craft({
	output = "colored_chests:pink_chest",
	recipe = {
		{"dye:pink", "dye:pink", "dye:pink"},
		{"dye:pink", "default:chest", "dye:pink"},
		{"dye:pink", "dye:pink", "dye:pink"},
	}
})
minetest.register_craft({
	output = "colored_chests:grey_chest",
	recipe = {
		{"dye:grey", "dye:grey", "dye:grey"},
		{"dye:grey", "default:chest", "dye:grey"},
		{"dye:grey", "dye:grey", "dye:grey"},
	}
})
minetest.register_craft({
	output = "colored_chests:darkgrey_chest",
	recipe = {
		{"dye:darkgrey", "dye:darkgrey", "dye:darkgrey"},
		{"dye:darkgrey", "default:chest", "dye:darkgrey"},
		{"dye:darkgrey", "dye:darkgrey", "dye:darkgrey"},
	}
})
minetest.register_craft({
	output = "colored_chests:black_chest",
	recipe = {
		{"dye:black", "dye:black", "dye:black"},
		{"dye:black", "default:chest", "dye:black"},
		{"dye:black", "dye:black", "dye:black"},
	}
})
minetest.register_craft({
	output = "colored_chests:brown_chest",
	recipe = {
		{"dye:brown", "dye:brown", "dye:brown"},
		{"dye:brown", "default:chest", "dye:brown"},
		{"dye:brown", "dye:brown", "dye:brown"},
	}
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:red_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_red_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:darkred_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_darkred_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:orange_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_orange_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:yellow_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_yellow_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:green_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_green_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:darkgreen_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_darkgreen_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:cyan_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_cyan_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:blue_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_blue_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:darkblue_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_darkblue_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:violet_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_violet_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:magenta_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_magenta_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:pink_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_pink_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:grey_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_grey_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:darkgrey_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_darkgrey_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:black_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_black_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:brown_chest",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "colored_chests:locked_brown_chest",
	burntime = 30,
})
