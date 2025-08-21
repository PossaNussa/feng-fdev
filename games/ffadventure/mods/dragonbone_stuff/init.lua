print("This file will be run at load time!")

local MP = minetest.get_modpath("dragonbone_stuff")

if minetest.get_modpath("3d_armor") then
	dofile(MP.."/armor.lua")
end

minetest.register_tool("dragonbone_stuff:dragonbone_sword", {
    description = "Dragonbone Sword",
    inventory_image = "dragonbone_sword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=3, [2]=2, [3]=1}, uses=500, maxlevel=3},
		},
		damage_groups = {fleshy=12},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_sword 1",
    recipe = {
        {"", "draconis:dragon_bone", ""},
        {"", "draconis:dragon_bone", ""},
        {"", "steel_ingot", ""}
    }
})

minetest.register_tool("dragonbone_stuff:dragonbone_pickaxe", {
    description = "Dragon bone pickaxe",
    inventory_image = "dragonbone_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=3, [2]=2, [3]=1}, uses=550, maxlevel=1},
                    cracky={times={[1]=0.50, [2]=0.30, [3]=0.10}, uses=550, maxlevel=1}
		},
		damage_groups = {fleshy=8},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_craft({
    output = "dragonbone_stuff:dragonbone_pickaxe 1",
    recipe = {
        {"draconis:dragon_bone", "draconis:dragon_bone", "draconis:dragon_bone"},
        {"", "steel_ingot", ""},
        {"", "steel_ingot", ""}
    }
})