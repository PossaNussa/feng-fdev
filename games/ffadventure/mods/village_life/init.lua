-- Village Life
--
-- mg_villages knows an enormous amount about its villages that nothing ever
-- reads back: which mob sleeps in which bed, which plot that mob works at,
-- which workplace marker inside it, and a precomputed path from the front door
-- to both. The villagers themselves were mobs redo NPCs with no brain beyond
-- the default random walk, so they drifted out of the village and died, and
-- every workstation stood empty.
--
-- This mod is the missing consumer of that data. It binds each villager to its
-- plot, gives it a day, and lets the village defend itself. It also replaces
-- the trader's shop stock, which was identical for every villager sharing a
-- profession.
--
-- Nothing here edits mg_villages, lottmobs or creaturemob: villager spawning
-- goes through mg_villages' documented `spawn_one_mob` hook, and behaviour is
-- attached by writing `do_custom`/`on_rightclick` onto the already-registered
-- entity prototypes (core.register_entity uses the prototype as the instances'
-- metatable, so late writes reach mobs that are already walking around).

village_life = {}

local modpath = minetest.get_modpath("village_life")

local function setting_bool(name, default)
	local v = minetest.settings:get_bool("village_life_" .. name)
	if v == nil then return default end
	return v
end

local function setting_number(name, default)
	return tonumber(minetest.settings:get("village_life_" .. name)) or default
end

village_life.settings = {
	-- master switches, so a server can keep the economy and drop the AI or
	-- the other way round
	schedule    = setting_bool("schedule", true),
	defence     = setting_bool("defence", true),
	census      = setting_bool("census", true),
	economy     = setting_bool("economy", true),

	-- how far from a player village simulation stays awake. Mobs only step
	-- inside the active block range anyway; this just stops the census and
	-- threat scans from ranging further than the mobs can act.
	active_range = setting_number("active_range", 64),

	-- Pathfinding is budgeted by creaturemob, in microseconds per step across
	-- every mob in the world: see creaturemob_path_budget_us.

	-- seconds a villager waits after dying before the census replaces it
	respawn_delay = setting_number("respawn_delay", 240),

	-- shop stock is rerolled every this many in-game days
	restock_days = setting_number("restock_days", 1),

	-- villagers refuse to trade while asleep or fleeing
	shop_hours = setting_bool("shop_hours", true),

	-- villagers lie down in their own beds at night, and injuries heal over
	-- time -- faster asleep than on their feet
	rest = setting_bool("rest", true),

	-- villages remember how each player has treated them
	reputation = setting_bool("reputation", true),

	-- villagers witness events, talk to each other about them, and carry word
	-- of the worst of it out of the valley
	gossip = setting_bool("gossip", true),

	-- taking from a container while a villager is watching is an offence.
	-- Corpses are always exempt: burying the dead means digging the node.
	crime = setting_bool("crime", true),

	-- a killed villager stays dead. The bed is filled by an heir coming of age
	-- or, much later, by an incomer -- not by an identical copy four minutes
	-- later. With this off the census behaves as it always did.
	permadeath = setting_bool("permadeath", true),

	-- villagers leave a body holding what they were carrying. Always public:
	-- looting and digging it is never a crime.
	remains = setting_bool("remains", true),

	-- right-click opens a conversation rather than the shop counter
	dialogue = setting_bool("dialogue", true),

	-- floating nameplates above villagers' heads. Off by default: a name is
	-- something you learn by asking, not read off a tag over a stranger.
	nametags = setting_bool("nametags", false),

	-- an ordinary villager struck by a monster rouses and fights back for a
	-- while instead of only fleeing. Children, the old and the timid still run.
	selfdefence = setting_bool("selfdefence", true),

	-- children are smaller than adults and grow towards adult size over in-game
	-- time (mg_villages only ever set their age once, at generation).
	aging = setting_bool("aging", true),

	-- villagers can be talked into coming with you: persuasion, wages, and
	-- walking home again when it stops being worth it
	hiring = setting_bool("hiring", true),

	-- players can found their own town from a written "Town Deed": punch the
	-- ground to plant it, punch beds to say who lives in them, and talk NPCs
	-- into moving in (on foot, or making their own way there)
	settlement = setting_bool("settlement", true),

	-- innkeepers rent rooms for the night, and sleeping in an inn's bed you
	-- haven't paid for is an offence if a villager sees you do it
	lodging = setting_bool("lodging", true),

	-- adventurers pass through: inn guests become travellers who know the
	-- country (dungeons dungeonsplus really built, or a rumour), and bedless
	-- travellers turn up near a village after dark and are gone by day
	adventurers = setting_bool("adventurers", true),

	-- redeeming monsters: yell a sentient beastman (lionman, gnoll, frog-folk)
	-- down, talk it out of being a monster, and recruit it like any wanderer;
	-- trolls are recruitable directly. Gates only the yell trigger and calm menu.
	redeem = setting_bool("redeem", true),

	debug = setting_bool("debug", false),
}

village_life.log = function(level, msg)
	if level == "info" and not village_life.settings.debug then return end
	minetest.log(level == "info" and "action" or level, "[village_life] " .. msg)
end

dofile(modpath .. "/lua/util.lua")
dofile(modpath .. "/lua/threats.lua")
dofile(modpath .. "/lua/home.lua")
-- wanderer marks the four peaceful lottmobs traders as bedless recruits and
-- defines is_bedless_recruit / is_villager_entity, both read by the shared
-- brain / hire / companion / dialogue paths below. Only home is needed first.
dofile(modpath .. "/lua/wanderer.lua")
dofile(modpath .. "/lua/kin.lua")
dofile(modpath .. "/lua/navigate.lua")
dofile(modpath .. "/lua/schedule.lua")
-- rest takes a local alias of nav, so it loads after navigate.lua.
dofile(modpath .. "/lua/rest.lua")
dofile(modpath .. "/lua/economy.lua")
dofile(modpath .. "/lua/market.lua")
dofile(modpath .. "/lua/reputation.lua")
dofile(modpath .. "/lua/trade_ui.lua")
dofile(modpath .. "/lua/persona.lua")
-- memory reads persona for a villager's mood baseline, and dialogue reads
-- memory to colour a village's standing with what this particular person
-- thinks of you, so it sits between them.
dofile(modpath .. "/lua/memory.lua")
-- events raises, gossip carries. events checks for gossip at call time rather
-- than load time, so the pair can be loaded in either order; this one reads
-- better.
dofile(modpath .. "/lua/gossip.lua")
dofile(modpath .. "/lua/events.lua")
dofile(modpath .. "/lua/backstory.lua")
dofile(modpath .. "/lua/crime.lua")
-- lodging watches the beds mod's on_rightclick for trespass and reads economy
-- for the price of a room; both are loaded above. dialogue offers the room, so
-- this comes before it.
dofile(modpath .. "/lua/lodging.lua")
-- poi records the dungeons dungeonsplus builds; adventurer reads it to point a
-- player at a real one. Both load before dialogue, which offers the road
-- questions, and before defence/census, which do not depend on them.
dofile(modpath .. "/lua/poi.lua")
dofile(modpath .. "/lua/adventurer.lua")
dofile(modpath .. "/lua/faith.lua")
dofile(modpath .. "/lua/traits.lua")
dofile(modpath .. "/lua/remains.lua")
dofile(modpath .. "/lua/succession.lua")
-- regard reads kin, persona, traits, memory and succession, so it comes after
-- all five. It stores nothing of its own.
dofile(modpath .. "/lua/regard.lua")
-- land surveys the map around a village. Nothing depends on it at load time;
-- it reads gossip and memory when asked.
dofile(modpath .. "/lua/land.lua")
-- banter reads land for a wind bearing and regard for somebody to make a joke
-- about, so it follows both.
dofile(modpath .. "/lua/banter.lua")
-- companion owns the hired state and the bed's `away` mark; hire is the
-- persuasion in front of it and asks companion whether somebody is already
-- spoken for, so companion loads first.
dofile(modpath .. "/lua/companion.lua")
dofile(modpath .. "/lua/hire.lua")
-- settlement lets a player found their own town as a synthetic mg_villages
-- village and pull NPCs into it. It reuses home/companion/hire, so it loads
-- after them; dialogue offers the "come and live in my town" menu, so it loads
-- before dialogue.
dofile(modpath .. "/lua/settlement.lua")
dofile(modpath .. "/lua/plotclaim.lua")
-- dialogue takes over on_rightclick from trade_ui, so it must register its
-- on_mods_loaded handler after trade_ui's.
dofile(modpath .. "/lua/dialogue.lua")
dofile(modpath .. "/lua/brain.lua")
-- redeem gates the beastmen/trolls between their native AI and the villager
-- brain, so it loads after brain (uses brain.step / villager_punch / villager_die)
-- and after dialogue/wanderer/companion, all of which it dispatches to.
dofile(modpath .. "/lua/redeem.lua")
dofile(modpath .. "/lua/defence.lua")
-- champion reads threats and reputation; a blunt conversation for the buff
-- pigmen that guard a village, which have no bed and so no villager dialogue.
dofile(modpath .. "/lua/champion.lua")
dofile(modpath .. "/lua/census.lua")
dofile(modpath .. "/lua/commands.lua")

-- The travelling-adventurer spawner honours its own switch; the guest reflavour
-- and the poi rumours in dialogue are always on -- they cost nothing when no
-- adventurer is about.
village_life.adventurer.set_enabled(village_life.settings.adventurers)

minetest.log("action", "[village_life] loaded")
