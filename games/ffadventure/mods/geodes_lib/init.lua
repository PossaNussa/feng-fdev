-- geodes_lib: all-in-one replacement (fixed)
-- - Supports both `geodes_lib:register_geode({...})` and `geodes_lib.register_geode({...})`
-- - Unique per-geode technical nodes to avoid collisions
-- - Safe vector math (no table arithmetic)
-- - Robust to load order: no hard errors if nodes aren't registered yet

local modname = minetest.get_current_modname() or "geodes_lib"

geodes_lib = rawget(_G, "geodes_lib") or {}
local M = geodes_lib

-- ========= Utilities =========

local function clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function tbl_copy(t)
  local r = {}
  for i = 1, #t do r[i] = t[i] end
  return r
end

-- Place 'name' only if the current node is not air and 'name' is registered
local function set_if_solid(p, name)
  if not name or not minetest.registered_nodes[name] then return end
  local nn = minetest.get_node(p).name
  if nn ~= "air" then
    minetest.set_node(p, { name = name })
  end
end

-- ========= Geode core generator =========
-- Carves a hollow sphere, lines inner rim with crystals, builds shell layers.
local function generate_geode(center, radius, core, core_alt, core_alt_chance, shell, center_node, wherein)
  -- Filter shell list to registered nodes (placement-time check also done)
  local shell_layers = {}
  for i = 1, #shell do
    local m = shell[i]
    if minetest.registered_nodes[m] then
      shell_layers[#shell_layers + 1] = m
    end
  end
  if #shell_layers == 0 then
    -- Fallback so we still carve a cavity even if shell nodes aren't ready
    shell_layers = tbl_copy(shell)
  end

  local R = math.max(2, radius)  -- ensure minimum interior
  local R_outer = R + #shell_layers

  for dx = -R_outer, R_outer do
    for dy = -R_outer, R_outer do
      for dz = -R_outer, R_outer do
        local p = vector.add(center, { x = dx, y = dy, z = dz })
        local d = math.sqrt(dx * dx + dy * dy + dz * dz)

        if d <= R_outer + 0.5 then
          if d <= R + 0.5 then
            -- Inside the geode
            if d >= R - 0.5 then
              -- Thin inner rim: place crystals sparsely
              if math.random(1, 100) <= 65 then
                local name = core
                if core_alt and core_alt_chance and core_alt_chance > 1 then
                  if math.random(1, core_alt_chance) == 1 then
                    name = core_alt
                  end
                end
                if minetest.registered_nodes[name] then
                  set_if_solid(p, name)
                else
                  -- Fallback: keep host rock if unknown
                  if wherein and minetest.registered_nodes[wherein] then
                    set_if_solid(p, wherein)
                  end
                end
              else
                minetest.set_node(p, { name = "air" })
              end
            else
              -- Interior cavity
              minetest.set_node(p, { name = "air" })
            end
          else
            -- Shell layers outside the cavity
            if d > R then
              local idx = math.ceil(d - R)
              local mat = shell_layers[idx]
              if mat and minetest.registered_nodes[mat] then
                set_if_solid(p, mat)
              elseif wherein and minetest.registered_nodes[wherein] then
                set_if_solid(p, wherein)
              end
            end
          end
        end
      end
    end
  end

  -- Optional single node at the exact center
  if center_node and minetest.registered_nodes[center_node] then
    minetest.set_node(center, { name = center_node })
  end
end

-- ========= Registration =========

-- data fields:
-- id, wherein, y_min, y_max, scarcity, generation_chance (1..100),
-- core, core_alt, core_alt_chance, shell (list), radius_min, radius_max,
-- center_node (optional single node at the center)
function M.register_geode(self, data)
  -- Accept both colon-call and dot-call:
  --   geodes_lib:register_geode({...})  -> self=geodes_lib, data=table
  --   geodes_lib.register_geode({...})  -> self=table, data=nil
  if data == nil then
    data = self
  end

  if type(data) ~= "table" then
    error("[geodes_lib] register_geode expects a table")
  end

  local id                 = tostring(data.id or "")
  if id == "" then
    error("[geodes_lib] 'id' is required, e.g. '_ruby'")
  end

  local wherein            = data.wherein or "default:stone"
  local y_min              = tonumber(data.y_min or -31000)
  local y_max              = tonumber(data.y_max or 31000)
  local scarcity           = tonumber(data.scarcity or 32)
  local generation_chance  = clamp(tonumber(data.generation_chance or 20), 1, 100)
  local core               = data.core or "default:stone"
  local core_alt           = data.core_alt
  local core_alt_chance    = tonumber(data.core_alt_chance or 10)
  local shell              = tbl_copy(data.shell or { "default:stone" })
  local radius_min         = math.max(2, tonumber(data.radius_min or 3))
  local radius_max         = math.max(radius_min, tonumber(data.radius_max or (radius_min + 2)))
  local center_node        = data.center_node

  -- Don't hard error on unregistered nodes; mapgen may load earlier than some mods.
  if not minetest.registered_nodes[core] then
    minetest.log("warning", "[geodes_lib] core '" .. tostring(core) .. "' not registered at init; continuing")
  end
  if core_alt and not minetest.registered_nodes[core_alt] then
    minetest.log("warning", "[geodes_lib] core_alt '" .. tostring(core_alt) .. "' not registered at init; continuing")
  end
  if center_node and not minetest.registered_nodes[center_node] then
    minetest.log("warning", "[geodes_lib] center_node '" .. tostring(center_node) .. "' not registered at init; continuing")
  end

  -- Unique technical mapgen node per geode (prevents collisions)
  local tech = string.format("%s:technical_mapgen%s", modname, id)

  -- Mirror core visuals if available so debugging is easy; hide from creative
  local core_def = minetest.registered_nodes[core] or {}
  minetest.register_node(tech, {
    description = (core_def.description or core) .. " Geode Marker " .. id,
    tiles = core_def.tiles or { "default_stone.png" },
    drawtype = core_def.drawtype,
    use_texture_alpha = core_def.use_texture_alpha,
    paramtype = core_def.paramtype,
    paramtype2 = core_def.paramtype2,
    groups = { not_in_creative_inventory = 1 },
    sunlight_propagates = core_def.sunlight_propagates,
    is_ground_content = true,
    drop = "",
  })

  -- Register ore that places the technical node inside 'wherein'
  minetest.register_ore({
    ore_type = "scatter",
    ore = tech,
    wherein = wherein,
    clust_scarcity = scarcity * scarcity * scarcity, -- 1 per (scarcity^3) nodes
    clust_num_ores = 1,
    clust_size = 1,
    y_min = y_min,
    y_max = y_max,
  })

  -- LBM: when the marker loads, replace it with a geode
  minetest.register_lbm({
    name = modname .. ":geode_generation" .. id,
    label = "Generate geode " .. id,
    nodenames = { tech },
    run_at_every_load = true,
    action = function(pos, node)
      if math.random(1, 100) <= generation_chance then
        local radius = math.random(radius_min, radius_max)
        generate_geode(pos, radius, core, core_alt, core_alt_chance, shell, center_node, wherein)
      else
        -- Chance failed; restore host rock if known
        if minetest.registered_nodes[wherein] then
          minetest.set_node(pos, { name = wherein })
        else
          minetest.set_node(pos, { name = "default:stone" })
        end
      end
    end,
  })
end

-- ========= User registrations =========

-- Kyawthuite: one center node per geode; uses ruby crystals inside limestone
geodes_lib:register_geode({
  id = "_kyawthuite",
  wherein = "default:limestone",
  y_min = -31000, y_max = 128,
  scarcity = 80,                 -- rarer than ruby
  generation_chance = 1,         -- extremely rare geode
  core = "default:rubyblock",
  core_alt = "default:quartz",
  core_alt_chance = 8,
  shell = { "default:limestone", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
  center_node = "default:ore_kyawthuite",
})

-- Amethyst — common-ish (ore: -31000 .. -340)
geodes_lib:register_geode({
  id = "_amethyst",
  wherein = "default:basalt",
  y_min = -31000, y_max = -340,
  scarcity = 22,
  generation_chance = 50,
  core = "default:amethystblock",
  core_alt = "default:quartz", core_alt_chance = 10,
  shell = { "default:basalt", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Garnet — uncommon (ore: -6550 .. 500)
geodes_lib:register_geode({
  id = "_garnet",
  wherein = "default:schist",
  y_min = -6550, y_max = 500,
  scarcity = 24,
  generation_chance = 40,
  core = "default:garnetblock",
  core_alt = "default:quartz", core_alt_chance = 12,
  shell = { "default:schist", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Opal — shallow uncommon (ore in clay: -30 .. -15)
geodes_lib:register_geode({
  id = "_opal",
  wherein = "default:clay",
  y_min = -30, y_max = -15,
  scarcity = 26,
  generation_chance = 38,
  core = "default:opalblock",
  core_alt = "default:quartz", core_alt_chance = 10,
  shell = { "default:clay", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Blue Topaz — rare (ore: -3100 .. -340)
geodes_lib:register_geode({
  id = "_btopaz",
  wherein = "default:granite",
  y_min = -3100, y_max = -340,
  scarcity = 32,
  generation_chance = 25,
  core = "default:btopazblock",
  core_alt = "default:quartz", core_alt_chance = 10,
  shell = { "default:granite", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Emerald — rare (ore: -800 .. -240)
geodes_lib:register_geode({
  id = "_emerald",
  wherein = "default:schist",
  y_min = -800, y_max = -240,
  scarcity = 34,
  generation_chance = 22,
  core = "default:emeraldblock",
  core_alt = "default:quartz", core_alt_chance = 10,
  shell = { "default:schist", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Sapphire — very rare (ore: -6550 .. 500)
geodes_lib:register_geode({
  id = "_sapphire",
  wherein = "default:granite",
  y_min = -6550, y_max = 500,
  scarcity = 38,
  generation_chance = 18,
  core = "default:sapphireblock",
  core_alt = "default:quartz", core_alt_chance = 10,
  shell = { "default:granite", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Ruby — very rare (ore: -31000 .. 128)
geodes_lib:register_geode({
  id = "_ruby",
  wherein = "default:limestone",
  y_min = -31000, y_max = 128,
  scarcity = 40,
  generation_chance = 16,
  core = "default:rubyblock",
  core_alt = "default:quartz", core_alt_chance = 8,
  shell = { "default:limestone", "default:onyx", "default:quartz" },
  radius_min = 3, radius_max = 6,
})

-- Diamond — ultra rare (ore: -31000 .. -340)
geodes_lib:register_geode({
  id = "_diamond",
  wherein = "default:granite",
  y_min = -31000, y_max = -340,
  scarcity = 60,
  generation_chance = 12,
  core = "default:diamondblock",
  core_alt = "default:quartz", core_alt_chance = 14,
  shell = { "default:granite", "default:onyx", "default:quartz" },
  radius_min = 4, radius_max = 7,
})

-- Fire Opal — extreme (rarest) (ore: -3100 .. 340)
geodes_lib:register_geode({
  id = "_fopal",
  wherein = "default:basalt",
  y_min = -3100, y_max = 340,
  scarcity = 80,
  generation_chance = 8,
  core = "default:fopalblock",
  core_alt = "default:opalblock", core_alt_chance = 6,
  shell = { "default:basalt", "default:onyx", "default:quartz" },
  radius_min = 4, radius_max = 7,
})
