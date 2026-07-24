-- -------- --
--  CLOUDS  --
-- -------- --

core.register_node("cloudcraft:cloud",{
  description = "Cloud",
  drawtype = "glasslike",
  tiles = { "[fill:16x16:#F9F9F9F0" },
  use_texture_alpha = true,
  post_effect_color = "#F9F9F9F0",
  sunlight_propagates = true,
  paramtype = "light",
  is_ground_content = false,
  walkable = false,
  climbable = false,
  groups = {
    oddly_breakable_by_hand = 1,
    dig_immediate = 3,
  },
  drop = "cloudcraft:cloud",
  sounds = nil,
  after_place_node = function(pos, placer)
    if placer and placer:is_player() then
      local node = minetest.get_node(pos)
      node.param2 = 1
      minetest.set_node(pos, node)
    end
  end,
})

-- --------------- --
--  MAPGEN MARKER  --
-- --------------- --

core.register_node("cloudcraft:cloud_marker",{
  drawtype = "airlike",
  buildable_to = true,
  pointable = false,
  paramtype = "light",
  sunlight_propagates = true,
  groups = { not_in_creative_inventory = 1, fall_damage_add_percent = -100 },
  on_construct = function(pos)
    core.get_node_timer(pos):start(5)
  end,
  on_timer = function(pos)
    if core.get_node(pos).name == "cloudcraft:cloud_marker" then
      core.remove_node(pos)
    end
  end,
})

-- ---------------------- --
--  SPARSE CLOUD CLEANUP  --
-- ---------------------- --

local vc = vector.copy
core.register_abm({
  label = "Sparse Cloud Dispersal",
  nodenames = {"cloudcraft:cloud"},
  interval = 4,
  chance = 2,
  catch_up = false,
  action = function(pos)
    local at = core.get_node(pos)
    if at.param2 ~= 0 then
      return -- skip player-placed (1) and drift transient states (2, 3)
    end

    local npos = vc(pos)
    local not_cloud = 0
    for x = -1, 1, 1 do
      npos.x = pos.x + x
      for z = -1, 1, 1 do
        npos.z = pos.z + z
        if x == 0 or z == 0 then
          not_cloud = not_cloud + (core.get_node(npos).name ~= "cloudcraft:cloud" and 1 or 0)
        end
      end
      if not_cloud > 2 then
        core.set_node(pos,{ name = "air" })
        return
      end
    end
  end,
})

-- ------------------- --
--  WIND DRIFT ABM     --
-- ------------------- --

if cloudcraft.dependencies["climate_api"] then

  -- Cache the move decision for the current time window so all cloud nodes
  -- agree on whether to move this tick (prevents row desynchronisation).
  local move_cache = { tick = -1, should_move = false, dir = vector.new(0,0,0) }

  local function get_move_params(wind)
    local tick = math.floor(core.get_gametime() / 10)
    if tick ~= move_cache.tick then
      move_cache.tick = tick
      local speed = math.sqrt(wind.x * wind.x + wind.z * wind.z)
      local rng = PcgRandom(tick)
      move_cache.should_move = rng:next(0, 999) < math.min(speed / 3, 1) * 1000
      if math.abs(wind.x) >= math.abs(wind.z) then
        move_cache.dir = vector.new(wind.x > 0 and 1 or -1, 0, 0)
      else
        move_cache.dir = vector.new(0, 0, wind.z > 0 and 1 or -1)
      end
    end
    return move_cache.should_move, move_cache.dir
  end

  core.register_abm({
    label = "Cloud Wind Drift",
    nodenames = {"cloudcraft:cloud"},
    interval = 10,
    chance = 1,
    catch_up = false,
    action = function(pos, node)
      if node.param2 == 1 then return end  -- player-placed, skip

      -- param2=2: trailing edge marked last tick → remove now (prevents cascade)
      if node.param2 == 2 then
        core.remove_node(pos)
        return
      end

      -- param2=3: leading edge placed last tick → normalize so it doesn't
      -- chain-grow again this tick (both edges now run on the same 2-tick cadence)
      if node.param2 == 3 then
        core.set_node(pos, {name = "cloudcraft:cloud", param2 = 0})
        return
      end

      local wind = climate_api.environment.get_wind(pos)
      local should_move, dir = get_move_params(wind)
      if not should_move then return end

      local downwind = vector.add(pos, dir)
      local upwind   = vector.subtract(pos, dir)

      -- Leading edge: grow into air downwind, tagged param2=3 so it waits one
      -- tick before becoming a normal node (preventing same-tick chain growth).
      if minetest.get_node(downwind).name == "air" then
        minetest.set_node(downwind, {name = "cloudcraft:cloud", param2 = 3})
      end
      -- Trailing edge: mark for removal next tick so neighbours still see a
      -- cloud this tick and no cascade removal occurs.
      if minetest.get_node(upwind).name ~= "cloudcraft:cloud" then
        core.set_node(pos, {name = "cloudcraft:cloud", param2 = 2})
      end
    end,
  })

end
