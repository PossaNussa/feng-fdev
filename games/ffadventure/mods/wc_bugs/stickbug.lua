-- Stickbugs: the twig you picked up out of the leaf litter has legs.

local S = wc_bugs.S

local stickbug = "default_tree.png^[colorize:#241708:50"
local sticktop = "default_tree_top.png^[colorize:#241708:50"

------------------------------------------------------------------------
minetest.register_node("wc_bugs:stickbug", {
	description = S("Stickbug"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-1 / 16, -0.5, -1 / 16, 1 / 16, 0, 1 / 16}
	},
	selection_box = {
		type = "fixed",
		fixed = {-1 / 8, -0.5, -1 / 8, 1 / 8, 0, 1 / 8}
	},
	tiles = {sticktop, sticktop, stickbug},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		choppy = 3,
		bug = 1,
		stickbug = 1,
		crawling = 1,
		catchable = 1,
		flammable = 2,
		falling_node = 1
	},
	sounds = default.node_sound_wood_defaults()
})

------------------------------------------------------------------------
wc_bugs.register_smush("wc_bugs:stickbug", "default:stick")

minetest.register_craft({
	type = "fuel",
	recipe = "wc_bugs:stickbug",
	burntime = 5,
})

------------------------------------------------------------------------
-- Shaking out leaves turns up the occasional one, a quarter as often as an
-- ordinary stick.
wc_bugs.register_dig_spawn({"group:leaves"}, "wc_bugs:stickbug", 60)

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:stickbug", {
	chance = 30,
	comfort = {"default:stick", "group:leaves"},
	wander = 1 / 120,
})
