-- Woven Gauntlets --

	armor:register_armor("3d_armor_gloves_ae:gloves_woven", {
	description = ("Woven Gauntlets"),
	inventory_image = "3d_armor_gloves_ae_inv_gloves_woven.png",
	groups = {armor_hands=1, armor_heal=0, armor_use=2500, flammable=1},
	armor_groups = {fleshy=5},
	damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

if minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"group:grass", "farming:string", "group:grass"},
            {"group:grass", "farming:string", "group:grass"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_ae:gloves_woven",
    })
end