unused_args = false
max_line_length = 170

globals = {
    "core",
    "adoors",
    "angledglass",
    "angledwalls",
    "slopedwalls",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump",

    -- MTG
    "default", "screwdriver",
}
