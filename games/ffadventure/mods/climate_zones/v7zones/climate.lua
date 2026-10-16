-- climate_zones_v7/climate.lua
-- Zone climate shared by the main env (biome painting + runtime overrides)
-- and the mapgen env (v7_rivers water tint). The world is split into Voronoi
-- cells of roughly zone_size nodes; each cell gets a single heat/humidity
-- pair, so a whole zone resolves to one biome (rare biomes stay full-sized).
-- Heat follows latitude: 100 at climate_v7_equator_z, 0 at climate_v7_pole_z,
-- plus a seeded per-zone jitter; humidity is a seeded regional noise sampled
-- once per zone.

local S = core.settings

local ZONE    = tonumber(S:get("climate_v7_zone_size")) or 384
local BLEND   = tonumber(S:get("climate_v7_border_blend")) or 12
-- The full map is 62000 nodes across, and heat clamps to 0..100, so an equator
-- and pole closer together than the map leave everything beyond them pinned
-- flat with no gradient. These span it.
local EQUATOR = tonumber(S:get("climate_v7_equator_z")) or -31000
local POLE    = tonumber(S:get("climate_v7_pole_z")) or 31000
local JITTER  = tonumber(S:get("climate_v7_heat_jitter")) or 14
local LAPSE   = tonumber(S:get("climate_v7_altitude_chill")) or 0.08

local WATER_LEVEL = tonumber(core.get_mapgen_setting("water_level")) or 1

-- One sample per zone. A spread of a few zones makes neighbouring zones'
-- values correlate into wet belts and warm/cool anomaly regions rather than
-- pure per-zone dice rolls.
local np_jitter = {
	offset = 0, scale = 1, seed = 8871, octaves = 1,
	spread = {x = ZONE * 3, y = ZONE * 3, z = ZONE * 3},
}
local np_humid = {
	offset = 0, scale = 1, seed = 5227, octaves = 1,
	spread = {x = ZONE * 2.5, y = ZONE * 2.5, z = ZONE * 2.5},
}

local floor, max = math.floor, math.max

local function clamp(v, lo, hi)
	if v < lo then return lo elseif v > hi then return hi end
	return v
end

-- white-noise hash, same as the standalone climate_zones mapgen
local function n22(x, y)
	local ax = x * 534.709
	local ay = y * 7123.5381
	local az = x * 6783.52711
	ax = ax - floor(ax)
	ay = ay - floor(ay)
	az = az - floor(az)
	local dot = (ax * ax + ay * ay + az * az) * 350.648391
	ax = ax + dot
	ay = ay + dot
	az = az + dot
	x = ax * ay
	y = ay * az
	return x - floor(x), y - floor(y)
end

local nobj_jitter, nobj_humid
local cell_cache, cache_count = {}, 0

local function zone_climate(cx, cz)
	local key = cx .. ":" .. cz
	local c = cell_cache[key]
	if c then
		return c
	end
	-- lazy: noise objects need the world seed, unavailable at load time
	nobj_jitter = nobj_jitter or core.get_value_noise(np_jitter)
	nobj_humid = nobj_humid or core.get_value_noise(np_humid)
	local dx, dz = n22(cx, cz)
	local px = (cx + dx) * ZONE
	local pz = (cz + dz) * ZONE
	local lat_heat = 100 * (POLE - pz) / (POLE - EQUATOR)
	c = {
		heat = clamp(lat_heat + nobj_jitter:get_2d({x = px, y = pz}) * JITTER, 0, 100),
		humid = clamp(nobj_humid:get_2d({x = px, y = pz}) * 55 + 50, 0, 100),
	}
	if cache_count >= 4096 then
		cell_cache, cache_count = {}, 0
	end
	cell_cache[key] = c
	cache_count = cache_count + 1
	return c
end

local function zone_at(x, z)
	-- per-node warp turns clean voronoi edges into ragged dither bands
	local wx, wz = n22(x, z)
	x = (x + (wx - 0.5) * 2 * BLEND) / ZONE
	z = (z + (wz - 0.5) * 2 * BLEND) / ZONE
	local ix, iz = floor(x), floor(z)
	local fx, fz = x - ix, z - iz
	local best, bx, bz = math.huge, ix, iz
	for oz = -1, 1 do
		for ox = -1, 1 do
			local cx, cz = ix + ox, iz + oz
			local dx, dz = n22(cx, cz)
			local ddx = dx + ox - fx
			local ddz = dz + oz - fz
			local d = ddx * ddx + ddz * ddz
			if d < best then
				best, bx, bz = d, cx, cz
			end
		end
	end
	return bx, bz
end

local M = {
	LAPSE = LAPSE,
	WATER_LEVEL = WATER_LEVEL,
	EQUATOR = EQUATOR,
	POLE = POLE,
}

-- sea-level heat/humidity of the zone covering (x, z)
function M.climate_at(x, z)
	return zone_climate(zone_at(x, z))
end

--- Where a position sits on the climate axis: 0 at the equator, 1 at the pole.
--
-- This is the honest latitude, which local biome heat is not: heat also carries
-- altitude chill and per-zone jitter, so a mountain in the tropics reads as
-- cold as the arctic. Anything that wants to know "how far from the equator am
-- I" -- seasonal amplitude, above all -- wants this and not heat.
--
-- Clamped, so the flat regions beyond either endpoint report exactly 0 or 1
-- rather than running past them. Deliberately ignores x and y.
function M.latitude_at(pos)
	return clamp((pos.z - EQUATOR) / (POLE - EQUATOR), 0, 1)
end

-- drop-in for core.get_heat: zone heat with altitude chill
function M.get_heat(pos)
	local c = zone_climate(zone_at(pos.x, pos.z))
	return c.heat - max(pos.y - WATER_LEVEL, 0) * LAPSE
end

-- drop-in for core.get_humidity
function M.get_humidity(pos)
	local c = zone_climate(zone_at(pos.x, pos.z))
	return c.humid
end

-- Flat per-column maps for biomegen.generate_biomes. biomegen subtracts
-- max(pos.y, water_level) * lapse_rate itself, so bake in the water_level
-- offset to make sea-level heat come out as the zone heat.
function M.make_maps(minp, maxp)
	local heatmap, humidmap = {}, {}
	local off = WATER_LEVEL * LAPSE
	local i = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local c = zone_climate(zone_at(x, z))
			heatmap[i] = c.heat + off
			humidmap[i] = c.humid
			i = i + 1
		end
	end
	return heatmap, humidmap
end

return M
