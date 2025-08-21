---------------------------
-- Intrusive stone types

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

if default_loaded then
	local stone, desert_stone, obsidian, coal_block, diamond_block,
		river_water_source = "default:stone", "default:desert_stone",
			"default:obsidian", "default:coalblock", "default:diamondblock",
			"default:river_water_source"
	-- Obsidian
	minetest.register_ore({
		ore_type        = "blob",
		ore             = obsidian,
		wherein         = {
			stone,
			"aotearoa:andesite",
			"default:granite",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		biomes = {"gumland", "islands_hot", "rainforest", "pohutukawa_forest"},
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Desert stone into deep stone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = desert_stone,
		wherein         = {
			stone,
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = -150,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -31666,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gneiss into deep stone, schist
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gneiss",
		wherein         = {
			stone,
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 56752,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Schist into deep stone, greywacke
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:schist",
		wherein         = {
			stone,
			"aotearoa:greywacke",
			"default:gneiss",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -89851,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Granite into deep stone, and metamorphic rocks
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:granite",
		wherein         = {
			stone,
			"default:schist",
			"aotearoa:greywacke",
			"default:gneiss",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -30027,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Greywacke into deep stone and schist
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:greywacke",
		wherein         = {
			stone,
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -145366,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Andesite into deep stone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:andesite",
		wherein         = {
			stone,
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -11117,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Basalt into deep stone, and greywacke, granite
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:obsidian",
		wherein         = {
			stone,
			"aotearoa:greywacke",
			"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -800317,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Limestone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:limestone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -2018,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Grey sandstone into pale sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:grey_sandstone",
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -1009674,
			octaves = 2,
			persist = 0.4
		},
	})

	-- Pale sandstone into grey sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:pale_sandstone",
		wherein         = {
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -104074,
			octaves = 2,
			persist = 0.4
		},
	})

	-- Claystone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:claystone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 1996,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Siltstone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:siltstone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 1886,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Coquina into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:coquina_limestone",
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -1999,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Conglomerate into sandstone and andesite
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:conglomerate",
		wherein         = {
			"aotearoa:andesite",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 9,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 21106,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Volcanic sand
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:volcanic_sand",
		wherein         = {
			"aotearoa:andesite",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.02,
			spread = {x = 5, y = 5, z = 5},
			seed = 868,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Small bits of iron-sand in volcanic sand
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:iron_sand",
		wherein         = {
			"aotearoa:volcanic_sand",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.01,
			spread = {x = 5, y = 5, z = 5},
			seed = 86811112,
			octaves = 1,
			persist = 0.2
		},
	})

	-- Small bits of scoria in volcanic
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:scoria",
		wherein         = {
			"default:obsidian",
			"aotearoa:andesite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.01,
			spread = {x = 5, y = 5, z = 5},
			seed = 7701112,
			octaves = 1,
			persist = 0.2
		},
	})


	-----------------------------------------
	-- Special Features & Minerals
	local mineral_scale = 0.03
	local mineral_spread = {x = 40, y = 40, z = 40}
	local mineral_oct = 3
	local mineral_persist = 0.8
	local deep_scatter = -256

	------------------------
	--[[
	Iron Ore... Limonite
	NZ has very little apart from iron sands. A bit of limonite in NW Nelson
	(Southern podo); not sure where it really ought to go... shall put it in
	sedimentary rocks...
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:limonite",
		wherein         = {
			"aotearoa:conglomerate",
			"aotearoa:siltstone",
			"aotearoa:claystone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 1184053,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:limonite",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 1,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 1184053,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:limonite",
		wherein         = {
			"aotearoa:conglomerate",
			"aotearoa:siltstone",
			"aotearoa:claystone",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
			"default:obsidian",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 2,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	----------------------
	--[[
	Copper
	Comes in many forms:
	- Chalcopyrite: most important...
	- In andesite, granite(?),..various intusions into schist, greywacke,
	(other ores... malachite and a whole bunch of others...).
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:chalcopyrite",
		wherein         = {
			"aotearoa:andesite",
			"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale/2,
			spread = mineral_spread,
			seed = 1222243,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:chalcopyrite",
		wherein         = {
			"aotearoa:greywacke",
			"default:gneiss",
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 1,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale/2,
			spread = mineral_spread,
			seed = 1222243,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:chalcopyrite",
		wherein         = {
			"default:gneiss",
				"default:schist",
				"aotearoa:greywacke",
				"aotearoa:andesite",
				"default:granite",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 2,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	-------------------------
	--[[
	Tin
	Cassiterite
	With granite
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:cassiterite",
		wherein         = {
				"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 120013,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:cassiterite",
		wherein         = {
			"default:granite",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 2,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	-------------------
	-- West Coast coal
	minetest.register_ore({
		ore_type        = "blob",
		ore             = coal_block,
		wherein         = {
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 7886,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = coal_block,
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 7886,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = coal_block,
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	--------------------
	-- Pounamu
	-- (technically jade, bowenite, and serpentine)
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:pounamu",
		wherein         = {
			"default:schist",
			stone,
			desert_stone,
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = -7181,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	--------------------------
	-- Coromandel/Otago Gold
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:quartz_with_gold",
		wherein         = {
			"aotearoa:andesite",
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 1,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = -7444,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:quartz_with_gold",
		wherein         = {
			"aotearoa:andesite",
			"default:schist",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 2,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	--------------------------
	-- Diamonds
	minetest.register_ore({
			ore_type       = "scatter",
			ore            = diamond_block,
			wherein        = {
				"default:gneiss",
				"default:schist",
			},
			clust_scarcity = 15 * 15 * 15,
			clust_num_ores = 2,
			clust_size     = 1,
			y_min          = -31000,
			y_max          = deep_scatter *1.5,
		})


	----------------------------------------------
	-- Weird stuff...

	-- Sinking mud holes in surface peat
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:mud_sinking",
		wherein         = {
			"aotearoa:restiad_peat",
			"aotearoa:forest_peat",
			"aotearoa:gumland_soil",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = 74331,
			octaves = 1,
			persist = 0.3
		},
		--biomes = {},
	})

	-- River water holes in some surface peat
	minetest.register_ore({
		ore_type        = "blob",
		ore             = river_water_source,
		wherein         = {
			"aotearoa:forest_peat",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = 110388,
			octaves = 1,
			persist = 0.3
		},
		--biomes = {},
	})

	-- Air pockets
	-- For rocks with lots of caves
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "air",
		wherein         = {
			"aotearoa:coquina_limestone",
			"default:limestone",
			"aotearoa:scoria",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = -999931,
			octaves = 2,
			persist = 0.9
		},
		--biomes = {},
	})
elseif zero_loaded then
	local stone, desert_stone, obsidian, coal_block, diamond_block,
		river_water_source = "zr_stone:stone", "zr_sand:desert_stone",
			"zr_glass:obsidian", "zr_coal:block", "zr_diamond:block",
			"zr_water:river_source"
	-- Obsidian
	minetest.register_ore({
		ore_type        = "blob",
		ore             = obsidian,
		wherein         = {
			stone,
			"aotearoa:andesite",
			"default:granite",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gneiss into deep stone, schist
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gneiss",
		wherein         = {
			stone,
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 56752,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Schist into deep stone, greywacke
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:schist",
		wherein         = {
			stone,
			"aotearoa:greywacke",
			"default:gneiss",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -89851,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Granite into deep stone, and metamorphic rocks
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:granite",
		wherein         = {
			stone,
			"default:schist",
			"aotearoa:greywacke",
			"default:gneiss",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -30027,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Greywacke into deep stone and schist
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:greywacke",
		wherein         = {
			stone,
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -145366,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Andesite into deep stone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:andesite",
		wherein         = {
			stone,
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -11117,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Basalt into deep stone, and greywacke, granite
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:obsidian",
		wherein         = {
			stone,
			"aotearoa:greywacke",
			"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -800317,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Limestone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:limestone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -2018,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Grey sandstone into pale sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:grey_sandstone",
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 10,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -1009674,
			octaves = 2,
			persist = 0.4
		},
	})

	-- Pale sandstone into grey sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:pale_sandstone",
		wherein         = {
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 7,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -104074,
			octaves = 2,
			persist = 0.4
		},
	})

	-- Claystone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:claystone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 1996,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Siltstone into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:siltstone",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 1886,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Coquina into sandstone
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:limestone",
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 12,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = -1999,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Conglomerate into sandstone and andesite
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:conglomerate",
		wherein         = {
			"aotearoa:andesite",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 9,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0,
			scale = 1,
			spread = {x = 15, y = 15, z = 15},
			seed = 21106,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Volcanic sand
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:volcanic_sand",
		wherein         = {
			"aotearoa:andesite",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.02,
			spread = {x = 5, y = 5, z = 5},
			seed = 868,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Small bits of iron-sand in volcanic sand
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:iron_sand",
		wherein         = {
			"aotearoa:volcanic_sand",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.01,
			spread = {x = 5, y = 5, z = 5},
			seed = 86811112,
			octaves = 1,
			persist = 0.2
		},
	})

	-- Small bits of scoria in volcanic
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:scoria",
		wherein         = {
			"default:obsidian",
			"aotearoa:andesite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.01,
			spread = {x = 5, y = 5, z = 5},
			seed = 7701112,
			octaves = 1,
			persist = 0.2
		},
	})


	-----------------------------------------
	-- Special Features & Minerals
	local mineral_scale = 0.03
	local mineral_spread = {x = 40, y = 40, z = 40}
	local mineral_oct = 3
	local mineral_persist = 0.8
	local deep_scatter = -256

	------------------------
	--[[
	Iron Ore... Limonite
	NZ has very little apart from iron sands. A bit of limonite in NW Nelson
	(Southern podo); not sure where it really ought to go... shall put it in
	sedimentary rocks...
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:limonite",
		wherein         = {
			"aotearoa:conglomerate",
			"aotearoa:siltstone",
			"aotearoa:claystone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 1184053,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:limonite",
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 1184053,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:limonite",
		wherein         = {
			"aotearoa:conglomerate",
			"aotearoa:siltstone",
			"aotearoa:claystone",
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
			"default:obsidian",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	----------------------
	--[[
	Copper
	Comes in many forms:
	- Chalcopyrite: most important...
	- In andesite, granite(?),..various intusions into schist, greywacke,
	(other ores... malachite and a whole bunch of others...).
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:chalcopyrite",
		wherein         = {
			"aotearoa:andesite",
			"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale/2,
			spread = mineral_spread,
			seed = 1222243,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:chalcopyrite",
		wherein         = {
			"aotearoa:greywacke",
			"default:gneiss",
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale/2,
			spread = mineral_spread,
			seed = 1222243,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:chalcopyrite",
		wherein         = {
			"default:gneiss",
				"default:schist",
				"aotearoa:greywacke",
				"aotearoa:andesite",
				"default:granite",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	-------------------------
	--[[
	Tin
	Cassiterite
	With granite
	--]]
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:cassiterite",
		wherein         = {
				"default:granite",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 120013,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:cassiterite",
		wherein         = {
			"default:granite",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	-------------------
	-- West Coast coal
	minetest.register_ore({
		ore_type        = "blob",
		ore             = coal_block,
		wherein         = {
			"aotearoa:grey_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 7886,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = coal_block,
		wherein         = {
			"aotearoa:pale_sandstone",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 2,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = 7886,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = coal_block,
		wherein         = {
			"aotearoa:pale_sandstone",
			"aotearoa:grey_sandstone",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	--------------------
	-- Pounamu
	-- (technically jade, bowenite, and serpentine)
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:pounamu",
		wherein         = {
			"default:schist",
			stone,
			desert_stone,
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = -7181,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	--------------------------
	-- Coromandel/Otago Gold
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:quartz_with_gold",
		wherein         = {
			"aotearoa:andesite",
			"default:schist",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = mineral_scale,
			spread = mineral_spread,
			seed = -7444,
			octaves = mineral_oct,
			persist = mineral_persist
		},
		--biomes = {},
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "aotearoa:quartz_with_gold",
		wherein         = {
			"aotearoa:andesite",
			"default:schist",
		},
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = -31000,
		y_max          = deep_scatter,
	})

	--------------------------
	-- Diamonds
	minetest.register_ore({
			ore_type       = "scatter",
			ore            = diamond_block,
			wherein        = {
				"default:gneiss",
				"default:schist",
			},
			clust_scarcity = 15 * 15 * 15,
			clust_num_ores = 4,
			clust_size     = 3,
			y_min          = -31000,
			y_max          = deep_scatter *1.5,
		})


	----------------------------------------------
	-- Weird stuff...

	-- Sinking mud holes in surface peat
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "aotearoa:mud_sinking",
		wherein         = {
			"aotearoa:restiad_peat",
			"aotearoa:forest_peat",
			"aotearoa:gumland_soil",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 3,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = 74331,
			octaves = 1,
			persist = 0.3
		},
		--biomes = {},
	})

	-- River water holes in some surface peat
	minetest.register_ore({
		ore_type        = "blob",
		ore             = river_water_source,
		wherein         = {
			"aotearoa:forest_peat",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = 110388,
			octaves = 1,
			persist = 0.3
		},
		--biomes = {},
	})

	-- Air pockets
	-- For rocks with lots of caves
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "air",
		wherein         = {
			"aotearoa:coquina_limestone",
			"default:limestone",
			"aotearoa:scoria",
			"default:obsidian",
		},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 4,
		y_min           = -31000,
		y_max           = 31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.6,
			spread = {x = 10, y = 10, z = 10},
			seed = -999931,
			octaves = 2,
			persist = 0.9
		},
		--biomes = {},
	})
end
