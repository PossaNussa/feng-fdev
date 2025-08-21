--my first mod!!!! if there is any messy or weird code DO send suggestions i want this to be better

local get_connected_players = minetest.get_connected_players
local hurtwait = {}

local function blockwithinrange(xs, ys, zs, xe, ye, ze, name)
	for x = math.floor(xs), math.floor(xe) do
		for y = math.floor(ys), math.floor(ye) do
			for z = math.floor(zs), math.floor(ze) do
				if minetest.get_node({x=x, y=y, z=z}).name == name then
					return true
				end
			end
		end
	end
	return false
end

local function blocktouching(player, name)
	local pos = player:get_pos()
	local spd = player:get_velocity()
	local spdy = math.min(player:get_velocity().y / 10, -0.8)
	return blockwithinrange(pos.x + 0.15, pos.y - 0.08 + spdy, pos.z + 0.15, pos.x + 0.85, pos.y + 2 + spdy, pos.z + 0.85, name)
end

minetest.register_globalstep(function(dtime)
	for _, player in pairs(get_connected_players()) do
		local pname = player:get_player_name()
		if not hurtwait[pname] then
			if blocktouching(player, "default:cactus") then
				player:set_hp(player:get_hp() - 1, "cactus")
				hurtwait[pname] = true
				minetest.after(0.5, function() hurtwait[pname] = nil end)
			end
		end
	end
end)

--[[minetest.register_chatcommand("pos", {
	params = "",
	description = "Position",
	privs = { server = true },
	func = function(name, param)
		minetest.chat_send_player(name, minetest.colorize("#ffffff", minetest.get_player_by_name(name):get_pos()))
	end,
})]]
