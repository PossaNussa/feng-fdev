-- Tasks: what each crew member is asked to do, and the HUD that shows it.
--
-- A task is one or more steps; each step is "use N different stations of
-- kind K". Players get a handful of tasks, weighted towards their job. When
-- they finish them all they get a fresh set. Anyone can also use any station
-- as a small voluntary repair, so there's always something to do.

local S = csd_tasks.S

------------------------------------------------------------------------------
-- Station kinds
------------------------------------------------------------------------------

-- extra: need = item used up, give = item handed over, tool = item worn
-- (watering can), on_complete(player, pos), screens = per-look textures
local function station(kind, description, minigame, shape, screen, extra)
	local def = {
		description = description, minigame = minigame, shape = shape,
		screen = "csd_tasks_screen_" .. (screen or kind) .. ".png",
	}
	for k, v in pairs(extra or {}) do def[k] = v end
	csd_tasks.register_station_kind(kind, def)
end

local VENT = {normal = "csd_tasks_vent.png", ok = "csd_tasks_vent_clean.png", warn = "csd_tasks_vent_clogged.png"}

-- Rations go into the nearest serving counter (mess hall) for anyone to eat.
local function serve_rations(player, pos)
	local counter = core.global_exists("csd_ship") and csd_ship.nearest_counter
		and csd_ship.nearest_counter(pos) or core.find_node_near(pos, 40, {"group:csd_serving"})
	local stack = ItemStack("csd_tasks:ration 4")
	if counter then
		local inv = core.get_meta(counter):get_inventory()
		stack = inv:add_item("main", stack)
		if core.global_exists("csd_ship") and csd_ship.refresh_counter then csd_ship.refresh_counter(counter) end
		core.chat_send_player(player:get_player_name(), S("Four rations are out on the serving counter in the mess hall."))
	end
	if not stack:is_empty() then
		local left = player:get_inventory():add_item("main", stack)
		if not left:is_empty() then core.add_item(player:get_pos(), left) end
	end
end

station("wiring",          S("Wiring Panel"),        "wires",     "wall")
station("nav_console",     S("Navigation Console"),  "calibrate", "console")
station("reactor_console", S("Reactor Console"),     "sequence",  "console")
station("id_reader",       S("ID Card Reader"),      "swipe",     "wall")
station("o2_filter",       S("Oxygen Filter"),       "debris",    "vent", nil, {screens = VENT})
station("air_vent",        S("Air Vent"),            "debris",    "vent", nil, {screens = VENT})
station("comms_terminal",  S("Comms Terminal"),      "download",  "console", nil, {on_complete = function(player)
	local left = player:get_inventory():add_item("main", csd_tasks.make_data_chip())
	if not left:is_empty() then core.add_item(player:get_pos(), left) end
end})
station("nav_upload",      S("Data Uplink"),         "upload",    "console", nil,
	{need = "csd_tasks:data_chip", need_msg = S("You need a Data Chip - download one at a Comms Terminal.")})
station("med_scanner",     S("Medbay Scanner"),      "scan",      "pad")
station("planter",         S("Hydroponic Planter"),  "water",     "planter", nil, {
	tool = "wateringcan:wateringcan_water",
	tool_msg = S("You need a filled watering can - fill one at a water tap in Hydroponics."),
	screens = {normal = "csd_tasks_screen_planter.png", ok = "csd_tasks_planter_lush.png", warn = "csd_tasks_planter_dry.png"},
})
station("fuel_pump",       S("Fuel Pump"),           "fuel",      "console", nil, {give = "csd_tasks:fuel_cell"})
station("engine_port",     S("Engine Fuel Port"),    "fuel",      "wall", nil,
	{need = "csd_tasks:fuel_cell", need_msg = S("You need a Fuel Cell - fill one at a Fuel Pump.")})
station("garbage_chute",   S("Garbage Chute"),       "trash",     "wall")
station("weapons_console", S("Weapons Console"),     "asteroids", "console")
station("shield_console",  S("Shield Console"),      "shields",   "console")
station("galley_station",  S("Galley Station"),      "rations",   "console", nil, {on_complete = serve_rations})
station("centrifuge",      S("Sample Centrifuge"),   "samples",   "console")
station("hull_panel",      S("Damaged Hull Panel"),  "weld",      "vent", nil, {
	need = "csd_tasks:hull_patch",
	need_msg = S("You need a Hull Patch - press Scrap Metal in the Machine Shop (crates have scrap)."),
	screens = {normal = "csd_tasks_hull_panel.png", ok = "csd_tasks_hull_panel_fixed.png", warn = "csd_tasks_hull_panel_broken.png"},
})

-- Requirement checks and results (used by tasks and voluntary repairs alike)
function csd_tasks.check_station(sdef, player)
	local inv = player:get_inventory()
	if sdef.need and not inv:contains_item("main", sdef.need) then
		return false, sdef.need_msg
	end
	if sdef.tool and core.registered_items[sdef.tool] and not inv:contains_item("main", sdef.tool) then
		return false, sdef.tool_msg
	end
	return true
end

function csd_tasks.station_results(sdef, player, pos)
	local inv = player:get_inventory()
	if sdef.need then inv:remove_item("main", sdef.need) end
	if sdef.tool and core.registered_items[sdef.tool] then
		for i, stack in ipairs(inv:get_list("main")) do
			if stack:get_name() == sdef.tool then
				local wear = stack:get_wear() + 2849 -- a watering can holds 24 waterings
				if wear > 65535 then
					stack = ItemStack("wateringcan:wateringcan_empty")
				else
					stack:set_wear(wear)
				end
				inv:set_stack("main", i, stack)
				break
			end
		end
	end
	if sdef.give then
		local left = inv:add_item("main", sdef.give)
		if not left:is_empty() then core.add_item(player:get_pos(), left) end
	end
	if sdef.on_complete then sdef.on_complete(player, pos) end
end

------------------------------------------------------------------------------
-- Task definitions
------------------------------------------------------------------------------

csd_tasks.tasks = {}

-- def = {title, system, reward, jobs = {...}, steps = {{kind = "planter", count = 4}, ...}}
function csd_tasks.register_task(id, def)
	def.id = id
	def.reward = def.reward or 12
	def.jobs = def.jobs or {}
	for _, step in ipairs(def.steps) do
		step.count = step.count or 1
	end
	csd_tasks.tasks[id] = def
end

local reg = csd_tasks.register_task
reg("fix_wiring",      {title = S("Fix Wiring"),          system = "power",        jobs = {"engineer", "custodian"}, steps = {{kind = "wiring", count = 2}}})
reg("start_reactor",   {title = S("Start Reactor"),       system = "power",        jobs = {"engineer"},              steps = {{kind = "reactor_console"}}, reward = 15})
reg("refuel",          {title = S("Refuel Engines"),      system = "power",        jobs = {"engineer"},              steps = {{kind = "fuel_pump"}, {kind = "engine_port"}}, reward = 18})
reg("calibrate_nav",   {title = S("Calibrate Navigation"),system = "navigation",   jobs = {"navigator"},             steps = {{kind = "nav_console"}}})
reg("download_data",   {title = S("Download & Upload Data"), system = "comms",     jobs = {"navigator", "scientist"},steps = {{kind = "comms_terminal"}, {kind = "nav_upload"}}, reward = 18})
reg("swipe_card",      {title = S("Swipe ID Card"),       system = "comms",        jobs = {"security"},              steps = {{kind = "id_reader"}}, reward = 8})
reg("clean_o2",        {title = S("Clean Oxygen Filter"), system = "life_support", jobs = {"botanist", "custodian"},  steps = {{kind = "o2_filter"}}})
reg("clean_vents",     {title = S("Clean Air Vents"),     system = "life_support", jobs = {"custodian"},             steps = {{kind = "air_vent", count = 2}}})
reg("med_scan",        {title = S("Submit Medbay Scan"),  system = "life_support", jobs = {"medic"},                 steps = {{kind = "med_scanner"}}, reward = 8})
reg("analyse_samples", {title = S("Analyse Samples"),     system = "life_support", jobs = {"scientist", "medic"},    steps = {{kind = "centrifuge"}}, reward = 15})
reg("water_plants",    {title = S("Water Plants"),        system = "hydroponics",  jobs = {"botanist"},              steps = {{kind = "planter", count = 4}}, reward = 16})
reg("empty_garbage",   {title = S("Empty Garbage"),       system = "hull",         jobs = {"custodian", "cook"},     steps = {{kind = "garbage_chute"}}, reward = 8})
reg("clear_asteroids", {title = S("Clear Asteroids"),     system = "hull",         jobs = {"security", "navigator"}, steps = {{kind = "weapons_console"}}})
reg("prime_shields",   {title = S("Prime Shields"),       system = "hull",         jobs = {"navigator", "security"}, steps = {{kind = "shield_console"}}})
reg("prepare_rations", {title = S("Prepare Rations"),     system = "morale",       jobs = {"cook"},                  steps = {{kind = "galley_station"}}})
reg("repair_hull",     {title = S("Repair Hull Panels"),  system = "hull",         jobs = {"engineer", "custodian"}, steps = {{kind = "hull_panel", count = 2}}, reward = 16})

------------------------------------------------------------------------------
-- Per-player task lists (stored in player meta)
------------------------------------------------------------------------------

local TASKS_PER_PLAYER = tonumber(core.settings:get("csd_tasks_per_player")) or 5
local NEW_TASKS_DELAY = 30
local VOLUNTARY_COOLDOWN = 90
local VOLUNTARY_REWARD = 3

local function get_list(player)
	return core.deserialize(player:get_meta():get_string("csd_tasks:list")) or {}
end

local function save_list(player, list)
	player:get_meta():set_string("csd_tasks:list", core.serialize(list))
end

local function task_available(def)
	for _, step in ipairs(def.steps) do
		if #csd_tasks.get_stations(step.kind) < step.count then
			return false
		end
	end
	return true
end

function csd_tasks.assign_tasks(player)
	local job = csd_core.get_job(player:get_player_name())
	local pool, total = {}, 0
	for id, def in pairs(csd_tasks.tasks) do
		if task_available(def) then
			local w = 1
			for _, j in ipairs(def.jobs) do
				if j == job then w = 4 end
			end
			pool[#pool + 1] = {id = id, w = w}
			total = total + w
		end
	end
	table.sort(pool, function(a, b) return a.id < b.id end)
	local list = {}
	for _ = 1, math.min(TASKS_PER_PLAYER, #pool) do
		local r = math.random() * total
		for i, entry in ipairs(pool) do
			r = r - entry.w
			if r <= 0 then
				list[#list + 1] = {id = entry.id, step = 1, progress = 0, visited = {}}
				total = total - entry.w
				table.remove(pool, i)
				break
			end
		end
	end
	save_list(player, list)
	csd_tasks.update_hud(player)
	return list
end

local function is_done(entry)
	local def = csd_tasks.tasks[entry.id]
	return not def or entry.step > #def.steps
end

local stats_storage = core.get_mod_storage()

local function add_stat(name, n)
	local stats = core.deserialize(stats_storage:get_string("crew_stats")) or {}
	stats[name] = (stats[name] or 0) + n
	stats_storage:set_string("crew_stats", core.serialize(stats))
	return stats[name]
end

local complete_callbacks = {}
-- func(player, task_id, total_completed)
function csd_tasks.register_on_task_complete(func)
	table.insert(complete_callbacks, func)
end

local pending_new = {}

local function finish_task(player, entry)
	local name = player:get_player_name()
	local def = csd_tasks.tasks[entry.id]
	csd_tasks.add_system(def.system, def.reward)
	local total = add_stat(name, 1)
	core.chat_send_player(name, core.colorize("#7dffa0",
		S("Task complete: @1 (+@2 @3)", def.title, def.reward, csd_tasks.systems[def.system].title)))
	for _, func in ipairs(complete_callbacks) do
		func(player, entry.id, total)
	end
end

local function all_done(list)
	for _, entry in ipairs(list) do
		if not is_done(entry) then return false end
	end
	return true
end

-- Advance the player's current step of `kind` because they finished it at
-- `pos`. Returns true if it counted towards one of their tasks.
function csd_tasks.progress_step(player, kind, pos)
	local list = get_list(player)
	local h = core.pos_to_string(vector.round(pos))
	for _, entry in ipairs(list) do
		local def = csd_tasks.tasks[entry.id]
		local step = def and def.steps[entry.step]
		if step and step.kind == kind and not entry.visited[h] then
			entry.visited[h] = true
			entry.progress = entry.progress + 1
			entry.started = nil
			if entry.progress >= step.count then
				entry.step, entry.progress, entry.visited = entry.step + 1, 0, {}
				if entry.step > #def.steps then
					finish_task(player, entry)
				else
					core.chat_send_player(player:get_player_name(), S("Next: @1", csd_tasks.step_text(entry)))
				end
			end
			save_list(player, list)
			csd_tasks.update_hud(player)
			local name = player:get_player_name()
			if all_done(list) and not pending_new[name] then
				pending_new[name] = true
				core.chat_send_player(name, core.colorize("#7dffa0",
					S("All tasks done - thanks! New ones arrive in @1 seconds.", NEW_TASKS_DELAY)))
				core.after(NEW_TASKS_DELAY, function()
					pending_new[name] = nil
					local p = core.get_player_by_name(name)
					if p and all_done(get_list(p)) then
						csd_tasks.assign_tasks(p)
						core.chat_send_player(name, S("New tasks have been assigned."))
					end
				end)
			end
			return true
		end
	end
	return false
end

-- Hooks that get first go at a station use (csd_events uses this for
-- malfunction consoles). func(pos, kind, player) -> true if handled.
local use_hooks = {}
function csd_tasks.register_on_station_use(func)
	table.insert(use_hooks, func)
end

local voluntary = {} -- name -> {hash -> time}

function csd_tasks.use_station(pos, kind, player)
	for _, hook in ipairs(use_hooks) do
		if hook(pos, kind, player) then return end
	end
	local name = player:get_player_name()
	local sdef = csd_tasks.station_kinds[kind]
	if not sdef or not sdef.minigame then return end

	local list = get_list(player)
	local h = core.pos_to_string(vector.round(pos))
	local mine, already
	for _, entry in ipairs(list) do
		local def = csd_tasks.tasks[entry.id]
		local step = def and def.steps[entry.step]
		if step and step.kind == kind then
			if entry.visited[h] then
				already = true
			else
				mine = entry
				break
			end
		end
	end

	if mine or not already then
		local ok_req, msg = csd_tasks.check_station(sdef, player)
		if not ok_req then
			core.chat_send_player(name, core.colorize("#ffb347", msg or S("You're missing something for this.")))
			return
		end
	end

	if mine then
		csd_tasks.start_minigame(player, sdef.minigame, pos, function(p, ok)
			if ok then
				csd_tasks.station_results(sdef, p, pos)
				csd_tasks.progress_step(p, kind, pos)
				csd_tasks.mark_fixed(pos)
			else
				-- Keep timers like sample analysis.
				local l = get_list(p)
				for _, e in ipairs(l) do
					if e.id == mine.id and e.step == mine.step then
						e.started = mine.started
					end
				end
				save_list(p, l)
			end
		end, {step = mine})
		return
	end
	if already then
		core.chat_send_player(name, S("You've done this one already - find another @1.", sdef.description))
		return
	end

	-- Voluntary repair
	voluntary[name] = voluntary[name] or {}
	local last = voluntary[name][h]
	if last and os.time() - last < VOLUNTARY_COOLDOWN then
		core.chat_send_player(name, S("This station is running fine. Check back later."))
		return
	end
	-- Which system does this station help? The first task that uses it.
	local system
	for _, def in pairs(csd_tasks.tasks) do
		for _, step in ipairs(def.steps) do
			if step.kind == kind then system = def.system end
		end
	end
	csd_tasks.start_minigame(player, sdef.minigame, pos, function(p, ok)
		if ok and system then
			csd_tasks.station_results(sdef, p, pos)
			csd_tasks.mark_fixed(pos)
			voluntary[name][h] = os.time()
			csd_tasks.add_system(system, VOLUNTARY_REWARD)
			core.chat_send_player(name, core.colorize("#9fe8ff",
				S("Thanks for pitching in (+@1 @2).", VOLUNTARY_REWARD, csd_tasks.systems[system].title)))
		end
	end, {step = {}})
end

------------------------------------------------------------------------------
-- HUD
------------------------------------------------------------------------------

local huds = {} -- name -> {list = id, waypoint = id, systems = {...}}

function csd_tasks.step_text(entry)
	local def = csd_tasks.tasks[entry.id]
	local step = def.steps[entry.step]
	if not step then return def.title end
	local sk = csd_tasks.station_kinds[step.kind]
	local txt = sk and sk.description or step.kind
	if step.count > 1 then
		txt = txt .. (" (%d/%d)"):format(entry.progress, step.count)
	end
	return txt
end

local function list_text(player, list)
	local lines = {S("TASKS")}
	local pos = player:get_pos()
	for _, entry in ipairs(list) do
		local def = csd_tasks.tasks[entry.id]
		if def then
			if is_done(entry) then
				lines[#lines + 1] = "[x] " .. def.title
			else
				local step = def.steps[entry.step]
				local where = ""
				local st = csd_tasks.nearest_station(step.kind, pos, entry.visited)
				if st then where = " - " .. (st.room or "?") end
				local multi = #def.steps > 1 and (" [%d/%d]"):format(entry.step, #def.steps) or ""
				lines[#lines + 1] = "[ ] " .. def.title .. multi .. ": " .. csd_tasks.step_text(entry) .. where
			end
		end
	end
	if #list == 0 then
		lines[#lines + 1] = S("(none - new tasks soon)")
	end
	return table.concat(lines, "\n")
end

-- One target per unfinished task: the nearest station for its current step.
local function task_targets(player, list)
	local pos = player:get_pos()
	local out = {}
	for i, entry in ipairs(list) do
		if not is_done(entry) then
			local step = csd_tasks.tasks[entry.id].steps[entry.step]
			local st = csd_tasks.nearest_station(step.kind, pos, entry.visited)
			if st then out[i] = {station = st, entry = entry} end
		end
	end
	return out
end

local WAYPOINT_COLORS = {0x7dffa0, 0x7dd8ff, 0xffd27d, 0xff9de0, 0xc8a0ff, 0xa0fff0, 0xffb07d}

local function system_color(v)
	if v < 25 then return 0xff4444 elseif v < 50 then return 0xffaa33 end
	return 0x88ffaa
end

local function ensure_hud(player)
	local name = player:get_player_name()
	if huds[name] then return huds[name] end
	local h = {systems = {}}
	h.list = player:hud_add({
		type = "text", position = {x = 0.005, y = 0.25}, alignment = {x = 1, y = 1},
		offset = {x = 8, y = 0}, number = 0xe8f0ff, text = "", z_index = 10,
		style = 0,
	})
	h.systems_title = player:hud_add({
		type = "text", position = {x = 1, y = 0.25}, alignment = {x = -1, y = 1},
		offset = {x = -12, y = -22}, number = 0x9fe8ff, text = S("SHIP SYSTEMS"), z_index = 10,
	})
	for i, id in ipairs(csd_tasks.system_order) do
		local y = (i - 1) * 22
		h.systems[id] = {
			bg = player:hud_add({
				type = "image", position = {x = 1, y = 0.25}, alignment = {x = 1, y = 1},
				offset = {x = -112, y = y + 4}, scale = {x = 1, y = 1}, text = "csd_tasks_bar_bg.png", z_index = 9,
			}),
			fg = player:hud_add({
				type = "image", position = {x = 1, y = 0.25}, alignment = {x = 1, y = 1},
				offset = {x = -110, y = y + 6}, scale = {x = 1, y = 1}, text = "csd_tasks_bar_fg.png", z_index = 10,
			}),
			label = player:hud_add({
				type = "text", position = {x = 1, y = 0.25}, alignment = {x = -1, y = 1},
				offset = {x = -120, y = y}, number = 0xffffff, text = "", z_index = 10,
			}),
		}
	end
	huds[name] = h
	return h
end

function csd_tasks.update_system_hud(player)
	local h = ensure_hud(player)
	for _, id in ipairs(csd_tasks.system_order) do
		local v = csd_tasks.get_system(id)
		local e = h.systems[id]
		player:hud_change(e.label, "text", ("%s %d%%"):format(csd_tasks.systems[id].title, math.floor(v + 0.5)))
		player:hud_change(e.label, "number", system_color(v))
		-- The bar image is 100 px wide: scale it by the level.
		player:hud_change(e.fg, "scale", {x = math.max(0.01, v / 100), y = 1})
		player:hud_change(e.fg, "text", ("csd_tasks_bar_fg.png^[multiply:#%06x"):format(system_color(v)))
	end
end

function csd_tasks.update_hud(player)
	local name = player:get_player_name()
	local h = ensure_hud(player)
	local list = get_list(player)
	player:hud_change(h.list, "text", list_text(player, list))
	-- A waypoint for every unfinished task, each in its own colour.
	h.waypoints = h.waypoints or {}
	local targets = task_targets(player, list)
	for i = 1, math.max(#list, 12) do -- (waypoints may have holes, so no #)
		local t, id = targets[i], h.waypoints[i]
		if t then
			local title = csd_tasks.tasks[t.entry.id].title
			if id then
				player:hud_change(id, "world_pos", t.station.pos)
				player:hud_change(id, "name", title)
			else
				h.waypoints[i] = player:hud_add({
					type = "waypoint", name = title, text = "m", precision = 1,
					number = WAYPOINT_COLORS[(i - 1) % #WAYPOINT_COLORS + 1],
					world_pos = vector.offset(t.station.pos, 0, 0.6, 0), z_index = 5,
				})
			end
		elseif id then
			player:hud_remove(id)
			h.waypoints[i] = nil
		end
	end
	huds[name] = h
end

local hud_dirty = false
csd_tasks.register_on_system_change(function()
	hud_dirty = true
end)

local hud_timer = 0
core.register_globalstep(function(dtime)
	hud_timer = hud_timer + dtime
	if hud_timer < 2 then return end
	hud_timer = 0
	local systems = hud_dirty
	hud_dirty = false
	for _, player in ipairs(core.get_connected_players()) do
		-- Room names and nearest-station targets change as people walk.
		csd_tasks.update_hud(player)
		if systems then csd_tasks.update_system_hud(player) end
	end
end)

core.register_on_joinplayer(function(player)
	core.after(1, function()
		if not player:is_player() then return end
		local list = get_list(player)
		if #list == 0 or all_done(list) then
			csd_tasks.assign_tasks(player)
		end
		csd_tasks.update_hud(player)
		csd_tasks.update_system_hud(player)
	end)
end)

core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	huds[name] = nil
	voluntary[name] = nil
	pending_new[name] = nil
end)

csd_core.register_on_job_change(function(player, _, old)
	-- First job pick: re-roll the starter tasks so they match the job.
	if not old then
		csd_tasks.assign_tasks(player)
	end
end)

------------------------------------------------------------------------------
-- Commands
------------------------------------------------------------------------------

core.register_chatcommand("tasks", {
	params = "[new]",
	description = S("List your tasks (\"new\" re-rolls them, needs server privilege)"),
	func = function(name, param)
		local player = core.get_player_by_name(name)
		if not player then return false end
		if param == "new" then
			if not core.check_player_privs(name, {server = true}) then
				return false, S("You need the server privilege.")
			end
			csd_tasks.assign_tasks(player)
		end
		return true, list_text(player, get_list(player))
	end,
})

core.register_chatcommand("crewstats", {
	description = S("Who has done the most tasks"),
	func = function()
		local stats = core.deserialize(stats_storage:get_string("crew_stats")) or {}
		local rows = {}
		for n, c in pairs(stats) do rows[#rows + 1] = {n, c} end
		table.sort(rows, function(a, b) return a[2] > b[2] end)
		local out = {S("Tasks completed:")}
		for i = 1, math.min(10, #rows) do
			out[#out + 1] = ("%d. %s - %d"):format(i, rows[i][1], rows[i][2])
		end
		return true, table.concat(out, "\n")
	end,
})

core.register_chatcommand("stations", {
	description = S("Count the task stations aboard"),
	privs = {builder = true},
	func = function()
		local out = {}
		local kinds = {}
		for kind in pairs(csd_tasks.station_kinds) do kinds[#kinds + 1] = kind end
		table.sort(kinds)
		for _, kind in ipairs(kinds) do
			out[#out + 1] = kind .. "=" .. #csd_tasks.get_stations(kind)
		end
		return true, table.concat(out, ", ")
	end,
})
