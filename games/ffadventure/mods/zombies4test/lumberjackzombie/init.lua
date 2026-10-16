-- init.lua — Lumberjack Vampire (stabilized hotfix)
-- Focus: make Eek! shapeshift work reliably, stop “black hearts”, fix blessing, keep daylight burn.
-- Notes:
--  * No more global hp_max side-effects: extra-hearts are paused to avoid broken HUD bars.
--  * Bat form is a real mesh swap + safe restore, coordinated with player_api if present.
--  * Blessing uses runtime item detection and clearer matching; logs why it refuses.

-- ================================
-- Config
-- ================================
local INFECTION_CHANCE_FROM_MOB     = 25
local INFECTION_CHANCE_FROM_PLAYER  = 15
local DAY_BURN_LIGHT_MIN            = 14
local DAY_START, DAY_END            = 0.20, 0.80

local BAT_DURATION_SEC              = 30
local BAT_SPEED_MULT                = 2.0
local BAT_JUMP_MULT                 = 2.0
local BAT_GRAVITY                   = 0.10
local BAT_COLLISION                 = { -0.3, -0.5, -0.3, 0.3, 0.5, 0.3 }
local BAT_MESH                      = "animalia_bat.b3d"
local BAT_TEX                       = "animalia_bat.png"

local HEAL_ON_HIT_FRACTION          = 0.5
local EXTRA_HEARTS_ENABLED          = false   -- TEMP OFF to prevent black-HP HUD issues
local LAST_HIT_WINDOW_SEC           = 8

-- Deities (word match, case-insensitive)
-- Multi-word names use space/hyphen and are matched with plain find before single-word boundary match.
local DEITIES = {
  nu=true, nua=true, ngwe=true, nuananim=true, barrowman=true, tulara=true,
  maraxis=true, nuna=true, mother=true, razu=true, novus=true,
  hastur=true, mundakar=true, cthulhu=true, tsathoggua=true,
  ["chaugnar faugn"]=true, azathoth=true, ["atlach-nacha"]=true,
  frith=true, valka=true, crom=true, hekmet=true,
}

-- Candidate water bottles (runtime-checked — includes all known water bottle items)
local CANDIDATE_WATER_BOTTLES = {
  "swamp:glass_bottle_with_water",
  "potions_and_magic:water_glass_bottle",
  "x_farming:bottle_water",
  "ffadventure:water_bottle",
  "vessels:glass_bottle_water",
  "vessels:drinking_glass_water",
}

local CANDIDATE_EMPTY_BOTTLES = {
  "vessels:glass_bottle", "vessels:drinking_glass"
}

-- Excluded entities for lifesteal
local LIFESTEAL_EXCLUDE_ENTS = {
  ["zombies:zombie"] = true,
  ["zombies:normal"] = true,
  ["zombies:1arm"]   = true,
  ["zombies:crawler"]= true
}

-- ================================
-- Faith tracking (deity invocation counts)
-- ================================
local FAITH_FILE = minetest.get_worldpath() .. "/faith_tracker.txt"

-- Data: { global = { deity = count }, players = { name = { deity = count } } }
local faith_data = { global = {}, players = {} }

-- Initialize all deities to 0 in global
for d in pairs(DEITIES) do
  faith_data.global[d] = 0
end

local function load_faith()
  local f = io.open(FAITH_FILE, "r")
  if not f then return end
  local text = f:read("*a")
  f:close()
  local data = minetest.deserialize(text)
  if not data then return end
  if data.global then
    for d in pairs(DEITIES) do
      faith_data.global[d] = (data.global[d] or 0)
    end
  end
  if data.players then
    for pname, counts in pairs(data.players) do
      faith_data.players[pname] = {}
      for d in pairs(DEITIES) do
        faith_data.players[pname][d] = counts[d] or 0
      end
    end
  end
end

local function save_faith()
  local f = io.open(FAITH_FILE, "w")
  if not f then return end
  f:write(minetest.serialize(faith_data))
  f:close()
end

load_faith()

-- Record a deity mention from a player
local function record_invocation(pname, deity)
  faith_data.global[deity] = (faith_data.global[deity] or 0) + 1
  if not faith_data.players[pname] then
    faith_data.players[pname] = {}
    for d in pairs(DEITIES) do
      faith_data.players[pname][d] = 0
    end
  end
  faith_data.players[pname][deity] = (faith_data.players[pname][deity] or 0) + 1
end

-- ================================
-- Public faith API
-- ================================
--
-- Everything above is file-local, so until now nothing outside this mod could
-- see the pantheon or a player's standing in it, and faith could only move by
-- someone typing a god's name in chat. That is enough for the holy water
-- recipe and not enough for anyone else to build on -- a priest cannot preach
-- about a god they cannot name, and a deed cannot be pleasing to one.
--
-- Nothing below changes how the existing mechanic behaves. It exposes what was
-- already there, and adds the one thing that was missing: a way to grant faith
-- for something other than speaking.

lumberjackzombie = lumberjackzombie or {}

-- Is this the name of a god? Case-insensitive, like the chat matcher.
function lumberjackzombie.is_deity(name)
  return name ~= nil and DEITIES[tostring(name):lower()] == true
end

-- Every god's name, as a sorted list. A copy: callers must not be able to
-- edit the pantheon by editing what they were handed.
function lumberjackzombie.deities()
  local out = {}
  for d in pairs(DEITIES) do out[#out + 1] = d end
  table.sort(out)
  return out
end

-- Add a god at runtime, so a pantheon can be extended without editing this
-- table. Returns false if it was already known.
function lumberjackzombie.register_deity(name)
  name = tostring(name):lower()
  if DEITIES[name] then return false end
  DEITIES[name] = true
  faith_data.global[name] = faith_data.global[name] or 0
  return true
end

-- How much this player has invoked one god, or a table of all of them.
function lumberjackzombie.get_faith(pname, deity)
  local counts = faith_data.players[pname]
  if not deity then
    local out = {}
    for d in pairs(DEITIES) do out[d] = (counts and counts[d]) or 0 end
    return out
  end
  return (counts and counts[tostring(deity):lower()]) or 0
end

-- How much the world has invoked one god.
function lumberjackzombie.get_global_faith(deity)
  return faith_data.global[tostring(deity):lower()] or 0
end

-- The god this player has called on most, and by how much. Nil if they have
-- never named one.
function lumberjackzombie.patron_of(pname)
  local counts = faith_data.players[pname]
  if not counts then return end
  local best, best_n
  for d, n in pairs(counts) do
    if n > 0 and (not best_n or n > best_n) then best, best_n = d, n end
  end
  return best, best_n
end

-- Grant (or withdraw) faith for something other than speaking a name: an
-- offering, a burial, a deed a god cares about. This is the mutator the chat
-- handler always had privately and nothing else could reach.
function lumberjackzombie.add_faith(pname, deity, n)
  if not pname or not deity then return end
  deity = tostring(deity):lower()
  if not DEITIES[deity] then return end
  n = n or 1

  faith_data.global[deity] = math.max(0, (faith_data.global[deity] or 0) + n)
  if not faith_data.players[pname] then
    faith_data.players[pname] = {}
    for d in pairs(DEITIES) do faith_data.players[pname][d] = 0 end
  end
  local was = faith_data.players[pname][deity] or 0
  faith_data.players[pname][deity] = math.max(0, was + n)
  return faith_data.players[pname][deity]
end

-- Save periodically (every 5 minutes)
local faith_save_accum = 0
minetest.register_globalstep(function(dtime)
  faith_save_accum = faith_save_accum + dtime
  if faith_save_accum >= 300 then
    faith_save_accum = 0
    save_faith()
  end
end)

minetest.register_on_shutdown(save_faith)

-- Capitalize each word in a deity name
local function capitalize(s)
  return s:gsub("(%a)([%w%-]*)", function(first, rest)
    return first:upper() .. rest
  end)
end

-- /faith — global deity power ranking
minetest.register_chatcommand("faith", {
  description = "List all deities ranked by invocation power.",
  func = function(name)
    local sorted = {}
    for d, count in pairs(faith_data.global) do
      sorted[#sorted+1] = { name = d, pts = count }
    end
    table.sort(sorted, function(a, b) return a.pts > b.pts end)

    local lines = {"=== Deities by Power (Total Invocations) ==="}
    for i, entry in ipairs(sorted) do
      lines[#lines+1] = string.format(" %2d. %-14s %d pts", i, capitalize(entry.name), entry.pts)
    end
    return true, table.concat(lines, "\n")
  end,
})

-- /myfaith — personal invocation counts
minetest.register_chatcommand("myfaith", {
  description = "Show your personal deity invocation counts.",
  func = function(name)
    local pcounts = faith_data.players[name]
    if not pcounts then
      return true, "You have not invoked any deity yet."
    end

    local sorted = {}
    for d, count in pairs(pcounts) do
      if DEITIES[d] then
        sorted[#sorted+1] = { name = d, pts = count }
      end
    end
    table.sort(sorted, function(a, b) return a.pts > b.pts end)

    local lines = {"=== Your Personal Invocations ==="}
    for _, entry in ipairs(sorted) do
      if entry.pts > 0 then
        lines[#lines+1] = string.format("  %-14s %d", capitalize(entry.name), entry.pts)
      end
    end
    if #lines == 1 then
      return true, "You have not invoked any deity yet."
    end
    return true, table.concat(lines, "\n")
  end,
})

-- ================================
-- Utilities
-- ================================
local function rng(pct) return math.random(1,100) <= pct end
local function now_day() return minetest.get_day_count() end

local function head_pos(obj)
  local p = obj:get_pos(); if not p then return nil end
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

local function any_present_item_names(candidates)
  local out = {}
  for _, name in ipairs(candidates) do
    if minetest.registered_items[name] then out[#out+1] = name end
  end
  return out
end

local PRESENT_EMPTY_BOTTLE = (function()
  for _, n in ipairs(CANDIDATE_EMPTY_BOTTLES) do
    if minetest.registered_items[n] then return n end
  end
  return nil
end)()

-- ================================
-- Player vamp state
-- ================================
local function meta(player) return player:get_meta() end
local function is_vampire(player) return meta(player):get_int("lz_vampire")==1 end
local function set_vampire(player,on) meta(player):set_int("lz_vampire", on and 1 or 0) end

-- Save/restore only visuals & shape; DO NOT touch hp_max here (prevents global HUD glitches)
local function save_full_props(player)
  local props = player:get_properties() or {}
  meta(player):set_string("lz_saved_props", minetest.write_json({
    textures     = props.textures or {},
    mesh         = props.mesh or "",
    visual       = props.visual or "mesh",
    visual_size  = props.visual_size or {x=1,y=1},
    collisionbox = props.collisionbox or {-0.3,-1,-0.3, 0.3,1,0.3},
  }))
end

local function load_full_props(player)
  local s = meta(player):get_string("lz_saved_props")
  if s=="" then return nil end
  return minetest.parse_json(s)
end

local function gray_textures(tex_list)
  local out = {}
  for i,t in ipairs(tex_list or {}) do
    out[i] = (t or "character.png") .. "^[colorize:#808080:128"
  end
  return (#out>0) and out or tex_list
end

local function apply_vampire_visuals(player)
  local props = player:get_properties() or {}
  if meta(player):get_string("lz_saved_props")=="" then
    save_full_props(player)
  end
  local tinted = gray_textures(props.textures or {})
  if tinted then player:set_properties({textures=tinted}) end
end

local function restore_full_visuals(player)
  local sp = load_full_props(player)
  if sp then
    player:set_properties({
      textures     = sp.textures,
      mesh         = sp.mesh,
      visual       = sp.visual,
      visual_size  = sp.visual_size,
      collisionbox = sp.collisionbox,
    })
  end
end

-- ================================
-- Awards (optional)
-- ================================
local has_awards = minetest.get_modpath("awards") ~= nil
local function _aw_notify(trigger, player)
  if not has_awards or not player then return end
  local f = awards["notify_"..trigger]; if f then f(player) end
end
local function _aw_unlock(player, name)
  if not has_awards or not player then return end
  awards.unlock(player:get_player_name(), name)
end

if has_awards then
  awards.register_trigger("vamp_contract", { type="counted", progress="@1/@2 infections" })
  awards.register_trigger("vamp_kill",     { type="counted", progress="@1/@2 vampires slain" })
  awards.register_trigger("vamp_bless",    { type="counted", progress="@1/@2 blessings" })
  awards.register_trigger("vamp_bat",      { type="counted", progress="@1/@2 bat forms" })
  awards.register_trigger("vamp_death",    { type="counted", progress="@1/@2 deaths as vampire" })
  awards.register_trigger("vamp_cure",     { type="counted", progress="@1/@2 cures" })

  awards.register_award("lumberjackzombie:love_to_count", {
    title="I Love to Count!", description="Say any number in chat while a vampire.", difficulty=1
  })
  awards.register_award("lumberjackzombie:sucks_to_suck", {
    title="Sucks to Suck", description="Contract vampirism.", trigger={type="vamp_contract", target=1}
  })
  awards.register_award("lumberjackzombie:oops_again", {
    title="Oops, I did it again...", description="Contract vampirism for the second time.",
    trigger={type="vamp_contract", target=2}
  })
  awards.register_award("lumberjackzombie:vampire_slayer", {
    title="Vampire Slayer", description="Kill a vampire.", trigger={type="vamp_kill", target=1}
  })
  awards.register_award("lumberjackzombie:ultimate_slayer", {
    title="Ultimate Vampire Slayer", description="Kill 500 vampires.", difficulty=10,
    trigger={type="vamp_kill", target=500}
  })
  awards.register_award("lumberjackzombie:priest_now", {
    title="Look Ma, I'm a Priest Now!", description="Bless water into holy water.",
    trigger={type="vamp_bless", target=1}
  })
  awards.register_award("lumberjackzombie:eek", {
    title="Eek!", description="Type “Eek!” to transform into a bat as a vampire.",
    trigger={type="vamp_bat", target=1}
  })
  awards.register_award("lumberjackzombie:nail_coffin", {
    title="Nail in the Coffin", description="Die while being a vampire.",
    trigger={type="vamp_death", target=1}
  })
  awards.register_award("lumberjackzombie:cured", {
    title="A Fang-cy Cure", description="Be cured of vampirism.",
    trigger={type="vamp_cure", target=1}
  })
end

-- ================================
-- Infection / Cure (hearts growth paused)
-- ================================
local function infect_player(player, notify)
  if is_vampire(player) then return false end
  set_vampire(player, true)
  apply_vampire_visuals(player)
  if notify then
    minetest.chat_send_player(player:get_player_name(), "You feel unwell…")
  end
  _aw_notify("vamp_contract", player)
  return true
end

local function cure_player(player, notify)
  if not is_vampire(player) then return false end
  set_vampire(player, false)
  restore_full_visuals(player)
  _aw_notify("vamp_cure", player)
  if notify then
    minetest.chat_send_player(player:get_player_name(), "The affliction leaves you.")
  end
  return true
end

-- ================================
-- Daylight burning
-- ================================
local function burn_vampire_if_sunlit(player)
  if not is_vampire(player) then return end
  if not is_day() then return end
  local lp = node_light_at_head(player); if lp < DAY_BURN_LIGHT_MIN then return end
  if not is_under_open_sky(player:get_pos()) then return end
  if fire_plus and fire_plus.burn_player then
    fire_plus.burn_player(player, 1, 1)
  else
    player:set_hp(math.max(player:get_hp()-1, 0))
  end
end

-- ================================
-- Bat shapeshift ("Eek!") — smoke form with fly, speed, and invisibility
-- ================================
local SMOKE_TEXTURE = "smoke_puff.png"

local function is_bat(player) return meta(player):get_int("lz_is_bat") == 1 end

local function shapeshift_to_bat(player)
  if is_bat(player) then return end -- prevent double-activation

  -- Save current state
  local props = player:get_properties() or {}
  meta(player):set_string("lz_saved_vis_size", minetest.write_json(props.visual_size or {x=1, y=1}))
  local oldtag = player:get_nametag_attributes() or {}
  meta(player):set_string("lz_saved_nametag", minetest.write_json(oldtag))

  -- Save current physics so we restore them, not hardcoded 1/1/1
  local phys = player:get_physics_override()
  meta(player):set_string("lz_saved_physics", minetest.write_json({
    speed = phys.speed or 1, jump = phys.jump or 1, gravity = phys.gravity or 1
  }))

  -- Mark bat form active
  meta(player):set_int("lz_is_bat", 1)

  -- Make the player visually vanish
  player:set_properties({ visual_size = { x = 0.01, y = 0.01 } })
  player:set_nametag_attributes({ color = { a = 0, r = 255, g = 255, b = 255 } })

  -- Smoke particles that follow the player
  minetest.add_particlespawner({
    amount = 300,
    time   = BAT_DURATION_SEC,
    attached = player,
    minpos = { x = -0.2, y = 0.0, z = -0.2 },
    maxpos = { x =  0.2, y = 1.2, z =  0.2 },
    minvel = { x = -0.5, y = 0.2, z = -0.5 },
    maxvel = { x =  0.5, y = 1.5, z =  0.5 },
    minacc = { x =  0.0, y = 0.0, z =  0.0 },
    maxacc = { x =  0.0, y = 0.2, z =  0.0 },
    minsize = 2,
    maxsize = 5,
    collisiondetection = false,
    texture = SMOKE_TEXTURE,
  })

  -- Movement buffs + fly priv
  player:set_physics_override({ speed = 2.0, jump = 2.0, gravity = 0.1 })

  local name  = player:get_player_name()
  local privs = minetest.get_player_privs(name) or {}
  if privs.fly then
    meta(player):set_int("lz_prev_fly", 1)
  else
    meta(player):set_int("lz_prev_fly", 0)
    privs.fly = true
    minetest.set_player_privs(name, privs)
  end

  minetest.chat_send_player(name, "You dissolve into a cloud of dark smoke...")
  _aw_notify("vamp_bat", player)
end

local function revert_from_bat(player)
  if not is_bat(player) then return end -- already reverted

  meta(player):set_int("lz_is_bat", 0)

  -- Restore visibility
  local vs_json = meta(player):get_string("lz_saved_vis_size")
  local size    = (vs_json ~= "" and minetest.parse_json(vs_json)) or { x = 1, y = 1 }
  player:set_properties({ visual_size = size })

  local nt_json = meta(player):get_string("lz_saved_nametag")
  local tag     = (nt_json ~= "" and minetest.parse_json(nt_json)) or { color = { a = 255, r = 255, g = 255, b = 255 } }
  player:set_nametag_attributes(tag)

  -- Restore physics to what they were before bat form (not hardcoded 1/1/1)
  local phys_json = meta(player):get_string("lz_saved_physics")
  local phys = (phys_json ~= "" and minetest.parse_json(phys_json)) or {speed=1, jump=1, gravity=1}
  player:set_physics_override({ speed = phys.speed, jump = phys.jump, gravity = phys.gravity })

  -- Revoke fly if we granted it
  local name  = player:get_player_name()
  local privs = minetest.get_player_privs(name) or {}
  if meta(player):get_int("lz_prev_fly") == 0 then
    privs.fly = nil
    minetest.set_player_privs(name, privs)
  end

  -- Re-apply vampire visuals (gray tint) since restoring size clears them
  if is_vampire(player) then
    apply_vampire_visuals(player)
  end

  minetest.chat_send_player(name, "You reform from the smoke.")
end

-- Safety: revert bat form on join (handles disconnect during bat form)
minetest.register_on_joinplayer(function(player)
  if is_bat(player) then
    revert_from_bat(player)
  end
end)

-- ================================
-- Holy water
-- ================================
minetest.register_craftitem("lumberjackzombie:holy_water", {
  description = "Holy Water",
  inventory_image = "pm_water_glass_bottle.png^[colorize:#d0f0ff:90^[brighten",
  stack_max = 1,
  on_use = function(itemstack, user)
    if user and user:is_player() then
      -- Holy water cures both the vampiric affliction (this mod) and
      -- petz lycanthropy. Try each; consume the bottle if either took.
      local cured = cure_player(user, true)

      if minetest.get_modpath("petz") and petz and petz.has_lycanthropy
         and petz.has_lycanthropy(user) then
        petz.cure_lycanthropy(user)
        cured = true
      end

      if cured then
        if PRESENT_EMPTY_BOTTLE then
          return ItemStack(PRESENT_EMPTY_BOTTLE)
        else
          return ItemStack("")
        end
      end
    end
    return itemstack
  end
})

local PRESENT_WATER_BOTTLES = nil
local function rebuild_present_water_list()
  PRESENT_WATER_BOTTLES = any_present_item_names(CANDIDATE_WATER_BOTTLES)
end

local function holding_water_bottle(player)
  if not PRESENT_WATER_BOTTLES or #PRESENT_WATER_BOTTLES==0 then
    rebuild_present_water_list()
  end
  local stack = player:get_wielded_item()
  if not stack or stack:is_empty() then return false end
  local name = stack:get_name()
  for _, cand in ipairs(PRESENT_WATER_BOTTLES) do
    if name == cand then return true end
  end
  return false
end

local function make_holy_water_in_hand(player)
  local stack = player:get_wielded_item()
  stack:replace("lumberjackzombie:holy_water")
  player:set_wielded_item(stack)
  _aw_notify("vamp_bless", player)
end

-- Exposed so a priest can perform the blessing in person, rather than the
-- player having to type the formula in chat. Same item list, same result -- the
-- chat route is untouched.
function lumberjackzombie.holding_water(player)
  return player ~= nil and holding_water_bottle(player)
end

-- Bless what the player is holding, in the name of `deity`. Returns false if
-- they are not holding water. The faith credit is the caller's business.
function lumberjackzombie.bless_wielded(player, deity)
  if not lumberjackzombie.holding_water(player) then return false end
  make_holy_water_in_hand(player)
  if deity then
    lumberjackzombie.add_faith(player:get_player_name(), deity, 1)
  end
  return true
end

-- ================================
-- Fill bottle from water source
-- ================================
local WATER_SOURCES = {
  ["default:water_source"] = true,
  ["default:river_water_source"] = true,
  ["default:dirty_water_source"] = true,
}

local FILL_RESULT = "potions_and_magic:water_glass_bottle"

minetest.register_on_mods_loaded(function()
  -- Only override if the water bottle item actually exists
  if not minetest.registered_items[FILL_RESULT] then return end
  local bottle_def = minetest.registered_nodes["vessels:glass_bottle"]
  if not bottle_def then return end

  local old_on_place = bottle_def.on_place

  minetest.override_item("vessels:glass_bottle", {
    on_place = function(itemstack, placer, pointed_thing)
      if pointed_thing and pointed_thing.type == "node" then
        local node = minetest.get_node(pointed_thing.under)
        if WATER_SOURCES[node.name] then
          -- Fill the bottle
          itemstack:take_item()
          local inv = placer:get_inventory()
          local water_bottle = ItemStack(FILL_RESULT)
          if inv:room_for_item("main", water_bottle) then
            inv:add_item("main", water_bottle)
          else
            minetest.add_item(placer:get_pos(), water_bottle)
          end
          return itemstack
        end
      end
      if old_on_place then
        return old_on_place(itemstack, placer, pointed_thing)
      end
      return minetest.item_place(itemstack, placer, pointed_thing)
    end,
  })
end)

-- ================================
-- Commands
-- ================================
minetest.register_chatcommand("vampire_infect", {
  params="<player>", description="Infect a player with vampirism.", privs={server=true},
  func=function(_, param)
    local target = minetest.get_player_by_name(param or "")
    if not target then return false, "Player not found." end
    if infect_player(target, true) then return true, "Infected." end
    return true, "Already infected."
  end
})

minetest.register_chatcommand("vampire_cure", {
  params="<player>", description="Cure a player of vampirism.", privs={server=true},
  func=function(_, param)
    local target = minetest.get_player_by_name(param or "")
    if not target then return false, "Player not found." end
    if cure_player(target, true) then return true, "Cured." end
    return true, "Not infected."
  end
})

-- ================================
-- Chat hooks (Eek! + Bless + Count)
-- Inserted at position 1 so it runs before proxchat (which returns true on all messages)
-- ================================
local function lz_chat_handler(name, msg)
  local player = minetest.get_player_by_name(name)
  if not player then return false end
  local lmsg = msg:lower()

  -- Eek! exact word, any casing, no extra text
  if lmsg:match("^%s*eek!?%s*$") and is_vampire(player) then
    if is_bat(player) then
      minetest.chat_send_player(name, "You are already in smoke form!")
    else
      shapeshift_to_bat(player)
      minetest.after(BAT_DURATION_SEC, function()
        local p = minetest.get_player_by_name(name)
        if p then revert_from_bat(p) end
      end)
    end
    return true
  end

  -- Track all deity mentions in chat (faith system) + check for blessing
  local deity_ok = false
  if not msg:match("^%s*/") then  -- skip slash commands
    for d in pairs(DEITIES) do
      local found = false
      if d:find("[%s%-]") then
        -- Multi-word name: plain string find
        found = lmsg:find(d, 1, true) ~= nil
      else
        -- Single word: word-boundary match
        found = lmsg:find("%f[%w_]"..d.."%f[^%w_]") ~= nil
      end
      if found then
        record_invocation(name, d)
        deity_ok = true
      end
    end
  end
  if deity_ok and lmsg:find("please%p*%s+bless") then
    if holding_water_bottle(player) then
      make_holy_water_in_hand(player)
      minetest.chat_send_player(name, "Your water has been blessed.")
    else
      minetest.log("action", "[lumberjackzombie] Bless refused: not holding any known water bottle")
    end
  end

  -- "I Love to Count!" — vampire says any number (not command)
  if is_vampire(player) and not msg:match("^%s*/") and msg:match("%d") then
    _aw_unlock(player, "lumberjackzombie:love_to_count")
  end

  return false
end

-- Insert at front of callback list so we run before proxchat swallows the message
minetest.register_on_mods_loaded(function()
  local cb = minetest.registered_on_chat_messages
  table.insert(cb, 1, lz_chat_handler)
end)

-- ================================
-- Combat hooks
-- ================================
minetest.register_on_punchplayer(function(player, hitter, _, _, _, damage)
  if not player or not hitter then return false end

  -- Infect from vampire mob
  if not hitter:is_player() then
    local ent = hitter:get_luaentity()
    if ent and ent.name and ent.name:find(":vampire", 1, true) then
      if rng(INFECTION_CHANCE_FROM_MOB) then infect_player(player, true) end
    end
  end

  -- Infect + lifesteal from vampire player
  if hitter:is_player() and is_vampire(hitter) then
    if rng(INFECTION_CHANCE_FROM_PLAYER) then infect_player(player, true) end
    if damage and damage > 0 then
      if not minetest.is_player(player) then
        -- vs entities handled below
      else
        local heal = math.floor(damage * HEAL_ON_HIT_FRACTION + 0.5)
        if heal > 0 then
          hitter:set_hp(math.min(hitter:get_hp() + heal, hitter:get_properties().hp_max or 20))
        end
      end
    end
  end
  return false
end)

-- Lifesteal vs mobs + track last hitter for kill credit
minetest.register_on_mods_loaded(function()
  for name, def in pairs(minetest.registered_entities) do
    if type(def)=="table" and def.on_punch then
      local old_on_punch = def.on_punch
      def.on_punch = function(self, hitter, tflp, toolcaps, dir, damage)
        if hitter and hitter.is_player and hitter:is_player() then
          self._lz_last_hitter = hitter
          self._lz_last_hit_time = minetest.get_gametime()
        end
        local ret = old_on_punch(self, hitter, tflp, toolcaps, dir, damage)
        if hitter and hitter.is_player and hitter:is_player() and is_vampire(hitter) then
          local entname = self.name or name
          if not LIFESTEAL_EXCLUDE_ENTS[entname] then
            local dmg = damage or 0
            if (not dmg or dmg<=0) and toolcaps then dmg = 1 end
            if dmg>0 then
              local heal = math.floor(dmg * HEAL_ON_HIT_FRACTION + 0.5)
              if heal>0 then
                hitter:set_hp(math.min(hitter:get_hp()+heal, hitter:get_properties().hp_max or 20))
              end
            end
          end
        end
        return ret
      end
    end
  end
end)

-- Award death-while-vampire, revert bat form, then cure
minetest.register_on_dieplayer(function(player)
  if is_vampire(player) then _aw_notify("vamp_death", player) end
  if is_bat(player) then revert_from_bat(player) end
  cure_player(player, false)
end)

-- Periodic: burn in day
local accum = 0
minetest.register_globalstep(function(dtime)
  accum = accum + dtime
  if accum < 1.0 then return end
  accum = 0
  for _, player in ipairs(minetest.get_connected_players()) do
    if is_vampire(player) then
      burn_vampire_if_sunlit(player)
    end
  end
end)

-- ================================
-- Vampire Mob (unchanged)
-- ================================
mobs:register_mob("lumberjackzombie:vampire", {
  type="monster", passive=false, attack_type="dogfight", attack_npcs=false,
  group_attack=true, pathfinding=true, reach=3, damage=3,
  hp_min=5, hp_max=350, light_damage=19, armor=100,
  visual="mesh", mesh="zombie_normal.b3d", textures={{"v1.png"}},
  makes_footstep_sound=true, sounds={ random="zombie_angry", death="zombie_death" },
  walk_velocity=1, run_velocity=3, jump_height=2, stepheight=1.1, floats=0, view_range=35,
  drops = {
    {name="default:gold_ingot", chance=1, min=0, max=9},
    {name="default:silverbar",  chance=12, min=0, max=9},
    {name="default:rustysword", chance=3, min=0, max=1},
    {name="tinkering:silver_sword", chance=4, min=0, max=1},
    {name="tinkering:csteel_shovel",chance=5, min=0, max=1},
    {name="default:copper_ingot",   chance=4, min=0, max=9},
    {name="default:ironbar",        chance=5, min=0, max=9},
    {name="default:coal",           chance=3, min=0, max=9},
    {name="default:fopal",          chance=9, min=0, max=1},
    {name="default:diamond",        chance=9, min=0, max=1},
    {name="default:peridot",        chance=9, min=0, max=1},
    {name="default:ruby",           chance=9, min=0, max=1},
    {name="default:emerald",        chance=9, min=0, max=1},
    {name="default:btopaz",         chance=9, min=0, max=1},
  },
  animation = {
    speed_normal=44, speed_run=44, punch_speed=20,
    stand_start=0, stand_end=40, walk_start=41, walk_end=101,
    run_start=41, run_end=101, punch_start=102, punch_end=142,
  },
  collisionbox={-0.25,-1,-0.3, 0.25,0.75,0.3},
  on_die=function(self)
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
  {"group:crumbly","default:dirt_with_grass"}, 15, 0, 12000, 1, 31000, false)

mobs:register_egg("lumberjackzombie:vampire", "Vampire", "zombies_egg.png", 0)

