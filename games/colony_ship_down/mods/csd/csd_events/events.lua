-- The malfunctions themselves.

local S = core.get_translator("csd_events")
local reg = csd_events.register_event
local now = csd_events.now

local function stations(kind)
	return csd_tasks.get_stations(kind)
end

local function key(pos)
	return core.pos_to_string(vector.round(pos))
end

-- Hurt everyone a little, never fatally.
local function sting(amount)
	for _, player in ipairs(core.get_connected_players()) do
		if player:get_hp() > 0 then
			player:set_hp(math.max(1, player:get_hp() - amount), {type = "set_hp", csd_reason = "malfunction"})
		end
	end
end

-- When a malfunction station also belongs to someone's task, count it.
local function credit_task(player, kind, pos)
	csd_tasks.progress_step(player, kind, pos)
end

------------------------------------------------------------------------------
-- Reactor meltdown: two people hold the two stabiliser pads at once.
------------------------------------------------------------------------------

local function pads_needed()
	local n = math.min(2, #stations("reactor_stabilizer"))
	if #core.get_connected_players() < 2 then n = math.min(n, 1) end
	return n
end

reg("reactor_meltdown", {
	title = S("Reactor Meltdown"),
	kinds = {"reactor_stabilizer"},
	countdown = 60,
	lights = "alert",
	available = function() return #stations("reactor_stabilizer") > 0 end,
	weight = function() return 1 + (csd_tasks.get_system("power") < 30 and 2 or 0) end,
	hint = function(st)
		local held = 0
		for _ in pairs(st.holders or {}) do held = held + 1 end
		return S("Stand on the reactor stabilisers together (@1) - @2/@3 held",
			csd_events.room_of_kind("reactor_stabilizer"), held, pads_needed())
	end,
	start = function(st)
		st.holders, st.hold = {}, 0
	end,
	on_station = function(st, pos, kind, player)
		if kind ~= "reactor_stabilizer" then return end
		st.holders[key(pos)] = {name = player:get_player_name(), pos = pos}
		core.chat_send_player(player:get_player_name(), S("Holding the stabiliser - stay on the pad!"))
		return true
	end,
	tick = function(st, dtime)
		local held = 0
		for k, h in pairs(st.holders) do
			local p = core.get_player_by_name(h.name)
			if not p or vector.distance(p:get_pos(), vector.offset(h.pos, 0, 0.5, 0)) > 1.4 then
				st.holders[k] = nil
			else
				held = held + 1
			end
		end
		if held >= pads_needed() and held > 0 then
			st.hold = st.hold + dtime
			if st.hold >= 2.5 then return "fixed" end
		else
			st.hold = 0
		end
	end,
	fail = function()
		csd_tasks.add_system("power", -35)
		csd_tasks.add_system("hull", -15)
		sting(6)
	end,
})

------------------------------------------------------------------------------
-- Oxygen depletion: enter the code at both O2 panels.
------------------------------------------------------------------------------

local function o2_needed()
	return math.min(2, #stations("o2_panel"))
end

reg("o2_depletion", {
	title = S("Oxygen Depleted"),
	kinds = {"o2_panel"},
	countdown = 90,
	lights = "alert",
	available = function() return #stations("o2_panel") > 0 end,
	weight = function() return 1 + (csd_tasks.get_system("life_support") < 30 and 2 or 0) end,
	hint = function(st)
		local n = 0
		for _ in pairs(st.done or {}) do n = n + 1 end
		return S("Enter the code at the oxygen panels (@1) - @2/@3",
			csd_events.room_of_kind("o2_panel"), n, o2_needed())
	end,
	start = function(st) st.done = {} end,
	on_station = function(st, pos, kind, player)
		if kind ~= "o2_panel" then return end
		local k = key(pos)
		if st.done[k] then
			core.chat_send_player(player:get_player_name(), S("This panel is reset. Do the other one!"))
			return true
		end
		csd_tasks.start_minigame(player, "keypad", pos, function(_, ok)
			if ok and csd_events.active and csd_events.active.state == st then
				st.done[k] = true
			end
		end)
		return true
	end,
	tick = function(st)
		local n = 0
		for _ in pairs(st.done) do n = n + 1 end
		if n >= o2_needed() then return "fixed" end
	end,
	fail = function()
		csd_tasks.add_system("life_support", -40)
		for _, player in ipairs(core.get_connected_players()) do
			player:set_breath(1)
		end
		sting(4)
	end,
})

------------------------------------------------------------------------------
-- Lights out: reset the breakers in Electrical. No timer, just darkness.
------------------------------------------------------------------------------

reg("lights_out", {
	title = S("Power Failure"),
	kinds = {"breaker_panel"},
	lights = "off",
	available = function() return #stations("breaker_panel") > 0 end,
	weight = function() return 1 + (csd_tasks.get_system("power") < 40 and 3 or 0) end,
	hint = function()
		return S("Reset the breakers (@1). Flashlights help.", csd_events.room_of_kind("breaker_panel"))
	end,
	start = function() csd_tasks.decay_multiplier.power = 2 end,
	stop = function() csd_tasks.decay_multiplier.power = nil end,
	on_station = function(st, pos, kind, player)
		if kind ~= "breaker_panel" then return end
		csd_tasks.start_minigame(player, "breakers", pos, function(_, ok)
			if ok and csd_events.active and csd_events.active.state == st then
				st.fixed = true
			end
		end)
		return true
	end,
	tick = function(st)
		if st.fixed then return "fixed" end
	end,
})

------------------------------------------------------------------------------
-- Comms blackout: chat between distant crew comes through as static.
------------------------------------------------------------------------------

local CLEAR_RANGE = 24

local function garble(text)
	return (text:gsub("[^%s]", function(c)
		if math.random() < 0.55 then
			local noise = {"#", "%", "~", "*", "-", "?", "/"}
			return noise[math.random(#noise)]
		end
		return c
	end))
end

reg("comms_blackout", {
	title = S("Comms Blackout"),
	kinds = {"comms_dish"},
	available = function() return #stations("comms_dish") > 0 end,
	weight = function() return 1 + (csd_tasks.get_system("comms") < 30 and 2 or 0) end,
	hint = function()
		return S("Recalibrate the comms array (@1). Long-range chat is scrambled.", csd_events.room_of_kind("comms_dish"))
	end,
	start = function() csd_tasks.decay_multiplier.comms = 2 end,
	stop = function() csd_tasks.decay_multiplier.comms = nil end,
	on_station = function(st, pos, kind, player)
		if kind ~= "comms_dish" then return end
		csd_tasks.start_minigame(player, "calibrate", pos, function(_, ok)
			if ok and csd_events.active and csd_events.active.state == st then
				st.fixed = true
			end
		end)
		return true
	end,
	tick = function(st)
		if st.fixed then return "fixed" end
	end,
})

local function blackout()
	local a = csd_events.active
	return a and a.id == "comms_blackout"
end

if core.global_exists("proxchat") and proxchat.register_message_filter then
	-- Proximity chat: only voices close by come through clearly.
	proxchat.register_message_filter(function(_, _, msg, dist)
		if blackout() and dist > 12 then return garble(msg) end
		return msg
	end)
	-- ...and the ship-wide intercom is all static.
	local global = core.registered_chatcommands["global"]
	if global then
		local old = global.func
		global.func = function(name, param)
			if blackout() and param ~= "" then
				core.chat_send_all(("(Global) <%s> %s"):format(name, garble(param)))
				return true
			end
			return old(name, param)
		end
	end
else
	core.register_on_chat_message(function(name, message)
		if not blackout() or message:sub(1, 1) == "/" then return end
		local sender = core.get_player_by_name(name)
		if not sender or not core.check_player_privs(name, {shout = true}) then return end
		local spos = sender:get_pos()
		for _, player in ipairs(core.get_connected_players()) do
			local close = vector.distance(player:get_pos(), spos) <= CLEAR_RANGE
			core.chat_send_player(player:get_player_name(),
				core.format_chat_message(name, close and message or garble(message)))
		end
		return true
	end)
end

------------------------------------------------------------------------------
-- Hull breach: a hole opens somewhere; it drags people towards it until welded.
------------------------------------------------------------------------------

csd_tasks.register_minigame("weld", {
	title = S("Weld Hull Breach"),
	size = {9, 4},
	init = function(sess)
		-- With a hull patch it's quick; without, you weld raw plate (slow).
		local has_patch = sess.opts.breach and core.get_player_by_name(sess.name):get_inventory():contains_item("main", "csd_tasks:hull_patch")
		sess.state = {n = 0, need = (not sess.opts.breach or has_patch) and 6 or 20, patch = has_patch}
	end,
	render = function(sess)
		local hint = sess.state.patch and S("Welding a hull patch over the breach...")
			or (sess.opts.breach and S("No hull patch - welding raw plate, this takes a while.") or S("Keep welding until the patch holds."))
		return table.concat({
			csd_tasks.fs_label(0.5, 0.3, hint, "#c0cce0"),
			csd_tasks.fs_bar(0.5, 0.9, 8, 0.8, sess.state.n / sess.state.need, "#ffdd55"),
			csd_tasks.fs_button(3, 2, 3, 0.9, "weld", S("Weld"), "#6a5a2a"),
		})
	end,
	fields = function(sess, fields)
		if fields.weld then
			sess.state.n = sess.state.n + 1
			core.add_particlespawner({
				amount = 10, time = 0.2, pos = vector.copy(sess.pos),
				vel = {min = vector.new(-2, -1, -2), max = vector.new(2, 2, 2)},
				exptime = 0.4, size = 1, glow = 14, texture = "csd_events_spark.png",
			})
			if sess.state.n >= sess.state.need then
				if sess.state.patch then
					core.get_player_by_name(sess.name):get_inventory():remove_item("main", "csd_tasks:hull_patch")
				end
				return "done"
			end
		end
	end,
})

core.register_node("csd_events:hull_breach", {
	description = S("Hull Breach"),
	tiles = {{name = "csd_events_breach.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.8}}},
	paramtype = "light",
	light_source = 8,
	light_colour = "#ff6030",
	groups = {not_in_creative_inventory = 1, cracky = 1},
	drop = "",
	on_rightclick = function(pos, _, clicker)
		local a = csd_events.active
		if not (a and a.id == "hull_breach" and clicker and clicker:is_player()) then return end
		csd_tasks.start_minigame(clicker, "weld", pos, function(_, ok)
			if ok and csd_events.active and csd_events.active.state == a.state then
				a.state.welded = true
			end
		end, {breach = true})
	end,
})

reg("hull_breach", {
	title = S("Hull Breach"),
	available = function()
		return core.get_modpath("csd_ship") ~= nil and csd_ship.random_breach_spot ~= nil
	end,
	weight = function() return 1 + (csd_tasks.get_system("hull") < 30 and 3 or 0) end,
	hint = function(st)
		return S("Weld the breach in @1 before it drags someone out!", st.room or "?")
	end,
	targets = function(st)
		return st.pos and {{pos = st.pos, label = S("!! Hull Breach")}} or {}
	end,
	start = function(st)
		local spot = csd_ship.random_breach_spot()
		if not spot then
			st.welded = true
			return
		end
		st.pos, st.room = spot.pos, spot.room
		st.old = core.get_node(spot.pos)
		core.set_node(spot.pos, {name = "csd_events:hull_breach"})
		st.timer, st.damage_timer = 0, 0
	end,
	tick = function(st, dtime)
		if st.welded then return "fixed" end
		if not st.pos then return end
		st.timer = st.timer + dtime
		st.damage_timer = st.damage_timer + dtime
		if st.damage_timer >= 4 then
			st.damage_timer = 0
			csd_tasks.add_system("hull", -1)
		end
		if st.timer >= 0.25 then
			st.timer = 0
			core.add_particlespawner({
				amount = 8, time = 0.25,
				pos = {min = vector.offset(st.pos, -2, -1, -2), max = vector.offset(st.pos, 2, 1, 2)},
				attract = {kind = "point", strength = 4, origin = st.pos, die_on_contact = true},
				exptime = 1, size = 1.2, texture = "csd_events_dust.png",
			})
			for _, obj in ipairs(core.get_objects_inside_radius(st.pos, 10)) do
				if obj:is_player() and not obj:get_attach() then
					local d = vector.subtract(st.pos, obj:get_pos())
					local dist = math.max(1, vector.length(d))
					obj:add_velocity(vector.multiply(vector.normalize(d), 3 / dist))
				end
			end
		end
	end,
	stop = function(st)
		if st.pos and core.get_node(st.pos).name == "csd_events:hull_breach" then
			core.set_node(st.pos, st.old or {name = "air"})
		end
	end,
})

------------------------------------------------------------------------------
-- Asteroid storm: the ship rocks and takes hull damage until the weapons
-- consoles clear a path (two runs) or the storm passes.
------------------------------------------------------------------------------

reg("asteroid_storm", {
	title = S("Asteroid Storm"),
	kinds = {"weapons_console"},
	duration = 120,
	lights = "alert",
	available = function() return #stations("weapons_console") > 0 end,
	weight = function() return 1 + (csd_tasks.get_system("navigation") < 30 and 2 or 0) end,
	hint = function(st)
		return S("Man the weapons consoles (@1) - @2/2 cleared",
			csd_events.room_of_kind("weapons_console"), st.cleared or 0)
	end,
	start = function(st) st.cleared, st.timer = 0, 0 end,
	on_station = function(st, pos, kind, player)
		if kind ~= "weapons_console" then return end
		csd_tasks.start_minigame(player, "asteroids", pos, function(p, ok)
			if ok and csd_events.active and csd_events.active.state == st then
				st.cleared = st.cleared + 1
				credit_task(p, kind, pos)
			end
		end)
		return true
	end,
	tick = function(st, dtime)
		if st.cleared >= 2 then return "fixed" end
		st.timer = st.timer + dtime
		if st.timer < 7 then return end
		st.timer = 0
		csd_tasks.add_system("hull", -2)
		for _, player in ipairs(core.get_connected_players()) do
			core.sound_play("csd_events_impact", {to_player = player:get_player_name(), gain = 0.8}, true)
			if not player:get_attach() then
				player:add_velocity(vector.new((math.random() - 0.5) * 6, 2.5, (math.random() - 0.5) * 6))
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Pipe burst: water pours from the ceiling of a room with a shutoff valve
-- until someone closes that valve; then the pumps drain it. With
-- dynamic_liquid the water is finite and sloshes out through the doors.
------------------------------------------------------------------------------

local WATER = "default:water_source"
local MAX_SPILL = 30

reg("pipe_burst", {
	title = S("Burst Pipe"),
	available = function()
		return core.registered_nodes[WATER] ~= nil and #stations("valve") > 0
			and core.global_exists("csd_ship") and csd_ship.room_at ~= nil
	end,
	weight = function() return 1 + (csd_tasks.get_system("life_support") < 30 and 1 or 0) end,
	hint = function(st)
		return S("Water everywhere in @1! Close the shutoff valve there.", st.room or "?")
	end,
	targets = function(st)
		local out = {}
		if st.valve then out[#out + 1] = {pos = st.valve, label = S("!! Shutoff Valve")} end
		if st.leak then out[#out + 1] = {pos = st.leak, label = S("!! Burst Pipe")} end
		return out
	end,
	start = function(st)
		local list = stations("valve")
		local v = list[math.random(#list)]
		st.valve = v.pos
		local r = csd_ship.room_at(v.pos)
		st.room = v.room or (r and r.name)
		if r then
			st.leak = vector.new(math.random(math.floor(r.minp.x) + 2, math.floor(r.maxp.x) - 2), r.maxp.y,
				math.random(math.floor(r.minp.z) + 2, math.floor(r.maxp.z) - 2))
			st.minp, st.maxp = vector.subtract(r.minp, vector.new(12, 1, 12)), vector.add(r.maxp, vector.new(12, 1, 12))
		end
		st.spilled, st.timer = 0, 0
		csd_tasks.decay_multiplier.life_support = 1.5
	end,
	on_station = function(st, pos, kind, player)
		if kind ~= "valve" then return end
		if not vector.equals(vector.round(pos), vector.round(st.valve)) then
			core.chat_send_player(player:get_player_name(), S("Wrong valve - the burst is in @1.", st.room or "?"))
			return true
		end
		csd_tasks.start_minigame(player, "valve", pos, function(_, ok)
			if ok and csd_events.active and csd_events.active.state == st then st.closed = true end
		end)
		return true
	end,
	tick = function(st, dtime)
		if st.closed then return "fixed" end
		if not st.leak then return end
		st.timer = st.timer + dtime
		core.add_particlespawner({
			amount = 6, time = 0.2, pos = st.leak,
			vel = {min = vector.new(-1.5, -4, -1.5), max = vector.new(1.5, -1, 1.5)}, acc = vector.new(0, -9, 0),
			exptime = 0.8, size = 1, texture = "csd_ship_droplet.png",
		})
		if st.timer >= 3 and st.spilled < MAX_SPILL then
			st.timer = 0
			local node = core.get_node_or_nil(st.leak)
			if node and (node.name == "air" or node.name == WATER or node.name == "default:water_flowing") then
				core.set_node(st.leak, {name = WATER})
				st.spilled = st.spilled + 1
			end
			core.sound_play("csd_sfx_locker", {pos = st.leak, gain = 0.5, pitch = 0.6, max_hear_distance = 20}, true)
		end
	end,
	stop = function(st)
		csd_tasks.decay_multiplier.life_support = nil
		if not st.minp then return end
		core.chat_send_all(core.colorize("#55aaff", S("Pumps engaged - draining @1.", st.room or "")))
		-- Drain gradually so it looks like pumping, not vanishing.
		local function drain(round)
			local found = core.find_nodes_in_area(st.minp, st.maxp, {WATER, "default:water_flowing"})
			if #found == 0 or round > 30 then return end
			-- turning pumps (csd_create) drain twice as fast
			local rate = 25 * ((core.global_exists("csd_create") and csd_create.pumps_running
				and csd_create.pumps_running() > 0) and 2 or 1)
			for i = 1, math.min(#found, rate) do core.remove_node(found[i]) end
			core.after(1, drain, round + 1)
		end
		core.after(2, drain, 1)
	end,
})
