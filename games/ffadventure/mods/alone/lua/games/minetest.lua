local internal_api = ...

spawn.register_on_spawn(function(player, is_new)
	if is_new then
		return internal_api.new_player_spawn(player)
	else
		return internal_api.respawn(player)
	end
end)

function internal_api.game_respawn(player)
	local pos = beds.spawn[player:get_player_name()]
	if pos then
		player:set_pos(pos)
		return true
	end

	return false
end

internal_api.spawn_handled = true

