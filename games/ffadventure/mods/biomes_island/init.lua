islands= {}

local floor = math.floor
local ceil = math.ceil
local min = math.min
local max = math.max
local random = math.random

local convex = false
local mpath = minetest.get_modpath('biomes_island')



local islands_biome = minetest.get_biome_id("biomes_island")
dofile(mpath ..'/registerstuff.lua')
dofile(mpath ..'/weather.lua')

minetest.register_on_newplayer(function(obj)
	local inv = obj:get_inventory()
	inv:add_item('main', 'spyglass:spyglass')
	inv:add_item('main', 'boats:boat')

	local pos = obj:get_pos()
	pos.y = 3
	obj:set_pos(pos)

	return true
end)
