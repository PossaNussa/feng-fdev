--[[
    X Farming. Extends Minetest farming mod with new plants, crops and ice fishing.
    Copyright (C) 2023 SaKeL <juraj.vajda@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to juraj.vajda@gmail.com
--]]

stairs = stairs --[[@as MtgStairs]]

local S = minetest.get_translator(minetest.get_current_modname())

-- trunk
minetest.register_node('x_farming:pine_nut_tree', {
    description = S('Pine Nut Tree'),
    short_description = S('Pine Nut Tree'),
    tiles = { 'x_farming_pine_nut_tree_top.png', 'x_farming_pine_nut_tree_top.png', 'x_farming_pine_nut_tree.png' },
    paramtype2 = 'facedir',
    is_ground_content = false,
    groups = {
        -- MTG
        choppy = 2,
        oddly_breakable_by_hand = 1,
        -- MCL
        handy = 1,
        axey = 1,
        building_block = 1,
        material_wood = 1,
        fire_encouragement = 5,
        fire_flammability = 5,
        -- ALL
        tree = 1,
        flammable = 2,
    },
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
    sounds = x_farming.node_sound_wood_defaults(),
    on_place = minetest.rotate_node
})

-- leaves
minetest.register_node('x_farming:pine_nut_leaves', {
    description = S('Pine Nut Needles') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Pine Nut Needles'),
    drawtype = 'allfaces_optional',
    waving = 1,
    tiles = { 'x_farming_pine_nut_leaves.png' },
    special_tiles = { 'x_farming_pine_nut_leaves.png' },
    paramtype = 'light',
    is_ground_content = false,
    groups = {
        -- MTG
        snappy = 3,
        leafdecay = 3,
        -- MCL
        handy = 1,
        hoey = 1,
        shearsy = 1,
        swordy = 1,
        dig_by_piston = 1,
        fire_encouragement = 30,
        fire_flammability = 60,
        deco_block = 1,
        compostability = 30,
        -- ALL
        flammable = 2,
        leaves = 1,
    },
    _mcl_shears_drop = true,
    _mcl_blast_resistance = 0.2,
    _mcl_hardness = 0.2,
    _mcl_silk_touch_drop = true,
    drop = {
        max_items = 1,
        items = {
            {
                -- player will get sapling with 1/20 chance
                items = { 'x_farming:pine_nut_sapling' },
                rarity = 20,
            },
            {
                -- player will get leaves only if he get no saplings,
                -- this is because max_items is 1
                items = { 'x_farming:pine_nut_leaves' },
            }
        }
    },
    sounds = x_farming.node_sound_leaves_defaults(),
    after_place_node = x_farming.after_place_leaves,
})

-- sapling
minetest.register_node('x_farming:pine_nut_sapling', {
    description = S('Pine Nut Sapling') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Pine Nut Sapling'),
    drawtype = 'plantlike',
    tiles = { 'x_farming_pine_nut_sapling.png' },
    inventory_image = 'x_farming_pine_nut_sapling.png',
    wield_image = 'x_farming_pine_nut_sapling.png',
    paramtype = 'light',
    sunlight_propagates = true,
    walkable = false,
    on_timer = x_farming.grow_pine_nut_tree,
    selection_box = {
        type = 'fixed',
        fixed = { -4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16 }
    },
    groups = {
        -- MTG
        snappy = 2,
        flammable = 2,
        -- MCL
        plant = 1,
        non_mycelium_plant = 1,
        deco_block = 1,
        dig_by_water = 1,
        dig_by_piston = 1,
        destroy_by_lava_flow = 1,
        compostability = 30,
        -- ALL
        dig_immediate = 3,
        attached_node = 1,
        sapling = 1,
    },
    _mcl_blast_resistance = 0,
    _mcl_hardness = 0,
    sounds = x_farming.node_sound_leaves_defaults(),

    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(300, 1500))
    end,

    on_place = function(itemstack, placer, pointed_thing)
        itemstack = x_farming.sapling_on_place(itemstack, placer, pointed_thing,
            'x_farming:pine_nut_sapling',
            -- minp, maxp to be checked, relative to sapling pos
            -- minp_relative.y = 1 because sapling pos has been checked
            { x = -2, y = 1, z = -2 },
            { x = 2, y = 8, z = 2 },
            -- maximum interval of interior volume check
            4)

        return itemstack
    end,
})

-- fruit
local pine_nut_def = {
    description = S('Pine Nut') .. '\n' .. S('Compost chance') .. ': 65%',
    short_description = S('Pine Nut'),
    drawtype = 'plantlike',
    tiles = { 'x_farming_pine_nut.png' },
    inventory_image = 'x_farming_pine_nut.png',
    paramtype = 'light',
    sunlight_propagates = true,
    walkable = false,
    is_ground_content = false,
    selection_box = {
        type = 'fixed',
        fixed = {
            -4 / 16,
            -5 / 16,
            -4 / 16,
            4 / 16,
            7 / 16,
            4 / 16
        }
    },
    groups = {
        -- MTG
        fleshy = 3,
        dig_immediate = 3,
        leafdecay = 3,
        leafdecay_drop = 1,
        compost = 65,
        -- MCL
        handy = 1,
        shearsy = 1,
        non_mycelium_plant = 1,
        fire_encouragement = 60,
        fire_flammability = 100,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        compostability = 65,
        -- ALL
        flammable = 2,
        attached_node = 1,
    },
    _mcl_blast_resistance = 0,
    _mcl_hardness = 0,
    sounds = x_farming.node_sound_leaves_defaults(),

    after_place_node = function(pos, placer, itemstack, pointed_thing)
        minetest.set_node(pos, { name = 'x_farming:pine_nut', param2 = 1 })
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        if oldnode.param2 == 0 then
            minetest.set_node(pos, { name = 'x_farming:pine_nut_mark' })
            minetest.get_node_timer(pos):start(math.random(300, 1500))
        end
    end,
}

minetest.register_node('x_farming:pine_nut', pine_nut_def)

local pine_nut_roasted_def = {
    description = S('Pine Nut Roasted') .. '\n' .. S('Compost chance') .. ': 85%\n'
        .. minetest.colorize(x_farming.colors.brown, S('Hunger') .. ': 2'),
    short_description = S('Pine Nut Roasted'),
    inventory_image = 'x_farming_pine_nut_roasted.png',
    groups = {
        -- MTG
        fleshy = 3,
        dig_immediate = 3,
        compost = 85,
        -- MCL
        handy = 1,
        shearsy = 1,
        deco_block = 1,
        non_mycelium_plant = 1,
        fire_encouragement = 60,
        fire_flammability = 100,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        compostability = 85,
        food = 2,
        eatable = 1,
        -- ALL
        flammable = 2,
        attached_node = 1,
    },
    _mcl_blast_resistance = 0,
    _mcl_hardness = 0,
}

if minetest.get_modpath('farming') then
    pine_nut_roasted_def.on_use = minetest.item_eat(2)
end

if minetest.get_modpath('mcl_farming') then
    pine_nut_roasted_def.on_place = minetest.item_eat(2)
    pine_nut_roasted_def.on_secondary_use = minetest.item_eat(2)
end

minetest.register_craftitem('x_farming:pine_nut_roasted', pine_nut_roasted_def)

minetest.register_node('x_farming:pine_nut_mark', {
    description = S('Pine Nut Marker'),
    short_description = S('Pine Nut Marker'),
    inventory_image = 'x_farming:pine_nut.png^x_farming_invisible_node_overlay.png',
    wield_image = 'x_farming:pine_nut.png^x_farming_invisible_node_overlay.png',
    drawtype = 'airlike',
    paramtype = 'light',
    sunlight_propagates = true,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    drop = '',
    groups = { not_in_creative_inventory = 1 },
    on_timer = function(pos, elapsed)
        if not minetest.find_node_near(pos, 1, 'x_farming:pine_nut_leaves') then
            minetest.remove_node(pos)
        elseif minetest.get_node_light(pos) < 11 then
            minetest.get_node_timer(pos):start(200)
        else
            minetest.set_node(pos, { name = 'x_farming:pine_nut' })
        end
    end
})
-- Register an ABM to handle the growth of pine nuts on dynamic trees' leaves
minetest.register_abm({
    nodenames = {"group:dt_pine_leaves"},
    neighbors = {"air"},
    interval = 900, -- run every 60 seconds
    chance = 20,   -- 1 out of 20 chance of growth per interval per node
    action = function(pos, node, active_object_count, active_object_count_wider)
        local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local above_node = minetest.get_node(above_pos)
        
        if above_node.name == "air" then
            minetest.set_node(above_pos, {name = "x_farming:pine_nut"})
        end
    end,
})