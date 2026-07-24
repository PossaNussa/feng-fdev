-- Minecraft-style water current: pushes players in the flow direction.
-- Non-player entities receive natural resistance from the liquid's move_resistance group.
--
-- Flow direction is determined the same way the queue processor decides where a source
-- moves: downward if below is passable (falling water), otherwise toward passable
-- horizontal neighbours (gradient toward drop-off or open channel).

local PUSH_ACCEL = tonumber(minetest.settings:get("dynamic_liquid_push_accel")) or 5.0

local get_node = minetest.get_node

-- Source → flowing mapping for passability checks.
-- Checked at load-time; sailing is included only if the mod is present.
local push_map = {
	["default:water_source"]         = "default:water_flowing",
	["default:water_flowing"]        = "default:water_flowing",
	["default:river_water_source"]   = "default:river_water_flowing",
	["default:river_water_flowing"]  = "default:river_water_flowing",
}

if minetest.get_modpath("sailing") then
	push_map["sailing:shallow_water_source"]  = "sailing:shallow_water_flowing"
	push_map["sailing:shallow_water_flowing"] = "sailing:shallow_water_flowing"
end

-- Returns a normalised {x,y,z} flow direction for the liquid at `pos`, or nil.
-- Prefers downward (falling water), then accumulates horizontal open directions.
local function get_flow_dir(pos, flowing_name)
	local x, y, z = pos.x, pos.y, pos.z
	local below = get_node({x=x, y=y-1, z=z}).name
	if below == "air" or below == flowing_name then
		return {x=0, y=-1, z=0}
	end
	local dx, dz = 0, 0
	local nx, nz
	nx = get_node({x=x+1, y=y, z=z}).name
	if nx == "air" or nx == flowing_name then dx = dx + 1 end
	nx = get_node({x=x-1, y=y, z=z}).name
	if nx == "air" or nx == flowing_name then dx = dx - 1 end
	nz = get_node({x=x, y=y, z=z+1}).name
	if nz == "air" or nz == flowing_name then dz = dz + 1 end
	nz = get_node({x=x, y=y, z=z-1}).name
	if nz == "air" or nz == flowing_name then dz = dz - 1 end
	if dx == 0 and dz == 0 then return nil end
	local len = math.sqrt(dx*dx + dz*dz)
	return {x=dx/len, y=0, z=dz/len}
end

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		-- Check feet node and one block above (chest-level); feet take priority.
		local y0 = math.floor(pos.y)
		for _, cy in ipairs({y0, y0 + 1}) do
			local cpos = {x=pos.x, y=cy, z=pos.z}
			local node = get_node(cpos)
			local flowing = push_map[node.name]
			if flowing then
				local dir = get_flow_dir(cpos, flowing)
				if dir then
					player:add_velocity({
						x = dir.x * PUSH_ACCEL * dtime,
						y = dir.y * PUSH_ACCEL * dtime * 0.4,
						z = dir.z * PUSH_ACCEL * dtime,
					})
				end
				break  -- only apply the lowest water node's push
			end
		end
	end
end)
