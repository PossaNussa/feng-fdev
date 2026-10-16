-- Landmarks worth walking to.
--
-- dungeonsplus builds towers, ruins and dungeons at worldgen and then forgets
-- where: the position is logged and thrown away. This keeps the ones it makes,
-- so a wandering adventurer can point a player at a *real* dungeon a few hundred
-- nodes off rather than only ever inventing one. dungeonsplus calls record()
-- from its own generation loop (guarded there -- it does not depend on us).
--
-- Nothing here writes to the map. A point of interest is a coordinate and a
-- name; what a player finds when they get there is dungeonsplus' business, dug
-- out of the ground long before anyone asked about it.

local util = village_life.util

local poi = {}
village_life.poi = poi

local storage = minetest.get_mod_storage()
local dirty = false

--------------------------------------------------------------------------------
-- Tuning
--------------------------------------------------------------------------------

-- Two dungeons within this of each other are the same landmark as far as a
-- direction-and-distance rumour is concerned; the second is dropped rather than
-- filling the book with near-duplicates of one place.
local MERGE = 48

-- The book is capped so a well-explored world does not grow it without bound.
-- Oldest out first: a landmark a player found a real-world week ago is the one
-- least worth a fresh rumour. Plenty for "somewhere near here" -- the lookup is
-- always range-bounded anyway.
local MAX = 400

-- How far a landmark can be and still be something an adventurer "knows about".
-- A morning's walk: far enough to be an errand, near enough to be true.
poi.RANGE = 420

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- A flat list of {name = string, x, y, z, at = day}. A list rather than a grid:
-- it is capped small and every read is a range scan, so the constant factor of
-- a hash grid buys nothing and costs the bucket bookkeeping.
poi.list = {}

local function load()
	local raw = storage:get_string("poi")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then poi.list = data end
end

local function save()
	if not dirty then return end
	storage:set_string("poi", minetest.serialize(poi.list))
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
poi.save = save

--------------------------------------------------------------------------------
-- Recording
--------------------------------------------------------------------------------

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

-- Remember a landmark. Called from mapgen (dungeonsplus), so it must stay cheap
-- and never touch the map: a dedupe scan of a few-hundred-entry list and, at
-- worst, dropping the oldest entry.
function poi.record(name, pos)
	if not pos or not pos.x then return end
	local rx, ry, rz = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)

	for _, e in ipairs(poi.list) do
		if math.abs(e.x - rx) <= MERGE and math.abs(e.z - rz) <= MERGE
				and math.abs(e.y - ry) <= MERGE then
			return  -- already have this one
		end
	end

	poi.list[#poi.list + 1] = {name = name or "dungeon",
			x = rx, y = ry, z = rz, at = today()}

	-- Trim oldest first when over the cap.
	if #poi.list > MAX then
		table.remove(poi.list, 1)
	end
	dirty = true
end

--------------------------------------------------------------------------------
-- Lookup
--------------------------------------------------------------------------------

-- The nearest landmark to `pos` within `maxdist` (default poi.RANGE), as
-- {name, pos = {x,y,z}, dist}. Nil when there is nothing known nearby -- which
-- is the common case, and the cue for an adventurer to fall back on a rumour.
function poi.nearest(pos, maxdist)
	if not pos then return end
	maxdist = maxdist or poi.RANGE
	local best, best_d
	for _, e in ipairs(poi.list) do
		local dx, dz = e.x - pos.x, e.z - pos.z
		local d = math.sqrt(dx * dx + dz * dz)
		if d <= maxdist and (not best_d or d < best_d) then
			best_d, best = d, e
		end
	end
	if not best then return end
	return {name = best.name, pos = {x = best.x, y = best.y, z = best.z},
			dist = best_d}
end

--------------------------------------------------------------------------------
-- Saying where
--------------------------------------------------------------------------------

-- Eight-wind compass bearing from `from` to `to`. +z is north in Luanti, +x is
-- east, so the octant is read straight off the signed offsets.
local WINDS = {"north", "north-east", "east", "south-east",
               "south", "south-west", "west", "north-west"}

-- LuaJIT (what the engine runs) has math.atan2; a stock Lua 5.4 build folds it
-- into two-argument math.atan. Take whichever is here so the bearing is right on
-- both.
local atan2 = math.atan2 or math.atan

function poi.bearing(from, to)
	local dx, dz = to.x - from.x, to.z - from.z
	if dx == 0 and dz == 0 then return "right here" end
	-- atan2(east, north) so 0 = due north, increasing clockwise through east.
	local ang = atan2(dx, dz)                       -- -pi..pi
	local octant = math.floor((ang / (math.pi / 4)) + 0.5) % 8
	return WINDS[octant + 1]
end

-- Rough distance, in the units a person on foot talks in. Never a node count --
-- an adventurer paces the world, they do not read a coordinate off it.
local function far_talk(d)
	if d < 120 then return "not far" end
	if d < 260 then return "a fair walk" end
	if d < 420 then return "the better part of a morning's walk" end
	return "a long way"
end

-- dungeonsplus names features in snake_case ("brick_dungeon", "tower"). Turn
-- that into something a person would say, and lead unknowns with a plain word.
function poi.pretty(name)
	if not name or name == "" then return "an old ruin" end
	local words = name:gsub("_", " ")
	-- "dungeon"/"tower"/"ruin" already read as nouns; anything else gets one.
	if words:find("dungeon") or words:find("tower") or words:find("ruin")
			or words:find("hut") or words:find("lair") then
		return "a " .. words
	end
	return "an old " .. words
end

-- "a brick dungeon, north-east of here and a fair walk off" -- a true bearing to
-- a landmark that is actually in the ground.
function poi.describe(from, entry)
	local dir = poi.bearing(from, entry.pos)
	return ("%s, %s of here and %s off"):format(
			poi.pretty(entry.name), dir, far_talk(entry.dist))
end

--------------------------------------------------------------------------------
-- When there is nothing real to point at
--------------------------------------------------------------------------------

-- A rumour: a direction and a vague distance and a kind of place, made up on the
-- spot but made up the *same* way every time for the same teller, so an
-- adventurer does not contradict themselves between one question and the next.
-- No promise anything is there -- it is a story they heard, said as one.
local RUMOUR_KINDS = {
	"an old tower somebody swears they saw",
	"a barrow the shepherds won't go near",
	"a ruin the moss has nearly taken",
	"a stair cut into the rock, going down",
	"a cellar under a house that isn't there any more",
	"a cave mouth with old marks around it",
}

function poi.rumor(seed, from)
	local rng = util.rng("poi_rumor", seed or "x")
	local kind = RUMOUR_KINDS[rng:next(1, #RUMOUR_KINDS)]
	local dir = WINDS[rng:next(1, #WINDS)]
	local d = rng:next(150, 900)
	return ("%s, %s of here -- %s, if the telling's true"):format(
			kind, dir, far_talk(d))
end

return poi
