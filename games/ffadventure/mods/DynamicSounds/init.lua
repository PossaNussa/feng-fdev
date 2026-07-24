-- DynamicSounds: Occlusion and simple reflections for Luanti (Minetest)
-- MIT License

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

local S = minetest.get_translator and minetest.get_translator(modname) or function(s) return s end

-- Keep original sound_play to avoid recursion when wrapping
local ORIG_SOUND_PLAY = minetest.sound_play
local ORIG_SOUND_STOP = minetest.sound_stop
local ORIG_SOUND_FADE = minetest.sound_fade
-- Forward declaration for internal sound play helper used by callbacks defined above
local base_sound_play

-- SETTINGS
local enable_wrapper = minetest.settings:get_bool("dynamicsounds.enable_wrapper")
if enable_wrapper == nil then enable_wrapper = true end
local OCCLUSION_STRENGTH = tonumber(minetest.settings:get("dynamicsounds.occlusion_strength")) or 0.7
local RAYCAST_STEP = tonumber(minetest.settings:get("dynamicsounds.raycast_step")) or 0.5
local MAX_TRACE_NODES = tonumber(minetest.settings:get("dynamicsounds.max_trace_nodes")) or 64
local SPEED_OF_SOUND = tonumber(minetest.settings:get("dynamicsounds.speed_of_sound")) or 340
local MAX_REFLECTIONS = tonumber(minetest.settings:get("dynamicsounds.max_reflections")) or 4
local ECHO_DECAY = tonumber(minetest.settings:get("dynamicsounds.echo_decay")) or 0.65
-- Enclosure and reverb settings
local ENC_PROBE_STEPS = tonumber(minetest.settings:get("dynamicsounds.enclosure_probe_steps")) or 6
local ENC_OCCLUSION_BOOST = tonumber(minetest.settings:get("dynamicsounds.enclosure_occlusion_boost")) or 0.5
local ENC_REFLECTION_BOOST = tonumber(minetest.settings:get("dynamicsounds.enclosure_reflection_boost")) or 1.0
local LATE_REVERB_TAPS = tonumber(minetest.settings:get("dynamicsounds.late_reverb_taps")) or 6
local LATE_REVERB_DECAY = tonumber(minetest.settings:get("dynamicsounds.late_reverb_decay")) or 0.7
local LATE_REVERB_MIN_MS = tonumber(minetest.settings:get("dynamicsounds.late_reverb_min_ms")) or 80
local LATE_REVERB_MAX_MS = tonumber(minetest.settings:get("dynamicsounds.late_reverb_max_ms")) or 450
-- Non-positional and reflection realism
local PROCESS_NON_POSITIONAL = minetest.settings:get_bool("dynamicsounds.process_non_positional", true) ~= false
local AMBIENT_COVER_MUFFLE = tonumber(minetest.settings:get("dynamicsounds.ambient_cover_muffle")) or 0.6
local REFLECTION_RAYCAST = minetest.settings:get_bool("dynamicsounds.reflection_raycast", true) ~= false
-- Room and echo realism
local ROOM_PROBE_MAXDIST = tonumber(minetest.settings:get("dynamicsounds.room_probe_maxdist")) or 40
local RT60_SCALE = tonumber(minetest.settings:get("dynamicsounds.rt60_scale")) or 0.15 -- overall reverb length scale
local REFLECTION_ABSORB = tonumber(minetest.settings:get("dynamicsounds.reflection_absorb")) or 0.25 -- per-bounce amplitude loss proxy
local REVERB_TAP_DENSITY = tonumber(minetest.settings:get("dynamicsounds.reverb_tap_density")) or 60 -- taps/sec
local PITCH_MUFFLE_AMOUNT = tonumber(minetest.settings:get("dynamicsounds.pitch_muffle_amount")) or 0.02
local MIN_REFLECTION_DELAY_MS = tonumber(minetest.settings:get("dynamicsounds.min_reflection_delay_ms")) or 45
local LATE_REVERB_PREDELAY_MS = tonumber(minetest.settings:get("dynamicsounds.late_reverb_predelay_ms")) or 70
-- Occluded echo helpers
local OCCLUDED_REFLECTION_BOOST = tonumber(minetest.settings:get("dynamicsounds.occluded_reflection_boost")) or 0.6
local OCCLUDED_MIN_REFLECTION_DELAY_MS = tonumber(minetest.settings:get("dynamicsounds.occluded_min_reflection_delay_ms")) or 18
local OCCLUDED_DIFFUSE_SPILL = minetest.settings:get_bool("dynamicsounds.occluded_diffuse_spill", true) ~= false
local OCCLUDED_DIRECT_GAIN_FLOOR = tonumber(minetest.settings:get("dynamicsounds.occluded_direct_gain_floor")) or 0.06
local REVERB_TAIL_MIN_GAIN = tonumber(minetest.settings:get("dynamicsounds.reverb_tail_min_gain")) or 0.22
-- Indoor/Outdoor cross-case controls (reduce outdoor animal echo indoors)
local INDOOR_OUTDOOR_REFLECTION_MULT = tonumber(minetest.settings:get("dynamicsounds.indoor_outdoor_reflection_mult")) or 0.35
local INDOOR_OUTDOOR_SKIP_TAIL = minetest.settings:get_bool("dynamicsounds.indoor_outdoor_skip_tail", true) ~= false
local INDOOR_OUTDOOR_DISABLE_SPILL = minetest.settings:get_bool("dynamicsounds.indoor_outdoor_disable_spill", true) ~= false
local INDOOR_OUTDOOR_EXTRA_OCCLUSION = tonumber(minetest.settings:get("dynamicsounds.indoor_outdoor_extra_occlusion")) or 0.2
-- Material reflectivity and near distance floor
local MATERIAL_REFLECTIVITY_RAW = minetest.settings:get("dynamicsounds.material_reflectivity") or 
  "stone:0.95,metal:0.97,glass:0.9,ice:0.85,wood:0.6,dirt:0.35,sand:0.3,gravel:0.35,wool:0.15,leaves:0.1,water:0.05"
local SECONDARY_REFLECTIONS = minetest.settings:get_bool("dynamicsounds.secondary_reflections", true)
local MAX_SECONDARY_REFLECTIONS = tonumber(minetest.settings:get("dynamicsounds.max_secondary_reflections")) or 2
local NEAR_DISTANCE = tonumber(minetest.settings:get("dynamicsounds.near_distance")) or 1.8
local NEAR_MIN_DIRECT_GAIN = tonumber(minetest.settings:get("dynamicsounds.near_min_direct_gain")) or 0.2
-- Non-positional classification
local NONPOS_PROFILE = (minetest.settings:get("dynamicsounds.nonpos_profile") or "smart"):lower()
local AMBIENT_NAME_PATTERNS = (minetest.settings:get("dynamicsounds.ambient_name_patterns") or "rain,weather,ambient,wind,water,fire"):lower()
local UI_NAME_PATTERNS = (minetest.settings:get("dynamicsounds.ui_name_patterns") or "pickup,item,click,ui,pop,xp"):lower()
local FOOTSTEP_NAME_PATTERNS = (minetest.settings:get("dynamicsounds.footstep_name_patterns") or "footstep,step,walk,run,land,jump"):lower()
-- Close-range occlusion relaxation and sampling offset
local NEAR_OCCLUSION_RELAX = tonumber(minetest.settings:get("dynamicsounds.near_occlusion_relax")) or 0.5
local NEAR_OCCLUSION_DISTANCE = tonumber(minetest.settings:get("dynamicsounds.near_occlusion_distance")) or 2.0
local OCCLUSION_START_OFFSET = tonumber(minetest.settings:get("dynamicsounds.occlusion_start_offset")) or 0.6
local MATERIAL_FACTORS_RAW = minetest.settings:get("dynamicsounds.material_muffle_factor") or
  "stone:0.9,wood:0.6,leaves:0.2,glass:0.3,metal:0.8,water:0.9"
-- Group handle auto-cleanup TTL (seconds). 0 disables auto-cleanup.
local HANDLE_TTL = tonumber(minetest.settings:get("dynamicsounds.handle_ttl")) or 0

-- Parse material factors
local MATERIAL_FACTORS = {}
for pair in MATERIAL_FACTORS_RAW:gmatch("[^,]+") do
  local k, v = pair:match("%s*([^:]+)%s*:%s*([%d%.]+)%s*")
  if k and v then
    MATERIAL_FACTORS[k] = tonumber(v) or 0.5
  end
end

local MATERIAL_REFLECT = {}
for pair in MATERIAL_REFLECTIVITY_RAW:gmatch("[^,]+") do
  local k, v = pair:match("%s*([^:]+)%s*:%s*([%d%.]+)%s*")
  if k and v then
    MATERIAL_REFLECT[k] = tonumber(v) or 0.5
  end
end

-- UTILITIES
-- ensure table.copy exists
if not table.copy then
  function table.copy(orig)
    if type(orig) ~= 'table' then return orig end
    local copy = {}
    for k, v in pairs(orig) do
      copy[k] = table.copy(v)
    end
    return copy
  end
end
local function clamp(x, a, b)
  if x < a then return a end
  if x > b then return b end
  return x
end

local function len(v)
  return math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
end

local function sub(a,b) return {x=a.x-b.x, y=a.y-b.y, z=a.z-b.z} end
local function add(a,b) return {x=a.x+b.x, y=a.y+b.y, z=a.z+b.z} end
local function muls(a,s) return {x=a.x*s, y=a.y*s, z=a.z*s} end

local function normalize(v)
  local l = len(v)
  if l <= 1e-6 then return {x=0,y=0,z=0}, 0 end
  return {x=v.x/l, y=v.y/l, z=v.z/l}, l
end

local function rand_unit_vec()
  local x = math.random()*2-1
  local y = math.random()*2-1
  local z = math.random()*2-1
  local v, l = normalize({x=x,y=y,z=z})
  if l == 0 then return {x=1,y=0,z=0} end
  return v
end

local function split_csv(str)
  local t = {}
  for part in (str or ""):gmatch("[^,]+") do
    local s = part:gsub("^%s+",""):gsub("%s+$","")
    if s ~= "" then table.insert(t, s) end
  end
  return t
end

local AMBIENT_PAT_LIST = split_csv(AMBIENT_NAME_PATTERNS)
local UI_PAT_LIST = split_csv(UI_NAME_PATTERNS)
local FOOTSTEP_PAT_LIST = split_csv(FOOTSTEP_NAME_PATTERNS)

local function matches_any(name, list)
  if not name then return false end
  local lname = tostring(name):lower()
  for _,p in ipairs(list) do
    if lname:find(p, 1, true) then return true end
  end
  return false
end

local function get_sound_name(spec)
  if type(spec) == "string" then return spec end
  if type(spec) == "table" then
    if type(spec.name) == "string" then return spec.name end
    if type(spec[1]) == "string" then return spec[1] end
  end
  return nil
end

local function get_player_ear_pos(player)
  local pos = player:get_pos()
  local eye_h = player.get_eye_height and player:get_eye_height() or 1.5
  return {x=pos.x, y=(pos.y or 0) + eye_h, z=pos.z}
end

-- Check if position is open to sky (simple upward ray test)
local function sky_open_at(pos)
  if not pos then return false end
  local start = {x=pos.x, y=pos.y + 0.5, z=pos.z}
  local stop = {x=pos.x, y=pos.y + 30, z=pos.z}
  local ray = minetest.raycast(start, stop, false, true)
  for pointed in ray do
    if pointed.type == "node" then
      local npos = pointed.under or pointed.above
      if npos then
        local name = minetest.get_node(npos).name
        local def = name and minetest.registered_nodes[name]
        if def then
          local g = def.groups or {}
          -- treat solid, non-window leaves/glass as sky blockers; allow leaves/glass to pass as "open"
          local is_glass = g.glass or name:find("glass", 1, true)
          local is_leaves = g.leaves or name:find("leaves", 1, true)
          if def.walkable and not is_glass and not is_leaves then
            return false
          end
        end
      end
    end
  end
  return true
end

-- Aggregated handle registry (group id -> list of engine handles)
local DS_HANDLE_COUNTER = 100000
local DS_HANDLES = {}
local CLEAN_INTERVAL = 15 -- seconds between sweeps
local function now_us() return (minetest.get_us_time and minetest.get_us_time()) or (os.time() * 1000000) end
local function ds_new_group_handle()
  DS_HANDLE_COUNTER = DS_HANDLE_COUNTER + 1
  DS_HANDLES[DS_HANDLE_COUNTER] = { sub = {}, last_us = now_us(), persistent = false }
  return DS_HANDLE_COUNTER
end
local function ds_add_subhandle(group_id, handle)
  if type(group_id) == 'number' and DS_HANDLES[group_id] and type(handle) == 'number' then
    table.insert(DS_HANDLES[group_id].sub, handle)
    DS_HANDLES[group_id].last_us = now_us()
  end
end

-- periodic cleanup of non-persistent groups after HANDLE_TTL seconds of inactivity
local function ds_cleanup_sweep()
  if HANDLE_TTL and HANDLE_TTL > 0 then
    local cutoff_us = HANDLE_TTL * 1000000
    local tnow = now_us()
    for gid,entry in pairs(DS_HANDLES) do
      if entry and not entry.persistent then
        local last = entry.last_us or tnow
        if (tnow - last) > cutoff_us then
          DS_HANDLES[gid] = nil
        end
      end
    end
  end
  minetest.after(CLEAN_INTERVAL, ds_cleanup_sweep)
end
-- start cleaner
minetest.after(CLEAN_INTERVAL, ds_cleanup_sweep)

-- SIMPLE MATERIAL MUFFLE ACCUMULATION via ray stepping
local function occlusion_factor(src_pos, ear_pos)
  local dir, dist = normalize(sub(ear_pos, src_pos))
  if dist < 0.5 then return 1.0 end

  -- step along the path in RAYCAST_STEP increments, up to MAX_TRACE_NODES
  local start_off = math.min(OCCLUSION_START_OFFSET, dist * 0.5)
  local steps = math.min(MAX_TRACE_NODES, math.floor((dist - start_off) / RAYCAST_STEP))
  if steps <= 0 then return 1.0 end

  local occl = 1.0
  local p = add(src_pos, muls(dir, start_off))
  for i=1,steps do
    p = add(p, muls(dir, RAYCAST_STEP))
    local nodepos = {x=math.floor(p.x+0.5), y=math.floor(p.y+0.5), z=math.floor(p.z+0.5)}
    local node = minetest.get_node_or_nil(nodepos)
    if node and node.name then
      if node.name ~= "air" and node.name ~= "ignore" then
        local def = minetest.registered_nodes[node.name]
        if def then
          -- treat walkable or liquids as occluding; check common groups
          local is_occluding = (def.walkable ~= false) or (def.liquidtype and def.liquidtype ~= "none")
          if is_occluding then
            local mf = 0.5
            local g = def.groups or {}
            -- accumulate weighted by strongest matching group
            for k, factor in pairs(MATERIAL_FACTORS) do
              if g[k] and g[k] > 0 then
                mf = math.max(mf, factor)
              end
            end
            -- apply occlusion: reduce effective gain by OCCLUSION_STRENGTH * mf
            occl = occl * (1.0 - OCCLUSION_STRENGTH * clamp(mf, 0, 1))
            -- early exit if almost fully occluded
            if occl < 0.1 then return occl end
          end
        end
      end
    end
  end
  return clamp(occl, 0.05, 1.0)
end

-- Enclosure factor near the ear: sample 6 axes for nearby occluders
local function enclosure_factor(ear_pos)
  local dirs = {
    {x=1,y=0,z=0}, {x=-1,y=0,z=0}, {x=0,y=1,z=0}, {x=0,y=-1,z=0}, {x=0,y=0,z=1}, {x=0,y=0,z=-1},
  }
  local blocked = 0
  local up_open = true
  for _,d in ipairs(dirs) do
    local p = {x=ear_pos.x, y=ear_pos.y, z=ear_pos.z}
    local hit = false
    for i=1,ENC_PROBE_STEPS do
      p = add(p, d)
      local node = minetest.get_node_or_nil({x=math.floor(p.x+0.5), y=math.floor(p.y+0.5), z=math.floor(p.z+0.5)})
      if node and node.name and node.name ~= "air" and node.name ~= "ignore" then
        local def = minetest.registered_nodes[node.name]
        if def and ((def.walkable ~= false) or (def.liquidtype and def.liquidtype ~= "none")) then
          hit = true
          break
        end
      end
    end
    if hit then blocked = blocked + 1 end
    if d.x == 0 and d.z == 0 and d.y == 1 and hit then
      up_open = false
    end
  end
  local f = blocked / #dirs
  -- If upward is open and not very blocked, diminish enclosure
  if up_open and f < 0.6 then f = f * 0.5 end
  local cover = up_open and 0 or 1
  return clamp(f, 0.0, 1.0), cover
end

-- Simple reflection: cast a few rays around normal directions to find nearby surfaces
local function compute_reflections(src_pos, ear_pos)
  if MAX_REFLECTIONS <= 0 then return {} end
  local reflections = {}

  -- sample 6 axis directions from midpoint
  local mid = muls(add(src_pos, ear_pos), 0.5)
  local dirs = {
    {x=1,y=0,z=0}, {x=-1,y=0,z=0}, {x=0,y=1,z=0}, {x=0,y=-1,z=0}, {x=0,y=0,z=1}, {x=0,y=0,z=-1},
  }
  local checked = 0
  for _,d in ipairs(dirs) do
    if checked >= MAX_REFLECTIONS then break end
    -- march up to a few nodes to find first solid
    local hit_pos
    local p = {x=mid.x, y=mid.y, z=mid.z}
    for i=1,6 do
      p = add(p, d)
      local node = minetest.get_node_or_nil({x=math.floor(p.x+0.5), y=math.floor(p.y+0.5), z=math.floor(p.z+0.5)})
      if node and node.name and node.name ~= "air" then
        local def = minetest.registered_nodes[node.name]
        if def and def.walkable ~= false then
          hit_pos = {x=p.x, y=p.y, z=p.z}
          break
        end
      end
    end
    if hit_pos then
      checked = checked + 1
      -- reflect source around the hit plane approximately by mirroring across hit_pos
      local image_src = add(hit_pos, sub(hit_pos, src_pos))
      local path_len = len(sub(image_src, ear_pos))
      local delay = path_len / SPEED_OF_SOUND
      table.insert(reflections, {pos=image_src, delay=delay})
    end
  end
  return reflections
end

-- Raycast-based reflections for more realistic early echoes
local function compute_reflections_raycast(src_pos, ear_pos, encf)
  if MAX_REFLECTIONS <= 0 then return {} end
  local results = {}
  local maxdist = math.max(20, ROOM_PROBE_MAXDIST)
  local tries = math.max(MAX_REFLECTIONS * 3, 6)
  local bias = sub(ear_pos, src_pos)
  local dir_main, _ = normalize(bias)
  for i=1,tries do
    local jitter = rand_unit_vec()
    -- bias around main axis
    local dir = normalize(add(muls(dir_main, 0.7), muls(jitter, 0.3)))
    local ray = minetest.raycast(ear_pos, add(ear_pos, muls(dir, maxdist)), false, true)
    for pointed in ray do
      if pointed.type == "node" then
        local np = pointed.under or pointed.above or pointed.intersection_point
        if np then
          local hit = {x=np.x+0.5, y=np.y+0.5, z=np.z+0.5}
          -- compute path length source->hit->ear
          local L = len(sub(hit, src_pos)) + len(sub(ear_pos, hit))
          local delay = L / SPEED_OF_SOUND
          -- estimate reflectivity from node groups
          local npos = pointed.under or pointed.above
          local name = npos and minetest.get_node(npos).name
          local refl = 0.6
          if name then
            local def = minetest.registered_nodes[name]
            if def then
              local g = def.groups or {}
              for k,f in pairs(MATERIAL_REFLECT) do
                if g[k] and g[k] > 0 then
                  refl = math.max(refl, f)
                end
              end
            end
          end
          refl = clamp(refl, 0.05, 0.98)
          table.insert(results, {pos=hit, delay=delay, refl=refl})
        end
        break
      end
    end
    if #results >= MAX_REFLECTIONS then break end
  end
  -- Add small jitter to delays to avoid metallic ringing
  for _,r in ipairs(results) do
    local j = (math.random()*2 - 1) * 0.015 -- +/-15ms
    r.delay = math.max(0, r.delay + j)
  end
  return results
end

-- Optional secondary bounces from first hits
local function compute_secondary_bounces(ear_pos, first_refs)
  if not SECONDARY_REFLECTIONS or MAX_SECONDARY_REFLECTIONS <= 0 then return {} end
  local secs = {}
  for _,r in ipairs(first_refs) do
    local dir_to_ear, _ = normalize(sub(ear_pos, r.pos))
    for i=1,MAX_SECONDARY_REFLECTIONS do
      local jitter = rand_unit_vec()
      local dir = normalize(add(muls(dir_to_ear, 0.6), muls(jitter, 0.4)))
      local ray = minetest.raycast(r.pos, add(r.pos, muls(dir, ROOM_PROBE_MAXDIST)), false, true)
      for pointed in ray do
        if pointed.type == "node" then
          local np = pointed.under or pointed.above or pointed.intersection_point
          if np then
            local hit = {x=np.x+0.5, y=np.y+0.5, z=np.z+0.5}
            local npos = pointed.under or pointed.above
            local name = npos and minetest.get_node(npos).name
            local refl2 = 0.6
            if name then
              local def = minetest.registered_nodes[name]
              if def then
                local g = def.groups or {}
                for k,f in pairs(MATERIAL_REFLECT) do
                  if g[k] and g[k] > 0 then
                    refl2 = math.max(refl2, f)
                  end
                end
              end
            end
            refl2 = clamp(refl2, 0.05, 0.98)
            table.insert(secs, {pos=hit, parent=r, refl=refl2})
          end
          break
        end
      end
    end
  end
  return secs
end

-- Probe room by 6-axis distances from ear; approximate a rectangular room box
local function probe_room_box(ear_pos)
  local axes = {
    {k="+x", d={x=1,y=0,z=0}}, {k="-x", d={x=-1,y=0,z=0}},
    {k="+y", d={x=0,y=1,z=0}}, {k="-y", d={x=0,y=-1,z=0}},
    {k="+z", d={x=0,y=0,z=1}}, {k="-z", d={x=0,y=0,z=-1}},
  }
  local dist = {}
  for _,a in ipairs(axes) do
    local ray = minetest.raycast(ear_pos, add(ear_pos, muls(a.d, ROOM_PROBE_MAXDIST)), false, true)
    local hitdist = ROOM_PROBE_MAXDIST
    for pointed in ray do
      if pointed.type == "node" then
        local p = pointed.under or pointed.above or pointed.intersection_point
        if p then
          hitdist = len(sub(p, ear_pos))
        end
        break
      end
    end
    dist[a.k] = hitdist
  end
  local dx = math.max(2, dist["+x"] + dist["-x"])
  local dy = math.max(2, dist["+y"] + dist["-y"])
  local dz = math.max(2, dist["+z"] + dist["-z"])
  return dx, dy, dz
end

-- Compute RT60 using a coarse Sabine-like estimate for a box room
local function compute_rt60(dx, dy, dz)
  local V = dx * dy * dz
  local S = 2*(dx*dy + dy*dz + dx*dz)
  local alpha = clamp(1.0 - REFLECTION_ABSORB, 0.05, 0.95) -- reflectivity -> absorption approx
  local T60 = RT60_SCALE * (V / (S * (1.0 - alpha) + 1e-3))
  return clamp(T60, 0.15, 4.0)
end

-- Schedule an RT60-based reverb tail around ear
local function schedule_rt60_tail(spec, base_params, ear_pos, base_gain, base_pitch, T60, encf, dims, aggregator)
  if REVERB_TAP_DENSITY <= 0 then return end
  local taps = math.min(math.floor(REVERB_TAP_DENSITY * T60), 240)
  if taps <= 0 then return end
  local dx,dy,dz = dims[1], dims[2], dims[3]
  local avg_dim = (dx + dy + dz) / 3
  local radius = 2 + 0.15 * avg_dim + 4 * encf
  for i=1,taps do
    local t = (LATE_REVERB_PREDELAY_MS/1000.0) + (i / taps) * T60 * 1.1 -- predelay then spread slightly beyond T60
    local amp = base_gain * math.pow(10, -3 * t / math.max(T60, 0.001))
    if amp < 0.008 then break end
    local v = rand_unit_vec()
    local pos = add(ear_pos, muls(v, radius))
    local rp = table.copy(base_params)
    rp.pos = pos
    rp.gain = amp
    rp.pitch = base_pitch
    minetest.after(t, function()
      local hh = base_sound_play(spec, rp)
      if aggregator and hh then aggregator(hh) end
    end)
  end
end

-- PLAYBACK
base_sound_play = function(spec, params, ephemeral)
  return ORIG_SOUND_PLAY(spec, params, ephemeral)
end

-- Core per-player processed playback
local function play_processed(spec, params, only_player_name, aggregator)
  params = params or {}
  local src_pos = params.pos
  if (not src_pos) and params.object and params.object.get_pos then
    src_pos = params.object:get_pos()
  end

  if not src_pos then
    -- non-positional sound: just play normally
    return base_sound_play(spec, params)
  end

  local handles = {}
  local players
  if only_player_name then
    local p = minetest.get_player_by_name(only_player_name)
    players = p and {p} or {}
  else
    players = minetest.get_connected_players()
  end

  for _,player in ipairs(players) do
    local ear = get_player_ear_pos(player)
    local base_gain = params.gain or 1.0
    local base_pitch = params.pitch or 1.0
    local maxdist = params.max_hear_distance or 32

    -- distance attenuation similar to engine's, but we piggyback by altering gain
    local d = len(sub(ear, src_pos))
    if d <= maxdist then
      local encf, cover = enclosure_factor(ear)
      local occl = occlusion_factor(src_pos, ear)
      local occ_strength = clamp(1.0 - occl, 0.0, 1.0) -- 0 open, 1 fully blocked
      -- Indoor/outdoor cross detection: ear likely indoors (covered/enclosed), source likely outdoors (sky-open)
      local ear_indoors = (cover == 1) or (encf > 0.5)
      local src_outdoor = sky_open_at(src_pos)
      local indoor_outdoor_cross = ear_indoors and src_outdoor and (occ_strength > 0.25)
      -- Boost occlusion in enclosed spaces by exponentiating
      occl = math.pow(occl, 1.0 + ENC_OCCLUSION_BOOST * encf)

      -- gentler pitch shift to avoid underwater feel; none when very close
      local pitch
      if d < 1.6 then
        pitch = base_pitch
      else
        pitch = clamp(base_pitch * (1.0 - PITCH_MUFFLE_AMOUNT*(1.0-occl)), 0.9, 1.25)
      end

      -- combine occlusion with base gain; also slight extra attenuation with distance
      local dist_factor = clamp(1.0 - (d / (maxdist+0.001)) * 0.5, 0.2, 1.0)
      -- relax occlusion when very close to avoid underwater feel
      if d < NEAR_OCCLUSION_DISTANCE then
        local exp = clamp(1.0 - NEAR_OCCLUSION_RELAX, 0.1, 1.0)
        occl = math.pow(occl, exp)
      end
      local gain = base_gain * occl * dist_factor
      -- ensure a tiny floor when heavily occluded, to keep presence around corners
      if occ_strength > 0.45 and d > 1.2 then
        gain = math.max(gain, base_gain * OCCLUDED_DIRECT_GAIN_FLOOR)
      end
      -- apply extra dampening if source is outside and listener is inside
      if indoor_outdoor_cross then
        gain = gain * clamp(1.0 - INDOOR_OUTDOOR_EXTRA_OCCLUSION, 0.2, 1.0)
      end
      if d < NEAR_DISTANCE then
        gain = math.max(gain, base_gain * NEAR_MIN_DIRECT_GAIN)
      end

      if gain > 0.02 then
        local p = table.copy(params)
        p.to_player = player:get_player_name()
        p.gain = gain
        p.pitch = pitch
        -- play direct sound for this listener
        local h = base_sound_play(spec, p)
        if h then
          table.insert(handles, h)
          if aggregator then aggregator(h) end
        end

        -- reflections
        local refs = REFLECTION_RAYCAST and compute_reflections_raycast(src_pos, ear, encf) or compute_reflections(src_pos, ear)
        -- Boost reflections in enclosed spaces
        local name = get_sound_name(spec)
        local is_step = matches_any(name, FOOTSTEP_PAT_LIST)
        local ref_boost = clamp(1.0 + ENC_REFLECTION_BOOST * encf + (is_step and 0.2 or 0.0), 1.0, 2.7)
        -- If the direct path is occluded, add extra boost so echoes carry around corners
        ref_boost = ref_boost * (1.0 + occ_strength * OCCLUDED_REFLECTION_BOOST)
        -- But if the situation is outdoor->indoor across a wall, reduce reflections so outdoor animals don't echo indoors
        if indoor_outdoor_cross then
          ref_boost = ref_boost * INDOOR_OUTDOOR_REFLECTION_MULT
        end
        local r_gain = gain * ref_boost
  local r_pitch = base_pitch -- keep reflections neutral in tone
        -- If very close to source, skip early reflections to avoid double-hit perception
        local allow_refs = not (d < 1.6)
        -- But if occluded and somewhat enclosed, allow refs even when near (sound wraps around)
        if occ_strength > 0.35 and encf > 0.2 then
          allow_refs = true
        end
        local min_delay_s = ((occ_strength > 0.35 and encf > 0.2) and OCCLUDED_MIN_REFLECTION_DELAY_MS or MIN_REFLECTION_DELAY_MS) / 1000.0
        if is_step and encf >= 0.4 then
          -- allow some reflections for footsteps in enclosed spaces even when near
          allow_refs = true
        end
        for i,ref in ipairs(refs) do
          if not allow_refs then break end
          if (ref.delay or 0) < min_delay_s then
            -- skip too-early reflections (Haas window)
            goto continue_ref
          end
          r_gain = r_gain * (ref.refl or 0.7) * ECHO_DECAY
          if r_gain < 0.02 then break end
          local rp = table.copy(params)
          rp.to_player = player:get_player_name()
          rp.pos = ref.pos
          rp.gain = r_gain
          rp.pitch = r_pitch
          -- schedule delayed reflection
          local ag = aggregator
          minetest.after(ref.delay, function()
            local hh = base_sound_play(spec, rp)
            if ag and hh then ag(hh) end
          end)
          ::continue_ref::
        end

        if allow_refs and SECONDARY_REFLECTIONS and REFLECTION_RAYCAST and not indoor_outdoor_cross then
          local secs = compute_secondary_bounces(ear, refs)
          local sgain = r_gain * 0.7
          for _,s in ipairs(secs) do
            local L2 = len(sub(s.pos, s.parent.pos)) + len(sub(ear, s.pos))
            local base_delay = (s.parent.delay or 0) + (L2 / SPEED_OF_SOUND)
            if base_delay >= (MIN_REFLECTION_DELAY_MS/1000.0) then
              sgain = sgain * (ECHO_DECAY * s.refl)
              if sgain < 0.015 then break end
              local rp2 = table.copy(params)
              rp2.to_player = player:get_player_name()
              rp2.pos = s.pos
              rp2.gain = sgain
              rp2.pitch = r_pitch
              local ag = aggregator
              minetest.after(base_delay, function()
                local hh = base_sound_play(spec, rp2)
                if ag and hh then ag(hh) end
              end)
            end
          end
        end

        -- RT60-based late reverb tail in enclosed spaces
        if encf > 0.3 and (d > 3.0 or encf > 0.6) and not (indoor_outdoor_cross and INDOOR_OUTDOOR_SKIP_TAIL) then
          local dx, dy, dz = probe_room_box(ear)
          local T60 = compute_rt60(dx, dy, dz)
          local bp = table.copy(params)
          bp.to_player = player:get_player_name()
          -- Ensure a minimum late tail presence even if direct is heavily occluded
          local tail_base = math.max(gain * 0.8, base_gain * REVERB_TAIL_MIN_GAIN * (0.6 + 0.4*encf) * (1.0 + 0.3*occ_strength))
          schedule_rt60_tail(spec, bp, ear, tail_base, base_pitch, T60, encf, {dx,dy,dz}, aggregator)
        end

        -- Diffuse spill: small, short taps around the ear to simulate diffraction around corners
        if OCCLUDED_DIFFUSE_SPILL and not (indoor_outdoor_cross and INDOOR_OUTDOOR_DISABLE_SPILL) and occ_strength > 0.45 and encf > 0.25 then
          local taps = 2 + (encf > 0.6 and 1 or 0)
          local spill_gain = base_gain * 0.18 * occ_strength * (0.5 + 0.5*encf)
          for i=1,taps do
            local v = rand_unit_vec()
            local pos = add(ear, muls(v, 1.5 + 1.5*encf))
            local delay = 0.06 + 0.05*i + math.random()*0.03
            local rp = table.copy(params)
            rp.to_player = player:get_player_name()
            rp.pos = pos
            rp.gain = spill_gain
            rp.pitch = base_pitch
            local ag = aggregator
            minetest.after(delay, function()
              local hh = base_sound_play(spec, rp)
              if ag and hh then ag(hh) end
            end)
          end
        end
      end
    end
  end

  return handles
end

-- Process non-positional sounds (rain/ambient/animals targeting player without pos)
local function play_processed_nonpositional(spec, params, only_player_name, aggregator)
  if not PROCESS_NON_POSITIONAL then
    return base_sound_play(spec, params)
  end
  local handles = {}
  local players
  if only_player_name then
    local p = minetest.get_player_by_name(only_player_name)
    players = p and {p} or {}
  else
    players = minetest.get_connected_players()
  end
  for _,player in ipairs(players) do
    local ear = get_player_ear_pos(player)
    local base_gain = params.gain or 1.0
    local base_pitch = params.pitch or 1.0
    local encf, cover = enclosure_factor(ear)
    local name = get_sound_name(spec)
  local ambient_match = matches_any(name, AMBIENT_PAT_LIST)
  local ui_match = matches_any(name, UI_PAT_LIST)
  local footstep_match = matches_any(name, FOOTSTEP_PAT_LIST)

    local mode = NONPOS_PROFILE
    if mode == "smart" then
      if ambient_match then mode = "ambient" else mode = "ui" end
    end

  if mode == "ui" and not footstep_match then
      -- UI-like feedback: no pitch change, no reflections, minimal gain change
      local p = table.copy(params)
      p.to_player = player:get_player_name()
      p.gain = base_gain
      p.pitch = base_pitch
      local h = base_sound_play(spec, p)
      if h then
        table.insert(handles, h)
        if aggregator then aggregator(h) end
      end
    else
      -- Ambient-like: apply cover occlusion and enclosure reverb
      local occl = clamp(1.0 - AMBIENT_COVER_MUFFLE * cover, 0.2, 1.0)
      local pitch = base_pitch -- keep natural
      local gain = base_gain * occl

      local p = table.copy(params)
      p.to_player = player:get_player_name()
      p.gain = gain
      p.pitch = pitch
      local h = base_sound_play(spec, p)
      if h then
        table.insert(handles, h)
        if aggregator then aggregator(h) end
      end

      if encf > 0.3 then
        local ref_boost = clamp(1.0 + ENC_REFLECTION_BOOST * encf, 1.0, 2.5)
        local r_gain = gain * 0.5 * ref_boost * (footstep_match and 1.15 or 1.0)
        local taps = math.min(MAX_REFLECTIONS, 4)
        for i=1,taps do
          r_gain = r_gain * ECHO_DECAY
          if r_gain < 0.02 then break end
          local v = rand_unit_vec()
          local pos = add(ear, muls(v, 2 + 4*encf))
          local delay = 0.06 + 0.08*i + encf*0.05*math.random()
          local rp = table.copy(params)
          rp.to_player = player:get_player_name()
          rp.pos = pos
          rp.gain = r_gain
          rp.pitch = base_pitch
          local ag = aggregator
          minetest.after(delay, function()
            local hh = base_sound_play(spec, rp)
            if ag and hh then ag(hh) end
          end)
        end
        -- Late tail as well
        if LATE_REVERB_TAPS > 0 then
          local tail_gain = gain * 0.5 * ref_boost
          local min_s = (LATE_REVERB_MIN_MS or 80) / 1000.0
          local max_s = (LATE_REVERB_MAX_MS or 450) / 1000.0
          for i=1,math.min(LATE_REVERB_TAPS, 10) do
            tail_gain = tail_gain * LATE_REVERB_DECAY
            if tail_gain < 0.01 then break end
            local v = rand_unit_vec()
            local pos = add(ear, muls(v, 3 + 5*encf))
            local delay = min_s + (max_s - min_s) * (i-1) / math.max(1, LATE_REVERB_TAPS-1)
            local rp = table.copy(params)
            rp.to_player = player:get_player_name()
            rp.pos = pos
            rp.gain = tail_gain
            rp.pitch = base_pitch
            local ag = aggregator
            minetest.after(delay, function()
              local hh = base_sound_play(spec, rp)
              if ag and hh then ag(hh) end
            end)
          end
        end
      end
    end
  end
  return handles
end

-- Public API
local dynamicsounds = {}
function dynamicsounds.play(spec, params)
  return play_processed(spec, params)
end

-- Optional wrapper
if enable_wrapper then
  local orig_play = ORIG_SOUND_PLAY
  minetest.sound_play = function(spec, params, ephemeral)
    params = params or {}
    -- Aggregate sub-sounds under a single handle for compatibility with sound_stop/fade
    local gid = ds_new_group_handle()
    -- mark persistent if caller requested loop
    if params.loop == true then
      if DS_HANDLES[gid] then DS_HANDLES[gid].persistent = true end
    end
    local function agg(h)
      ds_add_subhandle(gid, h)
    end
    -- If targeted but positional (pos/object), process for that specific player.
    if params.to_player then
      if params.pos or params.object then
        play_processed(spec, params, params.to_player, agg)
        return gid
      else
        play_processed_nonpositional(spec, params, params.to_player, agg)
        return gid
      end
    end
    if params.pos or params.object then
      play_processed(spec, params, nil, agg)
      return gid
    else
      play_processed_nonpositional(spec, params, nil, agg)
      return gid
    end
  end

  -- Wrap stop/fade to operate on group handles
  minetest.sound_stop = function(handle)
    if type(handle) == 'number' and DS_HANDLES[handle] then
      for _,h in ipairs(DS_HANDLES[handle].sub) do
        ORIG_SOUND_STOP(h)
      end
      DS_HANDLES[handle] = nil
      return
    end
    return ORIG_SOUND_STOP(handle)
  end

  minetest.sound_fade = function(handle, step, gain)
    if type(handle) == 'number' and DS_HANDLES[handle] then
      for _,h in ipairs(DS_HANDLES[handle].sub) do
        ORIG_SOUND_FADE(h, step, gain)
      end
      return
    end
    return ORIG_SOUND_FADE(handle, step, gain)
  end
end

-- Chat command for quick testing
minetest.register_chatcommand("ds_test", {
  description = S("Play a test sound with DynamicSounds (usage: /ds_test <soundname>)"),
  params = S("<soundname> (optional)"),
  privs = {},
  func = function(name, param)
    local player = minetest.get_player_by_name(name)
    if not player then return false, S("No player.") end
    local pos = player:get_pos()
    local sound = param ~= "" and param or "default_dig_metal"
    dynamicsounds.play({ name = sound }, { pos = pos, gain = 1.0, max_hear_distance = 48 })
    return true, S("Played ") .. sound
  end
})

-- export globally for other mods
_G.dynamicsounds = dynamicsounds
