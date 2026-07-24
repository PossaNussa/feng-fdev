
gates_long = {}

gates_long.register_gate = function( type_name, desc, tiles, craft_from)

	-- the closed version contains the string "fence" in its name - thus preventing mobs from jumping over
	-- Use ":modname:" prefix so registration works both during mod loading and inside
	-- register_on_mods_loaded callbacks (where get_current_modname() returns nil).
	minetest.register_node(":gates_long:fence_gate_closed_"..type_name, {
		description = desc.." fence gate (closed)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {tiles[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				-- horizontal wood
				{ -0.85, -0.25, -0.02, -0.005, -0.05,  0.02},
				{ -0.85,  0.15, -0.02, -0.005,  0.35,  0.02},

				{  0.005, -0.25, -0.02,  0.85, -0.05,  0.02},
				{  0.005,  0.15, -0.02,  0.85,  0.35,  0.02},

				-- vertical wood
				{ -0.80, -0.05, -0.02, -0.60,  0.15,  0.02},
				{  0.60, -0.05, -0.02,  0.80,  0.15,  0.02},

				{ -0.25, -0.05, -0.02, -0.05,  0.15,  0.02},
				{  0.05, -0.05, -0.02,  0.25,  0.15,  0.02},

				-- locking mechanism (top)
				{ -0.15,  0.32, -0.01,  0.15,  0.38,  0.01},
				-- locking mechanism (bottom)
				{ -0.15, -0.28, -0.01,  0.15, -0.22,  0.01},

				-- hinges for the horizontal wood
				{ -0.91, -0.24, -0.015, -0.84, -0.06,  0.015},
				{ -0.91,  0.16, -0.015, -0.84,  0.34,  0.015},

				{  0.84, -0.24, -0.015,  0.91, -0.06,  0.015},
				{  0.84,  0.16, -0.015,  0.91,  0.34,  0.015},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.85, -0.25, -0.1,  0.85,  0.35,  0.1},
			},
		},
                on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = "gates_long:gate_open_"..type_name, param2 = node.param2})
                end,
		is_ground_content = false,
	})


	-- the opened version allows cattle to pass (until it autocloses)
	minetest.register_node(":gates_long:gate_open_"..type_name, {
		description = desc.." fence gate (open)",
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {tiles[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "gates_long:fence_gate_closed_"..type_name,
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
		node_box = {
			type = "fixed",
			fixed = {
				-- horizontal wood
				{ -0.87, -0.25, -0.02, -0.83,  -0.05,  0.85},
				{ -0.87,  0.15, -0.02, -0.83,   0.35,  0.85},

				{  0.83, -0.25, -0.02,  0.87, -0.05,  0.85},
				{  0.83,  0.15, -0.02,  0.87,  0.35,  0.85},

				-- vertical wood
				{ -0.87, -0.05,  0.80, -0.83,  0.15,  0.60},
				{ -0.87, -0.05,  0.25, -0.83,  0.15,  0.05},

				{  0.83, -0.05,  0.80,  0.87,  0.15,  0.60},
				{  0.83, -0.05,  0.25,  0.87,  0.15,  0.05},

				-- locking mechanism (top) - they are only on one side
				{ -0.86,  0.32,  0.53, -0.84,  0.38,  0.83},
				-- locking mechanism (bottom) - these as well
				{ -0.86, -0.28,  0.53, -0.84, -0.22,  0.83},

				-- hinges for the horizontal wood (they remain the same)
				{ -0.91, -0.24, -0.015, -0.84, -0.06,  0.015},
				{ -0.91,  0.16, -0.015, -0.84,  0.34,  0.015},

				{  0.84, -0.24, -0.015,  0.91, -0.06,  0.015},
				{  0.84,  0.16, -0.015,  0.91,  0.34,  0.015},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.90, -0.25, 0,  0.90,  0.35,  0.50},
			},
		},
                on_rightclick = function(pos, node, puncher)
                    minetest.swap_node(pos, {name = "gates_long:fence_gate_closed_"..type_name, param2 = node.param2})
                end,
		is_ground_content = false,
	})


	-- automaticly close the gates again to prevent cattle from escaping
	minetest.register_abm({
		nodenames = {"gates_long:gate_open_"..type_name},
		interval = 5,
		chance = 1,
		action = function(pos, old_node)
			minetest.swap_node(pos, {name = "gates_long:fence_gate_closed_"..type_name, param2 = old_node.param2})
		end
	})

	minetest.register_craft({
		output = "gates_long:fence_gate_closed_"..type_name.." 2",
                recipe = {
                        { "default:steel_ingot", craft_from, "default:steel_ingot" },
                        { "",                    craft_from,         "" },
                }
        })
end


gates_long.register_gate( 'wood',      'wooden',    {'default_wood.png'},        "default:wood" )
gates_long.register_gate( 'junglewood','junglewood',{'default_junglewood.png'},  "default:junglewood" )
gates_long.register_gate( 'pine',      'pine',      {'default_pine_wood.png'},   "default:pine_wood" )
gates_long.register_gate( 'acacia',    'acacia',    {'default_acacia_wood.png'}, "default:acacia_wood" )
gates_long.register_gate( 'tree',      'tree',      {'default_tree.png^[transformR90'}, "default:tree" )

-- All remaining wood types from plank_splitting's list.
-- Registered on_mods_loaded so the tile is read directly from each node's
-- registered definition — no need to guess texture filenames, and missing
-- mods are skipped cleanly.
minetest.register_on_mods_loaded(function()
	local function first_tile(node_name)
		local ndef = minetest.registered_nodes[node_name]
		if not ndef or not ndef.tiles then return nil end
		local t = ndef.tiles[1]
		if type(t) == "string" then return t end
		if type(t) == "table"  then return t.name end
		return nil
	end

	local variants = {
		-- default
		{"aspen",                "aspen",                "default:aspen_wood"},
		-- moretrees
		{"moretrees_spruce",     "spruce",               "moretrees:spruce_planks"},
		{"moretrees_cedar",      "cedar",                "moretrees:cedar_planks"},
		{"moretrees_poplar",     "poplar",               "moretrees:poplar_planks"},
		{"moretrees_rubber",     "rubber tree",          "moretrees:rubber_tree_planks"},
		-- dynamic_trees
		{"bamboo",               "bamboo",               "dynamic_trees:bamboo_planks"},
		{"dt_dry",               "dry",                  "dynamic_trees:dry_planks"},
		-- variety
		{"baobab",               "baobab",               "variety:baobab_wood"},
		{"cypress",              "cypress",              "variety:cypress_wood"},
		{"redwood",              "redwood",              "variety:redwood"},
		{"variety_cherry",       "cherry",               "variety:cherry_wood"},
		{"darkforest",           "dark forest",          "variety:darkforest_wood"},
		{"frost_land",           "frost land",           "variety:frost_land_wood"},
		{"tropical_rainforest",  "tropical rainforest",  "variety:tropical_rainforest_wood"},
		{"autumn_forest",        "autumn forest",        "variety:autumn_forest_wood"},
		-- standalone mods
		{"maple",                "maple",                "maple:maple_wood"},
		{"oak",                  "oak",                  "oak:wood"},
		{"cherrytree",           "cherry tree",          "cherrytree:wood"},
		{"lemontree",            "lemon tree",           "lemontree:wood"},
		{"hollytree",            "holly",                "hollytree:wood"},
		{"chestnuttree",         "chestnut",             "chestnuttree:wood"},
		{"spruce_tree",          "spruce",               "spruce_tree:spruce_planks"},
		{"larch",                "larch",                "larch:wood"},
		{"sequoia",              "sequoia",              "sequoia:wood"},
		{"metasequoia",          "metasequoia",          "paleotest:metasequoia_wood"},
		-- swamp
		{"mangrove",             "mangrove",             "swamp:mangrove_wood"},
		-- naturalbiomes
		{"nb_olive",             "olive",                "naturalbiomes:olive_wood"},
		{"nb_acacia",            "naturalbiomes acacia", "naturalbiomes:acacia_wood"},
		{"nb_outback",           "outback",              "naturalbiomes:outback_wood"},
		{"nb_alder",             "alder",                "naturalbiomes:alder_wood"},
		{"nb_palm",              "palm",                 "naturalbiomes:palm_wood"},
		{"nb_pine",              "naturalbiomes pine",   "naturalbiomes:pine_wood"},
		{"nb_banana",            "banana",               "naturalbiomes:banana_wood"},
		{"nb_heath_birch",       "heath birch",          "naturalbiomes:heath_birch_wood"},
		{"nb_heath_juniper",     "heath juniper",        "naturalbiomes:heath_juniper_wood"},
		{"nb_heath_willow",      "heath willow",         "naturalbiomes:heath_willow_wood"},
		-- livingdesert
		{"ld_date_palm",         "date palm",            "livingdesert:date_palm_wood"},
		{"ld_pine",              "livingdesert pine",    "livingdesert:pine_wood"},
		{"ld_saxaul",            "saxaul",               "livingdesert:saxaul_wood"},
		-- aotearoa
		{"pohutukawa",           "pohutukawa",           "aotearoa:pohutukawa_wood"},
		{"kauri",                "kauri",                "aotearoa:kauri_wood"},
		{"karaka",               "karaka",               "aotearoa:karaka_wood"},
		{"rimu",                 "rimu",                 "aotearoa:rimu_wood"},
		{"totara",               "totara",               "aotearoa:totara_wood"},
		{"miro",                 "miro",                 "aotearoa:miro_wood"},
		{"kahikatea",            "kahikatea",            "aotearoa:kahikatea_wood"},
		{"tawa",                 "tawa",                 "aotearoa:tawa_wood"},
		{"black_beech",          "black beech",          "aotearoa:black_beech_wood"},
		{"kamahi",               "kamahi",               "aotearoa:kamahi_wood"},
		{"mountain_beech",       "mountain beech",       "aotearoa:mountain_beech_wood"},
		{"pahautea",             "pahautea",             "aotearoa:pahautea_wood"},
		{"kowhai",               "kowhai",               "aotearoa:kowhai_wood"},
		{"silver_beech",         "silver beech",         "aotearoa:silver_beech_wood"},
		{"black_maire",          "black maire",          "aotearoa:black_maire_wood"},
		{"hinau",                "hinau",                "aotearoa:hinau_wood"},
	}

	for _, v in ipairs(variants) do
		local type_name, desc, craft_from = v[1], v[2], v[3]
		local tile = first_tile(craft_from)
		if tile then
			gates_long.register_gate(type_name, desc, {tile}, craft_from)
		end
	end
end)
