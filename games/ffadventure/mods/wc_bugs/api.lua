-- wc_bugs: shared helpers
--
-- This replaces the handful of nodecore.* facilities the mod was built on:
-- smoke/snuff effects, the "is it in direct sunlight" test, and the aism
-- item-stack callbacks that let bugs crawl out of your pockets.

wc_bugs = {}

local S = minetest.get_translator("wc_bugs")
wc_bugs.S = S

local has_fire = minetest.get_modpath("fire") ~= nil

------------------------------------------------------------------------
-- effects
------------------------------------------------------------------------

function wc_bugs.smokeburst(pos, amount)
	minetest.add_particlespawner({
		amount = amount or 3,
		time = 0.6,
		minpos = vector.subtract(pos, 0.2),
		maxpos = vector.add(pos, 0.2),
		minvel = {x = -0.3, y = 0.3, z = -0.3},
		maxvel = {x = 0.3, y = 1.0, z = 0.3},
		minexptime = 0.6,
		maxexptime = 1.4,
		minsize = 1,
		maxsize = 3,
		texture = "default_item_smoke.png",
	})
end

-- A bug snuffs out: puff of smoke plus a hiss.
function wc_bugs.snuff(pos)
	wc_bugs.smokeburst(pos, 4)
	minetest.sound_play("fire_extinguish_flame",
		{pos = pos, gain = 0.15, max_hear_distance = 8}, true)
end

function wc_bugs.spark(pos)
	minetest.add_particlespawner({
		amount = 4,
		time = 0.4,
		minpos = vector.subtract(pos, 0.15),
		maxpos = vector.add(pos, 0.15),
		minvel = {x = -0.6, y = 0.2, z = -0.6},
		maxvel = {x = 0.6, y = 1.2, z = 0.6},
		minexptime = 0.3,
		maxexptime = 0.8,
		minsize = 0.6,
		maxsize = 1.4,
		-- Tinted smoke rather than the fire mod's flame: fire is optional.
		texture = "default_item_smoke.png^[colorize:#ff6000:220",
		glow = 14,
	})
	minetest.sound_play("fire_fire",
		{pos = pos, gain = 0.08, max_hear_distance = 8}, true)
end

-- Set a flame in an air node next to pos, if there is anything to burn.
function wc_bugs.ignite_near(pos)
	if not has_fire then return end
	if not minetest.find_node_near(pos, 1, {"group:flammable"}) then return end
	local air = minetest.find_nodes_in_area(vector.subtract(pos, 1),
		vector.add(pos, 1), {"air"})
	if #air == 0 then return end
	local p = air[math.random(#air)]
	minetest.set_node(p, {name = "fire:basic_flame"})
end

------------------------------------------------------------------------
-- environment queries
------------------------------------------------------------------------

-- Direct, undiminished sunlight. Node light sources cap out at 14, so a
-- reading of 15 can only come from the sky.
function wc_bugs.is_full_sun(pos)
	return (minetest.get_node_light(pos) or 0) >= 15
end

function wc_bugs.is_quenched(pos)
	return minetest.find_node_near(pos, 1, {"group:water"}) ~= nil
end

------------------------------------------------------------------------
-- bugs escaping from inventories and from the ground
------------------------------------------------------------------------

local escapes = {}

-- def = {
--   chance = 8,                 -- higher is calmer
--   comfort = {"default:dirt"}, -- carrying these settles the bug
--   dark = true,                -- light makes it want out
--   wander = 1 / 120,           -- chance per tick to slip away as an item
-- }
function wc_bugs.register_escape(name, def)
	escapes[name] = def
end

local function eject(pos, stack)
	local obj = minetest.add_item(pos, stack)
	if not obj then return end
	obj:set_velocity({
		x = math.random() * 2 - 1,
		y = 1.5,
		z = math.random() * 2 - 1
	})
	minetest.sound_play("default_place_node_hard",
		{pos = pos, gain = 0.1, max_hear_distance = 6}, true)
end

-- Does the player carry anything that settles this bug? Accepts plain item
-- names and "group:foo".
local function has_comfort(list, items)
	for _, want in ipairs(items) do
		local group = want:match("^group:(.*)$")
		for _, stack in ipairs(list) do
			local name = stack:get_name()
			if name ~= "" then
				if group then
					if minetest.get_item_group(name, group) > 0 then
						return true
					end
				elseif name == want then
					return true
				end
			end
		end
	end
	return false
end

local function inventory_escapes(player)
	local inv = player:get_inventory()
	local list = inv and inv:get_list("main")
	if not list then return end

	local pos = player:get_pos()
	pos.y = pos.y + 1
	local light = minetest.get_node_light(pos) or 0
	local vel = player:get_velocity() or {x = 0, y = 0, z = 0}
	local speed = vector.length({x = vel.x, y = 0, z = vel.z})
	local changed = false

	for i, stack in ipairs(list) do
		local def = escapes[stack:get_name()]
		if def then
			-- Calmness: comforted by familiar company, unnerved by light
			-- and by being jostled around.
			local calm = 1
			if def.comfort and has_comfort(list, def.comfort) then
				calm = calm + 1
			end
			if def.dark then
				calm = calm - light / 5
			end
			calm = calm - speed / 5
			calm = math.max(1, calm) * 2

			if math.random(math.floor(def.chance * calm)) == 1 then
				eject(pos, stack:take_item(1))
				list[i] = stack
				changed = true
			end
		end
	end

	if changed then
		inv:set_list("main", list)
	end
end

-- Loose bugs on the ground skitter about, and eventually wander off.
local function ground_escapes(pos)
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 20)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "__builtin:item" and ent.itemstring then
			local def = escapes[ItemStack(ent.itemstring):get_name()]
			if def then
				local opos = obj:get_pos()
				if def.wander and math.random() < def.wander then
					obj:remove()
					wc_bugs.smokeburst(opos, 2)
				elseif math.random(2) == 1 then
					local vel = obj:get_velocity()
					if vel and math.abs(vel.y) < 0.1 then
						obj:set_velocity({
							x = math.random() * 3 - 1.5,
							y = 1,
							z = math.random() * 3 - 1.5
						})
					end
				end
			end
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2 then return end
	timer = 0
	for _, player in ipairs(minetest.get_connected_players()) do
		inventory_escapes(player)
		ground_escapes(player:get_pos())
	end
end)

------------------------------------------------------------------------
-- registration shorthands
------------------------------------------------------------------------

-- The nodecore original let you squash a bug by pummelling it with a
-- hammer, which has no equivalent here; a shapeless recipe stands in.
function wc_bugs.register_smush(bug, output)
	minetest.register_craft({
		output = output,
		type = "shapeless",
		recipe = {bug},
	})
end

-- Rare extra drop when a given kind of node is dug, used to seed the bugs
-- that hide inside terrain rather than sitting on top of it.
-- Names may be plain node names or "group:foo".
function wc_bugs.register_dig_spawn(nodenames, item, chance)
	local names, groups = {}, {}
	for _, n in ipairs(nodenames) do
		local g = n:match("^group:(.*)$")
		if g then
			groups[#groups + 1] = g
		else
			names[n] = true
		end
	end
	minetest.register_on_dignode(function(pos, oldnode, digger)
		if not digger then return end
		local hit = names[oldnode.name]
		if not hit then
			for _, g in ipairs(groups) do
				if minetest.get_item_group(oldnode.name, g) > 0 then
					hit = true
					break
				end
			end
		end
		if not hit or math.random(chance) ~= 1 then return end
		minetest.add_item(pos, item)
	end)
end
