-- Register liquid mud source
minetest.register_node("default:liquid_mud_source", {
	description = "Liquid Mud Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_mud_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_mud_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:liquid_mud_flowing",
	liquid_alternative_source = "default:liquid_mud_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, drowning = 1},
})

-- Register liquid mud flowing
minetest.register_node("default:liquid_mud_flowing", {
	description = "Flowing Liquid Mud",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"mud.png"},
	special_tiles = {
		{
			name = "default_mud_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "default_mud_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
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
	liquid_alternative_flowing = "default:liquid_mud_flowing",
	liquid_alternative_source = "default:liquid_mud_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, not_in_creative_inventory = 1, drowning = 1},
})
-- Register liquid mud source
minetest.register_node("default:dirty_water_source", {
	description = "Dirty Water Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{
			name = "default_dirty_water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "default_dirty_water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:dirty_water_flowing",
	liquid_alternative_source = "default:dirty_water_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, drowning = 1},
})

-- Register liquid mud flowing
minetest.register_node("default:dirty_water_flowing", {
	description = "Flowing Dirty Water",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_water.png"},
	special_tiles = {
		{
			name = "default_dirty_water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
		{
			name = "default_dirty_water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.5,
			},
		},
	},
	use_texture_alpha = "blend",
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
	liquid_alternative_flowing = "default:dirty_water_flowing",
	liquid_alternative_source = "default:dirty_water_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 192, r = 128, g = 64, b = 0},
	groups = {liquid = 3, not_in_creative_inventory = 1, drowning = 1},
})
-- Water surrounded by 3 or more mud nodes becomes liquid mud
minetest.register_abm({
	nodenames = {"default:water_source"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local surrounding = minetest.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
			{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
			{"default:mud"}
		)
		if #surrounding >= 9 then
			minetest.set_node(pos, {name = "default:liquid_mud_source"})
		end
	end,
})

-- Liquid mud turns into dirt when near lava
minetest.register_abm({
	nodenames = {"default:liquid_mud_source", "default:liquid_mud_flowing"},
	neighbors = {"default:lava_source", "default:lava_flowing"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		minetest.set_node(pos, {name = "default:dirt"})
	end,
})

-- Player heals when standing on liquid mud that is heated from below.
-- Ticks on a fixed timer instead of every server step: the old version ignored dtime
-- and healed +1 per step, so the heal rate silently rode the server's tick rate.
local mud_heal_timer = 0
local MUD_HEAL_INTERVAL = 0.1   -- seconds per +1 HP (tunable; ~10 HP/s, framerate-independent)
-- Volcano ambient-heat threshold (deg) at which liquid mud counts as a hot spring
-- even without a lava node directly below it. Matches the warm apron around an
-- active cone rather than the whole heat halo. See tempsurvive.get_volcano_heat_at.
local MUD_SPRING_VOLCANO_HEAT = 8
minetest.register_globalstep(function(dtime)
	mud_heal_timer = mud_heal_timer + dtime
	if mud_heal_timer < MUD_HEAL_INTERVAL then return end
	local heals = math.floor(mud_heal_timer / MUD_HEAL_INTERVAL)
	mud_heal_timer = mud_heal_timer - heals * MUD_HEAL_INTERVAL
	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		local node_at_feet = minetest.get_node({x=pos.x, y=pos.y-0.5, z=pos.z}).name
		if node_at_feet == "default:liquid_mud_source" then
			-- The mud heals when it is a *hot* mud spring. That means either lava
			-- directly heating it from below (the original hand-built spring), or
			-- the ambient heat of a nearby volcano warming a natural mud pool --
			-- so volcanic mud springs work without a hand-placed lava node.
			local node_two_below = minetest.get_node({x=pos.x, y=pos.y-2.5, z=pos.z}).name
			local heated = node_two_below == "default:lava_source"
			if not heated and minetest.global_exists("tempsurvive")
					and tempsurvive.get_volcano_heat_at then
				heated = tempsurvive.get_volcano_heat_at(pos) >= MUD_SPRING_VOLCANO_HEAT
			end
			if heated then
				player:set_hp(player:get_hp() + heals)
			end
		end
	end
end)

minetest.register_decoration({
    name = "default:mud_spring",
    deco_type = "schematic",
	place_on = {"default:dirt_with_rainforest_litter"},
    sidelen = 16,

		fill_ratio = 1,
	biomes = {"rainforest", "rainforest_swamp", "rainforest_ocean", "rainforest_under"},
    y_max = 31000,
    y_min = 1,  -- Since your mud spring goes 4 nodes into the ground
	schematic = minetest.get_modpath("default").."/schematics/mudsprings.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
})