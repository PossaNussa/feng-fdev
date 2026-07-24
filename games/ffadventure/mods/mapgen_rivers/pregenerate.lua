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

local nobj_base = PerlinNoiseMap(np_base, {x=X, y=1, z=Z})

local dem = nobj_base:get_3d_map_flat({x=0, y=0, z=0})
dem.X = X
dem.Y = Z

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
		if tectonic_step ~= 0 then
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
