-- Where the marks are.
--
-- Panels are rare, but they are not scattered.  A low-frequency noise picks
-- out the handful of regions that were ever worked; inside one, a mapchunk
-- has a decent chance of carrying a panel, and a panel is anywhere from two
-- marks to a whole gallery.  So the first one you find is never the only one.

local function num(key, default)
	return tonumber(minetest.settings:get("petroglyphs_" .. key)) or default
end

local Y_MIN          = num("y_min", -1250)
local Y_MAX          = num("y_max", 400)
-- Worked country was ~9.5% of columns at 0.62 and panels only land on exposed
-- rock, so a surface traveller crossed dozens of regions and saw nothing.
-- 0.40 opens it to ~22% of columns without losing the province clustering.
local SITE_THRESHOLD = num("site_threshold", 0.40)
-- One chunk in three inside worked country, up from one in four.
local CHUNK_CHANCE   = math.max(1, math.floor(num("chunk_chance", 3)))
local CULTURE_SIZE   = math.max(256, num("culture_size", 3000))
local ANOMALY_PCT    = num("anomaly_percent", 3)
local LOG            = minetest.settings:get_bool("petroglyphs_log", false)

-- how far a panel may spread across its wall, in nodes
local PANEL_W = 7
local PANEL_H = 5

local np_sites = {
	offset = 0,
	scale = 1,
	spread = { x = 384, y = 384, z = 384 },
	seed = 90210,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0,
}

local HDIRS = {
	{ x =  1, z =  0 },
	{ x = -1, z =  0 },
	{ x =  0, z =  1 },
	{ x =  0, z = -1 },
}

local c_air = minetest.CONTENT_AIR

local rock_of = {}   -- content id of bare rock -> index into petroglyphs.stones
local glyph_of = {}  -- [stone index][glyph number] -> content id
local site_noise

local data_buf, p2_buf = {}, {}

minetest.register_on_mods_loaded(function()
	for si, stone in ipairs(petroglyphs.stones) do
		if stone.short and minetest.registered_nodes[stone.node] then
			local list, complete = {}, true
			for i = 1, petroglyphs.glyph_count do
				local name = "petroglyphs:" .. stone.short .. "_" .. string.format("%02d", i)
				if minetest.registered_nodes[name] then
					list[i] = minetest.get_content_id(name)
				else
					complete = false
					break
				end
			end
			if complete then
				rock_of[minetest.get_content_id(stone.node)] = si
				glyph_of[si] = list
			end
		end
	end
end)

---------------------------------------------------------------------------

local culture_total = 0
for _, c in ipairs(petroglyphs.cultures) do
	culture_total = culture_total + c.weight
end

-- Weighted pick over the culture list from a roll in [0, culture_total).
local function culture_for_roll(roll)
	for _, c in ipairs(petroglyphs.cultures) do
		if roll < c.weight then
			return c
		end
		roll = roll - c.weight
	end
	return petroglyphs.cultures[1]
end

-- One culture per province, so a panel matches the panels over the next ridge.
-- Seeding PcgRandom off the province index beats any hash written here: an
-- affine mixer leaves neighbouring provinces a constant distance apart, which
-- drops them in the same weight bucket far more often than chance.
local function culture_at(x, z)
	local gx = math.floor(x / CULTURE_SIZE) + 8192
	local gz = math.floor(z / CULTURE_SIZE) + 8192
	local pr = PcgRandom(gx * 92837111 + gz * 689287499)
	return culture_for_roll(pr:next(0, culture_total - 1))
end

local function pick_glyph(pr, culture)
	if pr:next(1, 100) <= ANOMALY_PCT then
		return petroglyphs.anomalies[pr:next(1, #petroglyphs.anomalies)]
	end
	return pr:next(culture.first, culture.last)
end

local function pick_size(pr)
	local roll = pr:next(1, 100)
	if roll <= 55 then
		return pr:next(2, 4)    -- a couple of marks in passing
	elseif roll <= 88 then
		return pr:next(5, 10)   -- a worked panel
	end
	return pr:next(11, 24)      -- a gallery
end

-- Keep marks off each other so the wall reads as figures, not as a mosaic.
local function crowded(used, u, v)
	for du = -1, 1 do
		for dv = -1, 1 do
			if used[(u + du) .. "," .. (v + dv)] then
				return true
			end
		end
	end
	return false
end

---------------------------------------------------------------------------

local function place_panel(data, p2data, area, minp, maxp, pr, culture)
	local ylo = math.max(minp.y + 1, Y_MIN)
	local yhi = math.min(maxp.y - 1, Y_MAX)
	if yhi <= ylo then
		return false
	end

	-- Look for a vertical rock face with open air in front of it.  Sampling
	-- beats scanning: a mapchunk is half a million nodes and we only ever
	-- need one good wall.
	local anchor, face, si
	for _ = 1, 600 do
		local x = pr:next(minp.x + 2, maxp.x - 2)
		local y = pr:next(ylo, yhi)
		local z = pr:next(minp.z + 2, maxp.z - 2)
		if data[area:index(x, y, z)] == c_air then
			for _, d in ipairs(HDIRS) do
				local s = rock_of[data[area:index(x + d.x, y, z + d.z)]]
				-- two nodes of air out from the wall, or nobody could stand
				-- back far enough to cut it
				if s and data[area:index(x - d.x, y, z - d.z)] == c_air then
					anchor = { x = x + d.x, y = y, z = z + d.z }
					face = { x = -d.x, y = 0, z = -d.z }
					si = s
					break
				end
			end
			if anchor then
				break
			end
		end
	end
	if not anchor then
		return false
	end

	-- Slots on the same wall, in the plane the face lies in.
	local tu = (face.x ~= 0) and { x = 0, z = 1 } or { x = 1, z = 0 }
	local slots = {}
	for du = -PANEL_W, PANEL_W do
		for dv = -PANEL_H, PANEL_H do
			local px = anchor.x + tu.x * du
			local py = anchor.y + dv
			local pz = anchor.z + tu.z * du
			if px >= minp.x + 1 and px <= maxp.x - 1
					and pz >= minp.z + 1 and pz <= maxp.z - 1
					and py >= ylo and py <= yhi then
				local vi = area:index(px, py, pz)
				if rock_of[data[vi]] == si
						and data[area:index(px + face.x, py, pz + face.z)] == c_air
						and data[area:index(px + 2 * face.x, py, pz + 2 * face.z)] == c_air then
					slots[#slots + 1] = { u = du, v = dv, vi = vi }
				end
			end
		end
	end
	if #slots == 0 then
		return false
	end

	for i = #slots, 2, -1 do
		local j = pr:next(1, i)
		slots[i], slots[j] = slots[j], slots[i]
	end

	-- The front face is -Z, and 4dir points the back of the node along the
	-- given direction, so aim the back into the rock.
	local param2 = minetest.dir_to_fourdir({ x = -face.x, y = 0, z = -face.z })
	local want = pick_size(pr)
	local used, placed = {}, 0

	for _, slot in ipairs(slots) do
		if placed >= want then
			break
		end
		if not crowded(used, slot.u, slot.v) then
			used[slot.u .. "," .. slot.v] = true
			data[slot.vi] = glyph_of[si][pick_glyph(pr, culture)]
			p2data[slot.vi] = param2
			placed = placed + 1
		end
	end

	return placed > 0
end

---------------------------------------------------------------------------

minetest.register_on_generated(function(minp, maxp, blockseed)
	if maxp.y < Y_MIN or minp.y > Y_MAX then
		return
	end

	-- get_perlin was renamed in 5.12; keep working either side of that
	site_noise = site_noise
		or (minetest.get_value_noise or minetest.get_perlin)(np_sites)
	local cx = (minp.x + maxp.x) * 0.5
	local cz = (minp.z + maxp.z) * 0.5
	if site_noise:get_2d({ x = cx, y = cz }) < SITE_THRESHOLD then
		return
	end

	local pr = PcgRandom(blockseed + 71237)
	if pr:next(1, CHUNK_CHANCE) ~= 1 then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	if not vm then
		return
	end

	local data = vm:get_data(data_buf)
	local p2data = vm:get_param2_data(p2_buf)
	local area = VoxelArea:new({ MinEdge = emin, MaxEdge = emax })
	local culture = culture_at(cx, cz)

	local panels = (pr:next(1, 100) <= 25) and 2 or 1
	local wrote = 0
	for _ = 1, panels do
		if place_panel(data, p2data, area, minp, maxp, pr, culture) then
			wrote = wrote + 1
		end
	end

	if wrote > 0 then
		vm:set_data(data)
		vm:set_param2_data(p2data)
		-- rock swapped for rock: nothing about the lighting changed
		vm:write_to_map(false)
		if LOG then
			minetest.log("action", ("[petroglyphs] %d panel(s) at ~%d,%d,%d (%s)")
				:format(wrote, cx, (minp.y + maxp.y) * 0.5, cz, culture.name))
		end
	end
end)

-- Expose the lookup tables and site test so commands.lua can find and carve
-- panels the same way the mapgen does.
petroglyphs.rock_of = rock_of
petroglyphs.glyph_of = glyph_of
petroglyphs.culture_at = culture_at
petroglyphs.site_threshold = SITE_THRESHOLD
function petroglyphs.site_value(x, z)
	site_noise = site_noise
		or (minetest.get_value_noise or minetest.get_perlin)(np_sites)
	return site_noise:get_2d({ x = x, y = z })
end
