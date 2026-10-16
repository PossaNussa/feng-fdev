-- creaturemob :: core/world.lua
--
-- Node and neighbourhood queries shared by the pathfinder, the spawner and both
-- front-ends. Ported from creatura's api.lua, with two upstream bugs fixed --
-- see get_node_def() and is_pos_moveable() below.

local world = {}

local floor = math.floor
local vec_dist = vector.distance

local get_node = core.get_node
local get_node_or_nil = core.get_node_or_nil
local registered_nodes = core.registered_nodes

-- Both `ignore` and unknown nodes count as solid.
local default_node_def = {walkable = true, drawtype = "normal"}

local function vec_raise(v, n)
	if not v then return end
	return {x = v.x, y = v.y + n, z = v.z}
end

local function contains_val(tbl, val)
	for _, v in pairs(tbl) do
		if v == val then return true end
	end
	return false
end

----------------------------------------------------------------------
-- Node definitions
----------------------------------------------------------------------

function world.get_node_height_from_def(name)

	local def = registered_nodes[name] or default_node_def

	if not def.walkable then return 1 end

	if def.drawtype == "nodebox" and def.node_box
	and def.node_box.type == "fixed" then

		local fixed = def.node_box.fixed

		if type(fixed[1]) == "number" then
			return 0.5 + fixed[5]
		elseif type(fixed[1]) == "table" then
			return 0.5 + fixed[1][5]
		end
	end

	return 1
end

-- Very short walkable nodes (snow, moss, rugs) must not read as obstacles or
-- mobs refuse to walk over them.
--
-- Upstream creatura implemented that by assigning `def.walkable = false` on the
-- definition it had just fetched -- which is the live table out of
-- core.registered_nodes, so the first pathfinding query permanently marked
-- default:snow as non-walkable for *every mod in the game*. Worse, unknown nodes
-- fell through to a single shared default table, so one unknown node turned all
-- of them non-solid.
--
-- Here the override lives in a private memo table and the registry is never touched.

local shim_cache = {}

local function shimmed(name, def)

	local shim = shim_cache[name]

	if shim == nil then

		if def.walkable and world.get_node_height_from_def(name) < 0.26 then

			shim = {}

			for k, v in pairs(def) do shim[k] = v end

			shim.walkable = false
		else
			shim = false -- memoize "no override needed"
		end

		shim_cache[name] = shim
	end

	return shim or def
end

-- `node` may be a node name, a node table, or a position.

function world.get_node_def(node)

	if type(node) == "table" then
		node = (node.name or get_node(node).name)
	end

	return shimmed(node, registered_nodes[node] or default_node_def)
end

local get_node_def = world.get_node_def

----------------------------------------------------------------------
-- Climbable nodes
----------------------------------------------------------------------

-- Ladders and ropes are `climbable`: a mob standing in one can move straight up
-- or down through the cell, which is the one kind of vertical travel the ground
-- grid (capped at a one-node step-up) cannot express. `climbable` is a node
-- property, memoised by name the same way heights are.
local climbable_cache = {}

local function name_climbable(name)
	local c = climbable_cache[name]
	if c == nil then
		local def = registered_nodes[name]
		c = (def ~= nil and def.climbable == true) or false
		climbable_cache[name] = c
	end
	return c
end

world.name_climbable = name_climbable

function world.is_climbable(pos)
	local node = get_node_or_nil(pos)
	return node ~= nil and name_climbable(node.name)
end

-- Set true only for the duration of a climb-capable mob's pathing/snapping
-- query, by the navigate layer -- exactly like `door_pass` below. A mob without
-- the flag never has a ladder offered to it as a route, so nothing climbs that
-- was not meant to.
world.climb_pass = false

----------------------------------------------------------------------
-- Doors
----------------------------------------------------------------------

-- Doors (and any registered openable) are `walkable` in *every* state: opening
-- one swaps its mesh, not its collision flag. The pathfinder decides passability
-- from `walkable` alone, so an open door reads exactly like a wall and a mob can
-- never route through its own doorway -- the local-avoidance probe even steers
-- it away from the cell. A mob that can open doors should be able to plan and
-- walk through them (it opens the leaf before stepping in); a monster, which
-- cannot, correctly keeps seeing a door as a wall.
--
-- `world.openable` is the set of such node names, filled by whoever manages
-- doors (village_life). `world.door_pass` is set true only for the duration of a
-- door-capable mob's pathing/clearance query, by the navigate layer. Every one
-- of these calls is synchronous and single-threaded, so a plain module flag is
-- safe and needs no re-entrancy handling.
world.openable = {}
world.door_pass = false

-- Nodes a mob must not walk into even though they are not solid: fire, lava, and
-- anything else that hurts on contact. The pathfinder and the local-avoidance
-- probe both decide passability from `walkable`, and a flame or a lava surface is
-- `walkable = false` -- so without this a mob reads them as open air and strolls
-- in to burn. Treating them as blocked routes A* around them and steers the body
-- clear. Filled once at load, below.
world.hazard = {}

-- Would a body be blocked by this node? A hazard always blocks. Otherwise
-- walkable, unless it is an openable and the current query belongs to something
-- that can open it.
function world.move_blocked(name)
	if world.hazard[name] then return true end
	if world.door_pass and world.openable[name] then return false end
	return get_node_def(name).walkable
end

local move_blocked = world.move_blocked

-- Populate the hazard set from the node registry: any non-walkable node that
-- deals contact damage. A *walkable* damaging node (a cactus, a hot metal block)
-- is already an obstacle by its collision, and marking solid ground blocked would
-- wall mobs in -- so only the ones that would otherwise read as passable matter.
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_nodes) do
		if def.damage_per_second and def.damage_per_second > 0
				and not def.walkable then
			world.hazard[name] = true
		end
	end
	-- Named explicitly in case a game leaves the damage flag off the source or the
	-- flowing variant of lava.
	for _, n in ipairs({"default:lava_source", "default:lava_flowing",
			"fire:basic_flame", "fire:permanent_flame"}) do
		if minetest.registered_nodes[n] then world.hazard[n] = true end
	end
end)

----------------------------------------------------------------------
-- Geometry
----------------------------------------------------------------------

function world.get_ground_level(pos, range)

	range = range or 2

	local above = vector.round(pos)
	local under = {x = above.x, y = above.y - 1, z = above.z}

	if not get_node_def(above).walkable and get_node_def(under).walkable then
		return above
	end

	if get_node_def(above).walkable then

		for _ = 1, range do
			under = above
			above = {x = above.x, y = above.y + 1, z = above.z}

			if not get_node_def(above).walkable and get_node_def(under).walkable then
				return above
			end
		end
	end

	if not get_node_def(under).walkable then

		for _ = 1, range do
			above = under
			under = {x = under.x, y = under.y - 1, z = under.z}

			if not get_node_def(above).walkable and get_node_def(under).walkable then
				return above
			end
		end
	end

	return above
end

-- Can a box of `width` (half-extent) and `height` stand at `pos`?
--
-- Upstream wrote `base_p.x = pos.x + x` while `x` was already iterating over
-- absolute world coordinates from pos.x-width to pos.x+width -- so the scan
-- happened around 2*pos and the answer was unrelated to the position asked
-- about. Fixed to use the loop coordinates directly.

function world.is_pos_moveable(pos, width, height)

	local w = width + 0.2
	local base_p = {x = pos.x, y = pos.y, z = pos.z}
	local top_p = {x = pos.x, y = pos.y + height, z = pos.z}

	for z = pos.z - w, pos.z + w do
		for x = pos.x - w, pos.x + w do

			base_p.x, base_p.z = x, z
			top_p.x, top_p.z = x, z

			for pointed_thing in core.raycast(base_p, top_p, false, false) do
				if pointed_thing.type == "node"
				and get_node_def(get_node(pointed_thing.under).name).walkable then
					return false
				end
			end
		end
	end

	return true
end

local function is_blocked_thin(pos, height)

	local pos2 = {
		x = floor(pos.x + 0.5),
		y = floor(pos.y + 0.5) - 1,
		z = floor(pos.z + 0.5)
	}

	for _ = 1, height do

		pos2.y = pos2.y + 1

		local node = get_node_or_nil(pos2)

		if not node or move_blocked(node.name) then return true end
	end

	return false
end

function world.is_blocked(pos, width, height)

	if width <= 0.5 then return is_blocked_thin(pos, height) end

	local w, h = width + 0.2, height + 0.2
	local pos2 = {}

	for z = pos.z - w, pos.z + w do
		pos2.z = z
		for y = pos.y, pos.y + h do
			pos2.y = y
			for x = pos.x - w, pos.x + w do

				pos2.x = x

				local node = get_node_or_nil(pos2)

				if not node or move_blocked(node.name) then return true end
			end
		end
	end

	return false
end

----------------------------------------------------------------------
-- Line of sight
----------------------------------------------------------------------

-- Returns: clear, distance, blocking ObjectRef/false, intersection point

function world.fast_ray_sight(pos1, pos2, water)

	local ray = core.raycast(pos1, pos2, false, water or false)
	local pointed_thing = ray:next()

	while pointed_thing do

		if pointed_thing.type == "node"
		and get_node_def(pointed_thing.under).walkable then
			return false, vec_dist(pos1, pointed_thing.intersection_point),
					pointed_thing.ref, pointed_thing.intersection_point
		end

		pointed_thing = ray:next()
	end

	return true, vec_dist(pos1, pos2), false, pos2
end

local fast_ray_sight = world.fast_ray_sight

function world.sensor_floor(self, range, water)

	local pos = self.object:get_pos() ; if not pos then return range end

	local _, dist, node = fast_ray_sight(pos, vec_raise(pos, -range), water or false)

	return dist, node
end

function world.sensor_ceil(self, range, water)

	local pos = self.object:get_pos() ; if not pos then return range end

	pos = vec_raise(pos, self.height or 1)

	local _, dist, node = fast_ray_sight(pos, vec_raise(pos, range), water or false)

	return dist, node
end

----------------------------------------------------------------------
-- Nearby object lookups (read the mob's own cached scan)
----------------------------------------------------------------------

local function cached_objects(self, range)

	local stored = self._nearby_obj

	if stored and #stored > 0 then return stored end

	if self.store_nearby_objects then return self:store_nearby_objects(range) end

	return {}
end

function world.get_nearby_player(self, range)

	if not self.object:get_pos() then return end

	local objects = cached_objects(self, range)

	for i = 1, #objects do
		local object = objects[i]
		if object:is_player() and creaturemob.is_alive(object) then return object end
	end
end

function world.get_nearby_players(self, range)

	if not self.object:get_pos() then return end

	local objects = cached_objects(self, range)
	local nearby = {}

	for i = 1, #objects do
		local object = objects[i]
		if object:is_player() and creaturemob.is_alive(object) then
			nearby[#nearby + 1] = object
		end
	end

	return nearby
end

function world.get_nearby_object(self, name, range)

	if not self.object:get_pos() then return end

	local objects = cached_objects(self, range)

	for i = 1, #objects do

		local object = objects[i]
		local ent = creaturemob.is_alive(object) and object:get_luaentity()

		if ent and object ~= self.object and not ent._ignore
		and ((type(name) == "table" and contains_val(name, ent.name)) or ent.name == name) then
			return object
		end
	end
end

function world.get_nearby_objects(self, name, range)

	if not self.object:get_pos() then return end

	local objects = cached_objects(self, range)
	local nearby = {}

	for i = 1, #objects do

		local object = objects[i]
		local ent = creaturemob.is_alive(object) and object:get_luaentity()

		if ent and object ~= self.object and not ent._ignore
		and ((type(name) == "table" and contains_val(name, ent.name)) or ent.name == name) then
			nearby[#nearby + 1] = object
		end
	end

	return nearby
end

----------------------------------------------------------------------
-- Liveness, shared by both front-ends
----------------------------------------------------------------------

function creaturemob.is_valid(mob)

	if not mob then return false end

	if type(mob) == "table" then mob = mob.object end

	if type(mob) == "userdata" then
		if mob:is_player() then
			if mob:get_look_horizontal() then return mob end
		else
			if mob:get_yaw() then return mob end
		end
	end

	return false
end

function creaturemob.is_alive(mob)

	if not creaturemob.is_valid(mob) then return false end

	if type(mob) == "table" then return (mob.hp or mob.health or 0) > 0 end

	if mob:is_player() then return mob:get_hp() > 0 end

	local ent = mob:get_luaentity()

	return ent and (ent.hp or ent.health or 0) > 0
end

-- Node definitions can be overridden after load (override_item), so drop the
-- memo once everything has registered.
core.register_on_mods_loaded(function()
	shim_cache = {}
end)

return world
