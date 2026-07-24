--[[
	Beta Combat — Minecraft Beta style melee mechanics

	1. Full-damage spam: every punch deals full damage regardless of speed.
	   The engine's time_from_last_punch scaling is bypassed by cancelling
	   the original hit and re-punching with a full interval.
	2. Momentum bonus: the hitter's speed adds extra fleshy damage.
	   Sprint attacks, falling slashes, and launch attacks all hit harder.
]]

local MOMENTUM_SCALE       = 0.6   -- extra damage per m/s of hitter speed
local MOMENTUM_MIN_SPEED   = 4.0   -- ignore speeds below this (normal walk ~4)
local MOMENTUM_MAX_BONUS   = 6     -- cap so a fall from the sky isn't instant-kill
local MOMENTUM_VERTICAL_W  = 0.7   -- how much vertical speed counts (vs horizontal)

beta_combat = {}

-- Guard against re-entry when we call punch() ourselves
local repunching = {}
beta_combat.repunching = repunching

-- ─── 1. Full-damage override ─────────────────────────────────────────
-- The engine scales damage down when time_from_last_punch < full_punch_interval.
-- We cancel the original hit and re-punch with a faked full interval so
-- every click does full damage, no matter how fast you spam.

local function full_damage_override(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if not hitter:is_player() then return end

	local name = hitter:get_player_name()
	if repunching[name] then return end  -- let our re-punch through

	local interval = 0.9
	if tool_capabilities and tool_capabilities.full_punch_interval then
		interval = tool_capabilities.full_punch_interval
	end

	-- If the engine already considers this a full hit, let it through as-is
	if time_from_last_punch >= interval then return end

	-- Cancel the scaled-down hit, re-punch with full interval
	repunching[name] = true
	player:punch(hitter, interval, tool_capabilities, dir)
	repunching[name] = nil
	return true  -- cancel the original (weak) hit
end

table.insert(minetest.registered_on_punchplayers, 1, full_damage_override)


-- ─── 1b. Full-damage override for entities (mobs) ───────────────────
-- Same idea: wrap every entity's on_punch so spammed hits do full damage.

minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_entities) do
		local orig_on_punch = def.on_punch
		def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, ...)
			if puncher and puncher:is_player() then
				local pname = puncher:get_player_name()
				if not repunching[pname] then
					local interval = 0.9
					if tool_capabilities and tool_capabilities.full_punch_interval then
						interval = tool_capabilities.full_punch_interval
					end

					if time_from_last_punch < interval then
						-- Cancel scaled hit, re-punch at full interval
						repunching[pname] = true
						self.object:punch(puncher, interval, tool_capabilities, dir)
						repunching[pname] = nil
						return true
					end
				end
			end

			if orig_on_punch then
				return orig_on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, ...)
			end
		end
	end
end)


-- ─── 2. Momentum bonus damage (PvP) ─────────────────────────────────

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if not hitter:is_player() then return end

	local vel = hitter:get_velocity()
	if not vel then return end

	local h_speed = math.sqrt(vel.x * vel.x + vel.z * vel.z)
	local v_speed = math.abs(vel.y) * MOMENTUM_VERTICAL_W
	local total   = h_speed + v_speed

	if total < MOMENTUM_MIN_SPEED then return end

	local bonus = math.min((total - MOMENTUM_MIN_SPEED) * MOMENTUM_SCALE, MOMENTUM_MAX_BONUS)
	bonus = math.floor(bonus + 0.5)

	if bonus <= 0 then return end

	local hp = player:get_hp()
	player:set_hp(hp - bonus, {type = "punch", from = "beta_combat:momentum"})
end)
