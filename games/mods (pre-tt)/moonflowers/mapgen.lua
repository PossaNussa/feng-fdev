--
-- Detect mapgen to select functions
--

local mg_name = minetest.get_mapgen_setting("mg_name")
if mg_name == "v6" then

	--
	-- Mgv6
	--

	minetest.register_decoration({
		name = "moonflowers:moonflower",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter", "default:dirt_with_snow", "default:dry_dirt_with_dry_grass", "default:dirt_with_rainforest_litter"},
		sidelen = 16,
		noise_params = {
			offset = -0.01,
			scale = 0.05,
			spread = {x = 200, y = 200, z = 200},
			seed = 238900,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 20,
		decoration = "moonflowers:moonflower",
		spawn_by = {"group:tree"},
		num_spawn_by = 1,
	})

else

	--
	-- All other biome API mapgens
	--

	minetest.register_decoration({
		name = "moonflowers:moonflower",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter", "default:dirt_with_snow", "default:dry_dirt_with_dry_grass", "default:dirt_with_rainforest_litter"},
		sidelen = 16,
		noise_params = {
			offset = -0.01,
			scale = 0.05,
			spread = {x = 200, y = 200, z = 200},
			seed = 238900,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"deciduous_forest", "coniferous_forest", "rainforest", "taiga", "savanna", "rainforest"},
		y_max = 30,
		y_min = 20,
		decoration = "moonflowers:moonflower",
		spawn_by = {"group:tree"},
		num_spawn_by = 1,
	})

end
