print("This file will be run at load time!")

local MP = minetest.get_modpath("startest")

dofile(MP.."/craftitems.lua")

dofile(MP.."/nodes.lua")

dofile(MP.."/decorations.lua")
