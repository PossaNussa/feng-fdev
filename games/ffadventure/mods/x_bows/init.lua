--[[
    X Bows. Adds bow and arrows with API.
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

local DEFAULT_FOV = 70
local AIM_FOV = 60
local AIM_WOBBLE_DELAY = 3.0
local RAD = math.pi / 180

minetest = minetest.global_exists('minetest') and minetest --[[@as Minetest]]
ItemStack = minetest.global_exists('ItemStack') and ItemStack --[[@as ItemStack]]
vector = minetest.global_exists('vector') and vector --[[@as Vector]]
default = minetest.global_exists('default') and default --[[@as MtgDefault]]
sfinv = minetest.global_exists('sfinv') and sfinv --[[@as Sfinv]]
unified_inventory = minetest.global_exists('unified_inventory') and unified_inventory --[[@as UnifiedInventory]]
player_api = minetest.global_exists('player_api') and player_api --[[@as MtgPlayerApi]]

math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9))--[[@as number]] )

local path = minetest.get_modpath('x_bows')
local mod_start_time = minetest.get_us_time()
local bow_charged_timer = 0

dofile(path .. '/api.lua')
dofile(path .. '/particle_effects.lua')
dofile(path .. '/nodes.lua')
dofile(path .. '/arrow.lua')
dofile(path .. '/items.lua')

-- Inventory tab disabled (using i3 directly)
-- if XBows.i3 then
--     XBowsQuiver:i3_register_page()
-- elseif XBows.unified_inventory then
--     XBowsQuiver:ui_register_page()
-- else
--     XBowsQuiver:sfinv_register_page()
-- end

minetest.register_on_joinplayer(function(player)
    local inv_quiver = player:get_inventory() --[[@as InvRef]]
    local inv_arrow = player:get_inventory() --[[@as InvRef]]

    if XBows.settings.x_bows_show_3d_quiver and XBows.player_api then
        ---Order matters here
        if XBows.skinsdb then
         --   player_api.set_model(player, 'skinsdb_3d_armor_character_5.b3d')
        elseif XBows._3d_armor then
         --   player_api.set_model(player, 'x_bows_3d_armor_character.b3d')
        else
         --   player_api.set_model(player, 'x_bows_character.b3d')
        end
    end

    inv_quiver:set_size('x_bows:quiver_inv', 1 * 1)
    inv_arrow:set_size('x_bows:arrow_inv', 1 * 1)

    local quiver_stack = player:get_inventory():get_stack('x_bows:quiver_inv', 1)

    if quiver_stack and not quiver_stack:is_empty() then
        local st_meta = quiver_stack:get_meta()
        local quiver_id = st_meta:get_string('quiver_id')

        ---create detached inventory
        local detached_inv = XBowsQuiver:get_or_create_detached_inv(
            quiver_id,
            player:get_player_name(),
            st_meta:get_string('quiver_items')
        )

        ---set model textures
        if detached_inv:is_empty('main') then
            XBowsQuiver.quiver_empty_state[player:get_player_name()] = false
            XBowsQuiver:show_3d_quiver(player, { is_empty = true })
        else
            XBowsQuiver.quiver_empty_state[player:get_player_name()] = true
            XBowsQuiver:show_3d_quiver(player)
        end
    else
        ---set model textures
        XBowsQuiver:hide_3d_quiver(player)
    end

    XBows:reset_charged_bow(player, true)
    XBowsQuiver:close_quiver(player)
end)

-- 3D quiver model registration disabled: x_bows was overriding
-- skinsdb/3d_armor model definitions with wrong texture counts and
-- shipping incompatible .b3d files that corrupted player models.

---formspec callbacks
minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
    ---arrow inventory
    if action == 'move' and inventory_info.to_list == 'x_bows:arrow_inv' then
        local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)

        if minetest.get_item_group(stack:get_name(), 'arrow') ~= 0 then
            return inventory_info.count
        else
            return 0
        end
    elseif action == 'move' and inventory_info.from_list == 'x_bows:arrow_inv' then
        local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)

        if minetest.get_item_group(stack:get_name(), 'arrow') ~= 0 then
            return inventory_info.count
        else
            return 0
        end
    elseif action == 'put' and inventory_info.listname == 'x_bows:arrow_inv' then
        if minetest.get_item_group(inventory_info.stack:get_name(), 'arrow') ~= 0 then
            return inventory_info.stack:get_count()
        else
            return 0
        end
    elseif action == 'take' and inventory_info.listname == 'x_bows:arrow_inv' then
        if minetest.get_item_group(inventory_info.stack:get_name(), 'arrow') ~= 0 then
            return inventory_info.stack:get_count()
        else
            return 0
        end
    end

    ---quiver inventory
    if action == 'move' and inventory_info.to_list == 'x_bows:quiver_inv' then
        local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
        if minetest.get_item_group(stack:get_name(), 'quiver') ~= 0 then
            return inventory_info.count
        else
            return 0
        end
    elseif action == 'move' and inventory_info.from_list == 'x_bows:quiver_inv' then
        local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
        if minetest.get_item_group(stack:get_name(), 'quiver') ~= 0 then
            return inventory_info.count
        else
            return 0
        end
    elseif action == 'put' and inventory_info.listname == 'x_bows:quiver_inv' then
        if minetest.get_item_group(inventory_info.stack:get_name(), 'quiver') ~= 0 then
            return inventory_info.stack:get_count()
        else
            return 0
        end
    elseif action == 'take' and inventory_info.listname == 'x_bows:quiver_inv' then
        if minetest.get_item_group(inventory_info.stack:get_name(), 'quiver') ~= 0 then
            return inventory_info.stack:get_count()
        else
            return 0
        end
    end

    return inventory_info.count or inventory_info.stack:get_count()
end)

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
    ---arrow
    if action == 'move' and inventory_info.to_list == 'x_bows:arrow_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end
    elseif action == 'move' and inventory_info.from_list == 'x_bows:arrow_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end
    elseif action == 'put' and inventory_info.listname == 'x_bows:arrow_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end
    elseif action == 'take' and inventory_info.listname == 'x_bows:arrow_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end
    end

    ---quiver
    if action == 'move' and inventory_info.to_list == 'x_bows:quiver_inv' then
        local stack = inventory:get_stack(inventory_info.to_list, inventory_info.to_index)

        ---init detached inventory if not already
        local st_meta = stack:get_meta()
        local quiver_id = st_meta:get_string('quiver_id')

        if quiver_id == '' then
            quiver_id = stack:get_name() .. '_' .. XBows.uuid()
            st_meta:set_string('quiver_id', quiver_id)
            inventory:set_stack(inventory_info.to_list, inventory_info.to_index, stack)
        end

        local detached_inv = XBowsQuiver:get_or_create_detached_inv(
            quiver_id,
            player:get_player_name(),
            st_meta:get_string('quiver_items')
        )

        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end

        ---set player visual
        if detached_inv:is_empty('main') then
            XBowsQuiver.quiver_empty_state[player:get_player_name()] = false
            XBowsQuiver:show_3d_quiver(player, { is_empty = true })
        else
            XBowsQuiver.quiver_empty_state[player:get_player_name()] = true
            XBowsQuiver:show_3d_quiver(player)
        end
    elseif action == 'move' and inventory_info.from_list == 'x_bows:quiver_inv' then
        local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)

        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end

        ---set player visual
        if stack:is_empty() then
            XBowsQuiver:hide_3d_quiver(player)
        end
    elseif action == 'put' and inventory_info.listname == 'x_bows:quiver_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end
    elseif action == 'take' and inventory_info.listname == 'x_bows:quiver_inv' then
        if XBows.i3 then
            i3.set_fs(player)
        elseif XBows.unified_inventory then
            unified_inventory.set_inventory_formspec(player, 'x_bows:quiver_page')
        else
            sfinv.set_player_inventory_formspec(player)
        end

        ---set player visual
        if inventory:is_empty(inventory_info.listname) then
            XBowsQuiver:hide_3d_quiver(player)
        end
    end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if player and fields.quit then
        XBowsQuiver:close_quiver(player, formname)
    end
end)

---backwards compatibility
minetest.register_alias('x_bows:arrow_diamond_tipped_poison', 'x_bows:arrow_diamond')

-- Hold-to-fire system: Check for RMB release every tick, FOV zoom, aim wobble
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        local state = XBows.player_draw_state[player_name]

        if state and state.drawing then
            local controls = player:get_player_control()
            local wielded_stack = player:get_wielded_item()
            local wielded_stack_name = wielded_stack:get_name()

            -- Check if player stopped holding RMB or switched items
            if not controls.RMB or minetest.get_item_group(wielded_stack_name, 'bow') == 0 then
                -- FIRE! Calculate power based on draw time
                local draw_time = (minetest.get_us_time() - state.draw_start) / 1000000

                if minetest.get_item_group(wielded_stack_name, 'bow_charged') ~= 0 then
                    -- Shoot with power based on draw time
                    local power_mult = math.min(draw_time / state.full_charge_time, 1.0)
                    XBows:shoot(wielded_stack, player, nil)
                end

                -- Reset draw state
                state.drawing = false
                state.draw_start = nil
                state.full_charge_at = nil

                -- Snap FOV back fast
                if state.fov_zoomed then
                    player:set_fov(DEFAULT_FOV, false, 0.15)
                    state.fov_zoomed = false
                end

                -- Reset speed
                if XBows.playerphysics then
                    playerphysics.remove_physics_factor(player, 'speed', 'x_bows:bow_charged_speed')
                elseif XBows.player_monoids then
                    player_monoids.speed:del_change(player, 'x_bows:bow_charged_speed')
                end

                if XBows.player_bow_sneak[player_name] then
                    XBows.player_bow_sneak[player_name].sneak = false
                end
            else
                -- Still drawing — apply FOV zoom and aim wobble
                local draw_time = (minetest.get_us_time() - state.draw_start) / 1000000
                local is_charged = minetest.get_item_group(wielded_stack_name, 'bow_charged') ~= 0

                -- FOV zoom: kick in once bow is charged
                if is_charged and not state.fov_zoomed then
                    player:set_fov(AIM_FOV, false, 0.4)
                    state.fov_zoomed = true
                end

                -- Track when full charge was first reached
                if is_charged and not state.full_charge_at then
                    state.full_charge_at = minetest.get_us_time()
                end

                -- Aim wobble: figure-8 after holding full draw too long
                if state.full_charge_at then
                    local hold_seconds = (minetest.get_us_time() - state.full_charge_at) / 1000000
                    if hold_seconds > AIM_WOBBLE_DELAY then
                        local wobble_t = hold_seconds * 1.8
                        local dx = math.sin(wobble_t)
                        local dy = math.sin(wobble_t * 2)
                        local amplitude = math.min((hold_seconds - AIM_WOBBLE_DELAY) * 0.3, 1.5)
                        local noise = math.sin(wobble_t * 7.1) * 0.15

                        local look_h = player:get_look_horizontal()
                        local look_v = player:get_look_vertical()
                        player:set_look_horizontal(look_h + (dx + noise) * amplitude * RAD)
                        player:set_look_vertical(look_v + dy * amplitude * 0.7 * RAD)
                    end
                end
            end
        end
    end
end)

-- Original globalstep for speed management (runs less frequently)
-- NOTE: FOV handling removed - let mud.lua handle FOV to avoid conflicts
minetest.register_globalstep(function(dtime)
    bow_charged_timer = bow_charged_timer + dtime

    if bow_charged_timer > 0.5 then
        for _, player in ipairs(minetest.get_connected_players()) do
            local player_name = player:get_player_name()
            local wielded_stack = player:get_wielded_item()
            local wielded_stack_name = wielded_stack:get_name()

            if not wielded_stack_name then
                return
            end

            if not XBows.player_bow_sneak[player_name] then
                XBows.player_bow_sneak[player_name] = {}
            end

            if minetest.get_item_group(wielded_stack_name, 'bow_charged') ~= 0
                and not XBows.player_bow_sneak[player_name].sneak
            then
                --charged weapon - slow down player
                if XBows.playerphysics then
                    playerphysics.add_physics_factor(player, 'speed', 'x_bows:bow_charged_speed', 0.5)
                elseif XBows.player_monoids then
                    player_monoids.speed:add_change(player, 0.5, 'x_bows:bow_charged_speed')
                end

                XBows.player_bow_sneak[player_name].sneak = true
            elseif minetest.get_item_group(wielded_stack_name, 'bow_charged') == 0
                and XBows.player_bow_sneak[player_name].sneak
            then
                if XBows.playerphysics then
                    playerphysics.remove_physics_factor(player, 'speed', 'x_bows:bow_charged_speed')
                elseif XBows.player_monoids then
                    player_monoids.speed:del_change(player, 'x_bows:bow_charged_speed')
                end

                XBows.player_bow_sneak[player_name].sneak = false
            end

            XBows:reset_charged_bow(player)
        end

        bow_charged_timer = 0
    end
end)
