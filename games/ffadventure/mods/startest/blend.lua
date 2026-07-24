-- startest/blend.lua
-- Post-generation terrain blending for crystal deposit schematics.
-- Modelled after mg_villages flatten_village_area:
--   1. Fill air voids below the schematic footprint with dirt.
--   2. Blend surrounding grass/dirt surface toward the deposit base height,
--      measuring distance from the deposit's bounding-box EDGE so the ramp
--      begins right at the schematic boundary.
-- Stone columns are never touched.  Schematic internals are never modified.

local BLEND_RADIUS = 12   -- blocks of ramp outside the footprint
local MAX_RAISE     = 10  -- cap on how far we'll raise terrain
local MAX_LOWER     = 6   -- cap on how far we'll lower terrain

-- -----------------------------------------------------------------------
-- Per-schematic footprint pad table.
--
-- A fixed global FOOTPRINT_PAD cannot serve all schematics: large deposits
-- have crystal nodes almost flush with the schematic edge (need pad ≈ 2)
-- while tiny dense deposits have a single crystal in the middle of an 8×8
-- footprint (need pad ≈ 7).  Using a single value either leaves unblended
-- natural terrain at the edge of large deposits or fails to cover the full
-- footprint of dense ones.
--
-- Key: "MIN_DIM,MAX_DIM" where MIN/MAX are min/max of the crystal bbox
-- width in X and Z.  This pair is unique per schematic type and is
-- rotation-invariant (sorted), so it survives rotation="random".
--
-- Values computed from the schematic binary:
--   pad = max(cx0, sx-1-cx1, cz0, sz-1-cz1)
-- where (cx0,cx1,cz0,cz1) are the crystal-node bbox in schematic space.
-- -----------------------------------------------------------------------
local SCHEMATIC_PADS = {
	-- "MIN_DIM,MAX_DIM"  = symmetric pad to cover full schematic footprint
	["28,30"] = 2,   -- big_space_crystal_deposit         (32×30 schematic)
	["16,22"] = 2,   -- med_space_crystal_deposit          (19×22 schematic)
	["8,11"]  = 2,   -- small_space_crystal_deposit        (10×11 schematic)
	["6,8"]   = 1,   -- super_small_space_crystal_deposit  (8×9  schematic)
	["7,9"]   = 1,   -- big_dense_space_crystal_deposit    (9×10 schematic)
	["6,9"]   = 4,   -- big_dense_space_crystal_deposit2   (10×10 schematic)
	["2,2"]   = 3,   -- small_dense_space_crystal_deposit  (5×5  schematic)
	["1,5"]   = 5,   -- medium_dense_space_crystal_deposit (7×8  schematic)
	["1,1"]   = 7,   -- medium_dense_space_crystal_deposit2 (8×8 schematic)
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
local surface_ids

local function init_ids()
	if crystal_base_ids then return end
	c_air  = minetest.get_content_id("air")
	c_dirt = minetest.get_content_id("default:dirt")
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
	surface_ids = {}
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
	}) do
		local id = minetest.get_content_id(name)
		if id ~= minetest.CONTENT_IGNORE then
			surface_ids[id] = true
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 0 then return end
	init_ids()

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	-- Pass 1: locate crystal nodes → bounding box of deposit + base Y.
	--
	-- Scan the FULL voxelmanip area (emin..emax) rather than just minp..maxp.
	-- Large schematics (up to 32×30) placed near a chunk boundary can extend
	-- 16 blocks into the adjacent chunk.  The voxelmanip margin covers those
	-- blocks so they are visible in `data`, but they fall outside minp..maxp.
	-- Scanning emin..emax ensures the crystal bbox is always complete.
	local bx0, bx1 =  math.huge, -math.huge
	local bz0, bz1 =  math.huge, -math.huge
	local dep_base_y = math.huge

	for z = emin.z, emax.z do
		for x = emin.x, emax.x do
			for y = emin.y, emax.y do
				if crystal_base_ids[data[area:index(x, y, z)]] then
					if x < bx0 then bx0 = x end
					if x > bx1 then bx1 = x end
					if z < bz0 then bz0 = z end
					if z > bz1 then bz1 = z end
					if y < dep_base_y then dep_base_y = y end
					break  -- only need the bottom-most per column
				end
			end
		end
	end

	if dep_base_y == math.huge then return end  -- no deposit in this chunk

	-- Choose the correct footprint pad for this schematic based on the
	-- detected crystal bbox dimensions.  See SCHEMATIC_PADS above.
	local crystal_w_x = bx1 - bx0 + 1
	local crystal_w_z = bz1 - bz0 + 1
	local fp_pad = footprint_pad(crystal_w_x, crystal_w_z)

	bx0 = bx0 - fp_pad
	bx1 = bx1 + fp_pad
	bz0 = bz0 - fp_pad
	bz1 = bz1 + fp_pad

	local changed = false

	-- Pass 2: Fill air voids BELOW the schematic footprint with dirt.
	-- Only write within [minp, maxp] to avoid stomping adjacent chunks.
	for z = math.max(minp.z, bz0), math.min(maxp.z, bz1) do
		for x = math.max(minp.x, bx0), math.min(maxp.x, bx1) do
			for y = dep_base_y - 1, math.max(dep_base_y - 24, emin.y), -1 do
				local vi = area:index(x, y, z)
				if data[vi] == c_air then
					data[vi] = c_dirt
					changed = true
				else
					break  -- hit solid terrain, stop
				end
			end
		end
	end

	-- Pass 3: Blend surrounding terrain toward dep_base_y.
	local x_lo = math.max(emin.x, bx0 - BLEND_RADIUS)
	local x_hi = math.min(emax.x, bx1 + BLEND_RADIUS)
	local z_lo = math.max(emin.z, bz0 - BLEND_RADIUS)
	local z_hi = math.min(emax.z, bz1 + BLEND_RADIUS)

	for z = z_lo, z_hi do
		for x = x_lo, x_hi do
			-- Skip columns inside the footprint
			if x >= bx0 and x <= bx1 and z >= bz0 and z <= bz1 then goto next_col end
			-- Only write within the current mapchunk to avoid double-writes
			if x < minp.x or x > maxp.x or z < minp.z or z > maxp.z then goto next_col end

			-- Distance from the nearest point on the footprint edge
			local dx   = math.max(bx0 - x, 0, x - bx1)
			local dz   = math.max(bz0 - z, 0, z - bz1)
			local dist = math.sqrt(dx * dx + dz * dz)
			if dist > BLEND_RADIUS then goto next_col end

			-- Find topmost surface node scanning downward.
			local nat_y  = nil
			local nat_id = nil
			for y = math.min(maxp.y + 2, emax.y), math.max(minp.y - 2, emin.y), -1 do
				local id = data[area:index(x, y, z)]
				if surface_ids[id] then
					nat_y  = y
					nat_id = id
					break
				elseif id ~= c_air then
					break  -- stone or crystal — skip column
				end
			end
			if not nat_y then goto next_col end

			-- Smoothstep: t=0 at footprint edge → dep_base_y, t=1 at blend radius → nat_y.
			local t        = dist / BLEND_RADIUS
			local smooth_t = t * t * (3 - 2 * t)
			local target_y = math.floor(dep_base_y + smooth_t * (nat_y - dep_base_y) + 0.5)

			if target_y > nat_y then
				target_y = math.min(target_y, nat_y + MAX_RAISE)
			elseif target_y < nat_y then
				target_y = math.max(target_y, nat_y - MAX_LOWER)
			else
				goto next_col  -- no movement needed
			end

			-- Derive fill material from just below the current surface.
			local fill_id = c_dirt
			if nat_y - 1 >= emin.y then
				local b = data[area:index(x, nat_y - 1, z)]
				if b ~= c_air then fill_id = b end
			end

			if target_y > nat_y then
				data[area:index(x, nat_y, z)] = fill_id
				for y = nat_y + 1, target_y do
					if y > emax.y then break end
					data[area:index(x, y, z)] = (y == target_y) and nat_id or fill_id
				end
			else
				for y = nat_y, target_y + 1, -1 do
					if y < emin.y then break end
					data[area:index(x, y, z)] = c_air
				end
				if target_y >= emin.y and target_y <= emax.y then
					data[area:index(x, target_y, z)] = nat_id
				end
			end
			changed = true

			::next_col::
		end
	end

	if changed then
		vm:set_data(data)
		vm:write_to_map()
	end
end)
