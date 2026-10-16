-- Peatles: soil-coloured beetles that turn up when you dig through dirt.
-- Sitting still they are indistinguishable from a clod of earth.

local S = wc_bugs.S

local peat = "default_dirt.png^[colorize:#2b1c0a:60"
local prill = peat .. "^[mask:wc_bugs_bug_mask.png"

-- The shell of a crawling bug: a low lump with a head poking out one side.
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
minetest.register_node("wc_bugs:peatle", {
	description = S("Peatle"),
	tiles = {peat},
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
		crumbly = 3,
		bug = 1,
		peatle = 1,
		crawling = 1,
		catchable = 1,
		falling_node = 1
	},
	sounds = default.node_sound_dirt_defaults()
})

------------------------------------------------------------------------
-- A handful of them packs back down into the soil they came from.
minetest.register_craft({
	output = "default:dirt",
	recipe = {
		{"wc_bugs:peatle", "wc_bugs:peatle"},
		{"wc_bugs:peatle", "wc_bugs:peatle"},
	}
})

------------------------------------------------------------------------
-- Where they come from: hiding in dirt, turned up by the shovel.
wc_bugs.register_dig_spawn({
	"default:dirt",
	"default:dirt_with_grass",
	"default:dirt_with_rainforest_litter",
	"default:dirt_with_coniferous_litter",
	"default:dirt_with_dry_grass",
	"default:dry_dirt",
	"default:dry_dirt_with_dry_grass",
}, "wc_bugs:peatle", 80)

------------------------------------------------------------------------
-- Sunlight is fatal to them too, so they only linger in shade and caves.
minetest.register_abm({
	label = "Peatle starstroke",
	nodenames = {"wc_bugs:peatle"},
	interval = 10,
	chance = 6,
	action = function(pos)
		if wc_bugs.is_full_sun({x = pos.x, y = pos.y + 1, z = pos.z}) then
			minetest.remove_node(pos)
			wc_bugs.smokeburst(pos, 3)
		end
	end
})

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:peatle", {
	chance = 24,
	dark = true,
	comfort = {"default:dirt", "group:soil"},
	wander = 1 / 90,
})
