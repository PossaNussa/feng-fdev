-- Talking for the sake of it.
--
-- Every other topic in this mod extracts a fact and then closes: you learn
-- their name once, their trade once, what troubles them once. That is right for
-- facts and it is why a villager was exhausted in about ninety seconds. There
-- was nothing to come back for.
--
-- This is the part with nothing to extract. It never runs out, because it is
-- made of things that change: the weather now, the season, the hour, what mood
-- they are in today, what the village is short of this week. And it is the only
-- place the *player* says something rather than asking something -- which is
-- what makes it possible to be good company, or to put your foot in it.
--
-- Same rule as everywhere else: nothing is said as fact that the world does not
-- model. The remark about the weather is about the weather that is actually
-- falling on them.

local util = village_life.util

local banter = {}
village_life.banter = banter

--------------------------------------------------------------------------------
-- Remarks
--------------------------------------------------------------------------------

-- A remark is a function returning a line, or nil when it has nothing to say
-- right now -- which is most of them most of the time, and is the point. The
-- ones that can speak are the ones the world has given something to speak
-- about.
--
-- They are pooled and drawn from, rather than ranked, because small talk that
-- always picks the most interesting thing available is not small talk.
local remarks = {}

local function remark(id, fn)
	remarks[#remarks + 1] = {id = id, fn = fn}
end

remark("weather", function(ctx)
	local pos = ctx.self.object and ctx.self.object:get_pos()
	local severity = village_life.schedule.weather_severity(pos)
	if severity == "severe" then
		return "Filthy out. I'd not send a dog into that, and I've got to walk home in it."
	elseif severity == "mild" then
		return "It'll pass. It always passes. Doesn't stop it being wet in the meantime."
	end
	return "Fine day. We get about nine of them, so I'm counting."
end)

remark("wind", function(ctx)
	if not minetest.global_exists("climate_api")
			or not climate_api.environment
			or not climate_api.environment.get_wind then
		return
	end
	local pos = ctx.self.object and ctx.self.object:get_pos()
	if not pos then return end
	local ok, wind = pcall(climate_api.environment.get_wind, pos)
	if not ok or not wind then return end

	local speed = math.sqrt(wind.x * wind.x + wind.z * wind.z)
	if speed < 0.4 then
		return "Not a breath of wind. Weather's holding its tongue about something."
	end
	local from = village_life.land.bearing({x = 0, y = 0, z = 0},
			{x = -wind.x, y = 0, z = -wind.z})
	if speed > 3 then
		return ("Wind's up, and out of the %s. That's never good news."):format(from)
	end
	return ("Wind's out of the %s today. Steady enough."):format(from)
end)

remark("season", function(ctx)
	local season = village_life.market.season()
	local lines = {
		spring = "Ground's soft again. Everything to do and no time to do it in.",
		summer = "Long days. I'd complain, but I'd have to do it in this heat.",
		autumn = "Harvest in, and the light going by the day. Best time of year, whatever they say.",
		winter = "Short days, long nights, and everything worth eating costs double.",
	}
	return lines[season]
end)

remark("hour", function(ctx)
	local hour = util.hour()
	if hour < 6 then
		return "You're about early. Or late. I've stopped being able to tell."
	elseif hour < 10 then
		return "Morning. Half the day gone already, to hear my mother tell it."
	elseif hour > 20 then
		return "Getting on. I'll be for my bed before long, and so should you."
	end
	return nil
end)

remark("mood", function(ctx)
	local spirits = village_life.memory.spirits(ctx.self)
	local lines = {
		cheerful = "I'll tell you, I've had a good week. Doesn't happen often enough to waste it.",
		wretched = "I'm not much company today. I'd not take it personally.",
		low = "Bit of a week. Nothing you'd want to hear about.",
	}
	return lines[spirits]
end)

remark("trade", function(ctx)
	local c = village_life.market.character(ctx.village_id)
	if not c then return end
	return ("Everything's %s round here and never enough %s. That's the whole village in one sentence."):format(
			c.speciality, c.scarce)
end)

remark("player", function(ctx)
	local player = minetest.get_player_by_name(ctx.pname)
	if not player then return end
	local pos = player:get_pos()
	if not pos then return end
	if pos.y < -40 then
		return "You've the look of someone who's been underground. It's in the eyes."
	end
	-- `player.get_hp`, not `player:get_hp` -- the colon is a *call*, so probing
	-- with it is a syntax error rather than a check. Same trap as
	-- stack.get_short_description in trade_ui.
	local ok, hp = pcall(function() return player:get_hp() end)
	if ok and hp and hp <= 8 then
		return "You're bleeding on my step. Sit down before you fall down."
	end
	return nil
end)

remark("job", function(ctx)
	local title = ctx.r and ctx.r.title
	if not title or title == "" then return end
	return ("Twenty years the %s. It's not what I'd have picked at fifteen, but nobody asked me then either."):format(
			title)
end)

-- One remark. Which one moves with the day, so standing there asking twice
-- running gets two different answers, and asking tomorrow gets another.
function banter.remark(ctx)
	local pool = {}
	for _, r in ipairs(remarks) do
		local ok, line = pcall(r.fn, ctx)
		if ok and line then pool[#pool + 1] = line end
	end
	if #pool == 0 then return "Mm." end

	-- Walked, not sampled.
	--
	-- Drawing independently each time means repeats, and often: over five
	-- remarks, one ask in five says what the last one said. Small talk that
	-- repeats itself is the exact complaint this file exists to answer. So the
	-- *starting point* is random per villager per day and the conversation then
	-- steps through the pool, which cannot repeat until it has been exhausted.
	local n = (ctx.asked and ctx.asked.banter_count or 0)
	local rng = util.rng("banter", village_life.memory.key_of(ctx.self),
			ctx.pname, minetest.get_day_count and minetest.get_day_count() or 0)
	local offset = rng:next(0, #pool - 1)
	return pool[((offset + n) % #pool) + 1]
end

--------------------------------------------------------------------------------
-- Jokes
--------------------------------------------------------------------------------

-- Written per temperament, like the greetings, and for the same reason: a joke
-- assembled from fragments reads like a joke assembled from fragments.
--
-- `%s` is a real neighbour, drawn from the people this villager actually knows.
-- A joke at nobody's expense is a joke about nothing.
local JOKES = {
	gruff = {
		"A man walks into a tavern. Ought to have looked where he was going. That's it, that's the joke.",
		"What's the difference between %s and a sack of wet straw? The sack pulls its weight.",
	},
	warm = {
		"Why does %s never lose an argument? Nobody can be bothered to have one with them.",
		"My grandmother used to say: never trust a baker who's thin. She married one. He wasn't thin.",
	},
	shy = {
		"Oh -- um. Knock knock? ...No, I've forgotten the rest. Sorry.",
		"There's one about %s and a goat, but I couldn't possibly.",
	},
	proud = {
		"They say a prophet is never honoured in their own village. I wouldn't know. I'm honoured everywhere.",
		"%s once asked me for advice. Once. They've not needed any since, which tells you how good it was.",
	},
	weary = {
		"A traveller asks a villager the way to the city. Villager says: I wouldn't start from here. That's not a joke, that's advice.",
		"What do you call thirty years in the same trade? Tuesday.",
	},
	sly = {
		"How do you know when %s is lying? They've opened their mouth. -- Don't repeat that.",
		"Two thieves rob a miller. Only one goes to gaol. Guess which one wasn't the miller's cousin.",
	},
	earnest = {
		"Why did the farmer win an award? Because he was outstanding in his field! ...I like that one. I know.",
		"%s told me a joke last week and I've been laughing at it since. I can't remember it, mind.",
	},
	dreamy = {
		"I dreamt I told the funniest joke in the world and everyone wept. I've been trying to remember it since.",
		"What's the difference between a river and a road? Nothing. Both of them leave.",
	},
}

function banter.joke(ctx)
	local p = village_life.persona.of(ctx.self)
	local set = JOKES[p.temperament] or JOKES.earnest

	-- Stepped through rather than drawn from, same as the remarks: a villager
	-- with two jokes who tells you the same one twice running has one joke.
	local n = ctx.asked and ctx.asked.joke_count or 0
	local rng = util.rng("joke", village_life.memory.key_of(ctx.self))
	local line = set[((rng:next(0, #set - 1) + n) % #set) + 1]

	if line:find("%%s") then
		local people = village_life.regard.people(ctx.self)
		if #people == 0 then
			-- No neighbours, no joke at their expense. Fall back rather than
			-- naming somebody who is not there.
			line = set[1]:find("%%s") and
					"I had one. It's gone. That's the joke now, I suppose."
					or set[1]
		else
			-- Somebody they are not fond of, if there is one: a joke is a
			-- cheaper way of saying what they think than saying it.
			local pick, worst
			for _, row in ipairs(people) do
				local score = village_life.regard.of(ctx.self, row)
				if not worst or score < worst then pick, worst = row, score end
			end
			line = line:format(pick.name or "somebody")
		end
	end
	return line
end

--------------------------------------------------------------------------------
-- The player says something
--------------------------------------------------------------------------------

-- Each tone is a bet on who you are talking to. The stake is their opinion of
-- you, which is the same number every other kindness and injury in this mod
-- moves, so being an idiot in conversation costs exactly what it should and
-- being good company is worth exactly as much as a small gift.
--
-- Fields:
--   label     the button
--   gate      when it is offered at all
--   lands     (ctx, p) -> true when it works on this person
--   good/bad  what they say either way
banter.tones = {}

local function tone(id, def)
	def.id = id
	banter.tones[#banter.tones + 1] = def
end

tone("flatter", {
	label = "You strike me as the sharpest person in this village.",
	-- The proud drink it; the earnest hear a liar. That is the whole game.
	lands = function(ctx, p)
		return p.temperament == "proud" or p.temperament == "shy"
				or p.temperament == "dreamy"
	end,
	good = {
		proud = "Well. You're not the fool you look, then.",
		shy = "Oh -- no, I -- well. That's kind. Nobody says that.",
		dreamy = "Do I? How strange. I've always felt rather blurred.",
		[1] = "That's good of you to say.",
	},
	bad = {
		earnest = "You don't know me well enough to say that, and we both know it.",
		gruff = "Don't.",
		sly = "Flattery. From you. What is it you want?",
		weary = "Mm. And the sharpest person in the village is still here, isn't she.",
		[1] = "If you say so.",
	},
})

tone("needle", {
	label = "This whole village looks half asleep to me.",
	lands = function(ctx, p)
		return p.temperament == "sly" or p.temperament == "weary"
				or p.temperament == "gruff"
	end,
	good = {
		sly = "Ha! It is. Don't tell them I agreed with you.",
		weary = "You've been here an hour and you've got it exactly.",
		gruff = "...Aye. It does. Go on then, you're not all bad.",
		[1] = "You're not wrong.",
	},
	bad = {
		proud = "My village. Say that again and see what it gets you.",
		earnest = "That's a rotten thing to say about people who've done nothing to you.",
		shy = "Oh. That's -- I don't think that's fair.",
		warm = "Now that's unkind. These are good people, whatever you think of the place.",
		[1] = "I'll pretend I didn't hear that.",
	},
})

tone("boast", {
	label = "You're speaking to someone who's killed things you've only dreamt of.",
	-- The one tone the world can call your bluff on: it works if the village
	-- has actually seen you do something. Standing is that record.
	lands = function(ctx) return ctx.score >= 40 end,
	good = {
		[1] = "I'd heard something of that, actually. It's why I'm still standing here.",
	},
	bad = {
		sly = "Have you now. And here you are, telling a stranger about it.",
		gruff = "Everyone who says that is dead within the year. Good luck.",
		weary = "Mm. We had one of those last spring. Nice grave.",
		[1] = "I'm sure. Everyone who comes through here has killed something.",
	},
})

tone("joke", {
	label = "Here's one: what do you call a smith with no arms?",
	lands = function(ctx, p)
		-- A joke lands on the cheerful and dies on the miserable, which is the
		-- least surprising rule in this file and the truest.
		return village_life.memory.mood(ctx.self) > -10
				and p.temperament ~= "gruff"
	end,
	good = {
		sly = "...Go on. No, don't. I can see it coming and I want to keep liking you.",
		warm = "Ha! Terrible. Say another one.",
		earnest = "I don't know! What do you call them? ...Oh, that's awful. That's very good.",
		shy = "Oh -- ha. Yes. That's -- yes, that's funny.",
		[1] = "Hah. All right. That's not bad.",
	},
	bad = {
		gruff = "I'm a smith.",
		weary = "I've heard it. I heard it the first four hundred times.",
		[1] = "Mm. Yes. Very good.",
	},
})

tone("blunt", {
	label = "I'll be straight with you: I want something.",
	-- Nearly always works. Honesty is cheap and it is worth something to
	-- almost everybody -- which is what makes the other four a choice rather
	-- than a puzzle with one answer.
	lands = function(ctx, p) return p.temperament ~= "proud" end,
	good = {
		gruff = "Finally. Somebody who isn't dancing about it. What.",
		weary = "Thank you. Genuinely. Ask.",
		sly = "Everyone wants something. You're the first to say so. Ask.",
		[1] = "Well. That's refreshing. Go on.",
	},
	bad = {
		proud = "Of course you do. Nobody comes to me for the pleasure of it.",
		[1] = "Everybody does.",
	},
})

-- What being good or bad company is worth. Small: this is conversation, not a
-- quest, and it is capped by memory.lua's own bounds either way.
banter.WORTH_GOOD = 1
banter.WORTH_BAD = -1

function banter.say(ctx, def)
	local p = village_life.persona.of(ctx.self)
	local ok = def.lands ~= nil and def.lands(ctx, p) == true

	local set = ok and def.good or def.bad
	local line = set[p.temperament] or set[1] or "..."

	-- It lands in the same book as every other thing a player does to a
	-- villager, so being pleasant company really does warm somebody to you and
	-- being a boor really does cost you -- on the ladder the rest of the mod
	-- already reads.
	village_life.memory.remember(ctx.self, ctx.pname,
			ok and "amused" or "offended")
	village_life.memory.nudge_mood(ctx.self, ok and 2 or -3,
			ok and "good company" or "bad company")

	return line, ok
end

return banter
