
-- this function needs to be fed house x, z dimensions and rotation
-- it will then calculate the minimum point (xbmin, avsurfy, zbmin) where the house should be spawned
-- and mark a mapchunk-sized 'house area' for terrain blending

-- re-use already created data structures by the perlin noise functions
local noise_object_blending = nil;
local noise_buffer = nil;

mg_villages.village_area_mark_single_house_area = function(village_area, minp, maxp, pos, pr, village_nr, village)

	local YFLATMIN = 2 -- Lowest flat area height
	local FFAPROP = 0.5 -- front flat area proportion of dimension
	-- Improved noise parameters for more natural, organic terrain blending
	-- Larger spread creates smoother, more gradual transitions
	-- More octaves add fine detail variation to break up artificial edges
	local np_blend = {
		offset = 0,
		scale = 1.5,  -- Increased scale for more variation
		spread = {x=24, y=24, z=24},  -- Larger spread for smoother transitions
		seed = 38393,
		octaves = 4,  -- More octaves for finer detail
		persist = 0.55  -- Lower persistence for gentler transitions
	}

	local sidelen = maxp.x - minp.x + 1
	
	local xdim, zdim -- dimensions of house plus front flat area
	if pos.brotate == 0 or pos.brotate == 2 then
		xdim = pos.bsizex
		zdim = pos.bsizez + math.floor(FFAPROP * pos.bsizez)
	else
		xdim = pos.bsizex + math.floor(FFAPROP * pos.bsizex)
		zdim = pos.bsizez
	end

	-- 2D noise perlinmap
	local chulens = {x=sidelen, y=sidelen, z=sidelen}
	local minpos = {x=minp.x, y=minp.z}

	noise_object_blending = noise_object_blending or minetest.get_perlin_map(np_blend, chulens);
	local nvals_blend = noise_object_blending:get_2d_map_flat(minpos, noise_buffer);
--	local nvals_blend = minetest.get_perlin_map(np_blend, chulens):get_2d_map_flat(minpos)

	-- mark mapchunk-sized house area
	local ni = 1
--	for z = minp.z, maxp.z do
--	for x = minp.x, maxp.x do -- for each column do
	for z = math.max( village.vz - village.vs, minp.z), math.min(village.vz + village.vs, maxp.z), 1 do
	for x = math.max( village.vx - village.vs, minp.x), math.min(village.vx + village.vs, maxp.x), 1 do -- for each column do

		local xrm = x - minp.x -- relative to mapchunk minp
		local zrm = z - minp.z
		local xr = x - village.vx -- relative to blend centre
		local zr = z - village.vz
		local xre1 = (zdim / 2) * (xr / zr)
		local zre1 = zdim / 2
		local xre2 = xdim / 2
		local zre2 = (xdim / 2) * (zr / xr)
		local rade1 = math.sqrt(xre1 ^ 2 + zre1 ^ 2)
		local rade2 = math.sqrt(xre2 ^ 2 + zre2 ^ 2)
		local flatrad = math.min(rade1, rade2) -- radius at edge of rectangular house flat area
		local n_absblend = math.abs(nvals_blend[ni])
		-- Improved blend calculations for more natural terrain transitions
		-- Use squared falloff for smoother edges that don't create obvious crater rims
		local blend_variation = n_absblend * 3  -- More variation from noise
		local blenradn = village.vs - blend_variation -- vary blend radius more
		local flatradn = flatrad + blend_variation * 0.7 -- vary shape of house flat area
		local nodrad = math.sqrt(xr ^ 2 + zr ^ 2) -- node radius

		-- only blend the terrain if it does not already belong to another village
		if( village_area[ x ][ z ][ 2 ] == 0 ) then
			if    x >= (pos.x-1) and x <= (pos.x + pos.bsizex + 1) -- area reserved for house
			  and z >= (pos.z-1) and z <= (pos.z + pos.bsizez + 1) then
				village_area[ x ][ z ] = {village_nr, 4}
			elseif nodrad <= flatradn or (xr == 0 and zr == 0) then -- irregular flat area around house
				village_area[ x ][ z ] = {village_nr, 1}
			elseif nodrad <= blenradn then -- terrain blend area
				-- Use smoothstep curve for more natural blending transitions
				-- This prevents the harsh linear edges that create obvious crater rims
				local linear_prop = ((nodrad - flatradn) / (blenradn - flatradn))
				-- Smoothstep: 3x^2 - 2x^3 creates an S-curve for smoother transitions
				local blenprop = linear_prop * linear_prop * (3 - 2 * linear_prop)
				village_area[ x ][ z ] = {village_nr, -1 * blenprop} -- terrain blending
			else -- no change to terrain
				--village_area[xrm][zrm] = {village_nr, 0}
			end
		end
		ni = ni + 1
	end
	end
end
