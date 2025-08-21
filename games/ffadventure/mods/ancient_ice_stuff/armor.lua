armor:register_armor("ancient_ice_stuff:ancient_ice_chestplate", {
    description = "Ancient Ice Chestplate",
    inventory_image = "ancient_ice_stuff_inv_ancient_ice_chestplate.png",
    texture = "ancient_ice_stuff_ancient_ice_chestplate.png",
    preview = "ancient_ice_stuff_ancient_ice_chestplate_preview.png",
    wear = 0,
    groups = {armor_torso=1, armor_heal = 20, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=30},
})

armor:register_armor("ancient_ice_stuff:ancient_ice_helmet", {
    description = "Ancient Ice Helmet",
    inventory_image = "ancient_ice_stuff_inv_ancient_ice_helmet.png",
    texture = "ancient_ice_stuff_ancient_ice_helmet.png",
    preview = "ancient_ice_stuff_ancient_ice_helmet_preview.png",
    wear = 0,
    groups = {armor_head=1, armor_heal = 10, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=20},
})

armor:register_armor("ancient_ice_stuff:ancient_ice_boots", {
    description = "Ancient Ice Boots",
    inventory_image = "ancient_ice_stuff_inv_ancient_ice_boots.png",
    texture = "ancient_ice_stuff_ancient_ice_boots.png",
    preview = "ancient_ice_stuff_ancient_ice_boots_preview.png",
    wear = 0,
    groups = {armor_feet=1, armor_heal = 10, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=20},
})

armor:register_armor("ancient_ice_stuff:ancient_ice_leggins", {
    description = "Ancient Ice Leggins",
    inventory_image = "ancient_ice_stuff_inv_ancient_ice_leggins.png",
    texture = "ancient_ice_stuff_ancient_ice_leggins.png",
    preview = "ancient_ice_stuff_ancient_ice_leggins_preview.png",
    wear = 0,
    groups = {armor_legs=1, armor_heal = 20, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=30},
})

minetest.register_craft({
	output = "ancient_ice_stuff:ancient_ice_boots",
	recipe = {
		{"ancient_ice_stuff:ancient_ice_fragment", "", "ancient_ice_stuff:ancient_ice_fragment"},
		{"ancient_ice_stuff:iron_structure_with_ancient_ice", "", "ancient_ice_stuff:iron_structure_with_ancient_ice"}
	}
})
minetest.register_craft({
	output = "ancient_ice_stuff:ancient_ice_chestplate",
	recipe = {
		{"ancient_ice_stuff:iron_structure_with_ancient_ice", "", "ancient_ice_stuff:iron_structure_with_ancient_ice"},
		{"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"}
	}
})

minetest.register_craft({
	output = "ancient_ice_stuff:ancient_ice_leggins",
	recipe = {
		{"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
		{"ancient_ice_stuff:iron_structure_with_ancient_ice", "", "ancient_ice_stuff:iron_structure_with_ancient_ice"},
        {"ancient_ice_stuff:ancient_ice_fragment", "", "ancient_ice_stuff:ancient_ice_fragment"}
	}
})

minetest.register_craft({
	output = "ancient_ice_stuff:ancient_ice_helmet",
	recipe = {
		{"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
		{"ancient_ice_stuff:iron_structure_with_ancient_ice", "", "ancient_ice_stuff:iron_structure_with_ancient_ice"}
	}
})


if minetest.get_modpath("shields") then

    armor:register_armor("ancient_ice_stuff:ancient_ice_shield", {
        description = "Ancient Ice Shield",
        inventory_image = "ancient_ice_stuff_inv_ancient_ice_shield.png",
        texture = "ancient_ice_stuff_ancient_ice_shield.png",
        preview = "ancient_ice_stuff_ancient_ice_shield_preview.png",
        wear = 0,
        groups = {armor_shield=1, armor_heal = 15, armor_use = 3000, armor_fire = 20},
        armor_groups = {fleshy=25},
    })
    
    minetest.register_craft({
	    output = "ancient_ice_stuff:ancient_ice_shield",
	    recipe = {
		    {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
		    {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:iron_structure_with_ancient_ice", "ancient_ice_stuff:ancient_ice_fragment"},
            {"", "ancient_ice_stuff:ancient_ice_fragment", ""}
	    }
    })

end
