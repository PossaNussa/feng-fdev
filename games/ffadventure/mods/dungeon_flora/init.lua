-- See README.txt for licensing.

-- Only dungeons are actually used here.
minetest.set_gen_notify({ dungeon = true })

minetest.register_on_generated(function(minp, maxp, blockseed)
	-- Get dungeon anchors for this mapchunk.
	local gennotify = minetest.get_mapgen_object("gennotify")
	if not gennotify then return end
	local poslist = gennotify.dungeon or {}
	if #poslist == 0 then return end

	-- VoxelManip for bulk reads/writes
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({ MinEdge = emin, MaxEdge = emax })

	-- Content IDs (resolve once)
	local c_air           = minetest.get_content_id("air")
	local c_ignore        = minetest.get_content_id("ignore")
	local c_cobble        = minetest.get_content_id("default:cobble")
	local c_mossycobble   = minetest.get_content_id("default:mossycobble")
	local c_firefly       = minetest.get_content_id("fireflies:firefly")

	local c_grass = {
		minetest.get_content_id("default:grass_1"),
		minetest.get_content_id("default:grass_2"),
		minetest.get_content_id("default:grass_3"),
		minetest.get_content_id("default:grass_4"),
		minetest.get_content_id("default:grass_5"),
	}

	local c_mushroom_brown = minetest.get_content_id("flowers:mushroom_brown")
	local c_mushroom_red   = minetest.get_content_id("flowers:mushroom_red")

	-- Deterministic RNG per mapblock
	local pr = PseudoRandom(blockseed)

	-- Helpers on content IDs
	local function is_wall_cid(cid)
		return cid ~= c_air and cid ~= c_ignore
	end

	local function flora_cid(below_cid)
		-- If below is cobble/mossy, sometimes place mushrooms; else grass.
		if below_cid == c_cobble or below_cid == c_mossycobble then
			local r = pr:next(1, 8)
			if r < 5 then
				return c_grass[pr:next(1, 5)]
			elseif r == 6 then
				return c_mushroom_brown
			elseif r == 7 then
				return c_mushroom_red
			else
				return c_grass[pr:next(1, 5)]
			end
		else
			return c_grass[pr:next(1, 5)]
		end
	end

	-- Iterate a square (18x18) around each dungeon anchor, as in original
	for i = 1, #poslist do
		local anchor = poslist[i]
		-- y-layer indices we’ll touch
		local y_floor   = anchor.y     -- bpos y=0 layer
		local y_below   = anchor.y - 1 -- upos y=-1 (below)
		local y_above   = anchor.y + 1 -- fpos y=+1 (above)

		for k = 1, 18 do
			local dx = k - 9
			for j = 1, 18 do
				local dz = j - 9

				local x = anchor.x + dx
				local z = anchor.z + dz

				-- floor cell where we might place flora
				local idx_floor = area:index(x, y_floor, z)
				local cid_floor = data[idx_floor]

				if not is_wall_cid(cid_floor) then
					-- node below must be a wall to support flora
					local idx_below = area:index(x, y_below, z)
					local cid_below = data[idx_below]
					if is_wall_cid(cid_below) and pr:next(1, 3) == 2 then
						data[idx_floor] = flora_cid(cid_below)
					end
				end

				-- firefly one node above floor (only into air, 1/30 chance)
				local idx_above = area:index(x, y_above, z)
				if data[idx_above] == c_air and pr:next(1, 30) == 10 then
					data[idx_above] = c_firefly
				end
			end
		end
	end

	-- Commit changes. Lighting/liquids are usually fine to skip here.
	vm:set_data(data)
	vm:write_to_map(false)
end)

