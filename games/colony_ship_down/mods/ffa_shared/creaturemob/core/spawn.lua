-- creaturemob :: core/spawn.lua
--
-- Spawn predicates shared by both front-ends: clearance, light, height, time of
-- day, biome, heat and humidity.
--
-- The two APIs register spawns very differently (Mobs Redo builds an ABM or LBM
-- per mob; creatura groups spawns and caps them per active block range), so the
-- registration side stays with each front-end. What is unified here is every
-- question they both had to answer, which is where they had drifted apart -- the
-- climate filters in particular only existed on the Mobs Redo side.

local spawn = {}

local floor, ceil, max = math.floor, math.ceil, math.max

local DEFAULT_COLBOX = {-0.5, 0, -0.5, 0.5, 1, 0.5}

----------------------------------------------------------------------
-- Clearance
----------------------------------------------------------------------

-- Mobs Redo stamps `base_colbox` onto every def it registers, and its spawner
-- read only that -- so asking it to spawn an entity registered by any other API
-- silently did nothing. Fall back through the ordinary entity definition so
-- foreign entities (mobkit, mob_core, plain core.register_entity) work too.

function spawn.resolve_colbox(name)

	local ent = core.registered_entities[name] ; if not ent then return end

	return ent.base_colbox
			or ent.collisionbox
			or (ent.initial_properties and ent.initial_properties.collisionbox)
			or DEFAULT_COLBOX
end

-- ffadventure fork: whether a spawn node is a liquid. Both front-ends lift a
-- newly spawned mob one node above the node it was detected on, to clear it of
-- the soil it was standing in. For a spawn triggered *on* a liquid that bump
-- strands the mob in the air above the water -- where the swimmer air-damage
-- rule now (correctly) drowns fish on the spot. Callers use this to keep an
-- aquatic spawn submerged; genuine floaters are lifted back to the surface by
-- their own buoyancy.

function spawn.is_liquid_node(name)

	local def = core.registered_nodes[name]

	return def ~= nil and def.groups ~= nil and (def.groups.liquid or 0) > 0
end

local function get_range(width)

	if width % 2 == 0 then -- even widths are slightly offset
		local max_offset = width / 2
		return -max_offset + 1, max_offset
	end

	local max_offset = floor(width / 2)

	return -max_offset, max_offset
end

-- Returns the (possibly re-centred) spawn position, or nil when blocked.

function spawn.has_room(pos, name)

	local box = spawn.resolve_colbox(name) ; if not box then return end

	local width_x = max(1, ceil(box[4] - box[1]))
	local width_z = max(1, ceil(box[6] - box[3]))
	local height = max(0, ceil(box[5] - box[2]) - 1)

	local min_x, max_x = get_range(width_x)
	local min_z, max_z = get_range(width_z)

	for y = 0, height do
		for x = min_x, max_x do
			for z = min_z, max_z do

				local node = core.get_node_or_nil(
						{x = pos.x + x, y = pos.y + y, z = pos.z + z})
				local def = node and core.registered_nodes[node.name]

				if not def or def.walkable then return end -- blocked or unloaded
			end
		end
	end

	local pos2 = {x = pos.x, y = pos.y, z = pos.z}

	if width_x % 2 == 0 then pos2.x = pos2.x + 0.5 end -- centre even sized mobs
	if width_z % 2 == 0 then pos2.z = pos2.z + 0.5 end

	return pos2
end

----------------------------------------------------------------------
-- Environmental filters
----------------------------------------------------------------------

function spawn.check_light(pos, min_light, max_light)

	local light = core.get_node_light(pos)

	if not light then return false end
	if min_light and light < min_light then return false end
	if max_light and light > max_light then return false end

	return true
end

function spawn.check_height(pos, min_height, max_height)

	if min_height and pos.y < min_height then return false end
	if max_height and pos.y > max_height then return false end

	return true
end

-- Handles wrapping windows, e.g. min 19500 / max 4500 meaning "at night".

function spawn.check_time(min_time, max_time)

	if not min_time and not max_time then return true end

	local tod = (core.get_timeofday() or 0) * 24000

	min_time = min_time or 0
	max_time = max_time or 24000

	if min_time <= max_time then
		return tod >= min_time and tod <= max_time
	end

	return tod >= min_time or tod <= max_time
end

-- Biome list, prehashed by prepare_biomes() so this stays O(1) inside an ABM.

function spawn.check_biome(pos, biome_set)

	if not biome_set then return true end

	local data = core.get_biome_data(pos) ; if not data then return false end

	return biome_set[core.get_biome_name(data.biome)] == true
end

function spawn.prepare_biomes(biomes)

	if not biomes or #biomes == 0 then return nil end

	local set = {}

	for i = 1, #biomes do set[biomes[i]] = true end

	return set
end

function spawn.check_climate(pos, min_heat, max_heat, min_humidity, max_humidity)

	if min_heat or max_heat then

		local heat = core.get_heat(pos)

		if not heat then return false end
		if min_heat and heat < min_heat then return false end
		if max_heat and heat > max_heat then return false end
	end

	if min_humidity or max_humidity then

		local humidity = core.get_humidity(pos)

		if not humidity then return false end
		if min_humidity and humidity < min_humidity then return false end
		if max_humidity and humidity > max_humidity then return false end
	end

	return true
end

----------------------------------------------------------------------
-- Population
----------------------------------------------------------------------

-- Returns how many of `name` are within `radius`, and whether any player is.

function spawn.count_mobs(pos, name, radius)

	local objs = core.get_objects_inside_radius(pos, radius)
	local total, players = 0, false

	for i = 1, #objs do

		local obj = objs[i]

		if obj:is_player() then
			players = true
		else
			local ent = obj:get_luaentity()

			if ent and ent.name == name then total = total + 1 end
		end
	end

	return total, players
end

return spawn
