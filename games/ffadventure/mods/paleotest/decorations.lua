-- paleotest/decorations.lua
-- Prehistoric plant placement using the same technique as elysflowers:
-- per-column heatmap/humiditymap/heightmap from get_mapgen_object().
-- No biome names, no ground-node whitelists — pure climate filtering.

local path = minetest.get_modpath("paleotest")

local plant_defs = {
	-- Cycads: Triassic-Cretaceous subtropical/tropical.
	-- Need warmth and reliable moisture.
	{
		node      = "paleotest:cycad_3",
		heat_min  = 55, heat_max = 100,
		hum_min   = 50, hum_max  = 100,
		step      = 16,   -- sample every 16 nodes (sparse)
		chance    = 25,   -- 1-in-25 candidate cells placed
		y_min     = 1,    y_max = 220,
	},
	-- Horsetails: ancient, extremely wide heat tolerance, need high humidity.
	{
		node      = "paleotest:horsetail_3",
		heat_min  = 20, heat_max = 90,
		hum_min   = 65, hum_max  = 100,
		step      = 8,
		chance    = 18,
		y_min     = 1,    y_max = 150,
	},
	-- Metasequoia: temperate-to-subtropical deciduous conifer, moist valleys.
	{
		node      = "paleotest:metasequoia_sapling",
		heat_min  = 35, heat_max = 75,
		hum_min   = 50, hum_max  = 90,
		step      = 16,
		chance    = 50,
		y_min     = 1,    y_max = 220,
	},
}

-- Lookup tables built once after all mods load.
local plants         = {}   -- compiled specs with content IDs
local plantable_cids = {}   -- soil-group content IDs
local c_air

minetest.register_on_mods_loaded(function()
	c_air = minetest.CONTENT_AIR

	for name, def in pairs(minetest.registered_nodes) do
		if (def.groups.soil or 0) > 0 then
			plantable_cids[minetest.get_content_id(name)] = true
		end
	end

	for _, d in ipairs(plant_defs) do
		if minetest.registered_nodes[d.node] then
			plants[#plants + 1] = {
				cid      = minetest.get_content_id(d.node),
				heat_min = d.heat_min, heat_max = d.heat_max,
				hum_min  = d.hum_min,  hum_max  = d.hum_max,
				step     = d.step,
				chance   = d.chance,
				y_min    = d.y_min,    y_max    = d.y_max,
			}
		end
	end
end)

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 1 or #plants == 0 then return end

	local heatmap     = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local heightmap   = minetest.get_mapgen_object("heightmap")
	if not (heatmap and humiditymap and heightmap) then return end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area  = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data  = vm:get_data()

	local w  = maxp.x - minp.x + 1   -- chunk width  (X)
	local pr = PseudoRandom(seed + 5513)

	for _, p in ipairs(plants) do
		local step = p.step
		-- Jitter starting offsets to break grid patterns.
		local ox = pr:next(0, step - 1)
		local oz = pr:next(0, step - 1)

		for dz = oz, (maxp.z - minp.z), step do
			for dx = ox, (maxp.x - minp.x), step do
				local idx   = dz * w + dx + 1
				local heat  = heatmap[idx]
				local humid = humiditymap[idx]

				if heat and humid
				and heat  >= p.heat_min and heat  <= p.heat_max
				and humid >= p.hum_min  and humid <= p.hum_max then

					local y = heightmap[idx]
					if y and y >= p.y_min and y <= p.y_max then
						local px = minp.x + dx
						local pz = minp.z + dz

						local below_vi = area:index(px, y,     pz)
						local above_vi = area:index(px, y + 1, pz)

						if plantable_cids[data[below_vi]]
						and data[above_vi] == c_air
						and pr:next(1, p.chance) == 1 then
							data[above_vi] = p.cid
						end
					end
				end
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()

	-- Place occasional pre-grown metasequoia trees via schematic.
	-- Sampled at chunk centre is fine here since we just need a rough
	-- climate check before committing to an expensive schematic write.
	local cx  = math.floor((minp.x + maxp.x) / 2)
	local cz  = math.floor((minp.z + maxp.z) / 2)
	local idx0 = math.floor((cz - minp.z)) * w + math.floor((cx - minp.x)) + 1
	local ch   = heatmap[idx0]
	local cu   = humiditymap[idx0]

	if ch and cu and ch >= 35 and ch <= 75 and cu >= 50 and cu <= 90 then
		local schematic = path .. "/schems/paleotest_metasequoia.mts"
		local pr2 = PseudoRandom(seed + 1177)
		for _ = 1, 2 do
			if pr2:next(1, 250) == 1 then
				local tx = minp.x + pr2:next(8, maxp.x - minp.x - 8)
				local tz = minp.z + pr2:next(8, maxp.z - minp.z - 8)
				local surf = minetest.find_node_near(
					{x = tx, y = math.min(maxp.y, 200), z = tz},
					200, {"group:soil"}, true)
				if surf then
					minetest.place_schematic(
						{x = surf.x - 7, y = surf.y, z = surf.z - 7},
						schematic, "random", nil, false)
				end
			end
		end
	end
end)
