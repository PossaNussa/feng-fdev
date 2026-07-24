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

-- ========= Geode core generator =========
-- Carves a hollow sphere, lines inner rim with crystals, builds shell layers.
-- Uses VoxelManip so the entire geode is one bulk read + one bulk write.
local function generate_geode(center, radius, core, core_alt, core_alt_chance, shell, center_node, wherein)
  local shell_layers = {}
  local shell_all_registered = true
  for i = 1, #shell do
    local m = shell[i]
    if minetest.registered_nodes[m] then
      shell_layers[#shell_layers + 1] = m
    else
      shell_all_registered = false
    end
  end
  if #shell_layers == 0 then
    shell_layers = tbl_copy(shell)
    shell_all_registered = false
  end

  local R       = math.max(2, radius)
  local R_outer = R + #shell_layers

  -- Pre-compute squared thresholds — sqrt only needed in the shell band
  local ro05sq = (R_outer + 0.5) * (R_outer + 0.5)
  local ri05sq = (R       + 0.5) * (R       + 0.5)
  local rm05sq = (R       - 0.5) * (R       - 0.5)

  -- Load the entire bounding box in one VoxelManip call
  local minp = { x = center.x - R_outer, y = center.y - R_outer, z = center.z - R_outer }
  local maxp = { x = center.x + R_outer, y = center.y + R_outer, z = center.z + R_outer }
  local vm         = minetest.get_voxel_manip(minp, maxp)
  local emin, emax = vm:get_emerged_area()
  local data       = vm:get_data()
  local area       = VoxelArea:new({ MinEdge = emin, MaxEdge = emax })

  -- Pre-fetch all content IDs once
  local c_air    = minetest.get_content_id("air")
  local c_ignore = minetest.get_content_id("ignore")
  local c_core   = minetest.registered_nodes[core]   and minetest.get_content_id(core)
  local c_coralt = core_alt and minetest.registered_nodes[core_alt] and minetest.get_content_id(core_alt)
  local c_where  = wherein  and minetest.registered_nodes[wherein]  and minetest.get_content_id(wherein)
  local c_shell  = {}
  for i = 1, #shell_layers do
    local m = shell_layers[i]
    c_shell[i] = (shell_all_registered or minetest.registered_nodes[m])
                 and minetest.get_content_id(m)
  end

  local cx = center.x
  local cy = center.y
  local cz = center.z

  for dx = -R_outer, R_outer do
    local dxsq = dx * dx
    local px   = cx + dx
    for dy = -R_outer, R_outer do
      local dxysq = dxsq + dy * dy
      local py    = cy + dy
      for dz = -R_outer, R_outer do
        local dsq = dxysq + dz * dz
        if dsq <= ro05sq then
          local vi  = area:index(px, py, cz + dz)
          local cur = data[vi]
          if cur ~= c_ignore then
            if dsq <= ri05sq then
              if dsq >= rm05sq then
                -- Inner rim: crystals
                if math.random(100) <= 65 then
                  local cid = c_core
                  if c_coralt and core_alt_chance > 1 and math.random(core_alt_chance) == 1 then
                    cid = c_coralt
                  end
                  -- set_if_solid: only overwrite non-air
                  if cid and cur ~= c_air then
                    data[vi] = cid
                  elseif c_where and cur ~= c_air then
                    data[vi] = c_where
                  end
                else
                  data[vi] = c_air
                end
              else
                -- Interior cavity
                data[vi] = c_air
              end
            else
              -- Shell zone: sqrt only here to get layer index
              local d   = math.sqrt(dsq)
              local idx = math.ceil(d - R)
              local cid = c_shell[idx]
              if cid and cur ~= c_air then
                data[vi] = cid
              elseif c_where and cur ~= c_air then
                data[vi] = c_where
              end
            end
          end
        end
      end
    end
  end

  vm:set_data(data)
  vm:write_to_map(false)

  -- Optional single node at the exact center (set after vm write)
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
