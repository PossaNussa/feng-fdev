-- dynamic_trees/dt_crafting.lua
minetest.register_on_mods_loaded(function()
minetest.register_alias("default:acacia_sapling", "dynamic_trees:acacia_tree_sapling")
minetest.register_alias("default:sapling", "dynamic_trees:apple_tree_sapling")
minetest.register_alias("default:aspen_sapling", "dynamic_trees:aspen_tree_sapling")
minetest.register_alias("default:junglesapling", "dynamic_trees:jungle_tree_sapling")
minetest.register_alias("default:pine_sapling", "dynamic_trees:pine_tree_sapling")
end)
-- Crafting Recipe For The DT Acacia Sapling
minetest.register_craft({
	type = "shapeless",
	output = "dynamic_trees:acacia_tree_sapling 1",
	recipe = { 
		"default:acacia_leaves", "default:acacia_leaves", "default:acacia_leaves",
		"default:acacia_leaves", "default:acacia_leaves", "default:acacia_leaves",
		"default:acacia_leaves", "default:acacia_leaves", "default:acacia_leaves"
	}
})

-- Crafting Recipe For The DT Apple Sapling
minetest.register_craft({
	type = "shapeless",
	output = "dynamic_trees:apple_tree_sapling 1",
	recipe = { 
		"default:leaves", "default:leaves", "default:leaves",
		"default:leaves", "default:leaves", "default:leaves",
		"default:leaves", "default:leaves", "default:leaves"
	}
})

-- Crafting Recipe For The DT Aspen Sapling
minetest.register_craft({
	type = "shapeless",
	output = "dynamic_trees:aspen_tree_sapling 1",
	recipe = { 
		"default:aspen_leaves", "default:aspen_leaves", "default:aspen_leaves",
		"default:aspen_leaves", "default:aspen_leaves", "default:aspen_leaves",
		"default:aspen_leaves", "default:aspen_leaves", "default:aspen_leaves"
	}
})

-- Crafting Recipe For The DT Cactus Seedling
minetest.register_craft({
	output = "dynamic_trees:cactus_seedling 1",
	recipe = { 
		{"", "default:cactus", ""},
		{"default:cactus", "default:large_cactus_seedling", "default:cactus"},
		{"", "default:cactus", ""}
	}
})

-- Crafting Recipe For The DT Jungle Sapling
minetest.register_craft({
	type = "shapeless",
	output = "dynamic_trees:jungle_tree_sapling 1",
	recipe = { 
		"default:jungleleaves", "default:jungleleaves", "default:jungleleaves",
		"default:jungleleaves", "default:jungleleaves", "default:jungleleaves",
		"default:jungleleaves", "default:jungleleaves", "default:jungleleaves"
	}
})

-- Crafting Recipe For The DT Pine Sapling
minetest.register_craft({
	type = "shapeless",
	output = "dynamic_trees:pine_tree_sapling 1",
	recipe = { 
		"default:pine_needles", "default:pine_needles", "default:pine_needles",
		"default:pine_needles", "default:pine_needles", "default:pine_needles",
		"default:pine_needles", "default:pine_needles", "default:pine_needles"
	}
})

-- Crafting Recipe For The DT Bamboo Shoot
minetest.register_craft({
	output = "dynamic_trees:bamboo_shoot 1",
	recipe = { 
		{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"},
		{"group:dynamic_tree_bamboo", "group:dt_bamboo_leaves", "group:dynamic_tree_bamboo"},
		{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"}
	}
})

-- Bamboo bundle
minetest.register_node("dynamic_trees:bamboo_bundle", {
	description = "Bamboo Bundle",
	tiles = {"dt_bamboo_bundle_top.png", "dt_bamboo_bundle_top.png", "dt_bamboo_bundle_side.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node
})

-- Crafting Recipe For The Bamboo Bundle
minetest.register_craft({
	output = "dynamic_trees:bamboo_bundle 4",
	recipe = { 
		{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"},
		{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"},
		{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"}
	}
})

-- Bamboo Planks
minetest.register_node("dynamic_trees:bamboo_planks", {
	description = "Bamboo Planks",
	tiles = {"dt_bamboo_planks.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	place_param2 = 0
})

-- Bamboo Planks Recipes
minetest.register_craft({
	output = "dynamic_trees:bamboo_planks 1",
	recipe = {
		{"dynamic_trees:bamboo_2x2"},
	}
})

minetest.register_craft({
	output = "dynamic_trees:bamboo_planks 2",
	recipe = {
		{"dynamic_trees:bamboo_4x4"},
	}
})

minetest.register_craft({
	output = "dynamic_trees:bamboo_planks 3",
	recipe = {
		{"dynamic_trees:bamboo_6x6"},
	}
})

minetest.register_craft({
	output = "dynamic_trees:bamboo_planks 4",
	recipe = {
		{"dynamic_trees:bamboo_8x8"},
	}
})

-- Bamboo Doors
if minetest.global_exists("doors") then
	doors.register_trapdoor("dynamic_trees:bamboo_trapdoor", {
		description = "Bamboo Trapdoor",
		inventory_image = "dt_bamboo_trapdoor.png",
		wield_image = "dt_bamboo_trapdoor.png",
		tile_front = "dt_bamboo_trapdoor.png",
		tile_side = "dt_bamboo_trapdoor_side.png",
    	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
		gain_open = 0.06,
		gain_close = 0.13,
	})

	minetest.register_craft({
		output = "dynamic_trees:bamboo_trapdoor 2",
		recipe = {
			{"dynamic_trees:bamboo_planks", "dynamic_trees:bamboo_planks", "dynamic_trees:bamboo_planks"},
			{"dynamic_trees:bamboo_planks", "group:dynamic_tree_bamboo", "dynamic_trees:bamboo_planks"},
		}
	})

	doors.register("dynamic_trees:bamboo_door", {
    	tiles = {{ name = "dt_bamboo_door.png", backface_culling = true }},
    	description = "Bamboo Door",
    	inventory_image = "dt_bamboo_door_item.png",
    	groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    	gain_open = 0.06,
    	gain_close = 0.13,
		recipe = {
			{"dynamic_trees:bamboo_planks", "dynamic_trees:bamboo_planks"},
			{"group:dynamic_tree_bamboo", "group:dynamic_tree_bamboo"},
			{"dynamic_trees:bamboo_planks", "dynamic_trees:bamboo_planks"},
		} 
	})
end

-- Bamboo Plank And Bundle Stairs
if minetest.global_exists("stairs") then
	stairs.register_stair(
	"bamboo_planks",
	"dynamic_trees:bamboo_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_planks.png"},
	("Bamboo Planks Stair"),
	default.node_sound_wood_defaults(),
	false
	)

	stairs.register_slab(
	"bamboo_planks",
	"dynamic_trees:bamboo_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_planks.png"},
	("Bamboo Planks Slab"),
	default.node_sound_wood_defaults(),
	false
	)
	
	stairs.register_stair_inner(
	"bamboo_planks",
	"dynamic_trees:bamboo_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_planks.png"},
	("Bamboo Planks Inner Stair"),
	default.node_sound_glass_defaults(),
	false
	)

	stairs.register_stair_outer(
	"bamboo_planks",
	"dynamic_trees:bamboo_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_planks.png"},
	("Bamboo Planks Outer Stair"),
	default.node_sound_glass_defaults(),
	false
	)
	
	stairs.register_stair(
	"bamboo_bundle",
	"dynamic_trees:bamboo_bundle",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_bundle_stairs.png"},
	("Bamboo Bundle Stair"),
	default.node_sound_wood_defaults(),
	false
	)

	stairs.register_slab(
	"bamboo_bundle",
	"dynamic_trees:bamboo_bundle",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_bundle_stairs.png"},
	("Bamboo Bundle Slab"),
	default.node_sound_wood_defaults(),
	false
	)
	
	stairs.register_stair_inner(
	"bamboo_bundle",
	"dynamic_trees:bamboo_bundle",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_bundle_stairs.png"},
	("Bamboo Bundle Stair"),
	default.node_sound_glass_defaults(),
	false
	)

	stairs.register_stair_outer(
	"bamboo_bundle",
	"dynamic_trees:bamboo_bundle",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_bamboo_bundle_stairs.png"},
	("Bamboo Bundle Stair"),
	default.node_sound_glass_defaults(),
	false
	)
end

-- Bamboo Fence And Rails
default.register_fence("dynamic_trees:bamboo_fence", {
	description = "Bamboo Fence",
	texture = "dt_bamboo_fence.png",
	inventory_image = "default_fence_overlay.png^dt_bamboo_bundle_side.png^" ..
				"default_fence_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_overlay.png^dt_bamboo_bundle_side.png^" ..
				"default_fence_overlay.png^[makealpha:255,126,126",
	material = "group:dynamic_tree_bamboo",
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence_rail("dynamic_trees:bamboo_fence_rail", {
	description = "Bamboo Fence Rail",
	texture = "dt_bamboo_fence_rail.png",
	inventory_image = "default_fence_rail_overlay.png^dt_bamboo_bundle_side.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_rail_overlay.png^dt_bamboo_bundle_side.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	material = "group:dynamic_tree_bamboo",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})


-- If The Bonemeal Mod Is Installed This Allows The Bamboo Canopy Leaves
-- To Be Mulched, It At Least Makes Another Way To Get Rid Of Them If
-- They Aren't Used To Make Bamboo Shoots
if minetest.get_modpath("bonemeal") then
	minetest.register_craft({
	type = "shapeless",
	output = "bonemeal:mulch 3",
	recipe = { 
		"group:dt_bamboo_leaves", "group:dt_bamboo_leaves", "group:dt_bamboo_leaves",
		"group:dt_bamboo_leaves", "group:dt_bamboo_leaves", "group:dt_bamboo_leaves",
		"group:dt_bamboo_leaves", "group:dt_bamboo_leaves", "group:dt_bamboo_leaves"
	}
})
end

-- Crafting Recipe For The DT Dry Sapling
minetest.register_craft({
	output = "dynamic_trees:dry_tree_sapling 1",
	recipe = { 
		{"default:dry_shrub", "default:dry_shrub", "default:dry_shrub"},
		{"default:dry_shrub", "default:dry_shrub", "default:dry_shrub"},
		{"default:dry_shrub", "default:dry_shrub", "default:dry_shrub"}
	}
})

-- Dry Tree
minetest.register_node("dynamic_trees:dry_tree", {
	description = "Dry Tree",
	tiles = {"dt_dry_tree_top_bottom.png", "dt_dry_tree_bark.png", "dt_dry_tree_bark.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	on_place = minetest.rotate_node
})

-- Dry Planks
minetest.register_node("dynamic_trees:dry_planks", {
	description = "Dry Planks",
	tiles = {"dt_dry_planks.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	place_param2 = 0
})

-- Dry Planks Recipes
minetest.register_craft({
	output = "dynamic_trees:dry_planks 4",
	recipe = {
		{"dynamic_trees:dry_tree"},
	}
})

-- Dry Doors
if minetest.global_exists("doors") then
	doors.register_trapdoor("dynamic_trees:dry_trapdoor", {
		description = "Dry Trapdoor",
		inventory_image = "dt_dry_trapdoor.png",
		wield_image = "dt_dry_trapdoor.png",
		tile_front = "dt_dry_trapdoor.png",
		tile_side = "dt_dry_trapdoor_side.png",
    	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
		gain_open = 0.06,
		gain_close = 0.13,
	})

	minetest.register_craft({
		output = "dynamic_trees:dry_trapdoor 2",
		recipe = {
			{"dynamic_trees:dry_planks", "dynamic_trees:dry_planks", "dynamic_trees:dry_planks"},
			{"dynamic_trees:dry_planks", "dynamic_trees:dry_tree", "dynamic_trees:dry_planks"},
		}
	})

	doors.register("dynamic_trees:dry_door", {
    	tiles = {{ name = "dt_dry_door.png", backface_culling = true }},
    	description = "Dry Door",
    	inventory_image = "dt_dry_door_item.png",
    	groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    	gain_open = 0.06,
    	gain_close = 0.13,
		recipe = {
			{"dynamic_trees:dry_planks", "dynamic_trees:dry_planks"},
			{"dynamic_trees:dry_tree", "dynamic_trees:dry_tree"},
			{"dynamic_trees:dry_planks", "dynamic_trees:dry_planks"},
		} 
	})
end

-- Dry Plank Stairs
if minetest.global_exists("stairs") then
	stairs.register_stair(
	"dry_planks",
	"dynamic_trees:dry_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_dry_planks.png"},
	("Dry Planks Stair"),
	default.node_sound_wood_defaults(),
	false
	)

	stairs.register_slab(
	"dry_planks",
	"dynamic_trees:dry_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_dry_planks.png"},
	("Dry Planks Slab"),
	default.node_sound_wood_defaults(),
	false
	)
	
	stairs.register_stair_inner(
	"dry_planks",
	"dynamic_trees:dry_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_dry_planks.png"},
	("Dry Planks Inner Stair"),
	default.node_sound_glass_defaults(),
	false
	)

	stairs.register_stair_outer(
	"dry_planks",
	"dynamic_trees:dry_planks",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	{"dt_dry_planks.png"},
	("Dry Planks Outer Stair"),
	default.node_sound_glass_defaults(),
	false
	)
end

-- Dry Fence And Rails
default.register_fence("dynamic_trees:dry_fence", {
	description = "Dry Fence",
	texture = "dt_dry_fence.png",
	inventory_image = "default_fence_overlay.png^dt_dry_planks.png^" ..
				"default_fence_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_overlay.png^dt_dry_planks.png^" ..
				"default_fence_overlay.png^[makealpha:255,126,126",
	material = "dynamic_trees:dry_planks",
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = default.node_sound_wood_defaults()
})

default.register_fence_rail("dynamic_trees:dry_fence_rail", {
	description = "Dry Fence Rail",
	texture = "dt_dry_fence_rail.png",
	inventory_image = "default_fence_rail_overlay.png^dt_dry_planks.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_rail_overlay.png^dt_dry_planks.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	material = "dynamic_trees:dry_planks",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults()
})