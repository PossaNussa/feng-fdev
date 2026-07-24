-- plank_splitting: Break isolated placed logs with an axe to get planks

-- Section A: Tree-to-plank mapping
-- Each entry: { tree_node, plank_node, count, craft_type }
-- craft_type: "normal" or "shapeless" (must match how the recipe was registered)

local split_map = {
	-- default
	{"default:tree",              "default:wood",         4, "normal"},
	{"default:jungletree",        "default:junglewood",   4, "normal"},
	{"default:pine_tree",         "default:pine_wood",    4, "normal"},
	{"default:acacia_tree",       "default:acacia_wood",  4, "normal"},
	{"default:aspen_tree",        "default:aspen_wood",   4, "normal"},
	{"default:bush_stem",         "default:wood",         1, "normal"},
	{"default:acacia_bush_stem",  "default:acacia_wood",  1, "normal"},
	{"default:pine_bush_stem",    "default:pine_wood",    1, "normal"},

	-- moretrees (shapeless crafts)
	{"moretrees:spruce_trunk",             "moretrees:spruce_planks",      4, "shapeless"},
	{"moretrees:cedar_trunk",              "moretrees:cedar_planks",       4, "shapeless"},
	{"moretrees:poplar_trunk",             "moretrees:poplar_planks",      4, "shapeless"},
	{"moretrees:rubber_tree_trunk",        "moretrees:rubber_tree_planks", 4, "shapeless"},
	{"moretrees:rubber_tree_trunk_empty",  "moretrees:rubber_tree_planks", 4, "shapeless"},

	-- dynamic_trees (bamboo sizes + dry tree)
	{"dynamic_trees:bamboo_2x2",  "dynamic_trees:bamboo_planks", 1, "normal"},
	{"dynamic_trees:bamboo_4x4",  "dynamic_trees:bamboo_planks", 2, "normal"},
	{"dynamic_trees:bamboo_6x6",  "dynamic_trees:bamboo_planks", 3, "normal"},
	{"dynamic_trees:bamboo_8x8",  "dynamic_trees:bamboo_planks", 4, "normal"},
	{"dynamic_trees:dry_tree",    "dynamic_trees:dry_planks",    4, "normal"},

	-- variety
	{"variety:baobab_tree",              "variety:baobab_wood",              4, "normal"},
	{"variety:cypress_tree",             "variety:cypress_wood",             4, "normal"},
	{"variety:redwood_tree",             "variety:redwood",                  4, "normal"},
	{"variety:cherry_tree",              "variety:cherry_wood",              4, "normal"},
	{"variety:darkforest_tree",          "variety:darkforest_wood",          4, "normal"},
	{"variety:frost_land_tree",          "variety:frost_land_wood",          4, "normal"},
	{"variety:tropical_rainforest_tree", "variety:tropical_rainforest_wood", 4, "normal"},
	{"variety:autumn_forest_tree",       "variety:autumn_forest_wood",       4, "normal"},

	-- standalone tree mods
	{"maple:maple_tree",          "maple:maple_wood",          4, "normal"},
	{"oak:trunk",                 "oak:wood",                  4, "normal"},
	{"cherrytree:trunk",          "cherrytree:wood",           4, "normal"},
	{"lemontree:trunk",           "lemontree:wood",            4, "normal"},
	{"lemontree:trunk_nobark",    "lemontree:wood",            4, "normal"},
	{"hollytree:trunk",           "hollytree:wood",            4, "normal"},
	{"chestnuttree:trunk",        "chestnuttree:wood",         4, "normal"},
	{"spruce_tree:spruce_tree",   "spruce_tree:spruce_planks", 4, "normal"},
	{"larch:trunk",               "larch:wood",                4, "normal"},
	{"sequoia:trunk",             "sequoia:wood",              4, "normal"},
	{"paleotest:metasequoia_tree","paleotest:metasequoia_wood", 4, "normal"},

	-- swamp
	{"swamp:mangrove_tree", "swamp:mangrove_wood", 4, "normal"},

	-- naturalbiomes
	{"naturalbiomes:olive_trunk",         "naturalbiomes:olive_wood",         4, "normal"},
	{"naturalbiomes:acacia_trunk",        "naturalbiomes:acacia_wood",        4, "normal"},
	{"naturalbiomes:outback_trunk",       "naturalbiomes:outback_wood",       4, "normal"},
	{"naturalbiomes:alder_trunk",         "naturalbiomes:alder_wood",         4, "normal"},
	{"naturalbiomes:palm_trunk",          "naturalbiomes:palm_wood",          4, "normal"},
	{"naturalbiomes:pine_trunk",          "naturalbiomes:pine_wood",          4, "normal"},
	{"naturalbiomes:banana_trunk",        "naturalbiomes:banana_wood",        4, "normal"},
	{"naturalbiomes:heath_birch_trunk",   "naturalbiomes:heath_birch_wood",   4, "normal"},
	{"naturalbiomes:heath_juniper_trunk", "naturalbiomes:heath_juniper_wood", 4, "normal"},
	{"naturalbiomes:heath_willow_trunk",  "naturalbiomes:heath_willow_wood",  4, "normal"},

	-- livingdesert
	{"livingdesert:date_palm_trunk", "livingdesert:date_palm_wood", 4, "normal"},
	{"livingdesert:pine_trunk",      "livingdesert:pine_wood",      4, "normal"},
	{"livingdesert:saxaul_trunk",    "livingdesert:saxaul_wood",    4, "normal"},

	-- aotearoa
	{"aotearoa:pohutukawa_tree",    "aotearoa:pohutukawa_wood",    4, "normal"},
	{"aotearoa:kauri_tree",         "aotearoa:kauri_wood",         4, "normal"},
	{"aotearoa:karaka_tree",        "aotearoa:karaka_wood",        4, "normal"},
	{"aotearoa:rimu_tree",          "aotearoa:rimu_wood",          4, "normal"},
	{"aotearoa:totara_tree",        "aotearoa:totara_wood",        4, "normal"},
	{"aotearoa:miro_tree",          "aotearoa:miro_wood",          4, "normal"},
	{"aotearoa:kahikatea_tree",     "aotearoa:kahikatea_wood",     4, "normal"},
	{"aotearoa:tawa_tree",          "aotearoa:tawa_wood",          4, "normal"},
	{"aotearoa:black_beech_tree",   "aotearoa:black_beech_wood",   4, "normal"},
	{"aotearoa:kamahi_tree",        "aotearoa:kamahi_wood",        4, "normal"},
	{"aotearoa:mountain_beech_tree","aotearoa:mountain_beech_wood",4, "normal"},
	{"aotearoa:pahautea_tree",      "aotearoa:pahautea_wood",      4, "normal"},
	{"aotearoa:kowhai_tree",        "aotearoa:kowhai_wood",        4, "normal"},
	{"aotearoa:silver_beech_tree",  "aotearoa:silver_beech_wood",  4, "normal"},
	{"aotearoa:black_maire_tree",   "aotearoa:black_maire_wood",   4, "normal"},
	{"aotearoa:hinau_tree",         "aotearoa:hinau_wood",         4, "normal"},
}

-- Section B: Mark player-placed logs
-- Pre-build lookup set for O(1) checks in the placenode callback
local split_lookup = {}
for _, entry in ipairs(split_map) do
	split_lookup[entry[1]] = true
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if split_lookup[newnode.name] then
		minetest.get_meta(pos):set_int("player_placed", 1)
	end
end)

-- Section C: Helper functions

local function is_isolated(pos)
	local offsets = {
		{x=1,y=0,z=0}, {x=-1,y=0,z=0},
		{x=0,y=1,z=0}, {x=0,y=-1,z=0},
		{x=0,y=0,z=1}, {x=0,y=0,z=-1},
	}
	for _, d in ipairs(offsets) do
		local neighbor = minetest.get_node({x=pos.x+d.x, y=pos.y+d.y, z=pos.z+d.z})
		local ndef = minetest.registered_nodes[neighbor.name]
		if ndef and ndef.groups and ndef.groups.tree and ndef.groups.tree > 0 then
			return false
		end
	end
	return true
end

local function is_upright(node)
	local ndef = minetest.registered_nodes[node.name]
	if not ndef then return false end
	if ndef.paramtype2 ~= "facedir" and ndef.paramtype2 ~= "colorfacedir" then
		return true  -- non-facedir nodes (e.g. plantlike bush stems) always pass
	end
	return (node.param2 % 24) < 4
end

-- Section D: Override on_dig and remove crafting recipes

minetest.register_on_mods_loaded(function()
	for _, entry in ipairs(split_map) do
		local tree_name  = entry[1]
		local plank_name = entry[2]
		local count      = entry[3]
		local craft_type = entry[4]

		-- Skip entries where the tree node doesn't exist
		if not minetest.registered_nodes[tree_name] then
			goto continue
		end

		-- Remove the tree-to-plank crafting recipe
		if craft_type == "shapeless" then
			pcall(minetest.clear_craft, {type = "shapeless", recipe = {tree_name}})
		else
			pcall(minetest.clear_craft, {recipe = {{tree_name}}})
		end

		-- Save old on_dig and override with plank-splitting logic
		local old_on_dig = minetest.registered_nodes[tree_name].on_dig

		minetest.override_item(tree_name, {
			on_dig = function(pos, node, digger)
				local meta = minetest.get_meta(pos)
				if meta:get_int("player_placed") == 1
						and is_isolated(pos)
						and is_upright(node) then
					-- Plank split
					minetest.remove_node(pos)
					core.handle_node_drops(pos, {ItemStack(plank_name .. " " .. count)}, digger)
					-- Apply tool wear
					if digger and digger:is_player() then
						local tool = digger:get_wielded_item()
						local tool_def = tool:get_definition()
						if tool_def and tool_def.tool_capabilities then
							local tp = tool_def.tool_capabilities
							local ndef = minetest.registered_nodes[tree_name]
							local choppy = ndef and ndef.groups and ndef.groups.choppy or 1
							local uses = tp.groupcaps and tp.groupcaps.choppy
									and tp.groupcaps.choppy.uses or 0
							local maxlevel = tp.groupcaps and tp.groupcaps.choppy
									and tp.groupcaps.choppy.maxlevel or 0
							if uses > 0 then
								local wear = math.ceil(65535 / (uses * math.pow(3, maxlevel - choppy)))
								tool:add_wear(wear)
								digger:set_wielded_item(tool)
							end
						end
					end
					return
				end
				-- Normal dig: fall through to original on_dig or default
				if old_on_dig then
					return old_on_dig(pos, node, digger)
				else
					return minetest.node_dig(pos, node, digger)
				end
			end,
		})

		::continue::
	end
end)
