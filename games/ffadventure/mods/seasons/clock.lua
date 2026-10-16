-- Season model: day-of-year, the season name, and the two continuous curves
-- that every other module reads.
--
-- Nothing downstream should branch on the season *string* if it can help it.
-- Warmth and foliage are smooth floats precisely so that seasons feel like a
-- gradual drift rather than four hard jumps.

local S = seasons.settings

local YEAR_DAYS = S.year_length
local SEASON_DAYS = math.floor(YEAR_DAYS / 4)

seasons.YEAR_DAYS = YEAR_DAYS
seasons.SEASON_DAYS = SEASON_DAYS

local storage = minetest.get_mod_storage()

-- Admin offset in (fractional) days, persisted. This is how /season set works.
-- Pattern borrowed from astral.set_astral_day_offset().
seasons.day_offset = tonumber(storage:get_string("day_offset")) or 0

--------------------------------------------------------------------------------
-- Season table
--------------------------------------------------------------------------------

-- Astronomical seasons: each one begins at its solstice or equinox, on the
-- 21st. Winter starts in December and so wraps the year boundary;
-- seasons_clock supports a repeated name for exactly this case, which is why
-- winter appears twice.
--
-- Each entry's number is the day-of-year on which the *next* season begins.
-- The calendar is 12 months x 30 days (matching the `calendar` mod), and
-- boundaries scale with year_length so a shortened year still lines up.
local function doy(month, day)
	return YEAR_DAYS * ((month - 1) * 30 + (day - 1)) / 360
end

seasons.clock = seasons_clock.new_clock({
	-- Follow in-game days rather than wall-clock seconds, so /time and
	-- time_speed changes move the seasons too.
	use_seconds = false,
	seasons = {
		{"winter", doy(3, 21)},   -- Jan 1  - Mar 20
		{"spring", doy(6, 21)},   -- Mar 21 - Jun 20
		{"summer", doy(9, 21)},   -- Jun 21 - Sep 20
		{"autumn", doy(12, 21)},  -- Sep 21 - Dec 20
		{"winter", YEAR_DAYS},    -- Dec 21 - year end
	},
})

-- Let anything else that queries seasons_clock get our answers.
seasons_clock.set_default(seasons.clock)

-- Day-of-year that a new world starts on, i.e. what day 0 of the world maps to.
--
-- A world used to open on 1 January: deep winter, foliage at 1.00, the full
-- seasonal cold penalty and no tall grass to forage. Start at the vernal
-- equinox instead, which is exactly the winter->spring boundary in the table
-- above, so day one is the first day of spring.
--
-- The calendar mod owns the world's date, so take the offset from there when it
-- is installed (converting from its fixed 360-day year into ours) and fall back
-- to our own boundary when it is not. Either way the printed date and the
-- season name agree.
local function start_day_of_year()
	if minetest.global_exists("calendar") and calendar.START_DAY_OF_YEAR
			and calendar.YEAR_DAYS and calendar.YEAR_DAYS > 0 then
		return YEAR_DAYS * calendar.START_DAY_OF_YEAR / calendar.YEAR_DAYS
	end
	return doy(3, 21)
end

seasons.START_DAY_OF_YEAR = start_day_of_year()

-- Keep the default-clock (no-argument) API honest. seasons.clock was built with
-- start_day defaulting to 0, so seasons_clock.season() called WITHOUT a day
-- counts from world day 0 (1 January) and reports a season up to
-- START_DAY_OF_YEAR (~80) days out of step with the printed calendar date. The
-- primary path -- seasons.get_season(), which passes an explicit day-of-year --
-- is unaffected either way (season() uses the argument, not start_day), but
-- set_default() publishes this clock for other mods to query bare, so anchor it
-- to the calendar's day-of-year. days_since_start() = day_count - start_day, so
-- a negative start_day of -START_DAY_OF_YEAR yields day_count + START_DAY_OF_YEAR,
-- i.e. the calendar day-of-year. Read live from self.start_day, so setting it
-- after new_clock() takes effect immediately.
seasons.clock.start_day = -seasons.START_DAY_OF_YEAR

--------------------------------------------------------------------------------
-- Time
--------------------------------------------------------------------------------

--- Day of year as a float in [0, YEAR_DAYS).
-- Fractional so the curves drift smoothly through the day instead of stepping
-- at midnight.
function seasons.get_day_of_year()
	-- Both engine calls return nil until the server environment exists
	-- (mods load before it is created), so guard for load-time callers.
	local t = (minetest.get_day_count() or 0) + (minetest.get_timeofday() or 0)
		+ seasons.START_DAY_OF_YEAR + seasons.day_offset
	return t % YEAR_DAYS
end

--- Current season name, day within the season, and days remaining.
function seasons.get_season()
	return seasons.clock:season(seasons.get_day_of_year())
end

function seasons.get_days_left()
	local _, _, left = seasons.get_season()
	return left
end

function seasons.get_day_offset()
	return seasons.day_offset
end

function seasons.set_day_offset(n)
	seasons.day_offset = n % YEAR_DAYS
	storage:set_string("day_offset", tostring(seasons.day_offset))
	seasons.refresh()
end

--------------------------------------------------------------------------------
-- Driver curves
--------------------------------------------------------------------------------

--- Warmth: -1 at the coldest point of the year, +1 at the hottest.
--
-- A cosine offset by 1/24 of a year, which puts the minimum in mid-January and
-- the maximum in mid-July rather than at the solstices. That lag is real --
-- the coldest part of winter trails the shortest day by several weeks -- and it
-- puts the extremes near the middle of the astronomical seasons above rather
-- than on their solstice boundaries.
function seasons.get_warmth()
	if not S.enabled then return 0 end
	local doy = seasons.get_day_of_year()
	return -math.cos(2 * math.pi * (doy - YEAR_DAYS / 24) / YEAR_DAYS)
end

-- Foliage: 0 = full green, 1 = fully brown.
--
-- Deliberately NOT the warmth curve. Real autumn colour peaks in October while
-- the temperature curve bottoms out in January, so driving leaves off warmth
-- would put peak brown in midwinter. Explicit keyframes are also far easier to
-- tune by eye than a phase-shifted cosine. Positions are in twelfths of a year
-- so they survive a change of year_length.
local FOLIAGE_KEYS = {
	{0 / 12,  1.00},  -- Jan 1    dead
	{2 / 12,  0.85},  -- Mar 1    still bare, starting to stir
	{3.5 / 12, 0.00}, -- Apr 15   full green-up
	{8 / 12,  0.00},  -- Sep 1    end of summer, still green
	{10 / 12, 0.60},  -- Nov 1    turning
	{11 / 12, 1.00},  -- Dec 1    bare
	{12 / 12, 1.00},  -- wrap
}

function seasons.get_foliage()
	if not S.enabled then return 0 end
	local f = seasons.get_day_of_year() / YEAR_DAYS
	for i = 1, #FOLIAGE_KEYS - 1 do
		local a, b = FOLIAGE_KEYS[i], FOLIAGE_KEYS[i + 1]
		if f >= a[1] and f <= b[1] then
			local span = b[1] - a[1]
			if span <= 0 then return a[2] end
			local t = (f - a[1]) / span
			return a[2] + (b[2] - a[2]) * t
		end
	end
	return FOLIAGE_KEYS[#FOLIAGE_KEYS][2]
end

--------------------------------------------------------------------------------
-- Change notification and mapgen publication
--------------------------------------------------------------------------------

seasons.registered_on_season_change = {}

function seasons.register_on_season_change(func)
	table.insert(seasons.registered_on_season_change, func)
end

local last_season = nil
local last_grass_delta = nil

--- Recompute cached state, fire callbacks, and republish to the mapgen env.
-- Safe to call at any time; /season commands call it directly.
function seasons.refresh()
	local now = seasons.get_season()

	-- The mapgen Lua environment is isolated and cannot see this mod's globals,
	-- so always_greener's mapcolors.lua reads the grass bias over IPC instead.
	-- Publish scalars rather than a table: IPC (de)serialises on every access.
	local delta = seasons.get_grass_humidity_delta()
	if delta ~= last_grass_delta then
		core.ipc_set("seasons:grass_hum_delta", delta)
		last_grass_delta = delta
	end
	core.ipc_set("seasons:season", now)

	if now ~= last_season then
		local old = last_season
		last_season = now
		if old ~= nil then
			for _, f in ipairs(seasons.registered_on_season_change) do
				f(now, old)
			end
			if S.announce then
				minetest.chat_send_all(minetest.colorize("#88ccff",
					"The season turns to " .. now .. "."))
			end
			minetest.log("action", "[seasons] season changed: " .. old .. " -> " .. now)
		end
	end
end

-- One throttled globalstep. Season boundaries move at ~20 real minutes per
-- in-game day, so there is nothing to gain from checking more often than this.
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 10 then return end
	timer = 0
	seasons.refresh()
end)

-- Publish once on the first server step. This cannot run earlier: mods (and
-- on_mods_loaded) run before the server environment exists, and until then
-- get_day_count()/get_timeofday() return nil, so any season computed at load
-- time would be wrong. The first refresh() sets last_season from nil, which
-- never announces, and pushes the initial IPC values; until it runs the
-- mapgen env falls back to a neutral grass bias.
minetest.after(0, seasons.refresh)
