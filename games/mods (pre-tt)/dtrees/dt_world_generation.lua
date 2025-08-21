-- dynamic_trees/dt_world_generation.lua


	-- Acacia tree and log

	minetest.register_decoration({
		name = "default:acacia_tree",
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		decoration = "dynamic_trees:acacia_tree_sapling",
	})
	minetest.register_decoration({
		name = "default:palm_tree",
		deco_type = "simple",
		place_on = {"biomes_island:dirt_with_island_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.002,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"islands", "islands_hot"},
		y_max = 31000,
		y_min = 1,
		decoration = "dynamic_trees:palm_tree_sapling",
	})
	minetest.register_decoration({
		name = "default:apple_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:apple_tree_sapling",
	})

	minetest.register_decoration({
		name = "default:apple_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.0015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:apple_tree_sapling",
	})
	-- Aspen tree and log

	minetest.register_decoration({
		name = "default:aspen_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0,
			scale = -0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:aspen_tree_sapling",
	})
	minetest.register_decoration({
		name = "default:aspen_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0.0,
			scale = -0.0015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grove"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:aspen_tree_sapling",
	})
	-- Cactus

	minetest.register_decoration({
		name = "default:cactus",
		deco_type = "simple",
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
	decoration = "dynamic_trees:cactus_seedling",
	})


	-- Emergent jungle tree
	-- Due to 32 node height, altitude is limited and prescence depends on chunksize

	local chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
	if chunksize >= 5 then
		minetest.register_decoration({
			name = "default:emergent_jungle_tree",
			deco_type = "simple",
			place_on = {"default:dirt_with_rainforest_litter"},
			sidelen = 80,
			noise_params = {
				offset = 0.0,
				scale = 0.0025,
				spread = {x = 250, y = 250, z = 250},
				seed = 2685,
				octaves = 3,
				persist = 0.7
			},
			biomes = {"rainforest"},
			y_max = 32,
			y_min = 1,

	decoration = "dynamic_trees:jungle_tree_sapling",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
		})
	end
	


	-- Jungle tree and log

	minetest.register_decoration({
		name = "default:jungle_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_rainforest_litter"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"rainforest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:jungle_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})
	
	minetest.register_decoration({
		name = "default:redwood_tree",
		deco_type = "simple",
		place_on = {"redw:dirt_with_grass"},
		sidelen = 80,
		fill_ratio = 0.1,
		biomes = {"redwood_forest"},
		y_max = 31000,
		y_min = 1,
	decoration = "dynamic_trees:redwood_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Swamp jungle trees

	minetest.register_decoration({
		name = "default:jungle_tree(swamp)",
		deco_type = "simple",
		place_on = {"default:dirt"},
		sidelen = 16,
		-- Noise tuned to place swamp trees where papyrus is absent
		noise_params = {
			offset = 0.0,
			scale = -0.1,
			spread = {x = 200, y = 200, z = 200},
			seed = 354,
			octaves = 1,
			persist = 0.5
		},
		biomes = {"rainforest_swamp"},
		y_max = 0,
		y_min = -1,
	decoration = "dynamic_trees:jungle_tree_sapling",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})

	-- Taiga and temperate coniferous forest pine tree, small pine tree and log

	minetest.register_decoration({
		name = "default:pine_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = 0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest"},
		y_max = 31000,
		y_min = 4,
	decoration = "dynamic_trees:pine_tree_sapling",
		flags = "place_center_x, place_center_z",
	})

	minetest.register_decoration({
		name = "default:small_pine_tree",
		deco_type = "simple",
		place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0.010,
			scale = -0.048,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"taiga", "coniferous_forest"},
		y_max = 31000,
		y_min = 4,
	decoration = "dynamic_trees:pine_tree_sapling",
		flags = "place_center_x, place_center_z",
	})

-- Adds The Bamboo Shoot To The Rainforest And Deciduous Forest
minetest.register_decoration({
	name = "Dynamic Trees Bamboo Shoot",
	deco_type = "simple",
	place_on = {"group:soil","group:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.2,
		spread = {x = 500, y = 500, z = 500},
		seed = 6566,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"rainforest", "deciduous_forest"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:bamboo_shoot",
})

-- Adds The Dry Sapling To The Deserts
minetest.register_decoration({
	name = "Dynamic Trees Dry Tree Sapling",
	deco_type = "simple",
	place_on = {"group:soil","group:sand"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.15,
		spread = {x = 500, y = 500, z = 500},
		seed = 3628,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"desert", "sandstone_desert", "cold_desert"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:dry_tree_sapling",
})

minetest.register_decoration({
	name = "Dynamic Trees Dry Tree Sapling",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.1,
		scale = 0.00015,
		spread = {x = 500, y = 500, z = 500},
		seed = 3628,
		octaves = 3,
		persist = 0.7
	},
	biomes = {"grove"},
	y_max = 31000,
	y_min = 1,
	decoration = "dynamic_trees:dry_tree_sapling",
})
-- Function to set walkable property to false for all leaves
local function make_leaves_non_walkable()
    for name, def in pairs(minetest.registered_nodes) do
        if def.groups.leaves then
            minetest.override_item(name, {
                walkable = false
            })
        end
    end
end

-- Run the function shortly after server starts
minetest.after(0, make_leaves_non_walkable)

minetest.register_chatcommand("replace_trees", {
    params = "<radius>",
    description = "Replace the bottom-most logs of regular trees within a radius with dynamic tree saplings",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, "Player not found"
        end

        local radius = tonumber(param)
        if not radius then
            return false, "Invalid radius"
        end

        local pos = player:get_pos()
        local minp = vector.subtract(pos, radius)
        local maxp = vector.add(pos, radius)

        local nodes_to_replace = {
            ["default:tree"] = "dynamic_trees:apple_tree_sapling",
            ["default:jungletree"] = "dynamic_trees:jungle_tree_sapling",
            ["default:pine_tree"] = "dynamic_trees:pine_tree_sapling",
            ["default:acacia_tree"] = "dynamic_trees:acacia_tree_sapling",
            ["default:aspen_tree"] = "dynamic_trees:aspen_tree_sapling"
        }

        local total_replaced = 0

        for node_name, new_node_name in pairs(nodes_to_replace) do
            local positions = minetest.find_nodes_in_area(minp, maxp, {node_name})
            local bottom_most_logs = {}

            for _, p in ipairs(positions) do
                local y = p.y
                local is_bottom = true

                while true do
                    y = y - 1
                    local below_pos = {x = p.x, y = y, z = p.z}
                    local node_below = minetest.get_node_or_nil(below_pos)

                    if node_below and node_below.name == node_name then
                        is_bottom = false
                        break
                    else
                        break
                    end
                end

                if is_bottom then
                    bottom_most_logs[minetest.hash_node_position(p)] = p
                end
            end

            for _, bottom_pos in pairs(bottom_most_logs) do
                minetest.set_node(bottom_pos, {name = new_node_name})
                total_replaced = total_replaced + 1
            end

            for _, p in ipairs(positions) do
                if not bottom_most_logs[minetest.hash_node_position(p)] then
                    minetest.remove_node(p)

                    for dx = -2, 2 do
                        for dy = -2, 2 do
                            for dz = -2, 2 do
                                local leaf_pos = {x = p.x + dx, y = p.y + dy, z = p.z + dz}
                                local node = minetest.get_node_or_nil(leaf_pos)
                                if node and minetest.get_item_group(node.name, "leaves") > 0 then
                                    minetest.remove_node(leaf_pos)
                                end
                            end
                        end
                    end
                end
            end
        end

        return true, "Replaced " .. total_replaced .. " bottom-most tree logs with dynamic tree saplings."
    end
})