minetest.register_tool(":stardust:pick_stellar", {
    description = "Stellar Pickaxe",
    inventory_image = "stardust_pick_stellar.png",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level = 4,
        groupcaps={
			cracky = {times={[1]=1.25, [2]=0.6, [3]=0.3}, uses=30, maxlevel=4},
		},
        damage_groups = {fleshy=7},
    },
    sound = {breaks = "default_tool_breaks"},
	groups = {pickaxe = 1}
})

minetest.register_tool(":stardust:axe_stellar", {
    description = "Stellar Axe",
    inventory_image = "stardust_axe_stellar.png",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level = 4,
        groupcaps={
			choppy = {times={[1]=1.25, [2]=0.6, [3]=0.3}, uses=30, maxlevel=4},
		},
        damage_groups = {fleshy=8},
    },
    sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1}
})

minetest.register_tool(":stardust:shovel_stellar", {
    description = "Stellar Shovel",
    inventory_image = "stardust_shovel_stellar.png",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level = 4,
        groupcaps={
			crumbly = {times={[1]=1.25, [2]=0.6, [3]=0.3}, uses=30, maxlevel=4},
		},
        damage_groups = {fleshy=5},
    },
    sound = {breaks = "default_tool_breaks"},
	groups = {shovel = 1}
})

minetest.register_tool(":stardust:sword_stellar", {
    description = "Stellar Sword",
    inventory_image = "stardust_sword_stellar.png",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level = 4,
        looting_level = 3,
        groupcaps={
			snappy = {times={[1]=1.25, [2]=0.6, [3]=0.3}, uses=30, maxlevel=4},
		},
        damage_groups = {fleshy=12},
    },
    sound = {breaks = "default_tool_breaks"},
	groups = {sword = 1}
})

local handle_material = "default:mese_crystal_fragment"
local blade_material = "stardust:stellar_ingot"

minetest.register_craft({
    output = "stardust:pick_stellar",
    recipe = {
        {blade_material, blade_material, blade_material},
        {"" ,handle_material, ""},
        {"" ,handle_material, ""},
    }
})

minetest.register_craft({
    output = "stardust:axe_stellar",
    recipe = {
        {blade_material, blade_material, ""},
        {blade_material ,handle_material, ""},
        {"" ,handle_material, ""},
    }
})

minetest.register_craft({
    output = "stardust:shovel_stellar",
    recipe = {
        {blade_material},
        {handle_material},
        {handle_material},
    }
})

minetest.register_craft({
    output = "stardust:sword_stellar",
    recipe = {
        {blade_material},
        {blade_material},
        {handle_material},
    }
})

if minetest.get_modpath("terumet") then
    terumet.register_repairable_item("stardust:pick_stellar", 225*3)
    terumet.register_repairable_item("stardust:axe_stellar", 225*3)
    terumet.register_repairable_item("stardust:shovel_stellar", 225)
    terumet.register_repairable_item("stardust:sword_stellar", 225*2)
end

if minetest.get_modpath("lucky_block") then
    lucky_block:add_blocks(
        {
            {"dro", "stardust:pick_stellar", 1},
            {"dro", "stardust:axe_stellar", 1},
            {"dro", "stardust:shovel_stellar", 1},
            {"dro", "stardust:sword_stellar", 1},
        }
    )
end
