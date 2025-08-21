---------------------------------------------------------------
-- metrics                                                   --
---------------------------------------------------------------

-- spheres that look like cubes
function rockweed.max_metric(cx, cy, cz, x, y, z)
   return math.max(cx - x, cy - y, cz - z)
end

-- spheres that look like octahedrons
function rockweed.taxi_cab_metric(cx, cy, cz, x, y, z)
   return math.abs(cx - x) + math.abs(cy - y) + math.abs(cz - z)
end

-- spheres that look like speheres
function rockweed.cartesian_metric(cx, cy, cz, x, y, z)
   return math.sqrt((cx - x)^2 + (cy - y)^2 + (cz - z)^2)
end

function rockweed.random_metric()
   local i = math.random(1, 3)
   if     i == 1 then return rockweed.max_metric
   elseif i == 2 then return rockweed.taxi_cab_metric
   elseif i == 3 then return rockweed.cartesian_metric
   end
end

---------------------------------------------------------------
-- position functions                                        --
---------------------------------------------------------------

-- 3d vector position plus delta
function rockweed.pp(pos, dx, dy, dz)
   return {x = pos.x + dx,
           y = pos.y + dy,
           z = pos.z + dz}
end

function rockweed.random_nearby_pos(pos, radius)
   return rockweed.pp(
      pos,
      math.random(-radius, radius),
      math.random(-radius, radius),
      math.random(-radius, radius))
end

-- random direction (one of 6)
function rockweed.random_dir()
   local a = math.random(1, 6)
   if     a == 1 then return {x =  1, y =  0, z =  0}
   elseif a == 2 then return {x = -1, y =  0, z =  0}
   elseif a == 3 then return {x =  0, y =  1, z =  0}
   elseif a == 4 then return {x =  0, y = -1, z =  0}
   elseif a == 5 then return {x =  0, y =  0, z =  1}
   elseif a == 6 then return {x =  0, y =  0, z = -1}
   end
end

function rockweed.random_taxi_distance_one_pos(pos)
   local dir = rockweed.random_dir()
   return rockweed.pp(pos, dir.x, dir.y, dir.z)
end
