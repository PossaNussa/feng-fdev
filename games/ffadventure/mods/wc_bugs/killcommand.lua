-- /killbugs [radius] -- for when an infestation gets out of hand.

local S = wc_bugs.S

minetest.register_chatcommand("killbugs", {
	params = "[radius]",
	description = S("Annihilate all nearby bugs"),
	privs = {server = true},
	func = function(pname, param)
		local player = minetest.get_player_by_name(pname)
		if not player then
			return false, S("You need to be in the world to do that.")
		end

		local radius = tonumber(param) or 20
		radius = math.max(1, math.min(64, math.floor(radius)))

		local pos = vector.round(player:get_pos())
		local found = minetest.find_nodes_in_area(
			vector.subtract(pos, radius), vector.add(pos, radius),
			{"group:bug"})
		for _, p in ipairs(found) do
			minetest.remove_node(p)
		end

		return true, S("Removed @1 bugs within @2 nodes.",
			tostring(#found), tostring(radius))
	end
})
