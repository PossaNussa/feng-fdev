-- Player-founded settlements.
--
-- Everything else in this mod reads one data structure mg_villages already
-- keeps: all_villages[village_id] -> to_add_data.bpos[plot].beds[bed]. The
-- census fills any bed that has a first_name, home.resolve turns a villager's
-- (village, plot, bed) triple into a home and a bed to sleep in, and hire /
-- companion / lodging all key off the same rows.
--
-- So a player's town is not a new system. It is a *synthetic mg_villages
-- village*: a record injected into all_villages with a centre, a radius and a
-- to_add_data.bpos list the player builds up by hand. Once it is there the
-- census spawns and repopulates its residents, the schedule walks them home to
-- bed, and hiring works on them -- all for free, because none of those systems
-- ever asked how the village came to exist. It persists the same way every
-- other village does, through mg_villages.save_data() / the world's
-- mg_all_villages.data, so there is no storage of our own to keep.
--
-- The player's tools are a written book (the deed) and their own hands: punch
-- the ground to found, punch a bed to say who lives in it, punch a door to see
-- who lives in the house. The deed authorises the gesture and names the town;
-- the town itself is tracked by its founder and where it stands, not by the
-- book -- re-editing the book must not orphan the town.

local util = village_life.util
local home = village_life.home

local settlement = {}
village_life.settlement = settlement

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

-- Persist the village table exactly as a plot purchase or an `away` mark does.
local function save()
	if mg_villages.save_data then pcall(mg_villages.save_data) end
end
settlement.save = save

local function iround(n) return math.floor(n + 0.5) end

--------------------------------------------------------------------------------
-- The deed
--------------------------------------------------------------------------------

-- The book's body is a single string with embedded newlines, stored in the item
-- stack's metadata under "text" (see default/craftitems.lua). Split it the same
-- way the book code does.
local function lines_of(text)
	local out = {}
	for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
		out[#out + 1] = str
	end
	return out
end

-- A deed is any written book whose first line is "Town Deed". A "Name:" line
-- gives the settlement its name. Returns {name = ...} or nil. The town is not
-- recorded on the book -- the book only authorises and names -- because saving
-- a book rewrites its whole meta table and would wipe anything we stored there.
function settlement.deed_of(stack)
	if not stack or stack:is_empty() then return end
	if stack:get_name() ~= "default:book_written" then return end
	local meta = stack:get_meta()
	local text = meta:get_string("text") or ""
	if text == "" then return end
	local lines = lines_of(text)
	local head = (lines[1] or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if head:lower() ~= "town deed" then return end
	local name
	for _, l in ipairs(lines) do
		local n = l:match("^%s*[Nn][Aa][Mm][Ee]%s*:%s*(.-)%s*$")
		if n and n ~= "" then name = n break end
	end
	return {name = name}
end

--------------------------------------------------------------------------------
-- Towns: synthetic mg_villages villages
--------------------------------------------------------------------------------

-- Every player town, or only one founder's.
function settlement.towns_of(pname)
	local out = {}
	for id, v in pairs(mg_villages.all_villages or {}) do
		if v.is_player_town and (not pname or v.founder == pname) then
			out[id] = v
		end
	end
	return out
end

-- The nearest of a founder's towns whose circle this position falls in.
function settlement.town_at(pos, pname, margin)
	margin = margin or 8
	local best, best_id, best_d
	for id, v in pairs(settlement.towns_of(pname)) do
		if v.vx and v.vz then
			local dx, dz = pos.x - v.vx, pos.z - v.vz
			local d = math.sqrt(dx * dx + dz * dz)
			if d <= (v.vs or 16) + margin and (not best_d or d < best_d) then
				best, best_id, best_d = v, id, d
			end
		end
	end
	return best, best_id
end

-- Grow the town's circle so it covers a newly dedicated point, and keep its
-- build height roughly where the dedications are. home.village_at / the census
-- both work from vx/vz/vs/vh, so a bed outside the circle would be a resident
-- the census could not see.
local function expand_town(v, pos)
	local dx, dz = pos.x - v.vx, pos.z - v.vz
	local d = math.sqrt(dx * dx + dz * dz)
	local want = math.ceil(d) + 8
	if want > (v.vs or 16) then v.vs = want end
	-- Nudge the recorded height towards the dedication so the vertical bound in
	-- home.village_in keeps the town on the surface it is actually built on.
	v.vh = iround(((v.vh or pos.y) + pos.y) / 2)
end
settlement.expand_town = expand_town

-- Found a town centred on `pos`, or return the one already there. Refuses ground
-- that belongs to a mapgen village.
function settlement.found(pname, pos, name)
	if not name or name == "" then
		return nil, "This deed needs a 'Name:' line before it can found a town."
	end
	if mg_villages.get_town_id_at_pos then
		local existing = mg_villages.get_town_id_at_pos(pos)
		local ev = existing and mg_villages.all_villages[existing]
		if ev and not ev.is_player_town then
			return nil, "This ground already belongs to " ..
					(ev.name or "a village") .. "."
		end
	end

	local town_id = "deed:" .. pname .. ":" ..
			minetest.hash_node_position(util.round_pos(pos))
	local v = mg_villages.all_villages[town_id]
	if v then
		v.name = name
		return town_id, v
	end

	-- One name, one town. If this founder already has a settlement by this name
	-- standing somewhere else, punching fresh ground does not quietly start a
	-- second copy of it -- that was almost always a misfire, and the duplicate
	-- same-name towns it left behind are exactly what this guard (and the load-time
	-- cleanup below) close off. Move a town by digging its foundation stone first.
	for id, tv in pairs(settlement.towns_of(pname)) do
		if id ~= town_id and tv.name == name then
			return nil, ("You already have a town called %s. Dig its foundation "
					.. "stone first if you mean to move it."):format(name)
		end
	end

	v = {
		vx = iround(pos.x), vz = iround(pos.z), vh = iround(pos.y),
		vs = 16,
		name = name,
		village_type = "settlement",
		is_player_town = true,
		founder = pname,
		-- If mg_villages' optional protection is ever switched on, an ownerless
		-- plot inside a village reads as protected against everyone, which would
		-- lock the founder out of their own town. Naming them owner makes that
		-- case correct; it is inert while ENABLE_PROTECTION is false (the default).
		ownerlist = {[pname] = true},
		to_add_data = {bpos = {}, replacements = {}, dirt_roads = {}},
	}
	mg_villages.all_villages[town_id] = v
	save()
	village_life.log("action", pname .. " founded the settlement of " .. name)
	return town_id, v
end

-- Take a town off the map. A deliberately destructive act (digging the
-- foundation stone): the houses stay, but the town stops being one, and any
-- residents currently loaded lose their brain until /clearobjects or a reload
-- tidies them. Rare enough not to warrant walking them home first.
function settlement.dissolve(town_id)
	if not mg_villages.all_villages[town_id] then return end
	mg_villages.all_villages[town_id] = nil
	for key in pairs(home.roster) do
		if key:sub(1, #town_id + 1) == town_id .. "/" then
			home.roster[key] = nil
		end
	end
	save()
end

-- How many real residents a town has: beds with a name on them (someone living
-- there, or on the road to it). A bed the founder kept for themselves ("Home of
-- <player>"), a vacant bed or a public one does not count -- an all-"me" town is
-- empty of residents for the purpose of deciding which duplicate to keep.
local function resident_count(v)
	local n = 0
	for _, bpos in ipairs(v.to_add_data and v.to_add_data.bpos or {}) do
		for _, bed in ipairs(bpos.beds or {}) do
			if bed.first_name then n = n + 1 end
		end
	end
	return n
end
settlement.resident_count = resident_count

-- Clean up the duplicate same-name towns that could be founded before the guard
-- in settlement.found existed. For each (founder, name) collision, keep the one
-- with the most residents and dissolve the empty ones -- a town with a resident
-- (a settled Throg) is never removed, only the "just me" copies. Runs once at
-- load; anything with residents is always kept, so it can never eat real data.
function settlement.dedup_towns()
	local groups = {}
	for id, v in pairs(settlement.towns_of()) do
		local key = (v.founder or "?") .. "\0" .. (v.name or "?")
		groups[key] = groups[key] or {}
		table.insert(groups[key], {id = id, residents = resident_count(v)})
	end

	local removed = 0
	for _, list in pairs(groups) do
		if #list > 1 then
			-- Richest first; ties keep whichever pairs() happened to see first.
			table.sort(list, function(a, b) return a.residents > b.residents end)
			for i = 2, #list do
				if list[i].residents == 0 then
					settlement.dissolve(list[i].id)
					removed = removed + 1
					village_life.log("action",
							"dedup: dissolved empty duplicate town " .. list[i].id)
				end
			end
		end
	end
	if removed > 0 then save() end
	return removed
end

minetest.register_on_mods_loaded(function()
	if not village_life.settings.settlement then return end
	local n = settlement.dedup_towns()
	if n > 0 then
		minetest.log("action", ("[village_life] removed %d duplicate player town(s)")
				:format(n))
	end
end)

--------------------------------------------------------------------------------
-- Plots and beds
--------------------------------------------------------------------------------

-- A synthetic btype that is deliberately NOT in mg_villages.BUILDINGS. Every
-- consumer guards `local b = BUILDINGS[bpos.btype]; if b then ...`, so an
-- unknown type takes the fallback paths (home.resolve sleeps beside the bed,
-- lodging/kin/faith skip the plot) rather than crashing.
local PLOT_BTYPE = "player_house"

-- Beds within this of an existing plot's centre are taken to be the same house.
local CLUSTER = 8

local function bpos_centre(bpos)
	return {
		x = bpos.x + ((bpos.bsizex or 1) - 1) / 2,
		y = bpos.y,
		z = bpos.z + ((bpos.bsizez or 1) - 1) / 2,
	}
end

-- Grow a plot's footprint so it covers a bed inside it.
local function cover(bpos, pos)
	local x0 = math.min(bpos.x, iround(pos.x))
	local z0 = math.min(bpos.z, iround(pos.z))
	local x1 = math.max(bpos.x + (bpos.bsizex or 1) - 1, iround(pos.x))
	local z1 = math.max(bpos.z + (bpos.bsizez or 1) - 1, iround(pos.z))
	bpos.x, bpos.z = x0, z0
	bpos.bsizex = x1 - x0 + 1
	bpos.bsizez = z1 - z0 + 1
end

-- Which plot a bed belongs to: the one whose footprint contains it, else the
-- nearest within CLUSTER (grown to cover it), else a fresh one-house plot. This
-- is how two beds in one room become one household without the player having to
-- declare the walls.
local function find_or_make_bpos(v, pos)
	for i, bpos in ipairs(v.to_add_data.bpos) do
		if util.inside_plot(pos, bpos) then return i, bpos end
	end

	local best_i, best_d
	for i, bpos in ipairs(v.to_add_data.bpos) do
		local c = bpos_centre(bpos)
		local d = math.sqrt((pos.x - c.x) ^ 2 + (pos.z - c.z) ^ 2)
		if d <= CLUSTER and (not best_d or d < best_d) then
			best_i, best_d = i, d
		end
	end
	if best_i then
		cover(v.to_add_data.bpos[best_i], pos)
		return best_i, v.to_add_data.bpos[best_i]
	end

	local bpos = {
		x = iround(pos.x) - 1, y = iround(pos.y), z = iround(pos.z) - 1,
		bsizex = 3, bsizez = 3, brotate = 0, btype = PLOT_BTYPE,
		owner = v.founder, can_edit = {},
		beds = {},
	}
	table.insert(v.to_add_data.bpos, bpos)
	return #v.to_add_data.bpos, bpos
end

local function same_node(bed, pos)
	return bed.x == iround(pos.x) and bed.y == iround(pos.y)
			and bed.z == iround(pos.z)
end

-- A vacant bed row for a bed node, or the row already recorded for it. A vacant
-- row carries no first_name, so the census leaves it alone until a resident is
-- assigned or travels in.
local function find_or_make_bed(bpos, pos)
	bpos.beds = bpos.beds or {}
	for i, b in ipairs(bpos.beds) do
		if same_node(b, pos) then return i, b end
	end
	local node = minetest.get_node(pos)
	local row = {
		bnr = #bpos.beds + 1,
		x = iround(pos.x), y = iround(pos.y), z = iround(pos.z),
		p2 = node.param2 or 0,
		vacant = true,
	}
	table.insert(bpos.beds, row)
	return #bpos.beds, row
end

-- A bed the player owns by having bought its plot: the (village, id, plot, bed)
-- for a bed node standing inside a plot whose owner is this player. The bed row
-- is found by position, or recorded if the node has none yet -- so an empty
-- bought shop can be furnished with beds and staffed the same way a founded plot
-- is. Skips the player's own synthetic towns (handled by town_at); those are not
-- "bought" plots.
local function owned_bed_at(pname, pos)
	for id, v in pairs(mg_villages.all_villages or {}) do
		if not v.is_player_town and v.to_add_data and v.to_add_data.bpos then
			for pnr, bpos in ipairs(v.to_add_data.bpos) do
				if bpos.owner == pname and util.inside_plot(pos, bpos) then
					local bnr = find_or_make_bed(bpos, pos)
					return v, id, pnr, bnr
				end
			end
		end
	end
end
settlement.owned_bed_at = owned_bed_at

-- Wipe a bed row back to an empty, un-owned slot (no resident, not reserved).
local function clear_bed(bed)
	bed.first_name, bed.title, bed.gender, bed.generation = nil, nil, nil, nil
	bed.age, bed.works_at, bed.workplace = nil, nil, nil
	-- A hand-placed workstation (player town) goes with its worker too, or the
	-- next occupant of the bed inherits a job at a node that no longer names them.
	bed.work_pos, bed.work_facing = nil, nil
	bed.away, bed.dead, bed.arrive_day = nil, nil, nil
	bed.vacant, bed.public, bed.player_owner = nil, nil, nil
	-- Species and any lent kit go with the resident: a re-used bed must not revive
	-- the next occupant as the last one's mob, nor hand them the last one's gear.
	bed.species, bed.weapon, bed.armor = nil, nil, nil
end
settlement.clear_bed = clear_bed

-- Nearest dedicated plot to a position, for the door read-out.
local function nearest_plot(v, pos)
	local best_i, best_d
	for i, bpos in ipairs(v.to_add_data.bpos) do
		local c = bpos_centre(bpos)
		local d = (pos.x - c.x) ^ 2 + (pos.z - c.z) ^ 2
		if not best_d or d < best_d then best_i, best_d = i, d end
	end
	return best_i
end

--------------------------------------------------------------------------------
-- Recruiting: who has a bed spare
--------------------------------------------------------------------------------

-- A reserved-but-empty bed in the founder's nearest town, for a newcomer to be
-- assigned to. "Vacant" means the player set it aside on purpose; a bed with a
-- resident, a player-home label or an incoming traveller is not on offer.
function settlement.recruit_town(pname, near)
	local best_id, best_plot, best_bed, best_d
	for id, v in pairs(settlement.towns_of(pname)) do
		for pnr, bpos in ipairs(v.to_add_data.bpos) do
			for bnr, bed in ipairs(bpos.beds or {}) do
				if bed.vacant and not bed.first_name and not bed.arrive_day then
					local d = near and ((v.vx - near.x) ^ 2 + (v.vz - near.z) ^ 2)
							or 0
					if not best_d or d < best_d then
						best_id, best_plot, best_bed, best_d = id, pnr, bnr, d
					end
				end
			end
		end
	end

	-- Beds set aside in plots the player has *bought* count too: buy a shop, set a
	-- bed vacant in it with the deed, and you can recruit someone to travel there
	-- and work it. The destination is the plot's own village, so the census spawns
	-- them there wherever it stands -- no need for it to lie inside a town circle.
	for id, v in pairs(mg_villages.all_villages or {}) do
		if not v.is_player_town and v.to_add_data and v.to_add_data.bpos then
			for pnr, bpos in ipairs(v.to_add_data.bpos) do
				if bpos.owner == pname then
					for bnr, bed in ipairs(bpos.beds or {}) do
						if bed.vacant and not bed.first_name and not bed.arrive_day then
							local d = near
									and ((bed.x - near.x) ^ 2 + (bed.z - near.z) ^ 2) or 0
							if not best_d or d < best_d then
								best_id, best_plot, best_bed, best_d = id, pnr, bnr, d
							end
						end
					end
				end
			end
		end
	end

	return best_id, best_plot, best_bed
end

-- Count vacant beds in a town, for the overview.
local function vacancy_count(v)
	local n = 0
	for _, bpos in ipairs(v.to_add_data.bpos) do
		for _, bed in ipairs(bpos.beds or {}) do
			if bed.vacant and not bed.first_name and not bed.arrive_day then
				n = n + 1
			end
		end
	end
	return n
end

-- Living companions of `pname` standing near `pos` who are following on foot --
-- the ones who can be settled into a bed here and now.
-- The founder of the player town a villager lives in, or nil for a mapgen
-- villager / stray. Used to decide whether the player standing in front of them
-- is entitled to kit them out: you arm your own townsfolk, not someone else's.
function settlement.founder_of(self)
	local v = self and self.vl and self.vl.v
	local town = v and mg_villages.all_villages[v]
	if town and town.is_player_town then return town.founder end
	return nil
end

function settlement.following_companions(pname, pos)
	local out = {}
	if not minetest.get_objects_inside_radius then return out end
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 24)) do
		local ent = obj.get_luaentity and obj:get_luaentity()
		if ent and village_life.companion.employer(ent) == pname
				and village_life.companion.order(ent) == "follow" then
			out[#out + 1] = ent
		end
	end
	return out
end

-- Loaded villager mobs standing by this bed who could be (re)bound to it: this
-- town's own folk whose recorded home is not already this exact bed. That is the
-- resident of a bed you have physically carried elsewhere (their row still points
-- at the old spot), and the villager whose row was cleared out from under them by
-- an earlier edit -- both still walking, both re-attachable to a real bed here.
function settlement.rebindable_near(bed, town_id)
	local out, seen = {}, {}
	if not minetest.get_objects_inside_radius or not bed then return out end
	local c = {x = bed.x, y = bed.y, z = bed.z}
	for _, obj in ipairs(minetest.get_objects_inside_radius(c, 12)) do
		local ent = obj.get_luaentity and obj:get_luaentity()
		if ent and home.is_villager(ent) and ent.vl.v == town_id then
			-- Skip only a villager who *intactly* lives in this bed already: the
			-- row they point at is this one AND it still names them. A moved bed
			-- points them at a different row; a bed cleared out from under them
			-- points here but carries no name -- both want rebinding.
			local ob = home.bed_data(ent.vl.v, ent.vl.p, ent.vl.b)
			local intact_here = ob == bed and bed.first_name ~= nil
			if not intact_here then
				local r = home.resolve(ent)
				local nm = ent.game_name or (r and r.name) or "a villager"
				if not seen[ent] then
					seen[ent] = true
					out[#out + 1] = {ent = ent, name = nm}
				end
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Taking a resident (from the "come and live in my town" dialogue)
--------------------------------------------------------------------------------

-- Copy a villager's identity off their bed (or off the entity, for a bedless
-- adventurer) so it can be written onto a bed in the new town.
local function identity_of(self)
	local r = home.resolve(self)
	-- A wandering trader carries its trade/gender/name off its species rather than
	-- a bed row; make sure it travels in with all three, and remember the species
	-- so home.spawn revives a dwarf as a dwarf, not a pigman.
	local sp = village_life.wanderer and village_life.wanderer.species(self)
	-- Settle it as the trade its kind falls into (a mung as a hunter, say), rolled
	-- once and kept -- never the flat "trader" placeholder its species carries.
	if village_life.wanderer then village_life.wanderer.ensure_role(self) end
	-- An adventurer settles as its kind (a veteran stays a veteran), not the flat
	-- "adventurer" its self.profession carries -- that title also drives the skin.
	local title = (r and r.title) or self.profession or (sp and sp.title)
	if self._adventurer and village_life.adventurer then
		title = village_life.adventurer.settle_title(self) or title
	end
	return {
		name = self.game_name or (r and r.name)
				or (sp and village_life.wanderer.name_for(self)) or "Someone",
		title = title,
		gender = (r and r.gender) or self.gender or (sp and sp.gender) or "m",
		generation = (r and r.generation) or 2,
		species = self.name,
	}
end

-- Blank the villager's origin bed: they have moved away for good, so the house
-- they left simply loses a resident (the census will not refill a nameless
-- bed). Nothing to do for a bedless adventurer.
local function vacate_origin(self)
	if not home.is_villager(self) then return end
	local ob = home.bed_data(self.vl.v, self.vl.p, self.vl.b)
	if ob then clear_bed(ob) end
	home.check_out(self)
end
settlement.vacate_origin = vacate_origin

-- Attach a loaded villager to the bed the player is editing, taking their home
-- with them: their identity, job and kept kit move onto this row, and the row
-- they came from is emptied (never removed -- table.remove would shift every
-- later bed_nr in the plot out from under its resident). This is how a bed that
-- has been carried to a new spot gets reconnected to the person who sleeps in it,
-- and how a villager whose row was cleared out from under them (leaving them
-- loaded but homeless) is made a resident again.
function settlement.rebind_villager(pname, ent)
	local e = settlement.editing[pname]
	if not e then return false end
	local bed = home.bed_data(e.town_id, e.plot_nr, e.bed_nr)
	if not bed or not ent or not home.is_villager(ent) then return false end

	-- The row they point at now, unless it already is this bed. Kept so the job
	-- and gear it holds travel across before it is vacated.
	local old = home.bed_data(ent.vl.v, ent.vl.p, ent.vl.b)
	if old == bed then old = nil end

	local id = identity_of(ent)

	-- clear_bed leaves the node's own x/y/z/p2/bnr in place, so this stamps the
	-- person onto the bed without disturbing where the bed is.
	clear_bed(bed)
	bed.first_name = id.name
	bed.title = id.title
	bed.gender = id.gender
	bed.generation = id.generation
	bed.species = id.species

	if old then
		bed.works_at, bed.workplace = old.works_at, old.workplace
		if old.work_pos then
			bed.work_pos = {x = old.work_pos.x, y = old.work_pos.y, z = old.work_pos.z}
		end
		bed.work_facing = old.work_facing
		bed.weapon, bed.armor = old.weapon, old.armor
		clear_bed(old)
	end

	-- Last-ditch kit rescue: if no row carried a weapon (the row was already
	-- wiped from under a still-loaded mob), recover the blade it is visibly still
	-- holding -- the only place that name survives once the row is gone.
	if not bed.weapon and ent._vl_wield_item and ent._vl_wield_item ~= "" then
		bed.weapon = ent._vl_wield_item
	end

	-- Drop the stale roster entry under the old key, then point the mob at this
	-- bed. home.bind clears its cached resolution, so a loaded villager re-reads
	-- its home on the next think rather than waiting for a reload.
	home.check_out(ent)
	home.bind(ent, e.town_id, e.plot_nr, e.bed_nr)
	if village_life.companion and village_life.companion.update_visuals then
		village_life.companion.update_visuals(ent)
	end
	save()
	return true, id.name
end

-- The end of the "come and live in my town" negotiation. `mode` is "follow"
-- (walk there at your side, settle when told to a bed) or "travel" (leave now,
-- turn up by the reserved bed in a day or three).
function settlement.take_resident(self, pname, mode)
	local near = self.object and self.object:get_pos()
	local town_id, plot_nr, bed_nr = settlement.recruit_town(pname, near)
	if not town_id then
		return false, "You've nowhere ready for me. Set a bed aside first."
	end

	if mode == "follow" then
		if not village_life.companion.engage(self, pname) then
			return false, "I would, but I've nowhere to be leaving from."
		end
		return true, "follow"
	end

	-- Travel. Reserve the bed with their identity and an arrival a day or three
	-- off; the census brings them in once the day comes (see census.lua).
	local bed = home.bed_data(town_id, plot_nr, bed_nr)
	if not bed then return false, "Your town's records are in a muddle." end

	local id = identity_of(self)
	vacate_origin(self)

	bed.first_name = id.name
	bed.title = id.title
	bed.gender = id.gender
	bed.generation = id.generation
	-- The species the census must revive them as. nil / the pigman name both mean
	-- the ordinary pigman villager; anything else is a recruited wandering trader.
	bed.species = id.species
	bed.vacant = nil
	bed.public = nil
	bed.away = nil
	bed.dead = nil
	bed.arrive_day = today() + math.random(1, 3)
	save()

	-- Remove the walking body on the next step rather than in the middle of the
	-- dialogue callback that is still holding it -- a removed entity mid-repaint
	-- is the frozen-window bug by another road.
	local obj = self.object
	minetest.after(0, function() if obj then obj:remove() end end)
	return true, "travel"
end

--------------------------------------------------------------------------------
-- GUIs
--------------------------------------------------------------------------------

local esc = minetest.formspec_escape

-- Per-player editing context: which town/plot/bed a punch opened, plus the
-- companion shortlist a bed form drew (resolved by index on click, never rebuilt).
settlement.editing = {}

local FORM_BED = "village_life:settle_bed"
local FORM_DOOR = "village_life:settle_door"
local FORM_TOWN = "village_life:settle_town"
local FORM_WORK = "village_life:settle_work"

-- Every named resident of a town, as {plot_nr, bed_nr, bed}. A named bed is a
-- person (living there, or on the road to it); a vacant, public or "Home of me"
-- bed is not a resident.
local function residents_of(v)
	local out = {}
	for pnr, bpos in ipairs(v.to_add_data.bpos) do
		for bnr, bed in ipairs(bpos.beds or {}) do
			if bed.first_name then
				out[#out + 1] = {plot_nr = pnr, bed_nr = bnr, bed = bed}
			end
		end
	end
	return out
end

local function same_pos(a, b)
	return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function occupant_line(bed)
	if bed.arrive_day then
		local days = bed.arrive_day - today()
		return ("%s (travelling -- %s)"):format(bed.first_name or "Someone",
				days > 1 and (days .. " days off") or "due any day")
	end
	if bed.first_name then return bed.first_name .. (bed.title and (", " .. bed.title) or "") end
	if bed.player_owner then return "Home of " .. bed.player_owner end
	if bed.public then return "Public / spare" end
	if bed.vacant then return "Vacant (kept for a newcomer)" end
	return "Empty"
end

function settlement.show_bed_gui(pname)
	local e = settlement.editing[pname]
	if not e then return end
	local v = mg_villages.all_villages[e.town_id]
	local bed = v and home.bed_data(e.town_id, e.plot_nr, e.bed_nr)
	if not bed then return end

	local player = minetest.get_player_by_name(pname)
	e.comps = player and settlement.following_companions(pname,
			player:get_pos()) or {}
	-- Villagers of this town standing by the bed, offered for rebinding: a moved
	-- bed's resident, or someone left homeless by an earlier edit (resolved by
	-- index on click, never rebuilt -- the same contract as the companion list).
	e.locals = settlement.rebindable_near(bed, e.town_id)

	-- Body first, height last: size[] does not clip, so a companion list that
	-- runs past a fixed height would draw its buttons off the window. Grow the
	-- form to whatever the content needs instead.
	local body = {
		("label[0.5,0.6;%s]"):format(esc("A bed in " .. (v.name or "your town"))),
		("label[0.5,1.1;%s]"):format(esc("Sleeps here now: " .. occupant_line(bed))),
		"button[0.5,1.6;7,0.7;vacant;Keep vacant for a newcomer]",
		("button[0.5,2.5;7,0.7;mine;Home of %s (that's me)]"):format(esc(pname)),
		"button[0.5,3.4;7,0.7;public;A public / spare bed]",
		"button[0.5,4.3;7,0.7;clear;Clear this bed]",
	}

	local y = 5.4
	if #e.comps > 0 then
		body[#body + 1] = ("label[0.5,%s;%s]"):format(y,
				esc("Settle someone walking with you:"))
		y = y + 0.5
		for i, ent in ipairs(e.comps) do
			body[#body + 1] = ("button[0.5,%s;7,0.7;comp_%d;%s]"):format(y, i,
					esc("Settle " .. (ent.game_name or "your companion") .. " here"))
			y = y + 0.9
		end
	end

	if #e.locals > 0 then
		body[#body + 1] = ("label[0.5,%s;%s]"):format(y,
				esc("Make this bed the home of a villager standing here:"))
		y = y + 0.5
		for i, l in ipairs(e.locals) do
			body[#body + 1] = ("button[0.5,%s;7,0.7;rebind_%d;%s]"):format(y, i,
					esc("This is " .. l.name .. "'s bed"))
			y = y + 0.9
		end
	end

	body[#body + 1] = ("button_exit[0.5,%s;7,0.7;done;Done]"):format(y + 0.2)
	local height = y + 1.2
	minetest.show_formspec(pname, FORM_BED, table.concat({
		"formspec_version[4]",
		("size[8,%s]"):format(height),
		table.concat(body),
	}))
end

function settlement.show_door_gui(pname)
	local e = settlement.editing[pname]
	if not e then return end
	local v = mg_villages.all_villages[e.town_id]
	local bpos = v and v.to_add_data.bpos[e.plot_nr]
	if not bpos then return end

	local body = {
		("label[0.5,0.6;%s]"):format(esc("This house in " .. (v.name or "your town"))),
		("label[0.5,1.1;%s]"):format(esc("Who lives here:")),
	}
	local y = 1.6
	local any = false
	for _, bed in ipairs(bpos.beds or {}) do
		body[#body + 1] = ("label[0.7,%s;%s]"):format(y, esc("- " .. occupant_line(bed)))
		y = y + 0.4
		any = true
	end
	if not any then
		body[#body + 1] = ("label[0.7,%s;%s]"):format(y,
				esc("- nobody yet; dedicate its beds"))
		y = y + 0.4
	end
	y = y + 0.3
	body[#body + 1] = ("button[0.5,%s;7,0.7;public;%s]"):format(y,
			bpos.public and "Stop it being a public space" or "Mark as a public space")
	body[#body + 1] = ("button_exit[0.5,%s;7,0.7;done;Done]"):format(y + 0.9)
	minetest.show_formspec(pname, FORM_DOOR, table.concat({
		"formspec_version[4]",
		("size[8,%s]"):format(y + 2.0),
		table.concat(body),
	}))
end

function settlement.show_overview(pname, town_id)
	local v = mg_villages.all_villages[town_id]
	if not v then return end
	local residents, incoming = {}, {}
	for _, bpos in ipairs(v.to_add_data.bpos) do
		for _, bed in ipairs(bpos.beds or {}) do
			if bed.arrive_day then
				incoming[#incoming + 1] = bed.first_name or "Someone"
			elseif bed.first_name then
				residents[#residents + 1] = bed.first_name
			end
		end
	end

	settlement.editing[pname] = {town_id = town_id, overview = true}

	local body = {
		("label[0.5,0.6;%s]"):format(esc("The settlement of " .. (v.name or "?"))),
		("label[0.5,1.1;%s]"):format(esc("Founded by " .. (v.founder or "?"))),
		("label[0.5,1.6;%s]"):format(esc(("Residents: %d    Vacant beds: %d")
				:format(#residents, vacancy_count(v)))),
	}
	local y = 2.2

	-- Who works where. Every named resident, and whether they have been given a
	-- workstation to spend their day at. This is where "Trader Throg has no
	-- workstation!" is said, and the node to fix it is handed out.
	local work = residents_of(v)
	local without = 0
	if #work > 0 then
		body[#body + 1] = ("label[0.5,%s;%s]"):format(y, esc("Work:"))
		y = y + 0.45
		for _, w in ipairs(work) do
			local b = w.bed
			local has = b.work_pos ~= nil
			if not has then without = without + 1 end
			local label = ("%s%s -- %s"):format(
					b.first_name or "Someone",
					b.title and (", " .. b.title) or "",
					has and "has a workstation" or "no workstation!")
			body[#body + 1] = ("label[0.7,%s;%s]"):format(y, esc("- " .. label))
			y = y + 0.4
		end
		y = y + 0.15
	end

	if #incoming > 0 then
		body[#body + 1] = ("label[0.5,%s;%s]"):format(y, esc("On the road: " ..
				table.concat(incoming, ", ")))
		y = y + 0.5
	end

	body[#body + 1] = ("button[0.5,%s;7,0.7;getwork;%s]"):format(y,
			esc(without > 0
					and ("Give me a workstation node (%d need one)"):format(without)
					or "Give me a workstation node"))
	y = y + 0.95
	body[#body + 1] = ("label[0.5,%s;%s]"):format(y, esc(
			"Place it, then punch it with the deed to say who works there."))
	y = y + 0.5
	body[#body + 1] = ("label[0.5,%s;%s]"):format(y, esc(
			"Punch a bed to say who sleeps in it; a door to see a house."))
	y = y + 0.6
	body[#body + 1] = ("button_exit[0.5,%s;7,0.7;done;Done]"):format(y)

	minetest.show_formspec(pname, FORM_TOWN, table.concat({
		"formspec_version[4]",
		("size[8,%s]"):format(y + 1.0),
		table.concat(body),
	}))
end

-- Give the founder one workstation node to place.
function settlement.give_workstation(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return end
	local stack = ItemStack("village_life:workstation")
	local inv = player:get_inventory()
	if inv:room_for_item("main", stack) then
		inv:add_item("main", stack)
		minetest.chat_send_player(pname, "[Deed] A workstation. Place it where "
				.. "someone should work, then punch it with the deed to say who.")
	else
		minetest.add_item(player:get_pos(), stack)
		minetest.chat_send_player(pname,
				"[Deed] Your pack is full -- the workstation is at your feet.")
	end
end

--------------------------------------------------------------------------------
-- Assigning a workstation to a resident
--------------------------------------------------------------------------------

-- Whoever currently works at `wp` in town `v`, cleared. Returns the bed's
-- (plot_nr, bed_nr) so the caller can wake the resident to their new lack of a
-- job, or nil if the tile was unclaimed.
local function clear_worker_at(v, wp)
	for pnr, bpos in ipairs(v.to_add_data.bpos) do
		for bnr, bed in ipairs(bpos.beds or {}) do
			if same_pos(bed.work_pos, wp) then
				bed.work_pos, bed.work_facing = nil, nil
				return pnr, bnr
			end
		end
	end
end

-- Stamp the workstation node's meta with the bed it serves, so digging it can
-- release that bed, and label it for the world to read.
local function mark_workstation(wp, town_id, plot_nr, bed_nr, who)
	local meta = minetest.get_meta(wp)
	if plot_nr then
		meta:set_string("town_id", town_id)
		meta:set_int("plot_nr", plot_nr)
		meta:set_int("bed_nr", bed_nr)
		meta:set_string("infotext", "Workplace of " .. (who or "someone"))
	else
		meta:set_string("town_id", "")
		meta:set_string("plot_nr", "")
		meta:set_string("bed_nr", "")
		meta:set_string("infotext", "Workstation (unassigned)")
	end
end

function settlement.punch_workstation(pname, pos)
	local v, town_id = settlement.town_at(pos, pname, 64)
	if not v then
		minetest.chat_send_player(pname, "[Deed] That workstation isn't in one of "
				.. "your towns. Found a settlement nearby first.")
		return
	end
	settlement.editing[pname] = {
		town_id = town_id,
		work_pos = {x = iround(pos.x), y = iround(pos.y), z = iround(pos.z)},
	}
	settlement.show_work_gui(pname)
end

function settlement.show_work_gui(pname)
	local e = settlement.editing[pname]
	if not e or not e.work_pos then return end
	local v = mg_villages.all_villages[e.town_id]
	if not v then return end

	local wp = e.work_pos
	e.workers = residents_of(v)     -- resolved by index on click, never rebuilt

	local current
	for _, w in ipairs(e.workers) do
		if same_pos(w.bed.work_pos, wp) then current = w.bed.first_name end
	end

	local body = {
		("label[0.5,0.6;%s]"):format(esc("A workstation in " .. (v.name or "your town"))),
		("label[0.5,1.1;%s]"):format(esc("Worked by now: " .. (current or "nobody"))),
		("label[0.5,1.7;%s]"):format(esc("Set who works here:")),
	}
	local y = 2.2
	if #e.workers == 0 then
		body[#body + 1] = ("label[0.7,%s;%s]"):format(y,
				esc("- nobody lives here yet; dedicate a bed first"))
		y = y + 0.5
	end
	for i, w in ipairs(e.workers) do
		local b = w.bed
		local note = ""
		if same_pos(b.work_pos, wp) then note = "  (works here)"
		elseif b.work_pos then note = "  (has another workstation)" end
		body[#body + 1] = ("button[0.5,%s;7,0.7;assign_%d;%s]"):format(y, i,
				esc(("%s%s%s"):format(b.first_name or "Someone",
						b.title and (", " .. b.title) or "", note)))
		y = y + 0.9
	end
	if current then
		body[#body + 1] = ("button[0.5,%s;7,0.7;clearwork;%s]"):format(y,
				esc("No one works here"))
		y = y + 0.9
	end
	body[#body + 1] = ("button_exit[0.5,%s;7,0.7;done;Done]"):format(y + 0.2)

	minetest.show_formspec(pname, FORM_WORK, table.concat({
		"formspec_version[4]",
		("size[8,%s]"):format(y + 1.4),
		table.concat(body),
	}))
end

--------------------------------------------------------------------------------
-- Punch handlers
--------------------------------------------------------------------------------

function settlement.punch_ground(pname, pointed_thing)
	local pos = pointed_thing.under
	local _, town_id = settlement.town_at(pos, pname, 8)
	if town_id then
		settlement.show_overview(pname, town_id)
		return
	end

	local deed = settlement.deed_of(
			minetest.get_player_by_name(pname):get_wielded_item())
	local new_id, err = settlement.found(pname, pos, deed and deed.name)
	if not new_id then
		minetest.chat_send_player(pname, "[Deed] " .. tostring(err))
		return
	end

	local above = pointed_thing.above
	if minetest.get_node(above).name == "air" then
		minetest.set_node(above, {name = "village_life:foundation_stone"})
		local meta = minetest.get_meta(above)
		meta:set_string("town_id", new_id)
		meta:set_string("infotext", "Foundation of " .. (deed.name or "a settlement"))
	end
	minetest.chat_send_player(pname, ("[Deed] You found the settlement of %s. "
			.. "Dedicate the beds in the houses you build by punching them with the deed.")
			:format(deed.name or "?"))
	settlement.show_overview(pname, new_id)
end

function settlement.punch_bed(pname, bed_pos)
	-- Generous margin: a house may sit right on the edge of the young town's
	-- circle, and dedicating the bed is what grows the circle to include it.
	local v, town_id = settlement.town_at(bed_pos, pname, 64)
	if not v then
		-- Not in one of your towns -- but perhaps in a plot you have bought. A
		-- bought plot's beds are furnished and staffed the same way, written to the
		-- plot's own village so the census spawns whoever you settle there.
		local ov, oid, opnr, obnr = owned_bed_at(pname, bed_pos)
		if ov then
			settlement.editing[pname] = {
				town_id = oid, plot_nr = opnr, bed_nr = obnr, bought = true}
			save()
			settlement.show_bed_gui(pname)
			return
		end
		minetest.chat_send_player(pname, "[Deed] Found a settlement first -- "
				.. "punch the ground with the deed.")
		return
	end
	local plot_nr = find_or_make_bpos(v, bed_pos)
	local bed_nr = find_or_make_bed(v.to_add_data.bpos[plot_nr], bed_pos)
	expand_town(v, bed_pos)
	save()
	settlement.editing[pname] = {town_id = town_id, plot_nr = plot_nr, bed_nr = bed_nr}
	settlement.show_bed_gui(pname)
end

function settlement.punch_door(pname, door_pos)
	local v, town_id = settlement.town_at(door_pos, pname, 64)
	if not v then
		minetest.chat_send_player(pname, "[Deed] Found a settlement first -- "
				.. "punch the ground with the deed.")
		return
	end
	local plot_nr = nearest_plot(v, door_pos)
	if not plot_nr then
		minetest.chat_send_player(pname, "[Deed] No houses dedicated here yet. "
				.. "Punch the beds inside with the deed first.")
		return
	end
	settlement.editing[pname] = {town_id = town_id, plot_nr = plot_nr, door = true}
	settlement.show_door_gui(pname)
end

--------------------------------------------------------------------------------
-- The deed's on_use: dispatch a punch by what was punched
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	local def = minetest.registered_items["default:book_written"]
	if not def then return end
	local orig = def.on_use

	minetest.override_item("default:book_written", {
		on_use = function(itemstack, user, pointed_thing)
			-- Not a deed, or the feature is off: it is just a book.
			if not village_life.settings.settlement
					or not settlement.deed_of(itemstack)
					or not user or not user:is_player() then
				return orig and orig(itemstack, user, pointed_thing)
			end

			local pname = user:get_player_name()

			-- Punching air (or an entity): show the town overview if they are
			-- standing in one of their towns; otherwise it is just a book to
			-- read (founding is done by punching the ground).
			if not pointed_thing or pointed_thing.type ~= "node" then
				local _, town_id = settlement.town_at(user:get_pos(), pname, 32)
				if town_id then
					settlement.show_overview(pname, town_id)
					return itemstack
				end
				return orig and orig(itemstack, user, pointed_thing)
			end

			local node = minetest.get_node(pointed_thing.under)
			local groups = (minetest.registered_nodes[node.name]
					and minetest.registered_nodes[node.name].groups) or {}
			if node.name == "village_life:workstation" then
				settlement.punch_workstation(pname, pointed_thing.under)
			elseif (groups.bed or 0) > 0 then
				settlement.punch_bed(pname, pointed_thing.under)
			elseif (groups.door or 0) > 0 then
				settlement.punch_door(pname, pointed_thing.under)
			else
				settlement.punch_ground(pname, pointed_thing)
			end
			return itemstack
		end,
	})

	village_life.log("action", "settlement deed attached to default:book_written")
end)

--------------------------------------------------------------------------------
-- Form handling
--------------------------------------------------------------------------------

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local pname = player:get_player_name()
	local e = settlement.editing[pname]

	if formname == FORM_BED then
		if not e then return true end
		local v = mg_villages.all_villages[e.town_id]
		local bed = v and home.bed_data(e.town_id, e.plot_nr, e.bed_nr)
		if not bed then settlement.editing[pname] = nil return true end

		if fields.vacant then
			clear_bed(bed) ; bed.vacant = true
		elseif fields.mine then
			clear_bed(bed) ; bed.player_owner = pname
		elseif fields.public then
			clear_bed(bed) ; bed.public = true
		elseif fields.clear then
			clear_bed(bed)
		else
			local handled = false
			for i in pairs(e.comps or {}) do
				if fields["comp_" .. i] then
					local ent = e.comps[i]
					if ent and ent.object and ent.object:get_pos() then
						village_life.companion.settle(ent, e.town_id, e.plot_nr, e.bed_nr)
					end
					handled = true
					break
				end
			end
			if not handled then
				for i in pairs(e.locals or {}) do
					if fields["rebind_" .. i] then
						local l = e.locals[i]
						local ent = l and l.ent
						if ent and ent.object and ent.object:get_pos() then
							local ok, who = settlement.rebind_villager(pname, ent)
							if ok then
								minetest.chat_send_player(pname, ("[Deed] %s lives here now.")
										:format(who or "They"))
							end
						end
						break
					end
				end
			end
		end

		save()
		if fields.quit or fields.done then
			settlement.editing[pname] = nil
		else
			settlement.show_bed_gui(pname)
		end
		return true

	elseif formname == FORM_DOOR then
		if not e then return true end
		local v = mg_villages.all_villages[e.town_id]
		local bpos = v and v.to_add_data.bpos[e.plot_nr]
		if not bpos then settlement.editing[pname] = nil return true end
		if fields.public then
			bpos.public = not bpos.public
			save()
		end
		if fields.quit or fields.done then
			settlement.editing[pname] = nil
		else
			settlement.show_door_gui(pname)
		end
		return true

	elseif formname == FORM_TOWN then
		if fields.getwork and e and e.town_id then
			settlement.give_workstation(pname)
			-- Repaint so the count and instructions stay put; the node is in hand.
			settlement.show_overview(pname, e.town_id)
			return true
		end
		if fields.quit or fields.done then settlement.editing[pname] = nil end
		return true

	elseif formname == FORM_WORK then
		if not e or not e.work_pos then settlement.editing[pname] = nil return true end
		local v = mg_villages.all_villages[e.town_id]
		if not v then settlement.editing[pname] = nil return true end
		local wp = e.work_pos

		-- The node must still be there. If the player dug it between opening the
		-- form and clicking, do nothing rather than assign a job to empty air.
		local node = minetest.get_node(wp)
		local still_there = node.name == "village_life:workstation"

		if fields.clearwork and still_there then
			local pnr, bnr = clear_worker_at(v, wp)
			if pnr then home.reresolve(e.town_id, pnr, bnr) end
			mark_workstation(wp, e.town_id, nil)
			save()
		elseif still_there then
			for i in pairs(e.workers or {}) do
				if fields["assign_" .. i] then
					local w = e.workers[i]
					if w then
						-- One workstation, one worker: free whoever stood here, and
						-- take this worker off any station they held elsewhere.
						local opnr, obnr = clear_worker_at(v, wp)
						if opnr then home.reresolve(e.town_id, opnr, obnr) end
						if w.bed.work_pos then
							-- Blank the label on their old node if it is loaded.
							local old = w.bed.work_pos
							if minetest.get_node(old).name == "village_life:workstation" then
								mark_workstation(old, e.town_id, nil)
							end
						end
						w.bed.work_pos = {x = wp.x, y = wp.y, z = wp.z}
						w.bed.work_facing = node.param2 or 0
						home.reresolve(e.town_id, w.plot_nr, w.bed_nr)
						mark_workstation(wp, e.town_id, w.plot_nr, w.bed_nr,
								w.bed.first_name)
						save()
					end
					break
				end
			end
		end

		if fields.quit or fields.done then
			settlement.editing[pname] = nil
		else
			settlement.show_work_gui(pname)
		end
		return true
	end
end)

minetest.register_on_leaveplayer(function(player)
	settlement.editing[player:get_player_name()] = nil
end)

--------------------------------------------------------------------------------
-- The foundation stone
--------------------------------------------------------------------------------

minetest.register_node("village_life:foundation_stone", {
	description = "Town Foundation Stone",
	tiles = {"default_stone_block.png^[colorize:#e8b84055"},
	groups = {cracky = 3, not_in_creative_inventory = 1},
	is_ground_content = false,
	sounds = default and default.node_sound_stone_defaults and
			default.node_sound_stone_defaults() or nil,

	on_rightclick = function(pos, node, clicker)
		if not clicker or not clicker:is_player() then return end
		local town_id = minetest.get_meta(pos):get_string("town_id")
		if town_id ~= "" and mg_villages.all_villages[town_id] then
			settlement.show_overview(clicker:get_player_name(), town_id)
		end
	end,

	-- Only the founder may pull it up, and doing so unmakes the town.
	can_dig = function(pos, player)
		if not player then return false end
		local town_id = minetest.get_meta(pos):get_string("town_id")
		local v = town_id ~= "" and mg_villages.all_villages[town_id]
		if not v then return true end
		return v.founder == player:get_player_name()
	end,

	after_dig_node = function(pos, oldnode, oldmeta)
		local town_id = oldmeta and oldmeta.fields and oldmeta.fields.town_id
		if town_id and town_id ~= "" then settlement.dissolve(town_id) end
	end,
})

--------------------------------------------------------------------------------
-- The workstation
--------------------------------------------------------------------------------

-- A place a player-town resident spends their working day. mg_villages builds
-- these into its schematics as invisible markers a mob stands on; a player town
-- has no schematics, so the founder plants this node by hand and names who works
-- there by punching it with the deed. It is non-walkable (the worker stands on
-- the tile, facing the way it was placed, exactly as it would at a schematic
-- marker), and it releases its worker when dug.
minetest.register_node("village_life:workstation", {
	description = "Village Workstation",
	drawtype = "nodebox",
	tiles = {
		"default_wood.png^[colorize:#7a4a1e40",
		"default_wood.png",
		"default_wood.png^[colorize:#00000018",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, -0.4, 0.5},        -- a flat pad
			{-0.5, -0.4, -0.5, -0.4,  0.0, 0.5},        -- a low upright, the "bench"
			{-0.4, -0.15, -0.4, 0.5, -0.05, 0.4},       -- its worktop
		},
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default and default.node_sound_wood_defaults
			and default.node_sound_wood_defaults() or nil,

	on_construct = function(pos)
		minetest.get_meta(pos):set_string("infotext", "Workstation (unassigned)")
	end,

	-- Right-clicking with the deed in hand opens the same assignment window the
	-- deed's on_use does; empty-handed it just says what it is.
	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker or not clicker:is_player() then return itemstack end
		if village_life.settings.settlement and settlement.deed_of(itemstack) then
			settlement.punch_workstation(clicker:get_player_name(), pos)
		end
		return itemstack
	end,

	-- Dug: release whoever worked here, if the bed still points at this tile.
	after_dig_node = function(pos, oldnode, oldmeta)
		local f = oldmeta and oldmeta.fields or {}
		local town_id = f.town_id
		local plot_nr = tonumber(f.plot_nr)
		local bed_nr = tonumber(f.bed_nr)
		if town_id and town_id ~= "" and plot_nr and bed_nr then
			local bed = home.bed_data(town_id, plot_nr, bed_nr)
			local wp = {x = iround(pos.x), y = iround(pos.y), z = iround(pos.z)}
			if bed and bed.work_pos and bed.work_pos.x == wp.x
					and bed.work_pos.y == wp.y and bed.work_pos.z == wp.z then
				bed.work_pos, bed.work_facing = nil, nil
				home.reresolve(town_id, plot_nr, bed_nr)
				save()
			end
		end
	end,
})
