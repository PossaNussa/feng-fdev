-- seasons: a four-season system for ffadventure.
--
-- Design principle: shift the inputs that existing systems already read,
-- rather than reimplementing those systems.
--
--   * climate_api gates snowfall, snow melt, river ice and rain-vs-snow purely
--     on `heat`, so a seasonal heat offset makes all of that seasonal for free.
--   * always_greener already runs an ABM that repaints every grass node from a
--     16x16 palette, so wrapping its colour function repaints the world.
--   * tempsurvive derives player temperature from biome heat, so one wrapper
--     makes seasons a survival concern.
--
-- Every integration is optional and no-ops when its host mod is absent.

seasons = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())
seasons.modpath = modpath

local function get_bool(name, default)
	local v = minetest.settings:get_bool("seasons_" .. name)
	if v == nil then return default end
	return v
end

local function get_number(name, default)
	return tonumber(minetest.settings:get("seasons_" .. name)) or default
end

-- Settings are read once, here, and never re-read. Keys are consistently
-- prefixed with `seasons_` -- climate_api has a bug where one of its settings
-- is declared unprefixed and read prefixed, making it unreachable from the GUI.
seasons.settings = {
	enabled          = get_bool("enabled", true),
	year_length      = math.max(4, math.floor(get_number("year_length", 360))),

	heat_amplitude   = get_number("heat_amplitude", 22.0),
	tempsurvive_scale = get_number("tempsurvive_scale", 0.35),
	temperature      = get_bool("temperature", true),

	grass_color      = get_bool("grass_color", true),
	grass_dry_amount = get_number("grass_dry_amount", 38.0),
	leaves           = get_bool("leaves", true),

	weather          = get_bool("weather", true),
	farming          = get_bool("farming", true),

	announce         = get_bool("announce", true),
}

dofile(modpath .. "/clock.lua")
dofile(modpath .. "/temperature.lua")
dofile(modpath .. "/grass.lua")
dofile(modpath .. "/leaves.lua")
dofile(modpath .. "/weather.lua")
dofile(modpath .. "/farming.lua")
dofile(modpath .. "/commands.lua")

-- Deliberately no seasons.get_season() here: the day count is unreadable
-- until the server environment exists, which is after mods load.
minetest.log("action", string.format(
	"[seasons] loaded: %d-day year, %d-day seasons",
	seasons.YEAR_DAYS, seasons.SEASON_DAYS))
