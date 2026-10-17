-- creaturemob :: test/harness.lua
--
-- Loads the whole mod against a stubbed engine API and asserts that every
-- symbol consumer mods actually call is present. No server boot required.
--
--   luajit test/harness.lua        (run from mods/creaturemob)
--
-- This catches the failure mode that matters most for a compatibility layer:
-- a function that quietly stopped existing between upstream releases. It does
-- not exercise behaviour -- that needs the game.

local MODPATH = (arg and arg[0] or ""):gsub("test/harness%.lua$", ""):gsub("/$", "")
if MODPATH == "" then MODPATH = "." end

----------------------------------------------------------------------
-- Engine stubs
----------------------------------------------------------------------

local function noop() end
local function tbl() return {} end

local abms = {}

-- Mirrors builtin/game/register.lua:check_modname_prefix
local MODNAME = "creaturemob"
local prefix_errors = {}

local function check_prefix(name, kind)
	if name == nil then return name end
	if name:sub(1, 1) == ":" then return name:sub(2) end

	local expected = MODNAME .. ":"

	if name:sub(1, #expected) ~= expected then
		prefix_errors[#prefix_errors + 1] = ("%s %q needs a \":\" prefix (mod is %s)")
				:format(kind, name, MODNAME)
	elseif name:sub(#expected + 1):find("[^%w_]") then
		prefix_errors[#prefix_errors + 1] = ("%s %q contains unallowed characters")
				:format(kind, name)
	end

	return name
end

local registered_nodes = setmetatable({}, {__index = function()
	return {walkable = true, groups = {}, drawtype = "normal", liquid_viscosity = 0}
end})

-- Unknown nodes read as solid above, which is the safe default for a mob
-- runtime -- but air has to be registered explicitly or the whole world is a
-- wall and nothing that reasons about clearance can be tested. world.lua
-- memoises node definitions on first use, so this must be in place before the
-- mod is loaded.
registered_nodes["air"] = {walkable = false, groups = {},
		drawtype = "airlike", liquid_viscosity = 0}

-- Nodes the behavioural checks place in the world. Consulted by get_node
-- below, because world.lua captures core.get_node at load time and a later
-- reassignment would not reach it.
local scene_nodes = {}

local function scene_key(p)
	return math.floor(p.x + 0.5) .. "," .. math.floor(p.y + 0.5) .. "," ..
			math.floor(p.z + 0.5)
end

local function scene_get(p)
	return scene_nodes[scene_key(p)] or {name = "air", param2 = 0}
end

core = {
	registered_nodes = registered_nodes,
	registered_items = registered_nodes,
	registered_entities = {},
	registered_aliases = {},
	registered_craftitems = {},

	settings = {
		get = function() return nil end,
		get_bool = function(_, _, d) return d end
	},

	get_translator = function() return function(s, ...)
		local args = {...}
		return (s:gsub("@(%d)", function(n) return tostring(args[tonumber(n)]) end))
	end end,
	get_modpath = function(n) return n == "creaturemob" and MODPATH or nil end,
	get_current_modname = function() return "creaturemob" end,

	-- The engine enforces that a registered name starts with the current mod
	-- name, or with ':' to escape the check (builtin/game/register.lua,
	-- check_modname_prefix). Reproduced here because getting it wrong is silent
	-- until the game refuses to start, and this mod deliberately registers
	-- names under two foreign prefixes -- mobs: and creatura:.
	register_entity = function(name, def)
		name = check_prefix(name, "entity")
		core.registered_entities[name] = def
	end,
	register_node = function(name) check_prefix(name, "node") end,
	register_craftitem = function(name) check_prefix(name, "craftitem") end,
	register_tool = function(name) check_prefix(name, "tool") end,
	register_lbm = function(spec) check_prefix(spec and spec.name, "lbm") end,
	register_craft = noop,
	register_abm = function(def) abms[#abms + 1] = def end,
	register_alias = noop, register_alias_force = noop, register_globalstep = noop,
	register_on_mods_loaded = noop, register_on_joinplayer = noop,
	register_on_leaveplayer = noop, register_on_dieplayer = noop,
	register_on_respawnplayer = noop, register_chatcommand = noop,
	register_privilege = noop, register_on_punchplayer = noop,
	register_decoration = noop, register_biome = noop, register_ore = noop,
	register_on_player_hpchange = noop, register_on_shutdown = noop,
	register_on_generated = noop, register_on_newplayer = noop,
	register_on_player_receive_fields = noop, register_on_mapblocks_changed = noop,
	register_entity_damage_modifier = noop, register_on_rightclickplayer = noop,
	register_craft_predict = noop, register_on_item_eat = noop,
	register_on_placenode = noop, register_on_dignode = noop,
	log = noop, chat_send_player = noop, chat_send_all = noop,
	after = noop, sound_play = noop, sound_stop = noop,
	add_particlespawner = noop, add_particle = noop,
	set_node = noop, swap_node = noop, remove_node = noop, add_node = noop,
	add_item = noop, add_entity = noop, item_drop = noop,
	serialize = function() return "" end, deserialize = function() return nil end,
	get_node = scene_get,
	get_node_or_nil = scene_get,
	get_node_light = function() return 15 end,
	get_objects_inside_radius = tbl, get_objects_in_area = tbl,
	get_connected_players = tbl,
	get_timeofday = function() return 0.5 end,
	get_us_time = function() return 0 end,
	get_gametime = function() return 0 end,
	get_item_group = function() return 0 end,
	get_biome_data = function() return nil end,
	get_biome_name = function() return "" end,
	get_heat = function() return 50 end,
	get_humidity = function() return 50 end,
	find_node_near = function() return nil end,
	find_nodes_in_area = tbl,
	find_nodes_in_area_under_air = tbl,
	find_path = function() return nil end,
	line_of_sight = function() return true end,
	raycast = function() return function() return nil end end,
	hash_node_position = function(p) return p.x * 65536 + p.y * 256 + p.z end,
	get_position_from_hash = function() return {x = 0, y = 0, z = 0} end,
	get_content_id = function() return 0 end,
	get_name_from_content_id = function() return "air" end,
	get_voxel_manip = function() return {
		read_from_map = function() return {x=0,y=0,z=0}, {x=0,y=0,z=0} end,
		get_data = tbl, set_data = noop, write_to_map = noop,
		get_emerged_area = function() return {x=0,y=0,z=0}, {x=0,y=0,z=0} end
	} end,
	get_perlin = function() return {get_2d = function() return 0 end,
		get_3d = function() return 0 end} end,
	get_mapgen_setting = function() return "v7" end,
	get_mapgen_params = tbl,
	get_mapgen_object = function() return nil end,
	set_gen_notify = noop,
	is_protected = function() return false end,
	check_player_privs = function() return false end,
	is_creative_enabled = function() return false end,
	pos_to_string = function() return "" end,
	string_to_pos = function() return nil end,
	formspec_escape = function(s) return s end,
	colorize = function(_, s) return s end,
	show_formspec = noop, close_formspec = noop,
	global_exists = function(n) return _G[n] ~= nil end,
	explode_scrollbar_event = tbl,
	dir_to_yaw = function() return 0 end,
	yaw_to_dir = function() return {x = 0, y = 0, z = 1} end,
	item_place = noop, item_eat = function() return noop end,
	is_singleplayer = function() return true end,
	features = {},
	CONTENT_AIR = 126
}

minetest = core

vector = {
	new = function(x, y, z)
		if type(x) == "table" then return {x = x.x, y = x.y, z = x.z} end
		return {x = x or 0, y = y or 0, z = z or 0}
	end,
	add = function(a, b) return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z} end,
	subtract = function(a, b) return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z} end,
	multiply = function(a, n)
		if type(n) == "table" then return {x = a.x * n.x, y = a.y * n.y, z = a.z * n.z} end
		return {x = a.x * n, y = a.y * n, z = a.z * n}
	end,
	divide = function(a, n) return {x = a.x / n, y = a.y / n, z = a.z / n} end,
	distance = function(a, b)
		local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
		return (dx * dx + dy * dy + dz * dz) ^ 0.5
	end,
	length = function(a) return (a.x * a.x + a.y * a.y + a.z * a.z) ^ 0.5 end,
	normalize = function(a)
		local l = (a.x * a.x + a.y * a.y + a.z * a.z) ^ 0.5
		if l == 0 then return {x = 0, y = 0, z = 0} end
		return {x = a.x / l, y = a.y / l, z = a.z / l}
	end,
	direction = function(a, b)
		local d = {x = b.x - a.x, y = b.y - a.y, z = b.z - a.z}
		local l = (d.x * d.x + d.y * d.y + d.z * d.z) ^ 0.5
		if l == 0 then return {x = 0, y = 0, z = 0} end
		return {x = d.x / l, y = d.y / l, z = d.z / l}
	end,
	round = function(a)
		return {x = math.floor(a.x + 0.5), y = math.floor(a.y + 0.5), z = math.floor(a.z + 0.5)}
	end,
	floor = function(a)
		return {x = math.floor(a.x), y = math.floor(a.y), z = math.floor(a.z)}
	end,
	equals = function(a, b) return a.x == b.x and a.y == b.y and a.z == b.z end,
	offset = function(a, x, y, z) return {x = a.x + x, y = a.y + y, z = a.z + z} end,
	zero = function() return {x = 0, y = 0, z = 0} end
}

math.atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
math.hypot = math.hypot or function(x, y) return (x * x + y * y) ^ 0.5 end

ItemStack = function(s)
	return {
		get_name = function() return type(s) == "string" and s or "" end,
		get_count = function() return 1 end,
		is_empty = function() return s == nil or s == "" end,
		take_item = noop, add_item = noop, set_count = noop, to_string = function() return "" end
	}
end

default = {
	register_fence = noop, node_sound_leaves_defaults = tbl,
	node_sound_dirt_defaults = tbl, node_sound_wood_defaults = tbl,
	gui_bg = "", gui_bg_img = "", gui_slots = "", get_hotbar_bg = function() return "" end
}

----------------------------------------------------------------------
-- Load the mod
----------------------------------------------------------------------

local ok, err = pcall(dofile, MODPATH .. "/init.lua")

if not ok then
	io.stderr:write("LOAD FAILED: " .. tostring(err) .. "\n")
	os.exit(1)
end

----------------------------------------------------------------------
-- Expected surface
----------------------------------------------------------------------

local missing = {}

local function want(tblname, root, names)
	for _, n in ipairs(names) do
		local cur, path = root, tblname
		for part in n:gmatch("[^%.]+") do
			path = path .. "." .. part
			cur = type(cur) == "table" and cur[part] or nil
			if cur == nil then break end
		end
		if cur == nil then missing[#missing + 1] = path end
	end
end

-- Mobs Redo: values
want("mobs", mobs, {
	"mod", "version", "invis", "node_snow", "node_dirt", "fallback_node",
	"spawning_mobs", "mob_class", "is_creative", "translate"
})

-- Mobs Redo: functions, including the legacy surface upstream deleted
want("mobs", mobs, {
	"register_mob", "register_spawn", "spawn", "spawn_specific", "spawn_abm_check",
	"add_mob", "can_spawn", "register_arrow", "register_egg", "capture_mob",
	"force_capture", "feed_tame", "protect", "alias_mob", "remove", "effect",
	"explosion", "boom", "safe_boom", "node_ok", "is_node_dangerous",
	"yaw", "set_animation", "line_of_sight", "yaw_to_pos", "scale_mob",
	"is_invisible", "compatibility_check",
	-- mount.lua: attach/detach/drive/fly. There is no mobs:mount -- api.txt
	-- lists one, but no release ever defined it and nothing calls it.
	"attach", "detach", "drive", "fly"
})

-- Mobs Redo: private methods consumer mods call on `self`
want("mobs.mob_class", mobs and mobs.mob_class, {
	"set_velocity", "set_yaw", "set_animation", "do_states", "do_attack",
	"do_jump", "do_env_damage", "follow_flop", "general_attack", "breed",
	"replace", "on_step", "on_punch", "mob_activate", "mob_staticdata",
	"get_nodes", "is_at_cliff", "smart_mobs", "do_smart_path", "flight_check",
	"attempt_flight_correction", "yaw_to_pos", "line_of_sight", "collision",
	"set_velocity_legacy"
})

-- creatura
want("creatura", creatura, {
	"register_mob", "register_utility", "register_movement_method",
	"register_abm_spawn", "register_mob_spawn", "register_spawn_item",
	"register_spawn_egg", "register_on_spawn",
	"registered_utilities", "registered_movement_methods",
	"registered_mob_spawns", "registered_on_spawns",
	"is_valid", "is_alive", "get_node_def", "get_node_height_from_def",
	"get_ground_level", "is_pos_moveable", "is_blocked", "fast_ray_sight",
	"sensor_floor", "sensor_ceil",
	"get_nearby_player", "get_nearby_players", "get_nearby_object",
	"get_nearby_objects", "get_nearby_entity", "get_nearby_entities",
	"default_water_physics", "default_vitals", "drop_items", "basic_punch_func",
	"calc_steering", "get_context_default", "get_context_large",
	"get_context_small", "get_context_small_aquatic", "get_context_steering",
	"get_collision", "get_avoidance_lift", "get_avoidance_lift_aquatic",
	"action_move", "action_walk", "action_idle", "action_fallover",
	"get_next_move", "get_next_move_3d",
	"find_path", "find_lvm_path", "find_theta_path",
	"get_boid_dir", "get_boid_cached",
	"pathfinder.find_path", "pathfinder.find_path_theta",
	"pathfinder.get_neighbors_fly", "pathfinder.get_neighbors_swim"
})

-- creaturemob core
want("creaturemob", creaturemob, {
	"motion.apply", "motion.init", "motion.turn_to", "motion.turn_to_delayed",
	"motion.set_forward_velocity", "motion.set_vertical_velocity",
	"motion.set_vertical_impulse", "motion.set_world_velocity",
	"motion.set_gravity", "motion.set_friction", "motion.set_drag",
	"motion.set_push", "motion.add_horizontal_accel", "motion.halt",
	"motion.invalidate",
	"world.get_node_def", "world.is_blocked", "world.is_pos_moveable",
	"spawn.resolve_colbox", "spawn.has_room", "spawn.check_biome",
	"spawn.check_climate", "spawn.prepare_biomes", "spawn.count_mobs",
	"scheduler.brain_scale", "scheduler.tick",
	"sensors.update_push", "sensors.get_push", "sensors.props",
	"pathfind.find_path", "pathfind.find_path_theta",
	"navigate.find_path", "navigate.smooth", "navigate.line_clear",
	"navigate.clear_ahead", "navigate.shape", "navigate.enabled",
	"navigate.reset", "navigate.budget_left", "navigate.forget_routes",
	"is_valid", "is_alive"
})

----------------------------------------------------------------------
-- Behavioural spot-checks that do not need a world
----------------------------------------------------------------------

local failures = {}

local function check(name, cond, detail)
	if not cond then failures[#failures + 1] = name .. (detail and (": " .. detail) or "") end
end

-- Both names for the renamed movement method must resolve to the same function.
check("theta_pathfind alias",
	creatura.registered_movement_methods["creatura:theta_pathfind"] ~= nil
	and creatura.registered_movement_methods["creatura:theta_pathfind"]
		== creatura.registered_movement_methods["creatura:pathfind_theta"])

-- The version gate goblins/backpacks/mobs_turtles test against.
check("mobs.mod", mobs.mod == "redo", tostring(mobs.mod))
check("mobs.version >= 20200516",
	tonumber(mobs.version) and tonumber(mobs.version) >= 20200516, tostring(mobs.version))

-- get_node_def must not mutate the shared node registry (upstream creatura bug).
do
	registered_nodes["test:snow"] = {
		walkable = true, drawtype = "nodebox",
		node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5}},
		groups = {}
	}
	local def = creatura.get_node_def("test:snow")
	check("short node reads as non-walkable", def.walkable == false)
	check("registry not mutated", registered_nodes["test:snow"].walkable == true,
		"get_node_def wrote back into core.registered_nodes")
end

-- Foreign entities must resolve a collision box.
do
	core.registered_entities["test:mobkit_mob"] = {collisionbox = {-1, -1, -1, 1, 1, 1}}
	local box = creaturemob.spawn.resolve_colbox("test:mobkit_mob")
	check("foreign colbox resolves", box ~= nil and box[4] == 1)
end

-- The controller must flush at most once, and not at all when nothing moved.
do
	local writes = {vel = 0, acc = 0, rot = 0}
	local fake = {
		_cm = nil,
		object = {
			get_velocity = function() return {x = 0, y = 0, z = 0} end,
			get_rotation = function() return {x = 0, y = 0, z = 0} end,
			get_yaw = function() return 0 end,
			set_velocity = function() writes.vel = writes.vel + 1 end,
			set_acceleration = function() writes.acc = writes.acc + 1 end,
			set_rotation = function() writes.rot = writes.rot + 1 end
		}
	}
	local m = creaturemob.motion
	m.init(fake)
	m.set_forward_velocity(fake, 0)
	m.apply(fake, 0.09)
	local first_vel, first_acc = writes.vel, writes.acc
	m.apply(fake, 0.09)
	m.apply(fake, 0.09)
	check("first apply writes velocity", first_vel == 1, tostring(first_vel))
	check("idle steps send nothing", writes.vel == first_vel and writes.acc == first_acc,
		("vel %d acc %d"):format(writes.vel, writes.acc))
end

-- A swimmer's vertical intent must survive the set_velocity() that do_states'
-- "walk" state issues in the same tick. That call clears cm.world_* but not
-- cm.vert_once -- which is exactly why the swimmer code drives depth with a
-- vertical impulse rather than a world velocity. If this regresses, fish stop
-- moving up or down and hover on the surface.
do
	local last
	local fake = {
		object = {
			get_velocity = function() return {x = 0, y = 0, z = 0} end,
			get_rotation = function() return {x = 0, y = 0, z = 0} end,
			get_yaw = function() return 0 end,
			set_velocity = function(_, v) last = v end,
			set_acceleration = noop,
			set_rotation = noop
		}
	}
	local m = creaturemob.motion
	m.init(fake)
	m.set_vertical_impulse(fake, 3)   -- the swimmer's depth change
	m.set_forward_velocity(fake, 2)   -- do_states issues this straight after
	m.apply(fake, 0.09)
	check("vertical impulse survives a same-tick set_velocity",
		last ~= nil and math.abs(last.y - 3) < 1e-6, last and tostring(last.y))

	-- A world velocity, by contrast, is cleared by that same set_forward_velocity
	-- -- documenting the trap the swimmer fix sidesteps.
	last = nil
	m.init(fake)
	m.set_world_velocity(fake, 0, 3, 0)
	m.set_forward_velocity(fake, 2)
	m.apply(fake, 0.09)
	check("world velocity is wiped by a same-tick set_velocity (the trap)",
		last ~= nil and math.abs(last.y) < 1e-6, last and tostring(last.y))
end

-- A submerged creatura swimmer must never be left with zero gravity. The merge
-- derived buoyancy from _movement_data.gravity, which the swim methods zero, so
-- a fish parked at the surface had no restoring force. default_water_physics now
-- uses a fixed base gravity: in liquid a full-submergence fish gets half gravity
-- (negative), never 0.
do
	local real_group = core.get_item_group
	core.get_item_group = function(name, grp)
		if grp == "liquid" then return 1 end
		return 0
	end

	local fake = {
		liquid_submergence = 1,               -- fish (bouyancy_multiplier = 0)
		height = 0.3,
		stand_pos = {x = 0, y = 0, z = 0},
		stand_node = {name = "test:water"},
		_movement_data = {gravity = 0},       -- poisoned by a swim method
		dtime = 0.09,
		object = { get_velocity = function() return {x = 0, y = 0, z = 0} end }
	}
	creaturemob.motion.init(fake)
	creatura.default_water_physics(fake)

	check("submerged fish is flagged in_liquid", fake.in_liquid == "test:water")
	check("submerged fish keeps a restoring force (gravity ~= 0)",
		fake._cm.grav ~= nil and fake._cm.grav < 0, tostring(fake._cm.grav))

	core.get_item_group = real_group
end

-- Turning must be time-scaled and must terminate exactly on target.
do
	local yaw = 0
	local fake = {
		object = {
			get_velocity = function() return {x = 0, y = 0, z = 0} end,
			get_rotation = function() return {x = 0, y = yaw, z = 0} end,
			get_yaw = function() return yaw end,
			set_velocity = noop,
			set_acceleration = noop,
			set_rotation = function(_, r) yaw = r.y end
		}
	}
	local m = creaturemob.motion
	m.init(fake)
	m.turn_to(fake, math.pi / 2, 1) -- 1 rad/s
	for _ = 1, 200 do m.apply(fake, 0.05) end
	check("turn reaches target", math.abs(yaw - math.pi / 2) < 1e-6, tostring(yaw))

	-- Half the tick rate, same wall-clock time -> same result.
	yaw = 0
	m.init(fake)
	m.turn_to(fake, math.pi / 2, 1)
	for _ = 1, 100 do m.apply(fake, 0.10) end
	check("turn is framerate independent", math.abs(yaw - math.pi / 2) < 1e-6, tostring(yaw))
end

-- creatura.register_mob_spawn must not create an ABM.
--
-- Upstream deprecated it into a shim forwarding to register_abm_spawn, which
-- silently converts "one probe per player per 15s" into "one roll per matching
-- node per active mapblock per 30s". draconis registers a wyvern on
-- group:leaves with chance 16; as an ABM that is thousands of rolls per interval
-- in any forest, which is how the world filled with dragons.
do
	local before = #abms

	creatura.register_mob_spawn("draconis:jungle_wyvern", {
		chance = 16,
		min_group = 1,
		max_group = 2,
		biomes = {"deciduous_forest"},
		nodes = {"group:leaves"}
	})

	check("register_mob_spawn creates no ABM", #abms == before,
		("registered %d ABM(s); it must only record the definition")
			:format(#abms - before))

	check("register_mob_spawn still records the def",
		creatura.registered_mob_spawns["draconis:jungle_wyvern"] ~= nil
		and creatura.registered_mob_spawns["draconis:jungle_wyvern"].chance == 16,
		"consumer mods read registered_mob_spawns directly")
end

-- Non-monsters must not attack players unless their definition asks for it.
--
-- The fork this game ran guarded with `self.owner and self.type ~= "monster"`,
-- and `owner` defaults to "" -- truthy in Lua -- so no animal or NPC could ever
-- attack a player. Upstream tightened that to `... and self.tamed`, which flips
-- every untamed animal and NPC hostile, because attack_players defaults to true.
-- mg_villages' traders are type "npc" with attack_type "dogfight" and no
-- attack_players setting: under upstream's rule they beat players to death.
do
	mobs:register_mob("test:trader", {type = "npc", attack_type = "dogfight"})
	mobs:register_mob("test:beast", {type = "monster", attack_type = "dogfight"})
	mobs:register_mob("test:guard", {type = "npc", attack_type = "dogfight",
			attack_players = true})

	local trader = core.registered_entities["test:trader"]
	local beast = core.registered_entities["test:beast"]
	local guard = core.registered_entities["test:guard"]

	check("npc without attack_players is not marked explicit",
		trader.attack_players_explicit == false)
	check("npc with attack_players = true is marked explicit",
		guard.attack_players_explicit == true)
	check("monster def registers", beast ~= nil)

	-- Mirror the guard expression from general_attack().
	local function ignores_players(def)
		local attack_players = def.attack_players
		if attack_players == nil then attack_players = mobs.mob_class.attack_players end
		return not attack_players
			or (def.type ~= "monster"
				and not (def.attack_players_explicit and attack_players))
	end

	check("trader ignores players", ignores_players(trader) == true)
	check("guard still attacks players", ignores_players(guard) == false)
	check("monster still attacks players", ignores_players(beast) == false)
end

----------------------------------------------------------------------
-- A swimmer only drowns when genuinely beached
----------------------------------------------------------------------

-- Regression: aquatic mobs (e.g. zombies:salmon) took air/drowning damage
-- whenever the collisionbox mid-point read non-water -- which happens for a
-- fish bobbing at the surface, or a big fish whose tiny feet-level colbox rides
-- the waterline while its scaled-up model is clearly submerged. air_damage
-- defaults to 1 for swimmers, so a 3 HP fish died in water in ~3 seconds.
-- get_nodes now also records water_below; do_env_damage only drowns a swimmer
-- with no medium at or below it, and on_step pushes the others back under.
do
	registered_nodes["test:water"] = {walkable = false, drawtype = "liquid",
			liquid_viscosity = 1, groups = {liquid = 3, water = 1}}

	local cb = {-0.4, 0.0, -0.4, 0.4, 0.79, 0.4} -- salmon's box

	local function make_fish(py)
		return {
			swimmer = true,
			fly_in = "test:water",
			prop = {collisionbox = cb},
			base_colbox = cb,
			object = {
				get_pos = function() return {x = 0, y = py, z = 0} end,
				get_yaw = function() return 0 end,
			},
		}
	end

	-- Mirrors the medium test in do_env_damage: drowns only when out of the
	-- body medium *and* nothing to sink into.
	local function drowns(fish)
		return (not fish.body_in_liquid) and (not fish.water_below)
	end

	local get_nodes = mobs.mob_class.get_nodes

	local function fill_water(top_node)
		for k in pairs(scene_nodes) do scene_nodes[k] = nil end
		for y = top_node - 20, top_node do
			for x = -1, 1 do for z = -1, 1 do
				scene_nodes[x .. "," .. y .. "," .. z] = {name = "test:water", param2 = 0}
			end end
		end
	end

	-- Fully submerged: body in water, lives.
	fill_water(20)
	local fish = make_fish(5)
	get_nodes(fish)
	check("submerged swimmer is in its medium", fish.body_in_liquid == true)
	check("submerged swimmer does not drown", drowns(fish) == false)

	-- Bobbing at the surface: body top clears the water (mid reads air) but the
	-- feet are still wet. This is the case that used to kill fish.
	fill_water(5)
	fish = make_fish(5.2)
	get_nodes(fish)
	check("surfaced swimmer's body is out of the water", fish.body_in_liquid == false)
	check("surfaced swimmer has water below it", fish.water_below == true)
	check("surfaced swimmer does NOT drown (regression)", drowns(fish) == false)

	-- Riding one node above the surface: water still sits beneath, so it is
	-- pulled back down rather than drowned.
	fill_water(5)
	fish = make_fish(6.0)
	get_nodes(fish)
	check("swimmer above the surface still finds water below", fish.water_below == true)
	check("swimmer above the surface does NOT drown", drowns(fish) == false)

	-- Genuinely beached on dry land: no medium anywhere, so it drowns as before.
	for k in pairs(scene_nodes) do scene_nodes[k] = nil end
	fish = make_fish(5)
	get_nodes(fish)
	check("beached swimmer is out of its medium", fish.body_in_liquid == false)
	check("beached swimmer has no water below", fish.water_below == false)
	check("beached swimmer still drowns", drowns(fish) == true)

	for k in pairs(scene_nodes) do scene_nodes[k] = nil end
end

----------------------------------------------------------------------
-- Shallow-water film counts as a swimmer's medium
----------------------------------------------------------------------

-- Regression: the water update rests thin "shallow water" film nodes on the
-- surface of every body of water. They carry group:water but are distinct nodes
-- (dynamic_liquid.shallow_*), absent from any fish's fly_in list, so a swimmer
-- riding just under a film-topped surface read its feet/body as "not my medium"
-- and thrashed at the waterline. is_swim_medium now accepts a shallow film that
-- carries group:water as a swimmer's medium.
do
	local cb = {-0.4, 0.0, -0.4, 0.4, 0.79, 0.4}
	registered_nodes["test:water"] = {walkable = false, drawtype = "liquid",
			liquid_viscosity = 1, groups = {liquid = 3, water = 1}}
	registered_nodes["test:shallow_8"] = {walkable = false, drawtype = "nodebox",
			liquid_viscosity = 0, groups = {water = 1, dynamic_liquid_shallow = 1}}

	-- Stand in for the dynamic_liquid mod: is_swim_medium resolves it lazily via
	-- rawget(_G, "dynamic_liquid").
	local prev_dl = _G.dynamic_liquid
	_G.dynamic_liquid = {shallow_units_by_name = {["test:shallow_8"] = 8}}

	local real_group = core.get_item_group
	core.get_item_group = function(name, grp)
		if name == "test:shallow_8" and grp == "water" then return 1 end
		return real_group(name, grp)
	end

	for k in pairs(scene_nodes) do scene_nodes[k] = nil end
	for y = -15, 5 do for x = -1, 1 do for z = -1, 1 do
		scene_nodes[x .. "," .. y .. "," .. z] = {name = "test:water", param2 = 0}
	end end end
	-- the film sits one node above the full source surface
	for x = -1, 1 do for z = -1, 1 do
		scene_nodes[x .. ",6," .. z] = {name = "test:shallow_8", param2 = 0}
	end end

	local fish = {
		swimmer = true,
		fly_in = "test:water",
		prop = {collisionbox = cb},
		base_colbox = cb,
		object = {
			get_pos = function() return {x = 0, y = 6.0, z = 0} end,
			get_yaw = function() return 0 end,
		},
	}
	mobs.mob_class.get_nodes(fish)
	check("swimmer in a shallow-water film is in its medium",
			fish.body_in_liquid == true)
	check("swimmer in a film is not read as beached", fish.water_below == true)
	check("flight_check passes in a shallow-water film",
			mobs.mob_class.flight_check(fish) == true)

	core.get_item_group = real_group
	_G.dynamic_liquid = prev_dl
	for k in pairs(scene_nodes) do scene_nodes[k] = nil end
end

----------------------------------------------------------------------
-- Obstacle avoidance is opt-out
----------------------------------------------------------------------

-- It shipped defaulting to false and nothing ever set it, so every mob in the
-- game still reacted to a wall the stock Mobs Redo way: turn a random amount
-- and hope.
do
	mobs:register_mob("test:ordinary", {type = "animal", hp_min = 1, hp_max = 1})
	mobs:register_mob("zombies:test_shambler", {type = "monster", hp_min = 1, hp_max = 1})
	mobs:register_mob("test:deliberately_dim", {type = "animal", hp_min = 1,
			hp_max = 1, smart_path = false})

	-- rawget, so this tests what registration decided rather than what the
	-- mob_class default supplies through the metatable.
	local function smart(name)
		local e = core.registered_entities[name]
		return e and rawget(e, "smart_path")
	end

	check("ordinary mobs avoid obstacles by default", smart("test:ordinary") == true,
			tostring(smart("test:ordinary")))
	check("the undead keep shambling", smart("zombies:test_shambler") == false,
			tostring(smart("zombies:test_shambler")))
	check("an explicit opt-out is honoured", smart("test:deliberately_dim") == false,
			tostring(smart("test:deliberately_dim")))
end

----------------------------------------------------------------------
-- Shared navigation service
----------------------------------------------------------------------

do
	local navigate = creaturemob.navigate

	-- A world with a wall running along one x plane.
	registered_nodes["test:wall"] = {walkable = true, groups = {},
			drawtype = "normal", liquid_viscosity = 0}

	local function set_wall(x)
		for k in pairs(scene_nodes) do scene_nodes[k] = nil end
		if not x then return end
		for y = -1, 4 do
			for z = -20, 20 do
				scene_nodes[x .. "," .. y .. "," .. z] = {name = "test:wall", param2 = 0}
			end
		end
	end

	set_wall(5)

	check("a wall blocks the line",
			navigate.line_clear({x = 0, y = 1, z = 0}, {x = 10, y = 1, z = 0}, 0.35, 1.7)
			== false)
	check("open ground does not",
			navigate.line_clear({x = 0, y = 1, z = 0}, {x = 4, y = 1, z = 0}, 0.35, 1.7)
			== true)

	-- Doors: walkable in every state, so the pathfinder treats them as walls --
	-- unless the query belongs to a mob that can open them (world.door_pass), in
	-- which case a registered openable is passable. A monster keeps seeing a wall.
	do
		local world = creaturemob.world
		registered_nodes["doors:door_wood_a"] = {walkable = true, groups = {door = 1},
				drawtype = "mesh", liquid_viscosity = 0}
		for k in pairs(scene_nodes) do scene_nodes[k] = nil end
		-- A single door across the path at x = 3.
		for y = -1, 4 do
			scene_nodes["3," .. y .. ",0"] = {name = "doors:door_wood_a", param2 = 0}
		end

		world.openable["doors:door_wood_a"] = true

		world.door_pass = false
		check("a shut door blocks a mob that cannot open it",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == true)

		world.door_pass = true
		check("...but not one that can (thin)",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == false)
		check("...nor a wide door-user (buffpig)",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.7, 2.7) == false)
		check("door-user's line of sight passes through the doorway",
				navigate.line_clear({x = 0, y = 1, z = 0}, {x = 6, y = 1, z = 0}, 0.35, 1.7)
				== true)
		world.door_pass = false
		check("a real wall still blocks a door-user",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == true)

		world.openable["doors:door_wood_a"] = nil
		world.door_pass = false
		-- Restore the wall the checks below this block expect.
		set_wall(5)
	end

	-- Hazards: fire and lava are non-walkable, so the pathfinder reads them as
	-- open air and a mob walks in to burn. Marked as hazards they block like a
	-- wall -- for everyone, and door-passing does not exempt them.
	do
		local world = creaturemob.world
		registered_nodes["fire:basic_flame"] = {walkable = false,
				groups = {igniter = 1}, drawtype = "firelike", damage_per_second = 4}
		for k in pairs(scene_nodes) do scene_nodes[k] = nil end
		for y = -1, 4 do
			scene_nodes["3," .. y .. ",0"] = {name = "fire:basic_flame", param2 = 0}
		end

		check("an unmarked flame reads as passable (the bug)",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == false)
		world.hazard["fire:basic_flame"] = true
		check("a flame blocks a mob once marked a hazard",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == true)
		world.door_pass = true
		check("door-passing does not let a mob walk through fire",
				world.is_blocked({x = 3, y = 1, z = 0}, 0.35, 1.7) == true)
		world.door_pass = false
		world.hazard["fire:basic_flame"] = nil
		set_wall(5)
	end

	-- Shape comes from the collisionbox, which is what makes the route fit the
	-- body rather than a point.
	local mob = {
		prop = {collisionbox = {-0.35, -0.01, -0.35, 0.35, 1.69, 0.35}},
		object = {get_pos = function() return {x = 0, y = 1, z = 0} end},
	}
	local w, h = navigate.shape(mob)
	check("shape reads the collisionbox half-width", math.abs(w - 0.35) < 0.001, w)
	check("shape reads the collisionbox height", math.abs(h - 1.7) < 0.001, h)

	check("smart pathing is on unless refused", navigate.enabled(mob) == true)
	mob.smart_path = false
	check("...and off when refused", navigate.enabled(mob) == false)
	mob.smart_path = nil

	check("clear ahead in the open",
			navigate.clear_ahead(mob, {x = -1, z = 0}, 3) == true)
	check("not clear ahead into the wall",
			navigate.clear_ahead(mob, {x = 1, z = 0}, 8) == false)

	-- Smoothing: an A* result on a grid is a staircase, and a follower aiming
	-- at each step of a staircase steers diagonally into every corner.
	set_wall(nil)
	local staircase = {}
	for i = 0, 8 do
		staircase[#staircase + 1] = {x = i, y = 1, z = 0}
		staircase[#staircase + 1] = {x = i, y = 1, z = i}
	end
	local smoothed = navigate.smooth(staircase, 0.35, 1.7)
	check("smoothing collapses a clear staircase", #smoothed < #staircase,
			#smoothed .. " of " .. #staircase)
	check("smoothing keeps the destination",
			smoothed[#smoothed].x == staircase[#staircase].x
			and smoothed[#smoothed].z == staircase[#staircase].z)

	-- ...but must not collapse through a wall.
	set_wall(3)
	local through_wall = {
		{x = 0, y = 1, z = 0}, {x = 1, y = 1, z = 0}, {x = 2, y = 1, z = 0},
		{x = 2, y = 1, z = 5}, {x = 6, y = 1, z = 5}, {x = 6, y = 1, z = 0},
	}
	local kept = navigate.smooth(through_wall, 0.35, 1.7)
	local shortcut = false
	for _, p in ipairs(kept) do
		if p.x == 6 and p.z == 0 then shortcut = true end
	end
	check("smoothing keeps the far end", shortcut)
	check("smoothing does not cut through a wall",
			navigate.line_clear(kept[1], kept[2], 0.35, 1.7) == true)

	-- Short paths are returned untouched rather than mangled.
	local tiny = {{x = 0, y = 1, z = 0}, {x = 1, y = 1, z = 0}}
	check("a two-point path is left alone", #navigate.smooth(tiny, 0.35, 1.7) == 2)
	check("nil survives smoothing", navigate.smooth(nil, 0.35, 1.7) == nil)

	-- Snapping the goal onto a standable tile.
	--
	-- This is the one that made mobs walk into walls. The A* success test is an
	-- exact node hash match when the goal is on the ground, so a goal one node
	-- off a standable tile -- a bed, a workplace marker -- can never be
	-- matched, and the search does not fail fast: it expands to the open-set
	-- ceiling first. Every such request burned the whole budget and returned
	-- nothing, and a caller with no route steers straight at the goal.
	set_wall(nil)
	for x = -6, 6 do
		for z = -6, 6 do
			scene_nodes[x .. ",0," .. z] = {name = "test:wall", param2 = 0}
		end
	end

	local on_floor = navigate.snap({x = 2, y = 1, z = 2}, 0.35, 1.7)
	check("a standable goal is left alone",
			on_floor.x == 2 and on_floor.y == 1 and on_floor.z == 2,
			on_floor.x .. "," .. on_floor.y .. "," .. on_floor.z)

	local midair = navigate.snap({x = 2, y = 3, z = 2}, 0.35, 1.7)
	check("a goal in mid-air is brought down to the floor", midair.y == 1,
			midair.y)

	-- A goal inside a solid node -- which is what a bed or a marker tile
	-- effectively is -- must come out somewhere a body can stand.
	scene_nodes["2,1,2"] = {name = "test:wall", param2 = 0}
	local inside = navigate.snap({x = 2, y = 1, z = 2}, 0.35, 1.7)
	check("a goal inside a solid node is moved out",
			not (inside.x == 2 and inside.y == 1 and inside.z == 2),
			inside.x .. "," .. inside.y .. "," .. inside.z)
	check("...to somewhere standable",
			scene_get({x = inside.x, y = inside.y - 1, z = inside.z}).name
			== "test:wall")

	-- Sidestepping.
	set_wall(5)
	check("a mob facing a wall is offered a way round",
			navigate.sidestep(mob, {x = 1, z = 0}, 8) ~= nil)
	local away = navigate.sidestep(mob, {x = 1, z = 0}, 8)
	check("and the way round is actually clear",
			navigate.clear_ahead(mob, away, 8) == true)
	check("a mob with nothing in the way is not deflected",
			navigate.clear_ahead(mob, {x = -1, z = 0}, 3) == true)

	-- The budget is shared and refills each step.
	check("a budget exists", navigate.budget_left() ~= nil)
	navigate.forget_routes()

	set_wall(nil)
end

----------------------------------------------------------------------
-- Climbing: ladders and ropes as vertical corridors
----------------------------------------------------------------------

-- A villager that falls down a shaft only gets out if the pathfinder will route
-- it up the rope -- which the ground grid, capped at a one-node step-up, never
-- does. Climb neighbours are offered only when the search belongs to a
-- climb-capable mob (world.climb_pass), so a monster stays trapped in the pit.
do
	local world = creaturemob.world
	local pathfind = creaturemob.pathfind

	registered_nodes["test:rope"] = {walkable = false, climbable = true,
			groups = {}, drawtype = "airlike", liquid_viscosity = 0}

	for k in pairs(scene_nodes) do scene_nodes[k] = nil end

	local function wall(x, y, z)
		scene_nodes[x .. "," .. y .. "," .. z] = {name = "test:wall", param2 = 0}
	end
	local function rope(x, y, z)
		scene_nodes[x .. "," .. y .. "," .. z] = {name = "test:rope", param2 = 0}
	end

	-- A one-wide well. Surface ground for x = 0..3 at y = 4 (a body stands at
	-- y = 5); a rope filling the shaft from y = 1..4; the shaft walled on every
	-- side down to its floor, so the only way up is the rope itself.
	for x = 0, 3 do wall(x, 4, 0) end
	wall(0, 0, 0)
	for y = 1, 4 do
		rope(0, y, 0)
		wall(1, y, 0) ; wall(-1, y, 0) ; wall(0, y, 1) ; wall(0, y, -1)
	end
	scene_nodes["0,5,0"] = nil   -- the top of the shaft is open air, not ground

	local function fresh() return {_path_data = {}, width = 0.35, height = 1.7} end
	local S = {x = 0, y = 1, z = 0}
	local G = {x = 3, y = 5, z = 0}

	world.climb_pass = false
	check("a walled shaft has no ground route out",
			pathfind.find_path(fresh(), S, G) == nil)

	world.climb_pass = true
	local climbed = pathfind.find_path(fresh(), S, G)
	world.climb_pass = false

	check("a climb-capable mob is routed up the rope",
			climbed ~= nil and #climbed > 0)
	if climbed then
		local top = 0
		for _, p in ipairs(climbed) do if p.y > top then top = p.y end end
		check("the route rises out of the shaft", top >= 5, "peak y=" .. top)
		check("the route reaches the goal",
				climbed[#climbed].x == 3 and climbed[#climbed].z == 0,
				climbed[#climbed].x .. "," .. climbed[#climbed].z)
	end

	for k in pairs(scene_nodes) do scene_nodes[k] = nil end
	registered_nodes["test:rope"] = nil
end

----------------------------------------------------------------------
-- Report
----------------------------------------------------------------------

for _, e in ipairs(prefix_errors) do
	failures[#failures + 1] = "naming conventions: " .. e
end

if #missing > 0 then
	io.write("MISSING SYMBOLS (" .. #missing .. "):\n")
	for _, m in ipairs(missing) do io.write("  " .. m .. "\n") end
end

if #failures > 0 then
	io.write("FAILED CHECKS (" .. #failures .. "):\n")
	for _, f in ipairs(failures) do io.write("  " .. f .. "\n") end
end

if #missing == 0 and #failures == 0 then
	io.write("creaturemob harness: all symbols present, all checks passed\n")
	os.exit(0)
end

os.exit(1)
