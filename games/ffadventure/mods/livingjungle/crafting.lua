local S = minetest.get_translator("livingjungle")

local modname = "livingjungle"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")


doors.register_trapdoor("livingjungle:samauma_trapdoor", {
	description = S"Samauma Trapdoor",
	inventory_image = "livingjungle_samauma_trapdoor.png",
	wield_image = "livingjungle_samauma_trapdoor.png",
	tile_front = "livingjungle_samauma_trapdoor.png",
	tile_side = "livingjungle_samauma_trapdoor_side.png",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
	gain_open = 0.06,
	gain_close = 0.13,

})

minetest.register_craft({
	output = "livingjungle:samauma_trapdoor 2",
	recipe = {
		{"livingjungle:samauma_wood", "livingjungle:samauma_wood", "livingjungle:samauma_wood"},
		{"livingjungle:samauma_wood", "livingjungle:samauma_trunk", "livingjungle:samauma_wood"},
	}
})

doors.register("livingjungle_samauma_door", {
    tiles = {{ name = "livingjungle_samauma_door.png", backface_culling = true }},
    description = S"Samauma Door",
    inventory_image = "livingjungle_item_samauma_door.png",
    groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    gain_open = 0.06,
    gain_close = 0.13,
	recipe = {
		{"livingjungle:samauma_wood", "livingjungle:samauma_wood"},
		{"livingjungle:samauma_trunk", "livingjungle:samauma_trunk"},
		{"livingjungle:samauma_wood", "livingjungle:samauma_wood"},
	} 
})