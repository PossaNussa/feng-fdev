tanning_rack = {}

-- facedir → offset direction (which way the rack "faces", same logic as drying_rack)
tanning_rack.facedir_offsets = {
    [0] = {x =  0, y = 0, z =  1},
    [1] = {x =  1, y = 0, z =  0},
    [2] = {x =  0, y = 0, z = -1},
    [3] = {x = -1, y = 0, z =  0},
}

local modpath = minetest.get_modpath("tanning_rack")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/craft.lua")
