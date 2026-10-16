-- The other half of the lifecycle: grass has to come from somewhere.
--
-- Every system in this game that touches tall grass removes it. This mod dries
-- it and then kills it, regional_weather's snow_griefing ABM replaces flora
-- with a snow cover that later melts to air or a puddle, and players harvest
-- it. Only two things ever *create* a grass node, and neither can restart from
-- nothing:
--
--   * mapgen decorations, which run once when a chunk is generated and never
--     visit it again;
--   * flowers.flower_spread, which copies an existing flora node onto nearby
--     soil -- so it needs a surviving plant to copy.
--
-- The result is that one winter with snow on the ground leaves a world
-- permanently bare: every mapblock the player has loaded loses its grass, and
-- there is no seed stock left for flower_spread to work from when spring comes.
--
-- This file is the missing source. It seeds sparse single blades on bare
-- grassy ground during the growing season; flower_spread thickens each seed
-- into a patch, and the grow ABMs above raise the blades to full height.

local function get_bool(name, default)
	local v = minetest.settings:get_bool("living_grass_" .. name)
	if v == nil then return default end
	return v
end

local function get_number(name, default)
	return tonumber(minetest.settings:get("living_grass_" .. name)) or default
end

local S = {
	seeding  = get_bool("seeding", true),
	interval = math.max(1, get_number("seed_interval", 20)),
	chance   = math.max(1, get_number("seed_chance", 250)),
	spacing  = math.max(0, get_number("seed_spacing", 3)),
}

-- Same threshold flowers.flower_spread uses, so anywhere that can be seeded
-- can also spread.
local MIN_LIGHT = 13

--------------------------------------------------------------------------------
-- What grows on what
--------------------------------------------------------------------------------

-- Worked out from the ground node's own name rather than a hand-written table:
-- the biome mods in this game register some thirty variants of dirt_with_grass
-- between them (Variety, awuuwa_biomes, naturalbiomes, aotearoa,
-- livingfloatlands, biomes_island, ocular-networks ...) and they all follow the
-- same naming convention. Requiring "grass" in the name is also what keeps
-- seeding out of deserts, snowfields and forest litter without a biome lookup.
local sprout_cache = {}

local function sprout_for(ground)
	local plant = sprout_cache[ground]
	if plant ~= nil then return plant end

	plant = false
	if ground:find("grass", 1, true)
			and minetest.get_item_group(ground, "snowy") == 0 then
		local name = ground:find("dry", 1, true)
			and "default:dry_grass_1" or "default:grass_1"
		if minetest.registered_nodes[name] then
			plant = name
		end
	end

	sprout_cache[ground] = plant
	return plant
end

--------------------------------------------------------------------------------
-- When
--------------------------------------------------------------------------------

-- Grass staying gone through the winter is deliberate -- that is what the snow
-- burying it is for -- so seeding waits for the year to warm up. In the default
-- 360-day year this puts the growing season at roughly late March to early
-- November, so spring puts the grass back and winter takes it away again.
local GROWING_WARMTH = -0.35

local function growing_season()
	if not minetest.global_exists("seasons") then return true end
	if not (seasons.settings and seasons.settings.enabled) then return true end
	return seasons.get_warmth() > GROWING_WARMTH
end

--------------------------------------------------------------------------------
-- Where
--------------------------------------------------------------------------------

--- Can a sprout go in the air node at `above`, over ground node `ground`?
local function can_seed(above, ground)
	if minetest.get_node(above).name ~= "air" then return false end
	if (minetest.get_node_light(above) or 0) < MIN_LIGHT then return false end

	-- Keep seeds apart. flower_spread fills each patch in from here, up to its
	-- own cap of about 7 plants per 9x9, so seeding densely as well would
	-- carpet the world in a few minutes and bury the flowers.
	if S.spacing > 0
			and minetest.find_node_near(above, S.spacing, "group:flora") then
		return false
	end

	if minetest.is_protected(above, "") then return false end

	return sprout_for(ground)
end

--------------------------------------------------------------------------------
-- The seeding ABM
--------------------------------------------------------------------------------

if S.seeding then
	minetest.register_abm({
		label = "Grass seeding",
		-- The same node set default's own "Grass covered" ABM uses:
		-- dry_dirt_with_dry_grass is the one grassy ground node that is
		-- deliberately left out of the spreading_dirt_type group.
		nodenames = {"group:spreading_dirt_type", "default:dry_dirt_with_dry_grass"},
		neighbors = {"air"},
		interval = S.interval,
		chance = S.chance,
		catch_up = false,
		action = function(pos, node)
			if not growing_season() then return end
			-- Cheapest rejection first: most ground in a forest or a snowfield
			-- never sprouts anything and this is a cached table lookup.
			local plant = sprout_for(node.name)
			if not plant then return end

			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			if can_seed(above, node.name) then
				minetest.set_node(above, {name = plant})
			end
		end,
	})
end

--------------------------------------------------------------------------------
-- Admin repair
--------------------------------------------------------------------------------

-- The ABM only runs in mapblocks that are active, so a world that has already
-- been stripped bare recovers at walking pace. This reseeds an area at once.
local MAX_RADIUS = 64

minetest.register_chatcommand("regrow_grass", {
	params = "[radius]",
	description = "Seed grass on bare grassy ground around you (default 32, max "
		.. MAX_RADIUS .. ")",
	privs = {server = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then return false, "You are not online." end

		local radius = math.floor(tonumber(param) or 32)
		if radius < 1 then return false, "Radius must be at least 1." end
		if radius > MAX_RADIUS then radius = MAX_RADIUS end

		local pos = vector.round(player:get_pos())
		local ground = minetest.find_nodes_in_area_under_air(
			vector.subtract(pos, radius), vector.add(pos, radius),
			{"group:spreading_dirt_type", "default:dry_dirt_with_dry_grass"})

		local placed = 0
		for _, gp in ipairs(ground) do
			-- find_nodes_in_area returns scan order, so taking every position
			-- would lay the sprouts out on a regular lattice once the spacing
			-- check kicks in. Skipping at random breaks up the pattern.
			if math.random() < 0.5 then
				local above = {x = gp.x, y = gp.y + 1, z = gp.z}
				local plant = can_seed(above, minetest.get_node(gp).name)
				if plant then
					minetest.set_node(above, {name = plant})
					placed = placed + 1
				end
			end
		end

		return true, string.format(
			"Seeded %d patch%s of grass within %d nodes.",
			placed, placed == 1 and "" or "es", radius)
	end,
})
