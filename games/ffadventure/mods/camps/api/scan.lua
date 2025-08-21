
_c.scan = function (pos, camp)
    if camp.settings == nil then
        camp.settings = {
            size = 4,
        }
    end
    local p = vector.round(vector.copy(pos))
    p.x = p.x - camp.settings.size
    p.y = p.y - 1
    p.z = p.z - camp.settings.size
    for y = 0, (camp.settings.size * 2) + 1, 1 do
        for z = 0, (camp.settings.size * 2) + 1, 1 do
            for x = 0, (camp.settings.size * 2) + 1, 1 do
                local p1 = vector.copy(p)
                p1.x = p1.x + x
                p1.y = p1.y + y
                p1.z = p1.z + z
                local n = core.get_node_or_nil(p1)
                if n.name == "camps:camp" or n.name == "camps:base" then
                    return false
                end
            end
        end
    end
    return true
end
