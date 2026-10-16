-- The mini-games. Kept short: 10-30 seconds each, like Among Us tasks.

local S = csd_tasks.S
local button, bar, label = csd_tasks.fs_button, csd_tasks.fs_bar, csd_tasks.fs_label
local reg = csd_tasks.register_minigame

local function shuffled(list)
	local out = table.copy(list)
	for i = #out, 2, -1 do
		local j = math.random(i)
		out[i], out[j] = out[j], out[i]
	end
	return out
end

------------------------------------------------------------------------------
-- Wires: connect each coloured wire on the left to the same colour on the right.
------------------------------------------------------------------------------

local WIRE_COLORS = {
	{"#ff3b3b", S("Red")}, {"#3b8bff", S("Blue")}, {"#ffd23b", S("Yellow")}, {"#ff4fd8", S("Pink")},
}

reg("wires", {
	title = S("Fix Wiring"),
	size = {10, 6},
	init = function(sess)
		local idx = {1, 2, 3, 4}
		sess.state = {left = shuffled(idx), right = shuffled(idx), done = {}, picked = nil}
	end,
	render = function(sess)
		local st = sess.state
		local fs = {label(0.5, 0.3, S("Click a wire on the left, then the matching socket on the right."), "#c0cce0")}
		for row = 1, 4 do
			local y = 0.8 + (row - 1) * 1.2
			local l, r = st.left[row], st.right[row]
			local lc = WIRE_COLORS[l][1]
			local ltext = st.done[l] and "=====" or (st.picked == row and ">> " .. WIRE_COLORS[l][2] or WIRE_COLORS[l][2])
			fs[#fs + 1] = button(0.5, y, 3, 0.9, "l" .. row, ltext, st.done[l] and "#203020" or lc, "#101010")
			fs[#fs + 1] = button(6.5, y, 3, 0.9, "r" .. row, st.done[r] and "=====" or "( )", st.done[r] and "#203020" or WIRE_COLORS[r][1], "#101010")
		end
		-- Connected wires: a line of small segments from the left button to the
		-- matching socket on the right (formspecs can't draw diagonals).
		for c = 1, 4 do
			if st.done[c] then
				local li, ri
				for row = 1, 4 do
					if st.left[row] == c then li = row end
					if st.right[row] == c then ri = row end
				end
				local y1 = 0.8 + (li - 1) * 1.2 + 0.38
				local y2 = 0.8 + (ri - 1) * 1.2 + 0.38
				for k = 0, 30 do
					local f = k / 30
					fs[#fs + 1] = ("box[%f,%f;0.16,0.16;%s]"):format(3.5 + 2.84 * f, y1 + (y2 - y1) * f, WIRE_COLORS[c][1])
				end
			end
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for row = 1, 4 do
			if fields["l" .. row] and not st.done[st.left[row]] then
				st.picked = row
				return
			end
			if fields["r" .. row] and st.picked then
				if st.left[st.picked] == st.right[row] then
					st.done[st.right[row]] = true
					core.sound_play("csd_tasks_click", {to_player = sess.name, gain = 0.5}, true)
				else
					sess.message = core.colorize("#ff6060", S("Wrong socket!"))
				end
				st.picked = nil
				for c = 1, 4 do
					if not st.done[c] then return end
				end
				return "done"
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Calibrate: set three dials to their target readings.
------------------------------------------------------------------------------

reg("calibrate", {
	title = S("Calibrate Systems"),
	size = {10, 6},
	init = function(sess)
		local st = {target = {}, value = {}}
		for i = 1, 3 do
			st.target[i] = math.random(0, 99)
			repeat st.value[i] = math.random(0, 99) until st.value[i] ~= st.target[i]
		end
		sess.state = st
	end,
	render = function(sess)
		local st = sess.state
		local fs = {label(0.5, 0.3, S("Match each reading to its target, then lock in."), "#c0cce0")}
		for i = 1, 3 do
			local y = 0.8 + (i - 1) * 1.3
			local ok = st.value[i] == st.target[i]
			fs[#fs + 1] = label(0.5, y + 0.45, S("Target @1", ("%02d"):format(st.target[i])), "#9fe8ff")
			fs[#fs + 1] = button(2.6, y, 0.9, 0.9, "m10_" .. i, "-10")
			fs[#fs + 1] = button(3.6, y, 0.9, 0.9, "m1_" .. i, "-1")
			fs[#fs + 1] = ("style[v%d;font_size=*1.6;bgcolor=%s]button[4.7,%f;1.6,0.9;v%d;%02d]"):format(
				i, ok and "#1f6a3a" or "#3a2a2a", y, i, st.value[i])
			fs[#fs + 1] = button(6.5, y, 0.9, 0.9, "p1_" .. i, "+1")
			fs[#fs + 1] = button(7.5, y, 0.9, 0.9, "p10_" .. i, "+10")
		end
		fs[#fs + 1] = button(3.5, 4.8, 3, 0.9, "lock", S("Lock in"), "#2a6a8a")
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for i = 1, 3 do
			for key, delta in pairs({m10_ = -10, m1_ = -1, p1_ = 1, p10_ = 10}) do
				if fields[key .. i] then
					st.value[i] = (st.value[i] + delta) % 100
					return
				end
			end
		end
		if fields.lock then
			for i = 1, 3 do
				if st.value[i] ~= st.target[i] then
					sess.message = core.colorize("#ff6060", S("Readings don't match yet."))
					return
				end
			end
			return "done"
		end
	end,
})

------------------------------------------------------------------------------
-- Sequence: watch the lights, repeat them. Three rounds.
------------------------------------------------------------------------------

reg("sequence", {
	title = S("Start Reactor"),
	size = {8, 6.5},
	tick = 0.55,
	init = function(sess)
		local seq = {}
		for i = 1, 5 do seq[i] = math.random(9) end
		sess.state = {seq = seq, round = 3, phase = "show", step = 0, input = 0, lit = nil}
	end,
	on_tick = function(sess)
		local st = sess.state
		if st.phase ~= "show" then return "keep" end
		if st.lit then
			st.lit = nil -- gap between flashes
			return
		end
		st.step = st.step + 1
		if st.step > st.round then
			st.phase, st.input, st.step = "input", 0, 0
			return
		end
		st.lit = st.seq[st.step]
	end,
	render = function(sess)
		local st = sess.state
		local fs = {label(0.5, 0.3, st.phase == "show" and S("Watch...") or
			S("Repeat the sequence (@1 of @2)", st.input, st.round), "#c0cce0")}
		for i = 1, 9 do
			local x = 1.6 + ((i - 1) % 3) * 1.65
			local y = 0.8 + math.floor((i - 1) / 3) * 1.65
			local color = (st.lit == i) and "#5fe1ff" or "#1c2a44"
			fs[#fs + 1] = button(x, y, 1.5, 1.5, "c" .. i, "", color)
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		if st.phase ~= "input" then return end
		for i = 1, 9 do
			if fields["c" .. i] then
				st.input = st.input + 1
				if st.seq[st.input] ~= i then
					sess.message = core.colorize("#ff6060", S("Wrong! Watch again."))
					st.phase, st.step, st.lit = "show", 0, nil
					return
				end
				if st.input == st.round then
					if st.round == #st.seq then return "done" end
					st.round = st.round + 1
					st.phase, st.step, st.lit = "show", 0, nil
				end
				return
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Swipe card: swipe, then stop it at the right speed.
------------------------------------------------------------------------------

reg("swipe", {
	title = S("Swipe ID Card"),
	size = {9, 4.5},
	tick = 0.1,
	init = function(sess)
		sess.state = {t0 = nil}
	end,
	on_tick = function(sess)
		if not sess.state.t0 then return "keep" end
	end,
	render = function(sess)
		local st = sess.state
		local fs = {label(0.5, 0.3, S("Press SWIPE, then STOP after about one second."), "#c0cce0"),
			"box[0.5,0.8;8,1.2;#0d1424]"}
		local frac = 0
		if st.t0 then
			frac = math.min(1, (core.get_us_time() - st.t0) / 1.2e6)
		end
		fs[#fs + 1] = ("box[%f,0.95;1.5,0.9;#e8d36a]"):format(0.6 + frac * 6.3)
		fs[#fs + 1] = label(0.75 + frac * 6.3, 1.4, S("ID"), "#202020")
		if st.t0 then
			fs[#fs + 1] = button(3, 2.5, 3, 1, "stop", S("STOP"), "#8a2a2a")
		else
			fs[#fs + 1] = button(3, 2.5, 3, 1, "swipe", S("SWIPE"), "#2a6a8a")
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		if fields.swipe then
			st.t0 = core.get_us_time()
		elseif fields.stop and st.t0 then
			local dt = (core.get_us_time() - st.t0) / 1e6
			st.t0 = nil
			if dt < 0.75 then
				sess.message = core.colorize("#ff6060", S("Too fast. Try again."))
			elseif dt > 1.7 then
				sess.message = core.colorize("#ff6060", S("Too slow. Try again."))
			elseif math.random() < 0.12 then
				sess.message = core.colorize("#ff6060", S("Bad read. Try again."))
			else
				return "done"
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Clear debris: click every bit of junk out of the filter.
------------------------------------------------------------------------------

local JUNK = {"#7a6a4a", "#5a7a3a", "#8a8a8a", "#6a4a3a"}

reg("debris", {
	title = S("Clean Filter"),
	size = {9, 6},
	init = function(sess)
		local st = {}
		for i = 1, 7 do
			st[i] = {x = 0.5 + math.random() * 7, y = 0.7 + math.random() * 3.8, c = JUNK[math.random(#JUNK)]}
		end
		sess.state = st
	end,
	render = function(sess)
		local fs = {label(0.5, 0.3, S("Clear all the junk out of the filter."), "#c0cce0"),
			"box[0.4,0.6;8.2,4.9;#0d1a14]"}
		for i, j in pairs(sess.state) do
			fs[#fs + 1] = button(j.x, j.y, 0.9, 0.7, "j" .. i, "", j.c)
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		for i in pairs(sess.state) do
			if fields["j" .. i] then
				sess.state[i] = nil
				core.sound_play("csd_tasks_click", {to_player = sess.name, gain = 0.4}, true)
				if next(sess.state) == nil then return "done" end
				return
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Progress: press start and keep the window open until the bar fills.
-- Used for downloads/uploads, scans, refuelling. opts.verb / opts.seconds.
------------------------------------------------------------------------------

local function progress_game(id, title, verb, seconds, color, hint)
	reg(id, {
		title = title,
		size = {9, 4},
		tick = 0.5,
		max_distance = id == "scan" and 1.6 or nil,
		init = function(sess)
			sess.state = {running = false, t = 0}
		end,
		on_tick = function(sess)
			local st = sess.state
			if not st.running then return "keep" end
			st.t = st.t + 0.5
			if id == "scan" then
				local player = core.get_player_by_name(sess.name)
				if player then
					core.add_particlespawner({
						amount = 12, time = 0.5,
						pos = {min = vector.offset(sess.pos, -0.4, 0, -0.4), max = vector.offset(sess.pos, 0.4, 1.8, 0.4)},
						vel = {min = vector.new(0, 0.2, 0), max = vector.new(0, 0.6, 0)},
						exptime = 0.8, size = 1.5, glow = 14,
						texture = "csd_tasks_scan_particle.png",
					})
				end
			end
			if st.t >= seconds then return "done" end
		end,
		render = function(sess)
			local st = sess.state
			local fs = {label(0.5, 0.3, hint, "#c0cce0"),
				bar(0.5, 0.9, 8, 0.8, st.t / seconds, color)}
			if st.running then
				fs[#fs + 1] = label(0.5, 2.2, ("%s... %d%%"):format(verb, math.floor(st.t / seconds * 100)), "#9fe8ff")
			else
				fs[#fs + 1] = button(3, 2, 3, 0.9, "start", verb, "#2a6a8a")
			end
			return table.concat(fs)
		end,
		fields = function(sess, fields)
			if fields.start then sess.state.running = true end
		end,
	})
end

progress_game("download", S("Download Data"), S("Download"), 8, "#44ddff", S("Keep this window open until the download finishes."))
progress_game("upload", S("Upload Data"), S("Upload"), 8, "#44ff99", S("Keep this window open until the upload finishes."))
progress_game("scan", S("Medbay Scan"), S("Scan"), 10, "#66ff88", S("Stand still on the scanner pad."))
progress_game("water", S("Water Plants"), S("Water"), 3, "#55aaff", S("Give this planter a drink."))

------------------------------------------------------------------------------
-- Pump: click repeatedly to fill a tank / pull a lever.
------------------------------------------------------------------------------

local function pump_game(id, title, verb, presses, hint)
	reg(id, {
		title = title,
		size = {9, 4},
		init = function(sess) sess.state = {n = 0} end,
		render = function(sess)
			return table.concat({
				label(0.5, 0.3, hint, "#c0cce0"),
				bar(0.5, 0.9, 8, 0.8, sess.state.n / presses, "#ffaa33"),
				button(3, 2, 3, 0.9, "press", verb, "#6a4a2a"),
			})
		end,
		fields = function(sess, fields)
			if fields.press then
				sess.state.n = sess.state.n + 1
				core.sound_play("csd_tasks_click", {to_player = sess.name, gain = 0.4}, true)
				if sess.state.n >= presses then return "done" end
			end
		end,
	})
end

pump_game("fuel", S("Fill Fuel Canister"), S("Pump"), 10, S("Pump until the canister is full."))
pump_game("trash", S("Empty Garbage"), S("Pull lever"), 8, S("Keep pulling the lever to flush the chute."))

------------------------------------------------------------------------------
-- Asteroids: shoot the rocks drifting through the targeting grid.
------------------------------------------------------------------------------

-- func(sess) when an asteroid is shot down in the mini-game
csd_tasks.on_asteroid_shot = {}

reg("asteroids", {
	title = S("Clear Asteroids"),
	size = {10, 6.5},
	tick = 0.7,
	init = function(sess)
		sess.state = {rocks = {}, next_id = 1, hits = 0, need = 10}
	end,
	on_tick = function(sess)
		local st = sess.state
		for id, r in pairs(st.rocks) do
			r.x = r.x - 0.9
			if r.x < 0.4 then st.rocks[id] = nil end
		end
		if math.random() < 0.8 then
			st.rocks[st.next_id] = {x = 8.6, y = 0.7 + math.random() * 4}
			st.next_id = st.next_id + 1
		end
	end,
	render = function(sess)
		local st = sess.state
		local fs = {label(0.5, 0.3, S("Destroyed: @1 / @2", st.hits, st.need), "#c0cce0"),
			"box[0.4,0.6;9.2,5.2;#05070f]"}
		for id, r in pairs(st.rocks) do
			fs[#fs + 1] = ("image_button[%f,%f;0.9,0.9;csd_tasks_asteroid.png;a%d;]"):format(r.x, r.y, id)
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for id in pairs(st.rocks) do
			if fields["a" .. id] then
				st.rocks[id] = nil
				st.hits = st.hits + 1
				core.sound_play("csd_tasks_zap", {to_player = sess.name, gain = 0.4}, true)
				-- Something out there actually fires (csd_ship's turrets).
				for _, func in ipairs(csd_tasks.on_asteroid_shot) do func(sess) end
				if st.hits >= st.need then return "done" end
				return
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Shields: click every red hex until the whole grid is primed.
------------------------------------------------------------------------------

reg("shields", {
	title = S("Prime Shields"),
	size = {8, 6},
	init = function(sess)
		local st = {}
		for i = 1, 9 do st[i] = math.random() < 0.6 end
		st[math.random(9)] = true
		sess.state = st
	end,
	render = function(sess)
		local fs = {label(0.5, 0.3, S("Prime every red panel."), "#c0cce0")}
		for i = 1, 9 do
			local x = 1.3 + ((i - 1) % 3) * 1.8 + (math.floor((i - 1) / 3) % 2) * 0.4
			local y = 0.8 + math.floor((i - 1) / 3) * 1.55
			fs[#fs + 1] = button(x, y, 1.5, 1.35, "h" .. i, "", sess.state[i] and "#c03030" or "#e0e8f0")
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		for i = 1, 9 do
			if fields["h" .. i] and sess.state[i] then
				sess.state[i] = false
				for j = 1, 9 do
					if sess.state[j] then return end
				end
				return "done"
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Rations: pick the three ingredients on the order ticket.
------------------------------------------------------------------------------

local INGREDIENTS = {S("Algae paste"), S("Soy protein"), S("Tomato"), S("Noodles"), S("Spice mix"), S("Flatbread")}

reg("rations", {
	title = S("Prepare Rations"),
	size = {9, 5.5},
	init = function(sess)
		local pick = shuffled({1, 2, 3, 4, 5, 6})
		sess.state = {order = {pick[1], pick[2], pick[3]}, got = {}}
	end,
	render = function(sess)
		local st = sess.state
		local names = {}
		for _, i in ipairs(st.order) do
			names[#names + 1] = (st.got[i] and "[x] " or "[ ] ") .. INGREDIENTS[i]
		end
		local fs = {label(0.5, 0.3, S("Order: @1", table.concat(names, ",  ")), "#ffdd88")}
		for i = 1, 6 do
			local x = 0.5 + ((i - 1) % 3) * 2.75
			local y = 1.0 + math.floor((i - 1) / 3) * 1.5
			fs[#fs + 1] = button(x, y, 2.5, 1.2, "i" .. i, INGREDIENTS[i], st.got[i] and "#2a5a2a" or "#4a3a2a")
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local st = sess.state
		for i = 1, 6 do
			if fields["i" .. i] then
				local wanted = false
				for _, o in ipairs(st.order) do
					if o == i then wanted = true end
				end
				if not wanted then
					sess.message = core.colorize("#ff6060", S("That's not on the order. Start over."))
					st.got = {}
					return
				end
				st.got[i] = true
				for _, o in ipairs(st.order) do
					if not st.got[o] then return end
				end
				return "done"
			end
		end
	end,
})

------------------------------------------------------------------------------
-- Samples: start the centrifuge, come back when it's done.
-- Progress lives in the task step (sess.opts.step), not the session.
------------------------------------------------------------------------------

local SAMPLE_TIME = 45

reg("samples", {
	title = S("Analyse Samples"),
	size = {9, 4},
	tick = 1,
	init = function(sess) end,
	on_tick = function(sess)
		if not sess.opts.step or not sess.opts.step.started then return "keep" end
	end,
	render = function(sess)
		local step = sess.opts.step or {}
		local fs = {}
		if not step.started then
			fs[#fs + 1] = label(0.5, 0.3, S("Start the analysis. It takes a while - go do something else."), "#c0cce0")
			fs[#fs + 1] = button(3, 1.5, 3, 0.9, "start", S("Start"), "#2a6a8a")
		else
			local left = SAMPLE_TIME - (os.time() - step.started)
			fs[#fs + 1] = bar(0.5, 0.9, 8, 0.8, 1 - math.max(0, left) / SAMPLE_TIME, "#cc88ff")
			if left > 0 then
				fs[#fs + 1] = label(0.5, 0.3, S("Analysing... @1 s left. You can leave and come back.", left), "#c0cce0")
			else
				fs[#fs + 1] = label(0.5, 0.3, S("Analysis complete."), "#9fe8ff")
				fs[#fs + 1] = button(3, 2, 3, 0.9, "collect", S("Collect results"), "#2a8a4a")
			end
		end
		return table.concat(fs)
	end,
	fields = function(sess, fields)
		local step = sess.opts.step
		if not step then return "fail" end
		if fields.start and not step.started then
			step.started = os.time()
		elseif fields.collect and step.started and os.time() - step.started >= SAMPLE_TIME then
			return "done"
		end
	end,
})
