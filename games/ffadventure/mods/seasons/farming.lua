-- Seasonal crop growth.
--
-- farming's own climate gate, climate_factor(), is duplicated verbatim as a
-- `local function` in both farming/init.lua and farming/api.lua, so neither copy
-- can be patched. But both of its CALLERS are globals, and an extra
-- probabilistic skip is semantically identical to editing the gate itself -- so
-- no edit to farming is needed.

local S = seasons.settings

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

--- Growth multiplier at a position: below 1 slows growth, above 1 speeds it.
-- Composes multiplicatively with farming's own biome gate, which we leave alone.
function seasons.crop_growth_factor(pos)
	if not S.enabled or not S.farming then return 1.0 end
	-- Grassland swings roughly +/-17 heat units, so winter lands near 0.3
	-- (a real stall) and summer clamps at a modest bonus.
	return clamp(1.0 + seasons.get_heat_offset(pos) / 25, 0.15, 1.25)
end

minetest.register_on_mods_loaded(function()
	if not S.enabled or not S.farming then return end
	if not minetest.get_modpath("farming") then return end
	if not minetest.global_exists("farming") then return end

	--------------------------------------------------------------------------
	-- farming.plant_growth_timer  (farming/init.lua)
	--------------------------------------------------------------------------
	-- Called via a late global lookup, so a plain wrapper is enough.
	-- Returning true means "retry later", matching how its own climate gate
	-- signals a skipped tick.
	if type(farming.plant_growth_timer) == "function" then
		local orig_timer = farming.plant_growth_timer
		farming.plant_growth_timer = function(pos, elapsed, node_name)
			local f = seasons.crop_growth_factor(pos)
			if f < 1 and math.random() > f then
				return true
			end
			return orig_timer(pos, elapsed, node_name)
		end
	end

	--------------------------------------------------------------------------
	-- farming.grow_plant  (farming/api.lua)
	--------------------------------------------------------------------------
	if type(farming.grow_plant) == "function" then
		local orig_grow = farming.grow_plant

		farming.grow_plant = function(pos, elapsed)
			local f = seasons.crop_growth_factor(pos)
			if f < 1 and math.random() > f then
				-- Mirrors farming's own tick_again(): retry in 40-80s.
				minetest.get_node_timer(pos):start(math.random(40, 80))
				return
			end
			return orig_grow(pos, elapsed)
		end

		-- farming stores on_timer = farming.grow_plant BY VALUE in every crop
		-- definition, so wrapping the global alone would change nothing. The
		-- same by-value trap as climate_api's heat influence.
		local repointed = 0
		for name, def in pairs(minetest.registered_nodes) do
			if def.on_timer == orig_grow then
				minetest.override_item(name, {on_timer = farming.grow_plant})
				repointed = repointed + 1
			end
		end

		minetest.log("action",
			"[seasons] seasonal crop growth enabled (" .. repointed .. " crops re-pointed)")
	end
end)
