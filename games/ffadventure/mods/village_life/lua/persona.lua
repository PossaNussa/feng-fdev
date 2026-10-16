-- Who a villager is, beyond their job.
--
-- mg_villages gives every inhabitant a name, a gender, an age, a generation and
-- (for one per household) a profession. That is enough to run a schedule and
-- not nearly enough to hold a conversation: a hundred and fifty people who all
-- answer identically are set dressing, not a village.
--
-- So each one gets a character, derived deterministically from the identity
-- they already have. Nothing here is stored: the same villager is the same
-- person after a restart, in a backup, on another machine. The axes are chosen
-- to affect *what they say* rather than just decorating a profile screen, and
-- enough of them over a village of 150 make repeats vanishingly unlikely.
--
-- What a villager *feels* is elsewhere, and is stored, because it is a record
-- of things that happened rather than a function of a seed: mood and their
-- opinion of a player are in memory.lua, and what they do with their evenings
-- is in traits.lua, which has to consult the world before letting anyone claim
-- anything.

local util = village_life.util
local persona = {}
village_life.persona = persona

--------------------------------------------------------------------------------
-- The axes
--------------------------------------------------------------------------------

-- Temperament drives sentence shape: how they open, whether they volunteer
-- anything, how they refuse. Referenced by dialogue.lua when it picks lines.
persona.temperaments = {
	{id = "gruff",    label = "gruff"},
	{id = "warm",     label = "warm"},
	{id = "shy",      label = "shy"},
	{id = "proud",    label = "proud"},
	{id = "weary",    label = "weary"},
	{id = "sly",      label = "sly"},
	{id = "earnest",  label = "earnest"},
	{id = "dreamy",   label = "dreamy"},
}

-- What they do when they are not working lives in traits.lua, not here. It
-- used to be a flat list of strings drawn at random and spoken as fact, which
-- is how villagers came to keep bees they did not have and fish rivers that
-- were not there. A trait now has to be something the world can back, so it
-- needs to consult the world -- which is not this file's business.

-- What keeps them up. Gives the "how are things" answers somewhere to go, and
-- gives high reputation something to unlock.
persona.worries = {
	"the roof, which will not last another winter",
	"a debt owed to someone across the valley",
	"a son who left for the city and does not write",
	"the well, which tastes wrong lately",
	"wolves, closer every year",
	"a rival who undercuts them on everything",
	"their hands, which are not what they were",
	"a daughter who wants to be a soldier",
	"the tax collector's next visit",
	"something seen in the woods that they will not describe",
	"a brother nobody in the family will mention",
	"the harvest, which is late",
	"dreams they would rather not have",
	"the price of iron",
}

-- A fixed opinion. Two villagers who disagree about the same thing is most of
-- what makes a village feel inhabited.
persona.opinions = {
	"the tavern waters its beer",
	"the miller's thumb is on the scales",
	"the old road was better before they paved it",
	"the priest means well but talks too long",
	"children today are soft",
	"the village square needs a proper well, not that thing",
	"the guards drink on duty",
	"outsiders bring nothing but trouble",
	"outsiders are the only interesting thing that happens here",
	"the bakery is the only honest business left",
	"there is treasure under the hill, whatever anyone says",
	"the smith charges what he likes because he can",
}

-- How they refer to the player before they know them.
persona.strangers = {
	"stranger", "traveller", "friend", "you there", "outsider", "wanderer",
}

--------------------------------------------------------------------------------
-- Derivation
--------------------------------------------------------------------------------

local function pick(list, rng)
	return list[rng:next(1, #list)]
end

-- Character from an identity string alone, with no entity in hand.
--
-- Everything here is a pure function of the seed, so a villager's character can
-- be known without them being loaded -- which is what lets gossip, mourning and
-- succession reason about people who are not currently standing anywhere.
function persona.for_identity(id)
	local rng = util.rng("persona", id)

	return {
		temperament = pick(persona.temperaments, rng).id,
		worry       = pick(persona.worries, rng),
		opinion     = pick(persona.opinions, rng),
		stranger    = pick(persona.strangers, rng),
		-- Talkativeness gates how much they give away per question, so two
		-- villagers of the same temperament still differ in how hard they are
		-- to get anything out of.
		openness    = rng:next(0, 100),
	}
end

-- The same thing for a villager you do have in hand, cached per entity in the
-- weak scratch table because it costs a handful of RNG draws to rebuild.
function persona.of(self)
	local s = util.scratch(self)
	if s.persona then return s.persona end
	local p = persona.for_identity(village_life.economy.identity(self))
	s.persona = p
	return p
end

--------------------------------------------------------------------------------
-- Voice
--------------------------------------------------------------------------------

-- Openers, indexed by temperament and by how well they know the player. These
-- are the lines that carry the character, so they are written out per
-- temperament rather than assembled from fragments -- generated small talk
-- reads like generated small talk.
persona.greetings = {
	gruff = {
		stranger = "What.",
		known    = "You again.",
		friend   = "Ah. It's you. Sit if you like.",
	},
	warm = {
		stranger = "Hello there! Don't often see a new face.",
		known    = "Good to see you, %s.",
		friend   = "There you are! I was hoping you'd come by.",
	},
	shy = {
		stranger = "Oh -- hello. Sorry, I wasn't expecting anyone.",
		known    = "Hello again. I remembered your name this time.",
		friend   = "I'm glad it's you. I don't talk to many people.",
	},
	proud = {
		stranger = "You'll be wanting something, I expect.",
		known    = "Back again. Well, you know where to find me.",
		friend   = "You have good taste in company, %s. Sit down.",
	},
	weary = {
		stranger = "Mm. Make it quick, I've work.",
		known    = "Oh, it's you. Long day. What is it?",
		friend   = "You're a sight for tired eyes. What can I do?",
	},
	sly = {
		stranger = "Well now. And who might you be?",
		known    = "Back for more, are we?",
		friend   = "My favourite customer. Come in, come in.",
	},
	earnest = {
		stranger = "Good day to you. Can I help?",
		known    = "Hello again -- how have you been?",
		friend   = "%s! Genuinely good to see you.",
	},
	dreamy = {
		stranger = "Hm? Oh. Sorry, I was miles away.",
		known    = "Oh, hello. I was just thinking about you, actually.",
		friend   = "There you are. I had a feeling you'd come today.",
	},
}

-- What they say when they will not talk to you at all.
persona.rebuffs = {
	gruff   = "Get away from me.",
	warm    = "I've nothing to say to you. Not any more.",
	shy     = "Please -- just go.",
	proud   = "I do not speak with your sort.",
	weary   = "No. Not today, not you.",
	sly     = "You've a nerve, showing your face here.",
	earnest = "I trusted you once. Go away.",
	dreamy  = "You. You're the one from the dream. Go.",
}

-- What they say when they are running for their door and you have stopped them
-- to chat. `%s` is what they are running from -- "a zombie", "an ogre", or the
-- name of a player the village has written off.
persona.alarms = {
	gruff   = "Not now. There's %s loose.",
	warm    = "Not now, love -- there's %s out there! Get inside, go on!",
	shy     = "There's %s -- please, I can't, I have to go --",
	proud   = "Stand aside. There's %s in my village.",
	weary   = "Not now. There's %s about. There's always something.",
	sly     = "Later. There's %s out there and I've no intention of meeting it.",
	earnest = "There's %s nearby! Get inside, both of us, now!",
	dreamy  = "There's %s. I saw it. I saw it and I have to go.",
}

-- The same, for a villager who is only running because somebody shouted and
-- never saw what it was. Naming a thing they have not seen and were not told
-- about would be the mod putting words in their mouth.
persona.alarms_vague = {
	gruff   = "Not now. Something's out there.",
	warm    = "Not now, love -- something's wrong. Get inside!",
	shy     = "They're shouting -- I don't know what it is -- I have to go!",
	proud   = "Stand aside. There is trouble in my village.",
	weary   = "Not now. Something's out there again.",
	sly     = "Later. Whatever's out there, I'd rather be indoors.",
	earnest = "Something's happening -- get inside, quickly!",
	dreamy  = "Something's out there. I can feel it. I have to go.",
}

-- Small hedges prepended when a reticent villager answers something personal.
persona.hedges = {
	gruff   = "Hmph. ",
	warm    = "",
	shy     = "Well... ",
	proud   = "Since you ask. ",
	weary   = "If you must know. ",
	sly     = "Between us, then. ",
	earnest = "",
	dreamy  = "Mm. ",
}

function persona.greet(self, pname, familiarity)
	local p = persona.of(self)
	local set = persona.greetings[p.temperament] or persona.greetings.earnest
	local line = set[familiarity] or set.stranger
	return (line:gsub("%%s", pname))
end

function persona.hedge(self)
	local p = persona.of(self)
	return persona.hedges[p.temperament] or ""
end

function persona.rebuff(self)
	local p = persona.of(self)
	return persona.rebuffs[p.temperament] or persona.rebuffs.gruff
end

-- `what` is the threat in words, or nil if they cannot name it.
function persona.panic(self, what)
	local p = persona.of(self)
	local set = what and persona.alarms or persona.alarms_vague
	local line = set[p.temperament] or set.earnest
	if not what then return line end
	return (line:gsub("%%s", what))
end

-- Whether this villager will volunteer something personal at this standing.
-- The reticent need to be liked first; the open will tell anyone.
function persona.will_confide(self, score)
	local p = persona.of(self)
	return score >= (60 - p.openness * 0.6)
end
