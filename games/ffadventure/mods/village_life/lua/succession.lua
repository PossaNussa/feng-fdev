-- Death that sticks, and what fills the gap.
--
-- The census used to treat every empty bed as a bookkeeping error: wait four
-- minutes, put an identical person back. That is the right behaviour for a
-- villager whose mapblock unloaded and the wrong behaviour for one who was
-- murdered, and it could not tell the difference, so nobody in the world could
-- ever actually die.
--
-- Now a death is written into the bed row itself, in `mg_all_villages.data`.
-- That row is the authority on who lives where -- everything else in this mod
-- derives from it -- so marking it is what makes the death real to the census,
-- to kin, to the market and to anybody who asks after them.
--
-- The gap is then filled by *succession* rather than by replacement:
--
--   * a child of the house who is old enough comes up into the trade, keeping
--     their own name and character and inheriting the title; or
--   * failing that, after long enough, an incomer arrives and takes it on.
--
-- In between, the workstation stands empty and the trade goes out of the
-- village's market. A dead smith is supposed to be felt.

local util = village_life.util
local home = village_life.home

local succession = {}
village_life.succession = succession

--------------------------------------------------------------------------------
-- Recording a death
--------------------------------------------------------------------------------

-- mg_villages serialises the whole village table, so new fields on a bed row
-- persist without any schema work. These are ours:
--
--   dead        true once they are gone for good
--   died_day    in-game day, for mourning and for succession timing
--   killed_by   player name, if a player did it
--   was_named   their name, kept after the row is reused, so the village can
--               still say who used to live here

function succession.record_death(self, killer_name)
	if not village_life.settings.permadeath then return end
	if not home.is_villager(self) then return end

	local v, p, b = self.vl.v, self.vl.p, self.vl.b
	local bed = home.bed_data(v, p, b)
	if not bed or bed.dead then return end

	bed.dead = true
	bed.died_day = minetest.get_day_count and minetest.get_day_count() or 0
	bed.killed_by = killer_name
	bed.was_named = bed.first_name
	bed.was_titled = bed.title

	-- The bed row is the only authority; get it onto disk before anything can
	-- crash between here and the next autosave.
	if mg_villages.save_data then mg_villages.save_data() end

	-- Stop the census waiting on a replacement that is never coming.
	home.pending[home.key(v, p, b)] = nil

	village_life.log("action", ("%s of %s is dead%s"):format(
			tostring(bed.was_named), v,
			killer_name and (", killed by " .. killer_name) or ""))

	succession.mourn(self, v, p, b, bed)
end

--------------------------------------------------------------------------------
-- Mourning
--------------------------------------------------------------------------------

-- The household takes it hardest, then the people they worked with, then the
-- village. Applied to the memory book by key, so it reaches people who are not
-- currently loaded.
local GRIEF_KIN = -35
local GRIEF_COLLEAGUE = -12
local GRIEF_VILLAGE = -4

function succession.mourn(self, village_id, plot_nr, bed_nr, bed)
	local memory = village_life.memory
	local killer = bed.killed_by

	-- Household.
	local rows = village_life.kin.household(village_id, plot_nr, bed_nr)
	for _, row in ipairs(rows or {}) do
		local key = home.key(village_id, plot_nr, row.bed_nr)
		memory.nudge_mood_key(key, row.relation and GRIEF_KIN or GRIEF_COLLEAGUE,
				"bereaved")
		if killer then
			-- Losing someone in your own house to a named person is the
			-- heaviest single thing one villager can hold against one player.
			memory.remember_key(key, killer, "kin_killed")
		end
	end

	-- Everyone else in the village, lightly. Walked over the bed rows rather
	-- than the roster so it reaches the unloaded too.
	local village = home.village(village_id)
	if not village or not village.to_add_data then return end
	for pnr, bpos in ipairs(village.to_add_data.bpos or {}) do
		for bnr, other in ipairs(bpos.beds or {}) do
			local same_house = pnr == plot_nr
			if other.first_name and not other.dead
					and not (pnr == plot_nr and bnr == bed_nr) and not same_house then
				local key = home.key(village_id, pnr, bnr)
				memory.nudge_mood_key(key, GRIEF_VILLAGE, "a death in the village")
				if killer then
					memory.remember_key(key, killer, "neighbour_died")
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Filling the gap
--------------------------------------------------------------------------------

-- In-game days before a child steps up, and before an incomer arrives. The
-- first is shorter: the family is already there.
local HEIR_DAYS = 3
local INCOMER_DAYS = 12

-- Age at which a child of the house can take on a trade.
local COMING_OF_AGE = 16

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

-- A child in the same house who could take up the dead person's work.
local function heir_in_house(bpos, dead_bed_nr)
	local best, best_nr
	for nr, bed in ipairs(bpos.beds or {}) do
		if nr ~= dead_bed_nr and bed.first_name and not bed.dead
				and bed.generation == 1 and (bed.age or 0) >= COMING_OF_AGE
				and not bed.title then
			-- The eldest goes first.
			if not best or (bed.age or 0) > (best.age or 0) then
				best, best_nr = bed, nr
			end
		end
	end
	return best, best_nr
end

-- Generate a name for somebody arriving from outside. mg_villages owns name
-- generation; borrow it where it is reachable and fall back to a plain list
-- rather than inventing a second name generator.
local FALLBACK_NAMES = {
	m = {"Aldo", "Bertram", "Corvin", "Dunstan", "Edric", "Falk", "Gethin",
			"Hollis", "Ivor", "Jarl", "Kemp", "Lorin"},
	f = {"Alys", "Bryn", "Cerys", "Dagny", "Elke", "Fenna", "Greta", "Hilde",
			"Isolde", "Jonna", "Katrin", "Lise"},
}

local function new_name(gender, seed)
	local mg = mg_villages.inhabitants
	if mg and mg.get_new_inhabitant then
		local ok, row = pcall(mg.get_new_inhabitant, {}, gender, 2, {}, nil, nil)
		if ok and row and row.first_name then return row.first_name, row.age end
	end
	local list = FALLBACK_NAMES[gender] or FALLBACK_NAMES.m
	local rng = util.rng("incomer", seed)
	return list[rng:next(1, #list)], rng:next(19, 48)
end

-- Try to fill one dead bed. Returns true if somebody now lives there.
function succession.fill(village_id, plot_nr, bed_nr)
	local bpos = home.plot(village_id, plot_nr)
	local bed = bpos and bpos.beds and bpos.beds[bed_nr]
	if not bed or not bed.dead then return false end

	local elapsed = today() - (bed.died_day or 0)
	local title = bed.was_titled

	-- A child of the house comes up into the trade first. They keep their own
	-- name and their own character -- this is a person growing up, not a
	-- replacement being generated.
	if elapsed >= HEIR_DAYS and title then
		local heir, heir_nr = heir_in_house(bpos, bed_nr)
		if heir then
			heir.generation = 2
			heir.title = title
			heir.works_at = bed.works_at
			heir.workplace = bed.workplace
			heir.age = math.max(heir.age or COMING_OF_AGE, COMING_OF_AGE)

			-- The dead bed stays dead; the heir moved up in their own bed.
			if mg_villages.save_data then mg_villages.save_data() end

			-- Their character is seeded on the bed they sleep in, so it does
			-- not change -- but the memory of who they were as a child is no
			-- longer the right memory for the person they have become.
			village_life.log("action", ("%s of %s takes up as %s"):format(
					heir.first_name, village_id, title))

			if village_life.settings.gossip then
				village_life.events.raise({
					kind = "succession",
					village_id = village_id,
					pos = {x = heir.x, y = heir.y, z = heir.z},
					subject = home.key(village_id, plot_nr, heir_nr),
					subject_name = heir.first_name,
					detail = {title = title},
				})
			end
			return true
		end
	end

	-- Nobody in the family. Eventually somebody moves in.
	if elapsed >= INCOMER_DAYS then
		local gender = bed.gender or "m"
		local name, age = new_name(gender,
				home.key(village_id, plot_nr, bed_nr) .. ":" .. tostring(elapsed))

		-- Everything about the previous occupant goes. The identity key is the
		-- bed, so their memories and gossip would otherwise be inherited by a
		-- stranger.
		local key = home.key(village_id, plot_nr, bed_nr)
		village_life.memory.forget(key)
		village_life.gossip.forget(key)
		village_life.traits.forget(key)

		bed.dead = nil
		bed.died_day = nil
		bed.killed_by = nil
		bed.first_name = name
		bed.age = age or 25
		bed.generation = 2
		bed.title = title
		if mg_villages.save_data then mg_villages.save_data() end

		village_life.log("action", ("%s has moved into %s"):format(
				name, key))

		if village_life.settings.gossip then
			village_life.events.raise({
				kind = "succession",
				village_id = village_id,
				pos = {x = bed.x, y = bed.y, z = bed.z},
				subject = key,
				subject_name = name,
				detail = {title = title},
			})
		end
		return true
	end

	return false
end

--------------------------------------------------------------------------------
-- The slow pass
--------------------------------------------------------------------------------

-- Succession is measured in in-game days, so this runs rarely. It walks the
-- bed rows rather than the roster, because the whole point is to act on people
-- who are not there.
local SUCCESSION_INTERVAL = 60
local timer = 0

minetest.register_globalstep(function(dtime)
	if not village_life.settings.permadeath then return end

	timer = timer + dtime
	if timer < SUCCESSION_INTERVAL then return end
	timer = 0

	local range = village_life.settings.active_range
	local shortlist = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos then home.villages_near(ppos, range, shortlist) end
	end

	for village_id in pairs(shortlist) do
		local village = home.village(village_id)
		if village and village.to_add_data then
			for plot_nr, bpos in ipairs(village.to_add_data.bpos or {}) do
				for bed_nr, bed in ipairs(bpos.beds or {}) do
					if bed.dead then
						succession.fill(village_id, plot_nr, bed_nr)
					end
				end
			end
		end
	end
end)

--------------------------------------------------------------------------------
-- Remembering the dead
--------------------------------------------------------------------------------

-- Who has died in this village, most recent first. Used by dialogue so the
-- village can be asked about it, and by the debug command.
function succession.the_dead(village_id)
	local village = home.village(village_id)
	if not village or not village.to_add_data then return {} end

	local out = {}
	for plot_nr, bpos in ipairs(village.to_add_data.bpos or {}) do
		for bed_nr, bed in ipairs(bpos.beds or {}) do
			if bed.dead then
				out[#out + 1] = {
					name = bed.was_named,
					title = bed.was_titled,
					day = bed.died_day or 0,
					killed_by = bed.killed_by,
					plot_nr = plot_nr,
					bed_nr = bed_nr,
				}
			end
		end
	end
	table.sort(out, function(a, b) return a.day > b.day end)
	return out
end

-- Is this trade currently unfilled in this village? What makes a dead smith
-- felt rather than merely noted.
function succession.trade_vacant(village_id, title)
	if not title then return false end
	local village = home.village(village_id)
	if not village or not village.to_add_data then return false end

	local vacant = false
	for _, bpos in ipairs(village.to_add_data.bpos or {}) do
		for _, bed in ipairs(bpos.beds or {}) do
			if bed.title == title then
				if bed.dead then vacant = true else return false end
			end
			if bed.dead and bed.was_titled == title then vacant = true end
		end
	end
	return vacant
end
