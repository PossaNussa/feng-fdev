-- Room decorators: furnish each room and put its task stations in.
--
-- Each decorator gets the room record r and the builder b. Useful fields:
--   r.x0..r.x1, r.z0..r.z1  interior (inclusive), r.y floor surface, r.h height
--   r.side "N" | "S" | "full", r.back  unit vector towards the outer hull wall
-- Stations against a wall take the direction of that wall.

local S = csd_ship.S
local pick = csd_ship.pick
local Builder = csd_ship.Builder

csd_ship.decorators = {}
local D = csd_ship.decorators

local has_create = core.get_modpath("csd_create") ~= nil

-- Rows -------------------------------------------------------------------------

local function back_z(r) return r.side == "S" and r.z0 or r.z1 end
local function front_z(r) return r.side == "S" and r.z1 or r.z0 end
local function toward_back(r) return r.side == "S" and vector.new(0, 0, -1) or vector.new(0, 0, 1) end
local function toward_front(r) return vector.multiply(toward_back(r), -1) end

-- n evenly spaced integers in [a, b]
local function spread(a, b, n)
	local out = {}
	if n == 1 then return {math.floor((a + b) / 2)} end
	for i = 0, n - 1 do
		out[#out + 1] = math.floor(a + (b - a) * i / (n - 1) + 0.5)
	end
	return out
end

local function along_back(b, r, kind, n, wall_mounted, margin)
	margin = margin or 3
	for _, x in ipairs(spread(r.x0 + margin, r.x1 - margin, n)) do
		b:station(x, r.y + (wall_mounted and 1 or 0), back_z(r), kind, toward_back(r), r.name)
	end
end

local function on_side_wall(b, r, kind, which, z, wall_mounted)
	local x = which == "aft" and r.x0 or r.x1
	local dir = vector.new(which == "aft" and -1 or 1, 0, 0)
	b:station(x, r.y + (wall_mounted and 1 or 0), z, kind, dir, r.name)
end

local function wall_material(b, r, name)
	-- Re-skin the room's walls (only where there's ordinary wall panel).
	local wall = b:id("csd_ship:wall")
	for y = r.y, r.y + r.h do
		for x = r.x0 - 1, r.x1 + 1 do
			for _, z in ipairs({r.z0 - 1, r.z1 + 1}) do
				if b:get(x, y, z) == wall then b:set(x, y, z, name) end
			end
		end
		for z = r.z0, r.z1 do
			for _, x in ipairs({r.x0 - 1, r.x1 + 1}) do
				if b:get(x, y, z) == wall then b:set(x, y, z, name) end
			end
		end
	end
end

local function floor_material(b, r, name)
	b:fill(r.x0, r.y - 1, r.z0, r.x1, r.y - 1, r.z1, name)
end

local function screens(b, r, n)
	for _, x in ipairs(spread(r.x0 + 2, r.x1 - 2, n)) do
		local z = back_z(r)
		if b:get(x, r.y + 3, z) == b:id("air") then
			b:set(x, r.y + 3, z, "csd_ship:screen", core.dir_to_facedir(toward_back(r)))
		end
	end
end

local function plant(b, x, y, z)
	b:set(x, y, z, "csd_ship:plant_pot")
	b:set(x, y + 1, z, pick("scifi_nodes:plant3", "csd_ship:plant") or "csd_ship:plant")
end

local function crates(b, r, every)
	for x = r.x0 + 1, r.x1 - 1, every do
		for z = r.z0 + 1, r.z1 - 1, every do
			if math.abs(z) > 4 then
				local h = (x + z) % 3
				b:fill(x, r.y, z, x + 1, r.y + h, z + 1, "csd_ship:crate")
			end
		end
	end
end

local function benches_facing(b, r, dir, x0, x1, z0, z1, step)
	for z = z0, z1, step do
		for x = x0, x1 do
			b:set(x, r.y, z, "csd_ship:bench", core.dir_to_facedir(dir))
		end
	end
end

function Builder:machine(x, y, z, name, shaft_dir)
	if not has_create or not core.registered_nodes[name] then return end
	self:late_node(x, y, z, name, csd_create.param2_for(shaft_dir))
end

function Builder:gearbox(x, y, z)
	if not has_create then return end
	self:late_node(x, y, z, "air", 0, function(pos) csd_create.place_gearbox(pos) end)
end

function Builder:vshaft(x, y, z)
	if not has_create then return end
	self:late_node(x, y, z, "air", 0, function(pos) csd_create.place_vertical_shaft(pos) end)
end

function Builder:shaft(x, y, z, axis_dir)
	if not has_create then return end
	self:late_node(x, y, z, "air", 0, function(pos) csd_create.place_shaft(pos, axis_dir) end)
end

-- A short Create line along X: generator -> shafts -> machines.
local function machine_line(b, y, z, x0, parts)
	local x = x0
	for _, p in ipairs(parts) do
		if p == "shaft" then
			b:shaft(x, y, z, vector.new(1, 0, 0))
		else
			-- shaft_dir +X means the shaft points along the line; any X shaft connects.
			b:machine(x, y, z, p, vector.new(1, 0, 0))
		end
		x = x + 1
	end
end

-- Rooms -------------------------------------------------------------------------

D.cabins = function(r, b)
	local sgn = r.side == "S" and -1 or 1
	local wall_z = r.corridor_z
	local cabin = 8
	local x = r.x0
	local n = 0
	while x + cabin - 2 <= r.x1 do
		local cx1 = x + cabin - 2
		n = n + 1
		-- Every cabin is its own claimable room.
		csd_ship.add_room(b, {
			name = S("Cabin @1@2-@3", r.deck, r.side, ("%02d"):format(n)) .. " (" .. r.name .. ")",
			kind = "cabin", deck = r.deck, side = r.side, claimable = true, no_lights = true,
			x0 = x, x1 = cx1, z0 = r.z0, z1 = r.z1, y = r.y,
		})
		if cx1 + 1 <= r.x1 then
			b:fill(cx1 + 1, r.y, r.z0, cx1 + 1, r.y + r.h, r.z1, "csd_ship:wall")
		end
		floor_material(b, {x0 = x, x1 = cx1, z0 = r.z0, z1 = r.z1, y = r.y}, "csd_ship:floor_carpet")
		local door = x + 1
		csd_ship.doorway(b, door + 1, r.y, wall_z, 1)
		-- a sliding door, with wall above it
		csd_ship.place_door(b, door + 1, r.y, wall_z, false)
		b:set(door + 1, r.y + 2, wall_z, "csd_ship:wall")
		b:set(door + 1, r.y + 3, wall_z, "csd_ship:wall")
		local bz = back_z(r)
		b:set(x + 1, r.y, bz, "csd_ship:bunk", core.dir_to_facedir(toward_back(r)))
		b:set(x + 4, r.y, bz, "csd_ship:bunk", core.dir_to_facedir(toward_back(r)))
		b:set(cx1, r.y, bz - sgn * 3, "csd_ship:locker", core.dir_to_facedir(vector.new(1, 0, 0)))
		b:fill(x + 2, r.y + 2, back_z(r) + sgn, x + 3, r.y + 2, back_z(r) + sgn, "csd_ship:window")
		if math.floor(x / cabin) % 3 == 0 then plant(b, cx1, r.y, bz) end
		b:light(x + 3, r.y + r.h + 1, math.floor((r.z0 + r.z1) / 2))
		x = cx1 + 2
	end
	r.no_lights = true
end

D.comms = function(r, b)
	along_back(b, r, "comms_terminal", 2)
	b:station(r.x1 - 3, r.y, math.floor((r.z0 + r.z1) / 2), "comms_dish", vector.new(1, 0, 0), r.name)
	on_side_wall(b, r, "id_reader", "aft", math.floor((r.z0 + r.z1) / 2), true)
	screens(b, r, 4)
	wall_material(b, r, "csd_ship:wall_dark")
end

D.navigation = function(r, b)
	local mz = math.floor((r.z0 + r.z1) / 2)
	for _, x in ipairs(spread(r.x0 + 6, r.x1 - 6, 3)) do
		b:station(x, r.y, mz, "nav_console", toward_back(r), r.name)
	end
	along_back(b, r, "nav_upload", 1)
	screens(b, r, 6)
	wall_material(b, r, "csd_ship:wall_dark")
end

D.shields = function(r, b)
	along_back(b, r, "shield_console", 2, false, 8)
	screens(b, r, 3)
	for x = r.x0 + 1, r.x1 - 1, 4 do
		b:light(x, r.y + r.h, back_z(r), "csd_ship:light_strip")
	end
end

D.weapons = function(r, b)
	along_back(b, r, "weapons_console", 3, false, 6)
	crates(b, {x0 = r.x0, x1 = r.x0 + 10, z0 = r.z0, z1 = r.z1, y = r.y}, 4)
	screens(b, r, 3)
	csd_ship.windows(b, r, 8)
end

D.security = function(r, b)
	along_back(b, r, "id_reader", 2, true)
	on_side_wall(b, r, "wiring", "fore", math.floor((r.z0 + r.z1) / 2), true)
	screens(b, r, 8)
	benches_facing(b, r, toward_back(r), r.x0 + 4, r.x0 + 12, front_z(r) + 2 * (r.side == "S" and -1 or 1),
		front_z(r) + 2 * (r.side == "S" and -1 or 1), 1)
	-- armoury corner
	crates(b, {x0 = r.x1 - 10, x1 = r.x1, z0 = r.z0, z1 = r.z1, y = r.y}, 4)
	wall_material(b, r, "csd_ship:wall_dark")
end

D.observation = function(r, b)
	csd_ship.windows(b, r, 1)
	local mz = back_z(r) - 4 * (r.side == "S" and -1 or 1)
	for x = r.x0 + 3, r.x1 - 3 do
		if x % 7 ~= 0 then
			b:set(x, r.y, mz, "csd_ship:sofa", core.dir_to_facedir(toward_front(r)))
		else
			plant(b, x, r.y, mz)
		end
	end
	-- Skylights
	for x = r.x0 + 2, r.x1 - 2 do
		for z = r.z0 + 2, r.z1 - 2 do
			if x % 4 ~= 0 and z % 4 ~= 0 and b:is(x, r.y + r.h + 2, z, "csd_ship:hull") then
				b:set(x, r.y + r.h + 1, z, "csd_ship:window")
				b:set(x, r.y + r.h + 2, z, "csd_ship:window")
			end
		end
	end
end

D.science = function(r, b)
	along_back(b, r, "centrifuge", 3)
	local mz = math.floor((r.z0 + r.z1) / 2)
	for x = r.x0 + 4, r.x1 - 4, 6 do
		b:fill(x, r.y, mz - 1, x + 2, r.y, mz + 1, "csd_ship:table")
		b:set(x + 1, r.y + 1, mz, pick("scifi_nodes:microscope", "csd_ship:plant_pot") or "csd_ship:plant_pot")
	end
	wall_material(b, r, "csd_ship:wall_med")
end

D.lounge = function(r, b)
	local mz = math.floor((r.z0 + r.z1) / 2)
	for x = r.x0 + 3, r.x1 - 3, 7 do
		b:set(x, r.y, mz - 2, "csd_ship:sofa", core.dir_to_facedir(vector.new(0, 0, -1)))
		b:set(x + 1, r.y, mz - 2, "csd_ship:sofa", core.dir_to_facedir(vector.new(0, 0, -1)))
		b:set(x, r.y, mz, "csd_ship:table")
		b:set(x + 1, r.y, mz, "csd_ship:table")
		b:set(x, r.y, mz + 2, "csd_ship:sofa", core.dir_to_facedir(vector.new(0, 0, 1)))
		b:set(x + 1, r.y, mz + 2, "csd_ship:sofa", core.dir_to_facedir(vector.new(0, 0, 1)))
		plant(b, x + 3, r.y, mz)
	end
	local juke = pick("jukebox:box")
	if juke then b:set(r.x0 + 1, r.y, mz, juke) end
	if not r.bow then csd_ship.windows(b, r, 5) end
end

D.office = function(r, b)
	for x = r.x0 + 3, r.x1 - 3, 5 do
		b:set(x, r.y, back_z(r), "csd_ship:locker", core.dir_to_facedir(toward_back(r)))
		b:set(x + 1, r.y, back_z(r), "csd_ship:locker", core.dir_to_facedir(toward_back(r)))
	end
	along_back(b, r, "id_reader", 1, true, 10)
	screens(b, r, 4)
end

D.briefing = function(r, b)
	-- Big screen wall at the fore end, benches facing it.
	for z = -8, 8 do
		for y = r.y + 1, r.y + 4 do
			b:set(r.x1, y, z, "csd_ship:screen", core.dir_to_facedir(vector.new(1, 0, 0)))
		end
	end
	for x = r.x0 + 4, r.x1 - 6, 3 do
		benches_facing(b, r, vector.new(1, 0, 0), x, x, -12, -5, 1)
		benches_facing(b, r, vector.new(1, 0, 0), x, x, 5, 12, 1)
	end
end

D.bridge = function(r, b)
	-- Captain's chair in the middle, consoles in a horseshoe towards the windows.
	local cx = r.x0 + 12
	b:set(cx, r.y, 0, "csd_ship:sofa", core.dir_to_facedir(vector.new(-1, 0, 0)))
	b:station(cx + 6, r.y, -4, "nav_console", vector.new(1, 0, 0), r.name)
	b:station(cx + 6, r.y, 4, "nav_console", vector.new(1, 0, 0), r.name)
	b:station(cx + 9, r.y, 0, "nav_upload", vector.new(1, 0, 0), r.name)
	b:station(cx + 2, r.y, -8, "shield_console", vector.new(0, 0, -1), r.name)
	b:station(cx + 2, r.y, 8, "weapons_console", vector.new(0, 0, 1), r.name)
	b:set(cx, r.y - 1, 0, "csd_ship:floor_hazard")
	for x = r.x0, r.x1 - 1, 3 do
		b:light(x, r.y + r.h + 1, 0, "csd_ship:light_strip")
	end
end

D.medbay = function(r, b)
	wall_material(b, r, "csd_ship:wall_med")
	-- A red cross every so often along the inner wall, not on every panel.
	local wz = r.corridor_z
	for x = r.x0 + 4, r.x1 - 4, 10 do
		if b:is(x, r.y + 3, wz, "csd_ship:wall_med") then b:set(x, r.y + 3, wz, "csd_ship:wall_med_cross") end
	end
	floor_material(b, r, "csd_ship:floor_tile")
	local mz = math.floor((r.z0 + r.z1) / 2)
	b:station(r.x0 + 8, r.y, mz, "med_scanner", nil, r.name)
	b:station(r.x0 + 12, r.y, mz, "med_scanner", nil, r.name)
	for x = r.x0 + 20, r.x1 - 4, 4 do
		b:set(x, r.y, back_z(r), "csd_ship:bunk", core.dir_to_facedir(toward_back(r)))
	end
	along_back(b, r, "centrifuge", 1, false, 6)
	screens(b, r, 5)
end

D.arrivals = function(r, b)
	floor_material(b, r, "csd_ship:floor_tile")
	local mz = math.floor((r.z0 + r.z1) / 2)
	for x = r.x0 + 6, r.x1 - 6, 6 do
		benches_facing(b, r, toward_back(r), x, x + 2, mz - 2, mz - 2, 1)
		benches_facing(b, r, toward_back(r), x, x + 2, mz + 3, mz + 3, 1)
		plant(b, x + 4, r.y, mz)
	end
	screens(b, r, 8)
	csd_ship.windows(b, r, 4)
	b.spawn = b:abs(math.floor((r.x0 + r.x1) / 2), r.y, front_z(r) + (r.side == "S" and -3 or 3))
end

D.mess = function(r, b)
	floor_material(b, r, "csd_ship:floor_tile")
	for x = r.x0 + 3, r.x1 - 3, 5 do
		for z = r.z0 + 3, r.z1 - 6, 6 do
			b:fill(x, r.y, z, x + 2, r.y, z, "csd_ship:table")
			benches_facing(b, r, vector.new(0, 0, 1), x, x + 2, z - 1, z - 1, 1)
			benches_facing(b, r, vector.new(0, 0, -1), x, x + 2, z + 1, z + 1, 1)
		end
	end
	on_side_wall(b, r, "garbage_chute", "fore", back_z(r) - (r.side == "S" and -2 or 2), true)
	-- Serving counters along the aft wall (the galley stocks them)
	for z = r.z0 + 3, r.z0 + 8 do
		b:late_node(r.x0, r.y, z, "csd_ship:serving_counter", core.dir_to_facedir(vector.new(-1, 0, 0)))
	end
	csd_ship.windows(b, r, 3)
	screens(b, r, 4)
end

D.galley = function(r, b)
	along_back(b, r, "galley_station", 3, false, 4)
	on_side_wall(b, r, "garbage_chute", "aft", math.floor((r.z0 + r.z1) / 2), true)
	on_side_wall(b, r, "valve", "fore", math.floor((r.z0 + r.z1) / 2), true)
	floor_material(b, r, "csd_ship:floor_tile")
	for x = r.x0 + 4, r.x1 - 4 do
		b:set(x, r.y, math.floor((r.z0 + r.z1) / 2), "csd_ship:table")
	end
end

D.storage = function(r, b)
	crates(b, r, 4)
	on_side_wall(b, r, "air_vent", "fore", math.floor((r.z0 + r.z1) / 2), true)
end

D.recreation = function(r, b)
	local mz = math.floor((r.z0 + r.z1) / 2)
	local juke = pick("jukebox:box")
	if juke then b:set(r.x0 + 2, r.y, back_z(r), juke) end
	local dice = pick("dice2:dice_white", "dice2:dice_red")
	for x = r.x0 + 6, r.x1 - 6, 8 do
		b:fill(x, r.y, mz - 1, x + 1, r.y, mz, "csd_ship:table")
		if dice then b:set(x, r.y + 1, mz, dice) end
		b:set(x - 1, r.y, mz, "csd_ship:sofa", core.dir_to_facedir(vector.new(-1, 0, 0)))
		b:set(x + 2, r.y, mz, "csd_ship:sofa", core.dir_to_facedir(vector.new(1, 0, 0)))
		plant(b, x + 4, r.y, back_z(r))
	end
	screens(b, r, 6)
	csd_ship.windows(b, r, 6)
end

D.gym = function(r, b)
	floor_material(b, r, "csd_ship:floor_carpet")
	if has_create then
		-- A fan to jog against
		b:machine(r.x0 + 1, r.y, math.floor((r.z0 + r.z1) / 2), "csd_create:encased_fan", vector.new(-1, 0, 0))
	end
	benches_facing(b, r, toward_front(r), r.x0 + 4, r.x1 - 4, back_z(r), back_z(r), 1)
end

D.theatre = function(r, b)
	for z = -14, 14 do
		for y = r.y + 1, r.y + 5 do
			b:set(r.x1, y, z, "csd_ship:screen", core.dir_to_facedir(vector.new(1, 0, 0)))
		end
	end
	for x = r.x0 + 3, r.x1 - 8, 3 do
		for z = -16, 16 do
			if math.abs(z) > 4 then
				b:set(x, r.y, z, "csd_ship:sofa", core.dir_to_facedir(vector.new(-1, 0, 0)))
			end
		end
	end
	r.no_lights = true
	for x = r.x0 + 2, r.x1 - 2, 8 do
		b:light(x, r.y + r.h, -20, "csd_ship:light_strip")
		b:light(x, r.y + r.h, 20, "csd_ship:light_strip")
	end
end

D.reactor = function(r, b)
	local cx, cz = math.floor((r.x0 + r.x1) / 2) - 2, 0
	local top = r.y + 12
	-- Core: glowing column in a casing with viewing slots
	for y = r.y, top do
		for dx = -5, 5 do
			for dz = -5, 5 do
				local d = math.sqrt(dx * dx + dz * dz)
				if d <= 2.6 then
					b:set(cx + dx, y, cz + dz, "csd_ship:reactor_core")
				elseif d <= 4.4 then
					local slot = (y - r.y) % 4 == 2 and (dx == 0 or dz == 0)
					b:set(cx + dx, y, cz + dz, slot and "csd_ship:window" or "csd_ship:reactor_casing")
				end
			end
		end
	end
	-- The ceiling lights are two decks up: light the lower floor from the walls.
	for x = r.x0 + 2, r.x1 - 5, 5 do
		b:light(x, r.y + 3, r.z1 + 1)
		b:light(x, r.y + 3, r.z0 - 1)
	end
	for z = r.z0 + 3, r.z1 - 3, 5 do
		b:light(r.x0 - 1, r.y + 3, z)
	end
	-- ...and from lamps set into the floor.
	for x = r.x0 + 3, r.x1 - 5, 6 do
		for z = r.z0 + 3, r.z1 - 3, 6 do
			if b:is(x, r.y - 1, z, "csd_ship:floor") then
				b:light(x, r.y - 1, z)
			end
		end
	end
	-- Stabiliser pads and the lower-floor consoles
	b:station(cx, r.y, cz - 8, "reactor_stabilizer", nil, r.name)
	b:station(cx, r.y, cz + 8, "reactor_stabilizer", nil, r.name)
	b:fill(cx - 1, r.y - 1, cz - 9, cx + 1, r.y - 1, cz - 7, "csd_ship:floor_hazard")
	b:fill(cx - 1, r.y - 1, cz + 7, cx + 1, r.y - 1, cz + 9, "csd_ship:floor_hazard")
	b:station(cx - 6, r.y, r.z1, "reactor_console", vector.new(0, 0, 1), r.name)
	b:station(cx + 6, r.y, r.z1, "reactor_console", vector.new(0, 0, 1), r.name)
	-- Catwalk stations
	local cy = r.catwalk_y or r.y
	b:station(r.x0 + 6, cy, r.z1, "wiring", vector.new(0, 0, 1), r.name)
	b:station(r.x0 + 6, cy + 1, r.z0, "wiring", vector.new(0, 0, -1), r.name)
	-- Create machinery: the turbine line and a crank-charged capacitor
	machine_line(b, r.y, -20, r.x0 + 3, {
		"csd_create:turbine", "shaft", "shaft", "csd_create:flywheel", "shaft",
		"csd_create:speedometer", "csd_create:stressometer", "shaft", "shaft", "csd_create:flywheel", "shaft",
	})
	machine_line(b, r.y, 20, r.x0 + 3, {
		"csd_create:turbine", "shaft", "csd_create:flywheel", "shaft", "csd_create:speedometer",
	})
	if has_create then
		b:machine(r.x0 + 3, r.y, 26, "csd_create:hand_crank", vector.new(1, 0, 0))
		b:shaft(r.x0 + 4, r.y, 26, vector.new(1, 0, 0))
		b:shaft(r.x0 + 5, r.y, 26, vector.new(1, 0, 0))
		b:station(r.x0 + 6, r.y, 26, "capacitor", vector.new(-1, 0, 0), r.name)
	end
end

D.electrical = function(r, b)
	wall_material(b, r, "csd_ship:wall_pipes")
	along_back(b, r, "wiring", 2, true, 5)
	b:station(math.floor((r.x0 + r.x1) / 2), r.y + 1, back_z(r), "breaker_panel", toward_back(r), r.name)
	if has_create then
		local z = front_z(r) + (r.side == "S" and -3 or 3)
		b:machine(r.x0 + 3, r.y, z, "csd_create:hand_crank", vector.new(1, 0, 0))
		b:shaft(r.x0 + 4, r.y, z, vector.new(1, 0, 0))
		b:machine(r.x0 + 5, r.y, z, "csd_create:speedometer", vector.new(1, 0, 0))
		b:shaft(r.x0 + 6, r.y, z, vector.new(1, 0, 0))
		b:station(r.x0 + 7, r.y, z, "capacitor", vector.new(-1, 0, 0), r.name)
	end
end

D.life_support = function(r, b)
	wall_material(b, r, "csd_ship:wall_pipes")
	along_back(b, r, "o2_filter", 2, true, 6)
	b:station(math.floor((r.x0 + r.x1) / 2), r.y + 1, back_z(r), "o2_panel", toward_back(r), r.name)
	on_side_wall(b, r, "air_vent", "aft", math.floor((r.z0 + r.z1) / 2), true)
	on_side_wall(b, r, "valve", "fore", math.floor((r.z0 + r.z1) / 2), true)
	-- Air handlers: a turbine drives a shaft line; gearboxes turn the drive
	-- upwards into encased fans that blow into ceiling vents.
	if has_create then
		local z = math.floor((r.z0 + r.z1) / 2)
		local x = r.x0 + 4
		b:machine(x, r.y, z, "csd_create:turbine", vector.new(1, 0, 0))
		for dx = 1, 20 do
			local px = x + dx
			if dx % 7 == 6 then
				b:gearbox(px, r.y, z)
				b:vshaft(px, r.y + 1, z)
				b:vshaft(px, r.y + 2, z)
				b:machine(px, r.y + 3, z, "csd_create:encased_fan", vector.new(0, -1, 0))
				b:set(px, r.y + r.h + 1, z, "csd_ship:hull_vent")
			else
				b:shaft(px, r.y, z, vector.new(1, 0, 0))
			end
		end
	end
end

D.hydroponics = function(r, b)
	wall_material(b, r, "csd_ship:wall_hydro")
	floor_material(b, r, "csd_ship:floor_grate")
	for x = r.x0 + 4, r.x1 - 4, 5 do
		for z = r.z0 + 3, r.z1 - 3, 6 do
			b:station(x, r.y, z, "planter", nil, r.name)
			b:set(x + 1, r.y, z, "csd_ship:plant_pot")
			b:set(x + 1, r.y + 1, z, "csd_ship:plant")
		end
	end
	b:station(r.x1 - 2, r.y + 1, back_z(r), "o2_panel", toward_back(r), r.name)
	on_side_wall(b, r, "valve", "aft", math.floor((r.z0 + r.z1) / 2), true)
	for _, x in ipairs({r.x0 + 2, r.x0 + 30, r.x1 - 6}) do
		b:set(x, r.y + 1, back_z(r), "csd_ship:water_tap", core.dir_to_facedir(toward_back(r)))
	end
	-- Irrigation: a turbine line along the front, gearboxes lifting the drive
	-- to sprinklers that spray the planters.
	if has_create then
		local z = front_z(r) + (r.side == "S" and -1 or 1)
		local x = r.x0 + 2
		b:machine(x, r.y, z, "csd_create:turbine", vector.new(1, 0, 0))
		for dx = 1, 40 do
			if dx % 10 == 9 then
				b:gearbox(x + dx, r.y, z)
				b:vshaft(x + dx, r.y + 1, z)
				b:machine(x + dx, r.y + 2, z, "csd_create:sprinkler", vector.new(0, -1, 0))
			else
				b:shaft(x + dx, r.y, z, vector.new(1, 0, 0))
			end
		end
	end
	for x = r.x0 + 1, r.x1 - 1, 3 do
		b:light(x, r.y + r.h, back_z(r), "csd_ship:light_strip")
	end
end

D.water = function(r, b)
	wall_material(b, r, "csd_ship:wall_pipes")
	for x = r.x0 + 4, r.x1 - 4, 7 do
		b:fill(x, r.y, back_z(r) - (r.side == "S" and -1 or 1) * 4, x + 2, r.y + 3, back_z(r) - (r.side == "S" and -1 or 1) * 2, "csd_ship:reactor_casing")
	end
	along_back(b, r, "air_vent", 1, true, 10)
	on_side_wall(b, r, "wiring", "fore", math.floor((r.z0 + r.z1) / 2), true)
	on_side_wall(b, r, "valve", "aft", math.floor((r.z0 + r.z1) / 2) + 3, true)
	-- Pump line: a turbine driving pumps (they speed up draining after a burst)
	if has_create then
		local z = front_z(r) + (r.side == "S" and -2 or 2)
		machine_line(b, r.y, z, r.x0 + 3, {"csd_create:turbine", "shaft", "csd_create:mechanical_pump", "shaft",
			"csd_create:mechanical_pump", "shaft", "csd_create:speedometer", "shaft", "csd_create:mechanical_pump"})
	end
end

D.cryo = function(r, b)
	-- Upright pods: a row along the outer wall facing in, and back-to-back
	-- rows down the middle, with aisles between.
	local sgn = r.side == "S" and -1 or 1
	local bz = back_z(r)
	local mid = math.floor((r.z0 + r.z1) / 2)
	for x = r.x0 + 1, r.x1 - 1 do
		if x % 2 == 0 then
			csd_ship.place_cryopod(b, x, r.y, bz, toward_front(r))
			if math.abs(x - math.floor((r.x0 + r.x1) / 2)) > 2 then -- leave a cross aisle
				csd_ship.place_cryopod(b, x, r.y, mid, toward_front(r))
				csd_ship.place_cryopod(b, x, r.y, mid + sgn, toward_back(r))
			end
		end
	end
	screens(b, r, 5)
	r.no_lights = true
	for x = r.x0 + 1, r.x1 - 1, 4 do
		b:light(x, r.y + r.h + 1, mid - sgn * 4, "csd_ship:light_strip")
		b:light(x, r.y + r.h + 1, mid + sgn * 6, "csd_ship:light_strip")
	end
end

D.shuttle = function(r, b)
	-- Bay doors on the north hull, held by a forcefield
	b:fill(r.x0 + 6, r.y, 36, r.x1 - 6, r.y + 4, 36, "csd_ship:forcefield")
	floor_material(b, r, "csd_ship:floor_hazard")
	-- A little shuttle
	local sx, sz = math.floor((r.x0 + r.x1) / 2), 18
	b:fill(sx - 5, r.y, sz - 3, sx + 5, r.y + 3, sz + 3, "csd_ship:hull")
	b:fill(sx - 4, r.y + 1, sz - 2, sx + 4, r.y + 2, sz + 2, "air")
	b:fill(sx + 5, r.y + 1, sz - 2, sx + 5, r.y + 2, sz + 2, "csd_ship:window")
	b:fill(sx - 1, r.y, sz - 3, sx + 1, r.y + 2, sz - 3, "air")
	b:set(sx - 5, r.y + 1, sz, "csd_ship:engine_glow")
	b:station(r.x0 + 3, r.y, -20, "fuel_pump", vector.new(-1, 0, 0), r.name)
	-- EVA prep: a row of suit lockers along the aft wall, facing the bay doors.
	if core.registered_nodes["csd_eva:suit_locker"] then
		for z = 8, 30, 2 do
			b:set(r.x0, r.y, z, "csd_eva:suit_locker", core.dir_to_facedir(vector.new(-1, 0, 0)))
		end
		csd_ship.room_sign(b, r.x0, r.y + 3, 6, vector.new(-1, 0, 0), S("EVA Prep: suits here"))
		r.name = S("Shuttle & EVA Bay")
	end
end

D.engine_control = function(r, b)
	on_side_wall(b, r, "engine_port", "aft", math.floor((r.z0 + r.z1) / 2) - 4, true)
	on_side_wall(b, r, "engine_port", "aft", math.floor((r.z0 + r.z1) / 2) + 4, true)
	along_back(b, r, "wiring", 1, true, 8)
	screens(b, r, 6)
	wall_material(b, r, "csd_ship:wall_dark")
end

D.fuel = function(r, b)
	along_back(b, r, "fuel_pump", 2, false, 8)
	floor_material(b, r, "csd_ship:floor_hazard")
	crates(b, {x0 = r.x0 + 20, x1 = r.x1, z0 = r.z0, z1 = r.z1, y = r.y}, 4)
end

D.cargo = function(r, b)
	crates(b, r, 5)
	b:station(r.x0 + 1, r.y + 1, r.z1 - 6, "air_vent", vector.new(-1, 0, 0), r.name)
	b:station(r.x1, r.y + 1, r.z0 + 6, "garbage_chute", vector.new(1, 0, 0), r.name)
end

D.waste = function(r, b)
	along_back(b, r, "garbage_chute", 2, true, 6)
	on_side_wall(b, r, "air_vent", "aft", math.floor((r.z0 + r.z1) / 2), true)
	wall_material(b, r, "csd_ship:wall_pipes")
	floor_material(b, r, "csd_ship:floor_grate")
end

D.workshop = function(r, b)
	-- Machine Shop: a working press line and a fan tunnel, Create-style.
	floor_material(b, r, "csd_ship:floor_grate")
	if not has_create then return end
	-- Crank line on a row of crates, driving a press over a depot.
	local z = back_z(r) - (r.side == "S" and -2 or 2)
	local y = r.y + 1
	b:fill(r.x0 + 2, r.y, z, r.x0 + 6, r.y, z, "csd_ship:crate")
	b:machine(r.x0 + 2, y, z, "csd_create:hand_crank", vector.new(1, 0, 0))
	b:shaft(r.x0 + 3, y, z, vector.new(1, 0, 0))
	b:shaft(r.x0 + 4, y, z, vector.new(1, 0, 0))
	b:machine(r.x0 + 5, y, z, "csd_create:speedometer", vector.new(1, 0, 0))
	b:shaft(r.x0 + 6, y, z, vector.new(1, 0, 0))
	b:machine(r.x0 + 7, y, z, "csd_create:mechanical_press", vector.new(1, 0, 0))
	b:late_node(r.x0 + 7, r.y, z, "csd_create:depot")
	-- Turbine-driven second line with a fan blowing down the room
	local z2 = z - (r.side == "S" and -4 or 4)
	machine_line(b, r.y, z2, r.x0 + 2, {"csd_create:turbine", "shaft", "csd_create:stressometer", "shaft", "csd_create:flywheel", "shaft"})
	b:machine(r.x0 + 8, r.y, z2, "csd_create:encased_fan", vector.new(-1, 0, 0))
	for x = r.x0 + 12, r.x1 - 2, 6 do
		b:late_node(x, r.y, front_z(r) + (r.side == "S" and -1 or 1), "csd_create:depot")
	end
end

D.lift_lobby = function(r, b)
	b:station(r.x0, r.y + 1, back_z(r) - (r.side == "S" and -2 or 2), "air_vent", vector.new(-1, 0, 0), r.name)
	plant(b, r.x1 - 1, r.y, back_z(r))
end

D.maintenance = function(r, b)
	wall_material(b, r, "csd_ship:wall_pipes")
	local which = math.floor(r.x0 / 7) % 3
	local kinds = {"wiring", "air_vent", "garbage_chute"}
	b:station(math.floor((r.x0 + r.x1) / 2), r.y + 1, back_z(r), kinds[which + 1], toward_back(r), r.name)
	crates(b, {x0 = r.x0, x1 = r.x1, z0 = r.z0 + 2, z1 = r.z1 - 8, y = r.y}, 4)
end

-- Empty rooms for colonists to claim and make their own (/claim).
D.vacant = function(r, b)
	r.claimable = true
	floor_material(b, r, "csd_ship:floor_carpet")
	if not r.bow and r.side ~= "full" then csd_ship.windows(b, r, 4) end
	b:station(r.x0, r.y + 1, math.floor((r.z0 + r.z1) / 2), "air_vent", vector.new(-1, 0, 0), r.name)
end
