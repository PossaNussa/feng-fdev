-- Instead of directly using vector, store the wind as a table with yaw and mag
local function generate_next_wind()
  return {
    yaw = math.random() * 2 * math.pi,
    mag = math.random() * 15
  }
end
-- Add this to sailing_kit-master/wind.lua
local function generate_offset(mult)
  return (math.random() - 0.5) * mult
end
-- Convert wind table to vector when needed
local function wind_to_vector(wind)
  return vector.multiply(minetest.yaw_to_dir(wind.yaw), wind.mag)
end

-- Modify the modify_wind function to maintain this structure
local function modify_wind(dtime)
  -- [Existing logic for dtime, wind.counter, and wind.timer]

  if wind.counter >= wind.interval then
    wind.current_wind = wind.next_wind
    wind.next_wind = generate_next_wind()
    wind.counter = 0
  else
    local yaw_current = wind.current_wind.yaw
    local yaw_next = wind.next_wind.yaw
    local yaw = yaw_current + ((yaw_next - yaw_current) / wind.change_factor)

    local mag_current = wind.current_wind.mag
    local mag_next = wind.next_wind.mag
    local mag = mag_current + ((mag_next - mag_current) / wind.change_factor)

    wind.current_wind.yaw = yaw
    wind.current_wind.mag = mag
  end

  -- [Existing logic for wind.timer and ttime]
end

-- Now, modify the show_wind function to use wind_to_vector
function show_wind(pos, rand, player_name)
  if math.random() < rand then
    local random_pos = {
      x = pos.x + generate_offset(5),
      y = pos.y + generate_offset(5),
      z = pos.z + generate_offset(5)
    }
    local wind_vec = wind_to_vector(wind.current_wind)
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