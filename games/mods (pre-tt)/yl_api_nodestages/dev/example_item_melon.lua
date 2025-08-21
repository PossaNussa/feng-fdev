local stages = {}
local example = {}

table.insert(stages, {
    -- stage related
    stage_name = "example:melon_jam_1",
    duration = 10,
    next_stages = "example:melon_jam_2", -- same as next_stage = { {"example:melon_jam_2", 1} }
    -- node definition
    tiles = {"example_melon_jam_1.png"},
    description = "Awesome melon jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    -- stage related
    stage_name = "example:melon_jam_2",
    --[[
    duration = {10, 20},
    duration = {20, 10},
    duration = {10},
    duration = {10, 10},
    ]] --
    duration = 10,
    -- duration = "10",
    next_stages = {
        {"example:melon_jam_3", 50, {can_set = example.can_set}},
        {"example:melon_jam_4", 50},
        {"default:cobble", 50, {can_set = example.can_set}, {param2 = 12}}
    },
    -- node definition
    tiles = {"example_melon_jam_2.png"},
    description = "Awesome melon jam Stage 2",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    -- stage related
    stage_name = "example:melon_jam_3",
    -- duration = nil,
    -- next_stages = nil,
    -- node definition
    tiles = {"example_melon_jam_3.png"},
    description = "Awesome melon jam Stage 3",
    node_definition = example.get_node_definition()
})

--[[
table.insert(stages, {
    --stage related
    stage_name = "example:melon_jam_4",
    -- duration = {10, 20},
    -- duration = {20, 10},
    -- duration = {10},
    -- duration = {10, 10},
    duration = 10,
    duration = "10",
    next_stages = {
        { "example:melon_jam_1", 50 },
        { "example:melon_jam_2", 50 }
    },
    --node definition
    tiles = {"example_melon_jam_2.png"},
    description = "Awesome melon jam Stage 4",
    node_definition = example.get_node_definition()
})
]] --

local success, good, bad, total, reasons =
    yl_api_nodestages.register_stages(stages)

minetest.log("action", "success = " .. dump(success))
minetest.log("action", "good = " .. dump(good))
minetest.log("action", "bad = " .. dump(bad))
minetest.log("action", "total = " .. dump(total))
minetest.log("action", "reasons = " .. dump(reasons))

assert(success)
