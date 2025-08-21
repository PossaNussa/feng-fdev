
yl_api_nodestages.add_stage({
    --stage related
    stage_name = "default:cobble",
    duration = 10,
    next_stages = "default:stone",
    restart = false
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})

yl_api_nodestages.add_stage({
    --stage related
    stage_name = "default:stone",
    duration = 10,
    next_stages = "air",
    restart = false
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})