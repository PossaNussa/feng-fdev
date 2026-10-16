-- What a villager does when they are not working, and whether it is true.
--
-- The old `persona.pastimes` list was sixteen hand-written strings drawn at
-- random and spoken as fact. "I've been keeping bees behind the house" -- with
-- no hive, no bees, and no honey to sell you. "Fishing the river before dawn"
-- said by someone asleep at that hour, in a village with no river. A villager
-- who says a false thing about themselves in their one personal line is worse
-- than one who says nothing: it teaches the player that none of it means
-- anything.
--
-- So every trait now belongs to one of three classes, and the class decides
-- what the villager is allowed to claim:
--
--   simulated    There is really a hive on their plot. They really go and tend
--                it. It really produces honey, and they really sell it. Said
--                as plain fact, because it is one.
--   conditional  True only if the world supports it -- you cannot fish a river
--                that is not there. Checked against the actual map before the
--                trait is ever handed out.
--   behaviour    A claim about their own private conduct: singing badly,
--                re-reading the same three books. Nothing in the world could
--                confirm or deny it, and nothing needs to. These are the only
--                ones that stay pure text, and that is honest.
--
-- Anything that failed to be realised falls back to an *aspiration*, which is
-- phrased as a wish rather than a fact: "I'd keep bees, if I had the room."

local util = village_life.util
local home = village_life.home

local traits = {}
village_life.traits = traits

local storage = minetest.get_mod_storage()
local dirty = false

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- villager key -> {id = trait id, pos = {x,y,z} or nil, failed = bool}
--
-- Stored rather than derived, because where a hive ended up is a fact about the
-- world, not about the villager: it depends on what was buildable when they
-- first came to tend it.
traits.book = {}

local function load()
	local raw = storage:get_string("traits")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then traits.book = data end
end

local function save()
	if not dirty then return end
	storage:set_string("traits", minetest.serialize(traits.book))
	dirty = false
end

load()

local save_timer = 0
minetest.register_globalstep(function(dtime)
	save_timer = save_timer + dtime
	if save_timer < 300 then return end
	save_timer = 0
	save()
end)

minetest.register_on_shutdown(save)

traits.save = save

--------------------------------------------------------------------------------
-- Placing things on a plot
--------------------------------------------------------------------------------

-- An outdoor spot on this villager's plot where something can be stood on the
-- ground, avoiding the building itself.
--
-- Rings outward from the plot corner furthest from the door, so hives and
-- gardens end up round the back rather than across the front step.
local function open_ground(r, want)
	local bpos = r.bpos
	if not bpos then return end

	local sx, sz = bpos.bsizex or 5, bpos.bsizez or 5
	local candidates = {}

	-- One node outside the building footprint, all the way round.
	for dx = -1, sx do
		for dz = -1, sz do
			local on_edge = dx == -1 or dz == -1 or dx == sx or dz == sz
			if on_edge then
				candidates[#candidates + 1] = {x = bpos.x + dx, z = bpos.z + dz}
			end
		end
	end

	-- Deterministic order per villager, so two villagers on adjacent plots do
	-- not race for the same square and the same person picks the same spot
	-- after a restart.
	local rng = util.rng("trait_spot", r.village_id, r.plot_nr, r.bed_nr)
	for i = #candidates, 2, -1 do
		local j = rng:next(1, i)
		candidates[i], candidates[j] = candidates[j], candidates[i]
	end

	for _, c in ipairs(candidates) do
		-- Find the surface within a few nodes of the plot's own level.
		for dy = 2, -3, -1 do
			local p = {x = c.x, y = bpos.y + dy, z = c.z}
			local here = minetest.get_node_or_nil(p)
			local below = minetest.get_node_or_nil(
					{x = p.x, y = p.y - 1, z = p.z})
			local here_def = here and minetest.registered_nodes[here.name]
			local below_def = below and minetest.registered_nodes[below.name]

			if here_def and below_def and here_def.buildable_to
					and below_def.walkable
					and (not want or not want.soil
							or minetest.get_item_group(below.name, "soil") > 0
							or below.name == "default:dirt_with_grass") then
				return p
			end
		end
	end
end

-- Is there anything of this group within `radius` of `pos`?
local function group_near(pos, group, radius)
	local found = minetest.find_node_near(pos, radius, {"group:" .. group})
	return found ~= nil
end

--------------------------------------------------------------------------------
-- The traits
--------------------------------------------------------------------------------

-- Fields:
--   class       "simulated" | "conditional" | "behaviour"
--   fact        what they say when it is true
--   wish        what they say when it is not (simulated/conditional only)
--   possible    (self, r) -> bool. Checked before the trait is handed out.
--   realise     (self, r) -> pos | nil. Builds the thing. Simulated only.
--   tend        (self, r, pos). Called when they reach it on a hobby goal.
--   product     itemstring their shop gains once the trait is real.
traits.defs = {
	--------------------------------------------------------------------------
	-- Simulated: there is really something there
	--------------------------------------------------------------------------
	{
		id = "bees",
		class = "simulated",
		fact = "keeping bees behind the house",
		wish = "keep bees, if I had the room for a hive",
		product = "x_farming:honeycomb",
		possible = function()
			return minetest.registered_nodes["x_farming:bee_hive"] ~= nil
		end,
		realise = function(self, r)
			local pos = open_ground(r)
			if not pos then return end

			minetest.set_node(pos, {name = "x_farming:bee_hive", param2 = 0})

			-- A hive with occupancy 0 is an empty box: x_farming's timer
			-- returns immediately and it never makes honey. Placing one and
			-- calling it beekeeping would be exactly the lie this file exists
			-- to remove, so it gets bees in it.
			local meta = minetest.get_meta(pos)
			meta:set_string("x_farming", minetest.serialize({
				occupancy = 2, saturation = 0,
			}))
			minetest.get_node_timer(pos):start(math.random(90, 150))

			-- Bees need forage within five nodes or the hive never saturates.
			-- Someone who keeps bees would have seen to that.
			if not group_near(pos, "flower", 5) then
				for _ = 1, 3 do
					local fp = open_ground(r, {soil = true})
					if fp and minetest.registered_nodes["flowers:dandelion_yellow"] then
						minetest.set_node(fp,
								{name = "flowers:dandelion_yellow"})
					end
				end
			end
			return pos
		end,
		tend = function(self, r, pos)
			local node = minetest.get_node_or_nil(pos)
			if not node or node.name ~= "x_farming:bee_hive" then return end
			-- Keep the timer alive. A hive nobody visits stops ticking when its
			-- mapblock unloads, and the beekeeper is the reason it restarts.
			if not minetest.get_node_timer(pos):is_started() then
				minetest.get_node_timer(pos):start(math.random(90, 150))
			end
		end,
	},
	{
		id = "rose",
		class = "simulated",
		fact = "tending a rose that refuses to flower",
		wish = "grow something, if anything took in this soil",
		possible = function()
			return minetest.registered_nodes["flowers:rose"] ~= nil
		end,
		realise = function(self, r)
			local pos = open_ground(r, {soil = true})
			if not pos then return end
			minetest.set_node(pos, {name = "flowers:rose"})
			return pos
		end,
	},
	{
		id = "garden",
		class = "simulated",
		fact = "growing more than we can eat, out the back",
		wish = "put in a garden, if the ground were better",
		product = "farming:carrot",
		possible = function()
			return minetest.registered_nodes["farming:carrot_8"] ~= nil
					or minetest.registered_nodes["farming:carrot"] ~= nil
		end,
		realise = function(self, r)
			local first
			for _ = 1, 4 do
				local pos = open_ground(r, {soil = true})
				if pos then
					local crop = minetest.registered_nodes["farming:carrot_8"]
							and "farming:carrot_8" or "farming:carrot"
					minetest.set_node(pos, {name = crop})
					first = first or pos
				end
			end
			return first
		end,
	},

	--------------------------------------------------------------------------
	-- Conditional: true only where the world allows it
	--------------------------------------------------------------------------
	{
		id = "fishing",
		class = "conditional",
		fact = "fishing the river before dawn",
		wish = "fish, if there were any water worth the walk",
		possible = function(self, r)
			-- No river, no fishing. This one was the clearest of the old lies:
			-- villages inland had anglers.
			local centre = r.plot_centre or r.centre
			if not centre then return false end
			return minetest.find_node_near(centre, 24,
					{"group:water"}) ~= nil
		end,
	},
	{
		id = "stones",
		class = "conditional",
		fact = "collecting odd stones",
		wish = "collect stones, if there were any worth stooping for",
		possible = function(self, r)
			local centre = r.plot_centre or r.centre
			return centre ~= nil
					and minetest.find_node_near(centre, 20, {"group:stone"}) ~= nil
		end,
	},
	{
		id = "brewing",
		class = "conditional",
		fact = "brewing something the priest disapproves of",
		wish = "brew, if I could get the barley",
		possible = function(self, r)
			-- Somebody has to be growing grain within reach for this to be
			-- anything other than a boast.
			local c = village_life.market.character(r.village_id)
			return c ~= nil and (c.speciality == "grain" or c.scarce ~= "grain")
		end,
	},

	--------------------------------------------------------------------------
	-- Behaviour: private conduct, unverifiable by anyone, and none the worse
	--------------------------------------------------------------------------
	{id = "carving", class = "behaviour",
			fact = "carving little animals out of offcuts"},
	{id = "singing", class = "behaviour", fact = "singing badly, and often"},
	{id = "birds", class = "behaviour",
			fact = "writing down every bird I see"},
	{id = "baking", class = "behaviour",
			fact = "baking for people who did not ask"},
	{id = "grain_prices", class = "behaviour",
			fact = "arguing about the price of grain"},
	{id = "spoons", class = "behaviour",
			fact = "whittling spoons nobody needs"},
	{id = "stars", class = "behaviour",
			fact = "star-gazing from the roof"},
	{id = "books", class = "behaviour",
			fact = "reading the same three books over again"},
	{id = "sleeping", class = "behaviour",
			fact = "sleeping, mostly, and I'll not apologise for it"},
	{id = "listening", class = "behaviour",
			fact = "listening at windows I've no business under"},
}

local by_id = {}
for _, def in ipairs(traits.defs) do by_id[def.id] = def end
traits.by_id = by_id

--------------------------------------------------------------------------------
-- Assignment
--------------------------------------------------------------------------------

-- Which trait this villager has. Deterministic per villager, but filtered by
-- what this particular village can actually support, so the same person is the
-- same person while never being handed something the world cannot back.
function traits.of(self)
	local key = village_life.memory.key_of(self)
	if not key then return end

	local entry = traits.book[key]
	if entry then return by_id[entry.id], entry end

	local r = home.resolve(self)
	if not r then return end

	local eligible = {}
	for _, def in ipairs(traits.defs) do
		if not def.possible or def.possible(self, r) then
			eligible[#eligible + 1] = def
		end
	end
	if #eligible == 0 then return end

	local rng = util.rng("trait", key)
	local def = eligible[rng:next(1, #eligible)]

	entry = {id = def.id}
	traits.book[key] = entry
	dirty = true
	return def, entry
end

--------------------------------------------------------------------------------
-- Making it real
--------------------------------------------------------------------------------

-- Build the thing, once, the first time this villager is at home with the plot
-- loaded. Failure is remembered too: a plot with no room stays a plot with no
-- room, and the villager falls back to saying they wish they could.
--
-- Returns `pos, settled`. `settled` is false when the answer is "not yet" --
-- the plot's mapblocks are not loaded, so every node reads as nil and there is
-- nowhere to put anything. Callers must not treat that as failure or a villager
-- who first thought while standing at a workplace across the village would be
-- permanently barred from their own hobby.
function traits.realise(self)
	local def, entry = traits.of(self)
	if not def or not entry then return nil, true end
	if def.class ~= "simulated" then return nil, true end
	if entry.pos or entry.failed then return entry.pos, true end

	local r = home.resolve(self)
	if not r then return nil, true end

	if not r.bpos or not util.is_loaded(
			{x = r.bpos.x, y = r.bpos.y, z = r.bpos.z}) then
		return nil, false
	end

	local ok, pos = pcall(def.realise, self, r)
	if not ok then
		village_life.log("warning", ("trait %s failed: %s"):format(
				def.id, tostring(pos)))
		pos = nil
	end

	if pos then
		entry.pos = pos
		village_life.log("info", ("%s took up %s at %s"):format(
				village_life.memory.key_of(self), def.id,
				minetest.pos_to_string(pos)))
	else
		entry.failed = true
	end
	dirty = true
	return pos, true
end

-- Whether the thing is still there. A hive somebody chopped down is no longer
-- something its keeper can claim, and they go back to wishing.
function traits.realised(self)
	local def, entry = traits.of(self)
	if not def or not entry or not entry.pos then return false end
	if def.class ~= "simulated" then return true end

	local node = minetest.get_node_or_nil(entry.pos)
	if not node then
		-- Unloaded, not gone. Assume it survives; the tend step will find out.
		return true
	end
	if node.name == "air" or node.name == "ignore" then
		entry.pos = nil
		entry.failed = true
		dirty = true
		return false
	end
	return true
end

--------------------------------------------------------------------------------
-- What they say about it
--------------------------------------------------------------------------------

-- The clause a villager uses for their own pastime, and whether it is a fact.
-- Callers phrase it; this decides what is true.
function traits.clause(self)
	local def, entry = traits.of(self)
	if not def then return end

	if def.class == "behaviour" then
		return def.fact, true
	end

	if def.class == "conditional" then
		-- Conditionals were filtered at assignment, so holding one means the
		-- world supported it. It is stated.
		return def.fact, true
	end

	if entry and entry.pos and traits.realised(self) then
		return def.fact, true
	end
	return def.wish, false
end

-- Where their hobby lives, for the schedule to send them to.
function traits.place(self)
	local def, entry = traits.of(self)
	if not def or def.class ~= "simulated" then return end
	if not entry or not entry.pos then return end
	if not traits.realised(self) then return end
	return entry.pos, def
end

-- Called when they arrive. Keeps the thing running.
function traits.tend(self)
	local pos, def = traits.place(self)
	if not pos or not def or not def.tend then return end
	pcall(def.tend, self, home.resolve(self), pos)
end

-- The extra item a villager's own hobby puts on their shelf, if any.
function traits.product(self)
	local def = traits.of(self)
	if not def or not def.product then return end
	if not traits.realised(self) then return end
	if not minetest.registered_items[def.product] then return end
	return def.product
end

function traits.forget(key)
	if traits.book[key] then
		traits.book[key] = nil
		dirty = true
	end
end
