-- The seasonal heat offset, and the two places it gets injected.
--
-- This is the load-bearing module. regional_weather gates snowfall
-- (max_heat = 35), snow accumulation and melt (max_heat 35 / min_heat 38, see
-- regional_weather/abms/snow_cover.lua), river ice (abms/ice.lua) and the
-- rain-vs-snow split entirely on `heat`. So shifting heat seasonally makes all
-- of that seasonal with no edits to regional_weather whatsoever.

local S = seasons.settings

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

--------------------------------------------------------------------------------
-- How strongly the season is felt at a position
--------------------------------------------------------------------------------

-- Full seasonal swing from this far poleward, and proportionally less equatorward
-- of it. Latitude 0.6 is where zone heat falls to 40, which is exactly where the
-- old biome-heat proxy below saturated -- so temperate winters still cross
-- regional_weather's max_heat = 35 snow threshold, which is the entire point of
-- the feature. Raising this weakens winter everywhere; see the README on why
-- heat_amplitude is not the knob to reach for.
local TEMPERATE_FULL = 0.6

-- Resolved once, after mods load, rather than looked up per call: get_heat_offset
-- runs from climate ABMs and tempsurvive's globalstep.
local latitude_at = nil

minetest.register_on_mods_loaded(function()
	if not S.enabled then return end
	if minetest.global_exists("climate_zones_v7")
			and type(climate_zones_v7.latitude_at) == "function" then
		latitude_at = climate_zones_v7.latitude_at
		minetest.log("action",
			"[seasons] seasonal amplitude follows climate_zones_v7 latitude")
	else
		minetest.log("action",
			"[seasons] no zone climate; seasonal amplitude falls back to biome heat")
	end
end)

--- 0 (no seasons here) .. 1 (full seasonal swing).
local function seasonal_weight(pos, h0)
	if latitude_at then
		return clamp(latitude_at(pos) / TEMPERATE_FULL, 0, 1)
	end
	-- Zone climate is not driving the world, so biome heat stands in for
	-- latitude. It is a poor proxy -- it counts altitude chill and per-zone
	-- jitter as latitude, so a tropical mountain gets an arctic winter -- but
	-- without climate_zones_v7 there is nothing better available.
	return clamp((85 - h0) / 45, 0, 1)
end

--------------------------------------------------------------------------------
-- The offset
--------------------------------------------------------------------------------

--- Seasonal heat delta at a position, in engine heat units (the 0-100 scale of
-- minetest.get_heat).
function seasons.get_heat_offset(pos)
	if not S.enabled then return 0 end

	local h0 = minetest.get_heat(pos)
	local w = seasons.get_warmth()

	-- Hot places barely swing: deserts should never see snow and rainforests
	-- have no autumn.
	local lat = seasonal_weight(pos, h0)

	local off = S.heat_amplitude * w * lat

	-- Damp the *cooling* half only, so already-frigid biomes still get a real
	-- polar summer but are never driven further into lethal cold in winter.
	if off < 0 then
		off = off * clamp(h0 / 35, 0.25, 1)
	end

	-- Caves are seasonally stable. Taper to nothing by y = -30 so there is no
	-- discontinuity at the surface.
	if pos.y < 0 then
		off = off * clamp((pos.y + 30) / 30, 0, 1)
	end

	return off
end

--------------------------------------------------------------------------------
-- Injection A: climate_api
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not S.enabled then return end
	if not minetest.get_modpath("climate_api") then return end
	if not minetest.global_exists("climate_api") then return end

	local base_get_heat = climate_api.environment.get_heat

	climate_api.environment.get_heat = function(pos)
		-- Honour /set_heat and friends: a forced value must stay exactly forced,
		-- otherwise debugging the weather silently stops working. Note the
		-- upstream misspelling -- it really is "enviroment", one 'n'.
		if climate_mod.forced_enviroment.heat ~= nil then
			return climate_mod.forced_enviroment.heat
		end
		return base_get_heat(pos) + seasons.get_heat_offset(pos)
	end

	-- Re-registering is mandatory, not belt-and-braces. climate_api's
	-- lib/influences.lua registers the "heat" influence with the *function
	-- object* climate_api.environment.get_heat, captured by value at its load
	-- time. Wrapping the environment function alone would leave every weather
	-- preset and every climate ABM reading the unshifted number.
	--
	-- The closure does a late table lookup rather than capturing our wrapper, so
	-- this composes with any further wrapper another mod might add.
	climate_api.register_influence("heat", function(pos)
		return climate_api.environment.get_heat(pos)
	end)

	minetest.log("action", "[seasons] climate_api heat influence is now seasonal")
end)

--------------------------------------------------------------------------------
-- Injection B: tempsurvive
--------------------------------------------------------------------------------

-- tempsurvive reads minetest.get_heat directly rather than going through
-- climate_api, so it needs its own wrapper.
--
-- tempsurvive.get_bio_temperature is a plain global on the tempsurvive table and
-- is looked up late by every caller -- functions.lua (the HUD and damage loop)
-- and nodes_items.lua (the thermometer) -- so this single patch reaches all of
-- them without editing the mod.
minetest.register_on_mods_loaded(function()
	if not S.enabled or not S.temperature then return end
	if not minetest.get_modpath("tempsurvive") then return end
	if not minetest.global_exists("tempsurvive") then return end
	if type(tempsurvive.get_bio_temperature) ~= "function" then
		minetest.log("warning",
			"[seasons] tempsurvive.get_bio_temperature missing; skipping temperature integration")
		return
	end

	local orig = tempsurvive.get_bio_temperature

	-- Forward extra args (e.g. tempsurvive's volcano-heat bonus) untouched;
	-- capturing only `pos` would silently drop them.
	tempsurvive.get_bio_temperature = function(pos, ...)
		local t = orig(pos, ...)
		-- Mirror tempsurvive's own geothermal early-return exactly. Below y=-20
		-- it returns a depth-only value and seasons must not touch it.
		if pos.y < -20 then return t end
		return t + seasons.get_heat_offset(pos) * S.tempsurvive_scale
	end

	minetest.log("action", "[seasons] tempsurvive body temperature is now seasonal")
end)
