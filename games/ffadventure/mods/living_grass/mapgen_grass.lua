--------------------------------------------------------------------------------
-- Tall grass at worldgen, placed directly rather than via register_decoration
--------------------------------------------------------------------------------
--
-- Two separate problems are being worked around here.
--
-- 1. The decoration pipeline is not delivering. Under climate_zones_v7 the
--    engine is told `nodecorations` and biomegen's place_all_decos is supposed
--    to place everything from Lua. In this game it places nothing: the only
--    plants that appear in a fresh world come from paleotest and elysflowers,
--    which are precisely the two mods that bypass register_decoration and write
--    nodes themselves. Until that is root-caused, anything registered as a
--    decoration is simply absent.
--
-- 2. Even with a working pipeline, default's grass decoration is bound to
--    place_on {default:dirt_with_grass, variety:japanese_dirt_with_grass} and
--    biomes {grassland, deciduous_forest, sakura_forest, grove}. This game has
--    ~100 biomes and ~30 dirt_with_grass variants, so most grassland would get
--    no grass regardless.
--
-- So this uses the same technique paleotest and elysflowers use, which is
-- demonstrably the one that works here: a main-env on_generated that reads the
-- mapgen heightmap and writes grass straight into the voxel manipulator.
--
-- Ground eligibility is the rule regrowth.lua already uses -- the node is in
-- `spreading_dirt_type` and its name contains "grass". That covers the variants
-- without hardcoding a table, keeps grass out of deserts, snow and forest
-- litter, and leaves always_greener:dirt_with_dead_grass alone (it deliberately
-- lacks the group).
--
-- Runs after climate_zones_v7's painter, which sits at
-- registered_on_generateds[1] -- so by the time this executes the biome top
-- nodes it looks for actually exist.

local S = {
	enabled = core.settings:get_bool("living_grass.mapgen_grass") ~= false,
	-- 1 in N eligible columns gets a sprout. Default's decoration summed to
	-- roughly a third of a grassland column at full noise; this is in that range
	-- without the noise machinery.
	chance = tonumber(core.settings:get("living_grass.mapgen_grass_chance")) or 4,
	y_min = tonumber(core.settings:get("living_grass.mapgen_grass_y_min")) or 1,
	y_max = tonumber(core.settings:get("living_grass.mapgen_grass_y_max")) or 31000,
}

if not S.enabled then return end

local ground_cids = {}
local grass_cids = {}
local c_air

core.register_on_mods_loaded(function()

	c_air = core.CONTENT_AIR

	for name, def in pairs(core.registered_nodes) do
		if def.groups and def.groups.spreading_dirt_type
		and name:find("grass") then
			ground_cids[core.get_content_id(name)] = true
		end
	end

	for i = 1, 5 do
		local name = "default:grass_" .. i
		if core.registered_nodes[name] then
			grass_cids[#grass_cids + 1] = core.get_content_id(name)
		end
	end

	local nground = 0
	for _ in pairs(ground_cids) do nground = nground + 1 end

	core.log("action", ("[living_grass] worldgen grass: %d ground node(s), %d sprout(s)")
		:format(nground, #grass_cids))
end)

core.register_on_generated(function(minp, maxp, seed)

	if #grass_cids == 0 or maxp.y < S.y_min then return end

	local heightmap = core.get_mapgen_object("heightmap")
	if not heightmap then return end

	local vm, emin, emax = core.get_mapgen_object("voxelmanip")
	if not vm then return end

	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	local w = maxp.x - minp.x + 1
	local pr = PseudoRandom(seed + 8681)
	local nplaced = 0

	for dz = 0, maxp.z - minp.z do
		for dx = 0, w - 1 do

			local y = heightmap[dz * w + dx + 1]

			if y and y >= S.y_min and y <= S.y_max
			and y >= emin.y and y + 1 <= emax.y then

				local px, pz = minp.x + dx, minp.z + dz
				local ground_vi = area:index(px, y, pz)
				local above_vi = area:index(px, y + 1, pz)

				if ground_cids[data[ground_vi]]
				and data[above_vi] == c_air
				and pr:next(1, S.chance) == 1 then
					data[above_vi] = grass_cids[pr:next(1, #grass_cids)]
					nplaced = nplaced + 1
				end
			end
		end
	end

	if nplaced > 0 then
		vm:set_data(data)
		vm:write_to_map()
	end
end)
