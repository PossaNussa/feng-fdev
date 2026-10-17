-- creaturemob :: core/scheduler.lua
--
-- Decides how often a mob's *brain* runs, without ever touching how often its
-- *body* is updated.
--
-- That split is the core idea borrowed from creatura's step_delay: expensive
-- decision-making runs at a few hertz, while velocity and rotation are flushed
-- every single server step. Mobs Redo had it backwards -- it ran fairly cheap
-- decisions on a 1 Hz timer and actuated on that same 1 Hz timer, so the client
-- got a fresh, contradictory velocity vector once a second and corrected with a
-- visible snap.
--
-- Distance-based LOD stretches the brain interval for mobs nobody is near.
-- Their bodies keep updating normally, so they still arrive smoothly when a
-- player does come into view.

local sensors = creaturemob.sensors

local scheduler = {}

local settings = core.settings

local lod_enable = settings:get_bool("creaturemob_lod") ~= false
local lod_near = tonumber(settings:get("creaturemob_lod_near")) or 32
local lod_far = tonumber(settings:get("creaturemob_lod_far")) or 80

local lod_near_sq = lod_near * lod_near
local lod_far_sq = lod_far * lod_far

----------------------------------------------------------------------
-- Global per-step housekeeping
--
-- Registered once, not once per mob. Refreshes the player position table that
-- every mob's LOD check reads.
----------------------------------------------------------------------

core.register_globalstep(function()
	sensors.refresh_players()
end)

----------------------------------------------------------------------

-- Multiplier to apply to a mob's brain intervals. 1 = full rate.
--
--   within lod_near   : 1x   (a player can see it; think normally)
--   within lod_far    : 2x
--   beyond / nobody   : 4x
--
-- Returned rather than applied, so each front-end keeps ownership of its own
-- timer semantics.

function scheduler.brain_scale(self, pos)

	if not lod_enable or self.cm_no_lod then return 1 end

	local d = sensors.nearest_player_dist_sq(pos)

	if not d then return 4 end
	if d <= lod_near_sq then return 1 end
	if d <= lod_far_sq then return 2 end

	return 4
end

-- Convenience for front-ends with a single accumulating brain timer.
--
-- Accumulates `dtime` into `self[key]` and returns the elapsed time when the
-- (LOD-scaled) interval is reached, or nil when the brain should stay asleep.
-- Returning the *real* elapsed time rather than the nominal interval is what
-- keeps behaviour speed constant when the interval stretches -- the same
-- dtime compensation creatura does around step_delay.

function scheduler.tick(self, key, interval, dtime, scale)

	local elapsed = (self[key] or 0) + dtime

	if elapsed < interval * (scale or 1) then
		self[key] = elapsed
		return nil
	end

	self[key] = 0

	return elapsed
end

return scheduler
