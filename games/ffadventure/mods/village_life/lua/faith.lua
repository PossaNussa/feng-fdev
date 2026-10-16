-- What the villagers believe.
--
-- `lumberjackzombie` already had a pantheon: twenty-two names, a count of how
-- often each had been spoken, and one consequence -- naming a god over a bottle
-- of water makes holy water. What it did not have was any sense of *who* those
-- gods were. A name with a counter behind it is a scoreboard, not a religion,
-- and a priest standing in a church could not say one word about either.
--
-- This gives every name a domain, and every village a patron. That is enough
-- for a priest to preach, for villagers to know whose day it is, for an
-- offering to mean something, and for calling on the wrong god in the wrong
-- village to be a mistake you can make.
--
-- ============================================================================
-- THE LORE BELOW IS A FIRST PASS AND IS MEANT TO BE REWRITTEN.
--
-- Every string in `faith.gods` -- domain, epithet, tenet, the lot -- is yours
-- to replace. The code depends only on the *shape* of these entries, never on
-- the words, so rewriting all of it costs nothing structurally. What the code
-- reads is: `rank`, `church_ok`, `favours`, `abhors`, `offering`, `climate`.
-- ============================================================================
--
-- Ranks, which is the only structural opinion this file holds:
--
--   local    worshipped in villages. Harvests, hearths, roads, the dead.
--   greater  known everywhere, worshipped by those with a reason to.
--   outer    named, not worshipped. A village knows the name and would rather
--            you did not say it in the square.
--
-- The split is not a judgement about which names are "real" -- all of them are
-- canon here. It is about who builds a church to whom.

local util = village_life.util

local faith = {}
village_life.faith = faith

--------------------------------------------------------------------------------
-- The pantheon
--------------------------------------------------------------------------------

-- Fields:
--   rank      "local" | "greater" | "outer"
--   domain    what they are god of, as a villager would say it
--   epithet   how a believer refers to them
--   tenet     the one thing their faith asks of people
--   church_ok may be a village's patron
--   climate   village types / conditions that favour this patron (optional)
--   favours   deeds that please them        (event kinds, or "burial", "offering")
--   abhors    deeds that offend them
--   offering  an itemstring their altar takes, if any
faith.gods = {
	--------------------------------------------------------------------------
	-- Local gods: the ones with churches
	--------------------------------------------------------------------------
	nu = {
		rank = "local", church_ok = true,
		domain = "the turning year", epithet = "Nu of the Long Furrow",
		tenet = "sow more than you take",
		climate = {"farm", "field"},
		favours = {"harvest", "offering"}, abhors = {"theft"},
		offering = "farming:wheat",
	},
	nua = {
		rank = "local", church_ok = true,
		domain = "hearth and household", epithet = "Nua Who Keeps The Door",
		tenet = "no traveller sleeps outside",
		climate = {"house", "inn", "hotel"},
		favours = {"rescue", "offering"}, abhors = {"murder", "theft"},
		offering = "default:torch",
	},
	ngwe = {
		rank = "local", church_ok = true,
		domain = "running water and the deep well", epithet = "Ngwe of the Cold Spring",
		tenet = "foul no water another must drink",
		climate = {"mill", "well"},
		favours = {"offering"}, abhors = {"theft"},
		offering = "vessels:glass_bottle",
	},
	nuananim = {
		rank = "local", church_ok = true,
		domain = "the quiet dead", epithet = "Nuananim of the Last Rites",
		tenet = "bury what you kill, and what you loved",
		climate = {"church"},
		favours = {"burial"}, abhors = {"murder"},
		offering = "default:coal_lump",
	},
	tulara = {
		rank = "local", church_ok = true,
		domain = "the forge and honest work", epithet = "Tulara Iron-Handed",
		tenet = "a thing made badly is a lie told slowly",
		climate = {"forge", "sawmill"},
		favours = {"trade", "offering"}, abhors = {"theft"},
		offering = "default:steel_ingot",
	},
	nuna = {
		rank = "local", church_ok = true,
		domain = "birth and the growing child", epithet = "Nuna, Mother of Mornings",
		tenet = "the young are the village's only harvest that matters",
		climate = {"house", "school"},
		favours = {"rescue", "succession"}, abhors = {"murder"},
		offering = "flowers:rose",
	},
	mother = {
		rank = "local", church_ok = true,
		domain = "the earth itself", epithet = "the Mother",
		tenet = "take from the ground and give the ground its due",
		climate = {"farm", "field", "pasture"},
		favours = {"burial", "offering"}, abhors = {"theft"},
		offering = "default:dirt",
	},
	valka = {
		rank = "local", church_ok = true,
		domain = "the road and safe return", epithet = "Valka of the Milestones",
		tenet = "point a stranger the right way",
		climate = {"inn", "hotel", "trader", "shop"},
		favours = {"trade", "rescue"}, abhors = {"theft"},
		offering = "default:cobble",
	},
	hekmet = {
		rank = "local", church_ok = true,
		domain = "reckoning, letters and fair measure", epithet = "Hekmet of the Even Scale",
		tenet = "measure twice, and say what you measured",
		climate = {"library", "school", "townhall", "village_square"},
		favours = {"trade"}, abhors = {"theft"},
		offering = "default:paper",
	},
	novus = {
		rank = "local", church_ok = true,
		domain = "beginnings and the new year", epithet = "Novus of the First Light",
		tenet = "let a thing be started properly",
		climate = {"village_square", "townhall"},
		favours = {"succession", "offering"}, abhors = {},
		offering = "default:torch",
	},
	barrowman = {
		rank = "local", church_ok = true,
		domain = "old graves and what keeps to them", epithet = "the Barrowman",
		tenet = "leave the mounds alone",
		climate = {"church"},
		favours = {"burial"}, abhors = {"theft"},
		offering = "default:mese_crystal_fragment",
	},

	--------------------------------------------------------------------------
	-- Greater gods: known everywhere, worshipped by those with cause
	--------------------------------------------------------------------------
	razu = {
		rank = "greater", church_ok = true,
		domain = "fire, war and the sacked town", epithet = "Razu the Red Hour",
		tenet = "strike once, and mean it",
		climate = {"tower", "castle"},
		favours = {"feat"}, abhors = {},
		offering = "default:flint",
	},
	crom = {
		rank = "greater", church_ok = false,
		domain = "strength, and the contempt of prayer", epithet = "Crom on his mountain",
		tenet = "ask him for nothing; he does not listen",
		favours = {"feat"}, abhors = {},
	},
	frith = {
		rank = "greater", church_ok = true,
		domain = "the sun, and the cunning of small creatures", epithet = "Frith of the Thousand",
		tenet = "be quick, and be kind to the quick",
		climate = {"farm", "pasture"},
		favours = {"rescue"}, abhors = {"murder"},
		offering = "farming:carrot",
	},
	mundakar = {
		rank = "greater", church_ok = true,
		domain = "the mountain's root and what is mined from it",
		epithet = "Mundakar Under-Stone",
		tenet = "shore up what you dig out",
		climate = {"forge"},
		favours = {"offering"}, abhors = {},
		offering = "default:stone",
	},
	maraxis = {
		rank = "greater", church_ok = false,
		domain = "plague, and the mercy of a quick end", epithet = "Maraxis Pale-Handed",
		tenet = "the sick are not to be turned out",
		favours = {"burial"}, abhors = {},
	},

	--------------------------------------------------------------------------
	-- Outer names: spoken, not worshipped
	--------------------------------------------------------------------------
	hastur = {
		rank = "outer", church_ok = false,
		domain = "the yellow sign and what wears it", epithet = "Him Who Is Not To Be Named",
		tenet = "do not say it a third time",
		favours = {}, abhors = {},
	},
	cthulhu = {
		rank = "outer", church_ok = false,
		domain = "the drowned city and its long sleep", epithet = "the Dreamer in the Deep",
		tenet = "keep off the water at low tide",
		favours = {}, abhors = {},
	},
	tsathoggua = {
		rank = "outer", church_ok = false,
		domain = "lightless caves and the appetite in them",
		epithet = "the Toad of N'kai",
		tenet = "do not go down where the air stops moving",
		favours = {}, abhors = {},
	},
	azathoth = {
		rank = "outer", church_ok = false,
		domain = "the centre, where nothing thinks", epithet = "the Blind Idiot",
		tenet = "there is nothing to ask for",
		favours = {}, abhors = {},
	},
	["chaugnar faugn"] = {
		rank = "outer", church_ok = false,
		domain = "the thing on the altar that drinks", epithet = "the Horror of the Hills",
		tenet = "never let it be carried into a house",
		favours = {}, abhors = {},
	},
	["atlach-nacha"] = {
		rank = "outer", church_ok = false,
		domain = "the bridge being spun under the world",
		epithet = "the Spinner in the Gulf",
		tenet = "the web is nearly finished",
		favours = {}, abhors = {},
	},
}

-- New gods added by this mod, registered with lumberjackzombie so the chat
-- invocation mechanic picks them up too. These are civic and agrarian: the
-- original pantheon is strong on cosmic dread and thin on anyone a pig farmer
-- would actually thank for a good spring.
faith.NEW_GODS = {
	orrek = {
		rank = "local", church_ok = true,
		domain = "the herd, and the beasts that feed a village",
		epithet = "Orrek of the Full Sty",
		tenet = "a beast well kept is a debt well paid",
		climate = {"pasture", "farm", "horsestable"},
		favours = {"offering"}, abhors = {"theft"},
		offering = "farming:seed_wheat",
	},
	semmel = {
		rank = "local", church_ok = true,
		domain = "bread, beer and the shared table",
		epithet = "Semmel of the Warm Loaf",
		tenet = "nobody eats alone who does not want to",
		climate = {"bakery", "tavern", "pub", "inn"},
		favours = {"trade", "offering"}, abhors = {"theft"},
		offering = "farming:bread",
	},
	kettlebright = {
		rank = "local", church_ok = true,
		domain = "small mercies and things mended",
		epithet = "Kettlebright the Patient",
		tenet = "mend it before you replace it",
		climate = {"shop", "house"},
		favours = {"rescue", "trade"}, abhors = {"murder"},
		offering = "default:stick",
	},
}

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

-- Whether the faith mod is present at all. Everything here degrades to nothing
-- without it rather than erroring: village_life does not depend on it.
function faith.available()
	return lumberjackzombie ~= nil and lumberjackzombie.add_faith ~= nil
end

minetest.register_on_mods_loaded(function()
	if not faith.available() then
		village_life.log("action",
				"lumberjackzombie not present; village religion disabled")
		return
	end

	for name, def in pairs(faith.NEW_GODS) do
		lumberjackzombie.register_deity(name)
		faith.gods[name] = def
	end

	-- Anything the faith mod knows that this file does not gets a bare entry,
	-- so a god added elsewhere is still nameable rather than crashing the
	-- lookup. It just has no domain until somebody writes one.
	for _, name in ipairs(lumberjackzombie.deities()) do
		if not faith.gods[name] then
			faith.gods[name] = {rank = "greater", church_ok = false,
					domain = "something nobody here could explain",
					epithet = faith.title(name), tenet = "",
					favours = {}, abhors = {}}
		end
	end

	village_life.log("action", ("village religion: %d god(s)"):format(
			#lumberjackzombie.deities()))
end)

--------------------------------------------------------------------------------
-- Names
--------------------------------------------------------------------------------

-- "atlach-nacha" -> "Atlach-Nacha", "chaugnar faugn" -> "Chaugnar Faugn".
--
-- The hyphen is deliberately not part of the trailing class: including it, as
-- the faith mod's own capitalize does, swallows the second half of the name and
-- yields "Atlach-nacha".
function faith.title(name)
	if not name then return "" end
	return (tostring(name):gsub("(%a)([%w']*)", function(first, rest)
		return first:upper() .. rest
	end))
end

function faith.god(name)
	return name and faith.gods[tostring(name):lower()]
end

--------------------------------------------------------------------------------
-- Patrons
--------------------------------------------------------------------------------

-- Which god a village keeps. Deterministic from the village id, like every
-- other derived village fact, so it is the same after a restart and needs no
-- storage -- but weighted by what the village actually is, so a farming hamlet
-- does not end up dedicated to the god of the sacked town.
--
-- Cached per village id because it walks the plot list.
local patrons = {}

local function building_types(village_id)
	local village = village_life.home.village(village_id)
	local out = {}
	if not village or not village.to_add_data then return out end
	for _, bpos in ipairs(village.to_add_data.bpos or {}) do
		if bpos.btype then
			local building = mg_villages.BUILDINGS[bpos.btype]
			local typ = building and building.typ
			if typ then out[typ] = (out[typ] or 0) + 1 end
		end
	end
	return out
end

function faith.patron(village_id)
	if not village_id then return end
	local cached = patrons[village_id]
	if cached ~= nil then
		if cached == false then return end
		return cached, faith.gods[cached]
	end

	local types = building_types(village_id)

	-- Score each eligible god by how much of this village is their business.
	local candidates = {}
	for name, def in pairs(faith.gods) do
		if def.church_ok then
			local score = 1
			for _, want in ipairs(def.climate or {}) do
				score = score + (types[want] or 0) * 4
			end
			candidates[#candidates + 1] = {name = name, score = score}
		end
	end

	if #candidates == 0 then
		patrons[village_id] = false
		return
	end

	-- Sorted for determinism, then drawn from the seeded RNG weighted by score:
	-- a village with a forge usually keeps Tulara, but not always, and it is
	-- the same village every time you come back.
	table.sort(candidates, function(a, b)
		if a.score ~= b.score then return a.score > b.score end
		return a.name < b.name
	end)

	local total = 0
	for _, c in ipairs(candidates) do total = total + c.score end

	local rng = util.rng("patron", village_id)
	local roll = rng:next(1, math.floor(total))
	local chosen = candidates[1].name
	for _, c in ipairs(candidates) do
		roll = roll - c.score
		if roll <= 0 then chosen = c.name ; break end
	end

	patrons[village_id] = chosen
	return chosen, faith.gods[chosen]
end

-- The name a villager would use for their own god.
function faith.patron_name(village_id)
	local name = faith.patron(village_id)
	if not name then return end
	local def = faith.gods[name]
	return (def and def.epithet) or faith.title(name)
end

--------------------------------------------------------------------------------
-- Deeds
--------------------------------------------------------------------------------

-- What a deed is worth to a god who cares about it. Small numbers: faith is
-- counted in invocations, and a burial should be worth a good few prayers
-- without making the chat mechanic pointless.
faith.DEED_VALUE = {
	burial   = 5,
	offering = 3,
	rescue   = 2,
	feat     = 2,
	trade    = 1,
	harvest  = 1,
	succession = 1,
}

-- Credit a player with a deed. Every god who favours it gains, every god who
-- abhors it loses -- so a murderer can be devout to something and still be
-- losing ground with the village's own patron.
--
-- `village_id` restricts it to that village's patron where the deed is a local
-- matter (an offering at one church is not an offering at all of them).
function faith.deed(pname, kind, village_id)
	if not faith.available() or not pname or not kind then return end
	local value = faith.DEED_VALUE[kind]
	if not value then return end

	local moved = {}

	local function apply(name, def)
		for _, k in ipairs(def.favours or {}) do
			if k == kind then
				lumberjackzombie.add_faith(pname, name, value)
				moved[name] = value
			end
		end
		for _, k in ipairs(def.abhors or {}) do
			if k == kind then
				lumberjackzombie.add_faith(pname, name, -value)
				moved[name] = -value
			end
		end
	end

	if village_id then
		local name, def = faith.patron(village_id)
		if name and def then apply(name, def) end
	else
		for name, def in pairs(faith.gods) do apply(name, def) end
	end

	return moved
end

-- How devout this player looks to a given village: their standing with that
-- village's own god, which is the only one its priest cares about.
function faith.devotion(pname, village_id)
	if not faith.available() then return 0 end
	local name = faith.patron(village_id)
	if not name then return 0 end
	return lumberjackzombie.get_faith(pname, name)
end

-- The god this player has called on most, if the village would recognise it.
function faith.player_patron(pname)
	if not faith.available() then return end
	local name = lumberjackzombie.patron_of(pname)
	if not name then return end
	return name, faith.gods[name]
end

-- Whether naming this god in this village is an embarrassment. Villages do not
-- mind you keeping another local god; they mind the Outer names.
function faith.is_dread(name)
	local def = faith.god(name)
	return def ~= nil and def.rank == "outer"
end
