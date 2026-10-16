-- Adventurers: the people passing through.
--
-- Two kinds wear the explorer's cloak, and this module speaks for both.
--
--   * Inn guests. mg_villages seats a "guest" in a hotel bed; village_life used
--     to have them mutter "I'm only passing through" and nothing else. Now a
--     guest is an adventurer who rode in a night or two back, has somewhere to
--     be, and knows the country around here well enough to point you at a
--     dungeon. Their story is reseeded every few days, so the room turns over --
--     stay away a week and a different traveller has the bed.
--
--   * Travellers. Bedless pigmen that walk into a village after dark, or turn up
--     out in the wild near a road, and are gone by day. They belong to no
--     village -- home.adopt refuses them -- and this module spawns them, thins
--     them out, and lets them wander off again. That is the "town to town" of
--     it: nobody trudges cross-country (they would not survive the woods), they
--     simply appear where a player is, and the next night appear somewhere else.
--
-- Both come in kinds -- a plain wayfarer, a barbarian down from the north, a
-- pirate off a named crew, a beached sailor, a retired guard who still hunts --
-- and each has its own way of talking and, for the pirate, its own easy price.
--
-- What either of them knows about the land is poi.lua's business: a true bearing
-- to a dungeon dungeonsplus really built, or, when there is nothing known
-- nearby, a rumour told the same way every time so they keep their story
-- straight. What they know about the *world* -- Nune and the seas south of it,
-- the desert realms, the frozen north, the continents east -- is hot air, and
-- told as such.

local util = village_life.util
local home = village_life.home

local adventurer = {}
village_life.adventurer = adventurer

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

--------------------------------------------------------------------------------
-- Kinds
--------------------------------------------------------------------------------

local SUBTYPES = {"wayfarer", "barbarian", "pirate", "sailor", "veteran"}

-- Weights for a lone traveller. Pirates are not rolled here: they arrive as a
-- crew, handled apart. A bed-bound inn guest can still be any kind (a pirate
-- ashore, a barbarian at the inn) -- that draw is over all of SUBTYPES.
local SOLO = {
	{"wayfarer", 38}, {"veteran", 24}, {"sailor", 20}, {"barbarian", 18},
}

-- Skin per kind. The plain wayfarer has a male and a female cut (the explorer
-- sheets); the pirate has two variants; the rest a single sheet each. A
-- deterministic pick off the traveller's own seed keeps a crew from all wearing
-- the same coat while never flipping a given pirate's coat on a reload.
local SUBTYPE_SKIN = {
	wayfarer  = {m = {"villager_explorer.png"}, f = {"villager_explorer_f.png"}},
	barbarian = {any = {"villager_barbarian.png"}},
	pirate    = {any = {"villager_pirate.png", "villager_pirate2.png"}},
	sailor    = {any = {"villager_sailor.png"}},
	veteran   = {any = {"villager_veteran.png"}},
}

local function pick_skin(subtype, gender, seed)
	local set = SUBTYPE_SKIN[subtype] or SUBTYPE_SKIN.wayfarer
	local list = set.any or set[gender == "f" and "f" or "m"] or set.m or set.f
	if not list or #list == 0 then return "villager_explorer.png" end
	if #list == 1 then return list[1] end
	local rng = util.rng("adv_skin", seed or subtype)
	return list[rng:next(1, #list)]
end

--------------------------------------------------------------------------------
-- Names, crews, and the wider world
--------------------------------------------------------------------------------

-- Names for the bedless -- mg_villages does not name them, so the road does.
local TRAVELLER_NAMES = {
	"Corin", "Ashe", "Bramwell", "Neva", "Talis", "Roan", "Sela", "Garrow",
	"Wren", "Haldor", "Mira", "Fenn", "Osric", "Lyra", "Dax", "Perrin",
}

-- Pirates. Crew given-names, and the captains they answer to.
local PIRATE_NAMES = {
	"Toller", "Kegg", "Rook", "Nix", "Harl", "Denna", "Bilge", "Sedda",
	"Pell", "Mox", "Skarn", "Wick", "Cutter", "Sculla",
}
local CAPTAINS = {
	"Captain Vane", "Red Halgar", "Bess the Knife", "Old Marrow",
	"Sculla Drowned-Hand", "Grieve of the Fabled Sea", "One-Eye Toller",
}
-- Famous flags, the kind a pirate expects you to have heard of and is quietly
-- wounded when you have not.
local CREW_NAMES = {
	"the Salt Wolves", "the Drowned Kings", "the Red Gull", "the Black Sabre",
	"the Sadh Sada Corsairs", "the Fabled Sea Company", "the Nunish Reavers",
	"the Gutted Whale", "the Tide's Widow", "the Hollow Crown",
}

-- The tall tales. This is the canon of the world, told badly on purpose by
-- people who have mostly not been where they say. Nune is where you are; the
-- rest is south, north, and east of here, and the years are of the Questing Age.
local TALES = {
	"They say the Shahanshah of Oasis -- Alakshai, Lord of Lords -- has held his throne since the year eight. Eight! And not a grey hair on him. Immortal, the desert swears it, and I've met men who'd wager their ship on the truth of it.",
	"Up the north of the Endless Desert sits the Sadh Sada -- a whole kingdom of bandits, and prouder of it than any crowned king. I sold them rope once. Once.",
	"You'll have heard of the Blood War? Year eighty, and the gods themselves came back into the world -- the redemption of the whole of it, won against the hosts of Hell. Alakshai had a hand in it, or so Oasis tells the tale.",
	"Sail far enough south past the South Nunish Sea and you come to the Fabled Sea. Fabled, because half of what's said to be in it isn't, and the other half will swallow your boat whole.",
	"Hewendall, in the frozen north -- the hunter clans up there put a spear in things I'll not name after dark. Cold enough to freeze the truth right out of a man.",
	"East, past everything, lie the Dark Lands. And past even those, Galith -- so far off I've met but one man who claimed to have seen it. He lied about everything else, mind, so make of that what you will.",
	"This whole continent -- Nune -- and folk here think the world ends at the next valley. I walked its coast once. Took a year and cost me two toes.",
	"There's an island out in the Fabled Sea where the birds talk and the fish walk ashore of an evening, or so every deckhand swears. I've never found it. I keep looking.",
	"We count the years by the Questing Age now -- this being the eighty-first of it. But there were ages before, older than any telling, and things left over from them still down in the dark.",
	"They reckon it was the Blood War that mended the world's road to the gods -- eighty years into this age. Before that? A long quiet, and nobody above listening. Or so the priests would have it.",
}

--------------------------------------------------------------------------------
-- Who they are and where they've been
--------------------------------------------------------------------------------

-- Wayfarer flavour. Vague and place-nameless on purpose: an invented town two
-- valleys over that the player can then never find reads as a lie; "the coast
-- road" reads as a road.
local ORIGINS = {
	"the coast road", "over the eastern hills", "a holdfast a week north",
	"the salt marshes", "the deep-country mines", "downriver, a long way down",
	"the old kingdom road", "a village the fever emptied", "the high passes",
	"the last town with a wall still standing",
}
local HEADINGS = {
	"the mountains, before the snow closes them",
	"the coast, if the road holds",
	"wherever the road bends next",
	"the capital, eventually",
	"the ruins out in the deep wood",
	"south, ahead of the winter",
	"nowhere in particular -- that's rather the point",
	"back the way I came, once I've rested",
}
local REASONS = {
	"Work, mostly. There's always work for someone who'll go and look.",
	"Looking for something. Aren't we all.",
	"Ahead of a debt, if you must know.",
	"The maps are wrong, and somebody ought to say so.",
	"Curiosity. It's cost me before and it'll cost me again.",
	"I made a promise to someone who's dead now. Long story.",
}
local ARRIVED = {
	"last night", "a night or two back", "yesterday, footsore",
	"this evening, just ahead of the dark",
}

-- Guests keep their mg_villages name but turn over their *story* on this cadence,
-- so the inn's guest is plausibly a different traveller from one week to the
-- next without touching the bed data.
local LEG_DAYS = 3

-- Deterministic weighted pick from a {name, weight} list.
local function weighted(list, rng)
	local total = 0
	for _, e in ipairs(list) do total = total + e[2] end
	local roll = rng:next(1, total)
	for _, e in ipairs(list) do
		roll = roll - e[2]
		if roll <= 0 then return e[1] end
	end
	return list[1][1]
end

-- The adventurer's current story, cached and reseeded when the leg turns over
-- (guests) or once for good (a traveller, whose seed never changes while it
-- lives). Returns {subtype, origin, heading, reason, arrived, crew, captain,
-- seed} or nil.
function adventurer.of(self)
	if not self then return end
	local s = util.scratch(self)

	local seed, leg
	if self._adventurer then
		seed, leg = self._adv_seed or "adv", 0
	else
		local r = home.resolve(self)
		if not r or r.role ~= "guest" then return end
		seed = home.key(r.village_id, r.plot_nr, r.bed_nr)
		leg = math.floor(today() / LEG_DAYS)
	end

	if s.adv and s.adv_leg == leg and s.adv_seed == seed then return s.adv end

	local rng = util.rng("adventurer", seed, leg)

	-- A traveller carries its kind on the entity (set at spawn); a guest draws
	-- one from its seed, and may be any kind at all.
	local subtype = self._adv_subtype
	if not subtype then
		subtype = SUBTYPES[rng:next(1, #SUBTYPES)]
	end

	local a = {
		subtype = subtype,
		origin  = ORIGINS[rng:next(1, #ORIGINS)],
		heading = HEADINGS[rng:next(1, #HEADINGS)],
		reason  = REASONS[rng:next(1, #REASONS)],
		arrived = ARRIVED[rng:next(1, #ARRIVED)],
		seed    = seed .. ":" .. leg,
	}

	if subtype == "pirate" then
		-- A traveller pirate was spawned with a real crew; a guest pirate makes
		-- one up from its seed (their shipmates are wherever the ship is).
		a.crew    = self._adv_crew or CREW_NAMES[rng:next(1, #CREW_NAMES)]
		a.captain = self._adv_captain or CAPTAINS[rng:next(1, #CAPTAINS)]
	end

	s.adv, s.adv_leg, s.adv_seed = a, leg, seed
	return a
end

-- True of anyone this module speaks for: a marked traveller, or a villager the
-- inn has seated as a guest.
function adventurer.is(self)
	if not self then return false end
	if self._adventurer then return true end
	local r = home.resolve(self)
	return r ~= nil and r.role == "guest"
end

-- The kind of adventurer this is, or nil for anyone this module does not speak
-- for. Public so hire.lua can price a pirate differently and dialogue.lua can
-- offer the right questions.
function adventurer.subtype(self)
	if self and self._adv_subtype then return self._adv_subtype end
	local a = adventurer.of(self)
	return a and a.subtype
end

-- The town role a recruited adventurer settles into. It is their *kind* -- a
-- veteran settles as a veteran, a sailor as a sailor -- never the flat
-- "adventurer" placeholder self.profession carries, which threw away who they
-- were and (because "adventurer" is not one of lottmobs' career skins) repainted
-- them a random pigman on the first reload. lottmobs.pigman_trader_texture now
-- knows every subtype, so the title alone carries both the nameplate and the
-- coat across a settle and every later respawn. Both settle paths call this
-- (settlement.identity_of, companion.settle); apply_role heals older saves that
-- were already recorded under the generic title. nil for a non-adventurer.
function adventurer.settle_title(self)
	return adventurer.subtype(self)
end

--------------------------------------------------------------------------------
-- What they say
--------------------------------------------------------------------------------

-- The opener. Kept per-kind and seeded, so the same person greets you the same
-- way twice running.
local GREET = {
	wayfarer  = {"Evening. Long road, isn't it.", "Hail, stranger. Share the fire?"},
	barbarian = {"You. You look soft. No offence -- most folk do, to me.",
	             "Speak. I've split no skulls today and it's made me short."},
	pirate    = {"Well now. And what's your angle, friend?",
	             "You've the smell of coin about you. I like that in a stranger."},
	sailor    = {"Evening. Don't mind me -- just glad of ground that holds still.",
	             "Hail. You from around this... whatever you call this?"},
	veteran   = {"Evening. Keep your blade where I can see it and we'll get on fine.",
	             "Something needs killing? ...No? Pity. Sit, then."},
}

function adventurer.greeting(self)
	local st = adventurer.subtype(self) or "wayfarer"
	local a = adventurer.of(self)
	local rng = util.rng("adv_greet", (a and a.seed) or "adv")
	local pool = GREET[st] or GREET.wayfarer
	return pool[rng:next(1, #pool)]
end

-- The line that used to be "I'm only passing through". Now it says who they are
-- and where from, which is the whole difference between a guest and an
-- adventurer -- and differs by kind.
function adventurer.introduce(self)
	local a = adventurer.of(self)
	if not a then return "I'm only passing through, same as you." end
	local st = a.subtype
	if st == "barbarian" then
		return ("I came down out of the north -- Hewendall, the hunter clans -- looking for something worth fighting. Got in %s."):format(a.arrived)
	elseif st == "pirate" then
		return ("Off %s, %s's crew -- ashore %s and lighter of pocket than I'd like. Name means nothing to you? ...Landlocked. Gods have mercy."):format(a.crew, a.captain, a.arrived)
	elseif st == "sailor" then
		return ("Deckhand, beached till a ship'll have me again. Sailed the South Nunish Sea, mostly -- it's bigger than you're picturing, then bigger than that. Came inland %s."):format(a.arrived)
	elseif st == "veteran" then
		return ("Held a gate twenty years, till the pension pushed me out the door of it. Now I go where there's things want killing and coin for the killing. Got in %s."):format(a.arrived)
	end
	return ("I don't hold with staying put. Rode in from %s %s. On to %s next, weather willing."):format(a.origin, a.arrived, a.heading)
end

-- Why they are out here. Per-kind; the wayfarer keeps their rolled reason.
local WHY = {
	barbarian = "A warrior with no war is just a large man in a foul mood. I'm looking for the war.",
	pirate    = "Honest work? No. Profitable work -- there's a difference, and I'm on the right side of it. Mostly.",
	sailor    = "The sea, if I'm honest with you. A month ashore and my legs forget how to hold still.",
	veteran   = "There's things in the dark that want killing, and fewer folk every year with the stomach for it. I've still got the stomach.",
}

function adventurer.why(self)
	local a = adventurer.of(self)
	if not a then return "Just passing through." end
	return WHY[a.subtype] or a.reason
end

-- A tall tale of somewhere far off. Told from a per-teller shuffled deck, so a
-- traveller runs through their whole repertoire before repeating -- and a pirate
-- or a sailor, who have the sea in them, tell them with the most relish.
function adventurer.tale(self)
	local a = adventurer.of(self)
	local s = util.scratch(self)
	if not s.tale_order then
		local order = {}
		for i = 1, #TALES do order[i] = i end
		local rng = util.rng("adv_tale", (a and a.seed) or "adv")
		for i = #order, 2, -1 do
			local j = rng:next(1, i)
			order[i], order[j] = order[j], order[i]
		end
		s.tale_order = order
		s.tale_i = 0
	end
	s.tale_i = s.tale_i + 1
	local tale = TALES[s.tale_order[((s.tale_i - 1) % #s.tale_order) + 1]]

	local st = a and a.subtype
	if st == "pirate" or st == "sailor" then
		return tale
	end
	-- Landlubbers tell it more warily -- it is somebody else's story to them.
	return "Way I heard it -- " .. tale
end

-- Pirates and their crew. They know one another the way a family does: by name,
-- and with the same easy threat behind it.
function adventurer.crew_talk(self)
	local a = adventurer.of(self)
	if not a or a.subtype ~= "pirate" then
		return "I sail with no one. Just me and the road, and the road's poor company."
	end

	-- Traveller pirates carry the real names of the shipmates spawned alongside
	-- them; a guest pirate's crew is off with the ship.
	local mates = {}
	if self._adv_crewnames then
		for _, nm in ipairs(self._adv_crewnames) do
			if nm ~= self.game_name then mates[#mates + 1] = nm end
		end
	end

	if #mates == 0 then
		return ("%s, under %s. The rest of the crew's with the ship. Cross one of us and you'll find out how fast word travels."):format(a.crew, a.captain)
	end

	local who
	if #mates == 1 then
		who = mates[1]
	elseif #mates == 2 then
		who = mates[1] .. " and " .. mates[2]
	else
		who = table.concat(mates, ", ", 1, #mates - 1) .. ", and " .. mates[#mates]
	end
	return ("%s, %s's flag. %s came ashore with me -- known 'em years, closer than kin. Cross one of us, you've crossed the lot."):format(a.crew, a.captain, who)
end

--------------------------------------------------------------------------------
-- Crews, and their dead
--------------------------------------------------------------------------------

-- A pirate crew is spawned as a set that knows one another by name; if one falls,
-- the others have no way of learning it -- they scattered across the valley the
-- moment they landed. So the crew is recorded here, keyed by its flag, and a
-- death is written to it. A shipmate cannot read the register, but a player who
-- watched it happen can carry the news, which is the one thing only a player can
-- do. In-memory only: a crew is a night's event, gone by morning like the rest.
adventurer.crews = {}

-- Note a crew when it comes ashore, so a later death has somewhere to be recorded.
local function register_crew(crew, captain, names)
	if not crew then return end
	local c = adventurer.crews[crew]
	if not c then
		c = {captain = captain, members = {}, lost = {}}
		adventurer.crews[crew] = c
	end
	for _, nm in ipairs(names or {}) do c.members[nm] = true end
end

-- Record that a crew hand has died. Called from the villager on_die hook. Once
-- only per name, so a body punched twice is one loss.
function adventurer.note_death(self)
	if not self or not self._adventurer then return end
	local crew = self._adv_crew
	local name = self.game_name
	if not crew or not name then return end
	local c = adventurer.crews[crew]
	if not c then c = {members = {}, lost = {}} ; adventurer.crews[crew] = c end
	for _, e in ipairs(c.lost) do
		if e.name == name then return end
	end
	c.lost[#c.lost + 1] = {name = name, day = today()}
	c.members[name] = nil
	village_life.log("info", ("%s of %s is dead"):format(name, crew))
end

-- Crewmates of this pirate who have died and whom they have not yet been told
-- about. Only names on their own manifest count, so a stale flag reused by a
-- later crew cannot put a stranger's death in their mouth.
function adventurer.crew_losses_untold(self)
	local out = {}
	if adventurer.subtype(self) ~= "pirate" then return out end
	local c = self._adv_crew and adventurer.crews[self._adv_crew]
	if not c then return out end
	local known = {}
	for _, nm in ipairs(self._adv_crewnames or {}) do known[nm] = true end
	local mourned = util.scratch(self).crew_mourned or {}
	for _, e in ipairs(c.lost) do
		if e.name ~= self.game_name and known[e.name] and not mourned[e.name] then
			out[#out + 1] = e.name
		end
	end
	return out
end

-- The player breaks the news that a crewmate is dead. Names the one they have not
-- heard of yet, marks it heard, and lets the pirate answer it -- grief with a
-- knife in it, and harder as the crew thins.
function adventurer.tell_crew_loss(self)
	local untold = adventurer.crew_losses_untold(self)
	if #untold == 0 then
		return "My crew's my own business, landlubber."
	end
	local name = untold[1]
	local s = util.scratch(self)
	s.crew_mourned = s.crew_mourned or {}
	s.crew_mourned[name] = true

	local a = adventurer.of(self)
	local captain = (a and a.captain) or "the captain"
	local remaining = #untold - 1

	if remaining > 0 then
		return ("%s too? ...That's more of us gone than left. %s'll want blood for this, and so do I. You'd best hope you weren't the cause of it."):format(name, captain)
	end
	return ("%s. Dead. ...We came ashore together, you know. I'll drink to %s tonight, and cut whatever did it another night. Tell %s, if you see the ship before I do."):format(name, name, captain)
end

-- Barbarians and the champions. The great tusked buffpigs that guard these
-- villages are, to a barbarian, the finest warriors they have ever laid eyes on,
-- and the admiration runs hotter with one in sight.
function adventurer.champion_admire(self, from)
	local near = false
	from = from or (self.object and self.object:get_pos())
	if from then
		for _, obj in ipairs(minetest.get_objects_inside_radius(from, 26)) do
			local e = obj:get_luaentity()
			if e and e.name == "zombies:buffpig" then near = true ; break end
		end
	end
	if near then
		return "THAT. That great tusked brute you keep -- your champion. Look at the shoulders on it! I'd give three of my clan for the honour of wrestling one and living to boast of it."
	end
	return "You breed champions in these parts -- the big bristled ones that hold the roads. Magnificent beasts. Where I'm from we'd make a song of a creature like that, and sing it drunk."
end

-- Retired guards hunt. Ask, and they boast of it -- and point you at the nearest
-- place that would test the boast.
function adventurer.hunt(self, from)
	local brag = "Twenty years I stood a wall, and the things that came at it don't bear describing to a civilian. I've a taste for it now, gods help me."
	local tip = adventurer.tip(self, from)
	return brag .. " " .. tip
end

-- A lead-in for a directions tip, drawn from the teller's seed.
local LEADS = {
	"If it's somewhere to poke about you're after -- ",
	"You've the look of someone who digs where they shouldn't. ",
	"Since you ask, and keep it to yourself: ",
	"Word on the road is ",
}

-- What they know about the land nearby: a true bearing to a real dungeon if one
-- is within range, otherwise a rumour. `from` defaults to where they stand.
function adventurer.tip(self, from)
	from = from or (self.object and self.object:get_pos())
	if not from then return "Ask me somewhere I can see the sky." end

	local a = adventurer.of(self)
	local seed = (a and a.seed) or "adv"
	local rng = util.rng("adv_lead", seed)
	local lead = LEADS[rng:next(1, #LEADS)]

	local near = village_life.poi and village_life.poi.nearest(from)
	if near then
		return lead .. "there's " .. village_life.poi.describe(from, near)
				.. ". Mind what's living in it."
	end
	if village_life.poi then
		return lead .. "there's " .. village_life.poi.rumor(seed, from) .. "."
	end
	return "Nothing worth the walk that I've heard of. Not near here."
end

-- Muttered aloud into proximity chat now and then, so a traveller you stand
-- with -- above all one you have hired to walk at your shoulder -- is not silent
-- between right-clicks, the way a village square full of villagers is not. This
-- is their own voice: a tall tale, or a short word on the road for their kind.
-- It is *not* the village gossip network -- a wanderer belongs to no village,
-- carries none of its news, and has no part in passing it round. Proxchat only,
-- a no-op without it, and only when a player is close enough to actually hear.
local AMBIENT_RANGE = 18

local MUTTER = {
	wayfarer  = {"Long road behind me. Longer ahead, I shouldn't wonder.",
	             "Good country, this. Wouldn't mind resting the feet a while."},
	barbarian = {"Quiet. Too quiet. My axe is getting bored, and so am I.",
	             "Where I'm from, a day this still means something's about to go wrong."},
	pirate    = {"Land. I'll never get the trick of it -- won't stay still.",
	             "There's coin in this valley somewhere. I can nearly smell it."},
	sailor    = {"Ground that doesn't pitch under you. Strange feeling, still.",
	             "I miss the salt. A month ashore and my legs forget the sea."},
	veteran   = {"Eyes on the treeline. Old habit. Kept me breathing this long.",
	             "Twenty years I stood a wall. Hard to stop watching for what's coming."},
}

function adventurer.ambient(self)
	if not (minetest.global_exists("proxchat") and proxchat.speak) then return end
	if not adventurer.is(self) then return end

	local pos = self.object and self.object:get_pos()
	if not pos then return end

	-- Only speak if someone is near enough to hear it.
	local near = false
	for _, player in ipairs(minetest.get_connected_players()) do
		local pp = player:get_pos()
		if pp and util.dist(pp, pos) <= AMBIENT_RANGE then near = true ; break end
	end
	if not near then return end

	-- Most ticks, say nothing. A traveller at your shoulder muttering every
	-- half-minute is worse company than a quiet one, and a whole pirate crew
	-- doing it is a wall of text -- so this only fires now and then, and when it
	-- does it is usually a short word for their kind. A carried piece of news
	-- (something real from the last village) is worth jumping the queue for; a
	-- full tall tale is a rarer treat.
	if math.random(100) > 33 then return end

	local said
	local carried = village_life.gossip and village_life.gossip.carry_line(self)
	if carried and math.random(100) <= 60 then
		said = carried
	elseif math.random(100) <= 30 then
		said = adventurer.tale(self)
	else
		local st = adventurer.subtype(self) or "wayfarer"
		local pool = MUTTER[st] or MUTTER.wayfarer
		said = pool[math.random(#pool)]
	end

	if said then
		proxchat.speak(pos, self.game_name or "A traveller", said)
	end
end

--------------------------------------------------------------------------------
-- Travellers: spawning, and letting them move on
--------------------------------------------------------------------------------

-- Live travellers, weak-keyed so a removed entity's entry vanishes with it.
adventurer.live = setmetatable({}, {__mode = "k"})

-- Ceilings, kept low: adventurers are an event, not a crowd. A handful in the
-- whole world at once (a pirate crew can be most of that), and they thin out to
-- nothing by day.
local MAX_LIVE   = 6
local SPAWN_MIN  = 24     -- how close in a traveller appears...
local SPAWN_MAX  = 46     -- ...and how far -- offscreen-ish, never in your lap
local DESPAWN    = 120    -- gone once this far from every player
local LEAVE_CLEAR = 40    -- only slips away when no player is this close

local function is_night()
	local h = util.hour()
	return h < 5.5 or h > 20.5
end

-- A standable, dry, open spot on the surface near (cx, cz) around y_hint. Best
-- effort: returns nil rather than forcing a bad spawn, and the caller simply
-- tries again next tick.
local function surface_spot(cx, cz, y_hint)
	for _ = 1, 10 do
		local x = cx + math.random(-SPAWN_MAX, SPAWN_MAX)
		local z = cz + math.random(-SPAWN_MAX, SPAWN_MAX)
		local dx, dz = x - cx, z - cz
		if dx * dx + dz * dz >= SPAWN_MIN * SPAWN_MIN then
			for y = y_hint + 14, y_hint - 20, -1 do
				local p = {x = x, y = y, z = z}
				if util.is_loaded(p) then
					local n = minetest.get_node(p)
					local def = minetest.registered_nodes[n.name]
					if def and def.walkable
							and minetest.get_item_group(n.name, "liquid") == 0 then
						local foot = {x = x, y = y + 1, z = z}
						if util.is_clear(foot)
								and util.is_clear({x = x, y = y + 2, z = z}) then
							return foot
						end
						break  -- hit ground; if blocked, try a fresh column
					end
				end
			end
		end
	end
end

-- Put one traveller on the map at `pos`. `opts` may carry subtype, name, gender,
-- and (for a crew) crew/captain/crewnames. Returns the ObjectRef or nil.
function adventurer.spawn_traveller(pos, opts)
	if not lottmobs or not lottmobs.spawn_pigman_trader then return end
	opts = opts or {}
	local subtype = opts.subtype or "wayfarer"
	local name = opts.name or TRAVELLER_NAMES[math.random(#TRAVELLER_NAMES)]
	local gender = opts.gender or ((math.random(2) == 1) and "m" or "f")

	local obj = lottmobs.spawn_pigman_trader(pos, "adventurer", name, gender)
	if not obj then return end
	local ent = obj:get_luaentity()
	if not ent then return end

	ent._adventurer = true
	ent._adv_subtype = subtype
	ent._adv_seed = "adv_" .. math.random(1, 1000000000) .. "_" .. tostring(today())
	ent.id = ent._adv_seed
	ent.game_name = name
	ent.profession = "adventurer"
	if opts.crew then ent._adv_crew = opts.crew end
	if opts.captain then ent._adv_captain = opts.captain end
	if opts.crewnames then ent._adv_crewnames = opts.crewnames end
	-- Leaves when its time is up: a night's stay, in real seconds, jittered.
	ent._adv_expire = util.now() + math.random(20 * 60, 45 * 60)

	-- Force the kind's skin, base_texture and all, so a reload does not reselect
	-- a random one (the historical skin-flip). The pick is seeded on this
	-- traveller, so a pirate keeps its coat and a crew is not all in the same one.
	local skin = pick_skin(subtype, gender, ent._adv_seed)
	ent.base_texture = {skin}
	obj:set_properties({textures = {skin}})

	adventurer.live[ent] = true
	village_life.log("info", ("%s (%s) arrived at %s"):format(name, subtype,
			minetest.pos_to_string(vector.round(pos))))
	return obj
end

-- A pirate crew: two to four hands off one flag, spawned together and knowing
-- one another by name. `room` bounds it to what the live ceiling can hold.
function adventurer.spawn_crew(centre, room)
	local size = math.min(room, math.random(2, 4))
	if size < 2 then return end

	local crew = CREW_NAMES[math.random(#CREW_NAMES)]
	local captain = CAPTAINS[math.random(#CAPTAINS)]

	-- Distinct names for the hands, so they can name each other.
	local names, used = {}, {}
	while #names < size do
		local nm = PIRATE_NAMES[math.random(#PIRATE_NAMES)]
		if not used[nm] then used[nm] = true ; names[#names + 1] = nm end
	end

	-- Record the crew so a hand's death has somewhere to be written, for a player
	-- to carry the news of.
	register_crew(crew, captain, names)

	local spawned = 0
	for i = 1, size do
		local spot = util.find_standing_near(centre, 4) or centre
		if adventurer.spawn_traveller(spot, {
			subtype = "pirate", name = names[i],
			crew = crew, captain = captain, crewnames = names,
		}) then
			spawned = spawned + 1
		end
	end
	if spawned > 0 then
		village_life.log("action", ("%s came ashore (%d hands)"):format(crew, spawned))
	end
end

-- Nearest player to a position, and the distance, or nil if nobody is on.
local function nearest_player(pos)
	local best, best_d
	for _, player in ipairs(minetest.get_connected_players()) do
		local pp = player:get_pos()
		if pp then
			local d = util.dist(pp, pos)
			if not best_d or d < best_d then best_d, best = d, player end
		end
	end
	return best, best_d
end

-- Thin the live set: drop invalid entities, spare any that have taken service
-- (a hired pirate follows you and must not be reaped), remove ones that have
-- wandered far from everybody, and let expired ones slip away unobserved. Counts
-- what is left.
local function reap()
	local companion = village_life.companion
	local n = 0
	for ent in pairs(adventurer.live) do
		local obj = ent.object
		local pos = obj and obj:get_pos()
		if not pos then
			adventurer.live[ent] = nil
		elseif companion and companion.hired_by(ent) then
			n = n + 1                                   -- yours now; keep it
		else
			local _, d = nearest_player(pos)
			if not d or d > DESPAWN then
				obj:remove()
				adventurer.live[ent] = nil
			elseif ent._adv_expire and util.now() > ent._adv_expire
					and d > LEAVE_CLEAR then
				obj:remove()                            -- its night is over
				adventurer.live[ent] = nil
			else
				n = n + 1
			end
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- The manager tick
--------------------------------------------------------------------------------

local ENABLED = true    -- flipped by init.lua from the setting

local timer = 0
minetest.register_globalstep(function(dtime)
	if not ENABLED then return end
	timer = timer + dtime
	if timer < 8 then return end
	timer = 0

	local live = reap()
	local room = MAX_LIVE - live
	if room <= 0 then return end
	if not is_night() then return end   -- they arrive after dark

	local players = minetest.get_connected_players()
	if #players == 0 then return end
	local player = players[math.random(#players)]
	local ppos = player:get_pos()
	if not ppos then return end

	-- Is the player at or near a village? If so this is a town arrival, and a
	-- little likelier; out in the wild it is a chance roadside meeting. At one
	-- roll every 8s of night these still add up to the odd visitor, not a
	-- caravan.
	local _, village_id = home.village_at(ppos, 64, 24)
	local chance = village_id and 0.08 or 0.03
	if math.random() > chance then return end

	local spot = surface_spot(math.floor(ppos.x), math.floor(ppos.z),
			math.floor(ppos.y))
	if not spot then return end

	-- Now and then the arrival is a whole pirate crew rather than one traveller.
	if room >= 2 and math.random() < 0.30 then
		adventurer.spawn_crew(spot, room)
	else
		adventurer.spawn_traveller(spot, {subtype = weighted(SOLO, util.rng(
				"adv_solo", os.time(), math.random(1, 1e6)))})
	end
end)

-- init.lua calls this to honour the master setting.
function adventurer.set_enabled(on)
	ENABLED = on and true or false
end

return adventurer
