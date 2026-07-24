-- Transform polygon data into a heightmap

local make_polygons = dofile(mapgen_rivers.modpath .. '/polygons.lua')

local sea_level = tonumber(core.get_mapgen_setting('water_level'))
local riverbed_slope = tonumber(mapgen_rivers.settings:get('riverbed_slope')) * tonumber(mapgen_rivers.settings:get('blocksize'))

local out_elev = tonumber(mapgen_rivers.settings:get('margin_elev'))

-- Localize for performance
local floor, min, max, sqrt, abs = math.floor, math.min, math.max, math.sqrt, math.abs
local unpk = unpack

-- Geometrical helpers
local function distance_to_segment(x1, y1, x2, y2, x, y)
	-- get the distance between point (x,y) and segment (x1,y1)-(x2,y2)
	local a = (x1-x2)^2 + (y1-y2)^2 -- square of distance
	local b = (x1-x)^2 + (y1-y)^2
	local c = (x2-x)^2 + (y2-y)^2
	if a + b < c then
		-- The closest point of the segment is the extremity 1
		return sqrt(b)
	elseif a + c < b then
		-- The closest point of the segment is the extremity 2
		return sqrt(c)
	else
		-- The closest point is on the segment
		return abs(x1 * (y2-y) + x2 * (y-y1) + x * (y1-y2)) / sqrt(a)
	end
end

local function transform_quadri(X, Y, x, y)
	-- To index points in an irregular quadrilateral, giving x and y between 0 (one edge) and 1 (opposite edge)
	-- X, Y 4-vectors giving the coordinates of the 4 vertices
	-- x, y position to index.
	local x1, x2, x3, x4 = unpk(X)
	local y1, y2, y3, y4 = unpk(Y)

	-- Compare distance to 2 opposite edges, they give the X coordinate
	local d23 = distance_to_segment(x2,y2,x3,y3,x,y)
	local d41 = distance_to_segment(x4,y4,x1,y1,x,y)
	local xc = d41 / (d23+d41)

	-- Same for the 2 other edges, they give the Y coordinate
	local d12 = distance_to_segment(x1,y1,x2,y2,x,y)
	local d34 = distance_to_segment(x3,y3,x4,y4,x,y)
	local yc = d12 / (d12+d34)
	return xc, yc
end

-- Linear interpolation
local function interp(v00, v01, v11, v10, xf, zf)
	local v0 = v01*xf + v00*(1-xf)
	local v1 = v11*xf + v10*(1-xf)
	return v1*zf + v0*(1-zf)
end

local function make_heightmaps(minp, maxp)

	local polygons = make_polygons(minp, maxp)
	local incr = maxp.z-minp.z+1

	local terrain_height_map = {}
	local lake_height_map = {}
	local dpmax_map = {}

	local i = 1
	for z=minp.z, maxp.z do
		for x=minp.x, maxp.x do
			local poly = polygons[i]

			if poly then
				local xf, zf = transform_quadri(poly.x, poly.z, x, z)
				local i00, i01, i11, i10 = unpk(poly.i)

				-- Load river width on 4 edges and corners
				local r_west, r_north, r_east, r_south = unpk(poly.rivers)
				local c_NW, c_NE, c_SE, c_SW = unpk(poly.river_corners)

				-- Calculate the depth factor for each edge and corner.
				-- Depth factor:
				-- < 0: outside river
				-- = 0: on riverbank
				-- > 0: inside river
				local depth_factors = {
					r_west  -    xf , -- West edge (1)
					r_north -    zf , -- North edge (2)
					r_east  - (1-xf), -- East edge (3)
					r_south - (1-zf), -- South edge (4)
					c_NW -    xf  -    zf , -- North-West corner (5)
					c_NE - (1-xf) -    zf , -- North-East corner (6)
					c_SE - (1-xf) - (1-zf), -- South-East corner (7)
					c_SW -    xf  - (1-zf), -- South-West corner (8)
				}

				-- Find the maximal depth factor, which determines to which of the 8 river sections (4 edges + 4 corners) the current point belongs.
				-- If imax is still at 0, it means that we are not in a river.
				local dpmax = 0
				local imax = 0
				for i=1, 8 do
					if depth_factors[i] > dpmax then
						dpmax = depth_factors[i]
						imax = i
					end
				end
				-- Track unclamped max depth_factor for blend zone detection (v7_rivers)
				local raw_dpmax = depth_factors[1]
				for _i=2, 8 do
					if depth_factors[_i] > raw_dpmax then
						raw_dpmax = depth_factors[_i]
					end
				end

				-- Transform the coordinates to have xfc and zfc = 0 or 1 in rivers (to avoid rivers having lateral slope and to accomodate the riverbanks smoothly)
				local xfc, zfc
				-- xfc:
				if imax == 0 or imax == 2 or imax == 4 then -- river segment does not constrain X coordinate, so accomodate xf in function of other river sections
					local x0 =   max(r_west-dpmax, c_NW-zf-dpmax, c_SW-(1-zf)-dpmax, 0) -- new xf will be bounded to 0 by western riverbank
					local x1 = 1-max(r_east-dpmax, c_NE-zf-dpmax, c_SE-(1-zf)-dpmax, 0) -- and bounded to 1 by eastern riverbank
					if x0 >= x1 then
						xfc = 0.5
					else
						xfc = (xf-x0) / (x1-x0)
					end
				elseif imax == 1 or imax == 5 or imax == 8 then -- river at the western side of the polygon
					xfc = 0
				else -- 3, 6, 7 : river at the eastern side of the polygon
					xfc = 1
				end

				-- Same for zfc:
				if imax == 0 or imax == 1 or imax == 3 then -- river segment does not constrain Z coordinate, so accomodate zf in function of other river sections
					local z0 =   max(r_north-dpmax, c_NW-xf-dpmax, c_NE-(1-xf)-dpmax, 0) -- new zf will be bounded to 0 by northern riverbank
					local z1 = 1-max(r_south-dpmax, c_SW-xf-dpmax, c_SE-(1-xf)-dpmax, 0) -- and bounded to 1 by southern riverbank
					if z0 >= z1 then
						zfc = 0.5
					else
						zfc = (zf-z0) / (z1-z0)
					end
				elseif imax == 2 or imax == 5 or imax == 6 then -- river at the northern side of the polygon
					zfc = 0
				else -- 4, 7, 8 : river at the southern side of the polygon
					zfc = 1
				end

				-- Determine elevation by interpolation
				local vdem = poly.dem
				local terrain_height = floor(0.5+interp(
					vdem[1],
					vdem[2],
					vdem[3],
					vdem[4],
					xfc, zfc
				))

				-- Spatial gradient of the interpolation
				local slope_x = zfc*(vdem[3]-vdem[4]) + (1-zfc)*(vdem[2]-vdem[1]) < 0
				local slope_z = xfc*(vdem[3]-vdem[2]) + (1-xfc)*(vdem[4]-vdem[1]) < 0
				local lake_id = 0
				if slope_x then
					if slope_z then
						lake_id = 3
					else
						lake_id = 2
					end
				else
					if slope_z then
						lake_id = 4
					else
						lake_id = 1
					end
				end
				local lake_height = max(floor(poly.lake[lake_id]), terrain_height)

				if imax > 0 and dpmax > 0 then
					terrain_height = min(max(lake_height, sea_level) - floor(1+dpmax*riverbed_slope), terrain_height)
				end

				terrain_height_map[i] = terrain_height
				lake_height_map[i] = lake_height
				dpmax_map[i] = raw_dpmax
			else
				terrain_height_map[i] = out_elev
				lake_height_map[i] = out_elev
				dpmax_map[i] = -math.huge
			end
			i = i + 1
		end
	end

	return terrain_height_map, lake_height_map, dpmax_map
end

return make_heightmaps
