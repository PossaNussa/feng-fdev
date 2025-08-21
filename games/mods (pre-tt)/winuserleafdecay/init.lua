
local modname = "winuserleafdecay"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("winuserleafdecay") or
		dofile(path .. "intllib.lua")



-- lua
dofile(path .. "functions.lua") -- 
dofile(path .. "leafdecay.lua") -- 





print (S("[MOD] leafdecay loaded"))
