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
		neighbors = {flowing_liquid},
		interval = 1,
		chance = chance or 1,
		y_max = disable_flow_above,
		catch_up = false,
		action = function(pos,node) -- Do everything possible to optimize this method
			-- (A) Early exit for known-stable sources
			local h = minetest.hash_node_position(pos)
			local t = stable[h]
			if t and (minetest.get_gametime() - t) < STABLE_TTL then return end

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
