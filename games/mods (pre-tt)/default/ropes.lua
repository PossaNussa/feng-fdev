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

local S = minetest.get_translator(minetest.get_current_modname())

local function place_rope(pos, itemstack, placer)
    local next_node = minetest.get_node(pos)
    local stack_name = itemstack:get_name()
    local is_rope = stack_name == "default:rope" or stack_name == "default:hemp_rope"

    -- Start by placing the rope at the current position
    -- if it's air and the itemstack is not empty
    if next_node.name == 'air' and not itemstack:is_empty() and is_rope then
        if not minetest.is_protected(pos, placer:get_player_name()) then
            minetest.set_node(pos, {name = stack_name})
            itemstack:take_item()
        else
            return itemstack
        end
    end

    -- Then try to place the rope downwards
    local under_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
    local under_node = minetest.get_node(under_pos)
    while under_node.name == 'air' and not itemstack:is_empty() and is_rope do
        if not minetest.is_protected(under_pos, placer:get_player_name()) then
            minetest.set_node(under_pos, {name = stack_name})
            itemstack:take_item()
        end
        under_pos.y = under_pos.y - 1
        under_node = minetest.get_node(under_pos)
    end

    -- If there's an obstacle, navigate around it
    if under_node.name ~= 'air' and is_rope then
        for _, vec in ipairs({{x=1, y=0, z=0}, {x=-1, y=0, z=0}, {x=0, y=0, z=1}, {x=0, y=0, z=-1}}) do
            local side_pos = vector.add(under_pos, vec)
            local side_node = minetest.get_node(side_pos)
            if side_node.name == 'air' then
                if not minetest.is_protected(side_pos, placer:get_player_name()) then
                    minetest.set_node(side_pos, {name = stack_name})
                    itemstack:take_item()
                end
                break
            end
        end
    end

    return itemstack
end
minetest.register_node('default:rope', {
    description = S('Rope') .. '. ' .. S('Placing rope on rope will place the rope downwards.'),
    drawtype = 'plantlike',
    walkable = false,
    paramtype = 'light',
    sunlight_propagates = true,
    climbable = true,
    wield_scale = { x = 2, y = 2, z = 1 },
    groups = {
        -- MTG
        snappy = 3,
        flammable = 3,
        rope = 1,
    },
    tiles = { 'rope_texture.png' },
    inventory_image = 'rope_texture.png',
    wield_image = 'rope_texture.png',
    selection_box = {
        type = 'fixed',
        fixed = { -2 / 16, -0.5, -2 / 16, 2 / 16, 0.5, 2 / 16 }
    },
    sounds = default.node_sound_leaves_defaults(),
    on_place = function(itemstack, placer, pointed_thing)
        -- Check if we're pointing at something
        if pointed_thing.type == 'node' then
            -- Check if the rope can be tied to a fence or another rope
            local pos = pointed_thing.above
            local can_place = false
            local adj_node_names = {
                minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}).name,
                minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}).name,
                minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}).name
            }
            for _, name in ipairs(adj_node_names) do
                if name:find("^default:fence_") or name == "default:rope" then
                    can_place = true
                    break
                end
            end
            if can_place then
                return place_rope(pos, itemstack, placer)
            else
                minetest.remove_node(pos)
                -- Return the rope to the player's inventory
                local inv = placer:get_inventory()
                if inv:room_for_item("main", stack_name) then
                    inv:add_item("main", stack_name)
                else
                    minetest.add_item(pos, stack_name)
                end
            end
        end
        return itemstack
    end,
    on_punch = function(pos, node, puncher, pointed_thing)
        if minetest.is_protected(pos, puncher:get_player_name()) then
            return
        end

        local count = 0
        local below = vector.new(pos)
        local node_below = minetest.get_node(below)

        while minetest.get_item_group(node_below.name, 'rope') > 0 do
            minetest.remove_node(below)
            below.y = below.y - 1
            count = count + 1
            node_below = minetest.get_node(below)
        end

        if count == 0 then
            return
        end

        local stacks = {}
        local node_stack = ItemStack({ name = node.name })
        local stack_max = node_stack:get_stack_max()
        local stack_count = count

        if stack_count > stack_max then
            while stack_count > 0 do
                if stack_count > stack_max then
                    stack_count = stack_count - stack_max
                    table.insert(stacks, ItemStack({ name = node.name, count = stack_max }))
                else
                    table.insert(stacks, ItemStack({ name = node.name, count = stack_count }))
                    stack_count = 0
                end
            end
        else
            table.insert(stacks, ItemStack({ name = node.name, count = count }))
        end

        local inv = puncher:get_inventory()

        for _, stack in ipairs(stacks) do
            if inv and inv:room_for_item('main', stack) then
                inv:add_item('main', stack)
            else
                -- drop on the ground
                minetest.add_item(puncher:get_pos(), stack)
            end
        end

        return true
    end,
})

minetest.register_node('default:safety_net', {
    description = S('Safety Net. No fall damage when landing on this net.'),
    drawtype = 'nodebox',
    node_box = {
        type = 'fixed',
        fixed = { -8 / 16, -8 / 16, -8 / 16, 8 / 16, -7 / 16, 8 / 16 },
    },
    selection_box = {
        type = 'fixed',
        fixed = { -8 / 16, -8 / 16, -8 / 16, 8 / 16, -6 / 16, 8 / 16 }
    },
    tiles = {
        'x_farming_safety_net.png',
        'x_farming_safety_net.png',
        'x_farming_safety_net_side.png',
    },
    use_texture_alpha = 'clip',
    wield_image = 'x_farming_safety_net.png',
    inventory_image = 'x_farming_safety_net.png',
    paramtype = 'light',
    sunlight_propagates = true,
    wield_scale = { x = 2, y = 2, z = 1 },
    groups = {
        -- MTG
        snappy = 3,
        flammable = 3,
        bouncy = 33,
        fall_damage_add_percent = -100,
    },
    sounds = default.node_sound_leaves_defaults()
})

minetest.register_node('default:rope_fence', {
    description = S('Rope') .. ' ' .. S('Fence'),
    drawtype = 'nodebox',
    paramtype = 'light',
    climbable = true,
    wield_scale = { x = 2, y = 2, z = 1 },
    node_box = {
        type = 'connected',
        fixed = { -1 / 16, -1 / 2, -1 / 16, 1 / 16, 1 / 2, 1 / 16 },
        -- connect_top =
        -- connect_bottom =
        connect_front = {
            { 0, -8 / 16, -8 / 16, 0, 7 / 16, -1 / 16 }
        },
        connect_left = {
            { -1 / 2, -1 / 2, 0, -1 / 16, 7 / 16, 0 }
        },
        connect_back = {
            { 0, -8 / 16, 1 / 16, 0, 7 / 16, 1 / 2 }
        },
        connect_right = {
            { 1 / 16, -1 / 2, 0, 1 / 2, 7 / 16, 0 }
        }
    },
    collision_box = {
        type = 'connected',
        fixed = { -1 / 8, -1 / 2, -1 / 8, 1 / 8, 1 / 2, 1 / 8 },
        -- connect_top =
        -- connect_bottom =
        connect_front = { -1 / 8, -1 / 2, -1 / 2, 1 / 8, 1 / 2, -1 / 8 },
        connect_left = { -1 / 2, -1 / 2, -1 / 8, -1 / 8, 1 / 2, 1 / 8 },
        connect_back = { -1 / 8, -1 / 2, 1 / 8, 1 / 8, 1 / 2, 1 / 2 },
        connect_right = { 1 / 8, -1 / 2, -1 / 8, 1 / 2, 1 / 2, 1 / 8 }
    },
    connects_to = {
        -- MTG
        'group:fence',
        'group:wood',
        'group:tree',
        'group:wall',
        'group:stone',
    },
    inventory_image = 'x_farming_rope_fence_item.png',
    wield_image = 'x_farming_rope_fence_item.png',
    tiles = { 'x_farming_rope_fence.png' },
    use_texture_alpha = 'clip',
    sunlight_propagates = true,
    is_ground_content = false,
    groups = {
        -- MTG
        fence = 1,
        snappy = 3,
        flammable = 2
    },
    sounds = default.node_sound_leaves_defaults()
})

minetest.register_craft({
    output = "default:rope_fence 2",
    recipe = {
        {"default:rope", "default:rope", "default:rope"},
        {"default:rope", "default:rope", "default:rope"}
    }
})

minetest.register_craft({
    output = "default:safety_net",
	type = "shapeless",
    recipe = {
        "default:rope_fence"
    }
})

minetest.register_craft({
    output = "default:rope",
	type = "shapeless",
    recipe = {
        "default:hemp_rope"
    }
})


minetest.register_node("default:hemp_rope", {
	description = S("Hemp Rope"),
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	tiles = {"farming_hemp_rope.png"},
	wield_image = "farming_hemp_rope.png",
	inventory_image = "farming_hemp_rope.png",
	drawtype = "plantlike",
	groups = {
		handy = 1, axey = 1, swordy = 1, flammable = 2, choppy = 3,
		oddly_breakable_by_hand = 3, compostability = 55
	},
	--sounds =  default.sounds.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7}
	},
	_mcl_hardness = 0.8,
    on_place = function(itemstack, placer, pointed_thing)
        -- Check if we're pointing at something
        if pointed_thing.type == 'node' then
            -- Check if the rope can be tied to a fence or another rope
            local pos = pointed_thing.above
            local can_place = false
            local adj_node_names = {
                minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z}).name,
                minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name,
                minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1}).name,
                minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1}).name
            }
            for _, name in ipairs(adj_node_names) do
                if name:find("^default:fence_") or name == "default:hemp_rope" then
                    can_place = true
                    break
                end
            end
            if can_place then
                local stack_name = itemstack:get_name()  -- Define stack_name here
                return place_rope(pos, itemstack, placer, stack_name)  -- Pass stack_name to place_rope function
            else
                minetest.remove_node(pos)
                -- Return the rope to the player's inventory
                local inv = placer:get_inventory()
                local stack_name = itemstack:get_name()  -- Define stack_name here as well
                if inv:room_for_item("main", stack_name) then
                    inv:add_item("main", stack_name)
                else
                    minetest.add_item(pos, stack_name)
                end
            end
        end
        return itemstack
    end,
    on_punch = function(pos, node, puncher, pointed_thing)
        if minetest.is_protected(pos, puncher:get_player_name()) then
            return
        end

        local count = 0
        local below = vector.new(pos)
        local node_below = minetest.get_node(below)

        while minetest.get_item_group(node_below.name, 'hemp_rope') > 0 do
            minetest.remove_node(below)
            below.y = below.y - 1
            count = count + 1
            node_below = minetest.get_node(below)
        end

        if count == 0 then
            return
        end

        local stacks = {}
        local node_stack = ItemStack({ name = node.name })
        local stack_max = node_stack:get_stack_max()
        local stack_count = count

        if stack_count > stack_max then
            while stack_count > 0 do
                if stack_count > stack_max then
                    stack_count = stack_count - stack_max
                    table.insert(stacks, ItemStack({ name = node.name, count = stack_max }))
                else
                    table.insert(stacks, ItemStack({ name = node.name, count = stack_count }))
                    stack_count = 0
                end
            end
        else
            table.insert(stacks, ItemStack({ name = node.name, count = count }))
        end

        local inv = puncher:get_inventory()

        for _, stack in ipairs(stacks) do
            if inv and inv:room_for_item('main', stack) then
                inv:add_item('main', stack)
            else
                -- drop on the ground
                minetest.add_item(puncher:get_pos(), stack)
            end
        end

        return true
    end,
	_mcl_blast_resistance = 1
})

minetest.register_alias("farming:hemp_rope", "default:hemp_rope")