-- dynamic_trees/init.lua

-- Loads The LUA Files For The Mod

local path = minetest.get_modpath("dynamic_trees")

-- Crafting
dofile(path .. "/dt_crafting.lua")

-- World Generation
dofile(path .. "/dt_world_generation.lua")

-- DT Acacia Tree
dofile(path .. "/dt_acacia_tree_nodes.lua")
dofile(path .. "/dt_acacia_tree_growth.lua")


dofile(path .. "/dt_palm_tree_nodes.lua")
dofile(path .. "/dt_palm_tree_growth.lua")

minetest.register_alias("default:sapling_acacia", "dynamic_trees:acacia_tree_sapling")
minetest.register_alias("default:sapling_apple", "dynamic_trees:apple_tree_sapling")
minetest.register_alias("default:sapling_aspen", "dynamic_trees:aspen_tree_sapling")
minetest.register_alias("default:sapling_jungle", "dynamic_trees:jungle_tree_sapling")
minetest.register_alias("default:sapling_pine", "dynamic_trees:pine_tree_sapling")
-- DT Apple Tree
dofile(path .. "/dt_apple_tree_nodes.lua")
dofile(path .. "/dt_apple_tree_growth.lua")

-- DT Aspen Tree
dofile(path .. "/dt_aspen_tree_nodes.lua")
dofile(path .. "/dt_aspen_tree_growth.lua")

dofile(path .. "/dt_redwood_tree_nodes.lua")
dofile(path .. "/dt_redwood_tree_growth.lua")
-- DT Cactus
dofile(path .. "/dt_cactus_nodes.lua")
dofile(path .. "/dt_cactus_growth.lua")

-- DT Jungle Tree
dofile(path .. "/dt_jungle_tree_nodes.lua")
dofile(path .. "/dt_jungle_tree_growth.lua")

-- DT Pine Tree
dofile(path .. "/dt_pine_tree_nodes.lua")
dofile(path .. "/dt_pine_tree_growth.lua")

dofile(path .. "/dt_sakura_tree_nodes.lua")
dofile(path .. "/dt_sakura_tree_growth.lua")

-- DT Bamboo
dofile(path .. "/dt_bamboo_nodes.lua")
dofile(path .. "/dt_bamboo_growth.lua")

-- DT Dry Tree
dofile(path .. "/dt_dry_tree_nodes.lua")
dofile(path .. "/dt_dry_tree_growth.lua")