-- Wandering traders (dwarf / mung / human / elf) as recruitable townsfolk.
--
-- The world already spawns four peaceful lottmobs traders on the same
-- creaturemob framework as the pigman villager, but until now village_life
-- ignored them: you could only trade. This module is the small amount of glue
-- that lets a player talk to one, convince it to join a town, and (once it has
-- settled) equip it -- by reusing the bedless-recruit machinery the adventurer
-- system already built, without giving a dwarf a pirate's tales.
--
-- A wandering trader is "bedless but not an adventurer": home.resolve returns
-- nil for it, exactly like a passing traveller, so the same brain / hire /
-- companion code paths carry it. Adventurer flavour (crews, subtypes, world
-- lore) stays gated on the narrow self._adventurer flag; is_bedless_recruit is
-- the union of the two, and is what those shared paths test instead.

local home = village_life.home

local wanderer = {}
village_life.wanderer = wanderer

-- The four peaceful traders. `race` is a flavour label; `title` is the
-- profession the village systems read once one has settled into a town. The
-- native lottmobs trade window is captured at attach time (see dialogue.lua)
-- into `.native_trade`, so the "show me your wares" menu option can reopen the
-- shop the plain right-click used to.
wanderer.SPECIES = {
	-- ---------------------------------------------------------------------------
	-- EVERY lottmobs humanoid NPC. This is the whole list lottmobs registers --
	-- all dwarves, all elves, all humans, all mung, and the pigman -- each one
	-- talkable and recruitable through village_life. `_trader` mobs are shops on
	-- legs; the rest (elf/elf1/elf2, dwarf/dwarf1/dwarf2, nune_guard, mung_guard)
	-- are lottmobs guards/warriors, flagged `guard = true`. `race` is the
	-- canonical label the role/name pools key on: lottmobs' own tags are
	-- GAMEman/GAMEelf/GAMEdwarf/mung/pigman, mapped to human/elf/dwarf/mung here.
	-- (The pigman villager is attached directly by dialogue.lua/brain.lua as the
	-- base villager and needs no entry here.)
	-- ---------------------------------------------------------------------------

	-- DWARVES (lottmobs: GAMEdwarf)
	["lottmobs:dwarf_trader"] = {race = "dwarf", title = "trader", gender = "m"},
	["lottmobs:dwarf"]        = {race = "dwarf", title = "guard",  gender = "m", guard = true},
	["lottmobs:dwarf1"]       = {race = "dwarf", title = "guard",  gender = "m", guard = true},
	["lottmobs:dwarf2"]       = {race = "dwarf", title = "guard",  gender = "m", guard = true},

	-- ELVES (lottmobs: GAMEelf)
	["lottmobs:elf_trader"]   = {race = "elf",   title = "trader", gender = "m"},
	["lottmobs:elf"]          = {race = "elf",   title = "guard",  gender = "m", guard = true},
	["lottmobs:elf1"]         = {race = "elf",   title = "guard",  gender = "m", guard = true},
	["lottmobs:elf2"]         = {race = "elf",   title = "guard",  gender = "m", guard = true},

	-- HUMANS (lottmobs: GAMEman)
	["lottmobs:human_trader"] = {race = "human", title = "trader", gender = "m"},
	["lottmobs:nune_guard"]   = {race = "human", title = "guard",  gender = "m", guard = true},

	-- MUNG (lottmobs: mung). A mung *trader* keeps to hunter or trader
	-- (roles = "mung_trader"); a mung *guard* rolls the warlike mung spread.
	["lottmobs:mung_trader"]  = {race = "mung",  title = "trader", gender = "m", roles = "mung_trader"},
	["lottmobs:mung_guard"]   = {race = "mung",  title = "guard",  gender = "m", guard = true},

	-- Beastmen (redeem.lua). Hostile monsters until calmed: `calm_required` makes
	-- wanderer.is also require self._calmed, so a raging one is not yet a recruit
	-- and none of the recruit menus offer it. Their `title` is a placeholder --
	-- redeem.calm assigns the real town role (Hunter/Barbarian/Monster).
	-- `redeem = true` marks the creatures whose prototype wiring redeem.lua owns
	-- (do_custom / click / punch / death), so brain and dialogue skip them in
	-- their own attach loops.
	["zombies:lionman"]        = {race = "lion",    title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:lion_warrior"]   = {race = "lion",    title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:cheetahman"]     = {race = "cheetah", title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:cheetahwarrior"] = {race = "cheetah", title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:cheetarcher"]    = {race = "cheetah", title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:frarcher"]       = {race = "frog",    title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:froghman"]       = {race = "frog",    title = "hunter", gender = "m", calm_required = true, redeem = true},
	["zombies:gnoll"]          = {race = "gnoll",   title = "hunter", gender = "m", calm_required = true, redeem = true},

	-- Trolls are already peaceful npcs (they guard against monsters); recruitable
	-- directly, like a trader, with no calming step -- but redeem still owns their
	-- wiring so their native do_custom_guard is chained, not clobbered.
	["lottmobs:troll"]         = {race = "troll",   title = "troll",  gender = "m", redeem = true},
	["lottmobs:battle_troll"]  = {race = "troll",   title = "troll",  gender = "m", redeem = true},

	-- The buff pigman -- a village's champion. Already peaceful to players, so it
	-- recruits directly. `redeem` here only tells brain/dialogue's attach loops to
	-- leave it be: defence.lua owns its do_custom, champion.lua its right-click.
	["zombies:buffpig"]        = {race = "champion", title = "champion", gender = "m", redeem = true},
}

function wanderer.species(self)
	return (self and self.name and wanderer.SPECIES[self.name]) or nil
end

--------------------------------------------------------------------------------
-- What a recruited wanderer turns out to be
--------------------------------------------------------------------------------

-- Until now every settled trader took the town role "trader" -- their species'
-- placeholder title -- so a mung talked into a town became a shopkeeper whether
-- or not it ever had a shop to keep. That is not what these folk are. A mung is
-- warlike: most are hunters, a good few plain barbarians, and only the odd one
-- trades. Dwarves, humans and elves fall into the ordinary spread of village
-- trades, the same roles a home-grown villager can hold, leaning the way their
-- kind leans.
--
-- The role is rolled ONCE, the first time it matters (see wanderer.ensure_role),
-- and kept on the entity as self.profession -- which both settle paths already
-- copy onto the bed row, so it rides a settle and every later respawn. Redeemed
-- beastmen, trolls and the champion pick their own role in redeem.lua and are
-- left alone here.
--
-- These are village *professions* (home.role maps them: hunter/barbarian ->
-- guard and fight; the trade titles -> worker, and work at a workstation if you
-- give them one). "guard" is included directly for a plain watchman.
local ROLE_POOLS = {
	-- Mung guards: fighters first. A "barbarian" is one of the many that never had
	-- a trade counter to begin with; "hunter" the disciplined rest. This is the
	-- pool a mung *guard* rolls (and it still allows the odd trader/watchman).
	mung = {
		{title = "hunter",    weight = 6},
		{title = "barbarian", weight = 4},
		{title = "guard",     weight = 2},
		{title = "trader",    weight = 1},
	},
	-- Mung *traders* specifically: hunter or trader, nothing else. The mung you
	-- meet standing behind wares is either a hunter who took up selling or a plain
	-- trader -- not a barbarian.
	mung_trader = {
		{title = "hunter", weight = 3},
		{title = "trader", weight = 2},
	},
	-- Dwarves: makers and delvers, and no strangers to an axe.
	dwarf = {
		{title = "blacksmith", weight = 4},
		{title = "stonemason", weight = 3},
		{title = "carpenter",  weight = 2},
		{title = "guard",      weight = 2},
		{title = "shopkeeper", weight = 1},
		{title = "trader",     weight = 1},
	},
	-- Humans: the broad middle of a village, a bit of everything.
	human = {
		{title = "farmer",     weight = 3},
		{title = "baker",      weight = 2},
		{title = "carpenter",  weight = 2},
		{title = "butcher",    weight = 1},
		{title = "innkeeper",  weight = 1},
		{title = "shopkeeper", weight = 2},
		{title = "guard",      weight = 2},
		{title = "hunter",     weight = 1},
		{title = "trader",     weight = 1},
	},
	-- Elves: growers, glassworkers and keepers of quiet trades.
	elf = {
		{title = "farmer",     weight = 3},
		{title = "glassmaker", weight = 2},
		{title = "shopkeeper", weight = 2},
		{title = "carpenter",  weight = 1},
		{title = "dyemaker",   weight = 1},
		{title = "guard",      weight = 1},
		{title = "trader",     weight = 1},
	},
}
wanderer.ROLE_POOLS = ROLE_POOLS

-- Weighted pick from a race's pool. Falls back to "trader" if a race has no
-- pool (it never should, but a settled resident with no role is worse than a
-- dull one).
function wanderer.assign_role(self)
	local sp = wanderer.species(self)
	-- A species may name its own role pool (mung_trader); otherwise it rolls its
	-- race's full spread -- which is exactly what a guard should do.
	local pool = sp and ROLE_POOLS[sp.roles or sp.race]
	if not pool then return "trader" end
	local total = 0
	for _, r in ipairs(pool) do total = total + r.weight end
	local pick = math.random() * total
	for _, r in ipairs(pool) do
		pick = pick - r.weight
		if pick <= 0 then return r.title end
	end
	return pool[1].title
end

-- The role a plain wandering trader will settle with. Rolled once and stamped
-- onto self.profession, so the mung you walk up to and talk into your town is
-- already a hunter, not a shopkeeper, and stays that whichever recruit path it
-- takes. Redeem species (beastmen/trolls/champion) own their own role -- skip
-- them -- and never overwrite a role already set (by an earlier call, or by
-- redeem.calm). Returns the resolved role.
function wanderer.ensure_role(self)
	if not self then return end
	local sp = wanderer.species(self)
	-- Only the four peaceful traders roll a random trade here; redeem creatures
	-- are handled in redeem.lua, and anything already assigned is left be.
	if not sp or sp.redeem or sp.calm_required then
		return self.profession
	end
	if self._role_assigned or (self.profession and self.profession ~= "trader"
			and self.profession ~= "") then
		self._role_assigned = true
		return self.profession
	end
	self.profession = wanderer.assign_role(self)
	self._role_assigned = true
	return self.profession
end

-- A wandering trader is one of the four species that has NOT yet settled into a
-- town. Once settled it is a villager (home.is_villager true) and runs the
-- ordinary village schedule, so this must stop being true or the schedule would
-- never take it.
function wanderer.is(self)
	if not self or not self.name then return false end
	local sp = wanderer.SPECIES[self.name]
	if not sp then return false end
	if home.is_villager(self) then return false end
	-- A beastman is only a recruit once it has been calmed (redeem.lua). Before
	-- that it is a monster: no recruit menus, and home.adopt still refuses it.
	if sp.calm_required and not self._calmed then return false end
	return true
end

-- The union every bedless code path tests: an adventurer OR an un-settled
-- wandering trader. Adventurer-only flavour stays on self._adventurer.
function village_life.is_bedless_recruit(self)
	if not self then return false end
	return self._adventurer == true or wanderer.is(self)
end

-- Every entity village_life treats as one of its people: the pigman villager,
-- the four settle-able traders, and every lottmobs guard/warrior. Used where code
-- used to hard-check the literal pigman name (census, earshot, threat class).
-- Same whole list as SPECIES above -- keep the two in step.
local VILLAGER_ENTITIES = {
	["lottmobs:pigman_trader"] = true,
	["lottmobs:dwarf_trader"]  = true,
	["lottmobs:mung_trader"]   = true,
	["lottmobs:human_trader"]  = true,
	["lottmobs:elf_trader"]    = true,
	-- guards / warriors
	["lottmobs:dwarf"]         = true,
	["lottmobs:dwarf1"]        = true,
	["lottmobs:dwarf2"]        = true,
	["lottmobs:elf"]           = true,
	["lottmobs:elf1"]          = true,
	["lottmobs:elf2"]          = true,
	["lottmobs:nune_guard"]    = true,
	["lottmobs:mung_guard"]    = true,
}

function village_life.is_villager_entity(name)
	return name ~= nil and VILLAGER_ENTITIES[name] == true
end

--------------------------------------------------------------------------------
-- Names
--------------------------------------------------------------------------------

-- Race-flavoured name pools. A wandering trader carries no name off lottmobs, so
-- one is assigned the first time it is spoken to and kept on the entity (like an
-- adventurer's, which is set at spawn). game_name is what the name topic and the
-- nameplate both read.
local NAMES = {
	dwarf = {"Borin", "Dwalin", "Thrain", "Gloin", "Nain", "Farin", "Balin", "Oin"},
	mung  = {"Halbarad", "Bergil", "Damrod", "Forlong", "Hirgon", "Duilin", "Beregond"},
	human = {"Wulfric", "Aldric", "Cedric", "Osric", "Godwin", "Leofric", "Edmund"},
	elf   = {"Faelon", "Aerith", "Thalion", "Nimloth", "Elured", "Galdor", "Voronwe"},
	-- Beastmen: guttural, growled names. Trolls take heavy stone-and-bone names.
	lion    = {"Rassh", "Karnu", "Mruff", "Senna", "Tavhar", "Golmane", "Urrsk"},
	cheetah = {"Chakka", "Ssira", "Pryn", "Vesh", "Nakti", "Tsuru", "Yannu"},
	frog    = {"Grulk", "Blorb", "Ribbik", "Squoll", "Uumo", "Gribbet", "Wask"},
	gnoll   = {"Hrek", "Gnasher", "Yip", "Skarr", "Rukka", "Brakh", "Vekk"},
	troll   = {"Grond", "Bhurz", "Kagûl", "Morzek", "Ushkar", "Drûl", "Thokk"},
	champion = {"Grumble", "Bristle", "Tusk", "Snout", "Gnash", "Wallow",
			"Bramble", "Hodge", "Mudfoot", "Bellow"},
}

-- A stable index into a pool from whatever identity the entity carries. self.id
-- is the lottmobs-assigned string when present; a fresh trader may have none, so
-- fall back to its rounded position, and finally to a fixed value -- never a
-- fresh math.random per call, which would rename it every line.
local function seed_of(self)
	local s = self.id and tostring(self.id)
	if not s and self.object and self.object.get_pos then
		local p = self.object:get_pos()
		if p then
			s = math.floor(p.x + 0.5) .. math.floor(p.y + 0.5) .. math.floor(p.z + 0.5)
		end
	end
	s = s or "wanderer"
	local n = 0
	for i = 1, #s do n = (n * 31 + s:byte(i)) % 2147483647 end
	return n
end

--------------------------------------------------------------------------------
-- Revenants: displaced folk who resurface as wanderers
--------------------------------------------------------------------------------

-- Someone who lost their place -- a trader whose shop changed hands, a resident
-- painted over -- is not simply deleted from the world. Their name is remembered
-- here, and the next wandering trader of the right kind that a player stops to
-- speak to turns out to be them: back on the road, and findable again.
--
-- Persisted, because a resurfacing owed is owed across a restart. A tiny list of
-- {name, race}; race optional (nil matches the first wanderer of any kind).
local storage = minetest.get_mod_storage()
local revenants

local function load_revenants()
	local raw = storage:get_string("revenants")
	revenants = (raw ~= "" and minetest.deserialize(raw)) or {}
end
local function save_revenants()
	storage:set_string("revenants", minetest.serialize(revenants))
end
load_revenants()

-- Remember a displaced person to resurface later. `race` (human/dwarf/elf/mung)
-- pins which kind of wandering trader they come back as; nil takes the next one.
function wanderer.remember_displaced(name, race)
	if not name or name == "" then return end
	revenants[#revenants + 1] = {name = name, race = race}
	save_revenants()
end

function wanderer.pending_revenants()
	return revenants
end

-- Owe someone a return by hand: /vl_revenant <name> [race]. The next wandering
-- trader of that race a player stops to speak to turns out to be them. Server
-- priv, because it writes a person back into the world.
if minetest.register_chatcommand then
	minetest.register_chatcommand("vl_revenant", {
		params = "<name> [human|dwarf|elf|mung]",
		description = "Set a displaced person to resurface as the next wandering trader.",
		privs = {server = true},
		func = function(_, param)
			local name, race = param:match("^(%S+)%s*(%S*)$")
			if not name or name == "" then
				return false, "Usage: /vl_revenant <name> [human|dwarf|elf|mung]"
			end
			if race == "" then race = nil end
			wanderer.remember_displaced(name, race)
			return true, ("%s is owed a return -- the next %swandering trader you "
					.. "speak to will be them."):format(name,
					race and (race .. " ") or "")
		end,
	})
end

-- Claim a remembered name for a wanderer of this race, if one is waiting. Race
-- match first (so a human name waits for a human), then any untagged entry.
local function take_revenant(race)
	for i, r in ipairs(revenants) do
		if r.race == race then
			table.remove(revenants, i) ; save_revenants() ; return r.name
		end
	end
	for i, r in ipairs(revenants) do
		if not r.race then
			table.remove(revenants, i) ; save_revenants() ; return r.name
		end
	end
end

function wanderer.name_for(self)
	if self.game_name and self.game_name ~= "" then return self.game_name end
	local sp = wanderer.species(self)
	-- A displaced person waiting to resurface takes precedence over a fresh name:
	-- this wanderer turns out to be them.
	local revenant = take_revenant(sp and sp.race)
	if revenant then
		self.game_name = revenant
		return revenant
	end
	local pool = (sp and NAMES[sp.race]) or NAMES.human
	local name = pool[(seed_of(self) % #pool) + 1]
	self.game_name = name
	return name
end

--------------------------------------------------------------------------------
-- Voice
--------------------------------------------------------------------------------

local GREETINGS = {
	dwarf = {"Aye? Coin or curiosity, which is it?",
			"Mind the pack -- it's worth more than you are. What'll it be?"},
	mung  = {"Well met on the road, friend.", "A fair day for trade, wouldn't you say?"},
	human = {"Good day to you. A long road makes a man talkative.",
			"Hail, traveller. You've the look of someone who buys."},
	elf   = {"Peace on your road. You wished to speak?",
			"You walk quietly for one of your kind. Speak, then."},
	-- Calmed beastmen: wary, curious, still learning to trust a talking meal.
	lion    = {"You. You did not run. Strange little thing.",
			"Speak, then. My claws are still, for now."},
	cheetah = {"Hnn. You are quick to talk, quicker than you'd run.",
			"You have my ear. Do not waste it."},
	frog    = {"Brrk. You made the loud noise. I remember. Speak.",
			"Hrrm. Not-food, then. What do you want, not-food?"},
	gnoll   = {"Heh. The soft one wants words. Go on, soft one.",
			"You calmed the pack-anger in me. I am listening. Barely."},
	troll   = {"Hrrm. You are small and you talk. Talk, then.",
			"Troll listens. Make it quick, little one."},
	champion = {"Hrm. You want something.", "You're not food. Good. Speak.",
			"Grr. Speak, little one.", "...What."},
}

local INTRODUCE = {
	dwarf = "A trader, and a dwarf, and I'll not apologise for either. I carry what's worth carrying.",
	mung  = "I keep to the roads and sell what the towns can't make themselves. A trader, plainly.",
	human = "A travelling trader -- wares on my back and no roof to call my own. It suits me well enough.",
	elf   = "I trade, and I wander. The two are one road for my people.",
	lion    = "I was a hunter of the wilds, before your words. A hunter I remain, if you'll have me.",
	cheetah = "I run down what the pack needs. That is what I am. A hunter, now, of your monsters instead of you.",
	frog    = "I fought because the marsh told me to. It is quiet now. I could hunt for you, not-food.",
	gnoll   = "I ran with a pack. The pack is gone. Maybe your town is a pack too. I hunt well.",
	troll   = "Troll smashes what troubles the small ones. That is troll's work. Give troll a place and troll works.",
	champion = "I am the wall between the small ones and the dark. I hit what needs hitting. That is all I am.",
}

-- The pitch a wandering trader answers with when you propose they settle -- their
-- own reason a fixed roof might tempt them, coloured by race.
local WHY_SETTLE = {
	dwarf = "A hall of my own, and a forge nearby? You may yet talk me into it.",
	mung  = "The road wears thin after enough years. A town with a spare bed... go on.",
	human = "A bed that's mine and a square to sell in beats another night in the rain.",
	elf   = "I have wandered long. Somewhere quiet, among folk who'll have me -- perhaps.",
	lion    = "A den of my own, among your soft folk? ...I would guard it well. Say more.",
	cheetah = "A place to belong. The wild is cold and empty. Your town is warm. Go on.",
	frog    = "A warm hearth, not a cold marsh? Brrk. I could be swayed, not-food.",
	gnoll   = "A pack that does not turn on me. That is all I ever wanted. Speak on.",
	troll   = "Troll is tired of caves. A roof, and small ones who do not throw stones? Yes. Maybe.",
	champion = "A wall of my own to guard. Small ones to stand between and the dark. ...Yes. I could do that.",
}

-- A guard answers in a watchman's voice, not a trader's -- same four races, a
-- harder edge. Keyed by race and used in place of the trader tables when the
-- species carries `guard = true`.
local GUARD_GREETINGS = {
	human = {"Halt -- state your business. ...Ah, a friendly face.",
		"The road's watched, traveller. Talk, or move along."},
	mung  = {"You come armed to a mung's post. Speak quick.",
		"Hnf. A talker. What is it you want?"},
	elf   = {"You are seen from a long way off, traveller. Speak.",
		"Peace. I keep this ground. What brings you to it?"},
	dwarf = {"State your business, and mind the axe.",
		"Hrm. A visitor. Talk, then."},
}

local GUARD_INTRODUCE = {
	human = "A guardsman. I keep the roads and the walls, and I've swung a sword for less than a warm bed.",
	mung  = "I stand watch and I break heads. That's a mung's trade -- guard, warrior, call it what you like.",
	elf   = "I ward the borders of my people. A sentinel. I would ward yours, if you asked it well.",
	dwarf = "I guard hall and hoard both. Give me a wall to hold and I'll hold it till the mountain falls.",
}

local GUARD_WHY_SETTLE = {
	human = "A wall of my own to keep, and folk behind it worth keeping? Aye -- go on.",
	mung  = "A town that needs a hard hand at the gate? ...The road's cold anyway. Say more.",
	elf   = "A quiet ground to ward, among folk who'll have me. I have stood worse posts. Speak on.",
	dwarf = "A gate to hold and a forge at my back? Now you're talking a dwarf's language.",
}

local function pick(list, self)
	if not list or #list == 0 then return nil end
	return list[(seed_of(self) % #list) + 1]
end

function wanderer.greeting(self)
	local sp = wanderer.species(self)
	if not sp then return nil end
	local table = (sp.guard and GUARD_GREETINGS[sp.race]) or GREETINGS[sp.race]
	return pick(table, self)
end

function wanderer.introduce(self)
	local sp = wanderer.species(self)
	if sp and sp.guard then
		return GUARD_INTRODUCE[sp.race] or "A guard, plainly. I keep what's mine to keep."
	end
	return (sp and INTRODUCE[sp.race])
			or "A travelling trader, passing through."
end

function wanderer.why_settle(self)
	local sp = wanderer.species(self)
	if sp and sp.guard then
		return GUARD_WHY_SETTLE[sp.race]
				or "A post of my own to hold? You may talk me into it."
	end
	return (sp and WHY_SETTLE[sp.race])
			or "A roof of my own? You may talk me into it yet."
end

--------------------------------------------------------------------------------
-- Trade
--------------------------------------------------------------------------------

-- Reopen the native lottmobs shop that the plain right-click used to. The
-- original on_rightclick closure is captured at attach time into `.native_trade`.
function wanderer.trade(self, clicker)
	local sp = wanderer.species(self)
	if not sp or not sp.native_trade then return false end
	sp.native_trade(self, clicker)
	return true
end

return wanderer
