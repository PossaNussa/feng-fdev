--------------------
-- PaleoTest Ores --
--------------------
------ Ver 2.0 -----


--------------------
-- Ore Definition --
--------------------

-- Fossil Block --

-- Near-surface fossils: reduced from 64^3=262144 to 16^3=4096 (diamond tier, findable)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -32,
})

-- Mid-depth fossils: reduced from 32^3=32768 to 10^3=1000 (iron tier)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:stone",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -32,
	y_min          = -128,
})

-- Deep fossils: reduced from 16^3=4096 to 8^3=512 (coal tier, most abundant)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -128,
	y_min          = -31000,
})

-- Sedimentary strata fossils (higher density than stone — fossils concentrate here)

-- Silt layer (surface/near-surface, youngest fossils)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:silt",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 2,
	clust_size     = 2,
	y_max          = 60,
	y_min          = -10,
})

-- Shale (classic fossil-bearing, two zones: shallow hills and deep)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:shale",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 200,
	y_min          = -31000,
})

-- Limestone (best marine fossil preservation)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:limestone",
	clust_scarcity = 9 * 9 * 9,
	clust_num_ores = 6,
	clust_size     = 3,
	y_max          = 200,
	y_min          = -31000,
})

-- Sandstone (fluvial/terrestrial fossils)
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:fossil_block",
	wherein        = "default:sandstone",
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = 200,
	y_min          = -31000,
})

-- Suspicious Permafrost: reduced from 32^3=32768 to 18^3=5832

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:suspicious_permafrost",
	wherein        = "default:permafrost_with_stones",
	clust_scarcity = 18 * 18 * 18,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "paleotest:suspicious_permafrost",
	wherein        = "default:permafrost",
	clust_scarcity = 18 * 18 * 18,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})