-- Rain puddles slowly deepening into real (thin) water, and thin water drying up.
--
-- regional_weather's puddles (abms/puddle.lua) are a purely decorative skin on the
-- ground -- a flat nodebox in the "weather_puddle" group.  This file bridges them to
-- dynamic_liquid's shallow water so that, given enough rain, a puddle occasionally
-- fills up into an actual 1/8-deep body of water that then flows and spreads under
-- the liquid physics, and so that thin water dries up again in fair weather.
--
-- Both steps are deliberately rare and slow: a puddle "collecting" into water is
-- meant to be the exception during a long downpour, not the rule, and evaporation is
-- a fair-weather afterthought, never something that eats water out from under active
-- rain (the humidity split below keeps the two from ever running in the same place).

if not regional_weather.settings.puddles then return end

-- dynamic_liquid provides the shallow-water nodes and the wake helper.  It is only an
-- optional dependency, so bail out cleanly when it (or its shallow-water feature) is
-- absent -- the puddles simply stay decorative, exactly as before.
if not minetest.get_modpath("dynamic_liquid") then return end
if not (rawget(_G, "dynamic_liquid")
		and dynamic_liquid.config and dynamic_liquid.config.shallow_water) then
	return
end

-- Two independent off-switches (both default on).  Evaporation is the only thing in
-- this whole feature that removes water from the world, so it gets its own kill switch
-- for anyone who wants a strictly no-loss world.
local do_collect  = minetest.settings:get_bool("regional_weather_puddle_thin_water", true)
local do_evaporate = minetest.settings:get_bool("regional_weather_thin_water_evaporate", true)

-- Puddles fill to, and evaporate from, the thinnest possible depth: one 1/8 unit.
local THIN_UNITS = 1

local WATER_SOURCE = "default:water_source"

-- The set of conditions under which regional_weather considers it to be raining at a
-- spot -- copied from the "create rain puddles" ABM so a puddle only fills up where a
-- puddle could have formed in the first place.
local RAIN_CONDITIONS = {
	min_height     = regional_weather.settings.min_height,
	max_height     = regional_weather.settings.max_height,
	min_heat       = 35,
	min_humidity   = 50,
	min_biome_humidity = 26,
	daylight       = 15,
	indoors        = false,
	not_biome = {
		"cold_desert",
		"cold_desert_ocean",
		"desert",
		"desert_ocean",
		"sandstone_desert",
		"sandstone_desert_ocean",
		"tundra",
	},
}

-- Fair, drying weather.  max_humidity = 50 is the exact complement of rain's
-- min_humidity = 50, so a spot is never both "raining" (filling puddles) and "drying"
-- (evaporating) at once.  daylight keeps it under the open sky -- water in caves and
-- under cover does not evaporate -- and min_heat leaves frozen thin water to the ice
-- mods rather than boiling it off in a blizzard.
local EVAP_CONDITIONS = {
	indoors      = false,
	daylight     = 12,
	max_humidity = 50,
	min_heat     = 10,
}

-- A puddle slowly collecting into thin water.  Rare and slow on purpose: interval and
-- chance together mean a given puddle takes many minutes of continuous rain before it
-- is likely to fill.
if do_collect then
climate_api.register_abm({
	label     = "puddles collect into thin water",
	nodenames = { "group:weather_puddle" },
	interval  = 20,
	chance    = 220,
	catch_up  = false,
	conditions = RAIN_CONDITIONS,

	action = function(pos, node, env)
		if not dynamic_liquid.place_shallow then return end

		-- Only fill a puddle that is actually sitting on solid ground, so the result
		-- is supported thin water rather than a film hanging in the air (which would
		-- just fall on its first liquid tick anyway).
		local below = minetest.get_node({ x = pos.x, y = pos.y - 1, z = pos.z })
		local bdef = minetest.registered_nodes[below.name]
		if not (bdef and bdef.walkable) then return end

		-- place_shallow gives the puddle the right biome water colour, starts its flow
		-- timer, and wakes the neighbourhood so the liquid system picks it up at once.
		dynamic_liquid.place_shallow(pos, WATER_SOURCE, THIN_UNITS)
	end,
})
end

-- Thin water drying up.  Only the very thinnest film (1/8) evaporates; anything deeper
-- has somewhere to flow and should run off rather than vanish, so it is left to the
-- liquid physics.  This is the ONLY water-removing step in the feature -- gated behind
-- its own setting so a no-loss world can switch it off.
if do_evaporate then
climate_api.register_abm({
	label     = "thin water evaporates",
	nodenames = { "group:dynamic_liquid_shallow" },
	interval  = 30,
	chance    = 45,
	catch_up  = false,
	conditions = EVAP_CONDITIONS,

	action = function(pos, node, env)
		-- Only the very thinnest film (1/8) dries up; deeper puddles have somewhere to
		-- flow and are left to the liquid physics.
		local units = dynamic_liquid.shallow_units_by_name
			and dynamic_liquid.shallow_units_by_name[node.name]
		if not units or units > THIN_UNITS then return end

		-- Only dry up a STRANDED film -- an actual rain puddle sitting on its own.  A
		-- 1/8 film touching a body of water is the leading edge of that body (dynamic
		-- liquid thins every shoreline out to 1/8), and deleting it just makes the body
		-- flow straight back out to replace it -- a delete/refill loop that thrashes
		-- every coastline in dry weather.  A rain puddle has no water source beside it;
		-- a shoreline film always does, so leave those to the liquid physics.
		if minetest.find_node_near(pos, 1,
				{ "default:water_source", "default:river_water_source" }) then
			return
		end

		minetest.remove_node(pos)
		-- Let neighbouring water notice the newly opened cell (it may flow in to
		-- replace what dried, which is fine -- that just moves the drying elsewhere).
		if dynamic_liquid.wake_shallow then
			dynamic_liquid.wake_shallow(pos)
		end
	end,
})
end
