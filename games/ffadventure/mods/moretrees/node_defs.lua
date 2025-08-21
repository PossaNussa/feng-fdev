local S = minetest.get_translator("moretrees")

moretrees.avoidnodes = {}

moretrees.treelist = {
	{"spruce",       S("Spruce Tree"),    "spruce_cone",          S("Spruce Cone"), {-0.2, -0.5, -0.2, 0.2, 0, 0.2}, 0.8 },
	{"cedar",        S("Cedar Tree"),     "cedar_cone",           S("Cedar Cone"), {-0.2, -0.5, -0.2, 0.2, 0, 0.2}, 0.8 },
	{"poplar",       S("Poplar Tree")},
	{"rubber_tree",  S("Rubber Tree")},
	{"poplar_small", S("Poplar Tree")},
}

moretrees.treedesc = {
	spruce = {
		trunk = S("Spruce Tree Trunk"),
		planks = S("Spruce Tree Planks"),
		sapling = S("Spruce Tree Sapling"),
		leaves = S("Spruce Tree Leaves"),
		trunk_stair = S("Spruce Tree Trunk Stair"),
		trunk_slab = S("Spruce Tree Trunk Slab"),
		planks_stair = S("Spruce Tree Planks Stair"),
		planks_slab = S("Spruce Tree Planks Slab"),
		fence = S("Spruce Tree Fence"),
		fence_rail = S("Spruce Tree Fence Rail"),
		fence_gate = S("Spruce Tree Fence Gate"),
	},
	cedar =  {
		trunk = S("Cedar Tree Trunk"),
		planks = S("Cedar Tree Planks"),
		sapling = S("Cedar Tree Sapling"),
		leaves = S("Cedar Tree Leaves"),
		trunk_stair = S("Cedar Tree Trunk Stair"),
		trunk_slab = S("Cedar Tree Trunk Slab"),
		planks_stair = S("Cedar Tree Planks Stair"),
		planks_slab = S("Cedar Tree Planks Slab"),
		fence = S("Cedar Tree Fence"),
		fence_rail = S("Cedar Tree Fence Rail"),
		fence_gate = S("Cedar Tree Fence Gate"),
	},
	poplar = {
		trunk = S("Poplar Tree Trunk"),
		planks = S("Poplar Tree Planks"),
		sapling = S("Poplar Tree Sapling"),
		leaves = S("Poplar Tree Leaves"),
		trunk_stair = S("Poplar Tree Trunk Stair"),
		trunk_slab = S("Poplar Tree Trunk Slab"),
		planks_stair = S("Poplar Tree Planks Stair"),
		planks_slab = S("Poplar Tree Planks Slab"),
		fence = S("Poplar Tree Fence"),
		fence_rail = S("Poplar Tree Fence Rail"),
		fence_gate = S("Poplar Tree Fence Gate"),
	},
	
	rubber_tree = {
		trunk = S("Rubber Tree Trunk"),
		planks = S("Rubber Tree Planks"),
		sapling = S("Rubber Tree Sapling"),
		leaves = S("Rubber Tree Leaves"),
		trunk_stair = S("Rubber Tree Trunk Stair"),
		trunk_slab = S("Rubber Tree Trunk Slab"),
		planks_stair = S("Rubber Tree Planks Stair"),
		planks_slab = S("Rubber Tree Planks Slab"),
		fence = S("Rubber Tree Fence"),
		fence_rail = S("Rubber Tree Fence Rail"),
		fence_gate = S("Rubber Tree Fence Gate"),
	},
	poplar_small = {
		sapling = S("Small poplar Tree Sapling"),
	},
}


-- local dirs1 = { 21, 20, 23, 22, 21 }
local dirs2 = { 12, 9, 18, 7, 12 }
-- local dirs3 = { 14, 11, 16, 5, 14 }

local moretrees_new_leaves_drawtype = "allfaces_optional"
local moretrees_plantlike_leaves_visual_scale = 1

if moretrees.plantlike_leaves then
	moretrees_new_leaves_drawtype = "plantlike"
	moretrees_plantlike_leaves_visual_scale = math.sqrt(2)
end

for i in ipairs(moretrees.treelist) do
	local treename = moretrees.treelist[i][1]
	local fruit = moretrees.treelist[i][3]
	local fruitdesc = moretrees.treelist[i][4]
	local selbox = moretrees.treelist[i][5]
	local vscale = moretrees.treelist[i][6]

	local saptex = moretrees.treelist[i][7]

	-- player will get a sapling with 1/100 chance
	-- player will get leaves only if he/she gets no saplings,
	-- this is because max_items is 1

	local droprarity = 100
	local decay = moretrees.leafdecay_radius

	if treename == "palm" then
		droprarity = 20
		decay = moretrees.palm_leafdecay_radius
	elseif treename == "date_palm" then
		decay = moretrees.date_palm_leafdecay_radius
	end

	-- dont register planks/nodes for trees from default and small varients for trees
	local split_tn = treename:split("_")
	if treename ~= "jungletree" and treename ~= "pine" and split_tn[2]~="small" then

		saptex = "moretrees_"..treename.."_sapling.png"

		minetest.register_node("moretrees:"..treename.."_trunk", {
			description = moretrees.treedesc[treename].trunk,
			tiles = {
				"moretrees_"..treename.."_trunk_top.png",
				"moretrees_"..treename.."_trunk_top.png",
				"moretrees_"..treename.."_trunk.png"
			},
			paramtype2 = "facedir",
			is_ground_content = false,
			groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})

		minetest.register_node("moretrees:"..treename.."_planks", {
			description = moretrees.treedesc[treename].planks,
			tiles = {"moretrees_"..treename.."_wood.png"},
			is_ground_content = false,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
			sounds = default.node_sound_wood_defaults(),
		})

		local moretrees_leaves_inventory_image = nil
		local moretrees_new_leaves_waving = nil

		if moretrees.plantlike_leaves then
			moretrees_leaves_inventory_image = minetest.inventorycube("moretrees_"..treename.."_leaves.png")
		else
			moretrees_new_leaves_waving = 1
		end

		minetest.register_node("moretrees:"..treename.."_leaves", {
			description = moretrees.treedesc[treename].leaves,
			drawtype = moretrees_new_leaves_drawtype,
			waving = moretrees_new_leaves_waving,
			visual_scale = moretrees_plantlike_leaves_visual_scale,
			tiles = { "moretrees_"..treename.."_leaves.png" },
			inventory_image = moretrees_leaves_inventory_image,
			paramtype = "light",
			is_ground_content = false,
			groups = {snappy = 3, flammable = 2, leaves = 1, moretrees_leaves = 1, leafdecay = 1},
			sounds = default.node_sound_leaves_defaults(),

			drop = {
				max_items = 1,
				items = {
					{items = {"moretrees:"..treename.."_sapling"}, rarity = droprarity },
					{items = {"moretrees:"..treename.."_leaves"} }
				}
			},
		})

		if moretrees.enable_stairs then
			if minetest.get_modpath("moreblocks") then

	--			stairsplus:register_all(modname, subname, recipeitem, {fields})

				stairsplus:register_all(
					"moretrees",
					treename.."_trunk",
					"moretrees:"..treename.."_trunk",
					{
						groups = { snappy=1, choppy=2, oddly_breakable_by_hand=1, flammable=2, not_in_creative_inventory=1 },
						tiles =	{
							"moretrees_"..treename.."_trunk_top.png",
							"moretrees_"..treename.."_trunk_top.png",
							"moretrees_"..treename.."_trunk.png"
						},
						description = moretrees.treedesc[treename].trunk,
						drop = treename.."_trunk",
					}
				)

				stairsplus:register_all(
					"moretrees",
					treename.."_planks",
					"moretrees:"..treename.."_planks",
					{
						groups = { snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=3, not_in_creative_inventory=1 },
						tiles = { "moretrees_"..treename.."_wood.png" },
						description = moretrees.treedesc[treename].planks,
						drop = treename.."_planks",
					}
				)
			elseif minetest.get_modpath("stairs") then
				stairs.register_stair_and_slab(
					"moretrees_"..treename.."_trunk",
					"moretrees:"..treename.."_trunk",
					{ snappy=1, choppy=2, oddly_breakable_by_hand=1, flammable=2 },
					{	"moretrees_"..treename.."_trunk_top.png",
						"moretrees_"..treename.."_trunk_top.png",
						"moretrees_"..treename.."_trunk.png"
					},
					moretrees.treedesc[treename].trunk_stair,
					moretrees.treedesc[treename].trunk_slab,
					default.node_sound_wood_defaults()
				)

				stairs.register_stair_and_slab(
					"moretrees_"..treename.."_planks",
					"moretrees:"..treename.."_planks",
					{ snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=3 },
					{ "moretrees_"..treename.."_wood.png" },
					moretrees.treedesc[treename].planks_stair,
					moretrees.treedesc[treename].planks_slab,
					default.node_sound_wood_defaults()
				)

			end
		end

		if moretrees.enable_fences then
			local planks_name = "moretrees:" .. treename .. "_planks"
			local planks_tile = "moretrees_" .. treename .. "_wood.png"
			default.register_fence("moretrees:" .. treename .. "_fence", {
				description = moretrees.treedesc[treename].fence,
				texture = planks_tile,
				inventory_image = "default_fence_overlay.png^" .. planks_tile ..
										"^default_fence_overlay.png^[makealpha:255,126,126",
				wield_image = "default_fence_overlay.png^" .. planks_tile ..
										"^default_fence_overlay.png^[makealpha:255,126,126",
				material = planks_name,
				groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
				sounds = default.node_sound_wood_defaults()
			})
			default.register_fence_rail("moretrees:" .. treename .. "_fence_rail", {
				description = moretrees.treedesc[treename].fence_rail,
				texture = planks_tile,
				inventory_image = "default_fence_rail_overlay.png^" .. planks_tile ..
										"^default_fence_rail_overlay.png^[makealpha:255,126,126",
				wield_image = "default_fence_rail_overlay.png^" .. planks_tile ..
										"^default_fence_rail_overlay.png^[makealpha:255,126,126",
				material = planks_name,
				groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
				sounds = default.node_sound_wood_defaults()
			})
			if minetest.global_exists("doors") then
				doors.register_fencegate("moretrees:" .. treename .. "_gate", {
					description = moretrees.treedesc[treename].fence_gate,
					texture = planks_tile,
					material = planks_name,
					groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
				})
			end
		end
	end

	-- the default game provides jungle tree and pine saplings.
	if treename~="jungletree" and treename ~= "pine" then
		local regular_groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1}
		if minetest.settings:get_bool("creative_mode", false) then
			regular_groups["not_in_creative_inventory"]=1
		end

		minetest.register_node("moretrees:"..treename.."_sapling", {
			description = moretrees.treedesc[treename].sapling,
			drawtype = "plantlike",
			tiles = {split_tn[2] and split_tn[2]=="small" and "moretrees_" .. treename .. "_sapling.png" or saptex},
			inventory_image = split_tn[2] and split_tn[2]=="small" and "moretrees_" .. treename .. "_sapling.png" or saptex,
			paramtype = "light",
			paramtype2 = "waving",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = regular_groups,
			sounds = default.node_sound_defaults(),
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
					"moretrees:" ..treename.. "_sapling",
					-- minp, maxp to be checked, relative to sapling pos
					-- minp_relative.y = 1 because sapling pos has been checked
					{x = -3, y = 1, z = -3},
					{x = 3, y = 6, z = 3},
					-- maximum interval of interior volume check
					4)

				return itemstack
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(300)
			end,
			on_timer = function(pos, elapsed)
				if moretrees.can_grow(pos, treename) then
					--moretrees["grow_" .. treename](pos)
					minetest.set_node(pos, {name="air"})
					if type(moretrees["spawn_" .. treename .. "_object"])=="string" then
						local split = moretrees["spawn_" .. treename .. "_object"]:split(".")
						moretrees[split[2]](pos)
					else
						minetest.spawn_tree(pos, moretrees["spawn_" .. treename .. "_object"])
					end
				else
					minetest.get_node_timer(pos):start(300)
				end
			end,
		})
	end

	local ongen_groups = {
		snappy = 2,
		dig_immediate = 3,
		flammable = 2,
		attached_node = 1,
		sapling = 1,
		moretrees_ongen = 1,
		not_in_creative_inventory = 1
	}
	if minetest.settings:get_bool("creative_mode", false) then
		ongen_groups["not_in_creative_inventory"]=nil
	end
	minetest.register_node("moretrees:"..treename.."_sapling_ongen", {
		description = S("@1 (fast growth)", moretrees.treedesc[treename].sapling),
		drawtype = "plantlike",
		tiles = {split_tn[2] and split_tn[2]=="small" and "moretrees_" .. treename .. "_sapling.png" or saptex,},
		inventory_image = split_tn[2] and split_tn[2]=="small" and "moretrees_" .. treename .. "_sapling.png" or saptex,
		paramtype = "light",
		paramtype2 = "waving",
		walkable = false,
		is_ground_content = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
		},
		groups = ongen_groups,
		sounds = default.node_sound_defaults(),
		drop = "moretrees:"..treename.."_sapling",
		on_place = function(itemstack, placer, pointed_thing)
			itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
				"moretrees:" ..treename.. "_sapling_ongen",
				-- minp, maxp to be checked, relative to sapling pos
				-- minp_relative.y = 1 because sapling pos has been checked
				{x = -3, y = 1, z = -3},
				{x = 3, y = 6, z = 3},
				-- maximum interval of interior volume check
				4)

			return itemstack
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(2)
		end,
		on_timer = function(pos, elapsed)
			if moretrees.can_grow(pos, treename) then
				--moretrees["grow_" .. treename](pos)
				minetest.set_node(pos, {name="air"})
				if type(moretrees["spawn_" .. treename .. "_object"])=="string" then
					local split = moretrees["spawn_" .. treename .. "_object"]:split(".")
					moretrees[split[2]](pos)
				else
					minetest.spawn_tree(pos, moretrees["spawn_" .. treename .. "_object"])
				end
			else
				minetest.get_node_timer(pos):start(300)
			end
		end,
	})

	local fruitname = nil
	if fruit then
		fruitname = "moretrees:"..fruit
		minetest.register_node(fruitname, {
			description = fruitdesc,
			drawtype = "plantlike",
			tiles = { "moretrees_"..fruit..".png" },
			inventory_image = "moretrees_"..fruit..".png^[transformR180",
			wield_image = "moretrees_"..fruit..".png^[transformR180",
			visual_scale = vscale,
			paramtype = "light",
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = false,
			selection_box = {
				type = "fixed",
					fixed = selbox
				},
			groups = {fleshy=3,dig_immediate=3,flammable=2, attached_node=1, leafdecay = 1, leafdecay_drop = 1},
			sounds = default.node_sound_defaults(),
			after_place_node = function(pos, placer)
				if placer:is_player() then
					minetest.set_node(pos, {name = "moretrees:"..fruit, param2 = 1})
				end
			end
		})
	end

	if treename ~= "jungletree"
		and treename ~= "poplar_small"
		and treename ~= "pine" then
			default.register_leafdecay({
				trunks = { "moretrees:"..treename.."_trunk" },
				leaves = { "moretrees:"..treename.."_leaves", fruitname },
				radius = decay,
			})
	end

	minetest.register_abm({
		nodenames = { "moretrees:"..treename.."_trunk_sideways" },
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local fdir = node.param2 or 0
				local nfdir = dirs2[fdir+1]
			minetest.add_node(pos, {name = "moretrees:"..treename.."_trunk", param2 = nfdir})
		end,
	})

	table.insert(moretrees.avoidnodes, "moretrees:"..treename.."_trunk")

	if moretrees.spawn_saplings then
			table.insert(moretrees.avoidnodes, "moretrees:"..treename.."_sapling")
			table.insert(moretrees.avoidnodes, "moretrees:"..treename.."_sapling_ongen")
	end
end
-- poplar saplings leaves
local poplar_leaves_drop = minetest.registered_nodes["moretrees:poplar_leaves"].drop
minetest.override_item("moretrees:poplar_leaves", {
	drop = {
		max_items = poplar_leaves_drop.max_items,
		items = {
			{items = {"moretrees:poplar_sapling"}, rarity = 1.33 * poplar_leaves_drop.items[1].rarity },
			{items = {"moretrees:poplar_small_sapling"}, rarity = 1.33 * poplar_leaves_drop.items[1].rarity },
			{items = {"moretrees:poplar_leaves"} }
		}
	}
})


-- "empty" (tapped) rubber tree nodes

minetest.register_node("moretrees:rubber_tree_trunk_empty", {
	description = S("Rubber Tree Trunk (Empty)"),
	tiles = {
		"moretrees_rubber_tree_trunk_top.png",
		"moretrees_rubber_tree_trunk_top.png",
		"moretrees_rubber_tree_trunk_empty.png"
	},
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	is_ground_content = false,
	on_place = minetest.rotate_node,
})

minetest.register_abm({
	nodenames = { "moretrees:rubber_tree_trunk_empty_sideways" },
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local fdir = node.param2 or 0
			local nfdir = dirs2[fdir+1]
		minetest.add_node(pos, {name = "moretrees:rubber_tree_trunk_empty", param2 = nfdir})
	end,
})

-- For compatibility with old nodes, recently-changed nodes, and default nodes

minetest.register_alias("technic:rubber_tree_full",				"moretrees:rubber_tree_trunk")
minetest.register_alias("farming_plus:rubber_tree_full",		"moretrees:rubber_tree_trunk")
minetest.register_alias("farming:rubber_tree_full",				"moretrees:rubber_tree_trunk")

minetest.register_alias("technic:rubber_leaves",				"moretrees:rubber_tree_leaves")
minetest.register_alias("farming_plus:rubber_leaves",			"moretrees:rubber_tree_leaves")
minetest.register_alias("farming:rubber_leaves",				"moretrees:rubber_tree_leaves")

minetest.register_alias("technic:rubber_tree_sapling",			"moretrees:rubber_tree_sapling")
minetest.register_alias("farming_plus:rubber_sapling",			"moretrees:rubber_tree_sapling")
minetest.register_alias("farming:rubber_sapling",				"moretrees:rubber_tree_sapling")

minetest.register_alias("moretrees:conifer_trunk",				"moretrees:fir_trunk")
minetest.register_alias("moretrees:conifer_trunk_sideways",		"moretrees:fir_trunk_sideways")
minetest.register_alias("moretrees:conifer_leaves",				"moretrees:fir_leaves")
minetest.register_alias("moretrees:conifer_leaves_bright",		"moretrees:fir_leaves_bright")
minetest.register_alias("moretrees:conifer_sapling",			"moretrees:fir_sapling")

minetest.register_alias("conifers:trunk",						"moretrees:fir_trunk")
minetest.register_alias("conifers:trunk_reversed",				"moretrees:fir_trunk_sideways")
minetest.register_alias("conifers:leaves",						"moretrees:fir_leaves")
minetest.register_alias("conifers:leaves_special",				"moretrees:fir_leaves_bright")
minetest.register_alias("conifers:sapling",						"moretrees:fir_sapling")

minetest.register_alias("moretrees:jungletree_sapling",			"default:junglesapling")
minetest.register_alias("moretrees:jungletree_trunk_sideways",	"moreblocks:horizontal_jungle_tree")
minetest.register_alias("moretrees:jungletree_planks",			"default:junglewood")
minetest.register_alias("moretrees:jungletree_leaves_green",	"default:jungleleaves")

minetest.register_alias("moretrees:acacia_trunk",				"default:acacia_tree")
minetest.register_alias("moretrees:acacia_planks",				"default:acacia_wood")
minetest.register_alias("moretrees:acacia_sapling",				"default:acacia_sapling")
minetest.register_alias("moretrees:acacia_leaves",				"default:acacia_leaves")

minetest.register_alias("moretrees:pine_trunk",					"moretrees:cedar_trunk")
minetest.register_alias("moretrees:pine_planks",				"moretrees:cedar_planks")
minetest.register_alias("moretrees:pine_sapling",				"moretrees:cedar_sapling")
minetest.register_alias("moretrees:pine_leaves",				"moretrees:cedar_leaves")
minetest.register_alias("moretrees:pine_cone",					"moretrees:cedar_cone")
minetest.register_alias("moretrees:pine_nuts",					"moretrees:cedar_nuts")
minetest.register_alias("moretrees:pine_sapling_ongen",			"moretrees:cedar_sapling_ongen")

minetest.register_alias("moretrees:dates",					"moretrees:dates_f4")
