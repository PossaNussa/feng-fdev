-- Who a villager's people are.
--
-- mg_villages already builds families and then never mentions them again. The
-- structure is entirely positional, in `assign_mobs_to_beds` (inhabitants.lua
-- around line 231), and it is worth writing down because reading it off the
-- data requires knowing it:
--
--   bed 1        the male worker, generation 2. The household's head, and the
--                one who carries the plot's job title.
--   bed 2        his wife, generation 2. Never given a title of her own.
--   bed 3+       children (generation 1), grandparents (generation 3), guests
--                (title "guest") or servants (title "servant"/"housemaid"),
--                depending on the building.
--
-- Two building types have no families at all and must not be given any:
-- `lumberjack` huts are all unrelated men of generation 2, and `castle`
-- buildings are barracks full of soldiers. Inferring a marriage from "bed 1 and
-- bed 2 are both adults" would marry off half the garrison.
--
-- Grandparents are specifically the *father's* parents -- mg_villages ages them
-- against bed 1 and says so -- so bed 2's relationship to them is by marriage.
--
-- Nothing here is stored. It is all derivable from the bed rows, which are the
-- authority, and deriving it means succession cannot leave a stale family tree
-- behind.

local util = village_life.util
local home = village_life.home

local kin = {}
village_life.kin = kin

-- Building types whose occupants are housemates rather than a family.
local NO_FAMILY = {lumberjack = true, castle = true}

-- Player-town coupling. A mg_villages village ships ready-made families (bed 1 and
-- bed 2 are married by construction); we never touch those. A *player* town is
-- filled by independent recruits, so co-residence must not marry them -- the
-- founder, their neighbour and a passing trader all sharing a roof are not a
-- couple. Instead a marriage there is an explicit, stored `bed.spouse` link
-- (mutual, by bed_nr), formed by chance and then remembered.
local MARRY_CHANCE = 0.5      -- how often a co-resident adult pairs off at all

local storage = minetest.get_mod_storage and minetest.get_mod_storage()

local function is_guest(bed)
	local t = bed and bed.title
	return t == "guest"
end

local function is_servant(bed)
	local t = bed and bed.title
	return t == "servant" or t == "housemaid"
end

-- Someone who lives here but is not related to anyone: lodgers and staff.
local function is_lodger(bed)
	return is_guest(bed) or is_servant(bed)
end

--------------------------------------------------------------------------------
-- Player-town couples (stored, not positional)
--------------------------------------------------------------------------------

local function opposite(g) return (g == "f") and "m" or "f" end

-- A grown resident who could be somebody's spouse. The founder's own bed carries
-- `player_owner` and no `first_name`, so the player is never a candidate -- they
-- live in the house, they are simply not up for pairing off.
local function marriageable(bed)
	return bed and bed.first_name and (bed.generation or 2) == 2
			and not is_lodger(bed) and not bed.player_owner
end

-- Give the unpartnered adults of one player-town plot a single shot at romance
-- and store any link that forms. Two hard limits keep a crowded plot from marrying
-- itself off wholesale, which is what a founder's town -- one house holding many
-- independent recruits -- otherwise does:
--
--   * one look each. The moment a resident is considered they are marked
--     `courted`, whatever the outcome, and no later read ever rolls them again.
--     This is what stops a settled town re-pairing after a save repair, and it
--     means a big influx is only ever looked at once.
--   * one couple per plot. Once a pair forms the sweep stops matching, so a house
--     ends up with at most a single married couple, not a paired-off dormitory.
--
-- Same-sex pairing only happens when the roll actually asks for it: if the wanted
-- sex is not free, the resident simply stays single rather than falling back to
-- whoever is left, so a gender-skewed town does not turn uniformly same-sex.
-- Deterministic (seeded on the plot), so the outcome is stable across reloads.
-- Returns true when it changed a bed (a link, or just a `courted` mark), so the
-- caller can persist.
local function pair_up(village_id, plot_nr, bpos)
	local singles = {}
	for nr, bed in ipairs(bpos.beds or {}) do
		if marriageable(bed) and not bed.spouse then singles[#singles + 1] = nr end
	end
	if #singles < 2 then return false end

	local changed = false
	for _, anr in ipairs(singles) do
		local a = bpos.beds[anr]
		if not a.spouse then
			local rng = util.rng("couple", village_id, plot_nr, anr)
			if util.rng_float(rng, 0, 1) < MARRY_CHANCE then
				-- Man and woman only: pair with the opposite sex, and if none is
				-- free stay single rather than settling for a same-sex match.
				local want = opposite(a.gender or "m")
				for _, bnr in ipairs(singles) do
					local b = bnr ~= anr and bpos.beds[bnr]
					if b and marriageable(b) and not b.spouse
							and (b.gender or "m") == want then
						a.spouse = bnr
						b.spouse = anr
						changed = true
						break
					end
				end
			end
		end
	end
	return changed
end

-- One-time carry-over of the marriages that existed before couples became a
-- stored thing. Under the old rule the two adults of a family house were married
-- on sight; this writes that single fact down for every player town so nobody who
-- is married today wakes up single tomorrow. mg_villages' own villages are left
-- alone -- their families are still read positionally, below. Guarded so it runs
-- exactly once; after it, new households only ever couple by the roll above, never
-- by mere co-residence.
local migrated = false
local function migrate_once()
	if migrated then return end
	if not (mg_villages and mg_villages.all_villages) then return end
	if storage and storage:get_string("couples_migrated") == "1" then
		migrated = true ; return
	end
	local changed = false
	for _, v in pairs(mg_villages.all_villages) do
		if v.is_player_town and v.to_add_data then
			for _, bpos in ipairs(v.to_add_data.bpos or {}) do
				-- Exactly the pair the old rule would have married: the two adults
				-- of the house, none of them already linked. Three-plus adults were
				-- never a clean couple, so leave those to the roll.
				local adults = {}
				for nr, bed in ipairs(bpos.beds or {}) do
					if marriageable(bed) and not bed.spouse then adults[#adults + 1] = nr end
				end
				if #adults == 2 then
					bpos.beds[adults[1]].spouse = adults[2]
					bpos.beds[adults[2]].spouse = adults[1]
					changed = true
				end
			end
		end
	end
	migrated = true
	if storage then storage:set_string("couples_migrated", "1") end
	if changed and mg_villages.save_data then pcall(mg_villages.save_data) end
end

--------------------------------------------------------------------------------
-- The household
--------------------------------------------------------------------------------

-- Everyone sleeping on one plot, as {bed_nr, bed, relation} rows relative to
-- `bed_nr`. `relation` is nil for someone with no relation to them.
--
-- Returns nil rather than an empty list when there is no plot to read, so
-- callers can tell "lives alone" from "has no home".
function kin.household(village_id, plot_nr, bed_nr)
	local bpos = home.plot(village_id, plot_nr)
	if not bpos or not bpos.beds then return end

	local building = mg_villages.BUILDINGS[bpos.btype]
	local family = not (building and NO_FAMILY[building.typ])

	-- In a player town, marriage is a stored link rather than a seating position.
	-- Bring the old marriages forward once, then let new arrivals couple by chance,
	-- and persist a link the moment one forms.
	local village = home.village(village_id)
	local player_town = village and village.is_player_town
	if player_town then
		migrate_once()
		if pair_up(village_id, plot_nr, bpos) and mg_villages.save_data then
			pcall(mg_villages.save_data)
		end
	end

	local me = bpos.beds[bed_nr]
	if not me then return end

	local out = {}
	-- Players who keep a bed on this plot -- the founder living in the town they
	-- raised, sharing the roof with the folk they took in. They are residents:
	-- counted, and named when a villager speaks of the house, but never a relative
	-- and never in the marriage roll (see `marriageable`).
	local players = {}
	for nr, bed in ipairs(bpos.beds) do
		if nr ~= bed_nr and bed.first_name then
			out[#out + 1] = {
				bed_nr = nr,
				bed = bed,
				relation = family and kin.relation(me, bed_nr, bed, nr, player_town) or nil,
			}
		elseif bed.player_owner then
			players[#players + 1] = bed.player_owner
		end
	end
	return out, family, players
end

-- How `other` is related to `me`. Both are bed rows, with their bed numbers.
--
-- The bed numbers matter because the grandparents are specifically bed 1's
-- parents: to bed 1 they are his mother and father, to bed 2 they are her
-- in-laws, and the two rows are otherwise indistinguishable.
function kin.relation(me, me_nr, other, other_nr, player_town)
	if is_lodger(me) or is_lodger(other) then return end

	-- Player-town residents are recruits, not a bloodline: the only tie between
	-- two of them is a marriage they actually entered, held as a mutual `spouse`
	-- link. No positional parent/child/sibling is invented from the seating.
	if player_town then
		if me.spouse == other_nr and other.spouse == me_nr then return "spouse" end
		return
	end

	local mine, theirs = me.generation, other.generation
	local me_is_head, other_is_head = me_nr == 1, other_nr == 1

	-- Same generation, the two adults of the house: married. Anyone else of
	-- generation 2 in a family house is not a thing mg_villages generates, so
	-- there is no third case to invent.
	if mine == 2 and theirs == 2 then
		return "spouse"
	end

	if mine == 1 and theirs == 1 then return "sibling" end

	if mine == 1 then
		if theirs == 2 then return "parent" end
		if theirs == 3 then return "grandparent" end
	end

	if mine == 2 then
		if theirs == 1 then return "child" end
		if theirs == 3 then
			-- Whether the old couple upstairs are my parents or my in-laws
			-- turns on which of the two adults I am.
			return me_is_head and "parent" or "parent-in-law"
		end
	end

	if mine == 3 then
		if theirs == 1 then return "grandchild" end
		if theirs == 2 then
			return other_is_head and "child" or "child-in-law"
		end
		if theirs == 3 then return "spouse" end
	end
end

--------------------------------------------------------------------------------
-- Per-villager view
--------------------------------------------------------------------------------

-- The relations of the villager `self`, cached in the weak scratch table.
--
--   {relation -> {rows}, all = {rows}, family = bool}
--
-- where a row is {bed_nr, bed, relation, name}.
function kin.of(self)
	local s = util.scratch(self)
	if s.kin then return s.kin end

	local r = home.resolve(self)
	if not r then return end

	local rows, family, players = kin.household(r.village_id, r.plot_nr, r.bed_nr)
	if not rows then return end

	local out = {all = rows, family = family, players = players or {}, by = {}}
	for _, row in ipairs(rows) do
		row.name = row.bed.first_name
		row.title = row.bed.title
		if row.relation then
			local list = out.by[row.relation]
			if not list then list = {} ; out.by[row.relation] = list end
			list[#list + 1] = row
		end
	end

	s.kin = out
	return out
end

-- Everyone standing in a given relation to `self`, as rows. Always a list.
function kin.get(self, relation)
	local k = kin.of(self)
	return (k and k.by[relation]) or {}
end

-- The one person a villager would name first when asked about their family:
-- spouse, then children, then parents. Nil for the unattached.
function kin.closest(self)
	for _, relation in ipairs({"spouse", "child", "parent", "grandchild",
			"grandparent", "sibling"}) do
		local list = kin.get(self, relation)
		if list[1] then return list[1] end
	end
end

-- Players who share this villager's house. The founder of a player town keeps a
-- bed among the residents they settled, so the people they took in genuinely live
-- with them -- this is how a villager knows to say so.
function kin.housemate_players(self)
	local k = kin.of(self)
	return (k and k.players) or {}
end

-- Does this particular player share the villager's roof? Lets a villager greet the
-- person they live with as a housemate rather than a stranger at the door.
function kin.lives_with(self, pname)
	for _, p in ipairs(kin.housemate_players(self)) do
		if p == pname then return true end
	end
	return false
end

-- Whether this villager has anybody at all.
function kin.has_family(self)
	local k = kin.of(self)
	if not k or not k.family then return false end
	for _ in pairs(k.by) do return true end
	return false
end

--------------------------------------------------------------------------------
-- Beyond the household
--------------------------------------------------------------------------------

-- People who work where this villager works. Colleagues are not kin, but they
-- are the other set of people a villager sees every day, and the two together
-- are most of who someone knows.
--
-- The scan is over one village's plot list, which is tens of entries, and the
-- result is cached per entity.
function kin.colleagues(self)
	local s = util.scratch(self)
	if s.colleagues then return s.colleagues end

	local out = {}
	s.colleagues = out

	local r = home.resolve(self)
	local village = r and home.village(r.village_id)
	local works_at = r and r.bed and r.bed.works_at
	if not village or not works_at then return out end

	local bpos_list = village.to_add_data and village.to_add_data.bpos or {}
	for plot_nr, bpos in ipairs(bpos_list) do
		for bed_nr, bed in ipairs(bpos.beds or {}) do
			local same_place = bed.works_at == works_at
			local same_person = plot_nr == r.plot_nr and bed_nr == r.bed_nr
			if same_place and not same_person and bed.first_name then
				out[#out + 1] = {plot_nr = plot_nr, bed_nr = bed_nr, bed = bed,
						name = bed.first_name, title = bed.title}
			end
		end
	end
	return out
end

-- Households on nearby plots. Being able to say "the family two doors down"
-- needs no more than this.
local NEIGHBOUR_RANGE = 24

function kin.neighbours(self)
	local s = util.scratch(self)
	if s.neighbours then return s.neighbours end

	local out = {}
	s.neighbours = out

	local r = home.resolve(self)
	local village = r and home.village(r.village_id)
	if not village or not r.plot_centre then return out end

	local bpos_list = village.to_add_data and village.to_add_data.bpos or {}
	for plot_nr, bpos in ipairs(bpos_list) do
		if plot_nr ~= r.plot_nr and bpos.beds and bpos.beds[1]
				and bpos.beds[1].first_name then
			local centre = {
				x = bpos.x + math.floor((bpos.bsizex or 1) / 2),
				y = bpos.y,
				z = bpos.z + math.floor((bpos.bsizez or 1) / 2),
			}
			if util.dist_flat(centre, r.plot_centre) <= NEIGHBOUR_RANGE then
				out[#out + 1] = {plot_nr = plot_nr, bpos = bpos,
						head = bpos.beds[1].first_name,
						btype = bpos.btype}
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Naming
--------------------------------------------------------------------------------

-- "my wife Freya", "my son Aldo". Gendered where mg_villages knows the gender,
-- because it does, and "my child" reads like a form.
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

function kin.describe(row)
	if not row or not row.relation then return end
	local g = GENDERED[row.relation]
	local word = (g and g[row.bed and row.bed.gender]) or row.relation
	if row.name then
		return ("my %s %s"):format(word, row.name)
	end
	return "my " .. word
end
