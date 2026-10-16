-- What a villager remembers.
--
-- Reputation is a number per *village*. That is the right shape for "this
-- settlement has decided how it feels about you", and the wrong shape for
-- everything else: the baker could not tell you that you pulled a zombie off
-- her last winter, and every one of her neighbours felt exactly as she did
-- about you no matter which of them had actually been there.
--
-- So each villager keeps their own small book. Two things live in it:
--
--   opinion  what they personally think of one player, moved by what that
--            player did to *them*. Bounded well inside the village score's
--            range, so it colours a standing rather than replacing it -- a
--            villager can like you in a village that does not, but cannot
--            single-handedly make you its hero.
--   mood     how they are, today. Nothing to do with the player. Fed by
--            raids, deaths, weather and a good day's trade, and it drifts back
--            towards a baseline set by their temperament, so a cheerful person
--            recovers from a bad week faster than a weary one.
--
-- Both are stored rather than derived, because both are records of things that
-- happened, which is exactly the class of thing that cannot be recomputed from
-- a seed. Persona stays derived; this is the part of a villager that changes.

local util = village_life.util

local memory = {}
village_life.memory = memory

local storage = minetest.get_mod_storage()
local dirty = false

--------------------------------------------------------------------------------
-- Bounds
--------------------------------------------------------------------------------

-- Personal opinion is deliberately narrower than the village score's -100..100.
-- Added on top of it, it can carry someone a band or two either way without
-- ever outvoting the village.
local OP_MIN, OP_MAX = -40, 40

local MOOD_MIN, MOOD_MAX = -50, 50

-- Per in-game day, towards zero and towards the temperament baseline. Grudges
-- outlast goodwill here for the same reason they do in reputation.lua: being
-- forgiven should be possible, being trusted should need keeping up. Goodwill
-- decays slowly because an in-game day is only ~20 real minutes; what keeps a
-- long absence from wiping a friendship is the earned floor below, not the rate.
local OPINION_DECAY_BAD  = 0.8
local OPINION_DECAY_GOOD = 0.2
local MOOD_RECOVERY      = 4.0

-- Once a villager has enough remembered good turns from a player -- trades,
-- gifts, a rescue, good company across several visits -- their personal regard
-- has set, and no absence drops it back to indifference. The floor is modest:
-- it says "this is someone I know and think well of", not "my closest friend",
-- which is a standing that still has to be kept warm.
local OPINION_FLOOR      = 8
local FLOOR_AFTER_DEEDS  = 8

-- Where each temperament sits when nothing in particular is happening.
local MOOD_BASELINE = {
	gruff = -6, warm = 10, shy = 0, proud = 4,
	weary = -8, sly = 0, earnest = 5, dreamy = 3,
}

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- villager key -> {players = {pname -> {opinion, day, deeds = {kind -> n}}},
--                  mood = n, mood_day = n,
--                  acq = {other villager key -> {op = n, day = n}}}
memory.book = {}

local function load()
	local raw = storage:get_string("memory")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then memory.book = data end
end

local function save()
	if not dirty then return end
	storage:set_string("memory", minetest.serialize(memory.book))
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

memory.save = save

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

local function clamp(v, lo, hi)
	return math.max(lo, math.min(hi, v))
end

--------------------------------------------------------------------------------
-- The villager's page
--------------------------------------------------------------------------------

-- Keyed on the same identity everything else uses, so a villager's memory
-- survives being unloaded and reloaded, and dies with the bed row when the
-- household does.
local function key_of(self)
	return village_life.economy.identity(self)
end

memory.key_of = key_of

local function page_by_key(k, create)
	if not k then return end
	local p = memory.book[k]
	if not p then
		if not create then return end
		p = {players = {}, mood = 0, mood_day = today()}
		memory.book[k] = p
		dirty = true
	end
	return p
end

local function page(self, create)
	return page_by_key(key_of(self), create)
end

--------------------------------------------------------------------------------
-- Mood
--------------------------------------------------------------------------------

-- Keyed rather than entity-based, because persona is a pure function of the
-- same identity string: a villager's temperament -- and so where their mood
-- settles -- can be known without them being loaded.
local function baseline_by_key(k)
	if not k then return 0 end
	local p = village_life.persona.for_identity(k)
	return MOOD_BASELINE[p and p.temperament] or 0
end

-- Decay is applied on read, as in reputation.lua: villagers nobody is dealing
-- with cost nothing, and the arithmetic comes out the same.
local function settled_mood(k, pg)
	local base = baseline_by_key(k)
	if not pg then return base end
	local now = today()
	local elapsed = now - (pg.mood_day or now)
	if elapsed > 0 then
		local drift = MOOD_RECOVERY * elapsed
		if pg.mood > base then
			pg.mood = math.max(base, pg.mood - drift)
		else
			pg.mood = math.min(base, pg.mood + drift)
		end
		pg.mood_day = now
		dirty = true
	end
	return pg.mood or base
end

function memory.mood_key(k)
	return settled_mood(k, page_by_key(k, false))
end

function memory.mood(self)
	return memory.mood_key(key_of(self))
end

-- A word for the mood, for anything that has to say it out loud.
function memory.spirits(self)
	local m = memory.mood(self)
	if m >= 25 then return "cheerful" end
	if m >= 8 then return "content" end
	if m > -8 then return "even" end
	if m > -25 then return "low" end
	return "wretched"
end

function memory.nudge_mood_key(k, delta, reason)
	if not k or delta == 0 then return end
	local pg = page_by_key(k, true)
	if not pg then return end
	local before = settled_mood(k, pg)
	pg.mood = clamp(before + delta, MOOD_MIN, MOOD_MAX)
	pg.mood_day = today()
	dirty = true
	village_life.log("info", ("%s mood %+0.1f (%s)"):format(
			k, delta, reason or "?"))
	return pg.mood
end

function memory.nudge_mood(self, delta, reason)
	return memory.nudge_mood_key(key_of(self), delta, reason)
end

--------------------------------------------------------------------------------
-- Opinion of another villager, formed by meeting them
--------------------------------------------------------------------------------

-- Regard between two villagers used to be a pure function of who they are. This
-- is the part that isn't: a stored impression the two build by actually crossing
-- paths (nudged from the gossip mingle hook), which regard.between adds on top of
-- the natural affinity. Directional -- a's view of b lives on a's page -- so one
-- can warm to the other faster than it is returned, the same asymmetry the
-- chemistry table already has. Narrower than a player opinion: it can move a band
-- or two, never outvote temperament.
local ACQ_CAP   = 25
local ACQ_DECAY = 0.25   -- per idle day; an impression fades if they stop meeting

-- One person's stored opinion of another, decayed towards zero on read (as mood
-- is), and dropped once it reaches nothing so idle pairs cost no storage.
local function settled_acq(pg, other, now)
	if not pg or not pg.acq then return 0 end
	local a = pg.acq[other]
	if not a then return 0 end
	local elapsed = now - (a.day or now)
	if elapsed > 0 then
		local drift = ACQ_DECAY * elapsed
		if a.op > 0 then a.op = math.max(0, a.op - drift)
		else a.op = math.min(0, a.op + drift) end
		a.day = now
		dirty = true
	end
	if a.op == 0 then pg.acq[other] = nil ; return 0 end
	return a.op
end

-- a's meeting-formed opinion of b (0 when they have never met or it has faded).
function memory.acq_key(a, b)
	if not a or not b or a == b then return 0 end
	return settled_acq(page_by_key(a, false), b, today())
end

-- a and b have crossed paths: shift a's opinion of b by `delta`, clamped. Called
-- both ways round by the mingle hook, once per direction, so each keeps their own.
function memory.meet_key(a, b, delta)
	if not a or not b or a == b or delta == 0 then return end
	local pg = page_by_key(a, true)
	pg.acq = pg.acq or {}
	local now = today()
	local cur = settled_acq(pg, b, now)
	local rec = pg.acq[b]
	if not rec then rec = {op = 0, day = now} ; pg.acq[b] = rec end
	rec.op  = clamp(cur + delta, -ACQ_CAP, ACQ_CAP)
	rec.day = now
	if rec.op == 0 then pg.acq[b] = nil end
	dirty = true
end

--------------------------------------------------------------------------------
-- Opinion of a particular player
--------------------------------------------------------------------------------

local function record_by_key(k, pname, create)
	local pg = page_by_key(k, create)
	if not pg then return end
	local r = pg.players[pname]
	if not r then
		if not create then return end
		r = {opinion = 0, day = today(), deeds = {}}
		pg.players[pname] = r
		dirty = true
	end
	return r
end

local function record(self, pname, create)
	return record_by_key(key_of(self), pname, create)
end

-- The bottom this villager's regard will not decay past, given what the player
-- has done for them. Never above the current opinion, so decay only slows and
-- never invents goodwill. Counts the good turns they remember; the sour ones
-- (negative-worth deeds) are what the grudge side is for and do not count here.
local function earned_opinion_floor(r)
	local good = 0
	for kind, n in pairs(r.deeds or {}) do
		if (memory.DEEDS[kind] or 0) > 0 then good = good + n end
	end
	if good < FLOOR_AFTER_DEEDS then return 0 end
	return math.min(OPINION_FLOOR, r.opinion)
end

local function settled_opinion(r)
	if not r then return 0 end
	local now = today()
	local elapsed = now - (r.day or now)
	if elapsed > 0 then
		local rate = r.opinion < 0 and OPINION_DECAY_BAD or OPINION_DECAY_GOOD
		local drift = rate * elapsed
		if r.opinion > 0 then
			r.opinion = math.max(earned_opinion_floor(r), r.opinion - drift)
		else
			r.opinion = math.min(0, r.opinion + drift)
		end
		r.day = now
		dirty = true
	end
	return r.opinion
end

function memory.opinion(self, pname)
	return settled_opinion(record(self, pname, false))
end

-- Everything a villager has to weigh about one player: what the village thinks,
-- plus what they think themselves.
--
-- The sum, not an average: a village that has written you off still has, here
-- and there, someone who remembers you differently, and that person should be
-- perceptibly warmer without the village's verdict ceasing to mean anything.
function memory.regard(self, pname, village_score)
	return clamp((village_score or 0) + memory.opinion(self, pname), -100, 100)
end

--------------------------------------------------------------------------------
-- Deeds
--------------------------------------------------------------------------------

-- What one player can do to one villager, and what it is worth to them. These
-- are personal: the village-wide consequences of the same acts live in
-- reputation.lua and are applied alongside, not instead.
memory.DEEDS = {
	rescued        =  14,  -- killed something that was attacking them
	gift           =   9,
	traded         =   2,  -- capped per day, as trade reputation is
	greeted        =   1,  -- a first conversation on a given day
	-- Being good company, and being a boor. Deliberately the smallest values
	-- here bar `greeted`: a conversation is a conversation, and if talking
	-- well were worth as much as pulling somebody out of a fire then the way
	-- to be loved by a village would be to stand in the square clicking.
	-- Capped per day for exactly that reason.
	amused         =   2,
	offended       =  -3,
	struck         = -18,
	robbed         = -14,  -- caught taking from a container they could see
	trespassed     =  -8,  -- caught sleeping in the inn without paying for it
	kin_killed     = -30,
	neighbour_died = -10,
}

-- Kinds a player can repeat indefinitely, and how much of each is worth
-- anything in one day. Without a ceiling, standing is a function of how long
-- somebody was willing to stand at the counter -- or, for the conversational
-- ones, of how many times they clicked the same button.
--
-- Absolute values: `offended` is capped by how much *worse* it can make things,
-- so a boor cannot dig an unrecoverable hole in one afternoon either.
local DAILY_CAP = {
	traded = 6,
	amused = 4,
	offended = 9,
}

-- Things that count once a day however often they happen. Being spoken to is
-- worth a little; being spoken to forty times in a row is worth the same, or
-- standing becomes a reward for clicking.
local ONCE_PER_DAY = {greeted = true}

-- Remember something a player did, against a villager identified by key.
--
-- Keyed rather than entity-based so callers that outlive the luaentity -- the
-- shop session, a witness list, a queued event -- can write to it without
-- holding a reference that would keep an unloaded mob's table alive.
function memory.remember_key(key, pname, kind, scale)
	if not pname or not kind then return end
	local worth = memory.DEEDS[kind]
	if not worth then return end

	local r = record_by_key(key, pname, true)
	if not r then return end

	local before = settled_opinion(r)

	if ONCE_PER_DAY[kind] then
		r.daily = r.daily or {}
		local now = today()
		if r.daily[kind] == now then return before end
		r.daily[kind] = now
	end

	-- Anything a player can repeat indefinitely is capped per day, exactly as
	-- trade is in reputation.lua.
	local cap = DAILY_CAP[kind]
	if cap then
		local now = today()
		r.capped = r.capped or {}
		if r.cap_day ~= now then
			r.cap_day, r.capped = now, {}
		end
		local used = r.capped[kind] or 0
		if used >= cap then return before end
		r.capped[kind] = used + math.abs(worth)
	end

	r.opinion = clamp(before + worth * (scale or 1), OP_MIN, OP_MAX)
	r.day = today()
	r.deeds[kind] = (r.deeds[kind] or 0) + 1
	r.last = kind
	r.last_day = today()
	dirty = true

	return r.opinion
end

function memory.remember(self, pname, kind, scale)
	return memory.remember_key(key_of(self), pname, kind, scale)
end

-- Has this player ever done this to this villager?
function memory.did(self, pname, kind)
	local r = record(self, pname, false)
	return (r and r.deeds[kind] or 0) > 0
end

-- Below this a villager would not bring it up unprompted. Saying hello is
-- remembered -- it moves their opinion -- but it is not something anybody
-- describes as knowing you, and without a floor here every villager in the
-- world has an opinion piece about the one time you said good morning.
local NOTABLE_MIN = 8

-- The single thing this villager would bring up about a player, as a
-- {kind, count, day} record, or nil if they have nothing to say. Picked by
-- weight rather than recency: being pulled out of a fire outranks a haggle.
function memory.notable(self, pname)
	local r = record(self, pname, false)
	if not r then return end
	local best, best_weight
	for kind, n in pairs(r.deeds) do
		local w = math.abs(memory.DEEDS[kind] or 0) * math.min(n, 3)
		if w >= NOTABLE_MIN and (not best_weight or w > best_weight) then
			best, best_weight = kind, w
		end
	end
	if not best then return end
	return {kind = best, count = r.deeds[best], day = r.last_day}
end

-- How many separate people this villager has met.
function memory.acquaintances(self)
	local pg = page(self, false)
	if not pg then return 0 end
	local n = 0
	for _ in pairs(pg.players) do n = n + 1 end
	return n
end

--------------------------------------------------------------------------------
-- Clearing up
--------------------------------------------------------------------------------

-- Erase one specific thing a player did from a villager's book, as if it had
-- never been seen -- the repair tool for a grudge an act left behind after that
-- act stopped counting, such as a theft in what has since become your own town,
-- witnessed before the founder exemption existed. Only that one deed goes: the
-- villager's mood, their opinion of everyone else, and everything else they
-- remember about this player, are untouched.
function memory.pardon(key, pname, kind)
	local r = record_by_key(key, pname, false)
	if not r or not r.deeds or not r.deeds[kind] then return false end
	r.deeds[kind] = nil
	-- Lift whatever ill feeling this act was still contributing, but no further:
	-- a pardon reaches indifference, not fondness, so it can never leave the
	-- villager liking you for a theft you talked your way out of.
	local worth = memory.DEEDS[kind] or 0
	if worth < 0 then
		r.opinion = math.min(0, settled_opinion(r) - worth)
		r.day = today()
	end
	if r.last == kind then r.last, r.last_day = nil, nil end
	dirty = true
	return true
end

-- A villager who is gone for good takes their memories with them. Called by
-- succession; without it the book grows for the lifetime of the world.
function memory.forget(key)
	if memory.book[key] then
		memory.book[key] = nil
		dirty = true
	end
end

function memory.forget_entity(self)
	local k = key_of(self)
	if k then memory.forget(k) end
end
