minetest.register_node('asbestos:asbestos', {
    tiles = { 'asbestos_asbestos.png' },
    description = "Asbestos Block",
    groups = { oddly_breakable_by_hand = 1, asbestos = 1, snappy = 2 },
    is_ground_content = true,
    sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craftitem("asbestos:lump", {
	description = ("Asbestos Lump"),
	inventory_image = "asbestos_lump.png"
})

minetest.register_craftitem("asbestos:fabric", {
	description = ("Asbestos Fabric"),
	inventory_image = "asbestos_fabric.png"
})

minetest.register_craft({
	output = "asbestos:asbestos",
	recipe = {
		{"asbestos:lump", "asbestos:lump"},
		{"asbestos:lump", "asbestos:lump"},
	}
})

minetest.register_craft({
	output = "asbestos:fabric 2",
	recipe = {
		{"asbestos:lump", "asbestos:lump", "asbestos:lump"},
		{"asbestos:lump", "asbestos:lump", "asbestos:lump"},
	}
})

minetest.register_node('asbestos:stone_with_asbestos', {
    tiles = { 'default_stone.png^asbestos_stone_with_asbestos.png' },
    description = "Stone With Asbestos",
    groups = {cracky = 3, asbestos = 1},
    is_ground_content = true,
    drop = "asbestos:lump 4",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('asbestos:tile', {
    tiles = { 'asbestos_tile_top.png', 'asbestos_tile_top.png', 'asbestos_tile.png' },
    description = "Asbestos Reinforced Tile",
    groups = { cracky = 1, level = 1 },
    is_ground_content = true,
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "asbestos:tile 4",
	recipe = {
		{"asbestos:lump", "asbestos:lump"},
		{"group:stone", "group:stone"},
		{"group:stone", "group:stone"},
	}
})

-- Asbestos is a metamorphic mineral: chrysotile and the amphibole asbestos
-- form when ultramafic rock is cooked and sheared. In the default strata that
-- means the metamorphic band -- schist, slate and gneiss -- not plain stone.
-- Each ore below is clamped to the exact y range of its host stratum so the
-- deposits stay inside the layer they belong to.

minetest.register_node('asbestos:schist_with_asbestos', {
    tiles = { 'default_schist.png^asbestos_stone_with_asbestos.png' },
    description = "Schist With Asbestos",
    groups = {cracky = 3, stone = 1, asbestos = 1},
    is_ground_content = true,
    drop = "asbestos:lump 4",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('asbestos:slate_with_asbestos', {
    tiles = { 'default_slate.png^asbestos_stone_with_asbestos.png' },
    description = "Slate With Asbestos",
    groups = {cracky = 3, stone = 1, asbestos = 1},
    is_ground_content = true,
    drop = "asbestos:lump 4",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node('asbestos:gneiss_with_asbestos', {
    tiles = { 'default_gneiss.png^asbestos_stone_with_asbestos.png' },
    description = "Gneiss With Asbestos",
    groups = {cracky = 1, level = 2, stone = 1, asbestos = 1},
    is_ground_content = true,
    drop = "asbestos:lump 4",
    sounds = default.node_sound_stone_defaults(),
})

-- Schist stratum (-340 .. -240): the main asbestos band
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "asbestos:schist_with_asbestos",
	wherein        = "default:schist",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 6,
	clust_size     = 4,
	y_max          = -240,
	y_min          = -340,
})

-- Slate stratum (-540 .. -440): secondary band
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "asbestos:slate_with_asbestos",
	wherein        = "default:slate",
	clust_scarcity = 14 * 14 * 14,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -440,
	y_min          = -540,
})

-- Gneiss stratum (-870 .. -750): deep, high grade metamorphic
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "asbestos:gneiss_with_asbestos",
	wherein        = "default:gneiss",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -750,
	y_min          = -870,
})

-- Traces in the plain stone stratum sandwiched between slate and granite
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "asbestos:stone_with_asbestos",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 3,
	clust_size     = 3,
	y_max          = -540,
	y_min          = -640,
})

minetest.register_abm({
	label = "Asbestos extinguish fire",
	nodenames = {"fire:basic_flame"},
	interval = 1,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if minetest.find_node_near(pos, 10, { "group:asbestos" }) then
			minetest.set_node(pos, {name = "air"})
		end
	end
})