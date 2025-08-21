local modname = minetest.get_current_modname()
local chip_texture = "default_stone.png^[colorize:#D2B48C:100"
local ceramic_texture = "wc_pottery:_ceramic.png"

minetest.register_craftitem("wc_pottery:chip", {
    description = "Ceramic Chip",
    inventory_image = chip_texture,
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("wc_pottery:ceramic", {
    description = "Ceramic",
    tiles = {ceramic_texture .. "^[mask:default_stone.png"},
    groups = {cracky = 1, ceramic = 1},
    drop = "default:clay",
    sounds = default.node_sound_stone_defaults(),

    on_punch = function(pos, node, puncher)
        local player_name = puncher:get_player_name()
        minetest.add_item(pos, modname .. ":chip 8")
        minetest.remove_node(pos)
        minetest.sound_play(default.node_sound_stone_defaults().footstep, {pos = pos, max_hear_distance = 5})
    end,
})

