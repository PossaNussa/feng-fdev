-- Cactus Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_cactus", {
	description = ("Cactus Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_cactus.png",
	groups = {armor_hands=1, armor_heal=0, armor_use=1000},
	armor_groups = {fleshy=5},
	damage_groups = {cracky=3, snappy=3, choppy=2, crumbly=2, level=1},
})

minetest.register_craft({
	type = "fuel",
	recipe = "3d_armor_gloves_redo:gloves_cactus",
	burntime = 8,
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"default:cactus", "farming:string", "default:cactus"},
            {"default:cactus", "farming:string", "default:cactus"},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_cactus",
    })
end