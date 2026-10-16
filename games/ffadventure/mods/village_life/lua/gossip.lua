-- What people are saying.
--
-- Reputation was a single number per village, applied to everyone in it at
-- once. That is the shape of an announcement, not of news: the village knew you
-- had killed the baker the instant you did it, from any distance, indoors,
-- alone, at night.
--
-- Gossip replaces the announcement with a process. Something happens; whoever
-- could see it knows it; they tell each other when they stand about together;
-- and a little of it eventually leaves the valley. That gives three tiers of
-- standing that are the same mechanism at different ranges:
--
--   the person   what one villager saw, and remembers (memory.lua)
--   the village  what has been passed around enough to be common knowledge
--   the world    what is notorious enough to arrive before you do
--
-- News is retold, not copied. Each hop loses a detail and gains confidence, so
-- a rumour four people old is recognisably a rumour -- which is what lets a
-- player go and find out whether it is true.

local util = village_life.util
local home = village_life.home

local gossip = {}
village_life.gossip = gossip

local storage = minetest.get_mod_storage()
local dirty = false

--------------------------------------------------------------------------------
-- Tuning
--------------------------------------------------------------------------------

-- How many items of news one villager carries. Small on purpose: a villager
-- with twenty things to say has nothing to say.
local CARRY = 6

-- Hops past which news is not worth passing on. Combined with CARRY this is
-- what stops a village converging on one identical rumour set.
local MAX_HOPS = 4

-- How close two villagers must be to be talking, and how often the exchange is
-- attempted per villager.
local EARSHOT = 6
local SPREAD_INTERVAL = 11

-- News older than this in days has stopped being news.
local STALE_DAYS = 12

-- What proportion of an event's weight reaches the wider world when it travels.
local TRAVEL_FRACTION = 0.35

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- villager key -> { {ev = <event>, hops = n, day = n} }
gossip.book = {}

local function load()
	local raw = storage:get_string("gossip")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then gossip.book = data end
end

local function save()
	if not dirty then return end
	storage:set_string("gossip", minetest.serialize(gossip.book))
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

gossip.save = save

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

--------------------------------------------------------------------------------
-- Carrying news
--------------------------------------------------------------------------------

-- How much this item is worth to the villager holding it: newsworthiness,
-- decayed by how far it has been retold and how long ago it happened. This is
-- the sort order for both what they repeat and what they forget.
local function value(item)
	local age = today() - (item.day or 0)
	local w = (item.ev.weight or 20) * (0.65 ^ (item.hops or 0))
	return w - age * 3
end

local function has(list, ev_id)
	for _, item in ipairs(list) do
		if item.ev.id == ev_id then return item end
	end
end

-- A death or murder is only news while the subject is actually dead. Once their
-- bed is reoccupied -- revived by an admin, or an incomer who took the key --
-- the very same event describes a living villager being killed, and the person
-- now in that bed would be gossiping about their own death. Such an item is
-- spent and must not be repeated or passed on.
local function spent(item)
	local ev = item and item.ev
	if not ev or not ev.subject then return false end
	if ev.kind ~= "death" and ev.kind ~= "murder" then return false end
	local vid, p, b = ev.subject:match("^(.-)/(%d+)/(%d+)$")
	if not vid then return false end
	local bed = home.bed_data(vid, tonumber(p), tonumber(b))
	return bed ~= nil and not bed.dead
end
gossip.spent = spent

local function trim(list)
	-- Drop the stale and the spent outright, then the least worth repeating.
	for i = #list, 1, -1 do
		if today() - (list[i].day or 0) > STALE_DAYS or spent(list[i]) then
			table.remove(list, i)
		end
	end
	if #list <= CARRY then return end
	table.sort(list, function(a, b) return value(a) > value(b) end)
	for i = #list, CARRY + 1, -1 do
		list[i] = nil
	end
end

-- Give one villager an item of news. Returns true if it was new to them.
function gossip.tell(key, ev, hops, from)
	if not key or not ev then return false end
	if hops > MAX_HOPS then return false end

	local list = gossip.book[key]
	if not list then list = {} ; gossip.book[key] = list end

	local existing = has(list, ev.id)
	if existing then
		-- Hearing it again from someone closer to it sharpens the version they
		-- hold; hearing a worse version does not blunt the one they have.
		if hops < existing.hops then
			existing.hops = hops
			existing.from = from
			dirty = true
		end
		return false
	end

	list[#list + 1] = {ev = ev, hops = hops, day = today(), from = from}
	trim(list)
	dirty = true
	return true
end

-- First-hand: everyone who saw it. Called by events.raise.
function gossip.witness(keys, ev, mood_delta)
	for _, key in ipairs(keys) do
		if gossip.tell(key, ev, 0) and mood_delta and mood_delta ~= 0 then
			village_life.memory.nudge_mood_key(key, mood_delta, ev.kind)
		end
	end

	-- Anything worth carrying past the valley starts doing so the moment it is
	-- seen. Notoriety is not gossip reaching another village literally; it is
	-- the accumulated weight of what a player is known for.
	-- A villager doer has no notoriety to spread -- only a player's name travels.
	if ev.travels and ev.actor and not ev.actor_villager and #keys > 0 then
		village_life.reputation.spread_word(ev.actor,
				gossip.reputation_delta(ev) * TRAVEL_FRACTION, ev.kind)
	end
end

-- Which way an event pushes the doer's name, and how hard.
function gossip.reputation_delta(ev)
	local k = ev.kind
	if k == "murder" then return -30 end
	if k == "assault" then return -10 end
	if k == "theft" then return -8 end
	if k == "trespass" then return -6 end
	if k == "rescue" then return 10 end
	if k == "feat" then return 12 end
	if k == "trade" then return 1 end
	return 0
end

--------------------------------------------------------------------------------
-- Passing it on
--------------------------------------------------------------------------------

-- The best thing this villager could tell somebody, excluding what that
-- somebody already has.
local function best_to_share(key, listener_key)
	local list = gossip.book[key]
	if not list then return end
	local listener = gossip.book[listener_key]

	local best, best_value
	for _, item in ipairs(list) do
		if item.hops < MAX_HOPS
				and not (listener and has(listener, item.ev.id))
				and not spent(item) then
			local v = value(item)
			if not best_value or v > best_value then
				best, best_value = item, v
			end
		end
	end
	return best
end

-- One exchange between two villagers standing near each other.
function gossip.exchange(a_key, b_key)
	local told = false
	local a = best_to_share(a_key, b_key)
	if a then
		told = gossip.tell(b_key, a.ev, a.hops + 1, a_key) or told
	end
	local b = best_to_share(b_key, a_key)
	if b then
		told = gossip.tell(a_key, b.ev, b.hops + 1, b_key) or told
	end
	return told
end

-- Goals during which a villager is idle enough to be talking to their
-- neighbours. Working, fleeing and sleeping are not conversations.
local CHATTY = {["break"] = true, leisure = true, chores = true, home = true}

-- Two idle villagers sharing a spot form an impression of each other: a small
-- nudge each meeting, leaning the way their natural affinity already points (read
-- `raw`, so the stored opinion is not part of what shapes it), plus a little noise
-- so a first impression is not destiny. It is bounded and fades in memory, so it
-- shades regard over time without ever ruling it.
local MEET_STEP = 2.2

local function meet(a_key, b_key)
	local regard, memory = village_life.regard, village_life.memory
	if not regard or not memory then return end
	local function nudge(x, y)
		local natural = regard.between(x, y, {raw = true})
		-- Chemistry leads; the noise is small enough that two people with nothing
		-- between them stay near neutral rather than random-walking into a band.
		memory.meet_key(x, y, (natural / 100) * MEET_STEP + (math.random() - 0.5) * 0.6)
	end
	nudge(a_key, b_key)
	nudge(b_key, a_key)
end

-- Called from the brain's think step for one villager. Cheap by construction:
-- it only runs on a stagger, only when that villager is idle, and only scans
-- the roster of their own village.
function gossip.mingle(self, r)
	if not r or not r.village_id then return end

	local goal = util.scratch(self).goal
	if not goal or not CHATTY[goal.kind] then return end

	local key = home.key(r.village_id, r.plot_nr, r.bed_nr)
	local pos = self.object and self.object:get_pos()
	if not pos then return end

	local prefix = r.village_id .. "/"
	for other_key, entry in pairs(home.roster) do
		if other_key ~= key and other_key:sub(1, #prefix) == prefix then
			local opos = entry.obj and entry.obj:get_pos()
			if opos and util.dist(opos, pos) <= EARSHOT then
				meet(key, other_key)
				if gossip.exchange(key, other_key) then return true end
			end
		end
	end
end

gossip.SPREAD_INTERVAL = SPREAD_INTERVAL

-- Said out loud, into proximity chat, for a player standing near enough to
-- overhear. This is the same news the "Heard anything?" question surfaces, only
-- volunteered -- so a village square sounds like one. Requires the proxchat mod;
-- without it this is a no-op and news only reaches a player who asks.
local AMBIENT_RANGE = 20

function gossip.ambient(self, r)
	if not (minetest.global_exists("proxchat") and proxchat.speak) then return end
	if not r or not r.village_id then return end

	local goal = util.scratch(self).goal
	if not goal or not CHATTY[goal.kind] then return end

	local pos = self.object and self.object:get_pos()
	if not pos then return end

	-- Only bother if a player is close enough to hear it.
	local near = false
	for _, player in ipairs(minetest.get_connected_players()) do
		if util.dist(player:get_pos(), pos) <= AMBIENT_RANGE then near = true break end
	end
	if not near then return end

	local key = village_life.memory.key_of(self)
	local list = key and gossip.book[key]
	if not list or #list == 0 then return end

	-- The most newsworthy thing they are carrying -- but never a death that has
	-- been undone. Without this a widower stands in the square telling the world
	-- his revived wife is dead, on every ambient tick.
	local best, best_value
	for _, item in ipairs(list) do
		if not spent(item) then
			local v = value(item)
			if not best_value or v > best_value then best, best_value = item, v end
		end
	end

	local said = best and gossip.phrase(best)
	if said then
		proxchat.speak(pos, self.game_name or "A villager", said)
	end
end

-- A wanderer -- a hired companion, above all -- is in no village roster and has
-- no neighbours of their own, but they still stand among other people as they
-- travel, and news rubs off. Exchange with whatever villagers are in earshot,
-- whichever village those villagers belong to, so gossip rides along with them
-- from one valley to the next: the traveller is how a rumour crosses the map.
function gossip.mingle_nearby(self, pos)
	local key = village_life.memory.key_of(self)
	if not key or not pos then return end
	for other_key, entry in pairs(home.roster) do
		if other_key ~= key then
			local opos = entry.obj and entry.obj:get_pos()
			if opos and util.dist(opos, pos) <= EARSHOT then
				meet(key, other_key)
				if gossip.exchange(key, other_key) then return true end
			end
		end
	end
end

-- The best thing this carrier could say aloud right now, already phrased, or
-- nil if they are carrying nothing. Used by a travelling companion to retell on
-- the road what they picked up in the last village.
function gossip.carry_line(self)
	local key = village_life.memory.key_of(self)
	local list = key and gossip.book[key]
	if not list or #list == 0 then return end
	local best, best_value
	for _, item in ipairs(list) do
		if not spent(item) then
			local v = value(item)
			if not best_value or v > best_value then best, best_value = item, v end
		end
	end
	return best and gossip.phrase(best)
end

--------------------------------------------------------------------------------
-- Saying it out loud
--------------------------------------------------------------------------------

-- The item this villager would most want to pass on to a player, skipping
-- anything they have already been told. Returns the item, or nil.
function gossip.for_player(self, pname, already)
	local key = village_life.memory.key_of(self)
	local list = key and gossip.book[key]
	if not list then return end

	local best, best_value
	for _, item in ipairs(list) do
		if not (already and already[item.ev.id]) and not spent(item) then
			local v = value(item)
			if not best_value or v > best_value then
				best, best_value = item, v
			end
		end
	end
	return best
end

-- How a villager frames news of a given remove. First hand is stated; a rumour
-- is attributed, which is what makes it checkable.
local HEARSAY = {
	[1] = "%s told me %s",
	[2] = "I heard from %s that %s",
	[3] = "They're saying %s",
	[4] = "There's a story going round -- %s",
}

-- `listener`, when given, is the player being told the news: if they were the
-- one who did the deed, the retelling names them "you" instead of reporting
-- them to their own face as "some outsider".
function gossip.phrase(item, listener)
	local ev = item.ev
	local line, vague = village_life.events.retell(ev, item.hops, listener)
	if not line then return end

	if item.hops == 0 then
		return line, false
	end

	local frame = HEARSAY[math.min(item.hops, 4)]
	local source = item.from and gossip.speaker_name(item.from)

	-- Drop the leading capital: the line becomes a clause inside the frame.
	local clause = line:gsub("^(%u)", function(c) return c:lower() end)

	if item.hops <= 2 and source then
		return frame:format(source, clause), true
	end
	return HEARSAY[math.max(3, math.min(item.hops, 4))]:format(clause), true
end

-- The name of the villager a piece of news came from, for attribution.
function gossip.speaker_name(key)
	local village_id, plot_nr, bed_nr = key:match("^(.-)/(%d+)/(%d+)$")
	if not village_id then return end
	local bed = home.bed_data(village_id, tonumber(plot_nr), tonumber(bed_nr))
	return bed and bed.first_name
end

--------------------------------------------------------------------------------
-- Clearing up
--------------------------------------------------------------------------------

function gossip.forget(key)
	if gossip.book[key] then
		gossip.book[key] = nil
		dirty = true
	end
end

-- Drop, from everyone's news, any death or murder whose subject is this bed.
-- Called when the bed is reoccupied (a revive) so no one is left holding word of
-- a death that has been undone. `spent` would drop these lazily as books trim,
-- but a revive should take effect at once rather than the next time each carrier
-- happens to receive news. Returns how many items were dropped.
function gossip.forget_subject(subject_key)
	if not subject_key then return 0 end
	local n = 0
	for _, list in pairs(gossip.book) do
		for i = #list, 1, -1 do
			local ev = list[i].ev
			if ev and ev.subject == subject_key
					and (ev.kind == "death" or ev.kind == "murder") then
				table.remove(list, i)
				n = n + 1
			end
		end
	end
	if n > 0 then dirty = true end
	return n
end

-- Drop from one villager's news everything a given player did, optionally of a
-- single kind. The memory-book pardon stops them raising it as a grudge; this
-- stops them repeating it as gossip. Returns how many items were dropped.
function gossip.pardon(key, pname, kind)
	local list = gossip.book[key]
	if not list then return 0 end
	local n = 0
	for i = #list, 1, -1 do
		local ev = list[i].ev
		if ev and ev.actor == pname and (not kind or ev.kind == kind) then
			table.remove(list, i)
			n = n + 1
		end
	end
	if n > 0 then dirty = true end
	return n
end

-- How much news this villager is carrying, for the debug command.
function gossip.count(key)
	local list = gossip.book[key]
	return list and #list or 0
end

-- Let proxchat count a nearby villager as a listener, so a player talking among
-- villagers is not told "nobody can hear you". Villagers are pigmen, which is
-- the case the player means -- and so are the adventurers passing through and the
-- one you have hired to follow you, who are not in the village roster (they have
-- no bed) but are just as much a person standing in earshot.
minetest.register_on_mods_loaded(function()
	if minetest.global_exists("proxchat") and proxchat.register_listener_check then
		proxchat.register_listener_check(function(pos, max_dist)
			-- Anyone actually standing in earshot counts, and the reliable way to
			-- ask that is the loaded objects themselves rather than the roster or
			-- the traveller set -- a bedless adventurer or a freshly hired
			-- companion falls out of both of those bookkeeping tables at the edges,
			-- and then a player standing right beside them was told they were
			-- alone. Every villager, inn guest, traveller and hired companion is a
			-- `lottmobs:pigman_trader` -- or, for a settled/wandering trader, one of
			-- the four trader species is_villager_entity knows; a village's champion
			-- is a `zombies:buffpig`.
			if not minetest.get_objects_inside_radius then return false end
			for _, obj in ipairs(minetest.get_objects_inside_radius(pos, max_dist)) do
				local ent = obj.get_luaentity and obj:get_luaentity()
				-- A sentient beastman or troll counts as a listener even while it
				-- is aggressive -- you hear you are not alone with one snarling
				-- nearby, calmed or not (redeem.is_creature). Villagers, the
				-- champion buffpig, and traders count as before.
				if ent and (village_life.is_villager_entity(ent.name)
						or ent.name == "zombies:buffpig"
						or (village_life.redeem
							and village_life.redeem.is_creature(ent.name))) then
					return true
				end
			end
			return false
		end)
	end
end)
