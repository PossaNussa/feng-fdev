-- Climate integration.
--
-- The funnel is an entity, but the storm around it is weather, so it is
-- registered with climate_api like everything else. That gets the sky merging,
-- the sound loop fades, the indoor checks and the particle wind-slant for free,
-- and it means /weather reports a supercell the same way it reports rain.

if not minetest.global_exists("climate_api") then
	minetest.log("warning", "[tornado] climate_api not found: no storm sky, "
		.. "sound or lightning. Funnels still work.")
	return
end

local DUST = "tornado_dust.png^[colorize:#4a4238:160"

local AMBIENT_SOUND = (minetest.get_modpath("regional_weather") and "weather_wind")
	or (minetest.get_modpath("sum_air_currents") and "sum_air_currents_wind_low01")
	or nil

-- level 1 watch, 2 warning, 3 the funnel is close
local SKY = {
	[1] = { base = { r = 78, g = 86, b = 66 }, cloud = "#3b4a30d0", thickness = 32, density = 0.9 },
	[2] = { base = { r = 58, g = 66, b = 46 }, cloud = "#2a3320e8", thickness = 48, density = 1.0 },
	[3] = { base = { r = 34, g = 38, b = 28 }, cloud = "#171c14f0", thickness = 64, density = 1.0 },
}

--------------------------------------------------------------------------------
-- the sky, which applies indoors too: a cellar with a window still shows the
-- light going wrong, and that is half the warning
--------------------------------------------------------------------------------

climate_api.register_weather("tornado:supercell_sky",
	function(env)
		return tornado.alert_level(env.player) > 0
	end,
	function(env)
		local level = tornado.alert_level(env.player)
		local sky = SKY[level] or SKY[1]
		-- keep some day/night response so a storm at night is not brighter
		-- than the night it is happening in
		local light = math.max((env.daylight or 15) / 15, 0.35)
		local ppos = env.player:get_pos() or vector.new(0, 0, 0)

		return {
			["climate_api:skybox"] = {
				sky_data = {
					type = "plain",
					clouds = true,
					base_color = {
						r = sky.base.r * light,
						g = sky.base.g * light,
						b = sky.base.b * light,
						a = 255,
					},
				},
				cloud_data = {
					color = sky.cloud,
					density = sky.density,
					thickness = sky.thickness,
					height = ppos.y + 90,
				},
				priority = 80 + level,
			},
		}
	end)

--------------------------------------------------------------------------------
-- everything you only get outdoors
--------------------------------------------------------------------------------

climate_api.register_weather("tornado:supercell",
	function(env)
		return tornado.alert_level(env.player) > 0 and not env.indoors
	end,
	function(env)
		local level = tornado.alert_level(env.player)
		local effects = {}

		if AMBIENT_SOUND then
			effects["climate_api:sound"] = {
				name = AMBIENT_SOUND,
				gain = ({ 0.5, 0.9, 1.4 })[level] or 0.5,
				pitch = ({ 0.9, 0.75, 0.6 })[level] or 0.9,
			}
		end

		-- lightning ramps hard once a warning is out; this is the same effect
		-- regional_weather uses, so its own chance multiplier still applies
		effects["regional_weather:lightning"] = ({ 1 / 25, 1 / 12, 1 / 6 })[level] or 1 / 25

		if level >= 2 then
			-- grit and leaf litter going past horizontally. climate_api slants
			-- these with the wind, which the event is currently forcing, so
			-- they blow the same way the funnel is travelling.
			effects["climate_api:particles"] = {
				boxsize = { x = 14, y = 5, z = 14 },
				v_offset = 2,
				amount = level == 3 and 34 or 18,
				expirationtime = 1.1,
				minsize = 4,
				maxsize = 10,
				minvel = { x = -2, y = -1, z = -2 },
				maxvel = { x = 2, y = 2, z = 2 },
				texture = DUST,
				collisiondetection = false,
			}
		end

		return effects
	end)
