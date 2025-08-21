---------------------------------------------------------------------
-- config & global data
---------------------------------------------------------------------
math.randomseed(os.time())
rockweed = {}
rockweed.config = "rockweed-config.lua"

local modpath = core.get_modpath("rockweed")
dofile(modpath.."/"..rockweed.config)

-- the best place to store settings without affecting the addon repo
-- is WORLDPATH/rockweed-config.lua
local worldpath=core.get_worldpath()
if io.open(worldpath.."/"..rockweed.config, "r") then
   io.close()
   dofile(worldpath.."/"..rockweed.config)
end

dofile(modpath.."/nodes.lua")
dofile(modpath.."/trunks.lua")

rockweed.dormant = 1 -- param2 for dormant seeds
rockweed.arm3d = 6 -- param2 for arming 3d-copier, +1 for meta copy
core.register_privilege("rockweed", {
                               description = "can plant rockweed seeds (not enforced by default)",
                               give_to_singleplayer = false})
core.register_privilege("rockweed3d", {
                               description = "can arm 3d-copier",
                               give_to_singleplayer = false})
core.register_privilege("rockweed3dmeta", {
                               description = "can 3d-copy container contents",
                               give_to_singleplayer = false})

-- populate the hashes of acceptable trunk materials
-- note that third-party content ids may be unavailble here
-- so we do all trunk checking via string names
rockweed.is_trunk_material = {}
for n = 1, #rockweed.trunk_str, 1 do
   rockweed.is_trunk_material[rockweed.trunk_str[n]] = true
end
-- define trunk/hemp info for va
rockweed.default_p2 = 0
rockweed.trunk_id = core.get_content_id(rockweed.default_trunk)
rockweed.va_node_trunk = {id = rockweed.trunk_id, p2 = rockweed.default_p2}
rockweed.va_node_glow_hemp = {id = core.get_content_id("rockweed:glow_hemp"),
                              p2 = rockweed.default_p2}
rockweed.va_node_hq_hemp = {id = core.get_content_id("rockweed:hq_hemp"),
                            p2 = rockweed.default_p2}
rockweed.va_node_seed = {id = core.get_content_id("rockweed:seed"),
                            p2 = rockweed.default_p2}
rockweed.va_node_seed_dormant = {id = core.get_content_id("rockweed:seed"),
                            p2 = rockweed.dormant}

-- populate the hash of nodes that are ok to grow into
rockweed.can_grow_into_str = {"air",
                              "default:water_source",
                              "default:water_flowing",
                              "default:lava_source",
                              "default:lava_flowing",
}
rockweed.can_grow_into_id = {}
rockweed.can_grow_into_name = {}
for n = 1, #rockweed.can_grow_into_str, 1 do
   rockweed.can_grow_into_id[core.get_content_id(rockweed.can_grow_into_str[n])] = true
   rockweed.can_grow_into_name[rockweed.can_grow_into_str[n]] = true
end

-- hash of pattern-growing functions will be populated towards the end
rockweed.use_map = {}

dofile(modpath.."/metric-functions.lua")
dofile(modpath.."/grow-functions.lua")
dofile(modpath.."/patterns.lua")

core.register_abm({
      nodenames = {"rockweed:seed"},
      interval = rockweed.abm_interval,
      chance = rockweed.abm_chance,
      action = function(pos)
         rockweed.read_va(rockweed.pp(pos, -1, -1, -1), rockweed.pp(pos, 1, 1, 1))

         -- if it's too bright, then the seed pauses, and
         -- turns into hemp in really bright light
         local light_level = core.get_node_light(pos)
         if light_level > rockweed.light_cap then
            if light_level > rockweed.bright_light_cap then
               rockweed.force_trunk_va(pos, rockweed.va_node_trunk, 100)
               rockweed.write_va()
               return
            else
               return
            end
         end

         local node_map = rockweed.make_map(pos)

         -- if the seed is dormant, activate it and return
         local n_seed = core.get_node(pos)
         if n_seed.param2 == rockweed.dormant then
            n_seed.param2 = 0
            core.add_node(pos, n_seed)
            return
         end

         if rockweed.use_map[node_map] ~= nil then
            rockweed.use_map[node_map](pos)
         else
            ---------------------------------------------------------
            -- quantum walk
            ---------------------------------------------------------
            rockweed.read_va(rockweed.pp(pos, -rockweed.tunnel_cap - 3,
                                            -rockweed.tunnel_cap - 3,
                                            -rockweed.tunnel_cap - 3),
                             rockweed.pp(pos, rockweed.tunnel_cap + 3,
                                         rockweed.tunnel_cap + 3,
                                         rockweed.tunnel_cap + 3))

            local va_node = rockweed.random_nearby_trunk_va(pos, rockweed.tunnel_cap)
            local r_pos
            local walk_flag = false
            for r = 1, rockweed.tunnel_cap, 1 do
               for i = 1, 2 * (rockweed.tunnel_cap - r + 1), 1 do
                  r_pos = rockweed.random_nearby_pos(pos, r)
                  if rockweed.can_grow_into_va(r_pos) and
                     core.get_node_light(r_pos) <= rockweed.light_cap
                  then
                     walk_flag = true
                     break
                  end
               end
               if walk_flag then
                  break
               end
            end
            if walk_flag then
               rockweed.grow_trunk_va(r_pos, rockweed.va_node_seed, 0)
               -- make the seed dormant for the next abm call, which
               -- happens right away like half the time
               rockweed.p2data[rockweed.va:index(r_pos.x, r_pos.y, r_pos.z)] = rockweed.dormant
               rockweed.force_trunk_va(pos, va_node, 0)
               if math.random(1, rockweed.qw_star_chance) == 1 then
                  rockweed.grow_flower_va(pos, math.random(-1,1),
                                            math.random(-1,1),
                                            math.random(-1,1),
                                            rockweed.tunnel_cap + math.random(0, 1),
                                            va_node, rockweed.star_hemp_percent)
               end
            else
               if math.random(1, 6) == 1 then -- walk ends
                  rockweed.force_trunk_va(pos, va_node, 100)
                  rockweed.grow_chaos_star_va(pos, va_node, rockweed.star_hemp_percent)
                  rockweed.write_va()
                  return
               else
                  return
               end
            end
         end
         rockweed.write_va()
      end, -- of action
})
