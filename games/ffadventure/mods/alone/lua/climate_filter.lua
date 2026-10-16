local internal_api = ...

-- Spawn-site difficulty, and the biased sampling built on top of it.
--
-- A uniformly random X/Z is not a uniformly random *difficulty*. This world's
-- climate runs on a north-south latitude gradient (climate_zones_v7: heat 100
-- at the equator Z, 0 at the pole Z), so an even spread of Z is an even spread
-- of heat from scorched to frozen, and most of that range is a death sentence
-- for a player who spawns with nothing. Rather than reshaping the Z
-- distribution -- which would bake one climate mod's layout into this one --
-- we sample positions exactly as before and score what we actually find there,
-- through core.get_heat/get_humidity. Whatever is driving climate, those two
-- answer for it.

local S = core.settings

-- Body temperature in tempsurvive is roughly (biome heat - 50) / 2 degrees and
-- an unclothed player is safe between -10 and 40, so heat much below 30
-- freezes you before you can craft your way out of it, while the hot end has
-- far more headroom -- hence the asymmetric edges. Dryness kills nothing
-- directly, it just leaves no water, no food and no wood, so it weighs less.
local COLD_EDGE   = 35
local HOT_EDGE    = 78
local DRY_EDGE    = 25
local DRY_WEIGHT  = 0.6

-- Score at or above which a site counts as harsh, and the share of spawns
-- allowed to be harsh. 0.3 is reached at about heat 24 (roughly -13 degrees,
-- just past the unclothed limit), heat 85, or humidity 12.
local HARSH_SCORE = tonumber(S:get("alone_harsh_score")) or 0.3
local HARSH_SHARE = tonumber(S:get("alone_harsh_share")) or 0.25

--- How hostile a spot is to a player who arrives there with nothing.
--
-- 0 is temperate; the threshold above is the edge of survivable; the frozen
-- and scorched extremes run past 1. Takes a full position because altitude
-- chill is part of the answer -- a peak in the tropics reads as arctic.
function internal_api.harshness(pos)
	if not core.get_heat then return 0 end

	local heat = core.get_heat(pos) or 50
	local humid = core.get_humidity(pos) or 50
	local score = 0

	if heat < COLD_EDGE then
		score = score + (COLD_EDGE - heat) / COLD_EDGE
	elseif heat > HOT_EDGE then
		score = score + (heat - HOT_EDGE) / (100 - HOT_EDGE)
	end

	if humid < DRY_EDGE then
		score = score + DRY_WEIGHT * (DRY_EDGE - humid) / DRY_EDGE
	end

	return score
end

local function far_from_other_spawns(x, z)
	local rpos = vector.new(x, 0, z)
	for _, ppos in pairs(internal_api.player_spawns) do
		if vector.distance(rpos, ppos) < internal_api.player_dist then
			return false
		end
	end
	return true
end

--- Find somewhere to drop a player, biased towards a survivable climate.
--
-- Rolls the wanted tier first, then rejects candidates from the other tier.
-- The rolls stay uniform over the whole world, so the brutal quarter is still
-- drawn from the real extremes -- it is only how often you land in one that
-- changes.
--
-- Falls back to the nearest miss rather than failing: an off-tier spawn beats
-- no spawn at all.
function internal_api.find_spawn_pos(player, attempts)
	local pcg = internal_api.get_rand(player)
	local want_harsh = pcg:next(1, 1000) <= HARSH_SHARE * 1000

	local best, best_score

	for _ = 1, attempts do
		local x = pcg:next(internal_api.min_dist, internal_api.max_dist)
		if pcg:next(1, 2) > 1 then x = -x end
		local z = pcg:next(internal_api.min_dist, internal_api.max_dist)
		if pcg:next(1, 2) > 1 then z = -z end

		if far_from_other_spawns(x, z) then
			local y = core.get_spawn_level(x, z)
			if y then
				local pos = vector.new(x, y, z)
				local score = internal_api.harshness(pos)

				if (score >= HARSH_SCORE) == want_harsh then
					return pos, score
				end

				if not best_score
						or (want_harsh and score > best_score)
						or (not want_harsh and score < best_score) then
					best, best_score = pos, score
				end
			end
		end
	end

	return best, best_score
end
