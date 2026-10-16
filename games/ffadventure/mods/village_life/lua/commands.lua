-- Inspection commands. Everything this mod does is emergent and mostly
-- invisible from outside, so there has to be a way to ask what it thinks is
-- going on without reading the log.

local util    = village_life.util
local home    = village_life.home
local threats = village_life.threats
local market  = village_life.market

local function nearest_village(player)
	local pos = player:get_pos()
	if not pos then return end
	return home.village_at(pos, 200)
end

local function status(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end

	local village, village_id, dist = nearest_village(player)
	if not village then
		return true, "No village within 200 nodes."
	end

	local beds, filled, vacant = 0, 0, 0
	local roles = {}
	for plot_nr, bpos in ipairs(village.to_add_data.bpos) do
		if bpos.beds then
			for bed_nr, bed in ipairs(bpos.beds) do
				if bed.first_name then
					beds = beds + 1
					if home.occupied(village_id, plot_nr, bed_nr) then
						filled = filled + 1
						local title = bed.title or "(household)"
						roles[title] = (roles[title] or 0) + 1
					else
						vacant = vacant + 1
					end
				end
			end
		end
	end

	local c = market.character(village_id)
	local alarm = threats.alarm(village_id)
	local hostile = threats.by_village[village_id]
	local ppos = player:get_pos()

	-- The alarm is the single most useful thing to be able to see, because a
	-- stuck one makes every villager flee, keeps them standing indoors and
	-- stops the census repopulating -- three symptoms, one cause.
	local alert = "clear"
	if alarm then
		alert = ("RAISED %ds ago at %s (%d nodes from you, %+d in height)"):format(
				math.floor(util.now() - alarm.started),
				minetest.pos_to_string(vector.round(alarm.pos)),
				math.floor(util.dist_flat(alarm.pos, ppos)),
				math.floor(alarm.pos.y - (village.vh or alarm.pos.y)))
	end

	local lines = {
		("Village %s  (%s, %d nodes away, ground height %d)"):format(
				village_id, village.name or "unnamed", math.floor(dist or 0),
				village.vh or 0),
		("  population  %d of %d beds filled, %d vacant"):format(filled, beds, vacant),
		("  economy     known for %s, short of %s, wealth %.2f, season %s"):format(
				c.speciality, c.scarce, c.wealth, market.season()),
		("  alert       %s"):format(alert),
		("  hostiles    %d inside the village, %d anywhere in range"):format(
				hostile and #hostile or 0, #threats.list),
	}

	-- The dead are the reason a village is short-handed, so they belong here
	-- next to the population count rather than behind their own subcommand.
	local dead = village_life.succession.the_dead(village_id)
	if #dead > 0 then
		lines[#lines + 1] = ("  dead        %d"):format(#dead)
		for i = 1, math.min(#dead, 5) do
			local d = dead[i]
			lines[#lines + 1] = ("    %s%s, day %d%s"):format(
					d.name or "?",
					d.title and (" the " .. d.title) or "",
					d.day,
					d.killed_by and (", killed by " .. d.killed_by) or "")
		end
	end

	-- Every hostile the scan can see, with its height relative to the village
	-- floor: anything well below it is in a cave and must not be counting.
	for _, t in ipairs(threats.list) do
		lines[#lines + 1] = ("    %-28s %3d nodes out, %+4d height"):format(
				t.name, math.floor(util.dist_flat(t.pos, ppos)),
				math.floor(t.pos.y - (village.vh or t.pos.y)))
	end

	local titles = {}
	for title, n in pairs(roles) do titles[#titles + 1] = title .. " x" .. n end
	table.sort(titles)
	if #titles > 0 then
		lines[#lines + 1] = "  present     " .. table.concat(titles, ", ")
	end

	return true, table.concat(lines, "\n")
end

-- Where the player stands with the nearest village, and everywhere else they
-- have made an impression.
local function reputation(pname)
	if not village_life.settings.reputation then
		return true, "Reputation is disabled (village_life_reputation)."
	end

	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end

	local rep = village_life.reputation
	local lines = {}

	local village, village_id = nearest_village(player)
	if village_id then
		local score = rep.get(village_id, pname)
		local tier = rep.tier(score)
		lines[#lines + 1] = ("%s (%s): %s, %d point(s), %d visit(s)"):format(
				village.name or "nearest village", village_id,
				tier.name, math.floor(score + 0.5), rep.visits(village_id, pname))
		if tier.hostile then
			lines[#lines + 1] = "  Their guards will attack you on sight."
		elseif tier.shun then
			lines[#lines + 1] = "  They will not trade with you."
		elseif tier.favoured then
			lines[#lines + 1] = "  They keep goods back for you."
		end
		if tier.silent then
			lines[#lines + 1] = "  They will not speak to you."
		end
	else
		lines[#lines + 1] = "No village within 200 nodes."
	end

	local elsewhere = {}
	for id, entries in pairs(rep.book) do
		if id ~= village_id and entries[pname] then
			local score = rep.get(id, pname)
			if math.abs(score) >= 1 then
				elsewhere[#elsewhere + 1] = ("  %s: %s (%d)"):format(
						id, rep.tier(score).name, math.floor(score + 0.5))
			end
		end
	end
	table.sort(elsewhere)
	if #elsewhere > 0 then
		lines[#lines + 1] = "Elsewhere:"
		for _, l in ipairs(elsewhere) do lines[#lines + 1] = l end
	end

	return true, table.concat(lines, "\n")
end

-- What are the villagers around me actually doing, and why. Answers the
-- question "they are all just standing in corners" directly.
local function goals(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end
	local ppos = player:get_pos()

	local counts, unbound, unresolved, total = {}, 0, 0, 0

	for _, obj in ipairs(minetest.get_objects_inside_radius(ppos, 48)) do
		local ent = obj:get_luaentity()
		if ent and village_life.is_villager_entity(ent.name) then
			total = total + 1
			if not home.is_villager(ent) then
				unbound = unbound + 1
			elseif not home.resolve(ent) then
				unresolved = unresolved + 1
			else
				local goal = village_life.util.scratch(ent).goal
				local kind = goal and goal.kind or "(none yet)"
				counts[kind] = (counts[kind] or 0) + 1
			end
		end
	end

	if total == 0 then return true, "No villagers within 48 nodes." end

	local lines = {("%d villager(s) within 48 nodes:"):format(total)}
	local kinds = {}
	for kind in pairs(counts) do kinds[#kinds + 1] = kind end
	table.sort(kinds)
	for _, kind in ipairs(kinds) do
		lines[#lines + 1] = ("  %-12s %d"):format(kind, counts[kind])
	end
	if unbound > 0 then
		lines[#lines + 1] = ("  %-12s %d  (no village identity; awaiting adoption)")
				:format("unbound", unbound)
	end
	if unresolved > 0 then
		lines[#lines + 1] = ("  %-12s %d  (bound, but the village data did not resolve)")
				:format("unresolved", unresolved)
	end
	return true, table.concat(lines, "\n")
end

-- What the villagers around me are actually carrying, and what they think of
-- me personally. Gossip is invisible from outside by design, so without this
-- there is no way to tell a rumour that spread from one that never did.
local function talk(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end
	local ppos = player:get_pos()

	local memory = village_life.memory
	local gossip = village_life.gossip
	local lines = {}

	for _, obj in ipairs(minetest.get_objects_inside_radius(ppos, 32)) do
		local ent = obj:get_luaentity()
		if ent and village_life.is_villager_entity(ent.name) and home.is_villager(ent) then
			local key = memory.key_of(ent)
			local opinion = memory.opinion(ent, pname)
			lines[#lines + 1] = ("%s (%s): opinion %+d, %s, carrying %d item(s) of news")
					:format(ent.game_name or "?", key or "?",
							math.floor(opinion + 0.5), memory.spirits(ent),
							gossip.count(key))

			local item = gossip.for_player(ent, pname)
			if item then
				local said = gossip.phrase(item)
				if said then
					lines[#lines + 1] = ("    [%d hop] %s"):format(item.hops, said)
				end
			end

			local notable = memory.notable(ent, pname)
			if notable then
				lines[#lines + 1] = ("    remembers: %s x%d"):format(
						notable.kind, notable.count)
			end
		end
	end

	if #lines == 0 then return true, "No villagers within 32 nodes." end

	local fame = village_life.reputation.notorious(pname)
	table.insert(lines, 1, ("Your name, in the world at large: %d"):format(
			math.floor(fame + 0.5)))
	return true, table.concat(lines, "\n")
end

-- The nearest bound villager to a player, with its memory key, or nil. Used by
-- the one-off grudge pardon: you stand next to the villager you mean and run it.
local function nearest_villager(player)
	local ppos = player:get_pos()
	if not ppos then return end
	local best, best_d
	for _, obj in ipairs(minetest.get_objects_inside_radius(ppos, 16)) do
		local ent = obj:get_luaentity()
		if ent and village_life.is_villager_entity(ent.name)
				and home.is_villager(ent) then
			local d = util.dist(obj:get_pos(), ppos)
			if not best_d or d < best_d then best, best_d = ent, d end
		end
	end
	return best
end

-- Erase one villager's memory of a single thing this player did to them. Built
-- for the stale case: a theft witnessed in what is now your own town, before the
-- founder exemption stopped it counting -- the villager keeps bringing it up
-- because the deed record never decays, only the opinion does. This clears just
-- that deed and any theft rumour they still carry about you; their mood, and
-- everything else they and the village remember, are left alone.
local function forgive(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end

	local ent = nearest_villager(player)
	if not ent then return true, "No villager within 16 nodes to speak to." end

	local memory = village_life.memory
	local gossip = village_life.gossip
	local key = memory.key_of(ent)
	if not key then return true, "That villager has no memory to clear." end

	local who = ent.game_name or "The villager"
	local pardoned = memory.pardon(key, pname, "robbed")
	local hushed = gossip.pardon(key, pname, "theft")

	if not pardoned and hushed == 0 then
		return true, who .. " holds nothing against you for taking anything."
	end
	return true, who .. " will say no more about what you took."
end

-- Undo a death. permadeath marks a bed `dead` and stops the census ever
-- refilling it, but record_death leaves everything else on the row untouched --
-- first_name, title, species, gender, and the marriage link to their spouse's
-- bed. So clearing the flag and respawning brings the *same* person back, still
-- married, still remembered, not a replacement. `name` disambiguates when more
-- than one villager has died; with none given it takes the most recent death.
local function revive(pname, name)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end

	local _, village_id = nearest_village(player)
	if not village_id then return true, "No village within 200 nodes." end
	local village = home.village(village_id)
	if not village or not village.to_add_data then
		return true, "That village has no household data to read."
	end

	local want = name and name:lower() or nil
	local best, best_p, best_b, best_day
	for plot_nr, bpos in ipairs(village.to_add_data.bpos) do
		for bed_nr, bed in ipairs(bpos.beds or {}) do
			if bed.dead then
				local who = bed.was_named or bed.first_name
				if not want or (who and who:lower() == want) then
					-- Most recent death wins when several match / none named.
					if not best or (bed.died_day or 0) >= (best_day or 0) then
						best, best_p, best_b, best_day = bed, plot_nr, bed_nr, bed.died_day or 0
					end
				end
			end
		end
	end

	if not best then
		return true, want
				and ("Nobody named %s has died in this village."):format(name)
				or "No one in this village is dead. Everybody's home."
	end

	local who = best.was_named or best.first_name or "The villager"
	-- The row keeps their identity; we only lift the death.
	best.first_name = best.first_name or best.was_named
	best.title = best.title or best.was_titled
	best.dead, best.died_day, best.killed_by = nil, nil, nil
	if mg_villages.save_data then mg_villages.save_data() end

	-- Their death is undone, so no one should still be carrying word of it --
	-- otherwise the village, and the revived villager themselves, would go on
	-- gossiping about a death that no longer happened.
	if village_life.gossip and village_life.gossip.forget_subject then
		village_life.gossip.forget_subject(home.key(village_id, best_p, best_b))
	end

	-- Do not let the census's own pending timer race the hand-placed spawn.
	home.pending[home.key(village_id, best_p, best_b)] = nil

	local obj = home.spawn(village_id, best_p, best_b)
	if obj then
		return true, ("%s is back."):format(who)
	end
	-- Bed is in an unloaded mapblock, or spawn was blocked. The flag is already
	-- cleared and saved, so the census will place them the moment you stand near
	-- their house -- or run this again once you are closer.
	return true, ("%s is no longer dead, but their house is out of range to " ..
			"place them. Walk up to it and run /village_life census."):format(who)
end

-- Make amends with a whole village after a killing. `forgive` clears one
-- villager's memory of a theft; this is its counterpart for a death, and it is
-- village-wide because a killing is: the standing penalty is per-village, and
-- everyone who heard of it holds the grudge. Three things have to lift together
-- or the shops stay shut -- the standing number, the travelling notoriety behind
-- it, and the personal grudges individual villagers carry.
local KILL_GRUDGES = {"kin_killed", "neighbour_died"}

local function amends(pname)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "No such player." end

	local _, village_id = nearest_village(player)
	if not village_id then return true, "No village within 200 nodes." end

	local before, after
	if village_life.settings.reputation then
		before, after = village_life.reputation.make_amends(village_id, pname)
	end

	-- Clear the personal grudges and the murder rumours, bed by bed, so they
	-- reach the villagers who are not currently loaded too.
	local memory, gossip = village_life.memory, village_life.gossip
	local village = home.village(village_id)
	local pardoned, hushed = 0, 0
	if village and village.to_add_data then
		for plot_nr, bpos in ipairs(village.to_add_data.bpos) do
			for bed_nr in ipairs(bpos.beds or {}) do
				local key = home.key(village_id, plot_nr, bed_nr)
				for _, kind in ipairs(KILL_GRUDGES) do
					if memory.pardon(key, pname, kind) then pardoned = pardoned + 1 end
				end
				hushed = hushed + gossip.pardon(key, pname, "murder")
			end
		end
	end
	if gossip.save then gossip.save() end

	local place = (village and village.name) or village_id
	if before and after then
		return true, ("Amends made with %s: standing %d -> %d, %d grudge(s) let " ..
				"go, %d rumour(s) hushed. The shops will deal with you again."):format(
				place, math.floor(before), math.floor(after), pardoned, hushed)
	end
	return true, ("Amends made with %s: %d grudge(s) let go, %d rumour(s) " ..
			"hushed."):format(place, pardoned, hushed)
end

minetest.register_chatcommand("village_life", {
	params = "[status | rep | talk | goals | forgive | amends | revive [name] | census | restock | threats | calm]",
	description = "Inspect village_life state for the nearest village",
	privs = {},
	func = function(pname, param)
		param = (param or ""):trim()

		if param == "" or param == "status" then
			return status(pname)
		elseif param == "goals" then
			return goals(pname)
		elseif param == "rep" then
			return reputation(pname)
		elseif param == "talk" then
			return talk(pname)
		end

		-- `revive` takes an optional name argument, so match on the first word.
		local verb, rest = param:match("^(%S+)%s*(.-)$")
		verb = verb or param

		local player = minetest.get_player_by_name(pname)
		if not player then return false, "No such player." end

		if verb == "revive" then
			if not minetest.check_player_privs(pname, {server = true}) then
				return false, "Needs the server privilege."
			end
			return revive(pname, rest ~= "" and rest or nil)

		elseif param == "amends" then
			if not minetest.check_player_privs(pname, {server = true}) then
				return false, "Needs the server privilege."
			end
			return amends(pname)

		elseif param == "forgive" then
			if not minetest.check_player_privs(pname, {server = true}) then
				return false, "Needs the server privilege."
			end
			return forgive(pname)

		elseif param == "census" then
			if not minetest.check_player_privs(pname, {server = true}) then
				return false, "Needs the server privilege."
			end
			local _, village_id = nearest_village(player)
			if not village_id then return true, "No village nearby." end
			-- Immediate: fills every vacant bed in loaded parts of the village
			-- in one go, rather than noting them and waiting out the respawn
			-- delay. This is the repair tool for a village that generated
			-- underpopulated.
			local n = village_life.census.audit(village_id, true)
			return true, ("Repopulated %d villager(s). Beds in unloaded parts of " ..
					"the village are skipped -- walk the whole town and run it again.")
					:format(n)

		elseif param == "restock" then
			if not minetest.check_player_privs(pname, {server = true}) then
				return false, "Needs the server privilege."
			end
			local pos = player:get_pos()
			local n = 0
			for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 48)) do
				local ent = obj:get_luaentity()
				if ent and village_life.is_villager_entity(ent.name) then
					village_life.economy.invalidate(ent)
					n = n + 1
				end
			end
			return true, "Cleared stock for " .. n .. " trader(s); it rebuilds on next use."

		elseif param == "calm" then
			-- Escape hatch: clear the alert by hand. If the village goes
			-- straight back onto it, `status` will name what did it.
			local _, village_id = nearest_village(player)
			if not village_id then return true, "No village nearby." end
			threats.alarms[village_id] = nil
			return true, "Alarm cleared for " .. village_id .. "."

		elseif param == "threats" then
			local pos = player:get_pos()
			local lines = {}
			for _, t in ipairs(threats.list) do
				local d = util.dist(t.pos, pos)
				if d < 128 then
					lines[#lines + 1] = ("  %s at %d nodes"):format(
							t.name, math.floor(d))
				end
			end
			if #lines == 0 then return true, "No known threats within 128 nodes." end
			return true, "Known threats:\n" .. table.concat(lines, "\n")
		end

		return false,
				"Unknown subcommand. Try: status, rep, talk, goals, forgive, " ..
				"amends, revive, census, restock, threats, calm"
	end,
})
