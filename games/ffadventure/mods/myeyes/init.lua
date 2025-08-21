local background = core.settings:get_bool("myeyes.use_background", false)

-- Per-player HUD ids and last-seen node cache
local huds = {}       -- [playername] = {desc=<id>, name=<id>, bg=<id or nil>}
local old_node = {}   -- [playername] = "<nodename or empty>"

local distance = 9
local node_above = true

-- Single pass: return both node name and description from one raycast
local function get_pointed_info(player, node_above_flag, max_dist)
    local pos = player:get_pos()
    if not pos then return nil, nil end

    local dir = player:get_look_dir()
    if not dir then return nil, nil end

    local start_pos = vector.add(pos, { x = 0, y = 1.5, z = 0 })
    local end_pos   = vector.add(start_pos, vector.multiply(dir, max_dist))
    local ray = core.raycast(start_pos, end_pos, false, false)

    for pointed in ray do
        if pointed.type == "node" then
            local under, above = pointed.under, pointed.above
            if not under or not above then return nil, nil end

            local hit_pos = node_above_flag and vector.round(under) or vector.round(above)
            local node = core.get_node(hit_pos)
            if not node then return nil, nil end

            local name = node.name
            local def  = name and core.registered_nodes[name]
            local desc = def and def.description

            -- Fallback if description is missing/empty
            if not desc or desc == "" then
                desc = name or ""
            end

            return name, desc
        end
    end

    return nil, nil
end

core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    old_node[name] = ""

    local bg_id
    if background then
        bg_id = player:hud_add({
            type      = "image",
            position  = {x = 0.95, y = 0.105},
            offset    = {x = -150, y = -25},
            text      = "myeyes_background.png",
            alignment = 0,
            scale     = { x = 1, y = 1},
        })
    end

    local desc_id = player:hud_add({
        type      = "text",
        position  = {x = 0.95, y = 0.09},
        offset    = {x = -150, y = -25},
        text      = "",
        alignment = 0,
        scale     = { x = 100, y = 100},
        number    = 0x25de29,
        size      = { x = 1.7 },
        style     = 1,
    })

    local name_id = player:hud_add({
        type      = "text",
        position  = {x = 0.95, y = 0.12},
        offset    = {x = -150, y = -25},
        text      = "",
        alignment = 0,
        scale     = { x = 100, y = 100},
        number    = 0xdb9c10,
        size      = { x = 1 },
        style     = 2,
    })

    huds[name] = { desc = desc_id, name = name_id, bg = bg_id }
end)

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    huds[name] = nil
    old_node[name] = nil
end)

-- One globalstep; one raycast per player per frame
core.register_globalstep(function(dtime)
    for _, player in ipairs(core.get_connected_players()) do
        local name = player:get_player_name()
        local ids = huds[name]
        if ids then
            if not old_node[name] then old_node[name] = "" end

            local node_name, node_desc = get_pointed_info(player, node_above, distance)

            if node_name and node_name ~= old_node[name] then
                player:hud_change(ids.name, "text", node_name)
                old_node[name] = node_name
            end

            if node_desc then
                player:hud_change(ids.desc, "text", node_desc)
            end
        end
    end
end)


