local ai_module = {}

function ai_module.chase_and_attack(self)
  local player = self.object:get_luaentity().player
  if player then
    local pos = self.object:get_pos()
    local player_pos = player:get_pos()
    local dir = vector.normalize(vector.subtract(player_pos, pos))
    local speed = 1.0 -- adjust for desired speed

    self.object:set_velocity({x = dir.x * speed, y = dir.y, z = dir.z * speed})

    local dist = vector.distance(pos, player_pos)
    if dist < 2 then  -- change to desired attack distance
      -- Punch logic here
      local tool_capabilities = {
        full_punch_interval = 1.0,
        damage_groups = {fleshy = 5},
      }
      player:punch(self.object, 1.0, tool_capabilities)
    end
  end
end

function ai_module.search_and_attack_mobs(self)
  local all_objects = minetest.get_objects_inside_radius(self.object:get_pos(), 10)
  for _, obj in pairs(all_objects) do
    if obj:get_luaentity() and obj:get_luaentity().name ~= self.name then
      -- Move towards mob logic
      local pos = self.object:get_pos()
      local mob_pos = obj:get_pos()
      local velocity = {x = mob_pos.x - pos.x, y = mob_pos.y - pos.y, z = mob_pos.z - pos.z}
      self.object:set_velocity(velocity)
      
      -- Deal damage logic
      local tool_capabilities = {
        full_punch_interval = 0.8,
        damage_groups = {fleshy = 5},
      }
      local time_since_last_punch = tool_capabilities.full_punch_interval
      obj:punch(self.object, time_since_last_punch, tool_capabilities)
      break
    end
  end
end


function ai_module.wander(self)
  local speed = 5.0 -- increased speed
  local angle = math.random() * 2 * math.pi
  local dir = {x = math.cos(angle), y = 0, z = math.sin(angle)}
  self.object:set_velocity({x = dir.x * speed, y = dir.y, z = dir.z * speed})
  
  local yaw = math.atan2(dir.x, dir.z) + math.pi
  self.object:set_yaw(yaw) -- set yaw to make the Yeti face the direction

  -- Switch to idle state after 30 seconds
  minetest.after(30, function()
    if self.object and self.object:get_luaentity() then
      self.object:get_luaentity().state = "idle"
    end
  end)
end

function ai_module.idle(self)
  local current_yaw = self.object:get_yaw()

  -- Rotate the Yeti to simulate looking around
  local new_yaw = current_yaw + (math.random() - 0.5) * 0.3
  self.object:set_yaw(new_yaw)

  local pos = self.object:get_pos()
  local players = minetest.get_connected_players()
  local watched_player = nil

  -- Detect players and rotate towards them
  for _, player in ipairs(players) do
    local player_pos = player:get_pos()
    local dist = vector.distance(pos, player_pos)
    if dist < 15 then  -- 15 'nodes' worth of awareness
      watched_player = player
      local angle_to_player = math.atan2(player_pos.x - pos.x, player_pos.z - pos.z)
      self.object:set_yaw(angle_to_player)
      break
    end
  end

  -- Switch to the chase_and_attack state if a player was watched
  minetest.after(30, function()
    if self.object and self.object:get_luaentity() then
      if watched_player then
        self.object:get_luaentity().state = "chase_and_attack"
        self.object:get_luaentity().player = watched_player
      else
        self.object:get_luaentity().state = "wander"
      end
    end
  end)
end

return ai_module