local S = minetest.get_translator("lavagold")


minetest.register_node("lavagold:lavagold", {
	description = S("Lava gold"),
	drawtype = "liquid",
	tiles = {
		{
			name = "lavaoroanid.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4,
			},
		},
		{
			name = "lavaoroanid.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4,
			},
		},
	},
	paramtype = "light",
	light_source = 10,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
    glow = 10,
	liquidtype = "source",
	liquid_alternative_flowing = "lavagold:lavagoldflow",
	liquid_alternative_source = "lavagold:lavagold",
	liquid_viscosity = 10,
	liquid_renewable = false,
	damage_per_second = 3 * 4,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 1, liquid = 1, igniter = 1,
    not_in_creative_inventory=1},
})

minetest.register_node("lavagold:lavagoldflow", {
	description = "lava gold",
	drawtype = "flowingliquid",
	tiles = {"lavaoro.png"},
	special_tiles = {
		{
			name = "lavaoro2.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4,
			},
		},
		{
			name = "lavaoro2.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = 10,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
    glow = 9,
	liquidtype = "flowing",
	liquid_alternative_flowing = "lavagold:lavagoldflow",
	liquid_alternative_source = "lavagold:lavagold",
	liquid_viscosity = 10,
	liquid_renewable = false,
	damage_per_second = 4 * 4,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 1, liquid = 1, igniter = 1,
		not_in_creative_inventory = 1},
})
if minetest.get_modpath("bucket") then

	bucket.register_liquid(
		"lavagold:lavagold",
		"lavagold:lavagoldflow",
		"lavagold:bucketlavagold",
		"cubolavaoro.png",
		S("bucket lava gold"),
		{tool = 1}
	)
end

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "lavagold:lavagold",
	wherein        = "default:stone",
	clust_scarcity = 40 * 50 * 40,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max          = -10000,
	y_min          = -30000,
})