-- Dressing up the outside of the hull: stripes, the ship's name, panel
-- variation, roof beacons, radiator fins, a radar dish, antennas and a
-- sensor dome on the bow. Only plain hull (or vacuum) is ever replaced, so
-- windows are never covered.

local S = csd_ship.S

local function block(name, desc, tile, extra)
	local def = {description = desc, tiles = {tile}, groups = {cracky = 2, csd_ship = 1}, is_ground_content = false}
	for k, v in pairs(extra or {}) do def[k] = v end
	core.register_node("csd_ship:" .. name, def)
end
block("hull_dark", S("Hull Plating (Dark)"), "csd_ship_hull_dark.png")
block("hull_stripe_blue", S("Hull Stripe (Blue)"), "csd_ship_hull_stripe_blue.png")
block("hull_stripe_orange", S("Hull Stripe (Orange)"), "csd_ship_hull_stripe_orange.png")
block("hull_marking", S("Hull Marking"), "csd_ship_hull_marking.png")
block("radiator", S("Radiator Fin"), "csd_ship_radiator.png", {paramtype = "light", light_source = 3, light_colour = "#ff8040"})
block("dish", S("Dish Panel"), "csd_ship_dish.png")
block("beacon", S("Hull Beacon"), {name = "csd_ship_beacon.png",
	animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.5}},
	{paramtype = "light", light_source = 8, light_colour = "#ff3020"})
block("sensor_dome", S("Sensor Dome"), "csd_ship_sensor_dome.png",
	{drawtype = "glasslike", use_texture_alpha = "blend", paramtype = "light", light_source = 10,
	 light_colour = "#60c0ff", sunlight_propagates = true})

-- 5x5 block letters for the ship's name
local FONT = {
	A = {"01110", "10001", "11111", "10001", "10001"}, C = {"01111", "10000", "10000", "10000", "01111"},
	D = {"11110", "10001", "10001", "10001", "11110"}, E = {"11111", "10000", "11110", "10000", "11111"},
	I = {"11111", "00100", "00100", "00100", "11111"}, M = {"10001", "11011", "10101", "10001", "10001"},
	N = {"10001", "11001", "10101", "10011", "10001"}, R = {"11110", "10001", "11110", "10100", "10011"},
	S = {"01111", "10000", "01110", "00001", "11110"}, V = {"10001", "10001", "10001", "01010", "00100"},
	O = {"01110", "10001", "10001", "10001", "01110"}, L = {"10000", "10000", "10000", "10000", "11111"},
	T = {"11111", "00100", "00100", "00100", "00100"}, U = {"10001", "10001", "10001", "10001", "01110"},
	H = {"10001", "10001", "11111", "10001", "10001"}, P = {"11110", "10001", "11110", "10000", "10000"},
	G = {"01111", "10000", "10011", "10001", "01111"}, B = {"11110", "10001", "11110", "10001", "11110"},
	K = {"10001", "10010", "11100", "10010", "10001"}, W = {"10001", "10001", "10101", "11011", "10001"},
	Y = {"10001", "01010", "00100", "00100", "00100"}, F = {"11111", "10000", "11110", "10000", "10000"},
	["-"] = {"00000", "00000", "11111", "00000", "00000"},
}

-- Paint text on a flank. dir = +1 writes towards +X, -1 towards -X
-- (so it reads left-to-right for someone looking at that side).
local function paint_text(b, text, x_start, y_top, z, dir)
	-- Clear the hull ribs standing in front of the lettering.
	local x_end = x_start + (#text * 6) * dir
	local zr = z + (z > 0 and 1 or -1)
	for px = math.min(x_start, x_end) - 1, math.max(x_start, x_end) + 1 do
		for py = y_top - 6, y_top + 1 do
			if b:is(px, py, zr, "csd_ship:hull_rib") then b:set(px, py, zr, "csd_space:vacuum") end
		end
	end
	local x = x_start
	for ch in text:upper():gmatch(".") do
		local glyph = FONT[ch]
		if glyph then
			for row = 1, 5 do
				for col = 1, 5 do
					if glyph[row]:sub(col, col) == "1" then
						local px = x + (col - 1) * dir
						local py = y_top - (row - 1)
						if b:is(px, py, z, "csd_ship:hull") or b:is(px, py, z, "csd_ship:hull_dark") then
							b:set(px, py, z, "csd_ship:hull_marking")
						end
					end
				end
			end
		end
		x = x + 6 * dir
	end
end

local function replace_hull(b, x, y, z, name)
	if b:is(x, y, z, "csd_ship:hull") then b:set(x, y, z, name) end
end

local function vac(b, x, y, z)
	return b:is(x, y, z, "csd_space:vacuum")
end

function csd_ship.decorate_exterior(b)
	local G = csd_ship.geometry
	local L = csd_ship.layout
	local HW, ROOF, BOTTOM, X0, X1 = G.HW, G.ROOF, G.BOTTOM, G.X0, G.X1

	-- Panel variation: blocks of darker plating
	for x = X0, X1 do
		for y = BOTTOM, ROOF do
			local h = (math.floor(x / 4) * 73856093 + math.floor(y / 3) * 19349663) % 100
			if h < 22 then
				replace_hull(b, x, y, HW, "csd_ship:hull_dark")
				replace_hull(b, x, y, -HW, "csd_ship:hull_dark")
			end
		end
		for z = -HW, HW do
			local h = (math.floor(x / 4) * 73856093 + math.floor(z / 4) * 83492791) % 100
			if h < 18 then replace_hull(b, x, ROOF, z, "csd_ship:hull_dark") end
		end
	end

	-- Stripes: orange and blue bands down both flanks, blue on the roof
	for x = X0, X1 do
		for _, z in ipairs({HW, -HW}) do
			replace_hull(b, x, 6, z, "csd_ship:hull_stripe_orange")
			replace_hull(b, x, 7, z, "csd_ship:hull_stripe_blue")
			if b:is(x, 6, z, "csd_ship:hull_dark") then b:set(x, 6, z, "csd_ship:hull_stripe_orange") end
			if b:is(x, 7, z, "csd_ship:hull_dark") then b:set(x, 7, z, "csd_ship:hull_stripe_blue") end
		end
		for _, z in ipairs({-5, -4, 4, 5}) do
			if b:is(x, ROOF, z, "csd_ship:hull") or b:is(x, ROOF, z, "csd_ship:hull_dark") then
				b:set(x, ROOF, z, "csd_ship:hull_stripe_blue")
			end
		end
	end

	-- The ship's name on both flanks, between the deck 1 and deck 2 windows (y 20-24)
	local name = L.name
	local width = #name * 6
	paint_text(b, name, -60 + width, 24, HW, -1)   -- starboard (north) side reads towards -X
	paint_text(b, name, -60, 24, -HW, 1)           -- port (south) side reads towards +X
	paint_text(b, "COLONY SHIP", 60 + 11 * 6, 16, HW, -1)
	paint_text(b, "COLONY SHIP", 60, 16, -HW, 1)

	-- Beacons along the roof edges
	for x = X0 + 4, X1 - 4, 12 do
		if vac(b, x, ROOF + 1, HW) then b:set(x, ROOF + 1, HW, "csd_ship:beacon") end
		if vac(b, x, ROOF + 1, -HW) then b:set(x, ROOF + 1, -HW, "csd_ship:beacon") end
	end

	-- Radiator fins off both flanks, glowing faintly
	for _, xs in ipairs({-150, -90, -30, 30, 90}) do
		for x = xs, xs + 18 do
			for dz = 1, 12 do
				for _, sgn in ipairs({1, -1}) do
					local z = sgn * (HW + dz)
					if vac(b, x, 4, z) then
						b:set(x, 4, z, (x - xs) % 3 == 0 and "csd_ship:hull_rib" or "csd_ship:radiator")
					end
				end
			end
		end
	end

	-- Radar dish on the roof
	local dx, dz = 100, 0
	for y = ROOF + 1, ROOF + 5 do b:set(dx, y, dz, "csd_ship:hull_rib") end
	for r = 0, 5 do
		local y = ROOF + 5 + math.floor(r * r / 6)
		for a = 0, 359, 8 do
			local px = dx + math.floor(math.cos(math.rad(a)) * r + 0.5)
			local pz = dz + math.floor(math.sin(math.rad(a)) * r + 0.5)
			if vac(b, px, y, pz) then b:set(px, y, pz, "csd_ship:dish") end
		end
	end
	b:set(dx, ROOF + 7, dz, "csd_ship:running_red")

	-- Antenna farm
	for i, ax in ipairs({-20, -14, -8, -2, 4}) do
		local h = 4 + (i * 3) % 7
		for y = ROOF + 1, ROOF + h do
			if vac(b, ax, y, 10) then b:set(ax, y, 10, "csd_ship:hull_rib") end
		end
		b:set(ax, ROOF + h + 1, 10, "csd_ship:beacon")
	end

	-- Laser turrets: above the Weapons Bay windows (deck 1, north flank), on
	-- the bridge roof and over the stern.
	for _, tx in ipairs({-70, -55, -40, -25}) do
		if vac(b, tx, ROOF - 3, HW + 1) then csd_ship.place_turret(b, tx, ROOF - 3, HW + 1, vector.new(0, 0, 1)) end
	end
	for _, tx in ipairs({-60, -35}) do
		if vac(b, tx, ROOF - 3, -HW - 1) then csd_ship.place_turret(b, tx, ROOF - 3, -HW - 1, vector.new(0, 0, -1)) end
	end
	csd_ship.place_turret(b, L.bow.x0 + 10, ROOF + 1, 0, vector.new(0, 1, 0))
	csd_ship.place_turret(b, X0 + 6, ROOF + 1, 0, vector.new(0, 1, 0))

	-- Sensor dome on the bow
	local tip = L.bow.x1 + 1
	local cy = L.floor_y(1) - 2
	for x = tip + 1, tip + 4 do
		for y = cy - 3, cy + 3 do
			for z = -3, 3 do
				local d = math.sqrt((x - tip) ^ 2 + (y - cy) ^ 2 + z * z)
				if d <= 3.6 and vac(b, x, y, z) then b:set(x, y, z, "csd_ship:sensor_dome") end
			end
		end
	end
end
