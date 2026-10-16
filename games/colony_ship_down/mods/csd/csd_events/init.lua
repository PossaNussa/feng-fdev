-- Malfunctions: the "sabotage" of Colony Ship Down, except nobody is the
-- saboteur - the ship just breaks, and everyone pitches in.
--
-- An event has a fix (stations to use, people to stand on pads) and, for the
-- urgent ones, a countdown. Missing the countdown hurts the ship and stings
-- the crew a little, but never ends the game.
--
-- Admins: /malfunction <id> starts one, /malfunction stop ends it.

csd_events = {}

local S = core.get_translator("csd_events")
local function has_ship() return core.global_exists("csd_ship") end

local function now()
	return core.get_us_time() / 1e6
end
csd_events.now = now

csd_events.events = {}
csd_events.active = nil -- {id, def, started, deadline, state}

-- def = {
--   title, hint = "what to do", countdown = seconds or nil, duration = seconds or nil,
--   weight = function() return 1 end,   -- how likely it is to be picked now
--   start(state), stop(state, fixed), tick(state, dtime) -> "fixed" to end
--   fail(state)                         -- countdown ran out
--   lights = "alert" | "off" | nil
-- }
function csd_events.register_event(id, def)
	def.id = id
	csd_events.events[id] = def
end

------------------------------------------------------------------------------
-- Stations used by malfunctions
------------------------------------------------------------------------------

local function station(kind, description, shape, minigame)
	csd_tasks.register_station_kind(kind, {
		description = description, shape = shape, minigame = minigame,
		screen = "csd_events_screen_" .. kind .. ".png", light = 5,
	})
end
station("reactor_stabilizer", S("Reactor Stabiliser"), "pad")
station("o2_panel",           S("Oxygen Control Panel"), "wall", "keypad")
station("breaker_panel",      S("Breaker Panel"), "wall", "breakers")
station("comms_dish",         S("Comms Array Control"), "console", "calibrate")
station("valve",              S("Shutoff Valve"), "wall", "valve")

-- Valve: crank the wheel shut.
csd_tasks.register_minigame("valve", {
	title = S("Close Shutoff Valve"),
	size = {9, 4.5},
	init = function(sess) sess.state = {n = 0, left = true} end,
	render = function(sess)
		local st = sess.state
		return table.concat({
			csd_tasks.fs_label(0.5, 0.3, S("Turn the wheel - left, right, left..."), "#c0cce0"),
			csd_tasks.fs_bar(0.5, 0.9, 8, 0.8, st.n / 12, "#55aaff"),
			csd_tasks.fs_button(1, 2.2, 3, 1, "l", S("<< Turn"), st.left and "#2a6a8a" or "#222830"),
			csd_tasks.fs_button(5, 2.2, 3, 1, "r", S("Turn >>"), st.left and "#222830" or "#2a6a8a"),
		})
	end,
	fields = function(sess, fields)
		local st = sess.state
		if (fields.l and st.left) or (fields.r and not st.left) then
			st.n, st.left = st.n + 1, not st.left
			core.sound_play("csd_tasks_click", {to_player = sess.name, gain = 0.4, pitch = 0.7}, true)
			if st.n >= 12 then return "done" end
		end
	end,
})

-- Keypad: type the code shown on the panel.
csd_tasks.register_minigame("keypad", {
	title = S("Enter Oxygen Code"),
	size = {6, 7},
	init = function(sess)
		sess.state = {code = tostring(math.random(10000, 99999)), typed = ""}
	end,
	render = function(sess)
		local st = sess.state
		local fs = {
			csd_tasks.fs_label(0.4, 0.3, S("Code: @1", st.code), "#ffdd66"),
			"box[0.4,0.6;5.2,0.8;#0a1020]",
			csd_tasks.fs_label(0.6, 1.0, st.typed, "#9fe8ff"),
		}
		for i = 1, 10 do
			local digit = i == 10 and 0 or i
			local x = 0.6 + ((i - 1) % 3) * 1.65
			local y = 1.7 + math.floor((i - 1) / 3) * 1.1
			if i == 10 then x = 0.6 + 1.65 end
			fs[#fs + 1] = csd_tasks.fs_button(x, y, 1.5, 1, "d" .. digit, tostring(digit))
		end
		fs[#fs + 1] = csd_tasks.fs_button(0.6, 5.0, 1.5, 0.9, "clr", S("Clear"), "#5a2a2a")
		fs[#fs + 1] = csd_tasks.fs_button(3.9, 5.0, 1.5, 0.9, "ok", S("OK"), "#2a6a3a")
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for d = 0, 9 do
			if fields["d" .. d] and #st.typed < 5 then
				st.typed = st.typed .. d
				return
			end
		end
		if fields.clr then st.typed = "" return end
		if fields.ok then
			if st.typed == st.code then return "done" end
			st.typed = ""
			sess.message = core.colorize("#ff6060", S("Wrong code."))
		end
	end,
})

-- Breakers: flip every switch to ON. Some flip back when you touch a neighbour.
csd_tasks.register_minigame("breakers", {
	title = S("Reset Breakers"),
	size = {9, 4.5},
	init = function(sess)
		local st = {}
		for i = 1, 6 do st[i] = math.random() < 0.3 end
		st[math.random(6)] = false
		sess.state = st
	end,
	render = function(sess)
		local fs = {csd_tasks.fs_label(0.4, 0.3, S("Switch every breaker ON."), "#c0cce0")}
		for i = 1, 6 do
			local on = sess.state[i]
			fs[#fs + 1] = csd_tasks.fs_button(0.5 + (i - 1) * 1.4, 0.9, 1.2, 2.2, "b" .. i,
				on and S("ON") or S("OFF"), on and "#2a8a3a" or "#6a2a2a")
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for i = 1, 6 do
			if fields["b" .. i] then
				st[i] = not st[i]
				-- A worn breaker knocks its neighbour off now and then.
				if st[i] and math.random() < 0.25 then
					local n = i < 6 and i + 1 or i - 1
					st[n] = false
				end
				core.sound_play("csd_tasks_click", {to_player = sess.name, gain = 0.5}, true)
				for j = 1, 6 do
					if not st[j] then return end
				end
				return "done"
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Running an event
------------------------------------------------------------------------------

local hud = {} -- name -> {banner, overlay}
local alarm_timer, flash = 0, false

local function room_of_kind(kind)
	local list = csd_tasks.get_stations(kind)
	local rooms, seen = {}, {}
	for _, s in ipairs(list) do
		if s.room and not seen[s.room] then
			seen[s.room] = true
			rooms[#rooms + 1] = s.room
		end
	end
	return table.concat(rooms, ", ")
end
csd_events.room_of_kind = room_of_kind

local function banner_text()
	local a = csd_events.active
	if not a then return "" end
	local t = "!! " .. a.def.title:upper() .. " !!"
	if a.deadline then
		t = t .. ("   %d s"):format(math.max(0, math.ceil(a.deadline - now())))
	end
	local hint = type(a.def.hint) == "function" and a.def.hint(a.state) or a.def.hint
	return t .. "\n" .. (hint or "")
end

-- Where the fix is: every station of the event's kinds, plus whatever the
-- event itself reports (def.targets(state) -> {{pos=, label=}, ...}).
local function event_targets()
	local a = csd_events.active
	if not a then return {} end
	local out = {}
	for _, kind in ipairs(a.def.kinds or {}) do
		local sk = csd_tasks.station_kinds[kind]
		for _, st in ipairs(csd_tasks.get_stations(kind)) do
			out[#out + 1] = {pos = st.pos, label = "!! " .. (sk and sk.description or kind)}
		end
	end
	if a.def.targets then
		for _, t in ipairs(a.def.targets(a.state) or {}) do out[#out + 1] = t end
	end
	return out
end

local function clear_waypoints(player, h)
	for _, id in ipairs(h.waypoints or {}) do player:hud_remove(id) end
	h.waypoints = {}
end

local function update_waypoints(player, h)
	local targets = event_targets()
	if h.waypoint_count == #targets then
		-- positions can move (e.g. a new breach); refresh them
		for i, t in ipairs(targets) do player:hud_change(h.waypoints[i], "world_pos", vector.offset(t.pos, 0, 0.8, 0)) end
		return
	end
	clear_waypoints(player, h)
	for _, t in ipairs(targets) do
		h.waypoints[#h.waypoints + 1] = player:hud_add({
			type = "waypoint", name = t.label, text = "m", precision = 1,
			number = 0xff4040, world_pos = vector.offset(t.pos, 0, 0.8, 0), z_index = 8,
		})
	end
	h.waypoint_count = #targets
end

local function update_hud(player)
	local name = player:get_player_name()
	local h = hud[name]
	if not csd_events.active then
		if h then
			player:hud_remove(h.banner)
			player:hud_remove(h.overlay)
			clear_waypoints(player, h)
			hud[name] = nil
		end
		return
	end
	if not h then
		h = {
			banner = player:hud_add({
				type = "text", position = {x = 0.5, y = 0.08}, alignment = {x = 0, y = 1},
				number = 0xff5050, text = "", z_index = 20, size = {x = 1.5, y = 0}, style = 1,
			}),
			overlay = player:hud_add({
				type = "image", position = {x = 0.5, y = 0.5}, alignment = {x = 0, y = 0},
				scale = {x = -100, y = -100}, text = "", z_index = -10,
			}),
		}
		hud[name] = h
	end
	player:hud_change(h.banner, "text", banner_text())
	update_waypoints(player, h)
	local urgent = csd_events.active.def.countdown ~= nil
	player:hud_change(h.overlay, "text", (urgent and flash) and "csd_events_vignette.png" or "")
end

local function set_lights(mode)
	if has_ship() and csd_ship.set_lighting_mode then
		csd_ship.set_lighting_mode(mode)
	end
end

function csd_events.stop(fixed)
	local a = csd_events.active
	if not a then return end
	csd_events.active = nil
	if a.def.stop then a.def.stop(a.state, fixed) end
	for _, kind in ipairs(a.def.kinds or {}) do
		for _, st in ipairs(csd_tasks.get_stations(kind)) do
			csd_tasks.set_station_state(st.pos, csd_tasks.kind_failing(kind) and "warn" or "normal")
		end
	end
	set_lights("normal")
	local msg = fixed and core.colorize("#7dffa0", S("@1 - fixed. Nice work, crew.", a.def.title))
		or core.colorize("#ffb347", S("@1 is over.", a.def.title))
	core.chat_send_all(msg)
	for _, player in ipairs(core.get_connected_players()) do
		update_hud(player)
	end
end

function csd_events.start(id)
	local def = csd_events.events[id]
	if not def or csd_events.active then return false end
	if def.available and not def.available() then return false end
	local a = {id = id, def = def, started = now(), state = {}}
	if def.countdown then a.deadline = now() + def.countdown end
	if def.duration then a.ends = now() + def.duration end
	csd_events.active = a
	if def.start then def.start(a.state) end
	for _, kind in ipairs(def.kinds or {}) do
		for _, st in ipairs(csd_tasks.get_stations(kind)) do
			csd_tasks.set_station_state(st.pos, "warn")
		end
	end
	if def.lights then set_lights(def.lights) end
	core.chat_send_all(core.colorize("#ff5050", "!! " .. def.title .. " !! ") ..
		(type(def.hint) == "function" and def.hint(a.state) or def.hint or ""))
	for _, player in ipairs(core.get_connected_players()) do
		core.sound_play("csd_events_alarm", {to_player = player:get_player_name(), gain = 0.7}, true)
		update_hud(player)
	end
	return true
end

-- Event logic calls this when the crew has done what's needed.
function csd_events.fixed()
	csd_events.stop(true)
end

core.register_globalstep(function(dtime)
	local a = csd_events.active
	if a then
		if a.def.tick and a.def.tick(a.state, dtime) == "fixed" then
			csd_events.fixed()
			return
		end
		if a.deadline and now() >= a.deadline then
			if a.def.fail then a.def.fail(a.state) end
			core.chat_send_all(core.colorize("#ff5050", S("@1 - we ran out of time!", a.def.title)))
			csd_events.stop(false)
			return
		end
		if a.ends and now() >= a.ends then
			csd_events.stop(false)
			return
		end
	end
	alarm_timer = alarm_timer + dtime
	if alarm_timer >= 1 then
		alarm_timer = 0
		flash = not flash
		if a then
			for _, player in ipairs(core.get_connected_players()) do
				if a.def.countdown and flash then
					core.sound_play("csd_events_alarm", {to_player = player:get_player_name(), gain = 0.35}, true)
				end
				update_hud(player)
			end
		end
	end
end)

core.register_on_joinplayer(function(player)
	core.after(1, function()
		if player:is_player() then update_hud(player) end
	end)
end)

core.register_on_leaveplayer(function(player)
	hud[player:get_player_name()] = nil
end)

-- Stations used outside their malfunction just report all clear.
local idle_kinds = {reactor_stabilizer = true, o2_panel = true, breaker_panel = true, comms_dish = true, valve = true}
csd_tasks.register_on_station_use(function(pos, kind, player)
	local a = csd_events.active
	if a and a.def.on_station and a.def.on_station(a.state, pos, kind, player) then
		return true
	end
	if idle_kinds[kind] then
		core.chat_send_player(player:get_player_name(), S("All readings nominal."))
		return true
	end
end)

------------------------------------------------------------------------------
-- Scheduler
------------------------------------------------------------------------------

local INTERVAL = tonumber(core.settings:get("csd_malfunction_interval")) or 600
local ENABLED = core.settings:get_bool("csd_malfunctions", true)
local next_at = now() + INTERVAL * (0.5 + math.random() * 0.5)

local sched_timer = 0
core.register_globalstep(function(dtime)
	sched_timer = sched_timer + dtime
	if sched_timer < 5 then return end
	sched_timer = 0
	if not ENABLED or csd_events.active or #core.get_connected_players() == 0 then return end
	if now() < next_at then return end
	next_at = now() + INTERVAL * (0.7 + math.random() * 0.6)
	local pool, total = {}, 0
	for id, def in pairs(csd_events.events) do
		if not def.available or def.available() then
			local w = def.weight and def.weight() or 1
			if w > 0 then
				pool[#pool + 1] = {id, w}
				total = total + w
			end
		end
	end
	table.sort(pool, function(a, b) return a[1] < b[1] end)
	local r = math.random() * total
	for _, e in ipairs(pool) do
		r = r - e[2]
		if r <= 0 then
			csd_events.start(e[1])
			return
		end
	end
end)

core.register_chatcommand("malfunction", {
	params = "<id> | stop",
	description = S("Start or stop a ship malfunction"),
	privs = {server = true},
	func = function(_, param)
		param = param:trim()
		if param == "stop" then
			csd_events.stop(false)
			return true
		end
		if csd_events.events[param] then
			if csd_events.active then return false, S("A malfunction is already running.") end
			if not csd_events.start(param) then
				return false, S("That malfunction can't run on this ship (missing stations?).")
			end
			return true
		end
		local ids = {}
		for id in pairs(csd_events.events) do ids[#ids + 1] = id end
		table.sort(ids)
		return false, S("Malfunctions: @1", table.concat(ids, ", "))
	end,
})

dofile(core.get_modpath("csd_events") .. "/events.lua")
