-- Shared helpers: node classification, terrain probing, wind sampling,
-- and the registry of live funnels.

local S = tornado.settings

tornado.funnels = {}       -- live funnel luaentities, pruned as they die
tornado.debris_count = 0   -- live debris entities, capped by tornado_max_debris

-- Nodes that are never lifted, whatever the storm does.
-- Mods can add their own with tornado.add_immune() or the tornado_immune group.
tornado.immune = {
	["air"] = true,
	["ignore"] = true,
}

function tornado.add_immune(name)
	tornado.immune[name] = true
end

-- How hard a node is to tear loose. The funnel's force is at most 1.0 and falls
-- off towards the edge, so anything at or above 1.0 here effectively never
-- moves. Stone sits right on that line deliberately: it is what stops a funnel
-- from digging a trench across the world, and it is why a stone-walled shelter
-- is actually a shelter.
local GROUP_RESIST = {
	dig_immediate           = 0.12,
	snappy                  = 0.18,   -- leaves, grass, crops
	oddly_breakable_by_hand = 0.22,   -- glass, torches, clutter
	crumbly                 = 0.42,   -- dirt, sand, gravel
	choppy                  = 0.55,   -- wood, planks
	cracky                  = 1.05,   -- stone, ore, metal
}

-- Groups that veto lifting outright.
local HARD_VETO = { immortal = true, unbreakable = true, tornado_immune = true }

local function node_resist(def)
	local groups = def.groups or {}
	local best
	for group, base in pairs(GROUP_RESIST) do
		local rating = groups[group]
		if rating then
			-- higher group rating means softer, so only the harder-than-usual
			-- end is worth correcting for; digger level is a hard multiplier
			local resist = base
				* (1 + 0.25 * math.max(3 - rating, 0))
				* (1 + 0.6 * (groups.level or 0))
			if best == nil or resist < best then best = resist end
		end
	end
	-- unclassified nodes are treated as awkward but possible
	return best or 0.9
end

-- Would `force` (0..1, strongest at the funnel's axis) tear this node loose?
function tornado.can_lift(pos, node, force)
	if not S.griefing then return false end

	local name = node.name
	if tornado.immune[name] then return false end

	local def = minetest.registered_nodes[name]
	if not def then return false end
	if def.diggable == false then return false end
	if def.drawtype == "airlike" then return false end
	if def.liquidtype and def.liquidtype ~= "none" then return false end

	local groups = def.groups or {}
	for group in pairs(HARD_VETO) do
		if groups[group] then return false end
	end

	-- Chests, furnaces, machines and anything with a formspec stay put. Their
	-- contents are the player's, and a tornado that eats an inventory reads as
	-- a bug however well it is explained.
	if groups.container
		or def.on_metadata_inventory_put
		or def.on_metadata_inventory_take
		or def.on_receive_fields then
		return false
	end

	if node_resist(def) > force then return false end

	if S.respect_protection and minetest.is_protected(pos, "") then return false end

	return true
end

-- Topmost solid (or liquid) node in a column, searching around `around_y`.
-- Returns nil when the column is not loaded, which callers treat as "hold
-- position" rather than "there is nothing here".
-- `up`/`down` widen the search; the default window is deliberately tight
-- because this runs several times a second while a funnel is moving.
function tornado.ground_y(x, z, around_y, up, down)
	local pos = { x = math.floor(x + 0.5), y = 0, z = math.floor(z + 0.5) }
	local top = math.floor(around_y + (up or 12))
	local bottom = math.floor(around_y - (down or 24))
	for y = top, bottom, -1 do
		pos.y = y
		local node = minetest.get_node_or_nil(pos)
		if node == nil then return nil end
		if node.name ~= "ignore" then
			local def = minetest.registered_nodes[node.name]
			if def and (def.walkable or (def.liquidtype and def.liquidtype ~= "none")) then
				return y
			end
		end
	end
	return nil
end

-- The shared wind field, in the same terms every other weather-aware mod in
-- this game reads it: climate_api first, sum_air_currents as the fallback.
function tornado.wind(pos)
	if minetest.global_exists("climate_api") and climate_api.environment then
		local ok, wind = pcall(climate_api.environment.get_wind, pos)
		if ok and type(wind) == "table" and wind.x then
			return vector.new(wind.x, 0, wind.z)
		end
	end
	if minetest.global_exists("sum_air_currents") and sum_air_currents.wind then
		local wind = sum_air_currents.wind
		return vector.new(wind.x, 0, wind.z)
	end
	return vector.new(0, 0, 0)
end

local atan2 = math.atan2 or math.atan
local COMPASS = {
	"north", "north-east", "east", "south-east",
	"south", "south-west", "west", "north-west"
}

-- Compass name of a direction vector. +z is north, +x is east.
function tornado.compass(dir)
	if not dir or (dir.x == 0 and dir.z == 0) then return "nowhere" end
	local yaw = atan2(dir.x, dir.z) % (2 * math.pi)
	local index = math.floor(yaw / (2 * math.pi) * 8 + 0.5) % 8
	return COMPASS[index + 1]
end

function tornado.players_near(pos, radius)
	local found = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos and vector.distance(ppos, pos) <= radius then
			found[#found + 1] = player
		end
	end
	return found
end

-- Live funnels, pruned of the ones that have died since the last call.
function tornado.get_funnels()
	local alive = {}
	for _, ent in ipairs(tornado.funnels) do
		if ent.object and ent.object:get_pos() then
			alive[#alive + 1] = ent
		end
	end
	tornado.funnels = alive
	return alive
end

-- Distance to the nearest funnel and the funnel itself, or nil when there is
-- none. Used by the weather presets and the alert messages.
function tornado.nearest_funnel(pos)
	local best, best_dist
	for _, ent in ipairs(tornado.get_funnels()) do
		local fpos = ent.object:get_pos()
		local dist = vector.distance(pos, fpos)
		if not best_dist or dist < best_dist then
			best, best_dist = ent, dist
		end
	end
	return best, best_dist
end

-- Drop a funnel at `pos`. `opts.peak` scales its strength (0..1), `opts.lifetime`
-- its duration. Returns the luaentity, or nil if the position is unloaded.
function tornado.spawn(pos, opts)
	opts = opts or {}

	-- A touchdown point is picked from somewhere else on the map, so the ground
	-- under it can be a long way from the height that was asked for. Search
	-- wide, once.
	local ground = tornado.ground_y(pos.x, pos.z, pos.y, 90, 140)
	if ground then pos = { x = pos.x, y = ground + 1, z = pos.z } end

	local obj = minetest.add_entity(pos, "tornado:funnel")
	if not obj then return nil end

	local ent = obj:get_luaentity()
	if not ent then return nil end

	ent.peak = opts.peak or (0.55 + math.random() * 0.45)
	ent.lifetime = opts.lifetime or (S.lifetime * (0.7 + math.random() * 0.6))

	minetest.log("action", string.format(
		"[tornado] funnel touched down at %s (strength %.2f, lifetime %ds)",
		minetest.pos_to_string(vector.round(pos)), ent.peak, math.floor(ent.lifetime)))

	return ent
end

-- Remove every live funnel. Debris already in the air falls where it is.
function tornado.clear()
	local count = 0
	for _, ent in ipairs(tornado.get_funnels()) do
		ent:dissipate(true)
		count = count + 1
	end
	tornado.funnels = {}
	return count
end
