-- Binding a villager to the village data mg_villages already computed.
--
-- mg_villages stores, per village, a `to_add_data.bpos` list of plots. Each
-- plot that has beds carries a `beds` array where entry i is the mob sleeping
-- in bed i: its name, gender, generation, profession title, which plot it
-- works at (`works_at`) and which workplace marker in that plot (`workplace`).
-- The building type's schematic analysis (analyze_building_for_mobs.lua)
-- contributes `bed_list`, `stand_next_to_bed_list`, `workplace_list`,
-- `front_door_list` and `all_entrances` in schematic-local coordinates, plus
-- precomputed door->bed and door->workplace paths in `mg_villages.path_info`.
--
-- All of it was write-only. This module turns a (village, plot, bed) triple
-- into world positions and paths, and keeps a roster of which villagers are
-- currently alive so the census can tell who is missing.

local util = village_life.util
local home = {}
village_life.home = home

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

function home.key(village_id, plot_nr, bed_nr)
	return village_id .. "/" .. plot_nr .. "/" .. bed_nr
end

-- The only thing written onto the entity itself, and therefore the only thing
-- serialised into the mapblock. Everything else is derived on demand and kept
-- in the weak scratch table.
function home.bind(self, village_id, plot_nr, bed_nr)
	self.vl = {v = village_id, p = plot_nr, b = bed_nr}
	local s = util.scratch(self)
	s.resolved = nil
	s.resolve_retry = nil
end

function home.is_villager(self)
	return self.vl ~= nil and self.vl.v ~= nil
end

--------------------------------------------------------------------------------
-- Village lookups
--------------------------------------------------------------------------------

function home.village(village_id)
	return mg_villages.all_villages and mg_villages.all_villages[village_id]
end

function home.plot(village_id, plot_nr)
	local village = home.village(village_id)
	if not village or not village.to_add_data then return end
	return village.to_add_data.bpos[plot_nr]
end

function home.bed_data(village_id, plot_nr, bed_nr)
	local bpos = home.plot(village_id, plot_nr)
	if not bpos or not bpos.beds then return end
	return bpos.beds[bed_nr]
end

-- Which village contains this position? Villages are circles of radius `vs`
-- around (vx, vz). The margin lets a mob a little way outside the nominal
-- radius still count as "at home", because plots sit right on the edge.
function home.village_at(pos, margin, max_dy)
	margin = margin or 24
	if not mg_villages.all_villages then return end
	local best, best_id, best_d
	for id, village in pairs(mg_villages.all_villages) do
		if village.vx and village.vz then
			local dx, dz = pos.x - village.vx, pos.z - village.vz
			local d = math.sqrt(dx * dx + dz * dz)
			local reach = (village.vs or 30) + margin
			local vertical_ok = true
			if max_dy and village.vh then
				vertical_ok = math.abs(pos.y - village.vh) <= max_dy
			end
			if vertical_ok and d <= reach and (not best_d or d < best_d) then
				best, best_id, best_d = village, id, d
			end
		end
	end
	return best, best_id, best_d
end

function home.village_centre(village)
	return {x = village.vx, y = village.vh or 0, z = village.vz}
end

-- Every village within `range` of a position, as {id = village}.
--
-- all_villages grows with exploration, so anything that asks "which village is
-- this?" once per object per second has to work from a shortlist built once
-- per scan rather than sweeping the whole table each time.
function home.villages_near(pos, range, into)
	local out = into or {}
	if not mg_villages.all_villages then return out end
	for id, village in pairs(mg_villages.all_villages) do
		if not out[id] and village.vx and village.vz then
			local dx, dz = pos.x - village.vx, pos.z - village.vz
			local reach = (village.vs or 30) + range
			if dx * dx + dz * dz <= reach * reach then
				out[id] = village
			end
		end
	end
	return out
end

-- Which of an already-shortlisted set of villages contains this position.
--
-- `max_dy` bounds the answer vertically against the village's build height.
-- Villages sit on the surface and this game's caves are full of monsters; with
-- no height check a zombie forty nodes underground counts as "in the village"
-- and the whole place goes into lockdown, permanently, because there is always
-- something down there.
function home.village_in(shortlist, pos, margin, max_dy)
	margin = margin or 24
	local best_id, best_d
	for id, village in pairs(shortlist) do
		local dx, dz = pos.x - village.vx, pos.z - village.vz
		local d = math.sqrt(dx * dx + dz * dz)
		local vertical_ok = true
		if max_dy and village.vh then
			vertical_ok = math.abs(pos.y - village.vh) <= max_dy
		end
		if vertical_ok and d <= (village.vs or 30) + margin
				and (not best_d or d < best_d) then
			best_id, best_d = id, d
		end
	end
	return best_id
end

--------------------------------------------------------------------------------
-- Paths stored by mg_villages
--------------------------------------------------------------------------------

-- mg_villages.get_path_from_bed_to_outside() only knows about beds. The same
-- table holds workplace paths under a "|WORKPLACE" suffix, so this is that
-- function generalised over the suffix and given a safer fallback.
--
-- path_info[key][door_nr] is a list of paths, one per bed/workplace, with one
-- extra entry at the end: the shared run from the front door out to the street.
local function stored_path(village_id, plot_nr, index, door_nr, suffix)
	local res = mg_villages.get_plot_and_building_data(village_id, plot_nr)
	if not res or not res.building_data or not res.building_data.short_file_name then
		return
	end
	local key = res.building_data.short_file_name .. (suffix or "")
	local info = mg_villages.path_info and mg_villages.path_info[key]
	if not info or not info[door_nr] or not info[door_nr][index] then return end

	local path = {}
	for _, p in ipairs(info[door_nr][index]) do
		table.insert(path, mg_villages.transform_coordinates(p, res.bpos))
	end

	-- The last entry in the door's list is the common tail from the door to
	-- the street; append it unless we *are* that entry.
	local tail = #info[door_nr]
	if tail ~= index then
		for _, p in ipairs(info[door_nr][tail]) do
			table.insert(path, mg_villages.transform_coordinates(p, res.bpos))
		end
	end
	return path
end

local function reversed(path)
	if not path then return end
	local out = {}
	for i = #path, 1, -1 do out[#out + 1] = path[i] end
	return out
end

-- Inside-out and outside-in paths for a bed or a workplace. door_nr 1 is the
-- main front door and is what almost every building has.
function home.path_out(village_id, plot_nr, index, kind, door_nr)
	return stored_path(village_id, plot_nr, index, door_nr or 1,
			kind == "workplace" and "|WORKPLACE" or nil)
end

function home.path_in(village_id, plot_nr, index, kind, door_nr)
	return reversed(home.path_out(village_id, plot_nr, index, kind, door_nr))
end

--------------------------------------------------------------------------------
-- Resolving a villager's world positions
--------------------------------------------------------------------------------

-- transform_coordinates returns nil for a malformed entry, and indexes
-- BUILDINGS[bpos.btype].yoff, so both have to be known good before we call it.
local function transform(bpos, xyz)
	if not bpos or not bpos.btype or not mg_villages.BUILDINGS[bpos.btype] then
		return
	end
	if type(xyz) ~= "table" or not xyz[1] or not xyz[2] or not xyz[3] then
		return
	end
	return mg_villages.transform_coordinates({xyz[1], xyz[2], xyz[3], xyz[4]}, bpos)
end

-- How long a failed resolve is trusted before trying again.
local RESOLVE_RETRY = 10

-- Everything a brain needs about where this villager belongs, computed once
-- per activation and cached off-entity.
--
-- Returns nil when the village data is missing, which happens legitimately:
-- a pigman trader from a spawn egg has no plot, and a village whose data file
-- predates this mod may have been generated without bed assignments.
--
-- A failure is cached only briefly, never permanently. A villager spawned
-- during the mapgen pass that creates its own village resolves against an
-- all_villages entry that does not exist *yet* -- mg_villages writes it a few
-- lines later in the same call -- and a sticky negative would leave that
-- villager brainless for the life of the world.
function home.resolve(self)
	if not home.is_villager(self) then return end
	local s = util.scratch(self)
	if s.resolved then return s.resolved end
	if s.resolve_retry and util.now() < s.resolve_retry then return end

	local id, plot_nr, bed_nr = self.vl.v, self.vl.p, self.vl.b
	local bpos = home.plot(id, plot_nr)
	local bed = home.bed_data(id, plot_nr, bed_nr)
	if not bpos or not bed then
		s.resolve_retry = util.now() + RESOLVE_RETRY
		return
	end

	local building = mg_villages.BUILDINGS[bpos.btype]
	local r = {
		village_id = id,
		plot_nr    = plot_nr,
		bed_nr     = bed_nr,
		bpos       = bpos,
		bed        = bed,
		btype      = bpos.btype,
		building   = building,
		title      = bed.title,
		generation = bed.generation,
		gender     = bed.gender,
		name       = bed.first_name,
		bed_pos    = {x = bed.x, y = bed.y, z = bed.z},
	}

	-- Where the mob stands when getting in or out of bed. Beds are not
	-- standable, so this is the real sleep destination.
	if building and building.stand_next_to_bed_list then
		r.sleep_pos = transform(bpos, building.stand_next_to_bed_list[bed_nr])
	end
	r.sleep_pos = r.sleep_pos or util.find_standing_near(r.bed_pos, 2) or r.bed_pos

	-- Doors and the spot just outside them.
	r.doors = mg_villages.inhabitants.get_front_doors(bpos) or {}
	r.entrances = mg_villages.get_entrance_list(id, plot_nr) or {}

	-- Workplace: may be in a different plot entirely (a smith lives in a
	-- house and works at the forge), which is exactly why the forge stood
	-- empty before.
	if bed.works_at and bed.workplace and bed.workplace > 0 then
		local wbpos = home.plot(id, bed.works_at)
		local wbuilding = wbpos and mg_villages.BUILDINGS[wbpos.btype]
		local list = wbuilding and wbuilding.workplace_list
		local work_pos = list and list[bed.workplace]
				and transform(wbpos, list[bed.workplace])
		if work_pos then
			r.work_plot = bed.works_at
			r.work_index = bed.workplace
			r.work_pos = work_pos
			r.work_bpos = wbpos
			r.work_doors = mg_villages.inhabitants.get_front_doors(wbpos) or {}
			r.work_entrances = mg_villages.get_entrance_list(id, bed.works_at) or {}
			-- param2 of the marker tells us which way the mob should face
			-- while working, so a shopkeeper looks over the counter rather
			-- than at the wall behind it.
			r.work_facing = work_pos.p2
		end
	end

	-- A player-town resident works at a workstation the founder placed and
	-- assigned by hand: a real node in the world, not a schematic marker, so it is
	-- stored as a plain position on the bed row (settlement.lua). Take it only if
	-- the schematic path above found nothing -- a mapgen villager keeps its marker.
	if not r.work_pos and bed.work_pos then
		r.work_pos = {x = bed.work_pos.x, y = bed.work_pos.y, z = bed.work_pos.z}
		r.work_facing = bed.work_facing
		-- No plot or marker index: the schedule treats this as an open-air
		-- destination it can walk straight to (see schedule.goal_work).
		r.work_hand_placed = true
	end

	-- Plot centre, used as a loitering anchor for villagers with no job.
	r.plot_centre = {
		x = bpos.x + math.floor((bpos.bsizex or 1) / 2),
		y = bpos.y,
		z = bpos.z + math.floor((bpos.bsizez or 1) / 2),
	}

	local village = home.village(id)
	if village then
		r.village = village
		r.centre = home.village_centre(village)
		r.radius = village.vs or 30
	end

	r.role = home.role(r)

	-- A stable personal offset on the daily timetable, in hours. Computed once
	-- here rather than in schedule.decide, which runs every couple of seconds
	-- for every villager and would otherwise build a generator each time.
	local rng = util.rng("wake", id, plot_nr, bed_nr)
	r.hour_offset = util.rng_float(rng, -0.75, 0.75)

	-- Whether this villager minds ordinary rain and snow. Fixed per villager,
	-- not rolled per decision: a coin flip inside schedule.decide alternates
	-- the goal every couple of seconds, and the villager spends the whole
	-- shower walking back and forth through its own front door.
	r.hardy = rng:next(0, 99) < 55

	s.resolved = r
	return r
end

-- mg_villages only titles the household's worker. Everyone else -- wives,
-- children, grandparents, inn guests -- has no title at all, which is why they
-- all behaved identically. Give them a role so the schedule can differ.
function home.role(r)
	local title = r.title
	if title then
		if title == "guard" or title == "soldier" then return "guard" end
		if title == "guest" then return "guest" end
		if title == "servant" or title == "housemaid" then return "servant" end
		-- Redeemed beastmen and recruited buff-pigman champions defend their town:
		-- hunters, barbarians, the fearsome "monster" and the champion all route
		-- through the guard step and fight for it. A settled veteran is a retired
		-- guardsman who still hunts (adventurer.lua) -- it defends the town too.
		if title == "hunter" or title == "barbarian" or title == "monster"
				or title == "champion" or title == "veteran" then
			return "guard"
		end
		return "worker"
	end
	if r.generation == 1 then return "child" end
	if r.generation == 3 then return "elder" end
	return "homemaker"
end

-- Killing a guard costs less standing than killing a baker: they were armed
-- and it was a fight. Kept here because role resolution lives here.
function home.is_guard_role(self)
	local r = home.resolve(self)
	return r ~= nil and r.role == "guard"
end

--------------------------------------------------------------------------------
-- Roster of living villagers
--------------------------------------------------------------------------------

-- key -> {obj = ObjectRef, seen = os.time()}. Refreshed by the brain, cleared
-- on death. The census treats an entry it has not seen for a while as stale
-- rather than deleting it eagerly, because a mob whose mapblock unloaded is
-- still alive and will come back with the block.
home.roster = {}

-- key -> os.time() at which a replacement may be spawned
home.pending = {}

function home.check_in(self)
	if not home.is_villager(self) then return end
	local k = home.key(self.vl.v, self.vl.p, self.vl.b)
	home.roster[k] = {obj = self.object, seen = os.time()}
	home.pending[k] = nil
end

function home.check_out(self, died)
	if not home.is_villager(self) then return end
	local k = home.key(self.vl.v, self.vl.p, self.vl.b)
	home.roster[k] = nil
	if died then
		home.pending[k] = os.time() + village_life.settings.respawn_delay
	end
end

-- Drop the cached resolution of whoever lives in this bed, if they are loaded,
-- so their next think re-reads the bed row. Used when the row changes under a
-- living villager -- assigning them a workstation, say -- which would otherwise
-- not be felt until the mob reloaded. Harmless if nobody is home.
function home.reresolve(village_id, plot_nr, bed_nr)
	local entry = home.roster[home.key(village_id, plot_nr, bed_nr)]
	local obj = entry and entry.obj
	local ent = obj and obj.get_luaentity and obj:get_luaentity()
	if ent then
		local s = util.scratch(ent)
		s.resolved = nil
		s.resolve_retry = nil
	end
end

-- Is someone alive in this bed right now? A roster entry whose ObjectRef has
-- gone invalid means the entity was removed without dying (mapblock unload,
-- /clearobjects), so drop it and report vacant -- the census will re-place a
-- villager, which is the correct outcome either way.
function home.occupied(village_id, plot_nr, bed_nr)
	local k = home.key(village_id, plot_nr, bed_nr)
	local entry = home.roster[k]
	if not entry then return false end
	if not entry.obj:get_pos() then
		home.roster[k] = nil
		return false
	end
	return true
end

--------------------------------------------------------------------------------
-- Spawning
--------------------------------------------------------------------------------

-- Choose where a villager first appears. Just outside its own front door if we
-- know where that is, so it does not materialise inside a wall or on a roof.
--
-- `bed` and `bpos` may be passed in by a caller that already has them. During
-- mapgen that is the only way to get them: see the spawn hook below.
function home.spawn_pos(village_id, plot_nr, bed_nr, bed, bpos)
	-- A player-founded town's plot is hand-built: no schematic, no entrance list
	-- and no front-of-house path. The honest spawn point is right beside the bed,
	-- so go straight there rather than through the village heuristics (which for a
	-- player_house resolve only to the plot corner, and only by luck). This is the
	-- "spawn beside their bed" a recruited resident turns up at.
	local village = home.village(village_id)
	bed = bed or home.bed_data(village_id, plot_nr, bed_nr)
	if bed and ((village and village.is_player_town)
			or (bpos and bpos.btype == "player_house")) then
		local p = util.find_standing_near({x = bed.x, y = bed.y + 1, z = bed.z}, 3)
		if p then return p end
		return {x = bed.x, y = bed.y + 1, z = bed.z}
	end

	local entrances = mg_villages.get_entrance_list(village_id, plot_nr)
	if entrances and entrances[1] then
		local p = util.find_standing_near(entrances[1], 2)
		if p then return p end
		return {x = entrances[1].x, y = entrances[1].y + 0.5, z = entrances[1].z}
	end

	-- No entrance list (village not registered yet). handle_schematics can
	-- still work out the doorstep from the plot alone; this is what
	-- mg_villages' own spawn code used before this mod took the hook over.
	if bpos and handle_schematics and handle_schematics.get_pos_in_front_of_house then
		local p = handle_schematics.get_pos_in_front_of_house(bpos, bed_nr)
		if p then
			return util.find_standing_near(p, 2) or {x = p.x, y = p.y + 0.5, z = p.z}
		end
	end

	bed = bed or home.bed_data(village_id, plot_nr, bed_nr)
	if bed then
		local p = util.find_standing_near({x = bed.x, y = bed.y + 1, z = bed.z}, 3)
		if p then return p end
		return {x = bed.x, y = bed.y + 1, z = bed.z}
	end
end

-- Spawn one bound villager. Returns the ObjectRef, or nil if the area is not
-- loaded (get_node returns "ignore") or the position could not be worked out.
function home.spawn(village_id, plot_nr, bed_nr, bed, bpos)
	bed = bed or home.bed_data(village_id, plot_nr, bed_nr)
	if not bed or not bed.first_name then return end

	local pos = home.spawn_pos(village_id, plot_nr, bed_nr, bed, bpos)
	if not pos or not util.is_loaded(pos) then return end

	local obj
	local species = bed.species
	if species and species ~= "lottmobs:pigman_trader" then
		-- A recruited wandering trader (dwarf/mung/human/elf) who travelled in:
		-- revive it as its own species, keeping the mob's own textures. No pigman
		-- skinning is applied -- apply_role's skin block is guarded to the pigman.
		obj = minetest.add_entity(pos, species)
	else
		obj = lottmobs.spawn_pigman_trader(pos, bed.title or "villager",
				bed.first_name, bed.gender or "m")
	end
	if not obj then return end

	local ent = obj:get_luaentity()
	if not ent then return end
	ent.profession = bed.title or ent.profession

	home.bind(ent, village_id, plot_nr, bed_nr)
	-- Stable across restarts, unlike the random id lottmobs assigns. The shop
	-- inventory and the RNG that stocks it both key off this.
	ent.id = "vl_" .. home.key(village_id, plot_nr, bed_nr)
	ent.game_name = bed.first_name
	home.check_in(ent)
	village_life.apply_role(ent)

	return obj
end

--------------------------------------------------------------------------------
-- Adoption
--------------------------------------------------------------------------------

-- Villagers that predate this mod have no `vl` identity: they were spawned by
-- the old spawn_one_mob, which threw the (village, plot, bed) triple away and
-- returned a random string. Left alone they would keep the random walk *and*
-- the census would count their beds as empty and spawn a second copy of
-- everyone.
--
-- So an unbound pigman standing in a village claims a vacant bed, preferring
-- one whose occupant shares its name -- which, since lottmobs was given
-- bed.first_name at spawn, is usually its own bed.
function home.adopt(self)
	-- A bedless recruit -- a travelling adventurer, or one of the wandering
	-- traders (dwarf/mung/human/elf) -- must never claim a village bed on its own
	-- and settle down, or it stops wandering and the census starts counting on it.
	-- It joins a town only by being recruited, through settlement, never by adopt.
	if village_life.is_bedless_recruit and village_life.is_bedless_recruit(self) then
		return false
	end

	local pos = self.object:get_pos()
	if not pos then return false end

	local village, village_id = home.village_at(pos, 32)
	if not village or not village.to_add_data then return false end

	local best, best_score
	for plot_nr, bpos in ipairs(village.to_add_data.bpos) do
		if bpos.beds then
			for bed_nr, bed in ipairs(bpos.beds) do
				-- Never adopt into a dead person's bed: it would put a stray
				-- pigman into a murdered villager's name and undo the death by
				-- the back door. succession.lua is the only thing that fills
				-- those, and it does it by making somebody new.
				--
				-- `away` is refused for the same reason in the other
				-- direction: that bed's occupant is alive and out on the road
				-- with a player, and giving their name to a stray would make
				-- two of them.
				-- `arrive_day` is refused for the same reason as `away`: that
				-- name belongs to a newcomer still on the road to a player's
				-- town, and a stray taking it would make two of them.
				if bed.first_name and not bed.dead and not bed.away
						and not bed.arrive_day
						and not home.occupied(village_id, plot_nr, bed_nr) then
					local score = util.dist2(pos, {x = bed.x, y = bed.y, z = bed.z})
					-- A name match is worth more than any plausible distance.
					if self.game_name and bed.first_name == self.game_name then
						score = score - 1e6
					end
					if not best_score or score < best_score then
						best_score, best = score, {plot_nr, bed_nr}
					end
				end
			end
		end
	end

	if not best then return false end

	home.bind(self, village_id, best[1], best[2])
	local bed = home.bed_data(village_id, best[1], best[2])
	self.id = "vl_" .. home.key(village_id, best[1], best[2])
	if bed then
		self.game_name = bed.first_name
		self.profession = bed.title or self.profession
	end
	home.check_in(self)
	village_life.apply_role(self)
	village_life.log("info", "adopted a loose villager into "
			.. home.key(village_id, best[1], best[2]))
	return true
end

--------------------------------------------------------------------------------
-- mg_villages spawn hook
--------------------------------------------------------------------------------

-- mg_villages documents spawn_one_mob as the extension point for villager mods
-- ("see mobf_trader for an example"), so we take it over rather than patching
-- mg_villages. It is called once per bed as each village chunk generates.
--
-- The `bed` and `bpos` arguments have to be used rather than looked up.
-- mg_villages writes `all_villages[village_id]` *after* it calls
-- part_of_village_spawned (mapgen.lua: the mob spawn loop runs at ~1074, the
-- all_villages assignment at ~1101), so during the chunk that first creates a
-- village every lookup through all_villages returns nil -- and the village
-- generates completely empty. That is what mg_villages' own implementation
-- avoided by only ever touching the arguments it was handed.
minetest.register_on_mods_loaded(function()
	mg_villages.inhabitants.spawn_one_mob = function(bed, village_id, plot_nr, bed_nr, bpos)
		local obj = home.spawn(village_id, plot_nr, bed_nr, bed, bpos)
		if obj then
			return home.key(village_id, plot_nr, bed_nr)
		end
	end
end)
