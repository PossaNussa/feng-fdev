local S = minetest.get_translator(minetest.get_current_modname())

sum_air_currents = {
  enabled = true,
  -- constants
  max_wind_speed = 20, -- maxiumum speed of wind unless changed with commands
  max_player_push = 30,
  wind_change_mult = 1, -- how fast the wind gets up to speed
  stillness_chance = 0.5, -- chance that the wind will decide to stay 0 this time
  player_particles_threshold = 0.3, -- minimum wind speed to spawn wind particles
  -- realtime vars (DONT CHANGE THESE)
  wind_yaw = 3.14, -- affects dir
  wind_dir = vector.new(0,0,0), -- dir of the yaw
  wind_speed = 0, -- wind speed currently (pun unintended)
  wind = vector.new(0,0,0), -- ACTUAL wind, as calculated with wind_dir and wind_speed
  calm_cycle = false, -- stillness roll won this cycle; don't refresh from the field
  manual_speed = false, -- /wind <speed> is holding; don't refresh from the field
  -- for interpolation
  new_wind_yaw = 3.14, -- affects dir
  new_wind_dir = vector.new(0,0,0), -- dir of the yaw
  new_wind_speed = 0, -- wind speed currently (pun unintended)
  --
  old_wind_yaw = 3.14, -- affects dir
  old_wind_dir = vector.new(0,0,0), -- dir of the yaw
  old_wind_speed = 0, -- wind speed currently (pun unintended)
  -- enables features (setting them here does nothing)
  do_player_particles = false,
  do_push_entities = false,
  do_push_players = false,
  is_wind_predictable = false,
}

local ac = sum_air_currents

dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "utility_functions.lua")
dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "api.lua")
dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "sound.lua")
dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "particles.lua")
dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "commands.lua")
dofile(minetest.get_modpath("sum_air_currents") .. DIR_DELIM .. "items.lua")

-- load settings
ac.max_wind_speed = tonumber(minetest.settings:get("wind_max_speed") or ac.max_wind_speed)
ac.max_player_push = tonumber(minetest.settings:get("wind_max_player_push") or ac.max_player_push)
ac.wind_change_mult = tonumber(minetest.settings:get("wind_change_mult") or ac.wind_change_mult)
ac.stillness_chance = tonumber(minetest.settings:get("wind_stillness_chance") or ac.stillness_chance)
ac.do_player_particles = minetest.settings:get_bool("wind_player_particles") ~= false
ac.do_push_players = minetest.settings:get_bool("wind_push_players") ~= false
ac.do_push_entities = minetest.settings:get_bool("wind_push_entities") ~= false
ac.is_wind_predictable = minetest.settings:get_bool("wind_predictable") ~= false
ac.sound_system.gain = tonumber(minetest.settings:get("wind_volume") or 1)

local clamp = function(num, min, max)
  return (math.min(math.max(num, min), max))
end

local globalstep_timer = 1 -- start immediately
ac.timers = {
  change_dir = {time = 0, trigger = 20, func = nil, trigger_min = 30, trigger_max = 300},
}
-- load timer settings
ac.timers.change_dir.trigger_min = tonumber(minetest.settings:get("wind_change_time_min") or ac.timers.change_dir.trigger_min)
ac.timers.change_dir.trigger_max = tonumber(minetest.settings:get("wind_change_time_max") or ac.timers.change_dir.trigger_max)


-- The shared wind field.
--
-- climate_api's wind is the only coherent one in the game: a perlin walk over
-- time, persisted across restarts, already read by airutils, cloudcraft's cloud
-- drift, the weather particle slant, and the min_windspeed/max_windspeed gates
-- on storm, sandstorm, hail, pollen and fog. Taking direction and strength from
-- it makes this mod's particles, push and sound agree with all of that instead
-- of contradicting it.
--
-- Only a yaw and a normalised 0..1 gust are taken; the speed is rescaled to
-- ac.max_wind_speed below. That matters: the field's own magnitude runs about
-- 0..2.8 while this mod is tuned against 0..10, so feeding it in raw would leave
-- the particles below player_particles_threshold and the push imperceptible.
-- Rescaling keeps every threshold in this mod meaningful.
--
-- Sampled at y = 0 because this is a single global wind, while
-- environment.get_wind multiplies by a sigmoid in pos.y. At y = 0 that sigmoid
-- is 0.99, so this is the base field essentially unmodified.
-- airutils/wind.lua samples the same way for the same reason.
local WIND_REFERENCE = tonumber(minetest.settings:get("wind_field_reference")) or 2.0
local field_origin = vector.new(0, 0, 0)

-- Returns gust (0..1) and yaw, or nil when there is no field to read.
-- A yaw of nil means dead calm, which is a real reading but carries no heading.
local function read_wind_field()
  if not minetest.global_exists("climate_api")
      or type(climate_api.environment) ~= "table"
      or type(climate_api.environment.get_wind) ~= "function" then
    return nil
  end
  local ok, w = pcall(climate_api.environment.get_wind, field_origin)
  if not ok or type(w) ~= "table" or not w.x or not w.z then
    return nil
  end
  local mag = math.sqrt(w.x * w.x + w.z * w.z)
  if mag <= 0 then return 0, nil end
  return clamp(mag / WIND_REFERENCE, 0, 1), minetest.dir_to_yaw(w)
end

-- Rewrite `from` as the equivalent angle within pi of `to`, so that the linear
-- interpolation in ac.interpolate() takes the short way round. This did not
-- matter while yaws were random, but the field's heading walks continuously and
-- will cross the 0/2pi seam, where lerping 6.2 -> 0.1 swings the wind all the
-- way back through south instead of nudging it forward.
local function unwrap_towards(from, to)
  local d = (to - from) % (2 * math.pi)
  if d > math.pi then d = d - 2 * math.pi end
  return to - d
end

-- Pull the current field reading into new_wind_*. False when there is no field,
-- so callers can fall back to the original behaviour.
local function apply_field()
  local gust, yaw = read_wind_field()
  if not gust then return false end
  ac.new_wind_speed = gust * ac.max_wind_speed
  -- A nil yaw is dead calm, which has no heading; hold the last one.
  if yaw then
    ac.old_wind_yaw = unwrap_towards(ac.old_wind_yaw, yaw)
    ac.new_wind_yaw = yaw
  end
  return true
end

sum_air_currents.get_new_wind_direction = function()
  ac.old_wind_yaw = ac.new_wind_yaw
  ac.old_wind_dir = ac.new_wind_dir
  ac.old_wind_speed = ac.new_wind_speed
  ac.manual_speed = false
  --
  -- The stillness roll comes first and is untouched: half of all direction
  -- changes currently pick dead calm, and those lulls are a large part of how
  -- this mod feels.
  if math.random(0, 100)/100 < ac.stillness_chance then
    ac.new_wind_speed = 0
    ac.calm_cycle = true
    return
  end
  ac.calm_cycle = false

  -- The shared field wins over is_wind_predictable when it is available.
  --
  -- That looks like overriding a setting, so: wind_predictable exists to make
  -- wind "easier to navigate" by stepping it around in fixed ~86 degree
  -- increments, which was worth having only because the alternative was pure
  -- noise. The field is smooth, continuous, persisted, shared with the weather
  -- and readable with /set_wind -- navigable in the way the setting was reaching
  -- for, and consistent with what the sails and the rain are doing. Stepping it
  -- would only reintroduce the disagreement this is meant to remove.
  if apply_field() then
    -- nothing more to do; the field supplied both heading and strength
  elseif ac.is_wind_predictable then
    ac.new_wind_yaw = (ac.new_wind_yaw + (math.pi / 2.1)) % (math.pi * 2)
    ac.new_wind_speed = (ac.new_wind_speed + ac.max_wind_speed * 1.6) % ac.max_wind_speed
  else
    -- No climate_api. Original behaviour, unchanged.
    ac.new_wind_yaw = math.random(0, 100) * math.pi * 2 / 100
    ac.new_wind_speed = (math.random(0, ac.max_wind_speed*100) / 100)
  end
end

minetest.register_on_mods_loaded(function()
  if read_wind_field() then
    minetest.log("action", "[sum_air_currents] wind follows the climate_api field"
      .. (ac.is_wind_predictable and " (wind_predictable ignored: the field is already continuous)" or ""))
  else
    minetest.log("action", "[sum_air_currents] no climate_api wind field; using "
      .. (ac.is_wind_predictable and "the predictable pattern" or "random wind"))
  end
end)


sum_air_currents.timers.change_dir.func = function()
  ac.get_new_wind_direction()

  ac.timers.change_dir.time = 0

  ac.interpolate()
end


sum_air_currents.override_wind = function(wind_speed)
  ac.old_wind_speed = wind_speed
  ac.new_wind_speed = wind_speed
  ac.wind_speed = wind_speed
  -- Hold against the per-second field refresh, or `/wind 7` would be gone again
  -- a second later. Released by the next direction change, including `/wind
  -- change`, exactly as it used to expire on the next change_dir tick.
  ac.manual_speed = true
end


-- updates the dir and sped and wind values
sum_air_currents.update_values = function()
  ac.wind_dir = minetest.yaw_to_dir(ac.wind_yaw)
  ac.wind = vector.multiply(ac.wind_dir, ac.wind_speed)
end


-- interpolate between current wind and the next wind change
sum_air_currents.interpolate = function()
  -- ratio 0 : just started counting
  -- ratio 1 : finished counting
  -- ratio 0.1 : 10% through counting
  local r = math.min((ac.timers.change_dir.time / ac.timers.change_dir.trigger) * 5, 1)
  ac.wind_yaw = ac.old_wind_yaw * (1-r) + ac.new_wind_yaw * (r)
  ac.wind_speed = ac.old_wind_speed * (1-r) + ac.new_wind_speed * (r)
  ac.update_values()
end


sum_air_currents.on_step = function(dtime)
  if not ac.enabled then return end
  -- only do it once a second
  if globalstep_timer > 1 then
    globalstep_timer = globalstep_timer - 1
    for _, timer in pairs(ac.timers) do
      timer.time = timer.time + 1
      if timer.func ~= nil
      and timer.time >= timer.trigger then
        timer.trigger = math.random(timer.trigger_min, timer.trigger_max)
        timer.func()
      end
    end
  else
    globalstep_timer = globalstep_timer + dtime
    return
  end
  -- the rest will happen once per sec

  -- Track the field between direction changes, so /set_wind and the weather's
  -- own gusts show up within a second instead of waiting out the 30-300 second
  -- change_dir timer. Skipped during a calm cycle: the stillness roll picks dead
  -- air for a whole cycle, and refreshing here would blow those lulls away one
  -- second after they start.
  if not ac.calm_cycle and not ac.manual_speed then
    apply_field()
  end

  -- interpolate between the values of old and new
  ac.interpolate()
end


minetest.register_globalstep(sum_air_currents.on_step)

ac.get_new_wind_direction()
ac.get_new_wind_direction()
ac.override_wind(0)
