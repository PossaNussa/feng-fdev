-- Standalone character animation: head look, body turn lag, arm swing
-- Zero dependencies, no modlib. Uses set_bone_override (rotation-only, additive).

local RAD = math.pi / 180  -- degrees to radians

-- Config (degrees, converted to radians at use)
local TURN_SPEED_IDLE = 0.15  -- body yaw interpolation when standing still
local TURN_SPEED_WALK = 0.6   -- body yaw interpolation when walking (fast catch-up)
local HEAD_PITCH_MIN  = -60
local HEAD_PITCH_MAX  = 80
local HEAD_YAW_MIN    = -90
local HEAD_YAW_MAX    = 90
local ARM_RADIUS      = 20    -- arm swing amplitude in degrees
local ARM_SPEED       = 800   -- arm swing speed (degrees/sec)

-- Per-player state
local state = {}

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

-- Wrap angle to [-180, 180]
local function wrap180(a)
	a = a % 360
	if a > 180 then a = a - 360 end
	return a
end

-- Build a rotation-only bone override (additive to engine animation)
local function rot_override(x_deg, y_deg, z_deg)
	return {
		rotation = {
			vec = vector.new(x_deg * RAD, y_deg * RAD, z_deg * RAD),
			absolute = false,
			interpolation = 0,
		},
	}
end

-- Clear override for a bone
local function clear_override(player, bone)
	player:set_bone_override(bone, {})
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	state[name] = {
		body_yaw = player:get_look_horizontal() * 180 / math.pi,
		arm_phase = 0,
		arm_left_phase = 0,
	}
end)

minetest.register_on_leaveplayer(function(player)
	state[player:get_player_name()] = nil
end)

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local s = state[name]
		if not s then goto continue end

		-- Skip players attached to entities (vehicles, beds, etc.)
		if player:get_attach() then
			clear_override(player, "Head")
			clear_override(player, "Body")
			clear_override(player, "Arm_Right")
			clear_override(player, "Arm_Left")
			goto continue
		end

		-- Player look angles in degrees
		local look_pitch = -player:get_look_vertical() * 180 / math.pi   -- positive = looking up
		local look_yaw   = player:get_look_horizontal() * 180 / math.pi  -- 0..360

		-- === Body yaw: smooth lag toward look yaw ===
		local body_yaw = s.body_yaw
		local yaw_diff = wrap180(look_yaw - body_yaw)

		-- Force body to follow if head yaw would exceed clamp
		if math.abs(yaw_diff) > (-HEAD_YAW_MIN) then
			local overshoot = math.abs(yaw_diff) - (-HEAD_YAW_MIN)
			if yaw_diff > 0 then
				body_yaw = body_yaw + overshoot
			else
				body_yaw = body_yaw - overshoot
			end
			yaw_diff = wrap180(look_yaw - body_yaw)
		end

		-- When walking, body catches up fast so legs don't go diagonal
		local controls = player:get_player_control()
		local walking = controls.up or controls.down or controls.left or controls.right
		local turn_speed = walking and TURN_SPEED_WALK or TURN_SPEED_IDLE

		-- Smooth interpolation
		body_yaw = body_yaw + yaw_diff * turn_speed
		s.body_yaw = body_yaw

		-- Body rotation offset: difference between body_yaw and the engine's visual yaw
		-- The engine sets the player visual yaw to look_horizontal, so we offset by (body - look)
		local body_offset = wrap180(body_yaw - look_yaw)

		-- === Head rotation ===
		local head_pitch = clamp(look_pitch, HEAD_PITCH_MIN, HEAD_PITCH_MAX)
		local head_yaw   = clamp(-yaw_diff, HEAD_YAW_MIN, HEAD_YAW_MAX) -- relative to body

		-- === Right arm swing (LMB or RMB) ===
		local arm_r = 0
		if controls.LMB or controls.RMB then
			s.arm_phase = s.arm_phase + dtime * ARM_SPEED
			local swing = math.sin(s.arm_phase * RAD) * ARM_RADIUS
			arm_r = swing + head_pitch * 0.3
		else
			s.arm_phase = 0
		end

		-- === Left arm swing (RMB only — offhand use) ===
		local arm_l = 0
		if controls.RMB then
			s.arm_left_phase = s.arm_left_phase + dtime * ARM_SPEED
			local swing = math.sin(s.arm_left_phase * RAD) * ARM_RADIUS
			arm_l = swing + head_pitch * 0.3
		else
			s.arm_left_phase = 0
		end

		-- Apply rotation-only overrides (additive to engine animation, no position changes)
		player:set_bone_override("Head", rot_override(head_pitch, head_yaw, 0))
		player:set_bone_override("Body", rot_override(0, body_offset, 0))
		if arm_r ~= 0 then
			player:set_bone_override("Arm_Right", rot_override(arm_r, 0, 0))
		else
			clear_override(player, "Arm_Right")
		end
		if arm_l ~= 0 then
			player:set_bone_override("Arm_Left", rot_override(arm_l, 0, 0))
		else
			clear_override(player, "Arm_Left")
		end

		::continue::
	end
end)
