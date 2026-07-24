local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/drying_rack_utils.lua")
dofile(modpath .. "/craft.lua")
dofile(modpath .. "/nodes.lua")

drying_rack.init()
