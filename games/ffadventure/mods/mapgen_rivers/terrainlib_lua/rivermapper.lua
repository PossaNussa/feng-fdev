-- rivermapper.lua

-- This file provide functions to construct the river tree from an elevation model.
-- Based on a research paper:
--
--     Cordonnier, G., Bovy, B., and Braun, J.:
--     A versatile, linear complexity algorithm for flow routing in topographies with depressions,
--     Earth Surf. Dynam., 7, 549–562, https://doi.org/10.5194/esurf-7-549-2019, 2019.
--
-- Big thanks to them for releasing this paper under a free license ! :)

-- The algorithm here makes use of most of the paper's concepts, including the Planar Borůvka algorithm.


-- Applies all steps of the flow routing, to calculate flow direction for every node, and lake surface elevation.
-- It's quite a hard piece of code, but we will go step by step and explain what's going on, so stay with me and... let's goooooooo!
local function flow_routing(dem, dirs, lakes) -- 'dirs' and 'lakes' are optional tables to reuse for memory optimization, they may contain any data.
	dirs = dirs or {}
	lakes = lakes or {}

	-- Localize for performance
	local tremove = table.remove
	local mmax = math.max
	local mrand = math.random

	local X, Y = dem.X, dem.Y
	dirs.X = X
	dirs.Y = Y
	lakes.X = X
	lakes.Y = Y
	local i = 1
	local dirs2 = {}
	for i=1, X*Y do
		dirs2[i] = 0
	end

	----------------------------------------
	-- STEP 1: Find local flow directions --
	----------------------------------------
	-- Use the local flow function and fill the flow direction tables
	local singular = {}
	for y=1, Y do
		for x=1, X do
			local zi = dem[i]
			-- Determine how water should flow at 1 node scale.
			-- The straightforward approach would be "Water will flow to the lowest of the 4 neighbours", but here water flows to one of the lower neighbours, chosen randomly, with probability depending on height difference.
			-- This makes rivers better follow the curvature of the topography at large scale, and be less biased by pure N/E/S/W directions.
			local pSouth = y<Y and mmax(zi-dem[i+X], 0) or 0
			local pEast = x<X and mmax(zi-dem[i+1], 0) or 0
			local pNorth = y>1 and mmax(zi-dem[i-X], 0) or 0
			local pWest = x>1 and mmax(zi-dem[i-1], 0) or 0

			local d = 0
			local sum = pSouth + pEast + pNorth + pWest
			local r = mrand() * sum
			if sum > 0 then
				if r < pSouth then
					d = 1
				elseif r-pSouth < pEast then
					d = 2
				elseif r-pSouth-pEast < pNorth then
					d = 3
				else
					d = 4
				end
			end

			-- 'dirs': Direction toward which water flow
			-- 'dirs2': Directions from which water comes
			dirs[i] = d
			if d == 0 then -- If water can't flow from this node, add it to the list of singular nodes that will be resolved later
				singular[#singular+1] = i
			elseif d == 1 then
				dirs2[i+X] = dirs2[i+X] + 1
			elseif d == 2 then
				dirs2[i+1] = dirs2[i+1] + 2
			elseif d == 3 then
				dirs2[i-X] = dirs2[i-X] + 4
			elseif d == 4 then
				dirs2[i-1] = dirs2[i-1] + 8
			end
			i = i + 1
		end
	end

	--------------------------------------
	-- STEP 2: Compute basins and links --
	--------------------------------------
	-- Now water can flow until it reaches a singular node (which is in most cases the bottom of a depression)
	-- We will calculate the drainage basin of every singular node (all the nodes from which the water will flow in this singular node, directly or indirectly), make an adjacency list of basins, and find the lowest pass between each pair of adjacent basins (they are potential lake outlets)
	local nbasins = #singular
	local basin_id = {}
	local links = {}
	local basin_links

	for i=1, X*Y do
		basin_id[i] = 0
	end

	local cur = nbasins
	local ib = 0
	while cur > 0 do
			local i = singular[cur]
			cur = cur - 1
			if dirs[i] == 0 then
				basin_links = {}
				links[#links+1] = basin_links
				ib = ib + 1
			end
			basin_id[i] = ib
			local d = dirs2[i] -- Get the directions water is coming from

			-- Iterate through the 4 directions
			-- Loop is unrolled on purpose, for performance (critical part!)
			----------
			-- EAST --
			----------
			if d >= 8 then -- River coming from the East
				d = d - 8
				cur = cur + 1
				singular[cur] = i+1
			-- If no river is coming from the East, we might be at the limit of two basins, thus we need to test adjacency.
			elseif i%X > 0 then
				if basin_id[i+1] ~= ib and basin_id[i+1] ~= 0 then
					local b2 = basin_id[i+1]
					local elev = mmax(dem[i], dem[i+1]) -- Elevation of the highest of the two sides of the link (or only i1 if b2 is map outside)
					local l2 = basin_links[b2]
					if not l2 then
						l2 = {b2, ib, elev=elev, i=i+1, is_y=false}
						basin_links[b2] = l2 -- Potential non-linear complexity here
					elseif l2.elev > elev then -- If this link is lower than the lowest registered link between these two basins, register it as the new lowest pass
						l2.elev = elev
						l2.i = i+1
						l2.is_y = false
						l2[1] = b2
						l2[2] = ib
					end
				end
			else -- If the eastern neighbour is outside the map
				local l2 = basin_links[0]
				if not l2 then
					l2 = {0, ib, elev=dem[i], i=i, is_y=false}
					basin_links[0] = l2
				elseif l2.elev > dem[i] then
					l2.elev = dem[i]
					l2.i = i
					l2.is_y = false
					l2[1] = 0
					l2[2] = ib
				end
			end

			-----------
			-- SOUTH --
			-----------
			if d >= 4 then -- River coming from the South
				d = d - 4
				cur = cur + 1
				singular[cur] = i+X
			elseif i <= X*(Y-1) then
				if basin_id[i+X] ~= ib and basin_id[i+X] ~= 0 then
					local b2 = basin_id[i+X]
					local elev = mmax(dem[i], dem[i+X])
					local l2 = basin_links[b2]
					if not l2 then
						l2 = {b2, ib, elev=elev, i=i+X, is_y=true}
						basin_links[b2] = l2
					elseif l2.elev > elev then
						l2.elev = elev
						l2.i = i+X
						l2.is_y = true
						l2[1] = b2
						l2[2] = ib
					end
				end
			else
				local l2 = basin_links[0]
				if not l2 then
					l2 = {0, ib, elev=dem[i], i=i, is_y=true}
					basin_links[0] = l2
				elseif l2.elev > dem[i] then
					l2.elev = dem[i]
					l2.i = i
					l2.is_y = true
					l2[1] = 0
					l2[2] = ib
				end
			end

			----------
			-- WEST --
			----------
			if d >= 2 then -- River coming from the West
				d = d - 2
				cur = cur + 1
				singular[cur] = i-1
			elseif i%X ~= 1 then
				if basin_id[i-1] ~= ib and basin_id[i-1] ~= 0 then
					local b2 = basin_id[i-1]
					local elev = mmax(dem[i], dem[i-1])
					local l2 = basin_links[b2]
					if not l2 then
						l2 = {b2, ib, elev=elev, i=i, is_y=false}
						basin_links[b2] = l2
					elseif l2.elev > elev then
						l2.elev = elev
						l2.i = i
						l2.is_y = false
						l2[1] = b2
						l2[2] = ib
					end
				end
			else
				local l2 = basin_links[0]
				if not l2 then
					l2 = {0, ib, elev=dem[i], i=i, is_y=false}
					basin_links[0] = l2
				elseif l2.elev > dem[i] then
					l2.elev = dem[i]
					l2.i = i
					l2.is_y = false
					l2[1] = 0
					l2[2] = ib
				end
			end

			-----------
			-- NORTH --
			-----------
			if d >= 1 then -- River coming from the North
				cur = cur + 1
				singular[cur] = i-X
			elseif i > X then
				if basin_id[i-X] ~= ib and basin_id[i-X] ~= 0 then
					local b2 = basin_id[i-X]
					local elev = mmax(dem[i], dem[i-X])
					local l2 = basin_links[b2]
					if not l2 then
						l2 = {b2, ib, elev=elev, i=i, is_y=true}
						basin_links[b2] = l2
					elseif l2.elev > elev then
						l2.elev = elev
						l2.i = i
						l2.is_y = true
						l2[1] = b2
						l2[2] = ib
					end
				end
			else
				local l2 = basin_links[0]
				if not l2 then
					l2 = {0, ib, elev=dem[i], i=i, is_y=true}
					basin_links[0] = l2
				elseif l2.elev > dem[i] then
					l2.elev = dem[i]
					l2.i = i
					l2.is_y = true
					l2[1] = 0
					l2[2] = ib
				end
			end
	end
	dirs2 = nil

	links[0] = {}
	local nlinks = {}
	for i=0, nbasins do
		nlinks[i] = 0
	end

	-- Iterate through pairs of adjacent basins, and make the links reciprocal
	for ib1=1, #links do
		for ib2, link in pairs(links[ib1]) do
			if ib2 < ib1 then
				links[ib2][ib1] = link
				nlinks[ib1] = nlinks[ib1] + 1
				nlinks[ib2] = nlinks[ib2] + 1
			end
		end
	end

	-----------------------------------------------------
	-- STEP 3: Compute minimal spanning tree of basins --
	-----------------------------------------------------
	-- We've got an adjacency list of basins with the elevation of their links.
	-- We will build a minimal spanning tree of the basins (where costs are the elevation of the links). As demonstrated by Cordonnier et al., this finds the outlets of the basins, where water would naturally flow. This does not tell in which direction water is flowing, however.
	-- We will use a version of Borůvka's algorithm, with Mareš' optimizations to approach linear complexity (see paper).
	-- The concept of Borůvka's algorithm is to take elements and merge them with their lowest neighbour, until all elements are merged.
	-- Mareš' optimizations mainly consist in skipping elements that have over 8 links, until extra links are removed when other elements are merged.
	-- Note that for this step we are only working on basins, not grid nodes.
	local lowlevel = {}
	cur = 0
	local ref = singular -- Reuse table
	for i=0, nbasins do
		if nlinks[i] <= 8 then
			cur = cur + 1
			lowlevel[cur] = i
			ref[i] = cur
		end
	end

	local basin_graph = {}
	for i=0, nbasins do
		basin_graph[i] = {} -- Initialize (to ensure subtables don't go in the hash part)
	end
	for i=1, nbasins do
		-- Iterate in lowlevel but its contents may change during the loop
		local b1 = lowlevel[cur]
		cur = cur - 1
		local lnk1 = links[b1]

		local b2
		local lowest = math.huge
		local lnk1 = links[b1]
		-- Look for lowest link
		for bn, bdata in pairs(lnk1) do
			if bdata.elev < lowest then
				lowest = bdata.elev
				b2 = bn
			end
		end

		-- Add link to the graph, in both directions
		local bound = lnk1[b2]
		local bb1, bb2 = bound[1], bound[2]
		basin_graph[bb1][bb2] = bound -- Potential non-linear complexity here
		basin_graph[bb2][bb1] = bound

		-- Merge basin b1 into b2
		local lnk2 = links[b2]
		-- First, remove the link between b1 and b2
		lnk1[b2] = nil
		lnk2[b1] = nil
		nlinks[b2] = nlinks[b2] - 1
		-- When the number of links is changing, we need to check whether the basin can be added to / removed from 'lowlevel'
		if nlinks[b2] == 8 then
			cur = cur + 1
			lowlevel[cur] = b2
			ref[b2] = cur
		end
		-- Look for basin 1's neighbours, and add them to basin 2 if they have a lower pass
		for bn, bdata in pairs(lnk1) do
			local lnkn = links[bn]
			lnkn[b1] = nil

			if lnkn[b2] then -- If bassin bn is also linked to b2
				nlinks[bn] = nlinks[bn] - 1 -- Then bassin bn is losing a link because it keeps only one link toward b1/b2 after the merge
				if nlinks[bn] == 8 then
					cur = cur + 1
					lowlevel[cur] = bn
					ref[bn] = cur
				end
			else -- If bn was linked to b1 but not to b2
				nlinks[b2] = nlinks[b2] + 1 -- Then b2 is gaining a link to bn because of the merge
				if nlinks[b2] == 9 then
					lowlevel[ref[b2]] = lowlevel[cur]
					ref[lowlevel[cur]] = ref[b2]
					cur = cur - 1
				end
			end

			if not lnkn[b2] or lnkn[b2].elev > bdata.elev then -- If the link b1-bn will become the new lowest link between b2 and bn, redirect the link to b2
				lnkn[b2] = bdata
				lnk2[bn] = bdata
			end
		end
	end

	--------------------------------------------------------------
	-- STEP 4: Orient basin graph, and grid nodes inside basins --
	--------------------------------------------------------------
	-- We will finally solve those freaking singular nodes.
	-- To orient the basin graph, we will consider that the ultimate basin water should flow into is the map outside (basin #0). We will start from it and recursively walk upstream to the neighbouring basins, using only links that are in the minimal spanning tree. This gives the flow direction of the links, and thus, the outlet of every basin.
	-- This will also give lake elevation, which is the highest link encountered between map outside and the given basin on the spanning tree.
	-- And within each basin, we need to modify flow directions to connect the singular node to the outlet.
	local queue = {0}
	local queuevalues = {-math.huge}
	cur = 1
	local basin_lake = {}
	for n=1, nbasins do
		basin_lake[n] = 0
	end
	local reverse = {3, 4, 1, 2, [0]=0}
	while cur > 0 do
		local b1, elev1 = queue[cur], queuevalues[cur] -- Pop from queue
		cur = cur - 1
		basin_lake[b1] = elev1
		-- Iterate through b1's neighbours (according to the spanning tree)
		for b2, bound in pairs(basin_graph[b1]) do
			-- Make b2 flow into b1
			local i = bound.i -- Get the coordinate of the link (which is the basin's outlet)
			local dir = bound.is_y and 3 or 4 -- And get the direction (S/E/N/W)
			if basin_id[i] ~= b2 then
				dir = dir - 2
				-- Coordinate 'i' refers to the side of the link with the highest X/Y position. In case it is in the wrong basin, take the other side by decrementing by one row/column.
				if bound.is_y then
					i = i - X
				else
					i = i - 1
				end
			elseif b1 == 0 then
				dir = 0
			end

			-- Use the flow directions computed in STEP 2 to find the route from the outlet position to the singular node, and reverse this route to make the singular node flow into the outlet
			-- This can make the river flow uphill, which may seem unnatural, but it can only happen below a lake (because outlet elevation defines lake surface elevation)
			repeat
				-- Assign i's direction to 'dir', and get i's former direction
				dir, dirs[i] = dirs[i], dir
				-- Move i by following its former flow direction (downstream)
				if dir == 1 then
					i = i + X
				elseif dir == 2 then
					i = i + 1
				elseif dir == 3 then
					i = i - X
				elseif dir == 4 then
					i = i - 1
				end
				-- Reverse the flow direction for the next node, which will flow into i
				dir = reverse[dir]
			until dir == 0 -- Stop when reaching the singular node

			-- Add basin b2 into the queue, and keep the highest link elevation, that will define the elevation of the lake in b2
			cur = cur + 1
			queue[cur] = b2
			queuevalues[cur] = mmax(elev1, bound.elev)
			-- Remove b1 from b2's neighbours to avoid coming back to b1
			basin_graph[b2][b1] = nil
		end
		basin_graph[b1] = nil
	end

	-- Every node will be assigned the lake elevation of the basin it belongs to.
	-- If lake elevation is lower than ground elevation, it simply means that there is no lake here.
	for i=1, X*Y do
		lakes[i] = basin_lake[basin_id[i]]
	end

	-- That's it!
	return dirs, lakes
end


local function accumulate(dirs, waterq)
	-- Calculates the river flow by determining the surface of the catchment area for every node
	-- This means: how many nodes will give their water to that given node, directly or indirectly?
	-- This is obtained by following rivers downstream and summing up the flow of every tributary, starting with a value of 1 at the sources.
	-- This will give non-zero values for every node but only large values will be considered to be rivers.
	local X, Y = dirs.X, dirs.Y
	waterq = waterq or {X=X, Y=Y}

	local ndonors = {}
	for i=1, X*Y do
		ndonors[i] = 0
		waterq[i] = 1
	end

	-- Calculate the number of direct donors
	for i=1, X*Y do
		if dirs[i] == 1 then
			ndonors[i+X] = ndonors[i+X] + 1
		elseif dirs[i] == 2 then
			ndonors[i+1] = ndonors[i+1] + 1
		elseif dirs[i] == 3 then
			ndonors[i-X] = ndonors[i-X] + 1
		elseif dirs[i] == 4 then
			ndonors[i-1] = ndonors[i-1] + 1
		end
	end

	for i1=1, X*Y do
		-- Find sources (nodes that have no donor)
		if ndonors[i1] == 0 then
			local i2 = i1
			local dir = dirs[i2]
			local w = waterq[i2]
			-- Follow the water flow downstream: move 'i2' to the next node according to its flow direction
			while dir > 0 do
				if dir == 1 then
					i2 = i2 + X
				elseif dir == 2 then
					i2 = i2 + 1
				elseif dir == 3 then
					i2 = i2 - X
				elseif dir == 4 then
					i2 = i2 - 1
				end
				-- Increment the water quantity of i2
				w = w + waterq[i2]
				waterq[i2] = w

				-- Stop on an unresolved confluence (node with >1 donors) and decrease the number of remaining donors
				-- When the ndonors of a confluence has decreased to 1, it means that its water quantity has already been incremented by its tributaries, so it can be resolved like a standard river section. However, do not decrease ndonors to zero to avoid considering it as a source.
				if ndonors[i2] > 1 then
					ndonors[i2] = ndonors[i2] - 1
					break
				end
				dir = dirs[i2]
			end
		end
	end

	return waterq
end

return {
	flow_routing = flow_routing,
	accumulate = accumulate,
}
