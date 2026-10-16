-- /petcall : bring every mob you own to your position.
-- Reaches any of your pets that are currently loaded (nearby, or a chunk that
-- is loaded around you). Ones the game has unloaded far away are pulled in when
-- their area loads; stand where you last had them and call again if needed.

core.register_chatcommand("petcall", {
	description = "Teleport all pets you own to you",
	privs = {},
	func = function(name)

		local player = core.get_player_by_name(name)
		if not player then
			return false, "You must be in-game."
		end

		local pos = player:get_pos()
		local found = 0

		for _, ent in pairs(core.luaentities) do
			if ent and ent.owner == name and ent.object
			and ent.health and ent.health > 0 then

				-- spread them out a touch so they don't stack on one node
				local off = {
					x = pos.x + (math.random() * 2 - 1),
					y = pos.y + 0.5,
					z = pos.z + (math.random() * 2 - 1),
				}

				ent.object:set_pos(off)
				ent.object:set_velocity({x = 0, y = 0, z = 0})
				-- sit them right where they land so they stay with you
				ent.order = "stand"
				ent.state = "stand"
				found = found + 1
			end
		end

		if found == 0 then
			return true, "No pets of yours are loaded right now. Go to where you "
				.. "last saw them so the area loads, then run /petcall again."
		end

		return true, "Called " .. found .. " of your pets to you."
	end,
})
