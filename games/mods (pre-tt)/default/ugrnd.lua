minetest.register_node("default:silt", {
	description = "Silt",
	tiles = {"default_silt.png"},
	groups = {crumbly = 3, soil = 3, wet = 1, grassland = 1, field = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"default:flint"}, rarity = 15},
			{items = {"default:silt"}}
		}
	},
	soil = {
		base = "default:silt",
		dry = "default:silt",
		wet = "default:silt"
	}
})
minetest.register_node("default:oil_source", {
	description = "Liquid Mud Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "oil.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "oil.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:oil_flowing",
	liquid_alternative_source = "default:oil_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, drowning = 1},
})

-- Register liquid mud flowing
minetest.register_node("default:oil_flowing", {
	description = "Flowing Liquid Mud",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"mud.png"},
	special_tiles = {
		{
			name = "oil.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "oil.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:oil_flowing",
	liquid_alternative_source = "default:oil_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, not_in_creative_inventory = 1, drowning = 1},
})
minetest.register_node("default:saprolite", {
    description = "Saprolite",
    tiles = {"default_saprolite.png"},
    groups = {cracky = 3, crumbly = 1},  -- Grouping it as both cracky and crumbly

	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale", {
    description = "Shale",
    tiles = {"default_shale.png"},
    groups = {cracky = 3, crumbly = 1, stone = 1},  -- Grouping it as both cracky and crumbly

	sounds = default.node_sound_gravel_defaults(),
})

minetest.register_node("default:limestone", {
    description = "Limestone",
    tiles = {"default_limestone.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})
minetest.register_node("default:pumice", {
	description = "Pumice",
	tiles = {"nc_igneous_pumice.png"},
	groups = {
		snappy = 2,
		cracky = 2,
		stone = 1,
	},
	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
	})
minetest.register_node("default:pumtile", {
	description = "Pumice Tile",
	tiles = {"pumtile.png"},
	groups = {
		snappy = 2,
		cracky = 2,
		stone = 1,
	},
	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
	})
minetest.register_node("default:prick", {
	description = "Pumice Brick",
	tiles = {"prick.png"},
	groups = {
		snappy = 2,
		cracky = 2,
		stone = 1,
	},
	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
	})
minetest.register_node("default:pflag", {
	description = "Pumice Flagstone",
	tiles = {"pflag.png"},
	groups = {
		snappy = 2,
		cracky = 2,
		stone = 1,
	},
	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
	})
minetest.register_node("default:pumcobble", {
	description = "Pumice Cobble",
	tiles = {"pumcobble.png"},
	groups = {
		snappy = 2,
		cracky = 2,
		stone = 1,
	},
	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
	})
minetest.register_node("default:schist", {
    description = "Schist",
    tiles = {"default_schist.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})

minetest.register_node("default:slate", {
    description = "Slate",
    tiles = {"default_slate.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})

minetest.register_node("default:schist_with_garnet", {
	description = ("Garnet Geode"),
	tiles = {"default_schist.png^default_mineral_garnet.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:salt", {
    description = "Salt",
    tiles = {"default_salt.png"},
    groups = {cracky = 3, stone = 1}, 
    drop = {
        max_items = 1, -- Maximum number of items to drop
        items = {
            {
                items = {'x_farming:salt'}, -- Item to drop
                rarity = 1, -- Rarity of the drop
                -- The following function randomly returns a number between 2 and 9
                count = function() return math.random(2, 9) end,
            },
        },
    },

    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:quartz", {
    description = "Quartz",
    tiles = {"quartz.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})


minetest.register_node("default:marble", {
    description = "Marble",
    tiles = {"default_marble.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})

minetest.register_node("default:onyx", {
    description = "Onyx",
    tiles = {"onyx.png"},
    groups = {cracky = 3, stone = 1}, 

	sounds = default.node_sound_stone_defaults(),	-- Grouping it as both cracky and crumbly
})


minetest.register_node("default:limestone_pillar", {
    description = "Limestone Pillar",
    tiles = {"default_limestone_pillar.png"},
	sounds = default.node_sound_stone_defaults(),
    groups = {cracky = 3, stone = 1},  -- Grouping it as both cracky and crumbly
})

-- Register the 3x3 crafting recipe for Nickel Block
minetest.register_craft({
	output = "default:default_limestone_brick",
	recipe = {
		{"default:limestone", "default:limestone"},
		{"default:limestone", "default:limestone"}
	}
})

-- Register the 3x3 crafting recipe for Nickel Block
minetest.register_craft({
	output = "default:default_limestone_pillar",
	recipe = {
		{"default:limestone"},
		{"default:limestone"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:shale",
	burntime = 2,
})

minetest.register_craftitem("default:nickel_lump", {
	description = ("Nickel Lump"),
	inventory_image = "default_nickel_lump.png"
})

minetest.register_craftitem("default:chrome_lump", {
	description = ("Chromium Lump"),
	inventory_image = "chrome_lump.png"
})

minetest.register_craftitem("default:titanium_lump", {
	description = ("Titanium Lump"),
	inventory_image = "default_titanium_lump.png"
})

minetest.register_craftitem("default:platinum_lump", {
	description = ("Platinum Lump"),
	inventory_image = "default_platinum_lump.png"
})
minetest.register_craftitem("default:opal", {
	description = ("Opal"),
	inventory_image = "default_opal.png"
})

minetest.register_craftitem("default:nickelbar", {
	description = ("Nickel Bar"),
	inventory_image = "nickelbar.png"
})

minetest.register_craftitem("default:chromebar", {
	description = ("Chrome Bar"),
	inventory_image = "chromebar.png"
})

minetest.register_craftitem("default:titaniumbar", {
	description = ("Titanium Bar"),
	inventory_image = "titaniumbar.png"
})

minetest.register_craftitem("default:platinumbar", {
	description = ("Platinum Bar"),
	inventory_image = "platinumbar.png"
})

minetest.register_craftitem("default:cobaltsteel_ingot", {
	description = ("Cobalt Steel Bar"),
	inventory_image = "cobaltsteelbar.png"
})


minetest.register_craft({
	type = "cooking",
	output = "default:nickelbar",
	recipe = "default:nickel_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:chromebar",
	recipe = "default:chrome_lump",
})
minetest.register_craft({
	type = "cooking",
	output = "default:platinumbar",
	recipe = "default:platinum_lump",
})
minetest.register_craft({
	type = "cooking",
	output = "default:titaniumbar",
	recipe = "default:titanium_lump",
})
minetest.register_node("default:saprolite_with_nickel", {
	description = ("Nickel Ore"),
	tiles = {"default_saprolite.png^default_mineral_nickel.png"},
	groups = {cracky = 3, crumbly = 1},
	drop = "default:nickel_lump",
	sounds = default.node_sound_stone_defaults(),

})

minetest.register_node("default:nickelblock", {
	description = ("Nickel Block"),
	tiles = {"nickelblock.png"},
	groups = {cracky = 3},
	drop = "default:nickelblock",
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("default:chromeblock", {
	description = ("Chrome Block"),
	tiles = {"chromeblock.png"},
	groups = {cracky = 3},
	drop = "default:chromeblock",
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("default:titaniumblock", {
	description = ("Titanium Block"),
	tiles = {"titaniumblock.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_metal_defaults(),
})


minetest.register_node("default:platinumblock", {
	description = ("Platinum Block"),
	tiles = {"platinumblock.png"},
	groups = {cracky = 3},
	drop = "default:platinumblock",
	sounds = default.node_sound_metal_defaults(),
})
minetest.register_node("default:cobaltsteelblock", {
	description = ("Cobalt Steel Block"),
	tiles = {"cobaltsteelblock.png"},
	groups = {cracky = 3},
	drop = "default:cobaltsteelblock",
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("default:granite", {
	description = ("Granite"),
	tiles = {"default_granite.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:granite",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:gneiss", {
	description = ("Gneiss"),
	tiles = {"default_gneiss.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2, stone = 1},
})

minetest.register_node("default:mantle", {
	description = ("Mantle Rock"),
	tiles = {"mantle.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2, stone = 1},
})

-- Register the 3x3 crafting recipe for Nickel Block
minetest.register_craft({
	output = "default:nickelblock",
	recipe = {
		{"default:nickelbar", "default:nickelbar", "default:nickelbar"},
		{"default:nickelbar", "default:nickelbar", "default:nickelbar"},
		{"default:nickelbar", "default:nickelbar", "default:nickelbar"}
	}
})

minetest.register_craft({
	output = "default:chromeblock",
	recipe = {
		{"default:chromebar", "default:chromebar", "default:chromebar"},
		{"default:chromebar", "default:chromebar", "default:chromebar"},
		{"default:chromebar", "default:chromebar", "default:chromebar"}
	}
})
minetest.register_craft({
	output = "default:titaniumblock",
	recipe = {
		{"default:titaniumbar", "default:titaniumbar", "default:titaniumbar"},
		{"default:titaniumbar", "default:titaniumbar", "default:titaniumbar"},
		{"default:titaniumbar", "default:titaniumbar", "default:titaniumbar"}
	}
})
minetest.register_craft({
	output = "default:platinumblock",
	recipe = {
		{"default:platinumbar", "default:platinumbar", "default:platinumbar"},
		{"default:platinumbar", "default:platinumbar", "default:platinumbar"},
		{"default:platinumbar", "default:platinumbar", "default:platinumbar"}
	}
})
minetest.register_craft({
	output = "default:cobaltsteelblock",
	recipe = {
		{"default:cobaltsteelbar", "default:cobaltsteelbar", "default:cobaltsteelbar"},
		{"default:cobaltsteelbar", "default:cobaltsteelbar", "default:cobaltsteelbar"},
		{"default:cobaltsteelbar", "default:cobaltsteelbar", "default:cobaltsteelbar"}
	}
})

minetest.register_craft({
	output = "default:salt",
	recipe = {
		{"x_farming:salt", "x_farming:salt", "x_farming:salt"},
		{"x_farming:salt", "x_farming:salt", "x_farming:salt"},
		{"x_farming:salt", "x_farming:salt", "x_farming:salt"}
	}
})

minetest.register_node("default:opalblock", {
	description = ("Opal Block"),
	tiles = {"opalblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:btopazblock", {
	description = ("Blue Topaz Block"),
	tiles = {"btopazblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:amethystblock", {
	description = ("Amethyst Block"),
	tiles = {"ablock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:garnetblock", {
	description = ("Garnet Block"),
	tiles = {"garnetblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:fopalblock", {
	description = ("Fire Opal Block"),
	tiles = {"fopalblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_craftitem("default:ruby", {
	description = ("Ruby"),
	inventory_image = "ruby.png"
})


minetest.register_craftitem("default:emerald", {
	description = ("Emerald"),
	inventory_image = "emerald.png"
})

minetest.register_craftitem("default:garnet", {
	description = ("Garnet"),
	inventory_image = "garnet.png"
})

minetest.register_craftitem("default:sapphire", {
	description = ("Sapphire"),
	inventory_image = "sapphire.png"
})

minetest.register_craftitem("default:peridot", {
	description = ("Peridot"),
	inventory_image = "peridot.png"
})

minetest.register_craftitem("default:btopaz", {
	description = ("Blue Topaz"),
	inventory_image = "btopaz.png"
})

minetest.register_craftitem("default:amethyst", {
	description = ("Amethyst"),
	inventory_image = "amethyst.png"
})

minetest.register_craftitem("default:fopal", {
	description = ("Fire Opal"),
	inventory_image = "fopal.png"
})

minetest.register_craft({
	output = "default:opal",
	recipe = {
		{"default:clay_with_opal", "default:shale"}
	}
})

minetest.register_craft({
	output = "default:btopaz",
	recipe = {
		{"default:stone_with_blue_topaz", "default:shale"}
	}
})

minetest.register_craft({
	output = "default:amethyst",
	recipe = {
		{"default:stone_with_amethyst", "default:shale"}
	}
})

minetest.register_craft({
	output = "default:fopal",
	recipe = {
		{"default:stone_with_fire_opal", "default:shale"}
	}
})

minetest.register_craft({
	output = "default:ruby",
	recipe = {
		{"default:limestone_with_ruby", "default:shale"}
	}
})


minetest.register_craft({
	output = "default:emerald",
	recipe = {
		{"default:gneiss_with_emerald", "default:shale"}
	}
})

minetest.register_craft({
	output = "default:garnet",
	recipe = {
		{"default:granite_with_garnet", "default:shale"}
	}
})
minetest.register_craft({
	output = "default:sapphire",
	recipe = {
		{"default:granite_with_sapphire", "default:shale"}
	}
})
minetest.register_craft({
	output = "default:sapphire",
	recipe = {
		{"default:gneiss_with_sapphire", "default:shale"}
	}
})
minetest.register_craft({
	output = "default:fopal",
	recipe = {
		{"default:basalt_with_fire_opal", "default:shale"}
	}
})
minetest.register_craft({
	output = "default:peridot",
	recipe = {
		{"default:basalt_with_peridot", "default:shale"}
	}
})
minetest.register_craft({
	output = "default:opalblock",
	recipe = {
		{"default:opal", "default:opal", "default:opal"},
		{"default:opal", "default:opal", "default:opal"},
		{"default:opal", "default:opal", "default:opal"}
	}
})

minetest.register_craft({
	output = "default:fopalblock",
	recipe = {
		{"default:fopal", "default:fopal", "default:fopal"},
		{"default:fopal", "default:fopal", "default:fopal"},
		{"default:fopal", "default:fopal", "default:fopal"}
	}
})

minetest.register_craft({
	output = "default:btopazblock",
	recipe = {
		{"default:btopaz", "default:btopaz", "default:btopaz"},
		{"default:btopaz", "default:btopaz", "default:btopaz"},
		{"default:btopaz", "default:btopaz", "default:btopaz"}
	}
})


minetest.register_craft({
	output = "default:amethystblock",
	recipe = {
		{"default:amethyst", "default:amethyst", "default:amethyst"},
		{"default:amethyst", "default:amethyst", "default:amethyst"},
		{"default:amethyst", "default:amethyst", "default:amethyst"}
	}
})

minetest.register_node("default:rubyblock", {
	description = ("Ruby Block"),
	tiles = {"rubyblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:emeraldblock", {
	description = ("Emerald Block"),
	tiles = {"emeraldblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sapphireblock", {
	description = ("Sapphire Block"),
	tiles = {"sapphireblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:peridotblock", {
	description = ("Peridot Block"),
	tiles = {"peridotblock.png"},
	drawtype = "glasslike",
	 use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "default:rubyblock",
	recipe = {
		{"default:ruby", "default:ruby", "default:ruby"},
		{"default:ruby", "default:ruby", "default:ruby"},
		{"default:ruby", "default:ruby", "default:ruby"}
	}
})

minetest.register_craft({
	output = "default:emeraldblock",
	recipe = {
		{"default:emerald", "default:emerald", "default:emerald"},
		{"default:emerald", "default:emerald", "default:emerald"},
		{"default:emerald", "default:emerald", "default:emerald"}
	}
})

minetest.register_craft({
	output = "default:peridotblock",
	recipe = {
		{"default:peridot", "default:peridot", "default:peridot"},
		{"default:peridot", "default:peridot", "default:peridot"},
		{"default:peridot", "default:peridot", "default:peridot"}
	}
})

minetest.register_craft({
	output = "default:garnetblock",
	recipe = {
		{"default:garnet", "default:garnet", "default:garnet"},
		{"default:garnet", "default:garnet", "default:garnet"},
		{"default:garnet", "default:garnet", "default:garnet"}
	}
})

minetest.register_craft({
	output = "default:sapphireblock",
	recipe = {
		{"default:sapphire", "default:sapphire", "default:sapphire"},
		{"default:sapphire", "default:sapphire", "default:sapphire"},
		{"default:sapphire", "default:sapphire", "default:sapphire"}
	}
})


minetest.register_craftitem("default:silver_lump", {
	description = ("Silver Lump"),
	inventory_image = "default_silver_lump.png"
})

minetest.register_craftitem("default:malachite_lump", {
	description = ("Malachite Lump"),
	inventory_image = "default_malachite_lump.png"
})

minetest.register_craftitem("default:silverbar", {
	description = ("Silver Bar"),
	inventory_image = "silverbar.png"
})

minetest.register_craft({
	type = "cooking",
	output = "default:silverbar",
	recipe = "default:silver_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:copper_ingot",
	recipe = "default:malachite_lump",
})

minetest.register_craft({
    output = "default:gravel 2",
    recipe = {
        {"default:shale"},
    }
})

minetest.register_node("default:stone_with_silver", {
	description = ("Silver Ore"),
	tiles = {"default_stone.png^default_mineral_silver.png"},
	groups = {cracky = 3},
	drop = "default:silver_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_blue_topaz", {
	description = ("Topaz Geode"),
	tiles = {"default_stone.png^default_mineral_blue_topaz.png"},
	groups = {cracky = 3},
	drop = "default:stone_with_blue_topaz",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_fire_opal", {
	description = ("Fire Opal Geode"),
	tiles = {"default_stone.png^default_mineral_fire_opal.png"},
	groups = {cracky = 3},
	drop = "default:stone_with_fire_opal",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_amethyst", {
	description = ("Amethyst Geode"),
	tiles = {"default_stone.png^default_mineral_amethyst.png"},
	groups = {cracky = 3},
	drop = "default:stone_with_amethyst",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basalt_with_fire_opal", {
	description = ("Fire Opal Geode"),
	tiles = {"default_obsidian.png^default_mineral_fire_opal.png"},
	groups = {cracky = 3, level = 2},
	drop = "default:basalt_with_fire_opal",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:basalt_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_obsidian.png^default_mineral_iron.png"},
	groups = {cracky = 3, level = 2},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basalt_with_peridot", {
	description = ("Peridot Geode"),
	tiles = {"default_obsidian.png^default_mineral_peridot.png"},
	groups = {cracky = 3, level = 2},
	drop = "default:basalt_with_peridot",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_shale.png^default_mineral_iron.png"},
	groups = {cracky = 3},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale_with_zinc", {
	description = ("Zinc Ore"),
	tiles = {"default_shale.png^default_mineral_zinc.png"},
	groups = {cracky = 3},
	drop = "default:zinc_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale_with_fgold", {
	description = ("Gold Ore"),
	tiles = {"default_shale.png^default_mineral_gold.png"},
	groups = {cracky = 3},
	drop = "default:fgold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stone_with_fgold", {
	description = ("Gold Ore"),
	tiles = {"default_stone.png^default_mineral_gold.png"},
	groups = {cracky = 3},
	drop = "default:fgold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("default:zinc_lump", {
	description = ("Zinc Lump"),
	inventory_image = "default_zinc_lump.png"
})

minetest.register_craftitem("default:zbar", {
	description = ("Zinc Bar"),
	inventory_image = "zbar.png"
})

minetest.register_alias("default:zincbar", "default:zbar")
minetest.register_craft({
	type = "cooking",
	output = "default:zbar",
	recipe = "default:zinc_lump",
})
minetest.register_node("default:zblock", {
	description = ("Block of Zinc"),
	tiles = {"zblock.png"},
	groups = {cracky = 3},
	drop = "default:zblock",
	sounds = default.node_sound_metal_defaults(),
})
minetest.register_node("default:silverblock", {
	description = ("Block of Silver"),
	tiles = {"silverblock.png"},
	groups = {cracky = 3},
	drop = "default:silverblock",
	sounds = default.node_sound_metal_defaults(),
})
minetest.register_craft({
	output = "default:silverblock",
	recipe = {
		{"default:silverbar", "default:silverbar", "default:silverbar"},
		{"default:silverbar", "default:silverbar", "default:silverbar"},
		{"default:silverbar", "default:silverbar", "default:silverbar"}
	}
})
minetest.register_node("default:fgoldblock", {
	description = ("Block of Fool's Gold"),
	tiles = {"fgoldblock.png"},
	groups = {cracky = 3},
	drop = "default:fgoldblock",
	sounds = default.node_sound_metal_defaults(),
})

-- Register the 3x3 crafting recipe for Nickel Block
minetest.register_craft({
	output = "default:fgoldblock",
	recipe = {
		{"default:fgoldbar", "default:fgoldbar", "default:fgoldbar"},
		{"default:fgoldbar", "default:fgoldbar", "default:fgoldbar"},
		{"default:fgoldbar", "default:fgoldbar", "default:fgoldbar"}
	}
})

minetest.register_craft({
	output = "default:zblock",
	recipe = {
		{"default:zbar", "default:zbar", "default:zbar"},
		{"default:zbar", "default:zbar", "default:zbar"},
		{"default:zbar", "default:zbar", "default:zbar"}
	}
})

minetest.register_craftitem("default:fgold_lump", {
	description = ("Gold Lump"),
	inventory_image = "default_gold_lump.png"
})

minetest.register_craftitem("default:uranium_lump", {
	description = ("Uranium Lump"),
	inventory_image = "default_uranium_lump.png"
})

minetest.register_craftitem("default:amber_lump", {
	description = ("Ball of Amber"),
	inventory_image = "amber.png"
})

minetest.register_craftitem("default:cobalt_lump", {
	description = ("Cobalt Lump"),
	inventory_image = "default_cobalt_lump.png"
})

minetest.register_craftitem("default:fgoldbar", {
	description = ("Fool's Gold"),
	inventory_image = "fgoldbar.png"
})

minetest.register_craft({
	type = "cooking",
	output = "default:fgoldbar",
	recipe = "default:fgold_lump",
})

minetest.register_craftitem("default:cobaltbar", {
	description = ("Cobalt Bar"),
	inventory_image = "cobaltbar.png"
})

minetest.register_node("default:cobaltblock", {
	description = ("Cobalt Block"),
	tiles = {"cobaltblock.png"},
	groups = {cracky = 3},
	drop = "default:cobaltblock",
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:cobaltblock",
	recipe = {
		{"default:cobaltbar", "default:cobaltbar", "default:cobaltbar"},
		{"default:cobaltbar", "default:cobaltbar", "default:cobaltbar"},
		{"default:cobaltbar", "default:cobaltbar", "default:cobaltbar"}
	}
})

minetest.register_node("default:ironblock", {
	description = ("Iron Block"),
	tiles = {"ironblock.png"},
	groups = {cracky = 3},
	drop = "default:ironblock",
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "default:ironblock",
	recipe = {
		{"default:ironbar", "default:ironbar", "default:ironbar"},
		{"default:ironbar", "default:ironbar", "default:ironbar"},
		{"default:ironbar", "default:ironbar", "default:ironbar"}
	}
})
minetest.register_craft({
	output = "default:ironbar 9",
	recipe = {
		{"default:ironblock"}
	}
})

minetest.register_craft({
	type = "cooking",
	output = "default:silverbar",
	recipe = "default:silver_lump",
})

minetest.register_craft({
    output = "default:gravel 2",
    recipe = {
        {"default:shale"},
    }
})

minetest.register_node("default:silt_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_silt.png^default_mineral_coal.png"},
	groups = {crumbly = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:dirt_with_gold", {
	description = ("Gold Ore"),
	tiles = {"default_dirt.png^default_mineral_gold.png"},
	groups = {crumbly = 3},
	drop = "default:gold_lump",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:dirt_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_dirt.png^default_mineral_tin.png"},
	groups = {crumbly = 3},
	drop = "default:tin_lump",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:mud_with_coal", {
	description = ("Coal Ore"),
	tiles = {"mud.png^default_mineral_coal.png"},
	groups = {crumbly = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:clay_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_clay.png^default_mineral_coal.png"},
	groups = {crumbly = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:clay_with_opal", {
	description = ("Opal Geode"),
	tiles = {"default_clay.png^default_mineral_opal.png"},
	groups = {crumbly = 3},
	drop = "default:opal",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("default:saprolite_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_saprolite.png^default_mineral_coal.png"},
	groups = {cracky = 3, crumbly = 1},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:saprolite_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_saprolite.png^default_mineral_tin.png"},
	groups = {cracky = 3, crumbly = 1},
	drop = "default:tin_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:saprolite_with_copper", {
	description = ("Malachite"),
	tiles = {"default_saprolite.png^default_mineral_malachite.png"},
	groups = {cracky = 3, crumbly = 1},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:saprolite_with_cobalt", {
	description = ("Cobalt Ore"),
	tiles = {"default_saprolite.png^default_mineral_cobalt.png"},
	groups = {cracky = 3, crumbly = 1},
	drop = "default:cobalt_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_shale.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:schist_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_schist.png^default_mineral_coal.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slate_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_slate.png^default_mineral_coal.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:slate_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_slate.png^default_mineral_iron.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:shale_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_shale.png^default_mineral_tin.png"},
	groups = {cracky = 3},
	drop = "default:tin_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:shale_with_copper", {
	description = ("Malachite"),
	tiles = {"default_shale.png^default_mineral_malachite.png"},
	groups = {cracky = 3},
	drop = "default:malachite_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:limestone_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_limestone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:limestone_with_zinc", {
	description = ("Zinc Ore"),
	tiles = {"default_limestone.png^default_mineral_zinc.png"},
	groups = {cracky = 3},
	drop = "default:zinc_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:limestone_with_ruby", {
	description = ("Limestone with Ruby"),
	tiles = {"default_limestone.png^default_mineral_ruby.png"},
	groups = {cracky = 3},
	drop = "default:limestone_with_ruby",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:schist_with_ruby", {
	description = ("Ruby Geode"),
	tiles = {"default_schist.png^default_mineral_ruby.png"},
	groups = {cracky = 3},
	drop = "default:schist_with_ruby",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:limestone_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_limestone.png^default_mineral_iron.png"},
	groups = {cracky = 3},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("default:ironbar", {
	description = ("Iron Bar"),
	inventory_image = "default_iron_ingot.png"
})

minetest.register_node("default:limestone_with_copper", {
	description = ("Malachite"),
	tiles = {"default_limestone.png^default_mineral_malachite.png"},
	groups = {cracky = 3},
	drop = "default:malachite_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstone_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_sandstone.png^default_mineral_coal.png"},
	groups = {crumbly = 1, cracky = 3},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstone_with_copper", {
	description = ("Malachite"),
	tiles = {"default_sandstone.png^default_mineral_malachite.png"},
	groups = {crumbly = 1, cracky = 3},
	drop = "default:malachite_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstone_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_sandstone.png^default_mineral_iron.png"},
	groups = {crumbly = 1, cracky = 3},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})
-- Register the uranium ore node
minetest.register_node("default:sandstone_with_uranium", {
	description = "Uranium Ore",
	tiles = {"default_sandstone.png^default_mineral_uranium.png"},
	groups = {crumbly = 1, cracky = 3},
	drop = "default:sandstone_with_uranium",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstone_with_amber", {
	description = "Amber Ore",
	tiles = {"default_sandstone.png^default_mineral_amber.png"},
	groups = {crumbly = 1, cracky = 3},
	drop = "default:amber_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:granite_with_mithril", {
	description = ("Mithril Ore"),
	tiles = {"default_granite.png^default_mineral_mithril.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:gneiss_with_mithril", {
	description = ("Mithril Ore"),
	tiles = {"default_gneiss.png^default_mineral_mithril.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:basalt_with_mithril", {
	description = ("Mithril Ore"),
	tiles = {"default_obsidian.png^default_mineral_mithril.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:mantle_rock_with_mithril", {
	description = ("Mithril Ore"),
	tiles = {"mantle.png^default_mineral_mithril.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basalt_with_adamant", {
	description = ("Adamant Ore"),
	tiles = {"default_obsidian.png^default_mineral_adamant.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:mantle_rock_with_adamant", {
	description = ("Adamant Ore"),
	tiles = {"mantle.png^default_mineral_adamant.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granite_with_uranium", {
	description = ("Uranium Ore"),
	tiles = {"default_granite.png^default_mineral_coal.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
-- Function to damage players near uranium ore
local function damage_players_near(pos)
	local minp = vector.subtract(pos, 3)
	local maxp = vector.add(pos, 3)

	for _, player in ipairs(minetest.get_connected_players()) do
		local player_pos = player:get_pos()

		if vector.distance(pos, player_pos) <= 3 then
			player:set_hp(player:get_hp() - 1)
		end
	end
end

-- Register ABM for uranium ore
minetest.register_abm({
	nodenames = {"default:sandstone_with_uranium", "default:granite_with_uranium", "default:sandstone_with_uranium_dense", "default:granite_with_uranium", "industrialtest:uranium_block"},
	interval = 3,  -- operate every 3 seconds
	chance = 1, -- 100% chance to operate the nodename(s)

	action = function(pos)
		-- The following line will schedule the damage function to run after 3 seconds
		minetest.after(0, damage_players_near, pos)
	end,
})




minetest.register_node("default:granite_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_granite.png^default_mineral_coal.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:coal_lump",
	sounds = default.node_sound_stone_defaults(),
})



minetest.register_node("default:granite_with_chrome", {
	description = ("Chromium Ore"),
	tiles = {"default_granite.png^default_mineral_chrome.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:chrome_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:granite_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_granite.png^default_mineral_iron.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("default:granite_with_garnet", {
	description = ("Garnet Geode"),
	tiles = {"default_granite.png^default_mineral_garnet.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:granite_with_sapphire", {
	description = ("Sapphire Geode"),
	tiles = {"default_granite.png^default_mineral_sapphire.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:schist_with_sapphire", {
	description = ("Sapphire Geode"),
	tiles = {"default_schist.png^default_mineral_sapphire.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granite_with_copper", {
	description = ("Copper Ore"),
	tiles = {"default_granite.png^default_mineral_copper.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granite_with_gold", {
	description = ("Gold Ore"),
	tiles = {"default_granite.png^default_mineral_gold.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granite_with_silver", {
	description = ("Silver Ore"),
	tiles = {"default_granite.png^default_mineral_silver.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:silver_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:granite_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_granite.png^default_mineral_tin.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:tin_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:basalt_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_obsidian.png^default_mineral_coal.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:coal_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:basalt_with_copper", {
	description = ("Copper Ore"),
	tiles = {"default_obsidian.png^default_mineral_copper.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:copper_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:basalt_with_titanium", {
	description = ("Titanium Ore"),
	tiles = {"default_obsidian.png^default_mineral_titanium.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:titanium_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:basalt_with_platinum", {
	description = ("Platinum Ore"),
	tiles = {"default_obsidian.png^default_mineral_platinum.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:platinum_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_coal", {
	description = ("Coal Ore"),
	tiles = {"default_gneiss.png^default_mineral_coal.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:coal_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_titanium", {
	description = ("Titanium Ore"),
	tiles = {"default_gneiss.png^default_mineral_titanium.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:titanium_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_gold", {
	description = ("Gold Ore"),
	tiles = {"default_gneiss.png^default_mineral_gold.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:gold_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_emerald", {
	description = ("Emerald Geode"),
	tiles = {"default_gneiss.png^default_mineral_emerald.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:schist_with_emerald", {
	description = ("Emerald Geode"),
	tiles = {"default_schist.png^default_mineral_emerald.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 3, stone = 1},
})

minetest.register_node("default:schist_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_schist.png^default_mineral_iron.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:iron_lump",
	groups = {cracky = 3, stone = 1},
})

minetest.register_node("default:gneiss_with_iron", {
	description = ("Iron Ore"),
	tiles = {"default_gneiss.png^default_mineral_iron.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:iron_lump",
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:gneiss_with_sapphire", {
	description = ("Sapphire Geode"),
	tiles = {"default_gneiss.png^default_mineral_sapphire.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {cracky = 1, level = 2},
})
minetest.register_node("default:gneiss_with_copper", {
	description = ("Copper Ore"),
	tiles = {"default_gneiss.png^default_mineral_copper.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:copper_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_silver", {
	description = ("Silver Ore"),
	tiles = {"default_gneiss.png^default_mineral_silver.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:silver_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:gneiss_with_tin", {
	description = ("Tin Ore"),
	tiles = {"default_gneiss.png^default_mineral_tin.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:tin_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:mantle_rock_with_coal", {
	description = ("Coal Ore"),
	tiles = {"mantle.png^default_mineral_coal.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:coal_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:mantle_rock_with_peridot", {
	description = ("Peridot Geode"),
	tiles = {"mantle.png^default_mineral_peridot.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:coal_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:mantle_rock_with_titanium", {
	description = ("Titanium Ore"),
	tiles = {"mantle.png^default_mineral_titanium.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:titanium_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:mantle_rock_with_platinum", {
	description = ("Platinum Ore"),
	tiles = {"mantle.png^default_mineral_platinum.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:platinum_lump",
	groups = {cracky = 1, level = 2},
})

minetest.register_node("default:mantle_rock_with_diamond", {
	description = ("Diamond Geode"),
	tiles = {"mantle.png^default_mineral_diamond.png"},
	sounds = default.node_sound_stone_defaults(),
	drop = "default:diamond",
	groups = {cracky = 1, level = 2},
})

-- Function to register layers
local function register_strata()
	
    minetest.register_ore({
    ore_type       = "blob",
    ore            = "default:obsidian",
    wherein        = {"default:granite", "default:stone"},
    clust_scarcity = 12 * 12 * 12,  -- making it common
    clust_size     = 64,  -- you can adjust the size
        y_min = -650,
        y_max = -500,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
			}
    })
	minetest.register_ore({
			ore_type = "blob",
			ore = "default:pumice",
			wherein = "default:stone",
			clust_size = 5,
			clust_scarcity = 32 * 32 * 32,
			random_factor = 0,
			noise_params = {
				offset = -0.1,
				scale = 3,
				spread = {x = 64, y = 16, z = 64},
				seed = 1275,
				octaves = 3,
				persist = 0.5,
				flags = "eased",
			},
			noise_threshold = 1.2,
			y_max = -128
		})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:clay",
		wherein         = {"default:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})
-- Layer 3: Clay from -15 to -30 (stratum)


	-- Sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:sand",
		wherein         = {"default:stone", "default:desert_stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:quartz",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})


	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:marble",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 1234,
			octaves = 1,
			persist = 0.0
		},
	})

    minetest.register_ore({
    ore_type       = "blob",
    ore            = "default:granite",
    wherein        = {"default:obsidian", "default:stone"},
    clust_scarcity = 16 * 16 * 16,  -- making it common
    clust_size     = 64,  -- you can adjust the size
        y_min = -800,
        y_max = -650,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
			}
    })
	
    minetest.register_ore({
    ore_type       = "blob",
    ore            = "default:sand",
    wherein        = {"default:clay", "default:stone"},
    clust_scarcity = 4 * 4 * 4,  -- making it common
    clust_size     = 64,  -- you can adjust the size
        y_min = -30,
        y_max = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
			}
    })

minetest.register_ore({
    ore_type = "stratum",
    ore = "default:clay",
    wherein = "default:stone",
    clust_scarcity = 1,
    clust_size = 1,
    y_min = -30,
    y_max = -15,
})

minetest.register_ore({
    ore_type = "stratum",
    ore = "default:peridotblock",
    wherein = "default:stone",
    clust_scarcity = 1,
    clust_size = 1,
    y_min = -31000,
    y_max = -1224,
})
	

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:oil_source",
		wherein         = {"default:stone"},
		clust_scarcity  = 32 * 32 * 32,
		clust_size      = 8,
		y_max           = -120,
		y_min           = -230,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 361,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:oil_source",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 8,
		y_max           = -340,
		y_min           = -440,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 361,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:amethystblock",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = -340,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
	
		minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:garnetblock",
		wherein         = {"default:stone"},
		clust_scarcity  = 8 * 8 * 8,
		clust_size      = 8,
		y_max           = -1224,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

		minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:diamondblock",
		wherein         = {"default:stone"},
		clust_scarcity  = 12 * 12 * 12,
		clust_size      = 4,
		y_max           = -800,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})
    -- Layer 2: Clay/Mud from -5 to -15

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -15,
        y_max = -5,
    })
	






-- Layer 3 ABOVE: Clay from -15 to -30 (stratum)
minetest.register_ore({
    ore_type = "stratum",
    ore = "default:silt",
    wherein = "default:stone",
    clust_scarcity = 1,
    clust_size = 1,
    y_min = 15,
    y_max = 30,
})

    -- Layer 4: Saprolite from -30 to -60
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:saprolite",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -60,
        y_max = -30,
    })
	
	    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:saprolite",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 30,
        y_max = 55,
    })
	
	-- Layer 5: Shale
		   -- Layer 4: Saprolite from -30 to -60
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:schist",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -340,
        y_max = -240,
    })
	   -- Layer 4: Saprolite from -30 to -60
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:shale",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -440,
        y_max = -340,
    })
	   -- Layer 4: Saprolite from -30 to -60
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:slate",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -540,
        y_max = -440,
    })
		   -- Layer 4: Saprolite from -30 to -60
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:slate_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -540,
        y_max = -440,
    })
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:shale",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 55,
        y_max = 85,
    })
	
		-- Layer 6: Limestone
	
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:limestone",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -120,
        y_max = -60,
    })
	
	--layer 7: Sandstone

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:sandstone",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -240,
        y_max = -120,
    })
	
	--layer 8: Granite

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:granite",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_max = -640,
        y_min = -750,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:granite",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 180,
        y_max = 240,
    })


	--layer 9: Basalt

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:obsidian",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -1024,
        y_max = -870,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:obsidian",
        wherein = {"default:granite", "default:stone"},
        clust_scarcity = 1,
        clust_size = 1,
		biomes = {"grassland", "grassland_dunes", "desert", "sandstone_desert", "rainforest"},
        y_min = 180,
        y_max = 240,
    })
	
				minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_fire_opal",
		wherein        = "default:obsidian",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 340,
		y_min          = -3100,
	})
	
				minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_peridot",
		wherein        = "default:obsidian",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 340,
		y_min          = -3100,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_peridot",
		wherein        = "default:mantle",
		clust_scarcity = 4 * 4 * 4,
		clust_num_ores = 5,
		clust_size     = 5,
		y_max          = -1024,
		y_min          = -30100,
	})

	--layer 10: Gneiss

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:gneiss",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -870,
        y_max = -750,
    })


    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:stone",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -540,
        y_max = -640,
    })


    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mantle",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -1224,
        y_max = -1024,
    })	

   minetest.register_ore({
    ore_type       = "blob",
    ore            = "default:saprolite",
    wherein        = "default:shale",
    clust_scarcity = 16 * 16 * 16,  -- making it common
    clust_size     = 95,  -- you can adjust the size
        y_min = -500,
        y_max = 60,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
			}
    })

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_nickel",
		wherein        = "default:saprolite",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_nickel",
		wherein        = "default:saprolite",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_cobalt",
		wherein        = "default:saprolite",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_cobalt",
		wherein        = "default:saprolite_with_nickel",
		clust_scarcity = 4 * 4 * 4,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_nickel",
		wherein        = "default:saprolite",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 6,
		clust_size     = 6,
		y_max          = 0,
		y_min          = -31000,
	})
	
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_gold",
		wherein        = "default:granite",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_silver",
		wherein        = "default:granite",
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
	
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_chrome",
		wherein        = "default:granite",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 3,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_platinum",
		wherein        = "default:basalt",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 3,
		y_max          = 800,
		y_min          = -1024,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_sapphire",
		wherein        = "default:granite",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:schist_with_sapphire",
		wherein        = "default:schist",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_sapphire",
		wherein        = "default:gneiss",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -500,
		y_min          = -950,
	})
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_garnet",
		wherein        = "default:granite",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
				minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:schist_with_garnet",
		wherein        = "default:schist",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6550,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_silver",
		wherein        = "default:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -3100,
	})
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_blue_topaz",
		wherein        = "default:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 4,
		clust_size     = 5,
		y_max          = -340,
		y_min          = -3100,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_amethyst",
		wherein        = "default:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -3100,
	})
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_fire_opal",
		wherein        = "default:stone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -3100,
	})
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -3100,
	})
	
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_silver",
		wherein        = "default:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 180,
		y_min          = 112,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_silver",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 3,
		clust_size     = 3,
		y_max          = -400,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_fgold",
		wherein        = "default:shale",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -500,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:salt",
		wherein        = "default:shale",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -500,
	})


	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_fgold",
		wherein        = "default:shale",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 15,
		clust_size     = 6,
		y_max          = -95,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_iron",
		wherein        = "default:shale",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -500,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:schist_with_iron",
		wherein        = "default:schist",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -340,
		y_min          = -500,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:slate_with_iron",
		wherein        = "default:slate",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 1,
		clust_size     = 5,
		y_max          = -440,
		y_min          = -540,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_diamond",
		wherein        = "default:mantle",
		clust_scarcity = 17 * 17 * 17,
		clust_num_ores = 4,
		clust_size     = 3,
		y_max          = -1024,
		y_min          = -1224,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_platinum",
		wherein        = "default:mantle",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -1024,
		y_min          = -1224,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_adamant",
		wherein        = "default:mantle",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -1024,
		y_min          = -1224,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_mithril",
		wherein        = "default:mantle",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -1024,
		y_min          = -1224,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_mithril",
		wherein        = "default:mantle",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -500,
		y_min          = -650,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_mithril",
		wherein        = "default:obsidian",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = 800,
		y_min          = -1024,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_adamant",
		wherein        = "default:obsidian",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = 800,
		y_min          = -1024,
	})
	
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_mithril",
		wherein        = "default:gneiss",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -650,
		y_min          = -800,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mantle_rock_with_titanium",
		wherein        = "default:mantle",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -1024,
		y_min          = -1224,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_titanium",
		wherein        = "default:obsidian",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = 800,
		y_min          = -1024,
	})
	
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_titanium",
		wherein        = "default:gneiss",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -650,
		y_min          = -800,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_fgold",
		wherein        = "default:shale",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 60,
		y_min          = 45,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_iron",
		wherein        = "default:shale",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 60,
		y_min          = 45,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_tin",
		wherein        = "default:granite",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -650,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_tin",
		wherein        = "default:gneiss",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 7,
		clust_size     = 3,
		y_max          = -650,
		y_min          = -800,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_emerald",
		wherein        = "default:gneiss",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -650,
		y_min          = -800,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:schist_with_emerald",
		wherein        = "default:schist",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -240,
		y_min          = -800,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_tin",
		wherein        = "default:saprolite",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:sandstone_with_copper",
		wherein        = "default:sandstone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})
	
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_copper",
		wherein        = "default:granite",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -650,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:onyx",
		wherein        = "default:quartz",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 7,
		clust_size     = 3,
		y_max          = 500,
		y_min          = -6050,
	})
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:onyx",
		wherein         = {"default:quartz"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 123,
			octaves = 1,
			persist = 0.0
		},
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_copper",
		wherein        = "default:obsidian",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 4,
		clust_size     = 3,
		y_max          = 800,
		y_min          = -1024,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:sandstone_with_iron",
		wherein        = "default:sandstone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 2,
		clust_size     = 4,
		y_max          = 64,
		y_min          = -31000,
	})
		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:sandstone_with_uranium",
		wherein        = "default:sandstone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 1,
		clust_size     = 5,
		y_max          = 64,
		y_min          = -31000,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:sandstone_with_amber",
		wherein        = "default:sandstone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_uranium",
		wherein        = "default:granite",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = 264,
		y_min          = -31000,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_tin",
		wherein        = "default:shale",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 128,
		y_min          = -31000,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_zinc",
		wherein        = "default:shale",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 128,
		y_min          = -31000,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:saprolite_with_copper",
		wherein        = "default:saprolite",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:shale_with_copper",
		wherein        = "default:shale",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = 128,
		y_min          = -31000,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:limestone_with_copper",
		wherein        = "default:limestone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 128,
		y_min          = -31000,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:limestone_with_zinc",
		wherein        = "default:limestone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 2,
		clust_size     = 3,
		y_max          = 128,
		y_min          = -31000,
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:salt",
		wherein        = "default:limestone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = -60,
		y_min          = -1120,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:salt",
		wherein        = "default:sandstone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = 60,
		y_min          = -1120,
	})

			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:limestone_with_ruby",
		wherein        = "default:limestone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = 128,
		y_min          = -31000,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:schist_with_ruby",
		wherein        = "default:schist",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = 128,
		y_min          = -31000,
	})
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:limestone_with_iron",
		wherein        = "default:limestone",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 3,
		clust_size     = 5,
		y_max          = 128,
		y_min          = -31000,
	})
minetest.register_ore({
    ore_type = "blob",
    ore = "default:sand",
    wherein = {"default:stone", "default:clay"},
    clust_scarcity = 16 * 16 * 16,
    clust_size = 48,
    y_min = -30,
    y_max = -15,
})

-- Mud blobs in Clay and Stone
minetest.register_ore({
    ore_type = "blob",
    ore = "default:mud",
    wherein = "default:clay",
    clust_scarcity = 16 * 16 * 16,
    clust_size = 48,
    y_min = -30,
    y_max = -15,
	noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
})

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:silt",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 15,
        y_max = 30,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 5,
        y_max = 15,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:dirt",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -5,
        y_max = 5,
    })
	
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -15,
        y_max = -5,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:clay_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -30,
        y_max = -15,
    })
	    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:schist_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -340,
        y_max = -240,
    })
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:saprolite_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 30,
        y_max = 55,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:saprolite_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -60,
        y_max = -30,
    })
	
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:shale_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 55,
        y_max = 85,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:shale_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -440,
        y_max = -340,
    })

	
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:limestone_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -120,
        y_max = -60,
    })
	
	--layer 7: Sandstone

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:sandstone_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -240,
        y_max = -120,
    })
	
	--layer 8: Granite

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:granite_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -750,
        y_max = -640,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:granite_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 180,
        y_max = 240,
    })


	--layer 9: Basalt

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:basalt_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 1024,
        y_max = -870,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:basalt_with_coal",
        wherein = {"default:granite_with_coal", "default:stone_with_coal"},
        clust_scarcity = 1,
        clust_size = 1,
		biomes = {"grassland", "grassland_dunes", "desert", "sandstone_desert", "rainforest"},
        y_min = 180,
        y_max = 240,
    })

	--layer 10: Gneiss

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:gneiss_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -870,
        y_max = -750,
    })
	
			minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_copper",
		wherein        = "default:gneiss",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -650,
		y_min          = -8500,
	})

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mantle_rock_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -32000,
        y_max = -1024,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -15,
        y_max = -5,
    })

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud_with_coal",
        wherein = "default:stone_with_coal",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 5,
        y_max = 15,
    })

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "bones:bones",
		wherein        = {"default:silt", "default:dirt", "default:mud", "default:clay", "default:limestone", "default:sandstone", "default:schist", "default:shale", "default:slate", "default:stone", "default:granite", "default:gneiss", "default:obsidian", "default:mantle"},
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = 0,
		y_min          = -31000,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "bones:bones",
		wherein        = {"default:silt", "default:dirt", "default:mud", "default:limestone", "default:schist", "default:granite", "default:mantle"},
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = -128,
		y_min          = -31000,
	})
	
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:dirt_with_gold",
		wherein        = "default:dirt",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 30,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:dirt_with_tin",
		wherein        = "default:dirt",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 1,
		clust_size     = 3,
		y_max          = 30,
		y_min          = -300,
	})

		minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:clay_with_opal",
		wherein        = "default:clay",
		clust_scarcity = 16 * 16 * 16,
		clust_num_ores = 1,
		clust_size     = 2,
		y_max          = -15,
		y_min          = -30,
	})

end

-- Call function to register layers
register_strata()

-- Limestone Stairs
minetest.register_craft({
    output = 'stairs:stair_limestone 6',
    recipe = {
        {'', '', 'default:limestone'},
        {'', 'default:limestone', 'default:limestone'},
        {'default:limestone', 'default:limestone', 'default:limestone'}
    },
})


-- Limestone Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_limestone 4',
    recipe = {
        {'', 'default:limestone', ''},
        {'default:limestone', 'default:limestone', 'default:limestone'}
    },
})

-- Limestone Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_limestone 6',
    recipe = {
        {'', 'default:limestone', ''},
        {'default:limestone', '', 'default:limestone'},
        {'default:limestone', 'default:limestone', 'default:limestone'}
    },
})

-- Nickel Stairs
minetest.register_craft({
    output = 'stairs:stair_nickel 6',
    recipe = {
        {'', '', 'default:nickelbar'},
        {'', 'default:nickelbar', 'default:nickelbar'},
        {'default:nickelbar', 'default:nickelbar', 'default:nickelbar'}
    },
})

-- Nickel Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_nickel 6',
    recipe = {
        {'', 'default:nickelbar', ''},
        {'default:nickelbar', 'default:nickelbar', 'default:nickelbar'}
    },
})

-- Nickel Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_nickel 6',
    recipe = {
        {'', 'default:nickelbar', ''},
        {'default:nickelbar', '', 'default:nickelbar'},
        {'default:nickelbar', 'default:nickelbar', 'default:nickelbar'}
    },
})
-- Fgold Stairs
-- Fgold Stairs
minetest.register_craft({
    output = 'stairs:stair_fgold 6',
    recipe = {
        {'', '', 'default:fgoldbar'},
        {'', 'default:fgoldbar', 'default:fgoldbar'},
        {'default:fgoldbar', 'default:fgoldbar', 'default:fgoldbar'}
    },
})

-- Fgold Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_fgold 6',
    recipe = {
        {'', 'default:fgoldbar', ''},
        {'default:fgoldbar', 'default:fgoldbar', 'default:fgoldbar'}
    },
})

minetest.register_craft({
    output = 'default:steel_ingot 9',
    recipe = {
        {'default:ironbar', 'default:nickelbar', 'default:ironbar'},
        {'default:chromebar', 'default:ironbar', 'default:chromebar'},
        {'default:ironbar', 'default:cobaltbar', 'default:ironbar'}
    },
})

minetest.register_craft({
    output = 'default:cobaltsteel_ingot 9',
    recipe = {
        {'default:ironbar', 'default:chromebar', 'default:ironbar'},
        {'default:cobaltbar', 'default:ironbar', 'default:cobaltbar'},
        {'default:cobaltbar', 'default:cobaltbar', 'default:cobaltbar'}
    }
})

-- Fgold Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_fgold 6',
    recipe = {
        {'', 'default:fgoldbar', ''},
        {'default:fgoldbar', '', 'default:fgoldbar'},
        {'default:fgoldbar', 'default:fgoldbar', 'default:fgoldbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_fgold 6',
    recipe = {
        {'default:fgoldblock', 'default:fgoldblock', 'default:fgoldblock'}
    },
})

minetest.register_craft({
    output = 'stairs:slab_nickel 6',
    recipe = {
        {'default:nickelblock', 'default:nickelblock', 'default:nickelblock'}
    },
})

minetest.register_craft({
    output = 'stairs:slab_limestone 6',
    recipe = {
        {'default:limestone', 'default:limestone', 'default:limestone'}
    },
})

-- granite Stairs
minetest.register_craft({
    output = 'stairs:stair_granite 6',
    recipe = {
        {'', '', 'default:granite'},
        {'', 'default:granite', 'default:granite'},
        {'default:granite', 'default:granite', 'default:granite'}
    },
})

-- granite Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_granite 6',
    recipe = {
        {'', 'default:granite', ''},
        {'default:granite', 'default:granite', 'default:granite'}
    },
})

-- granite Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_granite 6',
    recipe = {
        {'', 'default:granite', ''},
        {'default:granite', '', 'default:granite'},
        {'default:granite', 'default:granite', 'default:granite'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_granite 6',
    recipe = {
        {'default:granite', 'default:granite', 'default:granite'}
    },
})


minetest.register_craft({
    output = 'stairs:stair_fgold 6',
    recipe = {
        {'', '', 'default:fgoldbar'},
        {'', 'default:fgoldbar', 'default:fgoldbar'},
        {'default:fgoldbar', 'default:fgoldbar', 'default:fgoldbar'}
    },
})

-- Fgold Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_cobalt 6',
    recipe = {
        {'', 'default:cobaltbar', ''},
        {'default:cobaltbar', 'default:cobaltbar', 'default:cobaltbar'}
    },
})

-- cobalt Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_cobalt 6',
    recipe = {
        {'', 'default:cobaltbar', ''},
        {'default:cobaltbar', '', 'default:cobaltbar'},
        {'default:cobaltbar', 'default:cobaltbar', 'default:cobaltbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_cobalt 6',
    recipe = {
        {'default:cobaltblock', 'default:cobaltblock', 'default:cobaltblock'}
    },
})

minetest.register_craft({
    output = 'stairs:stair_fgold 6',
    recipe = {
        {'', '', 'default:fgoldbar'},
        {'', 'default:fgoldbar', 'default:fgoldbar'},
        {'default:fgoldbar', 'default:fgoldbar', 'default:fgoldbar'}
    },
})

-- Fgold Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_zinc 6',
    recipe = {
        {'', 'default:zbar', ''},
        {'default:zbar', 'default:zbar', 'default:zbar'}
    },
})

-- cobalt Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_zinc 6',
    recipe = {
        {'', 'default:zbar', ''},
        {'default:zbar', '', 'default:zbar'},
        {'default:zbar', 'default:zbar', 'default:zbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_zinc 6',
    recipe = {
        {'default:zblock', 'default:zblock', 'default:zblock'}
    },
})

minetest.register_craft({
    output = 'stairs:stair_iron 6',
    recipe = {
        {'', '', 'default:ironbar'},
        {'', 'default:ironbar', 'default:ironbar'},
        {'default:ironbar', 'default:ironbar', 'default:ironbar'}
    },
})

-- Fgold Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_iron 6',
    recipe = {
        {'', 'default:ironbar', ''},
        {'default:ironbar', 'default:ironbar', 'default:ironbar'}
    },
})

-- cobalt Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_iron 6',
    recipe = {
        {'', 'default:ironbar', ''},
        {'default:ironbar', '', 'default:ironbar'},
        {'default:ironbar', 'default:ironbar', 'default:ironbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_iron 6',
    recipe = {
        {'default:ironblock', 'default:ironblock', 'default:ironblock'}
    },
})

-- cobaltsteelbar Stairs
minetest.register_craft({
    output = 'stairs:stair_csteel 6',
    recipe = {
        {'', '', 'default:cobaltsteelbar'},
        {'', 'default:cobaltsteelbar', 'default:cobaltsteelbar'},
        {'default:cobaltsteelbar', 'default:cobaltsteelbar', 'default:cobaltsteelbar'}
    },
})

-- cobaltsteelbar Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_csteel 6',
    recipe = {
        {'', 'default:cobaltsteelbar', ''},
        {'default:cobaltsteelbar', 'default:cobaltsteelbar', 'default:cobaltsteelbar'}
    },
})

-- cobaltsteelbar Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_csteel 6',
    recipe = {
        {'', 'default:cobaltsteelbar', ''},
        {'default:cobaltsteelbar', '', 'default:cobaltsteelbar'},
        {'default:cobaltsteelbar', 'default:cobaltsteelbar', 'default:cobaltsteelbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_csteel 6',
    recipe = {
        {'default:cobaltsteelbar', 'default:cobaltsteelbar', 'default:cobaltsteelbar'}
    },
})
-- chrome Stairs
minetest.register_craft({
    output = 'stairs:stair_chrome 6',
    recipe = {
        {'', '', 'default:chromebar'},
        {'', 'default:chromebar', 'default:chromebar'},
        {'default:chromebar', 'default:chromebar', 'default:chromebar'}
    },
})

-- chromebar Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_chrome 6',
    recipe = {
        {'', 'default:chromebar', ''},
        {'default:chromebar', 'default:chromebar', 'default:chromebar'}
    },
})

-- chromebar Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_chrome 6',
    recipe = {
        {'', 'default:chromebar', ''},
        {'default:chromebar', '', 'default:chromebar'},
        {'default:chromebar', 'default:chromebar', 'default:chromebar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_chrome 6',
    recipe = {
        {'default:chromebar', 'default:chromebar', 'default:chromebar'}
    },
})


-- platinum Stairs
minetest.register_craft({
    output = 'stairs:stair_platinum 6',
    recipe = {
        {'', '', 'default:platinumbar'},
        {'', 'default:platinumbar', 'default:platinumbar'},
        {'default:platinumbar', 'default:platinumbar', 'default:platinumbar'}
    },
})

-- platinumbar Inner Stairs
minetest.register_craft({
    output = 'stairs:stair_inner_platinum 6',
    recipe = {
        {'', 'default:platinumbar', ''},
        {'default:platinumbar', 'default:platinumbar', 'default:platinumbar'}
    },
})

-- platinumbar Outer Stairs
minetest.register_craft({
    output = 'stairs:stair_outer_platinum 6',
    recipe = {
        {'', 'default:platinumbar', ''},
        {'default:platinumbar', '', 'default:platinumbar'},
        {'default:platinumbar', 'default:platinumbar', 'default:platinumbar'}
    },
})	
-- Slabs are forever <3

minetest.register_craft({
    output = 'stairs:slab_platinum 6',
    recipe = {
        {'default:platinumbar', 'default:platinumbar', 'default:platinumbar'}
    },
})

-- Flag to indicate whether time is currently being fast-forwarded
local is_fast_forwarding = false

-- Function to fast-forward time
local function fast_forward_time(add_time)
    if is_fast_forwarding then
        return "Already fast-forwarding time."
    end

    is_fast_forwarding = true

    local increment = 10 -- in-game minutes
    local steps = math.floor(add_time / increment)
    local elapsed_steps = 0

    local function step_time()
        if elapsed_steps >= steps then
            is_fast_forwarding = false
            return
        end

        local current_time = minetest.get_timeofday()
        local new_time = current_time + (increment / 24000)
        minetest.set_timeofday(new_time % 1.0)

        elapsed_steps = elapsed_steps + 1
        minetest.after(0.1, step_time)
    end

    minetest.after(0.1, step_time)

    return "Fast-forwarding time by " .. add_time .. " in-game minutes."
end

-- Register the /fastforward command
minetest.register_chatcommand("fastforward", {
    params = "<time>",
    description = "Fast forward time by the specified in-game minutes.",
    privs = {server=true},
    func = function(player_name, time_str)
        local add_time = tonumber(time_str)
        if not add_time then
            return false, "Invalid time. Please provide a number."
        end

        local result = fast_forward_time(add_time)
        return true, result
    end
})

		minetest.register_decoration({
		decoration = "default:salt",
		deco_type = "simple",
		place_on = "default:sand",
		biomes = {"grassland", "badlands", "islands_hot"},
		spawn_by = "default:sand",
		num_spawn_by = 1,
		fill_ratio = 0.05,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
		y_min = 1,
		y_max = 31000,
	})
	
	
		minetest.register_decoration({
		decoration = "default:salt",
		deco_type = "simple",
		place_on = "default:desert_sand",
		spawn_by = "default:desert_sand",
		num_spawn_by = 1,
		fill_ratio = 0.001,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
		y_min = 1,
		y_max = 31000,
	})

		minetest.register_decoration({
		decoration = "default:salt",
		deco_type = "simple",
		place_on = "default:shale",
		spawn_by = "default:shale",
		num_spawn_by = 1,
		fill_ratio = 0.001,
		place_offset_y = -1,
		flags = "place_center_x, place_center_z, force_placement",
		y_min = -30001,
		y_max = 8754,
	})


minetest.register_craft({
    output = "beds:blanket",
    recipe = {
		{"group:wool", "group:wool", "group:wool"}
		}
		})

minetest.register_craft({
    output = "x_farming:bonemeal 2",
    recipe = {
		{"goblins:goblins_goblin_bone", "goblins:goblins_goblin_bone"}
		}
		})
		
minetest.register_craft({
    output = "default:canvas",
    recipe = {
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "default:paper", "default:stick"},
		{"default:stick", "default:stick", "default:stick"},
		}
		})
		
		minetest.register_craft({
	type = "cooking",
	output = "animalia:leather",
	recipe = "zombies:rotten_flesh",
})

-- ABM for making oil flammable
minetest.register_abm({
	nodenames = {"default:oil_source", "default:oil_flowing"},
	neighbors = {"default:torch", "fire:basic_flame"},
	interval = 2, -- How often this runs, in seconds
	chance = 1, -- The chance of this happening, 1 = always
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "fire:basic_flame"})
	end,
})

-- Function to check if node name contains "_with_coal"
local function has_coal_in_name(name)
    return string.find(name, "_with_coal") ~= nil
end

-- Listen for the node being placed
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    -- Check for torches being placed on any side of coal
    local nodes_around = {
        {x=pos.x+1, y=pos.y, z=pos.z}, {x=pos.x-1, y=pos.y, z=pos.z},
        {x=pos.x, y=pos.y+1, z=pos.z}, {x=pos.x, y=pos.y-1, z=pos.z},
        {x=pos.x, y=pos.y, z=pos.z+1}, {x=pos.x, y=pos.y, z=pos.z-1}
    }

    local is_torch_placed = newnode.name == "default:torch" or
                            newnode.name == "default:torch_wall" or
                            newnode.name == "default:torch_ceiling"

    for _, side_node_pos in pairs(nodes_around) do
        local side_node = minetest.get_node(side_node_pos)
        if is_torch_placed and has_coal_in_name(side_node.name) then
            minetest.after(0.1, function()
                tnt.boom(pos, {radius = 3})
            end)
            break -- Stop checking other sides if we've found coal
        end
    end
end)

minetest.register_chatcommand("tpnode", {
    params = "<node_name>",
    description = "Teleport to the nearest node of the specified type",
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        if param == "" then
            return false, "Please specify a node type"
        end

        local pos = player:get_pos()
        local node_pos = minetest.find_node_near(pos, 250, {param})

        if node_pos then
            player:set_pos(node_pos)
            return true, "Teleported to the nearest " .. param
        else
            return false, "No nodes of type '" .. param .. "' found nearby"
        end
    end,
})