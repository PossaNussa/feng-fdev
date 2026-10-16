-- Talking somebody into coming with you.
--
-- lottmobs has a hireable-follower path and it is not reachable from an
-- mg_villages villager, which is most of the NPCs in this game. It also could
-- not be reused if it were: `lottmobs.guard` (functions.lua ~305) takes payment
-- and then **removes the entity**, handing the player a craftitem which
-- respawns a nameless guard with `owner` and `order = "follow"` set. That
-- destroys the villager's identity, their bed row, their family, their memory
-- of you, their mood and everything they have heard -- which is to say,
-- everything this mod is. (It also parks its callback in a global, so with two
-- players hiring at once the last click wins.) Nothing here goes near it, and
-- nothing later should wire the two together.
--
-- So: the villager stays the villager. What changes is where they are standing.
--
-- The design rule is that a refusal is never a dead end without a reason. Every
-- "no" says which "no" it is -- some are arithmetic and will move if you come
-- back with more, some are about who this person is and never will. Being told
-- which is the difference between a system and a slot machine.

local util = village_life.util
local home = village_life.home

local hire = {}
village_life.hire = hire

--------------------------------------------------------------------------------
-- Who will not go, whatever you offer
--------------------------------------------------------------------------------

-- A hard refusal is one no amount of coin or standing will move, and it names
-- itself so the player stops paying into it.
--
-- Returns {hard = bool, line = "..."} or nil.
function hire.refusal(self, pname)
	if not village_life.settings.hiring then
		return {hard = true, line = "Folk here don't take service with strangers."}
	end

	local r = home.resolve(self)
	if not r then
		-- A bedless recruit -- a traveller off the road, or a wandering trader --
		-- has no village to leave, but is still hireable. Only the personal blocks
		-- apply: already spoken for, or blood between you.
		if village_life.is_bedless_recruit(self) then
			if village_life.companion.hired_by(self) then
				local who = village_life.companion.employer(self)
				if who == pname then
					return {hard = true, line = "I'm already with you. Have you forgotten?"}
				end
				return {hard = true,
						line = ("I'm spoken for. %s has my word on it."):format(
								who or "Somebody else")}
			end
			if village_life.memory.did(self, pname, "kin_killed") then
				return {hard = true,
						line = "You put down one of my crew. And you've the gall to ask."}
			end
			return
		end
		return {hard = true, line = "I'm nobody's man. Move along."}
	end

	if village_life.companion.hired_by(self) then
		local who = village_life.companion.employer(self)
		if who == pname then
			return {hard = true, line = "I'm already with you. Have you forgotten?"}
		end
		return {hard = true,
				line = ("I'm spoken for. %s has my word on it."):format(
						who or "Somebody else")}
	end

	-- Children and the old. Not a matter of price.
	if r.role == "child" then
		return {hard = true,
				line = "I'm not old enough to go anywhere. My mother would skin us both."}
	end
	if r.role == "elder" then
		return {hard = true,
				line = "Look at me. I'd not make the end of the lane, let alone wherever you're going."}
	end

	-- Blood. There is no sum of money for this and there should not be.
	if village_life.memory.did(self, pname, "kin_killed") then
		return {hard = true,
				line = "You killed one of mine. You stand there and ask me that."}
	end

	local village_id = r.village_id
	if village_life.settings.reputation and village_id then
		local score = village_life.memory.regard(self, pname,
				village_life.reputation.get(village_id, pname))
		local tier = village_life.reputation.tier(score)
		if tier.hostile then
			return {hard = true, line = village_life.persona.rebuff(self)}
		end
		if tier.shun then
			return {hard = true,
					line = "I'd not walk to the well with you, never mind out of the village."}
		end
	end

	-- Not while there is something in the streets. This one is temporary and
	-- says so.
	if village_life.threats.alarm(village_id) then
		return {hard = false,
				line = "Are you mad? There's something loose out there. Ask me when it's dealt with."}
	end

	-- The last person holding a weapon does not walk out of a village.
	if r.role == "guard" and hire.last_defender(village_id, self) then
		return {hard = false,
				line = "I'm the only one on the gate. Find them another pair of hands and we'll talk."}
	end

	-- Asleep, or mid-flight. The same gate the shop uses, for the same reason.
	if village_life.settings.shop_hours then
		local goal = util.scratch(self).goal
		if goal and goal.kind == "sleep" then
			return {hard = false, line = "In the morning. Ask me in the morning."}
		end
		if goal and goal.kind == "flee" then
			return {hard = false, line = village_life.persona.panic(self,
					goal.threat_label)}
		end
	end
end

-- Is this the only villager in the settlement whose job is to fight?
function hire.last_defender(village_id, except)
	if not village_id then return false end
	local village = home.village(village_id)
	if not village or not village.to_add_data then return false end

	local except_key = village_life.memory.key_of(except)
	local n = 0
	for plot_nr, bpos in ipairs(village.to_add_data.bpos or {}) do
		for bed_nr, bed in ipairs(bpos.beds or {}) do
			local t = bed.title
			if not bed.dead and (t == "guard" or t == "soldier") then
				local key = home.key(village_id, plot_nr, bed_nr)
				if key ~= except_key
						and not village_life.companion.away(village_id, plot_nr, bed_nr) then
					n = n + 1
				end
			end
		end
	end
	return n == 0
end

--------------------------------------------------------------------------------
-- How close they are to saying yes
--------------------------------------------------------------------------------

-- The bar. Above this they go.
hire.THRESHOLD = 100

-- Every term is something the player can find out about and change, and the
-- window shows the total, because the point of the whole exercise is that it
-- is a person being persuaded rather than a lock being picked.
--
-- Returns the total and the list of {label, value} it is made of. Coin is NOT
-- in here: an offer is a thing the player makes deliberately (see money_pull and
-- the proposition menu), and folding it in would price a hire off whatever
-- happened to be in a pocket. What is here is who the person is and what holds
-- them; money is weighed against that, separately.
-- A bedless traveller's leaning. They have no village strings and no family
-- here, so it is a small footloose base by kind plus what they personally make
-- of the player. Pirates barely care who you are -- for them the coin (money_pull
-- against a high venality) is nearly the whole of it, and this low base is what
-- makes them greedy: cheap to buy, but you *do* have to buy them.
local SUBTYPE_BASE = {
	wayfarer = 30, sailor = 28, veteran = 22, barbarian = 20, pirate = 8,
}

function hire.adventurer_inclination(self, pname)
	local parts = {}
	local function part(label, value)
		if value == 0 then return end
		parts[#parts + 1] = {label = label, value = value}
	end

	local st = (village_life.adventurer and village_life.adventurer.subtype(self))
			or "wayfarer"
	part("I'm free to go where I like", SUBTYPE_BASE[st] or 25)
	part("what I make of you myself", village_life.memory.opinion(self, pname) * 1.1)
	local mood = village_life.memory.mood(self)
	part("how my year's been going", -mood * 0.35)

	-- A veteran who has watched you deal with something in the dark, or a
	-- barbarian who has seen you fight, is halfway there before coin is spoken.
	if (st == "veteran" or st == "barbarian")
			and village_life.memory.did(self, pname, "rescued") then
		part("I've seen you handle yourself", st == "barbarian" and 20 or 18)
	end

	local total = 0
	for _, e in ipairs(parts) do total = total + e.value end
	return total, parts
end

function hire.inclination(self, pname)
	local r = home.resolve(self)
	if not r then
		-- A bedless recruit -- adventurer or wandering trader -- leans on the same
		-- footloose base. A trader has no subtype, so it defaults to wayfarer.
		if village_life.is_bedless_recruit(self) then
			return hire.adventurer_inclination(self, pname)
		end
		return 0, {}
	end

	local parts = {}
	local function part(label, value)
		if value == 0 then return end
		parts[#parts + 1] = {label = label, value = value}
	end

	local village_id = r.village_id
	local village_score = (village_life.settings.reputation and village_id)
			and village_life.reputation.get(village_id, pname) or 0

	-- What the village thinks, and what *they* think, counted separately: the
	-- woman whose life you saved will follow you out of a village that has
	-- written you off, and that is the most interesting case there is.
	part("what the village makes of you", village_score * 0.45)
	part("what I make of you myself", village_life.memory.opinion(self, pname) * 1.1)

	-- Somebody having a bad month is likelier to leave, which is not a happy
	-- thought but is a true one.
	local mood = village_life.memory.mood(self)
	part("how my year's been going", -mood * 0.35)

	local p = village_life.persona.of(self)
	-- Openness is how hard they are to get anything out of; the same axis
	-- decides how hard they are to move.
	part("what sort of person I am", (p.openness - 50) * 0.30)

	local TEMPERAMENT = {
		dreamy = 16, sly = 10, weary = 8, warm = 2,
		earnest = -4, shy = -10, gruff = -12, proud = -14,
	}
	part("whether I'm the wandering sort", TEMPERAMENT[p.temperament] or 0)

	-- Having actually talked to them. A player who has learned somebody's name
	-- and asked what troubles them is not a stranger with a purse, and the
	-- difference should be worth something.
	local dialogue = village_life.dialogue
	if dialogue.knows(pname, self, "name") then part("we've been introduced", 6) end
	if dialogue.knows(pname, self, "worry") then
		part("you asked what was troubling me", 10)
	end

	-- ...and having done something about it. This is the one term that is not
	-- about talking: their worry is a real thing, and some worries can be
	-- answered by going out and dealing with them.
	if hire.worry_answered(self, pname) then
		part("you saw to what was troubling me", 26)
	end

	-- Who is left behind. Somebody with young children in the house does not
	-- walk out of it for money, and a lodger has nothing holding them.
	local children = village_life.kin.get(self, "child")
	if #children > 0 then part("the children", -14 * math.min(#children, 3)) end
	if village_life.kin.get(self, "spouse")[1] then part("my husband or wife", -10) end
	if r.role == "guest" then part("I'm only passing through anyway", 22) end
	if r.role == "servant" then part("this isn't my house either", 12) end

	-- A trade is a life. The village needs its smith and its smith knows it.
	if r.title and r.title ~= "" and r.role ~= "guard" then
		part("somebody has to do my job", -12)
	end

	local total = 0
	for _, e in ipairs(parts) do total = total + e.value end
	return total, parts
end

-- Whether the player has actually dealt with the thing that keeps this villager
-- up at night. Only some worries are answerable by doing something -- the rest
-- are a son who does not write, or hands that are not what they were -- and
-- pretending otherwise would be the mod inventing a quest it does not have.
local WORRY_DEEDS = {
	["wolves, closer every year"] = "hunted",
	["something seen in the woods that they will not describe"] = "hunted",
	["the harvest, which is late"] = "fed",
	["the well, which tastes wrong lately"] = "fed",
	["the price of iron"] = "traded",
	["a debt owed to someone across the valley"] = "traded",
	["the tax collector's next visit"] = "traded",
}

function hire.worry_answered(self, pname)
	local p = village_life.persona.of(self)
	local want = WORRY_DEEDS[p.worry]
	if not want then return false end

	if want == "hunted" then
		-- Killing something hostile inside the village is already recorded as
		-- a defence, by the village, in reputation.lua. This asks whether this
		-- particular villager saw one.
		return village_life.memory.did(self, pname, "rescued")
	elseif want == "fed" then
		return village_life.memory.did(self, pname, "gift")
	elseif want == "traded" then
		return village_life.memory.did(self, pname, "traded")
	end
	return false
end

--------------------------------------------------------------------------------
-- Coin
--------------------------------------------------------------------------------

-- What is in the player's purse, loose coin and money bags together. Read
-- through lodging, which already handles both and the moneybag meta; hiring
-- prices an offer against what a player actually has, not what they are holding.
function hire.purse(pname)
	local lodging = village_life.lodging
	if lodging and lodging.purse then return lodging.purse(pname) end
	return 0
end

-- Take a set number of coins from the purse on a handshake. Also lodging's, so
-- there is one piece of code that knows how to empty a money bag. Returns true
-- if the coin was actually there and taken.
function hire.take_coins(pname, amount)
	if not amount or amount <= 0 then return true end
	local lodging = village_life.lodging
	if lodging and lodging.take_payment then
		return lodging.take_payment(pname, amount)
	end
	return false
end

-- How much this person is for sale. Some are not: a proud villager will not be
-- bought at any figure, and says so. The weary and the sly very much will. Read
-- off temperament, and nudged up by a hard year -- somebody having a bad time of
-- it is easier to tempt with coin. Not a happy truth, but a true one.
local VENALITY = {
	proud = 0.0, earnest = 0.35, dreamy = 0.5, warm = 0.6,
	shy = 0.85, gruff = 0.95, weary = 1.25, sly = 1.35,
}

-- Some kinds of adventurer have a price set by their trade, not their nature: a
-- pirate is very much for sale, a barbarian sells his arm but keeps his pride.
local SUBTYPE_VENALITY = {
	pirate = 1.6, sailor = 1.1, veteran = 0.8, barbarian = 0.6,
}

function hire.venality(self)
	local v
	local st = village_life.adventurer and village_life.adventurer.subtype(self)
	if st and SUBTYPE_VENALITY[st] then
		v = SUBTYPE_VENALITY[st]
	else
		local p = village_life.persona.of(self)
		v = VENALITY[p.temperament]
		if v == nil then v = 0.6 end
	end
	if v <= 0 then return 0 end
	local mood = village_life.memory.mood(self)
	if mood < 0 then v = v + math.min(0.4, -mood * 0.01) end
	return v
end

-- Inclination bought by an offer of `coins`. Diminishing -- the tenth coin says
-- less than the first -- but not capped, so that for the venal and the
-- unattached the right price really can carry the whole thing on its own, while
-- the proud get nothing from it however high it goes. For most people it is a
-- component: a little coin on top of a little persuasion is what does it.
function hire.money_pull(self, coins)
	coins = coins or 0
	if coins <= 0 then return 0 end
	local v = hire.venality(self)
	if v <= 0 then return 0 end
	return v * math.sqrt(coins) * 6
end

-- The coin amounts the proposition menu offers, filtered to what the purse can
-- cover, plus the whole purse as a last rung. A short, legible ladder rather
-- than a text box: you are naming a figure, not typing one.
local TIERS = {25, 50, 100, 250, 500}

function hire.offer_rungs(pname)
	local have = hire.purse(pname)
	if have <= 0 then return {}, 0 end
	local out, seen = {}, {}
	for _, n in ipairs(TIERS) do
		if n <= have and not seen[n] then out[#out + 1] = n ; seen[n] = true end
	end
	if not seen[have] then out[#out + 1] = have end   -- "everything I have"
	return out, have
end

--------------------------------------------------------------------------------
-- The arguments
--------------------------------------------------------------------------------

-- Each is offered only when it is *true of this person*, which is what stops
-- the persuasion being five buttons that all mean "roll again". Weight is what
-- it moves the inclination by if it lands.
--
--   gate(ctx, r)  is this argument available at all
--   lands(ctx, p) does it work on them
hire.arguments = {
	{
		id = "trade",
		label = "I could use someone who knows their trade.",
		gate = function(ctx, r) return r ~= nil and r.title ~= nil and r.title ~= "" end,
		lands = function(ctx, p)
			return p.temperament == "proud" or p.temperament == "earnest"
					or p.temperament == "warm"
		end,
		weight = 20,
		good = "You'd not find better this side of the valley. That's not boasting, that's twenty years.",
		bad = "My trade's here. That's rather the point of having one.",
	},
	{
		id = "worry",
		label = "You told me what was troubling you. I've seen to it.",
		-- Only offered if they really told you, and only lands if you really
		-- did something. Claiming it falsely is its own kind of answer.
		gate = function(ctx)
			return village_life.dialogue.knows(ctx.pname, ctx.self, "worry")
		end,
		lands = function(ctx) return hire.worry_answered(ctx.self, ctx.pname) end,
		weight = 30,
		good = "...You did, didn't you. Nobody's done that for me. Nobody.",
		bad = "Have you. Have you really. Then say what it was, because you haven't.",
	},
	{
		id = "wander",
		label = "Don't you ever want to see what's past the hill?",
		gate = function() return true end,
		lands = function(ctx, p)
			return p.temperament == "dreamy" or p.temperament == "sly"
					or p.temperament == "weary"
		end,
		weight = 22,
		good = "Every single day of my life. Every day.",
		bad = "No. I've been past the hill. It's more hill.",
	},
	{
		id = "nobody",
		label = "Nobody here would even miss you.",
		-- Cruel, and true of a lodger with no family in the village. Said to
		-- somebody with children in the house it is unforgivable, and the
		-- check for that is the kin list, not a dice roll.
		gate = function() return true end,
		lands = function(ctx)
			local k = village_life.kin.of(ctx.self)
			if not k then return true end
			for _ in pairs(k.by) do return false end
			return true
		end,
		weight = 24,
		penalty = 40,
		good = "...No. They wouldn't. When do we leave.",
		bad = "I have a family in that house. Get out of my sight.",
	},
}

-- Making an argument. Returns the line, whether it landed, and what it moved.
function hire.argue(ctx, def)
	local p = village_life.persona.of(ctx.self)
	local ok = def.lands(ctx, p) == true
	local delta = ok and def.weight or -(def.penalty or 6)

	-- An argument that misses is a thing you said to somebody, and they
	-- remember it. The cruel one costs a great deal more than the clumsy ones,
	-- which is the only reason it is worth having in the list.
	if not ok then
		village_life.memory.remember(ctx.self, ctx.pname, "offended",
				def.penalty and 3 or 1)
	end

	return (ok and def.good or def.bad), ok, delta
end

-- What they say when you put a figure on the table. The proud refuse it flat
-- and it costs you a little (offering to buy a proud person is an insult); for
-- everyone else it reacts to how far the coin moved them and whether, on top of
-- everything else, it is now enough. The second return is whether the offer was
-- entertained at all -- false only for the incorruptible, so the caller knows
-- not to bank the pledge.
function hire.money_react(self, coins, score)
	if hire.venality(self) <= 0 then
		return "Put your coin away. I'm not something you buy.", false
	end
	local pull = hire.money_pull(self, coins)
	if score >= hire.THRESHOLD then
		return ("...%d? Aye. For that I'll come -- ask me proper and I'm yours."):
				format(coins), true
	elseif pull >= 40 then
		return ("%d coins. Now that's an offer. It helps -- it truly does."):
				format(coins), true
	elseif pull >= 15 then
		return "Coin's coin, and it's not nothing. But it's not the whole of it either.",
				true
	end
	return "That barely covers my boots. You'll do better than that, or talk sweeter.",
			true
end

--------------------------------------------------------------------------------
-- The verdict
--------------------------------------------------------------------------------

-- How many arguments they will listen to before making up their mind. Small:
-- a conversation, not an attrition.
hire.ATTEMPTS = 3

-- What they say when they will not go, phrased so the player knows what would
-- have to change. This is the whole difference between a refusal and a wall.
function hire.decline(ctx, score)
	local short = hire.THRESHOLD - score
	if short > 60 then
		return "No. Not for you, not for that, not today."
	elseif short > 25 then
		return "No. Ask me again when you've a reason I'd believe."
	end
	return "...No. And I'll be honest with you, it was closer than I'd like. Come back."
end

function hire.accept(ctx)
	local p = village_life.persona.of(ctx.self)
	local lines = {
		gruff = "Right. Don't talk at me while we walk.",
		warm = "Then I'm with you. Let me get my coat.",
		shy = "Oh -- really? Yes. Yes, all right. I'll come.",
		proud = "You'll be glad of me. Lead on.",
		weary = "...Aye. Why not. Nothing keeping me.",
		sly = "Now this I did not expect to be doing today. After you.",
		earnest = "Then I'll come, and I'll do it properly. My word on it.",
		dreamy = "I dreamt about this. I did. Let's go before it changes.",
	}
	return lines[p.temperament] or lines.earnest
end

return hire
