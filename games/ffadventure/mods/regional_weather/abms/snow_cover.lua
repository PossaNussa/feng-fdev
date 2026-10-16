local CHECK_DISTANCE = 5
local SNOW_STEP = 8 -- matches default:snow leveled step

local S = regional_weather.i18n

-- Backward compatibility: alias old discrete snow cover nodes to default:snow
for i = 1, 5 do
	minetest.register_alias("regional_weather:snow_cover_" .. i, "default:snow")
end

if not minetest.get_modpath("default")
or default.node_sound_snow_defaults == nil
or not regional_weather.settings.snow then
	return
end

-- Common cold-weather conditions (no daylight requirement — snow falls at night too)
local snow_conditions = {
	min_height = regional_weather.settings.min_height,
	max_height = regional_weather.settings.max_height,
	max_heat = 35,
	min_humidity = 50,
	min_biome_humidity = 26,
	not_biome = {
		"cold_desert",
		"cold_desert_ocean",
		"desert",
		"desert_ocean",
		"sandstone_desert",
		"sandstone_desert_ocean"
	},
	indoors = false
}

-- Conditions for ABM 3 specifically, which is the only destructive one: it
-- deletes flora permanently.
--
-- The other snow ABMs are correctly gated on heat alone -- snow should fall
-- during a spring cold snap. Destroying plants must not, because nothing in the
-- game puts them back until the growing season, and `living_grass`'s reseeding
-- ABM is gated on `seasons.get_warmth() > -0.35`. Gated only on heat, this ABM
-- runs in *every* season in any biome whose heat sits below 35 -- which is most
-- temperate and all boreal ground -- so flora was being stripped year-round and
-- replaced for only part of the year. A world can only lose ground that way.
--
-- -0.35 is exactly living_grass's GROWING_WARMTH, so the two are complementary:
-- plants are destroyed only in the deep-winter window when nothing regrows, and
-- never while grass is seeding.
local snow_grief_conditions = table.copy(snow_conditions)

if minetest.get_modpath("seasons") then
	-- `season_warmth` is registered as a climate_api global influence by
	-- seasons/weather.lua. max_ means "run only when the value is below this".
	snow_grief_conditions.max_season_warmth = -0.35
end

-- ABM 1: Place initial snow cover on exposed ground
climate_api.register_abm({
	label			= "create snow covers",
	nodenames	= {
		"group:soil",
		"group:leaves",
		"group:stone",
		"default:snowblock",
		"group:coverable_by_snow"
	},
	neighbors	= { "air" },
	interval	= 15,
	chance		= 25,
	catch_up	= false,

	conditions	= snow_conditions,

	pos_override = function(pos)
		return vector.add(pos, { x = 0, y = 1, z = 0 })
	end,

	action = function (pos, node, env)
		-- only override air nodes
		if node.name ~= "air" then return end
		-- do not place snow if area is not fully loaded
		if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
		minetest.set_node(pos, { name = "default:snow", param2 = SNOW_STEP })
	end
})

-- ABM 2: Stack existing snow covers higher via node level
climate_api.register_abm({
	label			= "stack snow covers higher",
	nodenames	= { "default:snow" },
	neighbors	= { "air" },
	interval	= 15,
	chance		= 35,
	catch_up	= false,

	conditions	= snow_conditions,

	action = function (pos, node, env)
		-- do not stack if area is not fully loaded
		if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
		local level = minetest.get_node_level(pos)
		level = level + SNOW_STEP
		if level >= 64 then
			minetest.swap_node(pos, { name = "default:snowblock" })
		else
			minetest.set_node_level(pos, level)
		end
	end
})

-- ABM 3: Replace flora with snow (only if snow_griefing enabled)
if regional_weather.settings.snow_griefing then
	climate_api.register_abm({
		label			= "replace flora with snow covers",
		nodenames	= {
			"group:flora",
			"group:grass",
			"group:plant",
		},
		neighbors	= { "air" },
		interval	= 25,
		chance		= 160,
		catch_up	= false,

		conditions	= snow_grief_conditions,

		action = function (pos, node, env)
			-- do not override plants unless marked as buildable_to
			local def = minetest.registered_nodes[node.name]
			if def == nil or not def.buildable_to then return end
			-- do not override plants of the frost_resistance group
			local resistance = minetest.get_item_group(node.name, "frost_resistance") or 0
			if resistance > 0 then return end
			-- do not place snow if area is not fully loaded
			if minetest.find_node_near(pos, CHECK_DISTANCE, "ignore") then return end
			minetest.set_node(pos, { name = "default:snow", param2 = SNOW_STEP })
		end
	})
end

-- ABM 4: Melt snow covers when warm.
--
-- `default:snowblock` is included, not just `default:snow`: the stack ABM above
-- (and default:snow's own on_place) convert a full 64-level snow pile into a
-- snowblock, and until this was added nothing ever melted a snowblock -- so any
-- patch deep enough to have stacked into blocks over winter was a permanent
-- terminal state that no amount of summer heat could remove. A melting snowblock
-- drops back to a nearly-full snow layer and then thaws away a step at a time.
--
-- `neighbors = {"air"}` keeps this to surface snow: weather snow is always
-- air-exposed, but it also stops snowblock used as a buried building material
-- from silently thawing from the inside.
--
-- Threshold is min_heat 36 (was 38): snow forms at max_heat 35, so 36 leaves a
-- 1-degree hysteresis band (nothing both forms and melts at once) while still
-- letting cold biomes that only just cross into summer actually shed their snow.
-- interval/chance are tuned so melt in warm weather is a touch faster than the
-- accumulation ABMs above -- otherwise snow builds faster than it can ever clear
-- and, worse, melts too slowly to see.
climate_api.register_abm({
	label			= "melt snow covers",
	nodenames	= { "default:snow", "default:snowblock" },
	neighbors	= { "air" },
	interval	= 12,
	chance		= 10,
	catch_up	= true,

	conditions	= {
		min_heat = 36
	},

	action = function (pos, node, env)
		if node.name == "default:snowblock" then
			-- Step a full block back down to a nearly-full snow layer; the
			-- default:snow branch below then thaws the rest away.
			minetest.set_node(pos, { name = "default:snow", param2 = 64 - SNOW_STEP })
			return
		end
		local level = minetest.get_node_level(pos)
		if level > SNOW_STEP then
			minetest.set_node_level(pos, level - SNOW_STEP)
		elseif regional_weather.settings.puddles then
			minetest.set_node(pos, regional_weather.get_random_puddle())
		else
			minetest.set_node(pos, { name = "air" })
		end
	end
})
