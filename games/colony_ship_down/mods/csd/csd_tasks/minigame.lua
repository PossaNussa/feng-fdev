-- Mini-game sessions: one formspec per player that can redraw itself on a
-- timer (for sequences, progress bars, moving targets).
--
-- csd_tasks.register_minigame(id, {
--   title = "Fix Wiring",
--   size = {10, 7},                         -- formspec size
--   init = function(sess) end,              -- set up sess.state
--   render = function(sess) return "..." end,  -- formspec elements below the title bar
--   fields = function(sess, fields) end,    -- return "done", "fail", "keep" (no redraw) or nil (redraw)
--   tick = 0.5, on_tick = function(sess) end,  -- optional; same returns as fields
-- })
--
-- csd_tasks.start_minigame(player, id, pos, function(player, ok) ... end)

local S = csd_tasks.S

csd_tasks.minigames = {}
local sessions = {}
local FORMNAME = "csd_tasks:minigame"
local MAX_DISTANCE = 5

function csd_tasks.register_minigame(id, def)
	def.id = id
	csd_tasks.minigames[id] = def
end

local function header(sess)
	local def = csd_tasks.minigames[sess.id]
	local w, h = def.size[1], def.size[2]
	return table.concat({
		"formspec_version[6]",
		"size[", w, ",", h + 1, "]",
		"no_prepend[]",
		"bgcolor[#00000099;true]",
		"background9[0,0;", w, ",", h + 1, ";csd_tasks_panel.png;true;8]",
		"style_type[label;font_size=*1.1]",
		"label[0.4,0.5;", core.colorize("#9fe8ff", core.formspec_escape(def.title)), "]",
		sess.message and ("label[0.4,1.0;" .. core.formspec_escape(sess.message) .. "]") or "",
		"style[csd_close;bgcolor=#5a2030]",
		"button_exit[", w - 1.1, ",0.2;0.8,0.6;csd_close;X]",
		"container[0,1.2]",
	})
end

local function show(name)
	local sess = sessions[name]
	if not sess then return end
	local def = csd_tasks.minigames[sess.id]
	core.show_formspec(name, FORMNAME, header(sess) .. def.render(sess) .. "container_end[]")
end

local function finish(name, ok)
	local sess = sessions[name]
	if not sess then return end
	sessions[name] = nil
	local player = core.get_player_by_name(name)
	if ok then
		core.close_formspec(name, FORMNAME)
		if player then
			core.sound_play("csd_tasks_done", {to_player = name, gain = 0.6}, true)
		end
	end
	if sess.on_done and player then
		sess.on_done(player, ok, sess)
	end
end

local function handle(name, result)
	if result == "done" then
		finish(name, true)
	elseif result == "fail" then
		finish(name, false)
		core.close_formspec(name, FORMNAME)
	elseif result ~= "keep" and sessions[name] then
		show(name)
	end
end

function csd_tasks.start_minigame(player, id, pos, on_done, opts)
	local name = player:get_player_name()
	local def = csd_tasks.minigames[id]
	if not def then return false end
	if sessions[name] then
		finish(name, false)
	end
	local sess = {
		id = id, name = name, pos = vector.copy(pos), on_done = on_done,
		state = {}, elapsed = 0, tick_timer = 0, opts = opts or {},
	}
	sessions[name] = sess
	if def.init then def.init(sess) end
	show(name)
	return true
end

function csd_tasks.get_minigame_session(name)
	return sessions[name]
end

function csd_tasks.abort_minigame(name)
	if sessions[name] then
		finish(name, false)
		core.close_formspec(name, FORMNAME)
	end
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then return end
	local name = player:get_player_name()
	local sess = sessions[name]
	if not sess then return true end
	if fields.quit or fields.csd_close then
		finish(name, false)
		return true
	end
	sess.message = nil
	local def = csd_tasks.minigames[sess.id]
	handle(name, def.fields and def.fields(sess, fields))
	return true
end)

local check_timer = 0
core.register_globalstep(function(dtime)
	check_timer = check_timer + dtime
	local check = check_timer >= 0.5
	if check then check_timer = 0 end
	for name, sess in pairs(sessions) do
		local def = csd_tasks.minigames[sess.id]
		sess.elapsed = sess.elapsed + dtime
		if check then
			local player = core.get_player_by_name(name)
			if not player or vector.distance(player:get_pos(), sess.pos) > (def.max_distance or MAX_DISTANCE) then
				if player then
					core.chat_send_player(name, S("You walked away from the station."))
				end
				finish(name, false)
				core.close_formspec(name, FORMNAME)
			end
		end
		if sessions[name] and def.tick then
			sess.tick_timer = sess.tick_timer + dtime
			if sess.tick_timer >= def.tick then
				sess.tick_timer = 0
				handle(name, def.on_tick and def.on_tick(sess))
			end
		end
	end
end)

core.register_on_leaveplayer(function(player)
	sessions[player:get_player_name()] = nil
end)

-- Small helpers for mini-game formspecs ------------------------------------

function csd_tasks.fs_button(x, y, w, h, field, label, color, textcolor)
	return ("style[%s;bgcolor=%s;textcolor=%s]button[%f,%f;%f,%f;%s;%s]"):format(
		field, color or "#2a3a58", textcolor or "#ffffff", x, y, w, h, field, core.formspec_escape(label or ""))
end

function csd_tasks.fs_bar(x, y, w, h, frac, color)
	frac = math.max(0, math.min(1, frac))
	return ("box[%f,%f;%f,%f;#10182a]box[%f,%f;%f,%f;%s]"):format(
		x, y, w, h, x + 0.05, y + 0.05, math.max(0.001, (w - 0.1) * frac), h - 0.1, color or "#44ddff")
end

function csd_tasks.fs_label(x, y, text, color)
	return ("label[%f,%f;%s]"):format(x, y,
		core.formspec_escape(color and core.colorize(color, text) or text))
end
