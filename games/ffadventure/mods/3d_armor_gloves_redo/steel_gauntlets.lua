-- Steel Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_steel", {
	description = ("Steel Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_steel.png",
	groups = {armor_hands=1, armor_heal=0, armor_use=800,
		physics_speed=-0.01, physics_gravity=0.01},
	armor_groups = {fleshy=10},
	damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"default:steel_ingot", "farming:string", "default:steel_ingot"},
            {"default:steel_ingot", "farming:string", "default:steel_ingot"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_steel",
    })
end