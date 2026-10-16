local mod_name = "adaptive_crosshair"

local idle_opacity = 60      -- 0 - 255
local normal_opacity = 165   -- 0 - 255
local interact_opacity = 125 -- 0 - 255
local correct_tool_color = "#39FF14"
local wrong_tool_color = "#f90000"
local color_alpha = "145" -- 0 - 255

---@enum crosshairs
local crosshairs = {
  clear = "clear",
  default = "default",
  place = "place",
  mine = "mine",
  interact = "interact",
  use = "use",
  use_self = "use_self",
  mob = "mob",
  attack = "attack",
}

---@enum hud_type
local hud_type = {
  rightclick = "rightclick",
  leftclick = "leftclick",
}

---@param player table
---@return table {boolean,table,boolean,integer|nil}
local function lookingAt(player, reach_distance)
  -- if core.registered_tools[item_name] ~= nil then
  --  	core.log(dump(core.registered_tools[item_name]:get_definition()))
  -- end
  -- reach_distance = tonumber(core.registered_tools[item_name]:get_definition().range or 3)

  -- core.log(dump(hand_item:get_definition()))
  -- reach_distance = hand_item:get_definition().range or 3

  local eye_height = player:get_properties().eye_height
  local player_look_dir = player:get_look_dir()
  local pos = player:get_pos():add(player_look_dir)
  local player_pos = { x = pos.x, y = pos.y + eye_height, z = pos.z }
  local new_pos = player:get_look_dir():multiply(reach_distance):add(player_pos)
  local raycast_result = core.raycast(player_pos, new_pos, true, false):next()
  local distance = vector.distance(player_pos, new_pos)
  if dump(raycast_result) == "nil" then
    return { false, { type = "air" }, false, nil }
  elseif raycast_result.type == "node" then
    local node         = core.registered_nodes[core.get_node(raycast_result.under).name]
    local interactible = node.on_rightclick
    if interactible == nil then
      local formspec = core.get_meta(raycast_result.under):to_table()["fields"]["formspec"]
      -- core.log(dump())
      if formspec ~= nil then
        return { true, raycast_result, true, distance }
      end
    end
    -- core.log(dump(interactible))
    if interactible ~= nil then
      return { true, raycast_result, true, distance }
    end
    return { true, raycast_result, false, distance }
  elseif raycast_result.type == "object" then
    --FIXME: prevent looking at self
    if raycast_result.ref:get_luaentity() then
      local interactible = core.registered_entities[raycast_result.ref:get_luaentity().name].on_rightclick
      if interactible then
        return { true, raycast_result, true, distance }
      end
    end
  end
  return { true, raycast_result, false, distance }
end

---@class hud_def
---@field r_click table
---@field l_click table

---@class dn_hud_id
---@field player_name string
---@field huds hud_def
-- Replace everything from "---@type dn_hud_id[] local all_huds = {}" down to change_hud()
-- with the block below.

-- name -> { rightclick = id, leftclick = id }
local all_huds = {}

local texture = mod_name .. "_"

local function create_hud(player, label)
  return player:hud_add({
    hud_elem_type = "image",
    position = { x = 0.5, y = 0.5 },
    name = mod_name .. "_" .. label,
    direction = 0,
    -- Keep size predictable across DPI / GUI scales
    scale = { x = 5, y = 5 },
    text = "",
    z_index = 0,
  })
end

local function ensure_huds(player)
  local name = player:get_player_name()
  if not all_huds[name] then
    all_huds[name] = {
      rightclick = create_hud(player, "rightclick"),
      leftclick  = create_hud(player, "leftclick"),
    }
  end
  return all_huds[name]
end

-- Returns the HUD id table or nil
local function get_player_huds(name)
  return all_huds[name]
end

-- Set the HUD image (creates HUDs on demand)
local function change_hud(player, which_hud, new_value)
  local huds = ensure_huds(player)
  if new_value ~= nil then
    player:hud_change(huds[which_hud], "text", new_value)
  end
end

-- Clean start for every session; remove stale IDs on leave
minetest.register_on_joinplayer(function(player)
  ensure_huds(player)
end)

minetest.register_on_leaveplayer(function(player)
  all_huds[player:get_player_name()] = nil
end)


local function set_crosshair_action(player, which_hud, crosshair_type, opacity, color)
  opacity = opacity or 200
  color = color or nil
  -- if crosshair_type == "" then
  --   change_hud(player, which_hud, "")
  -- end
  crosshair_type = crosshair_type .. ".png"
  local crosshair_texture = texture .. crosshair_type
  if color ~= nil then
    crosshair_texture = string.format("%s^[colorize:%s:%s", crosshair_texture, color, color_alpha)
  end
  if opacity ~= nil then
    crosshair_texture = string.format("%s^[opacity:%s", crosshair_texture, opacity)
  end

  -- return the image with set style
  -- change_hud(player, type)
  change_hud(player, which_hud, crosshair_texture)
end

---CANT USE THIS, game/mods DO FUNKY THINGS, not worth tha hassel right now
-- ---@return table groups and level
-- local function getWieldGroup(wield)
--   local groups_found = false

--   -- prefer looking at tool_capabilities
--   for index, value in ipairs(wield["tool_capabilities"]) do
--   end

--   if groups_found == false then
--     for index, value in ipairs(wield["groups"]) do
--     end
--   end
--   -- ["axe"] ["tool_capabilities"]["max_drop_level"] ["tool_capabilities"]["groupcaps"]["choppy"]["maxlevel"]

--   return {nil,0}
-- end

-- Replace from: local tick = 0 ; core.register_globalstep(function(dtime) ...
local tick = 0
minetest.register_globalstep(function(dtime)
  tick = tick + dtime
  if tick < 0.25 then return end  -- ~4 Hz is plenty
  tick = 0

  local players = minetest.get_connected_players()
  if #players == 0 then return end

  for _, player in ipairs(players) do
    -- Only disable the engine crosshair after our HUDs are ready
    local flags = player:hud_get_flags()
    flags.crosshair = (get_player_huds(player:get_player_name()) == nil)
      and true  -- show engine crosshair until our HUDs exist
       or false -- then hide it
    player:hud_set_flags(flags)
        local reach_distance = 3.5
        --NOTE: mcl_ reach support
        if core.get_modpath("mcl_gamemode") and mcl_gamemode then
          local player_gamemode = mcl_gamemode.get_gamemode(player)
          if core.get_modpath("mcl_meshhand") and mcl_meshhand then
            if player_gamemode == "creative" then
              reach_distance = tonumber(minetest.settings:get("mcl_hand_range_creative")) or 9.5
            else
              reach_distance = tonumber(minetest.settings:get("mcl_hand_range")) or 3.5
            end
          end
        end

        local hand_item = player:get_wielded_item()
        local item_name = hand_item:get_name()
        local hud = player:hud_get_flags()
        local looking = lookingAt(player, reach_distance)

        hud["crosshair"] = false
        -- check if tool has a USE on_secondary_use
        -- core.log(dump(hand_item:to_table()))
        local wielded = core.registered_tools[item_name] or core.registered_items[item_name]
        if wielded == nil then
          -- wielded = core.registered_tools[""]
          wielded = core.registered_tools[""] or core.registered_items[""] --oops I thought "hand" was a tool, it is an item.
        end
        local secondary = nil
        if wielded ~= nil then
          -- core.log(dump(wield_dump["on_secondary_use"]))
          if wielded["type"] ~= "none" then
            if wielded["on_secondary_use"] ~= nil then
              secondary = "on_use"
              -- set_crosshair_action(player, hud_type.rightclick, crosshairs.interact_self, normal_opacity)
            elseif wielded["on_place"] ~= nil then
              secondary = "on_place"
            end
          end
        end

        -- handle looking at nothing
        if looking[2].type == "air" then
          if wielded["groups"]["weapon"] or wielded["groups"]["sword"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.attack, idle_opacity)
          end
          if wielded["groups"]["pickaxe"] or wielded["groups"]["axe"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, idle_opacity)
          end
          if wielded["groups"]["hoe"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, idle_opacity)
          end
          if wielded["groups"]["shears"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, idle_opacity)
          end
          if wielded["type"] == "node" then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.default, idle_opacity)
          end
          if wielded["type"] == "craft" then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.default, idle_opacity)
          end
          if wielded["type"] == "none" then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.default, idle_opacity)
          end
          if wielded["groups"]["weapon_ranged"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.default, normal_opacity)
          end
        end

        -- handle looking at node
if looking[2].type == "node" then
  local node_under = looking[2].under or nil
    local node_name = core.get_node(node_under).name
      local node = core.registered_nodes[node_name]
      
        -- Fallback for unknown nodes
          if not node then
              node = { groups = {} }
                elseif not node.groups then
                    node.groups = {}
                      end
                      
                        local group_stone = node.groups["pickaxey"] or node.groups["stone"]
                          local group_wood = node.groups["axey"] or node.groups["axe"] or node.groups["choppy"] or node.groups["tree"]
                            local group_soil = node.groups["soil"] or node.groups["dirt"] or node.groups["sand"] or
                                                 node.groups["shovel"] or node.groups["shovely"]
                                                   local group_hoe = node.groups["hoey"]
                                                     local group_shear = node.groups["shearsy"]
                                                     
                                                       if wielded["tool_capabilities"] ~= nil then
                                                           if wielded["groups"]["weapon"] then
                                                                 set_crosshair_action(player, hud_type.leftclick, crosshairs.attack, normal_opacity)
                                                                     elseif group_stone then
                                                                           if wielded["groups"]["pickaxe"] and wielded["tool_capabilities"]["max_drop_level"] >= group_stone then
                                                                                   set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, correct_tool_color)
                                                                                         else
                                                                                                 set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, wrong_tool_color)
                                                                                                       end
                                                                                                           elseif group_wood then
                                                                                                                 if wielded["groups"]["axe"] and (wielded["tool_capabilities"]["max_drop_level"] or wielded["tool_capabilities"]["groupcaps"]["choppy"]["maxlevel"]) >= group_wood then
                                                                                                                         set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, correct_tool_color)
                                                                                                                               else
                                                                                                                                       set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, wrong_tool_color)
                                                                                                                                             end
                                                                                                                                                 elseif group_soil then
                                                                                                                                                       if wielded["groups"]["shovel"] and wielded["tool_capabilities"]["max_drop_level"] >= group_soil then
                                                                                                                                                               set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, correct_tool_color)
                                                                                                                                                                     else
                                                                                                                                                                             set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, wrong_tool_color)
                                                                                                                                                                                   end
                                                                                                                                                                                       elseif group_hoe then
                                                                                                                                                                                             if wielded["groups"]["hoe"] and (wielded["tool_capabilities"]["max_drop_level"] or 1) >= group_hoe then
                                                                                                                                                                                                     set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, correct_tool_color)
                                                                                                                                                                                                           else
                                                                                                                                                                                                                   set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity, wrong_tool_color)
                                                                                                                                                                                                                         end
                                                                                                                                                                                                                             else
                                                                                                                                                                                                                                   set_crosshair_action(player, hud_type.leftclick, crosshairs.mine, normal_opacity)
                                                                                                                                                                                                                                       end
                                                                                                                                                                                                                                         else
                                                                                                                                                                                                                                             set_crosshair_action(player, hud_type.leftclick, crosshairs.default, normal_opacity)
                                                                                                                                                                                                                                               end
                                                                                                                                                                                                                                               end

        -- handles interactibles
        if looking[3] then
          local controls = player:get_player_control()
          if controls.sneak and wielded["type"] == "node" then
            set_crosshair_action(player, hud_type.rightclick, crosshairs.use, interact_opacity)
          else
            set_crosshair_action(player, hud_type.rightclick, crosshairs.interact, interact_opacity)
          end
          -- handles useable tool/item
        elseif wielded["type"] == "node" and looking[2].type == "node" then
          set_crosshair_action(player, hud_type.rightclick, crosshairs.use, interact_opacity)
        elseif wielded["type"] == "craft" and wielded["groups"]["eatable"] then
          set_crosshair_action(player, hud_type.rightclick, crosshairs.use_self, interact_opacity)
        else
          set_crosshair_action(player, hud_type.rightclick, crosshairs.clear, 0)
        end

        -- hand, no tool
        if wielded["type"] == "none" then
          if looking[2].type == "node" then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.default, normal_opacity)
          end
        end

        -- handle looking at mob
        if looking[2].type == "object" then
          if looking[3] then
            set_crosshair_action(player, hud_type.rightclick, crosshairs.interact, interact_opacity)
          end
          -- if wield_dump["groups"]["weapon"] or wield_dump["tool_capabilities"]["damage_groups"] then
          if wielded["groups"]["weapon"] or wielded["groups"]["sword"] then
            set_crosshair_action(player, hud_type.leftclick, crosshairs.attack, normal_opacity, correct_tool_color)
          else
            set_crosshair_action(player, hud_type.leftclick, crosshairs.attack, normal_opacity)
          end
        end

        player:hud_set_flags(hud)
      end
    tick = 0
end)
