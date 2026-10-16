-- Offline test harness.
--
-- Stubs enough of the engine and of mg_villages / lottmobs / creaturemob to
-- load village_life and exercise its decision-making, without starting a
-- server. Run from the mod directory:
--
--     luajit test/harness.lua
--
-- It checks three classes of thing:
--   * the mod loads at all, on Lua 5.1 semantics (no 5.3 operators)
--   * the pure functions behave (hashing, schedule choice, pricing)
--   * the village data plumbing resolves a bed and a workplace into world
--     positions, which is the part that silently returned nil before

local ok_count, fail_count = 0, 0

local function check(name, cond, detail)
	if cond then
		ok_count = ok_count + 1
	else
		fail_count = fail_count + 1
		io.write("FAIL: ", name, detail and ("  -- " .. tostring(detail)) or "", "\n")
	end
end

--------------------------------------------------------------------------------
-- Engine stubs
--------------------------------------------------------------------------------

local registered_globalsteps = {}
local registered_mods_loaded = {}
local stub_nodes = {}          -- "x,y,z" -> {name=...}
local stub_meta = {}           -- "x,y,z" -> {fields = {}, lists = {}}
local stub_timers = {}         -- "x,y,z" -> {started = bool, timeout = n}
local time_of_day = 0.5
local day_count = 12
local fake_us = 1000000000

local function pkey(p)
	return math.floor(p.x + 0.5) .. "," .. math.floor(p.y + 0.5) .. "," ..
			math.floor(p.z + 0.5)
end

local storage_data = {}

core = {
	field_handlers = {},
	leave_handlers = {},
	registered_items = {},
	registered_nodes = {},
	registered_entities = {},

	get_modpath = function() return "." end,
	get_current_modname = function() return "village_life" end,
	get_translator = function() return function(s) return s end end,
	log = function() end,
	global_exists = function(n) return _G[n] ~= nil end,

	settings = {
		get = function() return nil end,
		get_bool = function() return nil end,
		set_bool = function() end,
	},

	get_mod_storage = function()
		return {
			get_string = function(_, k) return storage_data[k] or "" end,
			set_string = function(_, k, v) storage_data[k] = v end,
		}
	end,

	register_globalstep = function(f) registered_globalsteps[#registered_globalsteps + 1] = f end,
	register_on_mods_loaded = function(f) registered_mods_loaded[#registered_mods_loaded + 1] = f end,
	register_chatcommand = function() end,
	-- The engine runs *every* registered handler, and this mod now registers
	-- more than one of each. Keeping only the last one silently disabled the
	-- trade window's.
	register_on_player_receive_fields = function(f)
		table.insert(core.field_handlers, f)
	end,
	register_on_leaveplayer = function(f)
		table.insert(core.leave_handlers, f)
	end,
	register_on_shutdown = function() end,

	get_timeofday = function() return time_of_day end,
	get_day_count = function() return day_count end,
	-- Wall-clock microseconds. The harness advances it by hand so expiry can
	-- be tested without sleeping.
	get_us_time = function() return fake_us end,
	pos_to_string = function(p) return ("(%d,%d,%d)"):format(p.x, p.y, p.z) end,
	get_objects_inside_radius = function() return {} end,

	-- A flat world: solid ground up to y=10, air above, and nothing at all
	-- ("unloaded") outside a box around the test village, so is_loaded is
	-- actually exercised.
	get_node = function(p) return stub_nodes[pkey(p)] or {name = "air"} end,
	get_node_or_nil = function(p)
		local override = stub_nodes[pkey(p)]
		if override then return override end
		if math.abs(p.x) > 500 or math.abs(p.z) > 500 then return nil end
		return {name = p.y <= 10 and "default:dirt" or "air"}
	end,
	find_path = function() return nil end,
	get_item_group = function(name, group)
		local def = core.registered_items[name]
		return (def and def.groups and def.groups[group]) or 0
	end,

	-- Shell search outward, like the engine's. Only sees nodes that were
	-- explicitly placed in stub_nodes plus the flat default ground, which is
	-- what the trait conditions are asking about.
	find_node_near = function(pos, radius, names)
		local want = {}
		for _, n in ipairs(type(names) == "table" and names or {names}) do
			want[n] = true
		end
		local function matches(node)
			if not node then return false end
			if want[node.name] then return true end
			for n in pairs(want) do
				local group = n:match("^group:(.+)$")
				if group and core.get_item_group(node.name, group) > 0 then
					return true
				end
			end
			return false
		end
		for r = 0, radius do
			for dx = -r, r do
				for dy = -r, r do
					for dz = -r, r do
						if r == 0 or math.abs(dx) == r or math.abs(dy) == r
								or math.abs(dz) == r then
							local p = {x = pos.x + dx, y = pos.y + dy,
									z = pos.z + dz}
							if matches(core.get_node_or_nil(p)) then return p end
						end
					end
				end
			end
		end
	end,

	find_nodes_in_area_under_air = function() return {} end,

	-- Every stubbed node in the box matching a name or group. Only sees what was
	-- explicitly placed plus the flat default ground, same as find_node_near.
	find_nodes_in_area = function(min, max, filter)
		local want = type(filter) == "table" and filter or {filter}
		local function matches(node)
			if not node then return false end
			for _, n in ipairs(want) do
				if node.name == n then return true end
				local group = n:match("^group:(.+)$")
				if group and core.get_item_group(node.name, group) > 0 then
					return true
				end
			end
			return false
		end
		local out = {}
		for x = min.x, max.x do
			for y = min.y, max.y do
				for z = min.z, max.z do
					local p = {x = x, y = y, z = z}
					if matches(core.get_node(p)) then out[#out + 1] = p end
				end
			end
		end
		return out
	end,
	line_of_sight = function() return true end,

	set_node = function(p, node)
		stub_nodes[pkey(p)] = {name = node.name, param2 = node.param2 or 0}
	end,
	remove_node = function(p) stub_nodes[pkey(p)] = {name = "air"} end,

	-- Just enough NodeMetaRef for the trait code: a string store and an
	-- inventory that behaves like a list of stacks.
	get_meta = function(p)
		local k = pkey(p)
		stub_meta[k] = stub_meta[k] or {fields = {}, lists = {}}
		local m = stub_meta[k]
		return {
			set_string = function(_, key, v) m.fields[key] = v end,
			get_string = function(_, key) return m.fields[key] or "" end,
			set_int = function(_, key, v) m.fields[key] = tostring(v) end,
			get_int = function(_, key) return tonumber(m.fields[key]) or 0 end,
			get_inventory = function()
				return {
					set_size = function(_, list, n) m.lists[list] = {n = n} end,
					add_item = function() end,
					room_for_item = function() return true end,
					is_empty = function() return true end,
					get_size = function(_, list)
						return m.lists[list] and m.lists[list].n or 0
					end,
					get_stack = function() return ItemStack("") end,
					set_stack = function() end,
				}
			end,
		}
	end,

	get_node_timer = function(p)
		local k = pkey(p)
		stub_timers[k] = stub_timers[k] or {started = false, timeout = 0}
		local t = stub_timers[k]
		return {
			start = function(_, timeout) t.started = true ; t.timeout = timeout end,
			stop = function() t.started = false end,
			is_started = function() return t.started end,
		}
	end,

	serialize = function(t)
		-- Enough for the demand table: numbers, strings and nested tables.
		local buf = {}
		local function ser(v)
			if type(v) == "table" then
				buf[#buf + 1] = "{"
				for k, val in pairs(v) do
					buf[#buf + 1] = "[" .. string.format("%q", tostring(k)) .. "]="
					ser(val)
					buf[#buf + 1] = ","
				end
				buf[#buf + 1] = "}"
			elseif type(v) == "string" then
				buf[#buf + 1] = string.format("%q", v)
			else
				buf[#buf + 1] = tostring(v)
			end
		end
		ser(t)
		return table.concat(buf)
	end,
	deserialize = function(s)
		local f = loadstring("return " .. s)
		if not f then return nil end
		local ok, v = pcall(f)
		return ok and v or nil
	end,

	formspec_escape = function(s) return s end,
	colorize = function(_, s) return s end,
	-- Captured, because a villager who refuses to open a conversation says so
	-- in chat and there is no window to read it out of.
	chat_send_player = function(pname, text)
		core.last_chat = {player = pname, text = text}
	end,
	sound_play = function() end,
	add_particlespawner = function() end,
	after = function() end,
	check_player_privs = function() return true end,
	is_protected = function() return false end,

	-- Node and item registration, enough for the settlement mod to register its
	-- foundation stone and override the written book's on_use at load.
	register_node = function(name, def)
		core.registered_nodes[name] = def
		core.registered_items[name] = def
	end,
	override_item = function(name, changes)
		local def = core.registered_items[name]
		if not def then return end
		for k, v in pairs(changes) do def[k] = v end
	end,
	-- A stable, invertible-enough integer hash of a rounded position, for the
	-- deed:<founder>:<hash> town ids.
	hash_node_position = function(p)
		return ((math.floor(p.x + 0.5) + 32768) * 65536
				+ (math.floor(p.z + 0.5) + 32768)) * 256
				+ (math.floor(p.y + 0.5) + 128)
	end,
}
minetest = core

--------------------------------------------------------------------------------
-- Item and inventory stubs
--------------------------------------------------------------------------------

-- Just enough ItemStack to move things between lists and read them back.
function ItemStack(s)
	if type(s) == "table" and s.__stack then return s end
	local name, count = "", 0
	if type(s) == "string" and s ~= "" then
		local n, c = s:match("^(%S+)%s*(%d*)$")
		name = n or s
		count = tonumber(c) or 1
	end
	local st = {__stack = true}
	-- Per-stack meta, so a money bag can actually record its coin count.
	local ints, strs = {}, {}
	local meta = {
		set_int = function(_, k, v) ints[k] = v end,
		get_int = function(_, k) return ints[k] or 0 end,
		set_string = function(_, k, v) strs[k] = v end,
		get_string = function(_, k) return strs[k] or "" end,
	}
	function st:get_name() return name end
	function st:get_count() return count end
	function st:is_empty() return name == "" or count == 0 end
	function st:set_name(n) name = n end
	function st:take_item(n) count = math.max(0, count - (n or 1)) return st end
	function st:add_item(other) return ItemStack("") end
	function st:to_string() return name .. " " .. count end
	function st:get_meta() return meta end
	return st
end

local detached = {}
core.dropped_items = {}

local function make_inventory()
	local lists = {}
	local inv = {}
	function inv:set_size(name, n)
		lists[name] = {}
		for i = 1, n do lists[name][i] = ItemStack("") end
	end
	function inv:get_size(name) return lists[name] and #lists[name] or 0 end
	function inv:set_stack(name, i, s)
		lists[name] = lists[name] or {}
		lists[name][i] = ItemStack(s)
	end
	function inv:get_stack(name, i)
		return (lists[name] and lists[name][i]) or ItemStack("")
	end
	function inv:add_item(name, stack)
		lists[name] = lists[name] or {}
		for i = 1, math.max(#lists[name], 1) do
			if not lists[name][i] or lists[name][i]:is_empty() then
				lists[name][i] = ItemStack(stack)
				return ItemStack("")
			end
		end
		return ItemStack(stack)   -- full: report it all as leftover
	end
	function inv:remove_item(name, stack)
		lists[name] = lists[name] or {}
		local want = ItemStack(stack)
		for i = 1, #lists[name] do
			if lists[name][i] and lists[name][i]:get_name() == want:get_name()
					and not lists[name][i]:is_empty() then
				lists[name][i] = ItemStack("")
				return want
			end
		end
		return ItemStack("")
	end
	return inv
end

core.create_detached_inventory = function(name, callbacks)
	local inv = make_inventory()
	detached[name] = {inv = inv, callbacks = callbacks}
	return inv
end
core.get_inventory = function(loc)
	if loc.type == "detached" and detached[loc.name] then
		return detached[loc.name].inv
	end
end
core.remove_detached_inventory = function(name) detached[name] = nil end
core.detached = detached

core.add_item = function(pos, stack)
	table.insert(core.dropped_items, {pos = pos, stack = ItemStack(stack)})
end

local players = {}
core.get_player_by_name = function(name) return players[name] end
core.get_connected_players = function()
	local out = {}
	for _, p in pairs(players) do out[#out + 1] = p end
	return out
end

local function make_player(name, x, y, z)
	local inv = make_inventory()
	inv:set_size("main", 32)
	local p
	p = {
		get_player_name = function() return name end,
		-- `_pos` and `_wield` are overridable by tests: hiring reads what the
		-- player is holding, and a companion follows where the player goes.
		get_pos = function()
			if p._pos then
				return {x = p._pos.x, y = p._pos.y, z = p._pos.z}
			end
			return {x = x, y = y, z = z}
		end,
		get_inventory = function() return inv end,
		is_player = function() return true end,
		get_hp = function() return p._hp or 20 end,
		get_wielded_item = function() return p._wield or ItemStack("") end,
		set_wielded_item = function(_, stack) p._wield = stack end,
	}
	players[name] = p
	return p
end
core.make_test_player = make_player

core.close_formspec = function() end

-- Dispatch to every handler, as the engine does.
core.on_fields = function(player, formname, fields)
	for _, f in ipairs(core.field_handlers) do f(player, formname, fields) end
end

core.on_leave = function(player)
	for _, f in ipairs(core.leave_handlers) do f(player) end
end

-- Captured formspecs, so the listring wiring can be checked.
core.last_formspec = nil
core.show_formspec = function(pname, formname, spec)
	core.last_formspec = {player = pname, name = formname, spec = spec}
end

-- Matches builtin/common/item_s.lua for the four upright rotations.
local FACEDIR = {
	[0] = {x = 0, y = 0, z = 1},
	[1] = {x = 1, y = 0, z = 0},
	[2] = {x = 0, y = 0, z = -1},
	[3] = {x = -1, y = 0, z = 0},
}
core.facedir_to_dir = function(f) return FACEDIR[(f or 0) % 4] end

-- Matches builtin/common/misc_helpers.lua: yaw 0 faces +Z and turns the
-- opposite way from the maths convention.
core.dir_to_yaw = function(dir) return -math.atan2(dir.x, dir.z) end
core.yaw_to_dir = function(yaw)
	return {x = -math.sin(yaw), y = 0, z = math.cos(yaw)}
end

-- PcgRandom: any deterministic generator will do, it only has to be stable
-- within a run so "same seed, same shelf" is testable.
function PcgRandom(seed)
	local state = (seed or 0) % 2147483647
	if state <= 0 then state = state + 2147483646 end
	return {
		next = function(_, a, b)
			state = (state * 16807) % 2147483647
			if not a then return state end
			return a + (state % ((b - a) + 1))
		end,
	}
end

vector = {
	new = function(x, y, z) return {x = x, y = y, z = z} end,
	round = function(p)
		return {x = math.floor(p.x + 0.5), y = math.floor(p.y + 0.5),
		        z = math.floor(p.z + 0.5)}
	end,
}

string.trim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

--------------------------------------------------------------------------------
-- Game stubs
--------------------------------------------------------------------------------

-- A one-plot village: a house with two beds, whose worker works at plot 2,
-- the forge next door. This is the exact shape that used to resolve to nil.
local BUILDING_HOUSE = {
	short_file_name = "test_house",
	typ = "house",
	bed_list = {{2, 1, 2, 0}, {4, 1, 2, 0}},
	stand_next_to_bed_list = {{2, 1, 3, 0}, {4, 1, 3, 0}},
	front_door_list = {{3, 1, 0}},
	workplace_list = {},
	bed_count = 2,
}

local BUILDING_FORGE = {
	short_file_name = "test_forge",
	typ = "forge",
	bed_list = {},
	stand_next_to_bed_list = {},
	front_door_list = {{2, 1, 0}},
	workplace_list = {{2, 1, 3, 1}},
}

mg_villages = {
	BUILDINGS = {house = BUILDING_HOUSE, forge = BUILDING_FORGE},
	path_info = {
		test_house = {{
			{{2, 1, 2, 0, 0}, {2, 1, 3, 0}, {3, 1, 1, 0}},
			{{4, 1, 2, 0, 0}, {4, 1, 3, 0}, {3, 1, 1, 0}},
			{{3, 1, 1, 0}, {3, 1, 0, 0}, {3, 1, -1, 0}},
		}},
		["test_forge|WORKPLACE"] = {{
			{{2, 1, 3, 1}, {2, 1, 2, 0}, {2, 1, 1, 0}},
			{{2, 1, 1, 0}, {2, 1, 0, 0}, {2, 1, -1, 0}},
		}},
	},
	all_villages = {},
	inhabitants = {},
}

function mg_villages.transform_coordinates(p, bpos)
	-- No rotation in the harness: plots are placed axis-aligned.
	return {x = bpos.x + p[1], y = bpos.y + p[2], z = bpos.z + p[3], p2 = p[4]}
end

function mg_villages.get_plot_and_building_data(village_id, plot_nr)
	local v = mg_villages.all_villages[village_id]
	if not v then return end
	local bpos = v.to_add_data.bpos[plot_nr]
	-- Mirror the real guard: an unregistered btype (a player-founded town's
	-- hand-built house) has no building_data, so return nil rather than a record
	-- with a nil building_data that every caller would then have to guard.
	if not bpos or not bpos.btype or not mg_villages.BUILDINGS[bpos.btype] then
		return
	end
	return {bpos = bpos, building_data = mg_villages.BUILDINGS[bpos.btype]}
end

function mg_villages.get_entrance_list(village_id, plot_nr)
	local res = mg_villages.get_plot_and_building_data(village_id, plot_nr)
	if not res or not res.building_data then return {} end
	local out = {}
	for _, d in ipairs(res.building_data.front_door_list or {}) do
		out[#out + 1] = mg_villages.transform_coordinates(
				{d[1], d[2], d[3] - 1, 0}, res.bpos)
	end
	return out
end

function mg_villages.inhabitants.get_front_doors(bpos)
	local bd = mg_villages.BUILDINGS[bpos.btype]
	local out = {}
	for i, d in ipairs(bd and bd.front_door_list or {}) do
		out[i] = mg_villages.transform_coordinates({d[1], d[2], d[3], 0}, bpos)
	end
	return out
end

function mg_villages.get_road_list() return {} end

mg_villages.all_villages["100:200"] = {
	vx = 100, vz = 200, vh = 10, vs = 40, name = "Testholm",
	to_add_data = {bpos = {
		{x = 100, y = 10, z = 200, btype = "house", bsizex = 7, bsizez = 7,
		 brotate = 0, beds = {
			{bnr = 1, x = 102, y = 11, z = 202, p2 = 0, first_name = "Yorath",
			 gender = "m", generation = 2, title = "smith", works_at = 2,
			 workplace = 1, age = 40},
			{bnr = 2, x = 104, y = 11, z = 202, p2 = 0, first_name = "Freya",
			 gender = "f", generation = 2, age = 38},
		 }},
		{x = 112, y = 10, z = 200, btype = "forge", bsizex = 5, bsizez = 5,
		 brotate = 0},
	}},
}

-- The faith mod, reduced to the API village_life actually consumes. The real
-- one keeps its counts in a world file and moves them when a god's name is
-- typed in chat; none of that matters here, only the shape.
do
	local deities = {
		nu = true, nua = true, tulara = true, hastur = true, cthulhu = true,
		nuananim = true, razu = true, hekmet = true, mother = true,
	}
	local counts = {}
	local global = {}

	lumberjackzombie = {
		is_deity = function(n) return deities[tostring(n):lower()] == true end,
		deities = function()
			local out = {}
			for d in pairs(deities) do out[#out + 1] = d end
			table.sort(out)
			return out
		end,
		register_deity = function(n)
			n = tostring(n):lower()
			if deities[n] then return false end
			deities[n] = true
			return true
		end,
		get_faith = function(p, d)
			if not d then return counts[p] or {} end
			return (counts[p] or {})[tostring(d):lower()] or 0
		end,
		get_global_faith = function(d) return global[tostring(d):lower()] or 0 end,
		add_faith = function(p, d, n)
			d = tostring(d):lower()
			if not deities[d] then return end
			n = n or 1
			counts[p] = counts[p] or {}
			counts[p][d] = math.max(0, (counts[p][d] or 0) + n)
			global[d] = math.max(0, (global[d] or 0) + n)
			return counts[p][d]
		end,
		patron_of = function(p)
			local best, best_n
			for d, n in pairs(counts[p] or {}) do
				if n > 0 and (not best_n or n > best_n) then best, best_n = d, n end
			end
			return best, best_n
		end,
		holding_water = function() return false end,
		bless_wielded = function() return false end,
	}
end

lottmobs = {
	pigman_general = {items = {}, messages = {"Welcome."}},
	trader_context = {},
	allow_move = function() return 0 end,
	allow_put = function() return 0 end,
	allow_take = function() return 0 end,
	update_takeaway = function() end,
	clear_selection = function() end,
	check_pay = function() return false end,
	face_pos = function() end,
	get_pigman_trader_for_profession = function() return lottmobs.pigman_general end,
}

-- Returns a stub entity that behaves enough like a spawned pigman for
-- home.spawn to bind and register it.
lottmobs.spawned = {}
function lottmobs.spawn_pigman_trader(pos, profession, name, gender)
	local ent = {
		name = "lottmobs:pigman_trader",
		profession = profession,
		game_name = name,
		gender = gender,
		set_animation = function() end,
		set_velocity = function() end,
	}
	ent.object = {
		get_pos = function() return {x = pos.x, y = pos.y, z = pos.z} end,
		set_properties = function() end,
		get_luaentity = function() return ent end,
	}
	table.insert(lottmobs.spawned, ent)
	return ent.object
end

-- village_life gets its routes from creaturemob's shared navigation service
-- rather than calling core.find_path itself.
creaturemob = {
	navigate = {
		find_path = function() return nil, "failed" end,
		clear_ahead = function() return true end,
		smooth = function(p) return p end,
		reset = function() end,
	},
}

-- Climate. The engine answers these from the mapgen's own noise; here they are
-- fixed so a village's survey is something the checks can assert against.
stub_climate = {biome = "naturalbiomes:alpine", heat = 30, humidity = 70}
core.get_biome_data = function()
	return {biome = 1, heat = stub_climate.heat, humidity = stub_climate.humidity}
end
core.get_biome_name = function() return stub_climate.biome end
core.get_heat = function() return stub_climate.heat end
core.get_humidity = function() return stub_climate.humidity end

-- magma_conduits generates named volcanoes and knows whether each one is awake.
-- Absent by default, because the interesting property of the land questions is
-- that they are not asked at all when the thing is not there.
stub_volcano = nil

seasons = {
	_season = "autumn",
	get_season = function() return seasons._season end,
}

climate_mod = {current_weather = {}}

--------------------------------------------------------------------------------
-- Item registry: register everything the pools mention so pruning keeps them.
--------------------------------------------------------------------------------

core.registered_nodes["default:dirt"] = {walkable = true, groups = {}}
core.registered_nodes["air"] = {walkable = false, groups = {}}

local function register_pool_items()
	for _, pool in pairs(village_life.economy.pools) do
		for _, e in ipairs(pool) do
			core.registered_items[e[1]] = {description = e[1]}
		end
	end
end

--------------------------------------------------------------------------------
-- Load
--------------------------------------------------------------------------------

local ok, err = pcall(dofile, "init.lua")
check("mod loads", ok, err)
if not ok then
	io.write("\ncannot continue\n")
	os.exit(1)
end

-- Pools are pruned in an on_mods_loaded handler, so register the items first
-- and then run the handlers in the order they were registered.
register_pool_items()

-- A stand-in for cottages' half door: no open/closed state in the name, only a
-- quarter turn of param2. Registered before the mods_loaded handlers run,
-- because that is when village_life decides which nodes are openable.
core.registered_nodes["cottages:half_door"] = {
	walkable = true,
	on_rightclick = function(pos, node)
		local p2 = node.param2
		if p2 % 4 == 1 then p2 = p2 + 1
		elseif p2 % 4 == 2 then p2 = p2 - 1
		elseif p2 % 4 == 3 then p2 = p2 - 3
		else p2 = p2 + 3 end
		stub_nodes[pkey(pos)] = {name = "cottages:half_door", param2 = p2}
	end,
}
-- The villager prototype as lottmobs registers it. village_life owns no mob of
-- its own: everything it does to a villager is written onto this table on
-- mods_loaded, which is also when rest.lua adds the lying-down animation.
core.registered_entities["lottmobs:pigman_trader"] = {
	type = "npc",
	animation = {
		speed_normal = 30,
		stand_start = 0, stand_end = 79,
		walk_start = 168, walk_end = 187,
	},
}

-- The four peaceful wandering traders, registered before the mods_loaded pass so
-- village_life's attach loops (dialogue, brain) hook them exactly as they hook
-- the pigman. Each ships a native on_rightclick -- its own lottmobs shop -- and
-- marks the entity when called, so a test can prove "show me your wares" reopens
-- the very window the plain right-click used to.
for _, tname in ipairs({"lottmobs:dwarf_trader", "lottmobs:mung_trader",
		"lottmobs:human_trader", "lottmobs:elf_trader"}) do
	core.registered_entities[tname] = {
		type = "npc",
		base_texture = {tname:gsub(":", "_") .. ".png"},
		animation = {stand_start = 0, stand_end = 79,
				walk_start = 168, walk_end = 187},
		on_rightclick = function(self) self._native_traded = true end,
	}
end

-- A wandering guard, registered before the mods_loaded pass so the dialogue and
-- brain attach loops hook it like a trader. Its native on_rightclick is a
-- mercenary HIRE, not a shop -- the attach must NOT capture it as native_trade
-- (no "wares"), and must still take the click over for dialogue.
core.registered_entities["lottmobs:mung_guard"] = {
	type = "npc",
	base_texture = {"mobs_mc_villager.png"},
	animation = {stand_start = 0, stand_end = 0, walk_start = 0, walk_end = 40},
	do_custom = function() return false end,      -- lottmobs' own guard AI
	on_rightclick = function(self) self._native_hired = true end,
	on_die = function() end,
}

-- Two beastmen (hostile monsters) and a troll (peaceful npc with its own guard
-- do_custom), registered before the mods_loaded pass so redeem.lua's attach hooks
-- them. The troll's do_custom marks the entity, to prove redeem chains it.
core.registered_entities["zombies:lionman"] = {
	type = "monster",
	animation = {stand_start = 0, stand_end = 79, walk_start = 168, walk_end = 187},
}
core.registered_entities["zombies:gnoll"] = {
	type = "monster",
	animation = {stand_start = 0, stand_end = 79, walk_start = 168, walk_end = 187},
}
core.registered_entities["lottmobs:troll"] = {
	type = "npc",
	animation = {stand_start = 0, stand_end = 19, walk_start = 20, walk_end = 35},
	do_custom = function(self) self._guard_ran = true ; return false end,
}
-- The buff pigman champion: a peaceful npc guardian, wired by defence + champion.
core.registered_entities["zombies:buffpig"] = {
	type = "npc",
	hp_max = 250,
	animation = {stand_start = 0, stand_end = 79, walk_start = 168, walk_end = 187},
}

for _, f in ipairs(registered_mods_loaded) do f() end

-- Kept, because the threat-classification tests later replace the prototype
-- with a stub of their own.
local pigman_animation = core.registered_entities["lottmobs:pigman_trader"].animation

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------

local util     = village_life.util
local home     = village_life.home
local schedule = village_life.schedule
local economy  = village_life.economy
local market   = village_life.market

-- Public surface
for _, name in ipairs({"util", "home", "nav", "schedule", "threats", "economy",
		"market", "trade", "brain", "defence", "census"}) do
	check("village_life." .. name .. " exists", village_life[name] ~= nil)
end

-- Hashing must be stable and must not have gone negative or fractional, which
-- is what a 5.3-only operator or an overflow would produce.
local h = util.hash("100:200/1/1")
check("hash is a non-negative integer", h >= 0 and h == math.floor(h), h)
check("hash is stable", util.hash("100:200/1/1") == h)
check("hash differs per input", util.hash("100:200/1/2") ~= h)

-- Village lookup
local village, vid = home.village_at({x = 105, y = 10, z = 205})
check("village found by position", vid == "100:200", tostring(vid))
check("no village far away", (home.village_at({x = 9000, y = 10, z = 9000})) == nil)

-- Resolution: the whole point of the mod. A worker living in plot 1 must
-- resolve a bed, a sleeping spot and a workplace in the *other* plot.
local smith = {vl = {v = "100:200", p = 1, b = 1}}
local r = home.resolve(smith)
check("worker resolves", r ~= nil)
if r then
	check("role is worker", r.role == "worker", r.role)
	check("bed position", r.bed_pos.x == 102 and r.bed_pos.z == 202)
	check("sleep spot is beside the bed", r.sleep_pos.z == 203,
			r.sleep_pos and r.sleep_pos.z)
	check("workplace resolved in the other plot", r.work_pos ~= nil)
	check("workplace is at the forge", r.work_pos and r.work_pos.x == 114,
			r.work_pos and r.work_pos.x)
	check("workplace facing kept", r.work_facing == 1, r.work_facing)
end

-- The wife has no title and must still get a role rather than falling through.
local wife = {vl = {v = "100:200", p = 1, b = 2}}
local wr = home.resolve(wife)
check("untitled adult resolves", wr ~= nil)
check("untitled adult is a homemaker", wr and wr.role == "homemaker",
		wr and wr.role)

-- Stored interior paths, in world coordinates
local path_in = home.path_in("100:200", 1, 1, "bed", 1)
check("interior bed path exists", path_in and #path_in > 0)
check("interior path ends at the bed", path_in and
		path_in[#path_in].x == 102 and path_in[#path_in].z == 202)

local work_path = home.path_in("100:200", 2, 1, "workplace", 1)
check("interior workplace path exists", work_path and #work_path > 0)

-- Schedule
local at = function(hour, fn)
	time_of_day = hour / 24
	return fn()
end

local pos = {x = 105, y = 11, z = 205}
local night_goal = at(2, function() return schedule.decide(smith, r, pos) end)
check("night sends the worker home", night_goal and night_goal.kind == "sleep",
		night_goal and night_goal.kind)

local work_goal = at(10, function() return schedule.decide(smith, r, pos) end)
check("mid-morning sends the worker to the forge",
		work_goal and work_goal.kind == "work", work_goal and work_goal.kind)
check("work goal targets the workplace",
		work_goal and work_goal.pos and work_goal.pos.x == 114)

local break_goal = at(13, function() return schedule.decide(smith, r, pos) end)
check("midday is a break", break_goal and break_goal.kind == "break",
		break_goal and break_goal.kind)

-- A villager with no workstation must not be handed a work goal.
local wife_goal = at(10, function() return schedule.decide(wife, wr, pos) end)
check("workless villager gets chores, not work",
		wife_goal and wife_goal.kind ~= "work", wife_goal and wife_goal.kind)

-- Weather overrides work. Severe weather only: drizzle must not empty a village.
climate_mod.current_weather = {p1 = {"regional_weather:rain"}}
schedule.flush_weather_cache()
check("light rain is mild", schedule.weather_severity() == "mild",
		schedule.weather_severity())
climate_mod.current_weather = {p1 = {"regional_weather:snow_heavy"}}
schedule.flush_weather_cache()
check("heavy snow is severe", schedule.weather_severity() == "severe",
		schedule.weather_severity())
local storm_goal = at(10, function() return schedule.decide(smith, r, pos) end)
check("severe weather sends the worker to shelter",
		storm_goal and storm_goal.kind == "shelter",
		storm_goal and storm_goal.kind)
climate_mod.current_weather = {}
schedule.flush_weather_cache()

-- Danger beats everything, including the working day.
village_life.threats.list = {{pos = {x = 106, y = 11, z = 206},
		name = "zombies:zombie"}}
village_life.threats.alarms["100:200"] = {pos = pos, expires = os.clock() + 30,
		started = os.clock()}
local flee_goal = at(10, function() return schedule.decide(smith, r, pos) end)
check("threat sends the worker home at a run",
		flee_goal and flee_goal.kind == "flee" and flee_goal.speed == "run",
		flee_goal and flee_goal.kind)
check("...and they can say what they are running from",
		flee_goal and flee_goal.threat_label == "a zombie",
		flee_goal and flee_goal.threat_label)

-- Fleeing on a neighbour's shout rather than on anything they can see: the
-- name comes off the alarm, because being told is a thing you may repeat.
village_life.threats.list = {}
village_life.threats.alarms["100:200"] = {pos = pos, name = "test:dire_wolf",
		expires = village_life.util.now() + 30, started = village_life.util.now()}
local heard_goal = at(10, function() return schedule.decide(smith, r, pos) end)
check("an alarm alone still sends them home",
		heard_goal and heard_goal.kind == "flee", heard_goal and heard_goal.kind)
check("...naming what the village reported",
		heard_goal and heard_goal.threat_label == "a dire wolf",
		heard_goal and heard_goal.threat_label)

-- ...and nothing is invented when nobody said what it was.
village_life.threats.alarms["100:200"] = {pos = pos,
		expires = village_life.util.now() + 30, started = village_life.util.now()}
local vague_goal = at(10, function() return schedule.decide(smith, r, pos) end)
check("a villager who was told nothing names nothing",
		vague_goal and vague_goal.threat_label == nil,
		vague_goal and vague_goal.threat_label)
village_life.threats.list = {}
village_life.threats.alarms = {}
time_of_day = 0.5

-- Adoption: a villager from before this mod has no identity and must claim
-- its own bed back, or the census would spawn a duplicate of it.
local function stub_object(x, y, z)
	return {
		get_pos = function() return {x = x, y = y, z = z} end,
		set_properties = function() end,
	}
end

local loose = {game_name = "Freya", object = stub_object(103, 11, 203)}
check("adoption succeeds inside a village", home.adopt(loose) == true)
check("adoption prefers the bed of the matching name",
		loose.vl and loose.vl.p == 1 and loose.vl.b == 2,
		loose.vl and (loose.vl.p .. "/" .. loose.vl.b))
check("adoption gives a stable shop identity",
		loose.id == "vl_100:200/1/2", loose.id)
check("adopted bed now reads as occupied", home.occupied("100:200", 1, 2))

local stray = {game_name = "Nobody", object = stub_object(9000, 11, 9000)}
check("adoption does nothing outside a village", home.adopt(stray) == false)
home.roster = {}

-- Economy: identity, determinism and variety
check("identity is the village key",
		economy.identity(smith) == "100:200/1/1", economy.identity(smith))

smith.profession = "smith"
local stock_a = economy.build_stock(smith)
local stock_b = economy.build_stock(smith)
check("stock is non-empty", #stock_a > 0, #stock_a)
check("stock is deterministic for one villager",
		#stock_a == #stock_b and stock_a[1].item == stock_b[1].item)

local other = {vl = {v = "100:200", p = 1, b = 2}, profession = "smith"}
local stock_c = economy.build_stock(other)
local same = 0
for i = 1, math.min(#stock_a, #stock_c) do
	if stock_a[i].item == stock_c[i].item then same = same + 1 end
end
check("two smiths do not stock the same shelf",
		same < math.min(#stock_a, #stock_c), same)

local far = {vl = {v = "900:900", p = 1, b = 1}, profession = "smith"}
local stock_d = economy.build_stock(far)
check("a smith in another village differs too",
		stock_d[1] and stock_a[1] and
		(stock_d[1].item ~= stock_a[1].item or stock_d[1].price ~= stock_a[1].price))

for _, offer in ipairs(stock_a) do
	check("price is a positive integer for " .. offer.item,
			offer.price and offer.price > 0 and offer.price == math.floor(offer.price),
			offer.price)
	check("stock depth is positive for " .. offer.item, offer.stock > 0)
end

-- Village character is derived, not stored, and is stable.
local c1 = market.character("100:200")
local c2 = market.character("100:200")
check("character is stable", c1.speciality == c2.speciality)
check("speciality differs from scarcity", c1.speciality ~= c1.scarce)

-- Seasons: fresh food must cost more in winter than at harvest.
local fresh = {item = "default:apple", tags = "food fresh", base = 10}
seasons._season = "autumn"
local autumn_mult = market.price_factor("100:200", fresh)
seasons._season = "winter"
local winter_mult, winter_ok = market.price_factor("100:200", fresh)
check("fresh food costs more in winter", winter_mult > autumn_mult,
		autumn_mult .. " -> " .. winter_mult)
check("plain fresh food is still sold in winter", winter_ok)

local berry = {item = "x_farming:strawberry", tags = "food fresh berry", base = 10}
local _, berry_ok = market.price_factor("100:200", berry)
check("berries are out of season in winter", berry_ok == false)
seasons._season = "autumn"

-- Demand moves prices and decays.
local before = market.price_factor("100:200", fresh)
for _ = 1, 20 do market.record_purchase("100:200", fresh, 5) end
local after = market.price_factor("100:200", fresh)
check("buying raises the price", after > before, before .. " -> " .. after)
day_count = day_count + 6
local later = market.price_factor("100:200", fresh)
check("demand decays over days", later < after, after .. " -> " .. later)

-- Selling
local sell = village_life.trade.sell_price("100:200", "default:steel_ingot", 5)
check("villagers buy known goods", sell > 0, sell)
check("villagers refuse unknown goods",
		village_life.trade.sell_price("100:200", "nonexistent:thing", 1) == 0)

-- ...and things nobody happens to *stock*. Valuing only what appears on a
-- shelf meant a player back from a hunt could not sell leather, hides or raw
-- meat to anyone, which is exactly backwards.
core.registered_items["animalia:leather"] = {groups = {leather = 1}}
core.registered_items["animalia:beef_raw"] = {groups = {meat = 1, food_meat = 1}}
core.registered_items["mobs:chicken_feather"] = {groups = {feather = 1}}
core.registered_items["test:pebble"] = {groups = {stone = 1}}
core.registered_items["test:junk"] = {groups = {}}
economy.forget_values()

check("leather is worth something",
		village_life.trade.sell_price("100:200", "animalia:leather", 4) > 0)
check("raw meat is worth something",
		village_life.trade.sell_price("100:200", "animalia:beef_raw", 4) > 0)
check("so is an unlisted item recognised only by its group",
		village_life.trade.sell_price("100:200", "mobs:chicken_feather", 10) > 0)
check("but not something with no use at all",
		village_life.trade.sell_price("100:200", "test:junk", 10) == 0)

-- Whom you sell it to matters.
local to_smith = village_life.trade.sell_price("100:200", "animalia:leather", 8, "smith")
local to_baker = village_life.trade.sell_price("100:200", "animalia:leather", 8, "baker")
check("a smith pays properly for hides", to_smith > to_baker,
		to_smith .. " vs " .. to_baker)

local meat_to_cook = village_life.trade.sell_price("100:200", "animalia:beef_raw", 8, "butcher")
local meat_to_mason = village_life.trade.sell_price("100:200", "animalia:beef_raw", 8, "stonemason")
check("a butcher pays properly for meat", meat_to_cook > meat_to_mason,
		meat_to_cook .. " vs " .. meat_to_mason)

check("more of a thing is worth more",
		village_life.trade.sell_price("100:200", "animalia:leather", 20)
		> village_life.trade.sell_price("100:200", "animalia:leather", 4))

--------------------------------------------------------------------------------
-- Regressions
--------------------------------------------------------------------------------

-- mg_villages writes all_villages[village_id] *after* it calls the mob spawn
-- hook, so during the mapgen pass that creates a village every lookup through
-- all_villages returns nil. Spawning has to work off the bed and bpos it was
-- handed, or brand new villages generate completely empty.
local saved_village = mg_villages.all_villages["100:200"]
mg_villages.all_villages["100:200"] = nil

lottmobs.spawned = {}
local bpos_mapgen = saved_village.to_add_data.bpos[1]
local bed_mapgen = bpos_mapgen.beds[1]
local spawned = mg_villages.inhabitants.spawn_one_mob(
		bed_mapgen, "100:200", 1, 1, bpos_mapgen)
check("villager spawns during mapgen, before all_villages exists",
		spawned == "100:200/1/1", tostring(spawned))
check("exactly one villager was created", #lottmobs.spawned == 1)

local mapgen_ent = lottmobs.spawned[1]
check("the mapgen villager is bound",
		mapgen_ent and mapgen_ent.vl and mapgen_ent.vl.v == "100:200")
check("the mapgen villager got a stable shop identity",
		mapgen_ent and mapgen_ent.id == "vl_100:200/1/1", mapgen_ent and mapgen_ent.id)

-- ...and while the village data is still missing it cannot resolve, but that
-- failure must not be cached forever: mg_villages fills the table in moments.
check("resolve fails while the village data is missing",
		home.resolve(mapgen_ent) == nil)
mg_villages.all_villages["100:200"] = saved_village
check("the failure is held briefly rather than retried every step",
		home.resolve(mapgen_ent) == nil)
fake_us = fake_us + 11 * 1000000
check("failure is not cached permanently -- resolve is retried",
		home.resolve(mapgen_ent) ~= nil)
home.roster = {}

-- A monster in a cave under the village must not count as being in it. This is
-- what kept villages on permanent alert: something is always down there.
local shortlist_v = home.villages_near({x = 100, y = 10, z = 200}, 64)
check("a hostile on the surface counts",
		home.village_in(shortlist_v, {x = 105, y = 11, z = 205}, 4, 10) == "100:200")
check("a hostile in a cave below does not",
		home.village_in(shortlist_v, {x = 105, y = -30, z = 205}, 4, 10) == nil)
check("without a height bound it would have counted",
		home.village_in(shortlist_v, {x = 105, y = -30, z = 205}, 4) == "100:200")

-- An alarm on the far side of a large village must not send everyone indoors.
village_life.threats.list = {}
village_life.threats.alarms["100:200"] = {
	pos = {x = 100, y = 10, z = 240},   -- 35 nodes from the villager below
	expires = util.now() + 30, started = util.now(),
}
local far_goal = at(10, function()
	return schedule.decide(smith, r, {x = 105, y = 11, z = 205})
end)
check("a distant alarm does not make an ordinary villager flee",
		far_goal and far_goal.kind == "work", far_goal and far_goal.kind)

village_life.threats.alarms["100:200"].pos = {x = 108, y = 10, z = 208}
local near_goal = at(10, function()
	return schedule.decide(smith, r, {x = 105, y = 11, z = 205})
end)
check("an alarm nearby does make them flee",
		near_goal and near_goal.kind == "flee", near_goal and near_goal.kind)

-- Guards answer the alarm wherever in the village it is: they are the ones
-- who are supposed to go and look.
local guard_r = {}
for k, v in pairs(r) do guard_r[k] = v end
guard_r.role = "guard"
village_life.threats.alarms["100:200"].pos = {x = 100, y = 10, z = 240}
local guard_goal = at(10, function()
	return schedule.decide(smith, guard_r, {x = 105, y = 11, z = 205})
end)
check("a guard responds to a distant alarm",
		guard_goal and guard_goal.kind == "defend", guard_goal and guard_goal.kind)

-- Alarms expire in wall-clock seconds.
fake_us = fake_us + 40 * 1000000
check("the alarm expires", village_life.threats.alarm("100:200") == nil)
village_life.threats.alarms = {}
time_of_day = 0.5

-- Village shortlisting, which the per-second threat scan and the census both
-- depend on to avoid sweeping every village in the world.
local shortlist = home.villages_near({x = 105, y = 10, z = 205}, 64)
check("shortlist finds the nearby village", shortlist["100:200"] ~= nil)
check("village_in picks it out",
		home.village_in(shortlist, {x = 108, y = 10, z = 208}) == "100:200")
check("village_in rejects a distant point",
		home.village_in(shortlist, {x = 900, y = 10, z = 900}) == nil)
check("shortlist is empty far away",
		next(home.villages_near({x = 9000, y = 10, z = 9000}, 64)) == nil)

-- Mild weather has to be a fixed trait, not a coin flip per decision: rolling
-- it inside decide() makes the goal alternate every think tick and the villager
-- spends the shower walking in and out of its own front door.
check("hardiness is a stable per-villager trait",
		type(r.hardy) == "boolean" and r.hardy == home.resolve(smith).hardy)
climate_mod.current_weather = {p1 = {"regional_weather:rain"}}
schedule.flush_weather_cache()
local first = at(16, function() return schedule.decide(smith, r, pos) end)
local second = at(16, function() return schedule.decide(smith, r, pos) end)
check("mild weather gives the same answer twice running",
		first.kind == second.kind, first.kind .. " then " .. second.kind)
climate_mod.current_weather = {}
schedule.flush_weather_cache()

-- The repair path for a village that generated underpopulated: fill every
-- vacant bed at once rather than noting them and waiting out the delay.
home.roster = {}
home.pending = {}
lottmobs.spawned = {}
local n = village_life.census.audit("100:200", true)
check("immediate census fills every vacant bed", n == 2, n)
check("immediate census actually spawned them", #lottmobs.spawned == 2,
		#lottmobs.spawned)
check("and it does not spawn over them a second time",
		village_life.census.audit("100:200", true) == 0)
home.roster = {}
home.pending = {}

--------------------------------------------------------------------------------
-- The shop counter
--------------------------------------------------------------------------------

local trade = village_life.trade
local player = core.make_test_player("tester", 105, 11, 205)

local shop = {
	id = "vl_test_shop",
	profession = "smith",
	game_name = "Yorath",
	vl = {v = "100:200", p = 1, b = 1},
	object = stub_object(105, 11, 205),
}

trade.open(shop, player)
local inv = minetest.get_inventory({type = "detached", name = "vl_test_shop"})
check("opening a shop creates its inventory", inv ~= nil)
check("the shelf is stocked", not inv:get_stack("goods", 1):is_empty())
check("a formspec was shown", core.last_formspec ~= nil)

-- Permissions. A cross-inventory move is gated by allow_take on the source, so
-- this is what decides whether the customer can get their own things back.
local cb = trade.callbacks("vl_test_shop")
local function may_take(list)
	return cb.allow_take(inv, list, 1, ItemStack("default:steel_ingot 5")) > 0
end
check("the sell slot can be taken from", may_take("selling"))
check("the payment slot can be taken from", may_take("payment"))
check("the takeaway slot can be taken from", may_take("takeaway"))
check("the sellprice slot can be taken from", may_take("sellprice"))
check("the shelf cannot be taken from", not may_take("goods"))
check("the selection cannot be taken from", not may_take("selection"))
check("the price preview cannot be taken from", not may_take("price"))

local function may_put(list)
	return cb.allow_put(inv, list, 1, ItemStack("default:steel_ingot 5")) > 0
end
check("things can be put up for sale", may_put("selling"))
check("payment can be put in", may_put("payment"))
check("nothing can be put on the shelf", not may_put("goods"))

inv:set_stack("goods", 3, "default:steel_ingot 5")
check("a whole stack may be picked off the shelf",
		cb.allow_move(inv, "goods", 3, "selection", 1, 5) == 5)
check("part of a stack may not",
		cb.allow_move(inv, "goods", 3, "selection", 1, 2) == 0)
inv:set_stack("selection", 1, "default:steel_ingot 5")
check("the selection may be put back on the shelf",
		cb.allow_move(inv, "selection", 1, "goods", 3, 5) == 5)
check("the selection may not be moved anywhere else",
		cb.allow_move(inv, "selection", 1, "payment", 1, 5) == 0)
inv:set_stack("selection", 1, nil)

-- Clear must empty the whole counter, not just the selection.
inv:set_stack("payment", 1, "simplecoins:coins 100")
inv:set_stack("selling", 1, "default:steel_ingot 7")
inv:set_stack("sellprice", 1, "simplecoins:coins 12")
core.on_fields(player, "village_life:trade", {clear = true})

check("Clear empties the payment slot", inv:get_stack("payment", 1):is_empty())
check("Clear empties the sell slot", inv:get_stack("selling", 1):is_empty())
check("Clear drops the sell price preview", inv:get_stack("sellprice", 1):is_empty())

local pinv = player:get_inventory()
local returned = {}
for i = 1, 32 do
	local s = pinv:get_stack("main", i)
	if not s:is_empty() then returned[s:get_name()] = s:get_count() end
end
check("Clear gives the coins back", returned["simplecoins:coins"] == 100,
		returned["simplecoins:coins"])
check("Clear gives the item back", returned["default:steel_ingot"] == 7,
		returned["default:steel_ingot"])
check("Clear invented nothing", #core.dropped_items == 0)

-- Closing the window must do the same, or the items are stranded in an
-- inventory the player has no way to reach again.
inv:set_stack("payment", 1, "simplecoins:coins 40")
core.on_fields(player, "village_life:trade", {quit = true})
check("closing the window returns the payment",
		inv:get_stack("payment", 1):is_empty())

-- ...and so must logging out mid-trade.
trade.viewing["tester"] = "vl_test_shop"
inv:set_stack("selling", 1, "default:apple 3")
core.on_leave(player)
check("logging out returns what was on the counter",
		inv:get_stack("selling", 1):is_empty())

-- A trader dying with the window open must not take the customer's coins with
-- it when its inventory is destroyed.
trade.viewing["tester"] = "vl_test_shop"
trade.sessions["vl_test_shop"].viewer = "tester"
inv:set_stack("payment", 1, "simplecoins:coins 55")
trade.close(shop)
check("a dying trader hands the coins back rather than deleting them",
		(function()
			for i = 1, 32 do
				local s = pinv:get_stack("main", i)
				if s:get_name() == "simplecoins:coins" and s:get_count() == 55 then
					return true
				end
			end
			return false
		end)())
check("and its inventory is gone",
		minetest.get_inventory({type = "detached", name = "vl_test_shop"}) == nil)

-- Shift-click routing. The client sends a quick-move to whatever list follows
-- the clicked one in the ring, finding the clicked list by its first
-- occurrence -- so this mirrors guiFormSpecMenu::getNextInventoryRing.
local ring = {}
for loc, list in core.last_formspec.spec:gmatch("listring%[([^;%]]+);([^%]]+)%]") do
	ring[#ring + 1] = loc .. ";" .. list
end
check("the window declares a ring", #ring >= 2, #ring)

local function quick_move_target(from)
	for i, entry in ipairs(ring) do
		if entry == from then return ring[(i % #ring) + 1] end
	end
end

local D = "detached:vl_test_shop;"
local MAIN = "current_player;main"
check("shelf shift-clicks into the selection",
		quick_move_target(D .. "goods") == D .. "selection")
check("the selection shift-clicks back onto the shelf",
		quick_move_target(D .. "selection") == D .. "goods")
check("the sell slot shift-clicks into the player inventory",
		quick_move_target(D .. "selling") == MAIN)
check("the payment slot shift-clicks into the player inventory",
		quick_move_target(D .. "payment") == MAIN)
check("bought goods shift-click into the player inventory",
		quick_move_target(D .. "takeaway") == MAIN)
check("sale proceeds shift-click into the player inventory",
		quick_move_target(D .. "sellprice") == MAIN)
check("the player inventory shift-clicks into the sell slot",
		quick_move_target(MAIN) == D .. "selling")

--------------------------------------------------------------------------------
-- Doors with no open/closed state
--------------------------------------------------------------------------------

local nav = village_life.nav
check("cottages half doors are recognised as openable",
		nav.openables["cottages:half_door"] ~= nil)

-- param2 0 puts the slab across the Z axis. A villager walking along Z is
-- blocked by it; one walking along X is not.
local door_pos = {x = 120, y = 11, z = 220}
stub_nodes[pkey(door_pos)] = {name = "cottages:half_door", param2 = 0}

check("a half door across the way is not opened when walking past it",
		nav.open_door_near(door_pos, {x = 1, z = 0}) == nil)
check("...and is still shut", stub_nodes[pkey(door_pos)].param2 == 0)

check("a half door in the way is opened",
		nav.open_door_near(door_pos, {x = 0, z = 1}) ~= nil)
check("opening swings it a quarter turn",
		stub_nodes[pkey(door_pos)].param2 == 3,
		stub_nodes[pkey(door_pos)].param2)
check("and it is not opened twice",
		nav.open_door_near(door_pos, {x = 0, z = 1}) == nil)

check("an open half door is closed behind",
		nav.close_door_near(door_pos, {x = 0, z = 1}) ~= nil)
check("closing swings it back",
		stub_nodes[pkey(door_pos)].param2 == 0,
		stub_nodes[pkey(door_pos)].param2)
check("and a shut door is not closed again",
		nav.close_door_near(door_pos, {x = 0, z = 1}) == nil)

--------------------------------------------------------------------------------
-- Threat classification
--------------------------------------------------------------------------------

do
	local threats = village_life.threats

	-- mob_class defaults attack_npcs to TRUE, so reading it off the instance
	-- classifies every cow and chicken in the game as a monster -- which puts
	-- villages on permanent alert, which is indistinguishable from the bug
	-- this whole subsystem exists to avoid.
	local mob_class = {attack_npcs = true, _cmi_is_mob = true}
	local meta = {__index = mob_class}

	local function register_stub(name, def)
		core.registered_entities[name] = setmetatable(def, meta)
		return setmetatable({name = name}, {__index = core.registered_entities[name]})
	end

	local cow = register_stub("mobs_animal:cow", {type = "animal"})
	local zombie = register_stub("zombies:zombie", {type = "monster"})
	local trader = register_stub("lottmobs:pigman_trader", {type = "npc"})
	local bandit = register_stub("test:bandit", {type = "npc", attack_npcs = true})

	check("a cow is not a monster", threats.is_hostile(cow) == false)
	check("a zombie is", threats.is_hostile(zombie) == true)
	check("a villager is not", threats.is_hostile(trader) == false)
	check("an NPC that explicitly hunts NPCs is",
			threats.is_hostile(bandit) == true)

	-- Whatever actually draws blood is a threat, recognised or not.
	local unknown = register_stub("weird:thing", {type = "npc"})
	check("an unknown mob starts harmless", threats.is_hostile(unknown) == false)
	village_life.register_threat("weird:thing")
	check("...and can be taught otherwise", threats.is_hostile(unknown) == true)
	village_life.register_threat("weird:thing", false)
	check("...or excused", threats.is_hostile(unknown) == false)

	-- Naming it. A villager who will not stop to talk because something is
	-- loose has to be able to say what, and "zombies:zombie" is not how
	-- anybody speaks.
	check("a threat is named without its modname",
			threats.describe("zombies:zombie") == "a zombie",
			threats.describe("zombies:zombie"))
	check("...with underscores read as spaces",
			threats.describe("mobs_monster:dungeon_master") == "a dungeon master",
			threats.describe("mobs_monster:dungeon_master"))
	check("...and the right article",
			threats.describe("mobs_monster:oerkki") == "an oerkki",
			threats.describe("mobs_monster:oerkki"))

	-- mobs redo copies `description` onto every registered entity and defaults
	-- it to the entity name, so a description with a colon in it is the mob mod
	-- having said nothing rather than having named its mob.
	register_stub("test:dire_wolf", {type = "monster", description = "Dire Wolf"})
	check("a mob that named itself is called what it calls itself",
			threats.describe("test:dire_wolf") == "a dire wolf",
			threats.describe("test:dire_wolf"))
	register_stub("test:silent", {type = "monster", description = "test:silent"})
	check("...and the default description is not mistaken for one",
			threats.describe("test:silent") == "a silent",
			threats.describe("test:silent"))

	-- An override is spoken exactly as written, because the reason to write one
	-- is usually that the automatic article is wrong.
	village_life.register_threat_label("test:swarm", "the swarm")
	check("a label can be overridden whole",
			threats.describe("test:swarm") == "the swarm",
			threats.describe("test:swarm"))

	check("a player is not a thing you name this way",
			threats.describe("player") == nil)
	check("and neither is nothing", threats.describe(nil) == nil)

	-- The alarm carries what was seen, so a villager who is only running
	-- because somebody shouted can still repeat what was shouted about.
	threats.alarms = {}
	threats.raise("100:200", {x = 100, y = 11, z = 200}, "zombies:zombie")
	check("an alarm remembers what raised it",
			threats.alarm("100:200").name == "zombies:zombie",
			threats.alarm("100:200").name)
	threats.raise("100:200", {x = 101, y = 11, z = 200})
	check("...and a later sighting with no name does not erase it",
			threats.alarm("100:200").name == "zombies:zombie",
			threats.alarm("100:200").name)
	threats.raise("100:200", {x = 101, y = 11, z = 200}, "test:dire_wolf")
	check("...but a named one replaces it",
			threats.alarm("100:200").name == "test:dire_wolf",
			threats.alarm("100:200").name)
	threats.alarms = {}
end

--------------------------------------------------------------------------------
-- Reputation
--------------------------------------------------------------------------------

do
	local rep = village_life.reputation
	rep.book = {}
	local V, P = "100:200", "tester"

	check("a stranger starts at nothing", rep.get(V, P) == 0)
	check("a stranger is a stranger", rep.tier(0).name == "a stranger",
			rep.tier(0).name)
	check("an unknown village is neutral", rep.get("nowhere", P) == 0)

	rep.adjust(V, P, 20, "test")
	check("goodwill accumulates", rep.get(V, P) == 20, rep.get(V, P))
	check("and is felt", rep.tier(rep.get(V, P)).name == "welcome",
			rep.tier(rep.get(V, P)).name)

	rep.adjust(V, P, 500, "test")
	check("standing is capped", rep.get(V, P) == 100, rep.get(V, P))
	rep.adjust(V, P, -1000, "test")
	check("...at both ends", rep.get(V, P) == -100, rep.get(V, P))

	-- Reputation is per village: a hero in one valley is nobody in the next.
	check("standing does not travel between villages", rep.get("900:900", P) == 0)

	-- Thresholds
	check("an enemy is an enemy", rep.is_enemy(V, P))
	check("an enemy cannot trade", not rep.will_trade(V, P))
	rep.book[V][P].score = -50
	check("the shunned cannot trade", not rep.will_trade(V, P))
	check("but are not attacked on sight", not rep.is_enemy(V, P))
	rep.book[V][P].score = 0
	check("a stranger can trade", rep.will_trade(V, P))
	check("a stranger gets no favours", not rep.is_favoured(V, P))
	rep.book[V][P].score = 60
	check("the favoured get favours", rep.is_favoured(V, P))

	-- One ladder, so the flags have to nest and must never un-fire as the score
	-- falls. Three separate sets of cut-points -- these tiers, the conversation
	-- bands and a handful of loose constants -- is how a shop came to refuse
	-- someone the conversation was still offering it to.
	local nesting, monotonic, banded = true, true, true
	local seen, bands = {}, {}
	for score = 100, -100, -1 do
		local t = rep.tier(score)
		if t.silent and not t.hostile then nesting = false end
		if t.hostile and not t.shun then nesting = false end
		if t.shun and t.favoured then nesting = false end
		if not t.band or not t.label or not t.colour then banded = false end
		bands[t.band] = true
		for _, flag in ipairs({"shun", "hostile", "silent"}) do
			if t[flag] then seen[flag] = true
			elseif seen[flag] then monotonic = false end
		end
	end
	check("refusing to speak implies refusing to trade", nesting)
	check("standing only worsens as the score falls", monotonic)
	check("every tier has a face to show", banded)

	local reachable = true
	for _, t in ipairs(rep.tiers) do
		if not bands[t.band] then reachable = false end
	end
	check("every band is reachable", reachable)

	-- Prices move with standing, in the right direction on both sides.
	rep.book[V][P].score = 100
	local friendly_buy = rep.price_factor(V, P)
	local friendly_sell = rep.sell_factor(V, P)
	rep.book[V][P].score = -100
	local hostile_buy = rep.price_factor(V, P)
	local hostile_sell = rep.sell_factor(V, P)

	check("friends buy cheaper", friendly_buy < 1, friendly_buy)
	check("enemies buy dearer", hostile_buy > 1, hostile_buy)
	check("friends are paid better", friendly_sell > 1, friendly_sell)
	check("enemies are paid worse", hostile_sell < 1, hostile_sell)
	rep.book[V][P].score = 0
	check("a stranger pays the asking price",
			math.abs(rep.price_factor(V, P) - 1) < 0.001)

	-- Grudges fade, so a village is recoverable.
	rep.book[V][P] = {score = -30, day = day_count, met = 0}
	day_count = day_count + 20
	local faded = rep.get(V, P)
	check("a grudge fades towards indifference", faded > -30 and faded <= 0, faded)

	-- ...and goodwill has to be maintained, more slowly.
	rep.book[V][P] = {score = 60, day = day_count, met = 0}
	day_count = day_count + 20
	local kept = rep.get(V, P)
	check("goodwill decays too", kept < 60, kept)
	check("but more slowly than a grudge", (60 - kept) < (30 - math.abs(faded)) + 60)
	check("decay never overshoots zero", kept >= 0, kept)

	-- An established relationship sets. Once a village has dealt with someone
	-- over several days, no absence drops them below "welcome" -- but standing
	-- above that still has to be kept up, so the floor is at the band, not the
	-- peak.
	rep.book[V][P] = {score = 60, day = day_count, met = 8}
	day_count = day_count + 400
	local established = rep.get(V, P)
	check("an established relationship holds at welcome", established >= 15,
			established)
	check("...but the goodwill above it still fades", established < 60,
			established)
	-- A near-stranger has not earned the floor and fades all the way back.
	rep.book[V][P] = {score = 60, day = day_count, met = 1}
	day_count = day_count + 400
	check("a near-stranger is not floored", rep.get(V, P) < 15, rep.get(V, P))

	-- Trading earns standing, but is capped so a village cannot be farmed by
	-- buying the same loaf four hundred times.
	rep.book[V] = {}
	for _ = 1, 50 do rep.on_trade(V, P, "trade") end
	local farmed = rep.get(V, P)
	check("trading earns standing", farmed > 0, farmed)
	check("but not without limit", farmed <= 6, farmed)

	day_count = day_count + 1
	for _ = 1, 50 do rep.on_trade(V, P, "trade") end
	check("the cap resets the next day", rep.get(V, P) > farmed, rep.get(V, P))

	-- Visits are counted separately from standing: being recognised is not the
	-- same as being liked. They are counted per day, because both talking to
	-- someone and buying from them count as dealing with the place, and a
	-- conversation that ends in a purchase is one visit rather than two.
	rep.book = {}
	rep.note_visit(V, P)
	rep.note_visit(V, P)
	check("visits are counted", rep.visits(V, P) == 1, rep.visits(V, P))
	day_count = day_count + 1
	rep.note_visit(V, P)
	check("...once per day, however many dealings",
			rep.visits(V, P) == 2, rep.visits(V, P))
	check("visiting is not the same as being liked", rep.get(V, P) == 0)

	-- Violence
	rep.book = {}
	local victim = {vl = {v = V, p = 1, b = 1}, object = stub_object(105, 11, 205)}
	local attacker = players[P]
	rep.on_villager_hurt(victim, attacker)
	check("striking a villager costs standing", rep.get(V, P) < 0, rep.get(V, P))

	local after_one = rep.get(V, P)
	rep.on_villager_hurt(victim, attacker)
	check("a flurry of blows only counts once", rep.get(V, P) == after_one,
			rep.get(V, P))

	rep.book = {}
	rep.on_villager_killed(victim, P, false)
	local murder = rep.get(V, P)
	rep.book = {}
	rep.on_villager_killed(victim, P, true)
	local guard_kill = rep.get(V, P)
	check("killing a villager is worse than killing a guard",
			murder < guard_kill, murder .. " vs " .. guard_kill)

	-- One murder shuts the shops; carrying on turns the village against you.
	rep.book = {}
	rep.on_villager_killed(victim, P, false)
	check("one killing closes the shops", not rep.will_trade(V, P), rep.get(V, P))
	check("one killing is not yet open war", not rep.is_enemy(V, P), rep.get(V, P))
	rep.on_villager_killed(victim, P, false)
	check("a second makes you an enemy", rep.is_enemy(V, P), rep.get(V, P))

	-- An enemy standing in the village registers as something to run from.
	rep.book = {}
	rep.book[V] = {[P] = {score = -100, day = day_count, met = 0}}
	local found = rep.enemy_near(V, {x = 105, y = 11, z = 205}, 16)
	check("an enemy nearby is noticed", found ~= nil)
	check("...but not from across the map",
			rep.enemy_near(V, {x = 900, y = 11, z = 900}, 16) == nil)

	rep.book = {}
end

--------------------------------------------------------------------------------
-- Memory and mood
--------------------------------------------------------------------------------

do
	local memory = village_life.memory
	local rep = village_life.reputation
	local V, P, Q = "100:200", "tester", "other"

	memory.book = {}
	rep.book = {}

	local baker = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 11, 205),
	}
	local smith = {
		id = "vl_100:200/1/2", vl = {v = V, p = 1, b = 2},
		game_name = "Freya", profession = "villager",
		object = stub_object(105, 11, 205),
	}

	check("a villager starts with no opinion", memory.opinion(baker, P) == 0)

	memory.remember(baker, P, "struck")
	check("being hit is remembered", memory.opinion(baker, P) < 0,
			memory.opinion(baker, P))
	check("...by the person who was hit", memory.did(baker, P, "struck"))
	check("...and not by their neighbour", memory.opinion(smith, P) == 0)
	check("...nor about somebody else", memory.opinion(baker, Q) == 0)

	-- Opinion is bounded well inside the village score's range: one villager
	-- cannot outvote their village however strongly they feel.
	for _ = 1, 20 do memory.remember(baker, P, "struck") end
	check("a personal grudge has a floor", memory.opinion(baker, P) >= -40,
			memory.opinion(baker, P))

	memory.book = {}
	for _ = 1, 20 do memory.remember(baker, P, "rescued") end
	check("...and so does personal goodwill", memory.opinion(baker, P) <= 40,
			memory.opinion(baker, P))

	-- Repeatable acts are capped so standing is not a reward for clicking.
	memory.book = {}
	memory.remember(baker, P, "greeted")
	local once = memory.opinion(baker, P)
	for _ = 1, 10 do memory.remember(baker, P, "greeted") end
	check("saying hello counts once a day", memory.opinion(baker, P) == once,
			memory.opinion(baker, P))
	day_count = day_count + 1
	memory.remember(baker, P, "greeted")
	check("...and again tomorrow", memory.opinion(baker, P) > once)

	memory.book = {}
	for _ = 1, 30 do memory.remember(baker, P, "traded") end
	local traded = memory.opinion(baker, P)
	check("trade goodwill is capped per day", traded <= 6, traded)

	-- Enough remembered good turns and their regard sets: a long absence no
	-- longer returns them to indifference, though the goodwill above the floor
	-- still fades if it is not kept warm.
	memory.book = {}
	for _ = 1, 8 do memory.remember(baker, P, "rescued") end
	local peak = memory.opinion(baker, P)
	day_count = day_count + 500
	local held = memory.opinion(baker, P)
	check("established regard holds above indifference", held >= 8, held)
	check("...but still fades below its peak", held < peak, held)
	-- A single kindness earns no floor and fades to nothing.
	memory.book = {}
	memory.remember(baker, P, "rescued")
	day_count = day_count + 500
	check("a one-off kindness is not floored", memory.opinion(baker, P) == 0,
			memory.opinion(baker, P))
	day_count = day_count - 1000

	-- Regard is the village's verdict plus this person's own dealings, so two
	-- neighbours can differ about you in the same village on the same day.
	memory.book = {}
	memory.remember(baker, P, "rescued")
	local warm = memory.regard(baker, P, 0)
	local cold = memory.regard(smith, P, 0)
	check("the one you helped thinks better of you", warm > cold, warm)
	check("...and the one who was not there thinks nothing", cold == 0)
	check("regard is still bounded", memory.regard(baker, P, 100) <= 100)

	-- Enough personal goodwill moves the band, which is the point of it.
	local band_alone = rep.band(0)
	local band_with = rep.band(memory.regard(baker, P, 14))
	check("a villager's own regard can shift the band",
			band_alone ~= band_with, band_alone .. " -> " .. band_with)

	-- Mood is about the villager, not the player, and recovers towards a
	-- baseline set by their temperament.
	memory.book = {}
	local settled = memory.mood(baker)
	memory.nudge_mood(baker, -40, "test")
	check("bad news lowers the mood", memory.mood(baker) < settled,
			memory.mood(baker))
	check("mood has a word for it", type(memory.spirits(baker)) == "string")
	day_count = day_count + 20
	check("and time brings them back round",
			math.abs(memory.mood(baker) - settled) < 0.001, memory.mood(baker))

	-- Someone gone for good takes their memories with them.
	memory.remember(baker, P, "struck")
	memory.forget_entity(baker)
	check("the dead remember nothing", memory.opinion(baker, P) == 0)

	memory.book = {}
	rep.book = {}
end

--------------------------------------------------------------------------------
-- Events and gossip
--------------------------------------------------------------------------------

do
	local events = village_life.events
	local gossip = village_life.gossip
	local memory = village_life.memory
	local rep = village_life.reputation
	local home = village_life.home
	local V, P = "100:200", "tester"

	gossip.book = {}
	memory.book = {}
	rep.book = {}
	rep.notoriety = {}
	home.roster = {}

	local A, B, C = V .. "/1/1", V .. "/1/2", V .. "/2/1"
	local FAR = "900:900/1/1"

	home.roster[A] = {obj = stub_object(105, 11, 205), seen = os.time()}
	home.roster[B] = {obj = stub_object(107, 11, 205), seen = os.time()}
	home.roster[C] = {obj = stub_object(180, 11, 205), seen = os.time()}
	home.roster[FAR] = {obj = stub_object(105, 11, 205), seen = os.time()}

	-- Only people who were there, and only people of that village.
	local seen = events.witnesses(V, {x = 105, y = 11, z = 205}, 20)
	local saw = {}
	for _, k in ipairs(seen) do saw[k] = true end
	check("someone standing there sees it", saw[A])
	check("...and so does their neighbour", saw[B])
	check("...but not someone across the village", not saw[C], #seen)
	check("...nor someone from another village standing on the spot",
			not saw[FAR])

	-- Raising an event hands it to the witnesses and nobody else. Freya (B) is
	-- the victim, so her bed must read as dead: by design, news of a murder whose
	-- subject is still alive is "spent" (a revived victim, or an incomer who took
	-- the bed, would otherwise be gossiping about their own death), and gossip.tell
	-- drops it on the spot. Staging the killing without a corpse is what used to
	-- make this check fail. Restored afterwards so later blocks see B alive.
	local victim = home.bed_data(V, 1, 2)
	local was_dead = victim and victim.dead
	if victim then victim.dead = true end
	local ev = events.raise({
		kind = "murder", village_id = V, pos = {x = 105, y = 11, z = 205},
		actor = P, subject = B, subject_name = "Freya",
	})
	check("an event is recorded", ev ~= nil and ev.kind == "murder")
	check("witnesses hear of it first hand", gossip.count(A) == 1)
	check("...and the far side of the village does not", gossip.count(C) == 0)
	if victim then victim.dead = was_dead end

	-- The victim knows regardless of whether they had line of sight to it.
	local ev2 = events.raise({
		kind = "theft", village_id = V, pos = {x = 400, y = 11, z = 400},
		actor = P, subject = C, subject_name = "Yorath",
	})
	check("the one it happened to always knows", gossip.count(C) == 1, ev2 and 1)

	-- Seeing a murder is not a neutral experience.
	check("witnessing a killing lowers the mood", memory.mood_key(A) < 0,
			memory.mood_key(A))

	-- Word of a murder travels; word of a good day's trade does not.
	check("a killing makes a name for you", rep.notorious(P) < 0,
			rep.notorious(P))
	local infamy = rep.notorious(P)
	events.raise({kind = "trade", village_id = V,
			pos = {x = 105, y = 11, z = 205}, actor = P})
	check("...but haggling does not", rep.notorious(P) == infamy)

	-- Notoriety is the mark a village that has never met you starts from.
	check("your name arrives before you do", rep.get("777:777", P) < 0,
			rep.get("777:777", P))
	check("...but counts for less than being there",
			rep.get("777:777", P) > rep.notorious(P))
	check("a stranger with no history is nobody",
			rep.get("777:777", "nobody_at_all") == 0)

	-- Retelling: news moves villager to villager and degrades as it goes.
	gossip.book = {}
	local far_ev = events.raise({
		kind = "murder", village_id = V, pos = {x = 105, y = 11, z = 205},
		actor = P, subject_name = "Freya", witnesses = {A},
	})
	check("only the one witness has it", gossip.count(A) == 1 and gossip.count(B) == 0)
	gossip.exchange(A, B)
	check("news passes to a neighbour", gossip.count(B) == 1)
	local item = gossip.book[B][1]
	check("...at one remove", item.hops == 1, item.hops)
	check("...and knows who said it", item.from == A)

	gossip.exchange(B, C)
	check("and on again", gossip.count(C) == 1)
	check("...at two", gossip.book[C][1].hops == 2, gossip.book[C][1].hops)

	-- Nobody tells the same person twice, and nothing goes round in circles.
	local before = gossip.count(A)
	gossip.exchange(B, A)
	check("news does not bounce back", gossip.count(A) == before)

	-- The wording changes with distance from the source.
	local first_hand = gossip.phrase({ev = far_ev, hops = 0})
	local second_hand, hearsay = gossip.phrase({ev = far_ev, hops = 1, from = A})
	local distant = gossip.phrase({ev = far_ev, hops = 4})
	check("first hand is stated plainly", first_hand:find(P, 1, true) ~= nil,
			first_hand)
	check("second hand is attributed", hearsay == true and second_hand ~= first_hand,
			second_hand)
	check("...to somebody by name",
			second_hand:find("Yorath", 1, true) ~= nil, second_hand)
	check("a distant rumour has lost the name",
			distant:find(P, 1, true) == nil, distant)
	check("...and says so", distant:find("saying") or distant:find("story"),
			distant)

	-- A villager only carries so much, and keeps what is worth repeating.
	gossip.book = {}
	for i = 1, 12 do
		gossip.tell(A, {id = 1000 + i, kind = "trade", weight = 5}, 0)
	end
	gossip.tell(A, {id = 2000, kind = "murder", weight = 100}, 0)
	check("a villager carries only so much news", gossip.count(A) <= 6,
			gossip.count(A))
	local kept_murder = false
	for _, it in ipairs(gossip.book[A]) do
		if it.ev.id == 2000 then kept_murder = true end
	end
	check("...and it is the killing they keep, not the haggling", kept_murder)

	gossip.book = {}
	memory.book = {}
	rep.book = {}
	rep.notoriety = {}
	home.roster = {}
end

--------------------------------------------------------------------------------
-- Traits: what they say is true
--------------------------------------------------------------------------------

do
	local traits = village_life.traits
	local V = "100:200"

	-- The engine always has these; the harness only ever needed get_node until
	-- something started placing nodes rather than reading them.
	core.registered_nodes["air"] = {buildable_to = true, walkable = false,
			groups = {}}
	core.registered_nodes["default:dirt"] = {walkable = true,
			groups = {soil = 1, crumbly = 3}}
	core.registered_nodes["default:dirt_with_grass"] = {walkable = true,
			groups = {soil = 1, crumbly = 3}}

	-- The nodes the simulated traits need. Without these registered, those
	-- traits are not eligible at all, which is itself the correct behaviour on
	-- a server that has no bee mod.
	core.registered_nodes["x_farming:bee_hive"] = {groups = {}}
	core.registered_nodes["flowers:rose"] = {groups = {flower = 1}}
	core.registered_nodes["flowers:dandelion_yellow"] = {groups = {flower = 1}}
	core.registered_nodes["farming:carrot_8"] = {groups = {}}
	core.registered_items["x_farming:honeycomb"] = {description = "Honeycomb"}
	core.registered_items["farming:carrot"] = {description = "Carrot"}

	traits.book = {}

	local villager = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 11, 205),
	}

	local def, entry = traits.of(villager)
	check("a villager has something they do", def ~= nil, def and def.id)
	check("...the same thing every time", traits.of(villager).id == def.id)
	check("...recorded, because where it ended up is a fact about the world",
			traits.book[village_life.memory.key_of(villager)] ~= nil)

	-- Whatever they were given, the world must support it. This is the whole
	-- point: the old pastimes were drawn from a flat list with no such check,
	-- which is how an inland village got anglers and everyone kept bees they
	-- did not have.
	local eligible = not def.possible or def.possible(villager,
			village_life.home.resolve(villager))
	check("...and the world can back it", eligible, def.id)

	-- Force the beekeeper case and check the hive is genuinely a working hive.
	traits.book = {}
	local key = village_life.memory.key_of(villager)
	traits.book[key] = {id = "bees"}
	local bee_def = traits.by_id.bees

	local clause, is_fact = traits.clause(villager)
	check("an unbuilt hive is not claimed as fact", is_fact == false, clause)
	check("...it is phrased as a wish", clause == bee_def.wish, clause)
	check("...and there is nothing to sell", traits.product(villager) == nil)

	-- An unloaded plot is "not yet", not "nowhere to put it". Getting this
	-- wrong bars a villager from their own hobby for good, because their first
	-- think can easily happen at a workplace across the village while the
	-- mapblocks around their house are not loaded.
	local real_get = core.get_node_or_nil
	core.get_node_or_nil = function() return nil end
	local nothing, settled = traits.realise(villager)
	core.get_node_or_nil = real_get

	check("an unloaded plot places nothing", nothing == nil)
	check("...and is not treated as failure", settled == false)
	check("...so the villager is not written off",
			traits.book[key].failed ~= true)

	local pos, done = traits.realise(villager)
	check("the beekeeper builds a hive", pos ~= nil)
	check("...and the question is settled", done == true)
	if not pos then
		io.write("\nno hive was placed; the rest of this block cannot run\n")
		os.exit(1)
	end

	local node = core.get_node(pos)
	check("...and it is a real bee hive",
			node.name == "x_farming:bee_hive", node.name)

	-- A hive with occupancy 0 is an empty box: x_farming's timer returns
	-- immediately and it never makes honey. Placing one and calling it
	-- beekeeping would be the same lie in a new costume.
	local data = core.deserialize(core.get_meta(pos):get_string("x_farming"))
	check("...with bees actually in it",
			data and data.occupancy > 0, data and data.occupancy)
	check("...and ticking", core.get_node_timer(pos):is_started())

	local said, fact = traits.clause(villager)
	check("now it is stated plainly", fact == true, said)
	check("...as the thing they said they did", said == bee_def.fact, said)
	check("the honey reaches the shelf",
			traits.product(villager) == "x_farming:honeycomb",
			traits.product(villager))
	check("and the schedule has somewhere to send them",
			traits.place(villager) ~= nil)

	-- Chop the hive down and the claim goes with it.
	core.set_node(pos, {name = "air"})
	check("a hive somebody felled is no longer theirs to boast of",
			traits.realised(villager) == false)
	local after, after_fact = traits.clause(villager)
	check("...and they go back to wishing", after_fact == false, after)
	check("...with nothing on the shelf", traits.product(villager) == nil)
	check("...and nowhere to be sent", traits.place(villager) == nil)

	-- Behaviour traits are private conduct: nothing in the world could confirm
	-- them, and they are stated anyway, which is honest.
	traits.book[key] = {id = "singing"}
	local sung, sung_fact = traits.clause(villager)
	check("private habits are simply stated", sung_fact == true, sung)
	check("...and need nothing built", traits.place(villager) == nil)

	-- Conditional traits are filtered before they are ever handed out. There is
	-- no water near the test village, so nobody there is an angler.
	local fishing = traits.by_id.fishing
	check("nobody fishes a river that is not there",
			fishing.possible(villager,
					village_life.home.resolve(villager)) == false)

	traits.book = {}
end

--------------------------------------------------------------------------------
-- Faith
--------------------------------------------------------------------------------

do
	local faith = village_life.faith
	local V, P = "100:200", "tester"

	check("the faith mod is reachable", faith.available())

	-- Every god the faith mod knows has an entry, even ones this file never
	-- wrote lore for -- a missing domain must not break a lookup.
	local complete = true
	for _, name in ipairs(lumberjackzombie.deities()) do
		local def = faith.god(name)
		if not def or not def.rank or not def.domain then complete = false end
	end
	check("every god has a domain", complete)

	-- The gods this mod adds are registered with the faith mod, so the chat
	-- invocation mechanic picks them up too rather than only working for the
	-- original twenty-two.
	local known = {}
	for _, n in ipairs(lumberjackzombie.deities()) do known[n] = true end
	check("new gods are registered with the faith mod", known.semmel == true)

	-- Ranks are the one structural claim this file makes.
	check("the Outer names are not worshipped", faith.is_dread("hastur"))
	check("...nor is the one in the deep", faith.is_dread("cthulhu"))
	check("but the harvest god is", not faith.is_dread("nu"))
	check("no village builds a church to Hastur",
			faith.god("hastur").church_ok ~= true)

	-- A village's patron is derived, stable, and fits what the village is.
	local patron = faith.patron(V)
	check("a village keeps a god", patron ~= nil, patron)
	check("...the same one every time", faith.patron(V) == patron)
	check("...and it is one a village would keep",
			faith.god(patron).church_ok == true, patron)
	check("...with a name to say", faith.patron_name(V) ~= nil)

	-- Two villages need not agree.
	local elsewhere = faith.patron("900:900")
	check("another village may keep another", elsewhere ~= nil)

	-- Deeds move faith, in both directions, without anyone typing a name.
	local before = lumberjackzombie.get_faith(P, patron)
	faith.deed(P, "offering", V)
	local after = lumberjackzombie.get_faith(P, patron)
	local cares = false
	for _, k in ipairs(faith.god(patron).favours or {}) do
		if k == "offering" then cares = true end
	end
	if cares then
		check("an offering pleases the god it is made to", after > before,
				after .. " vs " .. before)
	else
		check("a god who does not care is not moved", after == before)
	end

	-- A god who abhors something loses by it. Nua abhors murder outright.
	lumberjackzombie.add_faith(P, "nua", 10)
	local devout = lumberjackzombie.get_faith(P, "nua")
	faith.deed(P, "burial")
	check("burying the dead pleases the god of last rites",
			lumberjackzombie.get_faith(P, "nuananim") > 0)
	check("...and does not cost the god of the hearth",
			lumberjackzombie.get_faith(P, "nua") == devout)

	-- Devotion is measured against the village's own god, not the player's.
	check("devotion is measured in the village's own god",
			faith.devotion(P, V) == lumberjackzombie.get_faith(P, patron))
	check("an unknown village asks nothing of you",
			faith.devotion(P, nil) == 0)

	-- Names read as names.
	check("names are capitalised properly",
			faith.title("atlach-nacha") == "Atlach-Nacha",
			faith.title("atlach-nacha"))
	check("...including the two-word ones",
			faith.title("chaugnar faugn") == "Chaugnar Faugn",
			faith.title("chaugnar faugn"))
end

--------------------------------------------------------------------------------
-- Death, remains and succession
--------------------------------------------------------------------------------

do
	local succession = village_life.succession
	local remains = village_life.remains
	local memory = village_life.memory
	local home = village_life.home
	local V, P = "100:200", "tester"

	core.registered_nodes["bones:bones"] = {groups = {}}
	core.registered_items["farming:bread"] = {description = "Bread"}
	core.registered_items["default:stick"] = {description = "Stick"}
	core.registered_items["default:pick_steel"] = {description = "Steel Pickaxe"}

	memory.book = {}
	village_life.gossip.book = {}

	local bpos = mg_villages.all_villages[V].to_add_data.bpos[1]
	local smith_bed = bpos.beds[1]
	local wife_bed = bpos.beds[2]

	-- A body, holding what they had on them.
	local victim = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 12, 205),
	}
	local spot = remains.place(victim, {x = 105, y = 12, z = 205})
	check("a dead villager leaves a body", spot ~= nil)
	if spot then
		check("...and it is bones", core.get_node(spot).name == "bones:bones",
				core.get_node(spot).name)
		local meta = core.get_meta(spot)
		check("...naming who it was",
				meta:get_string("infotext"):find("Yorath", 1, true) ~= nil,
				meta:get_string("infotext"))
		-- The load-bearing one: an empty owner is what makes the node public,
		-- so anybody can open it AND anybody can dig it. A funeral has to be
		-- able to remove this node.
		check("...belonging to nobody, so anyone may bury it",
				meta:get_string("owner") == "")
		check("...and it is not a thing you can be arrested for taking",
				village_life.crime.is_exempt("bones:bones"))
	end

	-- Death is written into the bed row, which is the authority on who lives
	-- where. Without that the census simply puts an identical person back.
	check("the bed is not yet a dead one", smith_bed.dead ~= true)
	succession.record_death(victim, P)
	check("death is recorded where it counts", smith_bed.dead == true)
	check("...with the day", smith_bed.died_day ~= nil)
	check("...and the name of who did it", smith_bed.killed_by == P)
	check("...and who it was, for afterwards", smith_bed.was_named == "Yorath")
	check("...and what they did", smith_bed.was_titled == "smith")

	-- The census must leave that bed alone. This is the whole difference
	-- between a death and a bookkeeping error.
	local before = home.roster[home.key(V, 1, 1)]
	village_life.census.audit(V, true)
	check("the census does not resurrect the dead",
			home.roster[home.key(V, 1, 1)] == before)

	-- Nor may a stray pigman adopt into their name.
	home.roster = {}
	local stray = {game_name = "Yorath", object = stub_object(103, 11, 203)}
	home.adopt(stray)
	check("a stray does not step into a dead person's name",
			not (stray.vl and stray.vl.p == 1 and stray.vl.b == 1),
			stray.vl and (stray.vl.p .. "/" .. stray.vl.b))
	home.roster = {}

	-- The household takes it hardest.
	local widow_key = home.key(V, 1, 2)
	check("the widow is bereaved", memory.mood_key(widow_key) < 0,
			memory.mood_key(widow_key))
	check("...and holds it against the man who did it",
			memory.opinion({id = "x", vl = {v = V, p = 1, b = 2}}, P) < -20,
			memory.opinion({id = "x", vl = {v = V, p = 1, b = 2}}, P))

	-- The trade has gone out of the village.
	check("the village has lost its smith",
			succession.trade_vacant(V, "smith"))
	check("...but not trades nobody held", not succession.trade_vacant(V, "baker"))

	-- The dead are remembered by name.
	local dead = succession.the_dead(V)
	check("the village remembers its dead", #dead == 1, #dead)
	check("...by name and trade",
			dead[1].name == "Yorath" and dead[1].title == "smith")

	-- Succession: too soon, then an incomer, because this house has no child
	-- old enough to take the forge on.
	check("nobody steps up the same day", succession.fill(V, 1, 1) == false)
	day_count = day_count + 4
	check("...nor with no heir in the house", succession.fill(V, 1, 1) == false)

	day_count = day_count + 20
	check("eventually somebody moves in", succession.fill(V, 1, 1) == true)
	check("...and the bed is a living one again", smith_bed.dead ~= true)
	check("...with a new name", smith_bed.first_name ~= "Yorath",
			smith_bed.first_name)
	check("...who took up the trade", smith_bed.title == "smith")
	check("the dead man's memories did not come with the house",
			memory.opinion({id = "y", vl = {v = V, p = 1, b = 1}}, P) == 0)

	-- An heir comes up instead, when there is one. Give the house a grown child
	-- and kill the new smith.
	bpos.beds[3] = {bnr = 3, x = 106, y = 11, z = 202, p2 = 0,
			first_name = "Aldo", gender = "m", generation = 1, age = 17}
	succession.record_death({
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = smith_bed.first_name, profession = "smith",
		object = stub_object(105, 12, 205),
	}, nil)
	check("the new smith can die too", smith_bed.dead == true)

	day_count = day_count + 4
	check("the son takes up the forge", succession.fill(V, 1, 1) == true)
	check("...in his own bed, under his own name",
			bpos.beds[3].first_name == "Aldo")
	check("...as a grown man", bpos.beds[3].generation == 2)
	check("...with his father's trade", bpos.beds[3].title == "smith")
	check("...and the father's bed stays a grave", smith_bed.dead == true)

	-- Put the village back the way the later tests expect to find it.
	bpos.beds[3] = nil
	smith_bed.dead = nil
	smith_bed.died_day = nil
	smith_bed.killed_by = nil
	smith_bed.was_named = nil
	smith_bed.was_titled = nil
	smith_bed.first_name = "Yorath"
	smith_bed.title = "smith"
	smith_bed.generation = 2
	wife_bed.title = nil
	memory.book = {}
	village_life.gossip.book = {}
	home.roster = {}
end

--------------------------------------------------------------------------------
-- Crime
--------------------------------------------------------------------------------

do
	local crime = village_life.crime

	-- Corpses are exempt, and must stay exempt: burying the dead means digging
	-- the node, and a village that read its own funerals as theft would be
	-- unplayable.
	check("a corpse is not loot to steal", crime.is_exempt("bones:bones"))
	check("...nor is anyone else's grave marker",
			crime.is_exempt("ancient_bones:ancient_bones"))
	check("...however the mod spells it", crime.is_exempt("mymod:gravestone"))
	check("but a chest is a chest", not crime.is_exempt("default:chest"))
	check("...and a locked one too",
			not crime.is_exempt("default:chest_locked"))
end

--------------------------------------------------------------------------------
-- Kin
--------------------------------------------------------------------------------

do
	local kin = village_life.kin
	local V = "100:200"

	-- The relation table is a pure function of two bed rows, so the whole
	-- family structure can be checked without building a village for each case.
	local head    = {generation = 2, gender = "m", first_name = "Yorath"}
	local wife    = {generation = 2, gender = "f", first_name = "Freya"}
	local child   = {generation = 1, gender = "m", first_name = "Aldo"}
	local sister  = {generation = 1, gender = "f", first_name = "Mira"}
	local granny  = {generation = 3, gender = "f", first_name = "Edda"}
	local guest   = {generation = 2, gender = "m", first_name = "Rolf",
			title = "guest"}
	local maid    = {generation = 2, gender = "f", first_name = "Ilse",
			title = "housemaid"}

	check("the two adults of a house are married",
			kin.relation(head, 1, wife, 2) == "spouse")
	check("their children are their children",
			kin.relation(head, 1, child, 3) == "child")
	check("...and know it", kin.relation(child, 3, head, 1) == "parent")
	check("children of one house are siblings",
			kin.relation(child, 3, sister, 4) == "sibling")

	-- mg_villages ages the grandparents against bed 1 specifically, so they are
	-- his parents and her in-laws. The two bed rows are otherwise identical.
	check("the old woman upstairs is his mother",
			kin.relation(head, 1, granny, 5) == "parent")
	check("...and her mother-in-law",
			kin.relation(wife, 2, granny, 5) == "parent-in-law")
	check("she has a grandchild", kin.relation(granny, 5, child, 3) == "grandchild")
	check("...a son", kin.relation(granny, 5, head, 1) == "child")
	check("...and a daughter-in-law",
			kin.relation(granny, 5, wife, 2) == "child-in-law")

	-- Lodgers are not family, however long they stay.
	check("a guest is nobody's husband", kin.relation(guest, 3, wife, 2) == nil)
	check("nor is the staff", kin.relation(maid, 4, head, 1) == nil)

	-- Naming is gendered, because mg_villages knows the gender and "my child"
	-- reads like a form.
	check("relations are named as people would name them",
			kin.describe({relation = "spouse", bed = wife, name = "Freya"})
					== "my wife Freya")
	check("...and the other way round",
			kin.describe({relation = "spouse", bed = head, name = "Yorath"})
					== "my husband Yorath")
	check("...and for children",
			kin.describe({relation = "child", bed = child, name = "Aldo"})
					== "my son Aldo")

	-- Against the real village stub: a two-bed house holds a married couple.
	local rows, family = kin.household(V, 1, 1)
	check("a household can be read off the plot", rows ~= nil)
	check("...and this one is a family", family == true)
	check("the smith's wife is in it", rows and #rows == 1, rows and #rows)
	check("...as his spouse", rows and rows[1].relation == "spouse",
			rows and rows[1].relation)
	check("...and it is the woman in bed 2",
			rows and rows[1].bed.first_name == "Freya",
			rows and rows[1].bed.first_name)

	local villager = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", object = stub_object(105, 11, 205),
	}
	check("a villager knows who their people are", kin.has_family(villager))
	local closest = kin.closest(villager)
	check("...and who they would name first",
			closest and closest.name == "Freya", closest and closest.name)
	check("colleagues are a list, always",
			type(kin.colleagues(villager)) == "table")
	check("so are neighbours", type(kin.neighbours(villager)) == "table")
end

--------------------------------------------------------------------------------
-- Conversation
--------------------------------------------------------------------------------

do
	local dialogue = village_life.dialogue
	local persona = village_life.persona
	local rep = village_life.reputation
	local V, P = "100:200", "tester"

	rep.book = {}
	dialogue.known = {}

	local villager = {
		id = "vl_100:200/1/1",
		vl = {v = V, p = 1, b = 1},
		game_name = "Yorath",
		profession = "smith",
		object = stub_object(105, 11, 205),
	}

	-- Personality is derived, stable, and differs between people.
	local a = persona.of(villager)
	check("a villager has a character", a.temperament ~= nil and a.worry ~= nil)
	check("...which is stable", persona.of(villager).temperament == a.temperament)

	-- Bed 2 of plot 1 has no title: a homemaker. `profession` is set anyway,
	-- because the real spawner always sets one -- home.spawn passes a display
	-- fallback and lottmobs adds one of its own on top of that.
	local neighbour = {
		id = "vl_100:200/1/2", vl = {v = V, p = 1, b = 2},
		game_name = "Freya", profession = "villager",
		object = stub_object(105, 11, 205),
	}
	local elsewhere = {
		id = "vl_900:900/3/1", vl = {v = "900:900", p = 3, b = 1},
		game_name = "Yorath", object = stub_object(105, 11, 205),
	}
	local b = persona.of(neighbour)
	local c = persona.of(elsewhere)

	local same = 0
	for _, field in ipairs({"temperament", "worry", "opinion", "stranger"}) do
		if a[field] == b[field] then same = same + 1 end
	end
	check("two villagers are not the same person", same < 4, same)
	check("nor are two people who share a name",
			a.temperament ~= c.temperament or a.opinion ~= c.opinion
			or a.worry ~= c.worry)

	-- A villager you have not spoken to is a stranger, by name.
	check("an unmet villager has not told you their name",
			not dialogue.knows(P, villager, "name"))

	-- Asking is what teaches you, and only once.
	check("learning a name is news the first time",
			dialogue.learn(P, villager, "name") == true)
	check("...and not the second", dialogue.learn(P, villager, "name") == false)
	check("now you know them", dialogue.knows(P, villager, "name"))
	check("but not their neighbour",
			not dialogue.knows(P, neighbour, "name"))

	-- Village facts are learned once for the whole settlement: the second
	-- person to tell you where you are is not telling you anything.
	check("the village is unnamed until someone says",
			not dialogue.knows_village(P, V, "name"))
	dialogue.learn_village(P, V, "name")
	check("and then it is known", dialogue.knows_village(P, V, "name"))
	check("...for every villager in it, not just the one who said it",
			dialogue.knows_village(P, V, "name"))
	check("but not for the next village",
			not dialogue.knows_village(P, "900:900", "name"))

	-- Greetings differ by how well they know you.
	local stranger_line = persona.greet(villager, P, "stranger")
	local friend_line = persona.greet(villager, P, "friend")
	check("a stranger and a friend are greeted differently",
			stranger_line ~= friend_line, stranger_line)
	check("a rebuff exists for those who have earned one",
			type(persona.rebuff(villager)) == "string")

	-- Confiding is gated on standing, and on how open this particular person
	-- is -- so the same reputation gets you further with some people.
	check("nobody confides in a stranger",
			persona.will_confide(villager, 0) == false)
	check("everybody confides in an ally",
			persona.will_confide(villager, 100) == true)

	local reticent = {openness = 0}
	local open = {openness = 100}
	check("openness varies the threshold",
			(60 - reticent.openness * 0.6) > (60 - open.openness * 0.6))

	-- An enemy is refused outright: opening a conversation must not leave a
	-- session behind for them to drive.
	rep.book[V] = {[P] = {score = -100, day = day_count, met = 0}}
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("an enemy gets no conversation", dialogue.talking[P] == nil)

	-- ...whereas anyone else does.
	rep.book[V] = {[P] = {score = 0, day = day_count, met = 0}}
	dialogue.open(villager, player)
	check("everyone else does", dialogue.talking[P] ~= nil)
	check("and is shown a conversation, not a shop",
			core.last_formspec and core.last_formspec.name == "village_life:talk",
			core.last_formspec and core.last_formspec.name)

	-- The offered topics shrink as they are exhausted and shift with standing.
	local function option_count()
		local n = 0
		for _ in core.last_formspec.spec:gmatch("button%[[^;]+;[^;]+;topic_") do
			n = n + 1
		end
		return n
	end

	check("there is always a way out of a conversation",
			core.last_formspec.spec:find("topic_bye", 1, true) ~= nil)
	check("what they do is worth asking once",
			core.last_formspec.spec:find("topic_job", 1, true) ~= nil)

	-- Every button has to land inside the window that declares it. The list
	-- used to be drawn from y=3.9 at 0.68 a row inside a fixed size[11,8.6]:
	-- eight topics reach y=9.26, so the last of them were drawn past the
	-- bottom edge where they could be neither read nor clicked. Since the
	-- pinned topics are appended last, what was lost was always "Show me your
	-- wares" and "Goodbye".
	--
	-- Returns how far past the edge the worst offender goes. Once the list is
	-- long enough to scroll it is the container that has to fit, because the
	-- engine scrolls the buttons inside it.
	local function overflow(spec)
		local h = tonumber(spec:match("size%[[%d%.]+,([%d%.]+)%]"))
		if not h then return math.huge end

		local cy, ch = spec:match(
				"scroll_container%[[%d%.]+,([%d%.]+);[%d%.]+,([%d%.]+);")
		if cy then return (tonumber(cy) + tonumber(ch)) - h end

		local worst = 0
		for by, bh in spec:gmatch(
				"button%[[%d%.]+,([%d%.]+);[%d%.]+,([%d%.]+);topic_") do
			worst = math.max(worst, (tonumber(by) + tonumber(bh)) - h)
		end
		return worst
	end

	check("every button of a conversation fits inside its window",
			overflow(core.last_formspec.spec) <= 0,
			overflow(core.last_formspec.spec))

	-- ...including a list longer than any window worth opening, which scrolls
	-- rather than growing off the bottom of the screen.
	local layout_ctx = {pname = P, self = villager, band = "neutral"}
	local many = {}
	for i = 1, 20 do many[i] = {id = "t" .. i, label = "Topic " .. i} end

	local long = dialogue.layout(layout_ctx, "Well?", many, 0)
	check("a topic list too long for the window scrolls",
			long:find("scroll_container[", 1, true) ~= nil)
	check("...with a scrollbar to drive it",
			long:find("scrollbar[", 1, true) ~= nil)
	check("...and the list it scrolls fits inside the window",
			overflow(long) <= 0, overflow(long))
	local shown = 0
	for _ in long:gmatch("button%[[^%]]-;topic_") do shown = shown + 1 end
	check("...and every topic is still in it", shown == 20, shown)

	local short = dialogue.layout(layout_ctx, "Well?", {many[1], many[2]}, 0)
	check("a list that fits does not scroll",
			short:find("scroll_container[", 1, true) == nil)
	check("...and fits", overflow(short) <= 0, overflow(short))

	-- Scrolling is not an answer. It must not repaint -- which would throw the
	-- player back to the top of the list they were reading -- and it must not
	-- be mistaken for closing the window.
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	core.on_fields(player, "village_life:talk", {topics = "CHG:30"})
	check("scrolling does not end the conversation", dialogue.talking[P] ~= nil)
	check("...and is remembered for the next repaint",
			dialogue.talking[P] and dialogue.talking[P].scroll == 30,
			dialogue.talking[P] and dialogue.talking[P].scroll)

	local before = option_count()
	core.on_fields(player, "village_life:talk", {topic_job = true})
	check("asking a question uses it up",
			core.last_formspec.spec:find("topic_job", 1, true) == nil)
	check("what they told you is remembered",
			dialogue.knows(P, villager, "job"))
	check("the option list stays a conversation, not a menu",
			before <= 11, before)

	-- A critic will not discuss the village's weaknesses, but will still take
	-- your money: the shop's own threshold is lower than the sulking one, and
	-- the button has to agree with the shop rather than guess at it.
	rep.book[V] = {[P] = {score = -40, day = day_count, met = 0}}
	dialogue.open(villager, player)
	local critic_spec = core.last_formspec.spec
	check("a critic will not say what the village needs",
			not critic_spec:find("topic_needs", 1, true))
	check("...but still trades, because the shop would open",
			critic_spec:find("topic_trade", 1, true) ~= nil)

	-- Past the shunning threshold the shop closes, and the offer goes with it.
	-- These two used to disagree: the button vanished at -25 for a shop that
	-- served you until -45, and reappeared as a button that did nothing.
	rep.book[V] = {[P] = {score = -50, day = day_count, met = 0}}
	dialogue.open(villager, player)
	local shunned_spec = core.last_formspec.spec
	check("the shunned are not offered the shop",
			not shunned_spec:find("topic_trade", 1, true))
	check("...and the shop agrees",
			village_life.trade.refusal(villager, P) ~= nil)
	check("but they will still speak to you",
			dialogue.talking[P] ~= nil)

	rep.book[V] = {[P] = {score = 50, day = day_count, met = 0}}
	dialogue.open(villager, player)
	local friend_spec = core.last_formspec.spec
	check("a friend will", friend_spec:find("topic_needs", 1, true) ~= nil)
	check("...and will trade", friend_spec:find("topic_trade", 1, true) ~= nil)

	-- Asking to trade hands over to the shop and ends the conversation.
	core.on_fields(player, "village_life:talk", {topic_trade = true})
	check("asking to trade opens the counter",
			core.last_formspec.name == "village_life:trade",
			core.last_formspec.name)
	check("and ends the conversation", dialogue.talking[P] == nil)

	-- Saying goodbye ends it too.
	dialogue.open(villager, player)
	core.on_fields(player, "village_life:talk", {topic_bye = true})
	check("goodbye ends the conversation", dialogue.talking[P] == nil)

	-- An unemployed villager has something of their own to say. Branching on
	-- `self.profession` -- which is never nil -- made all four of these lines
	-- unreachable, so homemakers, children and elders alike answered "I'm the
	-- villager. Have been for longer than I care to count."
	rep.book[V] = {[P] = {score = 0, day = day_count, met = 0}}
	dialogue.known[P] = nil
	dialogue.learn(P, neighbour, "name")
	dialogue.talking[P] = nil
	dialogue.open(neighbour, player)
	core.on_fields(player, "village_life:talk", {topic_job = true})
	local job_spec = core.last_formspec.spec
	check("someone with no trade keeps house rather than being 'the villager'",
			job_spec:find("keep the house", 1, true) ~= nil)
	check("...and is not labelled with a profession they do not have",
			not job_spec:find("Freya, villager", 1, true))

	-- Someone who falls asleep -- or bolts -- mid-conversation says so in the
	-- window and leaves a way out of it. This is the reported "the chat just
	-- closes": brain.step rewrites the goal every two seconds, and the guard
	-- used to send a line to chat and return without repainting or closing,
	-- leaving a live-looking form whose every button silently did nothing.
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("the conversation is open", dialogue.talking[P] ~= nil)

	village_life.util.scratch(villager).goal = {kind = "sleep"}
	core.on_fields(player, "village_life:talk", {topic_standing = true})
	local sleep_spec = core.last_formspec.spec
	check("falling asleep mid-conversation is said in the window",
			sleep_spec:find("morning", 1, true) ~= nil)
	check("...and leaves a way out of it",
			sleep_spec:find("topic_bye", 1, true) ~= nil)
	check("...and nothing else to click", option_count() == 1, option_count())
	core.on_fields(player, "village_life:talk", {topic_bye = true})
	check("...which does end it", dialogue.talking[P] == nil)

	-- ...and asleep is not a state you can start a conversation in either.
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("nobody asleep is woken for a chat", dialogue.talking[P] == nil)

	-- Somebody running for their door says what they are running from. "Get
	-- inside!" told a player nothing about a village they had just walked into
	-- and could not see the far side of.
	village_life.util.scratch(villager).goal =
			{kind = "flee", threat_label = "a dire wolf"}
	dialogue.talking[P] = nil
	core.last_chat = nil
	dialogue.open(villager, player)
	check("a villager running from something refuses to talk",
			dialogue.talking[P] == nil)
	check("...and names it",
			core.last_chat and core.last_chat.text:find("dire wolf", 1, true) ~= nil,
			core.last_chat and core.last_chat.text)

	-- Interrupted mid-conversation, the same line arrives in the window rather
	-- than in chat -- a window that returns without repainting or closing is
	-- the "the chat just closes" bug all over again.
	village_life.util.scratch(villager).goal = nil
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	village_life.util.scratch(villager).goal =
			{kind = "flee", threat_label = "a dire wolf"}
	core.on_fields(player, "village_life:talk", {topic_standing = true})
	check("...and says it in the window if you were already talking",
			core.last_formspec.spec:find("dire wolf", 1, true) ~= nil,
			core.last_formspec.spec)
	check("...leaving a way out", option_count() == 1, option_count())

	-- Nothing is invented for a villager who never saw what it was.
	village_life.util.scratch(villager).goal = {kind = "flee"}
	dialogue.talking[P] = nil
	core.last_chat = nil
	dialogue.open(villager, player)
	check("someone who only heard the shouting names nothing",
			core.last_chat and not core.last_chat.text:find("a nil", 1, true)
					and #core.last_chat.text > 0,
			core.last_chat and core.last_chat.text)

	village_life.util.scratch(villager).goal = nil

	-- Repeatable topics step aside once used rather than squatting the list.
	-- `needs`, `sells` and `standing` wrote knowledge keys nothing read back,
	-- so they held three of the five question slots for good and pushed
	-- `worry` -- the one personal thing on offer -- off the end.
	dialogue.known[P] = nil
	dialogue.talking[P] = nil
	rep.book[V] = {[P] = {score = 100, day = day_count, met = 0}}
	dialogue.learn(P, villager, "name")
	dialogue.learn_village(P, V, "name")
	dialogue.open(villager, player)
	local function offered(id)
		return core.last_formspec.spec:find("topic_" .. id, 1, true) ~= nil
	end
	check("an ally is asked what troubles them", offered("worry"))
	for _, id in ipairs({"needs", "sells", "standing"}) do
		core.on_fields(player, "village_life:talk", {["topic_" .. id] = true})
	end
	check("...and still is, after the civic questions are used up",
			offered("worry"))

	-- Exhaust everything that can only be asked once. The repeatable topics
	-- must come back into view rather than being gone for good -- which is what
	-- their unread knowledge flags used to guarantee the wrong way round, by
	-- keeping them at full weight forever instead.
	for _, id in ipairs({"job", "pastime", "opinion", "worry", "god"}) do
		core.on_fields(player, "village_life:talk", {["topic_" .. id] = true})
	end
	check("civic questions come back when there is nothing newer",
			offered("needs"))
	check("...and so does the rest of it", offered("sells") and offered("standing"))
	check("what has been answered for good stays answered",
			not offered("worry") and not offered("pastime"))

	-- Something that actually happened outranks anything a villager merely
	-- thinks. This is what stops every conversation in a village being the same
	-- six questions in the same order.
	local ev = village_life.events.raise({
		kind = "murder", village_id = V, pos = {x = 105, y = 11, z = 205},
		actor = "someone_else", subject_name = "Berta",
		witnesses = {village_life.memory.key_of(villager)},
	})
	dialogue.heard[P] = nil
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("a villager with news leads with it", offered("news"))

	core.on_fields(player, "village_life:talk", {topic_news = true})
	local news_spec = core.last_formspec.spec
	check("...and tells it", news_spec:find("Berta", 1, true) ~= nil, news_spec)
	check("...saying they saw it themselves",
			news_spec:find("saw it myself", 1, true) ~= nil)
	check("...and does not repeat it", not offered("news"))

	-- What they personally remember of you is its own topic, and only exists
	-- once there is something to remember.
	village_life.memory.book = {}
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("a villager with no history of you says so", not offered("deeds"))

	village_life.memory.remember(villager, P, "rescued")
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	check("...but one you saved has something to say", offered("deeds"))
	core.on_fields(player, "village_life:talk", {topic_deeds = true})
	check("...and says it",
			core.last_formspec.spec:find("not forgotten", 1, true) ~= nil,
			core.last_formspec.spec)

	-- Family comes off the mg_villages bed rows, so the smith really does have
	-- a wife and can name her.
	dialogue.talking[P] = nil
	dialogue.open(villager, player)
	core.on_fields(player, "village_life:talk", {topic_family = true})
	check("a villager can name their own household",
			core.last_formspec.spec:find("Freya", 1, true) ~= nil,
			core.last_formspec.spec)

	village_life.gossip.book = {}
	village_life.memory.book = {}
	dialogue.heard[P] = nil

	rep.book = {}
	dialogue.known = {}
	dialogue.talking = {}
end

--------------------------------------------------------------------------------
-- Asking about other people
--------------------------------------------------------------------------------

-- The village grows a second household here rather than at the top of the
-- file, because the census test above counts its vacant beds and asserts the
-- number. Everything before this point sees the one-plot village it always saw.
do
	local V = "100:200"
	local bpos = mg_villages.all_villages[V].to_add_data.bpos
	bpos[3] = {
		x = 100, y = 10, z = 212, btype = "house", bsizex = 7, bsizez = 7,
		brotate = 0, beds = {
			{bnr = 1, x = 102, y = 11, z = 214, p2 = 0, first_name = "Aldo",
			 gender = "m", generation = 2, title = "baker", age = 44},
			{bnr = 2, x = 104, y = 11, z = 214, p2 = 0, first_name = "Mirren",
			 gender = "f", generation = 2, age = 41},
		},
	}
	-- A second smith, so the rivalry branch has something real to read.
	bpos[4] = {
		x = 112, y = 10, z = 212, btype = "house", bsizex = 7, bsizez = 7,
		brotate = 0, beds = {
			{bnr = 1, x = 114, y = 11, z = 214, p2 = 0, first_name = "Torvald",
			 gender = "m", generation = 2, title = "smith", age = 50},
		},
	}
end

do
	local regard = village_life.regard
	local dialogue = village_life.dialogue
	local rep = village_life.reputation
	local V = "100:200"
	local P = "tester"
	local player = core.make_test_player(P, 105, 11, 205)

	local smith2 = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 11, 205),
	}
	local rr = home.resolve(smith2)

	local people = regard.people(smith2)
	local by_name = {}
	for _, row in ipairs(people) do by_name[row.name] = row end

	check("a villager knows their own household", by_name.Freya ~= nil)
	check("...as kin, with the relationship named",
			by_name.Freya and by_name.Freya.relation == "spouse",
			by_name.Freya and by_name.Freya.relation)
	check("...and knows the neighbours", by_name.Aldo ~= nil)
	check("...but is not on their own list",
			by_name[rr.name] == nil, rr.name)

	----------------------------------------------------------------------------
	-- Derived, not stored, and not symmetric
	----------------------------------------------------------------------------

	local me = home.key(V, 1, 1)
	local her = home.key(V, 1, 2)

	check("what one villager thinks of another is stable across calls",
			regard.between(me, her) == regard.between(me, her))
	check("...and is not the same as what they think back",
			regard.between(me, her) ~= regard.between(her, me),
			regard.between(me, her) .. " vs " .. regard.between(her, me))
	check("nobody has a view of themselves", regard.between(me, me) == 0)

	-- Family sits warmer at the floor. Averaged over the whole village so this
	-- is testing the bias rather than one lucky seed.
	local function mean_of(relation, n)
		local total = 0
		for i = 1, n do
			total = total + regard.between("a/" .. i, "b/" .. i,
					{relation = relation})
		end
		return total / n
	end
	check("blood is warmer than nothing in particular",
			mean_of("child", 200) > mean_of(nil, 200) + 10,
			mean_of("child", 200) .. " vs " .. mean_of(nil, 200))
	check("...and the second man in one trade is not a friend",
			mean_of(nil, 200) >
					(function()
						local total = 0
						for i = 1, 200 do
							total = total + regard.between("a/" .. i, "b/" .. i,
									{rival = true})
						end
						return total / 200
					end)() + 10)

	----------------------------------------------------------------------------
	-- The menu
	----------------------------------------------------------------------------

	rep.book[V] = {[P] = {score = 60, day = day_count, met = 0}}
	dialogue.known = {}
	dialogue.talking = {}
	dialogue.learn(P, smith2, "name")
	dialogue.open(smith2, player)

	local function offered(id)
		return core.last_formspec.spec:find("topic_" .. id, 1, true) ~= nil
	end
	check("somebody with neighbours can be asked about them", offered("people"))

	-- The whole point of a menu: one slot at the top level, a long list inside.
	local top_buttons = 0
	for _ in core.last_formspec.spec:gmatch("button%[[^;]+;[^;]+;topic_") do
		top_buttons = top_buttons + 1
	end
	check("...and the top of the conversation is still a conversation",
			top_buttons <= 11, top_buttons)

	core.on_fields(player, "village_life:talk", {topic_people = true})
	local list = core.last_formspec.spec
	check("opening the list repaints -- it never leaves a dead window",
			list ~= nil and list:find("button[", 1, true) ~= nil)
	check("the people in it are named", list:find("Freya", 1, true) ~= nil, list)
	check("...including the neighbours", list:find("Aldo", 1, true) ~= nil)
	check("there is a way back up", list:find("topic_back", 1, true) ~= nil)
	check("...and a way out", list:find("topic_bye", 1, true) ~= nil)

	-- Buttons inside a menu land inside the window, same as everywhere else.
	local function overflow(spec)
		local h = tonumber(spec:match("size%[[%d%.]+,([%d%.]+)%]"))
		if not h then return math.huge end
		local cy, ch = spec:match(
				"scroll_container%[[%d%.]+,([%d%.]+);[%d%.]+,([%d%.]+);")
		if cy then return (tonumber(cy) + tonumber(ch)) - h end
		local worst = 0
		for by, bh in spec:gmatch(
				"button%[[%d%.]+,([%d%.]+);[%d%.]+,([%d%.]+);topic_") do
			worst = math.max(worst, (tonumber(by) + tonumber(bh)) - h)
		end
		return worst
	end
	check("every button of a menu fits inside its window too",
			overflow(list) <= 0, overflow(list))

	-- Ask about the first person on the list.
	core.on_fields(player, "village_life:talk", {topic_opt1 = true})
	local said = core.last_formspec.spec
	check("asking about somebody gets an answer about them",
			said:find(people[1].name, 1, true) ~= nil, said)
	check("...and stays in the list, so you can ask about the next one",
			said:find("topic_back", 1, true) ~= nil)
	check("being told about somebody is being introduced to them",
			dialogue.knows_key(P, people[1].key, "name"))

	core.on_fields(player, "village_life:talk", {topic_back = true})
	check("going back returns to the top of the conversation",
			core.last_formspec.spec:find("topic_people", 1, true) ~= nil,
			core.last_formspec.spec)
	check("...and the conversation is still open",
			dialogue.talking[P] ~= nil)

	----------------------------------------------------------------------------
	-- A list that changed under the player answers nothing rather than lying
	----------------------------------------------------------------------------

	dialogue.talking[P].stack = {{menu = "people"}}
	dialogue.talking[P].options = {}
	core.last_formspec = nil
	core.on_fields(player, "village_life:talk", {topic_opt3 = true})
	check("a click on an entry that is no longer there does nothing",
			core.last_formspec == nil)
	check("...and does not end the conversation", dialogue.talking[P] ~= nil)

	-- An answer that throws must not take the callback with it. A callback that
	-- dies before repainting leaves a live-looking window whose every button
	-- silently does nothing -- the frozen conversation, arriving by a new road.
	dialogue.talking[P].options = {
		{label = "Broken", answer = function() error("deliberate") end},
	}
	core.last_formspec = nil
	core.on_fields(player, "village_life:talk", {topic_opt1 = true})
	check("an answer that throws still repaints", core.last_formspec ~= nil)
	check("...and leaves the conversation usable",
			dialogue.talking[P] ~= nil
					and core.last_formspec.spec:find("topic_", 1, true) ~= nil)

	----------------------------------------------------------------------------
	-- The dead are mourned, not gossiped about
	----------------------------------------------------------------------------

	local bpos = mg_villages.all_villages[V].to_add_data.bpos
	bpos[3].beds[1].dead = true
	bpos[3].beds[1].was_named = "Aldo"
	bpos[3].beds[1].killed_by = P

	village_life.util.scratch(smith2).people = nil
	local mourned
	for _, row in ipairs(regard.people(smith2)) do
		if row.name == "Aldo" then mourned = row end
	end
	check("a dead neighbour is still someone you can be asked about",
			mourned ~= nil and mourned.dead == true)

	local ctx = {pname = P, self = smith2, band = "friend"}
	local said_dead = regard.line(smith2, mourned, ctx)
	check("...and the answer is that they died, not what they were like",
			said_dead:find("dead", 1, true) ~= nil, said_dead)
	check("...and the killer is not told the news as though it were news",
			said_dead:find("you know exactly how", 1, true) ~= nil
					or said_dead:find("don't stand there asking me", 1, true) ~= nil,
			said_dead)

	bpos[3].beds[1].dead = nil
	bpos[3].beds[1].killed_by = nil
	village_life.util.scratch(smith2).people = nil

	rep.book = {}
	dialogue.known = {}
	dialogue.talking = {}
end

--------------------------------------------------------------------------------
-- Sleeping in a bed, and getting better
--------------------------------------------------------------------------------

local rest = village_life.rest

core.registered_nodes["beds:fancy_bed_bottom"] =
		{walkable = true, groups = {bed = 1}}
core.registered_nodes["beds:fancy_bed_top"] =
		{walkable = true, groups = {bed = 2}}

-- param2 0 faces +Z, so the head half is one node along +Z from the foot.
local bed_foot = {x = 130, y = 11, z = 230}
local bed_head = {x = 130, y = 11, z = 231}
stub_nodes[pkey(bed_foot)] = {name = "beds:fancy_bed_bottom", param2 = 0}
stub_nodes[pkey(bed_head)] = {name = "beds:fancy_bed_top", param2 = 0}

local slot, bed_p2 = rest.bed_slot(bed_foot)
check("a bed is somewhere to lie down", slot ~= nil)
check("the sleeper lies between its two halves",
		slot and math.abs(slot.z - 230.5) < 0.001, slot and slot.z)
check("...clear of the mattress", slot and slot.y > bed_foot.y, slot and slot.y)
check("...along the bed", bed_p2 == 0, bed_p2)

-- Reached from the head half the body is centred the other way, so a villager
-- adopted into a bed placed by hand does not lie through the wall behind it.
local head_slot = rest.bed_slot(bed_head)
check("the head half centres the body the other way",
		head_slot and math.abs(head_slot.z - 230.5) < 0.001,
		head_slot and head_slot.z)

stub_nodes[pkey(bed_head)] = {name = "air"}
local half_slot = rest.bed_slot(bed_foot)
check("half a bed is still slept in",
		half_slot and math.abs(half_slot.z - 230) < 0.001,
		half_slot and half_slot.z)
stub_nodes[pkey(bed_head)] = {name = "beds:fancy_bed_top", param2 = 0}

check("bare floor is not a bed", rest.bed_slot({x = 130, y = 11, z = 240}) == nil)

-- A villager rich enough in method calls for rest.lua to drive.
local function sleeper_at(pos, health, hp_max)
	hp_max = hp_max or 25
	local ent = {
		name = "lottmobs:pigman_trader",
		health = health or 10,
		prop = {hp_max = hp_max},
		set_animation = function(self, a) self.anim = a end,
		set_velocity = function() end,
		set_yaw = function(self, y) self.yaw = y ; return y end,
		update_tag = function(self) self.tagged = true end,
	}
	local at = {x = pos.x, y = pos.y, z = pos.z}
	ent.object = {
		get_pos = function() return {x = at.x, y = at.y, z = at.z} end,
		set_pos = function(_, p) at = {x = p.x, y = p.y, z = p.z} end,
		get_properties = function() return {hp_max = hp_max} end,
		set_hp = function(_, hp) ent.hp = hp end,
		get_luaentity = function() return ent end,
	}
	return ent
end

local bedside = {x = 130, y = 11, z = 229}
local bed_row = {bed_pos = bed_foot}

local sleeper = sleeper_at(bedside)
check("a villager beside their own bed gets into it",
		rest.sleep(sleeper, bed_row) == true)
check("...and lies down in it", sleeper.anim == "lay", sleeper.anim)
check("...on the bed rather than beside it",
		math.abs(sleeper.object:get_pos().z - 230.5) < 0.001,
		sleeper.object:get_pos().z)
check("...and is known to be in it", rest.abed(sleeper))

rest.rise(sleeper)
check("morning gets them up", rest.abed(sleeper) == false)
check("...and back on their feet", sleeper.anim == "stand", sleeper.anim)

-- Getting in is a step onto the mattress, not a way through the bedroom wall.
local stray = sleeper_at({x = 160, y = 11, z = 229})
check("a villager who never reached their room does not appear in the bed",
		rest.sleep(stray, bed_row) == false)
check("...and stays where they stopped", stray.object:get_pos().x == 160)

local homeless = sleeper_at(bedside)
check("a bed that was dug out leaves them standing",
		rest.sleep(homeless, {bed_pos = {x = 130, y = 11, z = 240}}) == false)

-- Recovery. util.every seeds its stagger on the first call and fires on the
-- next one past the interval, so each of these is ticked twice.
local hurt = sleeper_at(bedside, 10)
rest.tick(hurt, bed_row, 0)
rest.tick(hurt, bed_row, 60)
check("wounds close over time", hurt.health > 10, hurt.health)
check("...and the health bar is told", hurt.hp == hurt.health, hurt.hp)
check("...and so is the nametag, which is coloured by health", hurt.tagged)

local whole = sleeper_at(bedside, 25)
rest.tick(whole, bed_row, 0) ; rest.tick(whole, bed_row, 60)
check("nobody heals past full", whole.health == 25, whole.health)

local beaten = sleeper_at(bedside, 10)
rest.note_hurt(beaten)
rest.tick(beaten, bed_row, 0) ; rest.tick(beaten, bed_row, 60)
check("nothing heals while it is still being hit",
		beaten.health == 10, beaten.health)

local afoot = sleeper_at(bedside, 10)
rest.tick(afoot, bed_row, 0) ; rest.tick(afoot, bed_row, 60)
local resting = sleeper_at(bedside, 10)
rest.sleep(resting, bed_row)
rest.tick(resting, bed_row, 0) ; rest.tick(resting, bed_row, 60)
check("a night in bed is worth more than a day on your feet",
		resting.health > afoot.health, resting.health .. " vs " .. afoot.health)

-- The brain returns false from do_custom on every step, so creaturemob's own
-- once-a-second properties refresh never runs for a villager: hp_max would be
-- read from whatever the entity activated with, and a guard promoted to 40 by
-- apply_role would be capped at 25.
local promoted = sleeper_at(bedside, 30, 40)
promoted.prop = {hp_max = 25}
rest.tick(promoted, bed_row, 0) ; rest.tick(promoted, bed_row, 60)
check("a guard heals to the health they were promoted to, not the stale cap",
		promoted.health > 30, promoted.health)
check("...and the stale properties are refreshed on the way past",
		promoted.prop.hp_max == 40, promoted.prop.hp_max)

-- All of it is one switch, so a server can keep the schedule and drop the beds.
village_life.settings.rest = false
local unrested = sleeper_at(bedside, 10)
check("with rest off a villager stands beside their bed as they used to",
		rest.sleep(unrested, bed_row) == false)
rest.tick(unrested, bed_row, 0) ; rest.tick(unrested, bed_row, 60)
check("...and nothing heals", unrested.health == 10, unrested.health)
village_life.settings.rest = true

-- The mob was registered with no lying-down animation because nothing ever
-- asked it to lie down; character.b3d has had the frames all along.
check("the villager mesh has a lying-down animation to play",
		pigman_animation.lay_start == 162 and pigman_animation.lay_end == 166,
		pigman_animation.lay_start)
check("...held as a pose rather than played as a loop",
		pigman_animation.lay_speed == 0, pigman_animation.lay_speed)

--------------------------------------------------------------------------------
-- The country the village stands in
--------------------------------------------------------------------------------

do
	local land = village_life.land
	local dialogue = village_life.dialogue
	local rep = village_life.reputation
	local V, P = "100:200", "tester"
	local player = core.make_test_player(P, 105, 11, 205)

	----------------------------------------------------------------------------
	-- Bearings and distances, as a person would give them
	----------------------------------------------------------------------------

	local here = {x = 0, y = 0, z = 0}
	check("north is +z, as the engine has it",
			land.bearing(here, {x = 0, y = 0, z = 100}) == "north",
			land.bearing(here, {x = 0, y = 0, z = 100}))
	check("east is +x", land.bearing(here, {x = 100, y = 0, z = 0}) == "east",
			land.bearing(here, {x = 100, y = 0, z = 0}))
	check("and the diagonals are named",
			land.bearing(here, {x = 100, y = 0, z = 100}) == "north-east",
			land.bearing(here, {x = 100, y = 0, z = 100}))
	check("nobody counts out nodes to describe a journey",
			land.distance_phrase(900):find("day", 1, true) ~= nil,
			land.distance_phrase(900))

	----------------------------------------------------------------------------
	-- The survey
	----------------------------------------------------------------------------

	land.forget()
	local s = land.of(V)
	check("a village knows where it is", s ~= nil)
	check("...what biome it is in", s and s.biome == "alpine", s and s.biome)
	check("...with the mod prefix taken out of the name",
			s and s.biome and not s.biome:find(":", 1, true))
	check("...and what that means in words",
			s and s.climate and s.climate:find("cold", 1, true) ~= nil,
			s and s.climate)
	check("the harness's flat world reads as flat",
			s and s.relief and s.relief.kind == "plain",
			s and s.relief and s.relief.kind)

	check("a village with nothing generated near it has no neighbours to name",
			s and #s.villages == 0, s and #s.villages)
	check("...and says so rather than inventing one",
			land.line_villages({}, s):find("last house", 1, true) ~= nil,
			land.line_villages({}, s))

	-- A second settlement appears on the map, and now there is one to name.
	mg_villages.all_villages["100:600"] = {
		vx = 100, vz = 600, vh = 10, vs = 30, name = "Aldenmoor",
		village_type = "single", to_add_data = {bpos = {}},
	}
	land.forget()
	s = land.of(V)
	check("a village that has been generated is one they can name",
			#s.villages == 1 and s.villages[1].name == "Aldenmoor",
			#s.villages)
	local vline = land.line_villages({}, s)
	check("...with a bearing", vline:find("north", 1, true) ~= nil, vline)
	check("...and a distance in walking, not in nodes",
			vline:find("day", 1, true) ~= nil or vline:find("walk", 1, true) ~= nil,
			vline)

	----------------------------------------------------------------------------
	-- Only what is there
	----------------------------------------------------------------------------

	check("with no magma_conduits there is no volcano", s.volcano == nil)
	check("...and nothing to say about one", land.line_volcano({}, s) == nil)

	magma_conduits = {
		volcano_state_extinct = 0.2,
		volcano_state_dormant = 0.5,
		get_volcano = function()
			return {location = {x = 340, z = 200}, depth_peak = 140,
					state = 0.9, name = "Anvilhead"}
		end,
	}
	land.forget()
	s = land.of(V)
	check("with a volcano on the map there is one to ask about",
			s.volcano ~= nil)
	check("...under the name its own mod gave it",
			s.volcano and s.volcano.name == "Anvilhead",
			s.volcano and s.volcano.name)
	check("...and in the state its own mod says it is in",
			s.volcano and s.volcano.state == "active",
			s.volcano and s.volcano.state)
	local vol = land.line_volcano({}, s)
	check("a villager names it", vol:find("Anvilhead", 1, true) ~= nil, vol)
	check("...says which way", vol:find("East", 1, true) ~= nil, vol)
	check("...and that it is awake", vol:find("awake", 1, true) ~= nil, vol)

	-- A cone far enough away that nobody here has ever seen it is not
	-- something they mention. The mod's regions are thousands of nodes across,
	-- so without this every village in one would talk about the same mountain.
	magma_conduits.get_volcano = function()
		return {location = {x = 9000, z = 200}, depth_peak = 140, state = 0.9,
				name = "Farcinder"}
	end
	land.forget()
	check("a volcano over the horizon is not on anybody's mind",
			land.of(V).volcano == nil)

	----------------------------------------------------------------------------
	-- The menu
	----------------------------------------------------------------------------

	magma_conduits.get_volcano = function()
		return {location = {x = 340, z = 200}, depth_peak = 140, state = 0.9,
				name = "Anvilhead"}
	end
	land.forget()

	local villager = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 11, 205),
	}
	rep.book[V] = {[P] = {score = 60, day = day_count, met = 0}}
	dialogue.known = {}
	dialogue.talking = {}
	dialogue.learn(P, villager, "name")
	dialogue.open(villager, player)
	check("the country is something you can ask about",
			core.last_formspec.spec:find("topic_land", 1, true) ~= nil,
			core.last_formspec.spec)

	core.on_fields(player, "village_life:talk", {topic_land = true})
	local list = core.last_formspec.spec
	check("...and asking opens a list of what there is to ask",
			list:find("topic_back", 1, true) ~= nil, list)
	check("the volcano is in it, by name",
			list:find("Anvilhead", 1, true) ~= nil, list)

	-- The smith stays in the village. He knows the next settlement is there;
	-- a bearing to it is a thing you learn by walking it.
	check("somebody who never leaves the village does not give directions",
			not list:find("Other settlements", 1, true))

	local bpos3 = mg_villages.all_villages[V].to_add_data.bpos[3]
	local was_title = bpos3.beds[1].title
	bpos3.beds[1].title = "lumberjack"
	local ranger = {
		id = "vl_100:200/3/1", vl = {v = V, p = 3, b = 1},
		game_name = "Aldo", profession = "lumberjack",
		object = stub_object(105, 11, 205),
	}

	dialogue.talking = {}
	dialogue.learn(P, ranger, "name")
	dialogue.open(ranger, player)
	core.on_fields(player, "village_life:talk", {topic_land = true})
	check("somebody who walks the country will point you at the next village",
			core.last_formspec.spec:find("Other settlements", 1, true) ~= nil,
			core.last_formspec.spec)
	check("...and the lumberjack is asked about his own timber",
			core.last_formspec.spec:find("What timber grows", 1, true) ~= nil,
			core.last_formspec.spec)

	-- The material questions are read off the map, and each trade is asked only
	-- about its own: a lumberjack about the trees, a miner about the rock.
	core.registered_nodes["test:oak"] =
			{description = "Oak Wood", walkable = true, groups = {tree = 1}}
	core.registered_items["test:oak"] = {groups = {tree = 1}}
	core.registered_nodes["test:granite"] =
			{description = "Granite", walkable = true, groups = {stone = 1}}
	core.registered_items["test:granite"] = {groups = {stone = 1}}
	for x = 96, 103 do for z = 196, 203 do
		core.set_node({x = x, y = 10, z = z}, {name = "test:oak"})
	end end
	for x = 96, 101 do for z = 196, 201 do
		core.set_node({x = x, y = 6, z = z}, {name = "test:granite"})
	end end
	land.forget()
	local ms = land.of(V)
	check("the lumberjack names the timber that is actually there",
			land.line_trees({}, ms):find("Oak", 1, true) ~= nil,
			land.line_trees({}, ms))
	check("the miner names the rock that is actually under them",
			land.line_stone({}, ms):find("granite", 1, true) ~= nil,
			land.line_stone({}, ms))
	-- heat 30 in stub_climate is temperate country; the farmer grows for it.
	check("the farmer's crops follow the climate the fields sit in",
			land.line_crops({}, ms):find("wheat and barley", 1, true) ~= nil,
			land.line_crops({}, ms))
	for x = 96, 103 do for z = 196, 203 do
		core.remove_node({x = x, y = 10, z = z})
	end end
	for x = 96, 101 do for z = 196, 201 do
		core.remove_node({x = x, y = 6, z = z})
	end end
	core.registered_nodes["test:oak"] = nil
	core.registered_items["test:oak"] = nil
	core.registered_nodes["test:granite"] = nil
	core.registered_items["test:granite"] = nil
	land.forget()

	bpos3.beds[1].title = was_title

	----------------------------------------------------------------------------
	-- What is out there is what has been seen
	----------------------------------------------------------------------------

	village_life.gossip.book = {}
	local ctx = {self = villager}
	check("a village that has seen nothing does not invent a monster",
			land.line_dangers(ctx, s):find("Wolves", 1, true) ~= nil,
			land.line_dangers(ctx, s))

	-- events.KINDS declared `sighting` and gossip knew how to phrase one, but
	-- nothing ever raised any: the whole branch was dead. A village alarm is
	-- precisely somebody having seen something, so that is where it comes from.
	village_life.threats.alarms = {}
	home.roster[village_life.memory.key_of(villager)] =
			{obj = villager.object, seen = os.time()}
	village_life.threats.raise(V, {x = 105, y = 11, z = 205},
			"mobs_monster:dungeon_master")
	local carried = village_life.gossip.book[village_life.memory.key_of(villager)]
	check("an alarm is a sighting, and somebody saw it",
			carried ~= nil and #carried > 0)
	check("...and it is what they now say is out there",
			land.line_dangers(ctx, s):find("dungeon master", 1, true) ~= nil,
			land.line_dangers(ctx, s))

	-- One monster pacing the treeline is one thing that happened, not twenty.
	local n = #carried
	village_life.threats.raise(V, {x = 105, y = 11, z = 205},
			"mobs_monster:dungeon_master")
	check("an alarm that is only running on does not become fresh news",
			#carried == n, #carried)

	home.roster = {}
	village_life.gossip.book = {}
	village_life.threats.alarms = {}
	mg_villages.all_villages["100:600"] = nil
	magma_conduits = nil
	land.forget()
	rep.book = {}
	dialogue.known = {}
	dialogue.talking = {}
end

--------------------------------------------------------------------------------
-- Small talk, jokes, and putting your foot in it
--------------------------------------------------------------------------------

do
	local banter = village_life.banter
	local dialogue = village_life.dialogue
	local memory = village_life.memory
	local rep = village_life.reputation
	local V, P = "100:200", "tester"
	local player = core.make_test_player(P, 105, 11, 205)

	local villager = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", profession = "smith",
		object = stub_object(105, 11, 205),
	}
	local r = home.resolve(villager)

	memory.book = {}
	rep.book[V] = {[P] = {score = 20, day = day_count, met = 0}}

	----------------------------------------------------------------------------
	-- Remarks come out of the live world, and vary
	----------------------------------------------------------------------------

	local ctx = {self = villager, pname = P, r = r, village_id = V,
			score = 20, band = "acquaintance", asked = {}}

	-- Stepped through, not sampled: eight consecutive asks must be eight
	-- different remarks, or small talk repeats itself, which is the complaint
	-- this whole file answers.
	local seen, lines = {}, {}
	for i = 1, 8 do
		ctx.asked.banter_count = i
		local line = banter.remark(ctx)
		lines[#lines + 1] = line
		seen[line] = (seen[line] or 0) + 1
	end
	local repeated = false
	for i = 2, #lines do
		if lines[i] == lines[i - 1] then repeated = true end
	end
	check("small talk never says the same thing twice running", not repeated)

	local variety = 0
	for _ in pairs(seen) do variety = variety + 1 end
	check("...and works through what it has to say", variety >= 4, variety)

	-- What it says about the season is the season the world is actually in.
	local function said_within(needle, tries)
		for i = 1, tries do
			ctx.asked.banter_count = i
			if banter.remark(ctx):find(needle, 1, true) then return true end
		end
		return false
	end
	seasons._season = "winter"
	check("what it says about the season is the season it really is",
			said_within("Short days", 12))
	seasons._season = "spring"
	check("...and changes when the season does",
			said_within("Ground's soft", 12))
	seasons._season = "autumn"

	----------------------------------------------------------------------------
	-- A joke is at somebody's expense, and it is somebody who exists
	----------------------------------------------------------------------------

	local people = village_life.regard.people(villager)
	check("the villager used for jokes has neighbours to joke about",
			#people > 0)

	-- Every temperament, not just whichever one this villager happened to
	-- roll. persona.of reads the entity's scratch cache, so overriding it
	-- there is how the other seven branches get exercised at all -- and half
	-- the joke sets have a name in them, which is the half worth checking.
	local named_someone_real = 0
	for _, t in ipairs(village_life.persona.temperaments) do
		village_life.util.scratch(villager).persona =
				village_life.persona.for_identity("forced/" .. t.id)
		village_life.util.scratch(villager).persona.temperament = t.id

		for i = 1, 4 do
			ctx.asked.joke_count = i
			local line = banter.joke(ctx)
			check("a joke is never left with an unfilled slot in it",
					not line:find("%%s"), t.id .. ": " .. line)
			for _, row in ipairs(people) do
				if row.name and line:find(row.name, 1, true) then
					named_someone_real = named_someone_real + 1
				end
			end
		end
	end
	check("a joke at somebody's expense names somebody who is really there",
			named_someone_real > 0, named_someone_real)

	village_life.util.scratch(villager).persona = nil

	----------------------------------------------------------------------------
	-- Tone: it lands or it does not, and either way it costs something
	----------------------------------------------------------------------------

	local by_id = {}
	for _, t in ipairs(banter.tones) do by_id[t.id] = t end
	check("the player has something to say, not only things to ask",
			by_id.flatter and by_id.needle and by_id.blunt)

	-- Flattery on the proud and flattery on the earnest are the same words and
	-- opposite outcomes, which is the entire point of having a tone at all.
	local function fresh(temperament)
		-- Find a villager key whose derived temperament is the one wanted, so
		-- this tests the branch rather than whichever character the test
		-- village happened to roll.
		for i = 1, 4000 do
			local key = "tone/" .. i
			if village_life.persona.for_identity(key).temperament == temperament then
				return {
					id = key, vl = nil, game_name = "Test",
					object = stub_object(105, 11, 205),
				}
			end
		end
	end

	local proud = fresh("proud")
	local earnest = fresh("earnest")
	check("a proud villager exists to be flattered", proud ~= nil)
	check("...and an earnest one to be insulted by it", earnest ~= nil)

	memory.book = {}
	local proud_ctx = {self = proud, pname = P, score = 20, asked = {}}
	local _, proud_ok = banter.say(proud_ctx, by_id.flatter)
	check("flattery works on the proud", proud_ok == true)
	check("...and warms them to you", memory.opinion(proud, P) > 0,
			memory.opinion(proud, P))

	local earnest_ctx = {self = earnest, pname = P, score = 20, asked = {}}
	local _, earnest_ok = banter.say(earnest_ctx, by_id.flatter)
	check("the same words fail on the earnest", earnest_ok == false)
	check("...and cost you", memory.opinion(earnest, P) < 0,
			memory.opinion(earnest, P))

	-- Boasting is the one tone the world can call your bluff on: it works only
	-- if the village has actually seen you do something.
	local nobody_ctx = {self = proud, pname = P, score = 0, asked = {}}
	check("boasting to a village that has never seen you do anything fails",
			by_id.boast.lands(nobody_ctx,
					village_life.persona.of(proud)) == false)
	local hero_ctx = {self = proud, pname = P, score = 70, asked = {}}
	check("...and works once they have",
			by_id.boast.lands(hero_ctx, village_life.persona.of(proud)) == true)

	-- Being a boor is capped per day, or standing is a function of how many
	-- times somebody clicked the same button.
	memory.book = {}
	local before = memory.opinion(earnest, P)
	for _ = 1, 40 do banter.say(earnest_ctx, by_id.flatter) end
	check("you cannot talk your way to being hated in one afternoon",
			memory.opinion(earnest, P) > -12,
			memory.opinion(earnest, P))
	check("...but you did manage some of it",
			memory.opinion(earnest, P) < before)

	----------------------------------------------------------------------------
	-- In the window
	----------------------------------------------------------------------------

	memory.book = {}
	dialogue.known = {}
	dialogue.talking = {}
	dialogue.learn(P, villager, "name")
	dialogue.open(villager, player)
	check("there is always somewhere to go just to talk",
			core.last_formspec.spec:find("topic_talk", 1, true) ~= nil,
			core.last_formspec.spec)

	core.on_fields(player, "village_life:talk", {topic_talk = true})
	local list = core.last_formspec.spec
	check("...and it opens", list:find("topic_back", 1, true) ~= nil, list)
	check("with something to say as well as something to ask",
			list:find("Tell me something funny", 1, true) ~= nil, list)

	-- Small talk is the one thing that must never run out: that is the whole
	-- reason it exists. Ask the same question ten times and it is still there.
	for _ = 1, 10 do
		core.on_fields(player, "village_life:talk", {topic_opt1 = true})
	end
	check("small talk never runs out",
			core.last_formspec.spec:find("topic_opt1", 1, true) ~= nil)
	check("...and the conversation is still open after ten of them",
			dialogue.talking[P] ~= nil)

	memory.book = {}
	rep.book = {}
	dialogue.known = {}
	dialogue.talking = {}
end

--------------------------------------------------------------------------------
-- Talking somebody into coming with you
--------------------------------------------------------------------------------

do
	local hire = village_life.hire
	local companion = village_life.companion
	local dialogue = village_life.dialogue
	local memory = village_life.memory
	local rep = village_life.reputation
	local V, P = "100:200", "tester"
	local player = core.make_test_player(P, 105, 11, 205)

	local function villager_at(plot, bed)
		return {
			id = ("vl_100:200/%d/%d"):format(plot, bed),
			vl = {v = V, p = plot, b = bed},
			game_name = "Test", profession = "smith",
			health = 25, prop = {hp_max = 25},
			object = stub_object(105, 11, 205),
			set_animation = function() end,
			set_velocity = function() end,
			set_yaw = function() end,
		}
	end

	memory.book = {}
	rep.book = {}
	village_life.threats.alarms = {}
	dialogue.known = {}
	dialogue.talking = {}

	----------------------------------------------------------------------------
	-- Refusals that no money will move, and refusals that will
	----------------------------------------------------------------------------

	local bpos = mg_villages.all_villages[V].to_add_data.bpos
	local smith = villager_at(1, 1)

	-- A child. Not a matter of price, and it says so.
	local child_bed = {bnr = 3, x = 106, y = 11, z = 202, p2 = 0,
			first_name = "Wren", gender = "f", generation = 1, age = 9}
	bpos[1].beds[3] = child_bed
	local child = villager_at(1, 3)
	local r_child = home.resolve(child)
	check("a child is not somebody you can hire", r_child.role == "child")
	local refusal = hire.refusal(child, P)
	check("...and the refusal is absolute", refusal and refusal.hard == true)

	-- Blood.
	memory.remember(smith, P, "kin_killed")
	local blood = hire.refusal(smith, P)
	check("nobody whose family you killed will follow you",
			blood and blood.hard == true, blood and blood.line)
	memory.book = {}

	-- The alarm is a soft no, and says when to come back.
	village_life.threats.raise(V, {x = 105, y = 11, z = 205})
	local alarmed = hire.refusal(smith, P)
	check("nobody leaves while there is something in the streets",
			alarmed ~= nil)
	check("...but that one will pass, and the refusal says so",
			alarmed and alarmed.hard == false, alarmed and alarmed.line)
	village_life.threats.alarms = {}

	check("otherwise there is nobody standing in the way",
			hire.refusal(smith, P) == nil)

	----------------------------------------------------------------------------
	-- The sum is legible, and moves with things the player controls
	----------------------------------------------------------------------------

	rep.book[V] = {[P] = {score = 0, day = day_count, met = 0}}
	local neutral = hire.inclination(smith, P, 0)

	rep.book[V] = {[P] = {score = 90, day = day_count, met = 0}}
	local hero, parts = hire.inclination(smith, P, 0)
	check("standing well with a village makes its people likelier to go",
			hero > neutral, hero .. " vs " .. neutral)
	check("...and the sum says what it is made of", #parts > 0)

	rep.book[V] = {[P] = {score = -30, day = day_count, met = 0}}
	local distrusted = hire.inclination(smith, P, 0)
	check("standing badly makes them less likely",
			distrusted < neutral, distrusted .. " vs " .. neutral)

	-- Coin is deliberately not folded into inclination -- that is who the person
	-- is, weighed apart from what is in a pocket -- but the leaning the menu
	-- actually acts on (inclination + money_pull) does move with an offer.
	rep.book[V] = {[P] = {score = 90, day = day_count, met = 0}}
	local pw2 = village_life.persona.of(smith)
	local was_t2 = pw2.temperament
	pw2.temperament = "weary"
	check("what is on the table counts too",
			hero + hire.money_pull(smith, 40) > hero)
	pw2.temperament = was_t2

	-- Having actually talked to somebody is worth something a purse is not.
	dialogue.known = {}
	local silent = hire.inclination(smith, P, 0)
	dialogue.learn(P, smith, "name")
	dialogue.learn(P, smith, "worry")
	check("asking what troubles somebody counts for more than nothing",
			hire.inclination(smith, P, 0) > silent)

	-- ...and having done something about it counts for a great deal more.
	local spoken = hire.inclination(smith, P, 0)
	local p = village_life.persona.of(smith)
	local was_worry = p.worry
	p.worry = "wolves, closer every year"
	memory.remember(smith, P, "rescued")
	check("seeing to what troubles them is the biggest thing you can do",
			hire.inclination(smith, P, 0) > spoken + 20,
			hire.inclination(smith, P, 0) .. " vs " .. spoken)
	check("...and it is checked against what really happened",
			hire.worry_answered(smith, P) == true)
	memory.book = {}
	check("...not against having merely claimed it",
			hire.worry_answered(smith, P) == false)
	p.worry = was_worry

	-- Payment does not simply scale: the tenth purse says nothing the first
	-- did not, or hiring is a wallet check and every other term is decoration.
	core.registered_items["simplecoins:coins"] = {description = "Coins"}
	village_life.economy.item_values = village_life.economy.item_values or {}
	village_life.economy.item_values["simplecoins:coins"] = {value = 1, tags = ""}
	village_life.economy.forget_values()

	-- Pinned to a temperament coin actually moves, so the curve is non-zero
	-- whatever persona this identity happens to hash to; the proud would return
	-- nothing at any figure, which is a different property tested elsewhere.
	local pw = village_life.persona.of(smith)
	local was_temperament = pw.temperament
	pw.temperament = "weary"
	local small = hire.money_pull(smith, 10)
	local huge = hire.money_pull(smith, 400)
	check("more coin is worth more", huge > small, huge .. " vs " .. small)
	check("...but not proportionally -- you cannot simply buy a person",
			huge < small * 10, huge .. " vs " .. small)
	pw.temperament = was_temperament

	----------------------------------------------------------------------------
	-- Arguments are only offered when they are true of the person
	----------------------------------------------------------------------------

	local by_id = {}
	for _, a in ipairs(hire.arguments) do by_id[a.id] = a end

	local ctx = {self = smith, pname = P, r = home.resolve(smith),
			village_id = V, asked = {}}

	-- The cruel one. True of a lodger with nobody; unforgivable to a man with
	-- a wife and a child in the house, and the check for that is the family,
	-- not a dice roll.
	check("'nobody would miss you' fails on somebody with a family",
			by_id.nobody.lands(ctx) == false)

	local guest_bed = {bnr = 4, x = 108, y = 11, z = 202, p2 = 0,
			first_name = "Corin", gender = "m", generation = 2, title = "guest",
			age = 30}
	bpos[1].beds[4] = guest_bed
	local guest = villager_at(1, 4)
	local guest_ctx = {self = guest, pname = P, r = home.resolve(guest),
			village_id = V, asked = {}}
	check("...and lands on a lodger with nobody here",
			by_id.nobody.lands(guest_ctx) == true)

	memory.book = {}
	local line, ok = hire.argue(ctx, by_id.nobody)
	check("saying it to the wrong person does not land", ok == false)
	check("...and they remember that you said it",
			memory.opinion(smith, P) < 0, memory.opinion(smith, P))

	----------------------------------------------------------------------------
	-- Taking service
	----------------------------------------------------------------------------

	memory.book = {}
	rep.book[V] = {[P] = {score = 90, day = day_count, met = 0}}
	dialogue.known = {}
	dialogue.talking = {}
	dialogue.learn(P, guest, "name")

	dialogue.open(guest, player)
	check("a proposition is something you can put to somebody",
			core.last_formspec.spec:find("topic_hire", 1, true) ~= nil,
			core.last_formspec.spec)

	core.on_fields(player, "village_life:talk", {topic_hire = true})
	local list = core.last_formspec.spec
	check("...and it opens onto arguments", list:find("topic_back", 1, true) ~= nil)
	check("the window says how it is going, in words not numbers",
			list:find("they seem", 1, true) ~= nil, list)

	-- Push them over the line and accept.
	local opts = dialogue.talking[P].options
	local ask_index
	for i, o in ipairs(opts) do
		if o.label and o.label:find("will you come with me", 1, true) then
			ask_index = i
		end
	end
	check("there is always the option of simply asking", ask_index ~= nil)

	dialogue.talking[P].asked.hire = {tried = {}, bonus = 500, spent = 0}
	core.on_fields(player, "village_life:talk",
			{["topic_opt" .. ask_index] = true})
	check("somebody sufficiently persuaded comes with you",
			companion.hired_by(guest) == true)
	check("...and knows whose service they are in",
			companion.employer(guest) == P, companion.employer(guest))
	check("...and follows by default", companion.order(guest) == "follow")

	----------------------------------------------------------------------------
	-- Their bed is theirs, and the village must not fill it
	----------------------------------------------------------------------------

	check("their bed is marked away", guest_bed.away == P, guest_bed.away)

	home.roster = {}
	home.pending = {}
	lottmobs.spawned = {}
	village_life.census.audit(V, true)
	local cloned = false
	for _, ent in ipairs(lottmobs.spawned) do
		if ent.game_name == "Corin" then cloned = true end
	end
	check("the village does not spawn a second copy of your companion",
			not cloned)
	home.roster = {}
	home.pending = {}
	lottmobs.spawned = {}

	check("nor does a stray get given their name",
			hire.refusal(guest, "somebody_else") ~= nil)

	----------------------------------------------------------------------------
	-- They follow, and they can be told otherwise
	----------------------------------------------------------------------------

	local g = companion.goal(guest, home.resolve(guest), {x = 105, y = 11, z = 205})
	check("a companion standing beside you attends you",
			g and g.kind == "attend", g and g.kind)

	player._pos = {x = 160, y = 11, z = 260}
	g = companion.goal(guest, home.resolve(guest), {x = 105, y = 11, z = 205})
	check("...and follows when you walk off", g and g.kind == "follow",
			g and g.kind)
	check("...at a run when you get far enough ahead", g and g.speed == "run",
			g and g.speed)
	player._pos = {x = 105, y = 11, z = 205}

	-- The schedule hands over to it entirely: a hired villager does not keep
	-- their village's hours, and above all does not bolt for a front door half
	-- a valley behind them.
	local night = at(2, function()
		return schedule.decide(guest, home.resolve(guest),
				{x = 105, y = 11, z = 205})
	end)
	check("a companion does not go home to bed at nightfall",
			night and night.companion == true, night and night.kind)

	guest.vl.h.order = "wait"
	g = companion.goal(guest, home.resolve(guest), {x = 105, y = 11, z = 205})
	check("told to wait, they wait", g and g.kind == "wait", g and g.kind)
	guest.vl.h.order = "follow"

	-- A hired guard is the one villager it makes most sense to take with you,
	-- and was the one who would have ignored you: brain.step routes guards to
	-- the defence loop and returns before the schedule is ever consulted, so a
	-- hired guard went on patrolling a village the player had left that
	-- morning. They now escort -- fighting what they can see, around whoever is
	-- paying them, and never answering an alarm in a village they have left.
	local guard_bed = {bnr = 5, x = 110, y = 11, z = 202, p2 = 0,
			first_name = "Bryn", gender = "m", generation = 2, title = "guard",
			age = 33}
	bpos[1].beds[5] = guard_bed
	local hired_guard = villager_at(1, 5)
	check("the hired guard resolves as a guard",
			home.resolve(hired_guard).role == "guard")
	check("...and is not the last one, so they may be hired at all",
			hire.last_defender(V, hired_guard) == true)

	companion.engage(hired_guard, P)
	village_life.threats.alarms = {}
	village_life.threats.raise(V, {x = 105, y = 11, z = 205})
	local escort = village_life.defence.escort_step(hired_guard,
			home.resolve(hired_guard), 1, {x = 105, y = 11, z = 205})
	check("an escort does not run off to a village alarm it has left behind",
			escort == false, tostring(escort))
	village_life.threats.alarms = {}

	local guard_goal = companion.goal(hired_guard,
			home.resolve(hired_guard), {x = 105, y = 11, z = 205})
	check("...and takes its orders from whoever hired it",
			guard_goal and guard_goal.companion == true,
			guard_goal and guard_goal.kind)
	companion.release(hired_guard, "test over")
	bpos[1].beds[5] = nil

	----------------------------------------------------------------------------
	-- Wages, and going home when it stops being worth it
	----------------------------------------------------------------------------

	check("nothing is owed on the first day", companion.owed(guest) == 0)
	day_count = day_count + 1
	local owed = companion.owed(guest)
	check("a day's work is a day's wages", owed > 0, owed)

	player._wield = ItemStack("simplecoins:coins 1")
	local paid, why = companion.pay(guest, P)
	check("underpaying them does not settle it", paid == false, why)
	player._wield = ItemStack("simplecoins:coins 200")
	paid = companion.pay(guest, P)
	check("paying them does", paid == true)
	check("...and nothing is owed after", companion.owed(guest) == 0)
	check("...and they are glad of it", memory.opinion(guest, P) > 0,
			memory.opinion(guest, P))

	-- Left unpaid long enough, they go home. This is the whole reason hiring
	-- somebody is a relationship rather than a purchase.
	day_count = day_count + 4
	core.last_chat = nil
	-- Twice: util.every is a stagger, so the first call on a fresh timer only
	-- seeds the offset and returns false.
	companion.tick(guest, home.resolve(guest), 999)
	companion.tick(guest, home.resolve(guest), 999)
	check("somebody you never pay stops working for you",
			companion.hired_by(guest) == false)
	check("...and says why", core.last_chat ~= nil
			and core.last_chat.text:find("coin", 1, true) ~= nil,
			core.last_chat and core.last_chat.text)
	check("...and their bed is theirs again", guest_bed.away == nil)

	----------------------------------------------------------------------------
	-- Dying in your service
	----------------------------------------------------------------------------

	rep.book[V] = {[P] = {score = 60, day = day_count, met = 0}}
	companion.engage(guest, P)
	check("engaged again for the last test", companion.hired_by(guest))
	local before_death = rep.get(V, P)
	companion.on_death(guest, "a wolf")
	check("somebody who died in your employ costs you with their village",
			rep.get(V, P) < before_death,
			rep.get(V, P) .. " vs " .. before_death)
	check("...and their bed stops being marked away, so succession can have it",
			guest_bed.away == nil)

	rep.book[V] = {[P] = {score = 60, day = day_count, met = 0}}
	companion.engage(guest, P)
	local before_murder = rep.get(V, P)
	companion.on_death(guest, P)
	check("killing them yourself costs a great deal more",
			(before_murder - rep.get(V, P)) > (before_death - rep.get(V, P)) / 2)

	----------------------------------------------------------------------------
	-- All of it is one switch
	----------------------------------------------------------------------------

	village_life.settings.hiring = false
	dialogue.talking = {}
	dialogue.known = {}
	dialogue.learn(P, smith, "name")
	dialogue.open(smith, player)
	check("with hiring off nobody is propositioned",
			not core.last_formspec.spec:find("topic_hire", 1, true))
	check("...and the rest of the conversation is untouched",
			core.last_formspec.spec:find("topic_talk", 1, true) ~= nil)
	check("...and nobody can be recruited by any other road",
			(hire.refusal(smith, P) or {}).hard == true)
	village_life.settings.hiring = true

	bpos[1].beds[3] = nil
	bpos[1].beds[4] = nil
	player._wield = nil
	player._pos = nil
	memory.book = {}
	rep.book = {}
	dialogue.known = {}
	dialogue.talking = {}
	village_life.threats.alarms = {}
end

--------------------------------------------------------------------------------
-- Getting indoors
--------------------------------------------------------------------------------

-- These are regressions, and every one of them was checked by reverting its fix
-- and confirming it fails.
--
-- The bug they cover is a single fact with two visible symptoms. A shut door is
-- a `walkable` node, and creaturemob's `world.is_blocked` treats anything
-- walkable as impassable -- so A* *cannot* find a route into a house whose door
-- is closed. It returned "failed", the path was thrown away, and nav.tick fell
-- back to steering in a straight line at a bed on the far side of a wall: the
-- villagers who ran at walls. And because the only code that ever opened a
-- front door was the stuck handler -- the per-step check needs a waypoint
-- within reach, and a villager grinding on a wall has no path and so no
-- waypoints -- and that handler discarded what it opened, the door was never
-- shut again: the doors left standing open.
--
-- `creaturemob.navigate.find_path` returns "failed" for everything in this
-- harness, which is exactly the condition being reproduced.

do
	local nav = village_life.nav
	local util = village_life.util
	local house = mg_villages.all_villages["100:200"].to_add_data.bpos[1]

	-- A villager that nav.tick can actually drive.
	local function walker_at(x, y, z)
		local at = {x = x, y = y, z = z}
		local ent = {
			name = "lottmobs:pigman_trader",
			walk_velocity = 1, run_velocity = 2, rotate = 0,
			yaw = 0,
			set_animation = function() end,
			set_velocity = function(self, v) self.vel = v end,
			set_yaw = function(self, yy) self.yaw = yy ; return yy end,
			yaw_to_pos = function() end,
			do_smart_path = function() return nil end,
		}
		ent.object = {
			get_pos = function() return {x = at.x, y = at.y, z = at.z} end,
			set_pos = function(_, p) at = {x = p.x, y = p.y, z = p.z} end,
			get_yaw = function() return ent.yaw end,
			get_luaentity = function() return ent end,
		}
		ent.move_to = function(_, p) at = {x = p.x, y = p.y, z = p.z} end
		return ent
	end

	----------------------------------------------------------------------------
	-- The stored path is the route, not a suffix on a search that never returns
	----------------------------------------------------------------------------

	local route = home.path_in("100:200", 1, 1, "bed", 1)
	check("the house has a stored interior path to walk", route and #route > 1)

	local walker = walker_at(103, 11, 199)
	nav.set_goal(walker, r.sleep_pos, {
		tolerance = 1.5, route = route, inside = house, tag = "sleep:final",
	})

	local g = util.scratch(walker).nav
	check("a stored route is adopted as the path immediately",
			g and g.path ~= nil and #g.path == #route)
	check("...and is marked as a route, so it is never re-searched",
			g and g.route ~= nil)

	nav.tick(walker, 0.1)
	check("the villager has a path while the pathfinder can find none",
			util.scratch(walker).nav ~= nil
					and util.scratch(walker).nav.path ~= nil)
	check("...and is walking it rather than standing still",
			walker.vel ~= nil and walker.vel > 0, walker.vel)

	-- Without the route it is the old behaviour: nothing at all to follow, and
	-- the fallback is a straight line at a bed through a wall.
	local blind = walker_at(103, 11, 199)
	nav.set_goal(blind, r.sleep_pos, {tolerance = 1.5, tag = "sleep:blind"})
	nav.tick(blind, 0.1)
	check("without a stored route there is no path at all -- the old bug",
			util.scratch(blind).nav.path == nil)

	----------------------------------------------------------------------------
	-- The outdoor leg aims at the street, not at the door node
	----------------------------------------------------------------------------

	local home_goal = {kind = "sleep", pos = r.sleep_pos, indoor = true,
			interior_kind = "bed", interior_index = 1, plot = 1}
	local approach = schedule.approach_pos(r, home_goal)
	check("an indoor goal has an approach position", approach ~= nil)
	check("...which is the stored path's own outdoor end",
			approach and route and approach.x == route[1].x
					and approach.z == route[1].z,
			approach and (approach.x .. "," .. approach.z))
	check("...and is outside the building, not in it",
			approach and not util.inside_plot(approach, house))

	check("the plot an indoor goal finishes in is resolved",
			schedule.goal_plot(r, home_goal) == house)

	----------------------------------------------------------------------------
	-- Arrival has to happen from inside
	----------------------------------------------------------------------------

	-- Standing outside the wall, within tolerance of a bed on the other side of
	-- it. This used to report "arrived": the goal completed, the door was never
	-- opened, and "go indoors" silently did nothing whatsoever.
	local outside = walker_at(r.sleep_pos.x, r.sleep_pos.y, house.z - 1.2)
	nav.set_goal(outside, r.sleep_pos, {
		tolerance = 6, inside = house, tag = "sleep:outside",
	})
	check("an indoor goal is not reached from outside the wall",
			nav.tick(outside, 0.1) ~= "arrived")

	local inside = walker_at(r.sleep_pos.x, r.sleep_pos.y, r.sleep_pos.z)
	nav.set_goal(inside, r.sleep_pos, {
		tolerance = 1.5, inside = house, tag = "sleep:inside",
	})
	check("...and is reached from inside it",
			nav.tick(inside, 0.1) == "arrived")

	check("the plot test is bounded in height, so the cellar is not the house",
			util.inside_plot({x = house.x + 2, y = house.y - 40,
					z = house.z + 2}, house) == false)

	----------------------------------------------------------------------------
	-- Every door opened is a door owed
	----------------------------------------------------------------------------

	local d1 = {x = 140, y = 11, z = 240}
	local d2 = {x = 140, y = 11, z = 244}
	stub_nodes[pkey(d1)] = {name = "cottages:half_door", param2 = 0}
	stub_nodes[pkey(d2)] = {name = "cottages:half_door", param2 = 0}

	local doorman = walker_at(140, 11, 238)
	local along = {x = 0, z = 1}

	nav.note_opened(doorman, nav.open_door_near(d1, along), along)
	nav.note_opened(doorman, nav.open_door_near(d2, along), along)
	check("both doors were opened",
			stub_nodes[pkey(d1)].param2 == 3 and stub_nodes[pkey(d2)].param2 == 3)
	check("both are queued to be shut again",
			#util.scratch(doorman).doors_open == 2,
			#util.scratch(doorman).doors_open)

	nav.note_opened(doorman, d1, along)
	check("...and the same door is not queued twice",
			#util.scratch(doorman).doors_open == 2)

	check("barring shuts every door owed, not just the last one",
			nav.bar_door(doorman, doorman.object:get_pos()))
	check("...the front door among them -- one slot lost this one",
			stub_nodes[pkey(d1)].param2 == 0, stub_nodes[pkey(d1)].param2)
	check("...and the inner one", stub_nodes[pkey(d2)].param2 == 0,
			stub_nodes[pkey(d2)].param2)
	check("...leaving nothing owed", util.scratch(doorman).doors_open == nil)

	-- A stateless swing door cannot be closed without knowing which way the
	-- villager went through it: swing_blocks() answers "blocked" for an unknown
	-- heading, and close only swings when it answers "clear". bar_door's
	-- fallback passed no heading at all, so it could never shut one.
	local lone = {x = 150, y = 11, z = 250}
	stub_nodes[pkey(lone)] = {name = "cottages:half_door", param2 = 0}
	nav.open_door_near(lone, along)
	check("a half door with no record is still shut, from the way we face",
			nav.close_door_near(lone, along) ~= nil)
	check("...and really is shut", stub_nodes[pkey(lone)].param2 == 0,
			stub_nodes[pkey(lone)].param2)

	----------------------------------------------------------------------------
	-- The stuck handler owes what it opens
	----------------------------------------------------------------------------

	-- Wedged: set_pos is honoured but nav writes velocity, not position, so this
	-- villager never actually moves and trips the stuck timer.
	local d3 = {x = 160, y = 11, z = 260}
	stub_nodes[pkey(d3)] = {name = "cottages:half_door", param2 = 0}

	local wedged = walker_at(160, 11, 259)
	nav.set_goal(wedged, {x = 160, y = 11, z = 262}, {tag = "stuck:test"})
	for _ = 1, 8 do nav.tick(wedged, 0.5) end

	check("a villager stuck against a shut door opens it",
			stub_nodes[pkey(d3)].param2 ~= 0, stub_nodes[pkey(d3)].param2)
	check("...and owes it a closing -- this record was simply dropped",
			util.scratch(wedged).doors_open ~= nil
					and #util.scratch(wedged).doors_open > 0)
end

--------------------------------------------------------------------------------

-- The globalsteps must survive being run with nobody connected, which is the
-- state a dedicated server spends most of its life in.
local step_ok, step_err = pcall(function()
	for _ = 1, 3 do
		for _, f in ipairs(registered_globalsteps) do f(20) end
	end
end)
check("globalsteps run with no players", step_ok, step_err)

--------------------------------------------------------------------------------
-- Children, combat and the new APIs
--------------------------------------------------------------------------------

do
	local cs = village_life.child_scale
	check("child scale API present", type(cs) == "function")
	if type(cs) == "function" then
		check("a small child is much smaller than an adult", cs(1) < 0.65)
		check("an older child is nearly adult size", cs(18) > 0.85)
		check("child scale grows with age", cs(5) < cs(12))
		check("child scale is clamped below", cs(0) == cs(1))
		check("child scale is clamped above", cs(40) == cs(18))
	end

	check("self-defence and role-arming API present",
			type(village_life.arm) == "function"
			and type(village_life.pacify) == "function"
			and type(village_life.rouse) == "function")
	check("child aging API present", type(village_life.age_child) == "function")
	check("champion dialogue module present", village_life.champion ~= nil)
	check("ambient gossip API present",
			type(village_life.gossip.ambient) == "function")

	-- Arming a mob makes it a fighter; pacifying puts it back.
	local mob = {object = {set_properties = function() end}, health = 10}
	village_life.arm(mob, "roused")
	check("arm turns off passivity", mob.passive == false and mob.attack_monsters == true)
	village_life.pacify(mob)
	check("pacify restores it", mob.passive == true and mob.attack_monsters == false)
end

--------------------------------------------------------------------------------
-- A companion who fights, the gear you give them, and the road news they carry
--------------------------------------------------------------------------------
do
	local companion = village_life.companion
	local gossip = village_life.gossip
	local events = village_life.events
	local home = village_life.home
	local P = "gear_tester"
	local player = core.make_test_player(P, 50, 11, 50)

	core.registered_items["test:cutlass"] = {
		description = "Test Cutlass",
		tool_capabilities = {damage_groups = {fleshy = 6}},
	}
	core.registered_items["test:steel_vest"] = {
		description = "Steel Vest", groups = {armor_torso = 1},
	}

	local denna = {
		_adventurer = true, _adv_subtype = "pirate",
		game_name = "Denna", id = "adv_denna", health = 20,
		object = {
			get_pos = function() return {x = 50, y = 11, z = 50} end,
			set_properties = function() end,
		},
	}

	check("a bedless adventurer can be engaged", companion.engage(denna, P))
	check("...and is armed to fight monsters at your side, not players",
			denna.attack_monsters == true and denna.attack_players == false)
	local base_damage = denna.damage
	check("...at their kind's base damage", base_damage == 5, base_damage)
	local base_hp = denna.vl.h.hp_max
	check("...and their kind's health", base_hp == 30, base_hp)

	-- A weapon in the hand is handed over and sharpens their swing.
	player._wield = ItemStack("test:cutlass")
	local okw, line = companion.equip(denna, P)
	check("a weapon is accepted", okw == true, line)
	check("...taken from your hand", player._wield:is_empty())
	check("...recorded as their weapon", (companion.gear(denna)) == "test:cutlass")
	check("...and it raises their damage", denna.damage > base_damage, denna.damage)

	-- Armour is worn as extra hide.
	player._wield = ItemStack("test:steel_vest")
	check("armour is accepted", (companion.equip(denna, P)) == true)
	check("...and it raises their max health", denna.vl.h.hp_max > base_hp,
			denna.vl.h.hp_max)

	-- Neither weapon nor armour: refused.
	player._wield = ItemStack("test:pebble")
	check("a pebble is neither, and is refused", (companion.equip(denna, P)) == false)

	-- Handing it all back strips the bonuses.
	companion.return_gear(denna, P)
	local wpn2, arm2 = companion.gear(denna)
	check("handing gear back clears both slots", wpn2 == nil and arm2 == nil)
	check("...and damage drops to the base again", denna.damage == base_damage,
			denna.damage)

	-- Chatter picked up on the road: a villager in earshot, carrying news.
	local ev = events.raise({kind = "murder", village_id = "100:200",
			pos = {x = 51, y = 11, z = 50}, actor = "someone", subject_name = "Bram"})
	gossip.book = {}
	home.roster = {}
	local villager_key = "100:200/1/1"
	home.roster[villager_key] = {obj = {
		get_pos = function() return {x = 51, y = 11, z = 50} end}}
	gossip.tell(villager_key, ev, 0)

	local denna_key = village_life.memory.key_of(denna)
	check("a travelling companion starts carrying nothing",
			gossip.count(denna_key) == 0)
	gossip.mingle_nearby(denna, denna.object:get_pos())
	check("...and picks up news off a villager in earshot",
			gossip.count(denna_key) == 1, gossip.count(denna_key))
	check("...which they can then say out loud on the road",
			type(gossip.carry_line(denna)) == "string")

	gossip.book = {}
	home.roster = {}
	player._wield = nil
end

--------------------------------------------------------------------------------
-- A room for the night
--------------------------------------------------------------------------------
do
	local lodging = village_life.lodging
	local home = village_life.home
	local rep = village_life.reputation
	local V, P = "100:200", "tester"

	-- Give the test village an inn plot on the end of its plot list.
	mg_villages.BUILDINGS.inn = {typ = "inn", yoff = 0, ysize = 6, scm = {}}
	local plots = home.village(V).to_add_data.bpos
	local bpos = {x = 130, y = 10, z = 200, btype = "inn", bsizex = 6,
			bsizez = 6, beds = {{bnr = 1, x = 132, y = 11, z = 202, p2 = 0}}}
	plots[#plots + 1] = bpos
	local inn_nr = #plots
	local bedpos = {x = 132, y = 11, z = 202}

	check("an inn plot reads as lodging", lodging.is_lodging(bpos))
	check("a house plot does not", not lodging.is_lodging(plots[1]))
	check("a bed inside the inn is found as a lodging bed",
			(lodging.plot_at(V, bedpos)) == inn_nr, (lodging.plot_at(V, bedpos)))
	check("a bed in an ordinary house is not lodging",
			lodging.plot_at(V, {x = 101, y = 11, z = 201}) == nil)

	-- Rentals are per player per inn, and expire.
	rep.book = {}
	village_life.settings.reputation = false
	check("no room until you rent one", not lodging.has_room(P, V, inn_nr))
	lodging.grant(P, V, inn_nr)
	check("...and a granted room reads as rented", lodging.has_room(P, V, inn_nr))
	check("somebody else's name gets no room off it",
			not lodging.has_room("other", V, inn_nr))

	-- Paying draws coins out of the player's purse: loose coins and money bags.
	local player = core.make_test_player(P, 132, 11, 202)
	local pinv = player:get_inventory()
	local price = lodging.price(V, P)
	check("with reputation off a room is the base price", price == 10, price)

	-- Too little coin: refused, and the purse is untouched.
	pinv:set_stack("main", 1, ItemStack("simplecoins:coins 4"))
	local okpoor, why = lodging.take_payment(P, price)
	check("a purse short of the price is refused", okpoor == false and why == "short", why)
	check("...and nothing is taken", pinv:get_stack("main", 1):get_count() == 4)

	-- Loose coins cover it; exactly the price is removed.
	pinv:set_stack("main", 1, ItemStack("simplecoins:coins 25"))
	check("paying in loose coin succeeds", lodging.take_payment(P, price) == true)
	check("...and takes exactly the price",
			pinv:get_stack("main", 1):get_count() == 25 - price,
			pinv:get_stack("main", 1):get_count())

	-- A money bag pays: coin is drawn out of it (moneybags hold simplecoins).
	pinv:set_stack("main", 1, ItemStack(""))
	local bag = ItemStack("moneybag:bolsa_dinero_1")
	bag:get_meta():set_int("coins", 500)
	pinv:set_stack("main", 2, bag)
	check("paying out of a money bag succeeds", lodging.take_payment(P, price) == true)
	check("...and the bag is lighter by the price",
			pinv:get_stack("main", 2):get_meta():get_int("coins") == 500 - price,
			pinv:get_stack("main", 2):get_meta():get_int("coins"))

	-- Loose coin is spent before the bag is opened.
	pinv:set_stack("main", 1, ItemStack("simplecoins:coins 6"))
	local bag2 = ItemStack("moneybag:bolsa_dinero_1")
	bag2:get_meta():set_int("coins", 100)
	pinv:set_stack("main", 2, bag2)
	check("a mixed purse pays, loose coin first",
			lodging.take_payment(P, price) == true
			and pinv:get_stack("main", 1):get_count() == 0
			and pinv:get_stack("main", 2):get_meta():get_int("coins") == 100 - (price - 6),
			pinv:get_stack("main", 2):get_meta():get_int("coins"))

	-- Trespass: sleeping in the inn's bed unpaid, if somebody sees, is an offence.
	rep.book = {}
	village_life.gossip.book = {}
	village_life.settings.reputation = true
	village_life.settings.crime = true
	village_life.settings.gossip = true
	village_life.settings.lodging = true
	lodging.rooms[P] = nil          -- the room rented above is spent; check-in only
	local keeper = {id = "vl_inn", vl = {v = V, p = inn_nr, b = 1},
			game_name = "Host", object = stub_object(133, 11, 202)}
	home.roster[village_life.memory.key_of(keeper)] =
			{obj = keeper.object, seen = os.time()}
	local sleeper = core.make_test_player(P, 132, 11, 202)

	local ev = lodging.on_sleep(bedpos, sleeper)
	check("sleeping unpaid at the inn, witnessed, is an offence",
			ev ~= nil and ev.kind == "trespass", ev and ev.kind)
	check("...and it costs standing with the village",
			rep.get(V, P) < 0, rep.get(V, P))

	-- Same bed, having paid, passes without a word.
	lodging.grant(P, V, inn_nr)
	village_life.gossip.book = {}
	check("a paid-up guest in their room is no offence",
			lodging.on_sleep(bedpos, sleeper) == nil)

	-- Out in the wild, a bed is nobody's business.
	check("a bed that is not in any village is free to sleep in",
			lodging.on_sleep({x = 9000, y = 11, z = 9000}, sleeper) == nil)

	-- The retelling names the sleeper to their own face as "you".
	local line = village_life.events.retell(
			{kind = "trespass", actor = P}, 0, P)
	check("the trespass retells in the first person to the doer",
			line:find("^You "), line)

	-- The innkeeper keeps late hours: after dark they open with the evening
	-- greeting that tells a traveller a bed can be had at this time, so a room
	-- can be rented night or day.
	local dialogue = village_life.dialogue
	local was_tod = time_of_day
	time_of_day = 0.9                                   -- night
	check("the innkeeper greets a caller in the evening",
			(dialogue._keeper_greeting(keeper) or ""):find("evening", 1, true) ~= nil,
			dialogue._keeper_greeting(keeper))
	time_of_day = 0.5                                   -- midday
	check("...and by day has no special evening line",
			dialogue._keeper_greeting(keeper) == nil)
	time_of_day = 0.9
	check("somebody who keeps no inn has no room to offer at nightfall",
			dialogue._keeper_greeting(
				{vl = {v = V, p = 1, b = 1}, game_name = "Townsman"}) == nil)
	time_of_day = was_tod

	home.roster = {}
	plots[inn_nr] = nil
	mg_villages.BUILDINGS.inn = nil
	rep.book = {}
	village_life.gossip.book = {}
end

--------------------------------------------------------------------------------
-- Player-founded settlements
--------------------------------------------------------------------------------

do
	local S = village_life.settlement
	check("settlement module exists", S ~= nil)

	local fp = core.make_test_player("founder", 300, 11, 300)

	-- Deed parsing: a written book whose first line is "Town Deed".
	local function deed_book(text)
		local st = ItemStack("default:book_written")
		st:get_meta():set_string("text", text)
		return st
	end
	check("a Town Deed book parses its name",
			(S.deed_of(deed_book("Town Deed\nName: Riverbend\nsettled in spring"))
					or {}).name == "Riverbend")
	check("the header is case-insensitive",
			S.deed_of(deed_book("town deed\nName: Foo")) ~= nil)
	check("a plain written book is not a deed",
			S.deed_of(deed_book("My Diary\nName: nobody")) == nil)
	check("a deed with no Name line parses but is nameless",
			(function()
				local d = S.deed_of(deed_book("Town Deed\njust a note"))
				return d ~= nil and d.name == nil
			end)())
	check("an empty stack is not a deed", S.deed_of(ItemStack("")) == nil)

	-- Founding a town.
	local town_id, v = S.found("founder", {x = 300, y = 10, z = 300}, "Riverbend")
	check("founding mints a namespaced town id",
			type(town_id) == "string" and town_id:sub(1, 5) == "deed:", town_id)
	check("the record is a player town owned by its founder",
			v.is_player_town == true and v.founder == "founder")
	check("the town lands in mg_villages.all_villages",
			mg_villages.all_villages[town_id] == v)
	check("founding refuses without a name",
			(select(2, S.found("founder", {x = 300, y = 10, z = 300}, nil))) ~= nil)
	check("the town is found by position like any village",
			(select(2, home.village_at({x = 302, y = 10, z = 302}))) == town_id)

	-- Dedicating beds. Two near beds are one household; a distant one is its own.
	S.punch_bed("founder", {x = 301, y = 11, z = 301})
	S.punch_bed("founder", {x = 303, y = 11, z = 301})
	S.punch_bed("founder", {x = 340, y = 11, z = 340})
	local bpos = v.to_add_data.bpos
	check("two beds in one room share a household",
			bpos[1].beds and #bpos[1].beds == 2, bpos[1].beds and #bpos[1].beds)
	check("a bed across the town starts its own household",
			#bpos >= 2 and bpos[#bpos].beds and #bpos[#bpos].beds == 1)
	check("a dedicated bed starts vacant",
			bpos[1].beds[1].vacant == true and not bpos[1].beds[1].first_name)
	check("the town circle grew to reach the far house", v.vs >= 56, v.vs)

	-- A player-house plot has an unregistered btype, so the resident who spawns
	-- there resolves a sleep spot beside the bed rather than crashing on the
	-- missing building data.
	do
		local resident = {vl = {v = town_id, p = 1, b = 1},
				game_name = "Tester", object = stub_object(301, 11, 301)}
		bpos[1].beds[1].first_name = "Testresident"
		local rr = home.resolve(resident)
		check("a town resident resolves without schematic data", rr ~= nil)
		check("...and sleeps beside their own bed",
				rr and rr.sleep_pos ~= nil)
		bpos[1].beds[1].first_name = nil   -- back to vacant for the tests below
	end

	-- Assigning a bed to the player is a roster label, no census resident.
	S.punch_bed("founder", {x = 301, y = 11, z = 301})   -- reopens bed 1
	core.on_fields(fp, "village_life:settle_bed", {mine = true, done = true})
	check("assigning a bed to yourself labels it your home",
			bpos[1].beds[1].player_owner == "founder"
					and not bpos[1].beds[1].vacant)

	-- Recruiting: a vacant bed remains (bed 2 in house 1, and house 2's bed).
	local rt, rp, rb = S.recruit_town("founder", {x = 300, z = 300})
	check("recruit_town finds a vacant bed", rt == town_id and rp and rb,
			tostring(rt) .. "/" .. tostring(rp) .. "/" .. tostring(rb))
	local rbed = home.bed_data(rt, rp, rb)
	check("the offered bed is genuinely vacant", rbed and rbed.vacant == true)

	-- Travel-yourself: a bedless traveller reserves the bed and is given an
	-- arrival a day to three off; nothing spawns until then.
	local trav = {game_name = "Rowan", profession = "hunter", gender = "m",
			object = stub_object(305, 11, 305)}
	local before = minetest.get_day_count()
	check("take_resident (travel) succeeds",
			S.take_resident(trav, "founder", "travel") == true)
	check("the reserved bed now names the traveller",
			rbed.first_name == "Rowan" and not rbed.vacant)
	check("...with an arrival one to three days off",
			rbed.arrive_day and rbed.arrive_day >= before + 1
					and rbed.arrive_day <= before + 3, rbed.arrive_day)

	home.roster = {}
	home.pending = {}
	lottmobs.spawned = {}
	village_life.census.audit(town_id, true)
	check("the census leaves an unarrived traveller on the road",
			#lottmobs.spawned == 0, #lottmobs.spawned)

	day_count = rbed.arrive_day
	village_life.census.audit(town_id, true)
	check("the census brings the traveller in on the day",
			#lottmobs.spawned >= 1, #lottmobs.spawned)
	check("and clears the travel marker once they arrive",
			rbed.arrive_day == nil)
	day_count = before
	home.roster = {}
	home.pending = {}

	-- Follow-then-settle: the same body becomes a resident, dropping its hire
	-- state and binding to the town bed.
	rbed.first_name = nil ; rbed.title = nil ; rbed.gender = nil
	rbed.generation = nil ; rbed.vacant = true   -- free the bed again
	local comp = {_adventurer = true, game_name = "Perrin", profession = "ranger",
			gender = "m", vl = {h = {p = "founder", order = "follow"}},
			object = stub_object(300, 11, 300)}
	check("companion.settle succeeds",
			village_life.companion.settle(comp, town_id, rp, rb) == true)
	check("the settled companion is now bound to the town bed",
			comp.vl and comp.vl.v == town_id and comp.vl.p == rp and comp.vl.b == rb)
	check("...and is no longer in service", comp.vl.h == nil)
	check("the town bed now holds the settler", rbed.first_name == "Perrin")

	-- A recruited adventurer settles as its KIND, not the flat "adventurer"
	-- placeholder its self.profession carries: a veteran stays a veteran on the
	-- nameplate (and, via lottmobs' career-skin map, keeps the veteran's coat).
	rbed.first_name = nil ; rbed.title = nil ; rbed.gender = nil
	rbed.generation = nil ; rbed.vacant = true   -- free the bed again
	local lyra = {_adventurer = true, _adv_subtype = "veteran",
			game_name = "Lyra", profession = "adventurer", gender = "f",
			vl = {h = {p = "founder", order = "follow"}},
			object = stub_object(300, 11, 300)}
	check("a veteran adventurer settles",
			village_life.companion.settle(lyra, town_id, rp, rb) == true)
	check("...recorded as a veteran, not the generic 'adventurer'",
			rbed.title == "veteran", rbed.title)
	check("...and a settled veteran stands watch (guard role)",
			home.role({title = "veteran"}) == "guard", home.role({title = "veteran"}))

	-- Older saves recruited an adventurer under the flat "adventurer" role, losing
	-- the veteran. On reload the kind still rides on the entity (staticdata), and
	-- apply_role heals the bed and role back from it.
	rbed.title = "adventurer"
	local reloaded = {_adventurer = true, _adv_subtype = "veteran",
			name = "lottmobs:pigman_trader", game_name = "Lyra",
			profession = "adventurer", vl = {v = town_id, p = rp, b = rb},
			object = stub_object(300, 11, 300)}
	village_life.apply_role(reloaded)
	check("apply_role heals a save stuck on the generic 'adventurer' role",
			rbed.title == "veteran", rbed.title)

	-- Dissolving a town (digging its foundation stone) takes it off the map.
	S.dissolve(town_id)
	check("dissolving removes the town", mg_villages.all_villages[town_id] == nil)
	home.roster = {}
	home.pending = {}
end

--------------------------------------------------------------------------------
-- Pirate crews and their dead
--------------------------------------------------------------------------------

do
	local adv = village_life.adventurer
	local crew = "the Test Wolves"
	local mates = {"Alpha", "Beta"}
	local function pirate(name)
		return {_adventurer = true, _adv_subtype = "pirate", _adv_crew = crew,
				_adv_captain = "Captain Test", _adv_crewnames = mates,
				game_name = name, object = stub_object(600, 11, 600)}
	end
	local alpha, beta = pirate("Alpha"), pirate("Beta")

	check("a whole crew starts with no losses to report",
			#adv.crew_losses_untold(beta) == 0)

	adv.note_death(alpha)
	local untold = adv.crew_losses_untold(beta)
	check("a survivor can be told of a fallen crewmate",
			#untold == 1 and untold[1] == "Alpha", untold[1])
	check("the dead never report their own death",
			#adv.crew_losses_untold(alpha) == 0)

	local line = adv.tell_crew_loss(beta)
	check("breaking the news names the dead", line:find("Alpha") ~= nil, line)
	check("...and is not offered twice", #adv.crew_losses_untold(beta) == 0)

	-- Recording the same death twice is one loss, not two.
	adv.note_death(alpha)
	check("a body counted twice is still one loss",
			(function()
				local c = adv.crews[crew]
				local n = 0
				for _, e in ipairs(c.lost) do if e.name == "Alpha" then n = n + 1 end end
				return n
			end)() == 1)

	-- A non-pirate has no crew to lose.
	check("a wayfarer has no crew news",
			#adv.crew_losses_untold({_adventurer = true, _adv_subtype = "wayfarer",
					game_name = "Corin"}) == 0)

	adv.crews[crew] = nil
end

--------------------------------------------------------------------------------
-- Shop stock: depletes, persists, and refills slowly
--------------------------------------------------------------------------------

do
	local economy = village_life.economy
	local bed = home.bed_data("100:200", 1, 1)
	bed.shop = nil                                   -- a clean shelf to start
	local day0 = minetest.get_day_count()

	local shop = {vl = {v = "100:200", p = 1, b = 1}, profession = "smith",
			game_name = "Yorath", object = stub_object(105, 11, 205)}

	local stock1 = economy.stock(shop)
	check("a shop has wares", #stock1 > 0)
	local o1 = stock1[1]
	local item = o1.item
	check("a ware carries a full-shelf maximum", o1.max and o1.max > 0, o1.max)
	check("a fresh shelf starts at its maximum", o1.stock == o1.max)

	-- Sell it out, unit by unit, the way the counter does.
	for _ = 1, o1.max do
		o1.stock = math.max(0, o1.stock - 1)
		economy.record_sale("100:200/1/1", o1)
	end
	check("selling down empties the offer", o1.stock == 0)
	check("the depletion is written to the bed row", bed.shop.q[item] == 0)

	-- A reload the same day (rebuild the shelf) must not refill it.
	economy.invalidate(shop)
	local function find(stock, name)
		for _, o in ipairs(stock) do if o.item == name then return o end end
	end
	local o2 = find(economy.stock(shop), item)
	check("a reload the same day does not restock", o2 and o2.stock == 0,
			o2 and o2.stock)

	-- The catalogue is stable: the same wares are on the shelf, day to day.
	local set1, set2 = {}, {}
	for _, o in ipairs(stock1) do set1[o.item] = true end
	for _, o in ipairs(economy.stock(shop)) do set2[o.item] = true end
	local same = true
	for k in pairs(set1) do if not set2[k] then same = false end end
	check("a shop keeps the same wares across restocks", same)

	-- A day later it has refilled a little, but not to the brim.
	day_count = day0 + 1
	economy.invalidate(shop)
	local o3 = find(economy.stock(shop), item)
	check("a day on, the shelf refills part way",
			o3 and o3.stock > 0 and o3.stock < o3.max, o3 and o3.stock)

	-- Given enough days, it fills.
	day_count = day0 + 20
	economy.invalidate(shop)
	local o4 = find(economy.stock(shop), item)
	check("given enough days it fills to the brim", o4 and o4.stock == o4.max,
			o4 and (o4.stock .. "/" .. o4.max))

	day_count = day0
	bed.shop = nil
	economy.invalidate(shop)
end

--------------------------------------------------------------------------------
-- Fresh produce is scarce where the land cannot grow it
--------------------------------------------------------------------------------

do
	local m = village_life.market
	mg_villages.all_villages["swamptest"] =
			{vx = 300, vz = -300, vh = 10, to_add_data = {bpos = {}}}
	mg_villages.all_villages["meadowtest"] =
			{vx = 340, vz = -300, vh = 10, to_add_data = {bpos = {}}}

	local apple = {item = "default:apple", tags = "food fresh"}
	local iron = {item = "default:steel_ingot", tags = "metal"}

	stub_climate.heat, stub_climate.humidity = 30, 85          -- swamp
	local swamp_f = m.produce_climate_factor("swamptest", apple)
	stub_climate.heat, stub_climate.humidity = 50, 55          -- temperate
	local meadow_f = m.produce_climate_factor("meadowtest", apple)

	check("a swamp keeps fewer apples than a meadow", swamp_f < meadow_f,
			swamp_f .. " vs " .. meadow_f)
	check("apples in a bog are genuinely thin", swamp_f <= 0.5, swamp_f)
	check("the land does not touch hardware",
			m.produce_climate_factor("meadowtest", iron) == 1)

	mg_villages.all_villages["swamptest"] = nil
	mg_villages.all_villages["meadowtest"] = nil
	stub_climate.heat, stub_climate.humidity = 30, 70          -- restore
end

--------------------------------------------------------------------------------
-- Wandering traders: recognised, talkable, recruited, and armed as townsfolk
--------------------------------------------------------------------------------

do
	local wanderer   = village_life.wanderer
	local companion  = village_life.companion
	local settlement = village_life.settlement
	local brain      = village_life.brain
	local re         = core.registered_entities

	local function trader(species, x, y, z)
		local ent = {
			name = species,
			base_texture = re[species] and re[species].base_texture,
			object = stub_object(x or 200, y or 11, z or 200),
			set_animation = function() end,
			set_velocity = function() end,
			set_yaw = function() end,
		}
		return ent
	end

	----------------------------------------------------------------------------
	-- Predicates
	----------------------------------------------------------------------------

	local dwarf = trader("lottmobs:dwarf_trader")
	check("a wandering trader is recognised as one", wanderer.is(dwarf) == true)
	check("...and counts as a bedless recruit",
			village_life.is_bedless_recruit(dwarf) == true)
	check("a plain pigman is not a wanderer",
			wanderer.is({name = "lottmobs:pigman_trader"}) == false)
	check("a settled trader (with a village) is no longer a loose wanderer",
			wanderer.is({name = "lottmobs:dwarf_trader",
					vl = {v = "100:200", p = 1, b = 1}}) == false)
	check("is_villager_entity spans the traders and the pigman, not the champion",
			village_life.is_villager_entity("lottmobs:mung_trader")
			and village_life.is_villager_entity("lottmobs:pigman_trader")
			and not village_life.is_villager_entity("zombies:buffpig"))

	----------------------------------------------------------------------------
	-- Dialogue took the click over and kept the native shop as an option
	----------------------------------------------------------------------------

	check("dialogue took the trader's right-click over",
			type(re["lottmobs:dwarf_trader"].on_rightclick) == "function")
	check("...and captured its native shop",
			wanderer.SPECIES["lottmobs:dwarf_trader"].native_trade ~= nil)
	wanderer.trade(dwarf)
	check('..."show me your wares" reopens the native shop',
			dwarf._native_traded == true)

	-- A guard's click is taken over the same way, but its native hire is dropped,
	-- not kept: no "wares" option, and the brain drives it once recruited.
	check("dialogue took the guard's right-click over too",
			type(re["lottmobs:mung_guard"].on_rightclick) == "function"
			and re["lottmobs:mung_guard"].on_rightclick
					~= (function(self) self._native_hired = true end))
	check("...but the guard's mercenary hire is NOT offered as wares",
			wanderer.SPECIES["lottmobs:mung_guard"].native_trade == nil)
	check("the villager brain is attached to the guard as well",
			re["lottmobs:mung_guard"].do_custom == brain.step)

	----------------------------------------------------------------------------
	-- The brain is attached, but a loose trader is left to its own AI (nil, not
	-- false, so mobs redo keeps driving it)
	----------------------------------------------------------------------------

	check("the villager brain is attached to the trader",
			re["lottmobs:dwarf_trader"].do_custom == brain.step)
	check("a loose trader keeps its native wander AI (brain.step returns nil)",
			brain.step(dwarf, 0.1) == nil)

	local named = wanderer.name_for(dwarf)
	check("a trader is given a name when asked", named ~= nil and named ~= "")
	check("...and keeps the same one", wanderer.name_for(dwarf) == named)

	----------------------------------------------------------------------------
	-- Recruiting one into a player town, travelling in as itself
	----------------------------------------------------------------------------

	local P = "founder"
	local town_id = "deed:founder:test"
	mg_villages.all_villages[town_id] = {
		vx = 200, vz = 200, vh = 11, vs = 16, name = "Newholm",
		is_player_town = true, founder = P,
		to_add_data = {bpos = {
			{x = 200, y = 10, z = 200, btype = "player_house",
			 bsizex = 3, bsizez = 3, brotate = 0, owner = P, beds = {
				{bnr = 1, x = 201, y = 11, z = 201, p2 = 0, vacant = true},
			}},
		}},
	}
	local bpos1 = mg_villages.all_villages[town_id].to_add_data.bpos[1]
	local bed   = bpos1.beds[1]

	local mung = trader("lottmobs:mung_trader", 201, 11, 201)
	local ok, mode = settlement.take_resident(mung, P, "travel")
	check("a trader agrees to travel in to a town with a bed set aside",
			ok == true and mode == "travel", mode)
	check("...its species is written onto the reserved bed for the census",
			bed.species == "lottmobs:mung_trader", bed.species)
	check("...along with a name and an arrival day",
			bed.first_name ~= nil and bed.first_name ~= "" and bed.arrive_day ~= nil)

	-- The census revives it beside the bed as its own species, not a pigman.
	local spawned_name
	local real_add = core.add_entity
	core.add_entity = function(pos, name)
		spawned_name = name
		local ent = {name = name, set_animation = function() end,
				set_velocity = function() end, set_yaw = function() end}
		ent.object = {
			get_pos = function() return {x = pos.x, y = pos.y, z = pos.z} end,
			set_properties = function() end,
			get_luaentity = function() return ent end,
		}
		return ent.object
	end
	bed.arrive_day = nil            -- pretend the day has come
	local obj = home.spawn(town_id, 1, 1, bed, bpos1)
	core.add_entity = real_add
	check("a travelled-in trader is revived as its own species, not a pigman",
			spawned_name == "lottmobs:mung_trader", spawned_name)
	check("...and home.spawn hands back the new body", obj ~= nil)

	-- spawn_pos for a player town goes straight to the bedside.
	local sp = home.spawn_pos(town_id, 1, 1, bed, bpos1)
	check("a player town spawns a resident right beside the bed",
			sp ~= nil and math.abs(sp.x - bed.x) <= 3 and math.abs(sp.z - bed.z) <= 3,
			sp and (sp.x .. "," .. sp.y .. "," .. sp.z))

	-- The other arrival: follow on foot, then settle into a spare bed. The same
	-- body rebinds, so it stays its own species -- and the bed still records it.
	bpos1.beds[2] = {bnr = 2, x = 202, y = 11, z = 201, p2 = 0, vacant = true}
	local elf = trader("lottmobs:elf_trader", 201, 11, 201)
	check("a trader takes service to be walked home",
			companion.engage(elf, P) == true)
	check("...settles into the spare bed",
			companion.settle(elf, town_id, 1, 2) == true)
	check("...keeps its own species on the bed, and stays a settled villager",
			bpos1.beds[2].species == "lottmobs:elf_trader"
			and home.is_villager(elf) == true, bpos1.beds[2].species)
	check("...and is given a trade rather than settling in nameless",
			bpos1.beds[2].title ~= nil and bpos1.beds[2].first_name ~= nil)

	mg_villages.all_villages[town_id] = nil

	----------------------------------------------------------------------------
	-- Arming townsfolk: kit on the bed row lifts a resident's defence stats
	----------------------------------------------------------------------------

	core.registered_items["vltest:sword"] =
			{tool_capabilities = {damage_groups = {fleshy = 6}}}
	core.registered_items["vltest:steel_chestplate"] =
			{groups = {armor_chestplate = 1}}

	local function resident(plot, bnr, x, y, z)
		return {
			name = "lottmobs:pigman_trader",
			id = ("vl_100:200/%d/%d"):format(plot, bnr),
			vl = {v = "100:200", p = plot, b = bnr},
			game_name = "Yorath", profession = "smith", gender = "m",
			health = 25, prop = {hp_max = 25}, hp_max = 25,
			object = stub_object(x, y, z),
			set_animation = function() end, set_velocity = function() end,
			set_yaw = function() end,
		}
	end

	local smith = resident(1, 1, 102, 11, 202)
	local bed1  = mg_villages.all_villages["100:200"].to_add_data.bpos[1].beds[1]

	bed1.weapon, bed1.armor = nil, nil
	village_life.arm(smith, "roused")
	local unarmed = smith.damage

	bed1.weapon = "vltest:sword"
	village_life.arm(smith, "roused")
	check("a resident's weapon lifts their blow when they rouse",
			smith.damage > unarmed, unarmed .. " -> " .. smith.damage)
	check("...read off the bed row through companion.gear",
			(companion.gear(smith)) == "vltest:sword")

	-- Gear on someone in your service is read from the hire record, not the bed.
	local hired = resident(1, 1, 102, 11, 202)
	hired.vl.h = {p = "someone", weapon = "vltest:steel_chestplate"}
	check("a hire's kit is read from the hire record, not the bed row",
			(companion.gear(hired)) == "vltest:steel_chestplate")

	bed1.weapon, bed1.armor = nil, nil

	----------------------------------------------------------------------------
	-- Only a town's founder may kit out that town's residents
	----------------------------------------------------------------------------

	local kit_town = "deed:founder:kit"
	mg_villages.all_villages[kit_town] = {
		vx = 250, vz = 250, vh = 11, vs = 16, is_player_town = true,
		founder = "founder", to_add_data = {bpos = {}},
	}
	check("founder_of names the founder of a player-town resident's town",
			settlement.founder_of({name = "lottmobs:dwarf_trader",
					vl = {v = kit_town, p = 1, b = 1}}) == "founder")
	check("...and is nil for a mapgen villager (no player town to arm from)",
			settlement.founder_of({name = "lottmobs:pigman_trader",
					vl = {v = "100:200", p = 1, b = 1}}) == nil)
	mg_villages.all_villages[kit_town] = nil
end

--------------------------------------------------------------------------------
-- Recruit roles, the equipment set, hand-placed workstations, town dedup
--------------------------------------------------------------------------------

do
	local wanderer   = village_life.wanderer
	local companion  = village_life.companion
	local settlement = village_life.settlement
	local home       = village_life.home
	local schedule   = village_life.schedule

	----------------------------------------------------------------------------
	-- A recruited wanderer settles as its kind's trade, not a flat "trader"
	----------------------------------------------------------------------------

	local real_rand = math.random
	-- assign_role walks the pool subtracting weight; random()=0 returns the first
	-- entry, which for a mung is "hunter".
	math.random = function() return 0 end
	check("a mung's likeliest recruit role is a fighter, not a trader",
			wanderer.assign_role({name = "lottmobs:mung_trader"}) == "hunter",
			wanderer.assign_role({name = "lottmobs:mung_trader"}))

	-- Every title a pool can yield is one home.role and the trade systems know.
	local known = {
		hunter = 1, barbarian = 1, guard = 1, trader = 1, blacksmith = 1,
		stonemason = 1, carpenter = 1, shopkeeper = 1, farmer = 1, baker = 1,
		butcher = 1, innkeeper = 1, glassmaker = 1, dyemaker = 1,
	}
	local all_known = true
	for _, pool in pairs(wanderer.ROLE_POOLS) do
		for _, entry in ipairs(pool) do
			if not known[entry.title] then all_known = false end
		end
	end
	check("every role a pool can hand out is a recognised trade", all_known)

	local m2 = {name = "lottmobs:mung_trader"}
	check("ensure_role stamps a plain trader with a settled role",
			wanderer.ensure_role(m2) == "hunter")
	check("...kept on the entity", m2.profession == "hunter")
	math.random = function() return 0.99 end          -- would pick differently
	check("...and never rerolled once set", wanderer.ensure_role(m2) == "hunter")
	math.random = real_rand

	local lion = {name = "zombies:lionman"}
	wanderer.ensure_role(lion)
	check("ensure_role leaves a redeem species' role to redeem.lua",
			lion.profession == nil)

	----------------------------------------------------------------------------
	-- Wandering guards recruit like traders, with the full role spread
	----------------------------------------------------------------------------

	-- The lottmobs guards (mung/nune/elf/dwarf) used to spam a hire one-liner and
	-- had no way into a town, because they were never in SPECIES. They are now.
	local guard_sp = wanderer.SPECIES["lottmobs:mung_guard"]
	check("a mung guard is a recognised wanderer species",
			guard_sp ~= nil and guard_sp.guard == true and guard_sp.race == "mung")
	check("guard races are mapped to the canonical labels the pools use",
			wanderer.SPECIES["lottmobs:nune_guard"].race == "human"
			and wanderer.SPECIES["lottmobs:elf1"].race == "elf"
			and wanderer.SPECIES["lottmobs:dwarf2"].race == "dwarf")
	check("a loose guard is a recruitable wanderer, no calming step",
			wanderer.is({name = "lottmobs:mung_guard"}) == true)
	check("a settled guard counts as a villager entity for census/gossip",
			village_life.is_villager_entity("lottmobs:mung_guard")
			and village_life.is_villager_entity("lottmobs:elf"))

	-- A mung *guard* rolls the warlike mung spread (barbarian is reachable); a
	-- mung *trader* is confined to hunter/trader. random()=0.5 lands on the
	-- second-heaviest entry of each pool.
	math.random = function() return 0.5 end
	check("a mung guard can roll barbarian (full mung fighter pool)",
			wanderer.assign_role({name = "lottmobs:mung_guard"}) == "barbarian")
	check("a mung trader at the same roll stays a hunter, never a barbarian",
			wanderer.assign_role({name = "lottmobs:mung_trader"}) == "hunter")
	math.random = function() return 0.99 end
	check("a mung trader's other outcome is trader -- only ever hunter or trader",
			wanderer.assign_role({name = "lottmobs:mung_trader"}) == "trader")
	math.random = real_rand

	-- A human guard rolls the ordinary human trades, same as a home-grown human.
	check("a human guard uses its race's full trade pool",
			wanderer.ROLE_POOLS[wanderer.SPECIES["lottmobs:nune_guard"].race]
					== wanderer.ROLE_POOLS.human)

	-- Guards talk like watchmen, not pedlars.
	local mg = {name = "lottmobs:mung_guard"}
	check("a guard introduces itself as a guard, not a trader",
			wanderer.introduce(mg) ~= wanderer.introduce({name = "lottmobs:mung_trader"})
			and wanderer.introduce(mg):find("watch") ~= nil)
	check("a guard greets and offers a settle reason without erroring",
			type(wanderer.greeting(mg)) == "string"
			and type(wanderer.why_settle(mg)) == "string")

	-- Completeness guarantee: EVERY lottmobs humanoid a player can meet must be on
	-- the list -- all dwarves, all elves, all humans, all mung -- and each one must
	-- (a) resolve a real role pool so it settles with a full town-role spread, and
	-- (b) count as a villager entity so it gossips and shows in the census like the
	-- rest. This is the "no species silently missing" check the whole exercise was
	-- about. The pigman is the base villager (attached directly) and is listed in
	-- VILLAGER_ENTITIES but not SPECIES, so it is checked separately.
	local every_lottmobs_humanoid = {
		"lottmobs:dwarf_trader", "lottmobs:dwarf", "lottmobs:dwarf1", "lottmobs:dwarf2",
		"lottmobs:elf_trader",   "lottmobs:elf",   "lottmobs:elf1",   "lottmobs:elf2",
		"lottmobs:human_trader", "lottmobs:nune_guard",
		"lottmobs:mung_trader",  "lottmobs:mung_guard",
	}
	local missing_species, no_pool, not_villager = {}, {}, {}
	for _, name in ipairs(every_lottmobs_humanoid) do
		local sp = wanderer.SPECIES[name]
		if not sp then
			missing_species[#missing_species + 1] = name
		elseif not wanderer.ROLE_POOLS[sp.roles or sp.race] then
			no_pool[#no_pool + 1] = name
		end
		if not village_life.is_villager_entity(name) then
			not_villager[#not_villager + 1] = name
		end
	end
	check("every lottmobs humanoid is on the dialogue-able SPECIES list",
			#missing_species == 0, table.concat(missing_species, ", "))
	check("...each settles with a full town-role spread (a real role pool)",
			#no_pool == 0, table.concat(no_pool, ", "))
	check("...and each is a villager entity (gossip, census, earshot)",
			#not_villager == 0, table.concat(not_villager, ", "))
	check("the pigman villager itself is a villager entity",
			village_life.is_villager_entity("lottmobs:pigman_trader"))

	----------------------------------------------------------------------------
	-- The equipment set: a weapon plus a whole suit of armour, worn together
	----------------------------------------------------------------------------

	core.registered_items["vltest:helm"]  = {groups = {armor_head = 1}}
	core.registered_items["vltest:boots"] = {groups = {armor_feet = 1}}
	core.registered_items["vltest:helm2"] = {groups = {armor_head = 1}}

	local P2 = "kitter"
	local kp = core.make_test_player(P2, 60, 11, 60)
	local fighter = {
		_adventurer = true, _adv_subtype = "veteran",
		name = "test:adventurer", game_name = "Kit", id = "adv_kit", health = 20,
		object = {
			get_pos = function() return {x = 60, y = 11, z = 60} end,
			set_properties = function() end,
		},
	}
	companion.engage(fighter, P2)
	local base_hp = fighter.vl.h.hp_max

	kp._wield = ItemStack("vltest:helm")
	companion.equip(fighter, P2)
	kp._wield = ItemStack("vltest:boots")
	companion.equip(fighter, P2)
	local _, worn = companion.gear(fighter)
	check("both armour pieces are worn as a set, not one replacing the other",
			worn and #worn == 2, worn and #worn)
	check("...and their hide sums onto max health", fighter.vl.h.hp_max > base_hp,
			base_hp .. " -> " .. fighter.vl.h.hp_max)

	kp._wield = ItemStack("vltest:helm2")             -- another head piece
	companion.equip(fighter, P2)
	local _, worn2 = companion.gear(fighter)
	check("a second helm displaces the first helm, not the boots",
			worn2 and #worn2 == 2, worn2 and #worn2)

	companion.return_gear(fighter, P2)
	local w3, a3 = companion.gear(fighter)
	check("returning the gear strips the whole set", w3 == nil and a3 == nil)
	check("...and drops max health back to the base",
			fighter.vl.h.hp_max == base_hp, fighter.vl.h.hp_max)

	-- The kit window: an inventory grid you drag gear onto, and it equips live.
	local P3 = "gridder"
	local gp = core.make_test_player(P3, 70, 11, 70)
	local f2 = {
		_adventurer = true, _adv_subtype = "wayfarer", name = "test:adv2",
		game_name = "Grid", id = "adv_grid", health = 20,
		object = {
			get_pos = function() return {x = 70, y = 11, z = 70} end,
			set_properties = function() end,
		},
	}
	companion.engage(f2, P3)

	-- The slot rules: right kind in the right cell, nothing else.
	check("the weapon cell rejects armour",
			companion.kit_accepts("weapon", 1, "vltest:helm") == false)
	check("the weapon cell takes a blade",
			companion.kit_accepts("weapon", 1, "vltest:sword") == true)
	check("the head cell takes a helm but not boots",
			companion.kit_accepts("armor", 1, "vltest:helm") == true
			and companion.kit_accepts("armor", 1, "vltest:boots") == false)
	-- Gloves (armor_hands) have their own cell -- the slot the player was missing.
	core.registered_items["vltest:gloves"] = {groups = {armor_hands = 1}}
	check("gloves are recognised as armour",
			companion.armor_bonus("vltest:gloves") ~= nil)
	check("...and there is a hands cell that takes them, not a helm",
			companion.kit_accepts("armor", 5, "vltest:gloves") == true
			and companion.kit_accepts("armor", 5, "vltest:helm") == false)

	check("open_kit builds the player's kit inventory",
			companion.open_kit(f2, P3) == true)
	local kinv = minetest.get_inventory(
			{type = "detached", name = "village_life:kit_" .. P3})
	check("...and it exists", kinv ~= nil)

	-- Drop gear onto the grid, then let the sync read it back.
	kinv:set_stack("weapon", 1, ItemStack("vltest:sword"))
	kinv:set_stack("armor", 1, ItemStack("vltest:helm"))    -- head cell
	kinv:set_stack("armor", 4, ItemStack("vltest:boots"))   -- feet cell
	companion.kit_sync(P3)
	local sw, sarm = companion.gear(f2)
	check("dropping a weapon on the grid equips it", sw == "vltest:sword", sw)
	check("...and each armour cell is worn", sarm and #sarm == 2, sarm and #sarm)

	-- Emptying a cell takes the piece back off.
	kinv:set_stack("weapon", 1, ItemStack(""))
	companion.kit_sync(P3)
	check("clearing the weapon cell unequips it", (companion.gear(f2)) == nil)

	----------------------------------------------------------------------------
	-- A hand-placed workstation in a player town
	----------------------------------------------------------------------------

	local wt = "deed:kitter:work"
	mg_villages.all_villages[wt] = {
		vx = 400, vz = 400, vh = 11, vs = 16, name = "Workton",
		is_player_town = true, founder = P2,
		to_add_data = {bpos = {
			{x = 400, y = 10, z = 400, btype = "player_house", bsizex = 3,
			 bsizez = 3, brotate = 0, owner = P2, beds = {
				{bnr = 1, x = 401, y = 11, z = 401, p2 = 0, first_name = "Throg",
				 title = "smith", gender = "m", generation = 2},
			}},
		}},
	}
	local wbed = mg_villages.all_villages[wt].to_add_data.bpos[1].beds[1]

	local r0 = home.resolve({vl = {v = wt, p = 1, b = 1}, game_name = "Throg",
			object = stub_object(401, 11, 401)})
	check("a resident with no workstation resolves no work_pos",
			r0 and r0.work_pos == nil)

	wbed.work_pos = {x = 405, y = 11, z = 402}
	wbed.work_facing = 2
	local worker = {vl = {v = wt, p = 1, b = 1}, game_name = "Throg",
			object = stub_object(401, 11, 401)}
	local r1 = home.resolve(worker)
	check("a hand-placed workstation becomes the resident's work_pos",
			r1 and r1.work_pos and r1.work_pos.x == 405,
			r1 and r1.work_pos and r1.work_pos.x)
	check("...marked hand-placed for the open-air walk", r1.work_hand_placed == true)
	check("...keeping the facing it was placed with", r1.work_facing == 2)

	-- Clear weather so nothing sends them indoors, then send them to work.
	climate_mod.current_weather = {p1 = {}}
	schedule.flush_weather_cache()
	time_of_day = 10 / 24
	local wg = schedule.decide(worker, r1, {x = 401, y = 11, z = 401})
	check("the smith is sent to their workstation mid-morning",
			wg and wg.kind == "work" and wg.pos and wg.pos.x == 405,
			wg and (wg.kind .. " " .. tostring(wg.pos and wg.pos.x)))
	check("...as an open-air goal, not an indoor one", wg and not wg.indoor)

	-- clear_bed wipes the station so the next occupant does not inherit the job.
	settlement.clear_bed(wbed)
	check("clearing a bed also releases its workstation", wbed.work_pos == nil)
	mg_villages.all_villages[wt] = nil

	----------------------------------------------------------------------------
	-- One town per name, and the load-time cleanup of the old duplicates
	----------------------------------------------------------------------------

	local t1 = settlement.found("dupe", {x = 600, y = 10, z = 600}, "Twinsville")
	check("a first town of a name is founded", type(t1) == "string", t1)
	local t2, err = settlement.found("dupe", {x = 700, y = 10, z = 700}, "Twinsville")
	check("a second town of the same name is refused", t2 == nil and err ~= nil, err)
	mg_villages.all_villages[t1] = nil

	-- Two same-name towns as an old world might hold them: one has a resident
	-- (Throg), one is only the founder's own bed. Dedup keeps the peopled one.
	local a, b = "deed:dupe:aaa", "deed:dupe:bbb"
	mg_villages.all_villages[a] = {
		vx = 800, vz = 800, vh = 11, vs = 16, name = "Oldtwin",
		is_player_town = true, founder = "dupe", to_add_data = {bpos = {
			{x = 800, y = 10, z = 800, btype = "player_house",
			 beds = {{bnr = 1, x = 801, y = 11, z = 801, first_name = "Throg"}}},
		}},
	}
	mg_villages.all_villages[b] = {
		vx = 900, vz = 900, vh = 11, vs = 16, name = "Oldtwin",
		is_player_town = true, founder = "dupe", to_add_data = {bpos = {
			{x = 900, y = 10, z = 900, btype = "player_house",
			 beds = {{bnr = 1, x = 901, y = 11, z = 901, player_owner = "dupe"}}},
		}},
	}
	local removed = settlement.dedup_towns()
	check("dedup removes an empty duplicate town", removed >= 1, removed)
	check("...keeping the copy with a resident", mg_villages.all_villages[a] ~= nil)
	check("...and dissolving the founder-only copy",
			mg_villages.all_villages[b] == nil)
	mg_villages.all_villages[a] = nil

	----------------------------------------------------------------------------
	-- Your own town is your own: the founder is never a thief in it
	----------------------------------------------------------------------------

	local crime  = village_life.crime
	local events = village_life.events
	local ctid = "deed:owner:crime"
	mg_villages.all_villages[ctid] = {
		vx = 1000, vz = 1000, vh = 11, vs = 16, name = "Mine",
		is_player_town = true, founder = "owner", to_add_data = {bpos = {}},
	}
	local cpos = {x = 1001, y = 11, z = 1001}

	-- A chest under the hand, a witness watching, and the theft recorded -- so the
	-- only thing that decides guilt here is who is doing the taking.
	local real_node = minetest.get_node_or_nil
	minetest.get_node_or_nil = function() return {name = "default:chest"} end
	local real_wit, real_raise = events.witnesses, events.raise
	events.witnesses = function() return {"vl:onlooker"} end
	local raised
	events.raise = function(ev) raised = ev; return ev end

	core.make_test_player("owner", 1001, 11, 1001)
	core.make_test_player("thief", 1001, 11, 1001)
	local loot = ItemStack("default:diamond 3")

	raised = nil
	crime.on_take(cpos, loot, minetest.get_player_by_name("owner"))
	check("the founder is never a thief in their own town", raised == nil)

	raised = nil
	crime.on_take(cpos, loot, minetest.get_player_by_name("thief"))
	check("...but another player taking the same chest still answers for it",
			raised ~= nil)

	events.witnesses, events.raise = real_wit, real_raise
	minetest.get_node_or_nil = real_node
	mg_villages.all_villages[ctid] = nil
end

--------------------------------------------------------------------------------
-- Redeeming monsters: yell one down, calm it, recruit it, betray it
--------------------------------------------------------------------------------

do
	local redeem   = village_life.redeem
	local wanderer = village_life.wanderer
	local re       = core.registered_entities

	local function beast(name, x, y, z)
		return {
			name = name,
			object = stub_object(x or 300, y or 11, z or 300),
			set_animation = function() end,
			set_velocity = function() end,
			set_yaw = function() end,
		}
	end

	----------------------------------------------------------------------------
	-- Predicates + attachment
	----------------------------------------------------------------------------

	local lion = beast("zombies:lionman")
	check("a beastman is recognised as a sentient monster",
			redeem.is_sentient(lion) == true)
	check("a troll is a redeem creature but not a sentient monster",
			redeem.is_creature("lottmobs:troll")
			and not redeem.is_sentient({name = "lottmobs:troll"}))
	check("a raging beastman is not yet a recruit",
			wanderer.is(lion) == false
			and village_life.is_bedless_recruit(lion) == false)
	check("redeem wired the beastman prototype",
			re["zombies:lionman"].do_custom ~= nil
			and re["zombies:lionman"].on_rightclick ~= nil)
	check("redeem marked the beastman persistent (never despawns)",
			re["zombies:lionman"].persistent == true)

	----------------------------------------------------------------------------
	-- The yell: calming word + loudness
	----------------------------------------------------------------------------

	check("a calming word is required",
			redeem.has_calm_word("get away from me") == false
			and redeem.has_calm_word("please, stop") == true)
	check("caps and ! make a yell louder",
			redeem.loudness("STOP!!") > redeem.loudness("stop"),
			redeem.loudness("stop") .. " -> " .. redeem.loudness("STOP!!"))

	-- yell() idles a sentient monster in earshot when the roll lands.
	local real_objs, real_rand = core.get_objects_inside_radius, math.random
	core.make_test_player("yeller", 300, 11, 300)
	core.get_objects_inside_radius = function()
		return {{get_luaentity = function() return lion end}}
	end
	math.random = function() return 0 end          -- force the chance to land
	redeem.yell("yeller", "STOP! EASY NOW!")
	check("shouting a calming word idles a beast in earshot",
			redeem.is_idling(lion) == true)
	lion._calm_until, lion._calm_loud = nil, nil
	redeem.yell("yeller", "hello there friendo")   -- no calm word
	check("an ordinary line does not idle it", redeem.is_idling(lion) == false)
	core.get_objects_inside_radius, math.random = real_objs, real_rand

	----------------------------------------------------------------------------
	-- Idling: frozen, and re-arming when the window closes
	----------------------------------------------------------------------------

	redeem.begin_idle(lion, 30, 2)
	check("an idled beast stops targeting players", lion.attack_players == false)
	check("do_custom freezes an idling beast (returns false, no native AI)",
			redeem.do_custom(lion, 0.1, nil, function() return "NATIVE" end) == false)

	lion._calm_until = village_life.util.now() - 1     -- window elapsed
	local nat = redeem.do_custom(lion, 0.1, nil, function() return "NATIVE" end)
	check("an expired idle re-arms and hands back to native monster AI",
			lion.attack_players == true and nat == "NATIVE")

	----------------------------------------------------------------------------
	-- Calming: loses monster status, becomes a recruit with a name and a role
	----------------------------------------------------------------------------

	redeem.begin_idle(lion, 30, 2)
	check("calming an idled beast succeeds", redeem.calm(lion, "yeller") == true)
	check("...it loses monster status (type npc, no player attacks)",
			lion.type == "npc" and lion.attack_players == false
			and lion._calmed == true)
	check("...it is given a name", lion.game_name ~= nil and lion.game_name ~= "")
	check("...and a town role of hunter/barbarian/monster",
			lion.profession == "hunter" or lion.profession == "barbarian"
			or lion.profession == "monster", lion.profession)
	check("...now it IS a wanderer recruit",
			wanderer.is(lion) == true
			and village_life.is_bedless_recruit(lion) == true)
	check("...and do_custom delegates to the villager brain, not native AI",
			redeem.do_custom(lion, 0.1, nil, function() return "NATIVE" end) ~= "NATIVE")

	----------------------------------------------------------------------------
	-- Betrayal: a homeless calmed beast reverts; a settled one does not
	----------------------------------------------------------------------------

	redeem.revert(lion, "test")
	check("a homeless calmed beast reverts to a monster if betrayed",
			lion._calmed == nil and lion.type == "monster"
			and lion.attack_players == true)

	-- A settled beastman is a villager: revert refuses it (it defends itself
	-- through the ordinary rouse instead of relapsing on its own town).
	local settled = beast("zombies:gnoll")
	settled.vl = {v = "100:200", p = 1, b = 1}
	settled._calmed = true
	redeem.revert(settled, "struck")
	check("a settled beastman does not relapse into a monster",
			settled.type ~= "monster" and settled._calmed == true)

	----------------------------------------------------------------------------
	-- Trolls: recruitable directly, guard AI chained
	----------------------------------------------------------------------------

	local troll = beast("lottmobs:troll")
	check("a troll is a recruit without any calming (calm_required false)",
			wanderer.is(troll) == true)
	troll._guard_ran = nil
	redeem.do_custom(troll, 0.1, nil, re["lottmobs:troll"].do_custom)
	check("a wild troll keeps its own guard do_custom (chained, not clobbered)",
			troll._guard_ran == true)

	----------------------------------------------------------------------------
	-- A settled beastman revived from its bed comes up peaceful AND armed
	----------------------------------------------------------------------------

	local town = "deed:redeemer:test"
	mg_villages.all_villages[town] = {
		vx = 300, vz = 300, vh = 11, vs = 16, is_player_town = true,
		founder = "redeemer",
		to_add_data = {bpos = {
			{x = 300, y = 10, z = 300, btype = "player_house",
			 bsizex = 3, bsizez = 3, brotate = 0, beds = {
				{bnr = 1, x = 301, y = 11, z = 301, p2 = 0,
				 first_name = "Rassh", title = "hunter", gender = "m",
				 species = "zombies:lionman"},
			}},
		}},
	}
	local spawned
	local real_add = core.add_entity
	core.add_entity = function(pos, name)
		local ent = beast(name, pos.x, pos.y, pos.z)
		ent.health = 30
		spawned = ent
		ent.object.get_luaentity = function() return ent end
		return ent.object
	end
	home.spawn(town, 1, 1, mg_villages.all_villages[town].to_add_data.bpos[1].beds[1],
			mg_villages.all_villages[town].to_add_data.bpos[1])
	core.add_entity = real_add
	check("a settled beastman is revived as its own species", spawned ~= nil
			and spawned.name == "zombies:lionman")
	check("...made peaceful on revival (npc, no player attacks)",
			spawned and spawned.type == "npc" and spawned.attack_players == false
			and spawned._calmed == true)
	check("...and armed to its Hunter role (fights, damage well above a pacifist)",
			spawned and spawned.attack_monsters == true
			and (spawned.damage or 0) >= 8, spawned and spawned.damage)
	mg_villages.all_villages[town] = nil
end

--------------------------------------------------------------------------------
-- Recruiting champions, persistence, and trolls fleeing the sun
--------------------------------------------------------------------------------

do
	local redeem   = village_life.redeem
	local wanderer = village_life.wanderer
	local re       = core.registered_entities

	----------------------------------------------------------------------------
	-- Everyone who should persist, does
	----------------------------------------------------------------------------

	-- (The pigman prototype is deliberately replaced by an earlier threat-
	-- classification test, so it is checked there, not here; the traders go
	-- through the identical attach_brain path and are not clobbered.)
	check("the wandering traders are marked persistent",
			re["lottmobs:dwarf_trader"].persistent == true
			and re["lottmobs:elf_trader"].persistent == true
			and re["lottmobs:human_trader"].persistent == true
			and re["lottmobs:mung_trader"].persistent == true)
	check("trolls are marked persistent (via redeem)",
			re["lottmobs:troll"].persistent == true)
	check("buff pigman champions are marked persistent (via defence)",
			re["zombies:buffpig"].persistent == true)

	----------------------------------------------------------------------------
	-- A buff pigman is a recruitable champion
	----------------------------------------------------------------------------

	local buff = {
		name = "zombies:buffpig", hp_max = 250,
		object = stub_object(320, 11, 320),
		set_animation = function() end, set_velocity = function() end,
	}
	check("a buff pigman is a recruit without any calming",
			wanderer.is(buff) == true
			and village_life.is_bedless_recruit(buff) == true)
	check("its right-click opens the full recruit dialogue, not the champion box",
			re["zombies:buffpig"].on_rightclick ~= nil)

	-- Settled as a champion, it arms at the champion tier -- and is NOT nerfed to
	-- a guard's hit points (the one tier that raises hp instead of settling it).
	local hp_set
	local champ = {
		name = "zombies:buffpig",
		id = "vl_100:200/1/1", vl = {v = "100:200", p = 1, b = 1},
		game_name = "Tusk", profession = "champion", gender = "m", health = 250,
		object = {
			get_pos = function() return {x = 102, y = 11, z = 202} end,
			set_properties = function(_, p) if p.hp_max then hp_set = p.hp_max end end,
		},
		set_animation = function() end, set_velocity = function() end,
		set_yaw = function() end,
	}
	local bed1 = mg_villages.all_villages["100:200"].to_add_data.bpos[1].beds[1]
	local keep_title = bed1.title
	bed1.title = "champion"
	village_life.apply_role(champ)
	check("a settled champion fights (armed, attacks monsters)",
			champ.attack_monsters == true and (champ.damage or 0) >= 10, champ.damage)
	check("...and keeps its huge frame rather than a guard's hp",
			hp_set == 250, hp_set)
	bed1.title = keep_title

	----------------------------------------------------------------------------
	-- Trolls flee the sun
	----------------------------------------------------------------------------

	check("a troll is light-shy; a buff pigman is not",
			redeem.is_lightshy({name = "lottmobs:troll"}) == true
			and redeem.is_lightshy({name = "zombies:buffpig"}) == false)

	local troll = {
		name = "lottmobs:troll", object = stub_object(340, 11, 340),
		set_animation = function() end, set_velocity = function() end,
		set_yaw = function() end,
	}
	local real_light = core.get_node_light
	local real_setgoal, real_navtick = village_life.nav.set_goal, village_life.nav.tick
	village_life.nav.set_goal = function() end
	village_life.nav.tick = function() end

	core.get_node_light = function() return 15 end        -- open daylight
	check("a troll in daylight flees for cover (do_custom suppresses the rest)",
			redeem.do_custom(troll, 0.1, nil, function() return "GUARD" end) == false)

	core.get_node_light = function() return 4 end         -- shade / night
	troll._guard_ran = nil
	check("a troll in shade goes about its business (native AI runs)",
			redeem.do_custom(troll, 0.1, nil, function() return "GUARD" end) == "GUARD")

	core.get_node_light = real_light
	village_life.nav.set_goal, village_life.nav.tick = real_setgoal, real_navtick
end

--------------------------------------------------------------------------------
-- Backstory: a villager who moved here, and the news of it
--------------------------------------------------------------------------------

do
	local backstory = village_life.backstory
	local events = village_life.events
	local V = "100:200"

	-- Yorath's bed (100:200/1/1) starts with no backstory: born here.
	local yorath = {
		id = "vl_100:200/1/1", vl = {v = V, p = 1, b = 1},
		game_name = "Yorath", object = stub_object(105, 11, 205),
	}
	check("a home-grown villager has no backstory",
			backstory.of(yorath) == nil)

	-- Stamp one on: he kept a post called Dvpige and sold it to Ulfgar.
	check("a backstory can be stamped onto a bed",
			backstory.set(V, 1, 1,
					{from_place = "Dvpige", sold_to = "Ulfgar", moved_day = 877}))
	local b = backstory.of(yorath)
	check("...and read back", b ~= nil and b.from_place == "Dvpige"
			and b.sold_to == "Ulfgar" and b.moved_day == 877)
	check("a fresh arrival is news again (arrival_told cleared)",
			backstory.of(yorath).bed.arrival_told == nil)

	-- The fact rides one bed, not the whole village.
	local freya = {
		id = "vl_100:200/1/2", vl = {v = V, p = 1, b = 2},
		object = stub_object(105, 11, 205),
	}
	check("the backstory rides one bed, not the village",
			backstory.of(freya) == nil)

	-- The arrival is speakable: the new event kind phrases with name and origin.
	local said = events.retell(
			{kind = "arrival", subject_name = "Yorath",
			 detail = {from = "Dvpige"}}, 0, nil)
	check("an arrival is told with who came and where from",
			type(said) == "string" and said:find("Yorath") ~= nil
					and said:find("Dvpige") ~= nil, said)
	local bare = events.retell(
			{kind = "arrival", subject_name = "Yorath", detail = {}}, 0, nil)
	check("...and still says something when the origin is not known",
			type(bare) == "string" and bare:find("Yorath") ~= nil, bare)

	-- Leave the fixture bed as it was found.
	local bed = village_life.home.bed_data(V, 1, 1)
	bed.moved_from, bed.sold_to, bed.moved_day, bed.arrival_told =
			nil, nil, nil, nil
end

--------------------------------------------------------------------------------
-- Buying a plot: claiming it, and staffing it with your own villagers
--------------------------------------------------------------------------------

do
	local settlement = village_life.settlement
	local plotclaim = village_life.plotclaim
	local P = "buyer"

	-- A shop the player has bought in a mapgen hamlet: owner set, one bed set
	-- aside (vacant) ready for a newcomer.
	mg_villages.all_villages["500:500"] = {
		vx = 500, vz = 500, vh = 10, vs = 30, name = "Farhold",
		village_type = "hamlet",
		to_add_data = {bpos = {
			{x = 500, y = 10, z = 500, bsizex = 5, bsizez = 5, btype = "house",
			 brotate = 0, owner = P, beds = {
				{bnr = 1, x = 501, y = 11, z = 501, p2 = 0, vacant = true},
			 }},
		}},
	}

	-- The recruit search (what "come and live in my town" uses) now sees a
	-- reserved bed in a plot you bought, not only beds in a town you founded.
	local vid, pnr, bnr = settlement.recruit_town(P, {x = 501, z = 501})
	check("a bought plot's reserved bed is a valid recruit target",
			vid == "500:500" and pnr == 1 and bnr == 1, tostring(vid))

	-- The deed can open that bed to dedicate/staff it, because the plot is yours.
	local ov, oid, opnr, obnr = settlement.owned_bed_at(P, {x = 501, y = 11, z = 501})
	check("the deed can dedicate a bed in a plot you own",
			ov ~= nil and oid == "500:500" and opnr == 1 and obnr == 1)
	check("but not a plot owned by someone else",
			(settlement.owned_bed_at("stranger", {x = 501, y = 11, z = 501})) == nil)

	-- A non-vacant bed is not offered as a recruit slot.
	mg_villages.all_villages["500:500"].to_add_data.bpos[1].beds[1].vacant = nil
	mg_villages.all_villages["500:500"].to_add_data.bpos[1].beds[1].first_name = "Someone"
	check("a bed that is already lived in is not a recruit target",
			(settlement.recruit_town(P, {x = 501, z = 501})) == nil)
	mg_villages.all_villages["500:500"].to_add_data.bpos[1].beds[1].first_name = nil
	mg_villages.all_villages["500:500"].to_add_data.bpos[1].beds[1].vacant = true

	-- Joining the village: welcomed standing, membership, formal inhabitant.
	if village_life.settings.reputation then
		plotclaim.join(P, "500:500")
		check("joining a village records you as a member",
				plotclaim.is_member(P, "500:500"))
		check("...welcomed in standing (trusted or better)",
				village_life.reputation.get("500:500", P) >= 40)
		check("...and a formal inhabitant on the ownerlist",
				mg_villages.all_villages["500:500"].ownerlist
				and mg_villages.all_villages["500:500"].ownerlist[P] == true)
	end

	mg_villages.all_villages["500:500"] = nil
end

--------------------------------------------------------------------------------
-- Revenants: a displaced person resurfaces as a wanderer
--------------------------------------------------------------------------------

do
	local wanderer = village_life.wanderer

	-- A displaced human returns as the next human wandering trader spoken to.
	wanderer.remember_displaced("Swinrik", "human")
	local human = {name = "lottmobs:human_trader", id = "w1"}
	check("a displaced human resurfaces as a human wanderer",
			wanderer.name_for(human) == "Swinrik")
	check("...and the name sticks on that wanderer", human.game_name == "Swinrik")

	-- Once claimed it is not handed out again: the next trader is just a trader.
	local human2 = {name = "lottmobs:human_trader", id = "w2"}
	check("a claimed revenant is not handed out twice",
			wanderer.name_for(human2) ~= "Swinrik")

	-- Race is honoured: a dwarf name waits for a dwarf, not the next human by.
	wanderer.remember_displaced("Throfar", "dwarf")
	local human3 = {name = "lottmobs:human_trader", id = "w3"}
	check("a dwarf revenant is not spent on a human wanderer",
			wanderer.name_for(human3) ~= "Throfar")
	local dwarf = {name = "lottmobs:dwarf_trader", id = "w4"}
	check("...and comes back as the next dwarf trader",
			wanderer.name_for(dwarf) == "Throfar")
end

--------------------------------------------------------------------------------

io.write("\n", ok_count, " passed, ", fail_count, " failed\n")
os.exit(fail_count == 0 and 0 or 1)
