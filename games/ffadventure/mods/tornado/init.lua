-- tornado
--
-- A severe-weather event for the shared climate: a supercell builds, the sky
-- goes green, the wind turns, and once in a long while a funnel drops out of it
-- and rearranges the landscape.
--
-- Design notes worth knowing before changing numbers:
--   * The event is a state machine (build-up -> touchdown), not a dice roll that
--     happens at you, and it never says a word. The warning is carried entirely
--     by the wind dying, the light going green, and litter starting to stream
--     towards the storm. See alert.lua, which is mostly about that.
--   * Most supercells never produce a funnel. tornado_funnel_chance decides,
--     once, at the start. A build-up that fizzles is the common case and is the
--     point: the sky stays worth reading because it is usually survivable.
--   * Nothing is deleted. Every node the funnel lifts becomes a debris entity
--     and is put back down somewhere else (debris.lua). The map gets messy, not
--     hollow.
--   * Node resistance is scaled so that stone effectively never moves. That is
--     the safety property that keeps this from carving craters; see api.lua.

tornado = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
tornado.modpath = modpath

local function sbool(name, default)
	local value = minetest.settings:get_bool("tornado_" .. name)
	if value == nil then return default end
	return value
end

local function snum(name, default)
	local value = tonumber(minetest.settings:get("tornado_" .. name))
	if value == nil then return default end
	return value
end

tornado.settings = {
	-- master switches
	enabled            = sbool("enabled", true),
	griefing           = sbool("griefing", true),
	damage             = sbool("damage", true),
	respect_protection = sbool("respect_protection", true),
	force_wind         = sbool("force_wind", true),

	-- how often, and how much of a warning
	storm_chance   = snum("storm_chance", 0.02),    -- per 15s scan, per qualifying player
	funnel_chance  = snum("funnel_chance", 0.15),   -- of those storms, how many drop a funnel
	cooldown       = snum("cooldown", 5400),        -- seconds of quiet after an event
	watch_time     = snum("watch_time", 300),
	approach_distance = snum("approach_distance", 150), -- how far upwind it drops in
	alert_radius   = snum("alert_radius", 400),

	-- the funnel itself
	lifetime   = snum("lifetime", 210),
	radius     = snum("radius", 7),
	height     = snum("height", 34),
	speed      = snum("speed", 3.2),
	node_rate  = snum("node_rate", 9),   -- nodes lifted per second at full strength
	max_debris = snum("max_debris", 140),
	particles  = snum("particles", 1),
	min_y      = snum("min_y", -20),
	max_y      = snum("max_y", 250),
}

-- Loud, repeated, and honest about what this mod does to a world.
-- Printed once at load and again after everything else has finished spamming
-- the log, so it is still on screen when the server finishes starting.
local function shout()
	local bar = string.rep("!", 78)
	local lines = {
		bar,
		"!!  THE TORNADO MOD REARRANGES THE MAP. IT LIFTS NODES AND DROPS THEM  !!",
		"!!  SOMEWHERE ELSE. IT CAN FLATTEN A BUILD YOU SPENT A WEEK ON.        !!",
		"!!                                                                     !!",
		"!!  Creative or showcase world? Set  tornado_griefing = false          !!",
		"!!  Don't want it at all?       Set  tornado_enabled = false           !!",
		"!!                                                                     !!",
		"!!  Protected areas are respected while tornado_respect_protection is  !!",
		"!!  true (the default). Nothing else is safe.                          !!",
		bar,
	}
	for _ = 1, 2 do
		for _, line in ipairs(lines) do
			minetest.log("warning", "[tornado] " .. line)
			print("[tornado] " .. line)
		end
	end
end

if not tornado.settings.enabled then
	minetest.log("action", "[tornado] disabled by tornado_enabled = false")
	return
end

if tornado.settings.griefing then
	shout()
	minetest.after(3, shout)
else
	minetest.log("action", "[tornado] tornado_griefing is off: funnels are visual, "
		.. "they push players and entities but lift no nodes")
end

dofile(modpath .. "/api.lua")
dofile(modpath .. "/debris.lua")
dofile(modpath .. "/funnel.lua")
dofile(modpath .. "/alert.lua")
dofile(modpath .. "/weather.lua")
dofile(modpath .. "/commands.lua")
