-- The villager brain.
--
-- Attached to the already-registered lottmobs:pigman_trader prototype rather
-- than baked into its definition, because core.register_entity uses the
-- prototype as the instances' metatable: writing do_custom here reaches every
-- villager already standing in a village, including ones loaded from mapblocks
-- saved before this mod existed.
--
-- do_custom returns false whenever we are driving, which makes on_step skip
-- do_states(), general_attack(), follow_flop() and the rest of the mobs redo
-- FSM. That is deliberate and total: the random-walk state is precisely what
-- made villagers wander into the wilderness and die.

local util     = village_life.util
local home     = village_life.home
local nav      = village_life.nav
local schedule = village_life.schedule
local threats  = village_life.threats

local brain = {}
village_life.brain = brain

local MOB = "lottmobs:pigman_trader"

--------------------------------------------------------------------------------
-- Work flavour
--------------------------------------------------------------------------------

-- Per-profession working sound and particle, so a forge sounds like a forge.
-- Only sounds shipped by `default` are used; a missing file is a silent
-- warning on every swing otherwise.
local WORK_FLAVOUR = {
	smith        = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	blacksmith   = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	coppersmith  = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	bronzesmith  = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	tinsmith     = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	goldsmith    = {sound = "default_dig_metal",   particle = "fire_basic_flame.png", heat = true},
	stonemason   = {sound = "default_dig_cracky",  particle = "default_stone.png"},
	bricklayer   = {sound = "default_dig_cracky",  particle = "default_stone.png"},
	potterer     = {sound = "default_dig_crumbly", particle = "default_clay.png"},
	carpenter    = {sound = "default_dig_choppy",  particle = "default_wood.png"},
	lumberjack   = {sound = "default_dig_choppy",  particle = "default_wood.png"},
	["sawmill owner"] = {sound = "default_dig_choppy", particle = "default_wood.png"},
	baker        = {sound = "default_place_node",  particle = "farming_wheat.png", heat = true},
	miller       = {sound = "default_dig_crumbly", particle = "farming_flour.png"},
	farmer       = {sound = "default_dig_crumbly", particle = "default_dirt.png"},
	charachoal   = {sound = "default_place_node",  particle = "fire_basic_flame.png", heat = true},
	["charachoal burner"] = {sound = "default_place_node", particle = "fire_basic_flame.png", heat = true},
	glassmaker   = {sound = "default_dig_cracky",  particle = "fire_basic_flame.png", heat = true},
	roofer       = {sound = "default_place_node_hard"},
	default      = {sound = "default_place_node"},
}

local function flavour_for(title)
	return (title and WORK_FLAVOUR[title]) or WORK_FLAVOUR.default
end

local EMOTE_TIME = 0.8  -- how long the punch animation is held

-- One swing of whatever the villager is holding: a punch animation, a sound
-- and a puff of the right stuff. Costs nothing when nobody is watching,
-- because mobs only step near players.
--
-- The animation is held by a timer in the work branch below rather than reset
-- from a core.after callback: the work branch calls nav.idle() every step,
-- which sets the stand animation, so a callback-based reset would be racing
-- something that wins on the very next step.
local function work_emote(self, r)
	local pos = self.object:get_pos()
	if not pos then return end
	local f = flavour_for(r.title)

	self:set_animation("punch", true)
	util.scratch(self).emote_until = util.now() + EMOTE_TIME

	if f.sound then
		minetest.sound_play(f.sound,
				{pos = pos, gain = 0.35, max_hear_distance = 12}, true)
	end

	if f.particle then
		minetest.add_particlespawner({
			amount = f.heat and 6 or 4,
			time = 0.6,
			minpos = {x = pos.x - 0.3, y = pos.y + 1.0, z = pos.z - 0.3},
			maxpos = {x = pos.x + 0.3, y = pos.y + 1.4, z = pos.z + 0.3},
			minvel = {x = -0.2, y = 0.4, z = -0.2},
			maxvel = {x = 0.2, y = 1.2, z = 0.2},
			minacc = {x = 0, y = f.heat and 0.6 or -1.2, z = 0},
			maxacc = {x = 0, y = f.heat and 1.2 or -0.6, z = 0},
			minexptime = 0.4,
			maxexptime = 1.1,
			minsize = 0.6,
			maxsize = 1.6,
			texture = f.particle,
			glow = f.heat and 8 or 0,
		})
	end
end

--------------------------------------------------------------------------------
-- Turning a goal into movement
--------------------------------------------------------------------------------

-- Indoor goals are walked in two stages: out on the street to the spot in
-- front of the door, then along mg_villages' stored interior path. The engine
-- pathfinder is not reliable at threading a 0.7-wide collisionbox through a
-- doorway and up a staircase, and mg_villages already solved that problem on
-- the schematic when the building was registered.
--
-- It is worse than unreliable, in fact: a shut door is a `walkable` node and so
-- impassable to the search, which means the route into a house *cannot* be
-- found while the door is closed. The stored path is not an optimisation, it is
-- the only thing that works.
--
-- Which stage to start on is therefore decided by where the villager is
-- standing, not by how far off the destination is. This test used to be
-- `dist(pos, goal.pos) > 15`, which had it exactly backwards: it took the
-- careful two-stage route only from a distance, and sent everyone already near
-- their own house -- which is every `shelter` and `indoors` goal, and every
-- villager whose leisure anchor is their own plot -- straight at a bed through
-- a wall. Near is the case that needs the door most.
local function start_stage(self, r, goal, pos)
	if not goal.indoor then return "final" end
	local bpos = schedule.goal_plot(r, goal)
	if bpos and util.inside_plot(pos, bpos) then return "final" end
	return "approach"
end

-- Open whatever stands between the doorstep and the first few interior
-- waypoints, and record it so it gets shut again. Doing this at the hand-over
-- rather than leaving it to nav.tick's per-step check means the villager walks
-- up to the door and opens it, instead of arriving at it and stopping dead
-- until the throttled check comes round.
local function open_the_door(self, pos, route)
	if not route then return end
	local from = pos
	for i = 1, math.min(3, #route) do
		local wp = route[i]
		local dir = nav.heading(from, wp)
		local opened = nav.open_door_near(wp, dir)
		if opened then nav.note_opened(self, opened, dir) end
		from = wp
	end
end

local function apply_goal(self, r, goal)
	local s = util.scratch(self)
	local pos = self.object:get_pos()
	if not pos then return end

	-- Out of bed before anything else: a sleeper is lying on the mattress
	-- holding a pose, and neither the pose nor the pretence of sleep survives
	-- being asked to walk somewhere. Morning, a raid and a storm all arrive
	-- through here.
	if s.abed and (not goal or goal.kind ~= "sleep") then
		village_life.rest.rise(self)
	end

	s.goal = goal
	s.barred = nil
	if not goal then
		nav.clear(self)
		return
	end

	-- Loitering goals have no fixed destination; the activity handler picks
	-- wander targets as it goes. Drop whatever we were walking to, or a
	-- villager told to knock off for the day would carry on to the forge
	-- first.
	if goal.anchor then
		s.stage = nil
		nav.clear(self)
		return
	end

	if not goal.pos then return end

	local tag = goal.kind

	if start_stage(self, r, goal, pos) == "approach" then
		local approach = schedule.approach_pos(r, goal)
		if approach then
			s.stage = "approach"
			s.stage_goal = goal
			nav.set_goal(self, approach, {
				speed = goal.speed,
				tolerance = 1.4,
				tag = tag .. ":approach",
			})
			return
		end
	end

	-- Already inside, or there is no stored path to approach along.
	s.stage = "final"
	s.stage_goal = goal

	-- No stored path is handed to nav here. If we are already standing in the
	-- room, the stored path begins out on the street and would walk us back out
	-- the front door to reach a bed we are beside; the interior is open ground
	-- the pathfinder solves on its own. If we are outside with no stored path,
	-- the pathfinder can now route through the door itself, because a villager
	-- is a door_user (see creaturemob/core/world.lua) and the per-step opener
	-- lets it through. So only open a door up-front when we are outside with an
	-- interior route to thread through it -- opening the street-side door from
	-- inside just leaves it banging.
	local bpos = goal.indoor and schedule.goal_plot(r, goal)
	local already_inside = bpos and util.inside_plot(pos, bpos)
	local route = goal.indoor and not already_inside
			and schedule.interior_path(r, goal) or nil
	open_the_door(self, pos, route)
	nav.set_goal(self, goal.pos, {
		speed = goal.speed,
		-- Indoor destinations are a bed or a workplace marker: the mob stands
		-- *beside* them, not on them, and on a cramped upper floor the exact
		-- tile may not be standable at all.
		tolerance = goal.indoor and 1.5 or nil,
		tag = tag .. ":final",
		inside = goal.indoor and schedule.goal_plot(r, goal) or nil,
	})
end

-- Called when the outdoor leg of a two-stage goal finishes.
--
-- The villager is now standing on the stored path's own first waypoint, so the
-- rest of it *is* this leg: handed to nav as `route`, walked as written, and
-- never handed to the pathfinder -- which could not solve it anyway with the
-- door shut. Open the door first so they do not stop dead on the doorstep.
local function advance_stage(self, r)
	local s = util.scratch(self)
	if s.stage ~= "approach" or not s.stage_goal then return false end
	local goal = s.stage_goal
	s.stage = "final"

	local pos = self.object:get_pos()
	local route = schedule.interior_path(r, goal)
	if pos then open_the_door(self, pos, route) end

	nav.set_goal(self, goal.pos, {
		speed = goal.speed,
		tolerance = 1.5,
		tag = goal.kind .. ":final",
		route = route,
		inside = schedule.goal_plot(r, goal),
	})
	return true
end

--------------------------------------------------------------------------------
-- What to do once we are there
--------------------------------------------------------------------------------

local function activity(self, r, dtime)
	local s = util.scratch(self)
	local goal = s.goal
	if not goal then
		nav.idle(self)
		return
	end

	local pos = self.object:get_pos()
	if not pos then return end

	if goal.kind == "work" then
		nav.face_facedir(self, goal.face)

		if s.emote_until and util.now() < s.emote_until then
			-- Mid-swing: hold still without touching the animation.
			self:set_velocity(0)
			self.state = "stand"
		else
			nav.idle(self)
			if util.every(self, "emote", 4 + math.random() * 5, dtime) then
				work_emote(self, r)
			end
		end

	elseif goal.kind == "sleep" then
		-- Into their own bed. Anything that stops them -- a bed that was dug
		-- out, a room they could not get into -- leaves them standing quietly
		-- beside it, which is all they ever did before.
		if not village_life.rest.sleep(self, r) then
			nav.idle(self)
		end
		-- Shut the door behind them for the night. Once, on arrival at the bed --
		-- everyone is heading to their own room at this hour, so there is nobody
		-- to close it on.
		if not s.barred then
			s.barred = true
			nav.bar_door(self, pos)
		end

	elseif goal.kind == "hobby" then
		-- Standing over the hive, the rose, the row of carrots. Facing it, and
		-- keeping it running -- a node timer stops when its mapblock unloads,
		-- and the keeper is the reason it starts again.
		nav.idle(self)
		if util.every(self, "tend", 8, dtime) then
			village_life.traits.tend(self)
			work_emote(self, r)
		end

	elseif goal.kind == "shelter" or goal.kind == "indoors" or goal.kind == "flee" then
		-- Bar the door behind them, once, on arrival. Only for the goals
		-- that mean "something is out there"; a villager stepping in out of
		-- the drizzle does not slam the door.
		if not s.barred and (goal.kind == "flee" or goal.kind == "shelter"
				or goal.kind == "indoors") then
			s.barred = true
			nav.bar_door(self, pos)
		end
		nav.idle(self)
		-- The schedule picks a new goal on the next think tick anyway; this
		-- just stops them standing rigid in the meantime.
		if util.every(self, "peek", 6, dtime) and goal.kind ~= "flee" then
			self:set_yaw(math.random() * math.pi * 2, 6)
		end

	elseif goal.kind == "attend" or goal.kind == "wait" then
		-- Standing with the person who hired them. Facing them, because that
		-- is what a person waiting on somebody does, and it is the difference
		-- between a companion and a piece of luggage.
		nav.idle(self)
		if goal.face_pos and lottmobs and lottmobs.face_pos then
			lottmobs.face_pos(self, goal.face_pos)
		end

	elseif goal.anchor then
		-- Loitering: pick a new spot every so often and amble to it. Unlike
		-- mobs redo's random walk this is anchored, so a villager on a break
		-- never ends up three hundred nodes into a swamp.
		if not nav.has_goal(self) then
			if util.every(self, "wander", 4 + math.random() * 6, dtime) then
				local target = nav.wander_target(goal.anchor, goal.radius or 12)
				if target then
					nav.set_goal(self, target, {speed = "walk", tag = "wander"})
				end
			else
				nav.idle(self)
			end
		end

	else
		nav.idle(self)
	end
end

--------------------------------------------------------------------------------
-- Roles
--------------------------------------------------------------------------------

-- Guards and soldiers are the same entity as every other villager, so their
-- combat stats have to be applied per instance rather than declared in a mob
-- definition.
-- Combat stats for a defender, applied per instance because a guard is the same
-- entity as the baker and this cannot live in a mob definition. `tier` picks how
-- hard they hit and how much they can take.
local DEFENDER_TIERS = {
	guard = {damage = 8, reach = 2.5, view = 16, run = 2.6, walk = 1.2, hp = 40},
	-- A major or landlord leads the defence of their own village but is no
	-- trained soldier: they hit softer and fall sooner than a guard.
	leader = {damage = 5, reach = 2.5, view = 14, run = 2.2, walk = 1.0, hp = 30},
	-- An ordinary villager roused by being attacked. Enough to be worth
	-- something in a scrap, not enough to make hiring a guard pointless.
	roused = {damage = 4, reach = 2.2, view = 12, run = 2.4, walk = 1.1, hp = nil},
	-- A townsperson you have handed a weapon to: town militia. They keep watch and
	-- wade in of their own accord, but they are a baker with a blade, not a guard,
	-- so they hit softer and the weapon you give them is most of what they bring.
	militia = {damage = 3, reach = 2.3, view = 13, run = 2.4, walk = 1.15, hp = 28},
	-- Redeemed beastmen (redeem.lua). A hunter fights like a guard; a barbarian
	-- and a "monster" hit harder and take more -- the reason you went to the
	-- trouble of taming a lionman rather than hiring a watchman.
	hunter    = {damage = 8,  reach = 2.6, view = 16, run = 2.8, walk = 1.3, hp = 44},
	barbarian = {damage = 11, reach = 2.7, view = 16, run = 2.8, walk = 1.3, hp = 52},
	monster   = {damage = 12, reach = 2.8, view = 18, run = 2.6, walk = 1.2, hp = 60},
	-- A recruited buff pigman keeps its huge frame: this is the one tier that
	-- *raises* hp rather than settling it, so arming a champion never nerfs it.
	champion  = {damage = 10, reach = 2.8, view = 18, run = 2.4, walk = 1.2, hp = 250},
}

-- Which combat tier a redeemed beastman's or champion's town role arms it at.
-- Guards/leaders keep their own tiers above; this covers the recruited fighters.
village_life.REDEEM_TIER = {
	hunter = "hunter", barbarian = "barbarian", monster = "monster",
	champion = "champion",
}

function village_life.arm(self, tier)
	local t = DEFENDER_TIERS[tier] or DEFENDER_TIERS.roused
	self.attack_monsters = true
	self.attack_animals = false
	self.attack_npcs = false
	self.attack_players = false
	self.passive = false
	self.damage = t.damage
	self.reach = t.reach
	self.view_range = t.view
	self.run_velocity = t.run
	self.walk_velocity = t.walk
	self.attack_chance = 0

	-- Kit a townsperson has been handed lifts what they can do in a fight: a
	-- weapon adds to the blow and its reach, a piece of armour to what they can
	-- take. Read through companion.gear so it covers a settled resident (kit on
	-- the bed row) as well as a hire. Recomputed from the tier base every call, so
	-- it is idempotent -- taking the gear away takes the bonus back off. `hp`
	-- stays nil for a roused villager unless armour gives a reason to raise it.
	local hp = t.hp
	local companion = village_life.companion
	if companion then
		local weapon, armor = companion.gear(self)
		local wb = weapon and companion.weapon_bonus(weapon)
		if wb then
			self.damage = self.damage + wb.damage
			self.reach = self.reach + (wb.reach or 0)
		end
		-- Every piece worn adds hide, summed. gearstore's own tally does the work.
		local add = companion.armor_hp(companion.gearstore(self) or {})
		if add > 0 then
			local base = hp
			if not base then
				local props = self.object and self.object.get_properties
						and self.object:get_properties()
				base = (props and props.hp_max) or self.hp_max or 20
			end
			hp = base + add
		end
		-- Put the weapon in their hand and the armour on their body, where the
		-- model allows it.
		if companion.update_visuals then companion.update_visuals(self) end
	end

	if hp then
		self.object:set_properties({hp_max = hp})
		if self.health and self.health < hp then self.health = hp end
	end
end

-- Back to a pacifist. Traders carry attack_type "dogfight" but no
-- attack_players, so being explicit here costs nothing and survives a rebase.
function village_life.pacify(self)
	self.attack_monsters = false
	self.attack_players = false
	self.attack_npcs = false
	self.attack_animals = false
	self.passive = true
end

local ROUSE_TIME = 12

-- An ordinary villager struck by something rouses and fights back for a while.
-- Children, the elderly and the shy flee instead; guards and leaders are armed
-- already and never need this.
function village_life.rouse(self, r)
	if not village_life.settings.selfdefence then return end
	if not r or r.role == "guard" or self._vl_leader then return end
	if r.role == "child" or r.role == "elder" then return end
	local p = village_life.persona and village_life.persona.of(self)
	if p and p.temperament == "shy" then return end
	local s = util.scratch(self)
	s.roused_until = util.now() + ROUSE_TIME
	if not s.armed_roused then
		s.armed_roused = true
		village_life.arm(self, "roused")
	end
end

-- A child is scaled down by age (mg_villages gives it one, 1..18). The mesh is
-- feet-origin, so a uniform shrink keeps it standing on the ground; the
-- collisionbox is shrunk to match, or the child keeps an adult-sized hitbox.
local CHILD_BOX = {-0.35, -0.01, -0.35, 0.35, 1.69, 0.35}

function village_life.child_scale(age)
	age = math.max(1, math.min(18, age or 8))
	-- age 1 -> 0.55, age 18 -> 0.90
	return 0.55 + (age - 1) / 17 * 0.35
end

local function size_villager(self, r)
	local scale = 1.0
	if r.role == "child" then
		scale = village_life.child_scale(r.bed and r.bed.age)
	end
	local box
	if scale ~= 1.0 then
		box = {
			CHILD_BOX[1] * scale, CHILD_BOX[2], CHILD_BOX[3] * scale,
			CHILD_BOX[4] * scale, CHILD_BOX[5] * scale, CHILD_BOX[6] * scale,
		}
	end
	self.object:set_properties({
		visual_size = {x = scale, y = scale},
		collisionbox = box,     -- nil restores the entity's own box
	})
	self._vl_scale = scale
end

-- mg_villages sets a child's age once, at generation, and never advances it.
-- Here a child grows a year every few in-game days and is re-sized as it does,
-- so a village visibly has children in it that are getting older rather than a
-- frozen tableau. The age lives on the bed row, which mg_villages serialises, so
-- growth survives a restart; nothing is force-saved, it rides the next autosave.
-- Coming of age (taking a trade, becoming an adult) stays succession's job.
local DAYS_PER_YEAR = 3
local CHILD_MAX_AGE = 18

function village_life.age_child(self, r)
	local bed = r.bed
	if not bed then return end
	local day = minetest.get_day_count and minetest.get_day_count() or 0

	-- First sight: mark the day and wait. Otherwise a child loaded on a world
	-- days old would leap several years on its first think.
	if bed.vl_aged == nil then bed.vl_aged = day ; return end

	if day - bed.vl_aged >= DAYS_PER_YEAR and (bed.age or 0) < CHILD_MAX_AGE then
		bed.age = (bed.age or 1) + 1
		bed.vl_aged = day
		size_villager(self, r)
	end
end

-- The plate over a villager's head, painted in one place so both apply_role
-- (on spawn) and the dialogue that introduces them (on being asked their name
-- and their trade) agree. Three states:
--
--   nametags on   -- always shown, the admin override for a legible village
--   introduced    -- shown once a player has learned this villager's name *and*
--                    job; the plate is a single engine property seen by
--                    everyone, so it appears to all players once any one of them
--                    has been introduced -- the nearest the engine allows to a
--                    per-player plate. What each player is *told* stays per
--                    player (dialogue.known); this governs only the plate.
--   stranger      -- blank, and kept blank: a name is learned, not read off it.
function village_life.reveal_nameplate(self, r)
	r = r or home.resolve(self)

	-- A bedless traveller has no home row at all -- home.adopt refuses them, so
	-- home.resolve returns nil and, until now, they never got a plate however
	-- fully you were introduced. Their name lives on the entity instead, and the
	-- kind of adventurer they are stands in for a trade. (Inn guests already have
	-- a home row carrying r.name, so they fall through untouched.)
	if (not r or not r.name) and self.game_name then
		if village_life.adventurer and village_life.adventurer.is(self) then
			r = {name = self.game_name, title = village_life.adventurer.subtype(self)}
		elseif village_life.wanderer and village_life.wanderer.is(self) then
			-- A wandering trader or a calmed beastman/troll: no home row, so its
			-- name lives on the entity and its trade/town-role stands in for a
			-- title. This is what puts a plate over a redeemed lionman.
			local sp = village_life.wanderer.species(self)
			r = {name = self.game_name, title = self.profession or (sp and sp.title)}
		end
	end

	if not r or not r.name then return end

	local show = village_life.settings.nametags
	if not show then
		-- Has anyone here finished the introductions?
		local key = village_life.economy.identity(self)
		local dialogue = village_life.dialogue
		for _, player in ipairs(minetest.get_connected_players()) do
			local pname = player:get_player_name()
			if dialogue.knows_key(pname, key, "name")
					and dialogue.knows_key(pname, key, "job") then
				show = true
				break
			end
		end
	end

	if show then
		local tag = r.name .. (r.title and (" the " .. r.title) or "")
		if self.update_tag and self.prop then
			-- update_tag colours the plate by health; hand it the name and let
			-- it paint. Clear the legacy field it would otherwise consume first.
			self.nametag = ""
			self:update_tag(tag)
		else
			self.nametag = tag
			self._nametag = tag
			self.object:set_properties({nametag = tag, nametag_color = "#dddddd"})
		end
	else
		-- Blank both tag fields and keep them blank: update_tag repaints the
		-- plate coloured by health but no-ops when both are empty, so the name
		-- never comes back on its own.
		self.nametag = ""
		self._nametag = ""
		self.object:set_properties({nametag = ""})
	end
end

function village_life.apply_role(self)
	local r = home.resolve(self)
	if not r then return end

	-- Heal a settled adventurer that an older save recorded under the flat
	-- "adventurer" role: their kind still rides on the entity (self._adv_subtype,
	-- kept in staticdata), so write it back as the real title -- "veteran" and the
	-- rest -- onto the bed and the resolved role. That restores the nameplate, and
	-- because the title also drives the skin (lottmobs career map), the skin block
	-- below then re-forces the veteran's coat instead of a random pigman face.
	if self._adventurer and r.title == "adventurer" and village_life.adventurer then
		local sub = village_life.adventurer.settle_title(self)
		if sub then
			r.title = sub
			if r.bed then r.bed.title = sub end
			r.role = home.role(r)
		end
	end

	-- A settled beastman revived from its bed comes up as its hostile monster
	-- prototype (home.spawn re-adds the raw zombies:lionman). Make it peaceful
	-- again before anything reads its state, so it never swings at the town it
	-- lives in. The role branch below still arms it as hunter/barbarian/monster.
	if village_life.redeem and village_life.redeem.is_sentient(self) then
		village_life.redeem.make_peaceful(self)
	end

	if r.name then
		self.game_name = r.name
		village_life.reveal_nameplate(self, r)
	end
	if r.title then self.profession = r.title end

	-- Re-force the career skin on every activation, not only at first spawn:
	-- mob_activate reselects a random base_texture from the mob's list each time
	-- a villager loads in, so a skin set only at spawn reverts on the first
	-- mapblock reload -- the historical "skin doesn't set until you right-click"
	-- bug. Only the five careers have a skin here; everything else returns nil
	-- and is left on whatever default it already carries, untouched.
	-- base_texture must be a TABLE ({"name.png"}) -- the shape creaturemob stores
	-- and re-applies verbatim on every refresh; a bare string renders as the
	-- missing-texture placeholder. An earlier version of this code wrote a string
	-- and it got baked into villagers' staticdata, so we both force the career
	-- skin AND repair any string left behind, even for non-career villagers.
	-- Skinning is pigman-only: the career skins are pigman textures, and a settled
	-- wandering trader (a dwarf, say) must keep its own look -- otherwise its title
	-- could match a pigman career and repaint it as a pig on every reload.
	if self.name == "lottmobs:pigman_trader"
			and lottmobs and lottmobs.pigman_trader_texture then
		-- self.id is "vl_<village>/<plot>/<bed>", stable across reloads, so the
		-- gendered careers (guard/housemaid) keep the same variant every load.
		local skin = lottmobs.pigman_trader_texture(r.title, r.gender, self.id)
		local cur = self.base_texture
		if skin then
			-- One of the five careers: force its skin (repairing a bad value too).
			if type(cur) ~= "table" or cur[1] ~= skin then
				self.base_texture = {skin}
				self.object:set_properties({textures = {skin}})
			end
		elseif type(cur) == "string" then
			-- Not a career, but its base_texture was left as a bare string.
			-- Keep the skin it names; just restore the shape creaturemob expects.
			self.base_texture = {cur}
			self.object:set_properties({textures = {cur}})
		end
	end

	-- Villagers can open doors, so the pathfinder is allowed to route them
	-- through their own (openable) doorways rather than treating a shut -- or
	-- even an open -- door as a wall. Monsters never get this flag, so a door
	-- still keeps them out. See creaturemob/core/world.lua.
	self.door_user = true

	-- And they can climb: the pathfinder may route them up or down a ladder or
	-- rope, and the follower drives them along it. This is what gets a villager
	-- back out of a hole it fell into, and up the ladders of a two-storey house.
	-- Same gate as door_user -- a monster never gets it, so a rope is no escape
	-- from a pit meant to hold one. See creaturemob/core/{world,pathfind}.lua.
	self.can_climb = true

	if village_life.settings.aging then
		size_villager(self, r)
	end

	local title = r.title
	local is_leader = title == "major" or title == "landlord"

	if r.role == "guard" then
		-- A redeemed beastman arms at its role's tier (hunter/barbarian/monster);
		-- an ordinary guard at the guard tier. A "monster" also carries the wary
		-- flag its neighbours read.
		village_life.arm(self, village_life.REDEEM_TIER[title] or "guard")
		self._wary = (title == "monster") or nil
	elseif is_leader and village_life.settings.defence then
		-- The village's own leadership fights for it. Their combat routing (like
		-- a guard's) is in brain.step; this only gives them the stats to do it.
		village_life.arm(self, "leader")
		self._vl_leader = true
	else
		-- Everyone else starts a pacifist -- UNLESS you have armed them. A
		-- townsperson handed a weapon becomes town militia: they stand watch and
		-- fight of their own accord (arm folds in the blade and any armour, and
		-- puts the weapon in their hand). Given only armour, they stay peaceful but
		-- wear it -- a protected baker, not a charging one -- and still rouse harder
		-- when struck. Given nothing, they are the pacifist they always were.
		local companion = village_life.companion
		local weapon, armor = companion and companion.gear(self)
		if weapon and village_life.settings.defence then
			village_life.arm(self, "militia")
		else
			village_life.pacify(self)
			if companion and companion.update_visuals then companion.update_visuals(self) end
			-- Armour with no weapon: keep the hide it gives without the aggression.
			-- Anchor to the prototype's own hp_max, not the current one, so applying
			-- this on every reload does not stack the bonus on top of itself.
			local add = armor and companion.armor_hp(companion.gearstore(self) or {}) or 0
			if add > 0 then
				local proto = minetest.registered_entities[self.name] or {}
				local base = proto.hp_max
						or (proto.initial_properties and proto.initial_properties.hp_max)
						or self.hp_max or 20
				self.object:set_properties({hp_max = base + add})
				if self.health and self.health < base + add then self.health = base + add end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Following, for the bedless
--------------------------------------------------------------------------------

-- A hired adventurer with no bed (a pirate off a crew, say). It has no schedule
-- and no home to walk back to; it wears, it is paid, and it follows, and that is
-- the whole of its day. Reuses companion.tick (wages, morale, quitting) and
-- companion.goal (follow/wait), but drives nav directly rather than through
-- apply_goal's building-approach staging, which is all beds and doors it has not
-- got.
-- Too far to walk back to reliably, or wedged for too long: a following
-- companion is snapped to the player's heel rather than lost. This is what
-- stops travel with one feeling like a dainty escort mission -- the pathfinder
-- walks the ordinary case, and this catches the corner cases (a sprint across
-- broken ground, an unloaded gap, a wall the legs cannot solve).
local TELEPORT_AT = 30    -- this far from the player and out of nav's reach
local WEDGED_AT   = 14    -- ...or blocked while at least this far behind

local function catch_up(self, ppos, pos)
	local spot = util.find_standing_near(ppos, 3)
			or util.find_standing_near(ppos, 5)
	if not spot then return false end
	self.object:set_pos(spot)
	nav.clear(self)
	return true
end

function brain.follow_step(self, dtime)
	local companion = village_life.companion
	local pos = self.object and self.object:get_pos()
	if not pos then return false end

	nav.service_doors(self, pos)
	companion.tick(self, nil, dtime)
	-- A hired adventurer heals like everyone else -- otherwise the one villager
	-- doing your fighting is the only one who never recovers from it. rest.tick
	-- ignores `r`; it reads hp_max off the properties apply_loadout sets below.
	village_life.rest.tick(self, nil, dtime)
	if not companion.hired_by(self) then
		nav.clear(self)     -- they quit or were released mid-tick
		return false
	end

	-- Re-assert combat stats and equipment every step: entity fields reset on
	-- every reload, and a gated call would leave them a defenceless trader for
	-- the first few seconds after each one. Cheap -- the one costly op inside
	-- (set_properties for hp_max) only fires when the figure actually changes.
	companion.apply_loadout(self)

	-- Say the odd thing out loud, and pick up news off any villagers we pass, so
	-- a companion carries gossip from village to village and retells it.
	if village_life.settings.gossip then
		if village_life.adventurer
				and util.every(self, "adv_ambient", 30, dtime) then
			village_life.adventurer.ambient(self)
		end
		if util.every(self, "cmingle", village_life.gossip.SPREAD_INTERVAL, dtime) then
			village_life.gossip.mingle_nearby(self, pos)
		end
	end

	-- Fight what threatens the pair of you. escort_step returns nil once they are
	-- actually attacking (handed to the combat FSM), and false otherwise -- but
	-- "false" covers both walking towards a threat (it has already set and ticked
	-- its own nav goal) and having nothing to do. So if a monster is in view the
	-- escort owns the step and we must not clobber its goal with a follow one;
	-- only when the coast is clear do we take over and follow.
	local engaged = false
	if village_life.settings.defence and companion.order(self) ~= "wait" then
		local player = minetest.get_player_by_name(companion.employer(self))
		local anchor = (player and player:get_pos()) or pos
		local result = village_life.defence.escort_step(self, nil, dtime, anchor)
		if result ~= false then
			-- nil hands the step to mobs redo's combat FSM -- that IS the fight.
			return result
		end
		engaged = village_life.threats.nearest(pos, self.view_range or 14) ~= nil
	end

	if not engaged then
		if util.every(self, "follow", 0.4, dtime) then
			local goal = companion.goal(self, nil, pos)
			if goal and goal.pos and util.dist_flat(goal.pos, pos) > 3 then
				-- Lost the trail? Catch up rather than trudge. Only while actually
				-- following (not a "wait"/"home" goal), only when the player is
				-- loaded, and only far enough out that the snap is not jarring.
				local s = util.scratch(self)
				local ppos = goal.kind == "follow" and goal.pos
				local far = ppos and util.dist(ppos, pos) > TELEPORT_AT
				if ppos and (far or (s.follow_blocked and util.dist(ppos, pos) > WEDGED_AT))
						and catch_up(self, ppos, pos) then
					s.follow_blocked = nil
					return false
				end
				nav.set_goal(self, goal.pos,
						{speed = goal.speed or "walk", tolerance = 2.0, tag = "follow"})
			else
				nav.clear(self)
			end
		end

		-- Follow owns nav.tick here; when escort is engaged it ticked nav itself.
		if nav.tick(self, dtime) == "blocked" then
			util.scratch(self).follow_blocked = true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- The step
--------------------------------------------------------------------------------

local THINK = 2.0  -- seconds between schedule decisions

function brain.step(self, dtime, moveresult)
	if not village_life.settings.schedule then return end

	local r = home.resolve(self)
	if not r then
		-- Anyone bedless who has taken service follows the person who hired them --
		-- a bedless adventurer or a wandering trader recruited to walk in on foot.
		-- Neither has a village day to live, so this never reaches the schedule.
		if village_life.settings.hiring
				and village_life.companion.hired_by(self) then
			return brain.follow_step(self, dtime)
		end
		-- A lone traveller passing through has no bed to claim and no village day
		-- to live -- but standing near a player it should still say the odd thing,
		-- and its wounds should close over like anyone else's (no bed, so only ever
		-- at the slower on-its-feet rate).
		if self._adventurer then
			village_life.rest.tick(self, nil, dtime)
			if village_life.settings.gossip and village_life.adventurer
					and util.every(self, "adv_ambient", 30, dtime) then
				village_life.adventurer.ambient(self)
			end
			return
		end
		-- A loose wandering trader not yet recruited: heal it like anyone else, but
		-- return nil (not false) so its native lottmobs wander AI keeps running.
		-- village_life only drives one of these once it is hired or has settled.
		if village_life.wanderer and village_life.wanderer.is(self) then
			village_life.rest.tick(self, nil, dtime)
			return
		end
		-- No identity. Either this pigman predates the mod, in which case it
		-- should claim its bed back before the census decides that bed is
		-- vacant and spawns a duplicate; or it came from a spawn egg out in
		-- the world, in which case there is nothing to claim and mobs redo
		-- keeps it.
		if util.every(self, "adopt", 10, dtime) then
			home.adopt(self)
		end
		return
	end

	local pos = self.object:get_pos()
	if not pos then return end

	local s = util.scratch(self)

	if not s.role_applied then
		s.role_applied = true
		village_life.apply_role(self)
	end

	-- Wounds close over. Before the guard branch below, because a guard who
	-- takes a beating every night is exactly who needs it.
	village_life.rest.tick(self, r, dtime)

	-- Wages, weariness, and going home when it stops being worth it. Before
	-- the guard branch too: a hired guard is still somebody you are not paying.
	if village_life.settings.hiring then
		village_life.companion.tick(self, r, dtime)
	end

	-- Build the hive, plant the rose. Once per villager, and only once the plot
	-- is loaded: a villager whose first think happens at a workplace across the
	-- village would otherwise read every node at home as nil and be written off
	-- as having nowhere to put anything.
	if not s.trait_checked and util.every(self, "trait", 20, dtime) then
		local _, settled = village_life.traits.realise(self)
		if settled then s.trait_checked = true end
	end

	local hired = village_life.settings.hiring
			and village_life.companion.hired_by(self)

	-- Shut any door this villager owes, on every path -- including the guard and
	-- companion branches below, which return before nav.tick (where the ordinary
	-- villager's doors are serviced). Without this a guard or a hired companion
	-- leaves every door it opens standing open.
	nav.service_doors(self, pos)

	-- Guards run their own loop, which hands the step back to the mobs redo
	-- combat FSM once they are actually fighting.
	--
	-- A guard who has taken service is the exception, and had to be, because
	-- this branch returns before the schedule is ever consulted -- so a hired
	-- guard would have gone on patrolling a village the player had left that
	-- morning, which is the one villager it makes most sense to hire and the
	-- one who would have ignored you. They still fight; they just do it around
	-- the person paying them, and when there is nothing to fight the step falls
	-- through to the companion goal below.
	if r.role == "guard" and village_life.settings.defence then
		if hired then
			local employer = village_life.companion.employer(self)
			local player = employer and minetest.get_player_by_name(employer)
			local anchor = (player and player:get_pos()) or pos
			local result = village_life.defence.escort_step(self, r, dtime, anchor)
			if result ~= false then return result end
		else
			return village_life.defence.guard_step(self, r, dtime)
		end
	end

	-- A roused villager whose spell has run out goes back to being a pacifist.
	if s.armed_roused and not (s.roused_until and s.roused_until > util.now()) then
		s.armed_roused = nil
		s.roused_until = nil
		if not self._vl_leader then village_life.pacify(self) end
	end

	-- Leaders always, and ordinary villagers while roused, break off to fight
	-- when there is something to fight -- then fall through to their normal day.
	if village_life.settings.defence
			and (self._vl_leader
				or (s.roused_until and s.roused_until > util.now())) then
		local anchor = r.centre or r.plot_centre or pos
		local engaged, result = village_life.defence.rouse_step(self, r, dtime, anchor)
		if engaged then return result end
	end

	if util.every(self, "roster", 5, dtime) then
		home.check_in(self)
	end

	-- Children grow up. Checked rarely -- growth is measured in in-game days.
	if village_life.settings.aging and r.role == "child"
			and util.every(self, "age", 60, dtime) then
		village_life.age_child(self, r)
	end

	if util.every(self, "think", THINK, dtime) then
		local goal = schedule.decide(self, r, pos)
				or {kind = "leisure", anchor = r.plot_centre, radius = 10}
		local current = s.goal
		-- Only re-plan when the kind of thing we are doing changed. Loitering
		-- goals are re-issued constantly and must not restart the walk.
		if not current or current.kind ~= goal.kind
				or (goal.pos and current.pos and util.dist2(goal.pos, current.pos) > 4) then
			apply_goal(self, r, goal)
		else
			s.goal = goal
		end
	end

	-- Standing about with a neighbour is how news moves. Staggered per villager
	-- and gated on an idle goal inside gossip.mingle, so a working village is
	-- silent and a village square is not.
	if village_life.settings.gossip
			and util.every(self, "gossip", village_life.gossip.SPREAD_INTERVAL,
					dtime) then
		village_life.gossip.mingle(self, r)
	end

	-- Now and then, say a piece of it out loud for a player within earshot, so
	-- the square is audibly alive and not only a set of menus. Proximity chat
	-- only; a no-op without it.
	if village_life.settings.gossip
			and util.every(self, "ambient", 23, dtime) then
		village_life.gossip.ambient(self, r)
	end

	local status = nav.tick(self, dtime)

	if status == "arrived" then
		if not advance_stage(self, r) then
			s.stage = nil
		end
	elseif status == "blocked" then
		-- Could not get there. Drop the goal so the next think picks
		-- something achievable rather than pathing into the same wall.
		s.stage = nil
		s.goal = nil
	elseif status == nil then
		activity(self, r, dtime)
	end

	-- Total control: skip do_states(), general_attack() and the random walk.
	return false
end

--------------------------------------------------------------------------------
-- Villager reactions to being hurt and to dying
--------------------------------------------------------------------------------

-- Extracted from the attach so redeem.lua can give a *settled* beastman the same
-- reactions -- rousing to defend itself, and leaving a body that releases its bed
-- to the ordinary succession -- rather than the native monster behaviour. `prev`
-- is the prototype's original handler, chained at the end.

-- Whatever hurts a villager is a threat, whether or not the classifier
-- recognised it, and it puts the village on alert.
function brain.villager_punch(self, hitter, tflp, tool_caps, dir, prev_punch)
	threats.note_attacker(self, hitter)
	-- Nothing heals while it is still being hit.
	village_life.rest.note_hurt(self)
	-- Struck: fight back for a while instead of only fleeing. Eligibility
	-- (not a child, the elderly or the timid) is decided inside rouse.
	village_life.rouse(self, home.resolve(self))
	if village_life.settings.reputation then
		village_life.reputation.on_villager_hurt(self, hitter)
	end
	-- The village hears that someone was struck; the person struck knows
	-- exactly who did it, and does not need telling twice.
	if hitter and hitter.is_player and hitter:is_player() then
		local pname = hitter:get_player_name()
		village_life.memory.remember(self, pname, "struck")
		village_life.memory.nudge_mood(self, -10, "struck")

		-- Rate-limited on the wall clock, so a flurry of blows is one thing
		-- that happened rather than eight. util.every is a stagger, not a
		-- cooldown -- driving it from a callback rather than a step would
		-- fire on every punch after the first.
		local s = util.scratch(self)
		local now = util.now()
		local fresh = not s.assault_seen or now - s.assault_seen > 6
		if fresh then s.assault_seen = now end

		if village_life.settings.gossip and fresh
				and self.vl and self.vl.v then
			local r = home.resolve(self)
			village_life.events.raise({
				kind = "assault",
				village_id = self.vl.v,
				pos = self.object:get_pos(),
				actor = pname,
				subject = village_life.memory.key_of(self),
				subject_name = self.game_name or (r and r.name),
			})
		end
	end
	if prev_punch then return prev_punch(self, hitter, tflp, tool_caps, dir) end
end

function brain.villager_die(self, pos, prev_die)
	local r = home.resolve(self)
	local killer = self.cause_of_death and self.cause_of_death.puncher
	local by_player = killer and killer.is_player and killer:is_player()
			and killer:get_player_name() or nil

	-- A pirate off a crew: write the loss to the crew's book, so a player who
	-- saw it fall can carry word to the survivors -- who otherwise have no way
	-- of ever learning one of their own is gone.
	if self._adventurer and village_life.adventurer then
		village_life.adventurer.note_death(self)
	end

	-- Somebody who died in your service. Before everything else, because it
	-- has to clear the bed row's `away` mark while home.resolve still reads
	-- a living person -- succession is about to write `dead` into that same
	-- row, and a row carrying both marks is a row the census cannot read.
	if village_life.settings.hiring
			and village_life.companion.hired_by(self) then
		village_life.companion.on_death(self, by_player)
	end

	-- The body, before check_out: it reads the shop stock and the trait to
	-- decide what they were carrying, and both are keyed off state that
	-- teardown clears.
	village_life.remains.place(self, pos)

	home.check_out(self, true)
	village_life.trade.close(self)
	-- Their death is the village's business: it means something got in.
	if self.vl and self.vl.v then
		threats.raise(self.vl.v, pos)
	end
	if village_life.settings.reputation and by_player then
		village_life.reputation.on_villager_killed(self, by_player,
				home.is_guard_role(self))
	end

	-- Recorded as well as punished, so the village can talk about it
	-- afterwards -- and, if it was murder, so word of it can leave the
	-- valley. The witness sweep runs before the body is gone, which is why
	-- this is here rather than in a later handler.
	if village_life.settings.gossip and self.vl and self.vl.v then
		village_life.events.raise({
			kind = by_player and "murder" or "death",
			village_id = self.vl.v,
			pos = pos,
			actor = by_player,
			subject = village_life.memory.key_of(self),
			subject_name = self.game_name or (r and r.name),
			detail = {title = r and r.title},
		})
	end

	-- Last, because it writes to the bed row and saves the village: after
	-- this, home.resolve reads a dead row and anything above that wanted
	-- the living person's data would get nothing.
	village_life.succession.record_death(self, by_player)

	if prev_die then return prev_die(self, pos) end
end

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

-- Attach the brain to one prototype: the pigman villager, and the four peaceful
-- wandering traders. Each capture of prev_punch/prev_die is per prototype, so the
-- function is called once per mob and closes over its own originals.
local function attach_brain(mob_name)
	local proto = minetest.registered_entities[mob_name]
	if not proto then
		village_life.log("warning", mob_name .. " is not registered; villager AI disabled")
		return
	end

	proto.do_custom = brain.step

	-- Never despawn. The pigman villager and the four wandering traders are all a
	-- bounded, non-breeding set, so this is cap-safe (see mob-persistence notes),
	-- and a villager the census counts on should not vanish when its block unloads
	-- far from a player -- it should still be there when you come back.
	proto.persistent = true

	local prev_punch = proto.do_punch
	proto.do_punch = function(self, hitter, tflp, tool_caps, dir)
		return brain.villager_punch(self, hitter, tflp, tool_caps, dir, prev_punch)
	end

	local prev_die = proto.on_die
	proto.on_die = function(self, pos)
		return brain.villager_die(self, pos, prev_die)
	end

	village_life.log("action", "villager brain attached to " .. mob_name)
end

minetest.register_on_mods_loaded(function()
	attach_brain(MOB)
	-- The wandering traders share the same brain, but only ever reach its
	-- managed paths once hired or settled; while loose, brain.step returns nil
	-- (see the no-bed branch) and leaves them on the native mobs-redo wander AI.
	-- Redeem-owned species (beastmen, trolls) are skipped: redeem.lua wires their
	-- do_custom/punch/death and delegates to brain.step only once calmed.
	if village_life.wanderer then
		for name, sp in pairs(village_life.wanderer.SPECIES) do
			if not sp.redeem then attach_brain(name) end
		end
	end
end)
