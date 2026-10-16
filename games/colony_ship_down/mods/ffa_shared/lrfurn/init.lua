-- lrfurn/init.lua
-- Living Room Furnitures
--[[
    Living Room Furniture by thefamilygrog66 and 1F616EMO
    is marked with CC0 1.0. To view a copy of this license,
    visit http://creativecommons.org/publicdomain/zero/1.0
]]

local S = minetest.get_translator("lrfurn")

lrfurn = {}

function lrfurn.sofa_click(pos, node, clicker)
    if not clicker:is_player() then
        return
    end
    pos.y = pos.y - 0.5
    clicker:set_pos(pos)
end

dofile(minetest.get_modpath("lrfurn").."/longsofas.lua")
dofile(minetest.get_modpath("lrfurn").."/sofas.lua")
dofile(minetest.get_modpath("lrfurn").."/armchairs.lua")
dofile(minetest.get_modpath("lrfurn").."/coffeetable.lua")
dofile(minetest.get_modpath("lrfurn").."/endtable.lua")
