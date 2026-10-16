-- Seasonal grass colour, via always_greener's existing palette machinery.
--
-- always_greener overrides default:dirt_with_grass with paramtype2 = "color"
-- and a 16x16 palette indexed as (16 * humidity_step + heat_step), and it
-- already runs an ABM ("Grass Color Update", interval 30 / chance 10) that
-- recolours every grass node continuously by calling awg.get_biome_color.
--
-- So wrapping that one function makes the entire loaded world repaint itself
-- seasonally, with no node sweeping of our own. The same wrap also covers
-- always_greener:dirt_with_dead_grass, footprints:dirt_with_grass, grass
-- spread and grass placement, because they all call it too.
--
-- Palette axes, sampled from awg_grass_colormap.png:
--   row 15 (wettest): #0b351c -> #316a1a   deep saturated green
--   row  8 (mid):     #2c6538 -> #9b9642   healthy green to olive
--   row  0 (driest):  #497b5b -> #988463   grey-green, olive, dusty tan
-- Falling humidity is the browning axis, which is exactly what autumn needs.

local S = seasons.settings

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

--------------------------------------------------------------------------------
-- The seasonal bias
--------------------------------------------------------------------------------

--- Seasonal humidity delta in raw humidity units (the 0-100 scale), before any
-- per-position damping. Negative is drier, i.e. browner.
--
-- Position-independent so it can be published to the mapgen environment over
-- IPC. clock.lua calls this on every refresh.
function seasons.get_grass_humidity_delta()
	if not S.enabled or not S.grass_color then return 0 end

	local foliage = seasons.get_foliage()      -- 0 green .. 1 brown
	local warmth = seasons.get_warmth()        -- -1 .. 1

	-- Asymmetric on purpose: summer grass should read as lusher, but not as
	-- dark as rainforest, so the upward push is much smaller than the drying.
	local lush = 12 * math.max(0, warmth) * (1 - foliage)
	local dry = S.grass_dry_amount * foliage

	return lush - dry
end

--- Tropical damping, shared with the mapgen-side copy in always_greener.
-- Grass in a rainforest stays green all year.
function seasons.grass_latitude_weight(heat)
	return clamp((85 - heat) / 45, 0, 1)
end

--------------------------------------------------------------------------------
-- The wrap
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not S.enabled or not S.grass_color then return end
	if not minetest.get_modpath("always_greener") then return end
	if not minetest.global_exists("awg") or type(awg.get_biome_color) ~= "function" then
		minetest.log("warning",
			"[seasons] awg.get_biome_color missing; skipping seasonal grass colour")
		return
	end

	local orig = awg.get_biome_color

	-- Shift the packed index rather than reimplementing awg's ~25 lines of
	-- altitude-chill and water-proximity logic. Unpacking loses no information:
	-- those terms are already baked into the index by the time we see it. The
	-- only cost is that the shift quantises to whole palette steps, which is
	-- imperceptible on a smooth 16-step gradient.
	awg.get_biome_color = function(pos)
		local idx = orig(pos)

		local delta = seasons.get_grass_humidity_delta()
		if delta == 0 then return idx end

		local lat = seasons.grass_latitude_weight(minetest.get_heat(pos))
		-- 16 palette rows spanning 100 humidity units.
		local steps = math.floor(delta * lat * 16 / 100 + 0.5)
		if steps == 0 then return idx end

		local heat_step = idx % 16
		local hum_step = clamp(math.floor(idx / 16) + steps, 0, 15)
		return hum_step * 16 + heat_step
	end

	minetest.log("action", "[seasons] always_greener grass colour is now seasonal")
end)
