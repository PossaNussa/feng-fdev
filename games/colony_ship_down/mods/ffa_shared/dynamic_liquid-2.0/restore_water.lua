-- Restore drained v7_rivers water WITHOUT regenerating — so nothing you have
-- built is ever deleted.
--
-- An earlier build of this mod had a bug that dissolved standing water.  The
-- BASINS and river channels v7_rivers carved are still in the map; only the water
-- inside them is gone.  This command asks v7_rivers' OWN heightmap module where
-- the water surface sits for every column — the exact figure the mapgen used —
-- and pours water back into the air beneath it.
--
-- Safety, by construction:
--   * It only ever replaces `air` and this mod's own shallow-water films.  A solid
--     node (terrain, your house, anything placed) is NEVER overwritten.
--   * Each column is filled DOWNWARD from the water surface and stops at the first
--     solid node, so a roofed cellar or a sealed cave under a lake is not flooded.
--   * It reads, it does not delete.  There is no delete_area, no regen, no emerge.

if core.get_mapgen_setting("mg_name") == "singlenode" then return end

local S_WATER = "default:water_source"
local S_RIVER = "default:river_water_source"
local MAXDEPTH = 200        -- how far below a water surface a single column is scanned
local CAP      = 600000     -- hard ceiling on nodes touched in one run

local make_heightmaps       -- resolved lazily; the grid may not exist on some worlds

-- Bring v7_rivers' heightmap pipeline up in the MAIN environment.  It normally
-- runs inside the mapgen sandbox, but its only inputs are the on-disk river grid
-- (plain file reads) and settings, so it runs here just as well.  `glaciers` is
-- off by default and is the only thing that would need the biome-heat noise, so
-- nothing mapgen-only is required.
local function ensure_loaded()
	if make_heightmaps then return true end
	local mr = rawget(_G, "mapgen_rivers")
	if not (mr and mr.modpath and mr.data_path) then return false end
	local sizef = io.open(mr.data_path .. "size", "r")
	if not sizef then return false end
	sizef:close()

	local ok, err = pcall(function()
		if not mr.grid then
			mr.grid = dofile(mr.modpath .. "grid_load.lua")
		end
		-- Set up the heat noiseparam the same way v7_rivers' mapgen does, in case
		-- this world runs with glaciers on (polygons.lua reads it only then).
		if not mr.np_heat and core.get_mapgen_setting_noiseparams then
			mr.np_heat = core.get_mapgen_setting_noiseparams("mg_biome_np_heat")
		end
		make_heightmaps = dofile(mr.modpath .. "heightmap.lua")
	end)
	if not ok then
		core.log("error", "[dynamic_liquid] restorewater: could not load river data: " .. tostring(err))
		make_heightmaps = nil
		return false
	end
	return type(make_heightmaps) == "function"
end

core.register_chatcommand("restorewater", {
	params = "[radius]",
	description = "Refill v7_rivers lakes/rivers drained by the old water bug, using"
		.. " the mapgen's own water levels. Only ever fills air and shallow films;"
		.. " never deletes anything. Default radius 64 (max 120).",
	privs = {server = true},
	func = function(name, param)
		if not ensure_loaded() then
			return false, "No v7_rivers grid for this world (or it failed to load) —"
				.. " nothing to restore from."
		end
		local player = core.get_player_by_name(name)
		if not player then return false, "You must be in-world to run this." end

		local radius = math.floor(tonumber(param) or 64)
		radius = math.max(8, math.min(radius, 120))

		local pp = player:get_pos()
		local cx = math.floor(pp.x + 0.5)
		local cz = math.floor(pp.z + 0.5)
		local minp = {x = cx - radius, y = 0, z = cz - radius}
		local maxp = {x = cx + radius, y = 0, z = cz + radius}

		local sea = tonumber(core.get_mapgen_setting("water_level")) or 1

		-- v7's own per-column ground surface, water surface and river signal.
		local terrain_map, lake_map, dpmax_map = make_heightmaps(minp, maxp)

		local shallow_units = dynamic_liquid.shallow_units_by_name or {}
		local get_node = core.get_node

		local water_pos, river_pos = {}, {}
		local capped = false

		-- Same iteration order make_heightmaps used (z outer, x inner), so index i
		-- lines up with its maps.
		local i = 1
		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				local th = terrain_map[i]
				local lw = lake_map[i]
				local dp = dpmax_map[i]
				i = i + 1

				-- A water column is one whose water surface stands above its own
				-- (possibly channel-lowered) ground, or ordinary sea floor below the
				-- sea level.  Everything else is dry land and is left untouched.
				if th and lw and (lw > th or th < sea) then
					local target = lw
					if target < sea then target = sea end

					local river = dp and dp > 0
					local list = river and river_pos or water_pos

					local y = target
					local bottom = target - MAXDEPTH
					while y >= bottom do
						local nn = get_node({x = x, y = y, z = z}).name
						if nn == "air" or shallow_units[nn] then
							list[#list + 1] = {x = x, y = y, z = z}
							if (#water_pos + #river_pos) >= CAP then
								capped = true
								break
							end
						elseif nn == S_WATER or nn == S_RIVER then
							break   -- reached surviving water: this column is full below here
						else
							break   -- solid bed / terrain / unloaded: stop, never overwrite it
						end
						y = y - 1
					end
				end
				if capped then break end
			end
			if capped then break end
		end

		local total = #water_pos + #river_pos
		if total == 0 then
			return true, "No missing water found in range — nothing needed restoring."
		end

		-- One biome colour for the pour (always_greener's water palette if present).
		local param2 = 0
		local ag = rawget(_G, "always_greener")
		if ag and ag.water_param2 then param2 = ag.water_param2(pp) end

		if core.bulk_set_node then
			if #water_pos > 0 then core.bulk_set_node(water_pos, {name = S_WATER, param2 = param2}) end
			if #river_pos > 0 then core.bulk_set_node(river_pos, {name = S_RIVER, param2 = param2}) end
		else
			for _, p in ipairs(water_pos) do core.set_node(p, {name = S_WATER, param2 = param2}) end
			for _, p in ipairs(river_pos) do core.set_node(p, {name = S_RIVER, param2 = param2}) end
		end

		-- Nudge the movement ABM so the fresh water settles at once (bulk_set_node
		-- fires no placenode hook).
		if dynamic_liquid.invalidate_stability then
			dynamic_liquid.invalidate_stability({x = cx, y = sea, z = cz})
		end

		local msg = string.format("Restored %d water nodes (%d lake/sea, %d river) within %d nodes.",
			total, #water_pos, #river_pos, radius)
		if capped then
			msg = msg .. string.format("  Hit the %d-node safety cap — move along and run again to continue.", CAP)
		end
		return true, msg
	end,
})
