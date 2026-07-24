--[[
(C) TPH/tph9677/TubberPupperHusker/TubberPupper/Damotrix
MIT License
https://opensource.org/license/mit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

return {
main = function(moddata, moduledata, events)
    -- dirty vector check function in case I want compatibility for prior to 5.5
    -- doesn't error on a non-table either
    local function vector_equal(pos, pos2)
        if type(pos) == "table" and type(pos2) == "table" then
            if pos.x == pos2.x and pos.y == pos2.y and pos.z == pos2.z then
                return true
            end
        end
    end

    -- gets and saves `core.hash_node_position(pos)` as indexes
    -- saves player name as value
    local light_positions = {}
    -- /!\ use below functions /!\ for getting hash due to issue with storing the hash numbers as indexes

    -- currently returns wielder player's name
    local function get_lightnode_data(hash)
        if not hash then return nil end -- causes crash with `tostring()` if not returning `nil`, I HATE LUA!
        hash = type(hash) == "table" and core.hash_node_position(hash) or hash
        return light_positions[hash]
    end
    -- sets player's name to light position
    local function set_lightnode_data(hash, pname)
        hash = type(hash) == "table" and core.hash_node_position(hash) or hash
        light_positions[hash] = pname
    end

    -- handle removing the light node safely
    local function handle_lightnode_removal(pos, node)
        node = node or core.get_node(pos)
        -- not a light node
        if core.get_item_group(node.name, "tph_wielditem_light") == 0 then return end
        -- we good
        core.remove_node(pos)
    end

    -- runs `core.remove_node` and removes from light positions
    local function light_remove_node(pos, hash, immediate)
        pos = pos or (hash and core.get_position_from_hash(hash))
        if type(pos) ~= "table" then return end -- failure
        -- we need to get rid of this node immediately (e.g. leaving)
        if immediate then
            handle_lightnode_removal(pos)
        -- remove on after so it's more smooth
        else
            core.after(0, function() handle_lightnode_removal(pos) end)
        end
        hash = hash or core.hash_node_position(pos)
        -- player interactions
        local hashdata = get_lightnode_data(hash) -- will be a player name
        local pdata = hashdata and tph_wielditem.get_player_data(hashdata)
        -- remove from player data
        if pdata then
            pdata.wlight = nil
            -- item callback if available
            local itemdef = pdata.itemdef
            if itemdef and type(itemdef.tph_wielditem_wieldlight_unlit) == "function" then
                -- returns a copy of pos
                -- position of light node, player's data, item definition
                itemdef.tph_wielditem_wieldlight_unlit(table.copy(pos), pdata, itemdef)
            end
        end
        -- pdata should not be relied upon, however here's an event!
        events.wieldlight_unlit(table.copy(pos), pdata) -- ditto to item callback (excluding item definition)
        set_lightnode_data(hash, nil)
    end

    -- register light nodes
    for i=1, 14 do
        core.register_node("tph_wielditem:light_"..i, {
            description = "Wield Light "..i,
            groups = {not_in_creative_inventory = 1, internal_light = 1, tph_wielditem_light = 1},
            tiles = {"blank.png"},
            drawtype = "airlike",
            -- node interactions
            is_ground_content = false,
            buildable_to = true,
            walkable = false,
            -- light specific
            sunlight_propagates = true,
            light_source = i,
            paramtype2 = "light",
            -- misc
            drop = "",
            pointable = false,
            -- run timer
            on_construct = function(pos)
                local timer = core.get_node_timer(pos)
                timer:start(20)
            end,
            -- check every 20 seconds
            on_timer = function(pos, timeout)
                local hash = core.hash_node_position(pos)
                local pdata = get_lightnode_data(hash) -- (currently player's name)
                if not pdata then return core.remove_node(pos) end
                pdata = tph_wielditem.get_player_data(pdata) -- proper player's data
                local wlight = pdata and pdata.wlight
                -- could not get wield light hash
                if not wlight then return core.remove_node(pos) end
                -- different hash
                if wlight ~= hash then return core.remove_node(pos) end
                return true
            end,
        })
    end

    -- use player's properties and position to return a node adequate position
    -- permits pos argument internally
    -- returns node if successful the first time
    local function player_to_node_pos(plr, pos, checklight)
        -- get specific stuff for eye calculation
        local pprops = plr:get_properties() or {} -- player properties
        local eyeheight = pprops.eye_height or 1
        -- where to place light
        local nodepos = pos and table.copy(pos) or plr:get_pos()
        -- add 80% of eyeheight (prevents light from despawning if you jump up into a node lol)
        nodepos.y = math.ceil(nodepos.y + (eyeheight*0.8) )
        -- otherwise just round regularly
        nodepos.x = math.floor(nodepos.x + 0.5)
        nodepos.z = math.floor(nodepos.z + 0.5)
        -- check node
        local node = core.get_node(nodepos)
        -- don't do anything here!
        if checklight then
            local ndef = core.registered_nodes[node.name]
            local ls = ndef and type(ndef.light_source) == "number" and ndef.light_source
            if ls and ls >= checklight then return end -- don't need to check any further here!
        end
        -- considered air if we're a light
        if core.get_item_group(node.name, "tph_wielditem_light") ~= 0 then
            node.name = "air"
        end
        -- first node is bad, check below and erase node argument!
        if node.name ~= "air" then
            nodepos.y = nodepos.y - 1
            node = nil
        end
        return nodepos, node
    end

    -- pos and node are optional
    local function add_light(plr, pdata, item, itemdef, pos, node)
        pdata = pdata or tph_wielditem.get_player_data(plr) -- get player's data for wlight
        item = item or pdata.itemstack or plr:get_wielded_item()
        itemdef = itemdef or pdata.itemdef or item:get_definition()
        -- no light functionality, return!
        if type(itemdef.light_source) ~= "number" or itemdef.light_source < 1 then return end
        -- check position
        if not pos then
            pos, node = player_to_node_pos(plr)
        end
        local hash = core.hash_node_position(pos) -- convert to hash
        -- at the same position
        if hash == pdata.wlight then return end
        -- moved! found a previous light, must delete!
        if pdata.wlight then light_remove_node(nil, pdata.wlight, nil) end
        -- check if we should replace
        node = node or core.get_node(pos)
        -- not air, return
        if node.name ~= "air" then return end
        -- set node
        local lv = math.max(1, math.min(14, math.floor(itemdef.light_source)))
        node.name = "tph_wielditem:light_"..lv
        core.set_node(pos, node)
        -- item callback
        if type(itemdef.tph_wielditem_wieldlight_alit) == "function" then
            -- copy of new light position and copy of node (with light name, but same param1 and param2),
            -- item's definition, player's data
            itemdef.tph_wielditem_wieldlight_alit(table.copy(pos), table.copy(node), itemdef, pdata)
        end
        -- send event, ditto to callback
        events.wieldlight_alit(table.copy(pos), table.copy(node), itemdef, pdata)
        -- and update hash mechanics
        pdata.wlight = hash
        set_lightnode_data(hash, pdata.name)
        -- return hash and pos on success
        return hash, pos
    end


    -- events
    local stored_positions = {}
    tph_wielditem.register_on_step(function(plr, item, index, dtime, def, pdata)
        -- current item exists and is a light source
        if def and type(def.light_source) == "number" and def.light_source ~= 0 then
            -- old player position table (contains `raw` and `node`)
            -- dirty, but helpful
            local oppos = stored_positions[pdata.name]
            if not oppos then
                oppos = {}
                stored_positions[pdata.name] = oppos
            end
            -- get player's position for checking
            local ppos = pdata.obj:get_pos()
            -- we've moved (changes between oppos and ppos)
            if not vector_equal(ppos, oppos.raw) then
                -- update
                oppos.raw = ppos
                -- node pos, potential node return, optional 3rd "checklight" - don't modify if light source is here!
                local npos, node = player_to_node_pos(pdata.obj, ppos, def.light_source)
                if not npos then return end -- not doing anything here!
                -- update will remove old light
                add_light(pdata.obj, pdata, pdata.itemstack, def, npos, node)
                -- update node position
                oppos.node = npos
            end
        -- not an existent definition or is not a light source
        -- check for if wield light hash exists, remove light node if so
        elseif pdata.wlight then
            light_remove_node(nil, pdata.wlight, nil)
            stored_positions[pdata.name] = nil -- clear from stored
        end
    end)

    -- on join, so that players aren't left in the dark
    tph_wielditem.register_on_joinplayer(function(plr, pdata)
        local def = pdata and pdata.itemdef
        if not def then return end
        if type(def.light_source) ~= "number" or def.light_source == 0 then return end -- not a source of light
        -- let there be light! run on after for correct addition
        core.after(0.4, function() add_light(plr, pdata) end)
    end)

    -- erase entity on player leave
    tph_wielditem.register_on_leaveplayer(function(plr, pdata)
        if not (pdata and pdata.wlight) then return end -- never was light
        light_remove_node(nil, pdata.wlight, true) -- 3rd boolean for immediate delete
    end)

    -- restore light blocks that were blocked by a placed light source
    core.register_on_dignode(function(pos, oldnode, digger)
        if not core.is_player(digger) then return end -- not player
        local pname = digger:get_player_name()
        local wlightpos = stored_positions[pname]
        -- stored_position value, table containing `wlightpos.raw` and `wlightpos.node` (refined)
        wlightpos = wlightpos and wlightpos.node
        -- at exact stored position, restore light
        if vector_equal(pos, wlightpos) then
            local pdata = tph_wielditem.get_player_data(pname)
            if not pdata then return end
            pdata.wlight = nil -- refresh!
            add_light(digger, nil, nil, nil, wlightpos, {name="air"})
        end
    end)
end,
-- custom events
events = {"alit", "unlit"},
-- requires `wield3d` module
depends = {"wield3d"}
}