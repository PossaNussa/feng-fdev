-- ===================================================================

local S   = castle.S

-- ===================================================================

minetest.register_node ("castle:hides", {
    drawtype = "nodebox",
    description = S("Hides"),
    inventory_image = "castle_hide.png",
    paramtype = "light",
    walkable = false,
    tiles = {'castle_hide.png'},
    climbable = true,
    paramtype2 = "wallmounted",
    groups = {dig_immediate=2},
    node_box = {
        type = "wallmounted",
        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
    },
})

-- ===================================================================

minetest.register_craft( {
    type = "shapeless",
    output = "castle:hides 6",
    recipe = { "wool:white" , "bucket:bucket_water" },
    replacements = {
        { 'bucket:bucket_water', 'bucket:bucket_empty' }
    }
})

-- ===================================================================

minetest.register_node("castle:bound_straw", {
    description = S("Bound Straw"),
    drawtype = "normal",
    tiles = {"castle_straw_bale.png"},
    groups = {choppy=4, flammable=1, oddly_breakable_by_hand=3},
    sounds = default.node_sound_leaves_defaults(),
    paramtype = "light",
})

-- ===================================================================

minetest.register_node("castle:straw_dummy", {
    description = S("Training Dummy"),
    tiles = {"castle_straw_dummy.png"},
    groups = {choppy=4, flammable=1, oddly_breakable_by_hand=3},
    sounds = default.node_sound_leaves_defaults(),
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.125, 0, 0.1875, 0.125}, -- right_leg
            {0, -0.5, -0.125, 0.25, 0.1875, 0.125}, -- left_leg
            {-0.25, 0.1875, -0.1875, 0.25, 0.875, 0.125}, -- torso
            {0.25, 0.1875, -0.125, 0.5, 0.875, 0.125}, -- left_arm
            {-0.5, 0.1875, -0.125, -0.25, 0.875, 0.125}, -- right_arm
            {-0.25, 0.875, -0.25, 0.25, 1.3125, 0.1875}, -- head
        }
    }
})

-- ===================================================================

minetest.register_craft({
    output = "castle:straw_dummy",
    recipe = {
        {"group:stick", "castle:bound_straw","group:stick"},
        {"", "castle:bound_straw",""},
        {"group:stick", "","group:stick"},
    },
})

-- ===================================================================

minetest.register_craft({
    output = "castle:bound_straw 6",
    type = "shapeless",
    recipe = {"farming:straw", "farming:straw", "farming:straw", "farming:straw", "farming:straw", "farming:straw", "ropes:ropesegment",}
})

-- ===================================================================

minetest.register_craft({
    output = "castle:bound_straw",
    type = "shapeless",
    recipe = {"farming:straw", "farming:cotton",}
})

-- ===================================================================

minetest.register_craft({
    type = "fuel",
    recipe = "castle:bound_straw",
    burntime = 10
})

-- ===================================================================

local stick_burn_time = minetest.get_craft_result({method="fuel", width=1, items={ItemStack("default:stick")}}).time

minetest.register_craft({
    type = "fuel",
    recipe = "castle:straw_dummy",
    burntime = 10*2 + 4*stick_burn_time
})

-- ===================================================================
