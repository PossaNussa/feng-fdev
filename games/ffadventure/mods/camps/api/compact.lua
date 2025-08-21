
local chest_api = rawget(_G, "mcl_chests") or nil
if chest_api == nil and _c.cache.gamemode == "VL" then
    _c.error("Failed obtaining 'mcl_chests' API")
end

core.register_on_mods_loaded(function ()
    _c.cache.timer_list = {}
    _c.cache.chest_dat = {}
    for name, def in pairs(core.registered_nodes) do
        if def._chest_entity_textures ~= nil then
            if _c.cache.chest_dat[name] == nil then
                _c.cache.chest_dat[name] = {
                    textures = def._chest_entity_textures
                }
            else
                _c.cache.chest_dat[name].textures = def._chest_entity_textures
            end
        end
        if def._chest_entity_sound ~= nil then
            if _c.cache.chest_dat[name] == nil then
                _c.cache.chest_dat[name] = {
                    sound = def._chest_entity_sound
                }
            else
                _c.cache.chest_dat[name].sound = def._chest_entity_sound
            end
        end
        if def._chest_entity_mesh ~= nil then
            if _c.cache.chest_dat[name] == nil then
                _c.cache.chest_dat[name] = {
                    mesh = def._chest_entity_mesh
                }
            else
                _c.cache.chest_dat[name].mesh = def._chest_entity_mesh
            end
        end
        if def._chest_entity_animation_type ~= nil then
            if _c.cache.chest_dat[name] == nil then
                _c.cache.chest_dat[name] = {
                    animation = def._chest_entity_animation_type
                }
            else
                _c.cache.chest_dat[name].animation = def._chest_entity_animation_type
            end
        end
        if def.on_timer ~= nil then
            _c.cache.timer_list[name] = true
        end
    end
end)

---Obtain all information about a node
---
---This does NOT remove the node
---
---Output used by `camps.set`
---
---Obtains:
---* name
---* param1
---* param2
---* timer (If exists)
---* metadata
---  * inventory
---@param pos vector
---@return table | nil
_c.get = function (pos)
    -- Obtain node
    local node = core.get_node_or_nil(pos)
    if node == nil then
        -- Instantly error if we can't access it
        return nil
    end
    if node.name == "ignore" then
        -- Instantly error if it's not loaded/generated
        -- Apollo: This may be redundant as the get_node_or_nil should return nil on a unloaded node
        return nil
    end
    -- Form a local table to hold all our data we can gather
    local dat = {
        node = node.name
    }
    if node.param1 ~= 0 then
        dat.param1 = node.param1
    end
    if node.param2 ~= 0 then
        dat.param2 = node.param2
    end
    -- If the node has a timer, save it
    if _c.cache.timer_list[dat.node] == true then
        local timer = core.get_node_timer(pos)
        if timer ~= nil then
            dat.timer = {
                elapsed = timer:get_elapsed(),
                timeout = timer:get_timeout(),
                started = timer:is_started(),
            }
        end
    end
    -- Metadata is complex, but important
    local meta = core.get_meta(pos)
    -- I need to convert userdata into table (so I need to manually convert each ItemStack)
    local inv = meta:get_inventory()
    local inv_root = nil
    for name, list in pairs(inv:get_lists()) do
        if inv_root == nil then
            inv_root = {}
        end
        local i = {}
        for slot, stack in ipairs(list) do
            i[slot] = stack:to_table()
        end
        inv_root[name] = {
            size = inv:get_size(name),
            stacks = i
        }
    end
    dat.meta = meta:to_table()
    dat.meta.inventory = nil
    dat.inventory = inv_root
    if _c.cache.chest_dat[dat.node] ~= nil then
        dat.chest_dat = _c.cache.chest_dat[dat.node]
    end
    return dat
end

---Sets a node given data obtained from `camps.get`
---@param pos vector
---@param dat table
_c.set = function (pos, dat)
    -- Remove existing node, this should also wipe metadata
    -- core.remove_node(pos)
    -- Set node, param1 and param2
    core.swap_node(pos, {name=dat.node, param1=dat.param1 or 0, param2=dat.param2 or 0})
    -- Assign metadata
    local meta = core.get_meta(pos)
    meta:from_table(dat.meta)
    if dat.inventory ~= nil then
        local inv = meta:get_inventory()
        for name, data in pairs(dat.inventory) do
            inv:set_size(name, data.size)
            if data.stacks ~= nil then
                for slot, stack in pairs(data.stacks) do
                    inv:set_stack(name, slot, ItemStack(stack))
                end
            end
        end
    end
    -- Restart node timer if it existed
    if dat.timer ~= nil then
        if dat.timer.started then
            local timer = core.get_node_timer(pos)
            timer:start(dat.timer.timeout, dat.timer.elapsed)
        end
    end
    -- Extra VoxeLibre code for chests
    if dat.chest_dat ~= nil then
        local cdat = dat.chest_dat
        local double = core.get_item_group(dat.node, "double_chest") > 0
        chest_api.find_or_create_entity(
            pos,
            dat.node,
            cdat.textures,
            dat.param2 or 0,
            double,
            cdat.sound,
            cdat.mesh,
            cdat.animation
        ):reinitialize(dat.node)
    end
end
