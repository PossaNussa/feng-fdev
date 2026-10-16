-- Keeping villages populated.
--
-- mg_villages spawns its inhabitants exactly once, from the mapgen callback,
-- as each chunk of a village is generated. After that the population only ever
-- goes down: a villager that drowns, falls, is eaten or is caught by
-- /clearobjects is gone for good, and its workstation stands empty for the
-- rest of the world's life. That is the other half of "workstations for people
-- that don't exist" -- the people existed once.
--
-- This walks the bed list of nearby villages and replaces whoever is missing,
-- after a delay, and never while something is hunting in the street.

local util = village_life.util
local home = village_life.home
local threats = village_life.threats

local census = {}
village_life.census = census

-- One village gets audited per pass, round-robin, so a player standing between
-- three villages does not pay for all of them on the same step.
local CENSUS_INTERVAL = 15
local MAX_SPAWNS_PER_PASS = 4

local timer = 0
local cursor = 1

-- Ids of the villages within simulation range of any player.
local function nearby_villages()
	local range = village_life.settings.active_range
	local shortlist = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos then home.villages_near(ppos, range, shortlist) end
	end

	local out = {}
	for id in pairs(shortlist) do out[#out + 1] = id end
	-- pairs() order is not stable between calls, and the round-robin cursor
	-- below indexes into this list; sorting keeps the rotation honest.
	table.sort(out)
	return out
end

-- Would a villager spawned here be immediately eaten? Replacing the baker into
-- the jaws of the thing that ate the last one is worse than an empty bakery.
--
-- Deliberately about this doorstep, not about the village. Refusing on the
-- village-wide alarm meant one monster anywhere in range stopped the village
-- repopulating at all, which is how a town ends up with more houses than
-- people.
local function safe_to_spawn(village_id, pos)
	return threats.nearest(pos, 20) == nil
end

-- `immediate` skips the waiting period and the per-pass cap. Only the chat
-- command passes it: on the periodic pass the wait is what stops a villager
-- whose mapblock merely happens to be unloaded from being duplicated.
function census.audit(village_id, immediate)
	local village = home.village(village_id)
	if not village or not village.to_add_data then return 0 end

	local now = os.time()
	local spawned = 0
	local cap = immediate and math.huge or MAX_SPAWNS_PER_PASS

	for plot_nr, bpos in ipairs(village.to_add_data.bpos) do
		if bpos.beds then
			for bed_nr, bed in ipairs(bpos.beds) do
				-- A bed marked dead is not a vacancy to fix. Somebody was
				-- killed there, and putting an identical person back four
				-- minutes later is what made death meaningless. succession.lua
				-- owns that bed now, on a timescale of days.
				-- `away` is the other reason an empty bed is not a vacancy:
				-- its occupant has taken service with a player and is
				-- somewhere else entirely. Without this the village hands out
				-- a second, identical copy of your companion the moment its
				-- mapblocks unload -- the same trap `dead` had to solve, and
				-- solved the same way, in the row that is the authority on who
				-- lives where.
				-- `arrive_day` in the future is a third: a newcomer who agreed
				-- to move into a player's town and is still on the road. The bed
				-- carries their name so it is theirs, but nobody stands in it
				-- until the day they turn up (settlement.take_resident).
				local incoming = bed.arrive_day
						and minetest.get_day_count
						and minetest.get_day_count() < bed.arrive_day
				if bed.first_name and not bed.dead and not bed.away and not incoming
						and not home.occupied(village_id, plot_nr, bed_nr) then
					local key = home.key(village_id, plot_nr, bed_nr)
					local due = home.pending[key]

					if due == nil and not immediate then
						-- First time we have noticed this bed empty. It may
						-- simply be that the mapblock holding the villager is
						-- not loaded, so wait one respawn delay before
						-- concluding anybody is actually missing.
						home.pending[key] = now + village_life.settings.respawn_delay
					elseif immediate or now >= due then
						local pos = home.spawn_pos(village_id, plot_nr, bed_nr)
						if pos and util.is_loaded(pos)
								and safe_to_spawn(village_id, pos) then
							if home.spawn(village_id, plot_nr, bed_nr) then
								-- A newcomer who has now arrived is just a
								-- resident: drop the travel marker so it is not
								-- carried in their bed row forever.
								if bed.arrive_day then
									bed.arrive_day = nil
									if mg_villages.save_data then
										pcall(mg_villages.save_data)
									end
								end
								spawned = spawned + 1
								village_life.log("info",
										"repopulated " .. key .. " (" .. bed.first_name .. ")")
								if spawned >= cap then
									return spawned
								end
							else
								-- Spawn refused (unloaded, no room). Try again
								-- next pass rather than every 15 seconds
								-- forever.
								home.pending[key] = now + 60
							end
						end
					end
				end
			end
		end
	end

	return spawned
end

minetest.register_globalstep(function(dtime)
	if not village_life.settings.census then return end

	timer = timer + dtime
	if timer < CENSUS_INTERVAL then return end
	timer = 0

	local villages = nearby_villages()
	if #villages == 0 then return end

	if cursor > #villages then cursor = 1 end
	local village_id = villages[cursor]
	cursor = cursor + 1

	census.audit(village_id)
end)

--------------------------------------------------------------------------------
-- Roster upkeep
--------------------------------------------------------------------------------

-- Drop roster entries whose ObjectRef has gone invalid. Mobs that unloaded
-- with their mapblock will check back in when it reloads; this only clears
-- entries that will never come back, so the census can see the vacancy.
local sweep = 0
minetest.register_globalstep(function(dtime)
	sweep = sweep + dtime
	if sweep < 30 then return end
	sweep = 0

	for key, entry in pairs(home.roster) do
		if not entry.obj:get_pos() then
			home.roster[key] = nil
		end
	end
end)
