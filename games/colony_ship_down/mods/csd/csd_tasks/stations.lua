-- Task stations: the consoles, pads and planters tasks send you to.
--
-- Each station kind has a node (made here, or by another mod that passes
-- `node`). Where every station is gets remembered so the HUD can point at
-- the nearest one. Builders can place stations by hand; the ship generator
-- registers the ones it places with csd_tasks.add_station().

local S = csd_tasks.S
local storage = core.get_mod_storage()

csd_tasks.station_kinds = {}
local node_to_kind = {}

-- Positions by kind: stations[kind][hash] = {pos = pos, room = "Hydroponics"}
local stations = core.deserialize(storage:get_string("stations")) or {}

local save_pending = false
local function save_later()
	if save_pending then return end
	save_pending = true
	core.after(2, function()
		save_pending = false
		storage:set_string("stations", core.serialize(stations))
	end)
end

-- Returns the room a position is in. csd_ship replaces this.
function csd_tasks.room_name(pos)
	local meta = core.get_meta(pos)
	local room = meta:get_string("csd_room")
	if room ~= "" then return room end
	return S("Deck @1", math.floor(pos.y))
end

function csd_tasks.add_station(pos, kind, room)
	if not csd_tasks.station_kinds[kind] then return end
	stations[kind] = stations[kind] or {}
	stations[kind][core.hash_node_position(pos)] = {pos = vector.copy(pos), room = room}
	if room then
		local meta = core.get_meta(pos)
		meta:set_string("csd_room", room)
		meta:set_string("infotext", csd_tasks.station_kinds[kind].description .. "\n" .. room)
	end
	save_later()
end

function csd_tasks.remove_station(pos, kind)
	if stations[kind] then
		stations[kind][core.hash_node_position(pos)] = nil
		save_later()
	end
end

function csd_tasks.get_stations(kind)
	local out = {}
	for _, s in pairs(stations[kind] or {}) do
		out[#out + 1] = s
	end
	return out
end

-- exclude: optional set of core.pos_to_string() keys to skip
function csd_tasks.nearest_station(kind, pos, exclude)
	local best, best_d
	for _, s in pairs(stations[kind] or {}) do
		if not (exclude and exclude[core.pos_to_string(s.pos)]) then
			local d = vector.distance(pos, s.pos)
			if not best_d or d < best_d then
				best, best_d = s, d
			end
		end
	end
	return best, best_d
end

function csd_tasks.kind_at(pos)
	local node = core.get_node_or_nil(pos)
	return node and node_to_kind[node.name]
end

function csd_tasks.clear_stations()
	stations = {}
	storage:set_string("stations", core.serialize(stations))
end

-- Node shapes. The front face (-Z, towards whoever placed it) carries the screen texture.
local shapes = {
	console = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, 0.2, 0.5},     -- cabinet
			{-0.45, 0.2, 0.1, 0.45, 0.8, 0.3},     -- screen
		},
	},
	wall = {
		type = "fixed",
		fixed = {{-0.45, -0.45, 0.3, 0.45, 0.45, 0.5}},
	},
	vent = { -- a grille set flush into the wall
		type = "fixed",
		fixed = {{-0.5, -0.5, 0.42, 0.5, 0.5, 0.5}},
	},
	pad = {
		type = "fixed",
		fixed = {{-0.5, -0.5, -0.5, 0.5, -0.35, 0.5}},
	},
	planter = {
		type = "fixed",
		fixed = {{-0.45, -0.5, -0.45, 0.45, 0.1, 0.45}},
	},
	full = nil,
}

-- def = {
--   description = "Wiring Panel",
--   minigame = "wires",          -- csd_tasks.minigames id; nil if `node` handles use itself
--   shape = "console",           -- console | wall | pad | planter | full
--   screen = "csd_tasks_screen_wires.png",
--   light = 4,
--   node = "othermod:node",      -- use an existing node instead of making one
--   nodes = {...},               -- further node names that are the same station (e.g. charge levels)
-- }
function csd_tasks.register_station_kind(kind, def)
	def.kind = kind
	csd_tasks.station_kinds[kind] = def
	if def.node then
		node_to_kind[def.node] = kind
		for _, n in ipairs(def.nodes or {}) do
			node_to_kind[n] = kind
		end
		return
	end
	local name = "csd_tasks:station_" .. kind
	def.node = name
	local shape = def.shape or "console"
	local side = "csd_tasks_console_side.png"
	-- Three looks per station: normal, "_ok" (just fixed, green) and "_warn"
	-- (its ship system is failing, red). Same behaviour in all three.
	for _, variant in ipairs({"", "_ok", "_warn"}) do
		local vname = name .. variant
		node_to_kind[vname] = kind
		-- def.screens = {normal=, ok=, warn=} gives each look its own texture;
		-- otherwise the ok/warn looks are overlays on the normal screen.
		local screen = def.screens and def.screens[variant == "" and "normal" or variant:sub(2)]
			or (def.screen .. (variant ~= "" and ("^csd_tasks_overlay" .. variant .. ".png") or ""))
		local tiles
		if shape == "pad" then
			tiles = {screen, side, side, side, side, side}
		elseif shape == "vent" then
			tiles = {side, side, side, side, side, screen}
		elseif shape == "planter" then
			tiles = {screen, side, "csd_tasks_planter_side.png", "csd_tasks_planter_side.png",
				"csd_tasks_planter_side.png", "csd_tasks_planter_side.png"}
		else
			tiles = {"csd_tasks_console_top.png", side, side, side, side, screen}
		end
		-- ":" because other mods (csd_events) register station kinds too.
		core.register_node(":" .. vname, {
			description = def.description,
			drawtype = shapes[shape] and "nodebox" or "normal",
			node_box = shapes[shape],
			selection_box = shapes[shape],
			tiles = tiles,
			paramtype = "light",
			paramtype2 = "facedir",
			light_source = variant == "" and (def.light or 4) or 7,
			light_colour = (variant == "_ok" and "#60ff90") or (variant == "_warn" and "#ff4030") or nil,
			sunlight_propagates = shapes[shape] ~= nil,
			drop = name,
			groups = {cracky = 2, csd_station = 1, oddly_breakable_by_hand = 2,
				not_in_creative_inventory = variant ~= "" and 1 or nil},
			sounds = core.global_exists("default") and default.node_sound_metal_defaults and default.node_sound_metal_defaults() or nil,
			on_construct = function(pos)
				csd_tasks.add_station(pos, kind, csd_tasks.room_name(pos))
			end,
			on_destruct = function(pos)
				csd_tasks.remove_station(pos, kind)
			end,
			on_rightclick = function(pos, _, clicker)
				if clicker and clicker:is_player() then
					csd_tasks.use_station(pos, kind, clicker)
				end
			end,
			on_timer = function(pos)
				csd_tasks.set_station_state(pos, csd_tasks.kind_failing(kind) and "warn" or "normal")
			end,
		})
	end
end

-- Station looks ------------------------------------------------------------------

local WARN_BELOW = 30

-- The system a station kind serves (from the first task that uses it).
function csd_tasks.kind_system(kind)
	for _, t in pairs(csd_tasks.tasks or {}) do
		for _, step in ipairs(t.steps) do
			if step.kind == kind then return t.system end
		end
	end
end

function csd_tasks.kind_failing(kind)
	local sys = csd_tasks.kind_system(kind)
	return sys ~= nil and csd_tasks.get_system(sys) < WARN_BELOW
end

-- state: "normal" | "ok" | "warn"
function csd_tasks.set_station_state(pos, state)
	local node = core.get_node_or_nil(pos)
	local kind = node and node_to_kind[node.name]
	local def = kind and csd_tasks.station_kinds[kind]
	if not def or not def.node:find("^csd_tasks:") then return end
	local want = def.node .. (state == "normal" and "" or "_" .. state)
	if node.name ~= want then
		core.swap_node(pos, {name = want, param2 = node.param2})
	end
end

-- A station that was just fixed glows green for a while.
function csd_tasks.mark_fixed(pos)
	csd_tasks.set_station_state(pos, "ok")
	core.get_node_timer(pos):start(180)
	core.add_particlespawner({
		amount = 16, time = 0.3,
		pos = {min = vector.offset(pos, -0.4, 0, -0.4), max = vector.offset(pos, 0.4, 0.8, 0.4)},
		vel = {min = vector.new(-0.3, 0.6, -0.3), max = vector.new(0.3, 1.5, 0.3)},
		exptime = 1, size = 1.2, glow = 14, texture = "csd_tasks_scan_particle.png",
	})
end

core.register_on_mods_loaded(function()
	csd_tasks.register_on_system_change(function(id, value, old)
		if (value < WARN_BELOW) == (old < WARN_BELOW) then return end
		for kind in pairs(csd_tasks.station_kinds) do
			if csd_tasks.kind_system(kind) == id then
				for _, st in ipairs(csd_tasks.get_stations(kind)) do
					local node = core.get_node_or_nil(st.pos)
					if node and not node.name:find("_ok$") then
						csd_tasks.set_station_state(st.pos, value < WARN_BELOW and "warn" or "normal")
					end
				end
			end
		end
	end)
end)

-- Stations placed with schematics/VoxelManip miss on_construct; pick them up
-- the first time their block loads.
core.register_lbm({
	label = "Register CSD task stations",
	name = "csd_tasks:register_stations",
	nodenames = {"group:csd_station"},
	run_at_every_load = true,
	action = function(pos, node)
		local kind = node_to_kind[node.name]
		if kind and not (stations[kind] and stations[kind][core.hash_node_position(pos)]) then
			csd_tasks.add_station(pos, kind, csd_tasks.room_name(pos))
		end
		-- Catch up with the ship's state while this block was unloaded.
		if kind and not node.name:find("_ok$") then
			csd_tasks.set_station_state(pos, csd_tasks.kind_failing(kind) and "warn" or "normal")
		end
	end,
})
