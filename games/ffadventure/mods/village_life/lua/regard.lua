-- What one villager thinks of another.
--
-- kin.lua already works out who is married to whom, who works alongside whom
-- and who lives two doors down. Nothing ever read it back, so the one question
-- everybody actually wants to ask in a village -- "what do you make of him,
-- then?" -- had no answer at all.
--
-- Nothing here is stored. A regard is a pure function of the two identities,
-- their relationship, and their two characters, all of which are themselves
-- derived. That means:
--
--   * the smith thinks the same thing of the baker after a restart, in a
--     backup, and on somebody else's server;
--   * it can be computed for people who are not loaded, because
--     persona.for_identity works off the key alone -- which is what lets a
--     villager have a view of the man across the village without that man
--     being spawned;
--   * and asking A about B, then B about A, gives two different answers,
--     because the seed is the *ordered* pair. Mutual dislike is a special
--     case, not the default, and the asymmetry is free.
--
-- The rule from traits.lua holds here too: nothing is said as fact that the
-- world does not model. Every specific detail in a line -- their trade, their
-- age, their hobby, what keeps them up at night -- is read from the same bed
-- rows and the same derivations the subject themselves would answer from. Ask
-- them yourself and they will say the same thing.

local util = village_life.util
local home = village_life.home
local kin  = village_life.kin

local regard = {}
village_life.regard = regard

--------------------------------------------------------------------------------
-- Who a villager can be asked about
--------------------------------------------------------------------------------

-- Everyone this villager sees often enough to have a view of: their household,
-- the people at their workplace, and the heads of the houses nearby. Rows are
--
--   {key, name, title, relation, bed, plot_nr, bed_nr, how}
--
-- where `how` is "kin" | "colleague" | "neighbour" -- the reason they know
-- them, which is what the answer is framed by.
--
-- Cached per entity in the weak scratch table, as kin's own lookups are.
function regard.people(self)
	local s = util.scratch(self)
	if s.people then return s.people end

	local out, seen = {}, {}
	s.people = out

	local r = home.resolve(self)
	if not r then return out end

	local me = home.key(r.village_id, r.plot_nr, r.bed_nr)

	local function add(plot_nr, bed_nr, bed, relation, how)
		if not bed or not bed.first_name then return end
		local key = home.key(r.village_id, plot_nr, bed_nr)
		if key == me or seen[key] then return end
		seen[key] = true
		out[#out + 1] = {
			key = key, name = bed.first_name, title = bed.title,
			relation = relation, how = how, bed = bed,
			plot_nr = plot_nr, bed_nr = bed_nr,
			village_id = r.village_id,
			dead = bed.dead == true,
		}
	end

	-- Household first: these are the people they would name first.
	local k = kin.of(self)
	for _, row in ipairs((k and k.all) or {}) do
		add(r.plot_nr, row.bed_nr, row.bed, row.relation, "kin")
	end

	for _, row in ipairs(kin.colleagues(self)) do
		add(row.plot_nr, row.bed_nr, row.bed, nil, "colleague")
	end

	-- Neighbours are named by the head of the household -- bed 1 -- which is
	-- what "the family two doors down" means to somebody standing in the
	-- street.
	for _, row in ipairs(kin.neighbours(self)) do
		local bed = row.bpos and row.bpos.beds and row.bpos.beds[1]
		add(row.plot_nr, 1, bed, nil, "neighbour")
	end

	return out
end

--------------------------------------------------------------------------------
-- How they feel about them
--------------------------------------------------------------------------------

-- Who gets on with whom, by temperament. Deliberately not symmetric: the shy
-- find the gruff frightening while the gruff barely notice the shy, and an
-- earnest person's dislike of a sly one is not returned in kind -- the sly
-- rather enjoy them. Absent pairs are 0.
local CHEMISTRY = {
	gruff   = {gruff = -6, proud = -10, shy = -4, warm = 4, earnest = -5,
			dreamy = -8, sly = -4},
	warm    = {warm = 8, shy = 10, weary = 7, earnest = 8, gruff = 5,
			proud = -2, dreamy = 4},
	shy     = {gruff = -13, proud = -11, sly = -9, warm = 10, earnest = 8,
			shy = 5, dreamy = 4},
	proud   = {proud = -15, gruff = -8, sly = -7, earnest = 4, shy = 2,
			weary = -5},
	weary   = {weary = 6, proud = -9, dreamy = -7, warm = 6, earnest = -3,
			gruff = 2},
	sly     = {sly = -9, earnest = -11, proud = -7, dreamy = 6, warm = 4,
			shy = 3},
	earnest = {earnest = 7, sly = -14, warm = 8, gruff = -4, proud = 3,
			dreamy = -2},
	dreamy  = {dreamy = 9, gruff = -9, weary = -4, warm = 5, sly = 5,
			earnest = -2},
}

-- What the relationship itself is worth before anybody's character comes into
-- it. Family is warmer at the floor and no less varied at the top -- the seed
-- spread is untouched, so an unhappy marriage is perfectly possible, just not
-- the usual case.
local RELATION_BIAS = {
	spouse = 22, child = 26, parent = 20, sibling = 6,
	grandparent = 14, grandchild = 20,
	["parent-in-law"] = -6, ["child-in-law"] = -4,
}

-- Half the spread of the seeded base, which is the largest single term: two
-- people with nothing else to go on are mostly a roll.
local BASE = 34

function regard.between(a_key, b_key, opts)
	if not a_key or not b_key or a_key == b_key then return 0 end
	opts = opts or {}

	local rng = util.rng("regard", a_key, b_key)
	local score = util.rng_float(rng, -BASE, BASE)

	score = score + (RELATION_BIAS[opts.relation] or 0)

	-- Working alongside somebody is warming; being the *second* person in one
	-- village with the same trade is not. There is one forge and one set of
	-- customers, and mg_villages will happily title two people "smith".
	if opts.how == "colleague" then score = score + 8 end
	if opts.rival then score = score - 20 end

	local pa = village_life.persona.for_identity(a_key)
	local pb = village_life.persona.for_identity(b_key)
	local row = CHEMISTRY[pa.temperament]
	score = score + ((row and row[pb.temperament]) or 0)

	-- A villager having a bad week is harder on everybody, which is why the
	-- same pair can read differently a fortnight apart.
	score = score + (village_life.memory.mood_key(a_key) or 0) * 0.18

	-- Everything above is the *natural* affinity: who they are, not what has
	-- passed between them. On top of it sits the impression they have actually
	-- formed by meeting -- a stored, slowly-fading nudge (memory.acq_key, driven
	-- by the mingle hook). `raw` leaves it out, which is how that hook reads the
	-- natural score it then nudges, so an opinion can never feed on itself.
	if not opts.raw then
		score = score + (village_life.memory.acq_key(a_key, b_key) or 0)
	end

	return math.max(-100, math.min(100, score))
end

regard.BANDS = {
	{score =  30, band = "fond"},
	{score =  12, band = "warm"},
	{score =  -8, band = "neutral"},
	{score = -28, band = "cool"},
	{score = -100, band = "hostile"},
}

function regard.band(score)
	for _, b in ipairs(regard.BANDS) do
		if score >= b.score then return b.band end
	end
	return "neutral"
end

-- Are these two in the same trade in the same village? Read off the bed rows,
-- so it is true exactly when the village really does have two of them.
local function is_rival(r, row)
	local mine = r and r.title
	return mine ~= nil and mine ~= "" and mine == row.title
end

-- Everything the answer needs, in one place.
function regard.of(self, row)
	local r = home.resolve(self)
	if not r or not row then return 0, "neutral" end
	local me = home.key(r.village_id, r.plot_nr, r.bed_nr)
	local score = regard.between(me, row.key, {
		relation = row.relation,
		how = row.how,
		rival = is_rival(r, row),
	})
	return score, regard.band(score)
end

--------------------------------------------------------------------------------
-- Saying it
--------------------------------------------------------------------------------

-- How they refer to them. Kin get the relationship word kin.lua already builds;
-- everyone else gets the reason they know them, because "the man I work with"
-- and "the family down the lane" are different kinds of acquaintance and a
-- villager would say which.
local GENDERED = {
	spouse = {m = "husband", f = "wife"},
	child = {m = "son", f = "daughter"},
	parent = {m = "father", f = "mother"},
	sibling = {m = "brother", f = "sister"},
	grandparent = {m = "grandfather", f = "grandmother"},
	grandchild = {m = "grandson", f = "granddaughter"},
	["parent-in-law"] = {m = "father-in-law", f = "mother-in-law"},
	["child-in-law"] = {m = "son-in-law", f = "daughter-in-law"},
}

function regard.describe(row)
	if row.relation then
		local g = GENDERED[row.relation]
		return "my " .. ((g and g[row.bed and row.bed.gender]) or row.relation)
	end
	if row.how == "colleague" then
		return row.title and ("the " .. row.title) or "the one I work beside"
	end
	if row.title and row.title ~= "" then return "the " .. row.title end
	return "a neighbour"
end

-- The label on the button. Their name, plus enough to tell two Aldos apart.
function regard.label(row)
	local who = row.name or "somebody"
	if row.relation then
		local g = GENDERED[row.relation]
		local word = (g and g[row.bed and row.bed.gender]) or row.relation
		return ("%s (my %s)"):format(who, word)
	end
	if row.title and row.title ~= "" then
		return ("%s, the %s"):format(who, row.title)
	end
	if row.how == "colleague" then return ("%s (I work with them)"):format(who) end
	return who
end

local OPENERS = {
	fond = {
		"%s? Best of them, and I'll say so to anyone.",
		"%s. There's not a thing I'd say against them.",
		"Oh, %s. Yes. I'd trust them with the house key.",
	},
	warm = {
		"%s? Sound enough. We get on.",
		"%s. No trouble there. Never has been.",
		"%s is all right. Better than most here.",
	},
	neutral = {
		"%s. They're there. That's about the size of it.",
		"%s? Couldn't tell you much. We nod.",
		"%s. I know the face better than the person.",
	},
	cool = {
		"%s. Hm. I'd not go out of my way.",
		"%s? We don't speak, particularly.",
		"%s. I'll leave that where it is, if it's all the same.",
	},
	hostile = {
		"%s. Don't. Just don't.",
		"%s? There's a name I could do without hearing.",
		"%s and I have a history, and none of it's worth your time.",
	},
}

-- Family are talked about differently from neighbours at the same regard: you
-- are stuck with family, which is its own tone.
local KIN_OPENERS = {
	fond = {"%s? That's %s. I'd be lost without them, and don't you tell them."},
	warm = {"%s. That's %s. We manage, which is more than some manage."},
	neutral = {"%s is %s. What do you want me to say? They're family."},
	cool = {"%s. %s, for my sins. We keep out of each other's way."},
	hostile = {"%s is %s and that is the whole of what I'll say about it."},
}

-- Their pastime, if they really have one and it is really there. Read straight
-- out of the traits book by key rather than assigned here: asking about
-- somebody must never be what gives them a hobby, and a hive that was chopped
-- down is not something their neighbour can still describe.
local function pastime_of(key)
	local traits = village_life.traits
	local entry = traits.book[key]
	local def = entry and traits.by_id[entry.id]
	if not def then return end
	if def.class == "simulated" and not entry.pos then return end
	return def.fact
end

-- One specific, true thing. Which one depends on how well the speaker likes
-- them and how far the *player* is trusted -- the worry is somebody's private
-- business, and repeating it is a thing you do for a friend.
local function detail(ctx, row, band)
	local p = village_life.persona.for_identity(row.key)
	local bits = {}

	if row.bed and row.bed.age and row.bed.age < 14 then
		bits[#bits + 1] = ("They're only %d, mind."):format(row.bed.age)
	end

	local hobby = pastime_of(row.key)
	if hobby and (band == "fond" or band == "warm" or band == "neutral") then
		bits[#bits + 1] = ("They're forever %s."):format(hobby)
	end

	if band == "cool" or band == "hostile" then
		bits[#bits + 1] = ("Ask them about %s sometime, if you've an hour."):format(
				p.opinion:gsub("^the ", "the "))
	elseif p.opinion then
		bits[#bits + 1] = ("They'll tell you %s, given half a chance."):format(
				p.opinion)
	end

	-- The confidence. Only for someone they are fond of -- you do not repeat a
	-- friend's trouble to a stranger to spite them -- and only to a player the
	-- speaker is on real terms with. It is the subject's actual worry, so the
	-- player can go and do something about it, and hire.lua pays for that.
	if (band == "fond" or band == "warm")
			and (ctx.band == "friend" or ctx.band == "ally") then
		bits[#bits + 1] = ("Between us: it's %s that's eating them. Don't say I said."):format(
				p.worry)
	end

	if #bits == 0 then return end
	local rng = util.rng("regard_detail", ctx.pname, row.key,
			minetest.get_day_count and minetest.get_day_count() or 0)
	return bits[rng:next(1, #bits)]
end

-- What this villager says when asked about `row`.
function regard.line(self, row, ctx)
	if not row then return "Who?" end

	-- The dead are not gossiped about, they are mourned. succession keeps the
	-- authority on who has died -- the bed row -- and this reads it rather
	-- than keeping a second list that could disagree.
	if row.dead then
		local dead = village_life.succession.the_dead(row.village_id)
		for _, d in ipairs(dead) do
			if d.plot_nr == row.plot_nr and d.bed_nr == row.bed_nr then
				local line = ("%s is dead. You'll have heard."):format(row.name)
				if d.killed_by == ctx.pname then
					return ("%s is dead. And you know exactly how, so don't stand there asking me."):format(row.name)
				elseif d.killed_by then
					return line .. (" Killed, by a man called %s."):format(d.killed_by)
				end
				return line .. " Something got in. We don't talk about it."
			end
		end
		return ("%s isn't with us any more."):format(row.name)
	end

	local score, band = regard.of(self, row)
	local set = row.relation and KIN_OPENERS[band] or OPENERS[band]
	local rng = util.rng("regard_line", ctx.pname, row.key, band)
	local template = set[rng:next(1, #set)]

	local line
	if row.relation then
		line = template:format(row.name, regard.describe(row))
	else
		line = template:format(row.name)
	end

	local extra = detail(ctx, row, band)
	if extra then line = line .. " " .. extra end

	-- A villager who dislikes somebody is a villager with a reason, and the
	-- reason a village has two of anything is usually competition.
	local r = home.resolve(self)
	if score < -8 and is_rival(r, row) then
		line = line .. (" We're both the %s here. Work that one out."):format(
				row.title)
	end

	return line
end

return regard
