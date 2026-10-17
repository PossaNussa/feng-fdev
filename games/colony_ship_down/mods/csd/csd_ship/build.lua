-- The starter ship generator.
--
-- Writes the whole ship with one VoxelManip (hull, decks, corridors, rooms,
-- lifts, windows, lights), then lets the room decorators (decor.lua) furnish
-- each room. Things that need their on_construct (Create machines) are set
-- afterwards with core.set_node.

local L = csd_ship.layout
local S = csd_ship.S

------------------------------------------------------------------------------
-- Builder: a VoxelManip with ship-relative coordinates
------------------------------------------------------------------------------

local Builder = {}
Builder.__index = Builder

function csd_ship.pick(...)
	for _, name in ipairs({...}) do
		if core.registered_nodes[name] then return name end
	end
	return nil
end
local pick = csd_ship.pick

local function new_builder(minp, maxp)
	local o = L.origin
	local vm = core.get_voxel_manip()
	local e1, e2 = vm:read_from_map(vector.add(o, minp), vector.add(o, maxp))
	local b = setmetatable({
		vm = vm, area = VoxelArea(e1, e2), o = o,
		data = vm:get_data(), p2 = vm:get_param2_data(),
		ids = {}, late = {}, stations = {}, metas = {}, lights = {}, rooms = {}, missing = {},
	}, Builder)
	return b
end

function Builder:id(name)
	local c = self.ids[name]
	if c then return c end
	if not core.registered_nodes[name] then
		self.missing[name] = true
		name = "csd_ship:wall"
	end
	c = core.get_content_id(name)
	self.ids[name] = c
	return c
end

function Builder:abs(x, y, z)
	return vector.new(self.o.x + x, self.o.y + y, self.o.z + z)
end

function Builder:set(x, y, z, name, p2)
	local i = self.area:index(self.o.x + x, self.o.y + y, self.o.z + z)
	self.data[i] = self:id(name)
	self.p2[i] = p2 or 0
end

function Builder:get(x, y, z)
	return self.data[self.area:index(self.o.x + x, self.o.y + y, self.o.z + z)]
end

function Builder:is(x, y, z, name)
	return self:get(x, y, z) == self:id(name)
end

function Builder:fill(x0, y0, z0, x1, y1, z1, name, p2)
	if x0 > x1 then x0, x1 = x1, x0 end
	if y0 > y1 then y0, y1 = y1, y0 end
	if z0 > z1 then z0, z1 = z1, z0 end
	local c = self:id(name)
	local data, pd, area, o = self.data, self.p2, self.area, self.o
	for z = z0, z1 do
		for y = y0, y1 do
			local i = area:index(o.x + x0, o.y + y, o.z + z)
			for _ = x0, x1 do
				data[i] = c
				pd[i] = p2 or 0
				i = i + 1
			end
		end
	end
end

function Builder:light(x, y, z, name)
	self:set(x, y, z, name or "csd_ship:light")
	self.lights[#self.lights + 1] = self:abs(x, y, z)
end

function Builder:meta(x, y, z, fields)
	self.metas[#self.metas + 1] = {pos = self:abs(x, y, z), fields = fields}
end

-- Place a task station. wall_dir points at the wall it stands against
-- (the screen faces the other way, towards the player).
function Builder:station(x, y, z, kind, wall_dir, room)
	if not core.get_modpath("csd_tasks") then return end
	local sk = csd_tasks.station_kinds[kind]
	if not sk then return end
	local p2 = wall_dir and core.dir_to_facedir(wall_dir) or 0
	if sk.node:find("^csd_create:") then
		-- Create stations put their shaft towards the given direction.
		self:late_node(x, y, z, sk.node, wall_dir and csd_create.param2_for(wall_dir) or 0)
	else
		self:set(x, y, z, sk.node, p2)
	end
	self.stations[#self.stations + 1] = {pos = self:abs(x, y, z), kind = kind, room = room, wall_dir = wall_dir}
end

-- Set after the VoxelManip is written, with on_construct (machines, shafts).
function Builder:late_node(x, y, z, name, p2, extra)
	self:set(x, y, z, "air")
	self.late[#self.late + 1] = {pos = self:abs(x, y, z), node = {name = name, param2 = p2 or 0}, extra = extra}
end

csd_ship.Builder = Builder

------------------------------------------------------------------------------
-- Geometry
------------------------------------------------------------------------------

local HW = L.half_width
local CW = L.corridor
local MAIN_X0 = L.bands[1][2] - 1        -- aft hull wall
local MAIN_X1 = L.bands[#L.bands][3] + 1 -- fore end of the main hull
local TOP = L.floor_y(1) + 6             -- deck 1 ceiling
local ROOF = TOP + 2                     -- (deck 1 has a crawlspace too)
local DH = L.deck_height
local BOTTOM = -2

local function bow_half_width(x)
	return math.max(6, math.floor(HW - (x - L.bow.x0) * 0.8))
end

-- Room record used by the decorators and by room_at().
local function add_room(b, r)
	r.h = r.h or 5          -- interior height above the floor surface (y .. y+h)
	r.back = r.back or vector.new(0, 0, r.side == "S" and -1 or 1)
	b.rooms[#b.rooms + 1] = r
	return r
end
csd_ship.add_room = add_room

-- Doorway through a wall plane at z = wz between x0..x1, centred at cx.
local function doorway(b, cx, y, wz, width)
	local w = math.floor((width or 3) / 2)
	b:fill(cx - w, y, wz, cx + w, y + 3, wz, "air")
end

-- wall_dir points from the sign to the wall it hangs on.
local function room_sign(b, x, y, z, wall_dir, name)
	if core.registered_nodes["csd_ship:sign"] then
		b:late_node(x, y, z, "csd_ship:sign", core.dir_to_wallmounted(wall_dir), function(pos)
			local meta = core.get_meta(pos)
			meta:set_string("glow", "3")
			-- signs_lib draws the raw string, so resolve the translation first
			signs_lib.update_sign(pos, {text = core.get_translated_string("en", name)})
		end)
	else
		b:set(x, y, z, "csd_ship:room_sign", core.dir_to_facedir(wall_dir))
		b:meta(x, y, z, {infotext = name})
	end
end
csd_ship.room_sign = room_sign

local function corridor(b, deck, x0, x1)
	local y = L.floor_y(deck)
	b:fill(x0, y - 1, -CW, x1, y - 1, CW, "csd_ship:floor")
	b:fill(x0, y - 1, -CW, x1, y - 1, -CW, "csd_ship:floor_hazard")
	b:fill(x0, y - 1, CW, x1, y - 1, CW, "csd_ship:floor_hazard")
	for x = x0, x1 do
		if x % 6 == 0 then b:light(x, y + 6, 0) end
		if x % 6 == 3 then
			b:light(x, y + 5, -CW, "csd_ship:light_strip")
			b:light(x, y + 5, CW, "csd_ship:light_strip")
		end
	end
end

-- Outer windows for rooms that want a view.
local function windows(b, r, step)
	local wz = r.side == "S" and -HW or HW
	for x = r.x0 + 1, r.x1 - 1 do
		if step == 1 or x % step ~= 0 then
			b:fill(x, r.y + 1, wz, x, r.y + 3, wz, "csd_ship:window")
		end
	end
end

------------------------------------------------------------------------------
-- The build
------------------------------------------------------------------------------

function csd_ship.build(done)
	-- (room for radiator fins off the flanks and the sensor dome on the bow)
	local minp = vector.new(L.engines_x[1] - 8, BOTTOM - 4, -HW - 16)
	local maxp = vector.new(L.bow.x1 + 10, ROOF + 16, HW + 16)
	local amin, amax = vector.add(L.origin, minp), vector.add(L.origin, maxp)
	core.log("action", "[csd_ship] emerging the ship volume " .. core.pos_to_string(amin) .. " - " .. core.pos_to_string(amax))
	core.emerge_area(amin, amax, function(_, _, remaining)
		if remaining > 0 then return end
		local t0 = core.get_us_time()
		local b = new_builder(minp, maxp)
		csd_ship.build_with(b)
		b.vm:set_data(b.data)
		b.vm:set_param2_data(b.p2)
		b.vm:write_to_map(true)
		csd_ship.finish_build(b)
		core.log("action", ("[csd_ship] built the %s in %.1f s: %d rooms, %d stations, %d lights"):format(
			L.name, (core.get_us_time() - t0) / 1e6, #b.rooms, #b.stations, #b.lights))
		for name in pairs(b.missing) do
			core.log("warning", "[csd_ship] node not registered, used a wall panel instead: " .. name)
		end
		if done then done(b) end
	end)
end

function csd_ship.build_with(b)
	-- 1. Hull envelope: everything inside is air, the shell is plating.
	b:fill(MAIN_X0, BOTTOM, -HW, MAIN_X1, ROOF, HW, "csd_ship:hull")
	b:fill(MAIN_X0 + 1, BOTTOM + 1, -HW + 1, MAIN_X1 - 1, ROOF - 1, HW - 1, "air")

	-- 2. Deck slabs
	for deck = 1, L.decks do
		local y = L.floor_y(deck)
		b:fill(MAIN_X0 + 1, y - 1, -HW + 1, MAIN_X1 - 1, y - 1, HW - 1, "csd_ship:floor")
		b:fill(MAIN_X0 + 1, y + 6, -HW + 1, MAIN_X1 - 1, y + 6, HW - 1, "csd_ship:ceiling")
		-- the crawlspace above the ceiling: solid duct casing, ducts carved later
		b:fill(MAIN_X0 + 1, y + 7, -HW + 1, MAIN_X1 - 1, y + DH - 2, HW - 1, "csd_ship:duct_casing")
	end

	-- 3. Bands
	for _, band in ipairs(L.bands) do
		local name, bx0, bx1, kind = band[1], band[2], band[3], band[4]
		for deck = 1, L.decks do
			local y = L.floor_y(deck)
			-- Band partition wall (corridor stays open)
			b:fill(bx0, y, -HW + 1, bx0, y + 5, HW - 1, "csd_ship:wall")
			b:fill(bx0, y, -CW, bx0, y + 4, CW, "air")
			b:fill(bx0, y + 5, -CW, bx0, y + 5, CW, "csd_ship:wall_trim")
			corridor(b, deck, bx0, bx1)
			if kind == "lift" then
				csd_ship.build_lift_band(b, deck, bx0, bx1, name)
			else
				local spec = L.decks_rooms[deck][name]
				if spec then
					csd_ship.build_band_rooms(b, deck, bx0, bx1, spec)
				end
			end
			-- a damaged hull panel somewhere along each stretch of corridor
			local hx = bx0 + 2 + ((bx0 * 7 + deck * 13) % math.max(1, bx1 - bx0 - 3))
			local hz = ((bx0 + deck) % 2 == 0) and CW or -CW
			if b:is(hx, y + 1, hz + (hz > 0 and 1 or -1), "csd_ship:wall") then
				b:station(hx, y + 1, hz, "hull_panel", vector.new(0, 0, hz > 0 and 1 or -1), S("Deck @1 - Corridor", deck))
			end
		end
	end
	csd_ship.build_reactor_space(b)

	-- 4. Bow
	csd_ship.build_bow(b)

	-- 5. Outside: ribs, engines, running lights
	csd_ship.build_exterior(b)
	csd_ship.decorate_exterior(b)

	-- 6. Furnish every room (then run the air ducts to the vents)
	for _, r in ipairs(b.rooms) do
		local deco = csd_ship.decorators[r.kind]
		if deco then deco(r, b) end
		if not r.no_lights then
			for x = r.x0 + 2, r.x1 - 1, 6 do
				for z = r.z0 + 2, r.z1 - 1, 6 do
					if b:is(x, r.y + r.h + 1, z, "csd_ship:ceiling") then
						b:light(x, r.y + r.h + 1, z)
					end
				end
			end
		end
	end
	csd_ship.build_ducts(b)
end

-- Rooms on one deck of a band.
function csd_ship.build_band_rooms(b, deck, bx0, bx1, spec)
	local y = L.floor_y(deck)
	if spec.full then
		local r = spec.full
		add_room(b, {name = r[1], kind = r[2], deck = deck, side = "full",
			x0 = bx0 + 1, x1 = bx1, z0 = -HW + 1, z1 = HW - 1, y = y, tall = r.tall})
		return
	end
	for _, side in ipairs({"N", "S"}) do
		local list = spec[side]
		if list then
			local sgn = side == "N" and 1 or -1
			local wall_z = sgn * (CW + 1)
			local z0, z1 = CW + 2, HW - 1
			if side == "S" then z0, z1 = -(HW - 1), -(CW + 2) end
			b:fill(bx0 + 1, y, wall_z, bx1, y + 5, wall_z, "csd_ship:wall")
			b:fill(bx0 + 1, y + 5, wall_z, bx1, y + 5, wall_z, "csd_ship:wall_trim")
			-- Split the side among its rooms
			local fixed, flexible = 0, 0
			for _, r in ipairs(list) do
				if r[3] then fixed = fixed + r[3] else flexible = flexible + 1 end
			end
			local total = bx1 - bx0
			local share = flexible > 0 and math.floor((total - fixed) / flexible) or 0
			local x = bx0 + 1
			for i, r in ipairs(list) do
				local len = r[3] or share
				local rx1 = (i == #list) and bx1 or (x + len - 2)
				local room = add_room(b, {name = r[1], kind = r[2], deck = deck, side = side,
					x0 = x, x1 = rx1, z0 = z0, z1 = z1, y = y, corridor_z = wall_z, zoo = r.zoo})
				if i < #list then
					b:fill(rx1 + 1, y, z0, rx1 + 1, y + 5, z1, "csd_ship:wall")
				end
				-- Doorways (the cabins decorator makes its own)
				if r[2] ~= "cabins" and not r.sealed then
					local n = (rx1 - x) > 40 and 2 or 1
					for k = 1, n do
						local cx = math.floor(x + (rx1 - x) * k / (n + 1))
						doorway(b, cx, y, wall_z, 3)
						if r[2] == "vacant" or (r.zoo and r.zoo.doors) then
							-- colonists' suites get sliding doors (lockable once claimed)
							for dx = -1, 1 do
								csd_ship.place_door(b, cx + dx, y, wall_z, false)
								b:set(cx + dx, y + 2, wall_z, "csd_ship:wall")
								b:set(cx + dx, y + 3, wall_z, "csd_ship:wall")
							end
						end
						room_sign(b, cx, y + 4, wall_z - sgn, vector.new(0, 0, sgn), room.name)
					end
				else
					room_sign(b, math.floor((x + rx1) / 2), y + 4, wall_z - sgn, vector.new(0, 0, sgn), room.name)
				end
				x = rx1 + 2
			end
		end
	end
end

-- Lift band: shaft and lobby to the north, maintenance closet to the south.
function csd_ship.build_lift_band(b, deck, bx0, bx1, band_name)
	local y = L.floor_y(deck)
	local cx = math.floor((bx0 + 1 + bx1) / 2)
	-- North: lobby with the shaft near the corridor
	local nz = CW + 1
	b:fill(bx0 + 1, y, nz, bx1, y + 5, nz, "csd_ship:wall")
	doorway(b, cx, y, nz, 5)
	add_room(b, {name = S("Lift Lobby @1", band_name:sub(2)), kind = "lift_lobby", deck = deck, side = "N",
		x0 = bx0 + 1, x1 = bx1, z0 = CW + 2, z1 = HW - 1, y = y, corridor_z = nz, lift_x = cx})
	-- Shaft: 3x3 column of lift field through every deck slab
	local top = (deck == 1) and (y + 5) or (y + DH - 1)
	local bottom = (deck == L.decks) and y or (y - 1)
	b:fill(cx - 1, bottom, CW + 3, cx + 1, top, CW + 5, "csd_ship:gravlift")
	b:fill(cx - 2, y - 1, CW + 2, cx + 2, y - 1, CW + 2, "csd_ship:floor_hazard")
	b:fill(cx - 2, y - 1, CW + 6, cx + 2, y - 1, CW + 6, "csd_ship:floor_hazard")
	room_sign(b, cx, y + 4, nz - 1, vector.new(0, 0, 1), S("Gravity Lift: jump up, sneak down"))
	-- South: maintenance closet
	local sz = -(CW + 1)
	b:fill(bx0 + 1, y, sz, bx1, y + 5, sz, "csd_ship:wall")
	doorway(b, cx, y, sz, 3)
	add_room(b, {name = S("Maintenance @1-@2", deck, band_name:sub(2)), kind = "maintenance", deck = deck, side = "S",
		x0 = bx0 + 1, x1 = bx1, z0 = -(HW - 1), z1 = -(CW + 2), y = y, corridor_z = sz})
end

-- The Reactor Room spans decks 3 and 4: open the slab between them and add
-- a catwalk at deck 3 level.
function csd_ship.build_reactor_space(b)
	local band = L.bands[1]
	local x0, x1 = band[2] + 1, band[3]
	local y3, y4 = L.floor_y(3), L.floor_y(4)
	b:fill(x0, y4 + 6, -HW + 1, x1, y3 - 1, HW - 1, "air")
	-- catwalk along the walls and across the corridor line
	b:fill(x0, y3 - 1, -HW + 1, x1, y3 - 1, -HW + 3, "csd_ship:floor_grate")
	b:fill(x0, y3 - 1, HW - 3, x1, y3 - 1, HW - 1, "csd_ship:floor_grate")
	b:fill(x1 - 3, y3 - 1, -HW + 1, x1, y3 - 1, HW - 1, "csd_ship:floor_grate")
	-- Railings on the catwalk edges (the rail sits on the side facing the drop)
	for z = -HW + 4, HW - 4 do
		b:set(x1 - 3, y3, z, "csd_ship:railing", core.dir_to_facedir(vector.new(-1, 0, 0)))
	end
	for x = x0, x1 - 4 do
		b:set(x, y3, -HW + 3, "csd_ship:railing", core.dir_to_facedir(vector.new(0, 0, 1)))
		b:set(x, y3, HW - 3, "csd_ship:railing", core.dir_to_facedir(vector.new(0, 0, -1)))
	end
	-- Lift field from the lower floor up through the catwalk
	b:fill(x1 - 2, y4, -1, x1 - 1, y3 + 1, 1, "csd_ship:gravlift")
	for z = -1, 1 do
		b:set(x1 - 3, y3, z, "air") -- no railing in front of the lift
	end
	-- The room record (deck 3 entry) covers both decks.
	for _, r in ipairs(b.rooms) do
		if r.kind == "reactor" then
			r.y = y4
			r.h = (y3 + 5) - y4
			r.catwalk_y = y3
		end
	end
end

function csd_ship.build_bow(b)
	local bow = L.bow
	local ytop = ROOF
	local ybottom = L.floor_y(bow.decks[#bow.decks]) - 2
	for x = bow.x0, bow.x1 + 1 do
		local hw = bow_half_width(x)
		local front = x == bow.x1 + 1
		b:fill(x, ybottom, -hw, x, ytop, hw, "csd_ship:hull")
		if not front then
			b:fill(x, ybottom + 1, -hw + 1, x, ytop - 1, hw - 1, "air")
			for _, deck in ipairs(bow.decks) do
				local y = L.floor_y(deck)
				b:fill(x, y - 1, -hw + 1, x, y - 1, hw - 1, "csd_ship:floor")
				b:fill(x, y + 6, -hw + 1, x, y + 6, hw - 1, "csd_ship:ceiling")
				b:fill(x, y + 7, -hw + 1, x, y + DH - 2, hw - 1, "csd_ship:duct_casing")
				-- side windows
				if x % 3 ~= 0 then
					b:fill(x, y + 1, hw, x, y + 3, hw, "csd_ship:window")
					b:fill(x, y + 1, -hw, x, y + 3, -hw, "csd_ship:window")
				end
			end
		else
			for _, deck in ipairs(bow.decks) do
				local y = L.floor_y(deck)
				b:fill(x, y, -hw + 1, x, y + 4, hw - 1, "csd_ship:window")
			end
		end
	end
	-- Open the main hull's fore wall into the bow on the bow decks
	for _, deck in ipairs(bow.decks) do
		local y = L.floor_y(deck)
		local hw = bow_half_width(bow.x0)
		b:fill(MAIN_X1, y, -hw + 1, MAIN_X1, y + 5, hw - 1, "air")
		b:fill(MAIN_X1, y - 1, -hw + 1, MAIN_X1, y - 1, hw - 1, "csd_ship:floor")
		local r = L.decks_rooms[deck].bow
		if r then
			add_room(b, {name = r[1], kind = r[2], deck = deck, side = "full", bow = true,
				x0 = MAIN_X1, x1 = bow.x1, z0 = -(bow_half_width(bow.x1) - 1), z1 = bow_half_width(bow.x1) - 1, y = y,
				hw_at = bow_half_width})
		end
	end
end

function csd_ship.build_exterior(b)
	-- Ribs every 32 nodes
	for x = MAIN_X0 + 8, MAIN_X1 - 8, 32 do
		b:fill(x, BOTTOM - 1, -HW - 1, x + 1, BOTTOM - 1, HW + 1, "csd_ship:hull_rib")
		b:fill(x, ROOF + 1, -HW - 1, x + 1, ROOF + 1, HW + 1, "csd_ship:hull_rib")
		b:fill(x, BOTTOM - 1, -HW - 1, x + 1, ROOF + 1, -HW - 1, "csd_ship:hull_rib")
		b:fill(x, BOTTOM - 1, HW + 1, x + 1, ROOF + 1, HW + 1, "csd_ship:hull_rib")
		b:set(x, ROOF + 2, 0, "csd_ship:running_red")
	end
	-- Vents along the flanks
	for x = MAIN_X0 + 4, MAIN_X1 - 4, 16 do
		b:fill(x, 2, -HW, x + 2, 3, -HW, "csd_ship:hull_vent")
		b:fill(x, 2, HW, x + 2, 3, HW, "csd_ship:hull_vent")
	end
	-- Engines: four big nozzles off the stern
	local ex0, ex1 = L.engines_x[1], L.engines_x[2]
	local lo, hi = math.floor(BOTTOM + (ROOF - BOTTOM) * 0.27), math.floor(BOTTOM + (ROOF - BOTTOM) * 0.73)
	for _, c in ipairs({{lo, -18}, {lo, 18}, {hi, -18}, {hi, 18}}) do
		local cy, cz = c[1], c[2]
		for x = ex0, ex1 do
			local r = 6 + math.floor((x - ex0) / 12)
			for dy = -r, r do
				for dz = -r, r do
					local d = math.sqrt(dy * dy + dz * dz)
					if d <= r + 0.3 then
						local inner = d < r - 1.2
						if x == ex0 and inner then
							b:set(x, cy + dy, cz + dz, "csd_ship:engine_glow")
						elseif not inner or x == ex1 then
							b:set(x, cy + dy, cz + dz, "csd_ship:engine")
						end
					end
				end
			end
		end
	end
	-- Running lights at the bow tip and the stern corners
	local tip = L.bow.x1 + 1
	local thw = bow_half_width(tip)
	b:set(tip, L.floor_y(1) + 3, thw + 1, "csd_ship:running_green")
	b:set(tip, L.floor_y(1) + 3, -thw - 1, "csd_ship:running_red")
	b:set(MAIN_X0 - 1, ROOF, HW, "csd_ship:running_green")
	b:set(MAIN_X0 - 1, ROOF, -HW, "csd_ship:running_red")
	-- Antenna mast
	b:fill(-60, ROOF + 1, 0, -60, ROOF + 12, 0, "csd_ship:hull_rib")
	b:set(-60, ROOF + 13, 0, "csd_ship:running_red")
end

csd_ship.windows = windows
csd_ship.geometry = {HW = HW, ROOF = ROOF, BOTTOM = BOTTOM, X0 = MAIN_X0, X1 = MAIN_X1,
	bow_half_width = bow_half_width}
csd_ship.doorway = doorway

------------------------------------------------------------------------------
-- After the VoxelManip is written
------------------------------------------------------------------------------

function csd_ship.finish_build(b)
	for _, m in ipairs(b.metas) do
		local meta = core.get_meta(m.pos)
		for k, v in pairs(m.fields) do meta:set_string(k, v) end
	end
	for _, l in ipairs(b.late) do
		core.set_node(l.pos, l.node)
		if l.extra then l.extra(l.pos) end
	end
	if core.get_modpath("csd_tasks") then
		csd_tasks.clear_stations()
		for _, s in ipairs(b.stations) do
			csd_tasks.add_station(s.pos, s.kind, s.room)
		end
	end
	-- Rooms are stored in absolute coordinates.
	local rooms = {}
	for _, r in ipairs(b.rooms) do
		rooms[#rooms + 1] = {
			name = r.name, deck = r.deck, kind = r.kind, side = r.side, claimable = r.claimable, zoo = r.zoo,
			minp = b:abs(r.x0, r.y, r.z0), maxp = b:abs(r.x1, r.y + r.h, r.z1),
		}
		rooms[#rooms].id = core.pos_to_string(rooms[#rooms].minp)
	end
	csd_ship.set_ship_data({
		version = csd_ship.LAYOUT_VERSION,
		name = L.name,
		rooms = rooms,
		lights = b.lights,
		center = b:abs(0, math.floor(ROOF / 2), 0),
		turrets = b.turrets or {},
		hull_min = b:abs(MAIN_X0, BOTTOM, -HW),
		hull_max = b:abs(L.bow.x1 + 1, ROOF, HW),
	})
	if b.spawn then
		csd_core.set_spawn(b.spawn)
	end
end
