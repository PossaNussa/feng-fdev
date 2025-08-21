--
-- Aliases for map generators
--

-- All mapgens

minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_water_source", "default:water_source")
minetest.register_alias("mapgen_river_water_source", "default:river_water_source")

-- Additional aliases needed for mapgen v6

minetest.register_alias("mapgen_lava_source", "default:lava_source")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_gravel", "default:gravel")
minetest.register_alias("mapgen_desert_stone", "default:desert_stone")
minetest.register_alias("mapgen_desert_sand", "default:desert_sand")
minetest.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
minetest.register_alias("mapgen_snowblock", "default:snowblock")
minetest.register_alias("mapgen_snow", "default:snow")
minetest.register_alias("mapgen_ice", "default:ice")

minetest.register_alias("mapgen_tree", "default:tree")
minetest.register_alias("mapgen_leaves", "default:leaves")
minetest.register_alias("mapgen_apple", "default:apple")
minetest.register_alias("mapgen_jungletree", "default:jungletree")
minetest.register_alias("mapgen_jungleleaves", "default:jungleleaves")
minetest.register_alias("mapgen_junglegrass", "default:junglegrass")
minetest.register_alias("mapgen_pine_tree", "default:pine_tree")
minetest.register_alias("mapgen_pine_needles", "default:pine_needles")

minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
minetest.register_alias("mapgen_mossycobble", "default:mossycobble")
minetest.register_alias("mapgen_stair_desert_stone", "stairs:stair_desert_stone")

-- === Biome amplification hook (no call-site changes) ========================
-- Add `amplification = <number>` inside ANY minetest.register_biome({...}).
-- This shim records the value and removes the field before delegating to engine.

default = rawget(_G, "default") or {}
default._biome_amp    = default._biome_amp    or {}
default._biome_layers = default._biome_layers or {}

do
  local _orig_register_biome = minetest.register_biome
  function minetest.register_biome(def)
    if def and def.name then
      -- remember amplification and surface layers for later column fix-up
      default._biome_amp[def.name] = tonumber(def.amplification) or 1.0
      default._biome_layers[def.name] = {
        node_top     = def.node_top,
        node_filler  = def.node_filler,
        depth_top    = def.depth_top   or 1,
        depth_filler = def.depth_filler or 3,
      }
      def.amplification = nil -- engine doesn’t know this key
    end
    return _orig_register_biome(def)
  end
end
-- ===========================================================================


minetest.register_on_generated(function(minp, maxp, seed)
    minetest.after(0.1, function(minp, maxp, seed)
        local vm = minetest.get_voxel_manip(minp, maxp)
        local area = VoxelArea:new({MinEdge=minp, MaxEdge=maxp})
        local data = vm:get_data()

        local c_sand = minetest.get_content_id("default:sand")
        local c_mud = minetest.get_content_id("default:mud")

        local primary_noise = minetest.get_perlin(seed, 3, 0.5, 128) -- To decide primary node for larger regions
        local transition_noise = minetest.get_perlin(seed + 1, 3, 0.5, 8) -- To smooth out transitions between regions

        for z = minp.z, maxp.z do
            for x = minp.x, maxp.x do
                local primary_value = primary_noise:get2d({x=x, y=z})
                local transition_value = transition_noise:get2d({x=x, y=z})

                for y = minp.y, maxp.y do
                    local vi = area:index(x, y, z)
                    if data[vi] == c_sand then
                        if primary_value < 0.05 then 
                            data[vi] = c_mud
                        elseif primary_value >= 0.05 and primary_value < 0.07 then
                            -- Applying transition noise
                            if transition_value < 0 then
                                data[vi] = c_mud
                            end
                        end
                    end
                end
            end
        end

        vm:set_data(data)
        vm:update_liquids()
        vm:write_to_map()
    end, minp, maxp, seed)
end)
--
-- Register ores
--


-- Mgv6

function default.register_mgv6_ores()

	-- Blob ore
	-- These first to avoid other ores in blobs

	-- Clay
	-- This first to avoid clay in sand blobs

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:clay",
		wherein         = {"default:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})
-- Layer 3: Clay from -15 to -30 (stratum)


	-- Sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:sand",
		wherein         = {"default:stone", "default:desert_stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:marble",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 1234,
			octaves = 1,
			persist = 0.0
		},
	})
	
	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:quartz",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})


	-- Scatter ores

	-- Coal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 9,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -31000,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_max          = 0,
		y_min          = -31000,
	})

	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 12,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:granite_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 7 * 7 * 7,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -500,
		y_min          = -650,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:basalt_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 24 * 24 * 24,
		clust_num_ores = 27,
		clust_size     = 6,
		y_max          = -800,
		y_min          = -1024,
	})



	-- Copper

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_copper",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})


	-- Tin

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 10 * 10 * 10,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -340,
		y_min          = -500,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -650,
		y_min          = -800,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:gneiss_with_silver",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -650,
		y_min          = -800,
	})

	-- Diamond

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 4,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	-- Mese block

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "default:stone",
		clust_scarcity = 36 * 36 * 36,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "default:stone",
		clust_scarcity = 36 * 36 * 36,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -1024,
		y_min          = -31000,
	})
	
	minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bones:bones",
	wherein        = "default:stone",
	clust_scarcity = 8 * 8 * 8, -- You can adjust this value to make it rarer or more common
	clust_num_ores = 1,  -- Set to 1 to spawn individual bones
	clust_size     = 1,  -- Also set to 1 as we're spawning individual bones
	y_max          = -15,
	y_min          = -3000,
})
	
end


-- All mapgens except mgv6

function default.register_ores()

	-- Stratum ores.
	-- These obviously first.

    -- Layer 1: Dirt from -3 to -5
    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:dirt",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = -5,
        y_max = 5,
    })

	    -- Layer 2 Above Ground: Clay/Mud from 5 to 15

    minetest.register_ore({
        ore_type = "stratum",
        ore = "default:mud",
        wherein = "default:stone",
        clust_scarcity = 1,
        clust_size = 1,
        y_min = 5,
        y_max = 15,
    })
	
	-- Sand blobs in Clay and Stone
minetest.register_ore({
    ore_type = "blob",
    ore = "default:sand",
    wherein = "default:stone",
    clust_scarcity = 4 * 4 * 4,
    clust_size = 48,
    y_min = -30,
    y_max = -15,
})



minetest.register_ore({
    ore_type = "blob",
    ore = "default:mud",
    wherein = "default:stone",
    clust_scarcity = 16 * 16 * 16,
    clust_size = 48,
    y_min = -30,
    y_max = -15,
})






	-- Silver sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:silver_sandstone",
		wherein         = {"default:stone"},
		clust_scarcity  = 1,
		y_max           = 46,
		y_min           = 10,
		noise_params    = {
			offset = 28,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 4,
		biomes = {"cold_desert"},
	})

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:silver_sandstone",
		wherein         = {"default:stone"},
		clust_scarcity  = 1,
		y_max           = 42,
		y_min           = 6,
		noise_params    = {
			offset = 24,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"cold_desert"},
	})

	-- Desert sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:desert_sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 46,
		y_min           = 10,
		noise_params    = {
			offset = 28,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 4,
		biomes = {"desert"},
	})

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:desert_sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 42,
		y_min           = 6,
		noise_params    = {
			offset = 24,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"desert"},
	})

	-- Sandstone

	minetest.register_ore({
		ore_type        = "stratum",
		ore             = "default:sandstone",
		wherein         = {"default:desert_stone"},
		clust_scarcity  = 1,
		y_max           = 39,
		y_min           = 3,
		noise_params    = {
			offset = 21,
			scale = 16,
			spread = {x = 128, y = 128, z = 128},
			seed = 90122,
			octaves = 1,
		},
		stratum_thickness = 2,
		biomes = {"desert"},
	})

	-- Blob ore.
	-- These before scatter ores to avoid other ores in blobs.

	-- Clay

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:clay",
		wherein         = {"default:sand"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 0,
		y_min           = -15,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = -316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Silver sand

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:quartz",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 2316,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Dirt

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:dirt",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 17676,
			octaves = 1,
			persist = 0.0
		},
		-- Only where default:dirt is present as surface material
		biomes = {"taiga", "snowy_grassland", "grassland", "coniferous_forest",
				"deciduous_forest", "deciduous_forest_shore", "rainforest", "grove", 
				"rainforest_swamp"}
	})

	-- Gravel

	minetest.register_ore({
		ore_type        = "blob",
		ore             = "default:gravel",
		wherein         = {"default:stone"},
		clust_scarcity  = 16 * 16 * 16,
		clust_size      = 5,
		y_max           = 31000,
		y_min           = -31000,
		noise_threshold = 0.0,
		noise_params    = {
			offset = 0.5,
			scale = 0.2,
			spread = {x = 5, y = 5, z = 5},
			seed = 766,
			octaves = 1,
			persist = 0.0
		},
	})

	-- Scatter ores

	-- Coal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 9,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 8 * 8 * 8,
		clust_num_ores = 8,
		clust_size     = 3,
		y_max          = 64,
		y_min          = -127,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_coal",
		wherein        = "default:stone",
		clust_scarcity = 12 * 12 * 12,
		clust_num_ores = 30,
		clust_size     = 5,
		y_max          = -128,
		y_min          = -31000,
	})

	-- Tin

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_tin",
		wherein        = "default:stone",
		clust_scarcity = 10 * 10 * 10,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})



	-- Copper

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_copper",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})


	-- Iron

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_iron",
		wherein        = "default:stone",
		clust_scarcity = 9 * 9 * 9,
		clust_num_ores = 12,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})


	-- Gold

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 13 * 13 * 13,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_gold",
		wherein        = "default:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -340,
		y_min          = -500,
	})



	-- Mese crystal

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_mese",
		wherein        = "default:stone",
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_mese",
		wherein        = "default:stone",
		clust_scarcity = 18 * 18 * 18,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -512,
		y_min          = -1023,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_mese",
		wherein        = "default:stone",
		clust_scarcity = 14 * 14 * 14,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -1024,
		y_min          = -31000,
	})

	-- Diamond

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:stone_with_diamond",
		wherein        = "default:stone",
		clust_scarcity = 15 * 15 * 15,
		clust_num_ores = 4,
		clust_size     = 3,
		y_max          = 31000,
		y_min          = 1025,
	})


	-- Mese block

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "default:stone",
		clust_scarcity = 36 * 36 * 36,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = 31000,
		y_min          = 1025,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "default:stone",
		clust_scarcity = 36 * 36 * 36,
		clust_num_ores = 3,
		clust_size     = 2,
		y_max          = -2048,
		y_min          = -4095,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "default:mese",
		wherein        = "default:stone",
		clust_scarcity = 28 * 28 * 28,
		clust_num_ores = 5,
		clust_size     = 3,
		y_max          = -4096,
		y_min          = -31000,
	})
end


--
-- Register biomes
--

-- All mapgens except mgv6

function default.register_biomes()

	-- Icesheet

	minetest.register_biome({
		name = "icesheet",
		node_dust = "default:snowblock",
		node_top = "default:snowblock",
		depth_top = 1,
		node_filler = "default:snowblock",
		depth_filler = 3,
		node_stone = "default:cave_ice",
		node_water_top = "default:ice",
		node_water = "sailing:shallow_water_source",
		depth_water_top = 10,
		node_river_water = "default:ice",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_dungeon = "default:ice",
		node_dungeon_stair = "stairs:stair_ice",
		y_max = 31000,
		y_min = -8,
		heat_point = 0,
		humidity_point = 73,
	})

	minetest.register_biome({
		name = "icesheet_ocean",
		node_dust = "default:snowblock",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_water = "sailing:shallow_water_source",
		node_water_top = "default:ice",
		depth_water_top = 10,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -9,
		y_min = -255,
		heat_point = 0,
		humidity_point = 73,
	})

	minetest.register_biome({
		name = "icesheet_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		node_water = "sailing:shallow_water_source",
		y_max = -256,
		y_min = -31000,
		heat_point = 0,
		humidity_point = 73,
	})

	-- Tundra

	minetest.register_biome({
		name = "tundra_highland",
		node_dust = "default:snow",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_water = "sailing:shallow_water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 47,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra",
		node_top = "default:permafrost_with_stones",
		depth_top = 1,
		node_water = "sailing:shallow_water_source",
		node_filler = "default:permafrost",
		depth_filler = 1,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 4,
		y_max = 46,
		y_min = 2,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_beach",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 2,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 1,
		y_min = -3,
		node_water = "sailing:shallow_water_source",
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		node_water = "sailing:shallow_water_source",
		y_max = -4,
		y_min = -255,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		node_water = "sailing:shallow_water_source",
		y_max = -256,
		y_min = -31000,
		heat_point = 0,
		humidity_point = 40,
	})

	-- Taiga

	minetest.register_biome({
		name = "taiga",
		node_dust = "default:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_water = "default:river_water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 4,
		heat_point = 25,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "taiga_ocean",
		node_dust = "default:snow",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_water = "default:river_water_source",
		node_cave_liquid = "default:river_water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 3,
		y_min = -255,
		heat_point = 25,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "taiga_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_water = "default:river_water_source",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 25,
		humidity_point = 70,
	})

	-- Snowy grassland

	minetest.register_biome({
		name = "snowy_grassland",
		node_dust = "default:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_water = "default:river_water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 4,
		heat_point = 20,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "snowy_grassland_ocean",
		node_dust = "default:snow",
		node_top = "default:sand",
		depth_top = 1,
		node_water = "default:river_water_source",
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 3,
		y_min = -255,
		heat_point = 20,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "snowy_grassland_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_water = "default:river_water_source",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 20,
		humidity_point = 35,
	})

	-- Grassland

	minetest.register_biome({
		name = "grassland",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 6,
		heat_point = 50,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "grassland_dunes",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 2,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 5,
		y_min = 4,
		heat_point = 50,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "grassland_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 3,
		y_min = -255,
		heat_point = 50,
		humidity_point = 35,
	})

	minetest.register_biome({
		name = "grassland_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 50,
		humidity_point = 35,
	})

	-- Coniferous forest

	minetest.register_biome({
		name = "coniferous_forest",
		node_top = "default:dirt_with_coniferous_litter",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_water = "default:river_water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 6,
		heat_point = 42,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "coniferous_forest_dunes",
		node_top = "default:sand",
		depth_top = 1,
		node_water = "default:river_water_source",
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 5,
		y_min = 4,
		heat_point = 42,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "coniferous_forest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 3,
		y_min = -255,
		heat_point = 42,
		humidity_point = 70,
	})

	minetest.register_biome({
		name = "coniferous_forest_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_water = "default:river_water_source",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 42,
		humidity_point = 70,
	})

	-- Deciduous forest

	minetest.register_biome({
		name = "deciduous_forest",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 1,
		heat_point = 60,
		humidity_point = 68,
	})
	
	
	minetest.register_biome({
		name = "grove",
		node_top = "default:dirt_with_grass",
		depth_top = 1,
		node_filler = "default:silt",
		depth_filler = 3,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		node_dungeon = "default:scobblebrick",
		node_dungeon_alt = "default:limestonebrick",
		node_dungeon_stair = "stairs:stair_sandstone_block",
		y_max = 31000,
		y_min = 1,
		heat_point = 65,
		humidity_point = 55,
	})

	minetest.register_biome({
		name = "deciduous_forest_shore",
		node_top = "default:dirt",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 0,
		y_min = -1,
		heat_point = 60,
		humidity_point = 68,
	})

	minetest.register_biome({
		name = "deciduous_forest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = -2,
		y_min = -255,
		heat_point = 60,
		humidity_point = 68,
	})

	minetest.register_biome({
		name = "deciduous_forest_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 60,
		humidity_point = 68,
	})

	-- Desert

	minetest.register_biome({
		name = "desert",
		node_top = "default:desert_sand",
		depth_top = 1,
		node_filler = "default:desert_sand",
		depth_filler = 1,
		node_stone = "default:desert_stone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:desert_stone",
		node_dungeon_stair = "stairs:stair_desert_stone",
		y_max = 31000,
		y_min = 4,
		heat_point = 92,
		humidity_point = 16,
	})

	minetest.register_biome({
		name = "desert_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "default:desert_stone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:desert_stone",
		node_dungeon_stair = "stairs:stair_desert_stone",
		vertical_blend = 1,
		y_max = 3,
		y_min = -255,
		heat_point = 92,
		humidity_point = 16,
	})

	minetest.register_biome({
		name = "desert_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 92,
		humidity_point = 16,
	})
-- Sakura forest

minetest.register_biome({
	name = "sakura_forest",
	node_top = "variety:japanese_dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
		node_water = "default:river_water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	node_dungeon_stair = "stairs:stair_cobble",
	y_max = 165,
	y_min = 1,
	heat_point = 65,
	humidity_point = 70,
})

minetest.register_biome({
	name = "sakura_forest_shore",
	node_top = "default:dirt",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	node_dungeon_stair = "stairs:stair_cobble",
	y_max = 0,
	y_min = -1,
	heat_point = 65,
	humidity_point = 70,
})

minetest.register_biome({
	name = "sakura_forest_ocean",
	node_top = "default:sand",
	depth_top = 1,
	node_filler = "default:sand",
	depth_filler = 3,
	node_riverbed = "default:sand",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
	node_dungeon_stair = "stairs:stair_cobble",
	node_stone = "default:granite",
	vertical_blend = 1,
	y_max = -2,
	y_min = -255,
	heat_point = 65,
	humidity_point = 70,
})

minetest.register_biome({
	name = "sakura_forest_under",
	node_cave_liquid = {"default:water_source", "default:lava_source"},
	node_dungeon = "default:cobble",
	node_dungeon_alt = "default:mossycobble",
		node_water = "default:river_water_source",
	node_dungeon_stair = "stairs:stair_cobble",
	node_stone = "default:granite",
	y_max = -256,
	y_min = -540,
	heat_point = 65,
	humidity_point = 70,
})
	-- Sandstone desert

	minetest.register_biome({
		name = "sandstone_desert",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 1,
		node_stone = "default:sandstone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:sandstonebrick",
		node_dungeon_stair = "stairs:stair_sandstone_block",
		y_max = 31000,
		y_min = 4,
		heat_point = 60,
		humidity_point = 1,
	})

	minetest.register_biome({
		name = "sandstone_desert_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "default:sandstone",
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:sandstonebrick",
		node_dungeon_stair = "stairs:stair_sandstone_block",
		y_max = 3,
		y_min = -255,
		heat_point = 60,
		humidity_point = 1,
	})

	minetest.register_biome({
		name = "sandstone_desert_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 60,
		humidity_point = 1,
	})

	-- Cold desert

	minetest.register_biome({
		name = "cold_desert",
		node_top = "default:silver_sand",
		depth_top = 1,
		node_filler = "default:silver_sand",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 4,
		heat_point = 40,
		humidity_point = 0,
	})

	minetest.register_biome({
		name = "cold_desert_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = 3,
		y_min = -255,
		heat_point = 40,
		humidity_point = 0,
	})

	minetest.register_biome({
		name = "cold_desert_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 40,
		humidity_point = 0,
	})

	-- Savanna

	minetest.register_biome({
		name = "savanna",
		node_top = "default:dry_dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dry_dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 1,
		heat_point = 88,
		humidity_point = 42,
	})

	minetest.register_biome({
		name = "savanna_shore",
		node_top = "default:dry_dirt",
		depth_top = 1,
		node_filler = "default:dry_dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 0,
		y_min = -1,
		heat_point = 88,
		humidity_point = 42,
	})

	minetest.register_biome({
		name = "savanna_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = -2,
		y_min = -255,
		heat_point = 88,
		humidity_point = 42,
	})

	minetest.register_biome({
		name = "savanna_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 88,
		humidity_point = 42,
	})

	-- Rainforest

	minetest.register_biome({
		name = "rainforest",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 1,
		heat_point = 90,
		humidity_point = 65,
	})

	minetest.register_biome({
		name = "rainforest_swamp",
		node_top = "default:dirt",
		depth_top = 1,
		node_filler = "default:mud",
		depth_filler = 3,
		node_riverbed = "default:mud",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 0,
		y_min = -1,
		heat_point = 90,
		humidity_point = 65,
	})

	minetest.register_biome({
		name = "rainforest_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_cave_liquid = "default:water_source",
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		vertical_blend = 1,
		y_max = -2,
		y_min = -255,
		heat_point = 90,
		humidity_point = 65,
	})

	minetest.register_biome({
		name = "rainforest_under",
		node_cave_liquid = {"default:water_source", "default:lava_source"},
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = -256,
		y_min = -31000,
		heat_point = 90,
		humidity_point = 65,
	})
end


--
-- Register decorations
--

-- Mgv6

function default.register_mgv6_decorations()


	-- Papyrus

	minetest.register_decoration({
		name = "default:papyrus",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 100, y = 100, z = 100},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		y_max = 1,
		y_min = 1,
		decoration = "default:papyrus",
		height = 2,
		height_max = 4,
		spawn_by = "default:water_source",
		num_spawn_by = 1,
	})

	-- Cacti

	minetest.register_decoration({
		name = "default:cactus",
		deco_type = "simple",
		place_on = {"default:desert_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.012,
			scale = 0.024,
			spread = {x = 100, y = 100, z = 100},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:cactus",
		height = 3,
	        height_max = 4,
	})

	-- Long grasses

	for length = 1, 5 do
		minetest.register_decoration({
			name = "default:grass_"..length,
			deco_type = "simple",
			place_on = {"default:dirt_with_grass"},
			sidelen = 16,
			noise_params = {
				offset = 0,
				scale = 0.007,
				spread = {x = 100, y = 100, z = 100},
				seed = 329,
				octaves = 3,
				persist = 0.6
			},
			y_max = 30,
			y_min = 1,
			decoration = "default:grass_"..length,
		})
	end

	-- Dry shrubs

	minetest.register_decoration({
		name = "default:dry_shrub",
		deco_type = "simple",
		place_on = {"default:desert_sand", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.035,
			spread = {x = 100, y = 100, z = 100},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "default:dry_shrub",
		param2 = 4,
	})
end


-- All mapgens except mgv6

local function register_grass_decoration(offset, scale, length)
	minetest.register_decoration({
		name = "default:grass_" .. length,
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:japanese_dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = scale,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"grassland", "deciduous_forest", "sakura_forest", "grove"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:grass_" .. length,
	})
end

local function register_dry_grass_decoration(offset, scale, length)
	minetest.register_decoration({
		name = "default:dry_grass_" .. length,
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass", "variety:meadow_dirt_with_grass", "default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = offset,
			scale = scale,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"savanna", "grove", "meadow", "prairie"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:dry_grass_" .. length,
	})
end

local function register_fern_decoration(seed, length)
	minetest.register_decoration({
		name = "default:fern_" .. length,
		deco_type = "simple",
		place_on = {"default:dirt_with_coniferous_litter", "default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.2,
			spread = {x = 100, y = 100, z = 100},
			seed = seed,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"coniferous_forest", "grove"},
		y_max = 31000,
		y_min = 6,
		decoration = "default:fern_" .. length,
	})
end


function default.register_decorations()
	-- Savanna bare dirt patches.
	-- Must come before all savanna decorations that are placed on dry grass.
	-- Noise is similar to long dry grass noise, but scale inverted, to appear
	-- where long dry grass is least dense and shortest.

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass", "default:dirt_with_grass"},
		sidelen = 4,
		noise_params = {
			offset = -1.5,
			scale = -1.5,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 4,
			persist = 1.0
		},
		biomes = {"savanna", "grove"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:dry_dirt",
		place_offset_y = -1,
		flags = "force_placement",
	})

	-- Apple tree and log



	minetest.register_decoration({
		name = "default:apple_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		place_offset_y = 1,
		sidelen = 16,
		noise_params = {
			offset = 0.0012,
			scale = 0.0007,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/apple_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_grass",
		num_spawn_by = 8,
	})

	minetest.register_decoration({
		name = "default:sakura_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:japanese_dirt_with_grass"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"sakura_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:sakura_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})
	
minetest.register_decoration({
    name = "default:mudspring(swamp)",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter", "default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
        offset = 0.0,
        scale = -0.005,
        spread = {x = 200, y = 200, z = 200},
        seed = 354,
        octaves = 1,
        persist = 0.5
    },
    biomes = {"rainforest", "rainforest_swamp", "grove"},
    y_max = 1,
    y_min = -4,
    place_offset_y = -1,  -- Shifts the schematic down by 3 nodes
    schematic = minetest.get_modpath("default") .. "/schematics/mudsprings.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})

	minetest.register_decoration({
		name = "default:jungle_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_rainforest_litter"},
		place_offset_y = 1,
		sidelen = 80,
		fill_ratio = 0.005,
		biomes = {"rainforest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/jungle_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_rainforest_litter",
		num_spawn_by = 8,
	})



	minetest.register_decoration({
		name = "default:pine_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		place_offset_y = 1,
		sidelen = 80,
		fill_ratio = 0.0018,
		biomes = {"taiga", "coniferous_forest"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		num_spawn_by = 8,
	})
	

	minetest.register_decoration({
		name = "default:acacia_log",
		deco_type = "schematic",
		place_on = {"default:dry_dirt_with_dry_grass"},
		place_offset_y = 1,
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.001,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/acacia_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dry_dirt_with_dry_grass",
		num_spawn_by = 8,
	})


	minetest.register_decoration({
		name = "default:aspen_log",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		place_offset_y = 1,
		sidelen = 16,
		noise_params = {
			offset = 0.0,
			scale = -0.0008,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/aspen_log.mts",
		flags = "place_center_x",
		rotation = "random",
		spawn_by = "default:dirt_with_grass",
		num_spawn_by = 8,
	})

	-- Large cactus

	minetest.register_decoration({
		name = "default:large_cactus",
		deco_type = "schematic",
		place_on = {"default:desert_sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.0003,
			scale = 0.0009,
			spread = {x = 200, y = 200, z = 200},
			seed = 230,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/large_cactus.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})



	-- Papyrus

	-- Dirt version for rainforest swamp

	minetest.register_decoration({
		name = "default:papyrus_on_dirt",
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"rainforest_swamp"},
		y_max = 0,
		y_min = 0,
		schematic = minetest.get_modpath("default") .. "/schematics/papyrus_on_dirt.mts",
	})

	-- Dry dirt version for savanna shore

	minetest.register_decoration({
		name = "default:papyrus_on_dry_dirt",
		deco_type = "schematic",
		place_on = {"default:dry_dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.3,
			scale = 0.7,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"savanna_shore"},
		y_max = 0,
		y_min = 0,
		schematic = minetest.get_modpath("default") ..
			"/schematics/papyrus_on_dry_dirt.mts",
	})

	-- Bush

	minetest.register_decoration({
		name = "default:bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grassland", "deciduous_forest", "sakura_forest"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/bush.mts",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.005,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Blueberry bush

	minetest.register_decoration({
		name = "default:blueberry_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_grass", "default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 697,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grassland", "snowy_grassland", "grove"},
		y_max = 31000,
		y_min = 1,
		place_offset_y = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/blueberry_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Acacia bush

	minetest.register_decoration({
		name = "default:acacia_bush",
		deco_type = "schematic",
		place_on = {"default:dry_dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 90155,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		schematic = minetest.get_modpath("default") .. "/schematics/acacia_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Pine bush

	minetest.register_decoration({
		name = "default:pine_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"taiga", "snowy_grassland"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_bush.mts",
		flags = "place_center_x, place_center_z",
	})
	minetest.register_decoration({
		name = "default:pine_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.005,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 4,
		schematic = minetest.get_modpath("default") .. "/schematics/pine_bush.mts",
		flags = "place_center_x, place_center_z",
	})

	-- Grasses

	register_grass_decoration(-0.03,  0.09,  5)
	register_grass_decoration(-0.015, 0.075, 4)
	register_grass_decoration(0,      0.06,  3)
	register_grass_decoration(0.015,  0.045, 2)
	register_grass_decoration(0.03,   0.03,  1)

	-- Dry grasses

	register_dry_grass_decoration(0.01, 0.05,  5)
	register_dry_grass_decoration(0.03, 0.03,  4)
	register_dry_grass_decoration(0.05, 0.01,  3)
	register_dry_grass_decoration(0.07, -0.01, 2)
	register_dry_grass_decoration(0.09, -0.03, 1)

	-- Ferns

	register_fern_decoration(14936, 3)
	register_fern_decoration(801,   2)
	register_fern_decoration(5,     1)

	-- Junglegrass

	minetest.register_decoration({
		name = "default:junglegrass",
		deco_type = "simple",
		place_on = {"default:dirt_with_rainforest_litter"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"rainforest"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:junglegrass",
	})

	-- Dry shrub

	minetest.register_decoration({
		name = "default:dry_shrub",
		deco_type = "simple",
		place_on = {"default:desert_sand",
			"default:sand", "default:silver_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.02,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"desert", "sandstone_desert", "cold_desert"},
		y_max = 31000,
		y_min = 2,
		decoration = "default:dry_shrub",
		param2 = 4,
	})

	-- Marram grass

	minetest.register_decoration({
		name = "default:marram_grass",
		deco_type = "simple",
		place_on = {"default:sand"},
		sidelen = 4,
		noise_params = {
			offset = -0.7,
			scale = 4.0,
			spread = {x = 16, y = 16, z = 16},
			seed = 513337,
			octaves = 1,
			persist = 0.0,
			flags = "absvalue, eased"
		},
		biomes = {"coniferous_forest_dunes", "grassland_dunes"},
		y_max = 6,
		y_min = 4,
		decoration = {
			"default:marram_grass_1",
			"default:marram_grass_2",
			"default:marram_grass_3",
		},
	})

	-- Tundra moss

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:permafrost_with_stones"},
		sidelen = 4,
		noise_params = {
			offset = -0.8,
			scale = 2.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 53995,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra"},
		y_max = 50,
		y_min = 2,
		decoration = "default:permafrost_with_moss",
		place_offset_y = -1,
		flags = "force_placement",
	})

	minetest.register_decoration({
		name = "default:dry_shrub",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass",
			"default:sand", "default:silver_sand"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.005,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 2,
		decoration = "default:dry_shrub",
		param2 = 4,
	})

	-- Marram grass

	minetest.register_decoration({
		name = "default:marram_grass",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 4,
		noise_params = {
			offset = -0.7,
			scale = 0.005,
			spread = {x = 16, y = 16, z = 16},
			seed = 513337,
			octaves = 1,
			persist = 0.0,
			flags = "absvalue, eased"
		},
		biomes = {"coniferous_forest_dunes", "grassland_dunes"},
		y_max = 6,
		y_min = 4,
		decoration = {
			"default:marram_grass_1",
			"default:marram_grass_2",
			"default:marram_grass_3",
		},
	})

	-- Tundra moss

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 4,
		noise_params = {
			offset = -0.8,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 53995,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"grove"},
		y_max = 50,
		y_min = 2,
		decoration = "default:permafrost_with_moss",
		place_offset_y = -1,
		flags = "force_placement",
	})
	-- Tundra patchy snow

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {
			"default:permafrost_with_moss",
			"default:permafrost_with_stones",
			"default:stone",
			"default:gravel"
		},
		sidelen = 4,
		noise_params = {
			offset = 0,
			scale = 1.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 172555,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra", "tundra_beach"},
		y_max = 50,
		y_min = 1,
		decoration = "default:snow",
	})

	-- Coral reef

	minetest.register_decoration({
		name = "default:corals",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 4,
		noise_params = {
			offset = -4,
			scale = 4,
			spread = {x = 50, y = 50, z = 50},
			seed = 7013,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {
			"desert_ocean",
			"savanna_ocean",
			"rainforest_ocean",
		},
		y_max = -2,
		y_min = -8,
		flags = "force_placement",
		decoration = {
			"default:coral_green", "default:coral_pink",
			"default:coral_cyan", "default:coral_brown",
			"default:coral_orange", "default:coral_skeleton",
		},
	})

	-- Kelp

	minetest.register_decoration({
		name = "default:kelp",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = -0.04,
			scale = 0.1,
			spread = {x = 200, y = 200, z = 200},
			seed = 87112,
			octaves = 3,
			persist = 0.7
		},
		biomes = {
			"taiga_ocean",
			"snowy_grassland_ocean",
			"grassland_ocean",
			"coniferous_forest_ocean",
			"deciduous_forest_ocean",
			"sandstone_desert_ocean",
			"cold_desert_ocean"},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		decoration = "default:sand_with_kelp",
		param2 = 48,
		param2_max = 96,
	})
end


--
-- Detect mapgen to select functions
--

minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()

local mg_name = minetest.get_mapgen_setting("mg_name")

if mg_name == "v6" then
	default.register_mgv6_ores()
	default.register_mgv6_decorations()
else
	default.register_biomes()
	default.register_ores()
	default.register_decorations()
end

-- === Natural caves + biome amplification + light climate bias ===============
-- === Natural caves + biome amplification + light climate bias (fixed) =======

local C        = minetest.get_content_id
local c_air    = C("air")
local c_water  = C("default:water_source")
local c_stone  = C("default:stone")
local c_grass  = C("default:dirt_with_grass")
local c_snowt  = C("default:dirt_with_snow")
local c_litter = C("default:dirt_with_rainforest_litter")
local c_snow   = C("default:snow")

local WATER_LEVEL = tonumber(minetest.get_mapgen_setting("water_level")) or 1

-- Carvable rocks (extend list as needed)
local STONE_CIDS = {}
local function allow_stone(name)
  local def = minetest.registered_nodes[name]
  if def then STONE_CIDS[C(name)] = true end
end
for _,n in ipairs({
  "default:stone","default:desert_stone","default:sandstone",
  "default:silver_sandstone","default:granite","default:gneiss",
  "default:schist","default:slate","default:limestone","default:obsidian",
  "default:shale",
}) do allow_stone(n) end
local function carvable(cid) return STONE_CIDS[cid] == true end

-- Depth heat helper (can be reused elsewhere)
function default.get_depth_heat(y)
  if y >= 0 then return 0 end
  return (-y) / 75.0
end

-- Cave tuning
local SURFACE_FADE  = 24    -- caves taper out in top ~24 nodes
local DEEP_CAV_Y    = -800  -- big caverns only below this
local function depth_bias(y)
  if y >= -100 then return 0 end
  return math.min(0.18, ((-100 - y) / 3000) * 0.18)
end

-- Perlin parameters
local np_tight = {offset=0, scale=1, spread={x=40,y=20,z=40}, seed=0xC0FFEE, octaves=3, persist=0.5, lacunarity=2.0}
local np_maze  = {offset=0, scale=1, spread={x=60,y=30,z=60}, seed=0xA11CE,  octaves=2, persist=0.6,  lacunarity=2.0}
local np_cav   = {offset=0, scale=1, spread={x=220,y=90,z=220},seed=0xBADA55, octaves=3, persist=0.5,  lacunarity=2.0}

-- Robust constructors: support both PerlinNoise and get_perlin variants; support get3d/get_3d
local function make_perlin(np)
  if PerlinNoise then
    local p = PerlinNoise(np)
    if p then return p end
  end
  if minetest.get_perlin then
    local p = minetest.get_perlin(np)
    if p then return p end
    -- fallback old signature (approximate)
    return minetest.get_perlin(np.seed or 0, np.octaves or 3, np.persist or np.persistence or 0.5, (np.spread and np.spread.x) or 64)
  end
  return nil
end
local function p3d(p, pos)
  if not p then return 0 end
  if p.get3d then return p:get3d(pos) end
  if p.get_3d then return p:get_3d(pos) end
  return 0
end

-- Build perlin objects at load time
local p_tight = make_perlin(np_tight)
local p_maze  = make_perlin(np_maze)
local p_cav   = make_perlin(np_cav)
local HAVE_PERLIN = (p_tight and p_maze and p_cav) and true or false

-- Gentle river cliff clamp beside water
local RIVER_MAX_STEP = 5
local function smooth_riverbanks(vm, area, data, minp, maxp, heightmap)
  local sx = maxp.x - minp.x + 1
  local sz = maxp.z - minp.z + 1
  local function h(ix,iz) return heightmap[(iz-1)*sx + ix] or WATER_LEVEL end
  for iz=2,sz-1 do for ix=2,sx-1 do
    local y0 = h(ix,iz)
    if y0 <= WATER_LEVEL then
      for _,d in ipairs{{1,0},{-1,0},{0,1},{0,-1}} do
        local nx,nz = ix+d[1], iz+d[2]
        local yn = h(nx,nz)
        local delta = yn - y0
        if delta > RIVER_MAX_STEP then
          local target = y0 + RIVER_MAX_STEP + math.floor((delta - RIVER_MAX_STEP)/2)
          for y = yn, target+1, -1 do
            local vi = area:index(minp.x+nx-1, y, minp.z+nz-1)
            data[vi] = (y > WATER_LEVEL) and c_air or c_water
          end
        end
      end
    end
  end end
end

-- Climate trend pass (no bitwise; deterministic)
local function climate_cover_pass(vm, area, data, minp, maxp, heightmap, seed)
  local sx = maxp.x - minp.x + 1
  local sz = maxp.z - minp.z + 1

  local function rand01(s, x, z)
    local n = (s * 1103515245 + x * 12345 + z * 214013) % 2147483647
    return n / 2147483647
  end

  for iz = 1, sz do
    for ix = 1, sx do
      local idx2d = (iz-1)*sx + ix
      local y = heightmap[idx2d]
      if y then
        local x = minp.x + ix - 1
        local z = minp.z + iz - 1

        local lat = z / 8000   -- tune as needed
        local r = rand01(seed, x, z)

        -- North bias: grass -> snow cover
        if z < 0 and y > 8 and r < math.min(0.6, -lat) then
          local vi = area:index(x, y, z)
          if data[vi] == c_grass then
            data[vi] = c_snowt
            local vt = area:index(x, y + 1, z)
            if data[vt] == c_air then data[vt] = c_snow end
          end
        end

        -- South bias: grass -> rainforest litter
        if z > 0 and r < math.min(0.7, lat) then
          local vi = area:index(x, y, z)
          if data[vi] == c_grass then
            data[vi] = c_litter
          end
        end
      end
    end
  end
end

-- Column amplification using values captured by the biome registration shim
local function apply_amplification(vm, area, data, minp, maxp, heightmap, biomemap)
  local sx = maxp.x - minp.x + 1
  local sz = maxp.z - minp.z + 1
  for iz=1,sz do for ix=1,sx do
    local idx2d = (iz-1)*sx + ix
    local ysurf = heightmap[idx2d]
    if ysurf then
      local biome_id = biomemap[idx2d]
      local bname = biome_id and minetest.get_biome_name(biome_id) or nil
      local layers = bname and default._biome_layers and default._biome_layers[bname] or nil
      local amp = (bname and default._biome_amp and default._biome_amp[bname]) or 1.0
      if amp ~= 1.0 and layers then
        local x = minp.x + ix - 1
        local z = minp.z + iz - 1
        local rel    = ysurf - WATER_LEVEL
        local target = WATER_LEVEL + math.floor(rel * amp + 0.5)

        if target > ysurf then
          for y = ysurf+1, target do
            data[area:index(x,y,z)] = c_stone
          end
        elseif target < ysurf then
          for y = target+1, ysurf do
            local vi = area:index(x,y,z)
            data[vi] = (y > WATER_LEVEL) and c_air or c_water
          end
        end

        local top_cid  = layers.node_top     and C(layers.node_top)    or nil
        local fill_cid = layers.node_filler  and C(layers.node_filler) or c_stone
        local depth_top   = layers.depth_top   or 1
        local depth_fill  = layers.depth_filler or 3
        local y_top = target

        if top_cid then
          for dy=0,depth_top-1 do
            local y = y_top - dy
            if y >= minp.y then data[area:index(x,y,z)] = top_cid end
          end
          for dy=depth_top,depth_top+depth_fill-1 do
            local y = y_top - dy
            if y >= minp.y then data[area:index(x,y,z)] = fill_cid end
          end
        end

        heightmap[idx2d] = target
      end
    end
  end end
end

-- Main post-gen pass
minetest.register_on_generated(function(minp, maxp, seed)
  local vm, emin, emax = minetest.get_voxel_manip(minp, maxp)
  local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
  local data = vm:get_data()

  -- Use global getters (VM does not have get_mapgen_object)
  local heightmap = minetest.get_mapgen_object("heightmap")
  local biomemap  = minetest.get_mapgen_object("biomemap")

  -- 1) Cave carving (skip entirely if perlin objects failed to construct)
  if HAVE_PERLIN then
    for z=minp.z,maxp.z do
      for x=minp.x,maxp.x do
        local idx2d = (z - minp.z) * (maxp.x - minp.x + 1) + (x - minp.x) + 1
        local y_surf = heightmap[idx2d] or WATER_LEVEL
        for y=minp.y,maxp.y do
          if y <= y_surf then
            local vi  = area:index(x,y,z)
            local cid = data[vi]
            if carvable(cid) then
              local d_to_surface = y_surf - y
              local fade = (d_to_surface <= SURFACE_FADE) and (1 - d_to_surface/SURFACE_FADE) or 0

              local t_tight = 0.78
              local t_maze  = 0.22
              local t_cav   = -0.35
              local db = depth_bias(y)
              t_tight = t_tight - db + fade*0.15
              t_maze  = t_maze  - db*0.5 + fade*0.08
              t_cav   = t_cav   + db*0.4 + fade*0.2

              local n1 = p3d(p_tight, {x=x,y=y,z=z})
              local n2 = p3d(p_maze , {x=x,y=y,z=z})
              local n3 = p3d(p_cav  , {x=x,y=y,z=z})

              local carve = false
              if n1 > t_tight then carve = true end
              if not carve and cid == C("default:shale") and n2 > t_maze then carve = true end
              if not carve and y <= DEEP_CAV_Y and n3 < t_cav then carve = true end

              if carve then data[vi] = c_air end
            end
          end
        end
      end
    end
  end

  -- 2) Gentle riverbank smoothing beside water
  smooth_riverbanks(vm, area, data, minp, maxp, heightmap)

  -- 3) Apply biome amplification (values captured by the shim at registration time)
  apply_amplification(vm, area, data, minp, maxp, heightmap, biomemap)

  -- 4) Light visible climate trend (north colder cover, south humid cover)
  climate_cover_pass(vm, area, data, minp, maxp, heightmap, seed)

  vm:set_data(data)
  vm:update_liquids()
  vm:write_to_map()
end)

-- ===========================================================================


