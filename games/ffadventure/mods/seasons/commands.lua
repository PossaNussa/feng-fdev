-- Chat commands.
--
-- At 90 in-game days per season -- roughly 30 real hours -- /season set is not a
-- convenience, it is the only practical way to see or test this mod.

local S = seasons.settings

minetest.register_privilege("seasons", {
	description = "Can change the current season",
	give_to_singleplayer = false,
})

local ORDER = {"spring", "summer", "autumn", "winter"}

-- Day-of-year at the middle of each season, so /season set lands somewhere
-- representative rather than on a boundary where the curves are still neutral.
local function season_midpoint(name)
	local twelfths = {spring = 3.5, summer = 6.5, autumn = 9.5, winter = 0.5}
	local t = twelfths[name]
	if not t then return nil end
	return seasons.YEAR_DAYS * t / 12
end

local function fmt_date()
	if not minetest.get_modpath("calendar") or not minetest.global_exists("calendar") then
		return string.format("day %d of %d", seasons.get_day_of_year(), seasons.YEAR_DAYS)
	end
	-- Call calendar.get_date directly: calendar.get_date_string has a
	-- long-standing bug where it destructures d,m,y as y,m,d, so it prints the
	-- day where the year should be.
	-- calendar.get_date() applies the world's start-of-year offset itself, but
	-- only when called with no argument. We have to pass one (to fold in the
	-- admin offset), so add the same origin explicitly or the printed date drifts
	-- 80 days behind the season name above it.
	local total = calendar.get_current_day() + seasons.day_offset
	local d, m, y = calendar.get_date(math.floor(total), true)
	local month = calendar.month_names[m] or ("month " .. tostring(m))
	return string.format("%d %s, year %d", d, month, y)
end

local function status(name)
	local season, day_in, left = seasons.get_season()
	local lines = {
		minetest.colorize("#88ccff", "Season: " .. season) ..
			"  (" .. fmt_date() .. ")",
		string.format("  day %d of %d in this season, %d to go",
			math.floor(day_in) + 1, seasons.SEASON_DAYS, math.floor(left)),
		string.format("  warmth %+.2f    foliage %.2f",
			seasons.get_warmth(), seasons.get_foliage()),
	}

	local player = name and minetest.get_player_by_name(name)
	if player then
		local pos = player:get_pos()
		local biome = minetest.get_heat(pos)
		lines[#lines + 1] = string.format(
			"  here: biome heat %.1f, seasonal offset %+.1f, grass shift %+.1f",
			biome, seasons.get_heat_offset(pos),
			seasons.get_grass_humidity_delta() * seasons.grass_latitude_weight(biome))
		-- Latitude is what drives seasonal strength, and it is not readable from
		-- anywhere else in game, so surface it here.
		if minetest.global_exists("climate_zones_v7")
				and type(climate_zones_v7.latitude_at) == "function" then
			lines[#lines + 1] = string.format(
				"  latitude %.3f (0 = equator z%d, 1 = pole z%d)",
				climate_zones_v7.latitude_at(pos),
				climate_zones_v7.EQUATOR or 0, climate_zones_v7.POLE or 0)
		end
		if S.leaves then
			lines[#lines + 1] = string.format("  leaf stage here: %d of 31",
				seasons.get_foliage_stage(pos))
		end
	end

	return table.concat(lines, "\n")
end

minetest.register_chatcommand("season", {
	params = "[set <spring|summer|autumn|winter> | skip <days> | reset]",
	description = "Show the current season, or change it",
	privs = {},
	func = function(name, param)
		param = (param or ""):trim()

		if param == "" then
			return true, status(name)
		end

		local sub, arg = param:match("^(%S+)%s*(.*)$")
		sub = sub:lower()

		if sub ~= "set" and sub ~= "skip" and sub ~= "reset" then
			return false, "Usage: /season [set <season> | skip <days> | reset]"
		end

		if not minetest.check_player_privs(name, {seasons = true}) then
			return false, "You need the 'seasons' privilege to change the season."
		end

		if sub == "reset" then
			seasons.set_day_offset(0)
			return true, "Season offset cleared.\n" .. status(name)
		end

		if sub == "skip" then
			local days = tonumber(arg)
			if not days then
				return false, "Usage: /season skip <days>"
			end
			seasons.set_day_offset(seasons.day_offset + days)
			return true, string.format("Skipped %g days.\n%s", days, status(name))
		end

		-- set
		local want = arg:lower()
		local target = season_midpoint(want)
		if not target then
			return false, "Unknown season '" .. arg .. "'. Try: " ..
				table.concat(ORDER, ", ")
		end

		-- Shift the offset so that "now" lands at the middle of the wanted season.
		local current = seasons.get_day_of_year()
		seasons.set_day_offset((seasons.day_offset + (target - current)) % seasons.YEAR_DAYS)

		return true, status(name)
	end,
})
