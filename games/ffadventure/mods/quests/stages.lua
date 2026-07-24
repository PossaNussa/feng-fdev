-- Quest stage definitions
-- Add new stages by appending to this table
-- Quests within a stage can be completed in any order.

quests.stages = {
	{
		name = "hunter_gatherer",
		title = "Hunter-Gatherer",
		quests = {
			{
				id = "craft_flint_axe",
				desc = "Craft a flint axe",
				icon = "default_tool_stoneaxe.png",
				trigger = "craft",
				items = {"default:axe_stone"},
			},
			{
				id = "craft_flint_pick",
				desc = "Craft a flint pickaxe",
				icon = "default_tool_stonepick.png",
				trigger = "craft",
				items = {"default:pick_stone"},
			},
			{
				id = "craft_flint_shovel",
				desc = "Craft a flint shovel",
				icon = "default_tool_stoneshovel.png",
				trigger = "craft",
				items = {"default:shovel_stone"},
			},
			{
				id = "craft_flint_weapon",
				desc = "Craft a flint weapon (sword or spear)",
				icon = "default_tool_stonesword.png",
				trigger = "craft",
				items = {"default:sword_stone", "spears:spear_flint"},
			},
			{
				id = "obtain_wood",
				desc = "Chop down a tree",
				icon = "default_tree.png",
				trigger = "dig",
				groups = {"tree"},
			},
			{
				id = "craft_table",
				desc = "Craft a simple crafting table",
				icon = "craft_table_front.png",
				trigger = "craft",
				items = {"craft_table:simple"},
			},
			{
				id = "craft_bed",
				desc = "Craft a sleeping bag or hammock",
				icon = "wool_green.png",
				trigger = "craft",
				items = {"beds:sleeping_bag_bottom", "beds:sleeping_bag", "beds:hammock_bottom", "beds:hammock"},
			},
			{
				id = "craft_fire",
				desc = "Craft a bowdrill or torch",
				icon = "bowdrill.png",
				trigger = "craft",
				items = {"fire:bowdrill", "default:torch"},
			},
			{
				id = "craft_campfire",
				desc = "Build a campfire",
				icon = "default_tree_top.png",
				trigger = "craft",
				items = {"default:campfire"},
			},
			{
				id = "craft_fishing_net",
				desc = "Craft a fishing net",
				icon = "default:fishing_net",
				trigger = "craft",
				items = {"default:fishing_net"},
			},
			{
				id = "craft_woven_cap",
				desc = "Craft a woven cap",
				icon = "armor_expanded_inv_helmet_woven.png",
				trigger = "craft",
				items = {"armor_expanded:helmet_woven"},
			},
			{
				id = "craft_woven_tunic",
				desc = "Craft a woven tunic",
				icon = "armor_expanded_inv_chestplate_woven.png",
				trigger = "craft",
				items = {"armor_expanded:chestplate_woven"},
			},
			{
				id = "craft_woven_pants",
				desc = "Craft woven pants",
				icon = "armor_expanded_inv_leggings_woven.png",
				trigger = "craft",
				items = {"armor_expanded:leggings_woven"},
			},
			{
				id = "craft_woven_boots",
				desc = "Craft woven boots",
				icon = "armor_expanded_inv_boots_woven.png",
				trigger = "craft",
				items = {"armor_expanded:boots_woven"},
			},
			{
				id = "craft_woven_gauntlets",
				desc = "Craft woven gauntlets",
				icon = "3d_armor_gloves_ae_inv_gloves_woven.png",
				trigger = "craft",
				items = {"3d_armor_gloves_ae:gloves_woven"},
			},
		},
	},
	-- Future stages go here
}
