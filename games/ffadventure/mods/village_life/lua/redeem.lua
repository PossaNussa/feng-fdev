-- Redeeming monsters: calm a sentient beastman, then recruit it like a trader.
--
-- The zombies mod ships humanoid beastmen -- lionmen, cheetahmen, frog-folk,
-- gnolls -- as ordinary `type="monster"` mobs that attack on sight. This module
-- lets a player YELL one down (a calming word, the louder the better), which has
-- a small chance to make it stand down and idle for 30 seconds. While it idles it
-- can be right-clicked into a HARD persuasion (the calm menu, dialogue.lua); win
-- that and it loses monster status and becomes a peaceful wandering recruit --
-- from there it is a [[wanderer]], carried by the very machinery the traders use:
-- dialogue, hire/follow, and settling into a player town. It reverts to a monster
-- if betrayed.
--
-- Trolls (lottmobs) are already peaceful npc guards, so they skip the calming and
-- recruit directly like a trader; redeem still owns their wiring so their own
-- do_custom_guard is chained rather than clobbered.
--
-- Why this lives outside brain.lua: the beastmen must keep their native monster
-- AI until calmed, so their do_custom is a *gate* (native while raging, brain
-- once calmed), not the brain itself. See the plan and the mod README.

local util     = village_life.util
local home     = village_life.home
local wanderer = village_life.wanderer

local redeem = {}
village_life.redeem = redeem

--------------------------------------------------------------------------------
-- The roster
--------------------------------------------------------------------------------

-- The calmable monsters. `difficulty` scales how hard the persuasion is (the
-- calm menu reads it); the fiercer the beast, the harder to talk down.
redeem.BEASTMEN = {
	["zombies:lionman"]        = {race = "lion",    difficulty = 1.0},
	["zombies:lion_warrior"]   = {race = "lion",    difficulty = 1.3},
	["zombies:cheetahman"]     = {race = "cheetah", difficulty = 1.0},
	["zombies:cheetahwarrior"] = {race = "cheetah", difficulty = 1.3},
	["zombies:cheetarcher"]    = {race = "cheetah", difficulty = 1.1},
	["zombies:frarcher"]       = {race = "frog",    difficulty = 1.0},
	["zombies:froghman"]       = {race = "frog",    difficulty = 0.9},
	["zombies:gnoll"]          = {race = "gnoll",   difficulty = 1.1},
}

-- Already-peaceful creatures redeem wires for recruitment (their guard AI chained).
redeem.TROLLS = {
	["lottmobs:troll"]        = true,
	["lottmobs:battle_troll"] = true,
}

-- Every creature redeem touches -- beastmen and trolls -- for the earshot check.
function redeem.is_creature(name)
	return name ~= nil
			and (redeem.BEASTMEN[name] ~= nil or redeem.TROLLS[name] == true)
end

-- A calmable monster. Trolls are peaceful, so they are NOT "sentient monsters"
-- for the calming flow -- only the beastmen are.
function redeem.is_sentient(self)
	return self ~= nil and self.name ~= nil and redeem.BEASTMEN[self.name] ~= nil
end

function redeem.difficulty(self)
	local m = self and self.name and redeem.BEASTMEN[self.name]
	return (m and m.difficulty) or 1.0
end

function redeem.is_calmed(self)
	return self ~= nil and self._calmed == true
end

-- Standing down after a yell but not yet calmed: the window it can be parleyed in.
function redeem.is_idling(self)
	if not self or self._calmed then return false end
	return self._calm_until ~= nil and util.now() < self._calm_until
end

--------------------------------------------------------------------------------
-- Standing a monster down
--------------------------------------------------------------------------------

-- Driven by the village_life brain? A calmed creature, a settled resident, or a
-- companion hired to follow. Everything else keeps its own native AI.
local function managed(self)
	if self._calmed or home.is_villager(self) then return true end
	local companion = village_life.companion
	return companion ~= nil and companion.hired_by(self) == true
end

-- Clear its target, stop it where it stands, and refuse to re-acquire a player.
local function hold_idle(self)
	self.attack = nil
	self.state = "stand"
	self.attack_players = false
	if self.set_velocity then self:set_velocity(0) end
	if self.set_animation then self:set_animation("stand") end
end
redeem.hold_idle = hold_idle

-- A wordless telegraph -- it lowers its guard in a small puff of hearts -- so the
-- change is read off the world, not a chat line ([[weather-telegraph-not-chat]]).
local function telegraph(self)
	if not (self.object and minetest.add_particlespawner) then return end
	local pos = self.object:get_pos()
	if not pos then return end
	minetest.add_particlespawner({
		amount = 10, time = 0.6,
		minpos = {x = pos.x - 0.3, y = pos.y + 1.2, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.8, z = pos.z + 0.3},
		minvel = {x = -0.2, y = 0.5, z = -0.2},
		maxvel = {x = 0.2, y = 1.0, z = 0.2},
		minexptime = 0.6, maxexptime = 1.4, minsize = 1.0, maxsize = 2.0,
		texture = "heart.png",
	})
end

local IDLE_SECS = 30

-- Make a raging beastman stand down for `secs`. `loud` is the loudness of the
-- yell that did it, kept for the calm menu (a louder call gives you a head start).
function redeem.begin_idle(self, secs, loud)
	if not redeem.is_sentient(self) or self._calmed then return false end
	self._calm_until = util.now() + (secs or IDLE_SECS)
	self._calm_loud  = math.max(self._calm_loud or 1, loud or 1)
	hold_idle(self)
	telegraph(self)
	return true
end

--------------------------------------------------------------------------------
-- Light-shy creatures run from the sun
--------------------------------------------------------------------------------

-- Trolls take 60 damage a tick in daylight (light_damage=60) and, left to the
-- native AI, wander into it and die. These flee for cover whenever they are lit,
-- whatever else they are doing -- so a recruited troll keeps to the shade and the
-- indoors by day and is out and about by night, as a troll should be.
local LIGHTSHY = {
	["lottmobs:troll"]        = true,
	["lottmobs:battle_troll"] = true,
}

function redeem.is_lightshy(self)
	return self ~= nil and self.name ~= nil and LIGHTSHY[self.name] == true
end

-- get_node_light folds in the time of day, so a value at or above this is open
-- daylight; a troll's lethal band is 14-15. Flee a little before it bites.
local SUN_LIGHT = 13

-- The darkest reachable standing spot in a ring around here, for a shade run.
local function nearest_shade(pos)
	local best, best_light
	for _, r in ipairs({3, 6, 10}) do
		for i = 0, 7 do
			local a = i * math.pi / 4
			local p = util.find_standing_near({
				x = pos.x + math.cos(a) * r, y = pos.y, z = pos.z + math.sin(a) * r}, 2)
			if p then
				local l = minetest.get_node_light(p) or 15
				if not best_light or l < best_light then best, best_light = p, l end
			end
		end
		-- Good enough the moment we have found real shade; no need to widen.
		if best and best_light and best_light < SUN_LIGHT then return best, best_light end
	end
	return best, best_light
end

-- Returns true while it is actively sheltering (and has taken the step over), so
-- do_custom suppresses everything else. False when it is safe (shade or night).
function redeem.flee_sun(self, dtime)
	local pos = self.object and self.object:get_pos()
	if not pos or not minetest.get_node_light then return false end
	local light = minetest.get_node_light(pos)
	if not light or light < SUN_LIGHT then return false end   -- safe: shade or night

	local s = util.scratch(self)
	if not s.sun_goal or util.every(self, "sunflee", 1.5, dtime) then
		local shade, shade_light = nearest_shade(pos)
		if shade and (shade_light or 15) < light then
			s.sun_goal = shade
			village_life.nav.set_goal(self, shade)
		end
	end
	village_life.nav.tick(self, dtime)
	return true
end

--------------------------------------------------------------------------------
-- The do_custom gate
--------------------------------------------------------------------------------

function redeem.do_custom(self, dtime, moveresult, orig)
	-- Sunlight kills a troll and it will not save itself: run for cover first,
	-- ahead of everything -- its schedule, its guard duty, its native AI.
	if redeem.is_lightshy(self) and redeem.flee_sun(self, dtime) then
		return false
	end

	-- Calmed / settled / hired: the villager brain drives it -- a settled
	-- schedule, or the bedless wander/follow path for a homeless recruit.
	if managed(self) then
		return village_life.brain.step(self, dtime, moveresult)
	end

	-- Standing down after a yell: freeze the attack FSM for the window.
	if redeem.is_idling(self) then
		hold_idle(self)
		return false
	end

	-- The window closed without a deal: shake off the calm and re-arm.
	if self._calm_until then
		self._calm_until = nil
		self._calm_loud = nil
		if redeem.is_sentient(self) then self.attack_players = true end
	end

	-- A raging beastman keeps its native monster AI; a wild troll keeps its own
	-- guard do_custom (captured and chained here).
	if orig then return orig(self, dtime, moveresult) end
	return nil
end

--------------------------------------------------------------------------------
-- Calming, and turning back
--------------------------------------------------------------------------------

-- Make a settled/reviving beastman peaceful again. A bed-revived resident comes
-- up as its hostile monster prototype; this is called from apply_role before
-- anything reads its state, so it never gets a swing in at the town it lives in.
function redeem.make_peaceful(self)
	self._calmed = true
	self.type = "npc"
	self.attack = nil
	self.attack_players = false
end

-- The town roles a calmed beastman naturally falls into. Hunter is much the most
-- common; the fearsome "monster" is rare.
local ROLES = {
	{title = "hunter",    weight = 6},
	{title = "barbarian", weight = 3},
	{title = "monster",   weight = 2},
}

function redeem.assign_role()
	local total = 0
	for _, r in ipairs(ROLES) do total = total + r.weight end
	local pick = math.random() * total
	for _, r in ipairs(ROLES) do
		pick = pick - r.weight
		if pick <= 0 then return r.title end
	end
	return "hunter"
end

-- The payoff: it loses monster status for good and becomes a peaceful wandering
-- recruit. Persistence is free (type "npc" + lifetimer past the cull), and the
-- flags survive a reload because creaturemob serialises every plain self field.
function redeem.calm(self, pname)
	if not redeem.is_sentient(self) then return false end

	redeem.make_peaceful(self)
	self._calm_until = nil
	self._calm_loud  = nil
	self.state = "stand"
	self.passive = true
	self.attacks_monsters = true   -- it will still fight monsters, now for a town

	-- Never despawn now that it is a person. type=="npc" already does this at
	-- activate; set it here too so a mid-session calm sticks without a reload.
	self.lifetimer = 20001
	if self.object then self.object:set_properties({static_save = true}) end

	-- A name, and a town role stored as its profession -- companion.settle copies
	-- profession into bed.title, so the role survives a settle and a respawn.
	if wanderer and wanderer.name_for then wanderer.name_for(self) end
	self.profession = redeem.assign_role()

	-- The first thread of standing: it remembers who talked it down.
	if pname and village_life.memory then
		village_life.memory.remember(self, pname, "calmed")
		village_life.memory.nudge_mood(self, 12, "calmed")
	end
	if village_life.reveal_nameplate then village_life.reveal_nameplate(self) end

	village_life.log("action", (self.game_name or "A beast")
			.. " was calmed by " .. tostring(pname))
	return true
end

-- Betrayal. Only a calmed-but-UNSETTLED creature relapses into a monster; a
-- settled resident is handled as a villager (it rouses to defend itself) and
-- never reverts, or it would turn on the town it belongs to.
function redeem.revert(self, reason)
	if not redeem.is_sentient(self) then return end
	if home.is_villager(self) then return end

	self._calmed = nil
	self._calm_until = nil
	self.type = "monster"
	self.attack_players = true
	self.passive = false
	if self.set_animation then self:set_animation("stand") end

	village_life.log("action", (self.game_name or "A beast")
			.. " turned hostile again (" .. tostring(reason) .. ")")
end

-- A wild sentient cut down by a player unsettles calmed-but-homeless kin of the
-- same kind nearby -- they see the killing and their trust breaks.
function redeem.on_wild_death(self, pos)
	if not redeem.is_sentient(self) then return end
	local killer = self.cause_of_death and self.cause_of_death.puncher
	if not (killer and killer.is_player and killer:is_player()) then return end
	if not (pos and minetest.get_objects_inside_radius) then return end

	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 12)) do
		local ent = obj.get_luaentity and obj:get_luaentity()
		if ent and ent ~= self and ent._calmed and not home.is_villager(ent)
				and ent.name == self.name then
			redeem.revert(ent, "kin slain")
		end
	end
end

--------------------------------------------------------------------------------
-- Right-click
--------------------------------------------------------------------------------

function redeem.on_rightclick(self, clicker)
	if not clicker or not clicker.is_player or not clicker:is_player() then return end
	local dialogue = village_life.dialogue
	if not dialogue or not village_life.settings.dialogue then return end

	-- A troll, or an already-calmed / settled creature: ordinary conversation.
	if not redeem.is_sentient(self) or self._calmed or home.is_villager(self) then
		return dialogue.open(self, clicker)
	end

	-- A beastman that has stood down can be parleyed with (the calm menu).
	if redeem.is_idling(self) then
		return dialogue.open(self, clicker)
	end

	-- Still a raging monster. It will not listen; you must call it down first.
	minetest.chat_send_player(clicker:get_player_name(),
			"It's snarling and thrashing -- in no state to talk. "
			.. "Try shouting it down first.")
end

--------------------------------------------------------------------------------
-- The yell
--------------------------------------------------------------------------------

local CALM_WORDS = {
	wait = true, stop = true, calm = true, peace = true, easy = true,
	friend = true, hold = true, down = true, whoa = true, stay = true, ["no"] = true,
}

local BASE_CHANCE = 0.15
local RANGE = 20

-- How loud a line is, on proxchat's own reading: a mostly-capitals shout doubles
-- it, and each "!" adds a little. 1.0 for a word said plainly, up to ~3.
function redeem.loudness(msg)
	local f = 1.0
	local upper   = #(msg:gsub("[^A-Z]", ""))
	local letters = #(msg:gsub("[^A-Za-z]", ""))
	if letters > 0 and upper * 2 > letters then f = f * 2 end
	local bangs = #(msg:gsub("[^!]", ""))
	f = f + 0.15 * bangs
	return math.min(f, 3.0)
end

local function has_calm_word(msg)
	for w in msg:lower():gmatch("%a+") do
		if CALM_WORDS[w] then return true end
	end
	return false
end
redeem.has_calm_word = has_calm_word

-- Registered as a chat handler (never consumes the message: proxchat still
-- carries it). A calming word within earshot of a raging beastman gives it a
-- BASE_CHANCE, scaled up by loudness, to stand down.
function redeem.yell(pname, msg)
	if village_life.settings.redeem == false then return end
	if not msg or not has_calm_word(msg) then return end
	local player = minetest.get_player_by_name(pname)
	if not player then return end
	local pos = player:get_pos()
	if not pos or not minetest.get_objects_inside_radius then return end

	local loud   = redeem.loudness(msg)
	local chance = math.min(0.9, BASE_CHANCE * loud)

	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, RANGE)) do
		local ent = obj.get_luaentity and obj:get_luaentity()
		if ent and redeem.is_sentient(ent) and not ent._calmed
				and not redeem.is_idling(ent) then
			if math.random() < chance then
				redeem.begin_idle(ent, IDLE_SECS, loud)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

local function attach(name)
	local proto = minetest.registered_entities[name]
	if not proto then
		village_life.log("warning", name .. " is not registered; redeem skipped")
		return
	end

	-- Never despawn. A bounded roster (~10 species), so the mapblock object cap
	-- stays safe (see [[mob-persistence-selective]]); a calmed one also flips to
	-- type "npc", which the far-unload cull already spares.
	proto.persistent = true

	local orig_do = proto.do_custom
	proto.do_custom = function(self, dtime, mr)
		return redeem.do_custom(self, dtime, mr, orig_do)
	end

	proto.on_rightclick = function(self, clicker)
		return redeem.on_rightclick(self, clicker)
	end

	local orig_punch = proto.do_punch
	proto.do_punch = function(self, hitter, tflp, tool_caps, dir)
		local by_player = hitter and hitter.is_player and hitter:is_player()
		-- A settled resident defends itself exactly like any villager.
		if home.is_villager(self) then
			return village_life.brain.villager_punch(self, hitter, tflp,
					tool_caps, dir, orig_punch)
		end
		-- A calmed but homeless creature that you strike turns on you again.
		if self._calmed and by_player then
			redeem.revert(self, "struck")
		end
		if orig_punch then return orig_punch(self, hitter, tflp, tool_caps, dir) end
	end

	local orig_die = proto.on_die
	proto.on_die = function(self, pos)
		-- A settled/calmed creature dies as a villager: bones, and its bed
		-- released to the ordinary succession refill.
		if home.is_villager(self) or self._calmed then
			return village_life.brain.villager_die(self, pos, orig_die)
		end
		redeem.on_wild_death(self, pos)
		if orig_die then return orig_die(self, pos) end
	end

	village_life.log("action", "redeem attached to " .. name)
end

minetest.register_on_mods_loaded(function()
	for name in pairs(redeem.BEASTMEN) do attach(name) end
	for name in pairs(redeem.TROLLS) do attach(name) end

	-- Listen for the yell. Returns nothing, so the message still goes to proxchat
	-- and to ordinary chat -- shouting "STOP!" both calms the beast and is heard.
	if minetest.register_on_chat_message then
		minetest.register_on_chat_message(function(pname, msg)
			redeem.yell(pname, msg)
		end)
	end
end)

return redeem
