-- init.lua — Lumberjack Vampire + Vampirism + Awards (all-in-one)

-- ============================================================================
-- Configuration
-- ============================================================================
local INFECTION_CHANCE_FROM_MOB     = 25  -- % chance when hit by a vampire mob
local INFECTION_CHANCE_FROM_PLAYER  = 15  -- % chance when damaged by a vampire player
local DAY_BURN_LIGHT_MIN            = 14  -- sunlight level at head needed to trigger burning
local DAY_START, DAY_END            = 0.20, 0.80 -- in-game day window considered “daylight”
local BAT_DURATION_SEC              = 90
local BAT_SPEED_MULT                = 2.25
local BAT_JUMP_MULT                 = 2.50
local BAT_GRAVITY                   = 0.10
local BAT_COLLISION                 = { -0.3, -0.5, -0.3, 0.3, 0.5, 0.3 } -- ~1 node tall
local HEART_HP                      = 2    -- one “heart” equals 2 HP
local HEAL_ON_HIT_FRACTION          = 0.5  -- lifesteal on damage dealt
local EXTRA_HEART_EVERY_N_DAYS      = 3    -- in-game days between bonus hearts
local LAST_HIT_WINDOW_SEC           = 8    -- kill credit if mob dies <= this many seconds after a hit

-- Deities for holy water invocation (case-insensitive substring match)
local DEITIES = {
  nu=true, nua=true, ngwe=true, nuananim=true, barrowman=true, tulara=true,
  maraxis=true, nuna=true, mother=true, razu=true, novus=true
}

-- Water-bottle item names to recognize (non-MCL)
local CANDIDATE_WATER_BOTTLES = {
  "swamp:glass_bottle_with_water",
  "x_farming:bottle_water",
  "vessels:drinking_glass_water"
}

-- Empty container fallbacks post-cure
local CANDIDATE_EMPTY_BOTTLES = {
  "vessels:glass_bottle"
}

-- Zombies to exclude from lifesteal (entity names)
local LIFESTEAL_EXCLUDE_ENTS = {
  ["zombies:zombie"] = true,
  ["zombies:normal"] = true,
  ["zombies:1arm"]   = true,
  ["zombies:crawler"]= true
}

-- ============================================================================
-- Utilities
-- ============================================================================
local function now_day() return minetest.get_day_count() end
local function rng(pct) return math.random(1,100) <= pct end

local function head_pos(obj)
  local p = obj:get_pos()
  if not p then return nil end
  return {x=p.x, y=p.y + 1.5, z=p.z}
end

local function is_day()
  local t = minetest.get_timeofday()
  return t >= DAY_START and t <= DAY_END
end

local function is_under_open_sky(p, max_check)
  if not p then return false end
  max_check = max_check or 24
  local pos = {x=p.x, y=p.y+1, z=p.z}
  for _=1,max_check do
    local node = minetest.get_node_or_nil(pos)
    if not node then return false end
    if node.name ~= "air" and node.name ~= "ignore" then
      return false
    end
    pos.y = pos.y + 1
  end
  return true
end

local function node_light_at_head(obj)
  local hp = head_pos(obj)
  if not hp then return 0 end
  return (minetest.get_node_light(hp, nil) or 0)
end

local function find_present_item_name(candidates)
  for _, name in ipairs(candidates) do
    if minetest.registered_items[name] then return name end
  end
end

local PRESENT_WATER_BOTTLE = find_present_item_name(CANDIDATE_WATER_BOTTLES)
local PRESENT_EMPTY_BOTTLE = find_present_item_name(CANDIDATE_EMPTY_BOTTLES)

-- ============================================================================
-- Player Vampirism State & Appearance
-- ============================================================================
local function meta(player) return player:get_meta() end
local function is_vampire(player) return meta(player):get_int("lz_vampire") == 1 end
local function set_vampire(player, on) meta(player):set_int("lz_vampire", on and 1 or 0) end

local function save_props(player)
  local props = player:get_properties() or {}
  meta(player):set_string("lz_saved_props", minetest.write_json({
    textures = props.textures or {"character.png"},
    mesh = props.mesh or "",
    visual = props.visual or "mesh",
    visual_size = props.visual_size or {x=1, y=1},
    collisionbox = props.collisionbox or {-0.3,-1.0,-0.3, 0.3,1.0,0.3},
    hp_max = props.hp_max or 20
  }))
end

local function load_props(player)
  local s = meta(player):get_string("lz_saved_props")
  if s == "" then return nil end
  return minetest.parse_json(s)
end

local function set_hp_max(player, new_max)
  local props = player:get_properties() or {}
  props.hp_max = new_max
  player:set_properties(props)
  if player:get_hp() > new_max then
    player:set_hp(new_max)
  end
end

local function gray_textures(tex_list)
  local out = {}
  for i, t in ipairs(tex_list or {}) do
    out[i] = (t or "character.png") .. "^[colorize:#808080:128" -- 50% gray
  end
  return out
end

local function apply_vampire_visuals(player)
  local props = player:get_properties() or {}
  if meta(player):get_string("lz_saved_props") == "" then
    save_props(player)
  end
  props.textures = gray_textures(props.textures or {"character.png"})
  player:set_properties(props)
end

local function restore_visuals(player)
  local sp = load_props(player)
  if sp then
    local props = player:get_properties() or {}
    props.textures = sp.textures
    props.mesh = sp.mesh
    props.visual = sp.visual
    props.visual_size = sp.visual_size
    props.collisionbox = sp.collisionbox
    player:set_properties(props)
  end
end

-- ============================================================================
-- Awards (requires rubenwardy/awards)
-- ============================================================================
local has_awards = minetest.get_modpath("awards") ~= nil

-- Convenience wrappers
local function _aw_notify(trigger, player, key)
  if not has_awards or not player then return end
  local f = awards["notify_" .. trigger]
  if f then
    if key ~= nil then f(player, key) else f(player) end
  end
end
local function _aw_unlock(player, name)
  if not has_awards or not player then return end
  awards.unlock(player:get_player_name(), name)
end

if has_awards then
  -- Register custom triggers; awards creates notify_* helpers for each. :contentReference[oaicite:0]{index=0}
  awards.register_trigger("vamp_contract", { type = "counted",
    progress = "@1/@2 infections",
    auto_description = { "Contract vampirism", "Contract vampirism @1 times" }
  })
  awards.register_trigger("vamp_kill", { type = "counted",
    progress = "@1/@2 vampires slain",
    auto_description = { "Kill a vampire", "Kill @1 vampires" }
  })
  awards.register_trigger("vamp_bless", { type = "counted",
    progress = "@1/@2 blessings",
    auto_description = { "Bless water", "Bless water @1 times" }
  })
  awards.register_trigger("vamp_bat", { type = "counted",
    progress = "@1/@2 bat forms",
    auto_description = { "Take bat form", "Take bat form @1 times" }
  })
  awards.register_trigger("vamp_death", { type = "counted",
    progress = "@1/@2 deaths as vampire",
    auto_description = { "Die while a vampire", "Die @1 times while a vampire" }
  })
  awards.register_trigger("vamp_cure", { type = "counted",
    progress = "@1/@2 cures",
    auto_description = { "Be cured of vampirism", "Be cured @1 times" }
  })

  -- Register awards (achievements). :contentReference[oaicite:1]{index=1}
  awards.register_award("lumberjackzombie:love_to_count", {
    title = "I Love to Count!",
    description = "Say any number in chat while a vampire.",
    difficulty = 1,
    secret = false
  })

  awards.register_award("lumberjackzombie:sucks_to_suck", {
    title = "Sucks to Suck",
    description = "Contract vampirism.",
    trigger = { type = "vamp_contract", target = 1 }
  })

  awards.register_award("lumberjackzombie:oops_again", {
    title = "Oops, I did it again...",
    description = "Contract vampirism for the second time.",
    trigger = { type = "vamp_contract", target = 2 }
  })

  awards.register_award("lumberjackzombie:vampire_slayer", {
    title = "Vampire Slayer",
    description = "Kill a vampire.",
    trigger = { type = "vamp_kill", target = 1 }
  })

  awards.register_award("lumberjackzombie:ultimate_slayer", {
    title = "Ultimate Vampire Slayer",
    description = "Kill 500 vampires.",
    difficulty = 10,
    trigger = { type = "vamp_kill", target = 500 }
  })

  awards.register_award("lumberjackzombie:priest_now", {
    title = "Look Ma, I'm a Priest Now!",
    description = "Successfully bless water into holy water.",
    trigger = { type = "vamp_bless", target = 1 }
  })

  awards.register_award("lumberjackzombie:eek", {
    title = "Eek!",
    description = "Type “Eek!” to transform into a bat as a vampire.",
    trigger = { type = "vamp_bat", target = 1 }
  })

  awards.register_award("lumberjackzombie:nail_coffin", {
    title = "Nail in the Coffin",
    description = "Die while being a vampire.",
    trigger = { type = "vamp_death", target = 1 }
  })

  awards.register_award("lumberjackzombie:cured", {
    title = "A Fang-cy Cure",
    description = "Be cured of vampirism.",
    trigger = { type = "vamp_cure", target = 1 }
  })
end

-- ============================================================================
-- Infection / Cure / Progression
-- ============================================================================
local function grant_heart(player, hearts)
  local props = player:get_properties() or {}
  local new_max = (props.hp_max or 20) + (hearts * HEART_HP)
  set_hp_max(player, new_max)
end

local function schedule_next_growth(player, base)
  local n = (base or now_day()) + EXTRA_HEART_EVERY_N_DAYS
  meta(player):set_int("lz_next_growth_day", n)
end

local function infect_player(player, notify)
  if is_vampire(player) then return false end
  set_vampire(player, true)
  meta(player):set_int("lz_infected_day", now_day())
  meta(player):set_int("lz_growth_count", 0)
  schedule_next_growth(player)
  apply_vampire_visuals(player)
  grant_heart(player, 1) -- immediate +1 heart
  if notify then
    minetest.chat_send_player(player:get_player_name(), "You feel unwell…")
  end
  -- Awards: infection + progress
  _aw_notify("vamp_contract", player)
  return true
end

local function cure_player(player, notify)
  if not is_vampire(player) then return false end
  set_vampire(player, false)
  restore_visuals(player)
  set_hp_max(player, 20) -- baseline
  meta(player):set_string("lz_saved_props", "")
  meta(player):set_int("lz_next_growth_day", 0)
  meta(player):set_int("lz_growth_count", 0)
  -- Awards: cure progress
  _aw_notify("vamp_cure", player)
  if notify then
    minetest.chat_send_player(player:get_player_name(), "The affliction leaves you.")
  end
  return true
end

-- Growth over time (+1 heart every 3 in-game days)
local function handle_growth(player)
  if not is_vampire(player) then return end
  local due = meta(player):get_int("lz_next_growth_day")
  if due > 0 and now_day() >= due then
    grant_heart(player, 1)
    meta(player):set_int("lz_growth_count", meta(player):get_int("lz_growth_count")+1)
    schedule_next_growth(player, due)
    minetest.chat_send_player(player:get_player_name(), "Your vampiric vigor grows.")
  end
end

-- ============================================================================
-- Daylight Burning (uses fire_plus if present)
-- ============================================================================
local function burn_vampire_if_sunlit(player)
  if not is_vampire(player) then return end
  if not is_day() then return end
  local lp = node_light_at_head(player)
  if lp < DAY_BURN_LIGHT_MIN then return end
  if not is_under_open_sky(player:get_pos()) then return end

  if fire_plus and fire_plus.burn_player then
    fire_plus.burn_player(player, 1, 1)
  else
    player:set_hp(math.max(player:get_hp()-1, 0))
  end
end

-- ============================================================================
-- Bat Shapeshift (“Eek!” once per in-game day)
-- ============================================================================
local function can_bat_today(player)
  return meta(player):get_int("lz_last_bat_day") ~= now_day()
end

local function shapeshift_to_bat(player)
  local props = player:get_properties() or {}
  if meta(player):get_string("lz_saved_props") == "" then
    save_props(player)
  end
  props.mesh = "animalia_bat.b3d"
  props.visual = "mesh"
  props.visual_size = {x=1, y=1}
  props.collisionbox = BAT_COLLISION
  player:set_properties(props)
  player:set_physics_override({
    speed = BAT_SPEED_MULT, jump = BAT_JUMP_MULT, gravity = BAT_GRAVITY
  })

  -- grant temporary fly privilege
  local name = player:get_player_name()
  local privs = minetest.get_player_privs(name) or {}
  if privs.fly then
    meta(player):set_int("lz_prev_fly", 1)
  else
    meta(player):set_int("lz_prev_fly", 0)
    privs.fly = true
    minetest.set_player_privs(name, privs)
  end

  -- Awards: successful bat form
  _aw_notify("vamp_bat", player)
end

local function revert_from_bat(player)
  local sp = load_props(player)
  if sp then
    local props = player:get_properties() or {}
    props.mesh = sp.mesh
    props.visual = sp.visual
    props.visual_size = sp.visual_size
    props.collisionbox = sp.collisionbox
    player:set_properties(props)
  end
  player:set_physics_override({speed=1, jump=1, gravity=1})

  -- revoke temp fly if granted
  local name = player:get_player_name()
  local privs = minetest.get_player_privs(name) or {}
  if meta(player):get_int("lz_prev_fly") == 0 then
    privs.fly = nil
    minetest.set_player_privs(name, privs)
  end
end

-- ============================================================================
-- Holy Water (non-MCL)
-- ============================================================================
minetest.register_craftitem("lumberjackzombie:holy_water", {
  description = "Holy Water",
  inventory_image = "default_water.png^[colorize:#c0ffff:128",
  stack_max = 1,
  on_use = function(itemstack, user)
    if user and user:is_player() then
      if cure_player(user, true) then
        if PRESENT_EMPTY_BOTTLE then
          return ItemStack(PRESENT_EMPTY_BOTTLE)
        else
          return ItemStack("") -- consumed
        end
      end
    end
    return itemstack
  end
})

local function holding_water_bottle(player)
  if not PRESENT_WATER_BOTTLE then return false end
  local stack = player:get_wielded_item()
  return stack and stack:get_name() == PRESENT_WATER_BOTTLE
end

local function make_holy_water_in_hand(player)
  local stack = player:get_wielded_item()
  stack:replace("lumberjackzombie:holy_water")
  player:set_wielded_item(stack)
  -- Awards: blessing success
  _aw_notify("vamp_bless", player)
end

-- ============================================================================
-- Commands
-- ============================================================================
minetest.register_chatcommand("vampire_infect", {
  params = "<player>",
  description = "Infect a player with vampirism.",
  privs = {server = true},
  func = function(_, param)
    local target = minetest.get_player_by_name(param or "")
    if not target then return false, "Player not found." end
    if infect_player(target, true) then
      return true, "Infected."
    end
    return true, "Already infected."
  end
})

minetest.register_chatcommand("vampire_cure", {
  params = "<player>",
  description = "Cure a player of vampirism.",
  privs = {server = true},
  func = function(_, param)
    local target = minetest.get_player_by_name(param or "")
    if not target then return false, "Player not found." end
    if cure_player(target, true) then
      return true, "Cured."
    end
    return true, "Not infected."
  end
})

-- ============================================================================
-- Chat hooks (Holy water invocation + “Eek!” shapeshift + “I Love to Count!”)
-- ============================================================================
minetest.register_on_chat_message(function(name, msg)
  local player = minetest.get_player_by_name(name)
  if not player then return false end

  local lmsg = msg:lower()

  -- “Eek!” -> shapeshift once per in-game day (and award via shapeshift_to_bat)
  if lmsg:match("^%s*eek!%s*$") and is_vampire(player) then
    if can_bat_today(player) then
      meta(player):set_int("lz_last_bat_day", now_day())
      shapeshift_to_bat(player)
      minetest.after(BAT_DURATION_SEC, function()
        local p = minetest.get_player_by_name(name)
        if p then revert_from_bat(p) end
      end)
      return true -- swallow chat
    else
      minetest.chat_send_player(name, "You have already taken bat form today.")
      return true
    end
  end

  -- Holy water creation: requires a deity name AND the phrase “please bless”
  local mentions_deity = false
  for d,_ in pairs(DEITIES) do
    if lmsg:find(d, 1, true) then mentions_deity = true break end
  end
  if mentions_deity and lmsg:find("please%s+bless") and holding_water_bottle(player) then
    make_holy_water_in_hand(player)
    minetest.chat_send_player(name, "Your water has been blessed.")
    -- don't swallow; let it chat
  end

  -- "I Love to Count!" — say any number while being a vampire (non-command)
  if is_vampire(player) and not msg:match("^%s*/") and msg:match("%d") then
    _aw_unlock(player, "lumberjackzombie:love_to_count")
  end

  return false
end)

-- ============================================================================
-- Infection & Lifesteal Hooks
-- ============================================================================
-- On being punched: possible infection by vampire mob or vampire player
minetest.register_on_punchplayer(function(player, hitter, _, toolcaps, _, damage)
  if not player or not hitter then return false end

  -- Infection from vampire mob entity
  if not hitter:is_player() then
    local ent = hitter:get_luaentity()
    if ent and ent.name and ent.name:find(":vampire", 1, true) then
      if rng(INFECTION_CHANCE_FROM_MOB) then
        if infect_player(player, true) then
          -- Awards: infection progress happens inside infect_player
        end
      end
    end
  end

  -- Infection from vampire player
  if hitter:is_player() and is_vampire(hitter) then
    if rng(INFECTION_CHANCE_FROM_PLAYER) then
      if infect_player(player, true) then
        -- Awards: handled in infect_player
      end
    end
    -- Lifesteal vs players (unless excluded entities; players aren't excluded)
    if damage and damage > 0 then
      local heal = math.floor(damage * HEAL_ON_HIT_FRACTION + 0.5)
      if heal > 0 then
        hitter:set_hp(math.min(hitter:get_hp() + heal, (hitter:get_properties().hp_max or 20)))
      end
    end
  end

  return false
end)

-- Lifesteal vs mobs/entities + track last hitter for kill credit
minetest.register_on_mods_loaded(function()
  for name, def in pairs(minetest.registered_entities) do
    if type(def) == "table" and def.on_punch then
      local old_on_punch = def.on_punch
      def.on_punch = function(self, hitter, time_from_last_punch, toolcaps, dir, damage)
        -- Track last hitter and time for kill credit window
        if hitter and hitter.is_player and hitter:is_player() then
          self._lz_last_hitter = hitter
          self._lz_last_hit_time = minetest.get_gametime()
        end
        -- Keep original behavior
        local ret = old_on_punch(self, hitter, time_from_last_punch, toolcaps, dir, damage)
        -- Lifesteal for vampire players vs non-excluded mobs
        if hitter and hitter.is_player and hitter:is_player() and is_vampire(hitter) then
          local entname = self.name or name
          if not LIFESTEAL_EXCLUDE_ENTS[entname] then
            local dmg = damage or 0
            if (not dmg or dmg <= 0) and toolcaps then
              dmg = 1
            end
            if dmg and dmg > 0 then
              local heal = math.floor(dmg * HEAL_ON_HIT_FRACTION + 0.5)
              if heal > 0 then
                hitter:set_hp(math.min(hitter:get_hp() + heal, (hitter:get_properties().hp_max or 20)))
              end
            end
          end
        end
        return ret
      end
    end
  end
end)

-- On death: award death-while-vampire, then cure
minetest.register_on_dieplayer(function(player)
  if is_vampire(player) then
    _aw_notify("vamp_death", player)
  end
  cure_player(player, false)
end)

-- On join: re-apply visuals and ensure hp_max alignment
minetest.register_on_joinplayer(function(player)
  if is_vampire(player) then
    apply_vampire_visuals(player)
    local props = player:get_properties() or {}
    if (props.hp_max or 20) < 22 then
      grant_heart(player, 1)
    end
  end
end)

-- Periodic effects: sun burn + growth tick
local accum = 0
minetest.register_globalstep(function(dtime)
  accum = accum + dtime
  if accum < 1.0 then return end
  accum = 0
  for _, player in ipairs(minetest.get_connected_players()) do
    if is_vampire(player) then
      burn_vampire_if_sunlit(player)
      handle_growth(player)
    end
  end
end)

-- ============================================================================
-- Lumberjack Vampire Mob
-- ============================================================================
mobs:register_mob("lumberjackzombie:vampire", {
  type = "monster",
  passive = false,
  attack_type = "dogfight",
  attack_npcs = false,
  group_attack = true,
  pathfinding = true,
  reach = 3,
  damage = 3,
  hp_min = 5,
  hp_max = 350,
  light_damage = 19, -- strong sunlight aversion for the mob itself
  armor = 100,
  visual = "mesh",
  mesh = "zombie_normal.b3d",
  textures = { {"v1.png"} },
  makes_footstep_sound = true,
  sounds = {
    random = "zombie_angry",
    death  = "zombie_death",
  },
  walk_velocity = 1,
  run_velocity = 3,
  jump_height = 2,
  stepheight = 1.1,
  floats = 0,
  view_range = 35,
  drops = {
    {name="default:gold_ingot",     chance=1,  min=0, max=9},
    {name="default:silverbar",      chance=12, min=0, max=9},
    {name="default:rustysword",     chance=3,  min=0, max=1},
    {name="tinkering:silver_sword", chance=4,  min=0, max=1},
    {name="tinkering:csteel_shovel",chance=5,  min=0, max=1},
    {name="default:copper_ingot",   chance=4,  min=0, max=9},
    {name="default:ironbar",        chance=5,  min=0, max=9},
    {name="default:coal",           chance=3,  min=0, max=9},
    {name="default:fopal",          chance=9,  min=0, max=1},
    {name="default:diamond",        chance=9,  min=0, max=1},
    {name="default:peridot",        chance=9,  min=0, max=1},
    {name="default:ruby",           chance=9,  min=0, max=1},
    {name="default:emerald",        chance=9,  min=0, max=1},
    {name="default:btopaz",         chance=9,  min=0, max=1},
  },
  animation = {
    speed_normal = 44, speed_run = 44, punch_speed = 20,
    stand_start = 0,  stand_end = 40,
    walk_start = 41,  walk_end = 101,
    run_start = 41,   run_end = 101,
    punch_start = 102, punch_end = 142,
  },
  collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},

  -- Award kill credit when this vampire dies to a recent player hit
  on_die = function(self, pos)
    local killer = self._lz_last_hitter
    local hit_t  = self._lz_last_hit_time or 0
    if killer and killer.is_player and killer:is_player() then
      if (minetest.get_gametime() - hit_t) <= LAST_HIT_WINDOW_SEC then
        _aw_notify("vamp_kill", killer)
      end
    end
  end,
})

mobs:register_spawn("lumberjackzombie:vampire",
  {"group:crumbly", "default:dirt_with_grass"},
  15, 0, 12000, 1, 31000, false)

mobs:register_egg("lumberjackzombie:vampire", "Vampire", "zombies_egg.png", 0)

