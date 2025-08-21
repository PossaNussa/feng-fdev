local modname = minetest.get_current_modname()

local potsoil = "default_dirt.png"
local ceramic = "wc_pottery_ceramic.png"
local ceraform = ceramic .. "^[mask:nc_api_storebox_frame.png"
local cerasoil = "(" .. potsoil .. ")^(" .. ceraform .. ")"

local glaze = "wc_pottery_glaze.png"
local glazpatt = "wc_pottery_glaze_pattern.png^[opacity:40"
local glazform = "nc_api_storebox_frame.png^[opacity:40"
local glazcera = "(" .. ceramic .. ")^(" .. glaze .. ")"
local glazside = "(" .. glazcera .. ")^(" .. glazpatt .. ")"
local glazetop = "(" .. glazcera .. ")^(" .. glazform .. ")^[mask:nc_api_storebox_frame.png"
local glazsoil = "(" .. potsoil .. ")^(" .. glazetop .. ")"

minetest.register_node("wc_pottery:pottery_flowerpot", {
    description = "Ceramic Flowerpot",
    tiles = {
        cerasoil,
        ceramic,
        ceramic
    },
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
    },
    groups = {crumbly = 3, flowerpot = 1},
    sounds = default.node_sound_stone_defaults(),
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- Fill with compost
        if itemstack:get_name() == "default:dirt" then
            node.name = "wc_pottery:pottery_flowerpot_filled"
            minetest.swap_node(pos, node)
            itemstack:take_item()
            return itemstack
        end
    end
})

minetest.register_node("wc_pottery:pottery_flowerpot_filled", {
    description = "Filled Ceramic Flowerpot",
    tiles = {
        glazsoil,
        glazcera,
        glazside
    },
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
    },
    groups = {crumbly = 3, flowerpot = 1},
    sounds = default.node_sound_stone_defaults(),
    on_punch = function(pos, node, puncher, pointed_thing)
        -- Empty the flowerpot
        node.name = "wc_pottery:pottery_flowerpot"
        minetest.swap_node(pos, node)
        minetest.add_item(pos, ItemStack("default:dirt"))
    end
})

minetest.register_node("wc_pottery:pottery_flowerpot_glazed", {
    description = "Glazed Ceramic Flowerpot",
    tiles = {
        glazsoil,
        glazcera,
        glazside
    },
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
    },
    groups = {crumbly = 3, flowerpot = 1},
    sounds = default.node_sound_stone_defaults(),
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- Fill with compost
        if itemstack:get_name() == "default:dirt" then
            node.name = "wc_pottery:pottery_flowerpot_glazed_filled"
            minetest.swap_node(pos, node)
            itemstack:take_item()
            return itemstack
        end
    end
})

minetest.register_craft({
    output = "wc_pottery:pottery_claypot",
    type = "shapeless",
    recipe = {"wc_pottery:pottery_claypot", "default:dirt"}
})

minetest.register_node("wc_pottery:pottery_flowerpot_glazed_filled", {
    description = "Filled Glazed Ceramic Flowerpot",
    tiles = {
        glazsoil,
        glazcera,
        glazside
    },
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
    },
    groups = {crumbly = 3, flowerpot = 1},
    sounds = default.node_sound_stone_defaults(),
    on_punch = function(pos, node, puncher, pointed_thing)
        -- Empty the flowerpot
        node.name = "wc_pottery:pottery_flowerpot_glazed"
        minetest.swap_node(pos, node)
        minetest.add_item(pos, ItemStack("default:dirt"))
    end
})