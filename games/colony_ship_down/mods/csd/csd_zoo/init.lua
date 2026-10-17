-- The zoological deck: keeps every habitat stocked.
--
-- Habitats are rooms whose layout entry has a `zoo` spec (csd_ship/layout.lua):
-- animals = {{entity, count}, ...}. Every so often, for each habitat with a
-- player nearby, missing animals are added at random free spots inside it -
-- in the water for aquarium fish, in the air for birds, on the ground for the
-- rest. Wild spawning is off (mobs_spawn = false in minetest.conf), so these
-- are the only animals aboard.

csd_zoo = {}
local S = core.get_translator("csd_zoo")

local INTERVAL = 20
local NEAR = 48

------------------------------------------------------------------------------
-- The aquarium's salmon (adapted from the zombies mod)
------------------------------------------------------------------------------

if core.global_exists("mobs") and mobs.register_mob then
	mobs:register_mob("csd_zoo:salmon", {
		type = "animal",
		passive = true,
		hp_min = 3,
		hp_max = 3,
		armor = 100,
		collisionbox = {-0.4, 0.0, -0.4, 0.4, 0.79, 0.4},
		visual = "mesh",
		mesh = "csd_zoo_salmon.b3d",
		textures = {{"csd_zoo_salmon.png"}},
		visual_size = {x = 3, y = 3},
		animation = {stand_start = 1, stand_end = 20, walk_start = 1, walk_end = 20, run_start = 1, run_end = 20},
		drops = {{name = "csd_zoo:salmon_raw", chance = 1, min = 1, max = 1}},
		makes_footstep_sound = false,
		fly = true,
		fly_in = {"default:water_source", "default:river_water_source"},
		breathes_in_water = true,
		jump = false,
		view_range = 16,
		runaway = true,
		fear_height = 4,
		water_damage = 0,
		air_damage = 1,
		on_spawn = function(self)
			local k = 2 + math.random() * 3
			self.object:set_properties({visual_size = {x = k, y = k}})
			return true
		end,
	})

	core.register_craftitem("csd_zoo:salmon_raw", {
		description = S("Raw Salmon"),
		inventory_image = "csd_zoo_salmon_raw.png",
		on_use = core.item_eat(2),
		groups = {food = 2, eatable = 2, meat = 1},
	})
	core.register_craftitem("csd_zoo:salmon_cooked", {
		description = S("Cooked Salmon"),
		inventory_image = "csd_zoo_salmon_cooked.png",
		on_use = core.item_eat(6),
		groups = {food = 2, eatable = 6, meat = 1},
	})
	core.register_craft({type = "cooking", output = "csd_zoo:salmon_cooked", recipe = "csd_zoo:salmon_raw"})
end

------------------------------------------------------------------------------
-- Stocking
------------------------------------------------------------------------------

local function count_in(r)
	local counts = {}
	for _, obj in ipairs(core.get_objects_in_area(r.minp, vector.offset(r.maxp, 1, 1, 1))) do
		local ent = obj:get_luaentity()
		if ent and ent.name then counts[ent.name] = (counts[ent.name] or 0) + 1 end
	end
	return counts
end

local function free(pos, water)
	local n = core.get_node(pos).name
	if water then return core.get_item_group(n, "water") > 0 end
	local def = core.registered_nodes[n]
	return def and not def.walkable and def.liquidtype == "none"
end

-- How many nodes tall an animal is (the new pixel elephant is over four).
local function height_of(name)
	local def = core.registered_entities[name] or {}
	local cb = (def.initial_properties and def.initial_properties.collisionbox) or def.collisionbox
	return cb and math.max(1, math.ceil(cb[5] - cb[2])) or 2
end

-- A random spot in the room: in water, mid-air (birds) or on the floor with
-- room for an animal `h` nodes tall.
local function spot(r, water, birds, h)
	for _ = 1, 40 do
		local p = vector.new(math.random(r.minp.x + 1, r.maxp.x - 1), r.minp.y, math.random(r.minp.z + 1, r.maxp.z - 1))
		if water then
			p.y = math.random(r.minp.y + 1, r.maxp.y - 1)
			if free(p, true) then return p end
		elseif birds then
			p.y = r.minp.y + math.random(2, 4)
			if free(p) and free(vector.offset(p, 0, 1, 0)) then return p end
		else
			local ok = true
			for dy = 0, h do
				if not free(vector.offset(p, 0, dy, 0)) then ok = false break end
			end
			if ok then return vector.offset(p, 0, 0.2, 0) end
		end
	end
end

function csd_zoo.restock(r, force)
	local zoo = r.zoo
	if not (zoo and zoo.animals) then return 0 end
	if not core.compare_block_status(r.minp, "active") and not force then return 0 end
	local counts = count_in(r)
	local added = 0
	for _, a in ipairs(zoo.animals) do
		local name, want = a[1], a[2]
		if core.registered_entities[name] then
			local h = height_of(name)
			for _ = (counts[name] or 0) + 1, want do
				local p = spot(r, zoo.water, zoo.birds, h)
				if p and core.add_entity(p, name) then added = added + 1 end
			end
		end
	end
	return added
end

local function habitats()
	local data = csd_ship.get_ship_data()
	local out = {}
	for _, r in ipairs(data and data.rooms or {}) do
		if r.zoo then out[#out + 1] = r end
	end
	return out
end

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < INTERVAL then return end
	timer = 0
	local players = core.get_connected_players()
	if #players == 0 then return end
	for _, r in ipairs(habitats()) do
		local c = vector.divide(vector.add(r.minp, r.maxp), 2)
		for _, p in ipairs(players) do
			if vector.distance(p:get_pos(), c) < NEAR then
				csd_zoo.restock(r)
				break
			end
		end
	end
end)

core.register_chatcommand("zoo", {
	params = "restock",
	description = S("Restock every zoo habitat now"),
	privs = {builder = true},
	func = function(_, param)
		if param ~= "restock" then return false, S("Usage: /zoo restock") end
		local n = 0
		for _, r in ipairs(habitats()) do n = n + csd_zoo.restock(r, true) end
		return true, S("Added @1 animals.", n)
	end,
})
