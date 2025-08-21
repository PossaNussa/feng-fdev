minetest.register_node("hardcore_farming:scarecrow", {
	description = "Scarecrow",
	drawtype = "mesh",
	mesh = "scarecrow.obj",
	paramtype2 = "facedir",
	tiles = {
		"badland_scarecrow.png",
	},
	visual_scale = 0.5,
	wield_image = "badland_scarecrow_item.png",
	wield_scale = {x=1.0, y=1.0, z=1.0},
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
	},
	inventory_image = "badland_scarecrow_item.png",
	groups = {choppy = 1, oddly_breakable_by_hand = 1, scarecrow = 1},
	sounds = default.node_sound_wood_defaults()
})

