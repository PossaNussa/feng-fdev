-- Wooden Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_wood", {
	description = ("Wooden Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_wood.png",
	groups = {armor_hands=1, armor_heal=0, armor_use=2000, flammable=1},
	armor_groups = {fleshy=5},
	damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_craft({
	type = "fuel",
	recipe = "3d_armor_gloves_redo:gloves_wood",
	burntime = 4,
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"group:wood", "", "group:wood"},
            {"", "", ""},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_wood",
    })
end

-- Wooden Gauntlets --

	armor:register_armor("3d_armor_gloves_redo:gloves_bone", {
	description = ("Bone Gauntlets"),
	inventory_image = "3d_armor_gloves_redo_inv_gloves_wood.png^[colorize:white:192",
	groups = {armor_hands=1, armor_heal=0, armor_use=2000, flammable=1},
	armor_groups = {fleshy=8},
	damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
})

minetest.register_craft({
	type = "fuel",
	recipe = "3d_armor_gloves_redo:gloves_wood",
	burntime = 4,
})

if minetest.get_modpath("default") and minetest.get_modpath("farming") then
    minetest.register_craft({
        type = "shaped",
        recipe = {
            {"bonemeal:bone", "", "bonemeal:bone"},
            {"", "", ""},
            {"", "", ""}
        },
        output = "3d_armor_gloves_redo:gloves_bone",
    })
end
