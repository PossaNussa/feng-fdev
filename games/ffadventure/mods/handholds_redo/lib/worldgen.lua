-- Natural handholds during world generation.
--
-- The rule is simply: any air node with climbable rock beside it has CHANCE
-- percent of becoming a handhold. Every node rolls on its own.
--
-- Nothing is grouped into faces, runs or columns. Every attempt to qualify rock
-- by the uninterrupted run in its own column came out as vertical stripes, and
-- for a structural reason: a column is a line, exposed rock is a surface. On
-- anything but a perfectly sheer cliff, no single column has a long run, so
-- whole columns were excluded at once while the rare steep one was carved top to
-- bottom. Per-node rolling is the only thing that scatters holds across rock.

local enabled = core.settings:get_bool("handholds_worldgen", true)

local function setting(name, default)
	local value = tonumber(core.settings:get("handholds_worldgen_" .. name))
	if value == nil or value <= 0 then return default end
	return value
end

-- Percent of exposed rock that ends up carved.
local CHANCE = setting("chance", 30)

local c_air, c_holds
local is_wall
local initialized = false

local function init()
	initialized = true
	c_air = core.get_content_id("air")
	c_holds = core.get_content_id("handholds_redo:holds")

	is_wall = {}
	local count = 0
	for name, def in pairs(core.registered_nodes) do
		if def.groups and (def.groups.handholds or 0) > 0
				and def.walkable ~= false
				and not def.buildable_to
				and (def.drawtype == nil or def.drawtype == "normal"
					or def.drawtype == "glasslike") then -- ice cliffs count too
			is_wall[core.get_content_id(name)] = true
			count = count + 1
		end
	end
	core.log("action", "[Handholds Redo] worldgen active, "
		.. count .. " climbable wall materials")
end

core.register_on_generated(function(minp, maxp, blockseed)
	if not enabled then return end
	if not initialized then init() end

	local vm, emin, emax = core.get_mapgen_object("voxelmanip")
	if vm == nil then return end

	local va = VoxelArea:new({ MinEdge = emin, MaxEdge = emax })
	local data = vm:get_data()
	local param2 = vm:get_param2_data()
	local ystride = va.ystride

	-- param2 is the wallmounted direction pointing from the handhold at the wall
	local sides = {
		{ off =  1,          param2 = 2 }, -- wall to the east
		{ off = -1,          param2 = 3 }, -- wall to the west
		{ off =  va.zstride, param2 = 4 }, -- wall to the north
		{ off = -va.zstride, param2 = 5 }, -- wall to the south
	}

	local pr = PcgRandom(blockseed + 1723)
	local placed = 0

	for z = minp.z, maxp.z do
	for x = minp.x, maxp.x do
		local vi = va:index(x, minp.y, z)
		for _ = minp.y, maxp.y do
			-- Roll before looking around. The outcome is identical either way,
			-- and most air in a mapchunk is open sky with no rock near it, so
			-- this skips the neighbour lookups for the large majority of nodes.
			if data[vi] == c_air and pr:next(1, 100) <= CHANCE then
				-- Start on a random side, so a node touching rock on two sides
				-- does not always mount to the same one.
				local first = pr:next(1, 4)
				for k = 0, 3 do
					local s = sides[(first + k - 1) % 4 + 1]
					if is_wall[data[vi + s.off]] then
						data[vi] = c_holds
						param2[vi] = s.param2
						placed = placed + 1
						break
					end
				end
			end
			vi = vi + ystride
		end
	end
	end

	if placed > 0 then
		vm:set_data(data)
		vm:set_param2_data(param2)
		vm:write_to_map(false)
	end
end)
