-- creaturemob :: core/motion.lua
--
-- The single writer of velocity, acceleration and rotation for every mob, no
-- matter which front-end registered it.
--
-- Both mob APIs used to actuate straight from their behaviour code: Mobs Redo
-- issued object:set_velocity() from a dozen call sites on 1 Hz and 4 Hz timers
-- and stepped yaw with a frame counter that never looked at dtime, while
-- creatura buffered intent and flushed it once per step. The frame-counted,
-- multi-writer approach is what the client sees as rubberbanding: the mob's
-- committed velocity was derived from a yaw it no longer has, and every stale
-- correction arrives as a snap.
--
-- Here, behaviour code only ever writes *intent* into self._cm. Once per server
-- step apply() turns that intent into at most one set_velocity, one
-- set_acceleration and one set_rotation -- and skips even those when nothing
-- actually changed.

local motion = {}

local pi = math.pi
local abs, min, max = math.abs, math.min, math.max
local sin, cos = math.sin, math.cos

local TWO_PI = pi * 2

-- Nominal server step. Used only to convert Mobs Redo's frame-counted turn
-- delays into a rad/s rate; the rate itself is applied against real dtime.
local STEP_TIME = tonumber(core.settings:get("dedicated_server_step")) or 0.09

-- Below this, a re-send of the same value is pure network noise.
local VEL_EPSILON = 0.01
local ROT_EPSILON = 0.005

-- Ground friction when no forward speed is requested. creatura's value; the
-- Mobs Redo front-end leaves this at 0 because its FSM always states a speed.
motion.default_friction = 7

local function shortest_rotation(from, to)

	local diff = (to - from) % TWO_PI

	if diff > pi then return diff - TWO_PI end

	return diff
end

motion.shortest_rotation = shortest_rotation

-- Attach controller state to a mob. Safe to call repeatedly.

function motion.init(self, def)

	local cm = self._cm

	if not cm then
		cm = {}
		self._cm = cm
	end

	cm.yaw_offset = cm.yaw_offset or 0
	cm.friction = cm.friction or 0
	cm.drag = cm.drag or 0
	cm.grav = cm.grav or 0
	cm.turn_rate = cm.turn_rate or 5

	if def and def.friction then cm.friction = def.friction end

	return cm
end

----------------------------------------------------------------------
-- Intent setters. None of these touch the ObjectRef.
----------------------------------------------------------------------

-- Turn toward `yaw` at `rate` rad/s. rate = nil means snap this step.

function motion.turn_to(self, yaw, rate)

	local cm = self._cm ; if not cm then return end

	cm.tyaw = yaw % TWO_PI
	cm.turn_rate = rate
end

-- Mobs Redo compatibility: `delay` counts server steps, not seconds. Convert it
-- once, here, so the turn keeps its original wall-clock pacing but stops being
-- framerate-dependent.

function motion.turn_to_delayed(self, yaw, delay, cur_yaw)

	local cm = self._cm ; if not cm then return end

	yaw = yaw % TWO_PI

	if not delay or delay <= 0 then
		cm.tyaw = yaw
		cm.turn_rate = nil -- snap
		return yaw
	end

	local diff = abs(shortest_rotation(cur_yaw or 0, yaw))

	cm.tyaw = yaw
	cm.turn_rate = max(diff / (delay * STEP_TIME), 0.01)

	return yaw
end

-- Forward speed along the mob's own facing. nil releases the axis to friction.

function motion.set_forward_velocity(self, speed)

	local cm = self._cm ; if not cm then return end

	cm.horz = speed
	cm.world_x, cm.world_y, cm.world_z = nil, nil, nil -- last writer wins
end

-- Continuous vertical speed (swimmers, fliers). nil releases the axis.

function motion.set_vertical_velocity(self, speed)

	local cm = self._cm ; if not cm then return end

	cm.vert = speed
end

-- One-shot vertical impulse: jumps, buoyancy kicks. Consumed on the next apply.

function motion.set_vertical_impulse(self, speed)

	local cm = self._cm ; if not cm then return end

	cm.vert_once = speed
end

-- One-shot world-space velocity, for the cases that are not "move forward":
-- knockback, a flier diving back into its medium, an explicit full stop.
-- Consumed by the next apply(), and it clears any forward intent so the two
-- cannot fight over the same step.

function motion.set_world_velocity(self, vx, vy, vz)

	local cm = self._cm ; if not cm then return end

	cm.world_x, cm.world_y, cm.world_z = vx, vy, vz
	cm.horz = nil
	cm.vert = nil
	cm.vert_once = nil
end

function motion.set_gravity(self, gravity)

	local cm = self._cm ; if not cm then return end

	cm.grav = gravity or -9.8
end

-- World-space shove, added on top of forward velocity. Refreshed by the sensor
-- layer rather than recomputed inside every set_velocity call.

function motion.set_push(self, x, z)

	local cm = self._cm ; if not cm then return end

	cm.push_x = x
	cm.push_z = z
end

-- Temporary horizontal acceleration, e.g. Mobs Redo's mid-jump forward nudge.
-- Replaces a core.after() callback that fired outside the step loop entirely.

function motion.add_horizontal_accel(self, ax, az, duration)

	local cm = self._cm ; if not cm then return end

	cm.accel_x = ax
	cm.accel_z = az
	cm.accel_time = duration or 0.3
end

-- Horizontal drag applied only on steps where no forward speed was requested.

function motion.set_friction(self, friction)

	local cm = self._cm ; if not cm then return end

	cm.friction = friction or 0
end

function motion.set_drag(self, drag)

	local cm = self._cm ; if not cm then return end

	cm.drag = drag or 0
end

-- Drop all intent. Does not zero velocity: friction decays it, which is what
-- keeps a halt from reading as a snap.

function motion.halt(self)

	local cm = self._cm ; if not cm then return end

	cm.horz = nil
	cm.vert = nil
	cm.vert_once = nil
	cm.tyaw = nil
	cm.accel_time = nil
	cm.push_x = nil
	cm.push_z = nil
	cm.world_x, cm.world_y, cm.world_z = nil, nil, nil
end

----------------------------------------------------------------------
-- The actuator
----------------------------------------------------------------------

-- Runs every server step for every mob, including steps where the brain is
-- skipped. That is the whole point: cheap physical state stays fresh at full
-- tick rate while expensive decisions run at their own cadence.

function motion.apply(self, dtime)

	local cm = self._cm ; if not cm then return end

	local obj = self.object ; if not obj then return end

	local vel = obj:get_velocity() ; if not vel then return end

	----------------------------------------------------------------
	-- Rotation
	--
	-- get_rotation() allocates, so only reach for it when actually turning;
	-- otherwise get_yaw() is enough to derive horizontal velocity.
	----------------------------------------------------------------

	local yaw

	if cm.tyaw then

		local rot = obj:get_rotation() ; if not rot then return end

		yaw = rot.y

		local rate = cm.turn_rate
		local arrived = false

		if not rate then
			yaw = cm.tyaw
			arrived = true
		else
			local diff = shortest_rotation(yaw, cm.tyaw)
			local step = rate * dtime

			if abs(diff) <= step then
				yaw = cm.tyaw
				arrived = true
			else
				yaw = yaw + (diff > 0 and step or -step)
			end
		end

		yaw = yaw % TWO_PI

		-- Always write the final step so the mob lands exactly on target;
		-- otherwise skip sub-epsilon nudges.
		if arrived or abs(shortest_rotation(rot.y, yaw)) > ROT_EPSILON then
			rot.y = yaw
			obj:set_rotation(rot)
		end

		if arrived then cm.tyaw = nil end -- stop re-sending
	else
		yaw = obj:get_yaw() or 0
	end

	----------------------------------------------------------------
	-- Horizontal velocity, always derived from the yaw we just applied
	----------------------------------------------------------------

	local vx, vz = vel.x, vel.z
	local world_override = cm.world_x ~= nil

	if world_override then
		vx, vz = cm.world_x, cm.world_z
	elseif cm.horz then

		local a = yaw + (cm.yaw_offset or 0)

		vx = sin(a) * -cm.horz
		vz = cos(a) * cm.horz
	else
		-- No stated speed: let friction bleed it off rather than snapping to 0.
		local f = cm.friction or 0

		if f > 0 then
			local k = min(dtime * f, 0.5)
			vx = vx * (1 - k)
			vz = vz * (1 - k)
		end
	end

	-- Liquid drag, dtime-scaled so it behaves the same at any tick rate.
	-- An explicit world-space command is never dragged: it is an instruction,
	-- not carried-over momentum.
	if not world_override and cm.drag and cm.drag > 0 then
		local k = min(dtime * cm.drag, 0.9)
		vx = vx * (1 - k)
		vz = vz * (1 - k)
	end

	if cm.push_x then vx = vx + cm.push_x end
	if cm.push_z then vz = vz + cm.push_z end

	----------------------------------------------------------------
	-- Vertical velocity
	----------------------------------------------------------------

	local vy = vel.y

	if world_override then
		vy = cm.world_y
		cm.world_x, cm.world_y, cm.world_z = nil, nil, nil
	elseif cm.vert_once then
		vy = cm.vert_once
		cm.vert_once = nil
	elseif cm.vert then
		vy = cm.vert
	elseif cm.drag and cm.drag > 0 then
		-- Only a carried-over vertical velocity is dragged; a stated one is a
		-- command and must not be quietly scaled down.
		vy = vy * (1 - min(dtime * cm.drag, 0.9))
	end

	----------------------------------------------------------------
	-- Flush: one write each, and only when it actually moved
	----------------------------------------------------------------

	-- Kept as scalars, not a table: this runs for every mob every step and the
	-- allocation churn would be the most expensive thing in the whole module.
	if not cm.lvx
	or abs(cm.lvx - vx) > VEL_EPSILON
	or abs(cm.lvy - vy) > VEL_EPSILON
	or abs(cm.lvz - vz) > VEL_EPSILON then

		obj:set_velocity({x = vx, y = vy, z = vz})

		cm.lvx, cm.lvy, cm.lvz = vx, vy, vz
	end

	----------------------------------------------------------------
	-- Acceleration
	----------------------------------------------------------------

	local ax, az = 0, 0

	if cm.accel_time and cm.accel_time > 0 then

		cm.accel_time = cm.accel_time - dtime

		if cm.accel_time > 0 then
			ax = cm.accel_x or 0
			az = cm.accel_z or 0
		else
			cm.accel_time = nil
		end
	end

	local ay = cm.grav or 0

	if not cm.lax
	or abs(cm.lax - ax) > VEL_EPSILON
	or abs(cm.lay - ay) > VEL_EPSILON
	or abs(cm.laz - az) > VEL_EPSILON then

		obj:set_acceleration({x = ax, y = ay, z = az})

		cm.lax, cm.lay, cm.laz = ax, ay, az
	end
end

-- Called when something outside the controller wrote velocity directly (arrow
-- knockback, mount code, legacy_motion mobs), so the dirty check does not
-- suppress the next legitimate write.

function motion.invalidate(self)

	local cm = self._cm ; if not cm then return end

	cm.lvx, cm.lvy, cm.lvz = nil, nil, nil
	cm.lax, cm.lay, cm.laz = nil, nil, nil
end

return motion
