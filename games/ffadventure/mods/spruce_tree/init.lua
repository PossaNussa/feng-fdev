local useswhatsounds_wood = {}
local useswhatsounds_leaves = {}
if minetest.get_modpath("default") or minetest.get_modpath("default_sounds_for_other_games") then
useswhatsounds_wood = default.node_sound_wood_defaults()
useswhatsounds_leaves = default.node_sound_leaves_defaults()
end


if not minetest.get_modpath("mcl_trees") then
minetest.register_node("spruce_tree:spruce_planks", {
	description = "Spruce Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"spruce_tree_spruce_planks.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = useswhatsounds_wood,
})

minetest.register_node("spruce_tree:spruce_tree", {
	description = "Spruce Tree",
	tiles = {"spruce_tree_tree_top.png", "spruce_tree_tree_top.png",
		"spruce_tree_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = useswhatsounds_wood,

	on_place = minetest.rotate_node
})

minetest.register_craft({
	output = "spruce_tree:spruce_planks 4",
	recipe = {
		{"spruce_tree:spruce_tree"},
	}
})

function temporaaaaryvariaaabllle()

end
	if minetest.get_modpath("default") then
	temporaaaaryvariaaabllle = default.after_place_leaves
	end


minetest.register_node("spruce_tree:spruce_leaves", {
	description = "Spruce Tree Needles",
	drawtype = "allfaces_optional",
	tiles = {"spruce_tree_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = useswhatsounds_leaves,

	after_place_node = temporaaaaryvariaaabllle,
})
minetest.override_item("spruce_tree:spruce_leaves", {drop = {
	max_items = 1,
	items = {
		{items = {"spruce_tree:spruce_sapling"}, rarity = 32},
		{items = {""}},
	}
}})

minetest.register_node("spruce_tree:spruce_sapling", {
	description = "Spruce Tree Sapling",
	drawtype = "plantlike",
	tiles = {"spruce_tree_spruce_sapling.png"},
	inventory_image = "spruce_tree_cone.png",
	wield_image = "spruce_tree_cone.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3, attached_node = 1, sapling = 1},
	sounds = useswhatsounds_leaves,

})

minetest.register_abm({
	label = "Spruce Sapling Growing",
	nodenames = {"spruce_tree:spruce_sapling"},
	interval = 20,
	chance = 20,
	catch_up = false,
	action = function(pos, node)
		if (minetest.get_item_group(minetest.get_node(pos - vector.new(0, 1, 0)).name, "soil") == 0) then return end
		local path = minetest.get_modpath("spruce_tree") .. "/schematics/spruce_tree.mts"
		minetest.place_schematic(pos, path, "0", nil, true, "place_center_x, place_center_z")
	end,
})

if minetest.get_modpath("default") then
default.register_leafdecay({
	trunks = {"spruce_tree:spruce_tree"},
	leaves = {"spruce_tree:spruce_leaves"},
	radius = 4,
})
end
else

minetest.register_alias("spruce_tree:spruce_tree", "mcl_trees:tree_spruce")
minetest.register_alias("spruce_tree:spruce_leaves", "mcl_trees:leaves_spruce")
minetest.register_alias("spruce_tree:spruce_planks", "mcl_trees:wood_spruce")
minetest.register_alias("spruce_tree:spruce_sapling", "mcl_trees:sapling_spruce")

end


--[[minetest.register_decoration({
	name = "spruce_tree:spruce_tree",
	deco_type = "schematic",
	place_on = {"default:dirt", "default:sand", "default:desert_sand"},
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"grassland_dunes", "desert"},
	y_max = 10,
	y_min = 0,
	schematic = minetest.get_modpath("spruce_tree") .. "/schematics/spruce_tree.mts",
	flags = "place_center_x, place_center_z, force_placement",
	})]]
