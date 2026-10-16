minetest.register_node("asbestos:snow", {
	description = ("Asbestos Snow"),
	tiles = {"asbestos_snow.png"},
	inventory_image = "asbestos_snowball.png",
	wield_image = "asbestos_snowball.png",
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -6 / 16, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, asbestos_snow = 1},
	sounds = default.node_sound_snow_defaults(),
	_tnt_loss = 1, -- means it will disappear entirely

--	on_construct = function(pos)
--		pos.y = pos.y - 1
--		if minetest.get_node(pos).name == "default:dirt_with_grass" then
--			minetest.set_node(pos, {name = "default:dirt_with_snow"})
--		end
--	end,
})

minetest.register_node("asbestos:snow_block", {
	description = ("Asbestos Snow Block"),
	tiles = {"asbestos_snow.png"},
	groups = {crumbly = 3, asbestos_snow = 1},
	sounds = default.node_sound_snow_defaults(),

--	on_construct = function(pos)
--		pos.y = pos.y - 1
--		if minetest.get_node(pos).name == "default:dirt_with_grass" then
--			minetest.set_node(pos, {name = "default:dirt_with_snow"})
--		end
--	end,
})

minetest.register_craft({
	output = "asbestos:snow_block",
	recipe = {
		{"asbestos:snow", "asbestos:snow", "asbestos:snow"},
		{"asbestos:snow", "asbestos:snow", "asbestos:snow"},
		{"asbestos:snow", "asbestos:snow", "asbestos:snow"},
	}
})

minetest.register_craft({
	output = "asbestos:snow 5",
	recipe = {
		{"asbestos:lump", "", "asbestos:lump"},
		{"", "asbestos:lump", ""},
		{"asbestos:lump", "", "asbestos:lump"},
	}
})

minetest.register_craft({
	output = "asbestos:snow 9",
	recipe = {
		{"asbestos:snow_block"},
	}
})