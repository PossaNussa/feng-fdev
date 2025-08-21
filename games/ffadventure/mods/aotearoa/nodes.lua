----------------------------------------
--[[
Custom groups:

soft_stone = 1

Soft rocks that can be dug with a shovel (like sandstone and other loosely
consolidated sedimentary rocks), and are unusable for tools. Yet they are still
good enough for furnaces etc. (considering mud would be good enough for a
furnace).
--]]

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

------------------------------------------------
--[[
Redefinitions
Override default textures.
- Yellowish clay;
- Drop the block, allow plants to grow.
--]]
if default_loaded then
	minetest.override_item("default:clay", {
		description = "Clay",
		tiles = {"aotearoa_clay.png"},
		groups = {crumbly = 3, soil = 1},
		drop = "default:clay",  -- "default:clay_lump 4",
		sounds = default.node_sound_dirt_defaults(),
	})
elseif zero_loaded then
	minetest.override_item("zr_clay:clay", {
		description = "Clay",
		tiles = {"aotearoa_clay.png"},
		groups = {crumbly = 3, soil = 1},
		drop = "zr_clay:clay",  -- "zr_clay:lump 4",
		sounds = zr_dirt.sounds,
	})
end

-- Slabs for clay
if default_loaded then
	stairs.register_stair_and_slab(
		"default_clay",
		"default:clay",
		{crumbly = 3},
		{"aotearoa_clay.png"},
		"Clay Stair",
		"Clay Slab",
		default.node_sound_dirt_defaults()
	)
elseif zero_loaded then
	zr_stair.register_all("aotearoa:clay_", {recipeitem = "zr_clay:clay"})
end

-----------------------------------------------------
-- Clay
if default_loaded then
	minetest.register_node("aotearoa:gumland_hardpan", {
		description = "Gumland Hardpan",
		tiles = {"aotearoa_gumland_hardpan.png"},
		groups = {crumbly = 2},
		drop = {
			max_items = 2,
			items = {
				{items = {"aotearoa:kauri_gum"}, rarity = 15},
				{items = {"default:clay"}}
			}
		},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug      = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:gumland_hardpan", {
		description = "Gumland Hardpan",
		tiles = {"aotearoa_gumland_hardpan.png"},
		groups = {crumbly = 2},
		drop = {
			max_items = 2,
			items = {
				{items = {"aotearoa:kauri_gum"}, rarity = 15},
				{items = {"zr_clay:clay"}}
			}
		},
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

if default_loaded then
	minetest.register_node("aotearoa:gumland_soil", {
		description = "Gumland Soil",
		tiles = {
			"aotearoa_gumland_soil.png",
			"aotearoa_gumland_hardpan.png",
			{name ="aotearoa_gumland_hardpan.png".."^aotearoa_gumland_soil_side.png",
			tileable_vertical = false}
		},
		groups = {crumbly = 3},
		drop = {
			max_items = 2,
			items = {
				{items = {"aotearoa:kauri_gum"}, rarity = 20},
				{items = {"default:clay"}}
			}
		},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug      = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:gumland_soil", {
		description = "Gumland Soil",
		tiles = {
			"aotearoa_gumland_soil.png",
			"aotearoa_gumland_hardpan.png",
			{name ="aotearoa_gumland_hardpan.png".."^aotearoa_gumland_soil_side.png",
			tileable_vertical = false}
		},
		groups = {crumbly = 3},
		drop = {
			max_items = 2,
			items = {
				{items = {"aotearoa:kauri_gum"}, rarity = 20},
				{items = {"zr_clay:clay"}}
			}
		},
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

----------------------------------------------------
-- Gravel
if default_loaded then
	minetest.register_node("aotearoa:gravel_with_algae", {
		description = "Gravel with Algae",
		tiles = {"aotearoa_gravel_with_algae.png"},
		groups = {crumbly = 2, falling_node = 1},
		drop = {
			max_items = 1,
			items = {
				{items = {"default:flint"}, rarity = 16},
				{items = {"default:gravel"}}
			}
		},
		sounds = default.node_sound_gravel_defaults(),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:gravel_with_algae", {
		description = "Gravel with Algae",
		tiles = {"aotearoa_gravel_with_algae.png"},
		groups = {crumbly = 2, falling_node = 1},
		drop = {
			max_items = 1,
			items = {
				{items = {"zr_fire:flint"}, rarity = 16},
				{items = {"zr_gravel:gravel"}}
			}
		},
		sounds = zr_gravel.sounds,
	})
end

--------------------------------------------------
-- Dirt nodes
-- Differently textured versions of dirt.
if default_loaded then
	aotearoa.dirtlist = {
		{
			"dirt_with_dark_litter",
			"Dirt with Dark Litter",
			"aotearoa_dirt_with_dark_litter_bottom.png",
			"aotearoa_dirt_with_dark_litter_bottom.png",
		},
		{
			"dirt_with_moss",
			"Dirt with Moss",
			"default_dirt.png",
			"default_rainforest_litter.png",
		},
		{
			"dirt_with_beech_litter",
			"Dirt with Beech Litter",
			"aotearoa_dirt_with_dark_litter_bottom.png",
			"aotearoa_dirt_with_dark_litter_bottom.png",
		},
		{
			"dirt_with_dry_litter",
			"Dirt with Dry Litter",
			"default_dirt.png",
			"default_dirt.png",
		},
	}


	for i in ipairs(aotearoa.dirtlist) do
		local dirtname = aotearoa.dirtlist[i][1]
		local dirtdesc = aotearoa.dirtlist[i][2]
		local bottext  = aotearoa.dirtlist[i][3]
		local sidetext = aotearoa.dirtlist[i][4]

		minetest.register_node("aotearoa:"..dirtname, {
			description = dirtdesc,
			tiles = {
				"aotearoa_"..dirtname..".png",
				bottext,
				{name = sidetext.."^aotearoa_"..dirtname.."_side.png",
				tileable_vertical = false}
			},
			groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
			drop = "default:dirt",
			sounds = default.node_sound_dirt_defaults({
				footstep = {name = "default_grass_footstep", gain = 0.4},
			}),
		})
	end
elseif zero_loaded then
	aotearoa.dirtlist = {
		{
			"dirt_with_dark_litter",
			"Dirt with Dark Litter",
			"aotearoa_dirt_with_dark_litter_bottom.png",
			"aotearoa_dirt_with_dark_litter_bottom.png",
		},
		{
			"dirt_with_moss",
			"Dirt with Moss",
			"zr_dirt.png",
			"zr_dirt_litter.png",
		},
		{
			"dirt_with_beech_litter",
			"Dirt with Beech Litter",
			"aotearoa_dirt_with_dark_litter_bottom.png",
			"aotearoa_dirt_with_dark_litter_bottom.png",
		},
		{
			"dirt_with_dry_litter",
			"Dirt with Dry Litter",
			"zr_dirt.png",
			"zr_dirt.png",
		},
	}


	for i in ipairs(aotearoa.dirtlist) do
		local dirtname = aotearoa.dirtlist[i][1]
		local dirtdesc = aotearoa.dirtlist[i][2]
		local bottext  = aotearoa.dirtlist[i][3]
		local sidetext = aotearoa.dirtlist[i][4]

		minetest.register_node("aotearoa:"..dirtname, {
			description = dirtdesc,
			tiles = {
				"aotearoa_"..dirtname..".png",
				bottext,
				{name = sidetext.."^aotearoa_"..dirtname.."_side.png",
				tileable_vertical = false}
			},
			groups = {crumbly = 3, soil = 1, spread_to_dirt = 1},
			drop = "zr_dirt:dirt",
			sounds = {
				footstep = {name = "zr_dirt_grass_footstep", gain = 0.4},
				dig      = {name = "zr_dirt_dig", gain = 1.0},
				dug      = {name = "zr_dirt_footstep", gain = 1.0},
				place    = {name = "zr_dirt_place", gain = 1.0},
			},
		})
	end
end

--------------------------------------------------
-- Sand nodes
-- Differently textured versions of sand.
aotearoa.sandlist = {
	{"iron_sand", "Iron-sand"},
	{"volcanic_sand", "Volcanic Sand"},
	{"river_sand", "River Sand"},
}

for i in ipairs(aotearoa.sandlist) do
	local sandname = aotearoa.sandlist[i][1]
	local sanddesc = aotearoa.sandlist[i][2]

	if default_loaded then
		minetest.register_node("aotearoa:"..sandname, {
			description = sanddesc,
			tiles = {	"aotearoa_"..sandname..".png"},
			groups = {crumbly = 3, falling_node = 1, sand = 1},
			sounds = default.node_sound_sand_defaults(),
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..sandname, {
			description = sanddesc,
			tiles = {	"aotearoa_"..sandname..".png"},
			groups = {crumbly = 3, falling_node = 1, sand = 1},
			sounds = zr_sand.sounds,
		})
	end
end

-- Cook volcanic_sand to obsidian.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "default:obsidian",
		recipe = "aotearoa:volcanic_sand",
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_glass:obsidian",
		recipe = "aotearoa:volcanic_sand",
	})
end

--------------------------------------------------
-- Peat nodes

if default_loaded then
	minetest.register_node("aotearoa:peat", {
		description = "Peat",
		tiles = {
			"aotearoa_peat.png",
		},
		groups = {crumbly = 3},
		drop = {
			max_items = 1,
			items = {
				{items = {"default:iron_lump"}, rarity = 200},
				{items = {"aotearoa:peat"}}
			}
		},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:peat", {
		description = "Peat",
		tiles = {
			"aotearoa_peat.png",
		},
		groups = {crumbly = 3},
		drop = {
			max_items = 1,
			items = {
				{items = {"zr_iron:lump"}, rarity = 200},
				{items = {"aotearoa:peat"}}
			}
		},
		sounds = {
				footstep = {name = "aotearoa_mud", gain = 0.4},
				dig      = {name = "zr_dirt_dig", gain = 1.0},
				dug      = {name = "aotearoa_mud", gain = 0.4},
				place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

aotearoa.peatlist = {
	{"restiad_peat", "Restiad Peat"},
	{"forest_peat", "Forest Peat"}
}

for i in ipairs(aotearoa.peatlist) do
	local dirtname = aotearoa.peatlist[i][1]
	local dirtdesc = aotearoa.peatlist[i][2]

	if default_loaded then
		minetest.register_node("aotearoa:"..dirtname, {
			description = dirtdesc,
			tiles = {
				"aotearoa_"..dirtname..".png",
				"aotearoa_peat.png",
				{name ="aotearoa_peat.png^aotearoa_"..dirtname.."_side.png",
				tileable_vertical = false}
			},
			groups = {crumbly = 3},
			drop = {
				max_items = 1,
				items = {
					{items = {"default:iron_lump"}, rarity = 1000},
					{items = {"aotearoa:peat"}}
				}
			},
			sounds = default.node_sound_dirt_defaults({
				footstep = {name = "aotearoa_mud", gain = 0.4},
				dug = {name = "aotearoa_mud", gain = 0.4},
			}),
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..dirtname, {
			description = dirtdesc,
			tiles = {
				"aotearoa_"..dirtname..".png",
				"aotearoa_peat.png",
				{name ="aotearoa_peat.png^aotearoa_"..dirtname.."_side.png",
				tileable_vertical = false}
			},
			groups = {crumbly = 3},
			drop = {
				max_items = 1,
				items = {
					{items = {"zr_iron:lump"}, rarity = 1000},
					{items = {"aotearoa:peat"}}
				}
			},
			sounds = {
				footstep = {name = "aotearoa_mud", gain = 0.4},
				dig = {name = "zr_dirt_dig", gain = 1.0},
				dug = {name = "aotearoa_mud", gain = 0.4},
				place = {name = "zr_dirt_place", gain = 1.0},
			},
		})
	end
end

----------------------------------------------------
-- Silt

if default_loaded then
	minetest.register_node("aotearoa:silt", {
		description = "Silt",
		tiles = {
			"aotearoa_silt.png",
		},
		groups = {crumbly = 3, soil = 1},
		sounds = default.node_sound_dirt_defaults({
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:silt", {
		description = "Silt",
		tiles = {
			"aotearoa_silt.png",
		},
		groups = {crumbly = 3, soil = 1},
		sounds = zr_dirt.sounds,
	})
end

-- Slab for silt
if default_loaded then
	stairs.register_stair_and_slab(
		"aotearoa_silt",
		"aotearoa:silt",
		{crumbly = 3},
		{"aotearoa_silt.png"},
		"Silt Stair",
		"Silt Slab",
		default.node_sound_dirt_defaults()
	)
elseif zero_loaded then
	zr_stair.register_all("aotearoa:silt_", {recipeitem = "aotearoa:silt"})
end

----------------------------------------------------
-- Mud

-- Mud (for swamps and estuaries)
-- This is so you sink in.
if default_loaded then
	minetest.register_node("aotearoa:mud_sinking", {
		description = "Sinking Mud",
		tiles = {
			{
				name = "aotearoa_mud_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		paramtype = "light",
		walkable = false,
		--diggable = false,
		--pointable = false,
		buildable_to = true,
		drowning = 1,
		post_effect_color = {a = 250, r = 20, g = 20, b = 20},
		groups = {crumbly = 3, cools_lava = 1},
		drop = "aotearoa:silt",
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_water_footstep", gain = 0.2},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:mud_sinking", {
		description = "Sinking Mud",
		tiles = {
			{
				name = "aotearoa_mud_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		paramtype = "light",
		walkable = false,
		--diggable = false,
		--pointable = false,
		buildable_to = true,
		drowning = 1,
		post_effect_color = {a = 250, r = 20, g = 20, b = 20},
		groups = {crumbly = 3, cools_lava = 1},
		drop = "aotearoa:silt",
		sounds = {
			footstep = {name = "zr_water_footstep", gain = 0.2},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

-- Solid mud
if default_loaded then
	minetest.register_node("aotearoa:mud", {
		description = "Mud",
		tiles = {
			"aotearoa_mud.png",
		},
		--walkable = false,
		--diggable = false,
		--pointable = false,
		--buildable_to = true,
		groups = {crumbly = 3},
		drop = "aotearoa:silt",
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:mud", {
		description = "Mud",
		tiles = {
			"aotearoa_mud.png",
		},
		--walkable = false,
		--diggable = false,
		--pointable = false,
		--buildable_to = true,
		groups = {crumbly = 3},
		drop = "aotearoa:silt",
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

-----------------------------------------------
-- Boiling mud
if default_loaded then
	minetest.register_node("aotearoa:boiling_mud_source", {
		description = "Boiling Mud Source",
		drawtype = "liquid",
		tiles = {
			{
				name = "aotearoa_boiling_mud_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
			},
		},
		special_tiles = {
			{
				name = "aotearoa_boiling_mud_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
				backface_culling = false,
			},
		},
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "aotearoa:silt",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = "aotearoa:boiling_mud_flowing",
		liquid_alternative_source = "aotearoa:boiling_mud_source",
		liquid_viscosity = 7,
		liquid_renewable = false,
		damage_per_second = 1,
		post_effect_color = {a = 200, r = 73, g = 64, b = 55},
		groups = {liquid = 2},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
	})

	minetest.register_node("aotearoa:boiling_mud_flowing", {
		description = "Boiling Mud Lava",
		drawtype = "flowingliquid",
		tiles = {"aotearoa_boiling_mud.png"},
		special_tiles = {
			{
				name = "aotearoa_boiling_mud_flowing_animated.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.3,
				},
			},
			{
				name = "aotearoa_boiling_mud_flowing_animated.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.3,
				},
			},
		},
		paramtype = "light",
		paramtype2 = "flowingliquid",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "flowing",
		liquid_alternative_flowing = "aotearoa:boiling_mud_flowing",
		liquid_alternative_source = "aotearoa:boiling_mud_source",
		liquid_viscosity = 7,
		liquid_renewable = false,
		liquid_range = 2,
		damage_per_second = 1,
		post_effect_color = {a = 200, r = 73, g = 64, b = 55},
		groups = {liquid = 2,	not_in_creative_inventory = 1},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:boiling_mud_source", {
		description = "Boiling Mud Source",
		drawtype = "liquid",
		tiles = {
			{
				name = "aotearoa_boiling_mud_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
			},
		},
		special_tiles = {
			{
				name = "aotearoa_boiling_mud_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.0,
				},
				backface_culling = false,
			},
		},
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "aotearoa:silt",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = "aotearoa:boiling_mud_flowing",
		liquid_alternative_source = "aotearoa:boiling_mud_source",
		liquid_viscosity = 7,
		liquid_renewable = false,
		damage_per_second = 1,
		post_effect_color = {a = 200, r = 73, g = 64, b = 55},
		groups = {liquid = 2},
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})

	minetest.register_node("aotearoa:boiling_mud_flowing", {
		description = "Boiling Mud Lava",
		drawtype = "flowingliquid",
		tiles = {"aotearoa_boiling_mud.png"},
		special_tiles = {
			{
				name = "aotearoa_boiling_mud_flowing_animated.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.3,
				},
			},
			{
				name = "aotearoa_boiling_mud_flowing_animated.png",
				backface_culling = true,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 3.3,
				},
			},
		},
		paramtype = "light",
		paramtype2 = "flowingliquid",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "flowing",
		liquid_alternative_flowing = "aotearoa:boiling_mud_flowing",
		liquid_alternative_source = "aotearoa:boiling_mud_source",
		liquid_viscosity = 7,
		liquid_renewable = false,
		liquid_range = 2,
		damage_per_second = 1,
		post_effect_color = {a = 200, r = 73, g = 64, b = 55},
		groups = {liquid = 2,	not_in_creative_inventory = 1},
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
	})
end

-----------------------------------------------------
-- Seashells
if default_loaded then
	minetest.register_node("aotearoa:seashells", {
		description = "Seashells",
		tiles = {
			"aotearoa_seashells.png",
		},
		groups = {crumbly = 3, falling_node = 1},
		sounds = default.node_sound_gravel_defaults({
		}),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:seashells", {
		description = "Seashells",
		tiles = {
			"aotearoa_seashells.png",
		},
		groups = {crumbly = 3, falling_node = 1},
		sounds = zr_gravel.sounds,
	})
end

--------------------------------------------------------
-- Odd balls
-- Elements that are just...mmmm.

-------------
-- Raupo

-- Dig upwards.
function aotearoa.dig_up(pos, nodes, digger)
	if digger == nil then
		return
	end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	for p, v in pairs(nodes) do
		local nn = minetest.get_node(np)
		if nn.name == v then
			minetest.node_dig(np, nn, digger)
		end
	end
end

if default_loaded then
	minetest.register_node("aotearoa:raupo", {
		description = "Raupo\n".. minetest.colorize("#adaba0","(Typha orientalis)"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"aotearoa_raupo.png"},
		inventory_image = "aotearoa_raupo.png",
		wield_image = "aotearoa_raupo.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 1, dry_grass = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
		},
		after_dig_node = function(pos, node, metadata, digger)
			aotearoa.dig_up(pos, {"aotearoa:raupo", "aotearoa:raupo_flower"}, digger)
		end,
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:raupo", {
		description = "Raupo\n".. minetest.colorize("#adaba0","(Typha orientalis)"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"aotearoa_raupo.png"},
		inventory_image = "aotearoa_raupo.png",
		wield_image = "aotearoa_raupo.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 1, grass_dry = 1},
		sounds = zr_wood.leaves_sounds,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
		},
		after_dig_node = function(pos, node, metadata, digger)
			aotearoa.dig_up(pos, {"aotearoa:raupo", "aotearoa:raupo_flower"}, digger)
		end,
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "aotearoa:raupo",
	burntime = 1,
})

-- Raupo flower
if default_loaded then
	minetest.register_node("aotearoa:raupo_flower", {
		description = "Raupo Flower\n".. minetest.colorize("#adaba0","(Typha orientalis)"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"aotearoa_raupo_flower.png"},
		inventory_image = "aotearoa_raupo_flower.png",
		wield_image = "aotearoa_raupo_flower.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 1, dry_grass = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
		},
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:raupo_flower", {
		description = "Raupo Flower\n".. minetest.colorize("#adaba0","(Typha orientalis)"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"aotearoa_raupo_flower.png"},
		inventory_image = "aotearoa_raupo_flower.png",
		wield_image = "aotearoa_raupo_flower.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 1, grass_dry = 1},
		sounds = zr_wood.leaves_sounds,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, 0.5, 0.1},
		},
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "aotearoa:raupo_flower",
	burntime = 1,
})


-----------------------------
-- Pipi (shellfish)

if default_loaded then
	minetest.register_node("aotearoa:pipi", {
		description = "Pipi\n".. minetest.colorize("#adaba0","(Paphies australis)"),
		drawtype = "plantlike",
		paramtype = "light",
		visual_scale = 0.6,
		tiles = {"aotearoa_pipi.png"},
		inventory_image = "aotearoa_pipi.png",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, -0.2, 0.1}
		},
		groups = {fleshy = 3, dig_immediate = 3},
		sounds = default.node_sound_gravel_defaults(),
		-- Rebury shellfish.
		on_timer = function(pos)
			local below = {x = pos.x, y = pos.y - 1, z = pos.z}
				if minetest.get_node(below).name == "default:sand" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:sand_with_pipi"})
				elseif minetest.get_node(below).name == "aotearoa:iron_sand" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:iron_sand_with_pipi"})
				end
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(3, 5))
		end,
		-- Eat and get shells.
		-- on_use = minetest.item_eat(1,"aotearoa:seashells")
		on_use = minetest.item_eat(1)
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:pipi", {
		description = "Pipi\n".. minetest.colorize("#adaba0","(Paphies australis)"),
		drawtype = "plantlike",
		paramtype = "light",
		visual_scale = 0.6,
		tiles = {"aotearoa_pipi.png"},
		inventory_image = "aotearoa_pipi.png",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, -0.2, 0.1}
		},
		groups = {fleshy = 3, dig_immediate = 3},
		sounds = zr_gravel.sounds,
		-- Rebury shellfish.
		on_timer = function(pos)
			local below = {x = pos.x, y = pos.y - 1, z = pos.z}
				if minetest.get_node(below).name == "zr_sand:sand" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:sand_with_pipi"})
				elseif minetest.get_node(below).name == "aotearoa:iron_sand" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:iron_sand_with_pipi"})
				end
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(3, 5))
		end,
		-- Eat and get shells.
		-- on_use = minetest.item_eat(1,"aotearoa:seashells")
		on_use = minetest.item_eat(1)
	})
end

-- Pipi in sand
if default_loaded then
	minetest.register_node("aotearoa:sand_with_pipi", {
		description = "Sand with Pipi",
		tiles = {"aotearoa_sand_with_pipi.png"},
		groups = {crumbly = 3, falling_node = 1, sand = 1},
		sounds = default.node_sound_sand_defaults(),
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:pipi")
			minetest.set_node(pos, {name = "default:sand"})
		end,
	})

	minetest.register_node("aotearoa:iron_sand_with_pipi", {
		description = "Iron-sand with Pipi",
		tiles = {"aotearoa_iron_sand_with_pipi.png"},
		groups = {crumbly = 3, falling_node = 1, sand = 1},
		sounds = default.node_sound_sand_defaults(),
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:pipi")
			minetest.set_node(pos, {name = "aotearoa:iron_sand"})
		end,
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:sand_with_pipi", {
		description = "Sand with Pipi",
		tiles = {"aotearoa_sand_with_pipi.png"},
		groups = {crumbly = 3, falling_node = 1, sand = 1},
		sounds = zr_sand.sounds,
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:pipi")
			minetest.set_node(pos, {name = "zr_sand:sand"})
		end,
	})

	minetest.register_node("aotearoa:iron_sand_with_pipi", {
		description = "Iron-sand with Pipi",
		tiles = {"aotearoa_iron_sand_with_pipi.png"},
		groups = {crumbly = 3, falling_node = 1, sand = 1},
		sounds = zr_sand.sounds,
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:pipi")
			minetest.set_node(pos, {name = "aotearoa:iron_sand"})
		end,
	})
end

-----------------------------
-- Cockle (shellfish)

if default_loaded then
	minetest.register_node("aotearoa:cockle", {
		description = "Cockle\n".. minetest.colorize("#adaba0","(Austrovenus stutchburyi)"),
		drawtype = "plantlike",
		paramtype = "light",
		visual_scale = 0.6,
		tiles = {"aotearoa_cockle.png"},
		inventory_image = "aotearoa_cockle.png",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, -0.2, 0.1}
		},
		groups = {fleshy = 3, dig_immediate = 3},
		sounds = default.node_sound_gravel_defaults(),
		-- Rebury shellfish.
		on_timer = function(pos)
			local below = {x = pos.x, y = pos.y - 1, z = pos.z}
				if minetest.get_node(below).name == "aotearoa:mud" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:mud_with_cockles"})
				end
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(3, 5))
		end,
		-- Eat and get shells.
		-- on_use = minetest.item_eat(1,"aotearoa:seashells")
		on_use = minetest.item_eat(1)
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:cockle", {
		description = "Cockle\n".. minetest.colorize("#adaba0","(Austrovenus stutchburyi)"),
		drawtype = "plantlike",
		paramtype = "light",
		visual_scale = 0.6,
		tiles = {"aotearoa_cockle.png"},
		inventory_image = "aotearoa_cockle.png",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-0.1, -0.5, -0.1, 0.1, -0.2, 0.1}
		},
		groups = {fleshy = 3, dig_immediate = 3},
		sounds = zr_gravel.sounds,
		-- Rebury shellfish.
		on_timer = function(pos)
			local below = {x = pos.x, y = pos.y - 1, z = pos.z}
				if minetest.get_node(below).name == "aotearoa:mud" then
					minetest.set_node(pos, {name = "air"})
					minetest.set_node(below, {name = "aotearoa:mud_with_cockles"})
				end
		end,
		on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(3, 5))
		end,
		-- Eat and get shells.
		-- on_use = minetest.item_eat(1,"aotearoa:seashells")
		on_use = minetest.item_eat(1)
	})
end

-- Cockle in mud
if default_loaded then
	minetest.register_node("aotearoa:mud_with_cockles", {
		description = "Mud with Cockles",
		tiles = {"aotearoa_mud_with_cockles.png"},
		groups = {crumbly = 3},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dug = {name = "aotearoa_mud", gain = 0.4},
		}),
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:cockle")
			minetest.set_node(pos, {name = "aotearoa:mud"})
		end,
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:mud_with_cockles", {
		description = "Mud with Cockles",
		tiles = {"aotearoa_mud_with_cockles.png"},
		groups = {crumbly = 3},
		sounds = {
			footstep = {name = "aotearoa_mud", gain = 0.4},
			dig      = {name = "zr_dirt_dig", gain = 1.0},
			dug      = {name = "aotearoa_mud", gain = 0.4},
			place    = {name = "zr_dirt_place", gain = 1.0},
		},
		-- Dig up the shellfish.
		on_punch = function(pos, node, puncher)
			puncher:get_inventory():add_item("main", "aotearoa:cockle")
			minetest.set_node(pos, {name = "aotearoa:mud"})
		end,
	})
end


---------------------------------------------------------
--[[
Stone types
Note: default/zero hardness:  stone = 3, obsidian = 1.
Note: the metamorphic relations here (cooking) are an
extreme simplification, in places.
--]]
if default_loaded then
	aotearoa.stonelist = {
		{
			"pounamu",
			"Jade",
			1,
			1,
		},
		{
			"pale_sandstone",
			"Pale Sandstone",
			3,
			2,
			"sediment",
			"default:silver_sand",
		},
		{
			"grey_sandstone",
			"Grey Sandstone",
			3,
			2,
			"sediment",
			"aotearoa:river_sand",
		},
		{
			"siltstone",
			"Siltstone",
			3,
			2,
			"sediment",
			"aotearoa:silt",
		},
		{
			"claystone",
			"Claystone",
			3,
			2,
			"sediment",
			"default:clay",
		},
		{
			"conglomerate",
			"Conglomerate",
			3,
			2,
			"sediment",
			"default:gravel",
		},
		{
			"schist",
			"Schist",
			2,
			2,
			"cooked",
			"",
			{
				"aotearoa:greywacke",
				"aotearoa:andesite",
				"aotearoa:scoria",
				"aotearoa:basalt",
			}
		},
		{
			"coquina_limestone",
			"Coquina Limestone",
			3,
			2,
			"sediment",
			"aotearoa:seashells",
		},
		{
			"limestone",
			"Limestone",
			2,
			2,
			"cooked",
			"",
			{"aotearoa:coquina_limestone", "default:coral_orange"}
		},
		{
			"concrete",
			"Concrete",
			3,
			2,
		},
		{
			"andesite",
			"Andesite",
			3,
			2,
		},
		{
			"granite",
			"Granite",
			1,
			1,
		},
		{
			"greywacke",
			"Greywacke",
			3,
			2,
			"cooked",
			"",
			{
				"aotearoa:siltstone",
				"aotearoa:claystone",
				"aotearoa:pale_sandstone",
				"aotearoa:grey_sandstone",
				"default:sandstone",
				"default:silver_sandstone",
				"default:desert_sandstone",
			}
		},
		{
			"gneiss",
			"Gneiss",
			1,
			1,
			"cooked",
			"",
			{"aotearoa:schist", "aotearoa:granite"}
		},
		{"scoria", "Scoria", 3, 2},
		{"basalt", "Basalt", 2, 2},
	}


	for i in ipairs(aotearoa.stonelist) do
		local stonename = aotearoa.stonelist[i][1]
		local stonedesc = aotearoa.stonelist[i][2]
		local hardness = aotearoa.stonelist[i][3]
		local hardness2 = aotearoa.stonelist[i][4]
		local type = aotearoa.stonelist[i][5]
		local sediment = aotearoa.stonelist[i][6]
		local precursor = aotearoa.stonelist[i][7]

		-- Make soft sedimentary rocks from/into sediment and allow them to be dug.
		local g = nil
		if type == "sediment" then
			g = {cracky = hardness, crumbly = 1, soft_stone = 1}
			-- For bricks, blocks
			g2 = {cracky = hardness2, soft_stone = 1}

			minetest.register_craft({
				output = "aotearoa:"..stonename,
				recipe = {
					{sediment, sediment, ""},
					{sediment, sediment, ""},
					{"", "", ""},
				}
			})
			minetest.register_craft({
				output = sediment.." 4",
				recipe = {
					{"aotearoa:"..stonename},
				}
			})

		else
			g = {cracky = hardness, stone = 1}
			-- For bricks, blocks
			g2 = {cracky = hardness2, stone = 1}
		end

		-- Can get raw stone by cooking something else.
		if type == "cooked" then
			-- Go through list of precusors.
			for p, v in pairs(precursor) do
				minetest.register_craft({
					type = "cooking",
					output = "aotearoa:"..stonename,
					recipe = v,
					cooktime = 120,
				})
			end
		end

		-- Raw
		minetest.register_node("aotearoa:"..stonename, {
			description = stonedesc,
			tiles = {"aotearoa_"..stonename..".png"},
			groups = g,
			drop = "aotearoa:"..stonename,
			sounds = default.node_sound_stone_defaults(),
		})

		-- Blocks and bricks
		minetest.register_node("aotearoa:"..stonename.."brick", {
			description = stonedesc.." Brick",
			tiles = {"aotearoa_"..stonename.."brick.png"},
			groups = g2,
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_node("aotearoa:"..stonename.."_block", {
			description = stonedesc.. " Block",
			tiles = {"aotearoa_"..stonename.."_block.png"},
			groups = g2,
			sounds = default.node_sound_stone_defaults(),
		})

		-- Stairs and slabs

		-- Raw
		stairs.register_stair_and_slab(
			"aotearoa_"..stonename,
			"aotearoa:"..stonename,
			{cracky = hardness},
			{"aotearoa_"..stonename..".png"},
			stonedesc.." Stair",
			stonedesc.." Slab",
			default.node_sound_stone_defaults()
		)

		-- Brick
		stairs.register_stair_and_slab(
			"aotearoa_"..stonename.."brick",
			"aotearoa:"..stonename.."brick",
			{cracky = hardness2},
			{"aotearoa_"..stonename.."brick.png"},
			stonedesc.." Brick Stair",
			stonedesc.." Brick Slab",
			default.node_sound_stone_defaults()
		)

		-- Block
		stairs.register_stair_and_slab(
			"aotearoa_"..stonename.."_block",
			"aotearoa:"..stonename.."_block",
			{cracky = hardness2},
			{"aotearoa_"..stonename.."_block.png"},
			stonedesc.." Block Stair",
			stonedesc.." Block Slab",
			default.node_sound_stone_defaults()
		)

		-- Recipe
		minetest.register_craft({
			output = "aotearoa:"..stonename.."brick 4",
			recipe = {
				{"aotearoa:"..stonename, "aotearoa:"..stonename, ""},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, ""},
				{"", "", ""},
			}
		})

		minetest.register_craft({
			output = "aotearoa:"..stonename.."_block 9",
			recipe = {
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
			}
		})
	end
elseif zero_loaded then
	aotearoa.stonelist = {
		{
			"pounamu",
			"Jade",
			1,
			1,
		},
		{
			"pale_sandstone",
			"Pale Sandstone",
			3,
			2,
			"sediment",
			"zero_sand:sand",
		},
		{
			"grey_sandstone",
			"Grey Sandstone",
			3,
			2,
			"sediment",
			"aotearoa:river_sand",
		},
		{
			"siltstone",
			"Siltstone",
			3,
			2,
			"sediment",
			"aotearoa:silt",
		},
		{
			"claystone",
			"Claystone",
			3,
			2,
			"sediment",
			"zr_clay:clay",
		},
		{
			"conglomerate",
			"Conglomerate",
			3,
			2,
			"sediment",
			"zr_gravel:gravel",
		},
		{
			"schist",
			"Schist",
			2,
			2,
			"cooked",
			"",
			{
				"aotearoa:greywacke",
				"aotearoa:andesite",
				"aotearoa:scoria",
				"aotearoa:basalt",
			}
		},
		{
			"coquina_limestone",
			"Coquina Limestone",
			3,
			2,
			"sediment",
			"aotearoa:seashells",
		},
		{
			"limestone",
			"Limestone",
			2,
			2,
			"cooked",
			"",
			{"aotearoa:coquina_limestone", "zr_coral:orange"}
		},
		{
			"concrete",
			"Concrete",
			3,
			2,
		},
		{
			"andesite",
			"Andesite",
			3,
			2,
		},
		{
			"granite",
			"Granite",
			1,
			1,
		},
		{
			"greywacke",
			"Greywacke",
			3,
			2,
			"cooked",
			"",
			{
				"aotearoa:siltstone",
				"aotearoa:claystone",
				"aotearoa:pale_sandstone",
				"aotearoa:grey_sandstone",
				"zr_sand:sandstone",
				"zr_sand:silver_sandstone",
				"zr_sand:desert_sandstone",
			}
		},
		{
			"gneiss",
			"Gneiss",
			1,
			1,
			"cooked",
			"",
			{"aotearoa:schist", "aotearoa:granite"}
		},
		{"scoria", "Scoria", 3, 2},
		{"basalt", "Basalt", 2, 2},
	}


	for i in ipairs(aotearoa.stonelist) do
		local stonename = aotearoa.stonelist[i][1]
		local stonedesc = aotearoa.stonelist[i][2]
		local hardness = aotearoa.stonelist[i][3]
		local hardness2 = aotearoa.stonelist[i][4]
		local type = aotearoa.stonelist[i][5]
		local sediment = aotearoa.stonelist[i][6]
		local precursor = aotearoa.stonelist[i][7]

		-- Make soft sedimentary rocks from/into sediment and allow them to be dug.
		local g = nil
		if type == "sediment" then
			g = {cracky = hardness, crumbly = 1, soft_stone = 1}
			-- For bricks, blocks
			g2 = {cracky = hardness2, soft_stone = 1}

			minetest.register_craft({
				output = "aotearoa:"..stonename,
				recipe = {
					{sediment, sediment, ""},
					{sediment, sediment, ""},
					{"", "", ""},
				}
			})
			minetest.register_craft({
				output = sediment.." 4",
				recipe = {
					{"aotearoa:"..stonename},
				}
			})

		else
			g = {cracky = hardness, stone = 1}
			-- For bricks, blocks
			g2 = {cracky = hardness2, stone = 1}
		end

		-- Can get raw stone by cooking something else.
		if type == "cooked" then
			-- Go through list of precusors.
			for p, v in pairs(precursor) do
				minetest.register_craft({
					type = "cooking",
					output = "aotearoa:"..stonename,
					recipe = v,
					cooktime = 120,
				})
			end
		end

		-- Raw
		minetest.register_node("aotearoa:"..stonename, {
			description = stonedesc,
			tiles = {"aotearoa_"..stonename..".png"},
			groups = g,
			drop = "aotearoa:"..stonename,
			sounds = zr_stone.sounds,
		})

		-- Blocks and bricks
		minetest.register_node("aotearoa:"..stonename.."brick", {
			description = stonedesc.." Brick",
			tiles = {"aotearoa_"..stonename.."brick.png"},
			groups = g2,
			sounds = zr_stone.sounds,
		})

		minetest.register_node("aotearoa:"..stonename.."_block", {
			description = stonedesc.. " Block",
			tiles = {"aotearoa_"..stonename.."_block.png"},
			groups = g2,
			sounds = zr_stone.sounds,
		})

		-- Stairs and slabs

		-- Raw
		zr_stair.register_all("aotearoa:"..stonename.."_",
			{recipeitem = "aotearoa:"..stonename})

		-- Brick
		zr_stair.register_all("aotearoa:"..stonename.."brick_",
			{recipeitem = "aotearoa:"..stonename.."brick"})

		-- Block
		zr_stair.register_all("aotearoa:"..stonename.."_block_",
			{recipeitem = "aotearoa:"..stonename.."_block"})

		-- Recipe
		minetest.register_craft({
			output = "aotearoa:"..stonename.."brick 4",
			recipe = {
				{"aotearoa:"..stonename, "aotearoa:"..stonename, ""},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, ""},
				{"", "", ""},
			}
		})

		minetest.register_craft({
			output = "aotearoa:"..stonename.."_block 9",
			recipe = {
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
				{"aotearoa:"..stonename, "aotearoa:"..stonename, "aotearoa:"..stonename},
			}
		})
	end
end

------------------------------------------
-- Minerals

-- Quartz with gold
if default_loaded then
	minetest.register_node("aotearoa:quartz_with_gold", {
		description = "Quartz with Gold",
		tiles = {"aotearoa_quartz_with_gold.png"},
		groups = {cracky = 2},
		drop = "default:gold_lump",
		sounds = default.node_sound_stone_defaults(),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:quartz_with_gold", {
		description = "Quartz with Gold",
		tiles = {"aotearoa_quartz_with_gold.png"},
		groups = {cracky = 2},
		drop = "zr_gold:lump",
		sounds = zr_stone.sounds,
	})
end

-- Limonite (iron ore)
if default_loaded then
	minetest.register_node("aotearoa:limonite", {
		description = "Limonite",
		tiles = {"aotearoa_limonite.png"},
		groups = {cracky = 3},
		drop = "default:iron_lump",
		sounds = default.node_sound_stone_defaults(),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:limonite", {
		description = "Limonite",
		tiles = {"aotearoa_limonite.png"},
		groups = {cracky = 3},
		drop = "zr_iron:lump",
		sounds = zr_stone.sounds,
	})
end

-- Chalcopyrite (copper ore)
if default_loaded then
	minetest.register_node("aotearoa:chalcopyrite", {
		description = "Chalcopyrite",
		tiles = {"aotearoa_chalcopyrite.png"},
		groups = {cracky = 3},
		drop = "default:copper_lump",
		sounds = default.node_sound_stone_defaults(),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:chalcopyrite", {
		description = "Chalcopyrite",
		tiles = {"aotearoa_chalcopyrite.png"},
		groups = {cracky = 3},
		drop = "zr_copper:lump",
		sounds = zr_stone.sounds,
	})
end

-- Cassiterite (tin ore)
if default_loaded then
	minetest.register_node("aotearoa:cassiterite", {
		description = "Cassiterite",
		tiles = {"aotearoa_cassiterite.png"},
		groups = {cracky = 3},
		drop = "default:tin_lump",
		sounds = default.node_sound_stone_defaults(),
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:cassiterite", {
		description = "Cassiterite",
		tiles = {"aotearoa_cassiterite.png"},
		groups = {cracky = 3},
		drop = "zr_tin:lump",
		sounds = zr_stone.sounds,
	})
end


--------------------------------
-- Tree nodes
-- All nodes (wood, leaves, stairs...)

--local sapling_time_tree =
--local sapling_time_shrub =
--local sapling_time_palm =

aotearoa.treelist = {
	{
		"pohutukawa",
		"Pohutukawa",
		"\n".. minetest.colorize("#adaba0","(Metrosideros excelsa)"),
		3,
		"flower",
	},
	{
		"kauri",
		"Kauri",
		"\n".. minetest.colorize("#adaba0", "(Agathis australis)"),
		2,
	},
	{
		"karaka",
		"Karaka",
		"\n".. minetest.colorize("#adaba0", "(Corynocarpus laevigatus)"),
		3,
		nil,
		"karaka_fruit",
		"Karaka Fruit",
		{-0.2, 0, -0.2, 0.2, 0.5, 0.2},
		1,
		-5,
	},
	{
		"rimu",
		"Rimu",
		"\n".. minetest.colorize("#adaba0", "(Dacrydium cupressinum)"),
		3,
	},
	{
		"totara",
		"Totara",
		"\n".. minetest.colorize("#adaba0", "(Podocarpus totara)"),
		2,
	},
	{
		"miro",
		"Miro",
		"\n".. minetest.colorize("#adaba0", "(Prumnopitys ferruginea)"),
		2,
		nil,
		"miro_fruit",
		"Miro Fruit",
		{-0.2, 0, -0.2, 0.2, 0.5, 0.2},
		1,
		1,
	},
	{
		"kahikatea",
		"Kahikatea",
		"\n".. minetest.colorize("#adaba0", "(Dacrycarpus dacrydioides)"),
		2,
	},
	{
		"tawa",
		"Tawa",
		"\n".. minetest.colorize("#adaba0", "(Beilschmiedia tawa)"),
		3,
		nil,
		"tawa_fruit",
		"Tawa Fruit",
		{-0.2, 0, -0.2, 0.2, 0.5, 0.2},
		1,
		1,
	},
	{
		"black_beech",
		"Black Beech",
		"\n".. minetest.colorize("#adaba0", "(Fuscospora solandri)"),
		2,
	},
	{
		"kamahi",
		"Kamahi",
		"\n".. minetest.colorize("#adaba0", "(Weinmannia racemosa)"),
		2,
		"flower",
	},
	{
		"mountain_beech",
		"Mountain Beech",
		"\n".. minetest.colorize("#adaba0", "(Fuscospora cliffortioides)"),
		2,
	},
	{
		"pahautea",
		"Pahautea",
		"\n".. minetest.colorize("#adaba0", "(Libocedrus bidwillii)"),
		2,
	},
	{
		"kowhai",
		"Kowhai",
		"\n".. minetest.colorize("#adaba0", "(Sophora microphylla)"),
		3,
		"flower",
	},
	{
		"silver_beech",
		"Silver Beech",
		"\n".. minetest.colorize("#adaba0", "(Lophozonia menziesii)"),
		2,
	},
	{
		"black_maire",
		"Black Maire",
		"\n".. minetest.colorize("#adaba0", "(Nestegis cunninghamii)"),
		2,
		"flower",
	},
	{
		"hinau",
		"Hinau",
		"\n".. minetest.colorize("#adaba0", "(Elaeocarpus dentatus)"),
		2,
		"flower",
		"hinau_fruit",
		"Hinau Fruit",
		{-0.2, 0, -0.2, 0.2, 0.5, 0.2},
		1,
		1,
	},
}


for i in ipairs(aotearoa.treelist) do
	local treename = aotearoa.treelist[i][1]
	local treedesc = aotearoa.treelist[i][2]
	local sci_name = aotearoa.treelist[i][3]
	local decay = aotearoa.treelist[i][4]
	local type = aotearoa.treelist[i][5]
	local fruit = aotearoa.treelist[i][6]
	local fruitdesc = aotearoa.treelist[i][7]
	local selbox = aotearoa.treelist[i][8]
	local vscale = aotearoa.treelist[i][9]
	local foodvalue = aotearoa.treelist[i][10]
	-- Player will get a sapling with 1/50 chance.
	local droprarity = 50

	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc.." Tree"..sci_name,
			tiles = {
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree.png"
			},
			paramtype = "light",
			paramtype2 = "facedir",
			is_ground_content = false,
			groups = {tree = 1, choppy = 2, flammable = 2},
			sounds = default.node_sound_wood_defaults(),
			on_place = minetest.rotate_node,
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc.." Tree"..sci_name,
			tiles = {
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree.png"
			},
			paramtype = "light",
			paramtype2 = "facedir",
			is_ground_content = false,
			groups = {tree = 1, choppy = 2, flammable = 2},
			sounds = zr_wood.sounds,
			on_place = minetest.rotate_node,
		})
	end

	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_wood", {
			description = treedesc.." Wooden Planks"..sci_name,
			tiles = {"aotearoa_"..treename.."_wood.png"},
			paramtype = "light",
			paramtype2 = "facedir",
			is_ground_content = false,
			groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
			sounds = default.node_sound_wood_defaults(),
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_wood", {
			description = treedesc.." Wooden Planks"..sci_name,
			tiles = {"aotearoa_"..treename.."_wood.png"},
			paramtype = "light",
			paramtype2 = "facedir",
			is_ground_content = false,
			groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
			sounds = zr_wood.sounds,
		})
	end

	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = treedesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..treename.."_sapling.png"},
			inventory_image = "aotearoa_"..treename.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {
				snappy = 2,
				dig_immediate = 3,
				flammable = 2,
				attached_node = 1,
				sapling = 1,
			},
			sounds = default.node_sound_defaults(),
			on_timer = function(pos,elapsed)
				aotearoa.grow_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = default.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = treedesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..treename.."_sapling.png"},
			inventory_image = "aotearoa_"..treename.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2, dig_immediate=3, flammable=2, attached_node=1, sapling=1},
			sounds = zr_wood.leaves_sounds,
			on_timer = function(pos,elapsed)
				aotearoa.grow_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = zr_wood.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	end

	-- Put flowering in flower group.
	local g = nil
	if type == "flower" then
		g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1, flower = 1}
	else
		g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1}
	end

	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_leaves", {
			description = treedesc.." Leaves"..sci_name,
			drawtype = "allfaces_optional",
			tiles ={"aotearoa_"..treename.."_leaves.png"},
			paramtype = "light",
			is_ground_content = false,
			walkable = false,
			-- sunlight_propagates = true,
			groups = g,
			waving = 2,
			sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling"}, rarity = droprarity},
					{items = {"aotearoa:"..treename.."_leaves"}}
				}
			},
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_leaves", {
			description = treedesc.." Leaves"..sci_name,
			drawtype = "allfaces_optional",
			tiles ={"aotearoa_"..treename.."_leaves.png"},
			paramtype = "light",
			is_ground_content = false,
			walkable = false,
			-- sunlight_propagates = true,
			groups = g,
			waving = 2,
			sounds = zr_wood.leaves_sounds,
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling"}, rarity = droprarity},
					{items = {"aotearoa:"..treename.."_leaves"}}
				}
			},
		})
	end

	-- Stairs etc.
	if default_loaded then
		stairs.register_stair_and_slab(
			"aotearoa_"..treename.."_tree",
			"aotearoa:"..treename.."_tree",
			{snappy=1, choppy=2, oddly_breakable_by_hand=1, flammable=2},
			{
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree.png",
			},
			treedesc.." Tree Stair"..sci_name,
			treedesc.." Tree Slab"..sci_name,
			default.node_sound_wood_defaults()
		)

		stairs.register_stair_and_slab(
			"aotearoa_"..treename.."_wood",
			"aotearoa:"..treename.."_wood",
			{snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			{"aotearoa_"..treename.."_wood.png"},
			treedesc.." Wood Stair"..sci_name,
			treedesc.." Wood Slab"..sci_name,
			default.node_sound_wood_defaults()
		)
	elseif zero_loaded then
		zr_stair.register_all("aotearoa:"..treename.."_tree_",
			{recipeitem = "aotearoa:"..treename.."_tree"})

		zr_stair.register_all("aotearoa:"..treename.."_wood_",
			{recipeitem = "aotearoa:"..treename.."_wood"})
	end

	-- Fence
	if default_loaded then
		default.register_fence("aotearoa:fence_"..treename.."_wood", {
			description = treedesc.." Wood Fence"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = default.node_sound_wood_defaults(),
		})
	elseif zero_loaded then
		zr_fence.register_fence("aotearoa:fence_"..treename.."_wood", {
			description = treedesc.." Wood Fence"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = zr_wood.sounds,
		})
	end

	-- Fence rail
	if default_loaded then
		default.register_fence_rail("aotearoa:fence_rail_"..treename.."_wood", {
			description = treedesc.." Wood Fence Rail"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = default.node_sound_wood_defaults(),
		})
	elseif zero_loaded then
		zr_fence.register_fence_rail("aotearoa:fence_rail_"..treename.."_wood", {
			description = treedesc.." Wood Fence Rail"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = zr_wood.sounds,
		})
	end

	-- Gate
	if default_loaded then
		doors.register_fencegate("aotearoa:gate_"..treename.."_wood", {
			description = treedesc.." Wood Gate"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = default.node_sound_wood_defaults(),
		})
	elseif zero_loaded then
		zr_door.register_gate("aotearoa:gate_"..treename.."_wood", {
			description = treedesc.." Wood Gate"..sci_name,
			texture = "aotearoa_"..treename.."_wood.png",
			material = "aotearoa:"..treename.."_wood",
			groups = {snappy=1, choppy=2, oddly_breakable_by_hand=2, flammable=2},
			sounds = zr_wood.sounds,
		})
	end

	minetest.register_craft({
		output = "aotearoa:"..treename.."_wood 4",
		recipe = {
			{"aotearoa:"..treename.."_tree"},
		}
	})

	if default_loaded then
		local fruitname = nil
		if fruit then
			fruitname = "aotearoa:"..fruit
			minetest.register_node(fruitname, {
				description = fruitdesc..sci_name,
				drawtype = "plantlike",
				paramtype2 = "meshoptions",
				place_param2 = 0 + 0x08,
				tiles = {"aotearoa_"..fruit..".png"},
				inventory_image = "aotearoa_"..fruit..".png",
				wield_image = "aotearoa_"..fruit..".png",
				visual_scale = vscale,
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				selection_box = {
					type = "fixed",
					fixed = selbox
				},
				groups = {
					fleshy = 3,
					dig_immediate = 3,
					flammable = 2,
					leafdecay = 3,
					leafdecay_drop = 1,
				},
				on_use = minetest.item_eat(foodvalue),
				sounds = default.node_sound_defaults(),
			})

			default.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves", fruitname},
				radius = decay,
			})

		else
			default.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves"},
				radius = decay,
			})
		end
	elseif zero_loaded then
		local fruitname = nil
		if fruit then
			fruitname = "aotearoa:"..fruit
			minetest.register_node(fruitname, {
				description = fruitdesc..sci_name,
				drawtype = "plantlike",
				paramtype2 = "meshoptions",
				place_param2 = 0 + 0x08,
				tiles = {"aotearoa_"..fruit..".png"},
				inventory_image = "aotearoa_"..fruit..".png",
				wield_image = "aotearoa_"..fruit..".png",
				visual_scale = vscale,
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				selection_box = {
					type = "fixed",
					fixed = selbox
				},
				groups = {
					fleshy = 3,
					dig_immediate = 3,
					flammable = 2,
					leafdecay = 3,
					leafdecay_drop = 1,
				},
				on_use = minetest.item_eat(foodvalue),
				sounds = zr_wood.leaves_sounds,
			})

			zr_wood.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves", fruitname},
				radius = decay,
			})

		else
			zr_wood.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves"},
				radius = decay,
			})
		end
	end
end


--------------------------------
-- Shrub nodes
-- Small trees. Thin trunks. Craft into sticks rather than wood.
aotearoa.shrublist = {
	{
		"mangrove",
		"Mangrove",
		"\n".. minetest.colorize("#adaba0","(Avicennia marina)"),
		2,
	},
	{
		"karo",
		"Karo",
		"\n".. minetest.colorize("#adaba0","(Pittosporum crassifolium)"),
		2,
	},
	{
		"kawakawa",
		"Kawakawa",
		"\n".. minetest.colorize("#adaba0","(Piper excelsum)"),
		2,
		nil,
		0,
		"kawakawa_fruit",
		"Kawakawa Fruit",
		{-0.2, -0.5, -0.2, 0.2, 0, 0.2},
		0.8,
		1,
	},
	{
		"manuka",
		"Manuka",
		"\n".. minetest.colorize("#adaba0","(Leptospermum scoparium)"),
		2,
		"flower",
	},
	{
		"common_tree_daisy",
		"Common Tree Daisy",
		"\n".. minetest.colorize("#adaba0","(Olearia arborescens)"),
		2,
		"flower",
	},
	{
		"matagouri",
		"Matagouri",
		"\n".. minetest.colorize("#adaba0","(Discaria toumatou)"),
		2,
		nil,
		1,
	},
	{
		"mahoe",
		"Mahoe",
		"\n".. minetest.colorize("#adaba0","(Melicytus ramiflorus)"),
		2,
	},
	{
		"rangiora",
		"Rangiora",
		"\n".. minetest.colorize("#adaba0","(Brachyglottis repanda)"),
		2,
		"flower",
	},
}


for i in ipairs(aotearoa.shrublist) do
	local treename = aotearoa.shrublist[i][1]
	local treedesc = aotearoa.shrublist[i][2]
	local sci_name = aotearoa.shrublist[i][3]
	local decay = aotearoa.shrublist[i][4]
	local type = aotearoa.shrublist[i][5]
	local damage = aotearoa.shrublist[i][6]
	local fruit = aotearoa.shrublist[i][7]
	local fruitdesc = aotearoa.shrublist[i][8]
	local selbox = aotearoa.shrublist[i][9]
	local vscale = aotearoa.shrublist[i][10]
	local foodvalue = aotearoa.shrublist[i][11]
	--[[
	Player will get a sapling with 1/30 chance.
	Player will get leaves only if they get no saplings;
	this is because max_items is 1.
	--]]
	local droprarity = 30
	local trunkbox = {-1/6, -1/2, -1/6, 1/6, 1/2, 1/6}

	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc.." Tree"..sci_name,
			drawtype = "nodebox",
			tiles = {
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree.png"
			},
			node_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			selection_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			paramtype = "light",
			paramtype2 = "facedir",
			climbable = true,
			is_ground_content = false,
			groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
			sounds = default.node_sound_wood_defaults(),
			use_texture_alpha = "clip",
		})

		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = treedesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..treename.."_sapling.png"},
			inventory_image = "aotearoa_"..treename.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
			on_timer = function(pos,elapsed)
				aotearoa.grow_shrub_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = default.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc.." Tree"..sci_name,
			drawtype = "nodebox",
			tiles = {
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree_top.png",
				"aotearoa_"..treename.."_tree.png"
			},
			node_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			selection_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			paramtype = "light",
			paramtype2 = "facedir",
			climbable = true,
			is_ground_content = false,
			groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
			sounds = zr_wood.sounds,
			use_texture_alpha = "clip",
		})

		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = treedesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..treename.."_sapling.png"},
			inventory_image = "aotearoa_"..treename.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = zr_wood.leaves_sounds,
			on_timer = function(pos,elapsed)
				aotearoa.grow_shrub_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = zr_wood.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	end

	-- Put flowering in flower group.
	if default_loaded then
		local g = nil
		if type == "flower" then
			g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1, flower = 1}
		else
			g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1}
		end

		minetest.register_node("aotearoa:"..treename.."_leaves", {
			description = treedesc.." Leaves"..sci_name,
			drawtype = "allfaces_optional",
			tiles ={"aotearoa_"..treename.."_leaves.png"},
			paramtype = "light",
			is_ground_content = false,
			walkable = false,
			damage_per_second = damage,
			sunlight_propagates = true,
			waving = 2,
			groups = g,
			sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling",}, rarity = droprarity,},
					{items = {"aotearoa:"..treename.."_leaves",}}
				}
			},
		})

		minetest.register_craft({
			output = "default:stick 2",
			recipe = {
				{"aotearoa:"..treename.."_tree"},
			}
		})

		local fruitname = nil
		if fruit then
			fruitname = "aotearoa:"..fruit
			minetest.register_node(fruitname, {
				description = fruitdesc ..sci_name,
				drawtype = "plantlike",
				paramtype2 = "meshoptions",
				place_param2 = 0 + 0x08,
				tiles = {"aotearoa_"..fruit..".png"},
				inventory_image = "aotearoa_"..fruit..".png",
				wield_image = "aotearoa_"..fruit..".png",
				visual_scale = vscale,
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				selection_box = {
					type = "fixed",
					fixed = selbox,
				},
				groups = {
					fleshy = 3,
					dig_immediate = 3,
					flammable = 2,
					leafdecay = 3,
					leafdecay_drop = 1,
				},
				on_use = minetest.item_eat(foodvalue),
				sounds = default.node_sound_defaults(),
			})

			default.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves", fruitname},
				radius = decay,
			})
		else
			default.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves"},
				radius = decay,
			})
		end
	elseif zero_loaded then
		local g = nil
		if type == "flower" then
			g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1, flower = 1}
		else
			g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1}
		end

		minetest.register_node("aotearoa:"..treename.."_leaves", {
			description = treedesc.." Leaves"..sci_name,
			drawtype = "allfaces_optional",
			tiles ={"aotearoa_"..treename.."_leaves.png"},
			paramtype = "light",
			is_ground_content = false,
			walkable = false,
			damage_per_second = damage,
			sunlight_propagates = true,
			groups = g,
			waving = 2,
			sounds = zr_wood.leaves_sounds,
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling",}, rarity = droprarity,},
					{items = {"aotearoa:"..treename.."_leaves",}}
				}
			},
		})

		minetest.register_craft({
			output = "zr_wood:stick 2",
			recipe = {
				{"aotearoa:"..treename.."_tree"},
			}
		})

		local fruitname = nil
		if fruit then
			fruitname = "aotearoa:"..fruit
			minetest.register_node(fruitname, {
				description = fruitdesc ..sci_name,
				drawtype = "plantlike",
				paramtype2 = "meshoptions",
				place_param2 = 0 + 0x08,
				tiles = {"aotearoa_"..fruit..".png"},
				inventory_image = "aotearoa_"..fruit..".png",
				wield_image = "aotearoa_"..fruit..".png",
				visual_scale = vscale,
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				selection_box = {
					type = "fixed",
					fixed = selbox,
				},
				groups = {
					fleshy = 3,
					dig_immediate = 3,
					flammable = 2,
					leafdecay = 3,
					leafdecay_drop = 1,
				},
				on_use = minetest.item_eat(foodvalue),
				sounds = zr_wood.leaves_sounds,
			})

			zr_wood.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves", fruitname},
				radius = decay,
			})
		else
			zr_wood.register_leafdecay({
				trunks = {"aotearoa:"..treename.."_tree"},
				leaves = {"aotearoa:"..treename.."_leaves"},
				radius = decay,
			})
		end
	end
end


----------------------------------------------------------------------
-- Plant nodes
-- Ground cover plants
aotearoa.plantlist = {
	{
		"moss",
		"Moss",
		"",
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		1,
		nil,
		"crumbly",
		"nodebox",
	},
	{
		"pohuehue",
		"Pohuehue",
		"\n".. minetest.colorize("#adaba0","(Muehlenbeckia complexa)"),
		{-0.47, -0.5, -0.47, 0.47, 0.37,0.47},
		1,
		2,
		"sand",
		"nodebox",
	},
	{
		"pingao",
		"Pingao",
		"\n".. minetest.colorize("#adaba0","(Ficinia spiralis)"),
		nil,
		1,
		1,
		"sand",
	},
	{
		"spinifex",
		"Spinifex",
		"\n".. minetest.colorize("#adaba0","(Spinifex sericeus)"),
		nil,
		1,
		1,
		"sand",
	},
	{
		"wiwi",
		"Wiwi",
		"\n".. minetest.colorize("#adaba0","(Ficinia nodosa)"),
		nil,
		1,
		1,
		"grass",
	},
	{
		"flax",
		"Flax",
		"\n".. minetest.colorize("#adaba0","(Phormium tenax)"),
		nil,
		1.5,
		1,
		"flower",
	},
	{
		"bracken",
		"Bracken",
		"\n".. minetest.colorize("#adaba0","(Pteridium esculentum)"),
		nil,
		1,
		1,
		"dry_grass",
	},
	{
		"red_tussock",
		"Red tussock",
		"\n".. minetest.colorize("#adaba0","(Chionochloa rubra)"),
		nil,
		1,
		1,
		"dry_grass",
	},
	{
		"kiokio",
		"Kiokio",
		"\n".. minetest.colorize("#adaba0","(Parablechnum novae-zelandiae)"),
		nil,
		1,
		1,
		nil,
	},
	{
		"bristle_tussock",
		"Bristle Tussock",
		"\n".. minetest.colorize("#adaba0","(Rytidosperma setifolium)"),
		nil,
		1,
		1,
		"dry_grass",
	},
	{
		"kauri_grass",
		"Kauri Grass",
		"\n".. minetest.colorize("#adaba0","(Astelia trinervia)"),
		nil,
		1,
		1,
		nil,
	},
	{
		"crown_fern",
		"Crown Fern",
		"\n".. minetest.colorize("#adaba0","(Blechnum discolor)"),
		nil,
		1,
		1,
	},
	{
		"sea_rush",
		"Sea Rush",
		"\n".. minetest.colorize("#adaba0","(Juncus kraussii)"),
		nil,
		1,
		1,
		"grass",
	},
}


for i in ipairs(aotearoa.plantlist) do
	local plantname = aotearoa.plantlist[i][1]
	local plantdesc = aotearoa.plantlist[i][2]
	local sci_name = aotearoa.plantlist[i][3]
	local selbox = aotearoa.plantlist[i][4]
	local vscale = aotearoa.plantlist[i][5]
	local waves = aotearoa.plantlist[i][6]
	local type = aotearoa.plantlist[i][7]
	local draw = aotearoa.plantlist[i][8]

	if selbox == nil then
		selbox = {-0.4, -0.5, -0.4, 0.4, -0.2, 0.4}
	end

	if default_loaded then
		local g = nil
		if type == "grass" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, grass = 1}
		elseif type == "dry_grass" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, dry_grass = 1}
		elseif type == "flower" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, flower = 1}
		elseif type == "leaves" then
				g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, leaves = 1}
		elseif type == "crumbly" then
				g = {crumbly = 3, attached_node = 1, flammable = 1, flora = 1}
		-- Anything on sand must not be in flora group or "Flowers" spams it with dry shrubs.
		elseif type == "sand" then
			g = {snappy = 3, attached_node = 1, flammable = 1,}
		else
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1}
		end

		if draw ~= "nodebox" then
			minetest.register_node("aotearoa:"..plantname, {
				description = plantdesc ..sci_name,
				drawtype = "plantlike",
				waving = waves,
				visual_scale = vscale,
				tiles = {"aotearoa_"..plantname..".png"},
				inventory_image = "aotearoa_"..plantname..".png",
				wield_image = "aotearoa_"..plantname..".png",
				paramtype = "light",
				sunlight_propagates = true,
				walkable = false,
				buildable_to = true,
				groups = g,
				sounds = default.node_sound_leaves_defaults(),
				selection_box = {
					type = "fixed",
					fixed = selbox,
				},
				use_texture_alpha = "clip",
			})
		-- Single node bushes etc.
		elseif draw == "nodebox" then
			minetest.register_node("aotearoa:"..plantname, {
				description = plantdesc,
				drawtype = "nodebox",
				waving = waves,
				node_box = {
					type = "fixed",
					fixed = {
						selbox,
					},
				},
				tiles = {"aotearoa_"..plantname..".png"},
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				buildable_to = true,
				groups = g,
				sounds = default.node_sound_leaves_defaults(),
				use_texture_alpha = "clip",
			})
		end
	elseif zero_loaded then
		local g = nil
		if type == "grass" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, grass = 1}
		elseif type == "dry_grass" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, grass_dry = 1}
		elseif type == "flower" then
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, flower = 1}
		elseif type == "leaves" then
				g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1, leaves = 1}
		elseif type == "crumbly" then
				g = {crumbly = 3, attached_node = 1, flammable = 1, flora = 1}
		-- Anything on sand must not be in flora group or "Flowers" spams it with dry shrubs.
		elseif type == "sand" then
			g = {snappy = 3, attached_node = 1, flammable = 1,}
		else
			g = {snappy = 3, attached_node = 1, flammable = 1, flora = 1}
		end

		if draw ~= "nodebox" then
			minetest.register_node("aotearoa:"..plantname, {
				description = plantdesc ..sci_name,
				drawtype = "plantlike",
				waving = waves,
				visual_scale = vscale,
				tiles = {"aotearoa_"..plantname..".png"},
				inventory_image = "aotearoa_"..plantname..".png",
				wield_image = "aotearoa_"..plantname..".png",
				paramtype = "light",
				sunlight_propagates = true,
				walkable = false,
				buildable_to = true,
				groups = g,
				sounds = zr_wood.leaves_sounds,
				selection_box = {
					type = "fixed",
					fixed = selbox,
				},
				use_texture_alpha = "clip",
			})
		-- Single node bushes etc.
		elseif draw == "nodebox" then
			minetest.register_node("aotearoa:"..plantname, {
				description = plantdesc,
				drawtype = "nodebox",
				waving = waves,
				node_box = {
					type = "fixed",
					fixed = {
						selbox,
					},
				},
				tiles = {"aotearoa_"..plantname..".png"},
				paramtype = "light",
				sunlight_propagates = true,
				is_ground_content = false,
				walkable = false,
				buildable_to = true,
				groups = g,
				sounds = zr_wood.leaves_sounds,
				use_texture_alpha = "clip",
			})
		end
	end

	minetest.register_craft({
		type = "fuel",
		recipe = "aotearoa:"..plantname,
		burntime = 1,
	})
end


------------------------------------------
-- Bushes
-- Woody bushes
aotearoa.bushlist = {
	{
		"leatherwood",
		"Leatherwood",
		"\n".. minetest.colorize("#adaba0","(Olearia colensoi)"),
		2,
	},
	{
		"kokomuka",
		"Kokomuka",
		"\n".. minetest.colorize("#adaba0","(Veronica elliptica)"),
		2,
		"flower",
	},
}

for i in ipairs(aotearoa.bushlist) do
	local plantname = aotearoa.bushlist[i][1]
	local plantdesc = aotearoa.bushlist[i][2]
	local sci_name = aotearoa.bushlist[i][3]
	local decay = aotearoa.bushlist[i][4]
	local type = aotearoa.bushlist[i][5]
	local nodebox = aotearoa.bushlist[i][6]

	local droprarity = 5
	if nodebox == nil then
		nodebox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	end

	-- Put flowering in flower group.
	local g = nil
	if type == "flower" then
		g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1, flower = 1,}
	else
		g = {snappy = 3, flammable = 2, leaves = 1, leafdecay = 1,}
	end

	-- Sapling
	if default_loaded then
		minetest.register_node("aotearoa:"..plantname.."_sapling", {
			description = plantdesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..plantname.."_sapling.png"},
			inventory_image = "aotearoa_"..plantname.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
			on_timer = function(pos,elapsed)
				aotearoa.grow_bush_sapling(pos, plantname, "aotearoa:"..plantname.."_stem")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = default.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..plantname.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..plantname.."_sapling", {
			description = plantdesc.." Sapling"..sci_name,
			drawtype = "plantlike",
			tiles = {"aotearoa_"..plantname.."_sapling.png"},
			inventory_image = "aotearoa_"..plantname.."_sapling.png",
			paramtype = "light",
			walkable = false,
			is_ground_content = true,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = zr_wood.leaves_sounds,
			on_timer = function(pos,elapsed)
				aotearoa.grow_bush_sapling(pos, plantname, "aotearoa:"..plantname.."_stem")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = zr_wood.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..plantname.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	end

	-- Leaves
	if default_loaded then
		minetest.register_node("aotearoa:"..plantname, {
			description = plantdesc.. " Leaves"..sci_name,
			drawtype = "allfaces_optional",
			node_box = {
				type = "fixed",
				fixed = {
					nodebox,
				},
			},
			tiles = {"aotearoa_"..plantname..".png"},
			paramtype = "light",
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = false,
			groups = g,
			waving = 2,
			drop = {
			max_items = 1,
			items = {
				{items = {"aotearoa:"..plantname.."_sapling",}, rarity = droprarity},
				{items = {"aotearoa:"..plantname}}
			}
		},
			sounds = default.node_sound_leaves_defaults(),
			use_texture_alpha = "clip",
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..plantname, {
			description = plantdesc.. " Leaves"..sci_name,
			drawtype = "allfaces_optional",
			node_box = {
				type = "fixed",
				fixed = {
					nodebox,
				},
			},
			tiles = {"aotearoa_"..plantname..".png"},
			paramtype = "light",
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = false,
			groups = g,
			waving = 2,
			drop = {
			max_items = 1,
			items = {
				{items = {"aotearoa:"..plantname.."_sapling",}, rarity = droprarity},
				{items = {"aotearoa:"..plantname}}
			}
		},
			sounds = zr_wood.leaves_sounds,
			use_texture_alpha = "clip",
		})
	end

	-- Stem
	if default_loaded then
		minetest.register_node("aotearoa:"..plantname.."_stem", {
			description = plantdesc.." Stem"..sci_name,
			drawtype = "plantlike",
			visual_scale = 1.41,
			tiles = {"aotearoa_"..plantname.."_stem.png"},
			inventory_image = "aotearoa_"..plantname.."_stem.png",
			wield_image = "aotearoa_"..plantname.."_stem.png",
			paramtype = "light",
			sunlight_propagates = true,
			groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
			sounds = default.node_sound_wood_defaults(),
			selection_box = {
				type = "fixed",
				fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16},
			},
		})

		default.register_leafdecay({
			trunks = {"aotearoa:"..plantname.."_stem",},
			leaves = {"aotearoa:"..plantname,},
			radius = decay,
		})

		-- Craft stem into stick.
		minetest.register_craft({
			output = "default:stick",
			recipe = {
				{"aotearoa:"..plantname.."_stem"},
			}
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..plantname.."_stem", {
			description = plantdesc.." Stem"..sci_name,
			drawtype = "plantlike",
			visual_scale = 1.41,
			tiles = {"aotearoa_"..plantname.."_stem.png"},
			inventory_image = "aotearoa_"..plantname.."_stem.png",
			wield_image = "aotearoa_"..plantname.."_stem.png",
			paramtype = "light",
			sunlight_propagates = true,
			groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
			sounds = zr_wood.sounds,
			selection_box = {
				type = "fixed",
				fixed = {-7/16, -0.5, -7/16, 7/16, 0.5, 7/16},
			},
		})

		zr_wood.register_leafdecay({
			trunks = {"aotearoa:"..plantname.."_stem",},
			leaves = {"aotearoa:"..plantname,},
			radius = decay,
		})

		-- Craft stem into stick.
		minetest.register_craft({
			output = "zr_wood:stick",
			recipe = {
				{"aotearoa:"..plantname.."_stem"},
			}
		})
	end

	-- Burnables
	minetest.register_craft({
		type = "fuel",
		recipe = "aotearoa:"..plantname.."_stem",
		burntime = 2,
	})
end


-------------------------------------------
-- Tree ferns & palm style
-- Plant on a pole!
aotearoa.tfernlist = {
	{
		"mamaku",
		"Mamaku",
		"\n".. minetest.colorize("#adaba0","(Cyathea medullaris)"),
		3.5,
		"fern",
	},
	{
		"silver_fern",
		"Silver Fern",
		"\n".. minetest.colorize("#adaba0","(Cyathea dealbata)"),
		3,
		"fern"
	},
	{
		"wheki",
		"Wheki",
		"\n".. minetest.colorize("#adaba0","(Dicksonia squarrosa)"),
		2.5,
		"fern",
		nil,
		"skirt",
	},
	{
		"cabbage_tree",
		"Cabbage Tree",
		"\n".. minetest.colorize("#adaba0","(Cordyline australis)"),
		1.8,
	},
	{
		"nikau_palm",
		"Nikau Palm",
		"\n".. minetest.colorize("#adaba0","(Rhopalostylis sapida)"),
		3.5,
		"",
		nil,
		"skirt",
	},
}

for i in ipairs(aotearoa.tfernlist) do
	local treename   = aotearoa.tfernlist[i][1]
	local treedesc   = aotearoa.tfernlist[i][2]
	local sci_name   = aotearoa.tfernlist[i][3]
	local crownscale = aotearoa.tfernlist[i][4]
	local treetype   = aotearoa.tfernlist[i][5]
	local crownbox   = aotearoa.tfernlist[i][6]
	local skirt      = aotearoa.tfernlist[i][7]
	-- Player will get a sapling with 1/10 chance.
	local droprarity = 3
	local trunkbox = {-1/6, -1/2, -1/6, 1/6, 1/2, 1/6}
	-- Set a default selection box, for those that don't need special treatment.
	if crownbox == nil then
		crownbox = {-7/16, -1/2, -7/16, 7/16, 0, 7/16}
	end

	-- Special treatment for treeferns
	-- Give ferns spores, no sticks, same tree top image.
	local treetop_image = nil
	local sapimage = nil
	local sapdesc = nil
	local sapdraw = nil
	local sapbox = nil
	if treetype == "fern" then
		treetop_image = "aotearoa_tree_fern_top.png"
		sapimage = "aotearoa_tree_fern_spores.png"
		sapdesc = treedesc.." Spores"
		sapdraw = "nodebox"
		sapbox = {-0.5, -0.5, -0.5, 0.5, -0.48, 0.5}
	else
		treetop_image = "aotearoa_"..treename.."_tree_top.png"
		sapimage = "aotearoa_"..treename.."_sapling.png"
		sapdesc = treedesc.." Sapling"
		sapdraw = "plantlike"
		sapbox = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
		-- And while we are here... (ferns give a useless stick!).
		if default_loaded then
			minetest.register_craft({
				output = "default:stick 2",
				recipe = {
					{"aotearoa:"..treename.."_tree"},
				}
			})
		elseif zero_loaded then
			minetest.register_craft({
				output = "zr_wood:stick 2",
				recipe = {
					{"aotearoa:"..treename.."_tree"},
				}
			})
		end
	end

	-- Trunk
	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc .." Trunk "..sci_name,
			drawtype = "nodebox",
			tiles = {
				treetop_image,
				treetop_image,
				"aotearoa_"..treename.."_tree.png"
			},
			node_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			selection_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			paramtype = "light",
			paramtype2 = "facedir",
			climbable = true,
			is_ground_content = false,
			groups = {
				tree = 1,
				choppy = 3,
				oddly_breakable_by_hand = 1,
				flammable = 2,
				attached_node=1,
			},
			sounds = default.node_sound_wood_defaults(),
			use_texture_alpha = "clip",
		})

		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = sapdesc..sci_name,
			drawtype = sapdraw,
			tiles = {sapimage},
			inventory_image = sapimage,
			use_texture_alpha = "clip",
			node_box = {
				type = "fixed",
				fixed = {sapbox,},
			},
			selection_box = {
				type = "fixed",
				fixed = {sapbox,},
			},
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = true,
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
			on_timer = function(pos,elapsed)
				aotearoa.grow_tree_fern_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(1)
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = default.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_tree", {
			description = treedesc .." Trunk "..sci_name,
			drawtype = "nodebox",
			tiles = {
				treetop_image,
				treetop_image,
				"aotearoa_"..treename.."_tree.png"
			},
			node_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			selection_box = {
				type = "fixed",
				fixed = trunkbox,
			},
			paramtype = "light",
			paramtype2 = "facedir",
			climbable = true,
			is_ground_content = false,
			groups = {
				tree = 1,
				choppy = 3,
				oddly_breakable_by_hand = 1,
				flammable = 2,
				attached_node=1,
			},
			sounds = zr_wood.sounds,
			use_texture_alpha = "clip",
		})

		minetest.register_node("aotearoa:"..treename.."_sapling", {
			description = sapdesc..sci_name,
			drawtype = sapdraw,
			tiles = {sapimage},
			inventory_image = sapimage,
			use_texture_alpha = "clip",
			node_box = {
				type = "fixed",
				fixed = {sapbox,},
			},
			selection_box = {
				type = "fixed",
				fixed = {sapbox,},
			},
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = true,
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = zr_wood.leaves_sounds,
			on_timer = function(pos,elapsed)
				aotearoa.grow_tree_fern_sapling(pos, treename, "aotearoa:"..treename.."_tree")
			end,
			on_construct = function(pos)
				minetest.get_node_timer(pos):start(math.random(300, 1500))
			end,
			on_place = function(itemstack, placer, pointed_thing)
				itemstack = zr_wood.sapling_on_place(
					itemstack,
					placer,
					pointed_thing,
					"aotearoa:"..treename.."_sapling",
					-- minp, maxp to be checked, relative to sapling pos.
					-- minp_relative.y = 1 because sapling pos has been checked.
					{x = -2, y = 1, z = -2},
					{x = 2, y = 6, z = 2},
					-- Maximum interval of interior volume check
					4
				)
				return itemstack
			end,
		})
	end

	-- Tree fern crown
	if default_loaded then
		minetest.register_node("aotearoa:"..treename.."_crown", {
			description = treedesc.." Crown "..sci_name,
			drawtype = "plantlike",
			visual_scale = crownscale,
			paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = 0 + 0x08,
			tiles = {"aotearoa_"..treename.."_crown.png"},
			inventory_image = "aotearoa_"..treename.."_crown.png",
			walkable = false,
			sunlight_propagates = true,
			groups = {snappy = 3, flammable = 2, leaves = 1, attached_node=1,},
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling"}, rarity = droprarity,},
					{items = {"aotearoa:"..treename.."_crown"}}
				}
			},
			waving = 1,
			sounds = default.node_sound_leaves_defaults(),
			selection_box = {
				type = "fixed",
				fixed = crownbox,
			},
		})
	elseif zero_loaded then
		minetest.register_node("aotearoa:"..treename.."_crown", {
			description = treedesc.." Crown "..sci_name,
			drawtype = "plantlike",
			visual_scale = crownscale,
			paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = 0 + 0x08,
			tiles = {"aotearoa_"..treename.."_crown.png"},
			inventory_image = "aotearoa_"..treename.."_crown.png",
			walkable = false,
			sunlight_propagates = true,
			groups = {snappy = 3, flammable = 2, leaves = 1, attached_node=1,},
			drop = {
				max_items = 1,
				items = {
					{items = {"aotearoa:"..treename.."_sapling"}, rarity = droprarity,},
					{items = {"aotearoa:"..treename.."_crown"}}
				}
			},
			waving = 1,
			sounds = zr_wood.leaves_sounds,
			selection_box = {
				type = "fixed",
				fixed = crownbox,
			},
		})
	end

	-- Anything with a special top trunk (e.g. leaf skirts)
	if skirt == "skirt" then
		local drop_skirt = nil
		-- Get the trunk if fern.
		if treetype == "fern" then
			drop_skirt = "aotearoa:"..treename.."_tree"
		else
			drop_skirt = "aotearoa:"..treename.."_skirt"
		end

		if default_loaded then
			minetest.register_node("aotearoa:"..treename.."_skirt", {
				description = treedesc.. "Top" ..sci_name,
				drawtype = "nodebox",
				tiles = {
					"aotearoa_"..treename.."_skirt_top.png",
					"aotearoa_"..treename.."_skirt_top.png",
					"aotearoa_"..treename.."_skirt.png",
				},
				node_box = {
					type = "fixed",
					fixed = {-1/3, -1/2, -1/3, 1/3, 1/2, 1/3},
				},
				selection_box = {
					type = "fixed",
					fixed = {-1/3, -1/2, -1/3, 1/3, 1/2, 1/3},
				},
				paramtype = "light",
				paramtype2 = "facedir",
				is_ground_content = false,
				groups = {
					tree = 1,
					choppy = 3,
					oddly_breakable_by_hand = 1,
					flammable = 2,
					attached_node = 1,
				},
				drop = drop_skirt,
				sounds = default.node_sound_wood_defaults(),
				-- Collapse tree when cut.
				after_destruct = function(pos,oldnode)
					local node = minetest.get_node({x=pos.x, y=pos.y + 1, z=pos.z})
					if node.name == "aotearoa:"..treename.."_tree" then
							minetest.dig_node({x=pos.x, y=pos.y + 1, z=pos.z})
							-- minetest.add_item(pos,"aotearoa:"..treename.."_tree")
					end
				end,
			})
		elseif zero_loaded then
			minetest.register_node("aotearoa:"..treename.."_skirt", {
				description = treedesc.. "Top" ..sci_name,
				drawtype = "nodebox",
				tiles = {
					"aotearoa_"..treename.."_skirt_top.png",
					"aotearoa_"..treename.."_skirt_top.png",
					"aotearoa_"..treename.."_skirt.png",
				},
				node_box = {
					type = "fixed",
					fixed = {-1/3, -1/2, -1/3, 1/3, 1/2, 1/3},
				},
				selection_box = {
					type = "fixed",
					fixed = {-1/3, -1/2, -1/3, 1/3, 1/2, 1/3},
				},
				paramtype = "light",
				paramtype2 = "facedir",
				is_ground_content = false,
				groups = {
					tree = 1,
					choppy = 3,
					oddly_breakable_by_hand = 1,
					flammable = 2,
					attached_node = 1,
				},
				drop = drop_skirt,
				sounds = zr_wood.sounds,
				-- Collapse tree when cut.
				after_destruct = function(pos,oldnode)
					local node = minetest.get_node({x=pos.x, y=pos.y + 1, z=pos.z})
					if node.name == "aotearoa:"..treename.."_tree" then
							minetest.dig_node({x=pos.x, y=pos.y + 1, z=pos.z})
							-- minetest.add_item(pos,"aotearoa:"..treename.."_tree")
					end
				end,
			})
		end
	end
end

---------------------------------------------
-- Rotten wood
if default_loaded then
	minetest.register_node("aotearoa:rotten_wood", {
		description = "Rotten Wood",
		tiles = {
			"aotearoa_rotten_wood_top.png",
			"aotearoa_rotten_wood_top.png",
			"aotearoa_rotten_wood.png",
		},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {choppy = 3, oddly_breakable_by_hand = 3, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		on_place = minetest.rotate_node,
	})
elseif zero_loaded then
	minetest.register_node("aotearoa:rotten_wood", {
		description = "Rotten Wood",
		tiles = {
			"aotearoa_rotten_wood_top.png",
			"aotearoa_rotten_wood_top.png",
			"aotearoa_rotten_wood.png",
		},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {choppy = 3, oddly_breakable_by_hand = 3, flammable = 2},
		sounds = zr_wood.sounds,
		on_place = minetest.rotate_node,
	})
end

-- Ponga fence
if default_loaded then
	minetest.register_node("aotearoa:ponga_fence", {
		description = "Ponga Fence",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-1/4, -1/2, -1/4, 1/4, 1/2, 1/4}},
			-- connect_bottom =
			connect_front = {{-1/4, -1/2, -1/2, 1/4, 1/2, -1/4}},
			connect_left = {{-1/2, -1/2, -1/4, -1/4, 1/2, 1/4}},
			connect_back = {{-1/4, -1/2, 1/4, 1/4, 1/2, 1/2}},
			connect_right = {{1/4, -1/2, -1/4, 1/2, 1/2, 1/4}},
		},
		connects_to = {
			"group:crumbly",
			"group:wood",
			"group:tree",
			"group:stone",
			"aotearoa:ponga_fence",
		},
		paramtype = "light",
		tiles = {
			"aotearoa_ponga_fence_top.png",
			"aotearoa_ponga_fence_top.png",
			"aotearoa_ponga_fence.png",
		},
		inventory_image = "aotearoa_ponga_fence.png",
		wield_image = "aotearoa_ponga_fence.png",
		groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		use_texture_alpha = "clip",
	})
end
if zero_loaded then
	minetest.register_node("aotearoa:ponga_fence", {
		description = "Ponga Fence",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-1/4, -1/2, -1/4, 1/4, 1/2, 1/4}},
			-- connect_bottom =
			connect_front = {{-1/4, -1/2, -1/2, 1/4, 1/2, -1/4}},
			connect_left = {{-1/2, -1/2, -1/4, -1/4, 1/2, 1/4}},
			connect_back = {{-1/4, -1/2, 1/4, 1/4, 1/2, 1/2}},
			connect_right = {{1/4, -1/2, -1/4, 1/2, 1/2, 1/4}},
		},
		connects_to = {
			"group:crumbly",
			"group:wood",
			"group:tree",
			"group:stone",
			"aotearoa:ponga_fence",
		},
		paramtype = "light",
		tiles = {
			"aotearoa_ponga_fence_top.png",
			"aotearoa_ponga_fence_top.png",
			"aotearoa_ponga_fence.png",
		},
		inventory_image = "aotearoa_ponga_fence.png",
		wield_image = "aotearoa_ponga_fence.png",
		groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = zr_wood.sounds,
		use_texture_alpha = "clip",
	})
end

-- Flax rope
if default_loaded then
	minetest.register_node("aotearoa:flax_rope", {
		description = "Flax Rope",
		drawtype = "signlike",
		tiles = {"aotearoa_flax_rope.png"},
		inventory_image = "aotearoa_flax_rope.png",
		wield_image = "aotearoa_flax_rope.png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		climbable = true,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
			--wall_top = = <default>
			--wall_bottom = = <default>
			--wall_side = = <default>
		},
		groups = {snappy = 3, oddly_breakable_by_hand = 3, flammable = 2},
		legacy_wallmounted = true,
		sounds = default.node_sound_leaves_defaults(),
	})
end
if zero_loaded then
	minetest.register_node("aotearoa:flax_rope", {
		description = "Flax Rope",
		drawtype = "signlike",
		tiles = {"aotearoa_flax_rope.png"},
		inventory_image = "aotearoa_flax_rope.png",
		wield_image = "aotearoa_flax_rope.png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		climbable = true,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
			--wall_top = = <default>
			--wall_bottom = = <default>
			--wall_side = = <default>
		},
		groups = {snappy = 3, oddly_breakable_by_hand = 3, flammable = 2},
		legacy_wallmounted = true,
		sounds = zr_wood.leaves_sounds,
	})
end
