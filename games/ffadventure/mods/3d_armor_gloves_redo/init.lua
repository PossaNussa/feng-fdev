dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/wooden_gauntlets.lua")
dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/cactus_gauntlets.lua")
dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/steel_gauntlets.lua")
dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/bronze_gauntlets.lua")
dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/gold_gauntlets.lua")
dofile(minetest.get_modpath("3d_armor_gloves_redo") .. "/diamond_gauntlets.lua")

if minetest.global_exists("armor") and armor.elements then
	table.insert(armor.elements, "hands")
else
	minetest.log("warning","[3d_armor_gloves_redo] loaded but unused, no 3d_armor mod detected")
	return
end