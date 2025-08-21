-----------------------------------
-- Underwater life

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

if default_loaded then
	local sand = "zr_sand:sand"
	-------------------------
	-- Pipi shellfish beds
	minetest.register_ore({
		ore_type        = "puff",
		ore             = "aotearoa:sand_with_pipi",
		wherein         = {sand},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -7,
		y_max           = 0,
		noise_threshold = 0.19,
		noise_params    = {
			offset = 0,
			scale = 0.7,
			spread = {x = 32, y = 32, z = 32},
			seed = 4661,
			octaves = 2,
			persist = 0.5
		},
		biomes = {
			"sandy_beach",
			"shelly_beach",
			"gravel_beach",
		},
	})
elseif zero_loaded then
	local sand = "default:sand"
	-------------------------
	-- Pipi shellfish beds
	minetest.register_ore({
		ore_type        = "puff",
		ore             = "aotearoa:sand_with_pipi",
		wherein         = {sand},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -7,
		y_max           = 0,
		noise_threshold = 0.19,
		noise_params    = {
			offset = 0,
			scale = 0.7,
			spread = {x = 32, y = 32, z = 32},
			seed = 4661,
			octaves = 2,
			persist = 0.5
		},
		biomes = {
			"sandy_beach",
			"shelly_beach",
			"gravel_beach",
		},
	})
end

minetest.register_ore({
	ore_type        = "puff",
	ore             = "aotearoa:iron_sand_with_pipi",
	wherein         = {"aotearoa:iron_sand"},
	clust_scarcity  = 16 * 16 * 16,
	clust_size      = 3,
	y_min           = -7,
	y_max           = 0,
	noise_threshold = 0.19,
	noise_params    = {
		offset = 0,
		scale = 0.7,
		spread = {x = 32, y = 32, z = 32},
		seed = 4661,
		octaves = 2,
		persist = 0.5
	},
	biomes = {"iron_sand_beach",},
})

-------------------------
-- Cockle shellfish beds
minetest.register_ore({
	ore_type        = "puff",
	ore             = "aotearoa:mud_with_cockles",
	wherein         = {"aotearoa:mud"},
	clust_scarcity  = 16 * 16 * 16,
	clust_size      = 3,
	y_min           = -7,
	y_max           = 0,
	noise_threshold = 0.19,
	noise_params    = {
		offset = 0,
		scale = 0.8,
		spread = {x = 32, y = 32, z = 32},
		seed = 4607,
		octaves = 2,
		persist = 0.4
	},
	biomes = {
		"northern_estuary",
		"southern_estuary",
	},
})
