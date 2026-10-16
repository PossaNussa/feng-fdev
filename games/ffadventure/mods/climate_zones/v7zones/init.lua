-- climate_zones_v7: Voronoi climate zones with a north-south latitude
-- gradient, painted onto engine mapgen terrain. The engine keeps terrain,
-- caves, dungeons and base light (and v7_rivers keeps carving rivers in the
-- mapgen env, which always runs before this); biome paint, dust, ores and
-- decorations are re-done here through climate_zones_biomegen so they follow
-- the zone climate instead of the engine's smooth climate noise.

local modpath = core.get_modpath(core.get_current_modname())

if core.settings:get_bool("climate_zones_standalone", false) then
	return -- the standalone Climate Zones mapgen is driving the world
end
if not core.settings:get_bool("climate_v7_enabled", true) then
	return
end
if core.get_mapgen_setting("mg_name") == "singlenode" then
	return
end

local climate = dofile(modpath .. "/climate.lua")

-- Published so other mods can ask where they are on the climate axis instead of
-- inferring it from local biome heat, which conflates latitude with altitude
-- chill and per-zone jitter. Only set when zone climate is actually driving the
-- world -- the early returns above leave it nil, which is the signal for
-- consumers to fall back to whatever they did before.
climate_zones_v7 = {
	latitude_at = climate.latitude_at,  -- (pos) -> 0 at equator .. 1 at pole
	climate_at  = climate.climate_at,   -- (x, z) -> {heat, humid} at sea level
	get_heat    = climate.get_heat,     -- (pos) -> zone heat with altitude chill
	LAPSE       = climate.LAPSE,
	EQUATOR     = climate.EQUATOR,
	POLE        = climate.POLE,
}

core.set_mapgen_setting("mg_flags",
	"caves, dungeons, light, nodecorations, nobiomes, noores", true)

-- keep the mapgen env (v7_rivers river-water tint) on the same climate
core.register_mapgen_script(modpath .. "/mapgen_env.lua")

biomegen.set_lapse_rate(climate.LAPSE)

-- Route runtime climate queries (regional_weather, tempsurvive, mob
-- spawning, ...) through the zone climate so they agree with the painted
-- biomes.
function core.get_heat(pos)
	return climate.get_heat(pos)
end

function core.get_humidity(pos)
	return climate.get_humidity(pos)
end

local orig_get_biome_data = core.get_biome_data
local biomelist_ready = false
function core.get_biome_data(pos)
	if not biomelist_ready then
		orig_get_biome_data(pos) -- biomegen builds its biome list lazily
		biomelist_ready = true
	end
	local heat = climate.get_heat(pos)
	local humidity = climate.get_humidity(pos)
	local biome = biomegen.calc_biome_from_noise(heat, humidity, pos)
	return {
		heat = heat,
		humidity = humidity,
		biome = biome and biome.id or 0,
	}
end

local Y_SKIP_ABOVE = tonumber(core.settings:get("climate_v7_paint_y_max")) or 2000

local function paint(minp, maxp, blockseed, dim_name)
	if dim_name and dim_name ~= "" then
		return -- other dimensions run their own generation
	end
	if minp.y > Y_SKIP_ABOVE then
		return
	end

	local vm, emin, emax = core.get_mapgen_object("voxelmanip")
	if not vm then
		return
	end
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	local heatmap, humidmap = climate.make_maps(minp, maxp)
	biomegen.generate_biomes(data, area, minp, maxp, heatmap, humidmap)
	vm:set_data(data)

	-- The 4th argument needs the engine's optional-biomemap extension of
	-- generate_ores; an unpatched engine ignores it (ores still place, but
	-- their biome restrictions are lost).
	core.generate_ores(vm, minp, maxp, biomegen.get_biomemap_raw())

	biomegen.place_all_decos(data, area, vm, minp, maxp, blockseed)
	vm:get_data(data)
	biomegen.dust_top_nodes(data, area, vm, minp, maxp)

	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end

-- Run before every other main-env on_generated callback (startest blend
-- etc.) so they all see fully painted and decorated terrain — the same trick
-- the standalone Climate Zones mapgen uses.
table.insert(core.registered_on_generateds, 1, paint)
