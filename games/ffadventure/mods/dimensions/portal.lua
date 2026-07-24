-- dimensions/portal.lua
-- Portal integration wrapping nether's portal_api.
-- Each dimension can define a portal frame/material and destination.

--[[
  Usage:
    dimensions.register_portal(dim_name, portal_def)

  portal_def extends nether.register_portal's def with extra fields:
    frame_node    = "default:obsidian",     -- what the portal frame is made of
    -- target_pos: a callback to get the destination pos in the dimension
    find_dim_anchorpos    = function(pos, name)  ... return pos end,
    find_surface_anchorpos = function(pos, name) ... return pos end,

  When a player steps through the portal they are moved to the dimension
  via dimensions.send_player().
--]]

function dimensions.register_portal(dim_name, portal_def)
	local registered = dimensions._registered
	local portals    = dimensions._portals
	assert(registered[dim_name],
		"dimensions.register_portal: dimension '" .. dim_name .. "' not registered yet. " ..
		"Call dimensions.register() first.")

	portal_def = portal_def or {}

	local name = (portal_def.name or dim_name) .. "_portal"

	-- Build the nether portal definition
	local nether_def = {
		name = name,
		wormhole_node_color = portal_def.wormhole_color or 7,
		frame_node_name = portal_def.frame_node or "default:obsidian",
		wormhole_node_name = "nether:portal",
		particle_texture = portal_def.particle_texture or "nether_particle_anim.png",
		title = portal_def.title or (dim_name .. " Portal"),
		book_of_portals_image = portal_def.image or "",

		is_within_realm = function(pos)
			-- Check if this position belongs to the dimension's realm.
			-- Since dimensions can use any coordinate, we track it via
			-- which map the player's block comes from. For portal detection
			-- we use a simpler heuristic: look up the player near this pos.
			local nearby = minetest.get_objects_inside_radius(pos, 8)
			for _, obj in ipairs(nearby) do
				local player = obj:is_player() and obj or nil
				if player and
				   minetest.get_player_dimension(player:get_player_name()) == dim_name then
					return true
				end
			end
			return false
		end,

		find_realm_anchorPos = portal_def.find_dim_anchorpos or function(pos, player_name)
			-- Default: same XZ, Y=0 in the dimension
			return {x = pos.x, y = 0, z = pos.z}
		end,

		find_surface_anchorPos = portal_def.find_surface_anchorpos or function(pos, player_name)
			-- Default: find surface in main world at same XZ
			local spawn_y = minetest.get_spawn_level(pos.x, pos.z) or 5
			return {x = pos.x, y = spawn_y, z = pos.z}
		end,

		on_player_teleported = function(player, last_pos, new_pos)
			local pname = player:get_player_name()
			local current_dim = minetest.get_player_dimension(pname)
			if current_dim == dim_name then
				-- Leaving the dimension → go to main world
				dimensions.send_player(player, "", new_pos)
			else
				-- Entering the dimension
				dimensions.send_player(player, dim_name, new_pos)
			end
		end,
	}

	nether.register_portal(name, nether_def)

	portals[dim_name] = portals[dim_name] or {}
	table.insert(portals[dim_name], name)
end
