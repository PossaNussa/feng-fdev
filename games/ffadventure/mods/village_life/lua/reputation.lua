-- Standing.
--
-- A number per (player, village), from -100 to +100, that villages remember.
-- It is the only long-lived relationship the player has with an mg_villages
-- settlement, so it has to be earned slowly, felt everywhere, and be
-- recoverable -- a village that hates you forever is just a broken village.
--
-- What moves it is what the village can actually see: trade, defending the
-- place, and violence done to its people. What it changes is prices, what the
-- shops will show you, how you are greeted, and -- at the extremes -- whether
-- anyone will open the door at all.
--
-- Reputation is per village, not global. Word does not travel between
-- settlements, which is what makes it possible to be a hero in one valley and
-- unwelcome in the next.

local util = village_life.util
local rep = {}
village_life.reputation = rep

local storage = minetest.get_mod_storage()

local MIN, MAX = -100, 100

--------------------------------------------------------------------------------
-- Tiers
--------------------------------------------------------------------------------

-- Ordered high to low; the first threshold a score meets wins, so each tier
-- covers [score, next_higher_score).
--
-- This is the *only* ladder. There used to be three -- these tiers, a separate
-- set of conversation bands in dialogue.lua, and three loose constants -- and
-- they disagreed: the shop refused you at -45 while the conversation had
-- already written you off at -60, and the "Show me your wares" button appeared
-- at -25 for a shop that would not open until -45. Anything that wants to know
-- how a village feels about someone asks here.
--
--   band     the face of the tier in conversation
--   label    how a villager describes your standing to you
--   favoured shopkeepers show you the stock kept under the counter
--   shun     they will not trade with you
--   hostile  guards and buff pigmen treat you as a threat
--   silent   they will not talk to you at all
rep.tiers = {
	{score =  75, name = "honoured",   band = "ally",         colour = "#ffd970",
			label = "ally",             favoured = true},
	{score =  40, name = "trusted",    band = "friend",       colour = "#a8e06a",
			label = "friend",           favoured = true},
	{score =  15, name = "welcome",    band = "acquaintance", colour = "#b6d6a0",
			label = "acquaintance"},
	{score = -20, name = "a stranger", band = "neutral",      colour = "#c8c8c8",
			label = "a stranger to them"},
	{score = -45, name = "distrusted", band = "critic",       colour = "#e0b070",
			label = "distrusted"},
	{score = -75, name = "unwelcome",  band = "unwelcome",    colour = "#e08050",
			label = "unwelcome",        shun = true},
	{score = MIN, name = "an enemy",   band = "enemy",        colour = "#e05050",
			label = "an enemy",         shun = true, hostile = true, silent = true},
}

function rep.tier(score)
	for _, t in ipairs(rep.tiers) do
		if score >= t.score then return t end
	end
	return rep.tiers[#rep.tiers]
end

function rep.band(score)
	return rep.tier(score).band
end

-- There are deliberately no SHUN / HOSTILE / FAVOURED numbers any more. Three
-- loose constants beside a tier table is how the ladders drifted apart in the
-- first place -- a threshold is either the edge of a tier or it is a fourth
-- opinion about the same thing. Ask `rep.tier(score)` for the flags, or use the
-- predicates below.
function rep.flag(score, flag)
	return rep.tier(score)[flag] == true
end

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- village_id -> {player -> {score = n, day = last decay day, met = n}}
rep.book = {}

-- pname -> {score, day}. Declared here, beside the book, because load() runs
-- at the bottom of this section and would otherwise be undone by a later
-- initialiser.
rep.notoriety = {}

local dirty = false

local function load()
	local raw = storage:get_string("reputation")
	if raw ~= "" then
		local data = minetest.deserialize(raw)
		if type(data) == "table" then rep.book = data end
	end
	-- Stored separately from the book: it is keyed by player rather than by
	-- village, and a world that predates it should simply have nobody notorious
	-- rather than fail to load its villages.
	local raw_n = storage:get_string("notoriety")
	if raw_n ~= "" then
		local data = minetest.deserialize(raw_n)
		if type(data) == "table" then rep.notoriety = data end
	end
end

local function save()
	if not dirty then return end
	storage:set_string("reputation", minetest.serialize(rep.book))
	storage:set_string("notoriety", minetest.serialize(rep.notoriety))
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

--------------------------------------------------------------------------------
-- Reading and writing
--------------------------------------------------------------------------------

-- Standing drifts back towards indifference at this many points per in-game
-- day. Grudges fade faster than fame is kept, which is deliberate: a village
-- should forgive a bad first impression, but a reputation worth having ought to
-- need maintaining.
--
-- These are per in-game day, and an in-game day is ~20 real minutes: a "few
-- days later" of play is dozens of these. Goodwill decay is therefore small --
-- what stops standing evaporating over a long absence is the earned floor
-- below, not a slow rate alone. Grudges still fade at the old pace, because
-- being forgiven should stay reachable.
local DECAY_TOWARDS_ZERO = 1.0
local DECAY_OF_GOODWILL = 0.18

-- Once a player has genuinely dealt with a village over this many distinct days
-- (see note_visit / e.met), the relationship has set: they are a known,
-- welcome face and no absence drops them back below it. Standing *above*
-- "welcome" -- friend, ally -- is not floored and still has to be kept up, so
-- the maintenance the tier ladder is built on survives for the bands where it
-- means something.
local FLOOR_AFTER_VISITS = 4
local EARNED_FLOOR = 15   -- "welcome"; keep in step with rep.tiers

-- The bottom this particular relationship will not decay past. Never above the
-- current score, so decay can only slow, never hand out free standing.
local function earned_floor(e)
	if (e.met or 0) < FLOOR_AFTER_VISITS then return 0 end
	return math.min(EARNED_FLOOR, e.score)
end

--------------------------------------------------------------------------------
-- Notoriety: the third tier
--------------------------------------------------------------------------------

-- `rep.notoriety` (declared above, with the book) is what a player is known
-- for at all, anywhere.
--
-- This is not a third opinion sitting alongside the village's. It is the
-- impression a village that has never met you starts from -- your reputation
-- arriving before you do. Once a village has dealings of its own, those are
-- what count, and notoriety is only the mark it started at.
--
-- Fed by gossip.lua when something happens that is worth carrying out of the
-- valley, and by nothing else: a village's private grudge stays private.

-- Fame travels less well than infamy. Deliberate: being spoken of as a killer
-- three valleys away is the interesting outcome; being spoken of as a reliable
-- customer is not.
local NOTORIETY_DECAY_BAD = 0.5
local NOTORIETY_DECAY_GOOD = 1.2

-- How much of it a village that has never met you goes on. Well under half, so
-- arriving somewhere new as a known murderer is a cold reception rather than an
-- immediate lynching -- there is still room to be judged on your own conduct.
local PRECEDES = 0.45

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

function rep.notorious(pname)
	local n = rep.notoriety[pname]
	if not n then return 0 end
	local now = today()
	local elapsed = now - (n.day or now)
	if elapsed > 0 then
		local rate = n.score < 0 and NOTORIETY_DECAY_BAD or NOTORIETY_DECAY_GOOD
		local drift = rate * elapsed
		if n.score > 0 then
			n.score = math.max(0, n.score - drift)
		else
			n.score = math.min(0, n.score + drift)
		end
		n.day = now
		dirty = true
	end
	return n.score
end

-- Word gets around. Called by gossip when an event worth travelling is seen.
function rep.spread_word(pname, delta, reason)
	if not pname or not delta or delta == 0 then return end
	local n = rep.notoriety[pname]
	if not n then
		n = {score = 0, day = today()}
		rep.notoriety[pname] = n
	end
	local before = rep.notorious(pname)
	n.score = math.max(MIN, math.min(MAX, before + delta))
	n.day = today()
	dirty = true
	village_life.log("info", ("%s notoriety %+0.1f (%s)"):format(
			pname, delta, reason or "?"))
	return n.score
end

-- The standing a village that has never met this player begins from.
function rep.precedes(pname)
	return rep.notorious(pname) * PRECEDES
end

--------------------------------------------------------------------------------

local function entry(village_id, pname, create)
	local village = rep.book[village_id]
	if not village then
		if not create then return end
		village = {}
		rep.book[village_id] = village
	end
	local e = village[pname]
	if not e then
		if not create then return end
		-- A village meeting you for the first time starts from what it has
		-- heard, not from nothing.
		e = {score = rep.precedes(pname), day = today(), met = 0}
		village[pname] = e
	end
	return e
end

-- Decay is applied lazily on read: villages nobody is dealing with cost
-- nothing, and the arithmetic comes out the same.
local function decayed(e)
	if not e then return end
	local today = minetest.get_day_count and minetest.get_day_count() or 0
	local elapsed = today - (e.day or today)
	if elapsed > 0 then
		local rate = e.score < 0 and DECAY_TOWARDS_ZERO or DECAY_OF_GOODWILL
		local drift = rate * elapsed
		if e.score > 0 then
			e.score = math.max(earned_floor(e), e.score - drift)
		else
			e.score = math.min(0, e.score + drift)
		end
		e.day = today
		dirty = true
	end
	return e
end

function rep.get(village_id, pname)
	if not village_id or not pname then return 0 end
	local e = decayed(entry(village_id, pname, false))
	-- No dealings here yet: they go on what they have heard of you.
	if not e then return rep.precedes(pname) end
	return e.score
end

function rep.adjust(village_id, pname, delta, reason)
	if not village_id or not pname or delta == 0 then return end

	local e = decayed(entry(village_id, pname, true))
	local before = e.score
	e.score = math.max(MIN, math.min(MAX, e.score + delta))
	dirty = true

	if e.score == before then return e.score end

	local tier_before = rep.tier(before).name
	local tier_after = rep.tier(e.score).name

	-- Only tell the player when the *tier* changes. A running commentary on
	-- every coin's worth of goodwill would drown out everything else.
	if tier_before ~= tier_after then
		local village = village_life.home.village(village_id)
		local place = (village and village.name) or "this village"
		local t = rep.tier(e.score)
		minetest.chat_send_player(pname, minetest.colorize(t.colour,
				("In %s you are now %s."):format(place, t.name)))
	end

	village_life.log("info", ("%s %+0.1f in %s (%s)"):format(
			pname, delta, village_id, reason or "?"))

	return e.score
end

-- Wipe the slate with one village: standing back to at least neutral, and the
-- travelling reputation that would drag it straight back down again cleared.
-- This is the number half of "making amends" for a killing -- the admin command
-- pairs it with clearing the grudges individual villagers hold. Never lowers an
-- already-good standing. Returns the standing before and after.
function rep.make_amends(village_id, pname)
	if not village_id or not pname then return end
	local e = entry(village_id, pname, true)
	local before = e.score
	e.score = math.max(e.score, 0)
	e.day = today()
	-- Notoriety is global and keyed by player: leaving it in place would re-sink
	-- this village on the next word of mouth and precede the player, still a
	-- known killer, into every village they have yet to meet.
	rep.notoriety[pname] = nil
	dirty = true
	save()
	return before, e.score
end

-- How many days this player has dealt with this village. Used for greetings --
-- being recognised by a shopkeeper you have used twenty times is most of the
-- point.
--
-- Counted per day rather than per call, because both opening a conversation
-- and opening a shop count as dealing with the place, and a conversation that
-- ends in a purchase is one visit, not two.
function rep.note_visit(village_id, pname)
	if not village_id or not pname then return 0 end
	local e = entry(village_id, pname, true)
	local today = minetest.get_day_count and minetest.get_day_count() or 0
	if e.met_day == today then return e.met or 0 end
	e.met_day = today
	e.met = (e.met or 0) + 1
	dirty = true
	return e.met
end

function rep.visits(village_id, pname)
	local e = entry(village_id, pname, false)
	return e and e.met or 0
end

--------------------------------------------------------------------------------
-- Effects
--------------------------------------------------------------------------------

-- Price multiplier. At +100 goods cost a quarter less, at -100 a third more.
-- Applied on top of speciality, season and demand, and clamped with them.
function rep.price_factor(village_id, pname)
	local score = rep.get(village_id, pname)
	if score >= 0 then return 1 - (score / 100) * 0.25 end
	return 1 + (-score / 100) * 0.33
end

-- ...and the mirror image when selling to them.
function rep.sell_factor(village_id, pname)
	local score = rep.get(village_id, pname)
	if score >= 0 then return 1 + (score / 100) * 0.3 end
	return 1 - (-score / 100) * 0.35
end

function rep.will_trade(village_id, pname)
	return not rep.tier(rep.get(village_id, pname)).shun
end

function rep.is_favoured(village_id, pname)
	return rep.tier(rep.get(village_id, pname)).favoured == true
end

function rep.is_enemy(village_id, pname)
	return rep.tier(rep.get(village_id, pname)).hostile == true
end

-- Whether they will open a conversation at all. Deliberately a lower bar than
-- trading: being refused service is a rebuke, being refused a word is an
-- ending, and the two should not happen at the same moment.
function rep.will_talk(village_id, pname)
	return not rep.tier(rep.get(village_id, pname)).silent
end

-- A player this village has written off, close enough to matter. Villagers
-- treat them the way they treat a monster, and guards go for them.
function rep.enemy_near(village_id, pos, radius)
	if not village_id or not village_life.settings.reputation then return end
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos and util.dist(ppos, pos) <= radius
				and rep.is_enemy(village_id, player:get_player_name()) then
			return player, ppos
		end
	end
end

--------------------------------------------------------------------------------
-- What moves it
--------------------------------------------------------------------------------

rep.VALUES = {
	trade            =   1,   -- per completed purchase, capped per day
	sell_needed      =   2,   -- selling a village what it is short of
	killed_threat    =   3,   -- killing a hostile inside the village
	hurt_villager    = -10,
	-- Tuned against the thresholds above, because the thresholds are what the
	-- player actually experiences: one murder closes the shops, a second turns
	-- the village against you. A guard costs less -- it was a fight, and they
	-- were armed -- so it takes two to be refused service and three to be
	-- hunted.
	killed_villager  = -50,
	killed_defender  = -25,   -- a guard or a buff pigman
}

-- Goodwill from trading is capped per in-game day so a village cannot be
-- farmed by buying and selling the same loaf of bread four hundred times.
local TRADE_GAIN_PER_DAY = 6

function rep.on_trade(village_id, pname, kind)
	if not village_id or not pname then return end
	local e = entry(village_id, pname, true)
	local today = minetest.get_day_count and minetest.get_day_count() or 0

	if e.trade_day ~= today then
		e.trade_day = today
		e.trade_gain = 0
	end

	local value = rep.VALUES[kind] or rep.VALUES.trade
	local room = TRADE_GAIN_PER_DAY - (e.trade_gain or 0)
	if room <= 0 then return end

	value = math.min(value, room)
	e.trade_gain = (e.trade_gain or 0) + value
	rep.adjust(village_id, pname, value, kind)
end

--------------------------------------------------------------------------------
-- Violence
--------------------------------------------------------------------------------

local function attacker_name(hitter)
	if not hitter then return end
	if hitter.is_player and hitter:is_player() then
		return hitter:get_player_name()
	end
end

-- If the killer was a villager or a bound champion, who were they? Returns their
-- spoken name and the village they belong to, so a kill by one of the village's
-- own becomes a `feat` the neighbours gossip about -- "I saw Bjorn kill a 1arm".
local function villager_killer(hitter)
	local ent = hitter and hitter.get_luaentity and hitter:get_luaentity()
	if not ent then return end
	if ent.name == "zombies:buffpig" then
		return ent.game_name or "The champion", ent.vl_village
	end
	if ent.vl and ent.vl.v and ent.game_name and ent.game_name ~= "" then
		return ent.game_name, ent.vl.v
	end
end

-- Hooked onto the villager and buff pigman prototypes by brain.lua and
-- defence.lua, which already wrap do_punch and on_die for threat learning.
-- Villagers carry `vl.v`; buff pigmen carry `vl_village`. Anything else has to
-- be located by where it is standing.
local function village_of(self)
	if self.vl and self.vl.v then return self.vl.v end
	if self.vl_village then return self.vl_village end
	local pos = self.object and self.object:get_pos()
	if not pos then return end
	local _, village_id = village_life.home.village_at(pos, 32)
	return village_id
end

function rep.on_villager_hurt(self, hitter)
	local pname = attacker_name(hitter)
	if not pname then return end
	local village_id = village_of(self)
	if not village_id then return end

	-- Rate-limited: a sword swing is several punches and should not cost four
	-- separate reputations' worth of goodwill.
	local s = util.scratch(self)
	local now = util.now()
	if s.rep_hit and now - s.rep_hit < 2 then return end
	s.rep_hit = now

	rep.adjust(village_id, pname, rep.VALUES.hurt_villager, "struck a villager")
end

function rep.on_villager_killed(self, killer_name, defender)
	if not killer_name then return end
	local village_id = village_of(self)
	if not village_id then return end

	rep.adjust(village_id, killer_name,
			defender and rep.VALUES.killed_defender or rep.VALUES.killed_villager,
			defender and "killed a defender" or "killed a villager")
end

-- Killing something the village is afraid of, inside the village, is the
-- fastest honest way to earn standing.
minetest.register_on_mods_loaded(function()
	if not village_life.settings.reputation then return end

	local threats = village_life.threats
	local home = village_life.home

	-- Wrap every registered mob's on_die once, rather than hooking every mob
	-- mod separately. Only hostiles that die inside a village count.
	for name, def in pairs(minetest.registered_entities) do
		if def._cmi_is_mob or def.type == "monster" then
			local prev = def.on_die
			def.on_die = function(self, pos)
				if threats.is_hostile(self) and pos then
					local killer = self.cause_of_death
							and self.cause_of_death.puncher
					local pname = attacker_name(killer)
					-- What to call the thing that died, spoken with its article.
					local what = threats.describe(name) or name
					local _, village_id = home.village_at(pos,
							threats.ALARM_MARGIN, threats.ALARM_MAX_DY)

					if pname and village_id then
						rep.adjust(village_id, pname,
								rep.VALUES.killed_threat, "killed a " .. name)

						-- Whoever was close enough to be in danger from it
						-- takes it personally. A monster killed in an empty
						-- field is a service to the village; one killed at
						-- someone's door is a rescue, and they remember who.
						if village_life.settings.gossip then
							local saved = village_life.events.witnesses(
									village_id, pos, 8)
							for _, key in ipairs(saved) do
								village_life.memory.remember_key(key, pname,
										"rescued")
							end
							village_life.events.raise({
								kind = #saved > 0 and "rescue" or "feat",
								village_id = village_id,
								pos = pos,
								actor = pname,
								detail = {what = what},
							})
						end

					elseif village_id and village_life.settings.gossip then
						-- A guard, a champion or a roused neighbour made the kill.
						-- No player standing moves, but the village talks about
						-- who did it -- which is the news the player then hears.
						local kname, kvid = villager_killer(killer)
						if kname then
							village_life.events.raise({
								kind = "feat",
								village_id = kvid or village_id,
								pos = pos,
								actor = kname,
								actor_villager = true,
								detail = {what = what},
							})
						end
					end
				end
				if prev then return prev(self, pos) end
			end
		end
	end
end)
