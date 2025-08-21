
-- material properties table

-- h = probability of degradation (hardness) into lower quality material
-- r = probability of displacement (resistance) to a lower elevation
-- t = list of target materials, first one is default, others will be picked based on surroundings

return {
	-- default game materials
	["default:dirt"]
		= { h = 1.0, r = 1.0, t = { "default:dry_dirt", "default:mud", "defualt:clay" }},
	["default:mud"]
		= { h = 1.0, r = 1.0, t = { "default:liquid_mud_source", "default:silt", "default:desert_sand", "default:clay" }},
	["default:dirt_with_grass"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["livingdesert:coldsteppe_ground2"]
		= { h = 1.0, r = 1.0, t = { "livingdesert:coldsteppe_ground" }},
	["livingdesert:coldsteppe_ground"]
		= { h = 1.0, r = 1.0, t = { "default:sand", "livingdesert:coldsteppe_ground2" }},
	["always_greener:mud_with_grass"]
		= { h = 1.0, r = 1.0, t = { "default:mud" }},
	["default:silt"]
		= { h = 1.0, r = 1.5, t = { "etcetera:dust" }},
	["variety:meadow_dirt_with_grass"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["etcetera:dust"]
		= { h = 1.2, r = 2.0, t = { "etcetera:dust" }},
	["default:dirt_with_snow"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["default:dirt_with_rainforest_litter"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["default:dirt_with_coniferous_litter"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["default:dry_dirt"]
		= { h = 1.0, r = 1.0, t = { "default:silt" }},
	["default:dry_dirt_with_dry_grass"]
		= { h = 1.0, r = 1.0, t = { "default:dry_dirt" }},
	["default:permafrost"]
		= { h = 1.0, r = 1.0, t = { "default:dry_dirt", "default:gravel" }},
	["default:permafrost_with_moss"]
		= { h = 1.0, r = 1.0, t = { "default:permafrost_with_stones" }},
	["default:permafrost_with_stones"]
		= { h = 1.0, r = 1.0, t = { "default:permafrost" }},
	["default:sand"]
		= { h = 0.1, r = 1.0, t = { "etcetera:dust", "default:wet_sand", "livingdesert:coldsteppe_ground" }},
	["default:desert_sand"]
		= { h = 0.1, r = 1.0, t = { "etcetera:dust" }},
	["default:silver_sand"]
		= { h = 0.1, r = 1.0, t = { "etcetera:dust", "default:sand", "default:desert_sand" }},
	["default:gravel"]
		= { h = 0.15, r = 0.7, t = { "default:silver_sand" }},
	["default:clay"]
		= { h = 0.5, r = 0.3, t = { "default:saprolite" }},
	["default:saprolite"]
		= { h = 0.5, r = 0.3, t = { "default:silt" }},
	["default:sandstone"]
		= { h = 0.05, r = 0.05, t = { "default:scobble" }},
	["default:scobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:limecobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:limestone"]
		= { h = 0.05, r = 0.05, t = { "default:limecobble" }},
	["default:desert_sandstone"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:silver_sandstone"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:rhyolitecobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:cobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:mossycobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:desert_cobble"]
		= { h = 0.05, r = 0.05, t = { "default:gravel" }},
	["default:desert_stone"]
		= { h = 0.01, r = 0.01, t = { "default:desert_cobble" }},
	["default:stone"]
		= { h = 0.01, r = 0.01, t = { "default:rhyolitecobble", "default:desert_cobble" }},

	-- mg
	["mg:dirt_with_dry_grass"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},

	-- woodsoils
	["woodsoils:dirt_with_leaves_1"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},
	["woodsoils:dirt_with_leaves_2"]
		= { h = 1.0, r = 1.0, t = { "woodsoils:dirt_with_leaves_1" }},
	["woodsoils:grass_with_leaves_1"]
		= { h = 1.0, r = 1.0, t = { "woodsoils:dirt_with_leaves_2" }},
	["woodsoils:grass_with_leaves_2"]
		= { h = 1.0, r = 1.0, t = { "woodsoils:grass_with_leaves_1" }},

	-- dryplants
	["dryplants:grass_short"]
		= { h = 1.0, r = 1.0, t = { "default:dirt" }},

	-- moreores
	["moreores:mineral_mithril"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
	["moreores:mineral_silver"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
	["moreores:mineral_tin"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
	["moreores:mineral_tin"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},

	-- technic
	["technic:mineral_chromium"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
	["technic:mineral_uranium"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
	["technic:mineral_zinc"]
		= { h = 0.0001, r = 0.01, t = { "default:stone", "default:desert_stone" }},
}
