if minetest.get_modpath("3d_armor") then

armor:register_armor(":stardust:helmet_stellar", {
    description = "Stellar Helmet",
    inventory_image = "stardust_inv_helmet_stellar.png",
    texture = "stardust_helmet_stellar.png",
    preview = "stardust_armor_helmet_stellar_preview.png",
    groups = {armor_head=1, armor_heal=15, armor_use=135,
        physics_speed=0.03, physics_gravity=-0.03},
    armor_groups = {fleshy=20, radiation=25},
    damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

armor:register_armor(":stardust:chestplate_stellar", {
    description = "Stellar Chestplate",
    inventory_image = "stardust_inv_chestplate_stellar.png",
    texture = "stardust_chestplate_stellar.png",
    preview = "stardust_armor_chestplate_stellar_preview.png",
    groups = {armor_torso=1, armor_heal=15, armor_use=135,
        physics_speed=0.04, physics_gravity=-0.04},
    armor_groups = {fleshy=27, radiation=40},
    damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

armor:register_armor(":stardust:leggings_stellar", {
	description = "Stellar Leggings",
	inventory_image = "stardust_inv_leggings_stellar.png",
	texture = "stardust_leggings_stellar.png",
    preview = "stardust_armor_leggings_stellar_preview.png",
	groups = {armor_legs=1, armor_heal=15, armor_use=135,
		physics_speed=0.03, physics_gravity=-0.03},
	armor_groups = {fleshy=25, radiation=35},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

armor:register_armor(":stardust:boots_stellar", {
	description = "Stellar Boots",
	inventory_image = "stardust_inv_boots_stellar.png",
	texture = "stardust_boots_stellar.png",
    preview = "stardust_armor_boots_stellar_preview.png",
	groups = {armor_feet=1, armor_heal=15, armor_use=135,
		physics_speed=0.02, physics_gravity=-0.02},
	armor_groups = {fleshy=18},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

minetest.register_craft({
    output = "stardust:helmet_stellar",
    recipe = {
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"}
    }
})

minetest.register_craft({
    output = "stardust:chestplate_stellar",
    recipe = {
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"}
    }
})

minetest.register_craft({
    output = "stardust:leggings_stellar",
    recipe = {
        {"stardust:stellar_ingot", "stardust:stellar_ingot", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"}
    }
})

minetest.register_craft({
    output = "stardust:boots_stellar",
    recipe = {
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"},
        {"stardust:stellar_ingot", "", "stardust:stellar_ingot"}
    }
})

if minetest.get_modpath("terumet") then
    terumet.register_repairable_item("stardust:helmet_stellar", 225*5)
    terumet.register_repairable_item("stardust:chestplate_stellar", 225*8)
    terumet.register_repairable_item("stardust:leggings_stellar", 225*7)
    terumet.register_repairable_item("stardust:boots_stellar", 225*4)
end

if minetest.get_modpath("lucky_block") then
    lucky_block:add_blocks(
        {
            {"dro", "stardust:helmet_stellar", 1},
            {"dro", "stardust:chestplate_stellar", 1},
            {"dro", "stardust:leggings_stellar", 1},
            {"dro", "stardust:boots_stellar", 1},
        }
    )
end

end
