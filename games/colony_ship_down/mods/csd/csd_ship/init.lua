-- The colony ship.
--
--   nodes.lua   building palette (hull, walls, lights, lift field, furniture)
--   layout.lua  where the rooms go (data - edit to rearrange the ship)
--   build.lua   the generator
--   decor.lua   room decorators (furniture + task stations)
--
-- The generator runs once, the first time a CSD world starts. After that the
-- ship is just map: builders edit it by hand. /regenship rebuilds it.

csd_ship = {}
csd_ship.S = core.get_translator("csd_ship")
csd_ship.LAYOUT_VERSION = 1

local S = csd_ship.S
local storage = core.get_mod_storage()
local path = core.get_modpath("csd_ship")

dofile(path .. "/nodes.lua")
dofile(path .. "/cryo.lua")
dofile(path .. "/fixtures.lua")
dofile(path .. "/turrets.lua")
dofile(path .. "/doors.lua")
dofile(path .. "/layout.lua")
dofile(path .. "/build.lua")
dofile(path .. "/exterior.lua")
dofile(path .. "/decor.lua")

------------------------------------------------------------------------------
-- Ship data (rooms, lights) saved after generation
------------------------------------------------------------------------------

local ship = core.deserialize(storage:get_string("ship")) or nil

function csd_ship.set_ship_data(data)
	ship = data
	storage:set_string("ship", core.serialize(data))
	if core.get_modpath("csd_space") then
		csd_space.ship_center = data.center
	end
end

function csd_ship.get_ship_data()
	return ship
end

if ship and core.get_modpath("csd_space") then
	csd_space.ship_center = ship.center
end

-- Room lookup -----------------------------------------------------------------

local function inside(pos, minp, maxp)
	return pos.x >= minp.x - 0.5 and pos.x <= maxp.x + 0.5
		and pos.y >= minp.y - 0.5 and pos.y <= maxp.y + 1.5
		and pos.z >= minp.z - 0.5 and pos.z <= maxp.z + 0.5
end

-- The smallest room containing pos (so a cabin wins over its cabin wing).
function csd_ship.room_at(pos)
	if not ship then return nil end
	local best, best_v
	for _, r in ipairs(ship.rooms) do
		if inside(pos, r.minp, r.maxp) then
			local v = (r.maxp.x - r.minp.x + 1) * (r.maxp.z - r.minp.z + 1)
			if not best_v or v < best_v then best, best_v = r, v end
		end
	end
	return best
end

function csd_ship.deck_at(pos)
	if not ship then return nil end
	local L = csd_ship.layout
	local rel = pos.y - L.origin.y
	for deck = 1, L.decks do
		local y = L.floor_y(deck)
		if rel >= y - 1 and rel < y + 7 then return deck end
	end
	return nil
end

function csd_ship.location_label(pos)
	local r = csd_ship.room_at(pos)
	if r then
		return S("Deck @1 - @2", r.deck, r.name), r
	end
	local deck = csd_ship.deck_at(pos)
	if deck and ship and inside(pos, ship.hull_min, ship.hull_max) then
		return S("Deck @1 - Corridor", deck)
	end
	return nil
end

-- Task stations get their room from here.
if core.get_modpath("csd_tasks") then
	local old_room_name = csd_tasks.room_name
	function csd_tasks.room_name(pos)
		local label = (csd_ship.room_label or csd_ship.location_label)(pos)
		return label or old_room_name(pos)
	end
end

-- Where am I? HUD ----------------------------------------------------------------

local loc_hud = {}
local loc_text = {}

local loc_timer = 0
core.register_globalstep(function(dtime)
	loc_timer = loc_timer + dtime
	if loc_timer < 0.7 then return end
	loc_timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		local label = csd_ship.location_label(player:get_pos()) or (ship and S("Outside the @1", ship.name) or "")
		if loc_text[name] ~= label then
			loc_text[name] = label
			if loc_hud[name] then
				player:hud_change(loc_hud[name], "text", label)
			else
				loc_hud[name] = player:hud_add({
					type = "text", position = {x = 0.5, y = 0.015}, alignment = {x = 0, y = 1},
					number = 0x9fe8ff, text = label, z_index = 10, style = 1,
				})
			end
		end
	end
end)

core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	loc_hud[name], loc_text[name] = nil, nil
end)

------------------------------------------------------------------------------
-- Ship lighting: normal / alert (red) / off
------------------------------------------------------------------------------

-- Each light family has a node per mode; a light keeps its family when it swaps.
local FAMILIES = {
	{normal = "csd_ship:light", alert = "csd_ship:light_alert", off = "csd_ship:light_off"},
	{normal = "csd_ship:light_strip", alert = "csd_ship:light_strip_alert", off = "csd_ship:light_strip_off"},
}
local MODES = {normal = true, alert = true, off = true}
local family_of = {}
for _, fam in ipairs(FAMILIES) do
	for _, name in pairs(fam) do family_of[name] = fam end
end
csd_ship.light_families = family_of
csd_ship.lighting_mode = storage:get_string("lighting") ~= "" and storage:get_string("lighting") or "normal"

function csd_ship.set_lighting_mode(mode)
	if not MODES[mode] or not ship then return end
	csd_ship.lighting_mode = mode
	storage:set_string("lighting", mode)
	local by_target = {}
	for _, pos in ipairs(ship.lights) do
		local node = core.get_node_or_nil(pos)
		local fam = node and family_of[node.name]
		if fam and node.name ~= fam[mode] then
			by_target[fam[mode]] = by_target[fam[mode]] or {}
			table.insert(by_target[fam[mode]], pos)
		end
	end
	for name, list in pairs(by_target) do
		core.bulk_swap_node(list, {name = name})
	end
end

-- Blocks loaded later catch up with the current mode.
local light_nodes = {}
for name in pairs(family_of) do light_nodes[#light_nodes + 1] = name end
core.register_lbm({
	label = "Sync CSD ship lights with the lighting mode",
	name = "csd_ship:sync_lights",
	nodenames = light_nodes,
	run_at_every_load = true,
	action = function(pos, node)
		local want = family_of[node.name][csd_ship.lighting_mode]
		if node.name ~= want then
			core.swap_node(pos, {name = want, param2 = node.param2})
		end
	end,
})

------------------------------------------------------------------------------
-- Hull breach spots (csd_events)
------------------------------------------------------------------------------

function csd_ship.random_breach_spot()
	if not ship then return nil end
	local L = csd_ship.layout
	local candidates = {}
	for _, r in ipairs(ship.rooms) do
		if (r.side == "N" or r.side == "S") and r.kind ~= "lift_lobby" then
			candidates[#candidates + 1] = r
		end
	end
	if #candidates == 0 then return nil end
	for _ = 1, 10 do
		local r = candidates[math.random(#candidates)]
		local x = math.random(math.floor(r.minp.x) + 2, math.floor(r.maxp.x) - 2)
		local z = L.origin.z + (r.side == "N" and L.half_width or -L.half_width)
		local pos = vector.new(x, r.minp.y + 2, z)
		local node = core.get_node_or_nil(pos)
		if node and (node.name == "csd_ship:hull" or node.name == "csd_ship:window") then
			return {pos = pos, room = S("Deck @1 - @2", r.deck, r.name)}
		end
	end
	return nil
end

------------------------------------------------------------------------------
-- First-run generation and commands
------------------------------------------------------------------------------

local function is_csd_world()
	return core.get_game_info and core.get_game_info().id == "colony_ship_down"
end

local building = false

-- func(builder) runs after the ship is (re)built, e.g. to spawn its robots.
csd_ship.on_built = {}
function csd_ship.register_on_built(func)
	table.insert(csd_ship.on_built, func)
end

function csd_ship.generate(by)
	if building then return false end
	building = true
	core.chat_send_all(core.colorize("#9fe8ff", S("Assembling the @1... (this takes a few seconds)", csd_ship.layout.name)))
	csd_ship.build(function(b)
		building = false
		storage:set_string("generated", tostring(csd_ship.LAYOUT_VERSION))
		csd_ship.lighting_mode = "normal"
		storage:set_string("lighting", "normal")
		core.chat_send_all(core.colorize("#9fe8ff", S("The @1 is ready: @2 rooms, @3 task stations.",
			csd_ship.layout.name, #b.rooms, #b.stations)))
		for _, player in ipairs(core.get_connected_players()) do
			csd_core.send_to_spawn(player)
			if core.get_modpath("csd_tasks") then
				csd_tasks.assign_tasks(player)
			end
		end
		if by then core.log("action", "[csd_ship] ship rebuilt by " .. by) end
		for _, func in ipairs(csd_ship.on_built) do func(b) end
		-- Pre-generate the vacuum around the hull, so EVA views and the views
		-- through windows don't wait on the mapgen.
		local data = csd_ship.get_ship_data()
		local margin = vector.new(96, 48, 96)
		core.emerge_area(vector.subtract(data.hull_min, margin), vector.add(data.hull_max, margin))
	end)
	return true
end

if is_csd_world() or core.settings:get_bool("csd_ship_generate", false) then
	core.register_on_mods_loaded(function()
		core.after(1, function()
			if storage:get_string("generated") == "" then
				csd_ship.generate()
			end
		end)
	end)

	-- Hold new arrivals still until the ship exists.
	core.register_on_joinplayer(function(player)
		if storage:get_string("generated") == "" then
			player:set_physics_override({gravity = 0, speed = 0, jump = 0})
			local name = player:get_player_name()
			local function wait()
				local p = core.get_player_by_name(name)
				if not p then return end
				if storage:get_string("generated") ~= "" then
					p:set_physics_override({gravity = 1, speed = 1, jump = 1})
					csd_core.send_to_spawn(p)
				else
					p:set_breath(p:get_properties().breath_max)
					core.after(1, wait)
				end
			end
			core.after(1, wait)
		end
	end)
end

core.register_chatcommand("regenship", {
	params = "confirm",
	description = S("Rebuild the starter ship from the layout (destroys changes inside its volume)"),
	privs = {server = true},
	func = function(name, param)
		if param ~= "confirm" then
			return false, S("This overwrites the whole ship volume, including builders' changes. Type /regenship confirm")
		end
		if not csd_ship.generate(name) then
			return false, S("Already building.")
		end
		return true
	end,
})

core.register_chatcommand("shiplights", {
	params = "normal | alert | off",
	description = S("Switch the ship's lighting"),
	privs = {builder = true},
	func = function(_, param)
		if not MODES[param] then return false, S("Use normal, alert or off.") end
		csd_ship.set_lighting_mode(param)
		return true
	end,
})

core.register_chatcommand("whereami", {
	description = S("Which room you're in"),
	func = function(name)
		local player = core.get_player_by_name(name)
		if not player then return false end
		return true, csd_ship.location_label(player:get_pos()) or S("Somewhere in space.")
	end,
})

dofile(path .. "/claims.lua")
dofile(path .. "/loot.lua")
dofile(path .. "/effects.lua")
dofile(path .. "/stars.lua")
