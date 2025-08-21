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

function internal_api.new_player_spawn(player)
	local x, y, z

	local pcg = internal_api.get_rand(player)

	local count = 0
	while (not y) and (count < internal_api.spawn_attempts) do
		count = count + 1
		x = pcg:next(internal_api.min_dist, internal_api.max_dist)
		if pcg:next(1, 2) > 1 then x = -x end
		z = pcg:next(internal_api.min_dist, internal_api.max_dist)
		if pcg:next(1, 2) > 1 then z = -z end

		local rpos = vector.new(x, 0, z)

		local far_away = true
		for _, ppos in pairs(internal_api.player_spawns) do
			if vector.distance(rpos, ppos) < internal_api.player_dist then
				far_away = false
				break
			end
		end

		if far_away then
			local vm = core.get_voxel_manip()
			-- local emin, emax = vm:read_from_map(rpos, rpos)
			vm:read_from_map(rpos, rpos)

			y = core.get_spawn_level(x, z)
		end
	end

	if y then
		local pos = vector.new(x, y, z)
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

		player:get_meta():set_string("alone:spawn", core.pos_to_string(pos))
		player:set_pos(pos)

		internal_api.player_spawns[player:get_player_name()] = pos
		internal_api.storage:set_string("player_spawns",
		                                core.serialize(internal_api.player_spawns))
		return true
	end

	return false
end

function internal_api.respawn(player)
	if player and player:is_player() then

		if internal_api.game_respawn ~= nil then
			if internal_api.game_respawn(player) then return true end
		end

		local attr = player:get_meta():get_string("alone:spawn")
		if attr and attr ~= "" then
			local pos = core.string_to_pos(attr)
			if pos then
				player:set_pos(pos)
				return true
			end
		end
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
