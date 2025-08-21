
local test2 = function (stack, user, pointed)
    if user == nil then
        return stack
    end
    local target = pointed.under
    core.chat_send_player(user:get_player_name(), core.write_json(_c.get(target), true))
    return stack
end

core.register_tool("camps:test_tool2", {
    short_description = "Test Tool II",
    description = "Test Tool II\nPunch or Place on a node to see it's data",
    on_use = test2,
    on_place = test2,
})
