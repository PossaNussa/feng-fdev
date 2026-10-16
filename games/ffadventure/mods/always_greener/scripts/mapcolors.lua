
-- Filled in on_mods_loaded, not at load time.
--
-- As a mapgen script this file was executed after every mod had registered, so
-- get_content_id always resolved. Running in the main env it is executed during
-- registration instead, and always_greener does not depend on `sailing` -- so
-- looking up sailing:shallow_water_source here would raise "Unknown node" on a
-- perfectly valid install. Unregistered names are skipped rather than assumed.
local grassnodes = {}
local waternodes = {}

minetest.register_on_mods_loaded(function()

	local function add(set, name)
		if minetest.registered_nodes[name] then
			set[minetest.get_content_id(name)] = true
		end
	end

	add(grassnodes, 'default:dirt_with_grass')

	-- Tall grass. luscious gives these nodes paramtype2='color' with a green
	-- heat/humidity palette laid out exactly like awg_grass_colormap.png
	-- (index = humidity_step*16 + heat_step), so grass_color_at's index drops
	-- straight in and the tufts match the dirt_with_grass they stand on.
	--
	-- These used to be coloured by luscious's own register_on_generated, which
	-- reads the engine `heatmap`/`humiditymap` mapgen objects -- empty under
	-- climate_zones_v7's `nobiomes` -- and by maprotations.lua, a mapgen script
	-- that only reaches the chunk-margin overlap. Both left the familiar lattice
	-- of coloured strips. Colouring them here, after the biome painter, covers
	-- the whole chunk with the painted zone climate instead.
	add(grassnodes, 'default:grass_1')
	add(grassnodes, 'default:grass_2')
	add(grassnodes, 'default:grass_3')
	add(grassnodes, 'default:grass_4')
	add(grassnodes, 'default:grass_5')
	add(grassnodes, 'default:dry_grass_4')
	add(grassnodes, 'default:dry_grass_5')
	add(grassnodes, 'default:junglegrass')
	add(grassnodes, 'nettle:nettle')

	-- Source nodes use paramtype2='color' (256-entry palette).  Flowing nodes
	-- are coloured at runtime via colorflowingliquid (see water.lua); mapgen
	-- output contains virtually no flowing nodes, so only sources are handled.
	add(waternodes, 'default:water_source')
	add(waternodes, 'default:river_water_source')
	add(waternodes, 'sailing:shallow_water_source')
end)

local alt_chill = minetest.settings: get_bool('awg.grass_alt_chill', true)
local alt_dry = minetest.settings: get_bool('awg.grass_alt_dry', true)

local water_depth_dry = minetest.settings: get_bool('awg.water_depth_dry', true)
local water_alt_chill = minetest.settings: get_bool('awg.water_alt_chill', true)

local water_color = minetest.settings: get_bool('awg.water_color', true)

local floor, min, max = math.floor, math.min, math.max

local function scale_index(heat, humidity)
	local heat_scaled = min(15, floor((max(0, min(heat, 100)) / 100) * 16))
	local humidity_scaled = min(15, floor((max(0, min(humidity, 100)) / 100) * 16))
	return humidity_scaled * 16 + heat_scaled
end

local function grass_color_at(heat, humidity, y, season_hum)
	if y > 80 then
		if alt_chill then heat = heat - (y - 80) * 0.5 end
		if alt_dry then humidity = humidity - (y - 80) * 0.75 end
	end
	-- Seasonal browning, supplied by the `seasons` mod over IPC (see below).
	-- Damped for hot biomes so a rainforest stays green year-round; this must
	-- match seasons.grass_latitude_weight().
	if season_hum ~= 0 then
		humidity = humidity + season_hum * max(0, min(1, (85 - heat) / 45))
	end
	return scale_index(heat, humidity)
end

local function water_color_at(heat, humidity, y)
	if water_alt_chill and y > 90 then
		heat = heat - (y - 90) * 0.75
		humidity = humidity - (y - 90) * 0.75
	end
	-- Deep water reads progressively drier/darker
	if water_depth_dry and y < -15 then
		humidity = max(0, humidity + y * 0.25)
	end
	return scale_index(heat, humidity)
end

-- This runs in the MAIN environment, not as a mapgen script, and that is
-- load-bearing.
--
-- climate_zones_v7 sets mg_flags to include `nobiomes`, so the engine places no
-- biome top nodes during emerge -- default:dirt_with_grass does not exist yet
-- while mapgen-env callbacks run. The biome painter creates it afterwards, from
-- the main env, at registered_on_generateds[1].
--
-- As a mapgen script this pass therefore found grass only in the ~16-node
-- emerged-area margin that overlaps already-painted neighbouring chunks, and
-- painted a lattice of coloured strips across the world instead of covering it.
--
-- Running here also means core.get_biome_data is the one climate_zones_v7
-- overrides, so the heat and humidity are the painted zone climate rather than
-- raw engine v7 noise. (The mapgen env only overrides get_heat/get_humidity.)
minetest.register_on_generated(function(minp, maxp, blockseed)
	-- `seasons` publishes its grass bias over IPC because this pass used to run
	-- in the isolated mapgen environment. Kept as IPC: it costs nothing, and it
	-- keeps working if this ever moves back. Falls back to 0 when `seasons` is
	-- absent, so always_greener still works standalone.
	local season_hum = core.ipc_get("seasons:grass_hum_delta") or 0

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	if not vm then return end

	local dat = vm: get_data()
	local p2dat = vm: get_param2_data()

	local area = VoxelArea(emin, emax)
	local ystride = area.ystride

	local biome_pos = {x = 0, y = 0, z = 0}
	local touched = false

	-- Only this chunk. The emerged area laps ~16 nodes into the neighbours, and
	-- recolouring those means touching mapblocks this callback does not own.
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			-- Heat/humidity noise is 2D: fetch it once per column, lazily.
			local heat0, hum0
			local vi = area: index(x, minp.y, z)
			for y = minp.y, maxp.y do
				local id = dat[vi]
				local is_grass = grassnodes[id]
				local is_water = water_color and waternodes[id]
				if is_grass or is_water then
					if not heat0 then
						biome_pos.x, biome_pos.y, biome_pos.z = x, y, z
						local biomedat = minetest.get_biome_data(biome_pos)
						heat0, hum0 = biomedat.heat, biomedat.humidity
					end
					if is_grass then
						p2dat[vi] = grass_color_at(heat0, hum0, y, season_hum)
					else
						p2dat[vi] = water_color_at(heat0, hum0, y)
					end
					touched = true
				end
				vi = vi + ystride
			end
		end
	end

	if touched then
		vm: set_param2_data(p2dat)
		-- In the mapgen env the engine wrote the manip for us. Here we own it.
		vm: write_to_map()
	end
end)
