-- Generate the grid using terrainlib_lua
-- Only called on first mapgen, if there is no grid yet

local settings = mapgen_rivers.settings

local EvolutionModel = dofile(mapgen_rivers.modpath .. '/terrainlib_lua/erosion.lua')
local twist = dofile(mapgen_rivers.modpath .. '/terrainlib_lua/twist.lua')

local blocksize = tonumber(settings:get('blocksize'))
local tectonic_speed = tonumber(settings:get('tectonic_speed'))

local X = math.floor(tonumber(settings:get('map_x_size')) / blocksize)
local Z = math.floor(tonumber(settings:get('map_z_size')) / blocksize)

local np_base = settings:get_np_group('np_base')
np_base.spread = vector.divide(np_base.spread, blocksize)

local evol_params = {
	K = tonumber(settings:get('river_erosion_coef')),
	m = tonumber(settings:get('river_erosion_power')),
	d = tonumber(settings:get('diffusive_erosion')),
	compensation_radius = tonumber(settings:get('compensation_radius')),
}

local time = tonumber(settings:get('evol_time'))
local time_step = tonumber(settings:get('evol_time_step'))
local niter = math.ceil(time/time_step)
time_step = time / niter

local use_margin = settings:get_bool('use_margin')
local margin_width = tonumber(settings:get('margin_width')) / blocksize
local margin_elev = tonumber(settings:get('margin_elev'))

local base_from_mapgen = settings:get_bool('base_from_mapgen')
local base_detail = tonumber(settings:get('base_detail')) or 0

-- Grid node (i, j) sits at world (i*blocksize - map_offset.x, j*blocksize -
-- map_offset.z).  Must match polygons.lua, or the simulated landscape lands in
-- the wrong place relative to the terrain it was built from.
local map_offset = {x = 0, z = 0}
if settings:get_bool('center') then
	map_offset.x = blocksize * X / 2
	map_offset.z = blocksize * Z / 2
end

local function margin(dem, width, elev)
	local X, Y = dem.X, dem.Y
	for i=1, width do
		local c1 = ((i-1)/width) ^ 0.5
		local c2 = (1-c1) * elev
		local index = (i-1)*X + 1
		for x=1, X do
			dem[index] = dem[index] * c1 + c2
			index = index + 1
		end
		index = i
		for y=1, Y do
			dem[index] = dem[index] * c1 + c2
			index = index + X
		end
		index = X*(Y-i) + 1
		for x=1, X do
			dem[index] = dem[index] * c1 + c2
			index = index + 1
		end
		index = X-i + 1
		for y=1, Y do
			dem[index] = dem[index] * c1 + c2
			index = index + X
		end
	end
end

core.log("action", '[mapgen_rivers] Generating grid, this may take a while...')

if X*Z > 4e6 then
	core.log("warning", "[mapgen_rivers] You are going to generate a very large grid (>4M nodes). If you experience problems, you should increase blocksize or reduce map size.")
end

local seed = tonumber(core.get_mapgen_setting("seed"):sub(-10))
np_base.seed = (np_base.seed or 0) + seed

-- Sample the engine mapgen's own base terrain over the whole grid.
--
-- Done in horizontal strips: the field is assembled from a dozen noise maps and
-- holding twelve 4.3-million-element arrays at once would cost most of a
-- gigabyte.  A strip at a time keeps the peak in the tens of megabytes.
local function dem_from_mapgen(v7b)
	local dem = {}
	local STRIP = 64

	local detail_np
	if base_detail > 0 then
		detail_np = settings:get_np_group('np_base')
		detail_np.spread = vector.divide(detail_np.spread, blocksize)
		detail_np.scale = base_detail
		detail_np.offset = 0
		-- Same trap that aborted this on the base terrain field: dividing the
		-- spread by blocksize can push the finest octave below a spread of 1,
		-- which the engine refuses (Noise::resizeNoiseBuf, src/noise.cpp).
		-- np_base ships with 6 octaves and survives, but settingtypes.txt offers
		-- 8, and nothing stops a bigger blocksize either.  Drop octaves the grid
		-- cannot carry rather than dying at world creation.
		local lac = detail_np.lacunarity or 2.0
		while detail_np.octaves > 1
				and detail_np.spread.x / lac ^ (detail_np.octaves - 1) < 2.0 do
			detail_np.octaves = detail_np.octaves - 1
		end
	end

	local j = 0
	while j < Z do
		local rows = math.min(STRIP, Z - j)
		local strip = v7b.map(-map_offset.x, -map_offset.z + j * blocksize,
			X, rows, blocksize)
		local at = j * X

		if detail_np then
			local d = PerlinNoiseMap(detail_np, {x = X, y = rows, z = 1})
				:get_2d_map_flat({
					x = -map_offset.x / blocksize,
					y = -map_offset.z / blocksize + j,
				})
			for i = 1, X * rows do
				dem[at + i] = strip[i] + d[i]
			end
		else
			for i = 1, X * rows do
				dem[at + i] = strip[i]
			end
		end

		j = j + rows
		collectgarbage()
	end

	dem.X = X
	dem.Y = Z
	return dem
end

local v7b = core.global_exists('v7_rivers') and v7_rivers.base or nil
local from_mapgen = base_from_mapgen and v7b and v7b.available or false

local nobj_base
local dem

if from_mapgen then
	core.log('action', '[mapgen_rivers] Seeding the erosion simulation with the ' ..
		'engine mapgen base terrain.')
	dem = dem_from_mapgen(v7b)
else
	if base_from_mapgen then
		core.log('warning', '[mapgen_rivers] base_from_mapgen is set but the engine ' ..
			'base terrain is unavailable; falling back to np_base. Rivers will not ' ..
			'line up with the terrain.')
	end
	nobj_base = PerlinNoiseMap(np_base, {x=X, y=1, z=Z})
	dem = nobj_base:get_3d_map_flat({x=0, y=0, z=0})
	dem.X = X
	dem.Y = Z
end

if use_margin then
	margin(dem, margin_width, margin_elev)
end

local model = EvolutionModel(evol_params)
model.dem = dem
local ref_dem = model:define_isostasy(dem)

local tectonic_step = tectonic_speed * time_step
collectgarbage()
for i=1, niter do
	core.log("info", "[mapgen_rivers] Iteration " .. i .. " of " .. niter)

	model:diffuse(time_step)
	model:flow()
	model:erode(time_step)
	if i < niter then
		-- Tectonic forcing drifts the isostatic reference through np_base,
		-- growing new mountain ranges as the simulation runs.  It has to be
		-- off when the landscape came from the engine mapgen: the reference
		-- IS that landscape, and drifting it through unrelated noise would
		-- pull the result back off the terrain the rivers have to fit.
		-- Left alone, isostasy keeps restoring the large-scale form to the
		-- engine's own while erosion cuts valleys into it, which is exactly
		-- the landscape we are after.
		if tectonic_step ~= 0 and not from_mapgen then
			nobj_base:get_3d_map_flat({x=0, y=tectonic_step*i, z=0}, ref_dem)
			if use_margin then
				margin(ref_dem, margin_width, margin_elev)
			end
		end
		model:isostasy()
	end

	collectgarbage()
end
model:flow()

local mfloor = math.floor
local mmin, mmax = math.min, math.max
local offset_x, offset_y = twist(model.dirs, model.rivers, 5)
for i=1, X*Z do
	offset_x[i] = mmin(mmax(offset_x[i]*256, -128), 127)
	offset_y[i] = mmin(mmax(offset_y[i]*256, -128), 127)
end
collectgarbage()

-- Write the grid to files
core.mkdir(mapgen_rivers.data_path)

local schar = string.char
local unpk = unpack
local function write_file(filename, data, bytes)
	local size = #data
	local file = io.open(mapgen_rivers.data_path .. filename, 'wb')

	local bytelist = {}
	for j=1, bytes do
		bytelist[j] = 0
	end

	for i=1, size do
		local n = mfloor(data[i])
		data[i] = n
		for j=bytes, 2, -1 do
			bytelist[j] = n % 256
			n = mfloor(n / 256)
		end
		bytelist[1] = n % 256

		file:write(schar(unpk(bytelist)))
	end

	file:close()
end

write_file('dem', model.dem, 2)
write_file('lakes', model.lakes, 2)
write_file('dirs', model.dirs, 1)
write_file('rivers', model.rivers, 4)

write_file('offset_x', offset_x, 1)
write_file('offset_y', offset_y, 1)

local sfile = io.open(mapgen_rivers.data_path .. 'size', "w")
sfile:write(X..'\n'..Z)
sfile:close()

-- Record HOW this grid was made, next to the grid itself.
--
-- v7_rivers reads the difference between the engine's base terrain and this
-- eroded heightmap as the depth erosion cut, and carves that into the world as
-- valleys. That subtraction is only meaningful if the two share a vertical
-- frame, which they do only when the simulation started from that same base
-- terrain. Against a grid built from np_base the difference is hundreds of
-- nodes of nonsense.
--
-- The setting cannot answer this: mapgen_rivers writes missing settings into an
-- existing world's config with their defaults, so a world pregenerated before
-- this existed would come back claiming base_from_mapgen = true while its grid
-- says otherwise. A marker beside the data describes the data.
if from_mapgen then
	local mfile = io.open(mapgen_rivers.data_path .. 'base_from_mapgen', 'w')
	if mfile then
		mfile:write('1')
		mfile:close()
	end
end
