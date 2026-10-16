-- Village defence: guards, soldiers and buff pigmen.
--
-- mg_villages already hands out `guard` and `soldier` titles -- towers get a
-- guard, castle-type buildings fill every bed with soldiers -- but they were
-- the same peaceful trader entity as the baker, so a tower guard was a
-- shopkeeper standing in a tower. brain.lua gives them combat stats; this
-- module gives them a beat to walk and something to run towards.
--
-- zombies:buffpig is already a competent bodyguard (attack_monsters, and a
-- group_attack list that includes the villagers). Its problem is that it has no
-- idea where the village is: it spawns on a road, wanders off on the mobs redo
-- random walk, and is three hundred nodes away when something eats the baker.
-- Its ambient spawn rule is left exactly as it is; what is added here is an
-- anchor, a patrol and an ear for the alarm.

local util    = village_life.util
local home    = village_life.home
local nav     = village_life.nav
local threats = village_life.threats

local defence = {}
village_life.defence = defence

local BUFFPIG = "zombies:buffpig"

-- How far a defender will chase before breaking off and going home. Without
-- this a guard follows one zombie over the horizon and the village is
-- undefended for the rest of the night.
local LEASH = 40

--------------------------------------------------------------------------------
-- Patrol routes
--------------------------------------------------------------------------------

-- village_id -> ordered list of positions along the village's roads
defence.routes = {}

-- Sample patrol points from the road plots mg_villages laid out, so defenders
-- walk the streets rather than cutting across gardens. Falls back to a ring
-- around the centre for villages too small to have roads (single houses, and
-- the MINIMAL_BUILDUNGS_FOR_ROAD_PLACEMENT cutoff).
function defence.route(village_id)
	local cached = defence.routes[village_id]
	if cached then return cached end

	local village = home.village(village_id)
	if not village or not village.to_add_data then return end

	local bpos_list = village.to_add_data.bpos
	local points = {}

	local ok, roads = pcall(mg_villages.get_road_list, village_id, false)
	if ok and roads then
		for _, plot_nr in pairs(roads) do
			local bpos = bpos_list[plot_nr]
			if bpos then
				local sx, sz = bpos.bsizex or 1, bpos.bsizez or 1
				-- One point every few nodes along the road's long axis.
				local steps = math.max(1, math.floor(math.max(sx, sz) / 6))
				for i = 0, steps do
					local f = steps > 0 and (i / steps) or 0.5
					points[#points + 1] = {
						x = math.floor(bpos.x + (sx > sz and sx * f or sx / 2)),
						y = bpos.y,
						z = math.floor(bpos.z + (sz >= sx and sz * f or sz / 2)),
					}
				end
			end
		end
	end

	if #points < 3 then
		local c = home.village_centre(village)
		local radius = math.max(10, (village.vs or 24) * 0.6)
		for i = 0, 7 do
			local a = i * math.pi / 4
			points[#points + 1] = {
				x = math.floor(c.x + math.cos(a) * radius),
				y = c.y,
				z = math.floor(c.z + math.sin(a) * radius),
			}
		end
	end

	defence.routes[village_id] = points
	return points
end

-- The next stop on the beat. Each defender keeps its own index, seeded from
-- its position so two guards leaving the same tower do not walk in lockstep.
local function next_post(self, village_id)
	local route = defence.route(village_id)
	if not route or #route == 0 then return end
	local s = util.scratch(self)
	s.post = (s.post or math.random(#route)) % #route + 1
	local p = route[s.post]
	return util.find_standing_near(p, 4) or p
end

--------------------------------------------------------------------------------
-- Shared defender logic
--------------------------------------------------------------------------------

-- Seconds of enforced disinterest after a recall. Without it the defender
-- drops its target, takes one step homeward, re-acquires the same monster
-- (still well inside view_range) and oscillates on the leash boundary.
local RECALL_COOLDOWN = 8

-- Break off a pursuit that has gone too far from home and walk back.
local function leash(self, anchor)
	local pos = self.object:get_pos()
	if not pos or not anchor then return false end
	if util.dist_flat(pos, anchor) <= LEASH then return false end
	if self.stop_attack then self:stop_attack() end
	local s = util.scratch(self)
	s.recall_until = util.now() + RECALL_COOLDOWN
	nav.set_goal(self, anchor, {speed = "run", tolerance = 6, tag = "recall"})
	return true
end

local function recalling(self)
	local s = util.scratch(self)
	return s.recall_until ~= nil and s.recall_until > util.now()
end

-- Common body for guards and buff pigmen. `anchor` is the village centre,
-- `village_id` may be nil for a buff pigman that spawned in the wilderness.
--
-- `mode` selects who this is:
--   nil / "guard"  full-time defender: answers the alarm and walks a beat.
--   "escort"       a guard hired by a player: acquires and fights, but does not
--                  answer the village alarm (they left it) and does not patrol.
--   "rouse"        a leader, or an ordinary villager roused by being attacked:
--                  answers the alarm and fights, but does not patrol -- when
--                  there is nothing to fight it returns false so their ordinary
--                  day (or the companion goal) takes the step instead.
local function defender_step(self, dtime, village_id, anchor, mode)
	local escort = mode == "escort"
	local no_patrol = escort or mode == "rouse"
	local pos = self.object:get_pos()
	if not pos then return false end

	-- Standing in liquid: hand the step back so mobs redo's runaway_from and
	-- flop handling can get us out. Buff pigmen declare runaway_from
	-- {"group:water"} and float = 0, and both of those live in the
	-- once-a-second block that returning false skips.
	local in_node = self.standing_in and minetest.registered_nodes[self.standing_in]
	if in_node and in_node.groups and (in_node.groups.water or in_node.groups.lava) then
		nav.clear(self)
		return nil
	end

	-- Already fighting: hand the step back to mobs redo, whose combat FSM is
	-- perfectly good, but keep the leash on.
	if self.state == "attack" then
		if leash(self, anchor) then return false end
		return nil
	end

	-- We return false below, which skips on_step's one-second block --
	-- including general_attack(). Run target acquisition ourselves so
	-- defenders still notice things walking past them.
	if not recalling(self) and util.every(self, "acquire", 1, dtime) then
		-- A player the village has written off is a target like any other.
		-- Deliberately checked before general_attack, which will not consider
		-- players for a mob that does not set attack_players.
		local enemy = village_life.reputation.enemy_near(village_id, pos,
				self.view_range or 16)
		if enemy and self.do_attack then
			self:do_attack(enemy)
			return nil
		end

		if self.general_attack then
			self:general_attack()
			if self.state == "attack" then return nil end
		end
	end

	-- An escort answers only what it can see. A village alarm is somebody
	-- else's business once you have walked out of the village, and running
	-- back to it is the opposite of what you are being paid for.
	local alarm = (not escort) and village_id and threats.alarm(village_id)
	local threat = threats.nearest(pos, self.view_range or 16)
	local target = not recalling(self)
			and ((threat and threat.pos) or (alarm and alarm.pos))

	if target then
		-- Retarget on a timer, not every step. A monster moves a little each
		-- frame, so an unthrottled set_goal here would re-issue the goal
		-- constantly, and every re-issue discards the path and resets the
		-- stuck accounting -- the defender would never build up enough
		-- evidence to notice it was jammed against a wall.
		if not nav.has_goal(self) or util.every(self, "respond", 1, dtime) then
			nav.set_goal(self, target,
					{speed = "run", tolerance = 2.5, tag = "respond"})
		end
	elseif no_patrol then
		-- Nothing to fight. Say so, and let the companion goal or the ordinary
		-- schedule have the step instead of walking a beat.
		return false

	elseif not nav.has_goal(self) then
		-- Nothing doing: walk the beat. The pause between posts is what makes
		-- a patrol read as a patrol rather than a treadmill.
		if util.every(self, "patrol", 5 + math.random() * 7, dtime) then
			local post = village_id and next_post(self, village_id)
			if post then
				nav.set_goal(self, post, {speed = "walk", tolerance = 2, tag = "patrol"})
			elseif anchor then
				nav.set_goal(self, nav.wander_target(anchor, 14),
						{speed = "walk", tag = "patrol"})
			end
		else
			nav.idle(self)
		end
	end

	local status = nav.tick(self, dtime)
	if status == "blocked" then
		nav.clear(self)
	end

	return false
end

-- A guard who is working for a player rather than for their village. The leash
-- is the player, not the village square -- a bodyguard who breaks off at forty
-- nodes from a town they left this morning is no bodyguard at all.
--
-- Returns what defender_step returned: nil hands the step to mobs redo's combat
-- FSM, false means there is nothing to fight and the caller should carry on.
function defence.escort_step(self, r, dtime, anchor)
	-- r is nil for a bedless adventurer companion -- they have no village to
	-- answer an alarm for, which the escort mode wants anyway.
	return defender_step(self, dtime, r and r.village_id, anchor, "escort")
end

-- A leader (major/landlord), or an ordinary villager roused by being struck,
-- fights when there is something to fight and otherwise gets on with its day.
-- Returns engaged, result:
--   engaged=false           nothing to fight; the caller runs the normal schedule
--   engaged=true, result    result is defender_step's: false = walking to the
--                           target under nav control, nil = handed to the combat FSM
function defence.rouse_step(self, r, dtime, anchor)
	local pos = self.object:get_pos()
	if not pos then return false end

	local engaged = self.state == "attack"
			or threats.nearest(pos, self.view_range or 12)
			or (r.village_id and threats.alarm(r.village_id))
	if not engaged then return false end

	return true, defender_step(self, dtime, r.village_id, anchor, "rouse")
end

--------------------------------------------------------------------------------
-- Guards and soldiers
--------------------------------------------------------------------------------

-- Called from brain.step for villagers whose role resolved to "guard".
-- brain.step only routes here while village_life_defence is on; with it off a
-- guard is scheduled like any other worker and stands at its tower marker.
function defence.guard_step(self, r, dtime)
	if util.every(self, "roster", 5, dtime) then
		home.check_in(self)
	end

	local anchor = r.centre or r.plot_centre
	local result = defender_step(self, dtime, r.village_id, anchor)
	if result ~= false then return result end

	-- Off duty and unbothered: a guard whose beat has brought it back to its
	-- own tower faces the way the workplace marker points, so it looks out
	-- over the wall rather than at it.
	if not nav.has_goal(self) and r.work_pos and r.work_facing then
		local pos = self.object:get_pos()
		if pos and util.dist_flat(pos, r.work_pos) < 6 then
			nav.face_facedir(self, r.work_facing)
		end
	end

	return false
end

--------------------------------------------------------------------------------
-- Buff pigmen
--------------------------------------------------------------------------------

-- A buff pigman remembers the village it belongs to. Bound once, on the first
-- step after it activates, from whichever village it is standing in -- which
-- is the one the ambient spawn rule placed it in, because that rule only fires
-- on mg_villages road and plotmarker nodes.
local function buffpig_village(self)
	local s = util.scratch(self)
	if s.village_checked then
		return s.village_id, s.anchor
	end

	local pos = self.object:get_pos()
	if not pos then return end

	-- Persisted on the entity so a pigman that unloads on patrol still knows
	-- where home is when it comes back.
	if self.vl_village then
		local village = home.village(self.vl_village)
		if village then
			s.village_id = self.vl_village
			s.anchor = home.village_centre(village)
			s.village_checked = true
			return s.village_id, s.anchor
		end
	end

	local village, vid = home.village_at(pos, 48)
	if village then
		self.vl_village = vid
		s.village_id = vid
		s.anchor = home.village_centre(village)
	end
	s.village_checked = true
	return s.village_id, s.anchor
end

function defence.buffpig_step(self, dtime)
	-- A recruited champion -- settled into a player town, or hired to follow you --
	-- lives by the villager brain (its schedule, or the follow path), not the
	-- village-champion patrol. This is the on-ramp that lets a buff pigman be
	-- talked into joining a town like any other recruit.
	if home.is_villager(self)
			or (village_life.companion and village_life.companion.hired_by(self)) then
		return village_life.brain.step(self, dtime)
	end

	if not village_life.settings.defence then return end

	local village_id, anchor = buffpig_village(self)
	if not village_id then
		-- Spawned outside any village (a spawn egg, or a road plot whose
		-- village data has been forgotten). Leave mobs redo in charge.
		return
	end

	-- A bound champion patrols the village, so let the pathfinder route it
	-- through the village's doors like any other defender (see world.lua), and up
	-- a ladder or rope like any other villager (see navigate.lua).
	self.door_user = true
	self.can_climb = true

	return defender_step(self, dtime, village_id, anchor)
end

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	local proto = minetest.registered_entities[BUFFPIG]
	if not proto then
		village_life.log("info", BUFFPIG .. " not registered; no heavy defenders")
		return
	end

	proto.do_custom = defence.buffpig_step

	-- A champion is a defender the village counts on: never let it despawn.
	proto.persistent = true

	-- Buff pigmen already retaliate; this only teaches the classifier about
	-- attackers it did not recognise, and puts the village on alert when one
	-- of its guardians is being hit.
	local prev_punch = proto.do_punch
	proto.do_punch = function(self, hitter, tflp, tool_caps, dir)
		-- A recruited champion that has settled reacts as a villager (rousing, and
		-- leaving a body that releases its bed) rather than as a bound guardian.
		if home.is_villager(self) then
			return village_life.brain.villager_punch(self, hitter, tflp,
					tool_caps, dir, prev_punch)
		end
		threats.note_attacker(self, hitter)
		if village_life.settings.reputation then
			-- A buff pigman has no bed, so give it the village it is bound to.
			village_life.reputation.on_villager_hurt(self, hitter)
		end
		if prev_punch then return prev_punch(self, hitter, tflp, tool_caps, dir) end
	end

	local prev_die = proto.on_die
	proto.on_die = function(self, pos)
		if home.is_villager(self) then
			return village_life.brain.villager_die(self, pos, prev_die)
		end
		if village_life.settings.reputation then
			local killer = self.cause_of_death and self.cause_of_death.puncher
			if killer and killer.is_player and killer:is_player() then
				village_life.reputation.on_villager_killed(self,
						killer:get_player_name(), true)
			end
		end
		if prev_die then return prev_die(self, pos) end
	end

	village_life.log("action", "defender behaviour attached to " .. BUFFPIG)
end)
