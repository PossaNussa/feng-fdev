
core.register_tool("camps:test_tool", {
    short_description = "Test Tool",
    description = "Punch a node to gather | Place to place gathered node\n.camps 000000",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            camp = {
                maxlevel = 1,
                uses = 1,
                times = {[1]=1.0}
            },
        },
        damage_groups = {fleshy=1},
        punch_attack_uses = 0,
    },
    on_use = function (stack, user, pointed)
        local meta = stack:get_meta()
        local camp_id = meta:get_string("camp_id")
        if camp_id == "" or camp_id == "000000" then
            meta:set_string("camp_id", _c.generate())
            meta:set_string("description", "Punch a node to gather | Place to place gathered node\n.camps " .. meta:get_string("camp_id"))
            return stack
        end
        local target = pointed.under
        if _c.cache[camp_id] ~= nil then
            return stack
        end
        stack:set_wear(65534)
        _c.cache[camp_id] = _c.get(target)
        meta:set_string("description", "Punch a node to gather | Place to place gathered node\n" .. _c.cache[camp_id].node .. "\n.camps " .. camp_id)
        core.remove_node(target)
        return stack
    end,
    on_place = function (stack, user, pointed)
        local meta = stack:get_meta()
        local camp_id = meta:get_string("camp_id")
        if camp_id == "" or camp_id == "000000" then
            meta:set_string("camp_id", _c.generate())
            meta:set_string("description", "Punch a node to gather | Place to place gathered node\n.camps " .. meta:get_string("camp_id"))
            return stack
        end
        local target = pointed.above
        if _c.cache[camp_id] == nil then
            return stack
        end
        stack:set_wear(1)
        _c.set(target, _c.cache[camp_id])
        _c.cache[camp_id] = nil
        meta:set_string("description", "Punch a node to gather | Place to place gathered node\n.camps " .. camp_id)
        return stack
    end
})