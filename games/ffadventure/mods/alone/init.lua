local internal_api = {}

internal_api.mod_name = core.get_current_modname()
internal_api.mod_path = core.get_modpath(internal_api.mod_name)
internal_api.S, internal_api.P = core.get_translator(internal_api.mod_name)
internal_api.storage = core.get_mod_storage()
internal_api.mod_data_path = core.get_mod_data_path()
internal_api.spawn_handled = false

internal_api.home_alone = core.settings:get_bool("alone_home_alone", false)
internal_api.home_teleport = core.settings:get_bool("alone_home_teleport", false)
internal_api.home_waypoint = core.settings:get_bool("alone_home_waypoint", false)

internal_api.min_dist = tonumber(core.settings:get("alone_min_dist")) or 1000
internal_api.max_dist = tonumber(core.settings:get("alone_max_dist")) or 30000
internal_api.player_dist = tonumber(core.settings:get("alone_player_dist")) or 500
internal_api.spawn_attempts = tonumber(core.settings:get("alone_spawn_attempts")) or 5000
-- Respawns re-roll the spawn point every time, so their search runs on every
-- death and not once per player. A tighter budget keeps that off the server
-- step; the first tier-matching hit usually lands within a handful of tries.
internal_api.respawn_attempts = tonumber(core.settings:get("alone_respawn_attempts")) or 400

internal_api.bed_respawn = core.settings:get_bool("enable_bed_respawn", true)

internal_api.has_tpad = core.get_modpath("tpad")
internal_api.has_named_waypoints = core.get_modpath("named_waypoints")

internal_api.player_spawns = core.deserialize(internal_api.storage:get_string(
	                                              "player_spawns")) or {}

local game_info = core.get_game_info()

local S = internal_api.S
local MP = internal_api.mod_path

if internal_api.has_named_waypoints then
	local home_waypoint_def = {
		default_name = S("A player home"),
		default_color = 0xffd0672a,
		discovery_volume_radius = 60,
		on_discovery = named_waypoints.default_discovery_popup,
		visibility_volume_radius = 180,
	}

	named_waypoints.register_named_waypoints("alone_homes", home_waypoint_def)
end

assert(loadfile(MP .. "/lua/util.lua"))(internal_api)
assert(loadfile(MP .. "/lua/climate_filter.lua"))(internal_api)

function internal_api.new_player_spawn(player)
	local pos = internal_api.find_spawn_pos(player, internal_api.spawn_attempts)

	if pos then
		if internal_api.home_alone then
			local y_offset
			local has_house

			if internal_api.spawn_house ~= nil then
				y_offset, has_house = internal_api.spawn_house(player, pos)
			else
				y_offset, has_house = internal_api.default_spawn_house(player, pos)
			end

			if has_house then
				if y_offset ~= 0 then pos = vector.offset(pos, 0, y_offset, 0) end

				-- A house is a spawn point the player was given rather than one
				-- they wandered into, so it is theirs to keep: respawns stop
				-- re-rolling once this is set.
				player:get_meta():set_string("alone:home", core.pos_to_string(pos))

				local home_str = S("@1's home", player:get_player_name())

				if internal_api.home_teleport then
					if internal_api.has_tpad then
						core.set_node(pos, {name = "tpad:tpad"})
						local meta = core.get_meta(pos)
						meta:set_string("owner", player:get_player_name())
						meta:set_string("infotext", home_str)
						tpad.set_pad_data(pos, home_str, "Public (only owner's network)")
					end
				end

				if internal_api.home_waypoint then
					if internal_api.has_named_waypoints then
						local wp_pos = vector.offset(pos, 0, 1, 0)
						named_waypoints.add_waypoint("alone_homes", wp_pos, {name = home_str})
					end
				end
			end
		end

		player:set_pos(pos)

		-- The registry of places to keep other players away from. Respawns
		-- deliberately do not write to it: it records where people live, not
		-- wherever they last happened to wake up.
		internal_api.player_spawns[player:get_player_name()] = pos
		internal_api.storage:set_string("player_spawns",
		                                core.serialize(internal_api.player_spawns))
		return true
	end

	return false
end

--- True when the player has a spawn point they set on purpose, which must not
--- be re-rolled. Places them at it if nothing else will.
local function fixed_respawn(player)
	-- Every on_respawnplayer callback runs -- the list does not stop at the
	-- first one to return true -- so builtin's static_spawnpoint handler and
	-- beds' handler have already moved the player by the time we get here. For
	-- those two all we have to do is stand down and leave them where they are.
	if core.settings:get_pos("static_spawnpoint") then return true end

	local name = player:get_player_name()
	if internal_api.bed_respawn and beds and beds.spawn and beds.spawn[name] then
		return true
	end

	-- A house from alone_home_alone has no callback of its own, so we place it.
	local home = core.string_to_pos(player:get_meta():get_string("alone:home"))
	if home then
		player:set_pos(home)
		return true
	end

	return false
end

function internal_api.respawn(player)
	if not (player and player:is_player()) then return false end

	if internal_api.game_respawn ~= nil then
		if internal_api.game_respawn(player) then return true end
	end

	-- true here means someone placed them -- us, or a callback that ran before
	-- us and returned true of its own accord, which the engine ORs with ours.
	if fixed_respawn(player) then return true end

	-- No spawn of their own: the world hands them a new one every death rather
	-- than the single point they drew when they registered. Sleep in a bed to
	-- stop wandering; break the bed and the wandering starts again.
	local pos = internal_api.find_spawn_pos(player, internal_api.respawn_attempts)
	if pos then
		player:set_pos(pos)
		return true
	end

	return false
end

local game_file_path = MP .. "/lua/games/" .. game_info.id .. ".lua"
local file_test = io.open(game_file_path)
if file_test then
	file_test:close()
	assert(loadfile(game_file_path))(internal_api)
end

if not internal_api.spawn_handled then
	core.register_on_newplayer(function(player) internal_api.new_player_spawn(player) end)
	core.register_on_respawnplayer(function(player) return internal_api.respawn(player) end)
end
