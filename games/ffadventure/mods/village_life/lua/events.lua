-- Things that happen.
--
-- Until now the only things a village registered were the ones wired directly
-- into a consequence: a punch adjusted reputation, a death raised the alarm.
-- Nothing was *recorded*, so nothing could be talked about afterwards, and no
-- villager could distinguish what they had seen from what the whole settlement
-- somehow knew at once.
--
-- An event is a small immutable record of one occurrence. Raising it does two
-- things and no more: it finds who could actually see it, and it hands the
-- record to those people (gossip.lua takes it from there). Consequences stay
-- where they were -- this is a record of what happened, not a rule about what
-- it costs.

local util = village_life.util
local home = village_life.home

local events = {}
village_life.events = events

--------------------------------------------------------------------------------
-- Kinds
--------------------------------------------------------------------------------

-- `weight`   how newsworthy: decides what a villager repeats when they have
--            more news than room, and what survives being retold.
-- `travels`  whether word of it can reach other villages at all. Most of
--            village life is of no interest one valley over.
-- `mood`     what learning of it does to the villager who hears it.
events.KINDS = {
	death       = {weight = 90, travels = true,  mood = -14},
	murder      = {weight = 100, travels = true, mood = -20},
	raid        = {weight = 70, travels = false, mood = -10},
	theft       = {weight = 55, travels = true,  mood = -6},
	trespass    = {weight = 40, travels = false, mood = -5},
	assault     = {weight = 60, travels = true,  mood = -8},
	rescue      = {weight = 65, travels = true,  mood = 8},
	feat        = {weight = 75, travels = true,  mood = 6},
	trade       = {weight = 20, travels = false, mood = 1},
	succession  = {weight = 50, travels = false, mood = -4},
	-- Somebody has come to settle from somewhere else. Travels, because a new
	-- face with a story behind them is exactly the sort of thing a village talks
	-- about; mildly good news, because an arrival is a small hope.
	arrival     = {weight = 45, travels = true,  mood = 3},
	sighting    = {weight = 35, travels = false, mood = -3},
	blessing    = {weight = 45, travels = false, mood = 6},
	weather     = {weight = 15, travels = false, mood = -2},
}

-- How far away something can be noticed at all. Beyond this it did not happen
-- as far as anyone here is concerned.
local SEE = 22

--------------------------------------------------------------------------------
-- Witnesses
--------------------------------------------------------------------------------

-- The keys of villagers who could see `pos`.
--
-- Walks the roster rather than the world: it is already the list of villagers
-- that exist right now, it is keyed by exactly the identity memory and gossip
-- use, and it is small. Filtering by village prefix first keeps a raid in one
-- settlement from testing line of sight against every villager in the world.
function events.witnesses(village_id, pos, radius)
	local out = {}
	if not pos then return out end
	radius = radius or SEE
	local prefix = village_id and (village_id .. "/")

	for key, entry in pairs(home.roster) do
		if not prefix or key:sub(1, #prefix) == prefix then
			local opos = entry.obj and entry.obj:get_pos()
			if opos and util.dist(opos, pos) <= radius then
				-- Eye height, or a villager standing behind a fence witnesses
				-- nothing and one on the far side of a wall witnesses
				-- everything their feet can see under it.
				local from = {x = opos.x, y = opos.y + 1.4, z = opos.z}
				local to = {x = pos.x, y = pos.y + 1.0, z = pos.z}
				if not minetest.line_of_sight
						or minetest.line_of_sight(from, to) then
					out[#out + 1] = key
				end
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Raising
--------------------------------------------------------------------------------

local next_id = 0

-- Raise an event. `def` carries:
--
--   kind         one of events.KINDS
--   village_id   whose business it is
--   pos          where it happened
--   actor        player name responsible, if a player was
--   subject      villager key it happened to, if it happened to somebody
--   subject_name their name, for retelling after they are gone
--   detail       anything the retelling needs (an item, a monster, a god)
--   witnesses    an explicit list of keys, when the caller already knows who
--                saw it and a line-of-sight sweep would be wrong or wasteful
--
-- Returns the record, or nil if the kind is unknown.
function events.raise(def)
	local kind = events.KINDS[def.kind]
	if not kind then
		village_life.log("warning", "unknown event kind " .. tostring(def.kind))
		return
	end

	next_id = next_id + 1

	local ev = {
		id = next_id,
		kind = def.kind,
		village_id = def.village_id,
		pos = def.pos and vector.round(def.pos) or nil,
		actor = def.actor,
		-- The doer is a villager (a guard, a champion) rather than a player, so
		-- it phrases differently and does not feed a player's notoriety.
		actor_villager = def.actor_villager,
		subject = def.subject,
		subject_name = def.subject_name,
		detail = def.detail,
		day = minetest.get_day_count and minetest.get_day_count() or 0,
		at = util.now(),
		weight = def.weight or kind.weight,
		travels = kind.travels,
	}

	local seen = def.witnesses
			or events.witnesses(def.village_id, ev.pos, def.radius)

	-- Someone it happened *to* knows about it whether or not they had line of
	-- sight to their own back. Being robbed in the dark is still being robbed.
	if ev.subject then
		local already = false
		for _, k in ipairs(seen) do
			if k == ev.subject then already = true ; break end
		end
		if not already then seen[#seen + 1] = ev.subject end
	end

	ev.seen_by = #seen

	if village_life.gossip then
		village_life.gossip.witness(seen, ev, kind.mood)
	end

	village_life.log("info", ("event %s in %s, %d witness(es)"):format(
			ev.kind, tostring(ev.village_id), #seen))

	return ev
end

--------------------------------------------------------------------------------
-- Retelling
--------------------------------------------------------------------------------

-- What an event sounds like, said by someone who has it `hops` removed from
-- the source. First hand is specific; a rumour four people old has lost the
-- details and gained a certainty it never had.
--
-- Kept here rather than in gossip.lua because it is a property of the event
-- kind, and because everything that speaks -- dialogue, a priest's sermon, a
-- guard's warning -- wants the same sentence.
-- The doer, as they would be named at this remove. First-person ("you") is not
-- handled here -- it needs the verb to agree too ("you were", not "you was"), so
-- retell does it up front. This only ever names somebody else.
local function who(ev, hops, listener)
	if ev.actor and hops <= 1 then return ev.actor end
	-- A villager doer is one of the village's own, not a passing outsider, so
	-- their name fades into "one of ours" rather than "some outsider".
	if ev.actor and ev.actor_villager then return "one of ours" end
	if ev.actor and hops <= 2 then return "some outsider" end
	if ev.actor then return "somebody" end
	return nil
end

local function whom(ev, hops, listener)
	if listener and ev.subject_name == listener then return "you" end
	if ev.subject_name and hops <= 2 then return ev.subject_name end
	if ev.subject_name then return "one of ours" end
	return "somebody"
end

function events.retell(ev, hops, listener)
	hops = hops or 0
	local actor = who(ev, hops, listener)
	local subject = whom(ev, hops, listener)
	local vague = hops >= 3

	-- Told to the doer's own face. Written in the first person so the grammar
	-- agrees ("you were", "it was yours"), and starting with a capital "You" so
	-- that when a rumour frame lowercases the clause ("they're saying you...") it
	-- still reads. Only the kinds a player can be the actor of need this; anything
	-- else falls through to the third-person telling below.
	local mine = listener ~= nil and ev.actor == listener and not ev.actor_villager
	if mine then
		if ev.kind == "murder" then
			return ("You killed %s."):format(subject), vague
		elseif ev.kind == "assault" then
			return ("You laid hands on %s."):format(subject), vague
		elseif ev.kind == "theft" then
			local what = ev.detail and ev.detail.item_name
			if what and not vague then
				return ("You took %s that wasn't yours."):format(what), vague
			end
			return "You've been taking what isn't yours.", vague
		elseif ev.kind == "trespass" then
			return "You bedded down at the inn without paying for it.", vague
		elseif ev.kind == "rescue" then
			return ("You pulled %s out of trouble."):format(subject), vague
		elseif ev.kind == "feat" then
			local what = ev.detail and ev.detail.what or "something that needed doing"
			return ("You killed %s."):format(what), vague
		elseif ev.kind == "trade" then
			return "You've been good custom here.", vague
		end
	end

	if ev.kind == "murder" then
		if actor then
			return ("%s killed %s."):format(actor, subject), vague
		end
		return ("%s was killed."):format(subject), vague

	elseif ev.kind == "death" then
		return ("%s is dead."):format(subject), vague

	elseif ev.kind == "assault" then
		if actor then return ("%s laid hands on %s."):format(actor, subject), vague end
		return ("%s was set upon."):format(subject), vague

	elseif ev.kind == "theft" then
		local what = ev.detail and ev.detail.item_name
		if actor and what and not vague then
			return ("%s was seen taking %s that wasn't theirs."):format(actor, what), vague
		elseif actor then
			return ("%s has been helping themselves to what isn't theirs."):format(actor), vague
		end
		return "Things have been going missing.", vague

	elseif ev.kind == "trespass" then
		if actor then
			return ("%s was seen bedding down at the inn without paying for it."):format(actor), vague
		end
		return "Somebody's been sleeping at the inn and not paying for the bed.", vague

	elseif ev.kind == "rescue" then
		if actor then return ("%s pulled %s out of trouble."):format(actor, subject), vague end
		return ("%s got out of trouble somehow."):format(subject), vague

	elseif ev.kind == "feat" then
		local what = ev.detail and ev.detail.what or "something that needed doing"
		if actor then return ("%s killed %s."):format(actor, what), vague end
		return ("Somebody killed %s."):format(what), vague

	elseif ev.kind == "raid" then
		local what = ev.detail and ev.detail.what or "something"
		return ("%s came out of the dark at us."):format(what), vague

	elseif ev.kind == "sighting" then
		local what = ev.detail and ev.detail.what or "something"
		if vague then return "There's been something about, they say.", vague end
		return ("There was %s out past the fields."):format(what), vague

	elseif ev.kind == "succession" then
		local trade = ev.detail and ev.detail.title
		if trade then
			return ("%s has taken up as %s."):format(subject, trade), vague
		end
		return ("%s has come of age."):format(subject), vague

	elseif ev.kind == "arrival" then
		local from = ev.detail and ev.detail.from
		if from then
			return ("%s has come to settle here, from %s."):format(subject, from), vague
		end
		return ("%s has come to settle here."):format(subject), vague

	elseif ev.kind == "blessing" then
		local god = ev.detail and ev.detail.deity
		if god then return ("%s was named over the water."):format(god), vague end
		return "There was a blessing said.", vague

	elseif ev.kind == "trade" then
		if actor then return ("%s has been dealing with us."):format(actor), vague end
		return "Trade's been steady.", vague

	elseif ev.kind == "weather" then
		return (ev.detail and ev.detail.what) or "The weather's been against us.", vague
	end

	return nil
end
