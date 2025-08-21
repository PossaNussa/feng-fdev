unused_args = false
allow_defined_top = false

globals = {
    "yl_api_nodestages",
    "minetest.registered_nodes"
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Core
    "minetest",
    "core",

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative",
}
