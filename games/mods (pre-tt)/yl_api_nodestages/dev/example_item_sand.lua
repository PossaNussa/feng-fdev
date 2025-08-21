
yl_api_nodestages.add_stage({
    --stage related
    stage_name = "default:sand",
    duration = 10,
    next_stages = "default:gravel",
    restart = false
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})

yl_api_nodestages.overwrite_stage({
    --stage related
    stage_name = "default:sand",
    duration = 10,
    next_stages = "default:dirt",
    overwrite = true,
    restart = false
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})