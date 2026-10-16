-- Prillbugs: beetles with a shell of raw iron, found in ore seams. Squash
-- one and you get the lump back.

local S = wc_bugs.S

local lode = "default_steel_block.png^[colorize:#4a3a2a:70"
local prill = lode .. "^[mask:wc_bugs_bug_mask.png"

local crawler_box = {
	type = "fixed",
	fixed = {
		{-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875},
		{-0.125, -0.5, -0.25, 0.125, -0.4375, 0.1875},
		{-0.25, -0.5, -0.125, 0.25, -0.4375, 0.1875},
		{-0.125, -0.4375, -0.0625, 0.125, -0.375, 0.25},
	}
}

------------------------------------------------------------------------
minetest.register_node("wc_bugs:prillbug", {
	description = S("Prillbug"),
	tiles = {lode},
	drawtype = "nodebox",
	node_box = crawler_box,
	selection_box = crawler_box,
	paramtype = "light",
	paramtype2 = "facedir",
	on_place = minetest.rotate_node,
	sunlight_propagates = true,
	walkable = false,
	inventory_image = prill,
	wield_image = prill,
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		cracky = 3,
		bug = 1,
		prillbug = 1,
		crawling = 1,
		catchable = 1,
		falling_node = 1,
		metallic = 1
	},
	sounds = default.node_sound_metal_defaults()
})

------------------------------------------------------------------------
wc_bugs.register_smush("wc_bugs:prillbug", "default:iron_lump")

------------------------------------------------------------------------
-- Iron seams occasionally hand you a bug instead of a lump; it is the same
-- iron either way, once you have squashed it.
wc_bugs.register_dig_spawn({"default:stone_with_iron"}, "wc_bugs:prillbug", 16)

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:prillbug", {
	chance = 24,
	dark = true,
	comfort = {"default:iron_lump", "default:stone_with_iron"},
	wander = 1 / 90,
})
