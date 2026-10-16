-- Luxmoths: pale glowing moths that pupate on cave ceilings and die the
-- moment they meet direct sunlight.

local S = wc_bugs.S

local mothstill = "wc_bugs_luxmoth.png^[verticalframe:8:1"

------------------------------------------------------------------------
minetest.register_node("wc_bugs:luxmoth", {
	description = S("Luxmoth"),
	drawtype = "plantlike",
	tiles = {{
		name = "wc_bugs_luxmoth.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		},
	}},
	inventory_image = mothstill,
	wield_image = mothstill,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 6,
	light_colour = "#cfe8ff",
	stack_max = 1,
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		luxmoth = 1,
		bug = 1,
		flying = 1,
		catchable = 1,
		flammable = 1
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	sounds = default.node_sound_leaves_defaults()
})

------------------------------------------------------------------------
minetest.register_node("wc_bugs:chrysalis", {
	description = S("Chrysalis"),
	tiles = {"wc_bugs_chrysalis.png"},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.25, 0.25, 0.375, 0.25},
			{-0.375, -0.25, -0.375, 0.375, 0.25, 0.375},
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		}
	},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 6,
	light_colour = "#cfe8ff",
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 2,
		chrysalis = 1,
		bug = 1,
		flammable = 1,
		attached_node = 4  -- hangs from the ceiling it grew on
	},
	sounds = default.node_sound_leaves_defaults(),
	-- Breaking a chrysalis does not hand you a moth: it wakes one up.
	on_dig = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:luxmoth"})
		minetest.sound_play("default_dig_snappy",
			{pos = pos, gain = 0.3, max_hear_distance = 8}, true)
		return true
	end
})

------------------------------------------------------------------------
minetest.register_decoration({
	name = "wc_bugs:chrysalis",
	deco_type = "simple",
	place_on = {"group:stone", "group:sandstone"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.001,
	y_max = -16,
	y_min = -31000,
	flags = "all_ceilings",
	decoration = "wc_bugs:chrysalis",
})

------------------------------------------------------------------------
-- Sunlight is fatal.
minetest.register_abm({
	label = "Luxmoth starstroke",
	nodenames = {"wc_bugs:luxmoth"},
	interval = 10,
	chance = 4,
	action = function(pos)
		if wc_bugs.is_full_sun({x = pos.x, y = pos.y + 1, z = pos.z}) then
			minetest.remove_node(pos)
			wc_bugs.smokeburst(pos, 3)
			minetest.sound_play("default_dig_snappy",
				{pos = pos, gain = 0.2, max_hear_distance = 8}, true)
		end
	end
})

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:luxmoth", {
	chance = 20,
	dark = true,
	comfort = {"group:stone"},
	wander = 1 / 60,
})
