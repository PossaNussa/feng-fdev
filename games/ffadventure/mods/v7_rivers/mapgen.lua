-- v7_rivers/mapgen.lua
-- Runs as a mapgen script (emerge thread). Modifies the mapgen VM directly.
--
-- Design: mapgen_rivers' pregenerated DEM decides WHERE rivers run, how wide,
-- and roughly how high the water sits (lake_map, descending downstream).  v7
-- owns everything else — crucially, v7 owns the ocean and the coastline.
--
-- Rivers are carved ONLY into genuine v7 land (ground surface above sea level),
-- and the water is never placed above v7's own ground.  This is purely a
-- downward carve plus a water fill: no levees, no raised banks, no aqueducts.
--
-- Standing water comes from two places.  fill_basins finds small closed hollows
-- within a single chunk and floods them to their own spill level, carving
-- nothing.  The basin-lake branch in the carve loop handles the large ones,
-- which no chunk-local method can see: those come straight from the DEM, which
-- filled its own depressions to their spill points during erosion -- and those
-- DO reshape the ground around them, because measurement says they cannot work
-- any other way.  See "Terrain reconciliation" below.

-- Stone layers placed below the riverbed to seal caves/depressions.
--
-- The thickness varies per column between the two.  A single fixed depth plugs a
-- cavern with a rectangular slab of uniform thickness and a dead-flat underside,
-- hanging in the air with nothing holding it up -- which is what makes the seal
-- read as built rather than grown when you walk in underneath it.  Only the
-- BOTTOM of the plug moves; the top stays flush under the bed, so how watertight
-- it is does not depend on this at all.
local SEAL_DEPTH = 12
local SEAL_MIN   = 4
-- How far the water may sit above v7's own ground, held up by filled-in banks.
--
-- MUST BE 0 while the river heightmap and v7 are two unrelated landscapes.
-- Letting the water perch was meant to give a river some elevation of its own
-- instead of being pinned to whatever height v7 happened to build.  But the
-- heightmap's elevations mean nothing relative to v7's — its vertical spread is
-- 7.3x v7's base terrain and the two are uncorrelated — so "the river wants to
-- be higher here" is not a real signal.  All the perch did was raise water above
-- a field and wall it in: a stone-sided canal running over open ground, which is
-- what the raised veins were.
--
-- Reconciling the two landscapes is the fix (see v7base.lua); a perch only
-- becomes meaningful once the heightmap is built from v7's own terrain, and even
-- then it should stay small.
local MAX_PERCH = 0
-- How far below v7's ground the waterline is pushed when the heightmap wants the
-- river higher than v7 built.  Without it the water sits exactly flush with the
-- field it crosses, lapping at the grass; one node of groove reads as a stream
-- and gives the per-column roughness of v7's surface somewhere to hide.
--
-- This was briefly scaled up with river size, to force deeper channels and give
-- the banks more to slope down from.  It made every channel a canal, and where
-- the heightmap's path crossed a slope v7 had put there, a canal cut level into
-- a hillside.  A river's depth is not ours to invent.
local MIN_INCISION = 1
-- The bank taper, in dpmax units (polygon fractions).  blocksize is 30 nodes, so
-- 1.0 dpmax unit is 30 nodes on the ground.
--
-- dpmax is a SIGNED DISTANCE TO THE NEAREST RIVER measured in polygon fractions
-- (> 0 inside the channel, 0 on the bank, < 0 outside).  It is derived from a
-- single polygon's own river edges and corners, so it can only resolve about one
-- polygon's worth of distance: BANK_MAX must stay at or below 0.9 or the taper
-- runs off the end of the measurement and stops being continuous.
--
-- The taper is sized RELATIVE TO THE RIVER.  A flat width does not work: this
-- drainage network calls anything past min_catchment a river, and 58% of those
-- are under one node wide — invisible on the ground.  Giving every one of them
-- the same bank as a full-size river reshapes half the map around streams that
-- were never drawn, which reads exactly like terrain that "wanted to make a
-- river but didn't".
local BANK_RATIO = 2.0   -- bank reach as a multiple of the local river width
local BANK_MIN   = 0.03  -- ~1 node, so even a trickle gets a soft edge
local BANK_MAX   = 0.6   -- ~18 nodes; dpmax cannot resolve much past 1 anyway
-- Deepest cut allowed below v7's own ground.  The DEM decides where rivers run
-- with no knowledge of v7's terrain, so it will happily route one straight
-- through a mountain v7 put in the way; clearing every node above the waterline
-- then saws a vertical slot the full height of that mountain.  Past this depth
-- the column is left completely alone, so a river goes missing across high
-- ground rather than gouging a canyon through it.
local MAX_GORGE = 24
-- Standing water in closed hollows.  Deeper than this and a basin is treated as
-- something other than a pond -- a cave mouth, a quarry-like artifact -- and
-- left dry.  Smaller than this in area and it is a puddle not worth a water
-- node.  A basin reaching within LAKE_MARGIN of the chunk edge is skipped
-- entirely: its real extent is in the next chunk, which cannot see this one, so
-- neither may fill it without the two disagreeing at the seam.
local LAKE_MAX_DEPTH = 12
local LAKE_MIN_AREA = 8
local LAKE_MARGIN = 1
-- How far above the local water table a pond may stand, in nodes.
--
-- A closed hollow is not enough on its own.  v7's mountains are covered in
-- ledges, saddles and hollows that are geometrically closed but hold no water --
-- they drain and dry.  Filling them put ponds tens of nodes up the side of every
-- outcrop.  The river heightmap's own surface is the water table here: in a
-- valley floor it sits at the local ground, and on a mountain flank it is far
-- below, because the heightmap was built from v7's base terrain and knows
-- nothing of the mountain standing on top of it.
local LAKE_ABOVE_TABLE = 2
-- Off switch for the basin flood, so lakes can be turned off without touching
-- the river carving.
local DO_LAKES = core.settings:get_bool('v7_rivers_lakes', true)

-- Basin lakes: the big ones, the ones the chunk-local flood above structurally
-- cannot find.
--
-- That flood only ever sees one 80x80 chunk, and rejects any basin touching the
-- chunk edge because the neighbouring chunk cannot see this one and the two
-- would disagree about the water level.  So it finds tarns and ponds and nothing
-- else: a lake a thousand nodes across spans well over a hundred chunks and is
-- rejected by every one of them.
--
-- The DEM has the global view the flood lacks.  The erosion simulation fills its
-- own closed depressions to their spill points and stores the result in
-- lake_map, so lake_map > terrain_map marks a basin and lake_map IS its water
-- level -- one number, agreed on by every chunk, no seams possible.  That field
-- is already loaded here; it was only ever read as the river waterline.
--
local DO_BASIN_LAKES = core.settings:get_bool('v7_rivers_basin_lakes', true)
-- How far above sea level a basin's water must stand to count.
--
-- Not a realism knob -- a definition.  Measured on this world's grid, 38.7% of
-- it is "lake" by the bare lake_map > terrain_map test, in components running to
-- 6000 nodes across, essentially all of it sitting at elevation 2 to 7: coastal
-- flats that the simulation had not finished draining, not water bodies.  Above
-- elevation 8 that collapses to 1.4% of the map in 7922 separate basins, median
-- one about 60 nodes across and the largest about 950 -- rare, and worth walking
-- to when you find one.
local MIN_LAKE_ELEV = 7
-- Cap on how tall a stretch of a bank may be closed up in one column, as a
-- backstop.  The band that actually gets sealed is the depth of the water next
-- door, which is already bounded by the lake depth and by MAX_GORGE.
local SIDE_SEAL_MAX = 32

-- Terrain reconciliation around basin lakes ----------------------------------
--
-- A DEM basin has NO RIM.  `lakes` is the erosion simulation's filled-to-the-
-- spill-point field, so a basin's boundary is by construction exactly at its own
-- water level.  Measured over this world's whole grid (7937 basins above
-- MIN_LAKE_ELEV), the DEM terrain immediately outside a basin stands this far
-- above the water it is supposed to hold back:
--
--     percentile      5%   25%   50%   75%   90%
--     rim margin       0     0     1     2     5   nodes
--
-- 80% of the shoreline is within two nodes of the waterline.  v7's own surface
-- differs from that DEM terrain by the depth erosion cut (mean 3.5 nodes, see
-- the note further down) plus whatever `distort` moves the sampling by, which is
-- ten nodes horizontally in this world.  So every basin is breached somewhere:
-- pouring a DEM water level onto un-eroded v7 ground CANNOT be contained, at any
-- setting, and the only thing that ever held these lakes in was a stone wall
-- built up the outside of them.
--
-- The fix is to give the basin to v7's terrain instead of fighting it.
-- base_from_mapgen seeded the erosion simulation with v7's own base terrain, so
-- (v7base - terrain_map) is exactly how deep erosion cut, in a vertical frame
-- both landscapes share.  Applying that difference to the ground turns the
-- basin into a real hollow with a real rim, after which containment is the DEM's
-- own spill guarantee and not a wall: nothing is ever placed in open air again.
--
-- What is preserved: max(0, v7surf - v7base), v7's own relief above its base --
-- mountains, ridges, local detail.  Clamped at zero so it can only ever raise a
-- rim, never lower one.  A mountain inside a basin therefore keeps its full
-- height and comes out as an island, exactly as before.
local RECONCILE = core.settings:get_bool('v7_rivers_reconcile', true)
-- Full strength out to BLEND_CORE nodes beyond the basin edge -- the rim itself,
-- which must match the DEM or the guarantee above does not hold -- then eased
-- back to v7's untouched ground by BLEND_REACH.  BLEND_REACH is also the 2D
-- margin the heightmaps are computed over, so that a column at a chunk edge sees
-- the same basins its neighbour across the seam does.
local BLEND_CORE = 6
local BLEND_REACH = 16
-- Caps on how far a single column may be moved.  Down is capped tightly: past
-- this the DEM is asking to shave a landform v7 built, and an island is the
-- better answer.  Up is allowed much further, because raising is how a cave
-- mouth or a shaft inside a basin gets choked with sediment rather than roofed
-- over with a slab hanging in the dark, and there is no such thing as filling in
-- too much of a hole.
local MAX_LOWER = 16
local MAX_RAISE = 40
-- The slab that moves with the ground: soil below, and enough above to carry
-- grass, flowers and most trees along with it instead of stranding them.  A
-- column whose surface sits within CARRY_UP of the top of the chunk can only
-- move the part of its vegetation that is in this chunk; the rest is in a chunk
-- that has already been generated and cannot be written.
local CARRY_DOWN = 5
local CARRY_UP = 20
-- Chunks entirely above/below any possible river elevation are skipped outright.
local Y_SKIP_ABOVE = 600

-- Check river data exists
local size_f = io.open(core.get_worldpath() .. '/river_data/size', 'r')
if not size_f then
	core.log('error', '[v7_rivers] No river data found, rivers disabled.')
	return
end
size_f:close()

local make_heightmaps
local c_air, c_rwater, c_ignore, c_stone, c_sand
local surf_skip_ids -- decorations + liquids: skipped when scanning for real ground
local v7base          -- v7's base terrain field, for the erosion residual
local blocksize       -- DEM grid spacing, in nodes
local grid_off_x, grid_off_z -- world position of DEM grid node (0, 0)
local reconcile = false -- terrain reconciliation possible in this world at all

local ok, err = pcall(function()
	if not core.global_exists('mapgen_rivers') then
		rawset(_G, 'mapgen_rivers', {
			modpath   = core.get_modpath('mapgen_rivers') .. '/',
			data_path = core.get_worldpath() .. '/river_data/',
			settings  = Settings(core.get_worldpath() .. '/mapgen_rivers.conf'),
			thread    = 'mapgen',
		})
	end

	mapgen_rivers.np_heat = core.get_mapgen_setting_noiseparams('mg_biome_np_heat')
	local sea_level = tonumber(core.get_mapgen_setting('water_level')) or 1
	local ec = tonumber(mapgen_rivers.settings:get('elevation_chill')) or 0.25
	if mapgen_rivers.np_heat then
		mapgen_rivers.np_heat.offset = mapgen_rivers.np_heat.offset + sea_level * ec
	end

	mapgen_rivers.grid = dofile(mapgen_rivers.modpath .. 'grid_load.lua')
	make_heightmaps = dofile(mapgen_rivers.modpath .. 'heightmap.lua')

	-- Where the DEM grid sits in world coordinates, so a chunk can be tested
	-- against the raw grid without building a heightmap for it (polygons.lua).
	blocksize = tonumber(mapgen_rivers.settings:get('blocksize')) or 30
	grid_off_x, grid_off_z = 0, 0
	if mapgen_rivers.settings:get_bool('center') then
		grid_off_x = blocksize * mapgen_rivers.grid.size.x / 2
		grid_off_z = blocksize * mapgen_rivers.grid.size.z / 2
	end

	-- Terrain reconciliation needs both halves of the subtraction to mean
	-- something: v7's base terrain here, and a DEM that was eroded from that same
	-- field.  The marker beside the grid is what says so -- the setting cannot,
	-- since mapgen_rivers writes defaults into an existing world's config.
	v7base = dofile(core.get_modpath('v7_rivers') .. '/v7base.lua')
	local marker = io.open(mapgen_rivers.data_path .. 'base_from_mapgen', 'r')
	if marker then marker:close() end
	reconcile = RECONCILE and v7base.available and marker ~= nil

	c_air    = core.get_content_id('air')
	c_rwater = core.get_content_id('default:river_water_source')
	c_ignore = core.get_content_id('ignore')
	c_stone  = core.get_content_id('default:stone')
	c_sand   = core.get_content_id('default:sand')

	-- Surface scan must see past decorations AND existing liquid, so that an
	-- ocean column reads its seabed (below sea level) rather than the water top.
	surf_skip_ids = {}
	-- Extra groups for mods that don't use standard tree/leaves:
	-- 'leafdecay'   - aotearoa fruit; 'winleafdecay' - livingjungle liana;
	-- 'carpet'      - mahogany creepers.
	local skip_groups = {"leaves", "tree", "sapling", "grass", "flower",
	                     "mushroom", "coral", "seagrass", "bamboo",
	                     "leafdecay", "winleafdecay", "carpet"}
	for name, def in pairs(core.registered_nodes) do
		local id = core.get_content_id(name)
		if def.groups then
			for _, g in ipairs(skip_groups) do
				if def.groups[g] then surf_skip_ids[id] = true; break end
			end
		end
		if def.drawtype == "airlike" then
			surf_skip_ids[id] = true
		end
		if def.liquidtype and def.liquidtype ~= "none" then
			surf_skip_ids[id] = true
		end
	end
	local cc_id = core.get_content_id("cloudcraft:cloud")
	if cc_id then surf_skip_ids[cc_id] = true end

	core.log('action', '[v7_rivers] Mapgen script ready.')
end)

if not ok then
	core.log('error', '[v7_rivers] Init FAILED: ' .. tostring(err))
	return
end

-- Basin lakes without reconciliation are the walled reservoirs this was written
-- to get rid of: the DEM rim margin is zero, so the water can only be held in by
-- masonry.  No reconciliation, no basin lakes -- fill_basins still finds the
-- ponds that v7's own terrain genuinely closes.
if DO_BASIN_LAKES and not reconcile then
	DO_BASIN_LAKES = false
	core.log('warning', '[v7_rivers] basin lakes disabled: ' ..
		(not RECONCILE and 'terrain reconciliation turned off by setting'
		or not v7base.available and 'v7 base terrain unavailable'
		or 'river grid was not built from v7 terrain (base_from_mapgen)'))
end

-- Biome-tinted water: same palette encoding as always_greener/scripts/water.lua
-- (16x16 humidity x heat grid, index = hum_bucket * 16 + heat_bucket).
local function water_colour(x, y, z)
	local pos = {x = x, y = y, z = z}
	local heat = core.get_heat(pos) or 50
	local hum  = core.get_humidity(pos) or 50
	if heat < 0 then heat = 0 elseif heat > 100 then heat = 100 end
	if hum  < 0 then hum  = 0 elseif hum  > 100 then hum  = 100 end
	local heat_s = math.min(15, math.floor(heat * 0.16))
	local hum_s  = math.min(15, math.floor(hum  * 0.16))
	return hum_s * 16 + heat_s
end

local floor, min, max, sqrt = math.floor, math.min, math.max, math.sqrt

-- What to seal an air pocket with: whatever the rock immediately around it
-- already is.  Sealing everything with default:stone puts a grey plug through
-- sandstone, through desert stone, through a clay bank -- the plug is the right
-- shape and the wrong colour, and colour is what you notice.  Falls back to
-- stone only when all four neighbours are air, which is the middle of a cavern.
local function seal_material(data, vi, zstride)
	local n = data[vi + 1]
	if n and n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then return n end
	n = data[vi - 1]
	if n and n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then return n end
	n = data[vi + zstride]
	if n and n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then return n end
	n = data[vi - zstride]
	if n and n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then return n end
	return c_stone
end

-- Fill the run of air starting at from_y and going down, up to `thickness`
-- nodes, stopping the moment solid ground is reached.  Returns how many nodes
-- were placed.  Solid at from_y means there was nothing to close and costs one
-- array read, which is the usual case: almost every lake bed is v7's own ground.
local function seal_down(data, vi0, miny, maxy, ystride, zstride, from_y, thickness)
	local y = min(from_y, maxy)
	local n = 0
	while y >= miny and n < thickness do
		local vi = vi0 + (y - miny) * ystride
		if data[vi] ~= c_air then break end
		data[vi] = seal_material(data, vi, zstride)
		n = n + 1
		y = y - 1
	end
	return n
end

-- Close every air pocket between two heights, rather than stopping at the first
-- solid node.  Used down the sides of a body of water, where a cave can cross
-- its depth range with solid rock both above and below it.
--
-- The CALLER must clamp y_from to below the ground surface of this column.  A
-- bank is only ever closed where the air in it is underground -- that is, a
-- cave.  Sealing open air is how a river running along a drop turns into a
-- river running along a levee, and levees are exactly what this mod does not do:
-- where the ground beside the water falls away, the water is meant to fall with
-- it.
local function seal_band(data, vi0, miny, maxy, ystride, zstride, y_from, y_to)
	local n = 0
	local y0 = max(y_to, miny)
	local y1 = min(y_from, maxy)
	local vi = vi0 + (y0 - miny) * ystride
	for _ = y0, y1 do
		if data[vi] == c_air then
			data[vi] = seal_material(data, vi, zstride)
			n = n + 1
		end
		vi = vi + ystride
	end
	return n
end

-- Per-column plug thickness, SEAL_MIN..SEAL_DEPTH.  Deterministic in world
-- coordinates, so two chunks meeting at a seam agree, and non-periodic, so it
-- does not band into diagonal stripes the way (x*a + z*b) % n does.
local function seal_thickness(x, z)
	local s = math.sin(x * 12.9898 + z * 78.233) * 43758.5453
	return SEAL_MIN + floor((s - floor(s)) * (SEAL_DEPTH - SEAL_MIN + 1))
end

-- Is there a basin anywhere near this chunk?
--
-- Read straight off the DEM grid, which is one value per blocksize nodes and
-- costs a handful of array reads, rather than off a heightmap, which costs a
-- polygon scan over every column.  1.4% of the world is basin, so this answers
-- no for almost every chunk in the world and the whole reconciliation path --
-- including the wider heightmap it needs -- is skipped outright.
--
-- Deliberately loose: a grid cell is counted if it is anywhere near the padded
-- chunk, and the padding covers the blend reach plus the half-blocksize a
-- distorted polygon corner can wander.  Saying yes when the answer was no costs
-- one wasted heightmap; saying no when the answer was yes would drop a lake.
local function basins_near(minp, maxp, sea_level)
	local grid = mapgen_rivers.grid
	local gX, gZ = grid.size.x, grid.size.z
	local dem, lakes = grid.dem, grid.lakes
	local pad = BLEND_REACH + blocksize
	local i0 = max(floor((minp.x - pad + grid_off_x) / blocksize), 0)
	local i1 = min(floor((maxp.x + pad + grid_off_x) / blocksize), gX - 1)
	local j0 = max(floor((minp.z - pad + grid_off_z) / blocksize), 0)
	local j1 = min(floor((maxp.z + pad + grid_off_z) / blocksize), gZ - 1)
	local minw = sea_level + MIN_LAKE_ELEV
	for j = j0, j1 do
		local row = j * gX
		for i = i0, i1 do
			local k = row + i + 1
			local l = lakes[k]
			if l and l >= minw and l > dem[k] then return true end
		end
	end
	return false
end

-- Distance in nodes from every column of a grid to the nearest basin column,
-- by two-pass chamfer (3 orthogonal, 4 diagonal, scaled back by 3).  Exact
-- enough for a blend weight and linear in the grid, where a per-column search
-- would be quadratic.
--
-- Only correct out to the margin the grid was built with -- a column can only
-- be measured against basins the grid actually holds -- which is why the margin
-- and BLEND_REACH are the same number.
local function basin_distance(mask, sx, sz)
	local INF = 1e9
	local d = {}
	for k = 1, sx * sz do d[k] = mask[k] and 0 or INF end

	for j = 0, sz - 1 do
		local row = j * sx
		for i = 0, sx - 1 do
			local k = row + i + 1
			local v = d[k]
			if v > 0 then
				if i > 0 and d[k - 1] + 3 < v then v = d[k - 1] + 3 end
				if j > 0 then
					if d[k - sx] + 3 < v then v = d[k - sx] + 3 end
					if i > 0 and d[k - sx - 1] + 4 < v then v = d[k - sx - 1] + 4 end
					if i < sx - 1 and d[k - sx + 1] + 4 < v then v = d[k - sx + 1] + 4 end
				end
				d[k] = v
			end
		end
	end
	for j = sz - 1, 0, -1 do
		local row = j * sx
		for i = sx - 1, 0, -1 do
			local k = row + i + 1
			local v = d[k]
			if v > 0 then
				if i < sx - 1 and d[k + 1] + 3 < v then v = d[k + 1] + 3 end
				if j < sz - 1 then
					if d[k + sx] + 3 < v then v = d[k + sx] + 3 end
					if i < sx - 1 and d[k + sx + 1] + 4 < v then v = d[k + sx + 1] + 4 end
					if i > 0 and d[k + sx - 1] + 4 < v then v = d[k + sx - 1] + 4 end
				end
				d[k] = v
			end
		end
	end

	for k = 1, sx * sz do d[k] = d[k] / 3 end
	return d
end

-- Full strength over the basin and its rim, smoothstepped to nothing by
-- BLEND_REACH.  Smoothstep rather than a straight ramp so the reconciled ground
-- meets v7's own with a matching slope at both ends and there is no crease where
-- the blend starts or stops.
local function blend_weight(d)
	if d <= BLEND_CORE then return 1 end
	if d >= BLEND_REACH then return 0 end
	local t = (BLEND_REACH - d) / (BLEND_REACH - BLEND_CORE)
	return t * t * (3 - 2 * t)
end

-- Move a column's ground up or down by `delta`, carrying its soil, its surface
-- node and whatever is standing on it along for the ride.
--
-- The whole point of moving a slab rather than retopping a column is that
-- nothing has to be invented: the grass stays the biome's grass, the sand stays
-- sand, param2 (grass colour, facedir) goes with it, and a tree that was rooted
-- here is still rooted here afterwards rather than left hanging or buried.
--
-- Raising fills the gap opened underneath with whatever was already the deepest
-- node of the slab, so a column raised over a void ends up solid from the void's
-- floor to its new surface.  That is what chokes a cave mouth inside a basin,
-- and it is why this is the whole cave-mouth story: there is no slab bridged
-- across a shaft, because the shaft is filled.
local function shift_column(data, p2data, vi0, miny, maxy, ystride, surf, delta)
	-- The ground may not leave the chunk: below miny is a chunk that has already
	-- been generated and written, so a column pushed past it would lose its
	-- surface entirely and come back as a shaft of air.  Losing some of the soil
	-- under the slab is fine -- clamping `lo` does that -- but only once the
	-- surface itself is known to land inside.
	if surf + delta < miny then delta = miny - surf end
	if delta == 0 then return end

	local lo = max(surf - CARRY_DOWN, miny, miny - delta)
	local hi = min(surf + CARRY_UP, maxy)

	if delta < 0 then
		if lo > hi then return end
		local src = vi0 + (lo - miny) * ystride
		local dst = vi0 + (lo + delta - miny) * ystride
		for _ = lo, hi do
			data[dst] = data[src]
			p2data[dst] = p2data[src]
			src = src + ystride
			dst = dst + ystride
		end
		-- What the slab vacated at the top is open air now.
		for y = max(hi + delta + 1, miny), hi do
			local vi = vi0 + (y - miny) * ystride
			data[vi] = c_air
			p2data[vi] = 0
		end
	else
		local fill = data[vi0 + (lo - miny) * ystride]
		if fill == c_air or fill == c_ignore or surf_skip_ids[fill] then
			fill = c_stone
		end
		local top = min(hi + delta, maxy)
		local src = vi0 + (top - delta - miny) * ystride
		local dst = vi0 + (top - miny) * ystride
		for _ = top, lo + delta, -1 do
			data[dst] = data[src]
			p2data[dst] = p2data[src]
			src = src - ystride
			dst = dst - ystride
		end
		for y = lo, min(lo + delta - 1, maxy) do
			local vi = vi0 + (y - miny) * ystride
			data[vi] = fill
			p2data[vi] = 0
		end
	end
end

-- v7base.lua's reproduction of v7's base terrain was checked against the running
-- world on 2026-07-26 by correlating it, per chunk, with v7's real surface read
-- out of the voxel manip.  Two independent samples:
--
--   n=1114  r=0.809  mean(v7surf-base)=+3.5  sd(base)=19.6  sd(v7surf)=19.7
--   n=2232  r=0.762  mean(v7surf-base)=+3.5  sd(base)=19.4  sd(v7surf)=21.6
--
-- r near 1 rather than near 0 is the thing that matters: a wrong seed would make
-- the two independent fields.  It is not exactly 1 because v7's real surface is
-- the base level PLUS mountains, which this does not model — and those numbers
-- pin the mountain contribution at sd ~14, which is about right.  The check has
-- served its purpose and is gone; restore it from git history if the mgv7 noise
-- parameters or the seed handling ever change.

-- Standing water in closed hollows: ponds, tarns, and river water backed up
-- behind whatever a channel ran into.
--
-- This is how a lake actually forms -- a depression fills until it finds its
-- lowest way out -- so rather than trusting the river heightmap's own lake
-- surface, the spill level is computed from the terrain that ended up in this
-- chunk.  That matters because the heightmap's basins were shaped by v7's base
-- terrain, while what is actually here is that plus mountains: flooding to the
-- heightmap's own level would spill wherever those
-- disagree, and water pouring out of a hillside is the exact failure this whole
-- mod has been fighting.
--
-- Priority flood (Barnes/Planchon-Darboux): seed every edge column at its own
-- surface, then repeatedly take the lowest column reached so far and hand its
-- level to its neighbours, raised to their own surface if that is higher.  Each
-- column ends up at the level water would stand at, and by construction that is
-- never below its own ground and never above the lowest rim it could escape
-- over.  Containment is a property of the algorithm, not of tuning.
local function fill_basins(data, p2data, area, minp, maxp, sea_level, sx, sz, ystride, lake_map)
	local miny, maxy = minp.y, maxp.y
	local ncol = sx * sz
	local h, vi0s = {}, {}

	local i = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local vi0 = area:index(x, miny, z)
			vi0s[i] = vi0
			local top
			local vi = vi0 + (maxy - miny) * ystride
			for y = maxy, miny, -1 do
				local d = data[vi]
				if d ~= c_air and d ~= c_ignore then top = y; break end
				vi = vi - ystride
			end
			if not top or top >= maxy then
				-- Nothing to stand on, or ground running out of the top of the
				-- chunk: treat as an infinitely high wall so no basin fills
				-- through a column we cannot actually see the surface of.
				h[i] = math.huge
			else
				-- Water and river water count as surface -- the top of a river
				-- IS its water line, and reading the bed instead would have the
				-- flood treat every channel as a hollow to fill.
				h[i] = max(top, sea_level)
			end
			i = i + 1
		end
	end

	-- binary min-heap over (level, column)
	local hk, hv, hn = {}, {}, 0
	local function push(k, v)
		hn = hn + 1
		hk[hn], hv[hn] = k, v
		local c = hn
		while c > 1 do
			local p = floor(c / 2)
			if hv[p] <= hv[c] then break end
			hk[p], hk[c], hv[p], hv[c] = hk[c], hk[p], hv[c], hv[p]
			c = p
		end
	end
	local function pop()
		local k, v = hk[1], hv[1]
		hk[1], hv[1] = hk[hn], hv[hn]
		hk[hn], hv[hn] = nil, nil
		hn = hn - 1
		local c = 1
		while true do
			local l, r = c * 2, c * 2 + 1
			local m = c
			if l <= hn and hv[l] < hv[m] then m = l end
			if r <= hn and hv[r] < hv[m] then m = r end
			if m == c then break end
			hk[m], hk[c], hv[m], hv[c] = hk[c], hk[m], hv[c], hv[m]
			c = m
		end
		return k, v
	end

	local level = {}
	for k = 1, sx do
		local a, b = k, (sz - 1) * sx + k
		level[a] = h[a]; push(a, h[a])
		if b ~= a then level[b] = h[b]; push(b, h[b]) end
	end
	for j = 1, sz do
		local a, b = (j - 1) * sx + 1, j * sx
		if not level[a] then level[a] = h[a]; push(a, h[a]) end
		if not level[b] then level[b] = h[b]; push(b, h[b]) end
	end

	while hn > 0 do
		local k, lv = pop()
		local cx = (k - 1) % sx
		local cz = floor((k - 1) / sx)
		for d = 1, 4 do
			local nx = cx + (d == 1 and 1 or d == 2 and -1 or 0)
			local nz = cz + (d == 3 and 1 or d == 4 and -1 or 0)
			if nx >= 0 and nx < sx and nz >= 0 and nz < sz then
				local nk = nz * sx + nx + 1
				if not level[nk] then
					local nl = h[nk]
					if lv > nl then nl = lv end
					level[nk] = nl
					push(nk, nl)
				end
			end
		end
	end

	-- Group the flooded columns, and take only basins that are wholly inside
	-- this chunk, shallow enough to be a pond, and big enough to be worth one.
	local seen = {}
	local stack = {}
	local modified, p2_modified = false, false

	for k = 1, ncol do
		if not seen[k] and h[k] < math.huge and level[k] > h[k] then
			local group, gn = {}, 0
			local sn = 1
			stack[1] = k
			seen[k] = true
			local edge, deepest = false, 0
			local table_top = -math.huge
			while sn > 0 do
				local c = stack[sn]; sn = sn - 1
				gn = gn + 1; group[gn] = c
				local cx = (c - 1) % sx
				local cz = floor((c - 1) / sx)
				if cx <= LAKE_MARGIN or cx >= sx - 1 - LAKE_MARGIN
						or cz <= LAKE_MARGIN or cz >= sz - 1 - LAKE_MARGIN then
					edge = true
				end
				local d = level[c] - h[c]
				if d > deepest then deepest = d end
				local wt = lake_map[c]
				if wt and wt > table_top then table_top = wt end
				for dd = 1, 4 do
					local nx = cx + (dd == 1 and 1 or dd == 2 and -1 or 0)
					local nz = cz + (dd == 3 and 1 or dd == 4 and -1 or 0)
					if nx >= 0 and nx < sx and nz >= 0 and nz < sz then
						local nk = nz * sx + nx + 1
						if not seen[nk] and h[nk] < math.huge and level[nk] > h[nk] then
							seen[nk] = true
							sn = sn + 1; stack[sn] = nk
						end
					end
				end
			end

			local level0 = level[group[1]]
			if not edge and gn >= LAKE_MIN_AREA and deepest <= LAKE_MAX_DEPTH
					and level0 <= table_top + LAKE_ABOVE_TABLE then
				for gi = 1, gn do
					local c = group[gi]
					local y0, y1 = h[c] + 1, level[c]
					if y0 < miny then y0 = miny end
					if y1 > maxy then y1 = maxy end
					if y0 <= y1 then
						local x = minp.x + (c - 1) % sx
						local z = minp.z + floor((c - 1) / sx)
						-- Close anything hollow under the pond floor, for the same
						-- reason the basin lakes get a floor: containment here is
						-- lateral only, and a cave one node under the bed empties
						-- the pond into it.  One array read, and nothing placed,
						-- where the ground is already whole.
						if seal_down(data, vi0s[c], miny, maxy, ystride,
								area.zstride, h[c] - 1, seal_thickness(x, z)) > 0 then
							modified = true
						end
						local col = water_colour(x, y1, z)
						local vi = vi0s[c] + (y0 - miny) * ystride
						for _ = y0, y1 do
							if data[vi] == c_air then
								data[vi] = c_rwater
								modified = true
								if p2data[vi] ~= col then
									p2data[vi] = col
									p2_modified = true
								end
							end
							vi = vi + ystride
						end
					end
				end
			end
		end
	end

	return modified, p2_modified
end

core.register_on_generated(function(vm, minp, maxp, seed)
	if not make_heightmaps then return end

	local sea_level = tonumber(core.get_mapgen_setting('water_level')) or 1
	if minp.y > Y_SKIP_ABOVE or maxp.y < sea_level - (SEAL_DEPTH + 48) then
		return
	end

	local ok2, err2 = pcall(function()
		-- Basin work needs to see past the chunk edge: the blend has to reach the
		-- same distance out of a basin no matter which chunk is asking, or two
		-- chunks reconcile the same shoreline to two different shapes and the
		-- seam between them is a step.  So when there is a basin about, every 2D
		-- field is built over the chunk plus BLEND_REACH on each side, and the
		-- chunk itself is a window into it.  When there is not -- 98% of the world
		-- -- the maps are chunk-sized and this costs nothing.
		local do_basins = DO_BASIN_LAKES and basins_near(minp, maxp, sea_level)
		local M = do_basins and BLEND_REACH or 0
		local dminp = {x = minp.x - M, y = minp.y, z = minp.z - M}
		local dmaxp = {x = maxp.x + M, y = maxp.y, z = maxp.z + M}
		local dsx = dmaxp.x - dminp.x + 1
		local dsz = dmaxp.z - dminp.z + 1

		local terrain_map, lake_map, dpmax_map, rwidth_map = make_heightmaps(dminp, dmaxp)

		local emin, emax = vm:get_emerged_area()
		local data = vm:get_data()
		local p2data = vm:get_param2_data()
		local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
		local ystride = area.ystride
		local zstride = area.zstride

		local sx = maxp.x - minp.x + 1
		local sz = maxp.z - minp.z + 1
		local miny, maxy = minp.y, maxp.y
		local modified = false
		local p2_modified = false

		-- v7's own surface for every column.  Read once for the whole chunk
		-- rather than per column; same result, less walking.
		local hs = {}
		do
			local i = 1
			for z = minp.z, maxp.z do
				for x = minp.x, maxp.x do
					local vi = area:index(x, maxy, z)
					local top
					for y = maxy, miny, -1 do
						local n = data[vi]
						if n ~= c_air and n ~= c_ignore and not surf_skip_ids[n] then
							top = y
							break
						end
						vi = vi - ystride
					end
					-- Ground running out of the top of the chunk means the real
					-- surface is above and we cannot see it from here.
					if top == maxy then top = nil end
					hs[i] = top
					i = i + 1
				end
			end
		end

		-- Index of world column (x, z) in the (possibly wider) 2D fields.
		local dbase = -dminp.z * dsx - dminp.x + 1
		local function di(x, z) return z * dsx + x + dbase end

		-- Which columns the DEM says are basin, over the whole padded grid.  Read
		-- by the reconciliation, by the water fill, and by the shoreline seal, all
		-- from this one array so they cannot disagree about where a lake is.
		--
		-- `seed` is the same set minus the river channels.  A channel column
		-- passes the lake_map > terrain_map test too -- heightmap.lua takes the
		-- lake height first and only then digs the riverbed out from under it --
		-- and seeding the blend from those would reconcile the whole drainage
		-- network's valley, out of the lake and away down the river, on the
		-- strength of a test that was never about lakes.  A river crossing a lake
		-- still gets blended: it is a channel's width from water that did seed,
		-- which is well inside BLEND_CORE.
		local mask, seed
		if do_basins then
			mask, seed = {}, {}
			local minw = sea_level + MIN_LAKE_ELEV
			for k = 1, dsx * dsz do
				local m = rwidth_map[k] >= 0 and lake_map[k] >= minw
					and lake_map[k] > terrain_map[k]
				mask[k] = m
				seed[k] = m and dpmax_map[k] <= 0
			end
		end

		-- Terrain reconciliation: give the basin to v7's ground.
		--
		-- This is the only place in the mod that raises terrain, and it is not a
		-- levee -- a levee is a wall invented to hold water somewhere the land
		-- does not.  Here the land is being put back to the shape the erosion
		-- simulation eroded it into, in a band around a hollow that simulation
		-- says is there, and the water then sits in it without help.  After this
		-- runs, no seal is ever placed above ground anywhere.
		if do_basins then
			local dist = basin_distance(seed, dsx, dsz)
			local base_h = v7base.map(dminp.x, dminp.z, dsx, dsz, 1, 2 * blocksize)
			if base_h then
				local i = 1
				for z = minp.z, maxp.z do
					for x = minp.x, maxp.x do
						local k = di(x, z)
						local w = blend_weight(dist[k])
						local vsurf = hs[i]
						-- Below the waterline is v7's ocean floor and none of our
						-- business; off the grid there is no DEM to reconcile to.
						if w > 0 and vsurf and vsurf >= sea_level and rwidth_map[k] >= 0 then
							-- v7's own relief above its base terrain: mountains,
							-- ridges, detail.  Kept, and clamped at zero -- a rim
							-- may be higher than the DEM's, never lower, so the
							-- DEM's containment survives being blended.
							local detail = vsurf - base_h[k]
							if detail < 0 then detail = 0 end
							local target = floor(
								vsurf + w * (terrain_map[k] + detail - vsurf) + 0.5)
							local delta = target - vsurf
							if delta > MAX_RAISE then delta = MAX_RAISE end
							if delta < -MAX_LOWER then delta = -MAX_LOWER end
							-- v7 owns the coastline; and this chunk is all that can
							-- be written, so ground may not be pushed out of either
							-- end of it.  A column clamped here comes out only
							-- part-reconciled, which is the price of a surface that
							-- happens to sit against a chunk boundary.
							if vsurf + delta < sea_level then delta = sea_level - vsurf end
							if vsurf + delta < miny then delta = miny - vsurf end
							if vsurf + delta > maxy - 1 then delta = maxy - 1 - vsurf end

							if delta ~= 0 then
								shift_column(data, p2data, area:index(x, miny, z),
									miny, maxy, ystride, vsurf, delta)
								hs[i] = vsurf + delta
								modified = true
								p2_modified = true
							end
						end
						i = i + 1
					end
				end
			end
		end

		-- Columns that ended up holding basin-lake water, for the shoreline pass
		-- after the main loop.
		local wcol = {}

		local i2d = 1
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local k = di(x, z)
				local dpmax = dpmax_map[k]
				local W = lake_map[k] -- DEM water surface
				local rwidth = rwidth_map[k]

				-- How far out of the channel this river's bank reaches.  Zero
				-- when there is no river anywhere near, in which case dpmax is
				-- -math.huge and the column is left exactly as v7 built it.
				local bank = min(BANK_MAX, max(BANK_MIN, BANK_RATIO * rwidth))

				-- The channel itself (dpmax > 0), plus the bank taper just
				-- outside it, on land above the sea.
				-- >= sea_level, not >: at a river mouth the waterline IS sea level,
				-- and excluding it left the channel stopping short of the coast.
				local in_river = dpmax > -bank and W >= sea_level

				-- A negative width means this column is off the edge of the
				-- pregenerated grid, where the heightmaps hold the margin
				-- elevation rather than terrain.
				if rwidth < 0 then in_river = false end

				-- Inside a basin the DEM filled to its own spill point: standing
				-- water at level W, not a river running past.
				local in_basin = do_basins and mask[k]

				-- Inside a lake there is no bank to taper: the shoreline is
				-- simply wherever v7's ground rises out of the water.  The bank
				-- branch places no water of its own, so leaving these columns to
				-- it cut a dry trench at lake level all along the channel and gave
				-- the lake somewhere to run.  The channel itself still belongs to
				-- the river branch, which digs the bed.
				if in_basin and dpmax <= 0 then in_river = false end

				if in_river then
					local vi0 = area:index(x, miny, z)
					local vi
					local vsurf = hs[i2d]

					-- Ground BELOW sea level is ocean floor and is left alone; ground
					-- exactly AT sea level is the last of the shore, and skipping it
					-- left a one-node sill damming the river off from the sea.
					if vsurf and vsurf >= sea_level then
						-- v7's own surface, untouched.  Nothing outside a river's
						-- own zone is reshaped: terrain away from water is v7's to
						-- decide, and a heightmap difference is not a reason to
						-- shave it.
						local g = vsurf

						if in_river then
							-- The waterline, clamped to v7's ground: MAX_PERCH
							-- is 0, so water is never placed above the ground.  It
							-- may sit at most MAX_GORGE below it before we give up
							-- rather than saw a slot down to it.  Never below sea
							-- level: a river cannot run lower than the ocean it
							-- drains into.
							local incision = MIN_INCISION
							local water_top = max(sea_level,
								min(W, g + MAX_PERCH - incision))

							-- A river crossing a lake is at the lake's surface,
							-- not one node under the lake bed.  Pinning the
							-- waterline to v7's ground is right on a hillside and
							-- wrong here: it laid the channel's water BELOW the
							-- standing water either side of it, leaving a trench
							-- of air through the lake for the lake to drain into.
							-- This is not a perch -- the ground really is below W,
							-- and every column around this one is filled to the
							-- same level by the basin branch.
							if in_basin and g < W then water_top = W end

							if g - water_top > MAX_GORGE then
								-- High ground standing well above the river.  The
								-- Leave v7's terrain exactly as it built it,
								-- rather than sawing a slot down to the water.

							elseif dpmax <= 0 then
								-- Bank taper, easing from the waterline out to
								-- v7's surface, so the channel gets sloped sides
								-- rather than vertical walls.  water_top can never
								-- exceed g, so this only ever cuts: there is no
								-- path here that raises ground, and therefore no
								-- levee and no one-node stone lip.
								local t = -dpmax / bank
								local target = floor(g + (water_top - g) * (1 - t) + 0.5)
								if target < g then
									local y0 = max(target + 1, miny)
									local y1 = min(g, maxy)
									if y0 <= y1 then
										vi = vi0 + (y0 - miny) * ystride
										for _ = y0, y1 do
											local n = data[vi]
											if n ~= c_air and n ~= c_ignore then
												data[vi] = c_air
												modified = true
											end
											vi = vi + ystride
										end
									end
								end

							else
								-- Clear everything above the waterline.
								local y0 = max(water_top + 1, miny)
								if y0 <= maxy then
									vi = vi0 + (y0 - miny) * ystride
									for _ = y0, maxy do
										local n = data[vi]
										if n ~= c_air and n ~= c_ignore then
											data[vi] = c_air
											modified = true
										end
										vi = vi + ystride
									end
								end

								-- Channel: cut a bed down from the waterline and
								-- fill it.  Depth follows dpmax, which peaks at the
								-- middle of the channel and falls to zero at its
								-- banks, so the bed comes out dished rather than
								-- flat-bottomed.  The floor is 1, not 3: this
								-- network calls anything past min_catchment a
								-- river, and most of those are under a node wide.
								-- Giving a half-node trickle a three-deep bed is
								-- what made headwaters read as canals.
								local river_depth = max(3, min(floor(dpmax * 15), 15))
								local bed = max(water_top - river_depth, miny - 1)
								-- Never above v7's own ground: with the waterline
								-- raised to a lake's surface the bed can land
								-- above the lake floor, and the sand and stone
								-- laid on it would then be a riverbed hanging in
								-- open water.
								if bed > g then bed = g end
								y0 = max(bed + 1, miny)
								local y1 = min(water_top, maxy)
								if y0 <= y1 then
									local col = water_colour(x, water_top, z)
									vi = vi0 + (y0 - miny) * ystride
									for _ = y0, y1 do
										if data[vi] ~= c_rwater then
											data[vi] = c_rwater
											modified = true
										end
										if p2data[vi] ~= col then
											p2data[vi] = col
											p2_modified = true
										end
										vi = vi + ystride
									end
								end

								-- Bed: sand over stone.
								if bed >= miny and bed <= maxy then
									data[vi0 + (bed - miny) * ystride] = c_sand
									modified = true
								end
								if bed - 1 >= miny and bed - 1 <= maxy then
									data[vi0 + (bed - 1 - miny) * ystride] = c_stone
									modified = true
								end

								-- Seal air pockets (caves) directly under the bed.
								local thick = seal_thickness(x, z)
								local y = min(bed - 2, maxy)
								local seal_floor = max(miny, bed - 1 - thick)
								local sealed = 0
								while y >= seal_floor and sealed < thick do
									vi = vi0 + (y - miny) * ystride
									if data[vi] == c_air then
										data[vi] = seal_material(data, vi, zstride)
										modified = true
										sealed = sealed + 1
									else
										break
									end
									y = y - 1
								end
							end
						end
					end

				elseif in_basin then
					-- W is this basin's water level: one number for the whole
					-- lake, so the surface comes out flat and every chunk that
					-- touches it agrees on where it is.
					local vi0 = area:index(x, miny, z)
					local vsurf = hs[i2d]
					local bedy

					if vsurf then
						-- The reconciliation pass has already put this column where
						-- the DEM says the basin floor is, and choked any cave mouth
						-- or shaft that was reading through it, so the surface can
						-- simply be believed now.  There is no hole heuristic left:
						-- the fix for a hole is to fill it, not to roof it.
						if vsurf < W then bedy = vsurf end
					elseif data[area:index(x, maxy, z)] == c_air then
						-- Nothing solid anywhere in this column: the ground, and the
						-- lake floor with it, is in the chunk below.  This chunk
						-- holds the upper part of the water column, which would
						-- otherwise come out as a lake with its top sliced off at
						-- the chunk boundary.
						bedy = miny - 1
					end

					if bedy then
						-- Put a bottom on it.  Water needs one closed layer under
						-- it, and v7's ground supplies that almost everywhere -- but
						-- "almost" is not good enough: one cave breaking the bed
						-- drains the entire lake into it.  seal_down stops at the
						-- first solid node, so where the ground is already whole
						-- this costs a single array read and places nothing.
						if bedy >= miny then
							if seal_down(data, vi0, miny, maxy, ystride, zstride,
									bedy, seal_thickness(x, z)) > 0 then
								modified = true
							end
							-- and the same again just under the bed, so a cavern
							-- roof one node thick is not what the lake stands on.
							if seal_down(data, vi0, miny, maxy, ystride, zstride,
									bedy - 1, seal_thickness(x, z)) > 0 then
								modified = true
							end
						end

						local y0 = max(bedy + 1, miny)
						local y1 = min(W, maxy)
						if y0 <= y1 then
							local col = water_colour(x, W, z)
							local vi = vi0 + (y0 - miny) * ystride
							for _ = y0, y1 do
								if data[vi] == c_air then
									data[vi] = c_rwater
									wcol[i2d] = true
									modified = true
									if p2data[vi] ~= col then
										p2data[vi] = col
										p2_modified = true
									end
								end
								vi = vi + ystride
							end
						end
					end
				end

				i2d = i2d + 1
			end
		end

		-- Shoreline: close cave voids in the ring of columns immediately around
		-- the water.
		--
		-- A lake's bottom is not the only way out of it.  A cave crossing the
		-- shore at the depth the water occupies is a hole in the lake's SIDE, and
		-- the water runs out sideways into it.  Reconciled ground closes the
		-- surface of a basin; only v7's caves are left to close, and this is the
		-- one thing this pass may do.
		--
		-- The band is clamped to the column's OWN GROUND, which is what this pass
		-- never did before and what turned every lake into a reservoir with
		-- masonry sides: seal_band fills air, and air above the ground is sky.
		-- Nothing here can produce a wall now -- the highest node it can touch is
		-- the surface of the land it is standing in.
		--
		-- Only the ring, and only next to actual water: sealing every above-water
		-- column inside a basin filled thousands of nodes of cave for lakes that
		-- v7's mountains had left dry.  One ring is enough -- water can only reach
		-- a column it touches, and once that column is closed over the water's
		-- depth there is nowhere for the next one to be reached from.  A neighbour
		-- across the chunk edge is judged by the DEM instead of by wcol, which
		-- over-seals a one-column border underground and closes the gap that used
		-- to run all the way along every seam.
		if do_basins and next(wcol) ~= nil then
			local i = 1
			for z = minp.z, maxp.z do
				for x = minp.x, maxp.x do
					local vsurf = hs[i]
					if not wcol[i] and vsurf then
						local cx = (i - 1) % sx
						local cz = floor((i - 1) / sx)
						local k = di(x, z)
						local W = 0
						-- Inside the chunk, "wet" means water was actually placed.
						-- Across the seam there is no way to know, so the DEM
						-- answers instead.
						if (cx > 0 and wcol[i - 1] or cx == 0 and mask[k - 1])
								and lake_map[k - 1] > W then
							W = lake_map[k - 1]
						end
						if (cx < sx - 1 and wcol[i + 1] or cx == sx - 1 and mask[k + 1])
								and lake_map[k + 1] > W then
							W = lake_map[k + 1]
						end
						if (cz > 0 and wcol[i - sx] or cz == 0 and mask[k - dsx])
								and lake_map[k - dsx] > W then
							W = lake_map[k - dsx]
						end
						if (cz < sz - 1 and wcol[i + sx] or cz == sz - 1 and mask[k + dsx])
								and lake_map[k + dsx] > W then
							W = lake_map[k + dsx]
						end
						if W > 0 then
							if seal_band(data, area:index(x, miny, z), miny, maxy,
									ystride, zstride, min(W, vsurf),
									W - SIDE_SEAL_MAX) > 0 then
								modified = true
							end
						end
					end
					i = i + 1
				end
			end
		end

		-- After carving, so the flood sees the channels that were just cut and
		-- fills what they actually enclose.
		if DO_LAKES then
			-- fill_basins reads the water table per chunk column, so hand it a
			-- chunk-sized view when the fields were built wider than the chunk.
			local wt = lake_map
			if M > 0 then
				wt = {}
				local i = 1
				for z = minp.z, maxp.z do
					for x = minp.x, maxp.x do
						wt[i] = lake_map[di(x, z)]
						i = i + 1
					end
				end
			end
			local lm, lp2 = fill_basins(data, p2data, area, minp, maxp, sea_level,
				sx, sz, ystride, wt)
			modified = modified or lm
			p2_modified = p2_modified or lp2
		end

		if modified then
			vm:set_data(data)
		end
		if p2_modified then
			vm:set_param2_data(p2data)
		end
	end)

	if not ok2 then
		core.log('error', '[v7_rivers] on_generated error: ' .. tostring(err2))
	end
end)
