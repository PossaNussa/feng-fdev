-- Diamond Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_diamond", {
	description = ("Diamond Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_diamond.png",
	groups = {armor_hands=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"default:diamond", "farming:string", "default:diamond"},
            {"default:diamond", "farming:string", "default:diamond"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_diamond",
    })
end