-- creaturemob :: core/navigate.lua
--
-- The shared pathing service. Everything that wants a route asks here rather
-- than calling a pathfinder directly, so the cost is pooled and the answers are
-- reusable.
--
-- Three things distinguish this from calling core.find_path():
--
--   * it is time-sliced. core.find_path() runs the whole search inside one
--     step, so a village's worth of mobs asking at once is a visible stall.
--     pathfind.find_path() spends a few hundred microseconds and resumes next
--     step, and this layer adds a budget shared by every mob in the world, so
--     the cost per step is bounded no matter how many are asking.
--
--   * it knows how wide the mob is. The engine pathfinder solves for a point.
--     A 0.7-wide collisionbox handed a point-width route clips every corner it
--     is sent round, which is the "runs into walls constantly" symptom.
--
--   * it smooths. An A* route on a grid is a staircase, and a follower aiming
--     at each step of a staircase spends its whole time steering diagonally
--     into block corners. String-pulling collapses the staircase into the few
--     long straight runs a mob can actually walk.
--
-- Callers must tolerate `nil, "searching"` and keep steering toward the raw
-- goal in the meantime.

local navigate = {}

local world = creaturemob.world
local pathfind = creaturemob.pathfind

local floor, max, min = math.floor, math.max, math.min

local settings = core.settings

----------------------------------------------------------------------
-- Budget
----------------------------------------------------------------------

-- Microseconds of pathfinding per server step, shared by every mob. A budget
-- in time rather than in calls is what makes the degradation graceful: a
-- crowded village spreads its searches over more steps instead of handing most
-- of its mobs no route at all.
-- Each individual search slice is ~500us (creatura_a_star_alloted_time), so a
-- budget below about three slices means most mobs get no progress at all on
-- most steps -- and a mob with no route steers straight at its goal, which is
-- how it ends up in a wall. Six slices' worth is a few percent of a server
-- step and keeps a village's worth of mobs actually routed.
local BUDGET_US = tonumber(settings:get("creaturemob_path_budget_us")) or 3000

local budget_left = 0

core.register_globalstep(function()
	budget_left = BUDGET_US
end)

function navigate.budget_left()
	return budget_left
end

----------------------------------------------------------------------
-- Per-mob state
----------------------------------------------------------------------

-- Lives under the _cm_ prefix so Mobs Redo's clean_staticdata() leaves it out
-- of the mapblock: a frozen A* frontier has no business being serialised.
local function state(self)
	local s = self._cm_nav
	if not s then
		s = {pf = {_path_data = {}}}
		self._cm_nav = s
	end
	return s
end

-- Half-width and full height of the mob, from whichever collisionbox is
-- available at this point in its life cycle.
function navigate.shape(self)
	-- prop and base_colbox are Mobs Redo's caches; the object's own properties
	-- are the fallback that also covers creatura mobs and anything foreign.
	local cb = (self.prop and self.prop.collisionbox) or self.base_colbox

	if not cb then
		local props = self.object and self.object:get_properties()
		cb = props and props.collisionbox
	end

	if not cb then return 0.5, 1.8 end

	return max(cb[4], -cb[1]), max(0.5, cb[5] - cb[2])
end

-- Smart pathing is opt-out. A mob that wants to look stupid -- the undead,
-- anything meant to shamble -- sets `smart_path = false`.
function navigate.enabled(self)
	return self.smart_path ~= false
end

----------------------------------------------------------------------
-- Clearance
----------------------------------------------------------------------

-- Is the straight run from `a` to `b` walkable by a body this size? Sampled
-- rather than raycast because what matters is whether the *body* fits, not
-- whether a ray gets through: a diagonal between two block corners passes a
-- ray and stops a mob dead.
function navigate.line_clear(a, b, width, height)
	local dx, dy, dz = b.x - a.x, b.y - a.y, b.z - a.z
	local dist = (dx * dx + dz * dz) ^ 0.5
	local steps = max(1, floor(dist / 0.5))

	for i = 0, steps do
		local f = i / steps
		local p = {
			x = floor(a.x + dx * f + 0.5),
			y = floor(a.y + dy * f + 0.5),
			z = floor(a.z + dz * f + 0.5),
		}
		if world.is_blocked(p, width, height) then return false end
	end

	return true
end

-- Is there room to keep walking this way? `dir` is a horizontal unit vector.
-- This is the cheap per-step check that stops a mob grinding into a wall when
-- it has no route at all.
function navigate.clear_ahead(self, dir, dist)
	local pos = self.object:get_pos()
	if not pos or not dir then return true end

	local width, height = navigate.shape(self)
	dist = dist or (width + 1.0)

	local ahead = {
		x = pos.x + dir.x * dist,
		y = pos.y,
		z = pos.z + dir.z * dist,
	}

	-- A door-capable mob does not treat its own (openable) doorway as an
	-- obstacle to steer around: it opens it and walks through. See world.lua.
	world.door_pass = self.door_user == true
	local clear = navigate.line_clear(pos, ahead, width, height)
	world.door_pass = false
	return clear
end

-- Turn until something is clear. Returns a deflected unit vector, or nil if
-- the mob is boxed in.
--
-- Ordered smallest deflection first, and sides before reverse, so a mob brushing
-- a corner slides along it rather than spinning round -- and alternating left
-- and right means the choice is not biased into always hugging one wall.
local SIDESTEPS = {
	math.pi / 4, -math.pi / 4,
	math.pi / 2, -math.pi / 2,
	math.pi * 0.75, -math.pi * 0.75,
	math.pi,
}

function navigate.sidestep(self, dir, dist)
	if not dir then return end

	for i = 1, #SIDESTEPS do
		local a = SIDESTEPS[i]
		local cos_a, sin_a = math.cos(a), math.sin(a)
		local turned = {
			x = dir.x * cos_a - dir.z * sin_a,
			z = dir.x * sin_a + dir.z * cos_a,
		}
		if navigate.clear_ahead(self, turned, dist) then return turned end
	end
end

----------------------------------------------------------------------
-- Smoothing
----------------------------------------------------------------------

-- How far ahead string-pulling will look. Unbounded it is O(n^2) segment
-- tests; eight is enough to straighten any corridor and cheap enough to run on
-- every path that comes back.
local SMOOTH_LOOKAHEAD = 8

function navigate.smooth(path, width, height)
	if not path or #path < 3 then return path end

	local out = {path[1]}
	local i = 1

	while i < #path do
		local furthest = i + 1
		local limit = min(#path, i + SMOOTH_LOOKAHEAD)

		for j = limit, i + 2, -1 do
			-- Only collapse runs that stay on one level. Merging a step up or
			-- down into a long diagonal is how a mob ends up walking at a
			-- staircase from the side and jamming against its riser.
			if math.abs(path[j].y - path[i].y) < 0.6
					and navigate.line_clear(path[i], path[j], width, height) then
				furthest = j
				break
			end
		end

		out[#out + 1] = path[furthest]
		i = furthest
	end

	return out
end

----------------------------------------------------------------------
-- Route cache
----------------------------------------------------------------------

-- Villagers walk the same few routes all day: bed to workplace, workplace to
-- the square, the square home again. Caching by coarse cell means the second
-- villager to make a journey pays nothing for it.
local CACHE_TTL = 25          -- seconds
local CACHE_MAX = 512
local CELL = 2                -- cache granularity, in nodes

local cache = {}
local cache_count = 0

local function cell(v)
	return floor(v / CELL)
end

local function cache_key(from, to, width)
	return table.concat({
		cell(from.x), cell(from.y), cell(from.z),
		cell(to.x), cell(to.y), cell(to.z),
		width > 0.5 and "w" or "n",
	}, ":")
end

local function cache_get(key)
	local hit = cache[key]
	if not hit then return end
	if hit.expires < os.time() then
		cache[key] = nil
		cache_count = cache_count - 1
		return
	end
	return hit.path
end

local function cache_put(key, path)
	if cache_count >= CACHE_MAX then
		-- Cheap eviction: drop everything expired, and if that frees nothing,
		-- drop the lot. A route cache is a convenience, not a source of truth.
		local now = os.time()
		local freed = 0
		for k, v in pairs(cache) do
			if v.expires < now then cache[k] = nil ; freed = freed + 1 end
		end
		cache_count = cache_count - freed
		if freed == 0 then cache = {} ; cache_count = 0 end
	end
	cache[key] = {path = path, expires = os.time() + CACHE_TTL}
	cache_count = cache_count + 1
end

function navigate.forget_routes()
	cache = {}
	cache_count = 0
end

----------------------------------------------------------------------
-- The request
----------------------------------------------------------------------

-- Returns:
--   path, "cached"      a reusable route another mob already found
--   path, "found"       a fresh route
--   nil,  "searching"   the frontier is frozen, ask again next step
--   nil,  "budget"      no time left this step, ask again next step
--   nil,  "failed"      there is no route
--
-- "searching" and "budget" mean *keep going* -- steer at the goal in the
-- meantime. Only "failed" is a reason to give up.
-- Drop the goal onto a tile a body can actually occupy.
--
-- This matters far more than it looks. The A* success test is an exact node
-- hash match when the goal is on the ground, so a goal one node off a standable
-- tile -- a bed, a workplace marker, the middle of a doorway -- can never be
-- matched. The search does not fail fast either: it expands until it hits the
-- open-set ceiling and only then reports failure, so every such request burns
-- the whole budget and returns nothing. A caller that then steers straight at
-- the goal is a mob walking into a wall.
-- A cell a body can occupy: unblocked, and resting on something. Solid ground is
-- the usual something; for a climb-capable mob, being in (or directly above) a
-- ladder counts too, so a route can start from a villager caught mid-rung
-- instead of snapping it off onto the nearest floor and abandoning the climb.
local function standable(p, width, height)
	if world.is_blocked(p, width, height) then return false end
	local below = {x = p.x, y = p.y - 1, z = p.z}
	if world.get_node_def(core.get_node(below).name).walkable then return true end
	if world.climb_pass and (world.is_climbable(p) or world.is_climbable(below)) then
		return true
	end
	return false
end

function navigate.snap(pos, width, height)
	local base = {x = floor(pos.x + 0.5), y = floor(pos.y + 0.5), z = floor(pos.z + 0.5)}

	if standable(base, width, height) then return base end

	-- Shells outward, level first, then one step down, then one up.
	for r = 0, 2 do
		for _, dy in ipairs({0, -1, 1, -2, 2}) do
			for dx = -r, r do
				for dz = -r, r do
					if r == 0 or math.abs(dx) == r or math.abs(dz) == r then
						local p = {x = base.x + dx, y = base.y + dy, z = base.z + dz}
						if standable(p, width, height) then return p end
					end
				end
			end
		end
	end

	return base
end

function navigate.find_path(self, from, to)
	if not from or not to then return nil, "failed" end

	local s = state(self)
	local width, height = navigate.shape(self)

	-- A door-capable mob may plan through openable doors, and a climb-capable one
	-- through ladders; see world.lua. Both flags are set only around the queries
	-- that read them and cleared straight after, so nothing else in the world sees
	-- a door or a rung as passable.
	local door_pass = self.door_user == true
	local climb_pass = self.can_climb == true

	world.door_pass = door_pass
	world.climb_pass = climb_pass
	from = navigate.snap(from, width, height)
	to = navigate.snap(to, width, height)
	world.door_pass = false
	world.climb_pass = false

	-- Keyed on climb too: a route a climber found up a rope is not one a walker
	-- can take, and must not be served to it from the cache.
	local key = cache_key(from, to, width) .. (climb_pass and ":c" or "")
	local cached = cache_get(key)
	if cached then return cached, "cached" end

	-- A frozen frontier has already been paid for; let it finish even when the
	-- budget is gone, or a busy server would restart the same search forever.
	local resuming = s.pf._path_data and s.pf._path_data.start ~= nil

	if budget_left <= 0 and not resuming then return nil, "budget" end

	s.pf.width = width
	s.pf.height = height

	local t0 = core.get_us_time()
	world.door_pass = door_pass
	world.climb_pass = climb_pass
	local path = pathfind.find_path(s.pf, from, to)
	world.door_pass = false
	world.climb_pass = false
	budget_left = budget_left - (core.get_us_time() - t0)

	if path and #path > 0 then
		path = navigate.smooth(path, width, height)
		cache_put(key, path)
		return path, "found"
	end

	-- pathfind.find_path returns nil both for "still working" and for "no
	-- route". It leaves the frontier in _path_data in the first case and clears
	-- it in the second, which is the only way to tell them apart.
	if s.pf._path_data and s.pf._path_data.start ~= nil then
		return nil, "searching"
	end

	return nil, "failed"
end

-- Abandon whatever search this mob had in flight, e.g. because its goal moved.
function navigate.reset(self)
	local s = self._cm_nav
	if s then s.pf._path_data = {} end
end

return navigate
