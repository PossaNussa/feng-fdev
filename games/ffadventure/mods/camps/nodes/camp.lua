
core.register_node("camps:camp", {
    short_description = "Camp",
    description = "Camp\n.camp 000000",
    tiles = { "camps_camp.png" },
    groups = {
        dig_immediate=3,
    },
    light_source = 7,
    stack_max = 1,
    on_place = function (stack, placer, pointed)
        local target = pointed.above
        local name = placer:get_player_name()
        if core.is_protected(target, name) then
            core.record_protection_violation(target, name)
            return nil
        end
        local meta = stack:get_meta()
        local camp_id = meta:get_string("camp_id")
        if camp_id == "" or camp_id == "000000" then
            camp_id = _c.generate()
            meta:set_string("camp_id", camp_id)
        end
        local c = camps.get(camp_id) or {}
        if c.settings == nil then
            c.settings = {
                size = 4, -- This will actually give me a 5x5x5 area (camps:camp in the center)
            }
        end
        if c.camp == nil then
            -- Initialize an empty camp
            --[[
            _ _ _ _ _
            _ _ _ _ _
            _ _ _ _ _
            _ _ C _ _
            B B B B B
            _ = air
            B = camps:base
            C = camps:camp (this node)
            ]]
            c.camp = {}
            local p = vector.round(vector.copy(target))
            p.x = p.x - (c.settings.size + 1)
            p.z = p.z - (c.settings.size + 1)
            p.y = p.y - 1
            --_c.log({target=target, start=p})
            for y = 0, ((c.settings.size * 2) + 1), 1 do
                local layer = {}
                for z = 0, ((c.settings.size * 2) + 1), 1 do
                    local row = {}
                    for x = 0, ((c.settings.size * 2) + 1), 1 do
                        local p1 = vector.copy(p)
                        p1.x = p1.x + x
                        p1.y = p1.y + y
                        p1.z = p1.z + z
                        if y == 0 then
                            --_c.log({pos=p1, node="camps:base"})
                            table.insert(row, {node="camps:base", param1=nil, param2=nil})
                        elseif p1 == target then
                            -- Camp placed here
                            --_c.log({pos=p1, node="camps:camp", this_node=true})
                            table.insert(row, {
                                node = "camps:camp",
                                param1 = nil,
                                param2 = nil,
                                meta = meta:to_table()
                            })
                        else
                            --_c.log({pos=p1, node="air"})
                            table.insert(row, {node="air", param1=nil, param2=nil})
                        end
                    end
                    table.insert(layer, row)
                end
                table.insert(c.camp, layer)
            end
        end
        -- Precheck (In Area)
        if _c.scan(target, c) == false then
            core.chat_send_player(name, "Can't deploy, too close to another camp")
            return nil
        end
        -- Precheck (Below)
        local targ1 = vector.round(vector.copy(target))
        targ1.y = targ1.y - (c.settings.size + 1)
        if _c.scan(targ1, c) == false then
            core.chat_send_player(name, "Can't deploy, too close to another camp")
            return nil
        end
        -- Obtain terrain
        c.terrain = {}
        local p = vector.round(vector.copy(target))
        p.x = p.x - (c.settings.size + 1)
        p.z = p.z - (c.settings.size + 1)
        p.y = p.y - 1
        for y = 0, ((c.settings.size * 2) + 1), 1 do
            local layer = {}
            for z = 0, ((c.settings.size * 2) + 1), 1 do
                local row = {}
                for x = 0, ((c.settings.size * 2) + 1), 1 do
                    local p1 = vector.copy(p)
                    p1.x = p1.x + x
                    p1.y = p1.y + y
                    p1.z = p1.z + z
                    table.insert(row, _c.get(p1))
                end
                table.insert(layer, row)
            end
            table.insert(c.terrain, layer)
        end
        c.pos = placer:get_pos()
        c.face = {
            vertical = placer:get_look_vertical(),
            horizontal = placer:get_look_horizontal(),
        }
        -- Replace with camp data
        camps.set(camp_id, c)
        -- Replace nodes
        local p = vector.round(vector.copy(target))
        p.x = p.x - (c.settings.size + 1)
        p.z = p.z - (c.settings.size + 1)
        p.y = p.y - 1
        for y = 0, ((c.settings.size * 2) + 1), 1 do
            local layer = {}
            for z = 0, ((c.settings.size * 2) + 1), 1 do
                local row = {}
                for x = 0, ((c.settings.size * 2) + 1), 1 do
                    local p1 = vector.copy(p)
                    p1.x = p1.x + x
                    p1.y = p1.y + y
                    p1.z = p1.z + z
                    _c.set(p1, c.camp[y+1][z+1][x+1])
                    if p1 == target then
                        local m = core.get_meta(p1)
                        m:set_string("infotext", name .. "'s Camp\n.camp " .. camp_id)
                        m:set_string("camp_id", camp_id)
                    end
                end
            end
        end
        local targ = vector.round(vector.copy(target))
        targ.y = targ.y + 1
        placer:set_pos(targ)
        stack:clear()
        return stack
    end,
    on_dig = function (pos, node, digger)
        local meta = core.get_meta(pos)
        local camp_id = meta:get_string("camp_id")
        local name = digger:get_player_name()
        if core.is_protected(pos, name) then
            core.record_protection_violation(pos, name)
            return false
        end
        if camp_id == "" or camp_id == "000000" then
            core.chat_send_player(name, "Fatal, no camp id?")
            return false
        end
        local c = camps.get(camp_id)
        if c == nil or c.terrain == nil or c.settings == nil then
            core.chat_send_player(name, "'" .. camp_id .. "' data corrupted?")
            if c == nil then
                core.chat_send_player(name, "Camp doesn't exist?")
            else
                if c.terrain == nil then
                    core.chat_send_player(name, "No terrain data?")
                end
                if c.settings == nil then
                    core.chat_send_player(name, "Missing settings?")
                end
            end
            return false
        end
        -- Save existing camp
        c.camp = {}
        local p = vector.round(vector.copy(pos))
        p.x = p.x - (c.settings.size + 1)
        p.z = p.z - (c.settings.size + 1)
        p.y = p.y - 1
        for y = 0, ((c.settings.size * 2) + 1), 1 do
            local layer = {}
            for z = 0, ((c.settings.size * 2) + 1), 1 do
                local row = {}
                for x = 0, ((c.settings.size * 2) + 1), 1 do
                    local p1 = vector.copy(p)
                    p1.x = p1.x + x
                    p1.y = p1.y + y
                    p1.z = p1.z + z
                    table.insert(row, _c.get(p1))
                end
                table.insert(layer, row)
            end
            table.insert(c.camp, layer)
        end
        camps.set(camp_id, c)
        -- Generate item
        local stack = ItemStack("camps:camp")
        local m = stack:get_meta()
        m:set_string("camp_id", camp_id)
        m:set_string("description", "Camp\n.camp " .. camp_id)
        local inv = digger:get_inventory()
        local left =  inv:add_item("main", stack)
        if left:get_count() > 0 then
            core.chat_send_player(name, "Inventory full, can't pack up")
            return false
        end
        -- Restore terrain
        local p = vector.round(vector.copy(pos))
        p.x = p.x - (c.settings.size + 1)
        p.z = p.z - (c.settings.size + 1)
        p.y = p.y - 1
        for y = 0, ((c.settings.size * 2) + 1), 1 do
            local layer = {}
            for z = 0, ((c.settings.size * 2) + 1), 1 do
                local row = {}
                for x = 0, ((c.settings.size * 2) + 1), 1 do
                    local p1 = vector.copy(p)
                    p1.x = p1.x + x
                    p1.y = p1.y + y
                    p1.z = p1.z + z
                    _c.set(p1, c.terrain[y+1][z+1][x+1])
                end
            end
        end
        if c.pos ~= nil then
            digger:set_pos(c.pos)
        end
        if c.face ~= nil then
            digger:set_look_vertical(c.face.vertical)
            digger:set_look_horizontal(c.face.horizontal)
        end
        return true
    end
})
