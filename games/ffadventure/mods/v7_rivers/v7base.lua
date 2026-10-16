-- v7base.lua — reproduce MapgenV7's base terrain level in Lua.
--
-- This is the field v7 builds its land from BEFORE mountains, ridges, caves and
-- floatlands are laid on top: the large-scale shape of the continents.  Both
-- environments need it, for the same reason — the river heightmap and v7 are two
-- unrelated landscapes, and this is the only thing that lets them be compared or
-- reconciled:
--
--   * pregenerate.lua (main env)  seeds the erosion simulation with it, so the
--     drainage network is carved into v7's own landscape rather than into noise
--     that has nothing to do with the world the player walks on.
--   * mapgen.lua (mapgen env)     subtracts it from the eroded heightmap to
--     recover how deep erosion cut, which is the valley shape to apply to v7.
--
-- Engine reference: MapgenV7::baseTerrainLevelAtPoint / baseTerrainLevelFromMap
-- in src/mapgen/mapgen_v7.cpp, and Noise::noiseMap2D in src/noise.cpp.
--
--     hselect     = clamp(fractal(np_height_select), 0, 1)
--     persist     = fractal(np_terrain_persist)
--     height_base = fractal(np_terrain_base, persistence = persist)
--     height_alt  = fractal(np_terrain_alt,  persistence = persist)
--     level = height_alt > height_base and height_alt
--                                       or height_base*hselect + height_alt*(1-hselect)
--
-- The awkward part is that `persist` is itself a noise field, and a Lua
-- PerlinNoiseMap only takes a scalar persistence.  noiseMap2D's octave loop is
--
--     result += gmap * octave_value ; gmap *= persistence_map
--
-- i.e. result = offset + scale * SUM(persist(x,z)^i * octave_i(x,z)), so we
-- evaluate each octave as its own single-octave map and do that sum ourselves.
-- Octave i has spread/lacunarity^i and seed np.seed+i (noise.cpp:670).

local v7base = {}

local max = math.max

local TWO32 = 4294967296
local TWO31 = 2147483648

-- Wrap into the signed 32-bit range the engine does its noise seed arithmetic in.
local function s32(n)
	n = n % TWO32
	if n >= TWO31 then n = n - TWO32 end
	return n
end

-- The world seed is a u64 decimal string, well past what a Lua number can hold
-- exactly, and Mapgen truncates it to s32 anyway (Mapgen::Mapgen takes
-- (s32)params->seed).  Take the low 32 bits off the string a digit at a time so
-- nothing is ever rounded: the accumulator stays under 2^36.
local function world_seed_s32()
	local str = tostring(core.get_mapgen_setting('seed') or 0)
	local acc = 0
	for d in str:gmatch('%d') do
		acc = (acc * 10 + tonumber(d)) % TWO32
	end
	return s32(acc)
end

local function get_np(name)
	local np = core.get_mapgen_setting_noiseparams(name)
	if not np then return nil end
	np.persist = np.persist or np.persistence or 0.6
	np.lacunarity = np.lacunarity or 2.0
	np.octaves = np.octaves or 1
	return np
end

-- Split a fractal noise into one NoiseParams per octave, so we can weight the
-- octaves with a per-point persistence instead of a constant one.
local function octave_params(np, wseed)
	local out = {}
	local f = 1.0
	for i = 0, np.octaves - 1 do
		out[i + 1] = {
			offset = 0,
			scale = 1,
			spread = {
				x = np.spread.x / f,
				y = np.spread.y / f,
				z = np.spread.z / f,
			},
			seed = s32(wseed + np.seed + i),
			octaves = 1,
			persist = 1,
			lacunarity = np.lacunarity,
			flags = np.flags,
		}
		f = f * np.lacunarity
	end
	return out
end

local np_base, np_alt, np_hsel, np_pers
local oct_base, oct_alt
local wseed

v7base.available = false

if core.get_mapgen_setting('mg_name') == 'v7' then
	np_base = get_np('mgv7_np_terrain_base')
	np_alt  = get_np('mgv7_np_terrain_alt')
	np_hsel = get_np('mgv7_np_height_select')
	np_pers = get_np('mgv7_np_terrain_persist')

	if np_base and np_alt and np_hsel and np_pers then
		wseed = world_seed_s32()
		oct_base = octave_params(np_base, wseed)
		oct_alt  = octave_params(np_alt,  wseed)
		-- These two use their own scalar persistence, so a plain fractal is exact.
		np_hsel = table.copy(np_hsel); np_hsel.seed = s32(wseed + np_hsel.seed)
		np_pers = table.copy(np_pers); np_pers.seed = s32(wseed + np_pers.seed)
		v7base.available = true
	else
		-- Normal in a dimension's own mapgen environment: those run singlenode
		-- and carry no mgv7 noise parameters.  Callers must check `available`.
		core.log('info', '[v7_rivers] no mgv7 noise params in this mapgen env, ' ..
			'v7 base terrain unavailable here.')
	end
end

v7base.world_seed = wseed

local combine -- defined below, used by v7base.map

-- Cached noise objects, rebuilt whenever the requested geometry changes.
local cache_key
local nobj_hsel, nobj_pers, nobj_base, nobj_alt

-- PerlinNoiseMap has no stride, so sampling every `step` nodes is done by
-- dividing every spread by `step` and the origin with it.  noiseMap2D only ever
-- uses x/spread, so (minx/step + j) / (spread/step) == (minx + j*step) / spread:
-- exactly the same noise, read at every step'th node.
local function stretch(np, step, octaves)
	local c = table.copy(np)
	c.octaves = octaves
	if step ~= 1 then
		c.spread = {
			x = np.spread.x / step,
			y = np.spread.y / step,
			z = np.spread.z / step,
		}
	end
	return c
end

-- How many octaves of a field survive being read every `step` nodes.
--
-- Octave i has wavelength spread/lacunarity^i.  Read coarsely, the fine ones
-- alias: asking for v7's 15-node detail on a 30-node grid does not give you
-- detail, it gives you noise, and feeding that to the erosion simulation would
-- invent drainage texture the terrain does not have.  So the field is
-- band-limited to what the sampling can carry.
--
-- The engine enforces its own version of this: Noise::resizeNoiseBuf
-- (src/noise.cpp) refuses any noise whose finest octave has a spread below 1,
-- which is what used to abort pregeneration here -- height_select has 6 octaves
-- and a spread of 500, and dividing that by a 30-node step left the last octave
-- at 0.52.  Staying at or above 2*step clears that guard by construction.
local function octaves_for(np, min_feature)
	local n, w = 0, np.spread.x
	while n < np.octaves and w >= min_feature do
		n = n + 1
		w = w / np.lacunarity
	end
	return max(n, 1)
end

local function build(sx, sz, step, min_feature)
	local key = sx .. 'x' .. sz .. '@' .. step .. '/' .. min_feature
	if cache_key == key then return end
	local size = {x = sx, y = sz, z = 1}

	nobj_hsel = PerlinNoiseMap(stretch(np_hsel, step, octaves_for(np_hsel, min_feature)), size)
	nobj_pers = PerlinNoiseMap(stretch(np_pers, step, octaves_for(np_pers, min_feature)), size)

	-- base and alt are already split one map per octave (octave_params), so
	-- limiting them is just a matter of building fewer of them.
	nobj_base, nobj_alt = {}, {}
	for i = 1, octaves_for(np_base, min_feature) do
		nobj_base[i] = PerlinNoiseMap(stretch(oct_base[i], step, 1), size)
	end
	for i = 1, octaves_for(np_alt, min_feature) do
		nobj_alt[i] = PerlinNoiseMap(stretch(oct_alt[i], step, 1), size)
	end

	cache_key = key
end

-- Base terrain level over an sx x sz grid whose corner is world (minx, minz),
-- sampled every `step` nodes (default 1).  Returns a flat array indexed
-- x-fastest, matching get_2d_map_flat and the i2d walk in mapgen.lua.
--
-- `min_feature` is the finest horizontal wavelength kept, in nodes; it defaults
-- to twice the step.  A caller comparing its result against a field sampled at a
-- different step MUST pass the same min_feature that field was built with, or
-- the two will differ by whatever octaves only one of them kept.
function v7base.map(minx, minz, sx, sz, step, min_feature)
	if not v7base.available then return nil end
	step = step or 1
	min_feature = min_feature or (2 * step)
	build(sx, sz, step, min_feature)

	local pos = {x = minx / step, y = minz / step}
	local hsel = nobj_hsel:get_2d_map_flat(pos)
	local pers = nobj_pers:get_2d_map_flat(pos)
	local ob, oa = {}, {}
	for i, n in ipairs(nobj_base) do ob[i] = n:get_2d_map_flat(pos) end
	for i, n in ipairs(nobj_alt)  do oa[i] = n:get_2d_map_flat(pos) end
	return combine(hsel, pers, ob, oa, sx * sz)
end

-- Sum the octaves with the per-point persistence and apply v7's base/alt mix.
combine = function(hsel, pers, ob, oa, n)
	local o_base, s_base = np_base.offset, np_base.scale
	local o_alt,  s_alt  = np_alt.offset,  np_alt.scale
	local nb, na = #ob, #oa
	local out = {}

	for i = 1, n do
		local p = pers[i]

		local g, a = 1.0, 0.0
		for k = 1, nb do
			a = a + g * ob[k][i]
			g = g * p
		end
		local height_base = o_base + a * s_base

		g, a = 1.0, 0.0
		for k = 1, na do
			a = a + g * oa[k][i]
			g = g * p
		end
		local height_alt = o_alt + a * s_alt

		if height_alt > height_base then
			out[i] = height_alt
		else
			local h = hsel[i]
			if h < 0 then h = 0 elseif h > 1 then h = 1 end
			out[i] = height_base * h + height_alt * (1 - h)
		end
	end

	return out
end

return v7base
