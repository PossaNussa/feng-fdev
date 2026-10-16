-- Wind for both boat mods in this game.
--
-- This file feeds two separate consumers with two separate representations, and
-- until now they were two independent random walks -- so a canoe and a sailboat
-- side by side felt different wind at the same moment:
--   * wind.current_wind = {yaw, mag}  -- sailing's own canoe, via util.lua
--   * wind.wind         = vector      -- sailing_kit-master/init.lua:41
--
-- Both now derive from climate_api's wind field, which is also what the weather
-- particle slant, the storm/fog windspeed gates, airutils, cloudcraft's cloud
-- drift and sum_air_currents all read. Each keeps its own magnitude range and
-- its own smoothing, so neither boat handles differently than before -- they
-- just finally agree with each other and with the visible weather.

local CANOE_MAG = 15  -- sailing's own range, previously math.random() * 15
local KIT_MAG   = 10  -- sailing_kit's range, previously a constant 10

-- Field magnitude that reads as a full gale. Shared default with
-- sum_air_currents so the two cannot disagree about what "windy" means.
local WIND_REFERENCE = tonumber(minetest.settings:get("wind_field_reference")) or 2.0
local field_origin = vector.new(0, 0, 0)

-- Returns gust (0..1) and yaw, or nil when there is no field to read.
-- Sampled at y = 0: environment.get_wind scales by a sigmoid in pos.y, and this
-- is a single global wind, so it takes the base field. airutils/wind.lua does
-- the same.
local function read_gust()
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
  local gust = math.min(math.max(mag / WIND_REFERENCE, 0), 1)
  return gust, minetest.dir_to_yaw(w)
end

-- Rewrite `from` as the equivalent angle within pi of `to`, so interpolation
-- takes the short way round. The field's heading walks continuously and crosses
-- the 0/2pi seam, where lerping 6.2 -> 0.1 swings a boat all the way back
-- through south instead of nudging it forward.
local function unwrap_towards(from, to)
  local d = (to - from) % (2 * math.pi)
  if d > math.pi then d = d - 2 * math.pi end
  return to - d
end

-- Original functions from 'sailing'
local function generate_offset(mult)
  return (math.random() - 0.5) * mult
end

local function generate_next_wind()
  local gust, yaw = read_gust()
  if gust then
    -- yaw is nil only in dead calm, which has no heading of its own; any is fine
    -- at magnitude zero.
    return { yaw = yaw or (math.random() * 2 * math.pi), mag = gust * CANOE_MAG }
  end
  -- No climate_api. Original behaviour, unchanged.
  return {
    yaw = math.random() * 2 * math.pi,
    mag = math.random() * 15
  }
end

wind.current_wind = generate_next_wind()

local wind_interval = 60 * 20
local wind_counter = 0
local wind_change_factor = 4
wind.next_wind = generate_next_wind()

local function modify_wind()
  local gust, yaw = read_gust()
  if gust then
    -- Track the field every tick and let the lerp below smooth it. wind_interval
    -- only ever existed to stop a fresh random target from snapping the wind
    -- around; the field moves slowly on its own, so holding a stale target for
    -- 20 minutes would just make the boats lag the visible weather.
    --
    -- A nil yaw is dead calm: hold the current heading and let the magnitude
    -- fall to zero, rather than falling through to a random direction.
    wind.next_wind = { yaw = yaw or wind.next_wind.yaw, mag = gust * CANOE_MAG }
  elseif wind_counter > wind_interval then
    wind.current_wind = wind.next_wind
    wind.next_wind = generate_next_wind()
    wind_counter = 0
  end

  local cur, nxt = wind.current_wind, wind.next_wind
  local from_yaw = unwrap_towards(cur.yaw, nxt.yaw)
  wind.current_wind = {
    yaw = from_yaw + ((nxt.yaw - from_yaw) / wind_change_factor),
    mag = cur.mag + ((nxt.mag - cur.mag) / wind_change_factor)
  }
  wind_counter = wind_counter + 1
  minetest.after(1, modify_wind)
end

modify_wind()

function show_wind(pos, rand, player_name)
  if math.random() < rand then
    local random_pos = {
      x = pos.x + generate_offset(5),
      y = pos.y + generate_offset(5),
      z = pos.z + generate_offset(5)
    }
    local wind_vec = wind_to_vec()
    minetest.add_particle({
          pos = random_pos,
          velocity = {x=wind_vec.x, y=0, z=wind_vec.z},
          expirationtime = 3,
          size = 1,
          texture = "wind.png",
          playername = player_name,
          glow = 5
      })
    end
end

-- Additional globalstep functionality from 'sailing_kit'
--
-- wind.wind had a constant magnitude of 10, so unlike current_wind it could
-- never becalm a sailing_kit boat. Keep a floor rather than let a lull strand
-- one mid-ocean: the wind now varies where it did not before, and being unable
-- to move at all is a worse experience than sailing slowly.
local KIT_FLOOR = 0.35
local field_poll = 0

minetest.register_globalstep(
  function(dtime)
    wind.timer = wind.timer + dtime

    -- Throttle before touching the field, not after: this runs every frame, and
    -- read_gust is a pcall plus two mod-storage reads. Once a second is plenty
    -- either way -- the field is slow, and ttime below is 60-360 seconds.
    field_poll = field_poll + dtime
    if field_poll < 1 then return end
    field_poll = 0

    local gust, yaw = read_gust()
    if gust then
      -- A nil yaw is dead calm; hold the last heading.
      if yaw then
        local mag = KIT_MAG * math.max(gust, KIT_FLOOR)
        wind.wind = vector.multiply(minetest.yaw_to_dir(yaw), mag)
      end
      return
    end

    -- No climate_api. Original behaviour, unchanged.
    if wind.timer >= wind.ttime then
      local y = minetest.dir_to_yaw(wind.wind)
      y = y + math.random() - 0.5
      wind.wind = vector.multiply(minetest.yaw_to_dir(y), KIT_MAG)
      wind.ttime = wind.timer + math.random()*5*60 + 1*60
    end
  end
)

-- Initialize variables from 'sailing_kit'
local yaw = math.random()*math.pi*2-math.pi
wind.wind = vector.multiply(minetest.yaw_to_dir(yaw),10)
wind.timer = 0
wind.ttime = math.random()*5*60+1*60