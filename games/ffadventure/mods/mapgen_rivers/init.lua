-- Main file, calls the other files and triggers main functions

mapgen_rivers = {
	modpath = core.get_modpath(core.get_current_modname()) .. '/',
	data_path = core.get_worldpath() .. '/river_data/',
	settings = Settings(core.get_worldpath() .. '/mapgen_rivers.conf'),
	thread = 'main',
}

dofile(mapgen_rivers.modpath .. 'settings.lua')

core.register_on_mods_loaded(function()
	local f = io.open(mapgen_rivers.data_path .. "size", "r")
	if f then f:close() end
	if not f then
		dofile(mapgen_rivers.modpath .. '/pregenerate.lua')
		collectgarbage()
	end
end)

if core.get_mapgen_setting("mg_name") == "singlenode" then
	core.register_mapgen_script(mapgen_rivers.modpath .. 'init_mapgen.lua')

	core.set_gen_notify('custom', nil, {'mapgen_rivers:time'})
	local ngen = 0
	local sumtime = 0
	local sumtime2 = 0
	core.register_on_generated(function()
		local gennotify = core.get_mapgen_object('gennotify')
		local t = gennotify.custom['mapgen_rivers:time']
		ngen = ngen + 1
		sumtime = sumtime + t
		sumtime2 = sumtime2 + t*t

		core.log("verbose", ("[mapgen_rivers] Done in %5.3f s"):format(t))
	end)

	core.register_on_shutdown(function()
		local avg = sumtime / ngen
		local std = math.sqrt(sumtime2/ngen - avg*avg)
		core.log("action", ("[mapgen_rivers] Mapgen statistics:\n- Mapgen calls: %4d\n- Mean time: %5.3f s\n- Standard deviation: %5.3f s"):format(ngen, avg, std))
	end)
end
