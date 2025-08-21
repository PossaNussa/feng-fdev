local modname  = minetest.get_current_modname()
local modpath  = minetest.get_modpath (modname)
local thisdir  = modpath
local S, NS    = dofile (thisdir .. "/intllib.lua")

castle          = {}
castle.fcon     = default.convert_force
castle.cvt      = default.convert_node
castle.modpath  = modpath
castle.S        = S

dofile (thisdir .. "/castle_farming/init.lua"    )

