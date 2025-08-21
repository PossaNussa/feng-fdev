-- Bronze Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_bronze", {
	description = ("Bronze Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_bronze.png",
	groups = {armor_hands=1, armor_heal=6, armor_use=400,
			physics_speed=-0.01, physics_gravity=0.01},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"default:bronze_ingot", "farming:string", "default:bronze_ingot"},
            {"default:bronze_ingot", "farming:string", "default:bronze_ingot"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_bronze",
    })
end