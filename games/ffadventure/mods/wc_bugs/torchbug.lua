-- Torchbugs: fireflies with a temper. Leave one alone and it blinks in the
-- dark; grab at it and it flares up into a flamebug that starts fires.

local S = wc_bugs.S

local torchbug = "wc_bugs_torchbug.png^[verticalframe:8:2"
local flamebug = "wc_bugs_firebug.png^[verticalframe:8:2"

local function anim(texture, length)
	return {
		name = texture,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = length
		},
	}
end

------------------------------------------------------------------------
-- calm torchbug
------------------------------------------------------------------------
minetest.register_node("wc_bugs:torchbug", {
	description = S("Torchbug"),
	drawtype = "plantlike",
	tiles = {anim("wc_bugs_torchbug.png", 1.5)},
	inventory_image = torchbug,
	wield_image = torchbug,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 5,
	light_colour = "#e8a020",
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		torchbug = 1,
		bug = 1,
		flying = 1,
		catchable = 1
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	sounds = default.node_sound_leaves_defaults(),
	-- Digging one bare-handed only angers it. Use a bug net.
	on_dig = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:flamebug"})
		wc_bugs.spark(pos)
		return true
	end
})

------------------------------------------------------------------------
-- hidden torchbug (blinked off)
------------------------------------------------------------------------
minetest.register_node("wc_bugs:torchbug_hidden", {
	description = S("Torchbug"),
	drawtype = "airlike",
	inventory_image = torchbug .. "^default_invisible_node_overlay.png",
	wield_image = torchbug .. "^default_invisible_node_overlay.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	floodable = true,
	drop = "",
	groups = {
		torchbug = 1,
		bug = 1,
		flying = 1,
		not_in_creative_inventory = 1
	}
})

------------------------------------------------------------------------
-- flamebug (excited torchbug)
------------------------------------------------------------------------
minetest.register_node("wc_bugs:flamebug", {
	description = S("Flamebug"),
	drawtype = "plantlike",
	tiles = {anim("wc_bugs_firebug.png", 0.8)},
	inventory_image = flamebug,
	wield_image = flamebug,
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false,
	floodable = true,
	light_source = 9,
	light_colour = "#ff5000",
	damage_per_second = 1,
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		bug = 1,
		torchbug = 1,
		firebug = 1,
		flying = 1,
		igniter = 1,
		catchable = 1
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	sounds = default.node_sound_leaves_defaults(),
	drop = "",
	-- Too hot to pocket: it bolts as soon as you disturb it.
	on_dig = function(pos)
		minetest.remove_node(pos)
		wc_bugs.snuff(pos)
		return true
	end
})

------------------------------------------------------------------------
-- blinking
------------------------------------------------------------------------
minetest.register_abm({
	label = "Torchbug hide",
	nodenames = {"wc_bugs:torchbug"},
	interval = 2,
	chance = 10,
	action = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:torchbug_hidden"})
	end
})

minetest.register_abm({
	label = "Torchbug light",
	nodenames = {"wc_bugs:torchbug_hidden"},
	interval = 2,
	chance = 10,
	action = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:torchbug"})
	end
})

------------------------------------------------------------------------
-- temper
------------------------------------------------------------------------
minetest.register_abm({
	label = "Flamebug calm down",
	nodenames = {"wc_bugs:flamebug"},
	interval = 4,
	chance = 10,
	action = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:torchbug"})
		wc_bugs.snuff(pos)
	end
})

minetest.register_abm({
	label = "Torchbug flare up",
	nodenames = {"wc_bugs:torchbug", "wc_bugs:torchbug_hidden"},
	neighbors = {"group:igniter", "group:lava"},
	interval = 4,
	chance = 3,
	action = function(pos)
		minetest.set_node(pos, {name = "wc_bugs:flamebug"})
		wc_bugs.spark(pos)
	end
})

minetest.register_abm({
	label = "Flamebug sparks",
	nodenames = {"wc_bugs:flamebug"},
	interval = 5,
	chance = 4,
	action = function(pos)
		wc_bugs.spark(pos)
		wc_bugs.ignite_near(pos)
	end
})

------------------------------------------------------------------------
-- ways to die
------------------------------------------------------------------------
minetest.register_abm({
	label = "Torchbug drowning",
	nodenames = {"group:torchbug"},
	neighbors = {"group:water"},
	interval = 3,
	chance = 2,
	action = function(pos)
		minetest.remove_node(pos)
		wc_bugs.snuff(pos)
	end
})

-- Flying too far above the ground burns them out.
minetest.register_abm({
	label = "Torchbug Icarian flight",
	nodenames = {"group:torchbug"},
	interval = 10,
	chance = 4,
	action = function(pos)
		local down = {x = pos.x, y = pos.y - 20, z = pos.z}
		if #minetest.find_nodes_in_area(pos, down, {"air"}) >= 20 then
			minetest.remove_node(pos)
			wc_bugs.snuff(pos)
		end
	end
})

------------------------------------------------------------------------
-- spawning
------------------------------------------------------------------------
minetest.register_decoration({
	name = "wc_bugs:torchbug",
	deco_type = "simple",
	place_on = {"group:soil", "group:sand"},
	place_offset_y = 2,
	sidelen = 16,
	fill_ratio = 0.00015,
	y_max = 31000,
	y_min = 1,
	decoration = "wc_bugs:torchbug_hidden",
})

-- The nodecore original hatched torchbugs out of lit torches standing in
-- humus, which eats torches the player placed, so it is off by default.
if minetest.settings:get_bool("wc_bugs.torch_hatching", false) then
	minetest.register_abm({
		label = "Torchbug birth",
		nodenames = {"group:torch"},
		neighbors = {"group:soil"},
		interval = 60,
		chance = 30,
		action = function(pos)
			minetest.set_node(pos, {name = "wc_bugs:torchbug"})
			minetest.add_item(pos, "default:stick")
			wc_bugs.spark(pos)
		end
	})
end

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:torchbug", {
	chance = 24,
	dark = true,
	wander = 1 / 120,
})
