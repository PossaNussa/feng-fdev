minetest.register_craftitem("color_armors:blue_tin_lump", {
	description = ("Blue Tin Lump"),
	inventory_image = "color_armors_blue_tin_lump.png",
})

minetest.register_craftitem("color_armors:green_tin_lump", {
	description = ("Green Tin Lump"),
	inventory_image = "color_armors_green_tin_lump.png",
})

minetest.register_craftitem("color_armors:red_tin_lump", {
	description = ("Red Tin Lump"),
	inventory_image = "color_armors_red_tin_lump.png",
})

minetest.register_craftitem("color_armors:yellow_tin_lump", {
	description = ("Yellow Tin Lump"),
	inventory_image = "color_armors_yellow_tin_lump.png",
})

minetest.register_craftitem("color_armors:pink_tin_lump", {
	description = ("Pink Tin Lump"),
	inventory_image = "color_armors_pink_tin_lump.png",
})

minetest.register_craftitem("color_armors:purple_tin_lump", {
	description = ("Purple Tin Lump"),
	inventory_image = "color_armors_purple_tin_lump.png",
})

minetest.register_craftitem("color_armors:blue_tin_ingot", {
	description = ("Blue Tin Ingot"),
	inventory_image = "color_armors_blue_tin_ingot.png",
})

minetest.register_craftitem("color_armors:green_tin_ingot", {
	description = ("Green Tin Ingot"),
	inventory_image = "color_armors_green_tin_ingot.png",
})

minetest.register_craftitem("color_armors:red_tin_ingot", {
	description = ("Red Tin Ingot"),
	inventory_image = "color_armors_red_tin_ingot.png",
})

minetest.register_craftitem("color_armors:yellow_tin_ingot", {
	description = ("Yellow Tin Ingot"),
	inventory_image = "color_armors_yellow_tin_ingot.png",
})

minetest.register_craftitem("color_armors:pink_tin_ingot", {
	description = ("Pink Tin Ingot"),
	inventory_image = "color_armors_pink_tin_ingot.png",
})

minetest.register_craftitem("color_armors:purple_tin_ingot", {
	description = ("Purple Tin Ingot"),
	inventory_image = "color_armors_purple_tin_ingot.png",
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:blue_tin_ingot",
	recipe = "color_armors:blue_tin_lump",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:green_tin_ingot",
	recipe = "color_armors:green_tin_lump",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:red_tin_ingot",
	recipe = "color_armors:red_tin_lump",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:pink_tin_ingot",
	recipe = "color_armors:pink_tin_lump",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:yellow_tin_ingot",
	recipe = "color_armors:yellow_tin_lump",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "color_armors:purple_tin_ingot",
	recipe = "color_armors:purple_tin_lump",
	cooktime = 15,
})

if minetest.get_modpath("3d_armor") then
	minetest.register_craft({
		output = "color_armors:blue_helmet",
		recipe = {
			{"color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:blue_chestplate",
		recipe = {
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:blue_leggings",
		recipe = {
			{"color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:blue_boots",
		recipe = {
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"},
			{"color_armors:blue_tin_ingot", "", "color_armors:blue_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:green_helmet",
		recipe = {
			{"color_armors:green_tin_ingot", "color_armors:green_tin_ingot", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:green_chestplate",
		recipe = {
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "color_armors:green_tin_ingot", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "color_armors:green_tin_ingot", "color_armors:green_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:green_leggings",
		recipe = {
			{"color_armors:green_tin_ingot", "color_armors:green_tin_ingot", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:green_boots",
		recipe = {
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"},
			{"color_armors:green_tin_ingot", "", "color_armors:green_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:red_helmet",
		recipe = {
			{"color_armors:red_tin_ingot", "color_armors:red_tin_ingot", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:red_chestplate",
		recipe = {
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "color_armors:red_tin_ingot", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "color_armors:red_tin_ingot", "color_armors:red_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:red_leggings",
		recipe = {
			{"color_armors:red_tin_ingot", "color_armors:red_tin_ingot", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:red_boots",
		recipe = {
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"},
			{"color_armors:red_tin_ingot", "", "color_armors:red_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:yellow_helmet",
		recipe = {
			{"color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:yellow_chestplate",
		recipe = {
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:yellow_leggings",
		recipe = {
			{"color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:yellow_boots",
		recipe = {
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"},
			{"color_armors:yellow_tin_ingot", "", "color_armors:yellow_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:pink_helmet",
		recipe = {
			{"color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:pink_chestplate",
		recipe = {
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:pink_leggings",
		recipe = {
			{"color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:pink_boots",
		recipe = {
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"},
			{"color_armors:pink_tin_ingot", "", "color_armors:pink_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:purple_helmet",
		recipe = {
			{"color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:purple_chestplate",
		recipe = {
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:purple_leggings",
		recipe = {
			{"color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:purple_boots",
		recipe = {
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"},
			{"color_armors:purple_tin_ingot", "", "color_armors:purple_tin_ingot"}
		}
	})

	minetest.register_craft({
		output = "color_armors:blue_tin_lump",
		recipe = {
			{"dye:blue","default:tin_lump"}
		}
	})

	minetest.register_craft({
		output = "color_armors:green_tin_lump",
		recipe = {
			{"dye:green","default:tin_lump"}
		}
	})

	minetest.register_craft({
		output = "color_armors:red_tin_lump",
		recipe = {
			{"dye:red","default:tin_lump"}
		}
	})

	minetest.register_craft({
		output = "color_armors:yellow_tin_lump",
		recipe = {
			{"dye:yellow","default:tin_lump"}
		}
	})

	minetest.register_craft({
		output = "color_armors:pink_tin_lump",
		recipe = {
			{"dye:pink","default:tin_lump"}
		}
	})

	minetest.register_craft({
		output = "color_armors:purple_tin_lump",
		recipe = {
			{"dye:purple","default:tin_lump"}
		}
	})
end