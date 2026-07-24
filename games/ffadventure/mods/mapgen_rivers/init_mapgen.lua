if not core.global_exists('mapgen_rivers') then
	mapgen_rivers = {
		modpath = core.get_modpath(core.get_current_modname()) .. '/',
		data_path = core.get_worldpath() .. '/river_data/',
		settings = Settings(core.get_worldpath() .. '/mapgen_rivers.conf'),
		thread = 'mapgen',
	}
end

mapgen_rivers.grid = dofile(mapgen_rivers.modpath .. '/grid_load.lua')
dofile(mapgen_rivers.modpath .. '/mapgen.lua')
