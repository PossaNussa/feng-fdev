print("This file will be run at load time!")

local MP = minetest.get_modpath("ancient_ice_stuff")

if minetest.get_modpath("3d_armor") then
	dofile(MP.."/armor.lua")
end

dofile(MP.."/decorations.lua")

minetest.register_craftitem("ancient_ice_stuff:ancient_ice_fragment", {
    description = "Ancient Ice Fragment",
    inventory_image = "ancient_ice_fragment.png"
})

minetest.register_node("ancient_ice_stuff:ancient_ice_stuff_ore", {
    description = "Stalhrim Ore",
    tiles = {"ancient_ice_stuff_ore.png"},
    groups = {cracky=1, stone=1},
    is_ground_content = true,
    drop = "ancient_ice_stuff:ancient_ice_fragment 2"
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "ancient_ice_stuff:ancient_ice_stuff_ore",
    wherein        = "default:stone",
    clust_scarcity = 18 * 18 * 18,
    clust_num_ores = 2,
    clust_size     = 2,
    height_min     = -31000,
    height_max     = 31000
})

minetest.register_craftitem("ancient_ice_stuff:ancient_ice_mace_head", {
    description = "Ancient Ice Mace Head",
    inventory_image = "ancient_ice_mace_head.png"
})

minetest.register_craftitem("ancient_ice_stuff:reinforced_stick", {
    description = "Reinforced Stick",
    inventory_image = "reinforced_stick.png"
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_mace_head 1",
    recipe = {
        {"ancient_ice_stuff:ancient_ice_fragment", "steel_ingot", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "steel_ingot", "ancient_ice_stuff:ancient_ice_fragment"},
        {"", "steel_ingot", ""}
    }
})

minetest.register_tool("ancient_ice_stuff:ancient_ice_mace", {
    description = "Ancient Ice Mace",
    inventory_image = "ancient_ice_mace.png",
	tool_capabilities = {
		full_punch_interval = 3,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=3, [2]=2, [3]=1}, uses=500, maxlevel=3},
		},
		damage_groups = {fleshy=26},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craft({
    output = "ancient_ice_stuff:reinforced_stick 1",
    recipe = {
        {"", "steel_ingot", ""},
        {"", "group:stick", ""},
        {"", "group:stick", ""}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_mace 1",
    recipe = {
        {"", "ancient_ice_stuff:ancient_ice_mace_head", ""},
        {"", "steel_ingot", ""},
        {"", "ancient_ice_stuff:reinforced_stick", ""}
    }
})

minetest.register_tool("ancient_ice_stuff:ancient_ice_scythe", {
    description = "Ancient Ice Scythe",
    inventory_image = "ancient_ice_scythe.png",
	tool_capabilities = {
		full_punch_interval = 4,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=3, [2]=2, [3]=1}, uses=550, maxlevel=1},
                    cracky={times={[1]=0.50, [2]=0.30, [3]=0.10}, uses=550, maxlevel=1}
		},
		damage_groups = {fleshy=28},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_craftitem("ancient_ice_stuff:ancient_ice_scythe_major_head", {
    description = "Ancient Ice Scythe Major Head",
    inventory_image = "ancient_ice_scythe_major_head.png"
})

minetest.register_craftitem("ancient_ice_stuff:ancient_ice_scythe_minor_head", {
    description = "Ancient Ice Scythe Minor Head",
    inventory_image = "ancient_ice_scythe_minor_head.png"
})

minetest.register_craftitem("ancient_ice_stuff:iron_structure", {
    description = "Iron Structure",
    inventory_image = "iron_structure.png"
})

minetest.register_craftitem("ancient_ice_stuff:iron_structure_with_ancient_ice", {
    description = "Iron Structure With Ancient Ice",
    inventory_image = "iron_structure_with_ancient_ice.png"
})

minetest.register_craft({
    output = "ancient_ice_stuff:iron_structure 1",
    recipe = {
        {"steel_ingot", "", "steel_ingot"},
        {"", "steelblock", ""},
        {"steel_ingot", "", "steel_ingot"}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:iron_structure_with_ancient_ice 1",
    recipe = {
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:iron_structure", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_scythe_major_head 1",
    recipe = {
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_scythe_minor_head 1",
    recipe = {
        {"", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
        {"", "", "ancient_ice_stuff:ancient_ice_fragment"},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_scythe 1",
    recipe = {
        {"ancient_ice_stuff:ancient_ice_scythe_major_head", "ancient_ice_stuff:iron_structure_with_ancient_ice", "ancient_ice_stuff:ancient_ice_scythe_minor_head"},
        {"", "ancient_ice_stuff:reinforced_stick", ""},
        {"ancient_ice_stuff:reinforced_stick", "", ""}
    }
})

minetest.register_tool("ancient_ice_stuff:ancient_ice_axe", {
    description = "Ancient Ice Axe",
    inventory_image = "ancient_ice_axe.png",
	tool_capabilities = {
		full_punch_interval = 2,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=4, [2]=3, [3]=2}, uses=350, maxlevel=1},
                    choppy={times={[1]=1, [2]=0,50, [3]=0.10}, uses=350, maxlevel=1}
		},
		damage_groups = {fleshy=25},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_tool("ancient_ice_stuff:ancient_ice_short_sword", {
    description = "Ancient Ice Short Sword",
    inventory_image = "ancient_ice_short_sword.png",
	tool_capabilities = {
		full_punch_interval = 1.5,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=4, [2]=3, [3]=2}, uses=350, maxlevel=1},
		},
		damage_groups = {fleshy=20},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_tool("ancient_ice_stuff:ancient_ice_long_sword", {
    description = "Ancient Ice Long Sword",
    inventory_image = "ancient_ice_long_sword.png",
	tool_capabilities = {
		full_punch_interval = 2.5,
		max_drop_level=1,
		groupcaps={
					snappy={times={[1]=4, [2]=3, [3]=2}, uses=350, maxlevel=1},
		},
		damage_groups = {fleshy=27},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_short_sword 1",
    recipe = {
        {"", "ancient_ice_stuff:ancient_ice_fragment", ""},
        {"", "ancient_ice_stuff:ancient_ice_fragment", ""},
        {"", "ancient_ice_stuff:reinforced_stick", ""}
    }
})

minetest.register_craftitem("ancient_ice_stuff:ancient_ice_long_sword_blade", {
    description = "Ancient Ice Long Sword Blade",
    inventory_image = "ancient_ice_long_sword_blade.png"
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_long_sword_blade 1",
    recipe = {
        {"", "ancient_ice_stuff:ancient_ice_fragment", ""},
        {"", "ancient_ice_stuff:ancient_ice_fragment", ""},
        {"", "ancient_ice_stuff:iron_structure_with_ancient_ice", ""}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_long_sword 1",
    recipe = {
        {"", "ancient_ice_stuff:ancient_ice_long_sword_blade", ""},
        {"", "ancient_ice_stuff:ancient_ice_fragment", ""},
        {"", "ancient_ice_stuff:reinforced_stick", ""}
    }
})

minetest.register_craft({
    output = "ancient_ice_stuff:ancient_ice_axe 1",
    recipe = {
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:ancient_ice_fragment"},
        {"ancient_ice_stuff:ancient_ice_fragment", "ancient_ice_stuff:reinforced_stick", ""},
        {"", "ancient_ice_stuff:reinforced_stick", ""}
    }
})