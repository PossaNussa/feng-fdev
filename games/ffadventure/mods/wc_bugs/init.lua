-- wc_bugs -- a variety of bugs, ported from NodeCore to Minetest Game.
-- Original by Winter94. See README.md for what the port changed.

local modpath = minetest.get_modpath("wc_bugs")

local function include(name)
	dofile(modpath .. "/" .. name .. ".lua")
end

local function setting(name, default)
	return minetest.settings:get_bool("wc_bugs." .. name, default)
end

include("api")

include("peatle")
include("prillbug")
include("stickbug")
include("torchbug")
include("luxmoth")

if setting("termites", true) then
	include("termites")
end

include("killcommand")

if setting("toofar", true) then
	include("gone_too_far")
end

if setting("tremors", true) then
	include("wurm")
end

-- Last: the jars only register for bugs that actually exist.
if setting("bugjars", true) then
	include("bugjars")
end
