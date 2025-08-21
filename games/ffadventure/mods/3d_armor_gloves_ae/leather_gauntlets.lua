-- Leather Gauntlets --

	armor:register_armor("3d_armor_gloves_ae:gloves_leather", {
	description = ("Leather Gloves"),
	inventory_image = "3d_armor_gloves_ae_inv_gloves_leather.png",
	groups = {armor_hands=1, armor_heal=0, armor_use=800, flammable=1},
	armor_groups = {fleshy=9},
	damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=2, level=1},
})

if minetest.get_modpath("farming") and minetest.get_modpath("mobs") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"group:leather", "farming:string", "group:leather"},
            {"group:leather", "farming:string", "group:leather"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_ae:gloves_leather",
    })
end