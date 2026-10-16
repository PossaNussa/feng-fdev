-- By making this table of all possible permutations of horizontal direction we can avoid
-- lots of redundant calculations.

local all_direction_permutations = {
	{{x=0,z=1},{x=0,z=-1},{x=1,z=0},{x=-1,z=0}},
	{{x=0,z=1},{x=0,z=-1},{x=-1,z=0},{x=1,z=0}},
	{{x=0,z=1},{x=1,z=0},{x=0,z=-1},{x=-1,z=0}},
	{{x=0,z=1},{x=1,z=0},{x=-1,z=0},{x=0,z=-1}},
	{{x=0,z=1},{x=-1,z=0},{x=0,z=-1},{x=1,z=0}},
	{{x=0,z=1},{x=-1,z=0},{x=1,z=0},{x=0,z=-1}},
	{{x=0,z=-1},{x=0,z=1},{x=-1,z=0},{x=1,z=0}},
	{{x=0,z=-1},{x=0,z=1},{x=1,z=0},{x=-1,z=0}},
	{{x=0,z=-1},{x=1,z=0},{x=-1,z=0},{x=0,z=1}},
	{{x=0,z=-1},{x=1,z=0},{x=0,z=1},{x=-1,z=0}},
	{{x=0,z=-1},{x=-1,z=0},{x=1,z=0},{x=0,z=1}},
	{{x=0,z=-1},{x=-1,z=0},{x=0,z=1},{x=1,z=0}},
	{{x=1,z=0},{x=0,z=1},{x=0,z=-1},{x=-1,z=0}},
	{{x=1,z=0},{x=0,z=1},{x=-1,z=0},{x=0,z=-1}},
	{{x=1,z=0},{x=0,z=-1},{x=0,z=1},{x=-1,z=0}},
	{{x=1,z=0},{x=0,z=-1},{x=-1,z=0},{x=0,z=1}},
	{{x=1,z=0},{x=-1,z=0},{x=0,z=1},{x=0,z=-1}},
	{{x=1,z=0},{x=-1,z=0},{x=0,z=-1},{x=0,z=1}},
	{{x=-1,z=0},{x=0,z=1},{x=1,z=0},{x=0,z=-1}},
	{{x=-1,z=0},{x=0,z=1},{x=0,z=-1},{x=1,z=0}},
	{{x=-1,z=0},{x=0,z=-1},{x=1,z=0},{x=0,z=1}},
	{{x=-1,z=0},{x=0,z=-1},{x=0,z=1},{x=1,z=0}},
	{{x=-1,z=0},{x=1,z=0},{x=0,z=-1},{x=0,z=1}},
	{{x=-1,z=0},{x=1,z=0},{x=0,z=1},{x=0,z=-1}},
}

local get_node = minetest.get_node
local set_node = minetest.swap_node

local neighbour_dirs = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1},
	{x = 0, y = 1, z = 0},
	{x = 0, y = -1, z = 0},
}

-- Deciding whether a lone node of water is really on its own.  The six faces are
-- not enough: a node the flow has just pushed up onto a shore has the lake it
-- came from diagonally beneath it, and calling that stranded starts a loop —
-- it settles into a puddle, the puddle runs straight back into the lake, the
-- lake pushes another node out, forever.  Water within one cell in any
-- direction counts as the same body.
local function has_liquid_nearby(pos, liquid)
	local px, py, pz = pos.x, pos.y, pos.z
	for y = py - 1, py + 1 do
	for x = px - 1, px + 1 do
	for z = pz - 1, pz + 1 do
		if not (x == px and y == py and z == pz) and
				get_node({x = x, y = y, z = z}).name == liquid then
			return true
		end
	end
	end
	end
	return false
end

-- Dynamic liquids
-----------------------------------------------------------------------------------------------------------------------

local disable_flow_above = dynamic_liquid.config.disable_flow_above or 32767

-- Stability caches of all registered liquid ABMs, so node dig/place/liquid
-- events can invalidate every cache in one pass.
local stable_caches = {}

local function invalidate_in_all(pos)
	local h = minetest.hash_node_position(pos)
	for i = 1, #stable_caches do
		stable_caches[i][h] = nil
	end
end

local function invalidate_around_in_all(pos)
	local x, y, z = pos.x, pos.y, pos.z
	invalidate_in_all(pos)
	invalidate_in_all({x=x+1, y=y,   z=z  })
	invalidate_in_all({x=x-1, y=y,   z=z  })
	invalidate_in_all({x=x,   y=y+1, z=z  })
	invalidate_in_all({x=x,   y=y-1, z=z  })
	invalidate_in_all({x=x,   y=y,   z=z+1})
	invalidate_in_all({x=x,   y=y,   z=z-1})
end

-- Shallow water moves nodes around with set_node, which fires none of the hooks
-- below, so it has to say so itself.  Without this a source that gave up beside
-- a puddle stays marked stable for the full TTL after the puddle has gone, and
-- the flow behind it stands still for half a minute for no visible reason.
dynamic_liquid.invalidate_stability = function(pos)
	invalidate_around_in_all(pos)
end

-- Entries are only re-checked when their ABM fires, so stale entries for
-- unloaded areas would otherwise accumulate forever; wipe periodically.
local function purge_stable_caches()
	for i = 1, #stable_caches do
		local cache = stable_caches[i]
		for k in pairs(cache) do
			cache[k] = nil
		end
	end
	minetest.after(600, purge_stable_caches)
end
minetest.after(600, purge_stable_caches)

-- A dug/placed node or an engine liquid transform can open a path next to a
-- source that was marked stable; wake the neighbourhood up immediately.
minetest.register_on_dignode(function(pos)
	invalidate_around_in_all(pos)
end)
minetest.register_on_placenode(function(pos)
	invalidate_around_in_all(pos)
end)
minetest.register_on_liquid_transformed(function(pos_list)
	for i = 1, #pos_list do
		invalidate_around_in_all(pos_list[i])
	end
end)

dynamic_liquid.liquid_abm = function(liquid, flowing_liquid, chance)
	-- Stability cache: hash → gametime when marked stable.
	-- Settled sources skip the full neighbour scan until TTL expires or a neighbour moves.
	local stable = {}
	local STABLE_TTL = 30  -- seconds; dig/place/liquid hooks handle immediate cases
	stable_caches[#stable_caches + 1] = stable

	local function invalidate_around(pos)
		local x, y, z = pos.x, pos.y, pos.z
		stable[minetest.hash_node_position({x=x+1, y=y,   z=z  })] = nil
		stable[minetest.hash_node_position({x=x-1, y=y,   z=z  })] = nil
		stable[minetest.hash_node_position({x=x,   y=y+1, z=z  })] = nil
		stable[minetest.hash_node_position({x=x,   y=y-1, z=z  })] = nil
		stable[minetest.hash_node_position({x=x,   y=y,   z=z+1})] = nil
		stable[minetest.hash_node_position({x=x,   y=y,   z=z-1})] = nil
	end

	minetest.register_abm({
		label = "dynamic_liquid " .. liquid .. " and " .. flowing_liquid,
		nodenames = {liquid},
		-- The trigger is "air", not flowing water.  This ABM moves a source into
		-- an open cell itself (see the air checks below) — it never needed the
		-- engine's flowing water to carry the water, only something to tell it a
		-- source has somewhere to go.  Waking on flowing water made the whole
		-- system a hostage to the engine's finite liquid flow: throttle that flow
		-- down (to stop it flinging a sheet out ahead of the real water) and the
		-- ABM stops firing, so the water sits still.  A source is worth looking at
		-- the moment it touches air; the stable cache keeps still bodies cheap.
		--
		-- Flowing water and puddles stay on the list too: a source can be walled
		-- in by a puddle (not floodable, so no air appears beside it) or sat in a
		-- channel the engine has filled with flowing, and it must still wake then.
		neighbors = {"air", flowing_liquid, "group:dynamic_liquid_shallow"},
		interval = 1,
		chance = chance or 1,
		y_max = disable_flow_above,
		catch_up = false,
		action = function(pos,node) -- Do everything possible to optimize this method
			-- (A) Early exit for known-stable sources
			local h = minetest.hash_node_position(pos)
			local t = stable[h]
			if t and (minetest.get_gametime() - t) < STABLE_TTL then return end

			-- (A0) Water touching unloaded map holds still.  Nothing here ever
			-- writes into an "ignore" cell, so the water is not literally draining
			-- into the void — but whether a boundary source should fall, slosh or
			-- thin depends on the water in the next chunk, and that chunk is not in
			-- memory yet.  Deciding from the loaded half alone is what makes the
			-- frontier "leak": the edge column settles out or runs sideways as
			-- though the continuous water beyond it were open air.  Leave it be
			-- until the neighbour emerges — the water there is uninterrupted, it is
			-- just not loaded — and re-check every tick (deliberately NOT cached as
			-- stable) so the join comes out seamless the moment the map catches up.
			for i = 1, 6 do
				local dir = neighbour_dirs[i]
				if get_node({x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}).name == "ignore" then
					return
				end
			end

			-- A puddle in the way is left alone here rather than being moved or
			-- swapped: it clears itself out of a full node's path from its own
			-- side, by merging into it (see shallow.lua).  Trading places with
			-- it instead just moves the obstruction around, and the two halves
			-- end up handing the same water back and forth forever.
			local check_pos = {x=pos.x, y=pos.y-1, z=pos.z}
			local check_node = get_node(check_pos)
			local check_node_name = check_node.name
			if check_node_name == flowing_liquid or check_node_name == "air" then
				-- Scan the full column: find the lowest free position in one pass.
				-- A 10-block fall costs 1 swap instead of 10 ABM calls.
				local try_y = check_pos.y - 1
				local col_n = get_node({x=pos.x, y=try_y, z=pos.z})
				while col_n.name == flowing_liquid or col_n.name == "air" do
					check_pos.y = try_y
					try_y = try_y - 1
					col_n = get_node({x=pos.x, y=try_y, z=pos.z})
				end
				set_node(pos, check_node)
				set_node(check_pos, node)
				-- (B) Invalidate neighbours of both endpoints on any move
				invalidate_around(pos)
				invalidate_around(check_pos)
				return
			end
			-- A source with none of its own kind anywhere around it is a stranded
			-- block, not part of a body of water.  Rather than let it wander off
			-- in a random direction as a full cube, settle it out into shallow
			-- water.  Nothing in an ocean, a lake or a river gets here, and
			-- neither does anything at their edges.
			if dynamic_liquid.shallow_variants[liquid] then
				local isolated = true
				for i = 1, 6 do
					local dir = neighbour_dirs[i]
					if get_node({x = pos.x + dir.x, y = pos.y + dir.y, z = pos.z + dir.z}).name == liquid then
						isolated = false
						break
					end
				end
				-- Only worth the wider look once the cheap one says yes.
				if isolated and has_liquid_nearby(pos, liquid) then
					isolated = false
				end
				if isolated and dynamic_liquid.settle_as_shallow(pos, liquid) then
					invalidate_around(pos)
					return
				end

				-- Even when it is NOT stranded, a source that is only the exposed top
				-- skin of water — one node deep on solid ground, with none of its own
				-- liquid directly above or below it — should thin out rather than crawl
				-- forward as a full cube.  This is the whole point of the mod: the
				-- leading edge of a spreading sheet breaks down into 1/8 puddles and
				-- runs out as thin as it can.  Deep water (a source above or below,
				-- i.e. an ocean column or the body of a lake) is deliberately left to
				-- slosh sideways as whole cubes by the loop below.  settle_as_shallow
				-- itself refuses when there is nowhere for a puddle to go, so contained
				-- water in a basin is never touched and never churns.
				--
				-- NB: the cell below MUST be non-liquid here.  A source riding on top
				-- of the sea (liquid below) is left as a full cube on purpose — routing
				-- it into the shallow system makes it merge DOWN into the body, which
				-- rounds to the ledger and is not visibly conserved.  Smoothing proud
				-- surface bumps has to be done by spreading them thin ACROSS the
				-- surface, never by dissolving them into the water underneath.
				--
				-- check_node_name is still the node directly below (the fall branch
				-- above returned if it was air/flowing, and the isolated scan did not
				-- touch it), so no extra read is needed for the cell beneath.
				local above_name = get_node({x=pos.x, y=pos.y+1, z=pos.z}).name
				if check_node_name ~= liquid and above_name ~= liquid
						and dynamic_liquid.settle_as_shallow(pos, liquid) then
					invalidate_around(pos)
					return
				end
			end

			local perm = all_direction_permutations[math.random(24)]
			local dirs -- declare outside of loop so it won't keep entering/exiting scope
			for i=1,4 do
				dirs = perm[i]
				-- reuse check_pos to avoid allocating a new table
				check_pos.x = pos.x + dirs.x
				check_pos.y = pos.y
				check_pos.z = pos.z + dirs.z
				check_node = get_node(check_pos)
				check_node_name = check_node.name
				if check_node_name == flowing_liquid or check_node_name == "air" then
					set_node(pos, check_node)
					set_node(check_pos, node)
					-- (B) Invalidate neighbours of both endpoints on any move
					invalidate_around(pos)
					invalidate_around(check_pos)
					return
				end
			end
			-- (C) No move found: mark stable
			stable[h] = minetest.get_gametime()
		end
	})
	dynamic_liquid.registered_liquids[liquid] = flowing_liquid
	table.insert(dynamic_liquid.registered_liquid_neighbors, liquid)
end


if dynamic_liquid.config.displace_liquid then

	local cardinal_dirs = {
		{x= 0, y=0,  z= 1},
		{x= 1, y=0,  z= 0},
		{x= 0, y=0,  z=-1},
		{x=-1, y=0,  z= 0},
		{x= 0, y=-1, z= 0},
		{x= 0, y=1,  z= 0},
	}
	-- breadth-first search passing through liquid searching for air or flowing liquid.
	local flood_search_outlet = function(start_pos, source, flowing)
		local start_node =  minetest.get_node(start_pos)
		local start_node_name = start_node.name
		if start_node_name == "air" or start_node_name == flowing then
			return start_pos
		end

		local visited = {}
		visited[minetest.hash_node_position(start_pos)] = true
		local queue = {start_pos}
		local queue_pointer = 1

		while #queue >= queue_pointer do
			local current_pos = queue[queue_pointer]
			queue_pointer = queue_pointer + 1
			for _, cardinal_dir in ipairs(cardinal_dirs) do
				local new_pos = vector.add(current_pos, cardinal_dir)
				local new_hash = minetest.hash_node_position(new_pos)
				if visited[new_hash] == nil then
					local new_node = minetest.get_node(new_pos)
					local new_node_name = new_node.name
					if new_node_name == "air" or new_node_name == flowing then
						return new_pos
					end
					visited[new_hash] = true
					if new_node_name == source then
						table.insert(queue, new_pos)
					end
				end
			end
		end
		return nil
	end

	-- Conserve liquids, when placing nodes in liquids try to find a place to displace the liquid to.
	minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
		local flowing = dynamic_liquid.registered_liquids[oldnode.name]
		if flowing ~= nil then
			local dest = flood_search_outlet(pos, oldnode.name, flowing)
			if dest ~= nil then
				minetest.swap_node(dest, oldnode)
			end
		end
	end)

end
