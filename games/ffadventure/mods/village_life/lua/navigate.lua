-- Movement.
--
-- Mobs redo's own navigation is either "walk in a random direction for a few
-- seconds" or "attack something", with pathfinding bolted onto the attack
-- state via a temporary entity that the mob chases. Neither is usable for
-- "walk to this specific doorway, then along this specific corridor, and stop
-- at that specific tile".
--
-- So this is a plain waypoint follower. It writes only yaw and forward speed,
-- which is exactly the interface creaturemob's motion controller expects
-- (set_velocity records intent; the controller re-derives the vector from the
-- live yaw every step), so it inherits the anti-rubberbanding work for free.
--
-- The brain must return `false` from do_custom while a goal is active,
-- otherwise mobs redo's do_states() will fight us for the velocity once a
-- second.

local util = village_life.util
local nav = {}
village_life.nav = nav

local ARRIVE     = 0.9   -- how close counts as standing on a waypoint
local REPATH     = 4.0   -- seconds before a path is considered stale
local STUCK_TIME = 2.5   -- seconds of no progress before we intervene
local STUCK_DIST = 0.35  -- progress threshold over that window
local MAX_LEG    = 22    -- engine pathfinder search radius per leg
local DOOR_REACH = 2.2   -- open doors from this far away
local DODGE_TIME = 0.9   -- how long a deflection is held before re-aiming
local ROUTE_LOST = 6.0   -- off a stored route by this much and it is abandoned
local VSTEP      = 1.1   -- vertical gap over which a waypoint is "above", not "here"
local CLIMB_MIN  = 0.5   -- vertical gap below which climbing is not worth engaging

-- The x,z centre of the climbable column the villager should be on -- the one
-- under foot if it is already on it, otherwise a rope in a cell right beside it
-- that it should step onto. Returns nil when no reachable column is in touch,
-- which is the case a rope hanging out of reach above the head falls into: there
-- is nothing to seat on, so the climb never engages and the stuck detector is
-- left to give the goal up rather than orbit it forever. Node coordinates are
-- cell centres, so the integer cell is exactly the point to aim the body at.
local function ladder_column(pos)
	local w = creaturemob.world
	if not (w and w.is_climbable) then return nil end
	local b = {x = math.floor(pos.x + 0.5), y = math.floor(pos.y + 0.5),
			z = math.floor(pos.z + 0.5)}
	-- Already on (or straddling) a column: feet cell, or the cell just above or
	-- below it. This is the common case once a climb is under way.
	for _, dy in ipairs({0, 1, -1}) do
		if w.is_climbable({x = b.x, y = b.y + dy, z = b.z}) then
			return {x = b.x, z = b.z}
		end
	end
	-- Not on one yet, but a rung is in the next cell over at foot or head height:
	-- the moment of stepping off the ground onto the rope. Seating onto it is what
	-- stops the villager ramming its shoulder into the rope instead of mounting it.
	for _, d in ipairs({{1, 0}, {-1, 0}, {0, 1}, {0, -1}}) do
		local cx, cz = b.x + d[1], b.z + d[2]
		if w.is_climbable({x = cx, y = b.y, z = cz})
				or w.is_climbable({x = cx, y = b.y + 1, z = cz}) then
			return {x = cx, z = cz}
		end
	end
	return nil
end

-- Let go of the climb axis so gravity takes over again. Cheap to call when we
-- were not climbing, so callers do not have to check first.
local function release_climb(self, s)
	if s.climbing then
		s.climbing = nil
		if creaturemob.motion then
			creaturemob.motion.set_vertical_velocity(self, nil)
		end
	end
end
nav.release_climb = release_climb

-- Horizontal unit vector from a to b, or nil if they are on top of each other.
local function heading(a, b)
	local dx, dz = b.x - a.x, b.z - a.z
	local len = math.sqrt(dx * dx + dz * dz)
	if len < 0.01 then return end
	return {x = dx / len, z = dz / len}
end

-- The brain needs this too, to aim the door-opening at the hand-over.
nav.heading = heading

--------------------------------------------------------------------------------
-- Goals
--------------------------------------------------------------------------------

-- opts:
--   speed      "walk" (default) or "run"
--   tolerance  arrival distance override
--   interior   an mg_villages stored path to append once we reach its start
--   route      an mg_villages stored path that *is* the whole leg. Walked as
--              given, with no pathfinder involved at all -- see below.
--   inside     a bpos whose footprint the mob must actually be standing in
--              before this goal counts as reached
--   tag        free-form label the brain uses to notice its goal changed
function nav.set_goal(self, pos, opts)
	if not pos then return end
	opts = opts or {}
	local s = util.scratch(self)
	local g = s.nav

	-- Re-issuing the same goal must not reset the path, or a brain that
	-- refreshes its goal every tick would never take a step.
	if g and g.tag == opts.tag and g.target
			and util.dist2(g.target, pos) < 1 then
		return
	end

	-- Abandon any search still in flight. pathfind.find_path resumes from a
	-- frozen frontier keyed on the *old* start, so letting one carry over into
	-- a new goal returns a route beginning where the mob used to be -- and the
	-- follower then walks backwards to reach the start of its own path.
	creaturemob.navigate.reset(self)
	s.dodge_until = nil

	s.nav = {
		target    = {x = pos.x, y = pos.y, z = pos.z},
		speed     = opts.speed or "walk",
		tolerance = opts.tolerance or ARRIVE,
		interior  = opts.interior,
		inside    = opts.inside,
		tag       = opts.tag,
		path      = nil,
		idx       = 1,
		age       = REPATH,   -- forces a path computation on the next tick
		stuck     = 0,
		arrived   = false,
	}

	-- A stored route is walked as handed over, and the pathfinder is never
	-- asked about this leg.
	--
	-- This is the whole reason villagers could not get indoors. A shut door is
	-- a `walkable` node, and creaturemob's `world.is_blocked` treats anything
	-- walkable as impassable -- so A* *cannot* find a route into a house whose
	-- door is closed. It reported "failed", build_path threw the path away, and
	-- nav.tick fell back to steering in a straight line at a bed on the far
	-- side of a wall. Meanwhile mg_villages had already solved this leg on the
	-- schematic, and that answer was only ever used as a suffix on a search
	-- that never succeeded.
	if opts.route and #opts.route > 0 then
		local route = {}
		for i = 1, #opts.route do
			local p = opts.route[i]
			route[i] = {x = p.x, y = p.y, z = p.z}
		end
		s.nav.route = route
		s.nav.path = route
		s.nav.age = 0
	end
end

function nav.clear(self)
	local s = util.scratch(self)
	release_climb(self, s)
	if s.nav then
		s.nav = nil
		self:set_velocity(0)
		self:set_animation("stand")
		self.state = "stand"
	end
end

function nav.has_goal(self)
	return util.scratch(self).nav ~= nil
end

--------------------------------------------------------------------------------
-- Path building
--------------------------------------------------------------------------------

-- The engine pathfinder only searches a box around the start, so a trip across
-- a village has to be walked in legs. Aim at a point some way along the
-- straight line and let the next leg pick up from there.
local function leg_target(from, to)
	local d = util.dist_flat(from, to)
	if d <= MAX_LEG then return to end
	local f = (MAX_LEG - 4) / d
	local p = {
		x = from.x + (to.x - from.x) * f,
		y = to.y,
		z = from.z + (to.z - from.z) * f,
	}
	-- Snap to something standable so we do not aim at mid-air over a slope.
	return util.find_standing_near(util.round_pos(p), 3) or util.round_pos(p)
end

local function build_path(self, g, pos)
	local from = util.round_pos(pos)
	local to = util.round_pos(leg_target(pos, g.target))

	-- creaturemob.navigate rather than core.find_path.
	--
	-- The engine pathfinder solves for a *point* and runs the whole search
	-- inside one step, so it had to be rationed -- and a rationed blocking
	-- pathfinder means most of a village gets no route at all and falls back to
	-- steering straight at the goal, which is walking into walls. The shared
	-- service is time-sliced (so it can be asked every step), knows how wide
	-- the mob is, smooths the staircase out of the result, and caches routes
	-- that the whole village reuses.
	local path, status = creaturemob.navigate.find_path(self, from, to)

	if not path then
		-- "searching" and "budget" both mean ask again next step. Keep the old
		-- path in the meantime rather than throwing it away: a stale route is
		-- far better than none.
		if status ~= "failed" then
			g.age = REPATH * 0.5
			return false
		end
		g.path = nil
		g.idx = 1
		return false
	end

	-- The service returns a shared, cached table. Copy before trimming it,
	-- or one villager's progress would eat the route out from under every
	-- other villager walking the same street.
	local copy = {}
	for i = 1, #path do copy[i] = path[i] end
	path = copy

	if #path == 0 then
		g.path = nil
		g.idx = 1
		return false
	end

	-- Drop leading waypoints we are already past.
	--
	-- A time-sliced search finishes several steps after it was asked, by which
	-- point the mob has walked on, so the route legitimately starts behind it.
	-- Trimming while the next waypoint is nearer than the current one is enough
	-- to fix that without skipping round a corner, which cutting to the
	-- globally nearest waypoint would do.
	while #path > 1 and util.dist_flat(pos, path[2]) < util.dist_flat(pos, path[1]) do
		table.remove(path, 1)
	end

	-- The vertical guard keeps a climb intact: the first rung of a rope sits
	-- directly overhead, horizontally ~0 away, so a flat-distance test alone would
	-- read it as "already past" and lop the bottom off the climb.
	if #path > 1 and util.dist_flat(pos, path[1]) < 0.6
			and math.abs(pos.y - path[1].y) < VSTEP then
		table.remove(path, 1)
	end

	-- The mg_villages interior path is authoritative for the last stretch --
	-- it was computed on the schematic and knows about the staircase the
	-- engine pathfinder will not squeeze a 0.7-wide collisionbox through.
	if g.interior then
		for _, p in ipairs(g.interior) do
			path[#path + 1] = {x = p.x, y = p.y, z = p.z}
		end
		g.interior = nil
	end

	g.path = path
	g.idx = 1
	g.age = 0
	return true
end

--------------------------------------------------------------------------------
-- Doors
--------------------------------------------------------------------------------

-- node name -> {open = f(pos, node, dir), close = f(pos, node, dir)}
-- Each returns true if it changed anything.
nav.openables = {}

-- The pathfinder (creaturemob) treats a door as a wall in every state, because
-- a door stays `walkable` when open. Telling it which nodes are openable lets a
-- door-capable mob (self.door_user) plan and walk through them; see
-- creaturemob/core/world.lua. Populated in lock-step with nav.openables.
local function mark_passable(name)
	if creaturemob and creaturemob.world and creaturemob.world.openable then
		creaturemob.world.openable[name] = true
	end
end

function village_life.register_openable(name, def)
	nav.openables[name] = def
	mark_passable(name)
end

-- The doors mod keeps a real open/closed state in node meta, so this is the
-- easy case. A nil clicker makes door_toggle skip its protection check, which
-- is what we want: a villager owns its own front door, and mg_villages'
-- protection has no concept of a mob.
local doors_openable = {
	open = function(pos)
		local d = doors.get(pos)
		if d and not d:state() then d:open(nil) return true end
	end,
	close = function(pos)
		local d = doors.get(pos)
		if d and d:state() then d:close(nil) return true end
	end,
}

-- cottages' half doors have no open/closed state to read: opening rotates
-- param2 by a quarter turn, and both states use the same node name. What can
-- be read is the *orientation* -- the door slab fills one face of its cell, so
-- the axis it blocks is the node's facedir axis.
--
-- So "is this in my way" is decided geometrically: if the slab's axis lies
-- along the direction I am walking, it is across the doorway and I need it
-- moved. facedir_to_dir may point either way along that axis depending on the
-- node's convention, which is why this compares the absolute dot product.
local function swing_blocks(node, dir)
	if not dir then return true end
	local n = minetest.facedir_to_dir(node.param2)
	if not n then return true end
	return math.abs(n.x * dir.x + n.z * dir.z) > 0.55
end

local function swing(pos, node)
	local def = minetest.registered_nodes[node.name]
	if not def or not def.on_rightclick then return end
	-- cottages ignores the clicker argument; passing nil avoids pretending a
	-- player did this.
	def.on_rightclick(pos, node, nil)
	return true
end

local swing_openable = {
	open = function(pos, node, dir)
		if swing_blocks(node, dir) then return swing(pos, node) end
	end,
	close = function(pos, node, dir)
		if not swing_blocks(node, dir) then return swing(pos, node) end
	end,
}

-- Gates are name-based, so they need no geometry.
local function named_openable(closed_name)
	return {
		open = function(pos, node)
			if node.name == closed_name then return swing(pos, node) end
		end,
		close = function(pos, node)
			if node.name ~= closed_name then return swing(pos, node) end
		end,
	}
end

minetest.register_on_mods_loaded(function()
	if minetest.global_exists("doors") and doors.registered_doors then
		for name in pairs(doors.registered_doors) do
			nav.openables[name] = doors_openable
			mark_passable(name)
		end
	end
	for _, name in ipairs({"cottages:half_door", "cottages:half_door_inverted"}) do
		if minetest.registered_nodes[name] then
			nav.openables[name] = swing_openable
			mark_passable(name)
		end
	end
	for _, pair in ipairs({{"cottages:gate_closed", "cottages:gate_open"}}) do
		if minetest.registered_nodes[pair[1]] then
			nav.openables[pair[1]] = named_openable(pair[1])
			nav.openables[pair[2]] = named_openable(pair[1])
			mark_passable(pair[1])
			mark_passable(pair[2])
		end
	end
end)

-- Find an openable adjacent to `pos`. Both halves of a two-node door are
-- registered, so searching one node up as well means we still find it when the
-- path waypoint sits at the upper half.
local function openable_near(pos)
	local bx = math.floor(pos.x + 0.5)
	local by = math.floor(pos.y + 0.5)
	local bz = math.floor(pos.z + 0.5)
	for dy = 0, 1 do
	for dx = -1, 1 do
	for dz = -1, 1 do
		local p = {x = bx + dx, y = by + dy, z = bz + dz}
		local node = minetest.get_node_or_nil(p)
		local def = node and nav.openables[node.name]
		if def then return p, node, def end
	end
	end
	end
end

-- `dir` is the villager's direction of travel, normalised on the horizontal.
-- It is what tells a stateless swing door whether it is across the way or
-- already flat against the wall.
function nav.open_door_near(pos, dir)
	local p, node, def = openable_near(pos)
	if p and def.open(p, node, dir) then return p, node end
end

-- `dir` is not optional in practice. A cottages half door has no open/closed
-- state, so `swing_openable.close` is `if not swing_blocks(node, dir)` -- and
-- `swing_blocks` returns *true* when dir is nil, on the reasoning that an
-- unknown heading might be blocked. Called without one, this could therefore
-- never close a half door at all, which is most of the doors in a village.
function nav.close_door_near(pos, dir)
	local p, node, def = openable_near(pos)
	if p and def.close(p, node, dir) then return p, node end
end

-- The way the mob is facing, as a horizontal unit vector. The fallback heading
-- for closing a door we have no record of opening.
local function facing(self)
	local yaw = self.object:get_yaw()
	if not yaw then return end
	local d = minetest.yaw_to_dir(yaw + (self.rotate or 0))
	return heading({x = 0, y = 0, z = 0}, {x = d.x, z = d.z})
end

--------------------------------------------------------------------------------
-- Doors we have opened and owe the village a closing of
--------------------------------------------------------------------------------

-- A queue, not a single slot.
--
-- It used to be one field, so a villager who went through their front door and
-- then a bedroom door lost the front door's record and left it standing open
-- all night. Small cap: past a handful the oldest is the one least likely to
-- still matter, and an unbounded list on a mob that never quite gets clear of
-- anything is a leak.
local MAX_PENDING = 4

function nav.note_opened(self, pos, dir)
	if not pos then return end
	local s = util.scratch(self)
	local list = s.doors_open
	if not list then list = {} ; s.doors_open = list end

	for _, e in ipairs(list) do
		-- Already ours. Refresh the heading -- we may be going through it the
		-- other way this time -- but do not queue it twice.
		if util.dist2(e.pos, pos) < 0.1 then
			e.dir = dir or e.dir
			e.at = util.now()
			return
		end
	end

	list[#list + 1] = {pos = {x = pos.x, y = pos.y, z = pos.z}, dir = dir,
			at = util.now()}
	if #list > MAX_PENDING then table.remove(list, 1) end
end

local function shut(entry, fallback_dir)
	local node = minetest.get_node_or_nil(entry.pos)
	local def = node and nav.openables[node.name]
	if not def then return true end   -- gone, or replaced: stop tracking it
	return def.close(entry.pos, node, entry.dir or fallback_dir) ~= nil
end

-- Shut everything now rather than waiting to be clear of it -- for a villager
-- that has just run inside away from something. Prefers the doors it actually
-- came through, because those records carry the heading a stateless swing door
-- needs in order to know which way is shut.
function nav.bar_door(self, pos)
	local s = util.scratch(self)
	local list = s.doors_open
	local dir = facing(self)
	local any = false

	if list then
		for i = #list, 1, -1 do
			if shut(list[i], dir) then any = true end
			list[i] = nil
		end
		s.doors_open = nil
	end

	if any then return true end
	return nav.close_door_near(pos, dir) ~= nil
end

--------------------------------------------------------------------------------
-- The follower
--------------------------------------------------------------------------------

-- Shut the door behind you.
--
-- Deliberately not done the moment we step through: the villager is still
-- standing in the doorway, and a door closed on the spot either does nothing
-- or shuts in the face of whoever is following. Wait until we are clear of it,
-- or until enough time has passed that we have plainly stopped somewhere.
local CLOSE_DISTANCE = 3.2
local CLOSE_TIMEOUT = 12

local function service_doors(self, pos)
	local s = util.scratch(self)
	local list = s.doors_open
	if not list or #list == 0 then return end

	local now = util.now()
	local dir = facing(self)
	for i = #list, 1, -1 do
		local e = list[i]
		if util.dist(pos, e.pos) > CLOSE_DISTANCE
				or now - e.at > CLOSE_TIMEOUT then
			-- A stateless half door needs a heading to know which way is shut;
			-- an entry with no recorded direction (dir=nil) could otherwise never
			-- be closed. Fall back to the way the villager is now facing, exactly
			-- as bar_door does.
			shut(e, dir)
			table.remove(list, i)
		end
	end
	if #list == 0 then s.doors_open = nil end
end

-- Exposed so the brain can service a mob's owed doors on the paths that return
-- before nav.tick -- a guard or a hired companion, who would otherwise leave
-- every door they opened standing open.
nav.service_doors = service_doors

-- Returns one of:
--   nil        no goal
--   "moving"   under way
--   "arrived"  standing on the goal (the goal is cleared)
--   "blocked"  could not reach it and gave up (the goal is cleared)
function nav.tick(self, dtime)
	local s = util.scratch(self)

	local pos = self.object:get_pos()
	if not pos then return end

	-- Runs whether or not there is a goal: a villager that arrives just inside
	-- its own front door has no goal any more, and that is exactly the moment
	-- the door needs shutting.
	service_doors(self, pos)

	local g = s.nav
	if not g then return end

	-- Arrived?
	--
	-- An indoor goal also has to be reached from *inside*. The distance test
	-- alone counts a villager standing outside the wall, 1.5 nodes from their
	-- own bed on the other side of it, as having gone to bed -- the goal
	-- completed, the door was never opened, and "go indoors" silently did
	-- nothing at all. Failing the test instead lets the stuck handler open the
	-- door, and eventually lets the goal be reported blocked so the brain can
	-- pick something the villager can actually do.
	if util.dist_flat(pos, g.target) <= g.tolerance
			and math.abs(pos.y - g.target.y) < 2
			and (not g.inside or util.inside_plot(pos, g.inside)) then
		release_climb(self, s)
		s.nav = nil
		self:set_velocity(0)
		self.state = "stand"
		self:set_animation("stand")
		return "arrived"
	end

	g.age = g.age + dtime

	-- Progress / stuck accounting. A villager wedged on a fence post used to
	-- be indistinguishable from one standing still on purpose.
	if g.last then
		if util.dist(pos, g.last) < STUCK_DIST then
			g.stuck = g.stuck + dtime
		else
			g.stuck = 0
		end
	end
	g.last = {x = pos.x, y = pos.y, z = pos.z}

	-- Orbit accounting. A villager circling a point it cannot reach -- a rope that
	-- hangs too high to grab, most often -- keeps moving, so the wedged test above
	-- never trips. Track the closest it has actually come to the goal; while it
	-- keeps beating that, it is making progress, but a long spell of moving
	-- without ever getting nearer is orbiting, and the goal is effectively out of
	-- reach. More patient than the wedged timer so an honest detour round an
	-- obstacle (which loses ground before it gains) is not mistaken for it.
	local to_goal = util.dist(pos, g.target)
	if not g.closest or to_goal < g.closest - 0.5 then
		g.closest = to_goal
		g.orbit = 0
	else
		g.orbit = (g.orbit or 0) + dtime
	end

	if g.stuck > STUCK_TIME or (g.orbit or 0) > STUCK_TIME * 3 then
		g.stuck = 0
		g.orbit = 0
		g.age = REPATH          -- force a fresh path
		g.attempts = (g.attempts or 0) + 1
		-- A shut door is the usual culprit. Aim the "is it in my way" test at
		-- the waypoint we are trying to reach, or at the goal if we have no
		-- path at all.
		--
		-- Whatever this opens has to be recorded, or it is never shut again.
		-- That omission was the entire "villagers leave doors open" complaint:
		-- this was the only code path that ever opened a front door, because
		-- the one below needs a waypoint within reach and a villager grinding
		-- against a wall has no path and so no waypoints.
		local ahead = (g.path and g.path[g.idx]) or g.target
		local dir = heading(pos, ahead)
		local opened = nav.open_door_near(pos, dir)
		if opened then nav.note_opened(self, opened, dir) end
		if g.attempts > 3 then
			-- Three failures in a row means the destination is genuinely
			-- unreachable (a bed behind a player-built wall, a workplace
			-- buried by mapgen). Give up so the brain can choose something
			-- else instead of grinding the pathfinder forever.
			release_climb(self, s)
			s.nav = nil
			self:set_velocity(0)
			self.state = "stand"
			return "blocked"
		end
	end

	-- A stored route is authoritative and is not re-searched. It threads a
	-- doorway and a staircase that the pathfinder cannot solve while the door
	-- is shut, so "the path is stale, get a fresh one" would replace the only
	-- answer that works with no answer at all.
	--
	-- It is abandoned only when the villager is plainly no longer on it --
	-- shoved off by a neighbour, or dropped through a hole somebody dug. What
	-- is left of it becomes an `interior` suffix, so A* only has to solve the
	-- reconnection and the rest of the house is still walked as stored.
	if g.route then
		local wp = g.route[g.idx]
		if not wp or g.idx > #g.route then
			g.route = nil
		elseif util.dist(pos, wp) > ROUTE_LOST then
			local tail = {}
			for i = g.idx, #g.route do tail[#tail + 1] = g.route[i] end
			g.route = nil
			g.path = nil
			g.idx = 1
			g.interior = tail
			g.age = REPATH
		end
	end

	if not g.route and (not g.path or g.idx > #g.path or g.age >= REPATH) then
		build_path(self, g, pos)
	end

	-- A waypoint counts as reached only when we are near it on *both* axes. The
	-- vertical test is what makes a climb work: a rope route is a stack of
	-- waypoints all at the same x,z, so a purely horizontal "close enough" would
	-- mark every rung above us as already reached and skip the whole climb in one
	-- step. On level ground the vertical gap is ~0, so this changes nothing there.
	local function reached(p)
		return util.dist_flat(pos, p) < ARRIVE and math.abs(pos.y - p.y) < VSTEP
	end

	local wp
	if g.path and g.idx <= #g.path then
		-- Skip waypoints we are already past, which happens after a jump or
		-- a shove from another villager.
		while g.idx < #g.path and reached(g.path[g.idx]) do
			g.idx = g.idx + 1
		end
		wp = g.path[g.idx]
		if wp and reached(wp) then
			g.idx = g.idx + 1
			wp = g.path[g.idx]
		end
	end

	-- No path: steer straight at the goal. Villages are mostly open ground
	-- and mobs redo's do_jump (which runs before do_custom every quarter
	-- second) clears the fences and steps on its own.
	wp = wp or g.target

	-- Climbing. A waypoint well above or below us, with a ladder or rope under
	-- foot, means the route goes up or down a column the ground gait cannot walk.
	-- Drive the vertical axis by hand and ease in against the rungs, then release
	-- the moment we are level -- leaving it engaged would hold the villager
	-- pinned to the rope, and releasing it lets gravity settle them onto the lip.
	if self.can_climb and creaturemob.motion then
		local dy = wp.y - pos.y
		local col = ladder_column(pos)
		if math.abs(dy) > CLIMB_MIN and col then
			local climb = self.climb_velocity or 2
			creaturemob.motion.set_vertical_velocity(self, dy > 0 and climb or -climb)
			s.climbing = true
			self.state = "walk"
			-- A long climb is slow horizontal progress by construction; don't let
			-- the stuck (or orbit) detector read it as wedged and drop the goal.
			g.stuck = 0
			g.orbit = 0
			g.attempts = 0
			-- Seat on the rope column, NOT on the waypoint. A climb waypoint that
			-- sits up-and-over (the top of the rope, or the goal beyond it) would
			-- otherwise have the villager drive horizontally into the rope while
			-- trying to rise -- the "mashing into it" you saw. Aim the body at the
			-- column's centre instead: ease onto it when off, and once centred put
			-- all of the motion into the vertical and climb straight up.
			local off = math.abs(pos.x - col.x) + math.abs(pos.z - col.z)
			if off > 0.25 then
				self:yaw_to_pos({x = col.x, y = pos.y, z = col.z}, 0, 3)
				self:set_velocity((self.walk_velocity or 1) * 0.4)
			else
				self:set_velocity(0)
			end
			self:set_animation("walk")
			return "moving"
		end
		release_climb(self, s)
	end

	-- yaw_to_pos, not a hand-rolled atan2: it uses core.dir_to_yaw and also
	-- subtracts the mob's own `rotate` offset, which the motion controller
	-- adds back when it derives the velocity vector.
	local speed = g.speed == "run" and (self.run_velocity or 2)
			or (self.walk_velocity or 1)
	self.state = "walk"  -- do_jump refuses to fire while state is "stand"

	-- Local avoidance.
	--
	-- Even a good route leaves gaps: the mob gets shoved off it by a
	-- neighbour, or is walking straight at the goal because the search has not
	-- finished. Probing the width of the body ahead and turning is what makes
	-- the difference between grinding against a wall and walking round it.
	--
	-- The deflection has to be *committed to*. Setting a dodge heading and
	-- then steering back at the waypoint on the next step -- which is what
	-- happens when the yaw is rewritten every step, as it was -- means the mob
	-- never actually turns away from the wall. It has to hold the new heading
	-- long enough to clear the obstacle.
	local now = util.now()
	local dodging = s.dodge_until ~= nil and now < s.dodge_until

	if not dodging and util.every(self, "avoid", 0.25, dtime) then
		local dir = heading(pos, wp)
		if dir and not creaturemob.navigate.clear_ahead(self, dir) then
			-- do_smart_path also refuses ledges, so try it first; fall back to
			-- a pure clearance sidestep when it sees nothing wrong.
			local yaw = minetest.dir_to_yaw({x = dir.x, y = 0, z = dir.z})
			local dodge_yaw = self:do_smart_path(yaw)

			if not dodge_yaw then
				local away = creaturemob.navigate.sidestep(self, dir)
				if away then
					dodge_yaw = minetest.dir_to_yaw({x = away.x, y = 0, z = away.z})
				end
			end

			if dodge_yaw then
				self:set_yaw(dodge_yaw - (self.rotate or 0), 3)
				s.dodge_until = now + DODGE_TIME
				dodging = true
				-- Whatever route we were on does not survive contact with this
				-- wall; get a fresh one as soon as the budget allows.
				g.age = REPATH
			end
		end
	end

	if not dodging then
		-- yaw_to_pos, not a hand-rolled atan2: it uses core.dir_to_yaw and
		-- also subtracts the mob's own `rotate` offset, which the motion
		-- controller adds back when it derives the velocity vector.
		self:yaw_to_pos(wp, 0, 2)
	end

	self:set_velocity(speed)
	self:set_animation(g.speed == "run" and "run" or "walk")

	-- Reach for doors just before we hit them rather than after we are stuck.
	-- Throttled: openable_near is up to eighteen get_node calls, and this runs
	-- for every moving villager on every step.
	if util.dist_flat(pos, wp) < DOOR_REACH
			and util.every(self, "door", 0.5, dtime) then
		local dir = heading(pos, wp)
		local opened = nav.open_door_near(wp, dir)
		if opened then
			-- Remember it so we can shut it once we are through. The heading
			-- is stored too: a swing door has no open/closed state of its own,
			-- so closing it later means knowing which way we went through.
			nav.note_opened(self, opened, dir)
		end
	end

	return "moving"
end

--------------------------------------------------------------------------------
-- Small helpers the brains use
--------------------------------------------------------------------------------

-- Face the way a facedir param2 points. mg_villages' workplace markers carry
-- one, and it is how a shopkeeper ends up looking over the counter rather than
-- at the wall behind it.
function nav.face_facedir(self, p2)
	if not p2 then return end
	local dir = minetest.facedir_to_dir(p2 % 4)
	if not dir then return end
	self:set_yaw(minetest.dir_to_yaw(dir) - (self.rotate or 0), 4)
end

function nav.idle(self, anim)
	self:set_velocity(0)
	self.state = "stand"
	self:set_animation(anim or "stand")
end

-- A random point to loiter at, biased to stay inside `radius` of `anchor`.
function nav.wander_target(anchor, radius)
	local a = math.random() * math.pi * 2
	local r = radius * (0.35 + math.random() * 0.65)
	local p = util.round_pos({
		x = anchor.x + math.cos(a) * r,
		y = anchor.y,
		z = anchor.z + math.sin(a) * r,
	})
	return util.find_standing_near(p, 3) or p
end
