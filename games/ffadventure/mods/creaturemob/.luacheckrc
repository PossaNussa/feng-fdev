unused_args = false

read_globals = {
    "minetest",
    "core",
    "lucky_block",
    "vector",
    "table",
    "invisibility",
    "cmi",
    "toolranks",
    "pathfinder",
    "tnt",
    "mcl_explosions",
    "ItemStack",
    "VoxelArea",
    "PseudoRandom",
}

globals = {
    "creaturemob",
    "mobs",
    "creatura",
    "player_api",
    "default",
}

ignore = {
    "431", -- Shadowing an upvalue
    "432", -- Shadowing an upvalue argument
}

-- Vendored upstream sources. Kept as close to upstream as possible so the next
-- rebase is a readable diff, so they are not held to this mod's style rules.
files["creatura/"] = {ignore = {"1", "2", "4", "6"}}
files["mobs/"] = {ignore = {"1", "2", "4", "6"}}

files["test/"] = {
    globals = {"core", "minetest", "vector", "ItemStack", "default"},
    read_globals = {"arg"},
}
