minetest.register_chatcommand("heal", {
	description = ("Fully heal yourself"),
	privs = {heal=true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if player then
			player:set_hp(20)
		end
	end
})
minetest.register_privilege("heal", {
	description = "Can use the heal command",
	give_to_singleplayer = false,
	give_to_admin = false,
})