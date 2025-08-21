---------------------------------------------------------------
-- voxel buffering
---------------------------------------------------------------

function rockweed.read_va(pos1, pos2)
   rockweed.vm = core.get_voxel_manip()
   rockweed.minp, rockweed.maxp = rockweed.vm:read_from_map(
      {x = pos1.x, y = pos1.y, z = pos1.z},
      {x = pos2.x, y = pos2.y, z = pos2.z}
   )
   rockweed.va = VoxelArea:new({MinEdge = rockweed.minp, MaxEdge = rockweed.maxp})
   rockweed.data = rockweed.vm:get_data()
   rockweed.p2data = rockweed.vm:get_param2_data()
end

function rockweed.write_va()
   rockweed.vm:set_data(rockweed.data)
   rockweed.vm:set_param2_data(rockweed.p2data)
   rockweed.vm:write_to_map()
   rockweed.vm:update_map()
end

function rockweed.keep_loaded(pos1, pos2)
   local vm = core.get_voxel_manip()
   vm:read_from_map(pos1, pos2)
end

function rockweed.fix_light(pos, radius)
   rockweed.read_va(rockweed.pp(pos, -radius, -radius, -radius),
                    rockweed.pp(pos, radius, radius, radius))
   rockweed.write_va()
end

---------------------------------------------------------------
-- growth api functions                                      --
---------------------------------------------------------------

function rockweed.can_grow_into_va(pos)
   local i = rockweed.va:index(pos.x, pos.y, pos.z)
   return rockweed.can_grow_into_id[rockweed.data[i]]
end

-- makes a map of nearby nodes. maps are literal strings with 1
-- character per each of 27 nodes in a 3x3x3 neighborhood of the
-- central node, in order:
-- {x-1, y-1, z-1}, {x, y-1, z-1}, {x+1, y-1, z-1},
-- {x-1, y-1, z  }, {x, y-1, z  }, {x+1, y-1, z  },
-- ...
-- {x-1, y+1, z+1}, {x, y+1, z+1}, {x+1, y+1, z+1},

-- legend:
-- a anything rockweed grows into, like air
-- s something else

-- rockweed only grows into air, water, or lava

function rockweed.make_map(pos)
   local x, y, z, i, m
   rockweed.read_va(rockweed.pp(pos, -1, -1, -1), rockweed.pp(pos, 1, 1, 1))
   m = ""
   for dy = -1, 1, 1 do
      for dz = -1, 1, 1 do
         for dx = -1, 1, 1 do
            if rockweed.can_grow_into_va(rockweed.pp(pos, dx, dy, dz)) then
               m = m .. "a"
            else
               m = m .. "s"
            end
         end
      end
   end
   return m
end

-- look at pos + delta and return a va_node,
-- which is a table with .id and .p2
function rockweed.get_node_va(pos, dx, dy, dz)
   local i = rockweed.va:index(pos.x + dx, pos.y + dy, pos.z + dz)
   local id = rockweed.data[i]
   local p2 = rockweed.p2data[i]
   return {id = id, p2 = p2}
end

-- look at pos + delta and return a va_node with (coerced) trunk info
function rockweed.get_trunk_va(pos, dx, dy, dz)
   local i = rockweed.va:index(pos.x + dx, pos.y + dy, pos.z + dz)
   local id = rockweed.data[i]
   local p2 = rockweed.default_p2
   if rockweed.is_trunk_material[core.get_name_from_content_id(id)] then
      p2 = rockweed.p2data[i]
   else
      id = rockweed.trunk_id
   end
   return {id = id, p2 = p2}
end

function rockweed.force_trunk_va(pos, va_node, hemp_percent)
   local i = rockweed.va:index(pos.x, pos.y, pos.z)
   local va_new = va_node
   if math.random(1, 100) <= hemp_percent then
      if math.random(1, rockweed.hq_hemp_chance) == 1 then
         va_new = rockweed.va_node_hq_hemp
      else
         va_new = rockweed.va_node_glow_hemp
      end
   end
   rockweed.data[i] = va_new.id
   rockweed.p2data[i] = va_new.p2
end

function rockweed.grow_trunk_va(pos, va_node, hemp_percent)
   if rockweed.can_grow_into_va(pos) then
      rockweed.force_trunk_va(pos, va_node, hemp_percent)
   end
end

-- search the neighborhood of pos for a suitable trunk material to
-- use. if none can be found, return the default.
function rockweed.random_nearby_trunk_va(pos, radius)
   local dx, dy, dz
   local va_node = rockweed.va_node_trunk
   -- try to locate a suitable trunk a few times, then default
   for k = 1, rockweed.qw_trunk_tries, 1 do
      for r = 1, radius, 1 do
         dx = math.random(-r, r)
         dy = math.random(-r, r)
         dz = math.random(-r, r)
         va_node = rockweed.get_trunk_va(pos, dx, dy, dz)
         if va_node.id ~= rockweed.trunk_id then break end
      end
      if va_node.id ~= rockweed.trunk_id then break end
   end
   return va_node
end

---------------------------------------------------------------
-- growth creative functions                                 --
---------------------------------------------------------------

function rockweed.grow_box_va(pos1, pos2, va_node, hemp_percent)
   for x = math.min(pos1.x, pos2.x), math.max(pos1.x, pos2.x), 1 do
      for y = math.min(pos1.y, pos2.y), math.max(pos1.y, pos2.y), 1 do
         for z = math.min(pos1.z, pos2.z), math.max(pos1.z, pos2.z), 1 do
            rockweed.grow_trunk_va({x=x, y=y, z=z}, va_node, hemp_percent)
         end
      end
   end
end

-- grows a sphere filled with trunk nodes. pos is the center, tr is
-- the (integer) taxi-cab radius for looping over, r is the (real)
-- metric radius for filling purposes, and metric(cx, cy, cz, x, y, z)
-- is a distance function.
function rockweed.grow_sphere_va(pos, tr, r, metric, va_node, hemp_percent)
   for x = pos.x - tr, pos.x + tr, 1 do
      for y = pos.y - tr, pos.y + tr, 1 do
         for z = pos.z - tr, pos.z + tr, 1 do
            if metric(pos.x, pos.y, pos.z, x, y, z) <= r then
               rockweed.grow_trunk_va({x=x, y=y, z=z}, va_node, hemp_percent)
            end
         end
      end
   end
end

function rockweed.grow_chaos_star_va(pos, va_node, hemp_percent)
   rockweed.grow_trunk_va(pos, va_node, hemp_percent)
   for i = 1, 8, 1 do
      rockweed.grow_trunk_va(
         rockweed.pp(pos,
                     math.random(-1, 1),
                     math.random(-1, 1),
                     math.random(-1, 1)),
         va_node, hemp_percent)
   end
end

function rockweed.grow_xz_cylinder_va(
      pos, radius, height, metric, va_node, hemp_percent)
   for dx = -radius, radius, 1 do
      for dz = -radius, radius, 1 do
         for dy = 0, height - 1, 1 do
            if metric(0, 0, 0, dx, 0, dz) <= radius + 0.5 then
               rockweed.grow_trunk_va(
                  rockweed.pp(pos, dx, dy, dz), va_node, hemp_percent)
            end
         end
      end
   end
end

-- grows an arithmetic progression of nodes, useful for growing
-- straight lines
function rockweed.grow_line_va(pos, dx, dy, dz, length, va_node, hemp_percent)
   local p = pos
   for k = 1, length, 1 do
      rockweed.grow_trunk_va(p, va_node, hemp_percent)
      p = rockweed.pp(p, dx, dy, dz)
   end
end

-- grows a flower: a stem and a star at the end
function rockweed.grow_flower_va(pos, dx, dy, dz, length, va_node, hemp_percent)
   rockweed.grow_line_va(pos, dx, dy, dz, length, va_node, 0)
   rockweed.grow_chaos_star_va(
      rockweed.pp(pos, dx*length, dy*length, dz*length),
      va_node, rockweed.star_hemp_percent)
end

-- grows a flat (floor or ceiling)
function rockweed.grow_flat_va(pos, va_node, dy)
   local r = rockweed.flat_mr - math.random(0, 1) -- floor radius
   local sr = math.floor(r * 2^(-0.5)) -- star spread radius
   rockweed.grow_xz_cylinder_va(
      rockweed.pp(pos, 0, 0, 0), r, 1,
      rockweed.cartesian_metric, va_node, 0)
   for i = 1, 2, 1 do
      rockweed.grow_flower_va(
         rockweed.pp(pos, math.random(-sr, sr), dy, math.random(-sr, sr)),
         0, dy, 0, math.random(0, 3),
         va_node, rockweed.star_hemp_percent)
   end
end

-- grows a hanging floor
function rockweed.grow_hanging_floor_va(pos, va_node)
   local r = rockweed.hanging_floor_mr - 2  -- floor chunk radius
   local sr = math.floor(r * 2^(-0.5)) -- star spread radius
   for dx = -2, 2, 4 do
      for dz = -2, 2, 4 do
         rockweed.grow_xz_cylinder_va(
            rockweed.pp(pos, dx, 0, dz), r, 1,
            rockweed.random_metric(), va_node, 0)
      end
   end
   for dz = -1, 1, 2 do
      rockweed.grow_chaos_star_va(
         rockweed.pp(pos, math.random(-sr, sr), dz, math.random(-sr, sr)),
         va_node, rockweed.star_hemp_percent)
   end
end

-- grows a wall attached at pos.y - 1 along the (horizontal) direction dir
-- don't be clever with dir, make it either (1,?,0) or (0,?,1)
function rockweed.grow_wall_va(pos, dir, height, radius, va_node, hemp_percent)
   local l_pos = rockweed.pp(pos, -(dir.x * radius), -1, -(dir.z * radius))
   for i = 1, radius * 2 + 1, 1 do
      rockweed.grow_line_va(l_pos, 0, 1, 0,
                            height + math.random(0, 1), va_node, hemp_percent)
      l_pos = rockweed.pp(l_pos, dir.x, 0, dir.z)
   end
   if dir.x == 1 then
      for dz = -1, 1, 2 do
         rockweed.grow_chaos_star_va(
            rockweed.pp(pos, math.random(-rockweed.wall_sr, rockweed.wall_sr),
                        math.random(-1, rockweed.wall_sh - 1), dz),
                        va_node, rockweed.star_hemp_percent)
      end
   elseif dir.z == 1 then
      for dx = -1, 1, 2 do
         rockweed.grow_chaos_star_va(
            rockweed.pp(pos, dx, math.random(-1, rockweed.wall_sh - 1),
                        math.random(-rockweed.wall_sr, rockweed.wall_sr)),
                        va_node, rockweed.star_hemp_percent)
      end
   end
end

-- grows a bridge along the (horizontal) direction dir
-- don't be clever with dir, make it either (+-1,?,0) or (0,?,+-1)
function rockweed.grow_bridge_va(pos, dir, length, radius, va_node, hemp_percent)
   if dir.x ~= 0 then
      rockweed.grow_box_va(rockweed.pp(pos, -1 * dir.x, 0, -radius),
                           rockweed.pp(pos, length * dir.x, 0, radius),
                           va_node, hemp_percent)
      for dz = -radius - 1, radius + 1, 2 * radius + 2 do
         rockweed.grow_flower_va(rockweed.pp(pos,
                                             dir.x * math.random(1, rockweed.bridge_ml - 4),
                                             0, dz),
                                 0, 1, 0, math.random(2, 5),
                                 va_node, rockweed.star_hemp_percent)
      end
   elseif dir.z ~= 0 then
      rockweed.grow_box_va(rockweed.pp(pos, -radius, 0, -1 * dir.z),
                           rockweed.pp(pos, radius, 0, length * dir.z),
                           va_node, hemp_percent)
      for dx = -radius - 1, radius + 1, 2 * radius + 2 do
         rockweed.grow_flower_va(rockweed.pp(pos, dx, 0,
                                             dir.z * math.random(1, rockweed.bridge_ml - 4)),
                                 0, 1, 0, math.random(2, 5),
                                 va_node, rockweed.star_hemp_percent)
      end
   end
end

-- grows a spire in the direction dy = +-1
function rockweed.grow_spire_va(pos, dy, va_node, hemp_percent)
   local height = rockweed.spire_mh - math.random(2, 6)
   rockweed.grow_flower_va(pos, 0, dy, 0, height, va_node, rockweed.star_hemp_percent)
   for i = 1, 6, 1 do
      rockweed.grow_line_va(rockweed.pp(pos,
                                        math.random(-1, 1),
                                        0,
                                        math.random(-1, 1)),
                            0, dy, 0,
                            math.random(0, math.max(0, height - i)), va_node, 0)
   end
   for i = 1, 3, 1 do
      rockweed.grow_chaos_star_va(rockweed.pp(pos,
                                              math.random(-1, 1),
                                              0,
                                              math.random(-1, 1)),
                                  va_node, rockweed.star_hemp_percent)
   end
end


-- grows an upside-down fractal-like mushroom
function rockweed.grow_mushroom_va(pos, stem_length, rx, rz, va_node, hemp_percent)
   rockweed.grow_flower_va(pos, 0, -1, 0, stem_length - 1, va_node, rockweed.star_hemp_percent)
   rockweed.grow_flower_va(rockweed.pp(pos, math.random(-1,1), -stem_length, math.random(-1,1)),
			   0, 1, 0, stem_length, va_node, rockweed.star_hemp_percent)
   rockweed.grow_box_va(rockweed.pp(pos, -rx, -stem_length, -rz),
                        rockweed.pp(pos, rx, -stem_length, rz),
                        va_node, 0)
   rockweed.grow_box_va(rockweed.pp(pos, -rx+1, -stem_length-1, -rz+1),
                        rockweed.pp(pos, rx-1, -stem_length-1, rz-1),
                        va_node, 0)
end

-- grows a crystal-like pavement in all empty nodes which are
-- bottom-adjacent to filled-in n_base nodes.
function rockweed.grow_crystal_pavement_va(pos, rx, ry, rz, va_node, va_base, hemp_percent)
   local c_trunk = va_node.id
   local c_base = va_base.id

   for x = pos.x - rx, pos.x + rx, 1 do
      for y = pos.y + ry, pos.y - ry, -1 do
         for z = pos.z - rz, pos.z + rz, 1 do
            local i = rockweed.va:index(x, y, z)
            local d = rockweed.va:index(x, y - 1, z)
            if rockweed.can_grow_into_id[rockweed.data[i]] and
               rockweed.data[d] == c_base
            then
               rockweed.grow_trunk_va({x=x, y=y, z=z}, va_node, hemp_percent)
            end
         end
      end
   end
end

-- grows a crystal-like ceiling in all empty nodes which are
-- top-adjacent to filled-in n_base nodes.
function rockweed.grow_crystal_ceiling_va(pos, rx, ry, rz, va_node, va_base, hemp_percent)
   local c_trunk = va_node.id
   local c_base = va_base.id

   for x = pos.x - rx, pos.x + rx, 1 do
      for y = pos.y - ry, pos.y + ry, 1 do
         for z = pos.z - rz, pos.z + rz, 1 do
            local i = rockweed.va:index(x, y, z)
            local d = rockweed.va:index(x, y + 1, z)
            if rockweed.can_grow_into_id[rockweed.data[i]] and
               rockweed.data[d] == c_base
            then
               rockweed.grow_trunk_va({x=x, y=y, z=z}, va_node, hemp_percent)
            end
         end
      end
   end
end

-- grows a crystal-like film in all empty nodes which are
-- side-adjacent to filled-in n_base nodes. this operation neceserily
-- produces layers, since the crystal does not grow on top of itself.

function rockweed.grow_crystal_va(pos, rx, ry, rz, va_node, va_base, hemp_percent)
   local c_trunk = va_node.id
   local c_base = va_base.id
   if c_trunk == c_base then return end

   for x = pos.x - rx + 1, pos.x + rx - 1, 1 do
      for y = pos.y - ry + 1, pos.y + ry - 1, 1 do
         for z = pos.z - rz + 1, pos.z + rz - 1, 1 do
            local i = rockweed.va:index(x, y, z)
            local u = rockweed.va:index(x, y + 1, z)
            local d = rockweed.va:index(x, y - 1, z)
            local l = rockweed.va:index(x, y, z - 1)
            local r = rockweed.va:index(x, y, z + 1)
            local f = rockweed.va:index(x + 1, y, z)
            local b = rockweed.va:index(x - 1, y, z)
            if rockweed.can_grow_into_id[rockweed.data[i]] and (
               rockweed.data[u] == c_base or
               rockweed.data[d] == c_base or
               rockweed.data[l] == c_base or
               rockweed.data[r] == c_base or
               rockweed.data[f] == c_base or
               rockweed.data[b] == c_base )
            then
               rockweed.grow_trunk_va({x=x, y=y, z=z}, va_node, hemp_percent)
            end
         end
      end
   end
end

-- grows a flexible wall in all empty nodes which are bottom-adjacent
-- to filled-in n_base nodes.
function rockweed.grow_flex_wall_va(pos, rx, ry, rz, va_node, va_base, hemp_percent)
   local c_trunk = va_node.id
   local c_base = va_base.id

   for x = pos.x - rx, pos.x + rx, 1 do
      for y = pos.y - ry + 1, pos.y + ry, 1 do
         for z = pos.z - rz, pos.z + rz, 1 do
            local i = rockweed.va:index(x, y, z)
            local d = rockweed.va:index(x, y - 1, z)
            if rockweed.can_grow_into_id[rockweed.data[i]] and
               rockweed.data[d] == c_base
            then
               rockweed.grow_line_va({x=x, y=y, z=z},
                  0, 1, 0, rockweed.flex_wall_sh, va_node, 0)
            end
         end
      end
   end
   rockweed.grow_flower_va(pos, 0, 1, 0, rockweed.flex_wall_sh,
                           va_node, rockweed.star_hemp_percent)
end

-- starburst
function rockweed.starburst_va(pos, va_node)
   rockweed.grow_chaos_star_va(rockweed.pp(pos, 0, 0, 0), va_node, rockweed.star_hemp_percent)
   for k = 1, rockweed.starburst_max_stars, 1 do
      rockweed.attach_chaos_star_va(pos, rockweed.starburst_mr - 1, va_node)
   end
end

-- counts empties in 3x3x3 ball about pos
function rockweed.count_empty_27(pos)
   local c = 0
   for dy = -1, 1, 1 do
      for dz = -1, 1, 1 do
         for dx = -1, 1, 1 do
            if rockweed.can_grow_into_va(rockweed.pp(pos, dx, dy, dz)) then
               c = c + 1
            end
         end
      end
   end
   return c
end

-- attempts to attach a chaos star at the edge between empty and
-- nonepty nodes
function rockweed.attach_chaos_star_va(pos, radius, va_node)
   local c
   local r_pos
   for k = 1, rockweed.starburst_tries, 1 do
      r_pos = rockweed.pp(pos,
                          math.random(-radius, radius),
                          math.random(-radius, radius),
                          math.random(-radius, radius))
      c = rockweed.count_empty_27(r_pos)
      if (rockweed.can_grow_into_va(r_pos) and c < 27 and c > 1) then
         rockweed.grow_chaos_star_va(r_pos, va_node, rockweed.star_hemp_percent)
         break
      end
   end
end

-- grows a staircase
function rockweed.grow_stair_va(pos, steps, dx, dy, dz, va_node, hemp_percent)
   local cpos = rockweed.pp(pos, 0, 0, 0)
   local k, fx, fz
   for k = 1, steps, 1 do
      rockweed.grow_box_va(rockweed.pp(cpos, -1, 0, -1),
                           rockweed.pp(cpos, 1, 0, 1),
                           va_node, 0)
      if math.random(1, steps) < 4 then
         if math.random(1,2) == 1 then
            fx = 2*math.random(0, 1) - 1
            fz = (2*math.random(0, 1) - 1)*2
         else
            fx = (2*math.random(0, 1) - 1)*2
            fz = 2*math.random(0, 1) - 1
         end
         rockweed.grow_flower_va(rockweed.pp(cpos, fx, 0, fz),
                                 0, 1, 0, math.random(2,5),
                                 va_node, rockweed.star_hemp_percent)
      end
      cpos = rockweed.pp(cpos, dx, dy, dz)
   end
end
