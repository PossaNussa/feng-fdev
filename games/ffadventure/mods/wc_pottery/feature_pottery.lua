local modname = minetest.get_current_modname()

local rfcall = function(pos, player)
    local wield = player:get_wielded_item()
    wield:take_item(1)
    player:set_wielded_item(wield)
end

local function find_water(pos)
    return minetest.find_nodes_in_area(
        {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
        {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
        {"group:water"}
    )
end

local clay = "default_dirt.png^[colorize:#D2B48C:100"
local form = "default_tree_top.png^[mask:default_furnace_front.png"

local ceramic = "wc_pottery_ceramic.png"
local clayform = "(" .. clay .. ")^(" .. form .. ")"
local ceraform = ceramic .. "^[mask:default_furnace_front.png"

local glaze = "wc_pottery_glaze.png"
local glazpatt = "wc_pottery_glaze_pattern.png^[opacity:40"
local glaztop = "default_furnace_front.png^[opacity:40"
local glazcera = "(" .. ceramic .. ")^(" .. glaze .. ")"
local glazside = "(" .. glazcera .. ")^(" .. glazpatt .. ")"
local basket = "basket_inner.png"

minetest.register_node("wc_pottery:pottery_claypot_unfired", {
    description = "Unfired Ceramic Pot",
    tiles = {clayform, clayform, form},
    groups = {
        cracky = 1,
        oddly_breakable_by_hand = 1,
        not_in_creative_inventory = 1,
        store = 1,
        flammable = 40,
        fuel = 2,
        falling_node = 1
    },
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("wc_pottery:pottery_claypot", {
    description = "Ceramic Pot",
    tiles = {basket, ceramic, ceramic},
    groups = {
        cracky = 2,
        oddly_breakable_by_hand = 1,
        not_in_creative_inventory = 1,
        store = 1
    },
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("wc_pottery:pottery_claypot_glazed", {
    description = "Glazed Ceramic Pot",
    tiles = {basket, glazcera, glazside},
    groups = {
        cracky = 3,
        oddly_breakable_by_hand = 1,
        not_in_creative_inventory = 1,
        store = 1
    },
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft({
    output = "wc_pottery:pottery_claypot_unfired",
    type = "shapeless",
    recipe = {"default:clay", "default:stick"}
})

minetest.register_craft({
    type = "cooking",
    output = "wc_pottery:pottery_claypot",
    recipe = "wc_pottery:pottery_claypot_unfired",
    cooktime = 15
})

minetest.register_craft({
    output = "wc_pottery:pottery_claypot_glazed",
    type = "shapeless",
    recipe = {"wc_pottery:pottery_claypot", "dye:red"}
})

minetest.register_abm({
    label = "Wash unfired pottery",
    nodenames = {"wc_pottery:pottery_claypot_unfired"},
    neighbors = {"group:water"},
    interval = 10,
    chance = 4,
    action = function(pos)
        minetest.swap_node(pos, {name = "air"})
        minetest.add_item(pos, ItemStack("default:clay_lump"))
        minetest.sound_play("default_water_footstep", {gain = 0.25})
    end
})