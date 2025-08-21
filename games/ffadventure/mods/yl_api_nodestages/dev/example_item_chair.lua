local stages = {}
local example = {}

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_1",
    duration = 10,
    next_stages = {{"example:chair_jam_2"},{"example:chair_jam_1"},{"example:chair_jam_1"}},
    --node definition
    tiles = {"example_chair_jam_1.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_2",
    duration = 10,
    next_stages = {{"example:chair_jam_3",50},{"example:chair_jam_2",100}},
    --node definition
    tiles = {"example_chair_jam_2.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_3",
    duration = 10,
    next_stages = "example:chair_jam_4", --same as next_stage = { {"example:melon_jam_2", 1} }
    --node definition
    tiles = {"example_chair_jam_3.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_4",
    duration = 10,
    next_stages = "example:chair_jam_5", --same as next_stage = { {"example:melon_jam_2", 1} }
    --node definition
    tiles = {"example_chair_jam_4.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_5",
    duration = 10,
    next_stages = "example:chair_jam_6", --same as next_stage = { {"example:melon_jam_2", 1} }
    --node definition
    tiles = {"example_chair_jam_5.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

table.insert(stages, {
    --stage related
    stage_name = "example:chair_jam_6",
    duration = 10,
    next_stages = {
        { "stairs:stair_pine_wood", 50, {},{param2=12}},
        { "example:chair_jam_1", 50}
    },
    --node definition
    tiles = {"example_chair_jam_6.png"},
    description = "Awesome chair jam",
    node_definition = example.get_node_definition()
})

local success, good, bad, total, reasons = yl_api_nodestages.register_stages(stages)

minetest.log("action","success = ".. dump(success))
minetest.log("action","good = ".. dump(good))
minetest.log("action","bad = ".. dump(bad))
minetest.log("action","total = ".. dump(total))
minetest.log("action","reasons = ".. dump(reasons))

assert(success)