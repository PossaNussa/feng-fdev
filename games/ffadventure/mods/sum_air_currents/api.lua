local S = minetest.get_translator(minetest.get_current_modname())

local ac = sum_air_currents

-- gets just the wind speed
ac.get_wind_speed = function()
  return ac.wind_speed
end


ac.get_wind_speed_at = function(p)
  if ac.get_light(p) == 15 then
    return ac.wind_speed
  else return 0 end
end


-- gets just the wind direction if not zero
ac.get_wind_dir = function()
  if ac.wind_speed ~= 0 then
    return ac.wind_dir
  else
    return vector.new(0,0,0)
  end
end


-- go some distance and tell if there are solid nodes there
ac.get_node_dist = function(p, direction, nodes)
  -- go 10 nodes in the wind direction to look for nodes
  local pos = {x=p.x, y=p.y, z=p.z}
  -- Copy: this used to assign straight into the caller's vector, so passing
  -- ac.wind_dir in would have tilted the global wind field permanently.
  local dir = {x=direction.x, y=0.2, z=direction.z} -- go up at a slight angle
  for i=1, nodes do
    pos = vector.add(pos, dir)
    local node = minetest.get_node(pos).name
    local ndef = minetest.registered_nodes[node]
    -- An unknown node (mod removed since the world was built) has no
    -- definition; treat it as solid rather than indexing nil, which would
    -- abort the globalstep for every player on the server.
    if not ndef or ndef.walkable then
      return i
    end
  end
  return nodes
end


-- Is this position sheltered from the sky?
--
-- This has to mean the same thing here as it does to the weather and
-- temperature mods, or the player gets shoved around inside a building that
-- regional_weather and tempsurvive both agree is indoors. climate_api owns the
-- canonical test -- natural light below 14, or any non-air node in the column
-- above -- so borrow it when climate_api is loaded and mirror it when not.
--
-- `pos` is tested directly. climate_api's influence samples one node above
-- whatever it is handed, so it gets pos - (0,1,0) to land back on `pos`.
local CEILING_CHECKS = 10
ac.is_indoors = function(pos)
  if climate_mod and climate_mod.influences
      and type(climate_mod.influences.indoors) == "function" then
    local ok, indoors = pcall(climate_mod.influences.indoors,
      vector.subtract(pos, {x = 0, y = 1, z = 0}))
    if ok and indoors ~= nil then
      return indoors
    end
  end

  -- 14 rather than 15 on purpose, same as climate_api: walking under a single
  -- overhanging node should not flap the wind on and off.
  if (minetest.get_natural_light(pos, 0.5) or 0) < 14 then
    return true
  end
  local checks = (climate_mod and climate_mod.settings
    and climate_mod.settings.ceiling_checks) or CEILING_CHECKS
  for i = 1, checks do
    local node = minetest.get_node_or_nil(
      {x = pos.x, y = pos.y + i, z = pos.z})
    if node ~= nil and node.name ~= "air" and node.name ~= "ignore" then
      return true
    end
  end
  return false
end


-- get the wind as a vector
ac.get_wind = function(pos)
  if not ac.enabled then return vector.new(0,0,0) end
  local light = ac.get_light(pos)
  if light == 15 then
    return ac.wind
  end
  return vector.new(0,0,0)
end


-- DO NOT USE FOR MANY OBJECTS. DON'T FORGET THE PASSWORD.
ac.get_wind_expensive = function(p, password)
  if not ac.enabled
  or password ~= "This function call is laggy." then
    return {
      vector = vector.new(),
      speed = 0,
      strength = 0,}
  end
  -- Was `ac.get_light(p) < 1`, i.e. only pitch darkness counted as sheltered.
  -- Any room with daylight leaking in through a door or window still took the
  -- full push, which is why wind kept shoving players indoors while the
  -- particles (gated on light == 15) correctly stayed outside.
  if ac.is_indoors(p) then
    return {
      vector = vector.new(),
      speed = 0,
      strength = 0,}
  else
    local wind_strength = ac.get_node_dist(p, vector.multiply(ac.wind_dir, -1), 10)
    -- wind_strength = math.max(wind_strength - 0.5, 0) * 2
    if wind_strength and wind_strength > 0 then
      wind_strength = wind_strength / 10
      return {
        vector = vector.multiply(ac.wind_dir, wind_strength * ac.wind_speed),
        speed = wind_strength * ac.wind_speed,
        strength = wind_strength,}
    end
  end
  return {
    vector = vector.new(),
    speed = 0,
    strength = 0,}
end


-- apply the wind to an existing velocity
ac.apply_wind = function(vel, pos)
  if not ac.enabled then return vel end
  if not ac.do_push_entities then return vel end
  return vector.add(vel, ac.get_wind(pos))
end


-- get the light level to determine if you can have wind or not
ac.get_light = function(pos)
  local ret = 0
  if minetest.get_natural_light then
    ret = minetest.get_natural_light(pos, 0.5)
  else
    ret = minetest.get_light(pos, 0.5)
    -- so that we can use get_natural_light < 10 eg.
    if ret and ret < 15 then ret = 1 end
  end
  if not ret then ret = 0 end
  return ret
end