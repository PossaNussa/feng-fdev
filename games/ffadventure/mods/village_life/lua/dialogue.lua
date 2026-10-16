-- Talking to people.
--
-- Right-clicking a villager opens a conversation, not a shop. The shop is one
-- thing you can ask for, once you are on terms where they will show you.
--
-- The point is that a village is *learned* rather than displayed. A villager
-- you have never spoken to is "Stranger" and stays that way until you ask; the
-- village has no name until someone tells you; you find out what the place is
-- short of by asking someone who lives there, not by reading it off a debug
-- command. Everything the old /village_life status printed is in here, said by
-- somebody, and gated behind their willingness to say it.
--
-- What they will tell you depends on standing, so the same six questions play
-- very differently to an ally and to a critic.

local util    = village_life.util
local home    = village_life.home
local market  = village_life.market
local persona = village_life.persona

local dialogue = {}
village_life.dialogue = dialogue

local FORMNAME = "village_life:talk"

--------------------------------------------------------------------------------
-- What the player has learned
--------------------------------------------------------------------------------

-- Knowledge is per player and per villager, because being introduced to the
-- baker tells you nothing about the smith. Stored rather than derived: it is a
-- record of what happened, which is exactly the thing that cannot be
-- recomputed.
--
-- pname -> villager key -> {name = true, job = true, ...}
dialogue.known = {}

local storage = minetest.get_mod_storage()
local dirty = false

local function load()
	local raw = storage:get_string("dialogue")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then dialogue.known = data end
end

local function save()
	if not dirty then return end
	storage:set_string("dialogue", minetest.serialize(dialogue.known))
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

local function key_of(self)
	return village_life.economy.identity(self)
end

-- Keyed rather than entity-based, because being told about somebody is being
-- introduced to them: the baker naming her neighbour teaches you the
-- neighbour's name, and the neighbour is not standing here and may not even be
-- loaded. Everything below is this pair with an entity resolved to its key.
function dialogue.knows_key(pname, key, topic)
	local book = dialogue.known[pname]
	local page = book and key and book[key]
	return page ~= nil and page[topic] == true
end

function dialogue.learn_key(pname, key, topic)
	if not key then return false end
	local book = dialogue.known[pname]
	if not book then book = {} ; dialogue.known[pname] = book end
	local page = book[key]
	if not page then page = {} ; book[key] = page end
	if page[topic] then return false end
	page[topic] = true
	dirty = true
	return true
end

function dialogue.knows(pname, self, topic)
	return dialogue.knows_key(pname, key_of(self), topic)
end

function dialogue.learn(pname, self, topic)
	return dialogue.learn_key(pname, key_of(self), topic)
end

-- Village-level facts are learned once for the whole settlement: the second
-- person to tell you where you are is not telling you anything.
function dialogue.knows_village(pname, village_id, topic)
	local book = dialogue.known[pname]
	local page = book and book["village:" .. tostring(village_id)]
	return page ~= nil and page[topic] == true
end

function dialogue.learn_village(pname, village_id, topic)
	local book = dialogue.known[pname]
	if not book then book = {} ; dialogue.known[pname] = book end
	local k = "village:" .. tostring(village_id)
	local page = book[k]
	if not page then page = {} ; book[k] = page end
	if page[topic] then return false end
	page[topic] = true
	dirty = true
	return true
end

--------------------------------------------------------------------------------
-- Standing
--------------------------------------------------------------------------------

-- Bands come straight off the reputation ladder. They used to be a second set
-- of cut-points declared here, which disagreed with the tiers, with SHUN and
-- with HOSTILE -- so the "Show me your wares" button could appear for a shop
-- that would then refuse to open. There is one ladder now: see rep.tiers.
-- Returns the band, the score this villager is going on, and the village's own
-- verdict underneath it.
--
-- The two differ because a villager weighs what the village thinks *and* what
-- they personally remember. That is what stops a hundred and fifty people
-- reacting to you as one organism: the woman whose life you saved is warmer
-- than her neighbours, and the man you robbed is colder, in the same village on
-- the same day.
local function standing(village_id, pname, self)
	if not village_life.settings.reputation or not village_id then
		return "acquaintance", 0, 0
	end
	local village_score = village_life.reputation.get(village_id, pname)
	local score = village_score
	if self then
		score = village_life.memory.regard(self, pname, village_score)
	end
	return village_life.reputation.band(score), score, village_score
end

local function familiarity(band, knows_name)
	if band == "ally" or band == "friend" then return "friend" end
	if knows_name then return "known" end
	return "stranger"
end

-- Two lines drawn across the bands, so topics say what they mean about
-- standing rather than each listing the bands it excludes.

-- Will still tell you about the village, however coolly.
local function cordial(ctx)
	return ctx.band ~= "enemy" and ctx.band ~= "unwelcome"
end

-- Will volunteer something they were not asked for: what the place needs, what
-- they do with their evenings.
local function forthcoming(ctx)
	return cordial(ctx) and ctx.band ~= "critic"
end

-- Has this player founded a settlement named after `place`? Returns the town's
-- name (which is `place`, in its own capitalisation) so a villager whose old
-- home bore that name can be told the town that carries it now. Case-folded,
-- because "Dvpige" the town and "dvpige" the post are the same tribute.
local function town_named_after(pname, place)
	if not place or not (village_life.settlement
			and village_life.settlement.towns_of) then
		return nil
	end
	for _, v in pairs(village_life.settlement.towns_of(pname)) do
		if v.name and v.name:lower() == place:lower() then
			return v.name
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Sessions
--------------------------------------------------------------------------------

-- pname -> {
--   ent      luaentity being spoken to
--   line     the text currently in the window
--   asked    what has been asked in this conversation (scratch, not learned)
--   scroll   remembered scrollbar position
--   stack    the menu breadcrumb -- see below
--   options  the entries the last repaint actually drew
-- }
dialogue.talking = {}

local function ent_of(pname)
	local s = dialogue.talking[pname]
	return s and s.ent
end

-- Where in the conversation they are.
--
-- `stack` is a list of {menu = <menu id>, arg = <whatever the menu is about>}.
-- Empty means the top level. One frame is "asking about people"; two is
-- "asking about Freya" -- the argument is what lets a menu be about somebody
-- in particular without a separate topic per villager.
local function frame(session)
	local st = session and session.stack
	return st and st[#st]
end

local function push(session, menu, arg)
	if not session then return end
	session.stack = session.stack or {}
	session.stack[#session.stack + 1] = {menu = menu, arg = arg}
	-- A new list is a new thing to read, from the top of it.
	session.scroll = 0
end

local function pop(session)
	local st = session and session.stack
	if not st or #st == 0 then return end
	st[#st] = nil
	session.scroll = 0
end

--------------------------------------------------------------------------------
-- Topics
--------------------------------------------------------------------------------

-- Each topic: when it is offered, what it is called, and what is said.
--
-- `answer` returns the villager's line. `gate` decides whether the option
-- appears at all, so the list shortens as you exhaust it and lengthens as they
-- warm to you.
local topics = {}

local function add(id, def)
	def.id = id
	topics[#topics + 1] = def
end

-- A menu is a topic that opens a list instead of answering.
--
-- This is here because the conversation had one flat pool of eight slots, and
-- everything worth saying was competing for them. Adding topics to that pool
-- makes it *worse*: the civic questions -- what the village needs, what it is
-- short of -- get crowded off the end, which is the exact failure the weight
-- table was written to stop. A menu costs one slot at the top level and can
-- hold as many questions as it likes underneath.
--
-- Fields, beyond a topic's:
--   intro(ctx)    what they say as the list opens
--   options(ctx)  the entries in it, built fresh each repaint
--   max           how many entries to show (the window scrolls past that)
--
-- An entry is a topic-shaped table: {label, answer(ctx)}, plus optionally
-- `opens = {menu = id, arg = x}` to go a level deeper. Entries have no
-- registered id -- they are handed one at paint time and resolved against what
-- the window actually drew, so a list that changes between painting and
-- clicking cannot answer the wrong question.
local menus = {}

local function add_menu(id, def)
	def.id = id
	def.menu = true
	menus[id] = def
	topics[#topics + 1] = def
end

-- Menus that are only ever reached from inside another one, and so are not
-- offered at the top level.
local function add_submenu(id, def)
	def.id = id
	def.menu = true
	menus[id] = def
end

-- Declared up here rather than beside the field handler because the menu
-- builder needs it: every menu pins "Goodbye", and that is the registered
-- topic, not a copy of it.
local function find_topic(id)
	for _, t in ipairs(topics) do
		if t.id == id then return t end
	end
end

local function display_name(pname, self, r)
	if dialogue.knows(pname, self, "name") then
		return self.game_name or (r and r.name) or "Villager"
	end
	return "Stranger"
end

-- Weights, all in one place so the running order of a conversation can be read
-- at a glance. Introductions come first, the personal things a villager only
-- tells someone they trust come next, and the repeatable civic facts sink to
-- the bottom once you have heard them.
local W = {
	name = 100, job = 90, village = 85,
	-- A priest would rather talk about their god than about the price of
	-- grain, and outranks the ordinary personal topics for it.
	god_priest = 80, sermon = 76, dread = 74, blessing = 72,
	-- Something that actually happened outranks anything a villager merely
	-- thinks. `news` is adjusted by how far it has travelled and how big it
	-- was, so a fresh murder leads and a fourth-hand rumour about the grain
	-- price does not.
	news = 78, deeds = 72, dead = 68,
	-- Someone the player watched leave one place and turn up in another. The
	-- fact of the move sits high (it is the interesting thing about them); the
	-- player's own gesture -- naming a town after their lost post -- sits higher
	-- still, because it is the rare line the player gets to *say*, and the
	-- villager will want to have heard it.
	town_after = 92, moved = 82,
	worry = 70, mood_low = 66, family = 62, pastime = 60, opinion = 55,
	god = 50,
	needs = 40, sells = 38, standing = 30,
	-- The menus. Each costs one slot at the top level however much is inside
	-- it, which is the whole reason they exist. Asking about the neighbours
	-- outranks asking about the country, because a village is people first;
	-- both sit under the civic questions, which are how a player works out
	-- what a place is *for*.
	-- Ranked among themselves only, never against the questions. Asking about
	-- the neighbours leads, because a village is people first; small talk sits
	-- above the country because it is the one that never runs out and so the
	-- one a player must always be able to find.
	people = 44, room = 43, talk = 40, land = 36, hire = 34, settle = 33,
	-- Talking to somebody who is already with you outranks everything: they
	-- are standing there waiting to be told what to do.
	orders = 96,
	-- Small talk sits below the civic questions on purpose. "How are you
	-- keeping?" is pleasant; "what does the village need?" is how a player
	-- finds out what the place is for, and it must not be crowded out by
	-- pleasantries. Somebody genuinely having a bad week uses mood_low instead.
	mood = 25,
	-- what a repeatable topic drops to once it has been used
	stale = 15,
}

add("name", {
	label = "Who are you?",
	weight = function() return W.name end,
	gate = function(ctx) return not ctx.knows_name end,
	answer = function(ctx)
		local r, self = ctx.r, ctx.self
		dialogue.learn(ctx.pname, self, "name")
		local who = self.game_name or (r and r.name)
		-- A wandering trader carries no name off lottmobs; assign and keep one now.
		if not who and ctx.wanderer and village_life.wanderer then
			who = village_life.wanderer.name_for(self)
		end
		who = who or "nobody in particular"

		if ctx.band == "critic" then
			return ("My name's %s, not that it's your business."):format(who)
		end

		local p = persona.of(self)
		if p.temperament == "shy" then
			return ("%s. Um. %s, that's me."):format(who, who)
		elseif p.temperament == "proud" then
			return ("%s. You'll want to remember it."):format(who)
		elseif p.temperament == "gruff" then
			return ("%s. There. Happy?"):format(who)
		end
		return ("%s. And you'd be %s, I take it."):format(who, ctx.pname)
	end,
})

add("job", {
	label = "What do you do here?",
	weight = function() return W.job end,
	gate = function(ctx) return ctx.knows_name and not ctx.knows_job end,
	answer = function(ctx)
		local r, self = ctx.r, ctx.self
		dialogue.learn(ctx.pname, self, "job")

		-- Name and job both given: the introduction is complete, so the plate
		-- over their head can appear now.
		if village_life.reveal_nameplate then
			village_life.reveal_nameplate(self, r)
		end

		-- `self.profession` is never nil and so cannot be used to detect "has no
		-- job": home.spawn passes `bed.title or "villager"` and lottmobs falls
		-- back to "shopkeeper" on top of that, which made every branch below
		-- unreachable -- children, elders and homemakers all answered "I'm the
		-- villager." The bed row's own title is the only honest source, so read
		-- that, and only fall back to the entity's profession for a stray
		-- trader that has no bed row at all.
		-- Someone passing through -- an inn guest or a bedless traveller -- has
		-- no trade to name here; they answer with the road instead. Ahead of the
		-- title check because a traveller's profession *is* "adventurer", which
		-- would otherwise fall through to "I'm the adventurer" below.
		if ctx.adventurer and village_life.adventurer then
			return village_life.adventurer.introduce(self)
		end

		-- A wandering trader has no bed row and its lottmobs profession is unset,
		-- so it would otherwise fall through to "I keep the house". It names its
		-- trade in its own voice instead.
		if ctx.wanderer and village_life.wanderer then
			return village_life.wanderer.introduce(self)
		end

		local title = r and r.title
		if not r then title = self.profession end
		local role = r and r.role

		if not title or title == "" then
			if role == "child" then
				return "Nothing yet! I'm not old enough. I fetch water, mostly."
			elseif role == "elder" then
				return "I did my share. Now I sit, and watch, and complain."
			elseif role == "guest" then
				return "I'm only passing through, same as you."
			end
			return "I keep the house. It's more work than it sounds."
		end

		-- A redeemed beastman names its town role in its own voice -- and the
		-- fearsome "monster" says out loud that the folk here keep their distance.
		if title == "hunter" then
			return "I hunt. For your town now, not for myself. Old skills, new masters."
		elseif title == "barbarian" then
			return "I fight. It's what these hands are for. Your enemies are mine now."
		elseif title == "monster" then
			return "They call me the monster. I keep the worse things out. "
					.. "The folk here keep their distance. I don't blame them."
		end

		if role == "guard" then
			return "I hold this post. Quiet work, most nights. Not all of them."
		end

		return persona.hedge(self) ..
				("I'm the %s. Have been for longer than I care to count."):format(title)
	end,
})

-- The road. Only the people passing through are asked about it, and for them it
-- is the thing they would rather talk about than the price of grain -- so it
-- sits high, but only ever appears for an adventurer.
add("adv_road", {
	label = "What's your road, then?",
	weight = function(ctx)
		if not ctx.adventurer then return -1 end
		if ctx.asked.adv_road then return W.stale end
		return 84
	end,
	gate = function(ctx) return ctx.adventurer and ctx.knows_name end,
	answer = function(ctx)
		return village_life.adventurer.why(ctx.self)
	end,
})

-- What they know of the country: a true bearing to a dungeon that is really out
-- there, or a rumour when there is nothing known nearby. Not for someone the
-- village has turned against -- an adventurer reads the room too.
add("adv_tip", {
	label = "Seen anything worth finding?",
	weight = function(ctx)
		if not ctx.adventurer then return -1 end
		if ctx.asked.adv_tip then return W.stale - 1 end
		return 62
	end,
	gate = function(ctx) return ctx.adventurer and forthcoming(ctx) end,
	answer = function(ctx)
		local pos = ctx.self.object and ctx.self.object:get_pos()
		return village_life.adventurer.tip(ctx.self, pos)
	end,
})

-- A tale of somewhere far off. Every adventurer has one; a pirate or a sailor
-- has a dozen and will keep going. Others tell one and let it lie.
add("adv_tale", {
	label = "Tell me of somewhere far off.",
	weight = function(ctx)
		if not ctx.adventurer then return -1 end
		local st = ctx.adv_subtype
		if ctx.asked.adv_tale and st ~= "pirate" and st ~= "sailor" then
			return W.stale
		end
		return (st == "pirate" or st == "sailor") and 58 or 46
	end,
	gate = function(ctx) return ctx.adventurer end,
	answer = function(ctx) return village_life.adventurer.tale(ctx.self) end,
})

-- Pirates and their crew, who know one another the way a family does.
add("adv_crew", {
	label = "Whose flag do you sail under?",
	weight = function(ctx)
		if ctx.adv_subtype ~= "pirate" then return -1 end
		if ctx.asked.adv_crew then return W.stale end
		return 60
	end,
	gate = function(ctx) return ctx.adv_subtype == "pirate" end,
	answer = function(ctx) return village_life.adventurer.crew_talk(ctx.self) end,
})

-- Breaking grim news: a crewmate of theirs has died, and there is no way for the
-- scattered crew to have heard it but from someone who was there. Offered only to
-- a pirate whose flag has actually lost a hand the player can name, and it leads
-- because it is not the sort of thing that keeps.
add("adv_crew_news", {
	label = "I've grim news of your crew.",
	weight = function(ctx)
		if ctx.adv_subtype ~= "pirate" then return -1 end
		if #village_life.adventurer.crew_losses_untold(ctx.self) == 0 then
			return -1
		end
		return 82
	end,
	gate = function(ctx)
		return ctx.knows_name and ctx.adv_subtype == "pirate"
				and #village_life.adventurer.crew_losses_untold(ctx.self) > 0
	end,
	answer = function(ctx) return village_life.adventurer.tell_crew_loss(ctx.self) end,
})

-- A barbarian cannot take their eyes off the village's champion.
add("adv_champion", {
	label = "You keep eyeing our champion.",
	weight = function(ctx)
		if ctx.adv_subtype ~= "barbarian" then return -1 end
		if ctx.asked.adv_champion then return W.stale end
		return 60
	end,
	gate = function(ctx) return ctx.adv_subtype == "barbarian" end,
	answer = function(ctx)
		return village_life.adventurer.champion_admire(ctx.self,
				ctx.self.object and ctx.self.object:get_pos())
	end,
})

-- A retired guard still hunts what comes out of the dark, and will point you at
-- the nearest of it.
add("adv_hunt", {
	label = "You hunt the things in the dark?",
	weight = function(ctx)
		if ctx.adv_subtype ~= "veteran" then return -1 end
		if ctx.asked.adv_hunt then return W.stale end
		return 60
	end,
	gate = function(ctx) return ctx.adv_subtype == "veteran" end,
	answer = function(ctx)
		return village_life.adventurer.hunt(ctx.self,
				ctx.self.object and ctx.self.object:get_pos())
	end,
})

add("village", {
	label = "Where am I?",
	-- Learned once -- being told the village's name twice is pointless -- but
	-- the question does not vanish afterwards. It drops to a low weight and
	-- becomes a plain "where are we again", which a lost player can ask as often
	-- as they like.
	weight = function(ctx)
		if ctx.knows_village_name or (ctx.asked and ctx.asked.village) then
			-- Below the repeatable civic questions, so re-asking where you are
			-- never squats the slot "what does the village need?" wants -- it
			-- fills in only when there is nothing more useful to offer.
			return W.stale - 2
		end
		return W.village
	end,
	gate = function(ctx)
		-- An unbound villager has no village_id, which made knows_village_name
		-- nil rather than false: the gate passed forever and the answer wrote
		-- to the literal key "village:nil". Nobody with no village to name is
		-- asked to name it.
		return ctx.knows_name and ctx.village_id
	end,
	answer = function(ctx)
		local village = ctx.village
		local place = (village and village.name) or "this place"
		local p = persona.of(ctx.self)

		-- First time is the reveal: they tell you the name, once, for the whole
		-- settlement.
		if not ctx.knows_village_name then
			dialogue.learn_village(ctx.pname, ctx.village_id, "name")
			if p.temperament == "weary" then
				return ("%s. It isn't much, but it's dry."):format(place)
			elseif p.temperament == "proud" then
				return ("%s. Best village in the valley, whatever they tell you elsewhere."):format(place)
			elseif p.temperament == "dreamy" then
				return ("%s. Older than it looks. Things have happened here."):format(place)
			end
			return ("You're in %s."):format(place)
		end

		-- Asked again: name the place, and add where it sits -- true, because
		-- land.of reads the actual map around the village.
		local s = village_life.land and village_life.land.of(ctx.village_id)
		local where = place
		if s and s.biome then
			where = ("%s, in the %s"):format(place, s.biome)
		end
		if p.temperament == "gruff" then
			return ("%s. Same as it was a minute ago."):format(where)
		elseif p.temperament == "weary" then
			return ("Still %s. Still here."):format(where)
		end
		return ("You're in %s."):format(where)
	end,
})

add("needs", {
	label = "What does the village need?",
	-- Worth re-asking: what a village is short of moves with the season and
	-- with demand. It just stops being the most interesting thing they know.
	weight = function(ctx)
		if ctx.asked.needs or ctx.knows_needs then return W.stale end
		return W.needs
	end,
	gate = function(ctx)
		return ctx.knows_village_name and forthcoming(ctx)
	end,
	answer = function(ctx)
		local c = market.character(ctx.village_id)
		if not c then return "We get by." end
		dialogue.learn_village(ctx.pname, ctx.village_id, "needs")

		local line = ("We're short of %s. Always have been -- nobody hereabouts works it."):format(c.scarce)
		if ctx.band == "friend" or ctx.band == "ally" then
			line = line .. (" Bring us %s and you'll not find us ungrateful."):format(c.scarce)
		end
		return persona.hedge(ctx.self) .. line
	end,
})

add("sells", {
	label = "What is this village known for?",
	weight = function(ctx)
		if ctx.asked.sells or ctx.knows_sells then return W.stale end
		return W.sells
	end,
	gate = function(ctx)
		return ctx.knows_village_name and cordial(ctx)
	end,
	answer = function(ctx)
		local c = market.character(ctx.village_id)
		if not c then return "A bit of everything. Nothing special." end
		dialogue.learn_village(ctx.pname, ctx.village_id, "sells")

		local season = market.season()
		local line = ("%s. We've the best of it for a day's walk in any direction."):format(
				c.speciality:gsub("^%l", string.upper))
		if season == "winter" then
			line = line .. " Though everything fresh costs dear this time of year."
		elseif season == "autumn" then
			line = line .. " And the harvest is in, so you've come at a good time."
		end
		return line
	end,
})

add("standing", {
	label = "What do people here make of me?",
	-- Always askable -- your standing is exactly the thing that changes -- but
	-- asking twice in one conversation gets the same answer, so it steps aside
	-- for anything else on offer.
	weight = function(ctx)
		if ctx.asked.standing then return W.stale end
		return W.standing
	end,
	gate = function(ctx) return ctx.knows_name end,
	answer = function(ctx)
		-- The question is about the village, so it is answered on the village's
		-- score. What *they* think is a separate sentence, and only gets said
		-- when it differs enough from the village to be worth saying.
		local village_score = ctx.village_score or ctx.score
		local band = village_life.reputation.band(village_score)
		local lines = {
			ally = "You're one of us now. People say your name kindly when you're not here.",
			friend = "You're well thought of. That's not nothing, in a place this size.",
			acquaintance = "You're known. Not much more than that yet, but known.",
			neutral = "Nobody's made their mind up about you. That's the best most outsiders get.",
			critic = "Honestly? People are wary of you. You know why better than I do.",
			unwelcome = "You'll find no doors open to you here. Mine included.",
			enemy = "You're not welcome here. I'd have thought that was obvious.",
		}

		local line = (lines[band] or lines.neutral) ..
				(" (standing: %d)"):format(math.floor(village_score + 0.5))

		local personal = village_life.memory.opinion(ctx.self, ctx.pname)
		if personal >= 10 then
			line = line .. " For my own part, I've no complaints about you."
		elseif personal <= -10 then
			line = line .. " Speaking for myself, I've my own reasons to be wary."
		end
		return line
	end,
})

add("pastime", {
	label = "What do you do when you're not working?",
	weight = function() return W.pastime end,
	gate = function(ctx)
		return ctx.knows_name and forthcoming(ctx) and not ctx.knows_pastime
	end,
	answer = function(ctx)
		dialogue.learn(ctx.pname, ctx.self, "pastime")

		local clause, is_fact = village_life.traits.clause(ctx.self)
		if not clause then
			return persona.hedge(ctx.self) ..
					"Not a great deal. There isn't the time."
		end

		-- A wish is phrased as a wish. The old line stated every pastime as
		-- fact, which is how villagers ended up keeping bees they did not have.
		if not is_fact then
			return persona.hedge(ctx.self) ..
					("I'd %s. As it is, not much."):format(clause)
		end

		local line = persona.hedge(ctx.self) ..
				("I've been %s. Don't tell anyone, they'll only laugh."):format(clause)

		-- If there is really something to see, say where. The player can go and
		-- look, which is the whole point of having built it.
		local pos = village_life.traits.place(ctx.self)
		if pos and (ctx.band == "friend" or ctx.band == "ally") then
			line = line .. " It's round the back, if you want to see."
		end
		return line
	end,
})

add("opinion", {
	label = "Anything I should know about this place?",
	weight = function() return W.opinion end,
	gate = function(ctx)
		return ctx.knows_village_name and cordial(ctx) and not ctx.knows_opinion
	end,
	answer = function(ctx)
		local p = persona.of(ctx.self)
		dialogue.learn(ctx.pname, ctx.self, "opinion")
		local prefix = ctx.band == "critic" and "You'll hear it anyway. "
				or persona.hedge(ctx.self)
		return prefix .. ("I'll say this much: %s."):format(p.opinion)
	end,
})

add("worry", {
	label = "Is something troubling you?",
	weight = function() return W.worry end,
	gate = function(ctx)
		if ctx.knows_worry then return false end
		if not ctx.knows_name then return false end
		-- The reticent have to be liked first. Openness varies per villager, so
		-- the same standing gets you further with some people than others.
		return persona.will_confide(ctx.self, ctx.score)
	end,
	answer = function(ctx)
		local p = persona.of(ctx.self)
		dialogue.learn(ctx.pname, ctx.self, "worry")
		return persona.hedge(ctx.self) ..
				("It's %s. I don't say that to just anyone."):format(p.worry)
	end,
})

--------------------------------------------------------------------------------
-- Religion
--------------------------------------------------------------------------------

local faith = village_life.faith

-- Whose god this is, and whether the speaker is the one who tends the church.
local function patron_of(ctx)
	if not faith.available() or not ctx.village_id then return end
	return faith.patron(ctx.village_id)
end

local function is_priest(ctx)
	local title = ctx.r and ctx.r.title
	return title == "priest"
end

add("god", {
	label = "Who do you keep here?",
	weight = function(ctx)
		if ctx.asked.god or ctx.knows_god then return W.stale end
		-- A priest would rather talk about this than about anything else.
		return is_priest(ctx) and W.god_priest or W.god
	end,
	gate = function(ctx)
		return ctx.knows_name and cordial(ctx) and patron_of(ctx) ~= nil
	end,
	answer = function(ctx)
		local name, def = patron_of(ctx)
		dialogue.learn_village(ctx.pname, ctx.village_id, "god")
		if not def then return "We keep to ourselves." end

		local who = def.epithet or faith.title(name)

		if is_priest(ctx) then
			return ("This is the house of %s, god of %s. %s -- that is the whole of it, and it takes a lifetime.")
					:format(who, def.domain, def.tenet:gsub("^%l", string.upper))
		end

		local p = persona.of(ctx.self)
		if p.temperament == "sly" then
			return ("%s, officially. I keep the feast days and skip the rest."):format(who)
		elseif p.temperament == "earnest" then
			return ("%s, god of %s. My mother had me named on their day."):format(
					who, def.domain)
		end
		return ("%s. God of %s, if you're asking properly."):format(who, def.domain)
	end,
})

add("sermon", {
	label = "What does your god ask of people?",
	weight = function(ctx)
		if ctx.asked.sermon then return W.stale end
		return W.sermon
	end,
	gate = function(ctx)
		return is_priest(ctx) and ctx.knows_god and cordial(ctx)
	end,
	answer = function(ctx)
		local name, def = patron_of(ctx)
		if not def then return "Little enough. Turn up, mostly." end

		local devotion = faith.devotion(ctx.pname, ctx.village_id)
		local line = ("%s asks one thing: %s."):format(
				def.epithet or faith.title(name), def.tenet)

		-- The priest can see how often the player has called on their god,
		-- because faith is counted and this is the person who would count it.
		if devotion >= 25 then
			line = line .. (" You've said their name often enough that I've heard of you, %s.")
					:format(ctx.pname)
		elseif devotion >= 5 then
			line = line .. " You've said it once or twice, I'm told. That's a start."
		elseif devotion <= 0 then
			line = line .. " I've never once heard you say it."
		end

		if def.offering then
			local item = minetest.registered_items[def.offering]
			local label = (item and item.description or def.offering)
					:gsub("\n.*", "")
			line = line .. (" We take %s at the altar, if you're minded."):format(
					label:lower())
		end
		return line
	end,
})

add("dread", {
	label = "And the other names? The ones people don't say.",
	weight = function(ctx)
		if ctx.asked.dread then return W.stale end
		return W.dread
	end,
	gate = function(ctx)
		-- Only a priest will discuss them, and only with someone they trust:
		-- this is the one topic in the mod that is about being told something
		-- the village would rather nobody repeated.
		return is_priest(ctx) and ctx.knows_god and faith.available()
				and (ctx.band == "friend" or ctx.band == "ally")
	end,
	answer = function(ctx)
		-- Name the Outer god the world has spoken of most. It is a real count,
		-- so a server where somebody has been saying Hastur all week gets a
		-- priest who is worried about Hastur.
		local worst, worst_n
		for _, gname in ipairs(lumberjackzombie.deities()) do
			if faith.is_dread(gname) then
				local n = lumberjackzombie.get_global_faith(gname)
				if not worst_n or n > worst_n then worst, worst_n = gname, n end
			end
		end
		if not worst then
			return "There's nothing out there but weather and wolves. Sleep well."
		end

		local def = faith.god(worst)
		local who = (def and def.epithet) or faith.title(worst)

		if (worst_n or 0) <= 0 then
			return ("There are names I won't teach you. %s is one. Nobody here has said it and I'd keep it that way.")
					:format(faith.title(worst))
		end

		local line = ("%s. %s. It's been said aloud %d time%s that I know of, and every one of them was a mistake.")
				:format(faith.title(worst), who, worst_n,
						worst_n == 1 and "" or "s")
		if def and def.tenet ~= "" then
			line = line .. (" If you take one thing from me: %s."):format(def.tenet)
		end
		return line
	end,
})

add("blessing", {
	label = "Would you bless this water?",
	weight = function() return W.blessing end,
	gate = function(ctx)
		if not is_priest(ctx) or not faith.available() then return false end
		if ctx.band ~= "friend" and ctx.band ~= "ally" then return false end
		return dialogue.holding_water(ctx.pname) ~= nil
	end,
	answer = function(ctx)
		local name = patron_of(ctx)
		local blessed = dialogue.bless_water(ctx.pname, name, ctx.village_id)
		if not blessed then
			return "Bring it back when your hands are steadier."
		end
		return ("Hold it still. ...There. %s knows it now. Use it well, and not on people."):format(
				faith.title(name))
	end,
})

--------------------------------------------------------------------------------
-- News, family, the dead, and you
--------------------------------------------------------------------------------

-- Which items of news a player has already been told, this session. Runtime
-- only: event ids are handed out in order of occurrence and do not survive a
-- restart, so persisting this would mean remembering the wrong things.
dialogue.heard = {}

minetest.register_on_leaveplayer(function(player)
	dialogue.heard[player:get_player_name()] = nil
end)

local function news_for(ctx)
	if not village_life.settings.gossip then return end
	return village_life.gossip.for_player(ctx.self, ctx.pname,
			dialogue.heard[ctx.pname])
end

add("news", {
	label = "Heard anything?",
	weight = function(ctx)
		local item = news_for(ctx)
		if not item then return -1 end
		-- Fresh, first-hand news is the most interesting thing anybody in a
		-- village has to say. A fourth-hand rumour about a good day's trade is
		-- not, and sinks accordingly.
		return W.news - (item.hops or 0) * 6
				+ math.min((item.ev.weight or 20) / 5, 12)
	end,
	gate = function(ctx)
		return ctx.knows_name and cordial(ctx) and news_for(ctx) ~= nil
	end,
	answer = function(ctx)
		local item = news_for(ctx)
		if not item then return "Nothing worth repeating." end

		local heard = dialogue.heard[ctx.pname]
		if not heard then heard = {} ; dialogue.heard[ctx.pname] = heard end
		heard[item.ev.id] = true

		-- Remember which item this was, so a follow-up can react to *this* piece
		-- of news rather than whatever is next in the pile.
		local session = dialogue.talking[ctx.pname]
		if session then session.last_news = item end

		local said, is_hearsay = village_life.gossip.phrase(item, ctx.pname)
		if not said then return "Nothing worth repeating." end

		-- Hearsay is attributed, so the player can go and check it. That is the
		-- difference between a rumour and a fact printed on a villager.
		if is_hearsay then
			return persona.hedge(ctx.self) .. said
		end
		return said .. " I saw it myself."
	end,
	-- After a piece of news, you can react to it or ask for the next -- which
	-- turns a one-line rumour into an actual exchange, and lets a player work
	-- through everything a villager has heard in one sitting.
	follow = function(ctx)
		local session = dialogue.talking[ctx.pname]
		local item = session and session.last_news
		if not item then return end

		local kinddef = village_life.events.KINDS[item.ev.kind] or {}
		local grim = (kinddef.mood or 0) < 0
		local out = {}

		out[#out + 1] = {
			label = grim and "That's grim." or "Good to hear.",
			answer = function(c)
				-- Being decent company is worth a little goodwill, once per
				-- conversation, capped in memory besides.
				local s = dialogue.talking[c.pname]
				if s and not s.reacted then
					s.reacted = true
					village_life.memory.remember(c.self, c.pname, "amused")
				end
				local p = persona.of(c.self)
				if grim then
					if p.temperament == "gruff" then return "Aye. Grim's the word." end
					if p.temperament == "weary" then return "It is. Always something." end
					return "It is. Kind of you to say so."
				end
				if p.temperament == "warm" then return "Isn't it just!" end
				return "That it is."
			end,
		}

		out[#out + 1] = {
			label = "Heard anything else?",
			answer = function(c)
				local nxt = news_for(c)
				if not nxt then return "That's the end of the talk, for now." end
				local heard = dialogue.heard[c.pname]
				if not heard then heard = {} ; dialogue.heard[c.pname] = heard end
				heard[nxt.ev.id] = true
				local s = dialogue.talking[c.pname]
				if s then s.last_news = nxt ; s.reacted = nil end
				local said, is_hearsay = village_life.gossip.phrase(nxt, c.pname)
				if not said then return "Nothing else worth repeating." end
				if is_hearsay then return persona.hedge(c.self) .. said end
				return said .. " I saw it myself."
			end,
		}

		return out
	end,
})

-- The strand a follow-up opens: its entries live on the session, put there by
-- whichever answer had something more to say. Reached only from a follow, never
-- offered at the top level.
add_submenu("followup", {
	options = function(ctx)
		local session = dialogue.talking[ctx.pname]
		return (session and session.follow) or {}
	end,
})

add("family", {
	label = "Have you people of your own?",
	weight = function(ctx)
		if ctx.asked.family or ctx.knows_family then return W.stale end
		return W.family
	end,
	gate = function(ctx)
		return ctx.knows_name and forthcoming(ctx)
				and village_life.kin.of(ctx.self) ~= nil
	end,
	answer = function(ctx)
		dialogue.learn(ctx.pname, ctx.self, "family")

		local k = village_life.kin.of(ctx.self)
		if not k then return "Nobody. It suits me." end

		-- The founder who settled this town keeps a bed here too, so the folk they
		-- took in genuinely live with them. If that is who is asking, the villager
		-- says so -- you are a resident of this house, not a caller at its door.
		local roof = ""
		if village_life.kin.lives_with(ctx.self, ctx.pname) then
			roof = " And it's your house we're all under, besides -- I've not"
					.. " forgotten who took us in."
		end

		if not k.family then
			-- Lumberjack huts and barracks: housemates, not relatives.
			-- mg_villages is explicit about this and inventing a marriage from
			-- two adults sharing a roof would marry off the garrison.
			if #k.all == 0 then return "Not here. I keep to myself." .. roof end
			return ("No family here. I share the place with %s and the others.")
					:format(k.all[1].name or "some others") .. roof
		end

		local closest = village_life.kin.closest(ctx.self)
		if not closest then
			return "Not any more. It's a quiet house." .. roof
		end

		local line = ("There's %s."):format(village_life.kin.describe(closest))

		local children = village_life.kin.get(ctx.self, "child")
		if #children == 1 then
			line = line .. (" And %s, who is %d."):format(
					children[1].name, children[1].bed.age or 8)
		elseif #children > 1 then
			line = line .. (" And %d children, which is %d more than I planned.")
					:format(#children, #children - 1)
		end

		-- The dead are family too, and this is where a village stops being a
		-- set of shopfronts.
		if village_life.settings.permadeath then
			for _, d in ipairs(village_life.succession.the_dead(ctx.village_id)) do
				if d.plot_nr == (ctx.r and ctx.r.plot_nr) then
					line = line .. (" There was %s, too. Not any more.")
							:format(d.name or "somebody")
					break
				end
			end
		end
		return line .. roof
	end,
})

add("dead", {
	label = "Has the village lost anyone?",
	weight = function(ctx)
		if ctx.asked.dead then return W.stale end
		return W.dead
	end,
	gate = function(ctx)
		if not village_life.settings.permadeath then return false end
		if not ctx.knows_village_name or not cordial(ctx) then return false end
		return #village_life.succession.the_dead(ctx.village_id) > 0
	end,
	answer = function(ctx)
		local dead = village_life.succession.the_dead(ctx.village_id)
		if #dead == 0 then return "No. We've been lucky." end

		local d = dead[1]
		local who = d.name or "somebody"
		local line = d.title
				and ("%s. %s the %s."):format(
						#dead == 1 and "One" or ("%d, lately"):format(#dead),
						who, d.title)
				or ("%s. %s."):format(
						#dead == 1 and "One" or ("%d, lately"):format(#dead), who)

		if d.killed_by then
			if d.killed_by == ctx.pname then
				-- They know. Being asked about it by the person who did it is
				-- the single most pointed thing a villager can be asked.
				line = line .. " You know exactly how. Don't make me say it."
			else
				line = line .. (" Killed. By a man called %s."):format(d.killed_by)
			end
		else
			line = line .. " Something got in."
		end

		if d.title and village_life.succession.trade_vacant(ctx.village_id, d.title) then
			line = line .. (" We've had no %s since."):format(d.title)
		end
		return line
	end,
})

add("mood", {
	label = "How are you keeping?",
	weight = function(ctx)
		if ctx.asked.mood then return W.stale end
		-- Somebody having a bad week wants to say so.
		return (ctx.mood or 0) < -8 and W.mood_low or W.mood
	end,
	gate = function(ctx) return ctx.knows_name and cordial(ctx) end,
	answer = function(ctx)
		local spirits = village_life.memory.spirits(ctx.self)
		local p = persona.of(ctx.self)

		local lines = {
			cheerful = "Well, thanks for asking. Better than I've any right to be.",
			content  = "No complaints. That's as much as anyone gets.",
			even     = "Same as ever. Which is to say, fine.",
			low      = "Been better. It's been a week of it.",
			wretched = "Badly. I'd rather not go into it.",
		}

		local line = lines[spirits] or lines.even
		if spirits == "wretched" and p.temperament == "gruff" then
			line = "Don't."
		elseif spirits == "cheerful" and p.temperament == "shy" then
			line = "Oh -- well. Quite well, actually. Thank you."
		end
		return line
	end,
})

add("deeds", {
	label = "Do you know me?",
	weight = function(ctx)
		if ctx.asked.deeds then return W.stale end
		return village_life.memory.notable(ctx.self, ctx.pname) and W.deeds or -1
	end,
	gate = function(ctx)
		return ctx.knows_name
				and village_life.memory.notable(ctx.self, ctx.pname) ~= nil
	end,
	answer = function(ctx)
		local n = village_life.memory.notable(ctx.self, ctx.pname)
		if not n then return "Not really. You're a face, that's all." end

		local lines = {
			rescued = "I know what you did for me. I've not forgotten it and I won't.",
			gift = "You've been generous with me. People notice that.",
			traded = "You've been good custom. That counts for something.",
			greeted = "You stop and talk. Most don't.",
			struck = "You put your hands on me. That's what I know about you.",
			robbed = "I know what you took, and I know you knew I was watching.",
			trespassed = "You slept under our roof and never paid for it. We keep an inn, not a barn.",
			kin_killed = "You killed one of mine. Get away from me.",
			neighbour_died = "You brought death into this village. I know that much.",
		}
		local line = lines[n.kind] or "We've crossed paths."

		if (n.count or 1) > 2 then
			line = line .. (" More than once, at that."):format()
		end
		return line
	end,
})

--------------------------------------------------------------------------------
-- Someone who came from somewhere else
--------------------------------------------------------------------------------

-- The one villager the player watched arrive: their bed carries where they came
-- from (backstory.lua). Offered plainly once they are known and on speaking
-- terms, then it settles into the pile like any other thing you have heard.
add("moved", {
	label = "You've settled here recently, haven't you?",
	weight = function(ctx)
		if ctx.asked.moved or ctx.knows_moved then return W.stale end
		return W.moved
	end,
	gate = function(ctx)
		return ctx.moved ~= nil and ctx.knows_name and cordial(ctx)
	end,
	answer = function(ctx)
		dialogue.learn(ctx.pname, ctx.self, "moved")
		local place = ctx.moved.from_place
		local p = persona.of(ctx.self)
		if p.temperament == "gruff" then
			return ("Aye. Kept a trading post once -- %s. Don't, any more."):format(place)
		elseif p.temperament == "weary" then
			return ("I did. I ran a trading post, %s, for more years than I'll count. That's behind me now."):format(place)
		end
		return persona.hedge(ctx.self) ..
				("I did, at that. I used to keep a trading post -- %s, it was. This is where I've landed since."):format(place)
	end,
	-- The place has a story, and a story is worth a few questions: what became of
	-- it, who has it now, whether he minds. Each is a single exchange, and the
	-- strand stays open so you can ask them all before you move on.
	follow = function(ctx)
		local m = ctx.moved
		if not m then return end
		local out = {}
		if m.sold_to then
			out[#out + 1] = {
				label = ("Who has %s now?"):format(m.from_place),
				answer = function(c)
					return ("A man called %s. I sold it to him, fair and square -- he wanted it more than I did by the end. He'll make a decent trade of it."):format(m.sold_to)
				end,
			}
			out[#out + 1] = {
				label = "You sold it? Why leave?",
				answer = function(c)
					local p = persona.of(c.self)
					if p.temperament == "gruff" then
						return ("A post like that runs a man, not the other way about. %s can have the running of it."):format(m.sold_to)
					end
					return ("There comes a day the road looks better than the counter. %s made a fair offer, and I took it, and here I am. No regrets worth the name."):format(m.sold_to)
				end,
			}
		end
		out[#out + 1] = {
			label = ("Do you miss %s?"):format(m.from_place),
			answer = function(c)
				local p = persona.of(c.self)
				if p.temperament == "gruff" then
					return "Some days. Not most. And you'll not repeat the some."
				end
				return "Every so often. It had my name on it, in a manner of speaking. But a place is only a place -- and this one's growing on me."
			end,
		}
		return out
	end,
})

-- The one thing in the whole conversation the player *tells* rather than asks:
-- that they named a settlement of their own after this villager's lost post.
-- Only offered when the player really has such a town (settlement.towns_of), and
-- to a man who lost the place, it is no small thing to hear.
add("town_after", {
	label = "There's something I've been meaning to tell you.",
	weight = function(ctx)
		if ctx.knows_town_after then return W.stale end
		return W.town_after
	end,
	gate = function(ctx)
		return ctx.moved ~= nil and ctx.town_after ~= nil
				and ctx.knows_name and cordial(ctx) and not ctx.knows_town_after
	end,
	answer = function(ctx)
		dialogue.learn(ctx.pname, ctx.self, "town_after")
		-- Hearing it warms him to you, filed like any other kindness done him.
		village_life.memory.remember(ctx.self, ctx.pname, "amused")
		local place = ctx.town_after
		local p = persona.of(ctx.self)
		if p.temperament == "gruff" then
			return ("I founded a town of my own, and I named it %s. After your old post. ...Hmph. That's -- that's a good thing you've done. I'll not forget it."):format(place)
		end
		return ("I founded a settlement of my own, and I called it %s -- after your old trading post. I wanted the name to stand somewhere, even after you'd let the place go. ...I don't rightly know what to say. That's the kindest thing anyone's done for me in a long while, %s."):format(place, ctx.pname)
	end,
})

add("trade", {
	label = "Show me your wares.",
	gate = function(ctx)
		if not village_life.settings.economy then return false end
		-- Ask the shop itself rather than guessing from the standing band. The
		-- button used to appear whenever the band was better than "critic",
		-- while trade.open refused on a different threshold and on shop hours
		-- it did not check -- so clicking it could end the conversation and
		-- open nothing.
		return village_life.trade.refusal(ctx.self, ctx.pname) == nil
	end,
	answer = function(ctx)
		-- Handled specially in on_receive_fields: this closes the conversation
		-- and opens the shop.
		return nil
	end,
	opens_shop = true,
	pinned = true,
})

-- The wandering traders keep their own native lottmobs shop rather than the
-- village_life trade UI (which is keyed to a pigman's shop stock). "Show me your
-- wares" reopens the very window the plain right-click used to, captured at
-- attach time. Only offered while un-settled -- a settled trader trades through
-- the ordinary village shop like any other resident.
add("wares", {
	label = "Show me your wares.",
	gate = function(ctx)
		if not ctx.wanderer or not village_life.wanderer then return false end
		local sp = village_life.wanderer.species(ctx.self)
		return sp ~= nil and sp.native_trade ~= nil
	end,
	answer = function() return nil end,
	opens_native_trade = true,
	pinned = true,
})

--------------------------------------------------------------------------------
-- A room for the night
--------------------------------------------------------------------------------

-- Offered only by whoever actually keeps the inn -- read off their plot, not
-- their job title (lodging.is_keeper). The room is theirs for the night once
-- paid; sleeping in an inn bed unpaid is handled quite separately, by the bed
-- itself, in lodging.lua.
add_menu("room", {
	label = "Have you a room for the night?",
	weight = function(ctx)
		if not village_life.settings.lodging then return -1 end
		local plot_nr = ctx.self.vl and ctx.self.vl.p
		if ctx.asked.room or (plot_nr and village_life.lodging.has_room(
				ctx.pname, ctx.village_id, plot_nr)) then
			return W.stale
		end
		return W.room
	end,
	gate = function(ctx)
		if not village_life.settings.lodging then return false end
		if not ctx.knows_name or not cordial(ctx) then return false end
		if not village_life.lodging.is_keeper(ctx.self) then return false end
		-- A house that will not deal with you will not put you up either.
		if village_life.settings.reputation and ctx.village_id
				and not village_life.reputation.will_trade(ctx.village_id, ctx.pname) then
			return false
		end
		return true
	end,
	intro = function(ctx)
		local plot_nr = ctx.self.vl and ctx.self.vl.p
		if plot_nr and village_life.lodging.has_room(
				ctx.pname, ctx.village_id, plot_nr) then
			return "Your room's paid for. Top of the stairs whenever you want it."
		end
		local price = village_life.lodging.price(ctx.village_id, ctx.pname)
		return persona.hedge(ctx.self) ..
				("A room's %d for the night. Clean bed, and the door bolts from the inside."):format(price)
	end,
	options = function(ctx)
		local lodging = village_life.lodging
		local plot_nr = ctx.self.vl and ctx.self.vl.p
		local out = {}
		if not plot_nr or lodging.has_room(ctx.pname, ctx.village_id, plot_nr) then
			return out
		end

		local price = lodging.price(ctx.village_id, ctx.pname)
		out[#out + 1] = {
			label = ("Take a room for the night. (%d coins)"):format(price),
			answer = function(c)
				c.asked.room = true
				-- Priced now, from what they are holding now: a player who swapped
				-- their coin for a diamond between the two pays what they offer.
				local p = lodging.price(c.village_id, c.pname)
				local ok, why = lodging.take_payment(c.pname, p)
				if not ok then return lodging.cannot_pay_line(why) end

				lodging.grant(c.pname, c.village_id, c.self.vl.p)
				-- A paying guest is good custom, and the house remembers it.
				village_life.memory.remember(c.self, c.pname, "traded")
				return "Done. Top of the stairs, first on the left. Sleep as long as you like -- it's paid for."
			end,
		}
		out[#out + 1] = {
			label = "Another time.",
			answer = function() return "Suit yourself. The offer stands." end,
		}
		return out
	end,
})

--------------------------------------------------------------------------------
-- Other people
--------------------------------------------------------------------------------

-- The one question everybody wants to ask in a village and could not. The list
-- is real: kin.lua reads it off the bed rows, so these are the people this
-- villager genuinely lives with, works beside and lives near.
--
-- Asking about somebody is also how you learn who they are. A player who has
-- gossiped their way round a village knows more names than one who has
-- knocked on every door, which is the right way round.
add_menu("people", {
	label = "Let me ask you about someone.",
	weight = function(ctx)
		-- Below the civic questions, above small talk. It stays available for
		-- good -- unlike the one-shot facts, there is always another neighbour.
		return ctx.asked.people and W.stale or W.people
	end,
	gate = function(ctx)
		if not ctx.knows_name or not cordial(ctx) then return false end
		return #village_life.regard.people(ctx.self) > 0
	end,
	intro = function(ctx)
		local n = #village_life.regard.people(ctx.self)
		if n == 0 then return "I keep to myself." end
		local p = persona.of(ctx.self)
		if p.temperament == "sly" then
			return "Now that's a question I like. Who?"
		elseif p.temperament == "shy" then
			return "Oh -- I don't like to talk about people. ...Who?"
		elseif p.temperament == "gruff" then
			return "If you must. Who."
		end
		return "Ask away. It's a small place."
	end,
	options = function(ctx)
		local out = {}
		for _, row in ipairs(village_life.regard.people(ctx.self)) do
			out[#out + 1] = {
				label = village_life.regard.label(row),
				answer = function(c)
					-- Being told about somebody is being introduced to them.
					-- The knowledge is filed against *their* key, so the next
					-- person you meet is not a stranger.
					dialogue.learn_key(c.pname, row.key, "name")
					if row.title and row.title ~= "" then
						dialogue.learn_key(c.pname, row.key, "job")
					end
					return village_life.regard.line(c.self, row, c)
				end,
			}
		end
		return out
	end,
})

--------------------------------------------------------------------------------
-- The country
--------------------------------------------------------------------------------

-- Every entry here is gated on the thing existing. No volcano, no volcano
-- question; no water within sight of the village, nothing to ask about the
-- river. That is the same rule traits.lua enforces about a villager's own
-- life, applied to the ground they are standing on -- and it is why the list
-- is a different length in a different valley.
--
-- Who knows what is gated too. A hunter or a lumberjack has walked the country
-- and will give you a bearing to the next settlement; a baker knows the
-- weather and what everyone knows.
-- Trades whose hands are on one material all day, so they have something the
-- next person does not when asked about it. Keyed on the bed row's title, the
-- same source the job topic reads.
local TIMBER_TRADES = {
	lumberjack = true, forester = true, woodcutter = true, carpenter = true,
	wheelwright = true, ["sawmill owner"] = true, sawyer = true,
}
local STONE_TRADES = {
	miner = true, stonemason = true, stoneminer = true, mason = true,
	quarryman = true, smith = true, blacksmith = true,
}
-- Only trades that actually work the ground. A miller grinds what others grow
-- and a shepherd keeps animals, not fields -- both used to be asked "what do
-- you grow?" and answer with a field they do not have. The miller keeps a
-- question of their own below.
local CROP_TRADES = {
	farmer = true, ["seed seller"] = true, ["flower seller"] = true,
	gardener = true,
}
local MILL_TRADES = {
	miller = true, ["flour merchant"] = true,
}

local function trade_is(ctx, set)
	local title = ctx.r and ctx.r.title
	return title ~= nil and set[title] == true
end

add_menu("land", {
	label = "Tell me about this country.",
	weight = function(ctx) return ctx.asked.land and W.stale or W.land end,
	gate = function(ctx)
		if not ctx.knows_name or not cordial(ctx) then return false end
		return village_life.land.of(ctx.village_id) ~= nil
	end,
	intro = function(ctx)
		local s = village_life.land.of(ctx.village_id)
		if not s then return "Couldn't tell you. I don't go far." end
		if village_life.land.travelled(ctx.r) then
			return "Now that I can help you with. I'm out in it most days."
		end
		local p = persona.of(ctx.self)
		if p.temperament == "weary" then
			return "I've lived here all my life and looked at none of it. Go on, then."
		elseif p.temperament == "dreamy" then
			return "Oh, it's a strange country. What do you want to know?"
		end
		return "What about it?"
	end,
	options = function(ctx)
		local land = village_life.land
		local s = land.of(ctx.village_id)
		if not s then return {} end

		local out = {}
		local function entry(label, fn)
			out[#out + 1] = {label = label, answer = function(c)
				return fn(c, s) or "Couldn't say."
			end}
		end

		if s.biome or s.climate then
			entry("What sort of country is this?", land.line_climate)
		end
		if s.relief then
			entry("What's the lie of the land?", land.line_relief)
		end
		-- Asked either way round: whether there is water is worth knowing
		-- precisely when there is not.
		entry(s.water and "Is there water near?" or "Where do you get water?",
				land.line_water)
		if s.volcano then
			-- Named after the thing itself once they have told you what it is,
			-- because by then you can see it too.
			local v = s.volcano
			entry(v.name and ("What is %s?"):format(v.name)
					or "What's that mountain?", land.line_volcano)
		end

		-- The working trades, each with the one question their day answers. Only
		-- the tradesman is asked, and only about their own material -- a farmer is
		-- not asked what timber grows, a lumberjack is not asked about the rock.
		if trade_is(ctx, TIMBER_TRADES) then
			entry("What timber grows round here?", land.line_trees)
		end
		if trade_is(ctx, STONE_TRADES) then
			entry("What's the rock like under here?", land.line_stone)
		end
		if trade_is(ctx, CROP_TRADES) then
			entry("What do you grow?", land.line_crops)
		end
		if trade_is(ctx, MILL_TRADES) then
			entry("What comes to your mill?", land.line_mill)
		end
		-- A villager who does not travel will not send you over the hill. They
		-- know the place exists; the bearing is a thing you learn by walking it.
		if land.travelled(ctx.r) and forthcoming(ctx) then
			entry("What else is out there? Other settlements?",
					land.line_villages)
		end
		entry("Is it dangerous, out past the fields?", land.line_dangers)

		return out
	end,
})

--------------------------------------------------------------------------------
-- Talking for the sake of it
--------------------------------------------------------------------------------

-- The half of the conversation with nothing to extract, and so the half that
-- never runs out. It is also the only place the player says something instead
-- of asking something, which is what makes it possible to be good company or
-- to put your foot in it -- both of which land in the same book as every other
-- kindness and injury in this mod.
add_menu("talk", {
	label = "Never mind that. Let's just talk.",
	weight = function(ctx) return W.talk end,
	gate = function(ctx) return cordial(ctx) end,
	intro = function(ctx)
		local p = persona.of(ctx.self)
		if p.temperament == "gruff" then return "About what." end
		if p.temperament == "weary" then return "If you like. I'm not going anywhere." end
		if p.temperament == "warm" then return "Now you're talking. Go on." end
		return "All right, then."
	end,
	options = function(ctx)
		local banter = village_life.banter
		local out = {}

		out[#out + 1] = {
			label = "How's the world treating you?",
			answer = function(c)
				c.asked.banter_count = (c.asked.banter_count or 0) + 1
				return banter.remark(c)
			end,
		}

		out[#out + 1] = {
			label = "Tell me something funny.",
			answer = function(c)
				c.asked.joke_count = (c.asked.joke_count or 0) + 1
				return banter.joke(c)
			end,
		}

		-- The player's own lines. Offered only where they make sense: there is
		-- no point boasting to somebody who has never seen you do anything,
		-- and a tone with no gate is not a choice.
		for _, def in ipairs(banter.tones) do
			if not def.gate or def.gate(ctx) then
				out[#out + 1] = {
					label = def.label,
					answer = function(c)
						local line = banter.say(c, def)
						return line
					end,
				}
			end
		end

		return out
	end,
})

--------------------------------------------------------------------------------
-- Asking somebody to come with you
--------------------------------------------------------------------------------

-- Persuasion is a conversation, not a dice roll. Every argument is offered only
-- when it is *true of this person* -- there is no "appeal to their trade"
-- button for somebody with no trade -- and the window shows the sum, and what
-- the sum is made of, because the point is that this is a person being talked
-- round rather than a lock being picked.
--
-- The persuasion state lives in the session's `asked` table, which is the
-- conversation's own scratch memory: walk away and it is gone, which is right.
-- Nobody should be able to grind somebody down over a week of two-line visits.
local function hire_state(ctx)
	local h = ctx.asked.hire
	if not h then
		h = {tried = {}, bonus = 0, spent = 0, pledge = 0}
		ctx.asked.hire = h
	end
	return h
end

local function hire_score(ctx)
	local hire = village_life.hire
	local h = hire_state(ctx)
	local total = hire.inclination(ctx.self, ctx.pname)
	return total + h.bonus + hire.money_pull(ctx.self, h.pledge)
end

add_menu("hire", {
	label = "I've a proposition for you.",
	weight = function(ctx) return W.hire end,
	gate = function(ctx)
		if not village_life.settings.hiring then return false end
		if not ctx.knows_name then return false end
		-- A hard refusal is still worth being able to hear once -- it says
		-- something about them -- but not worth a permanent button.
		local refusal = village_life.hire.refusal(ctx.self, ctx.pname)
		if refusal and refusal.hard and ctx.asked.hire_refused then return false end
		return true
	end,
	intro = function(ctx)
		local hire = village_life.hire
		local refusal = hire.refusal(ctx.self, ctx.pname)
		if refusal then
			ctx.asked.hire_refused = true
			return refusal.line
		end

		local h = hire_state(ctx)
		if h.done == "accepted" then return hire.accept(ctx) end
		if h.done == "declined" then
			return "I've given you my answer."
		end

		local score = hire_score(ctx)
		local p = persona.of(ctx.self)
		if h.spent == 0 and h.pledge == 0 then
			if p.temperament == "sly" then
				return "A proposition. Go on, then -- I'm always interested in a proposition."
			elseif p.temperament == "gruff" then
				return "Out with it."
			end
			return "A proposition. All right. I'm listening."
		end
		-- Mid-negotiation: tell them where they stand, in words.
		if score >= village_life.hire.THRESHOLD then
			return "...You know, I think you might have talked me into this."
		elseif score >= village_life.hire.THRESHOLD * 0.6 then
			return "I'm listening. I'm not convinced, but I'm listening."
		end
		return "You'll have to do better than that."
	end,
	options = function(ctx)
		local hire = village_life.hire
		local out = {}

		if hire.refusal(ctx.self, ctx.pname) then return out end

		local h = hire_state(ctx)
		if h.done then return out end

		local r = ctx.r
		local score = hire_score(ctx)

		-- The arguments still left. Once made, an argument is made: saying the
		-- same thing twice is not more persuasive and should not be treated as
		-- though it were.
		if h.spent < hire.ATTEMPTS then
			for _, def in ipairs(hire.arguments) do
				if not h.tried[def.id] and (not def.gate or def.gate(ctx, r)) then
					out[#out + 1] = {
						label = def.label,
						answer = function(c)
							local hs = hire_state(c)
							hs.tried[def.id] = true
							hs.spent = hs.spent + 1
							local line, ok, delta = hire.argue(c, def)
							hs.bonus = hs.bonus + delta
							return line
						end,
					}
				end
			end
		end

		-- Coin on the table. Drawn from the purse (loose and in bags) as a short
		-- ladder of figures rather than a text box -- you name a price, you do
		-- not type one. Offering does not spend an argument: haggle the number as
		-- often as you like. The proud refuse any figure and it stings a little;
		-- money_react handles that and tells us not to bank the pledge.
		local rungs, have = hire.offer_rungs(ctx.pname)
		for _, amount in ipairs(rungs) do
			if amount ~= h.pledge then
				local label = (amount == have)
						and ("Offer everything you have (%d coins)."):format(amount)
						or ("Offer them %d coins."):format(amount)
				out[#out + 1] = {
					label = label,
					answer = function(c)
						local hs = hire_state(c)
						local prev = hs.pledge
						hs.pledge = amount
						local s = hire_score(c)
						local line, took = hire.money_react(c.self, amount, s)
						if not took then hs.pledge = prev end
						return line
					end,
				}
			end
		end
		if h.pledge > 0 then
			out[#out + 1] = {
				label = ("Take the coin back off the table. (%d offered)"):format(
						h.pledge),
				answer = function(c)
					hire_state(c).pledge = 0
					return "Suit yourself."
				end,
			}
		end

		-- Asking outright. Always available: a player who has said enough
		-- should not have to keep talking, and a player who has said nothing
		-- is entitled to find out how badly it is going.
		local lean = score >= hire.THRESHOLD and "willing"
				or score >= hire.THRESHOLD * 0.6 and "half-minded to"
				or score >= hire.THRESHOLD * 0.25 and "unconvinced"
				or "wholly unmoved"
		out[#out + 1] = {
			label = ("So: will you come with me? (they seem %s)%s"):format(lean,
					h.pledge > 0 and (" [%d coins offered]"):format(h.pledge) or ""),
			answer = function(c)
				local hs = hire_state(c)
				local s = hire_score(c)
				if s < hire.THRESHOLD then
					hs.done = "declined"
					return hire.decline(c, s)
				end

				-- The signing coin, taken now and only now, and only what was
				-- pledged. Priced from the purse at the handshake: somebody who
				-- spent it between the offer and the shake has nothing to hand
				-- over, and the deal falls through honestly rather than hiring
				-- for free.
				if hs.pledge and hs.pledge > 0 then
					if not hire.take_coins(c.pname, hs.pledge) then
						hs.done = "declined"
						return "You haven't the coin you offered. Come back when you have it."
					end
				end
				if not village_life.companion.engage(c.self, c.pname) then
					hs.done = "declined"
					return "I would. I can't. I don't rightly know where I'd be leaving from."
				end
				hs.done = "accepted"
				return hire.accept(c)
			end,
		}

		return out
	end,
})

-- Once they are with you, the proposition menu becomes the orders menu. Same
-- slot, because it is the same relationship at a later stage.
add_menu("orders", {
	label = "A word about our arrangement.",
	weight = function() return W.orders end,
	gate = function(ctx)
		return village_life.settings.hiring
				and village_life.companion.hired_by(ctx.self)
				and village_life.companion.employer(ctx.self) == ctx.pname
	end,
	intro = function(ctx)
		local owed, days = village_life.companion.owed(ctx.self)
		if owed > 0 then
			return ("You're %d behind. %s. What do you want?"):format(owed,
					(days or 1) > 1 and "Two days now" or "Since yesterday")
		end
		local spirits = village_life.memory.spirits(ctx.self)
		if spirits == "wretched" then
			return "I'm about done in, if I'm honest with you."
		elseif spirits == "low" then
			return "I'm tired. What is it?"
		end
		return "Aye? What's the plan?"
	end,
	options = function(ctx)
		local companion = village_life.companion
		local out = {}
		local order = companion.order(ctx.self)

		if order ~= "follow" then
			out[#out + 1] = {label = "Come with me.", answer = function(c)
				c.self.vl.h.order = "follow"
				c.self.vl.h.at = nil
				return "Right behind you."
			end}
		end
		if order ~= "wait" then
			out[#out + 1] = {label = "Wait here.", answer = function(c)
				c.self.vl.h.order = "wait"
				c.self.vl.h.at = c.self.object and c.self.object:get_pos()
				return "Here. Right. Don't be long."
			end}
		end

		local owed = companion.owed(ctx.self)
		out[#out + 1] = {
			label = owed > 0 and ("Here's your pay. (%d owed)"):format(owed)
					or "What am I paying you?",
			answer = function(c)
				local ok, line = companion.pay(c.self, c.pname)
				return line
			end,
		}

		-- Arm them with whatever you are holding: a weapon or a piece of armour.
		-- Bedless adventurers only -- they fight at your side through follow_step,
		-- where the loadout is kept applied; a hired villager keeps their village
		-- role instead.
		if ctx.self._adventurer then
			out[#out + 1] = {label = "Let me sort your gear. (open the kit window)",
					opens_kit = true}

			-- Only offer to hand it back once they are carrying something.
			local weapon, armor = companion.gear(ctx.self)
			if weapon or armor then
				out[#out + 1] = {label = "Give me back my gear.", answer = function(c)
					companion.return_gear(c.self, c.pname)
					return "Here. All of it. Your steel, your leather."
				end}
			end
		end

		out[#out + 1] = {label = "Go home. With my thanks.", answer = function(c)
			-- Sent off well: hand back anything you lent them, then set them on
			-- the road home.
			companion.return_gear(c.self, c.pname)
			c.self.vl.h.order = "home"
			-- Their last wages are forgiven on a clean dismissal. Being sent
			-- home well is worth something, and the alternative is a villager
			-- who walks off carrying a grudge for a debt the player has no way
			-- left to settle.
			village_life.memory.nudge_mood(c.self, 6, "sent home well")
			return "Then I'll see the village again. It's been... something. Good luck to you."
		end}

		return out
	end,
})

-- Arm one of your own townsfolk. The equip machinery is the same one hired
-- companions use, but for a settled resident the kit lives on their bed row
-- (persistent) and is folded into their defence role -- it lifts what they can do
-- when they rouse to defend the town, or add to a guard, rather than turning a
-- baker into a follower. Only a town's founder may kit out that town's residents,
-- and a hired companion uses the orders menu above instead.
add_menu("kit", {
	label = "Let me see to your kit.",
	weight = function() return W.orders end,
	gate = function(ctx)
		if not village_life.settings.settlement then return false end
		if not village_life.settlement.founder_of then return false end
		local self = ctx.self
		if not home.is_villager(self) then return false end
		if village_life.companion.hired_by(self) then return false end
		return village_life.settlement.founder_of(self) == ctx.pname
	end,
	intro = function(ctx)
		local weapon, armor = village_life.companion.gear(ctx.self)
		if weapon or armor then
			return "Aye, I've what you gave me. Something else for me?"
		end
		return "My kit? Only what I stand up in. Did you bring me something?"
	end,
	options = function(ctx)
		local companion = village_life.companion
		local out = {}
		out[#out + 1] = {
			label = "Let me sort your gear. (open the kit window)",
			opens_kit = true,
		}
		local weapon, armor = companion.gear(ctx.self)
		if weapon or armor then
			out[#out + 1] = {
				label = "Take everything off -- give it all back to me.",
				answer = function(c)
					companion.return_gear(c.self, c.pname)
					return "Here -- your steel, your leather. Back to you, and my thanks."
				end,
			}
		end
		return out
	end,
})

-- "Come and live in my town." The same persuasion as hiring -- the arguments,
-- the coin, the running total -- but the offer is a home rather than a wage, so
-- it opens with a bonus a mercenary contract does not have, and it ends not in
-- service but in a choice of how they travel: at your side, or on their own.
--
-- The state is the conversation's own scratch (ctx.asked.settle), separate from
-- a hire negotiation with the same person, so the two do not bleed into each
-- other.
local function settle_state(ctx)
	local h = ctx.asked.settle
	if not h then
		h = {tried = {}, bonus = 0, spent = 0, pledge = 0}
		ctx.asked.settle = h
	end
	return h
end

-- A home of one's own pulls harder than a day's wage. This is added to the same
-- inclination hiring uses, so someone who would just about hire on will settle
-- readily, and someone dead set against leaving still says no.
local SETTLE_BONUS = 30

local function settle_score(ctx)
	local hire = village_life.hire
	local h = settle_state(ctx)
	return hire.inclination(ctx.self, ctx.pname) + h.bonus
			+ hire.money_pull(ctx.self, h.pledge) + SETTLE_BONUS
end

-- Where the newcomer would be going, if anywhere: the founder's nearest town
-- with a bed kept vacant.
local function settle_target(ctx)
	local near = ctx.self.object and ctx.self.object:get_pos()
	return (village_life.settlement.recruit_town(ctx.pname, near))
end

-- The name of where the newcomer would be going -- a founded town, or the shop
-- you bought and set a bed aside in -- so the offer can name the place rather
-- than say "a town of your making".
local function settle_dest_name(ctx)
	local town_id = settle_target(ctx)
	local v = town_id and home.village(town_id)
	return v and v.name
end

add_menu("settle", {
	label = "How would you like to live somewhere new?",
	weight = function() return W.settle end,
	gate = function(ctx)
		if not village_life.settings.settlement then return false end
		if not ctx.knows_name then return false end
		-- Only if the player actually has a town with a bed set aside.
		local town_id = settle_target(ctx)
		if not town_id then return false end
		-- Not somebody who already lives there, and not somebody already in your
		-- service (that is what the orders menu and the bed's "settle" button are
		-- for).
		if ctx.self.vl and ctx.self.vl.v == town_id then return false end
		if village_life.companion.hired_by(ctx.self) then return false end
		local refusal = village_life.hire.refusal(ctx.self, ctx.pname)
		if refusal and refusal.hard and ctx.asked.settle_refused then return false end
		return true
	end,
	intro = function(ctx)
		local hire = village_life.hire
		local refusal = hire.refusal(ctx.self, ctx.pname)
		if refusal then
			ctx.asked.settle_refused = true
			return refusal.line
		end
		local h = settle_state(ctx)
		if h.done == "accepted" then
			return "I said I'd come. How am I to make the journey?"
		elseif h.done == "gone" then
			return "It's settled, then. I'll see you there."
		elseif h.done == "declined" then
			return "I've given you my answer."
		end
		local score = settle_score(ctx)
		if h.spent == 0 and h.pledge == 0 then
			-- A wandering trader opens with its own race-coloured reason a fixed
			-- roof might tempt it; a villager gives the generic line.
			if ctx.wanderer and village_life.wanderer then
				return village_life.wanderer.why_settle(ctx.self)
			end
			local dest = settle_dest_name(ctx)
			if dest then
				return ("My own place, at %s? Go on, then. Say your piece."):format(dest)
			end
			return "My own place, in a town of your making? Go on, then. Say your piece."
		end
		if score >= hire.THRESHOLD then
			return "...You know, the more you say it, the more I can picture it."
		elseif score >= hire.THRESHOLD * 0.6 then
			return "It's a fine thought. I'm not packed yet, mind."
		end
		return "It's a long way from here to yes."
	end,
	options = function(ctx)
		local hire = village_life.hire
		local out = {}
		if hire.refusal(ctx.self, ctx.pname) then return out end

		local h = settle_state(ctx)

		-- Once they have agreed, the only choices are how they travel.
		if h.done == "accepted" then
			out[#out + 1] = {
				label = "Walk there with me -- follow me on foot.",
				answer = function(c)
					local ok, why = village_life.settlement.take_resident(
							c.self, c.pname, "follow")
					if not ok then return why end
					settle_state(c).done = "gone"
					return "Right behind you, then. Lead the way."
				end,
			}
			out[#out + 1] = {
				label = "Make your own way; I'll meet you there.",
				answer = function(c)
					local ok, why = village_life.settlement.take_resident(
							c.self, c.pname, "travel")
					if not ok then return why end
					settle_state(c).done = "gone"
					local dest = settle_dest_name(c)
					return "Then I'll gather my things and set out. "
							.. (dest and ("Look for me by the bed at %s in a day or three."):format(dest)
								or "Look for me by the bed in a day or three.")
				end,
			}
			return out
		end
		if h.done then return out end

		-- The arguments still left, exactly as hiring offers them.
		if h.spent < hire.ATTEMPTS then
			for _, def in ipairs(hire.arguments) do
				if not h.tried[def.id] and (not def.gate or def.gate(ctx, ctx.r)) then
					out[#out + 1] = {
						label = def.label,
						answer = function(c)
							local hs = settle_state(c)
							hs.tried[def.id] = true
							hs.spent = hs.spent + 1
							local line, _, delta = hire.argue(c, def)
							hs.bonus = hs.bonus + delta
							return line
						end,
					}
				end
			end
		end

		-- Coin on the table, drawn from the purse as a ladder of figures.
		local rungs, have = hire.offer_rungs(ctx.pname)
		for _, amount in ipairs(rungs) do
			if amount ~= h.pledge then
				local label = (amount == have)
						and ("Offer everything you have (%d coins)."):format(amount)
						or ("Offer them %d coins."):format(amount)
				out[#out + 1] = {
					label = label,
					answer = function(c)
						local hs = settle_state(c)
						local prev = hs.pledge
						hs.pledge = amount
						local line, took = hire.money_react(c.self, amount, settle_score(c))
						if not took then hs.pledge = prev end
						return line
					end,
				}
			end
		end
		if h.pledge > 0 then
			out[#out + 1] = {
				label = ("Take the coin back off the table. (%d offered)"):format(h.pledge),
				answer = function(c)
					settle_state(c).pledge = 0
					return "Suit yourself."
				end,
			}
		end

		-- Asking outright, always available. On yes, the coin is taken and the
		-- menu turns into the travel choice; the deed's vacant bed is filled only
		-- when they pick how to come (settlement.take_resident).
		local score = settle_score(ctx)
		local lean = score >= hire.THRESHOLD and "won over"
				or score >= hire.THRESHOLD * 0.6 and "half-minded to"
				or score >= hire.THRESHOLD * 0.25 and "unconvinced"
				or "wholly unmoved"
		out[#out + 1] = {
			label = ("So: will you come and make a home in my town? (they seem %s)%s")
					:format(lean, h.pledge > 0
							and (" [%d coins offered]"):format(h.pledge) or ""),
			answer = function(c)
				local hs = settle_state(c)
				local s = settle_score(c)
				if s < hire.THRESHOLD then
					hs.done = "declined"
					return hire.decline(c, s)
				end
				if hs.pledge and hs.pledge > 0 then
					if not hire.take_coins(c.pname, hs.pledge) then
						hs.done = "declined"
						return "You haven't the coin you offered. "
								.. "Come back when you have it."
					end
				end
				hs.done = "accepted"
				return "Aye. I'll come. Now -- how am I to travel?"
			end,
		}

		return out
	end,
})

-- Talking a beast out of being a monster (redeem.lua). Structurally the settle
-- menu's twin -- a running persuasion with arguments and a bribe against a bar --
-- but it opens from far below zero (fear and bloodlust) scaled by how fierce the
-- creature is, so it is genuinely HARD. A loud yell gives a small head start, and
-- coin (meat, gold) helps. Win it and the beast loses monster status for good.
local CALM_BASE = -70      -- how deep in the red a monster starts
local CALM_THRESHOLD = 100 -- the bar; the base is what makes reaching it hard

local function calm_state(ctx)
	local h = ctx.asked.calm
	if not h then
		h = {spent = 0, bonus = 0, pledge = 0, tried = {}, done = nil}
		ctx.asked.calm = h
	end
	return h
end

-- The appeals a cornered beast can understand. Kept few and strong -- you have
-- only its ATTEMPTS' worth of patience before it decides.
local CALM_ARGS = {
	{id = "spared", delta = 24,
		label = "\"I calmed you. I could have killed you where you stood. I didn't.\"",
		line = "It goes still. The claws lower, a fraction. This it understands."},
	{id = "peace", delta = 18,
		label = "\"Your fighting days can end. No more running. No more dying.\"",
		line = "Something behind its eyes quiets. It is listening now."},
	{id = "warmth", delta = 16,
		label = "\"There's food where I come from. Warmth. A place by a fire.\"",
		line = "Its ears turn towards you. Hunger is a tongue it knows well."},
	{id = "seen", delta = 20,
		label = "\"I don't see a monster. I see something the world made cruel.\"",
		line = "It stares a long moment. No one has ever said such a thing to it."},
}
local CALM_ATTEMPTS = 3

local function calm_score(ctx)
	local hire = village_life.hire
	local h = calm_state(ctx)
	local diff = village_life.redeem.difficulty(ctx.self)
	local loud = ctx.self._calm_loud or 1          -- the louder you called it down
	local opinion = village_life.memory.opinion(ctx.self, ctx.pname) or 0
	return CALM_BASE * diff + h.bonus
			+ hire.money_pull(ctx.self, h.pledge)
			+ (loud - 1) * 12 + opinion
end

add_menu("calm", {
	label = "Speak to it, softly. (try to calm it)",
	weight = function() return W.settle + 10 end,   -- the only thing worth doing now
	gate = function(ctx)
		if village_life.settings.redeem == false then return false end
		-- Only a beast that has stood down and not yet been calmed.
		return ctx.calmable and not ctx.calmed
	end,
	intro = function(ctx)
		local h = calm_state(ctx)
		if h.done == "calmed" then
			return "The wildness has gone out of it. It looks at you now as a person might."
		elseif h.done == "declined" then
			return "It will not be reached. Not today, not by you."
		end
		local score = calm_score(ctx)
		if h.spent == 0 and h.pledge == 0 then
			return "It has not attacked. Its breath is ragged. Choose your words with care -- "
					.. "you will not get many."
		end
		if score >= CALM_THRESHOLD then
			return "The tension is bleeding out of it. It is nearly yours."
		elseif score >= CALM_THRESHOLD * 0.5 then
			return "It has not fled, and it has not struck. That is something."
		end
		return "Its lips draw back from its teeth. You are a long way from trust."
	end,
	options = function(ctx)
		local hire = village_life.hire
		local out = {}
		local h = calm_state(ctx)
		if h.done then return out end

		-- The appeals still left.
		if h.spent < CALM_ATTEMPTS then
			for _, def in ipairs(CALM_ARGS) do
				if not h.tried[def.id] then
					out[#out + 1] = {
						label = def.label,
						answer = function(c)
							local hs = calm_state(c)
							hs.tried[def.id] = true
							hs.spent = hs.spent + 1
							hs.bonus = hs.bonus + def.delta
							return def.line
						end,
					}
				end
			end
		end

		-- A bribe: coin, or whatever the purse values, offered as a ladder.
		local rungs = hire.offer_rungs(ctx.pname)
		for _, amount in ipairs(rungs) do
			if amount ~= h.pledge then
				out[#out + 1] = {
					label = ("Push some food and coin towards it. (%d)"):format(amount),
					answer = function(c)
						local hs = calm_state(c)
						hs.pledge = amount
						return "It sniffs at the offering, and does not back away."
					end,
				}
			end
		end
		if h.pledge > 0 then
			out[#out + 1] = {
				label = ("Take the offering back. (%d)"):format(h.pledge),
				answer = function(c) calm_state(c).pledge = 0
					return "It watches the food go. Something like regret." end,
			}
		end

		-- The moment of truth, always available.
		local score = calm_score(ctx)
		local lean = score >= CALM_THRESHOLD and "almost calm"
				or score >= CALM_THRESHOLD * 0.5 and "wavering"
				or "still wild"
		out[#out + 1] = {
			label = ("Hold out your open hand. (it seems %s)"):format(lean),
			answer = function(c)
				local hs = calm_state(c)
				local s = calm_score(c)
				if s < CALM_THRESHOLD then
					-- Not enough. It does not necessarily bolt -- the window may yet
					-- hold -- but this push failed.
					if s < CALM_THRESHOLD * 0.3 then
						hs.done = "declined"
						return "It recoils, snarling. The moment is gone."
					end
					return "It flinches from your hand. Not yet. Say more, and quickly."
				end
				if hs.pledge > 0 then hire.take_coins(c.pname, hs.pledge) end
				hs.done = "calmed"
				village_life.redeem.calm(c.self, c.pname)
				return "It lowers its head to your open hand. The wildness goes out of it. "
						.. "It is yours now -- not owned, but no longer lost."
			end,
		}

		return out
	end,
})

add("bye", {
	label = "Goodbye.",
	gate = function() return true end,
	closes = true,
})

-- Not registered as a topic: it is pinned onto every menu by options_for and
-- never appears at the top level, where there is nothing to go back to.
local BACK = {id = "back", label = "(Back)", back = true}

--------------------------------------------------------------------------------
-- Building the conversation
--------------------------------------------------------------------------------

local function context(self, pname)
	local r = home.resolve(self)
	local village_id = (self.vl and self.vl.v)
			or (r and r.village_id)
	local band, score, village_score = standing(village_id, pname, self)
	-- Only this villager's conversation counts. Turning from the baker to the
	-- smith starts a new one, and must not inherit what the baker was asked --
	-- nor which menu of the baker's you happened to have open.
	local session = dialogue.talking[pname]
	if session and session.ent ~= self then session = nil end

	local f = frame(session)

	-- Where they came from, if anywhere (backstory.lua), and -- only if they
	-- moved -- whether this player has named a town after the place they left.
	-- Resolved once here so the topic gates and their answers read the same fact.
	local moved = village_life.backstory and village_life.backstory.of(self) or nil
	local town_after = moved and town_named_after(pname, moved.from_place) or nil

	return {
		self = self,
		r = r,
		pname = pname,
		-- Which list is open, and what it is about. `arg` is how a menu is
		-- about a particular person without needing a topic per villager.
		menu = f and f.menu,
		arg = f and f.arg,
		depth = (session and session.stack and #session.stack) or 0,
		village_id = village_id,
		village = village_id and home.village(village_id),
		-- What role the village put them in, and whether they are one of the
		-- people passing through -- an inn guest or a bedless traveller. The road
		-- questions hang off this rather than off the title.
		role = r and r.role,
		adventurer = (village_life.adventurer
				and village_life.adventurer.is(self)) or false,
		-- An un-settled wandering trader (dwarf/mung/human/elf): bedless like a
		-- traveller, so the road-less merchant topics and the settle pitch hang
		-- off this rather than off a title.
		wanderer = (village_life.wanderer
				and village_life.wanderer.is(self)) or false,
		-- A sentient beastman (redeem.lua) and, if it has stood down after a yell,
		-- whether it can be talked out of being a monster right now. `race` colours
		-- both the calm menu and a calmed one's lines.
		sentient = (village_life.redeem
				and village_life.redeem.is_sentient(self)) or false,
		calmable = (village_life.redeem
				and village_life.redeem.is_idling(self)) or false,
		calmed = (village_life.redeem
				and village_life.redeem.is_calmed(self)) or false,
		race = (village_life.wanderer
				and village_life.wanderer.species(self)
				and village_life.wanderer.species(self).race) or nil,
		-- Which kind of adventurer, so the barbarian gets the champion question
		-- and the pirate the one about their crew. Nil for everyone else.
		adv_subtype = village_life.adventurer
				and village_life.adventurer.subtype(self) or nil,
		band = band,
		-- What this villager is going on: the village's verdict, coloured by
		-- their own dealings with the player.
		score = score,
		-- The village's verdict alone, for anything speaking for the village
		-- rather than for itself.
		village_score = village_score,
		mood = village_life.memory.mood(self),
		-- What has already been asked in *this* conversation, as opposed to
		-- what the player has learned for good. Repeatable topics use it to
		-- step aside once they have been used, without pretending the answer
		-- can never be worth hearing again.
		asked = (session and session.asked) or {},
		knows_name = dialogue.knows(pname, self, "name"),
		knows_job = dialogue.knows(pname, self, "job"),
		knows_pastime = dialogue.knows(pname, self, "pastime"),
		knows_opinion = dialogue.knows(pname, self, "opinion"),
		knows_worry = dialogue.knows(pname, self, "worry"),
		knows_village_name = village_id
				and dialogue.knows_village(pname, village_id, "name"),
		-- These two were written by their topics and never read back, so the
		-- topics stayed at full weight forever and squatted the option list.
		knows_needs = village_id
				and dialogue.knows_village(pname, village_id, "needs"),
		knows_sells = village_id
				and dialogue.knows_village(pname, village_id, "sells"),
		knows_god = village_id
				and dialogue.knows_village(pname, village_id, "god"),
		knows_family = dialogue.knows(pname, self, "family"),
		-- A villager who came here from somewhere else, and the story around it.
		moved = moved,
		knows_moved = dialogue.knows(pname, self, "moved"),
		-- The town this player named after that place, if they made one.
		town_after = town_after,
		knows_town_after = dialogue.knows(pname, self, "town_after"),
	}
end

--------------------------------------------------------------------------------
-- Blessing
--------------------------------------------------------------------------------

-- Both of these defer to lumberjackzombie so there is one definition of what
-- counts as a bottle of water and one of what blessing it does. The chat
-- formula still works exactly as it did; this is the same act performed by
-- somebody rather than typed.

function dialogue.holding_water(pname)
	if not village_life.faith.available() then return end
	if not lumberjackzombie.holding_water then return end
	local player = minetest.get_player_by_name(pname)
	if not player then return end
	return lumberjackzombie.holding_water(player) or nil
end

function dialogue.bless_water(pname, deity, village_id)
	if not village_life.faith.available() then return false end
	if not lumberjackzombie.bless_wielded then return false end
	local player = minetest.get_player_by_name(pname)
	if not player then return false end
	if not lumberjackzombie.bless_wielded(player, deity) then return false end

	-- A blessing given is a blessing worth having: it is the village's own
	-- god, said over you by their own priest, and that is worth more than
	-- saying the name yourself.
	village_life.faith.deed(pname, "offering", village_id)

	if village_life.settings.gossip and village_id then
		local player_pos = player:get_pos()
		village_life.events.raise({
			kind = "blessing",
			village_id = village_id,
			pos = player_pos,
			actor = pname,
			detail = {deity = village_life.faith.title(deity)},
		})
	end
	return true
end

-- How many topics fit on screen. Kept small on purpose: a wall of options is
-- a menu, not a conversation.
--
-- Two of these are always the pinned actions and up to four are menus, so this
-- is five questions and every way deeper. It was eight -- six questions --
-- which was right when questions were all there was; four menus thrown into
-- that pool would have taken the civic questions back off the end, and those
-- are how a player finds out what a village is for.
--
-- Past VISIBLE_ROWS the window scrolls rather than growing, so this is a
-- statement about how much conversation to offer at once, not about how much
-- will fit on the screen.
local MAX_TOPICS = 11

-- Ranking, so that what gets cut is what matters least rather than whatever
-- happens to be declared last. Before this, `needs`, `sells` and `standing`
-- never marked themselves answered and so permanently occupied three of the
-- five question slots -- `worry`, the one genuinely personal thing a villager
-- has to say, was pushed off the end until every other topic was exhausted.
local function weight_of(topic, ctx)
	if topic.weight then return topic.weight(ctx) end
	return 0
end

-- How many entries a menu shows before the window starts scrolling. Larger
-- than the top level on purpose: a menu is a list of one kind of thing -- the
-- people you know, the things about this country -- and there is no competition
-- for slots to arbitrate, so cutting it short only hides things.
local MAX_MENU = 14

local function ranked(list)
	table.sort(list, function(a, b)
		if a.weight ~= b.weight then return a.weight > b.weight end
		-- Declaration order breaks ties, so the list stays stable from one
		-- repaint to the next. A conversation whose buttons reshuffle under
		-- the cursor is unusable.
		return a.order < b.order
	end)
	return list
end

local function top_level_options(ctx)
	local questions, menu_list, pinned = {}, {}, {}

	for i, topic in ipairs(topics) do
		if not topic.gate or topic.gate(ctx) then
			local row = {topic = topic, order = i, weight = weight_of(topic, ctx)}
			if topic.pinned or topic.closes then
				pinned[#pinned + 1] = topic
			elseif topic.menu then
				menu_list[#menu_list + 1] = row
			else
				questions[#questions + 1] = row
			end
		end
	end

	ranked(questions)
	ranked(menu_list)

	-- Menus are never cut. They are the ways to keep talking -- they never go
	-- stale, and each one (hire, settle, the people, the country...) may be the
	-- single thing the player opened the conversation to do. The list is drawn
	-- inside a scroll_container, so there is no hard clip here: everything below
	-- the fold is reached by scrolling, not dropped. So every eligible menu goes
	-- in, and the questions fill whatever room is left inside MAX_TOPICS first --
	-- the lowest-ranked questions scroll below the fold rather than vanish.
	--
	-- Menus are still *drawn* below the questions: the thing the player may only
	-- get one chance to ask should be the first thing under their eye. Built as
	-- two lists and concatenated rather than sorted into place -- table.sort is
	-- not stable, and one pass of it here would scramble the ranking both lists
	-- were just given.
	local room = math.max(MAX_TOPICS - #pinned - #menu_list, 0)

	local out = {}
	for _, q in ipairs(questions) do
		if #out >= room then break end
		out[#out + 1] = q.topic
	end

	for _, m in ipairs(menu_list) do
		out[#out + 1] = m.topic
	end

	-- Trading and leaving have to survive whatever else is cut: pushing "Show
	-- me your wares" off the end of a full list makes a shopkeeper you are on
	-- good terms with unable to sell you anything, and dropping "Goodbye"
	-- leaves the player hitting Escape to end a conversation.
	for _, topic in ipairs(pinned) do
		out[#out + 1] = topic
	end

	return out
end

local function menu_options(ctx, def)
	local out = {}

	local ok, entries = pcall(def.options, ctx)
	if not ok then
		village_life.log("warning", ("menu %s failed: %s"):format(
				def.id, tostring(entries)))
		entries = nil
	end

	for _, entry in ipairs(entries or {}) do
		if #out >= (def.max or MAX_MENU) then break end
		out[#out + 1] = entry
	end

	-- Always a way back and always a way out. A menu whose list came out empty
	-- still has to be leavable, which is the whole "repaint or close" rule: a
	-- window with no buttons is the frozen conversation wearing a different
	-- hat.
	out[#out + 1] = BACK
	out[#out + 1] = find_topic("bye")
	return out
end

local function options_for(ctx, session)
	local f = frame(session)
	local def = f and menus[f.menu]
	if def and def.options then return menu_options(ctx, def) end
	return top_level_options(ctx)
end

--------------------------------------------------------------------------------
-- Formspec
--------------------------------------------------------------------------------

local esc = minetest.formspec_escape

-- Bands get a colour so standing is legible at a glance without a number.
-- Both come off rep.tiers, so the colour beside a villager's name and the
-- colour of the tier-change message are the same colour.
local BAND_COLOUR, BAND_LABEL = {}, {}
for _, t in ipairs(village_life.reputation.tiers) do
	BAND_COLOUR[t.band] = t.colour
	BAND_LABEL[t.band] = t.label
end

-- Layout of the topic list.
--
-- This used to be a fixed `size[11,8.6]` with buttons stepping 0.68 from
-- y=3.9. Eight topics reach y=9.26, which is past the bottom edge of the form:
-- the last buttons were drawn outside the window and could be neither read nor
-- clicked. Since `options_for` appends the pinned topics last, what fell off
-- was always "Show me your wares" and "Goodbye" -- the two the player most
-- needs. The window now grows to fit the list, and past `VISIBLE_ROWS` the
-- list scrolls inside it instead.
local FORM_W       = 11
local LIST_X       = 0.5
local LIST_W       = 10
local LIST_TOP     = 3.9
local ROW_H        = 0.6
local ROW_STEP     = 0.68
local FOOT_PAD     = 0.4
local VISIBLE_ROWS = 8
local BAR_W        = 0.3
local SCROLLBAR    = "topics"

-- Scrollbar positions are in tenths of a formspec unit: the scroll factor
-- below is 0.1, and the engine multiplies it by the size of one unit.
local SCROLL_FACTOR = 0.1

local function list_height(rows)
	if rows < 1 then return 0 end
	return (rows - 1) * ROW_STEP + ROW_H
end

-- The scrollbar value the engine will clamp to at the bottom of the list. Kept
-- here so a remembered position from a longer list cannot leave the buttons
-- scrolled off the top of a shorter one.
local function scroll_max(content_h, view_h)
	return math.max(0, math.ceil((content_h - view_h) / SCROLL_FACTOR))
end

local function build(ctx, line, options, scroll)
	local name = display_name(ctx.pname, ctx.self, ctx.r)
	-- Same reasoning as the `job` answer: the bed row's title, not the entity's
	-- profession, which is never empty. A homemaker gets no title after their
	-- name rather than the meaningless ", villager".
	local title = ctx.knows_job
			and (ctx.r and ctx.r.title or (not ctx.r and ctx.self.profession))

	local header = name
	if title and title ~= "" then header = header .. ", " .. title end

	-- formspec_escape wraps colorize, never the other way round: the escape has
	-- to be outermost or the colour code's own characters get mangled.
	local band = esc(minetest.colorize(BAND_COLOUR[ctx.band] or "#c8c8c8",
			BAND_LABEL[ctx.band] or ""))

	local content_h = list_height(#options)
	local view_h = math.min(content_h, list_height(VISIBLE_ROWS))
	local scrolls = content_h > view_h + 0.001

	local fs = {
		"formspec_version[4]",
		("size[%.2f,%.2f]"):format(FORM_W, LIST_TOP + view_h + FOOT_PAD),
		"label[0.5,0.6;", esc(header), "]",
		"label[0.5,1.05;", band, "]",
		"box[0.5,1.4;10,2.2;#00000040]",
		"textarea[0.6,1.5;9.8,2;;;", esc(line or ""), "]",
	}

	local x, y, w = LIST_X, LIST_TOP, LIST_W

	if scrolls then
		-- The scrollbar's range is set by the engine from the container's own
		-- contents, because the container declares a content padding (the
		-- sixth parameter). Nothing here has to be kept in step with the
		-- number of topics.
		w = LIST_W - BAR_W - 0.2
		fs[#fs + 1] = ("scrollbar[%.2f,%.2f;%.2f,%.2f;vertical;%s;%d]"):format(
				LIST_X + LIST_W - BAR_W, LIST_TOP, BAR_W, view_h, SCROLLBAR,
				math.min(scroll or 0, scroll_max(content_h, view_h)))
		fs[#fs + 1] = ("scroll_container[%.2f,%.2f;%.2f,%.2f;%s;vertical;%.2f;%.2f]")
				:format(LIST_X, LIST_TOP, w, view_h, SCROLLBAR, SCROLL_FACTOR,
						FOOT_PAD)
		-- Inside the container everything is placed relative to its corner.
		x, y = 0, 0
	end

	-- An entry with no registered id is one a menu built just now, and is named
	-- by its position in the list that is being drawn. The click is then
	-- resolved against exactly what the player was looking at, so a list that
	-- shifts between painting and clicking -- somebody died, somebody moved --
	-- cannot silently answer a different question than the one asked.
	--
	-- Still prefixed `topic_` so there is one button naming convention rather
	-- than two.
	for i, topic in ipairs(options) do
		fs[#fs + 1] = ("button[%.2f,%.2f;%.2f,%.2f;topic_%s;%s]")
				:format(x, y, w, ROW_H, topic.id or ("opt" .. i),
						esc(topic.label))
		y = y + ROW_STEP
	end

	if scrolls then fs[#fs + 1] = "scroll_container_end[]" end

	return table.concat(fs)
end

-- Exported for the test harness, which checks that every button this emits
-- lands inside the window it declares. Nothing else calls it.
dialogue.layout = build

--------------------------------------------------------------------------------
-- Opening and driving
--------------------------------------------------------------------------------

-- Why this villager will not hold a conversation right now, as the line they
-- would say, or nil if they will.
local function unwilling(self, ctx)
	if ctx.band == "enemy" then return persona.rebuff(self) end

	-- Asleep, or mid-flight from something.
	if village_life.settings.shop_hours then
		local goal = util.scratch(self).goal
		local kind = goal and goal.kind
		-- An innkeeper keeps an inn's hours and answers the door after dark: a
		-- bed for the night is the one thing you come to them for once everywhere
		-- else has shut. Everyone else is asleep until morning.
		local keeps_inn = village_life.lodging and village_life.lodging.is_keeper
				and village_life.lodging.is_keeper(self)
		if kind == "sleep" and not keeps_inn then
			return "Not now. Come back in the morning."
		end
		-- Naming what they are running from. "Get inside!" told the player
		-- nothing about a village they had just walked into and could not see
		-- the far side of; the thing itself is the useful half of the sentence.
		if kind == "flee" then
			return persona.panic(self, goal and goal.threat_label)
		end
	end
end

-- The session for this conversation, created if this is the start of one.
local function session_for(self, pname, ctx)
	local session = dialogue.talking[pname]
	if session and session.ent == self then return session end
	-- `asked` is the conversation's own scratch memory and has to be the same
	-- table across repaints, or every topic looks unasked again.
	session = {ent = self, asked = ctx.asked, stack = {}}
	dialogue.talking[pname] = session
	return session
end

-- Mung talk. The mung are cavemen, so their *own* spoken lines come out blunt and
-- ungrammatical -- "Me hunt bear. Throg break rock." -- while the menu of things
-- the player asks stays in plain English. Rather than write a caveman variant of
-- every topic, one transform is run over whatever the mung says as it is drawn.
--
-- It only ever rewrites small function words (pronouns, articles, auxiliaries,
-- the copula, negations); every content word and proper noun is left exactly as
-- it was, so "Throg", "Lyra", place names and item names survive untouched and the
-- line stays readable. Anything it cannot simplify it leaves alone.
local CAVE = {
	["i"] = "me", ["i'm"] = "me", ["im"] = "me", ["i've"] = "me", ["i'll"] = "me",
	-- ("mine" is left alone on purpose: in this game it is usually the hole in the
	-- ground, not the possessive.)
	["i'd"] = "me", ["my"] = "me", ["myself"] = "me",
	["your"] = "you", ["yours"] = "you",
	["am"] = "", ["are"] = "is", ["was"] = "is", ["were"] = "is", ["be"] = "is",
	["been"] = "is", ["being"] = "is",
	["the"] = "", ["a"] = "", ["an"] = "",
	["will"] = "", ["would"] = "", ["shall"] = "", ["should"] = "",
	["could"] = "", ["can"] = "", ["might"] = "", ["must"] = "", ["may"] = "",
	["do"] = "", ["does"] = "", ["did"] = "",
	["have"] = "", ["has"] = "", ["had"] = "", ["of"] = "",
	["very"] = "", ["really"] = "", ["quite"] = "", ["rather"] = "",
	["just"] = "", ["simply"] = "", ["perhaps"] = "maybe",
	["don't"] = "no", ["dont"] = "no", ["doesn't"] = "no", ["didn't"] = "no",
	["isn't"] = "no", ["aren't"] = "no", ["wasn't"] = "no", ["weren't"] = "no",
	["won't"] = "no", ["can't"] = "no", ["cannot"] = "no", ["couldn't"] = "no",
	["shouldn't"] = "no", ["wouldn't"] = "no", ["haven't"] = "no",
	["hasn't"] = "no", ["hadn't"] = "no",
	["it's"] = "it", ["that's"] = "that", ["there's"] = "there",
	["here's"] = "here", ["he's"] = "he", ["she's"] = "she", ["we're"] = "we",
	["they're"] = "they", ["you're"] = "you",
}

local function recap(s)
	s = s:gsub("^(%s*)(%l)", function(sp, c) return sp .. c:upper() end)
	return (s:gsub("([%.!%?]%s+)(%l)", function(p, c) return p .. c:upper() end))
end

local function cavemanize(text)
	if type(text) ~= "string" or text == "" then return text end
	local said = text:gsub("[A-Za-z']+", function(w)
		local m = CAVE[w:lower()]
		if m == nil then return w end   -- content word / proper noun: leave it
		return m                        -- "" drops the word
	end)
	said = said:gsub("%s+", " "):gsub("%s+([,%.!%?;:])", "%1")
	said = said:gsub("^%s+", ""):gsub("%s+$", "")
	if said == "" then return text end
	return recap(said)
end

-- A mung mob keeps its species name whether it settled or still wanders.
local function is_mung(self)
	local n = self and self.name
	return type(n) == "string" and n:find("mung", 1, true) ~= nil
end

local function render(self, player, ctx, line, options)
	if line and is_mung(self) then line = cavemanize(line) end
	local pname = player:get_player_name()
	local session = session_for(self, pname, ctx)
	session.line = line
	-- What was actually drawn, so a click on an unregistered entry resolves
	-- against the list the player was looking at rather than a rebuilt one.
	session.options = options
	-- Repainting resets the scrollbar unless the position is carried over, so
	-- answering a question a player had to scroll down to find would throw them
	-- back to the top of the list.
	minetest.show_formspec(pname, FORMNAME,
			build(ctx, line, options, session.scroll))
end

-- What they say as a list opens, or as the player steps back out of one.
--
-- Nil is a legitimate answer and means "say nothing new": dialogue.speak falls
-- back to their greeting, which is the right thing on returning to the top of a
-- conversation and reasonable everywhere else.
function dialogue.menu_line(self, ctx)
	local def = ctx.menu and menus[ctx.menu]
	if not def or not def.intro then return end
	local ok, line = pcall(def.intro, ctx)
	if not ok then
		village_life.log("warning", ("menu %s intro failed: %s"):format(
				ctx.menu, tostring(line)))
		return
	end
	return line
end

-- Their last word. The window stays up so the player can read it, but only
-- "Goodbye" is left.
--
-- This is the fix for the conversation that froze: the guards below are
-- re-checked after every answer, and a villager whose goal flipped to `sleep`
-- -- which brain.step rewrites every two seconds -- used to send a line to
-- chat and return without repainting or closing, leaving a live-looking form
-- whose every button silently did nothing.
function dialogue.interrupt(self, player, ctx, line)
	render(self, player, ctx, line, {find_topic("bye")})
end

-- The one thing this villager brings up unprompted the moment you speak to
-- them: the most notable thing you have done in their eyes, good or bad, read
-- from the same book every kindness and injury is written in. It is what makes
-- a village react to you rather than greet a stranger it has watched you save
-- somebody in.
local DEED_LINE = {
	rescued        = "You're the one who pulled me out of trouble. I'll not forget that.",
	gift           = "You've been good to me before. I remember it.",
	struck         = "You. You raised a hand to me once. Say your piece.",
	robbed         = "Keep your hands where I can see them this time.",
	trespassed     = "You're the one who beds down at the inn for free. Not tonight, you don't.",
	kin_killed     = "You spilled my own family's blood. We've nothing to say.",
	neighbour_died = "People have died since you started coming round. I've not forgotten.",
}

local function deed_opener(self, pname)
	if not village_life.settings.reputation then return end
	local note = village_life.memory.notable(self, pname)
	return note and DEED_LINE[note.kind]
end

-- An innkeeper greets by the hour. After dark the evening greeting is the cue
-- that the inn is open when everywhere else is shut, and that a bed can be had
-- for the asking. By day they fall through to their ordinary hello.
local function keeper_greeting(self)
	if not (village_life.lodging and village_life.lodging.is_keeper
			and village_life.lodging.is_keeper(self)) then
		return
	end
	local tod = minetest.get_timeofday and minetest.get_timeofday() or 0.5
	if tod >= 0.25 and tod <= 0.75 then return end   -- daytime: ordinary greeting

	local p = persona.of(self)
	if p.temperament == "gruff" then
		return "Good evening. Late to be about -- there's a bed if you want one."
	elseif p.temperament == "warm" then
		return "Good evening! In out of the dark with you -- there's a room if you need it."
	end
	return "Good evening. There's a room going, if you're after a bed."
end

-- Exported for the test harness.
dialogue._keeper_greeting = keeper_greeting

-- Starting a conversation. A refusal here has nothing to interrupt, so it is
-- said in chat and no window opens.
function dialogue.open(self, player, line)
	local pname = player:get_player_name()
	local ctx = context(self, pname)

	local excuse = unwilling(self, ctx)
	if excuse then
		minetest.chat_send_player(pname, "[NPC] <" ..
				display_name(pname, self, ctx.r) .. "> " .. excuse)
		dialogue.talking[pname] = nil
		minetest.close_formspec(pname, FORMNAME)
		return
	end

	-- Being recognised is worth as much as being liked, and talking to someone
	-- is dealing with them. Only the shop counted before, so a player who had
	-- spoken to half the village twenty times was still greeted as a stranger.
	if village_life.settings.reputation and ctx.village_id then
		village_life.reputation.note_visit(ctx.village_id, pname)
	end

	-- If they know you and you have made an impression -- saved them, robbed
	-- them, hurt one of theirs -- that is what they open with, instead of a
	-- generic hello.
	if not line and ctx.knows_name then
		line = deed_opener(self, pname)
	end

	-- After dark, an innkeeper opens with "Good evening" -- which is also how the
	-- player learns the inn is open and a room is to be had at this hour.
	if not line then
		line = keeper_greeting(self)
	end

	-- An adventurer opens in their own voice -- a pirate sizes up your purse,
	-- a barbarian your softness -- so you know at hello you are not talking to
	-- one of the settled folk.
	if not line and village_life.adventurer
			and village_life.adventurer.is(self) then
		line = village_life.adventurer.greeting(self)
	end

	-- A wandering trader opens in a merchant's voice, coloured by its race, so
	-- you know at hello it is one of the folk on the road, not a townsman.
	if not line and village_life.wanderer
			and village_life.wanderer.is(self) then
		line = village_life.wanderer.greeting(self)
	end

	-- A beast that has stood down after a yell: it has not attacked, but it has
	-- not decided about you either. This is the moment the calm menu belongs to.
	if not line and village_life.redeem
			and village_life.redeem.is_idling(self)
			and not village_life.redeem.is_calmed(self) then
		line = "The beast has stopped. Its chest heaves and its eyes track you -- "
				.. "wary, uncertain, and, for now, still."
	end

	-- Being on speaking terms is worth a little to the person you speak to,
	-- once a day. It is what makes a village you actually walk around in warmer
	-- than one you only buy from.
	village_life.memory.remember(self, pname, "greeted")

	-- Opening a conversation starts it at the top. Right-clicking somebody is
	-- walking up to them and saying hello, so resuming three menus deep into
	-- the last one -- under a greeting -- reads as the window having gone
	-- wrong.
	local session = dialogue.talking[pname]
	if session and session.ent == self then
		session.stack = {}
		session.scroll = 0
	end

	dialogue.speak(self, player, ctx, line)
end

-- Continuing one, after an answer.
function dialogue.advance(self, player, line)
	local pname = player:get_player_name()
	local ctx = context(self, pname)

	local excuse = unwilling(self, ctx)
	if excuse then
		return dialogue.interrupt(self, player, ctx, excuse)
	end

	dialogue.speak(self, player, ctx, line)
end

function dialogue.speak(self, player, ctx, line)
	if lottmobs and lottmobs.face_pos then
		lottmobs.face_pos(self, player:get_pos())
	end

	local pname = player:get_player_name()
	local session = session_for(self, pname, ctx)

	line = line or persona.greet(self, pname,
			familiarity(ctx.band, ctx.knows_name))

	render(self, player, ctx, line, options_for(ctx, session))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then return end
	local pname = player:get_player_name()

	if fields.quit then
		dialogue.talking[pname] = nil
		return
	end

	-- Scrolling is not an answer: remember where they are and repaint nothing.
	-- The value arrives as "CHG:12" / "VAL:12".
	local bar = fields[SCROLLBAR]
	if bar then
		local session = dialogue.talking[pname]
		local v = tonumber(bar:match("(%-?%d+)$"))
		if session and v then session.scroll = v end
	end

	local self = ent_of(pname)
	if not self or not self.object or not self.object:get_pos() then
		-- Whoever they were talking to is gone -- unloaded, or dead. Take the
		-- window away rather than leaving one whose buttons all land back here.
		dialogue.talking[pname] = nil
		minetest.close_formspec(pname, FORMNAME)
		return
	end

	-- Walking off mid-sentence ends the conversation, which is the natural
	-- thing for it to do and saves policing the distance anywhere else.
	local ppos = player:get_pos()
	local npos = self.object:get_pos()
	if ppos and npos and util.dist(ppos, npos) > 8 then
		dialogue.talking[pname] = nil
		minetest.close_formspec(pname, FORMNAME)
		return
	end

	local session = dialogue.talking[pname]

	for field in pairs(fields) do
		local id = field:match("^topic_(.+)$")

		-- Either a registered topic, or something the last repaint drew that is
		-- not one: a menu entry, or the Back action, which is pinned onto every
		-- menu rather than registered as a topic of its own.
		--
		-- Anything not registered is resolved against the list that was
		-- actually drawn, never against a freshly built one. A menu of people
		-- can lose somebody between the paint and the click, and answering
		-- about whoever shuffled up into that slot instead is worse than doing
		-- nothing at all.
		local topic = id and find_topic(id)
		if not topic and id and session and session.options then
			local n = tonumber(id:match("^opt(%d+)$"))
			if n then
				topic = session.options[n]
			else
				for _, entry in ipairs(session.options) do
					if entry.id == id then topic = entry ; break end
				end
			end
		end

		if topic then
			if topic.closes then
				dialogue.talking[pname] = nil
				minetest.close_formspec(pname, FORMNAME)
				return
			end

			-- Moving between lists. Both of these repaint, which is the rule
			-- the whole conversation lives by: a branch that returns without
			-- showing or closing a formspec leaves a live-looking window whose
			-- every button silently does nothing.
			if topic.back then
				pop(session)
				return dialogue.advance(self, player, dialogue.menu_line(self,
						context(self, pname)))
			end

			if topic.opens then
				push(session, topic.opens.menu, topic.opens.arg)
				return dialogue.advance(self, player, dialogue.menu_line(self,
						context(self, pname)))
			end

			-- A menu is its own way in: clicking the top-level topic opens the
			-- list it names.
			if topic.menu then
				push(session, topic.id)
				return dialogue.advance(self, player, dialogue.menu_line(self,
						context(self, pname)))
			end

			if topic.opens_shop then
				-- The gate already asked the shop whether it would open, but
				-- the answer can go stale between the repaint and the click.
				-- Interrupt rather than destroying the conversation for a shop
				-- that then refuses in chat.
				local refusal = village_life.trade.refusal(self, pname)
				if refusal then
					return dialogue.interrupt(self, player,
							context(self, pname), refusal)
				end
				dialogue.talking[pname] = nil
				minetest.close_formspec(pname, FORMNAME)
				village_life.trade.open(self, player)
				return
			end

			-- A wandering trader's own lottmobs shop, not the village_life one.
			if topic.opens_native_trade and village_life.wanderer then
				dialogue.talking[pname] = nil
				minetest.close_formspec(pname, FORMNAME)
				village_life.wanderer.trade(self, player)
				return
			end

			-- The kit window: an inventory grid to dress them from. It replaces the
			-- conversation (its own formspec), so end the talk cleanly first.
			if topic.opens_kit and village_life.companion.open_kit then
				dialogue.talking[pname] = nil
				minetest.close_formspec(pname, FORMNAME)
				village_life.companion.open_kit(self, pname)
				return
			end

			if session and session.asked and topic.id then
				session.asked[topic.id] = true
			end

			local ctx = context(self, pname)

			-- Protected, because an answer that throws would take the whole
			-- callback with it -- and a callback that dies before repainting
			-- leaves exactly the live-looking window whose every button does
			-- nothing that this file has been bitten by twice. A villager who
			-- somehow cannot answer says nothing and the list comes back.
			local line
			if topic.answer then
				local ok, result = pcall(topic.answer, ctx)
				if ok then
					line = result
				else
					village_life.log("warning", ("topic %s failed: %s"):format(
							tostring(topic.id or topic.label), tostring(result)))
					line = "..."
				end
			end

			-- An answer may open a short follow-up strand rather than just
			-- repainting the same list -- reacting to a piece of news, hearing
			-- the next one, asking why. The strand is a submenu of {label, answer}
			-- entries built fresh from this answer's context, so it is never a
			-- terminal one-liner. Anything thrown just falls through to a repaint.
			if topic.follow and session then
				local ok, list = pcall(topic.follow, ctx)
				if ok and type(list) == "table" and #list > 0 then
					session.follow = list
					push(session, "followup")
					return dialogue.advance(self, player, line)
				end
			end

			dialogue.advance(self, player, line)
			return
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	dialogue.talking[player:get_player_name()] = nil
end)

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

-- Takes over right-click from the trade window. Trading is still there; it is
-- now something you ask for rather than the only thing a person is for.
minetest.register_on_mods_loaded(function()
	if not village_life.settings.dialogue then return end

	-- The pigman villager plus the four peaceful wandering traders. Each trader
	-- ships its own on_rightclick (the native lottmobs shop); we capture that
	-- closure so "show me your wares" can reopen it, then take the click over for
	-- dialogue. The pigman has no native trade window here (village_life's own
	-- trade UI attaches separately), so there is nothing to capture for it.
	local wanderer = village_life.wanderer
	local attach = {"lottmobs:pigman_trader"}
	if wanderer then
		-- Redeem-owned species (beastmen, trolls) are skipped here: redeem.lua sets
		-- their on_rightclick, so a raging beastman gets a rebuff rather than an
		-- open conversation, and an idle/calmed one gets dialogue.open.
		for name, sp in pairs(wanderer.SPECIES) do
			if not sp.redeem then attach[#attach + 1] = name end
		end
	end

	for _, name in ipairs(attach) do
		local proto = minetest.registered_entities[name]
		if proto then
			-- Capture the trader's native shop so "show me your wares" can reopen
			-- it. A guard's native right-click is a mercenary hire, not a shop, so
			-- it is dropped, not captured -- there are no wares, and recruiting it
			-- into a town replaces the old hire outright.
			local sp = wanderer and wanderer.SPECIES[name]
			if sp and not sp.guard then sp.native_trade = proto.on_rightclick end

			proto.on_rightclick = function(self, clicker)
				if not clicker or not clicker:is_player() then return end
				dialogue.open(self, clicker)
			end

			village_life.log("action", "dialogue attached to " .. name)
		end
	end
end)
