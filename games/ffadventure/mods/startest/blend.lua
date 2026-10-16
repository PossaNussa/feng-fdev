-- startest/blend.lua
-- Post-generation terrain blending for crystal deposit schematics.
--
-- The schematics are placed by the decoration system without force_placement,
-- so their nodes only appear where there was air: the deposit sits ON the
-- surface at its anchor column and, on a slope, hangs over the downhill side
-- with a gap underneath.  This file settles it into the landscape:
--
--   1. Find every crystal node in the chunk and group them into deposits.
--      Two deposits in one mapchunk are blended separately -- merging them
--      into one bounding box is what produced the huge square platforms.
--   2. Build a support under the columns that actually carry deposit material,
--      so the pedestal takes the shape of the deposit rather than the shape of
--      its bounding box.
--   3. Lay a scree apron around it, on the downhill sides only.  The apron
--      reaches further where the drop is bigger, and its outline is broken up
--      by noise so it never reads as a rounded rectangle.
--
-- Uphill terrain is never cut away.  The schematic could not overwrite that
-- ground in the first place, so letting the slope bury the lower part of the
-- deposit is both free and exactly the look we want: rock and crystals
-- emerging from the hillside instead of a monolith parked on top of it.

local CLUSTER_GAP  = 14  -- crystals further apart than this are separate deposits
local MIN_DROP     = 2   -- below this the deposit is already seated; leave it be
local APRON_MIN    = 5   -- apron reach for a deposit sitting on flat ground
local TALUS        = 2.2 -- extra apron reach per node of drop (~24 degree scree)
local APRON_MAX    = 16  -- hard cap: see note on mapchunk margins below
local JITTER       = 0.35 -- +/- fraction the noise may push the apron reach
local MAX_PEDESTAL = 32  -- deepest support column we will build

-- APRON_MAX may not exceed 16.  A deposit is blended by every mapchunk whose
-- emerged area can see its crystals, and that margin is 16 nodes.  A wider
-- apron would be written by one chunk and not by its neighbour, leaving a
-- straight cut along the mapchunk border -- the very artefact this file exists
-- to remove.

-- -----------------------------------------------------------------------
-- Per-schematic footprint pad table.
--
-- A fixed global pad cannot serve all schematics: large deposits have crystal
-- nodes almost flush with the schematic edge (need pad ~ 2) while tiny dense
-- deposits have a single crystal in the middle of an 8x8 footprint (need
-- pad ~ 7).
--
-- Key: "MIN_DIM,MAX_DIM" where MIN/MAX are min/max of the crystal bbox width
-- in X and Z.  This pair is unique per schematic type and is rotation
-- invariant (sorted), so it survives rotation="random".
-- -----------------------------------------------------------------------
local SCHEMATIC_PADS = {
	["28,30"] = 2,   -- big_space_crystal_deposit          (32x30 schematic)
	["16,22"] = 2,   -- med_space_crystal_deposit          (19x22 schematic)
	["8,11"]  = 2,   -- small_space_crystal_deposit        (10x11 schematic)
	["6,8"]   = 1,   -- super_small_space_crystal_deposit  (8x9   schematic)
	["7,9"]   = 1,   -- big_dense_space_crystal_deposit    (9x10  schematic)
	["6,9"]   = 4,   -- big_dense_space_crystal_deposit2   (10x10 schematic)
	["2,2"]   = 3,   -- small_dense_space_crystal_deposit  (5x5   schematic)
	["1,5"]   = 5,   -- medium_dense_space_crystal_deposit (7x8   schematic)
	["1,1"]   = 7,   -- medium_dense_space_crystal_deposit2 (8x8  schematic)
}
local FALLBACK_PAD = 4

local function footprint_pad(crystal_w_x, crystal_w_z)
	local lo = math.min(crystal_w_x, crystal_w_z)
	local hi = math.max(crystal_w_x, crystal_w_z)
	return SCHEMATIC_PADS[lo .. "," .. hi] or FALLBACK_PAD
end

-- -----------------------------------------------------------------------
local c_air, c_dirt
local crystal_base_ids
local natural_top_ids
local overgrowth_ids
local edge_noise
local noise_get

local function init_ids()
	if crystal_base_ids then return end
	c_air   = minetest.get_content_id("air")
	c_dirt  = minetest.get_content_id("default:dirt")

	crystal_base_ids = {}
	for _, name in ipairs({
		"startest:space_crystal_ore",
		"startest:dense_space_crystal_ore",
		"startest:cracked_stone",
		"startest:space_crystal_spike",
		"startest:space_crystal_single_spike",
		"startest:space_crystal_pointed_spike",
		"startest:dense_space_crystal_spike",
		"startest:dense_space_crystal_single_spike",
		"startest:dense_space_crystal_pointed_spike",
	}) do
		local id = minetest.get_content_id(name)
		if id ~= minetest.CONTENT_IGNORE then
			crystal_base_ids[id] = true
		end
	end

	-- Anything the apron is allowed to grow out of.  Rock and sand are in the
	-- list too: a deposit on a stony mountainside used to get no apron at all
	-- on that side, which left a clean vertical edge.
	natural_top_ids = {}
	for _, name in ipairs({
		"default:dirt_with_grass",
		"default:dirt_with_dry_grass",
		"default:dirt_with_snow",
		"default:dirt",
		"default:dry_dirt",
		"default:dry_dirt_with_dry_grass",
		"default:permafrost_with_stones",
		"default:permafrost_with_moss",
		"default:permafrost",
		"default:stone",
		"default:desert_stone",
		"default:sand",
		"default:desert_sand",
		"default:silver_sand",
		"default:gravel",
		"default:snowblock",
	}) do
		local id = minetest.get_content_id(name)
		if id ~= minetest.CONTENT_IGNORE then
			natural_top_ids[id] = true
		end
	end

	-- Grass tufts, flowers and the like sit on top of the ground by the time
	-- this callback runs.  They have to be looked straight through, otherwise
	-- every decorated column is skipped and the apron comes out full of holes.
	-- Liquids are deliberately not in here: a column of water should stop the
	-- search so we never build land out into a lake.
	overgrowth_ids = {}
	for name, def in pairs(minetest.registered_nodes) do
		if def.walkable == false
				and (def.liquidtype == nil or def.liquidtype == "none") then
			local id = minetest.get_content_id(name)
			if id ~= minetest.CONTENT_IGNORE then
				overgrowth_ids[id] = true
			end
		end
	end

	-- World-wide and seed-stable, so neighbouring mapchunks agree on where the
	-- apron edge falls
	if minetest.get_perlin then
		edge_noise = minetest.get_perlin({
			offset = 0,
			scale = 1,
			spread = {x = 21, y = 21, z = 21},
			seed = 98213,
			octaves = 2,
			persist = 0.5,
		})
	end
	if edge_noise then
		noise_get = edge_noise.get_2d or edge_noise.get2d
	end
end

local function smoothstep(t)
	return t * t * (3 - 2 * t)
end

-- Reach of the apron at this column, jittered so the outline is ragged
local function apron_reach(drop, x, z)
	local reach = APRON_MIN + drop * TALUS
	if reach > APRON_MAX then reach = APRON_MAX end
	if noise_get then
		local n = noise_get(edge_noise, {x = x, y = z})    -- roughly -1 .. 1
		if n < -1 then n = -1 elseif n > 1 then n = 1 end
		reach = reach * (1 + n * JITTER)
	end
	return reach
end

-- -----------------------------------------------------------------------
-- Group crystal columns into separate deposits by growing bounding boxes.
-- -----------------------------------------------------------------------
local function cluster_columns(columns)
	local clusters = {}

	for _, col in ipairs(columns) do
		local host
		for _, cl in ipairs(clusters) do
			if col.x >= cl.x0 - CLUSTER_GAP and col.x <= cl.x1 + CLUSTER_GAP
					and col.z >= cl.z0 - CLUSTER_GAP and col.z <= cl.z1 + CLUSTER_GAP then
				host = cl
				break
			end
		end
		if host then
			if col.x < host.x0 then host.x0 = col.x end
			if col.x > host.x1 then host.x1 = col.x end
			if col.z < host.z0 then host.z0 = col.z end
			if col.z > host.z1 then host.z1 = col.z end
			if col.y < host.base_y then host.base_y = col.y end
		else
			clusters[#clusters + 1] = {
				x0 = col.x, x1 = col.x,
				z0 = col.z, z1 = col.z,
				base_y = col.y,
			}
		end
	end

	-- Growing the boxes above can leave two clusters overlapping, so fold
	-- those together before anything gets blended twice.
	local merged = true
	while merged do
		merged = false
		for i = 1, #clusters do
			local a = clusters[i]
			for j = #clusters, i + 1, -1 do
				local b = clusters[j]
				if a.x0 - CLUSTER_GAP <= b.x1 and b.x0 <= a.x1 + CLUSTER_GAP
						and a.z0 - CLUSTER_GAP <= b.z1 and b.z0 <= a.z1 + CLUSTER_GAP then
					if b.x0 < a.x0 then a.x0 = b.x0 end
					if b.x1 > a.x1 then a.x1 = b.x1 end
					if b.z0 < a.z0 then a.z0 = b.z0 end
					if b.z1 > a.z1 then a.z1 = b.z1 end
					if b.base_y < a.base_y then a.base_y = b.base_y end
					table.remove(clusters, j)
					merged = true
				end
			end
			if merged then break end
		end
	end

	return clusters
end

-- -----------------------------------------------------------------------
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0 then return end
	init_ids()

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	-- Pass 1: find crystal columns.
	--
	-- The whole emerged area is searched, not just minp..maxp: a large
	-- schematic placed near a chunk boundary reaches into the neighbour, and
	-- both chunks have to agree on the deposit's extent.  The scan walks the
	-- flat data array instead of calling area:index() a million times per
	-- mapchunk -- the vast majority of chunks contain no crystals at all and
	-- pay only for this loop.
	local xs = emax.x - emin.x + 1
	local ys = emax.y - emin.y + 1
	local volume = xs * ys * (emax.z - emin.z + 1)

	-- col_base maps a column to the underside of the deposit material standing
	-- in it, so each column can be supported from its own base instead of from
	-- the deposit's overall lowest point.
	local col_base = {}
	local columns = {}
	for i = 1, volume do
		if crystal_base_ids[data[i]] then
			local i0 = i - 1
			local lx = i0 % xs
			local rem = (i0 - lx) / xs
			local ly = rem % ys
			local lz = (rem - ly) / ys
			local key = lz * xs + lx
			if col_base[key] == nil then
				col_base[key] = emin.y + ly
				-- x varies fastest and y before z, so the first hit in a
				-- column is also its lowest node
				columns[#columns + 1] = {
					x = emin.x + lx,
					y = emin.y + ly,
					z = emin.z + lz,
				}
			end
		end
	end

	if #columns == 0 then return end

	local changed = false

	for _, cl in ipairs(cluster_columns(columns)) do
		local base_y = cl.base_y
		local pad = footprint_pad(cl.x1 - cl.x0 + 1, cl.z1 - cl.z0 + 1)
		local bx0, bx1 = cl.x0 - pad, cl.x1 + pad
		local bz0, bz1 = cl.z0 - pad, cl.z1 + pad

		-- Pass 2: support the deposit.
		--
		-- Only columns that actually carry deposit material get a pedestal, and
		-- each is filled from its own underside.  Filling the entire bounding
		-- box down from one flat height, as this used to, raised empty ground
		-- at the corners and squared the whole thing off.
		local py0 = math.max(minp.z, bz0)
		local py1 = math.min(maxp.z, bz1)
		for z = py0, py1 do
			for x = math.max(minp.x, bx0), math.min(maxp.x, bx1) do
				local col_y = col_base[(z - emin.z) * xs + (x - emin.x)]
				if col_y then
					local floor_y = math.max(col_y - MAX_PEDESTAL, emin.y)
					for y = col_y - 1, floor_y, -1 do
						local vi = area:index(x, y, z)
						if data[vi] == c_air then
							-- dirt, not stone: stone here reads as part of the
							-- schematic and washes out the deposit's shape
							data[vi] = c_dirt
							changed = true
						else
							break  -- reached solid ground
						end
					end
				end
			end
		end

		-- Pass 3: scree apron on the downhill sides.
		local x_lo = math.max(minp.x, bx0 - APRON_MAX)
		local x_hi = math.min(maxp.x, bx1 + APRON_MAX)
		local z_lo = math.max(minp.z, bz0 - APRON_MAX)
		local z_hi = math.min(maxp.z, bz1 + APRON_MAX)
		local scan_top = math.min(maxp.y + 8, emax.y)
		local scan_bot = math.max(minp.y - 8, emin.y)

		for z = z_lo, z_hi do
			for x = x_lo, x_hi do
				local inside = x >= bx0 and x <= bx1 and z >= bz0 and z <= bz1
				if not inside then
					local dx = math.max(bx0 - x, 0, x - bx1)
					local dz = math.max(bz0 - z, 0, z - bz1)
					local dist = math.sqrt(dx * dx + dz * dz)

					if dist <= APRON_MAX then
						-- topmost natural node in this column
						local nat_y, nat_id
						for y = scan_top, scan_bot, -1 do
							local id = data[area:index(x, y, z)]
							if id ~= c_air and not overgrowth_ids[id] then
								if natural_top_ids[id] then
									nat_y, nat_id = y, id
								end
								break  -- deposit or water: leave it alone
							end
						end

						-- Only ever build upward.  Where the ground already
						-- stands above the deposit's base the hillside is
						-- allowed to bury it, which is what makes the rock look
						-- like it belongs to the slope.
						local drop = nat_y and (base_y - nat_y) or 0
						local reach = drop >= MIN_DROP and apron_reach(drop, x, z) or 0
						if nat_y and drop >= MIN_DROP and dist <= reach then
							local t = smoothstep(dist / reach)
							local target_y = math.floor(base_y + t * (nat_y - base_y) + 0.5)

							if target_y > nat_y then
								-- Build with whatever this biome has under its
								-- surface, and keep the surface node on top, so
								-- the apron matches savanna, tundra and
								-- grassland without special casing any of them.
								local fill_id = c_dirt
								if nat_y - 1 >= emin.y then
									local below = data[area:index(x, nat_y - 1, z)]
									if below ~= c_air then fill_id = below end
								end
								for y = nat_y, math.min(target_y, emax.y) do
									local vi = area:index(x, y, z)
									data[vi] = (y == target_y) and nat_id or fill_id
								end
								changed = true
							end
						end
					end
				end
			end
		end
	end

	if changed then
		vm:set_data(data)
		vm:write_to_map()
	end
end)
