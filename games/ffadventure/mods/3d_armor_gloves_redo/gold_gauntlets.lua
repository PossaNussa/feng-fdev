-- Gold Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_gold", {
	description = ("Gold Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_gold.png",
	groups = {armor_hands=1, armor_heal=6, armor_use=300,
		physics_speed=-0.02, physics_gravity=0.02},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=1, snappy=2, choppy=2, crumbly=3, level=2},
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"default:gold_ingot", "farming:string", "default:gold_ingot"},
            {"default:gold_ingot", "farming:string", "default:gold_ingot"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_gold",
    })
end