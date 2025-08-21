armor:register_armor("dragonbone_stuff:dragonbone_helmet", {
    description = "Dragonbone Helmet",
    inventory_image = "dragonbone_inv_helmet.png",
    texture = "dragonbone_helmet_mesh.png",
    preview = "dragonbone_helmet_preview.png",
    wear = 0,
    groups = {armor_head=1, armor_heal = 15, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=35},
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_helmet",
    recipe = {
        {"draconis:dragon_bone", "draconis:dragon_bone", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
        {"", "", ""},
    }
})

armor:register_armor("dragonbone_stuff:dragonbone_chestplate", {
    description = "Dragonbone Chestplate",
    inventory_image = "dragonbone_inv_chestplate.png",
    texture = "dragonbone_chestplate.png",
    preview = "dragonbone_chestplate_preview.png",
    wear = 0,
    groups = {armor_torso=1, armor_heal = 25, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=35},
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_chestplate",
    recipe = {
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "draconis:dragon_bone", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "draconis:dragon_bone", "draconis:dragon_bone"},
    }
})

armor:register_armor("dragonbone_stuff:dragonbone_leggins", {
    description = "Dragonbone Leggins",
    inventory_image = "dragonbone_inv_leggins.png",
    texture = "dragonbone_leggins.png",
    preview = "dragonbone_leggins_preview.png",
    wear = 0,
    groups = {armor_legs=1, armor_heal = 15, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=25},
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_leggins",
    recipe = {
        {"draconis:dragon_bone", "draconis:dragon_bone", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
    }
})

armor:register_armor("dragonbone_stuff:dragonbone_boots", {
    description = "Dragonbone Boots",
    inventory_image = "dragonbone_inv_boots.png",
    texture = "dragonbone_boots.png",
    preview = "dragonbone_boots_preview.png",
    wear = 0,
    groups = {armor_feet=1, armor_heal = 15, armor_use = 3000, armor_fire = 20},
    armor_groups = {fleshy=15},
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_boots",
    recipe = {
        {"", "", ""},
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
        {"draconis:dragon_bone", "", "draconis:dragon_bone"},
    }
})

