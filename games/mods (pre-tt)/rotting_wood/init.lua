dofile(minetest.get_modpath("rotting_wood") .. "/nodes.lua")

local conversion_table = {
	["default:tree"]        = "rotting_wood:rotten_tree",
	["default:wood"]        = "rotting_wood:rotten_wood",
	["default:aspen_tree"]  = "rotting_wood:rotten_aspen_tree",
	["default:aspen_wood"]  = "rotting_wood:rotten_aspen_wood",
	["default:pine_tree"]   = "rotting_wood:rotten_pine_tree",
	["default:pine_wood"]   = "rotting_wood:rotten_pine_wood",
	["default:acacia_tree"] = "rotting_wood:rotten_acacia_tree",
	["default:acacia_wood"] = "rotting_wood:rotten_acacia_wood",
	["default:jungletree"]  = "rotting_wood:rotten_jungletree",
	["default:junglewood"]  = "rotting_wood:rotten_junglewood",
	["livingjungle:saxaul_wood"] = "rotting_wood:rotten_acacia_wood",
	["moretrees:poplar_tree"]  = "rotting_wood:rotten_aspen_tree",
	["moretrees:poplar_wood"]  = "rotting_wood:rotten_aspen_wood",
	["moretrees:cedar_tree"]  = "rotting_wood:rotten_aspen_tree",
	["moretrees:cedar_wood"]  = "rotting_wood:rotten_aspen_wood",
	["livingdesert:date_palm_wood"] = "rotting_wood:rotten_wood",
	["livingdesert:date_palm_tree"] = "rotting_wood:rotten_tree"
}

local function abm_action(pos)
	local meta = minetest.get_meta(pos)
	local rotting = meta:get_int("rotting")
	rotting = rotting + 5
	if rotting >= 300 then
		local node = minetest.get_node(pos)
		local rotten_node = conversion_table[node.name]
		
		-- If node is not explicitly in the conversion table
		if not rotten_node then
			if minetest.get_item_group(node.name, "tree") > 0 then
				rotten_node = "rotting_wood:rotten_tree"
			elseif minetest.get_item_group(node.name, "wood") > 0 then
				rotten_node = "rotting_wood:rotten_wood"
			end
		end
		
		-- If there's a valid rotten_node, replace the current node
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

minetest.register_abm({
	label = "Wood rotting",
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
