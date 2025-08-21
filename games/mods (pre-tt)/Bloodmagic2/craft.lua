
minetest.register_craft({
	output="bloodmagic2:needle 10",
	recipe={
		{"", "default:glass", "default:obsidian_shard"},
		{"default:glass", "", "default:glass"},
		{"default:steel_ingot", "default:glass", ""}
	}
})

minetest.register_craft({
	type="cooking",
	output="bloodmagic2:needle_sterile",
	recipe="bloodmagic2:needle",
})

minetest.register_craft({
	output="bloodmagic2:tube 40",
	recipe={
		{"dye:magenta", "default:glass", "default:obsidian_shard"},
		{"default:glass", "", "default:glass"},
		{"default:glass", "default:glass", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:tube_blood",
	type="shapeless",
	recipe={"bloodmagic2:needle_blood", "bloodmagic2:tube"},
	replacements = {{"bloodmagic2:needle_blood","bloodmagic2:needle"}}
})

minetest.register_craft({
	output="bloodmagic2:tube_blood_contaminated",
	type="shapeless",
	recipe={"bloodmagic2:needle_blood_contaminated", "bloodmagic2:tube"},
	replacements = {{"bloodmagic2:needle_blood_contaminated","bloodmagic2:needle"}}
})

minetest.register_craft({
	output="bloodmagic2:tube_leaf",
	type="shapeless",
	recipe={"group:leaves", "bloodmagic2:tube"},
})

minetest.register_craft({
	type="cooking",
	output="bloodmagic2:tube_serum",
	recipe="bloodmagic2:tube_blood",
})

minetest.register_craft({
	type="cooking",
	output="bloodmagic2:tube_blood",
	recipe="bloodmagic2:tube_blood_contaminated",
})

minetest.register_craft({
	type="cooking",
	output="bloodmagic2:tube_sap",
	recipe="bloodmagic2:tube_leaf",
})

minetest.register_craft({
	output="bloodmagic2:knife",
	recipe={
		{"", "bloodmagic2:tube_serum", "default:steel_ingot"},
		{"", "default:steel_ingot", "bloodmagic2:tube_serum"},
		{"default:obsidian_shard", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:knife_2 15",
	recipe={
		{"", "bloodmagic2:runestone_interference", "default:obsidian_shard"},
		{"bloodmagic2:tube_blood_contaminated", "default:obsidian_shard", "bloodmagic2:runestone_catalysis"},
		{"default:steel_ingot", "bloodmagic2:tube_blood_contaminated", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:ritual_dagger",
	recipe={
		{"", "bloodmagic2:tube_blood", "default:steel_ingot"},
		{"", "bloodmagic2:runestone_catalysis", "bloodmagic2:tube_blood"},
		{"bloodmagic2:knife", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:transfuser",
	recipe={
		{"bloodmagic2:tube_sap", "bloodmagic2:tube_sap", "bloodmagic2:tube_sap"},
		{"bloodmagic2:tube_sap", "vessels:glass_bottle", "bloodmagic2:tube_sap"},
		{"bloodmagic2:needle", "", "bloodmagic2:needle"}
	}
})

minetest.register_craft({
	output="bloodmagic2:altar_stone",
	recipe={
		{"bloodmagic2:tube_blood", "bloodmagic2:blood_gem", "bloodmagic2:tube_blood"},
		{"bloodmagic2:tube_serum", "default:stone", "bloodmagic2:tube_serum"},
		{"default:obsidian", "default:stone", "default:obsidian"}
	}
})

minetest.register_craft({
	output="bloodmagic2:blood_gem",
	recipe={
		{"", "bloodmagic2:tube_sap", ""},
		{"bloodmagic2:tube_blood", "default:mese_crystal", "bloodmagic2:tube_blood"},
		{"", "default:gold_lump", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:runestone 4",
	recipe={
		{"", "bloodmagic2:tube_sap", ""},
		{"bloodmagic2:tube_serum", "default:stone", "bloodmagic2:tube_blood"},
		{"", "default:tin_ingot", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:runestone_catalysis",
	recipe={
		{"", "flowers:mushroom_red", ""},
		{"bloodmagic2:tube_serum", "bloodmagic2:runestone", "bloodmagic2:tube_blood"},
		{"", "farming:seed_cotton", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:runestone_interference",
	recipe={
		{"", "default:mese_crystal_fragment", ""},
		{"bloodmagic2:tube_serum", "bloodmagic2:runestone", "bloodmagic2:tube_blood"},
		{"", "flowers:viola", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:parchment 3",
	recipe={
		{"dye:white", "bloodmagic2:tube_serum", "dye:yellow"},
		{"default:paper", "default:paper", "default:paper"},
		{"", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:parchment_flask",
	recipe={
		{"dye:black", "bloodmagic2:tube", "dye:magenta"},
		{"", "bloodmagic2:parchment", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:parchment_gem",
	recipe={
		{"dye:red", "default:mese_crystal_fragment", "dye:yellow"},
		{"", "bloodmagic2:parchment", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:recipe_flask_hp",
	recipe={
		{"group:leaves", "default:apple", "dye:red"},
		{"", "bloodmagic2:parchment_flask", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:parchment_alchemical",
	recipe={
		{"dye:red", "bloodmagic2:hemoglod", "dye:yellow"},
		{"", "bloodmagic2:parchment", ""},
		{"", "", ""}
	}
})

minetest.register_craft({
	output="bloodmagic2:hemoglod 5",
	recipe={
		{"default:gold_ingot", "bloodmagic2:tube_serum", "default:gold_ingot"},
		{"bloodmagic2:tube_serum", "default:gold_ingot", "bloodmagic2:tube_serum"},
		{"default:gold_ingot", "bloodmagic2:tube_serum", "default:gold_ingot"}
	}
})

minetest.register_craft({
	output="bloodmagic2:scramrax",
	recipe={
		{"bloodmagic2:hemoglod", "bloodmagic2:blood_gem", "bloodmagic2:hemoglod"},
		{"bloodmagic2:hemoglod", "default:stick", "bloodmagic2:hemoglod"},
		{"farming:cotton", "default:stick", "farming:cotton"}
	}
})