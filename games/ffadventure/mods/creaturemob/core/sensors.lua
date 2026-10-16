-- creaturemob :: core/sensors.lua
--
-- Shared, throttled world sampling.
--
-- The two front-ends each used to sample the world from inside their behaviour
-- code, sometimes several times per step. The worst offender was Mobs Redo's
-- collision(), which ran a get_objects_inside_radius() on every single
-- set_velocity() call -- so the push-out force was recomputed whenever anything
-- touched velocity, and then went stale for a full second afterwards.
--
-- Everything here is refreshed on a fixed cadence and read many times.

local sensors = {}

local abs = math.abs

-- How often the per-mob player proximity scan runs. Twice the rate the old
-- push-out force was effectively sampled at, for a quarter of the scans.
local PUSH_INTERVAL = 0.5

----------------------------------------------------------------------
-- Nearest player
--
-- Cheap enough to recompute globally each step: servers have a handful of
-- players, not a radius full of entities. Feeds the scheduler's LOD.
----------------------------------------------------------------------

local player_positions = {}
local player_count = 0

function sensors.refresh_players()

	local players = core.get_connected_players()

	player_count = #players

	for i = 1, player_count do
		local p = players[i]:get_pos()
		local slot = player_positions[i]

		if slot then
			slot.x, slot.y, slot.z = p.x, p.y, p.z
		else
			player_positions[i] = {x = p.x, y = p.y, z = p.z}
		end
	end

	for i = player_count + 1, #player_positions do
		player_positions[i] = nil
	end
end

-- Squared distance to the closest player, or nil when nobody is online.

function sensors.nearest_player_dist_sq(pos)

	if player_count == 0 then return nil end

	local best

	for i = 1, player_count do

		local p = player_positions[i]
		local dx, dy, dz = pos.x - p.x, pos.y - p.y, pos.z - p.z
		local d = dx * dx + dy * dy + dz * dz

		if not best or d < best then best = d end
	end

	return best
end

----------------------------------------------------------------------
-- Push-out force
--
-- Only players push mobs, so this scan is deliberately player-only and uses
-- the mob's own width as the radius -- it stays cheap even at 2 Hz.
----------------------------------------------------------------------

function sensors.update_push(self, pos, width, dtime)

	local t = (self._cm_push_timer or 0) + dtime

	if t < PUSH_INTERVAL then
		self._cm_push_timer = t
		return false
	end

	self._cm_push_timer = 0

	local x, z = 0, 0
	local width_sq = width * width
	local objects = core.get_objects_inside_radius(pos, width)

	for i = 1, #objects do

		local obj = objects[i]

		if obj:is_player() then

			local pos2 = obj:get_pos()

			if pos2 then

				local vx, vz = pos.x - pos2.x, pos.z - pos2.z
				local dist_sq = vx * vx + vz * vz

				if dist_sq < width_sq and dist_sq > 0 then
					local force = (width - dist_sq ^ 0.5) * 2
					x = x + vx * force
					z = z + vz * force
				end
			end
		end
	end

	self._cm_push_x, self._cm_push_z = x, z

	return true
end

-- Last computed push. Zero until the first scan lands.

function sensors.get_push(self)
	return self._cm_push_x or 0, self._cm_push_z or 0
end

----------------------------------------------------------------------
-- Cached entity properties
--
-- get_properties() allocates a fresh table every call. Once a second is plenty
-- for anything that is not actively being resized.
----------------------------------------------------------------------

function sensors.props(self, dtime)

	local t = (self._cm_prop_timer or 0) + (dtime or 0)

	if not self._cm_prop or t >= 1 then
		self._cm_prop = self.object:get_properties()
		t = 0
	end

	self._cm_prop_timer = t

	return self._cm_prop
end

-- Force a re-read after a deliberate resize (growing up, scale_mob).

function sensors.invalidate_props(self)
	self._cm_prop = nil
	self._cm_prop_timer = nil
end

----------------------------------------------------------------------
-- Generic interval helper, so front-ends stop hand-rolling accumulators
----------------------------------------------------------------------

function sensors.every(self, key, interval, dtime)

	local timers = self._cm_timers

	if not timers then
		timers = {}
		self._cm_timers = timers
	end

	local t = (timers[key] or 0) + dtime

	if t >= interval then
		timers[key] = 0
		return true
	end

	timers[key] = t

	return false
end

return sensors
