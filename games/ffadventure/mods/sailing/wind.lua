-- Original functions from 'sailing'
local function generate_offset(mult)
  return (math.random() - 0.5) * mult
end

local function generate_next_wind()
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
  if wind_counter > wind_interval then
    wind.current_wind = wind.next_wind
    wind.next_wind = generate_next_wind()
    wind_counter = 0
  end
  wind.current_wind = {
    yaw = wind.current_wind.yaw + ((wind.next_wind.yaw - wind.current_wind.yaw) / wind_change_factor),
    mag = wind.current_wind.mag + ((wind.next_wind.mag - wind.current_wind.mag) / wind_change_factor)
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
minetest.register_globalstep(
  function(dtime)
    wind.timer=wind.timer+dtime
    if wind.timer >= wind.ttime then
      local yaw = minetest.dir_to_yaw(wind.wind)
      local yaw = yaw+math.random()-0.5
      wind.wind = vector.multiply(minetest.yaw_to_dir(yaw),10)
      wind.ttime = wind.timer+math.random()*5*60+1*60
    end
  end
)

-- Initialize variables from 'sailing_kit'
local yaw = math.random()*math.pi*2-math.pi
wind.wind = vector.multiply(minetest.yaw_to_dir(yaw),10)
wind.timer = 0
wind.ttime = math.random()*5*60+1*60