ancient_bones = {}

ancient_bones.BONES_MIN = 0 -- not necessarily in a single dungeon
ancient_bones.BONES_MAX = 2
ancient_bones.STACKS_PER_BONES_MAX = 8

dofile(minetest.get_modpath("ancient_bones") .. "/ancient_bones.lua")

dofile(minetest.get_modpath("ancient_bones") .. "/loot.lua")
dofile(minetest.get_modpath("ancient_bones") .. "/mapgen.lua")
