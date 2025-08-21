local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath (modname)

if minetest.setting_getbool ("disable_castle") then
    ocutil.log ("castle is disabled")
else
    dofile (modpath .. "/baseinit.lua")
end
