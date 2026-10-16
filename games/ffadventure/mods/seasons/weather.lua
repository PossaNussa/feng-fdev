-- Season-aware weather.
--
-- The seasonal heat shift already does the real work: regional_weather's
-- rain-vs-snow split is nothing but a heat threshold. What is left here is
-- guard-rails against climate_api's perlin randomness -- it should never snow
-- in high summer no matter how the noise falls -- plus exposing the season so
-- any other mod can condition on it.

local S = seasons.settings

--------------------------------------------------------------------------------
-- Influences
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not S.enabled or not S.weather then return end
	if not minetest.get_modpath("climate_api") then return end
	if not minetest.global_exists("climate_api") then return end

	-- climate_api's condition evaluator applies its min_/max_/has_/not_ prefixes
	-- to ANY registered influence name, so registering these is all that is
	-- needed for presets to be able to say has_season = {"winter"}.
	climate_api.register_global_influence("season", function()
		return (seasons.get_season())
	end)
	climate_api.register_global_influence("season_warmth", seasons.get_warmth)
	climate_api.register_global_influence("season_phase", function()
		return seasons.get_day_of_year() / seasons.YEAR_DAYS
	end)

	--------------------------------------------------------------------------
	-- Preset gating
	--------------------------------------------------------------------------

	-- climate_mod.weathers[name].conditions is looked up fresh on every
	-- evaluation, so adding keys to it in place gates the preset with no edit to
	-- regional_weather at all.
	local function gate(preset, extra)
		local cfg = climate_mod.weathers[preset]
		if not cfg then return false end

		if type(cfg.conditions) == "function" then
			-- A few presets (ambient, storm, fog, sandstorm) use the function
			-- form. Wrap rather than mutate.
			local orig = cfg.conditions
			cfg.conditions = function(env)
				if not orig(env) then return false end
				for cond, goal in pairs(extra) do
					if not climate_mod.trigger.test_condition(cond, env, goal) then
						return false
					end
				end
				return true
			end
		else
			for cond, goal in pairs(extra) do
				cfg.conditions[cond] = goal
			end
		end
		return true
	end

	local applied = {}

	-- Pollen is a spring thing, not a year-round one.
	if gate("regional_weather:pollen", {has_season = {"spring"}}) then
		table.insert(applied, "pollen=spring")
	end

	-- Hard guard: never snow in high summer, whatever the noise says.
	for _, p in ipairs({"regional_weather:snow", "regional_weather:snow_heavy",
			"regional_weather:hail"}) do
		if gate(p, {not_season = {"summer"}}) then
			table.insert(applied, p:gsub("^regional_weather:", "") .. "!=summer")
		end
	end

	minetest.log("action", "[seasons] weather gating: " ..
		(#applied > 0 and table.concat(applied, ", ") or "no presets matched"))
end)
