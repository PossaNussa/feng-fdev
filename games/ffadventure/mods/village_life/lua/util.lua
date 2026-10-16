-- Shared helpers: deterministic RNG, cheap geometry, per-entity scratch space
-- and the global pathfinder budget.

local util = {}
village_life.util = util

local floor, abs, sqrt = math.floor, math.abs, math.sqrt

--------------------------------------------------------------------------------
-- Deterministic randomness
--------------------------------------------------------------------------------

-- djb2 over a string. Used to turn a stable identity ("village 12:-4, plot 7,
-- bed 2") into a seed, so a shop looks the same after a server restart and two
-- villages' blacksmiths differ without storing anything.
--
-- Multiply-and-add rather than the usual FNV-1a because mods run on LuaJIT
-- (Lua 5.1), which has no `~` xor operator, and the numeric-only form is
-- identical across every Lua the engine has ever shipped. Kept under 2^31 so
-- the running value stays exactly representable as a double.
function util.hash(str)
	local h = 5381
	for i = 1, #str do
		h = (h * 33 + str:byte(i)) % 2147483647
	end
	return h
end

function util.rng(...)
	local parts = {}
	for i = 1, select("#", ...) do
		parts[i] = tostring((select(i, ...)))
	end
	return PcgRandom(util.hash(table.concat(parts, "|")))
end

-- rng:next(a, b) is inclusive; this is the float form we want for jitter.
function util.rng_float(rng, min, max)
	return min + (max - min) * (rng:next(0, 1000000) / 1000000)
end

--------------------------------------------------------------------------------
-- Geometry
--------------------------------------------------------------------------------

function util.dist2(a, b)
	local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
	return dx * dx + dy * dy + dz * dz
end

function util.dist(a, b)
	return sqrt(util.dist2(a, b))
end

-- Horizontal distance. Almost every "have I arrived" test wants this: a mob
-- standing on a doorstep is at the same x/z as the target but a step lower.
function util.dist_flat(a, b)
	local dx, dz = a.x - b.x, a.z - b.z
	return sqrt(dx * dx + dz * dz)
end

function util.round_pos(p)
	return {x = floor(p.x + 0.5), y = floor(p.y + 0.5), z = floor(p.z + 0.5)}
end

-- Is this position standing on the plot `bpos` covers?
--
-- The building occupies the nodes bpos.x .. bpos.x + bsizex - 1, so in
-- positions that is [bpos.x - 0.5, bpos.x + bsizex - 0.5): the half node either
-- end is the width of the edge nodes themselves, not slack.
--
-- Deliberately not generous. A villager standing on the street tile in front of
-- their own door has to read as *outside*, because that is the test deciding
-- whether they walk up to the door and open it or strike out for their bed
-- through the wall. One node of slack here reads the doorstep as indoors and
-- puts the bug straight back.
--
-- The height bound stops the answer being "yes" for somebody in the cellar
-- underneath or on the hillside above -- the same mistake that put a whole
-- village on permanent alert when "is this in the village" was tested as a
-- cylinder of infinite height.
local PLOT_HEIGHT = 12

function util.inside_plot(pos, bpos)
	if not pos or not bpos or not bpos.x then return false end
	local sx = (bpos.bsizex or 1) - 0.5
	local sz = (bpos.bsizez or 1) - 0.5
	return pos.x >= bpos.x - 0.5 and pos.x <= bpos.x + sx
			and pos.z >= bpos.z - 0.5 and pos.z <= bpos.z + sz
			and (bpos.y == nil or abs(pos.y - bpos.y) <= PLOT_HEIGHT)
end

--------------------------------------------------------------------------------
-- World queries
--------------------------------------------------------------------------------

-- True when the node is loaded and not walkable. "ignore" means unloaded, and
-- must never read as free space or a villager will happily path into the void.
function util.is_clear(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then return false end
	local def = minetest.registered_nodes[node.name]
	return def ~= nil and not def.walkable
end

function util.is_loaded(pos)
	return minetest.get_node_or_nil(pos) ~= nil
end

-- Is there a roof over this position? Deliberately a short upward scan rather
-- than a raycast: it runs for every villager on every schedule tick, and the
-- question is only ever "am I standing under something", not "is the sky
-- visible along an arbitrary ray".
--
-- Leaves count as shelter from rain but not from snow-laden wind; that
-- distinction is not worth the complexity, so any walkable node counts.
function util.has_roof(pos, height)
	height = height or 10
	local p = {x = floor(pos.x + 0.5), y = 0, z = floor(pos.z + 0.5)}
	local base = floor(pos.y + 0.5)
	for dy = 2, height do
		p.y = base + dy
		local node = minetest.get_node_or_nil(p)
		if node then
			local def = minetest.registered_nodes[node.name]
			if def and def.walkable then return true end
		end
	end
	return false
end

local function standable(p)
	local below = {x = p.x, y = p.y - 1, z = p.z}
	local bnode = minetest.get_node_or_nil(below)
	local bdef = bnode and minetest.registered_nodes[bnode.name]
	if not bdef or not bdef.walkable then return false end
	return util.is_clear(p) and util.is_clear({x = p.x, y = p.y + 1, z = p.z})
end

-- Find a standable spot near `pos`. Used when a target -- a bed, a workplace
-- marker -- is itself not somewhere a mob can stand.
--
-- Searched as expanding shells with an early return rather than a full scan
-- for the minimum: this runs whenever an idle villager picks a new place to
-- loiter, and a full radius-3 box is several hundred node reads for an answer
-- that is almost always found in the first shell.
function util.find_standing_near(pos, radius)
	radius = radius or 2
	local base = util.round_pos(pos)

	-- Level first, then one step down (a doorstep), then one step up (a stair).
	local levels = {0, -1, 1}

	for r = 0, radius do
		for _, dy in ipairs(levels) do
			for dx = -r, r do
				for dz = -r, r do
					-- shell only: the interior was covered by a smaller r
					if r == 0 or abs(dx) == r or abs(dz) == r then
						local p = {x = base.x + dx, y = base.y + dy,
						           z = base.z + dz}
						if standable(p) then return p end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Per-entity scratch space
--------------------------------------------------------------------------------

-- Runtime state that must NOT be serialised: paths, timers, cached positions.
-- Weak keys so an unloaded mob's entry disappears with its luaentity table.
--
-- Mobs redo serialises every non-function field of `self`, so anything parked
-- directly on the entity is written into the mapblock on every unload. Only
-- the small identity table (see home.lua) belongs there.
local scratch = setmetatable({}, {__mode = "k"})

function util.scratch(self)
	local s = scratch[self]
	if not s then
		s = {}
		scratch[self] = s
	end
	return s
end

--------------------------------------------------------------------------------
-- Timers and budgets
--------------------------------------------------------------------------------

-- Staggered periodic tick. `key` names the timer, `interval` is in seconds.
-- The first fire is offset by a random fraction so a village's worth of mobs
-- that all activated in the same mapblock do not think on the same step.
function util.every(self, key, interval, dtime)
	local s = util.scratch(self)
	local k = "t_" .. key
	local t = s[k]
	if t == nil then
		s[k] = math.random() * interval
		return false
	end
	t = t + dtime
	if t >= interval then
		s[k] = 0
		return true
	end
	s[k] = t
	return false
end

--------------------------------------------------------------------------------
-- Wall clock
--------------------------------------------------------------------------------

-- Seconds, monotonic, real time.
--
-- Deliberately NOT os.clock(), which returns CPU time consumed by the process.
-- Luanti runs emerge and other threads alongside the server step, so os.clock()
-- can advance several times faster than the wall while a player explores and
-- then barely move on an idle server. Everything that expires -- alarms, recall
-- cooldowns, the weather cache -- has to be in real seconds or it behaves
-- differently depending on how busy the server is.
function util.now()
	if minetest.get_us_time then return minetest.get_us_time() / 1000000 end
	return os.time()
end

--------------------------------------------------------------------------------
-- Time of day
--------------------------------------------------------------------------------

-- Luanti's timeofday is 0..1 with 0.25 = 06:00 and 0.75 = 18:00.
function util.hour()
	return (minetest.get_timeofday() or 0.5) * 24
end
