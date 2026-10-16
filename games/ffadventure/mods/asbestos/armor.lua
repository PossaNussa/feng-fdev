if minetest.get_modpath("3d_armor") then
        minetest.register_on_mods_loaded(function()
            minetest.settings:set("armor_fire_protect", "true")
        end)

	armor:register_armor("asbestos:armor_helmet", {
		description = ("Asbestos Headpiece"),
		inventory_image = "asbestos_armor_helmet_inv.png",
		groups = {armor_head=1, armor_fire=1, armor_use=100},
		armor_groups = {fleshy=7},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=2, level=1},
	})

	armor:register_armor("asbestos:armor_chestplate", {
		description = ("Asbestos Garment"),
		inventory_image = "asbestos_armor_chestplate_inv.png",
		groups = {armor_torso=1, armor_fire=1, armor_use=100},
		armor_groups = {fleshy=12},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=2, level=1},
	})

	armor:register_armor("asbestos:armor_leggings", {
		description = ("Asbestos Trousers"),
		inventory_image = "asbestos_armor_leggings_inv.png",
		groups = {armor_legs=1, armor_fire=1, armor_use=100},
		armor_groups = {fleshy=12},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=2, level=1},
	})

	armor:register_armor("asbestos:armor_boots", { 
		description = ("Asbestos Bootsies"), -- Bootsies for the Wolfsies
		inventory_image = "asbestos_armor_boots_inv.png",
		groups = {armor_feet=1, armor_fire=1, armor_use=100},
		armor_groups = {fleshy=7},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=2, level=1},
	})

	minetest.register_craft({
		output = "asbestos:armor_helmet",
		recipe = {
			{"asbestos:fabric", "asbestos:fabric", "asbestos:fabric"},
			{"asbestos:fabric", "default:obsidian_glass", "asbestos:fabric"},
		}
	})

	minetest.register_craft({
		output = "asbestos:armor_chestplate",
		recipe = {
			{"asbestos:fabric", "", "asbestos:fabric"},
			{"asbestos:fabric", "asbestos:fabric", "asbestos:fabric"},
			{"asbestos:fabric", "asbestos:fabric", "asbestos:fabric"},
		}
	})

	minetest.register_craft({
		output = "asbestos:armor_leggings",
		recipe = {
			{"asbestos:fabric", "asbestos:fabric", "asbestos:fabric"},
			{"asbestos:fabric", "", "asbestos:fabric"},
			{"asbestos:fabric", "", "asbestos:fabric"},
		}
	})

	minetest.register_craft({
		output = "asbestos:armor_boots",
		recipe = {
			{"asbestos:fabric", "", "asbestos:fabric"},
			{"asbestos:fabric", "", "asbestos:fabric"},
		}
	})
end