local S = minetest.get_translator("livingdesert")

local modname = "livingdesert"
local modpath = minetest.get_modpath(modname)
local mg_name = minetest.get_mapgen_setting("mg_name")

doors.register_trapdoor("livingdesert:datepalm_trapdoor", {
	description = S"Date Palm Trapdoor",
	inventory_image = "livingdesert_datepalm_trapdoor.png",
	wield_image = "livingdesert_datepalm_trapdoor.png",
	tile_front = "livingdesert_datepalm_trapdoor.png",
	tile_side = "livingdesert_datepalm_trapdoor_side.png",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
	gain_open = 0.06,
	gain_close = 0.13,

})

minetest.register_craft({
	output = "livingdesert:datepalm_trapdoor 2",
	recipe = {
		{"livingdesert:date_palm_wood", "livingdesert:date_palm_wood", "livingdesert:date_palm_wood"},
		{"livingdesert:date_palm_wood", "livingdesert:date_palm_trunk", "livingdesert:date_palm_wood"},
	}
})

doors.register("livingdesert_datepalm_door", {
    tiles = {{ name = "livingdesert_datepalm_door.png", backface_culling = true }},
    description = S"Date Palm Door",
    inventory_image = "livingdesert_item_datepalm_door.png",
    groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    gain_open = 0.06,
    gain_close = 0.13,
	recipe = {
		{"livingdesert:date_palm_wood", "livingdesert:date_palm_wood"},
		{"livingdesert:date_palm_trunk", "livingdesert:date_palm_trunk"},
		{"livingdesert:date_palm_wood", "livingdesert:date_palm_wood"},
	} 
})

doors.register_trapdoor("livingdesert:saxaul_trapdoor", {
	description = S"Saxaul Trapdoor",
	inventory_image = "livingdesert_saxaul_trapdoor.png",
	wield_image = "livingdesert_saxaul_trapdoor.png",
	tile_front = "livingdesert_saxaul_trapdoor.png",
	tile_side = "livingdesert_saxaul_trapdoor_side.png",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
	gain_open = 0.06,
	gain_close = 0.13,

})

minetest.register_craft({
	output = "livingdesert:saxaul_trapdoor 2",
	recipe = {
		{"livingdesert:saxaul_wood", "livingdesert:saxaul_wood", "livingdesert:saxaul_wood"},
		{"livingdesert:saxaul_wood", "livingdesert:saxaul_trunk", "livingdesert:saxaul_wood"},
	}
})

doors.register("livingdesert_saxaul_door", {
    tiles = {{ name = "livingdesert_saxaul_door.png", backface_culling = true }},
    description = S"Saxaul Door",
    inventory_image = "livingdesert_item_saxaul_door.png",
    groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    gain_open = 0.06,
    gain_close = 0.13,
	recipe = {
		{"livingdesert:saxaul_wood", "livingdesert:saxaul_wood"},
		{"livingdesert:saxaul_trunk", "livingdesert:saxaul_trunk"},
		{"livingdesert:saxaul_wood", "livingdesert:saxaul_wood"},
	} 
})

doors.register_trapdoor("livingdesert:pine_trapdoor", {
	description = S"Cold Desert Larch Trapdoor",
	inventory_image = "livingdesert_pine_trapdoor.png",
	wield_image = "livingdesert_pine_trapdoor.png",
	tile_front = "livingdesert_pine_trapdoor.png",
	tile_side = "livingdesert_pine_trapdoor_side.png",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
	gain_open = 0.06,
	gain_close = 0.13,

})

minetest.register_craft({
	output = "livingdesert:pine_trapdoor 2",
	recipe = {
		{"livingdesert:pine_wood", "livingdesert:pine_wood", "livingdesert:pine_wood"},
		{"livingdesert:pine_wood", "livingdesert:pine_trunk", "livingdesert:pine_wood"},
	}
})

doors.register("livingdesert_pine_door", {
    tiles = {{ name = "livingdesert_pine_door.png", backface_culling = true }},
    description = S"Cold Desert Larch Door",
    inventory_image = "livingdesert_item_pine_door.png",
    groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    gain_open = 0.06,
    gain_close = 0.13,
	recipe = {
		{"livingdesert:pine_wood", "livingdesert:pine_wood"},
		{"livingdesert:pine_trunk", "livingdesert:pine_trunk"},
		{"livingdesert:pine_wood", "livingdesert:pine_wood"},
	} 
})