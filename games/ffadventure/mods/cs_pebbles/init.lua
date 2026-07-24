-- === STONE TYPES FOR PEBBLE VARIANTS ===

local stone_types = {
	{name = "limestone", texture = "default_limestone.png", node = "default:limestone"},
	{name = "sandstone", texture = "default_sandstone.png", node = "default:sandstone"},
	{name = "schist", texture = "default_schist.png", node = "default:schist"},
	{name = "shale", texture = "default_shale.png", node = "default:shale"},
	{name = "slate", texture = "default_slate.png", node = "default:slate"},
	{name = "granite", texture = "default_granite.png", node = "default:granite"},
	{name = "gneiss", texture = "default_gneiss.png", node = "default:gneiss"},
	{name = "quartz", texture = "quartz.png", node = "default:quartz"},
	{name = "marble", texture = "default_marble.png", node = "default:marble"},
	{name = "onyx", texture = "onyx.png", node = "default:onyx"},
	{name = "pumice", texture = "nc_igneous_pumice.png", node = "default:pumice"},
}

local stone_to_pebble = {}
local stone_node_list = {}

local pebble_nodebox = {
	type = "fixed",
	fixed = {
		{-0.25, -0.5, -0.0625, 0.1875, -0.3125, 0.1875},
		{0, -0.5, 0, 0.25, -0.375, 0.25},
		{-0.1875, -0.5, -0.125, 0.0625, -0.375, -0.0625},
	}
}

-- Register typed pebble nodes
for _, stone in ipairs(stone_types) do
	local pebble_name = "cs_pebbles:" .. stone.name .. "_pebble"
	local display_name = stone.name:gsub("^%l", string.upper) .. " Pebble"

	minetest.register_node(pebble_name, {
		description = display_name,
		groups = {attached_node = 3, dig_immediate = 2},
		tiles = {stone.texture},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "4dir",
		walkable = false,
		drop = {
			max_items = 1,
			items = {
				{items = {"default:flint"}, rarity = 3},
				{items = {pebble_name}},
			}
		},
		node_box = pebble_nodebox,
	})

	stone_to_pebble[stone.node] = pebble_name
	table.insert(stone_node_list, stone.node)
end

-- Placeholder for decoration (replaced during worldgen)
minetest.register_node("cs_pebbles:pebble", {
	description = "Pebble",
	groups = {attached_node=3, dig_immediate=2},
	tiles = {"pebble.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "4dir",
	walkable = false,
	drop = "default:flint",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.0625, 0.1875, -0.3125, 0.1875	},
			{0, -0.5, 0, 0.25, -0.375, 0.25			},
			{-0.1875, -0.5, -0.125, 0.0625, -0.375, -0.0625	},
		}
	}
})
minetest.register_node("cs_pebbles:stick", {
	description = "Fallen Branch",
	groups = {attached_node=3, dig_immediate=2},
	tiles = {"stick.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "4dir",
	walkable = false,
	drop = "default:stick",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375	},
			{0.0625, -0.5, 0.1875, 0.125, -0.375, 0.3125	},
			{-0.125, -0.5, 0, -0.0625, -0.375, 0.125	},
			{0.0625, -0.5, -0.0625, 0.125, -0.375, 0.0625	},
		}
	}
})

-- === WORLD GENERATION ===

-- Surfaces where pebbles/sticks can spawn
local spawn_surfaces = {
	"default:dirt_with_grass",
	"default:dirt_with_dry_grass",
	"default:dry_dirt_with_dry_grass",
	"default:dirt_with_coniferous_litter",
	"default:dirt_with_rainforest_litter",
	"default:dirt_with_snow",
	"default:sand",
	"default:desert_sand",
	"default:silver_sand",
	"default:gravel",
	"default:stone",
	"default:desert_stone",
}

-- Regular decoration for pebbles
minetest.register_decoration({
	name = "cs_pebbles:pebble",
	deco_type = "simple",
	place_on = spawn_surfaces,
	sidelen = 16,
	noise_params = {
		offset = 0.01,
		scale = 0.03,
		spread = {x = 50, y = 50, z = 50},
		seed = 92746,
		octaves = 3,
		persist = 0.6
	},
	y_max = 300,
	y_min = 1,
	decoration = "cs_pebbles:pebble",
	param2 = 0,
	param2_max = 3,
})

-- Regular decoration for sticks
minetest.register_decoration({
	name = "cs_pebbles:stick",
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass",
		"default:dirt_with_dry_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
	},
	sidelen = 16,
	noise_params = {
		offset = 0.008,
		scale = 0.025,
		spread = {x = 50, y = 50, z = 50},
		seed = 38291,
		octaves = 3,
		persist = 0.6
	},
	y_max = 300,
	y_min = 1,
	decoration = "cs_pebbles:stick",
	param2 = 0,
	param2_max = 3,
})

-- === HELPER FUNCTIONS ===

-- Find nearest compatible stone type
local function get_typed_pebble(pos)
	local found_pos = minetest.find_node_near(pos, 30, stone_node_list)
	if found_pos then
		local node = minetest.get_node(found_pos)
		if stone_to_pebble[node.name] then
			return stone_to_pebble[node.name]
		end
	end
	return "cs_pebbles:limestone_pebble"
end

-- === CAVE TELEGRAPH & PEBBLE TYPING ===

local CAVE_CHECK_DEPTH = 24
local CAVE_PEBBLE_CHANCE = 3
local UNDERGROUND_PEBBLE_CHANCE = 12

-- Build surface lookup table
local surface_set = {}
for _, name in ipairs(spawn_surfaces) do
	surface_set[name] = true
end

-- Cave floor surfaces for underground pebbles
local cave_floor_set = {}
for _, stone in ipairs(stone_types) do
	cave_floor_set[stone.node] = true
end
cave_floor_set["default:stone"] = true
cave_floor_set["default:desert_stone"] = true

minetest.register_on_generated(function(minp, maxp, blockseed)
	minetest.after(0, function()
		math.randomseed(blockseed)

		-- Replace decoration-placed pebbles with typed versions
		local pebble_positions = minetest.find_nodes_in_area(minp, maxp, {"cs_pebbles:pebble"})
		for _, pos in ipairs(pebble_positions) do
			local old_node = minetest.get_node(pos)
			local typed_pebble = get_typed_pebble(pos)
			minetest.set_node(pos, {name = typed_pebble, param2 = old_node.param2})
		end

		-- Cave telegraph: extra pebbles above caves
		for z = minp.z, maxp.z, 2 do
			for x = minp.x, maxp.x, 2 do
				for y = maxp.y, minp.y, -1 do
					local pos = {x = x, y = y, z = z}
					local node = minetest.get_node(pos)

					if node.name ~= "air" and surface_set[node.name] then
						local above = {x = x, y = y + 1, z = z}
						if minetest.get_node(above).name == "air" then
							for depth = 3, CAVE_CHECK_DEPTH do
								local below = {x = x, y = y - depth, z = z}
								if minetest.get_node(below).name == "air" then
									if math.random(1, CAVE_PEBBLE_CHANCE) == 1 then
										local typed_pebble = get_typed_pebble(pos)
										minetest.set_node(above, {name = typed_pebble, param2 = math.random(0, 3)})
									end
									break
								end
							end
						end
						break
					end
				end
			end
		end

		-- Underground pebbles in caves
		for z = minp.z, maxp.z, 3 do
			for x = minp.x, maxp.x, 3 do
				for y = minp.y, math.min(maxp.y, -1) do
					local pos = {x = x, y = y, z = z}
					local node = minetest.get_node(pos)

					if node.name == "air" then
						local below = {x = x, y = y - 1, z = z}
						local below_node = minetest.get_node(below)

						if cave_floor_set[below_node.name] then
							if math.random(1, UNDERGROUND_PEBBLE_CHANCE) == 1 then
								local typed_pebble = get_typed_pebble(pos)
								minetest.set_node(pos, {name = typed_pebble, param2 = math.random(0, 3)})
							end
						end
					end
				end
			end
		end
	end)
end)