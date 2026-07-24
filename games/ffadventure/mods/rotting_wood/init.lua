dofile(minetest.get_modpath("rotting_wood") .. "/nodes.lua")

-- Conversion table: source node → rotten replacement
-- Covers every tree/wood in the plank_splitting list plus defaults.
-- Unmapped nodes with group:tree fall back to rotten_tree,
-- unmapped group:wood fall back to rotten_wood.
local conversion_table = {
	-- default tree logs
	["default:tree"]             = "rotting_wood:rotten_tree",
	["default:jungletree"]       = "rotting_wood:rotten_jungletree",
	["default:pine_tree"]        = "rotting_wood:rotten_pine_tree",
	["default:acacia_tree"]      = "rotting_wood:rotten_acacia_tree",
	["default:aspen_tree"]       = "rotting_wood:rotten_aspen_tree",
	["default:bush_stem"]        = "rotting_wood:rotten_tree",
	["default:acacia_bush_stem"] = "rotting_wood:rotten_acacia_tree",
	["default:pine_bush_stem"]   = "rotting_wood:rotten_pine_tree",
	-- default planks
	["default:wood"]        = "rotting_wood:rotten_wood",
	["default:junglewood"]  = "rotting_wood:rotten_junglewood",
	["default:pine_wood"]   = "rotting_wood:rotten_pine_wood",
	["default:acacia_wood"] = "rotting_wood:rotten_acacia_wood",
	["default:aspen_wood"]  = "rotting_wood:rotten_aspen_wood",

	-- moretrees trunks (plank_splitting naming)
	["moretrees:spruce_trunk"]            = "rotting_wood:rotten_pine_tree",
	["moretrees:cedar_trunk"]             = "rotting_wood:rotten_pine_tree",
	["moretrees:poplar_trunk"]            = "rotting_wood:rotten_aspen_tree",
	["moretrees:rubber_tree_trunk"]       = "rotting_wood:rotten_jungletree",
	["moretrees:rubber_tree_trunk_empty"] = "rotting_wood:rotten_jungletree",
	-- moretrees planks
	["moretrees:spruce_planks"]      = "rotting_wood:rotten_pine_wood",
	["moretrees:cedar_planks"]       = "rotting_wood:rotten_pine_wood",
	["moretrees:poplar_planks"]      = "rotting_wood:rotten_aspen_wood",
	["moretrees:rubber_tree_planks"] = "rotting_wood:rotten_junglewood",
	-- legacy moretrees tree-structure node names
	["moretrees:poplar_tree"] = "rotting_wood:rotten_aspen_tree",
	["moretrees:poplar_wood"] = "rotting_wood:rotten_aspen_wood",
	["moretrees:cedar_tree"]  = "rotting_wood:rotten_pine_tree",
	["moretrees:cedar_wood"]  = "rotting_wood:rotten_pine_wood",

	-- dynamic_trees
	["dynamic_trees:bamboo_2x2"]    = "rotting_wood:rotten_tree",
	["dynamic_trees:bamboo_4x4"]    = "rotting_wood:rotten_tree",
	["dynamic_trees:bamboo_6x6"]    = "rotting_wood:rotten_tree",
	["dynamic_trees:bamboo_8x8"]    = "rotting_wood:rotten_tree",
	["dynamic_trees:dry_tree"]      = "rotting_wood:rotten_tree",
	["dynamic_trees:bamboo_planks"] = "rotting_wood:rotten_wood",
	["dynamic_trees:dry_planks"]    = "rotting_wood:rotten_wood",

	-- variety
	["variety:baobab_tree"]              = "rotting_wood:rotten_acacia_tree",
	["variety:cypress_tree"]             = "rotting_wood:rotten_pine_tree",
	["variety:redwood_tree"]             = "rotting_wood:rotten_pine_tree",
	["variety:cherry_tree"]              = "rotting_wood:rotten_aspen_tree",
	["variety:darkforest_tree"]          = "rotting_wood:rotten_tree",
	["variety:frost_land_tree"]          = "rotting_wood:rotten_pine_tree",
	["variety:tropical_rainforest_tree"] = "rotting_wood:rotten_jungletree",
	["variety:autumn_forest_tree"]       = "rotting_wood:rotten_aspen_tree",
	["variety:baobab_wood"]              = "rotting_wood:rotten_acacia_wood",
	["variety:cypress_wood"]             = "rotting_wood:rotten_pine_wood",
	["variety:redwood"]                  = "rotting_wood:rotten_pine_wood",
	["variety:cherry_wood"]              = "rotting_wood:rotten_aspen_wood",
	["variety:darkforest_wood"]          = "rotting_wood:rotten_wood",
	["variety:frost_land_wood"]          = "rotting_wood:rotten_pine_wood",
	["variety:tropical_rainforest_wood"] = "rotting_wood:rotten_junglewood",
	["variety:autumn_forest_wood"]       = "rotting_wood:rotten_aspen_wood",

	-- standalone tree mods
	["maple:maple_tree"]           = "rotting_wood:rotten_aspen_tree",
	["maple:maple_wood"]           = "rotting_wood:rotten_aspen_wood",
	["oak:trunk"]                  = "rotting_wood:rotten_tree",
	["oak:wood"]                   = "rotting_wood:rotten_wood",
	["cherrytree:trunk"]           = "rotting_wood:rotten_aspen_tree",
	["cherrytree:wood"]            = "rotting_wood:rotten_aspen_wood",
	["lemontree:trunk"]            = "rotting_wood:rotten_tree",
	["lemontree:trunk_nobark"]     = "rotting_wood:rotten_tree",
	["lemontree:wood"]             = "rotting_wood:rotten_wood",
	["hollytree:trunk"]            = "rotting_wood:rotten_aspen_tree",
	["hollytree:wood"]             = "rotting_wood:rotten_aspen_wood",
	["chestnuttree:trunk"]         = "rotting_wood:rotten_tree",
	["chestnuttree:wood"]          = "rotting_wood:rotten_wood",
	["spruce_tree:spruce_tree"]    = "rotting_wood:rotten_pine_tree",
	["spruce_tree:spruce_planks"]  = "rotting_wood:rotten_pine_wood",
	["larch:trunk"]                = "rotting_wood:rotten_pine_tree",
	["larch:wood"]                 = "rotting_wood:rotten_pine_wood",
	["sequoia:trunk"]              = "rotting_wood:rotten_pine_tree",
	["sequoia:wood"]               = "rotting_wood:rotten_pine_wood",
	["paleotest:metasequoia_tree"] = "rotting_wood:rotten_pine_tree",
	["paleotest:metasequoia_wood"] = "rotting_wood:rotten_pine_wood",

	-- swamp
	["swamp:mangrove_tree"] = "rotting_wood:rotten_jungletree",
	["swamp:mangrove_wood"] = "rotting_wood:rotten_junglewood",

	-- naturalbiomes
	["naturalbiomes:olive_trunk"]         = "rotting_wood:rotten_tree",
	["naturalbiomes:olive_wood"]          = "rotting_wood:rotten_wood",
	["naturalbiomes:acacia_trunk"]        = "rotting_wood:rotten_acacia_tree",
	["naturalbiomes:acacia_wood"]         = "rotting_wood:rotten_acacia_wood",
	["naturalbiomes:outback_trunk"]       = "rotting_wood:rotten_acacia_tree",
	["naturalbiomes:outback_wood"]        = "rotting_wood:rotten_acacia_wood",
	["naturalbiomes:alder_trunk"]         = "rotting_wood:rotten_aspen_tree",
	["naturalbiomes:alder_wood"]          = "rotting_wood:rotten_aspen_wood",
	["naturalbiomes:palm_trunk"]          = "rotting_wood:rotten_acacia_tree",
	["naturalbiomes:palm_wood"]           = "rotting_wood:rotten_acacia_wood",
	["naturalbiomes:pine_trunk"]          = "rotting_wood:rotten_pine_tree",
	["naturalbiomes:pine_wood"]           = "rotting_wood:rotten_pine_wood",
	["naturalbiomes:banana_trunk"]        = "rotting_wood:rotten_jungletree",
	["naturalbiomes:banana_wood"]         = "rotting_wood:rotten_junglewood",
	["naturalbiomes:heath_birch_trunk"]   = "rotting_wood:rotten_aspen_tree",
	["naturalbiomes:heath_birch_wood"]    = "rotting_wood:rotten_aspen_wood",
	["naturalbiomes:heath_juniper_trunk"] = "rotting_wood:rotten_pine_tree",
	["naturalbiomes:heath_juniper_wood"]  = "rotting_wood:rotten_pine_wood",
	["naturalbiomes:heath_willow_trunk"]  = "rotting_wood:rotten_tree",
	["naturalbiomes:heath_willow_wood"]   = "rotting_wood:rotten_wood",

	-- livingdesert
	["livingdesert:date_palm_tree"] = "rotting_wood:rotten_tree",
	["livingdesert:date_palm_wood"] = "rotting_wood:rotten_wood",
	["livingdesert:pine_trunk"]     = "rotting_wood:rotten_pine_tree",
	["livingdesert:pine_wood"]      = "rotting_wood:rotten_pine_wood",
	["livingdesert:saxaul_trunk"]   = "rotting_wood:rotten_tree",
	["livingdesert:saxaul_wood"]    = "rotting_wood:rotten_wood",

	-- aotearoa (NZ trees: conifers → pine, deciduous → aspen, hardwood → generic)
	["aotearoa:pohutukawa_tree"]     = "rotting_wood:rotten_tree",
	["aotearoa:pohutukawa_wood"]     = "rotting_wood:rotten_wood",
	["aotearoa:kauri_tree"]          = "rotting_wood:rotten_pine_tree",
	["aotearoa:kauri_wood"]          = "rotting_wood:rotten_pine_wood",
	["aotearoa:karaka_tree"]         = "rotting_wood:rotten_jungletree",
	["aotearoa:karaka_wood"]         = "rotting_wood:rotten_junglewood",
	["aotearoa:rimu_tree"]           = "rotting_wood:rotten_pine_tree",
	["aotearoa:rimu_wood"]           = "rotting_wood:rotten_pine_wood",
	["aotearoa:totara_tree"]         = "rotting_wood:rotten_pine_tree",
	["aotearoa:totara_wood"]         = "rotting_wood:rotten_pine_wood",
	["aotearoa:miro_tree"]           = "rotting_wood:rotten_pine_tree",
	["aotearoa:miro_wood"]           = "rotting_wood:rotten_pine_wood",
	["aotearoa:kahikatea_tree"]      = "rotting_wood:rotten_pine_tree",
	["aotearoa:kahikatea_wood"]      = "rotting_wood:rotten_pine_wood",
	["aotearoa:tawa_tree"]           = "rotting_wood:rotten_aspen_tree",
	["aotearoa:tawa_wood"]           = "rotting_wood:rotten_aspen_wood",
	["aotearoa:black_beech_tree"]    = "rotting_wood:rotten_tree",
	["aotearoa:black_beech_wood"]    = "rotting_wood:rotten_wood",
	["aotearoa:kamahi_tree"]         = "rotting_wood:rotten_tree",
	["aotearoa:kamahi_wood"]         = "rotting_wood:rotten_wood",
	["aotearoa:mountain_beech_tree"] = "rotting_wood:rotten_tree",
	["aotearoa:mountain_beech_wood"] = "rotting_wood:rotten_wood",
	["aotearoa:pahautea_tree"]       = "rotting_wood:rotten_pine_tree",
	["aotearoa:pahautea_wood"]       = "rotting_wood:rotten_pine_wood",
	["aotearoa:kowhai_tree"]         = "rotting_wood:rotten_aspen_tree",
	["aotearoa:kowhai_wood"]         = "rotting_wood:rotten_aspen_wood",
	["aotearoa:silver_beech_tree"]   = "rotting_wood:rotten_aspen_tree",
	["aotearoa:silver_beech_wood"]   = "rotting_wood:rotten_aspen_wood",
	["aotearoa:black_maire_tree"]    = "rotting_wood:rotten_tree",
	["aotearoa:black_maire_wood"]    = "rotting_wood:rotten_wood",
	["aotearoa:hinau_tree"]          = "rotting_wood:rotten_tree",
	["aotearoa:hinau_wood"]          = "rotting_wood:rotten_wood",

	-- misc
	["livingjungle:saxaul_wood"] = "rotting_wood:rotten_acacia_wood",
}

local function abm_action(pos)
	local meta = minetest.get_meta(pos)
	local rotting = meta:get_int("rotting")
	rotting = rotting + 5
	if rotting >= 300 then
		local node = minetest.get_node(pos)
		local rotten_node = conversion_table[node.name]

		-- Group fallback for unmapped nodes
		if not rotten_node then
			if minetest.get_item_group(node.name, "tree") > 0 then
				rotten_node = "rotting_wood:rotten_tree"
			elseif minetest.get_item_group(node.name, "wood") > 0 then
				rotten_node = "rotting_wood:rotten_wood"
			end
		end

		if rotten_node then
			minetest.set_node(pos, {name = rotten_node, param2 = node.param2})
		end
	else
		meta:set_int("rotting", rotting)
	end
end

local function lbm_action(pos)
	local meta = minetest.get_meta(pos)
	meta:set_int("rotting", 0)
end

minetest.register_lbm({
	label = "Set rotting metadata",
	name = "rotting_wood:set_rotting_metadata",
	nodenames = {"group:tree", "group:wood"},
	action = lbm_action
})

-- Rot wood adjacent to standing water (fast: ~5 min)
minetest.register_abm({
	label = "Wood rotting near water",
	nodenames = {"group:tree", "group:wood"},
	neighbors = {
		"default:water_source",
		"default:river_water_source",
		"default:water_flowing",
		"default:river_water_flowing"
	},
	interval = 5,
	chance = 1,
	action = abm_action
})

-- Rot wood adjacent to rain puddles (slow: ~2.5 hours of puddle exposure)
-- Uses group:weather_puddle so it's a no-op when regional_weather is absent.
minetest.register_abm({
	label = "Wood rotting near puddles",
	nodenames = {"group:tree", "group:wood"},
	neighbors = {"group:weather_puddle"},
	interval = 60,
	chance = 5,
	catch_up = false,
	action = abm_action
})
