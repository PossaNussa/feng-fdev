
yl_api_nodestages.add_stage({
    --stage related
    stage_name = "default:acacia_tree",
    duration = 10,
    next_stages = "default:gravel",
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})

yl_api_nodestages.overwrite_stage({
    --stage related
    stage_name = "default:acacia_tree",
    duration = 10,
    next_stages = "default:dirt",
    overwrite = true
    --node definition
    --tiles = {"example_melon_jam_1.png"},
    --description = "Awesome melon jam",
    --node_definition = example.get_node_definition()
})

yl_api_nodestages.rollback_stage("default", "acacia_tree")

