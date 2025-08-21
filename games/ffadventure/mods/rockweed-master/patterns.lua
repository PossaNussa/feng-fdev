---------------------------------------------------------------------
-- all growth patterns are defined here by populating the map hash
-- with grow functions
--
-- a rockweed map is a coding of the 3x3x3 cube of voxels
-- surrounding the seed. the 27-tuple is represented by a string
-- where «a» stands air or lava or water, «s» stands something
-- else.
--
-- keep in mind that y is the vertical coordinate in mintest,
-- z points to the north, and x points to the east.
-- (face north)
--
-- the coding lists voxels in 3 groups of 9, bottom to top.
--
-- within each group of 9, voxels are listed in 3 groups of 3,
-- with groups advancing in the z direction.
-- (forward and away from you)
--
-- within each group of 3, voxels are listed advancing in the x
-- direction
-- (left to right)
---------------------------------------------------------------------

-- 3d copier
rockweed.use_map["asaasssasaaaasaaaasssaasasa"] = function(pos)
   local base_pos = rockweed.pp(pos, 0, 0, 4)
   local out_pos = rockweed.pp(pos, 0, 0, 7)
   rockweed.read_va(rockweed.pp(pos, -3, -3, -3), rockweed.pp(pos, 3, 3, 10))
   local n_base = core.get_node(base_pos)
   local n_meta = core.get_meta(base_pos):to_table()
   local light_level = core.get_node_light(pos)
   local arm3d = rockweed.p2data[rockweed.va:index(pos.x, pos.y, pos.z)]
   -- param2 >= arm3d allows to arm the copier, and > arm3d allows to copy meta
   if arm3d >= rockweed.arm3d then
      if light_level <= rockweed.seed_light then
         if math.random(1, rockweed.copier_chance) == 1 then
            if rockweed.can_grow_into_va(out_pos) and
            (not rockweed.can_grow_into_va(base_pos)) then
               core.add_node(out_pos, n_base)
               if rockweed.copy_inventory and arm3d > rockweed.arm3d then
                  core.get_meta(out_pos):from_table(n_meta)
               end
            end
            -- re-read va after the copy is made
            rockweed.read_va(rockweed.pp(pos, -3, -3, -3), rockweed.pp(pos, 3, 3, 10))
            rockweed.force_trunk_va(pos, rockweed.va_node_trunk, 100)
         end
      end
   else
      rockweed.force_trunk_va(pos, rockweed.va_node_trunk, 0)
   end
   rockweed.write_va()
end

-- floor
rockweed.use_map["ssssssssssssssssssaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.flat_mr, -2, -rockweed.flat_mr),
                    rockweed.pp(pos, rockweed.flat_mr, 6, rockweed.flat_mr))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_flat_va(pos, va_node, 1)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- ceiling
rockweed.use_map["aaaaaaaaassssssssssssssssss"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.flat_mr, -6, -rockweed.flat_mr),
                    rockweed.pp(pos, rockweed.flat_mr, 2, rockweed.flat_mr))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_flat_va(pos, va_node, -1)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- hanging floor
rockweed.use_map["aaaaaaaaasssssssssaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.hanging_floor_mr, -2, -rockweed.hanging_floor_mr),
                    rockweed.pp(pos, rockweed.hanging_floor_mr, 2, rockweed.hanging_floor_mr))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_hanging_floor_va(pos, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- fractal-like tree
rockweed.use_map["sssssssssaaaasaaaaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -6, -2, -6), rockweed.pp(pos, 6, 20, 6))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   local trunk_length = math.random(1, 4)
   local l_pos = pos
   rockweed.grow_line_va(l_pos, 0, 1, 0, trunk_length, va_node, 0)
   l_pos = rockweed.pp(l_pos, 0, trunk_length, 0)
   local levels = math.random(1, 3) -- number of height levels
   for l = levels, 1, -1 do
      trunk_length = math.random(2, 3)
      rockweed.grow_line_va(l_pos, 0, 1, 0, trunk_length, va_node, 0)
      rockweed.grow_flower_va(rockweed.pp(l_pos, 0, math.random(1, trunk_length) - 1, 0),
                              2*(math.random(1, 2) - 1) - 1,
                              0,
                              2*(math.random(1, 2) - 1) - 1,
                              math.random(2, 3), va_node, rockweed.star_hemp_percent)
      l_pos = rockweed.pp(l_pos, 0, trunk_length, 0)
   end
   rockweed.grow_chaos_star_va(l_pos, va_node, rockweed.star_hemp_percent)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- wall along x
rockweed.use_map["aaasssaaaaaasssaaaaaasssaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.wall_sr - 4, -2, -2),
                    rockweed.pp(pos, rockweed.wall_sr + 4, rockweed.wall_sh + 4, 2))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   rockweed.grow_wall_va(pos, {x=1, z=0}, rockweed.wall_sh + math.random(0, 1),
                         rockweed.wall_sr + math.random(0, 2), va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- wall along z
rockweed.use_map["asaasaasaasaasaasaasaasaasa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -2, -2, -rockweed.wall_sr - 4),
                    rockweed.pp(pos, 2, rockweed.wall_sh + 4, rockweed.wall_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   rockweed.grow_wall_va(pos, {x=0, z=1}, math.random(4, 5),
                         math.random(5, 7), va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- antibomb
rockweed.use_map["aaaasaaaaasasssasaaaaasaaaa"] = function(pos)
   local r = rockweed.antibomb_sr + math.random(0, 1)
   rockweed.read_va(rockweed.pp(pos, -r-4, -r-4, -r-4),
                    rockweed.pp(pos, r+4, r+4, r+4))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   local m = rockweed.random_metric()
   if m == rockweed.taxi_cab_metric then r = r + 1 end
   for k = 1, 2, 1 do
      rockweed.grow_chaos_star_va(rockweed.pp(pos,
                                          math.random(-2, 2),
                                          math.random(-2, 2),
                                          math.random(-2, 2)),
                                  va_node, rockweed.star_hemp_percent)
   end
   rockweed.grow_sphere_va(pos, r, r + 0.5, m, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- bridge along x+
rockweed.use_map["aaaaaaaaassassassaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -3, -2, -rockweed.bridge_mr - 3),
                    rockweed.pp(pos, rockweed.bridge_ml + 2, 6, rockweed.bridge_mr + 3))
   local va_node = rockweed.get_trunk_va(pos, -1, 0, 0)
   rockweed.grow_bridge_va(pos, {x=1, z=0},
                           rockweed.bridge_ml - math.random(0, 4),
                           rockweed.bridge_mr - math.random(0, 1),
                           va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- bridge along x-
rockweed.use_map["aaaaaaaaaassassassaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, 3, -2, -rockweed.bridge_mr - 3),
                    rockweed.pp(pos, -rockweed.bridge_ml - 2, 6, rockweed.bridge_mr + 3))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_bridge_va(pos, {x=-1, z=0},
                           rockweed.bridge_ml - math.random(0, 4),
                           rockweed.bridge_mr - math.random(0, 1),
                           va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- bridge along z+
rockweed.use_map["aaaaaaaaassssssaaaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.bridge_mr - 3, -2, -3),
                    rockweed.pp(pos, rockweed.bridge_mr + 3, 6, rockweed.bridge_ml + 2))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, -1)
   rockweed.grow_bridge_va(pos, {x=0, z=1},
                           rockweed.bridge_ml - math.random(0, 4),
                           rockweed.bridge_mr - math.random(0, 1),
                           va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- bridge along z-
rockweed.use_map["aaaaaaaaaaaassssssaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.bridge_mr - 3, -2, 3),
                    rockweed.pp(pos, rockweed.bridge_mr + 3, 6, -rockweed.bridge_ml - 2))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, 1)
   rockweed.grow_bridge_va(pos, {x=0, z=-1},
                           rockweed.bridge_ml - math.random(0, 4),
                           rockweed.bridge_mr - math.random(0, 1),
                           va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- upward growing spire
rockweed.use_map["asasssasaaaaasaaaaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -4, -2, -4),
                    rockweed.pp(pos, 4, rockweed.spire_mh, 4))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   rockweed.grow_spire_va(pos, 1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- downward growing spire
rockweed.use_map["aaaaaaaaaaaaasaaaaasasssasa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -4, -rockweed.spire_mh, -4),
                    rockweed.pp(pos, 4, 2, 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   rockweed.grow_spire_va(pos, -1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- upside-down mushroom
rockweed.use_map["aaaaaaaaaaaaasaaaasssssssss"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.mushroom_sr - 5,
                                2, -rockweed.mushroom_sr - 5),
                    rockweed.pp(pos,
                                rockweed.mushroom_sr + 5,
                                -rockweed.mushroom_sh * 2 - 8,
                                rockweed.mushroom_sr + 5))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   local stem_length = rockweed.mushroom_sh + math.random(0, 1)
   local rx = rockweed.mushroom_sr + math.random(0, 1)
   local rz = rockweed.mushroom_sr + math.random(0, 1)
   rockweed.grow_mushroom_va(pos, stem_length, rx, rz, va_node, 0)
   rockweed.grow_mushroom_va(rockweed.pp(pos,
                                      math.random(-rx, rx),
                                      -stem_length - 1,
                                      math.random(-rz, rz)),
                          rockweed.mushroom_sh + math.random(0, 1),
                          math.random(1,2), math.random(1,2), va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- upward growing crystal
rockweed.use_map["sssssssssaaaasaaaaaaaasaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.u_crystal_sr - 4,
                                   -rockweed.u_crystal_sr - 4, -rockweed.u_crystal_sr - 4),
                    rockweed.pp(pos, rockweed.u_crystal_sr + 4, rockweed.u_crystal_sr + 4,
                                rockweed.u_crystal_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   local va_base = rockweed.get_node_va(pos, 0, -1, 0)
   rockweed.grow_crystal_pavement_va(pos,
                                  rockweed.u_crystal_sr + math.random(0, 2),
                                  rockweed.u_crystal_sr + 1 + math.random(0, 1),
                                  rockweed.u_crystal_sr + math.random(0, 2),
                                  va_node, va_base, 0)
   rockweed.grow_flower_va(pos, 0, 1, 0, math.random(2, 4),
                           va_node, rockweed.star_hemp_percent)
   rockweed.attach_chaos_star_va(pos, rockweed.u_crystal_sr, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- downward growing crystal
rockweed.use_map["aaaasaaaaaaaasaaaasssssssss"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.u_crystal_sr - 4,
                                   -rockweed.u_crystal_sr - 4, -rockweed.u_crystal_sr - 4),
                    rockweed.pp(pos, rockweed.u_crystal_sr + 4, rockweed.u_crystal_sr + 4,
                                rockweed.u_crystal_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, -1, 0)
   local va_base = rockweed.get_node_va(pos, 0, 1, 0)
   rockweed.grow_crystal_ceiling_va(pos,
                                  rockweed.u_crystal_sr + math.random(0, 2),
                                  rockweed.u_crystal_sr + 1 + math.random(0, 1),
                                  rockweed.u_crystal_sr + math.random(0, 2),
                                  va_node, va_base, 0)
   rockweed.grow_flower_va(pos, 0, -1, 0, math.random(2, 4),
                           va_node, rockweed.star_hemp_percent)
   rockweed.attach_chaos_star_va(pos, rockweed.u_crystal_sr, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- crystal
rockweed.use_map["sssssssssasasssasaaaaasaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.crystal_sr - 4,
                                   -rockweed.crystal_sr - 4, -rockweed.crystal_sr - 4),
                    rockweed.pp(pos, rockweed.crystal_sr + 4, rockweed.crystal_sr + 4,
                                rockweed.crystal_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   local va_base = rockweed.get_node_va(pos, 0, -1, 0)
   rockweed.grow_crystal_va(pos,
                         rockweed.crystal_sr + math.random(0, 2),
                         rockweed.crystal_sr + math.random(0, 2),
                         rockweed.crystal_sr + math.random(0, 2),
                         va_node, va_base, 0)
   rockweed.attach_chaos_star_va(pos, math.floor(rockweed.u_crystal_sr/2), va_node)
   rockweed.attach_chaos_star_va(pos, rockweed.u_crystal_sr, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- flex wall
rockweed.use_map["aaasssaaaaaasssaaaaaaasaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.flex_wall_sr - 4,
                                   -rockweed.flex_wall_myr - 2, -rockweed.flex_wall_sr - 4),
                    rockweed.pp(pos, rockweed.flex_wall_sr + 4, rockweed.flex_wall_sh + 4,
                                rockweed.flex_wall_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   local va_base = rockweed.get_node_va(pos, 0, -1, 0)
   rockweed.grow_flex_wall_va(pos,
                              rockweed.flex_wall_sr,
                              rockweed.flex_wall_myr,
                              rockweed.flex_wall_sr, va_node, va_base, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end
rockweed.use_map["asaasaasaasaasaasaaaaasaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.flex_wall_sr - 4,
                                   -rockweed.flex_wall_myr - 2, -rockweed.flex_wall_sr - 4),
                    rockweed.pp(pos, rockweed.flex_wall_sr + 4, rockweed.flex_wall_sh + 4,
                                rockweed.flex_wall_sr + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 1, 0)
   local va_base = rockweed.get_node_va(pos, 0, -1, 0)
   rockweed.grow_flex_wall_va(pos,
                              rockweed.flex_wall_sr,
                              rockweed.flex_wall_myr,
                              rockweed.flex_wall_sr, va_node, va_base, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- starburst
rockweed.use_map["sssaaaaaasssasaaaasssaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.starburst_mr, -rockweed.starburst_mr,  -rockweed.starburst_mr),
                    rockweed.pp(pos, rockweed.starburst_mr, rockweed.starburst_mr,  rockweed.starburst_mr))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, -1)
   rockweed.starburst_va(pos, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end
rockweed.use_map["aaaaaasssaaaasasssaaaaaasss"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.starburst_mr, -rockweed.starburst_mr,  -rockweed.starburst_mr),
                    rockweed.pp(pos, rockweed.starburst_mr, rockweed.starburst_mr,  rockweed.starburst_mr))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, 1)
   rockweed.starburst_va(pos, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end
rockweed.use_map["saasaasaasaassasaasaasaasaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.starburst_mr, -rockweed.starburst_mr,  -rockweed.starburst_mr),
                    rockweed.pp(pos, rockweed.starburst_mr, rockweed.starburst_mr,  rockweed.starburst_mr))
   local va_node = rockweed.get_trunk_va(pos, -1, 0, 0)
   rockweed.starburst_va(pos, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end
rockweed.use_map["aasaasaasaasassaasaasaasaas"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -rockweed.starburst_mr, -rockweed.starburst_mr,  -rockweed.starburst_mr),
                    rockweed.pp(pos, rockweed.starburst_mr, rockweed.starburst_mr,  rockweed.starburst_mr))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.starburst_va(pos, va_node)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

---------------------------------------------------------------
-- stairs
---------------------------------------------------------------

-- stair along x+ y+
rockweed.use_map["saasaasaassassassaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -3, -2, -5),
                    rockweed.pp(pos, rockweed.stair_ml + 4, rockweed.stair_ml + 10, 5))
   local va_node = rockweed.get_trunk_va(pos, -1, 0, 0)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 1, 1, 0, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along x+ y-
rockweed.use_map["aaaaaaaaassassassasaasaasaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -3, 2, -5),
                    rockweed.pp(pos, rockweed.stair_ml + 4, -rockweed.stair_ml - 10, 5))
   local va_node = rockweed.get_trunk_va(pos, -1, 0, 0)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 1, -1, 0, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along x- y+
rockweed.use_map["aasaasaasassassassaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, 3, -2, -5),
                    rockweed.pp(pos, -rockweed.stair_ml - 4, rockweed.stair_ml + 10, 5))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), -1, 1, 0, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along x- y-
rockweed.use_map["aaaaaaaaaassassassaasaasaas"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, 3, 2, -5),
                    rockweed.pp(pos, -rockweed.stair_ml - 4, -rockweed.stair_ml - 10, 5))
   local va_node = rockweed.get_trunk_va(pos, 1, 0, 0)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), -1, -1, 0, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along z+ y+
rockweed.use_map["sssaaaaaassssssaaaaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -5, -2, -3),
                    rockweed.pp(pos, 5, rockweed.stair_ml + 10, rockweed.stair_ml + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, -1)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 0, 1, 1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along z+ y-
rockweed.use_map["aaaaaaaaassssssaaasssaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -5, 2, -3),
                    rockweed.pp(pos, 5, -rockweed.stair_ml - 10, rockweed.stair_ml + 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, -1)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 0, -1, 1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along z- y+
rockweed.use_map["aaaaaasssaaassssssaaaaaaaaa"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -5, -2, 3),
                    rockweed.pp(pos, 5, rockweed.stair_ml + 10, -rockweed.stair_ml - 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, 1)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 0, 1, -1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end

-- stair along z- y-
rockweed.use_map["aaaaaaaaaaaassssssaaaaaasss"] = function(pos)
   rockweed.read_va(rockweed.pp(pos, -5, 2, 3),
                    rockweed.pp(pos, 5, -rockweed.stair_ml - 10, -rockweed.stair_ml - 4))
   local va_node = rockweed.get_trunk_va(pos, 0, 0, 1)
   rockweed.grow_stair_va(pos, rockweed.stair_ml - math.random(0,4), 0, -1, -1, va_node, 0)
   rockweed.force_trunk_va(pos, va_node, 0)
   rockweed.write_va()
end
