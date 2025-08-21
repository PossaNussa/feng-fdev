
camps.id_exists = function (id)
    local id_list = core.deserialize(_c.store:get_string("camps.id_list")) or {}
    for _, i in ipairs(id_list) do
        if i == id then
            return true
        end
    end
    return false
end

camps.get = function (id)
    if not camps.id_exists(id) then
        return {}
    end
    return core.parse_json(_c.store:get_string("camps." .. id))
end

camps.set = function (id, data)
    if not camps.id_exists(id) then
        local id_list = core.deserialize(_c.store:get_string("camps.id_list")) or {}
        table.insert(id_list, id)
        _c.store:set_string("camps.id_list", core.serialize(id_list))
    end
    _c.store:set_string("camps." .. id, core.write_json(data))
end
