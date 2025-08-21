-------------------------------------------------------------------
-- Terrestrial schematic deco_type plants and decorations, if running
-- Minetest Game.

local path = minetest.get_modpath("aotearoa")

---------------------------------------------------------------
-- Densities

-- Canopy
local can_fill = 0.0039
local can_dense_fill = can_fill * 2
local can_x_dense_fill = can_fill * 3
local can_sparse_fill = can_fill / 2
local can_rare_fill = can_fill / 10

-- Sub-canopy
local scan_fill = 0.01
local scan_dense_fill = scan_fill * 2
local scan_x_dense_fill = scan_fill * 10
local scan_sparse_fill = scan_fill / 4
local scan_rare_fill = scan_fill / 10

-- Clumping
local cl_spr = {x = 64, y = 64, z = 64,}
local cl_spr2 = {x = 128, y = 128, z = 128,}
local cl_oct = 2


-----------------------------------------------------------------
-- Altitudes
-- Make sure this matches mapgen file.

-- Basement
local basement_max = -400
local basement_min = -15000

-- Ocean
local ocean_max = -21
local ocean_min = basement_max - 2
------------
-- Beach
local beach_max = 3
local beach_min = ocean_max - 2
-- Dune
local dune_max = 5
local dune_min = beach_max - 2
-- Coastal forest etc.
local coastf_max = 14
local coastf_min = dune_max - 2
-- Lowland forest etc.
local lowf_max = 80
local lowf_min = coastf_max - 2
-- Highland forest etc.
local highf_max = 120
local highf_min = lowf_max - 2
-- Alpine
local alp_max = 140
local alp_min = highf_max - 2
-- High alpine
local high_alp_max = 31000
local high_alp_min = alp_max - 2

---------------------------------------------------------------
-- Registration

-- For forest/river edge spawn_by species.
local edge_nodes = {
	"default:river_water_source",
	"default:river_water_flowing",
	"default:gravel",
	"aotearoa:gravel_with_algae",
	"aotearoa:river_sand",
	"aotearoa:mud",
}

--------------------------------------
-- Need to arrange in size order (biggest/critical first),
-- so when it overlaps nodes, it is the smaller one that loses.
aotearoa.schematics_deco_list = {
	-- Mudpools
	{
		path .. "/schematics/mud_pool1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:volcanic_sand",
		},
		nil,
		{
			"geothermal_scrub",
			"white_island",
		},
		lowf_max / 3,
		dune_min + 1,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 128774,
			octaves = cl_oct,
			persist = 0.8,
		}
	},
	{
		path .. "/schematics/mud_pool2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:volcanic_sand",
		},
		nil,
		{
			"geothermal_scrub",
			"white_island",
		},
		lowf_max / 3,
		dune_min + 1,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 186674,
			octaves = cl_oct,
			persist = 0.8,
		}
	},

	-- Emergents...

	-- Dense kahikatea
	{
		path .. "/schematics/kahikatea1.mts",
		{"aotearoa:forest_peat",},
		can_x_dense_fill,
		{"kahikatea_swamp",},
		lowf_max,
		coastf_min + 2,
	},
	{
		path .. "/schematics/kahikatea2.mts",
		{"aotearoa:forest_peat",},
		can_x_dense_fill,
		{"kahikatea_swamp",},
		lowf_max,
		coastf_min + 2,
	},
	-- Rare kahikatea
	{
		path .. "/schematics/kahikatea1.mts",
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"fiordland_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/kahikatea2.mts",
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"fiordland_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare miro
	{
		path .. "/schematics/miro1.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/miro2.mts",
		{
		"aotearoa:dirt_with_moss",
		"aotearoa:dirt_with_beech_litter",
		"aotearoa:dirt_with_dark_litter",
		"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare rimu
	{
		path .. "/schematics/rimu1.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/rimu2.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare totara
	{
		path .. "/schematics/totara1.mts",
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/totara2.mts",
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},

	-- Dense totara
	{
		path .. "/schematics/totara1.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_x_dense_fill,
		{"northern_podocarp_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/totara2.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_x_dense_fill,
		{"northern_podocarp_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense rimu
	{
		path .. "/schematics/rimu1.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_x_dense_fill,
		{"southern_podocarp_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/rimu2.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_x_dense_fill,
		{"southern_podocarp_forest",},
		lowf_max,
		lowf_min,
	},

	-- Kauri
	{
		path .. "/schematics/kauri1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_fill,
		{"kauri_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/kauri2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_fill,
		{"kauri_forest",},
		lowf_max,
		lowf_min,
	},

	-- Canopy trees...

	-- Tawa
	{
		path .. "/schematics/tawa1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_fill,
		{"kauri_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/tawa2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_fill,
		{"kauri_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense Tawa
	{
		path .. "/schematics/tawa1.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_dense_fill,
		{"tawa_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/tawa2.mts",
		{"aotearoa:dirt_with_dark_litter",},
		can_dense_fill,
		{"tawa_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense black maire
	{
		path .. "/schematics/black_maire1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_dense_fill,
		{"maire_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/black_maire2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_dense_fill,
		{"maire_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense hinau
	{
		path .. "/schematics/hinau1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_dense_fill,
		{"hinau_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/hinau2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_dense_fill,
		{"hinau_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense black beech
	{
		path .. "/schematics/black_beech1.mts",
		{"aotearoa:dirt_with_beech_litter",},
		can_dense_fill,
		{"beech_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/black_beech2.mts",
		{"aotearoa:dirt_with_beech_litter",},
		can_fill,
		{"beech_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense silver beech
	{
		path .. "/schematics/silver_beech1.mts",
		{"aotearoa:dirt_with_beech_litter",},
		can_dense_fill,
		{"fiordland_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/silver_beech2.mts",
		{"aotearoa:dirt_with_beech_litter",},
		can_dense_fill,
		{"fiordland_forest",},
		lowf_max,
		lowf_min,
	},
	-- Dense pahautea
	{
		path .. "/schematics/pahautea1.mts",
		{"aotearoa:dirt_with_moss",},
		can_x_dense_fill,
		{"pahautea_forest",},
		highf_max,
		highf_min,
	},
	{
		path .. "/schematics/pahautea2.mts",
		{"aotearoa:dirt_with_moss",},
		can_x_dense_fill,
		{"pahautea_forest",},
		highf_max,
		highf_min,
	},
	-- Dense mountain beech
	{
		path .. "/schematics/mountain_beech1.mts",
		{"aotearoa:dirt_with_moss",},
		scan_dense_fill,
		{"mountain_beech_forest",},
		highf_max,
		highf_min,
	},
	{
		path .. "/schematics/mountain_beech2.mts",
		{"aotearoa:dirt_with_moss",},
		scan_dense_fill,
		{"mountain_beech_forest",},
		highf_max,
		highf_min,
	},

	-- Rare tawa
	{
		path .. "/schematics/tawa1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_rare_fill,
		{"maire_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/tawa2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_rare_fill,
		{"maire_forest",},
		lowf_max,
		lowf_min,
	},
	-- Rare black beech
	{
		path .. "/schematics/black_beech1.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_rare_fill,
		{
			"hinau_forest",
			"maire_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/black_beech2.mts",
		{"aotearoa:dirt_with_dry_litter",},
		can_rare_fill,
		{
			"hinau_forest",
			"maire_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare hinau
	{
		path .. "/schematics/hinau1.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"beech_forest",
			"maire_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/hinau2.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"beech_forest",
			"maire_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare black maire
	{
		path .. "/schematics/black_maire1.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"hinau_forest",
			"tawa_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/black_maire2.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
		},
		can_rare_fill,
		{
			"kamahi_forest",
			"hinau_forest",
			"tawa_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare silver beech
	{
		path .. "/schematics/silver_beech1.mts",
		{"aotearoa:dirt_with_moss",},
		can_rare_fill,
		{
			"mountain_beech_forest",
			"kamahi_forest",
		},
		highf_max,
		lowf_min,
	},
	{
		path .. "/schematics/silver_beech2.mts",
		{"aotearoa:dirt_with_moss",},
		can_rare_fill,
		{
			"mountain_beech_forest",
			"kamahi_forest",
		},
		highf_max,
		lowf_min,
	},
	-- Rare mountain beech
	{
		path .. "/schematics/mountain_beech1.mts",
		{"aotearoa:dirt_with_moss",},
		can_rare_fill,
		{"kamahi_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/mountain_beech2.mts",
		{"aotearoa:dirt_with_moss",},
		can_rare_fill,
		{"kamahi_forest",},
		lowf_max,
		lowf_min,
	},

	-- Smaller trees...

	-- Kowhai by streams etc.
	{
		path .. "/schematics/kowhai1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_grass",
		},
		can_dense_fill,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
			"coastal_scrub",
		},
		lowf_max,
		coastf_min + 3,
		nil,
		edge_nodes,
		2,
	},
	{
		path .. "/schematics/kowhai2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_grass",
		},
		can_dense_fill,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
			"coastal_scrub",
		},
		lowf_max,
		coastf_min + 3,
		nil,
		edge_nodes,
		2,
	},
	-- Rare karaka
	{
		path .. "/schematics/karaka1.mts",
		{"default:dirt_with_rainforest_litter",},
		can_rare_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min + 2,
	},
	{
		path .. "/schematics/karaka2.mts",
		{"default:dirt_with_rainforest_litter",},
		can_rare_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min + 2,
	},
	-- Karaka groves
	{
		path .. "/schematics/karaka1.mts",
		{"default:dirt_with_grass",},
		nil,
		{"coastal_scrub",},
		coastf_max,
		coastf_min + 2,
		{
			offset = 0,
			scale = 0.004,
			spread = cl_spr,
			seed = 45254,
			octaves = cl_oct,
			persist = 0.8,
		}
	},
	{
		path .. "/schematics/karaka2.mts",
		{"default:dirt_with_grass",},
		nil,
		{"coastal_scrub",},
		coastf_max,
		coastf_min + 2,
		{
			offset = 0,
			scale = 0.004,
			spread = cl_spr,
			seed = 108761,
			octaves = cl_oct,
			persist = 0.8,
		}
	},
	-- Rare kamahi
	{
		path .. "/schematics/kamahi1.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_rainforest_litter",
		},
		can_rare_fill,
		{
			"mountain_beech_forest",
			"pahautea_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"muttonbird_scrub",
		},
		highf_max - 2,
		dune_max + 3,
	},
	{
		path .. "/schematics/kamahi2.mts",
		{
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_rainforest_litter",
		},
		can_rare_fill,
		{
			"mountain_beech_forest",
			"pahautea_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"muttonbird_scrub",
		},
		highf_max - 2,
		dune_max + 3,
	},
	-- Dense kamahi
	{
		path .. "/schematics/kamahi1.mts",
		{"aotearoa:dirt_with_moss",},
		can_x_dense_fill,
		{"kamahi_forest",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/kamahi2.mts",
		{"aotearoa:dirt_with_moss",},
		can_x_dense_fill,
		{"kamahi_forest",},
		lowf_max,
		lowf_min,
	},

	-- Shrubs and Palms etc...

	-- Common tree daisy clumps
	{
		path .. "/schematics/common_tree_daisy1.mts",
		{"default:dirt_with_rainforest_litter",},
		nil,
		{"muttonbird_scrub",},
		coastf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.07,
			spread = cl_spr,
			seed = 1641230,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		path .. "/schematics/common_tree_daisy2.mts",
		{"default:dirt_with_rainforest_litter",},
		nil,
		{"muttonbird_scrub",},
		coastf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.07,
			spread = cl_spr,
			seed = 3022605,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Nikau palm clump
	{
		aotearoa.nikau_palm1,
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_grass",
			"default:dirt_with_rainforest_litter",
		},
		nil,
		{
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
			"coastal_scrub",
			"pohutukawa_forest",
		},
		lowf_max,
		coastf_min + 2,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 603507,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		aotearoa.nikau_palm2,
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_grass",
			"default:dirt_with_rainforest_litter",
		},
		nil,
		{
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
			"coastal_scrub",
			"pohutukawa_forest",
		},
		lowf_max,
		coastf_min + 2,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 542122,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Cabbage tree clump
	{
		aotearoa.cabbage_tree1,
		{
			"aotearoa:forest_peat",
			"default:dirt_with_grass",
			"default:dirt_with_rainforest_litter",
			"default:sand",
			"aotearoa:iron_sand",
		},
		nil,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"kahikatea_swamp",
			"coastal_scrub",
			"pohutukawa_forest",
			"pohutukawa_dunes",
			"sand_dunes",
			"iron_sand_dunes",
		},
		lowf_max,
		beach_max,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 60715,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		aotearoa.cabbage_tree2,
		{
			"aotearoa:forest_peat",
			"default:dirt_with_grass",
			"default:dirt_with_rainforest_litter",
			"default:sand",
			"aotearoa:iron_sand",
		},
		nil,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"kahikatea_swamp",
			"coastal_scrub",
			"pohutukawa_forest",
			"pohutukawa_dunes",
			"sand_dunes",
			"iron_sand_dunes",
		},
		lowf_max,
		beach_max,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 238412,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Rare nikau palm
	{
		aotearoa.nikau_palm1,
		{
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_dry_grass",
		},
		can_rare_fill,
		{
			"hinau_forest",
			"southern_podocarp_forest",
			"northern_podocarp_forest",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min + 2,
	},
	{
		aotearoa.nikau_palm2,
		{
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_dry_grass",
		},
		can_rare_fill,
		{
			"hinau_forest",
			"northern_podocarp_forest",
			"southern_podocarp_forest",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min + 2,
	},
	-- Rare cabbage tree
	{
		aotearoa.cabbage_tree1,
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_dry_grass",
		},
		can_rare_fill,
		{
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min,
	},
	{
		aotearoa.cabbage_tree2,
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"default:dirt_with_dry_grass",
		},
		can_rare_fill,
		{
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min,
	},

	-- Mamaku clump
	{
		aotearoa.mamaku1,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 4588017,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		aotearoa.mamaku2,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"broadleaf_scrub",
			"geothermal_scrub",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 8945192,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Silver fern clump
	{
		aotearoa.silver_fern1,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 456687,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		aotearoa.silver_fern2,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 8966892,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Wheki clump
	{
		aotearoa.wheki2,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"kamahi_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 688807,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		aotearoa.wheki1,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		nil,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"kamahi_forest",
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,lowf_min,
		{
			offset = 0,
			scale = 0.005,
			spread = cl_spr,
			seed = 564592,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Dense wheki
	{
		aotearoa.wheki2,
		{"default:dirt_with_rainforest_litter",},
		scan_x_dense_fill,
		{"broadleaf_scrub",},
		lowf_max,
		lowf_min,
	},
	{
		aotearoa.wheki1,
		{"default:dirt_with_rainforest_litter",},
		scan_dense_fill,
		{"broadleaf_scrub",},
		lowf_max,
		lowf_min,
	},

	-- Rare pohutukawa on dunes
	{
		path .. "/schematics/pohutukawa1.mts",
		{"default:sand",},
		can_rare_fill,
		{"pohutukawa_dunes",},
		dune_max,
		beach_max,
	},
	{
		path .. "/schematics/pohutukawa2.mts",
		{"default:sand",},
		can_rare_fill,
		{"pohutukawa_dunes",},
		dune_max,
		beach_max,
	},
	-- Pohutukawa forest
	{
		path .. "/schematics/pohutukawa1.mts",
		{"default:dirt_with_rainforest_litter",},
		can_sparse_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min,
	},
	{
		path .. "/schematics/pohutukawa2.mts",
		{"default:dirt_with_rainforest_litter",},
		can_sparse_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min,
	},
	-- Mahoe
	{
		path .. "/schematics/mahoe1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_fill,
		{
			"broadleaf_scrub",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/mahoe2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_fill,
		{
			"broadleaf_scrub",
			"hinau_forest",
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare mahoe
	{
		path .. "/schematics/mahoe1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_rare_fill,
		{
			"geothermal_scrub",
			"kamahi_forest",
			"beech_forest",
			"southern_podocarp_forest",
			"northern_podocarp_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/mahoe2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_rare_fill,
		{
			"geothermal_scrub",
			"kamahi_forest",
			"beech_forest",
			"southern_podocarp_forest",
			"northern_podocarp_forest",
		},
		lowf_max,
		lowf_min,
	},

	-- Karo clumps
	{
		path .. "/schematics/karo1.mts",
		{
			"default:dirt_with_grass",
			"default:sand",
			"aotearoa:iron_sand",
			"default:gravel",
		},
		nil,
		{
			"coastal_scrub",
			"pohutukawa_forest",
			"pohutukawa_dunes",
			"sand_dunes",
			"iron_sand_dunes",
			"gravel_dunes",
		},
		coastf_max,
		beach_max,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr,
			seed = 120140,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	{
		path .. "/schematics/karo2.mts",
		{
			"default:dirt_with_grass",
			"default:sand",
			"aotearoa:iron_sand",
			"default:gravel",
		},
		nil,
		{
			"coastal_scrub",
			"pohutukawa_forest",
			"pohutukawa_dunes",
			"sand_dunes",
			"iron_sand_dunes",
			"gravel_dunes",
		},
		coastf_max,
		beach_max,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr,
			seed = 304525,
			octaves = cl_oct,
			persist = 0.7,
		}
	},
	-- Manuka clumps
	{
		path .. "/schematics/manuka1.mts",
		{
			"default:dirt_with_dry_grass",
			"default:dirt_with_grass",
		},
		nil,
		{
			"coastal_tussock",
			"coastal_scrub",
		},
		lowf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.03,
			spread = cl_spr,
			seed = 1646630,
			octaves = cl_oct,
			persist = 0.8,
		}
	},
	{
		path .. "/schematics/manuka2.mts",
		{
			"default:dirt_with_dry_grass",
			"default:dirt_with_grass",
		},
		nil,
		{
			"coastal_tussock",
			"coastal_scrub",
		},
		lowf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.03,
			spread = cl_spr,
			seed = 3121165,
			octaves = cl_oct,
			persist = 0.8,
		}
	},
	-- Rare manuka clump
	{
		path .. "/schematics/manuka1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:gumland_soil",
			"aotearoa:restiad_peat",
		},
		nil,
		{
			"geothermal_scrub",
			"gumland",
			"fen",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr2,
			seed = 1622230,
			octaves = cl_oct,
			persist = 0.95,
		}
	},
	{
		path .. "/schematics/manuka2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:gumland_soil",
			"aotearoa:restiad_peat",
		},
		nil,
		{
			"geothermal_scrub",
			"gumland",
			"fen",
		},
		lowf_max,
		lowf_min,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr2,
			seed = 1125565,
			octaves = cl_oct,
			persist = 0.95,
		}
	},
	-- Karo subcanopy
	{
		path .. "/schematics/karo1.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min,
	},
	{
		path .. "/schematics/karo2.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_fill,
		{"pohutukawa_forest",},
		coastf_max,
		coastf_min,
	},
	-- Matagouri clumps
	{
		path .. "/schematics/matagouri1.mts",
		{"default:dirt_with_dry_grass",},
		nil,
		{
			"matagouri_scrub",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr,
			seed = 761090,
			octaves = cl_oct,
			persist = 0.9,
		}
	},
	{
		path .. "/schematics/matagouri2.mts",
		{"default:dirt_with_dry_grass",},
		nil,
		{
			"matagouri_scrub",
			"coastal_tussock",
		},
		lowf_max,
		coastf_min,
		{
			offset = 0,
			scale = 0.01,
			spread = cl_spr,
			seed = 413475,
			octaves = cl_oct,
			persist = 0.9,
		}
	},

	-- Rare rangiora
	{
		path .. "/schematics/rangiora1.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_rare_fill,
		{
			"geothermal_scrub",
			"kamahi_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/rangiora2.mts",
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_rare_fill,
		{
			"geothermal_scrub",
			"kamahi_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rangiora
	{
		path .. "/schematics/rangiora1.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_fill,
		{"broadleaf_scrub",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/rangiora2.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_fill,
		{"broadleaf_scrub",},
		lowf_max,
		lowf_min,
	},

	-- Kawakawa
	{
		path .. "/schematics/kawakawa1.mts",
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_fill,
		{
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/kawakawa2.mts",
		{
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
		},
		scan_fill,
		{
			"maire_forest",
			"tawa_forest",
			"kauri_forest",
		},
		lowf_max,
		lowf_min,
	},
	-- Rare kawakawa
	{
		path .. "/schematics/kawakawa1.mts",
		{
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_rainforest_litter",
		},
		scan_rare_fill,
		{
			"northern_podocarp_forest",
			"pohutukawa_forest",
		},
		lowf_max,
		coastf_min + 2,
	},
	{
		path .. "/schematics/kawakawa2.mts",
		{
			"aotearoa:dirt_with_dark_litter",
			"default:dirt_with_rainforest_litter",
		},
		scan_rare_fill,
		{
			"northern_podocarp_forest",
			"pohutukawa_forest",
		},
		lowf_max,
		coastf_min + 2,
	},
	-- Mangrove
	{
		path .. "/schematics/mangrove1.mts",
		{
			"aotearoa:mud_sinking",
			"aotearoa:mud",
		},
		nil,
		{"northern_estuary",},
		3,
		2,
		{
			offset = 0,
			scale = 0.078,
			spread = cl_spr,
			seed = 11712,
			octaves = cl_oct,
			persist = 0.35,
		}
	},
	{
		path .. "/schematics/mangrove2.mts",
		{
			"aotearoa:mud_sinking",
			"aotearoa:mud",
		},
		nil,
		{"northern_estuary",},
		3,
		2,
		{
			offset = 0,
			scale = 0.078,
			spread = cl_spr,
			seed = 15874,
			octaves = cl_oct,
			persist = 0.35,
		}
	},

	-- Rare common tree daisy
	{
		path .. "/schematics/common_tree_daisy1.mts",
		{"aotearoa:dirt_with_moss",},
		scan_rare_fill,
		{"pahautea_forest",},
		highf_max,
		highf_min,
	},
	{
		path .. "/schematics/common_tree_daisy2.mts",
		{"aotearoa:dirt_with_moss",},
		scan_rare_fill,
		{"pahautea_forest",},
		highf_max,
		highf_min,
	},

	-- Woody bushes...

	-- Dense leatherwood (muttonbird)
	{
		path .. "/schematics/leatherwood1.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_x_dense_fill,
		{"muttonbird_scrub",},
		coastf_max,
		coastf_min,
	},
	{
		path .. "/schematics/leatherwood2.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_x_dense_fill,
		{"muttonbird_scrub",},
		coastf_max,
		coastf_min,
	},
	-- Leatherwood (montane)
	{
		path .. "/schematics/leatherwood1.mts",
		{
			"default:dirt_with_dry_grass",
			"aotearoa:schist",
			"aotearoa:dirt_with_moss",
		},
		scan_dense_fill,
		{
			"fellfield",
			"mountain_tussock",
			"pahautea_forest",
		},
		highf_max + 2,
		highf_min + 5,
	},
	{
		path .. "/schematics/leatherwood2.mts",
		{
			"default:dirt_with_dry_grass",
			"aotearoa:schist",
			"aotearoa:dirt_with_moss",
		},
		scan_dense_fill,
		{
			"fellfield",
			"mountain_tussock",
			"pahautea_forest",
		},
		highf_max + 2,
		highf_min + 5,
	},

	-- Sparse kokomuka
	{
		path .. "/schematics/kokomuka1.mts",
		{"default:dirt_with_dry_grass",},
		scan_sparse_fill,
		{"coastal_tussock",},
		coastf_max,
		coastf_min,
	},
	{
		path .. "/schematics/kokomuka2.mts",
		{"default:dirt_with_dry_grass",},
		scan_sparse_fill,
		{"coastal_tussock",},
		coastf_max,
		coastf_min,
	},

	-- Raupo
	{
		aotearoa.raupo1,
		{"aotearoa:mud_sinking",},
		0.7,
		{"raupo_swamp",},
		lowf_max / 2,
		coastf_min + 2,
	},
	{
		aotearoa.raupo2,
		{"aotearoa:mud_sinking",},
		0.7,
		{"raupo_swamp",},
		lowf_max / 2,
		coastf_min + 2,
	},
	-- Rotten stump
	{
		aotearoa.stump1,
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:restiad_peat",
			"aotearoa:gumland_soil",
			"aotearoa:forest_peat",
		},
		can_sparse_fill,
		{
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
			"fen",
			"gumland",
			"kahikatea_swamp",
		},
		lowf_max,
		coastf_min + 2,
	},
	{
		aotearoa.stump2,
		{
			"aotearoa:dirt_with_beech_litter",
			"aotearoa:dirt_with_dark_litter",
			"aotearoa:dirt_with_dry_litter",
			"aotearoa:restiad_peat",
			"aotearoa:gumland_soil",
			"aotearoa:forest_peat",
		},
		can_sparse_fill,
		{
			"fiordland_forest",
			"beech_forest",
			"hinau_forest",
			"southern_podocarp_forest",
			"maire_forest",
			"tawa_forest",
			"northern_podocarp_forest",
			"kauri_forest",
			"fen",
			"gumland",
			"kahikatea_swamp",
		},
		lowf_max,
		coastf_min + 2,
	},
	-- Dense rotten stump
	{
		aotearoa.stump1,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
		},
		can_fill,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"mountain_beech_forest",
			"pahautea_forest",
			"kamahi_forest",
		},
		highf_max,
		lowf_min,
	},
	{
		aotearoa.stump2,
		{
			"default:dirt_with_rainforest_litter",
			"aotearoa:dirt_with_moss",
		},
		can_fill,
		{
			"manuka_scrub",
			"broadleaf_scrub",
			"geothermal_scrub",
			"mountain_beech_forest",
			"pahautea_forest",
			"kamahi_forest",
		},
		highf_max,
		lowf_min,
	},
	-- Dense manuka
	{
		path .. "/schematics/manuka1.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_x_dense_fill,
		{"manuka_scrub",},
		lowf_max,
		lowf_min,
	},
	{
		path .. "/schematics/manuka2.mts",
		{"default:dirt_with_rainforest_litter",},
		scan_x_dense_fill,
		{"manuka_scrub",},
		lowf_max,
		lowf_min,
	},
}


for i in ipairs(aotearoa.schematics_deco_list) do
	local decoration  = aotearoa.schematics_deco_list[i][1]
	local substrate   = aotearoa.schematics_deco_list[i][2]
	local density     = aotearoa.schematics_deco_list[i][3]
	local habitat     = aotearoa.schematics_deco_list[i][4]
	local max_alt     = aotearoa.schematics_deco_list[i][5]
	local min_alt     = aotearoa.schematics_deco_list[i][6]
	local noise       = aotearoa.schematics_deco_list[i][7]
	local next_to     = aotearoa.schematics_deco_list[i][8]
	local next_to_num = aotearoa.schematics_deco_list[i][9]

	-- Either uniformly spread, clumped, or spawned-by (not using noise).
	if density ~= nil then
		if next_to then
			minetest.register_decoration({
				deco_type = "schematic",
				place_on = substrate,
				sidelen = 8,
				fill_ratio = density,
				biomes = habitat,
				y_min = min_alt,
				y_max = max_alt,
				schematic = decoration,
				replacements = {["air"] = "ignore",},
				flags = "place_center_x, place_center_z",
				rotation = "random",
				spawn_by = next_to,
				num_spawn_by = next_to_num,
			})
		else
			minetest.register_decoration({
				deco_type = "schematic",
				place_on = substrate,
				sidelen = 8,
				fill_ratio = density,
				biomes = habitat,
				y_min = min_alt,
				y_max = max_alt,
				schematic = decoration,
				replacements = {["air"] = "ignore",},
				flags = "place_center_x, place_center_z",
				rotation = "random",
			})
		end
	else
		minetest.register_decoration({
			deco_type = "schematic",
			place_on = substrate,
			sidelen = 8,
			noise_params = noise,
			biomes = habitat,
			y_min = min_alt,
			y_max = max_alt,
			schematic = decoration,
			replacements = {["air"] = "ignore",},
			flags = "place_center_x, place_center_z",
			rotation = "random",
		})
	end
end
