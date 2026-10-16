-- sapling_autoplant/init.lua
--
-- Saplings never lie around as items: anything that would put a sapling item in
-- the world plants it instead. If the spot is taken by another sapling, the new
-- one shifts to the nearest free patch of ground.
--
-- Every source of ground drops funnels through core.add_item -- leaf decay,
-- attached-node detachment (builtin/game/falling.lua), digging with a full
-- inventory, mob drops, tree_felling/falling_item -- so that is the main place
-- this mod hooks, and no per-mod support tables are needed.
--
-- The one exception is a player breaking a sapling node: that sapling is theirs
-- and goes to their inventory. Thrown saplings do plant, but from the item
-- entity after it lands, because core.item_drop only clears the thrown stack
-- from the inventory once the entity exists.

sapling_autoplant = {}

local settings = core.settings

local function conf_bool(name, default)
	local v = settings:get_bool("sapling_autoplant_" .. name)
	if v == nil then
		return default
	end
	return v
end

local function conf_int(name, default, min, max)
	local v = tonumber(settings:get("sapling_autoplant_" .. name))
	if not v then
		return default
	end
	return math.max(min, math.min(max, math.floor(v)))
end

local ENABLED      = conf_bool("enable", true)
local RADIUS       = conf_int("radius", 5, 0, 16)
local SPACING      = conf_int("spacing", 2, 0, 8)
local MAX_FALL     = conf_int("max_fall", 24, 0, 64)
local RISE         = conf_int("rise", 2, 0, 8)
local STACK_LIMIT  = conf_int("stack_limit", 4, 1, 99)
local PLANT_THROWN = conf_bool("plant_thrown_items", true)
local KEEP_DUG     = conf_bool("keep_dug_saplings", true)
local PLACE_SOUND  = conf_bool("place_sound", true)
-- Long enough for a thrown sapling to land before it roots.
local THROW_DELAY  = 1.5

-- Ground a sapling is allowed to root in. Sand is in here for palms, cacti and
-- the desert trees; everything else wants group:soil.
local GROUND_GROUPS = {"soil", "sand"}

-- Nodes the search is allowed to fall through on its way down. Leaf decay hands
-- us a position up inside the canopy, with the decaying leaf itself still in
-- place, so trunks and leaves have to be transparent to the search.
local PASS_GROUPS = {"tree", "leaves", "leafdecay", "leaf_decay"}


--
-- What counts as a sapling
--

-- group:sapling on its own is not a safe test: a few mods tag ground cover with
-- it (awuuwa_biomes does for its grasses, flowers and vegetation), and those
-- must keep dropping as items. Requiring the name to look like a sapling too
-- keeps this list-free while excluding the mislabelled plants.
local NAME_HINTS = {"sapling", "seedling", "sprout", "shoot"}

local forced = {}
local cache = {}

-- Force a node to be treated as a sapling (true) or never (false); nil restores
-- automatic detection. For mods whose saplings are named something else.
function sapling_autoplant.set_sapling(name, is_sapling)
	forced[name] = is_sapling
	cache[name] = nil
end

function sapling_autoplant.is_sapling(name)
	local cached = cache[name]
	if cached ~= nil then
		return cached
	end

	local result = forced[name]
	if result == nil then
		result = false
		if core.registered_nodes[name] and core.get_item_group(name, "sapling") > 0 then
			local lower = name:lower()
			for i = 1, #NAME_HINTS do
				if lower:find(NAME_HINTS[i], 1, true) then
					result = true
					break
				end
			end
		end
	end

	cache[name] = result
	return result
end


--
-- Finding a spot
--

local function is_ground(name)
	local def = core.registered_nodes[name]
	if not def or not def.walkable then
		return false
	end
	for i = 1, #GROUND_GROUPS do
		if core.get_item_group(name, GROUND_GROUPS[i]) > 0 then
			return true
		end
	end
	return false
end

local function is_pass_through(name, def)
	if not def.walkable or def.buildable_to then
		return true
	end
	for i = 1, #PASS_GROUPS do
		if core.get_item_group(name, PASS_GROUPS[i]) > 0 then
			return true
		end
	end
	return false
end

-- Look straight down for the first ground the sapling could root in. Returns the
-- y of that ground, or nil if the column is water, unloaded, or roofed over by
-- something solid that is not part of a tree.
local function find_ground(x, z, y_top, y_bottom)
	local pos = {x = x, y = 0, z = z}
	for y = y_top, y_bottom, -1 do
		pos.y = y
		local name = core.get_node(pos).name
		local def = core.registered_nodes[name]
		if not def or name == "ignore" then
			return nil
		end
		if def.liquidtype and def.liquidtype ~= "none" then
			return nil
		end
		if is_ground(name) then
			return y
		end
		if not is_pass_through(name, def) then
			return nil
		end
	end
	return nil
end

local function is_plantable(pos)
	local def = core.registered_nodes[core.get_node(pos).name]
	return def and def.buildable_to
			and (not def.liquidtype or def.liquidtype == "none")
end

-- Candidate columns grouped into rings of equal distance, nearest ring first.
local rings = {}
do
	local by_dist = {}
	for dx = -RADIUS, RADIUS do
		for dz = -RADIUS, RADIUS do
			local d2 = dx * dx + dz * dz
			if d2 <= RADIUS * RADIUS then
				local ring = by_dist[d2]
				if not ring then
					ring = {d2 = d2, offsets = {}}
					by_dist[d2] = ring
					rings[#rings + 1] = ring
				end
				local offsets = ring.offsets
				offsets[#offsets + 1] = {dx, dz}
			end
		end
	end
	table.sort(rings, function(a, b) return a.d2 < b.d2 end)
end

if RADIUS <= SPACING then
	core.log("warning", "[sapling_autoplant] search radius " .. RADIUS ..
		" does not clear a spacing of " .. SPACING ..
		": saplings landing near an existing one will drop as items instead")
end


--
-- Planting
--

local function place_sapling(pos, name)
	local def = core.registered_nodes[name]

	core.set_node(pos, {name = name})

	-- on_construct (which set_node runs) starts the growth timer for almost
	-- every sapling, but a handful of mods do it in after_place_node instead.
	-- There is no placer to hand them, so guard against the ones that assume
	-- there is.
	if def and def.after_place_node then
		local ok, err = pcall(def.after_place_node,
			{x = pos.x, y = pos.y, z = pos.z}, nil, ItemStack(name), nil)
		if not ok then
			core.log("info", "[sapling_autoplant] after_place_node of " ..
				name .. " skipped: " .. tostring(err))
		end
	end

	if PLACE_SOUND and def and def.sounds and def.sounds.place then
		core.sound_play(def.sounds.place,
			{pos = pos, gain = 0.5, max_hear_distance = 16}, true)
	end
end

-- Saplings already standing in the search volume, collected once per drop. One
-- find_nodes_in_area beats a find_node_near per candidate column, and it lets
-- the search look at every column instead of giving up early: with any useful
-- spacing the nearest rings are all blocked, so a try limit would only ever cut
-- off the rings that could still succeed.
local function neighbours(ox, oy, oz)
	local pad = SPACING
	return core.find_nodes_in_area(
		{x = ox - RADIUS - pad, y = oy - MAX_FALL - pad, z = oz - RADIUS - pad},
		{x = ox + RADIUS + pad, y = oy + RISE + 1 + pad,  z = oz + RADIUS + pad},
		"group:sapling") or {}
end

local function too_close(pos, others)
	for i = 1, #others do
		local o = others[i]
		if math.abs(o.x - pos.x) <= SPACING
				and math.abs(o.y - pos.y) <= SPACING
				and math.abs(o.z - pos.z) <= SPACING then
			return true
		end
	end
	return false
end

-- Plant one sapling at or near (ox, oy, oz). Returns the position it went in at.
local function plant_one(name, ox, oy, oz, others, ground)
	local y_top = oy + RISE
	local y_bottom = oy - MAX_FALL

	for r = 1, #rings do
		local offsets = rings[r].offsets
		-- Any column in a ring is equally close, so shuffle: a fixed scan order
		-- lines self-planted saplings up in rows.
		for i = #offsets, 2, -1 do
			local j = math.random(i)
			offsets[i], offsets[j] = offsets[j], offsets[i]
		end

		for i = 1, #offsets do
			local x, z = ox + offsets[i][1], oz + offsets[i][2]

			-- Ground height per column is reused across a stack.
			local ckey = x .. ":" .. z
			local gy = ground[ckey]
			if gy == nil then
				gy = find_ground(x, z, y_top, y_bottom) or false
				ground[ckey] = gy
			end

			if gy then
				local target = {x = x, y = gy + 1, z = z}
				-- too_close covers the target itself, so a sapling already
				-- standing there is what pushes this one aside.
				if not too_close(target, others)
						and is_plantable(target)
						and not core.is_protected(target, "") then
					place_sapling(target, name)
					return target
				end
			end
		end
	end

	return nil
end

-- Plant up to `count` saplings around pos. Each one shifts clear of the last
-- through the spacing check. Returns how many were planted.
function sapling_autoplant.plant(pos, name, count)
	local ox = math.floor(pos.x + 0.5)
	local oy = math.floor(pos.y + 0.5)
	local oz = math.floor(pos.z + 0.5)

	local others = neighbours(ox, oy, oz)
	local ground = {}
	local planted = 0

	for _ = 1, count or 1 do
		local at = plant_one(name, ox, oy, oz, others, ground)
		if not at then
			break
		end
		others[#others + 1] = at
		planted = planted + 1
	end

	return planted
end


--
-- The hook
--

if ENABLED then
	local add_item = core.add_item
	local busy = false      -- re-entrancy guard around our own set_node
	local suppressed = 0    -- inside a drop that must stay a pickable item

	-- Run fn with autoplanting switched off, e.g. around a drop the player is
	-- expected to walk over and collect.
	function sapling_autoplant.without_planting(fn, ...)
		suppressed = suppressed + 1
		local results = {pcall(fn, ...)}
		suppressed = suppressed - 1
		if not results[1] then
			error(results[2], 0)
		end
		return results[2], results[3], results[4]
	end

	core.add_item = function(pos, item)
		if busy or suppressed > 0 or not pos or not item then
			return add_item(pos, item)
		end

		local stack = ItemStack(item)
		local name = stack:get_name()
		local count = stack:get_count()
		if count < 1 or not sapling_autoplant.is_sapling(name) then
			return add_item(pos, item)
		end

		busy = true
		local ok, planted = pcall(sapling_autoplant.plant, pos, name,
			math.min(count, STACK_LIMIT))
		busy = false

		if not ok then
			core.log("error", "[sapling_autoplant] planting " .. name ..
				" failed: " .. tostring(planted))
			return add_item(pos, item)
		end

		if planted == 0 then
			-- Nowhere to root: let it drop as usual rather than lose it.
			return add_item(pos, item)
		end
		if planted >= count then
			return nil
		end

		stack:set_count(count - planted)
		return add_item(pos, stack)
	end

	-- A thrown sapling cannot be planted from inside core.add_item: item_drop
	-- only clears the thrown stack from the inventory `if obj then`, so
	-- returning nil would plant the sapling and leave a copy in the inventory.
	-- Let the entity spawn, then plant from it once it has landed.
	local function plant_from_entity(obj)
		local ent = obj and obj:get_luaentity()
		if not ent or not ent.itemstring or ent.itemstring == "" then
			return
		end

		local stack = ItemStack(ent.itemstring)
		local count = stack:get_count()
		if count < 1 or not sapling_autoplant.is_sapling(stack:get_name()) then
			return
		end

		busy = true
		local ok, planted = pcall(sapling_autoplant.plant, obj:get_pos(),
			stack:get_name(), math.min(count, STACK_LIMIT))
		busy = false

		if not ok then
			core.log("error", "[sapling_autoplant] planting " ..
				stack:get_name() .. " failed: " .. tostring(planted))
			return
		end
		if planted == 0 then
			-- Nowhere to root right now; leave it lying there.
			return
		end
		if planted >= count then
			obj:remove()
			return
		end

		-- Some of the stack went in; come back for the rest.
		stack:set_count(count - planted)
		if ent.set_item then
			ent:set_item(stack)
			core.after(THROW_DELAY, plant_from_entity, obj)
		end
	end

	-- Both wrappers go on at mods_loaded so they sit outside anyone else's
	-- override of the same function (itemextensions wraps core.item_drop there
	-- too, etcetera's anvil wraps core.node_dig at load time).
	core.register_on_mods_loaded(function()
		if PLANT_THROWN and core.item_drop then
			local item_drop = core.item_drop
			core.item_drop = function(itemstack, dropper, pos)
				local name = ItemStack(itemstack):get_name()
				local left, obj = sapling_autoplant.without_planting(
					item_drop, itemstack, dropper, pos)
				if obj and sapling_autoplant.is_sapling(name) then
					core.after(THROW_DELAY, plant_from_entity, obj)
				end
				return left, obj
			end
		elseif core.item_drop then
			local item_drop = core.item_drop
			core.item_drop = function(...)
				return sapling_autoplant.without_planting(item_drop, ...)
			end
		end

		if KEEP_DUG and core.node_dig then
			-- Breaking a sapling hands it to the player rather than putting it
			-- straight back in the ground. This is the one exception: a sapling
			-- from leaf decay, from a detached node, or from digging anything
			-- that is not itself a sapling still plants.
			local node_dig = core.node_dig
			core.node_dig = function(pos, node, digger, ...)
				if node and sapling_autoplant.is_sapling(node.name)
						and digger and digger.is_player and digger:is_player() then
					return sapling_autoplant.without_planting(
						node_dig, pos, node, digger, ...)
				end
				return node_dig(pos, node, digger, ...)
			end
		end
	end)
end
