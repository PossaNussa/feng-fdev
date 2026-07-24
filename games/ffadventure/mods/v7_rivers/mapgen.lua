-- v7_rivers/mapgen.lua
-- Runs as a mapgen script (emerge thread). Modifies the mapgen VM directly.
--
-- Design: mapgen_rivers' pregenerated DEM decides WHERE rivers run, how wide,
-- and roughly how high the water sits (lake_map, descending downstream).  v7
-- owns everything else — crucially, v7 owns the ocean and the coastline.
--
-- Rivers are carved ONLY into genuine v7 land (ground surface above sea level),
-- and the water surface is clamped to never rise above that ground.  So a river
-- can never perch on a hillside and spill, and can never build up over the sea.
-- Where the DEM river sits below the v7 surface we cut a gorge down to it; where
-- it would sit above the surface we simply keep it at ground level.  This is
-- purely a downward carve + water fill — no levees, no raised banks.

-- Max stone layers placed below the riverbed to seal caves/depressions.
local SEAL_DEPTH = 12
-- Chunks entirely above/below any possible river elevation are skipped outright.
local Y_SKIP_ABOVE = 600

-- Check river data exists
local size_f = io.open(core.get_worldpath() .. '/river_data/size', 'r')
if not size_f then
	core.log('error', '[v7_rivers] No river data found, rivers disabled.')
	return
end
size_f:close()

local make_heightmaps
local c_air, c_rwater, c_ignore, c_stone, c_sand
local surf_skip_ids -- decorations + liquids: skipped when scanning for real ground

local ok, err = pcall(function()
	if not core.global_exists('mapgen_rivers') then
		rawset(_G, 'mapgen_rivers', {
			modpath   = core.get_modpath('mapgen_rivers') .. '/',
			data_path = core.get_worldpath() .. '/river_data/',
			settings  = Settings(core.get_worldpath() .. '/mapgen_rivers.conf'),
			thread    = 'mapgen',
		})
	end

	mapgen_rivers.np_heat = core.get_mapgen_setting_noiseparams('mg_biome_np_heat')
	local sea_level = tonumber(core.get_mapgen_setting('water_level')) or 1
	local ec = tonumber(mapgen_rivers.settings:get('elevation_chill')) or 0.25
	if mapgen_rivers.np_heat then
		mapgen_rivers.np_heat.offset = mapgen_rivers.np_heat.offset + sea_level * ec
	end

	mapgen_rivers.grid = dofile(mapgen_rivers.modpath .. 'grid_load.lua')
	make_heightmaps = dofile(mapgen_rivers.modpath .. 'heightmap.lua')

	c_air    = core.get_content_id('air')
	c_rwater = core.get_content_id('default:river_water_source')
	c_ignore = core.get_content_id('ignore')
	c_stone  = core.get_content_id('default:stone')
	c_sand   = core.get_content_id('default:sand')

	-- Surface scan must see past decorations AND existing liquid, so that an
	-- ocean column reads its seabed (below sea level) rather than the water top.
	surf_skip_ids = {}
	-- Extra groups for mods that don't use standard tree/leaves:
	-- 'leafdecay'   - aotearoa fruit; 'winleafdecay' - livingjungle liana;
	-- 'carpet'      - mahogany creepers.
	local skip_groups = {"leaves", "tree", "sapling", "grass", "flower",
	                     "mushroom", "coral", "seagrass", "bamboo",
	                     "leafdecay", "winleafdecay", "carpet"}
	for name, def in pairs(core.registered_nodes) do
		local id = core.get_content_id(name)
		if def.groups then
			for _, g in ipairs(skip_groups) do
				if def.groups[g] then surf_skip_ids[id] = true; break end
			end
		end
		if def.drawtype == "airlike" then
			surf_skip_ids[id] = true
		end
		if def.liquidtype and def.liquidtype ~= "none" then
			surf_skip_ids[id] = true
		end
	end
	local cc_id = core.get_content_id("cloudcraft:cloud")
	if cc_id then surf_skip_ids[cc_id] = true end

	core.log('action', '[v7_rivers] Mapgen script ready.')
end)

if not ok then
	core.log('error', '[v7_rivers] Init FAILED: ' .. tostring(err))
	return
end

-- Biome-tinted water: same palette encoding as always_greener/scripts/water.lua
-- (16x16 humidity x heat grid, index = hum_bucket * 16 + heat_bucket).
local function water_colour(x, y, z)
	local pos = {x = x, y = y, z = z}
	local heat = core.get_heat(pos) or 50
	local hum  = core.get_humidity(pos) or 50
	if heat < 0 then heat = 0 elseif heat > 100 then heat = 100 end
	if hum  < 0 then hum  = 0 elseif hum  > 100 then hum  = 100 end
	local heat_s = math.min(15, math.floor(heat * 0.16))
	local hum_s  = math.min(15, math.floor(hum  * 0.16))
	return hum_s * 16 + heat_s
end

local floor, min, max = math.floor, math.min, math.max

core.register_on_generated(function(vm, minp, maxp, seed)
	if not make_heightmaps then return end

	local sea_level = tonumber(core.get_mapgen_setting('water_level')) or 1
	if minp.y > Y_SKIP_ABOVE or maxp.y < sea_level - (SEAL_DEPTH + 48) then
		return
	end

	local ok2, err2 = pcall(function()
		local terrain_map, lake_map, dpmax_map = make_heightmaps(minp, maxp)

		local emin, emax = vm:get_emerged_area()
		local data = vm:get_data()
		local p2data = vm:get_param2_data()
		local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local ystride = area.ystride

		local width = maxp.x - minp.x + 1
		local miny, maxy = minp.y, maxp.y
		local modified = false
		local p2_modified = false

		local i2d = 1
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local dpmax = dpmax_map[i2d]
				local W = lake_map[i2d] -- DEM water surface

				-- Only real rivers (dpmax > 0) on land above the sea.
				if dpmax > 0 and W > sea_level then
					local vi0 = area:index(x, miny, z)

					-- Find the real v7 ground surface (skip air/ignore, deco and
					-- liquid).  Over ocean this returns the seabed, below sea
					-- level, so the column is left untouched.  If no ground is
					-- found in this chunk (sky/deep chunk), also skip.
					local vsurf = miny - 1
					local vi = vi0 + (maxy - miny) * ystride
					for y = maxy, miny, -1 do
						local n = data[vi]
						if n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then
							vsurf = y
							break
						end
						vi = vi - ystride
					end

					if vsurf >= miny and vsurf > sea_level then
						-- Water never rises above the ground: no perching, no
						-- floating over the sea.  Below-ground DEM river = gorge;
						-- above-ground DEM river = kept at ground level.
						local water_top = min(W, vsurf)

						-- Gorge: clear terrain above the waterline (trees go too).
						local y0 = max(water_top + 1, miny)
						if y0 <= maxy then
							vi = vi0 + (y0 - miny) * ystride
							for _ = y0, maxy do
								local n = data[vi]
								if n ~= c_air and n ~= c_ignore then
									data[vi] = c_air
									modified = true
								end
								vi = vi + ystride
							end
						end

						-- Channel: cut a bed down from the waterline and fill it.
						local river_depth = max(3, min(floor(dpmax * 15), 15))
						local bed = max(water_top - river_depth, miny - 1)
						y0 = max(bed + 1, miny)
						local y1 = min(water_top, maxy)
						if y0 <= y1 then
							local col = water_colour(x, water_top, z)
							vi = vi0 + (y0 - miny) * ystride
							for _ = y0, y1 do
								if data[vi] ~= c_rwater then
									data[vi] = c_rwater
									modified = true
								end
								if p2data[vi] ~= col then
									p2data[vi] = col
									p2_modified = true
								end
								vi = vi + ystride
							end
						end

						-- Bed: sand over stone.
						if bed >= miny and bed <= maxy then
							data[vi0 + (bed - miny) * ystride] = c_sand
							modified = true
						end
						if bed - 1 >= miny and bed - 1 <= maxy then
							data[vi0 + (bed - 1 - miny) * ystride] = c_stone
							modified = true
						end

						-- Seal air pockets (caves) directly under the bed.
						local y = min(bed - 2, maxy)
						local seal_floor = max(miny, bed - 1 - SEAL_DEPTH)
						local sealed = 0
						while y >= seal_floor and sealed < SEAL_DEPTH do
							vi = vi0 + (y - miny) * ystride
							if data[vi] == c_air then
								data[vi] = c_stone
								modified = true
								sealed = sealed + 1
							else
								break
							end
							y = y - 1
						end
					end
				end

				i2d = i2d + 1
			end
		end

		if modified then
			vm:set_data(data)
		end
		if p2_modified then
			vm:set_param2_data(p2data)
		end
	end)

	if not ok2 then
		core.log('error', '[v7_rivers] on_generated error: ' .. tostring(err2))
	end
end)
