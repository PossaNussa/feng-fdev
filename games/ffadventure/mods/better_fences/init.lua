-- better_fences/init.lua
-- Allow fences to connect to all nodes
-- Copyright (C) 2018-2020  ChimneySwift  <pono797 at gmail dot com>
-- Copyright (C) 2025  1F616EMO  <root at 1f616emo dot xyz>
-- SPDX-License-Identifier: LGPL-2.1-or-later

better_fences = {}

better_fences.additional_connected = {
    "group:crumbly",
    "group:cracky",
    "group:snappy",
    "group:choppy",
    "group:oddly_breakable_by_hand",
    "group:dig_immediate"
}

function better_fences.check_position(pos, nopropagate)
    local adjacents = 0
    for _, checkpos in ipairs({
        vector.offset(pos, 1, 0, 0),
        vector.offset(pos, -1, 0, 0),
        vector.offset(pos, 0, 0, 1),
        vector.offset(pos, 0, 0, -1),
    }) do
        local checknode = core.get_node(checkpos)
        local checkname = checknode.name
        if core.get_item_group(checkname, "fence") > 0 or core.get_item_group(checkname, "wall") > 0 then
            adjacents = adjacents + 1

            if nopropagate ~= true then
                better_fences.check_position(checkpos, true)
            end
        end
    end

    local node = core.get_node(pos)
    local def = core.registered_nodes[node.name]
    if (def and def.groups and def.groups.better_fences or 0) <= 0 then
        return
    end

    if adjacents >= 2 then
        if def._regular_fence and node.name ~= def._regular_fence then
            node.name = def._regular_fence
            core.swap_node(pos, node)
        end
    elseif def._end_fence and node.name ~= def._end_fence then
        node.name = def._end_fence
        core.swap_node(pos, node)
    end
end

-- Intresting compactibility hack
function better_fences.register_fence(...)
    -- Do this to allow default table override to apply
    return default.register_fence(...)
end

function better_fences.on_rightclick(pos, node, player, itemstack, pointed_thing)
    local item_name = itemstack and itemstack:get_name()
    if core.get_item_group(item_name, "sign") ~= 0 or core.get_item_group(item_name, "better_fences") ~= 0 then
        local item_def = core.registered_items[item_name]
        if item_def.type == "node" then
            return core.item_place_node(itemstack, player, pointed_thing)
        end
        return
    end
    local name = player:get_player_name()
    if core.is_protected(pos, name) then
        core.record_protection_violation(pos, name)
        return
    end

    local def = core.registered_nodes[node.name]
    if not (def and def.groups and (def.groups.better_fences or 0) > 0) then
        return
    end

    local newnodename = def.groups.better_fences == 2 and def._regular_fence or def._end_fence
    node.name = newnodename
    core.swap_node(pos, node)
end

core.register_on_mods_loaded(function()
    local additional_connected = better_fences.additional_connected

    local function register_end_node(old_name)
        local old_def = core.registered_nodes[old_name]
        local new_name = old_name .. "_end"
        local new_def = table.copy(old_def)

        for _, connected in ipairs(additional_connected) do
            new_def.connects_to[#new_def.connects_to + 1] = connected
        end

        new_def.on_rightclick = better_fences.on_rightclick
        new_def.on_construct = better_fences.check_position
        new_def.after_destruct = better_fences.check_position

        new_def.groups = new_def.groups or {}
        new_def.groups.not_in_creative_inventory = 1
        new_def.groups.better_fences = 2
        new_def.groups.end_fence = 1

        new_def._end_fence = new_name
        new_def._regular_fence = old_name

        new_def.description = new_def.description .. " (end)" -- No i18n
        new_def.drop = new_def.drop or old_name

        core.register_node(":" .. new_name, new_def)

        local old_groups = table.copy(old_def.groups or {})
        old_groups.better_fences = 1

        core.override_item(old_name, {
            on_rightclick = better_fences.on_rightclick,
            on_construct = better_fences.check_position,
            after_destruct = better_fences.check_position,
            groups = old_groups,
            _end_fence = new_name,
            _regular_fence = old_name,
        })
    end

    local nodes_to_process = {}
    for name, def in pairs(core.registered_nodes) do
        if def.groups
            and ((def.groups.fence or 0) > 0 or (def.groups.wall or 0) > 0)
            and def.node_box and def.node_box.type == "connected" then
            nodes_to_process[#nodes_to_process + 1] = name
        end
    end

    for _, name in ipairs(nodes_to_process) do
        core.log("action", "[better_fences] Overriding " .. name)
        register_end_node(name)
    end

    for _, name in ipairs({
        "wood",
        "acacia_wood",
        "junglewood",
        "pine_wood",
        "aspen_wood",
    }) do
        core.register_alias("better_fences:fence_" .. name, "default:" .. name)
        core.register_alias("better_fences:fence_" .. name .. "_end", "default:" .. name .. "_end")
    end

    for _, name in ipairs({
        "cobble",
        "mossycobble",
        "desertcobble",
    }) do
        core.register_alias("better_fences:wall_" .. name, "walls:" .. name)
        core.register_alias("better_fences:wall_" .. name .. "_end", "walls:" .. name .. "_end")
    end
end)
