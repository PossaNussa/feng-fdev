-- Taking the joke too far: stickbugs can be assembled into larger bugs that
-- happen to be shaped exactly like tools and building parts. Squash any of
-- them to get the honest wooden version.

local S = wc_bugs.S

local stickbug = "default_tree.png^[colorize:#241708:50"
local sticktop = "default_tree_top.png^[colorize:#241708:50"
local gtfbug = "default_wood.png^[colorize:#241708:60"

local lt = 1 / 16
local lw = 3 / 16
local ll = 1 / 2
local lf = 1 / 8

------------------------------------------------------------------------
minetest.register_node("wc_bugs:staffbug", {
	description = S("Staffbug"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {-lt, -0.5, -lt, lt, 0.5, lt}},
	selection_box = {type = "fixed", fixed = {-lf, -0.5, -lf, lf, 0.5, lf}},
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
minetest.register_node("wc_bugs:framebug", {
	description = S("Framebug"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-lt, -ll, -lt, lt, ll, lt},
			{-ll, -lt, -lt, ll, lt, lt},
			{-lt, -lt, -ll, lt, lt, ll}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-lf, -ll, -lf, lf, ll, lf},
			{-ll, -lf, -lf, ll, lf, lf},
			{-lf, -lf, -ll, lf, lf, ll}
		}
	},
	tiles = {gtfbug},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
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
minetest.register_node("wc_bugs:ladderbug", {
	description = S("Ladderbug"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-lt, -ll, -lt, lt, ll, lt},
			{-lw, -lt, -lt, lw, lt, lt},
			{-lt, -lt, -lw, lt, lt, lw}
		}
	},
	selection_box = {type = "fixed", fixed = {-lw, -ll, -lw, lw, ll, lw}},
	tiles = {gtfbug},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
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
-- An adze is an axe that also grubs at soil; the bug version is no better
-- at either job than a wooden one.
minetest.register_tool("wc_bugs:adzebug", {
	description = S("Adzebug"),
	inventory_image = "default_tool_woodaxe.png^[colorize:#241708:70",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			choppy = {times = {[2] = 3.00, [3] = 1.60}, uses = 10, maxlevel = 1},
			crumbly = {times = {[2] = 1.80, [3] = 0.90}, uses = 10, maxlevel = 1},
		},
		damage_groups = {fleshy = 2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {
		bug = 1,
		stickbug = 1,
		axe = 1,
		flammable = 2
	}
})

------------------------------------------------------------------------
minetest.register_tool("wc_bugs:rakebug", {
	description = S("Rakebug"),
	inventory_image = "default_tool_woodshovel.png^[colorize:#241708:70",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1] = 3.00, [2] = 1.60, [3] = 0.60},
				uses = 10, maxlevel = 1},
			snappy = {times = {[3] = 0.40}, uses = 10, maxlevel = 1},
		},
		damage_groups = {fleshy = 1},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {
		bug = 1,
		stickbug = 1,
		shovel = 1,
		flammable = 2
	}
})

------------------------------------------------------------------------
-- assembly
------------------------------------------------------------------------
minetest.register_craft({
	output = "wc_bugs:staffbug",
	recipe = {
		{"wc_bugs:stickbug"},
		{"wc_bugs:stickbug"},
	}
})

minetest.register_craft({
	output = "wc_bugs:framebug",
	recipe = {
		{"wc_bugs:staffbug", "wc_bugs:staffbug"},
	}
})

minetest.register_craft({
	output = "wc_bugs:ladderbug",
	recipe = {
		{"wc_bugs:stickbug", "", "wc_bugs:stickbug"},
		{"wc_bugs:stickbug", "wc_bugs:stickbug", "wc_bugs:stickbug"},
		{"wc_bugs:stickbug", "", "wc_bugs:stickbug"},
	}
})

minetest.register_craft({
	output = "wc_bugs:adzebug",
	recipe = {
		{"wc_bugs:stickbug", "wc_bugs:stickbug"},
		{"", "wc_bugs:staffbug"},
	}
})

minetest.register_craft({
	output = "wc_bugs:rakebug",
	recipe = {
		{"wc_bugs:stickbug", "wc_bugs:stickbug", "wc_bugs:stickbug"},
		{"", "wc_bugs:staffbug", ""},
		{"", "wc_bugs:staffbug", ""},
	}
})

-- A torch is a stick with something burning on top. So is a torchbug.
minetest.register_craft({
	output = "wc_bugs:torchbug",
	recipe = {
		{"default:coal_lump"},
		{"wc_bugs:staffbug"},
	}
})

------------------------------------------------------------------------
-- squashing
------------------------------------------------------------------------
wc_bugs.register_smush("wc_bugs:staffbug", "default:stick 2")
wc_bugs.register_smush("wc_bugs:framebug", "default:fence_wood")
wc_bugs.register_smush("wc_bugs:ladderbug", "default:ladder_wood")
wc_bugs.register_smush("wc_bugs:adzebug", "default:axe_wood")
wc_bugs.register_smush("wc_bugs:rakebug", "default:shovel_wood")

for _, bug in ipairs({"wc_bugs:staffbug", "wc_bugs:framebug",
		"wc_bugs:ladderbug", "wc_bugs:adzebug", "wc_bugs:rakebug"}) do
	minetest.register_craft({
		type = "fuel",
		recipe = bug,
		burntime = 8,
	})
end

------------------------------------------------------------------------
wc_bugs.register_escape("wc_bugs:staffbug", {
	chance = 40,
	comfort = {"default:stick", "wc_bugs:stickbug"},
	wander = 1 / 180,
})
