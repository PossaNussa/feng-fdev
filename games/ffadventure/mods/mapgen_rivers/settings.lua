local sfile = mapgen_rivers.settings

local defaults = Settings(mapgen_rivers.modpath .. "/settings_default.conf")

local function write_setting(name, default, is_noise)
	if sfile:has(name) then
		return
	end

	if default == nil then
		if core.settings:has("mapgen_rivers_"..name) then
			if is_noise then
				default = core.settings:get_np_group("mapgen_rivers_"..name)
			else
				default = core.settings:get("mapgen_rivers_"..name)
			end
		elseif defaults:has(name) then
			if is_noise then
				default = defaults:get_np_group(name)
			else
				default = defaults:get(name)
			end
		else
			return
		end
	end

	if is_noise then
		sfile:set_np_group(name, default)
	else
		sfile:set(name, default)
	end
end

local function write_noise_setting(name, default)
	write_setting(name, default, true)
end

write_setting('version', defaults:get('version'))

write_setting('center')
write_setting('blocksize')
write_setting('sea_level', core.settings:get('water_level'))
write_setting('min_catchment')
write_setting('river_widening_power')
write_setting('riverbed_slope')
write_setting('distort')
write_setting('biomes')
write_setting('glaciers')
write_setting('glacier_factor')
write_setting('elevation_chill')

write_setting('map_x_size')
write_setting('map_z_size')
write_setting('margin')
write_setting('margin_width')
write_setting('margin_elev')

write_setting('base_from_mapgen')
write_setting('base_detail')

write_setting('river_erosion_coef')
write_setting('river_erosion_power')
write_setting('diffusive_erosion')
write_setting('compensation_radius')
write_setting('tectonic_speed')
write_setting('evol_time')
write_setting('evol_time_step')

write_noise_setting('np_base')
write_noise_setting('np_distort_x')
write_noise_setting('np_distort_z')
write_noise_setting('np_distort_amplitude')

sfile:write()

mapgen_rivers.settings = sfile
