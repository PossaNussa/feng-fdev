--=======--
-- Setup --
--=======--

-- Translation wrapper for descriptive strings
local S = minetest.get_translator(minetest.get_current_modname())

-- Explicit local references to globals we use
local core = core

-- Locals we'll use a lot
local get_gametime = core.get_gametime
local get_day_count = core.get_day_count
local floor = math.floor


--=======================--
-- Configuration options --
--=======================--

--- Table for the mod. This is the only non-local variable. Defines
-- settings that can be used to influence seasons. TODO: That
seasons_clock = {
    __version__ = "0.0-1",
    -- the default clock to use with the simple API. Will be created using
    -- default settings if it is needed and doesn't yet exist. Call
    -- `set_default` to override it.
    _default_clock=nil,
    --- The adjustment when converting seconds into days when a clock sets
    -- use_seconds to true. 1200 is the number of seconds in a
    -- default-length day at server time speed 72 (the default).
    seconds_adjust=1200,
}


--=========================--
-- Default clock functions --
--=========================--

-- These functions instantiate if necessary and then make use of a default
-- seasons clock. If you want to customize things, you can create your own
-- clock and either use it directly or call `set_default` to use it as the
-- new default clock.

--- Gets the default season clock, creating a new one with default
-- parameters if it doesn't yet exist.
--
-- @treturn table A season clock table (complete with meta-table for the
--     current default clock. If `set_default` has been called, returns the 
--     clock that was used in that call.
seasons_clock.get_default = function()
    local result = seasons_clock._default_clock
    if result == nil then
        -- Table lookup, not an upvalue: `new_clock` is only localised further
        -- down the file, so an upvalue would resolve to a nil global here.
        result = seasons_clock.new_clock()
        seasons_clock._default_clock = result
    end
    return result
end

--- Overrides the default seasons clock so that the simple API functions
-- that work without a specific clock will use this one.
--
-- @tparam table clock The season clock you want to use. Should have been
--     created by `new_clock` so that it has the appropriate meta-table.
seasons_clock.set_default = function(clock) 
    seasons_clock._default_clock = clock
end
local set_default = seasons_clock.set_default


--- Returns the current season (name, days-in-season, and
-- days-until-last-day) for the default clock (see `get_default`). Same
-- parameters and return as the `season` method of a season clock.
seasons_clock.season = function(...)
    return seasons_clock.get_default():season(...)
end


--=========================--
-- Season Clock Definition --
--=========================--

-- Season clocks are tables that have a few data fields plus a bunch of
-- methods. Use `new_clock` to turn a table with just the data fields into
-- a full clock table w/ methods.

--- Takes a base clock definition table, fills in defaults if it's missing
-- any key info, and adds methods to turn it into a working seasons clock
-- table. The table you provide is modified, not copied.
--
-- @tparam table base The initial table w/ any custom settings you want to
--     provide. If it contains existing entries for any of the season clock
--     methods these will NOT be overridden, so you can pre-set custom
--     methods to override behavior if you wish. If this is nil, a new
--     empty table will be created as the base. The following keys are
--     relevant:
--
--     + start_day - A number; sets the starting day of the seasons,
--         specified in days-since-world-creation (see
--         `core.get_day_count`). By default this is 0. Usually doesn't
--         matter much since seasons cycle forever (or at least until
--         numbers start to get wonky).
--     + use_seconds - A boolean that causes the clock to use
--         seconds-since-world-creation everywhere it would normally use
--         days-since-world-creation. If set to true (default is false)
--         then 'start_day' and all day-based season durations are
--         interpreted as seconds instead of days, but they get multiplied
--         by `seasons_clock.seconds_adjust`, which is normally the number
--         of seconds in a default day at the default server speed of 72.
--         Because server time speed settings can be changed and time of
--         day can be set, the number of days is more variable than the
--         number of seconds. In particular, methods to freeze the
--         day/night cycle may result in days not passing. If you want
--         seasons to persist regardless rather than pause in this
--         scenario, you'll have to use seconds.
--     + start_second - When 'use_seconds' is true we set the start second
--         as the start day times the seconds adjust value. If you want to
--         set it precisely yourself (e.g., based on `get_gametime`) you
--         can set this value and 'start_day' will be ignored.
--     + seasons - This is an array where each entry is a sub-array holding
--         two values: a season name and an end day-within-cycle. The same
--         season name can be listed multiple times. Each entry will be
--         current from the end of the last season until the end of its
--         listed end day. The end days MUST be monotonically increasing.
--         The first day of a new cycle is day 1, and that will begin when
--         the last day of the previous cycle ends. Time is only tracked in
--         whole days.
--
--         So for example, if we use the following seasons table:
--
--         ```lua
--         {
--             { "spring", 91.25 },
--             { "summer", 182.5 },
--             { "fall", 273.75 },
--             { "winter", 365 },
--         }
--         ```
--
--         On days 1-91 (all 91 of them), the season will be "spring", then
--         on day 92 it will be "summer" until day 183 (91 days), when it
--         becomes "fall." "fall" lasts until day 273 (91 days), and on day
--         274 it becomes "winter," which lasts until the end of day 365
--         (92 days). When we reach what would have been day 366, we
--         instead start over at day 1 of a new cycle in "spring."
--
--         We could have used 91, 182, and 273 without the decimal parts to
--         achieve the same effect.
--
--         A table like this:
--
--         ```lua
--         {
--             { "wet", 60 },
--             { "dry", 120 },
--             { "wet", 180 }
--         }
--         ```
--
--         Would produce just two seasons "wet" and "dry", with "wet"
--         starting off the year and also ending the year. There will be a
--         total of 60 + 60 = 120 wet days and the middle 60 days of the
--         year starting from day 61 will be "dry". (There's no need for a
--         "year" to be 365 days; the last end-day in the table defines the
--         end of the year.)
--
-- @treturn table Returns the same table you gave it after modifications
--     have been made, or the new table it created from scratch.
seasons_clock.new_clock = function(base)
    if base == nil then
        base = {}
    end

    -- First we adjust/add default state variable values

    -- Start day is in days since world creation.
    if base.start_day == nil then
        base.start_day = 0
    end
    -- Use seconds instead of days since world creation. Changes meaning of
    -- all day durations into seconds.
    if base.use_seconds == nil then
        base.use_seconds = false
    end
    if base.start_second == nil and base.use_seconds then
        base.start_second = base.start_day * seasons_clock.seconds_adjust
    end
    -- Without a seasons table, `season` would index a nil value. Default to a
    -- 360-day year of four equal seasons (matches the `calendar` mod's
    -- 12 months x 30 days).
    if base.seasons == nil then
        base.seasons = {
            {"winter",  60},  -- Jan, Feb
            {"spring", 150},  -- Mar, Apr, May
            {"summer", 240},  -- Jun, Jul, Aug
            {"autumn", 330},  -- Sep, Oct, Nov
            {"winter", 360},  -- Dec
        }
    end

    -- Finally we add all the necessary methods

    -- This method returns the linear time value in days or
    -- adjusted-seconds relative to the starting time.
    -- Table lookup, not an upvalue: `_methods` is only localised at the very
    -- bottom of the file, so an upvalue would be nil when this runs.
    for name, method in pairs(seasons_clock._methods) do
        -- Skip if one is pre-provided to allow overrides
        if base[name] == nil then
            base[name] = method
        end
    end

    -- Finally we return the same table we got (or the new one we created
    -- by default)
    return base
end
local new_clock = seasons_clock.new_clock


--- Defines all of the standard season clock methods to be grafted onto
-- objects produced using `new_clock`.
seasons_clock._methods = {
    --- Season clock method that returns the linear time elapsed since the
    -- start of this season clock (set using the 'start_day' and/or
    -- 'start_second' fields). If 'use_seconds' is true, we return the current
    -- seconds-since-world-creation minus 'start_second', divided by the
    -- `seasons_clock.seconds_adjust` value to convert to "days." If
    -- 'use_seconds' is false, use just subtract 'start_day' from
    -- server-days-elapsed. If the server time speed is changed or commands
    -- are used that alter days, the actual number of days elapsed will be
    -- used when 'use_seconds' is false, and an estimate based on the
    -- default time speed is used when 'use_seconds' is true. This means
    -- that when 'use_seconds' is true, the seasons cycle predictably based
    -- on wall-clock time no matter how many in-game days pass or don't. On
    -- the other hand, when 'use_seconds' is false, seasons cycle
    -- predictably based on in-game days (and pausing in-game days pauses
    -- the seasons) but have no relation to wall-clock time.
    --
    -- @tparam table self A season clock table.
    days_since_start = function(self)
        if self.use_seconds then
            return (
                get_gametime() - self.start_second
            ) / seasons_clock.seconds_adjust
        else
            return get_day_count() - self.start_day
        end
    end,

    --- Returns the current season name as a string. Uses the current
    -- server time by default, but if given a particular day will return
    -- the season on that day instead. The day value is in
    -- days-since-server-start (or approximate-days-since-server-start if
    -- 'use_seconds' is set; see `days_since_start`). Set 'relative' to
    -- true to treat the specific day as relative days from the current
    -- time.
    --
    -- @tparam table self The season clock to query.
    -- @tparam number day (optional) A specific day to query about.
    -- @tparam boolean relative (optional) Whether the specific day is an
    --     absolute-day-since-world-creation (false; the default) or a
    --     relative-days-from-now (true). Has no effect if 'day' is nil.
    --
    -- @treturn multiple Three return values: first the name of the current
    --     season (a string), next the day number within the current
    --     season, starting with day 1, and finally the number of days
    --     remaining before the end of the current season (0 on the last
    --     day of the season).
    season = function(self, day, relative)
        local when
        if day ~= nil then
            if relative then
                when = self:days_since_start() + day
            else
                when = day
            end
        else
            when = self:days_since_start()
        end

        -- Get seasons; wrap into year
        local seasons = self.seasons
        local last = seasons[#seasons]
        local year_days = last[2]
        when = when % year_days

        -- Linear search. The original also had a binary-search branch for
        -- tables of 10+ seasons, but it assigned undeclared globals and had an
        -- off-by-one that could skip the correct entry. Season tables are tiny
        -- (4-5 entries in practice), so a linear scan is both correct and
        -- faster than the branch it replaces.
        local prev_end = 0
        for _, sdef in ipairs(seasons) do
            local this_end = sdef[2]
            if when < this_end then
                return sdef[1], when - prev_end, this_end - when
            end
            prev_end = this_end
        end

        -- `when` was wrapped into [0, year_days) above, so the loop always
        -- returns. Fall back to the last season rather than returning nil if a
        -- caller supplies a non-monotonic seasons table.
        local last_def = seasons[#seasons]
        return last_def[1], 0, 0
    end,

    -- TODO: Sun energy-based seasons
}
local _methods = seasons_clock._methods
