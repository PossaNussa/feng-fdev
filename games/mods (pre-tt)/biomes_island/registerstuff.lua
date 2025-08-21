local floor = math.floor
local ceil = math.ceil
local min = math.min
local max = math.max
local random = math.random

local dbg = minetest.chat_send_all
local rnodes = minetest.registered_nodes

local function dig_up(pos, node, metadata, digger)
	pos.y = pos.y+1
	local node2 = minetest.get_node(pos)
	if node2 and (node2.name == "biomes_island:underbrush" or rnodes[node2.name].drawtype == "plantlike") then
		minetest.dig_node(pos)
	end
end

local function should_use_alternative_tiles(pos)
    local biome_data = minetest.get_biome_data(pos)
    local biome = minetest.get_biome_name(biome_data.biome)
    
    -- Check if the biome is registered before accessing its properties
    if minetest.registered_biomes[biome] then
        local heat_point = minetest.registered_biomes[biome].heat_point
        return heat_point and heat_point >= 50
    end

    return false
end

minetest.register_node("biomes_island:dirt_with_island_litter", {
	description = ("Dirt with Grass"),
	tiles = {"islands_grass.png", "default_dirt.png",
		{name = "default_dirt.png^islands_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})
--[[
minetest.register_node("biomes_island:sand", {
	description = "Sand",
	tiles = {"islands_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("biomes_island:stone", {
	description = "Stone",
	tiles = {"islands_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "default:cobble",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("biomes_island:dirt", {
	description = "Dirt",
	tiles = {"islands_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
	
})

minetest.register_node("biomes_island:dirt_with_grass_palm", {
	description = "Dirt with Grass",
	tiles = {"islands_grass.png", "islands_dirt.png",
		{name = "islands_dirt.png^islands_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
--	drop = 'default:dirt',
	drop = 'biomes_island:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
	
	after_dig_node = dig_up,
	
})	--]]

minetest.register_node("biomes_island:seabed", {
	description = "Seabed",
	tiles = {"seabed.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})

--[[
minetest.register_node("biomes_island:dirt_with_palm_litter", {
	description = "Dirt with Litter",
	tiles = {"palm_floor.png", "islands_dirt.png",
		{name = "islands_dirt.png^palm_floor_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1},
	drop = 'biomes_island:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
	
	after_dig_node = dig_up,
})

minetest.register_node("biomes_island:dirt_with_snow", {
	description = "Dirt with Snow",
	tiles = {"default_snow.png", "islands_dirt.png",
		{name = "islands_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1},
	drop = 'biomes_island:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.2},
	}),
})	--]]

minetest.register_node("biomes_island:palm_tree", {
	description = "Palm Tree",
	tiles = {"palm_tree_top.png", "palm_tree_top.png",
		"palm_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("biomes_island:palm_leaves", {
	description = ("Uspen Tree Leaves"),
--	drawtype = "allfaces_optional",
	drawtype = "nodebox",
	tiles = {
	{name="palm_leaves_top.png",backface_culling = false},
	{name="nothing.png"},
	{name="palm_leaves.png",backface_culling = false},
	},
	waving = 2,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:aspen_sapling"}, rarity = 20},
			{items = {"default:aspen_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	--[[
	on_rightclick = function(pos)
		minetest.set_node(pos,{name="biomes_island:palm_leaves2"})
	end,	--]]
})

minetest.register_node("biomes_island:palm_leaves2", {
	description = ("Uspen Tree Leaves"),
--	drawtype = "allfaces_optional",
	drawtype = "nodebox",
	tiles = {
	{name="palm_leaves_top.png",backface_culling = false},
	{name="nothing.png"},
	{name="palm_leaves.png",backface_culling = false},
	},
	waving = 2,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:aspen_sapling"}, rarity = 20},
			{items = {"default:aspen_leaves"}}
		}
	},
	color = "#00B000",
	sounds = default.node_sound_leaves_defaults(),

	--[[
	on_rightclick = function(pos)
		minetest.set_node(pos,{name="biomes_island:palm_leaves"})
	end,	--]]
})


minetest.register_node("biomes_island:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 2,
	tiles = {"islands_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("biomes_island:twigs", {
	description = "Twigs",
	drawtype = "allfaces_optional",
	waving = 0,
	tiles = {"twigs.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

})

minetest.register_node("biomes_island:underbrush", {
	description = ("Underbrush"),
	drawtype = "nodebox",
	node_box ={
		type="fixed",
		fixed = {-0.5,-0.4,-0.5,0.5,-0.25,0.5}
	},
	selection_box = {
		type="fixed",
		fixed = {-0.3,-0.4,-0.3,0.3,-0.25,0.3}
	},
	tiles = {
		{name="islands_underbrush_top.png",backface_culling = false},
		{name="islands_underbrush_bot.png",backface_culling = false},
		{name="nothing.png"},
	},
	walkable = false,
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, flammable = 2, leaves = 1},
	sounds = default.node_sound_leaves_defaults(),

})

minetest.register_node("biomes_island:palm_small_bottom", {
	description = ("Young palm"),
	drawtype = "plantlike",
	selection_box = {
		type="fixed",
		fixed = {-0.2,-0.5,-0.2,0.2,0.3,0.2}
	},
	tiles = {"palm_small_bottom.png"},
	paramtype = "light",
	drop = '',
--	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

	after_dig_node = dig_up,
})

minetest.register_node("biomes_island:palm_small_top", {
	description = ("Young palm"),
	drawtype = "plantlike",
	tiles = {"palm_small_top.png"},
	paramtype = "light",
	sunlight_propagates = true,
	drop = '',
	waving = 1,
	pointable = false,
	walkable = false,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("biomes_island:wood", {
	description = "Wood Planks",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("biomes_island:grass", {
	description = ("Grass"),
	drawtype = "plantlike",
	tiles = {"islands_tall_grass.png"},
	selection_box = {
		type="fixed",
		fixed = {-0.2,-0.5,-0.2,0.2,0,0.2}
	},
	paramtype = "light",
	drop = "",
	waving = 1,
	buildable_to = true,
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node(":default:water_source", {
	description = "Water Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
--	alpha = 215,
	use_texture_alpha = true,
	sunlight_propagates = true,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:water_flowing",
	liquid_alternative_source = "default:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 190, r = 30, g = 130, b = 100},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_decoration({
	name = "biomes_island:palm_tree_tall",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.001,
		spread = {x = 64, y = 64, z = 64},
		seed = 2,
		octaves = 2,
		persist = 0.66
	},
	place_offset_y = 1,
	y_max = 100,
	y_min = 3,
	decoration = "dynamic_trees:palm_tree_sapling",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
    biomes = {"islands", "islands_hot"},
})

minetest.register_decoration({
	name = "biomes_island:palm_tree",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0.02,
		scale = 0.003,
		spread = {x = 64, y = 64, z = 64},
		seed = 2,
		octaves = 2,
		persist = 0.66
	},
	place_offset_y = 1,
	y_max = 100,
	y_min = 3,
	decoration = "dynamic_trees:palm_tree_sapling",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
    biomes = {"islands", "islands_hot"},
})

minetest.register_decoration({
	name = "biomes_island:tree",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0.013,
		scale = 0.002,
		spread = {x = 64, y = 64, z = 64},
		seed = 3,
		octaves = 2,
		persist = 0.66
	},
	place_offset_y = 1,
	y_max = 100,
	y_min = 3,
	decoration = "dynamic_trees:palm_tree_sapling",
			flags = "place_center_x, place_center_z",
			rotation = "random",
			place_offset_y = -4,
    biomes = {"islands", "islands_hot"},
})

minetest.register_decoration({
	name = "biomes_island:palm_tree_small",
	deco_type = "schematic",
	place_on = {"biomes_island:dirt_with_island_litter"},
	sidelen = 2,
	noise_params = {
		offset = 0.03,
		scale = 0.04,
		spread = {x = 64, y = 64, z = 64},
		seed = 7,
		octaves = 2,
		persist = 0.66
	},
	y_max = 100,
	y_min = 3,
	schematic = {
            size = {x = 1, y = 3, z = 1},
            data = {
                {name = "air"},
                {name = "dynamic_trees:palm_tree_sapling"},
                {name = "air"},
            },
			rotation = "random",
	},
	flags = "place_center_x, place_center_z",
    biomes = {"islands", "islands_hot"},
})


minetest.register_decoration({
	name = "biomes_island:grass",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter","default:dirt_with_grass"},
	sidelen = 2,
	noise_params = {
		offset = 0.15,
		scale = 0.05,
		spread = {x = 200, y = 200, z = 200},
		seed = 100,
		octaves = 3,
		persist = 0.6
	},
	y_max = 100,
	y_min = 3,
	decoration = "biomes_island:grass",
    biomes = {"islands", "islands_hot"},
})

minetest.register_decoration({
	name = "biomes_island:underbrush",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter"},
	sidelen = 2,
	noise_params = {
		offset = 0.15,
		scale = 0.05,
		spread = {x = 200, y = 200, z = 200},
		seed = 112,
		octaves = 3,
		persist = 0.6
	},
	y_max = 100,
	y_min = 3,
	decoration = "biomes_island:underbrush",
    biomes = {"islands", "islands_hot"},
})

-- cotton
minetest.register_decoration({
	name = "biomes_island:cotton_bush",
	deco_type = "simple",
	place_on = {"biomes_island:dirt_with_island_litter","default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.01,
		scale = 0.03,
		spread = {x = 64, y = 64, z = 64},
		seed = 1519,
		octaves = 3,
		persist = 0.6
	},
	y_max = 31000,
	y_min = 2,
	decoration = "farming:cotton_8",
    biomes = {"islands", "islands_hot"},
})

	minetest.register_decoration({
		name = "biomes_island:corals",
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
		name = "biomes_island:kelp",
		deco_type = "simple",
		place_on = {"biomes_island:seabed"},
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
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		decoration = "default:sand_with_kelp",
		param2 = 48,
		param2_max = 96,
	})

minetest.register_craft({
	output = "biomes_island:wood 4",
	recipe = {
		{"biomes_island:palm_tree"},
	}
})



--[[
isln_pos1 = {x=0,y=0,z=0}
isln_pos2 = {x=0,y=0,z=0}

minetest.register_on_chat_message(
	function(name, message)
		if message == 'pos1' then
			local plyr = minetest.get_player_by_name('singleplayer')
			isln_pos1 = plyr:get_pos()
			minetest.chat_send_all(dump(isln_pos1))
		end
	end
)	

minetest.register_on_chat_message(
	function(name, message)
		if message == 'doit' then
			local plyr = minetest.get_player_by_name('singleplayer')
			local pos = plyr:get_pos()
			minetest.chat_send_all(minetest.get_biome_name(minetest.get_biome_data(pos).biome))
		end
	end
)	

minetest.register_on_chat_message(
	function(name, message)
		if message == 'pos2' then
			local plyr = minetest.get_player_by_name('singleplayer')
			isln_pos2 = plyr:get_pos()
			isln_pos2.y = isln_pos2.y - 1.5
			minetest.chat_send_all(dump(isln_pos2))
		end
	end
)	
				
minetest.register_on_chat_message(
	function(name, message)
		if message == 'schm' then
			local fname = minetest.get_worldpath() .."/palm_tree.txt"
			minetest.chat_send_all(fname)
			minetest.create_schematic(isln_pos1,isln_pos2,nil,fname)
			minetest.chat_send_all('saved')
		end
	end
)	

minetest.register_on_chat_message(
	function(name, message)
		if message == 'place' then
			local fname = minetest.get_modpath('islands') .."/schematics/palm_tree_big.mts"
			minetest.chat_send_all(fname)
			minetest.place_schematic(isln_pos1,fname,'random',nil,false,'place_center_x,place_center_z')
			minetest.chat_send_all('plced')
		end
	end
)	
	--]]


local islands_biome = minetest.get_biome_id("islands")

minetest.register_biome({
    name = "islands",
    node_top = "biomes_island:dirt_with_island_litter",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:stone",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 120,      -- Slightly above sea level
    y_min = 6,     -- Slightly below sea level
    heat_point = 72,
    humidity_point = 72,
})

minetest.register_biome({
    name = "islands_beach",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:stone",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 5,      -- Slightly above sea level
    y_min = 4,     -- Slightly below sea level
    heat_point = 72,
    humidity_point = 72,
})
minetest.register_biome({
    name = "islands_hot_beach",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:obsidian",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 5,      -- Slightly above sea level
    y_min = 4,     -- Slightly below sea level
    heat_point = 90,
    humidity_point = 80,
})
minetest.register_biome({
    name = "islands_ocean_hot",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:obsidian",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 2,      -- Slightly above sea level
    y_min = -255,     -- Slightly below sea level
    heat_point = 90,
    humidity_point = 80,
})

minetest.register_biome({
    name = "islands_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:stone",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 2,      -- Slightly above sea level
    y_min = -255,     -- Slightly below sea level
    heat_point = 72,
    humidity_point = 72,
})

minetest.register_biome({
    name = "islands_hot",
    node_top = "biomes_island:dirt_with_island_litter",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 1,
    node_riverbed = "biomes_island:seabed",
    depth_riverbed = 2,
    node_stone = "default:obsidian",
    node_cave_liquid = {"default:water_source"},
    node_dungeon = "default:cobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 5000,      -- Slightly above sea level
    y_min = -3,     -- Slightly below sea level
    heat_point = 90,
    humidity_point = 80,
})
