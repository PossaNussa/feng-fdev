-- What a villager should be doing right now.
--
-- Pure decision-making: this module never moves anything. It answers "what is
-- this villager's current goal" from the clock, the weather, the alarm bus and
-- the villager's role, and the brain carries it out.
--
-- Priority runs top-down and the first match wins:
--
--   1. danger   a hostile is close, or the village is on alert
--   2. weather  it is raining/snowing/hailing and we are not under a roof
--   3. sleep    it is night
--   4. work     it is working hours and we have a workstation
--   5. leisure  everything else -- loiter near home, the well, the square
--
-- Every villager gets a small personal offset on the hour boundaries so a
-- village does not empty and refill like a shift change at a factory.

local util = village_life.util
local home = village_life.home
local threats = village_life.threats

local schedule = {}
village_life.schedule = schedule

--------------------------------------------------------------------------------
-- Weather
--------------------------------------------------------------------------------

-- climate_api computes weather per player, not per position: get_weather_presets
-- takes a player object and there is no positional equivalent. That is not a
-- limitation here, because a villager is only ever simulated within a player's
-- active block range, so "the weather the nearest player is standing in" is the
-- weather at the villager to within a few dozen nodes.
local SHELTER_WEATHER = {
	["regional_weather:rain"]       = true,
	["regional_weather:rain_heavy"] = true,
	["regional_weather:snow"]       = true,
	["regional_weather:snow_heavy"] = true,
	["regional_weather:hail"]       = true,
	["regional_weather:storm"]      = true,
	["regional_weather:sandstorm"]  = true,
}

-- Mild weather that villagers grumble about but keep working through. Only the
-- heavy variants clear the streets.
local MILD_WEATHER = {
	["regional_weather:rain"] = true,
	["regional_weather:snow"] = true,
}

function schedule.register_shelter_weather(name, mild)
	SHELTER_WEATHER[name] = true
	if mild then MILD_WEATHER[name] = true end
end

local weather_cache = {by_player = {}, at = -1}

-- Drop the cached answer. Only needed by tests and by anything that changes
-- the weather programmatically and wants the villagers to notice immediately.
function schedule.flush_weather_cache()
	weather_cache.at = -1
end

local function severity_of(presets)
	local severity
	for _, name in ipairs(presets or {}) do
		if SHELTER_WEATHER[name] then
			if MILD_WEATHER[name] then
				severity = severity or "mild"
			else
				return "severe"
			end
		end
	end
	return severity
end

-- Per-player severity, recomputed at most once a second so that a hundred and
-- fifty villagers asking the same question cost one pass.
local function weather_by_player()
	local now = util.now()
	if now - weather_cache.at < 1 then return weather_cache.by_player end

	local out = {}
	if minetest.global_exists("climate_mod") and climate_mod.current_weather then
		for pname, presets in pairs(climate_mod.current_weather) do
			out[pname] = severity_of(presets)
		end
	end
	weather_cache.by_player = out
	weather_cache.at = now
	return out
end

-- Returns nil, "mild" or "severe" for a position.
--
-- Taken from the nearest player rather than from "is it raining anywhere",
-- which would put a village in the desert indoors because someone is standing
-- in a blizzard a thousand nodes away.
function schedule.weather_severity(pos)
	local by_player = weather_by_player()

	if pos then
		local best, best_d2
		for _, player in ipairs(minetest.get_connected_players()) do
			local ppos = player:get_pos()
			if ppos then
				local d2 = util.dist2(ppos, pos)
				if not best_d2 or d2 < best_d2 then
					best, best_d2 = player:get_player_name(), d2
				end
			end
		end
		if best then return by_player[best] end
	end

	-- No position, or nobody connected: fall back to the worst weather any
	-- player has. Villagers only step near players, so in practice this is
	-- only reached from tests and from the /village_life command.
	local severity
	for _, s in pairs(by_player) do
		if s == "severe" then return "severe" end
		severity = severity or s
	end
	return severity
end

--------------------------------------------------------------------------------
-- Personal timing
--------------------------------------------------------------------------------

-- A stable offset in hours, +/- 45 minutes, derived from the villager's
-- identity so it survives restarts and differs between neighbours. Computed
-- once by home.resolve; this is only the fallback for a caller that passed a
-- hand-built record.
local function offset(r)
	return (r and r.hour_offset) or 0
end

-- How close a hostile has to be before an ordinary villager reacts to it, and
-- how close the alarm's reported position has to be before they take a
-- neighbour's word for it.
local SEE_THREAT = 16
local HEAR_ALARM = 28

local RISE  = 6.0
local WORK  = 8.0
local LUNCH = 12.5
local BACK  = 13.5
local CLOSE = 18.0
local BED   = 21.0

-- Children keep shorter hours than their parents and elders turn in early.
local function hours_for(role, off)
	if role == "child" then
		return RISE + 1.5 + off, WORK + 2 + off, CLOSE - 2 + off, BED - 2 + off
	elseif role == "elder" then
		return RISE - 0.5 + off, WORK + off, CLOSE - 1.5 + off, BED - 1.5 + off
	elseif role == "guard" then
		-- Guards are on duty around the clock; the schedule only decides when
		-- they change over between the day and night watch.
		return 0, 0, 24, 24
	end
	return RISE + off, WORK + off, CLOSE + off, BED + off
end

--------------------------------------------------------------------------------
-- The decision
--------------------------------------------------------------------------------

-- Goal shape:
--   {kind = "...", pos = <target>, speed = "walk"|"run", indoor = bool,
--    interior = <mg_villages path or nil>, face = <pos or nil>}
--
-- `indoor` marks goals that finish inside a building, so the brain knows to
-- append the stored door->destination path rather than trusting the engine
-- pathfinder to find its way through a doorway.

local function goal_home(r, speed)
	return {
		kind = "home",
		pos = r.sleep_pos,
		speed = speed or "walk",
		indoor = true,
		interior_kind = "bed",
		interior_index = r.bed_nr,
		plot = r.plot_nr,
	}
end

local function goal_work(r)
	if not r.work_pos then return end
	-- A hand-placed workstation in a player town has no schematic plot or marker
	-- index and no precomputed door path, so it is an open-air destination the
	-- pathfinder walks straight to -- not an indoor one that needs threading
	-- through a front door. Everything else is a schematic workplace as before.
	if r.work_hand_placed then
		return {
			kind = "work",
			pos = r.work_pos,
			speed = "walk",
			face = r.work_facing,
		}
	end
	return {
		kind = "work",
		pos = r.work_pos,
		speed = "walk",
		indoor = true,
		interior_kind = "workplace",
		interior_index = r.work_index,
		plot = r.work_plot,
		face = r.work_facing,
	}
end

-- Where a villager with nothing to do hangs about. Workers drift towards the
-- village centre (the square, the well, the tavern); everyone else stays near
-- their own plot, which is what keeps children off the moors.
local function leisure_anchor(r)
	if r.role == "child" or r.role == "elder" then
		return r.plot_centre, 8
	end
	if r.centre then return r.centre, math.min(r.radius or 24, 26) end
	return r.plot_centre, 12
end

function schedule.decide(self, r, pos)
	if not r then return end

	----------------------------------------------------------------------------
	-- 0. Somebody who has taken service
	----------------------------------------------------------------------------

	-- Above danger, and above everything else, because a hired villager is not
	-- living this village's day any more. They do not go to the forge at nine,
	-- and -- the part that matters -- they do not bolt for their own front door
	-- when something growls, because their own front door is half a valley
	-- behind them. Sticking with the person who hired them is the only sensible
	-- thing left to do, and it is what they agreed to.
	if village_life.settings.hiring then
		local g = village_life.companion.goal(self, r, pos)
		if g then return g end
	end

	local role = r.role
	local off = offset(r)
	local rise, work_start, work_end, bedtime = hours_for(role, off)
	local hour = util.hour()

	----------------------------------------------------------------------------
	-- 1. Danger
	----------------------------------------------------------------------------
	local alarm = threats.alarm(r.village_id)
	local threat, threat_dist = threats.nearest(pos, SEE_THREAT)

	-- A player the village has written off counts as something to run from.
	-- Nothing else in the mod makes standing physically legible; this does.
	if not threat then
		local enemy, enemy_pos = village_life.reputation.enemy_near(
				r.village_id, pos, SEE_THREAT)
		if enemy_pos then
			-- Named, because being run from by name is the point of being an
			-- enemy of the village. They know exactly who you are.
			threat = {pos = enemy_pos, name = "player",
					label = enemy and enemy:get_player_name()}
			threat_dist = util.dist_flat(enemy_pos, pos)
		end
	end

	if role == "guard" then
		-- Guards are the responders: the whole village is their business, so
		-- they act on the alarm wherever in it the trouble is.
		if threat or alarm then
			return {kind = "defend", pos = (threat and threat.pos) or alarm.pos,
					speed = "run", threat = threat}
		end

	-- Everyone else reacts to trouble they can actually see, or to an alarm
	-- raised somewhere near them. Acting on the bare village-wide flag put a
	-- whole ninety-node village indoors because of one monster at the far edge
	-- of the fields -- and left it there, because something is nearly always
	-- out there somewhere.
	elseif threat or (alarm and util.dist_flat(alarm.pos, pos) <= HEAR_ALARM) then
		-- Run for the door. A villager that flees in a straight line away
		-- from a monster -- which is what mobs redo's runaway_from does --
		-- just dies further from home.
		local g = goal_home(r, "run")
		g.kind = "flee"
		g.urgent = true
		-- What they are running from, in words, for anything that has to say so
		-- out loud. Seen for themselves when they can see it; otherwise what
		-- the alarm reported, which they were told and so may repeat. Neither
		-- is guaranteed to be nameable, and a villager who cannot name it says
		-- something vague rather than a nonsense word in a sentence.
		g.threat = threat
		g.threat_label = (threat and (threat.label or threats.describe(threat.name)))
				or (alarm and threats.describe(alarm.name))
		-- If the monster is between us and our own house, any door will do.
		if threat and threat_dist and threat_dist < 8 then
			g.desperate = true
		end
		return g
	end

	----------------------------------------------------------------------------
	-- 2. Weather
	----------------------------------------------------------------------------
	local severity = schedule.weather_severity(pos)
	if severity == "severe" and not util.has_roof(pos) then
		local g = goal_home(r)
		g.kind = "shelter"
		return g
	end

	----------------------------------------------------------------------------
	-- 3. Night
	----------------------------------------------------------------------------
	if hour >= bedtime or hour < rise then
		local g = goal_home(r)
		g.kind = "sleep"
		return g
	end

	----------------------------------------------------------------------------
	-- 4. Work
	----------------------------------------------------------------------------
	if hour >= work_start and hour < work_end then
		-- Midday break: workers step outside, eat, and gossip.
		local lunch_start, lunch_end = LUNCH + off, BACK + off
		if hour >= lunch_start and hour < lunch_end and role ~= "guard" then
			local anchor, radius = leisure_anchor(r)
			return {kind = "break", anchor = anchor, radius = radius, speed = "walk"}
		end

		local g = goal_work(r)
		if g then return g end

		-- No workstation of their own. Wives, elders and children still have
		-- a day: they keep to the plot and the village centre.
		if severity == "mild" and not r.hardy then
			local h = goal_home(r)
			h.kind = "indoors"
			return h
		end
		local anchor, radius = leisure_anchor(r)
		return {kind = "chores", anchor = anchor, radius = radius, speed = "walk"}
	end

	----------------------------------------------------------------------------
	-- 5. Leisure
	----------------------------------------------------------------------------
	if severity == "mild" and not r.hardy and not util.has_roof(pos) then
		local h = goal_home(r)
		h.kind = "indoors"
		return h
	end

	-- Somebody who says they keep bees goes and sees to the bees. This is the
	-- difference between a pastime and a line of dialogue: it is a thing that
	-- exists, in a place, that they visit.
	local hobby = village_life.traits.place(self)
	if hobby and util.dist_flat(hobby, pos) > 2 then
		return {kind = "hobby", pos = hobby, speed = "walk", face = hobby}
	end

	local anchor, radius = leisure_anchor(r)
	return {kind = "leisure", anchor = anchor, radius = radius, speed = "walk"}
end

--------------------------------------------------------------------------------
-- Interior paths
--------------------------------------------------------------------------------

-- The stored door->destination path for a goal that ends inside a building,
-- trimmed to start where the outdoor leg ends.
function schedule.interior_path(r, goal)
	if not goal or not goal.indoor or not goal.plot then return end
	return home.path_in(r.village_id, goal.plot, goal.interior_index,
			goal.interior_kind, 1)
end

-- The outdoor destination for an indoor goal: the spot just outside the front
-- door. The brain walks here first, then hands over to the interior path.
--
-- The stored path is the authority on where that spot is. `path_out` runs
-- bed -> door and then appends the shared tail from the door out to the street,
-- so reversed, its *first* entry is a tile in the street that mg_villages
-- worked out on the schematic -- which means it is standable by construction.
--
-- `get_entrance_list` is only the fallback, and needs snapping, because it
-- returns `building_data.all_entrances`: the positions of the door nodes
-- themselves. Aiming the outdoor leg at a door node let creaturemob's `snap`
-- resolve it to a standable tile on *either* side of the door, so the leg that
-- was supposed to end in the street could end up aimed through the wall.
function schedule.approach_pos(r, goal)
	if not goal or not goal.plot then return end

	local path = schedule.interior_path(r, goal)
	if path and path[1] then return path[1] end

	local entrances = mg_villages.get_entrance_list(r.village_id, goal.plot)
	local door = entrances and entrances[1]
	if door then return util.find_standing_near(door, 2) or door end
end

-- The plot an indoor goal finishes inside, for the "am I actually in the
-- building" test that both the hand-over and arrival depend on.
function schedule.goal_plot(r, goal)
	if not goal or not goal.indoor or not goal.plot then return end
	if goal.plot == r.plot_nr then return r.bpos end
	if goal.plot == r.work_plot then return r.work_bpos end
	return home.plot(r.village_id, goal.plot)
end
