local function get_node_drops(fullRockNode, cobbleRockNode)
    return {
        max_items = 1,
        items = {
            {
                -- drop the cobble variant with 1/3 chance
                items = {cobbleRockNode},
                rarity = 3,
            },
            {
                -- drop the full node with 2/3 chance
                items = {fullRockNode},
            }
        }
    }
end

----------
-- Nodes
----------

--[[
    Chalk
]]
minetest.register_node("darkage:chalk", {
    description = "Chalk",
    tiles = {"darkage_chalk.png"},
    is_ground_content = true,
    drop = 'darkage:chalk_powder 2',
    groups = {crumbly=2, cracky=2, not_cuttable=1},
    sounds = default.node_sound_stone_defaults()
})

minetest.register_node("darkage:cobble_with_plaster", {
    description = "Cobblestone with Plaster",
    tiles = {"darkage_chalk.png^(default_cobble.png^[mask:darkage_plaster_mask_D.png)", "darkage_chalk.png^(default_cobble.png^[mask:darkage_plaster_mask_B.png)", 
        "darkage_chalk.png^(default_cobble.png^[mask:darkage_plaster_mask_C.png)", "darkage_chalk.png^(default_cobble.png^[mask:darkage_plaster_mask_A.png)", 
        "default_cobble.png", "darkage_chalk.png"},
    is_ground_content = false,
    paramtype2 = "facedir",
    drop = 'default:cobble',
    groups = {cracky=3, not_cuttable=1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("darkage:chalked_bricks_with_plaster", {
    description = "Chalked Bricks with Plaster",
    tiles = {"darkage_chalk.png^(darkage_chalked_bricks.png^[mask:darkage_plaster_mask_D.png)", "darkage_chalk.png^(darkage_chalked_bricks.png^[mask:darkage_plaster_mask_B.png)", 
        "darkage_chalk.png^(darkage_chalked_bricks.png^[mask:darkage_plaster_mask_C.png)", "darkage_chalk.png^(darkage_chalked_bricks.png^[mask:darkage_plaster_mask_A.png)", 
        "darkage_chalked_bricks.png", "darkage_chalk.png"},
    is_ground_content = false,
    paramtype2 = "facedir",
    drop = 'default:cobble',
    groups = {cracky=3, not_cuttable=1},
    sounds = default.node_sound_stone_defaults(),
})

--lbm to convert the old cobble_with_plaster to the new chalked_bricks to keep texture consistent
minetest.register_lbm({
    name="darkage:convert_cobble_with_plaster",
    nodenames= "darkage:cobble_with_plaster",
    run_at_every_load = false,
    action = function(pos,node)
        node.name = "darkage:chalked_bricks_with_plaster"
        minetest.swap_node(pos, node)
    end
})

minetest.register_node("darkage:darkdirt", {
    description = "Dark Dirt",
    tiles = {"darkage_darkdirt.png"},
    is_ground_content = false,
    groups = {crumbly=2, not_cuttable=1},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("darkage:dry_leaves", {
    description = "Dry Leaves",
    tiles = {"darkage_dry_leaves.png"},
    is_ground_content = false,
    paramtype = "light",
    groups = {snappy=3, flammable=2},
    sounds = default.node_sound_leaves_defaults()
})


-- Removed straw, because its in minetst game. Registering alias for compatibility reasons
minetest.register_alias("darkage:straw", "farming:straw")

minetest.register_node("darkage:chalked_bricks", {
    description = "Chalked Brick",
    tiles = {"darkage_chalked_bricks.png"},
    is_ground_content = false,
    groups = {cracky = 2, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
    output = "darkage:chalked_bricks 4",
    recipe = {
        {"default:stone",           "default:stone",        "darkage:chalk_powder"},
        {"darkage:chalk_powder",    "darkage:chalk_powder", "darkage:chalk_powder"},
        {"default:stone",           "darkage:chalk_powder", "default:stone"},
    }
})
