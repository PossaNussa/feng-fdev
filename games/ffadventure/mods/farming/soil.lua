
local S = farming.translate

-- How long wet soil stays wet after water is no longer nearby (seconds).
local WET_TIMER_MIN = 300   -- 5 min
local WET_TIMER_MAX = 600   -- 10 min

-- Water/puddle search radius (Chebyshev, so diagonals included).
local WATER_RADIUS = 4

local function has_water_nearby(pos)
	return minetest.find_node_near(pos, WATER_RADIUS, {"group:water", "group:weather_puddle"})
end

-- Called when wet soil's timer fires: check if water still present,
-- either reset the timer (stay wet) or dry out.
local function wet_soil_timer(pos, elapsed)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	if not def or not def.soil or not def.soil.dry then return false end

	if has_water_nearby(pos) then
		-- Water still present: reset timer and stay wet.
		minetest.get_node_timer(pos):start(math.random(WET_TIMER_MIN, WET_TIMER_MAX))
		return false
	end

	-- Unloaded blocks nearby: could be hiding water. Retry soon.
	if minetest.find_node_near(pos, WATER_RADIUS, {"ignore"}) then
		minetest.get_node_timer(pos):start(math.random(60, 120))
		return false
	end

	-- No water: dry out.
	minetest.set_node(pos, {name = def.soil.dry})
	return false
end

local function wet_soil_construct(pos)
	minetest.get_node_timer(pos):start(math.random(WET_TIMER_MIN, WET_TIMER_MAX))
end


-- add soil types to existing dirt blocks
minetest.override_item("default:dirt", {
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_dry_grass", {
	soil = {
		base = "default:dirt_with_dry_grass",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

minetest.override_item("default:dirt_with_rainforest_litter", {
	soil = {
		base = "default:dirt_with_rainforest_litter",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

if minetest.registered_nodes["default:dirt_with_coniferous_litter"] then

	minetest.override_item("default:dirt_with_coniferous_litter", {
		soil = {
			base = "default:dirt_with_coniferous_litter",
			dry = "farming:soil",
			wet = "farming:soil_wet"
		}
	})
end


-- savanna soil
local dry_soil = "farming:soil"

if minetest.registered_nodes["default:dry_dirt"] then

	minetest.override_item("default:dry_dirt", {
		soil = {
			base = "default:dry_dirt",
			dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	minetest.override_item("default:dry_dirt_with_dry_grass", {
		soil = {
			base = "default:dry_dirt_with_dry_grass",
			dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	minetest.register_node("farming:dry_soil", {
		description = S("Savanna Soil"),
		tiles = {
			"default_dry_dirt.png^farming_soil.png",
			"default_dry_dirt.png"
		},
		drop = "default:dry_dirt",
		groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "default:dry_dirt",
			dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	minetest.register_node("farming:dry_soil_wet", {
		description = S("Wet Savanna Soil"),
		tiles = {
			"default_dry_dirt.png^farming_soil_wet.png",
			"default_dry_dirt.png^farming_soil_wet_side.png"
		},
		drop = "default:dry_dirt",
		groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, field = 1},
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "default:dry_dirt",
			dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		},
		on_construct = wet_soil_construct,
		on_timer = wet_soil_timer,
	})

	dry_soil = "farming:dry_soil"
end


-- normal soil
minetest.register_node("farming:soil", {
	description = S("Soil"),
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

-- wet soil
minetest.register_node("farming:soil_wet", {
	description = S("Wet Soil"),
	tiles = {
		"default_dirt.png^farming_soil_wet.png",
		"default_dirt.png^farming_soil_wet_side.png"
	},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, field = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet"
	},
	on_construct = wet_soil_construct,
	on_timer = wet_soil_timer,
})


-- sand is not soil, change existing sand-soil to use dry soil
minetest.register_alias("farming:desert_sand_soil", dry_soil)
minetest.register_alias("farming:desert_sand_soil_wet", dry_soil .. "_wet")


-- LBM: kick off timers on wet soil that already exists in the world
-- (placed before this system was added, or loaded from disk with no timer).
minetest.register_lbm({
	name = "farming:start_wet_soil_timer",
	nodenames = {"farming:soil_wet", "farming:dry_soil_wet"},
	run_at_every_load = false,
	action = function(pos, node)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(math.random(WET_TIMER_MIN, WET_TIMER_MAX))
		end
	end,
})


-- ABM: suck up nearby water/puddles → wet soil; revert idle dry soil → base dirt.
-- Wet-to-dry transition is handled by the node timer above, not here.
minetest.register_abm({
	label = "Soil changes",
	nodenames = {"group:field"},
	interval = 12,
	chance = 3,
	catch_up = false,

	action = function(pos, node)
		local ndef = minetest.registered_nodes[node.name]
		if not ndef or not ndef.soil or not ndef.soil.wet
		or not ndef.soil.base or not ndef.soil.dry then return end

		-- check what's directly above
		local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		local nn = minetest.get_node_or_nil(above_pos)
		if not nn then return end

		-- solid non-plant above → soil has been buried, revert to base dirt
		if minetest.registered_nodes[nn.name]
		and minetest.registered_nodes[nn.name].walkable
		and minetest.get_item_group(nn.name, "plant") == 0
		and minetest.get_item_group(nn.name, "growing") == 0 then
			minetest.set_node(pos, {name = ndef.soil.base})
			return
		end

		local wet_lvl = minetest.get_item_group(node.name, "wet")

		-- water or puddle within 4 blocks (including diagonals)
		if has_water_nearby(pos) then
			if wet_lvl == 0 then
				-- on_construct of soil_wet will start the drying timer
				minetest.set_node(pos, {name = ndef.soil.wet})
			end
			return
		end

		-- no water nearby: idle dry soil with nothing planted → revert to base
		if wet_lvl == 0
		and minetest.get_item_group(nn.name, "plant") == 0
		and minetest.get_item_group(nn.name, "seed") == 0
		and minetest.get_item_group(nn.name, "growing") == 0 then
			if not minetest.find_node_near(pos, WATER_RADIUS, {"ignore"}) then
				minetest.set_node(pos, {name = ndef.soil.base})
			end
		end
		-- wet soil → dry: handled by the node timer, not here
	end
})
