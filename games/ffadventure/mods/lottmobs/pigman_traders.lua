-- Pigman Traders for mg_villages integration
-- These replace the mobf_trader system with the lottmobs trading system

-- Common pigman names (shared across all professions)
local pigman_names = {
	"Yorath", "Zarek", "Caradoc", "Ulfgar", "Malachar",
	"Oren", "Rennard", "Henric", "Jorik", "Leander", "Theron", "Magnus",
	"Fendrel", "Ivor", "Ronan", "Viggo", "Wystan", "Ulfric", "Uther",
	"Tuskvar", "Swinmund", "Verrodan", "Hoggarim", "Bristovar", "Grunthar",
	"Boarin", "Snorrik", "Truffald", "Hogrim", "Verrond", "Swinhelm",
	"Bristow", "Tuskald", "Grunwald", "Boarthan", "Hoggard", "Verrik",
	"Truffen", "Swindar", "Tuskar", "Grondal", "Boarwulf", "Snortan",
	"Hogwulf", "Verran", "Truffin", "Bristal", "Gruntald", "Boarthor",
	"Hogarth", "Swinrik", "Bristogar", "Tuskrim", "Grondak", "Borvald"
}

-- Blacksmith - sells metal tools, armor, and ingots
lottmobs.pigman_blacksmith = {
	items = {
		{"default:pick_steel 1", "simplecoins:coins 45", 10},
		{"default:axe_steel 1", "simplecoins:coins 45", 10},
		{"default:shovel_steel 1", "simplecoins:coins 30", 10},
		{"default:sword_steel 1", "simplecoins:coins 50", 12},
		{"spears:real_spear_steel 1", "simplecoins:coins 55", 15},
		{"farming:hoe_steel 1", "simplecoins:coins 35", 15},
		{"default:steel_ingot 5", "simplecoins:coins 25", 8},
		{"default:steel_ingot 20", "simplecoins:coins 90", 12},
		{"default:bronze_ingot 5", "simplecoins:coins 30", 10},
		{"default:copper_ingot 10", "simplecoins:coins 40", 10},
		{"3d_armor:helmet_steel 1", "simplecoins:coins 120", 25},
		{"3d_armor:chestplate_steel 1", "simplecoins:coins 200", 30},
		{"3d_armor:leggings_steel 1", "simplecoins:coins 160", 28},
		{"3d_armor:boots_steel 1", "simplecoins:coins 80", 22},
		{"shields:shield_steel 1", "simplecoins:coins 150", 25},
		{"bucket:bucket_empty 1", "simplecoins:coins 35", 15},
	},
	items_race = {
		{"default:pick_steel 1", "simplecoins:coins 30", 10},
		{"default:axe_steel 1", "simplecoins:coins 30", 10},
		{"default:shovel_steel 1", "simplecoins:coins 20", 10},
		{"default:sword_steel 1", "simplecoins:coins 35", 12},
		{"spears:real_spear_steel 1", "simplecoins:coins 40", 15},
		{"farming:hoe_steel 1", "simplecoins:coins 25", 15},
		{"default:steel_ingot 10", "simplecoins:coins 40", 8},
		{"default:steel_ingot 40", "simplecoins:coins 150", 12},
		{"default:bronze_ingot 10", "simplecoins:coins 50", 10},
		{"default:copper_ingot 20", "simplecoins:coins 70", 10},
		{"3d_armor:helmet_steel 1", "simplecoins:coins 80", 25},
		{"3d_armor:chestplate_steel 1", "simplecoins:coins 140", 30},
		{"3d_armor:leggings_steel 1", "simplecoins:coins 110", 28},
		{"3d_armor:boots_steel 1", "simplecoins:coins 55", 22},
		{"shields:shield_steel 1", "simplecoins:coins 100", 25},
		{"bucket:bucket_empty 1", "simplecoins:coins 25", 15},
	},
	names = pigman_names,
	messages = {
		"The forge is hot today! What can I craft for you?",
		"Steel, bronze, copper - I work with all metals.",
		"My hammer has shaped a thousand blades.",
		"Need tools? Armor? I've got the best in the village.",
		"Careful with that sword, it's freshly sharpened!",
	}
}

-- Baker - sells bread, pies, and baked goods
lottmobs.pigman_baker = {
	items = {
		{"farming:bread 5", "simplecoins:coins 15", 5},
		{"farming:bread 20", "simplecoins:coins 55", 8},
		{"bushes:blueberry_pie_cooked 1", "simplecoins:coins 20", 15},
		{"bushes:strawberry_pie_cooked 1", "simplecoins:coins 20", 15},
		{"bushes:raspberry_pie_cooked 1", "simplecoins:coins 20", 15},
		{"bushes:basket_blueberry 1", "simplecoins:coins 35", 20},
		{"bushes:basket_strawberry 1", "simplecoins:coins 35", 20},
		{"farming:flour 10", "simplecoins:coins 25", 12},
		{"farming:flour 40", "simplecoins:coins 90", 15},
		{"default:apple 10", "simplecoins:coins 15", 10},
		{"x_farming:corn 5", "simplecoins:coins 12", 12},
		{"x_farming:strawberry 10", "simplecoins:coins 18", 15},
	},
	items_race = {
		{"farming:bread 10", "simplecoins:coins 20", 5},
		{"farming:bread 40", "simplecoins:coins 75", 8},
		{"bushes:blueberry_pie_cooked 2", "simplecoins:coins 25", 15},
		{"bushes:strawberry_pie_cooked 2", "simplecoins:coins 25", 15},
		{"bushes:raspberry_pie_cooked 2", "simplecoins:coins 25", 15},
		{"bushes:basket_blueberry 1", "simplecoins:coins 25", 20},
		{"bushes:basket_strawberry 1", "simplecoins:coins 25", 20},
		{"farming:flour 20", "simplecoins:coins 40", 12},
		{"farming:flour 80", "simplecoins:coins 150", 15},
		{"default:apple 20", "simplecoins:coins 20", 10},
		{"x_farming:corn 10", "simplecoins:coins 18", 12},
		{"x_farming:strawberry 20", "simplecoins:coins 28", 15},
	},
	names = pigman_names,
	messages = {
		"Fresh bread, straight from the oven!",
		"My pies are the best in the village.",
		"The smell of baking fills my shop every morning.",
		"Hungry? I've got just what you need.",
		"My grandmother's recipe, passed down for generations.",
	}
}

-- Farmer - sells crops, seeds, and farming supplies
lottmobs.pigman_farmer = {
	items = {
		{"farming:seed_wheat 20", "simplecoins:coins 15", 8},
		{"farming:seed_cotton 10", "simplecoins:coins 12", 10},
		{"farming:wheat 20", "simplecoins:coins 20", 8},
		{"farming:cotton 10", "simplecoins:coins 18", 10},
		{"default:apple 15", "simplecoins:coins 18", 8},
		{"x_farming:carrot 10", "simplecoins:coins 15", 12},
		{"x_farming:potato 10", "simplecoins:coins 15", 12},
		{"x_farming:corn 8", "simplecoins:coins 14", 10},
		{"x_farming:melon_item 5", "simplecoins:coins 20", 15},
		{"farming:hoe_wood 1", "simplecoins:coins 10", 10},
		{"farming:hoe_stone 1", "simplecoins:coins 18", 12},
		{"cottages:straw_mat 10", "simplecoins:coins 15", 10},
		{"default:papyrus 15", "simplecoins:coins 20", 12},
	},
	items_race = {
		{"farming:seed_wheat 40", "simplecoins:coins 20", 8},
		{"farming:seed_cotton 20", "simplecoins:coins 18", 10},
		{"farming:wheat 40", "simplecoins:coins 30", 8},
		{"farming:cotton 20", "simplecoins:coins 28", 10},
		{"default:apple 30", "simplecoins:coins 28", 8},
		{"x_farming:carrot 20", "simplecoins:coins 22", 12},
		{"x_farming:potato 20", "simplecoins:coins 22", 12},
		{"x_farming:corn 16", "simplecoins:coins 22", 10},
		{"x_farming:melon_item 10", "simplecoins:coins 32", 15},
		{"farming:hoe_wood 1", "simplecoins:coins 6", 10},
		{"farming:hoe_stone 1", "simplecoins:coins 12", 12},
		{"cottages:straw_mat 20", "simplecoins:coins 22", 10},
		{"default:papyrus 30", "simplecoins:coins 32", 12},
	},
	names = pigman_names,
	messages = {
		"Fresh from the fields!",
		"My crops are the finest in the village.",
		"Seeds for planting, produce for eating.",
		"The soil here is rich and fertile.",
		"A good harvest this season!",
	}
}

-- Stonemason - sells stone, brick, and building materials
lottmobs.pigman_stonemason = {
	items = {
		{"default:stone 50", "simplecoins:coins 40", 8},
		{"default:cobble 50", "simplecoins:coins 30", 8},
		{"default:stonebrick 30", "simplecoins:coins 45", 10},
		{"default:desert_stonebrick 30", "simplecoins:coins 50", 12},
		{"default:brick 20", "simplecoins:coins 40", 12},
		{"stairs:stair_stone 20", "simplecoins:coins 35", 15},
		{"stairs:stair_cobble 20", "simplecoins:coins 30", 15},
		{"stairs:slab_stone 30", "simplecoins:coins 35", 15},
		{"default:gravel 30", "simplecoins:coins 25", 10},
		{"default:sand 30", "simplecoins:coins 20", 10},
		{"default:sandstone 30", "simplecoins:coins 35", 12},
		{"default:furnace 1", "simplecoins:coins 50", 20},
	},
	items_race = {
		{"default:stone 99", "simplecoins:coins 60", 8},
		{"default:cobble 99", "simplecoins:coins 45", 8},
		{"default:stonebrick 60", "simplecoins:coins 70", 10},
		{"default:desert_stonebrick 60", "simplecoins:coins 80", 12},
		{"default:brick 40", "simplecoins:coins 65", 12},
		{"stairs:stair_stone 40", "simplecoins:coins 55", 15},
		{"stairs:stair_cobble 40", "simplecoins:coins 45", 15},
		{"stairs:slab_stone 60", "simplecoins:coins 55", 15},
		{"default:gravel 60", "simplecoins:coins 40", 10},
		{"default:sand 60", "simplecoins:coins 30", 10},
		{"default:sandstone 60", "simplecoins:coins 55", 12},
		{"default:furnace 1", "simplecoins:coins 35", 20},
	},
	names = pigman_names,
	messages = {
		"Stone, brick, mortar - I've got it all.",
		"Building something? I can help.",
		"My stones are cut with precision.",
		"From cobble to polished marble.",
		"A solid foundation starts here.",
	}
}

-- Carpenter - sells wood items, furniture, and fences
lottmobs.pigman_carpenter = {
	items = {
		{"default:wood 30", "simplecoins:coins 25", 8},
		{"default:junglewood 20", "simplecoins:coins 30", 10},
		{"default:fence_wood 20", "simplecoins:coins 30", 12},
		{"doors:door_wood 2", "simplecoins:coins 25", 12},
		{"default:chest 1", "simplecoins:coins 35", 15},
		{"default:chest_locked 1", "simplecoins:coins 55", 18},
		{"default:bookshelf 1", "simplecoins:coins 45", 18},
		{"default:ladder 10", "simplecoins:coins 20", 10},
		{"default:sign_wall 5", "simplecoins:coins 15", 12},
		{"cottages:bench 2", "simplecoins:coins 25", 15},
		{"cottages:table 1", "simplecoins:coins 30", 15},
		{"cottages:shelf 1", "simplecoins:coins 35", 18},
		{"stairs:stair_wood 20", "simplecoins:coins 30", 12},
		{"stairs:slab_wood 30", "simplecoins:coins 30", 12},
	},
	items_race = {
		{"default:wood 60", "simplecoins:coins 40", 8},
		{"default:junglewood 40", "simplecoins:coins 50", 10},
		{"default:fence_wood 40", "simplecoins:coins 48", 12},
		{"doors:door_wood 4", "simplecoins:coins 40", 12},
		{"default:chest 2", "simplecoins:coins 55", 15},
		{"default:chest_locked 2", "simplecoins:coins 90", 18},
		{"default:bookshelf 2", "simplecoins:coins 75", 18},
		{"default:ladder 20", "simplecoins:coins 32", 10},
		{"default:sign_wall 10", "simplecoins:coins 22", 12},
		{"cottages:bench 4", "simplecoins:coins 40", 15},
		{"cottages:table 2", "simplecoins:coins 48", 15},
		{"cottages:shelf 2", "simplecoins:coins 55", 18},
		{"stairs:stair_wood 40", "simplecoins:coins 48", 12},
		{"stairs:slab_wood 60", "simplecoins:coins 48", 12},
	},
	names = pigman_names,
	messages = {
		"Fine woodwork, crafted with care.",
		"From planks to furniture, I do it all.",
		"Need a chest? A door? I've got you covered.",
		"My father was a carpenter, and his father before him.",
		"Wood is my trade, quality is my promise.",
	}
}

-- Miller - sells flour and grain products
lottmobs.pigman_miller = {
	items = {
		{"farming:flour 20", "simplecoins:coins 30", 8},
		{"farming:flour 50", "simplecoins:coins 70", 10},
		{"farming:flour 99", "simplecoins:coins 130", 12},
		{"farming:seed_wheat 30", "simplecoins:coins 20", 10},
		{"farming:wheat 30", "simplecoins:coins 25", 10},
		{"cottages:straw_mat 20", "simplecoins:coins 25", 12},
		{"cottages:handmill 1", "simplecoins:coins 120", 25},
	},
	items_race = {
		{"farming:flour 40", "simplecoins:coins 45", 8},
		{"farming:flour 99", "simplecoins:coins 110", 10},
		{"farming:seed_wheat 60", "simplecoins:coins 32", 10},
		{"farming:wheat 60", "simplecoins:coins 38", 10},
		{"cottages:straw_mat 40", "simplecoins:coins 38", 12},
		{"cottages:handmill 1", "simplecoins:coins 85", 25},
	},
	names = pigman_names,
	messages = {
		"Flour ground fresh daily.",
		"The mill never stops turning.",
		"From wheat to flour, I make the magic happen.",
		"Bakers depend on my flour.",
		"The finest grain in the region.",
	}
}

-- Shopkeeper - sells general goods and sundries
lottmobs.pigman_shopkeeper = {
	items = {
		{"default:torch 20", "simplecoins:coins 15", 5},
		{"moretorches:clantern 5", "simplecoins:coins 35", 10},
		{"default:paper 10", "simplecoins:coins 18", 12},
		{"default:book 3", "simplecoins:coins 30", 15},
		{"default:coal_lump 20", "simplecoins:coins 25", 8},
		{"default:stick 30", "simplecoins:coins 12", 8},
		{"default:clay_lump 20", "simplecoins:coins 22", 12},
		{"wool:white 10", "simplecoins:coins 30", 12},
		{"vessels:glass_bottle 5", "simplecoins:coins 20", 15},
		{"vessels:drinking_glass 5", "simplecoins:coins 18", 15},
		{"default:flint 10", "simplecoins:coins 15", 12},
		{"bones:bones 5", "simplecoins:coins 20", 18},
	},
	items_race = {
		{"default:torch 40", "simplecoins:coins 22", 5},
		{"moretorches:clantern 10", "simplecoins:coins 55", 10},
		{"default:paper 20", "simplecoins:coins 28", 12},
		{"default:book 6", "simplecoins:coins 48", 15},
		{"default:coal_lump 40", "simplecoins:coins 40", 8},
		{"default:stick 60", "simplecoins:coins 18", 8},
		{"default:clay_lump 40", "simplecoins:coins 35", 12},
		{"wool:white 20", "simplecoins:coins 48", 12},
		{"vessels:glass_bottle 10", "simplecoins:coins 32", 15},
		{"vessels:drinking_glass 10", "simplecoins:coins 28", 15},
		{"default:flint 20", "simplecoins:coins 22", 12},
		{"bones:bones 10", "simplecoins:coins 32", 18},
	},
	names = pigman_names,
	messages = {
		"A little bit of everything!",
		"If I don't have it, you don't need it.",
		"Come browse my wares.",
		"Fair prices for quality goods.",
		"The village general store at your service.",
	}
}

-- Innkeeper - sells food, drinks, and beds
lottmobs.pigman_innkeeper = {
	items = {
		{"farming:bread 10", "simplecoins:coins 25", 8},
		{"default:apple 15", "simplecoins:coins 18", 10},
		{"bushes:blueberry_pie_cooked 2", "simplecoins:coins 30", 15},
		{"cottages:sleeping_mat 1", "simplecoins:coins 35", 15},
		{"beds:bed 1", "simplecoins:coins 80", 25},
		{"vessels:drinking_glass 5", "simplecoins:coins 18", 12},
		{"vessels:glass_bottle 5", "simplecoins:coins 20", 12},
		{"default:torch 15", "simplecoins:coins 12", 8},
		{"moretorches:clantern 3", "simplecoins:coins 25", 12},
	},
	items_race = {
		{"farming:bread 20", "simplecoins:coins 38", 8},
		{"default:apple 30", "simplecoins:coins 28", 10},
		{"bushes:blueberry_pie_cooked 4", "simplecoins:coins 48", 15},
		{"cottages:sleeping_mat 2", "simplecoins:coins 55", 15},
		{"beds:bed 1", "simplecoins:coins 60", 25},
		{"vessels:drinking_glass 10", "simplecoins:coins 28", 12},
		{"vessels:glass_bottle 10", "simplecoins:coins 32", 12},
		{"default:torch 30", "simplecoins:coins 18", 8},
		{"moretorches:clantern 6", "simplecoins:coins 40", 12},
	},
	names = pigman_names,
	messages = {
		"Welcome, traveler! Rest your weary bones.",
		"A warm bed and hot meal await.",
		"Best inn in the village!",
		"Stay the night, leave refreshed.",
		"We've got food, drink, and comfortable beds.",
	}
}

-- Food Seller - sells cooked meats, produce, and prepared foods from x_farming and animalia
lottmobs.pigman_foodseller = {
	items = {
		-- Cooked meats (animalia)
		{"animalia:beef_cooked 5", "simplecoins:coins 45", 12},
		{"animalia:mutton_cooked 5", "simplecoins:coins 38", 12},
		{"animalia:porkchop_cooked 5", "simplecoins:coins 40", 12},
		{"animalia:poultry_cooked 5", "simplecoins:coins 35", 12},
		{"animalia:venison_cooked 3", "simplecoins:coins 50", 15},
		-- Dairy and eggs
		{"animalia:bucket_milk 1", "simplecoins:coins 25", 15},
		{"animalia:chicken_egg 10", "simplecoins:coins 20", 10},
		-- x_farming prepared foods
		{"x_farming:carrot 10", "simplecoins:coins 15", 8},
		{"x_farming:carrot_golden 3", "simplecoins:coins 45", 20},
		{"x_farming:potato_baked 5", "simplecoins:coins 25", 10},
		{"x_farming:corn 10", "simplecoins:coins 18", 10},
		{"x_farming:popcorn 5", "simplecoins:coins 22", 12},
		{"x_farming:fries 3", "simplecoins:coins 28", 15},
		{"x_farming:donut 5", "simplecoins:coins 20", 12},
		{"x_farming:donut_chocolate 3", "simplecoins:coins 25", 15},
		{"x_farming:pumpkin_pie 2", "simplecoins:coins 30", 15},
		{"x_farming:beetroot_soup 2", "simplecoins:coins 28", 15},
		{"x_farming:fish_stew 2", "simplecoins:coins 35", 18},
		-- Fruits
		{"x_farming:melon 8", "simplecoins:coins 18", 10},
		{"x_farming:strawberry 15", "simplecoins:coins 22", 10},
		{"x_farming:kiwi 10", "simplecoins:coins 20", 12},
		{"x_farming:cactus_fruit_item 8", "simplecoins:coins 15", 12},
		-- Beverages
		{"x_farming:coffee_cup_hot 3", "simplecoins:coins 25", 15},
		{"x_farming:bottle_honey 2", "simplecoins:coins 35", 18},
	},
	items_race = {
		-- Cooked meats (animalia) - better prices for pigmen
		{"animalia:beef_cooked 10", "simplecoins:coins 70", 12},
		{"animalia:mutton_cooked 10", "simplecoins:coins 60", 12},
		{"animalia:porkchop_cooked 10", "simplecoins:coins 65", 12},
		{"animalia:poultry_cooked 10", "simplecoins:coins 55", 12},
		{"animalia:venison_cooked 6", "simplecoins:coins 80", 15},
		-- Dairy and eggs
		{"animalia:bucket_milk 2", "simplecoins:coins 40", 15},
		{"animalia:chicken_egg 20", "simplecoins:coins 32", 10},
		-- x_farming prepared foods
		{"x_farming:carrot 20", "simplecoins:coins 22", 8},
		{"x_farming:carrot_golden 6", "simplecoins:coins 72", 20},
		{"x_farming:potato_baked 10", "simplecoins:coins 40", 10},
		{"x_farming:corn 20", "simplecoins:coins 28", 10},
		{"x_farming:popcorn 10", "simplecoins:coins 35", 12},
		{"x_farming:fries 6", "simplecoins:coins 45", 15},
		{"x_farming:donut 10", "simplecoins:coins 32", 12},
		{"x_farming:donut_chocolate 6", "simplecoins:coins 40", 15},
		{"x_farming:pumpkin_pie 4", "simplecoins:coins 48", 15},
		{"x_farming:beetroot_soup 4", "simplecoins:coins 45", 15},
		{"x_farming:fish_stew 4", "simplecoins:coins 55", 18},
		-- Fruits
		{"x_farming:melon 16", "simplecoins:coins 28", 10},
		{"x_farming:strawberry 30", "simplecoins:coins 35", 10},
		{"x_farming:kiwi 20", "simplecoins:coins 32", 12},
		{"x_farming:cactus_fruit_item 16", "simplecoins:coins 22", 12},
		-- Beverages
		{"x_farming:coffee_cup_hot 6", "simplecoins:coins 40", 15},
		{"x_farming:bottle_honey 4", "simplecoins:coins 55", 18},
	},
	names = pigman_names,
	messages = {
		"Fresh meat and produce! Best in the village!",
		"Hungry? I've got cooked meats and hearty stews.",
		"From farm to table - quality you can taste!",
		"Try our famous porkchops! Perfectly seasoned.",
		"Fresh eggs, milk, and the finest cuts of meat.",
		"Fill your belly before your journey continues!",
		"Hot coffee to warm your bones on cold days.",
	}
}

-- Roofer - sells roofing materials
lottmobs.pigman_roofer = {
	items = {
		{"cottages:roof_straw 30", "simplecoins:coins 35", 10},
		{"cottages:roof_wood 30", "simplecoins:coins 40", 10},
		{"cottages:roof_red 30", "simplecoins:coins 45", 12},
		{"cottages:roof_brown 30", "simplecoins:coins 45", 12},
		{"cottages:roof_black 30", "simplecoins:coins 45", 12},
		{"cottages:roof_slate 30", "simplecoins:coins 50", 15},
		{"cottages:roof_flat_straw 20", "simplecoins:coins 25", 12},
		{"cottages:roof_flat_wood 20", "simplecoins:coins 28", 12},
	},
	items_race = {
		{"cottages:roof_straw 60", "simplecoins:coins 55", 10},
		{"cottages:roof_wood 60", "simplecoins:coins 65", 10},
		{"cottages:roof_red 60", "simplecoins:coins 72", 12},
		{"cottages:roof_brown 60", "simplecoins:coins 72", 12},
		{"cottages:roof_black 60", "simplecoins:coins 72", 12},
		{"cottages:roof_slate 60", "simplecoins:coins 80", 15},
		{"cottages:roof_flat_straw 40", "simplecoins:coins 40", 12},
		{"cottages:roof_flat_wood 40", "simplecoins:coins 45", 12},
	},
	names = pigman_names,
	messages = {
		"Keep the rain out with my roofing!",
		"Thatch, tile, or slate - I've got them all.",
		"A good roof makes a good home.",
		"No leaks guaranteed!",
		"My roofs last for generations.",
	}
}

-- Glassmaker - sells glass and glass products
lottmobs.pigman_glassmaker = {
	items = {
		{"default:glass 20", "simplecoins:coins 35", 10},
		{"default:glass 50", "simplecoins:coins 80", 12},
		{"default:obsidian_glass 10", "simplecoins:coins 50", 15},
		{"cottages:glass_pane 20", "simplecoins:coins 30", 12},
		{"vessels:glass_bottle 10", "simplecoins:coins 25", 10},
		{"vessels:drinking_glass 10", "simplecoins:coins 22", 10},
	},
	items_race = {
		{"default:glass 40", "simplecoins:coins 55", 10},
		{"default:glass 99", "simplecoins:coins 130", 12},
		{"default:obsidian_glass 20", "simplecoins:coins 80", 15},
		{"cottages:glass_pane 40", "simplecoins:coins 48", 12},
		{"vessels:glass_bottle 20", "simplecoins:coins 40", 10},
		{"vessels:drinking_glass 20", "simplecoins:coins 35", 10},
	},
	names = pigman_names,
	messages = {
		"Crystal clear glass, made with care.",
		"Windows, bottles, decorations - all glass!",
		"Watch your step, fragile merchandise!",
		"Light up your home with my glass.",
		"The finest sand makes the finest glass.",
	}
}

-- Dyemaker - sells dyed wool and dyes
lottmobs.pigman_dyemaker = {
	items = {
		{"wool:red 10", "simplecoins:coins 25", 12},
		{"wool:blue 10", "simplecoins:coins 25", 12},
		{"wool:green 10", "simplecoins:coins 25", 12},
		{"wool:yellow 10", "simplecoins:coins 25", 12},
		{"wool:orange 10", "simplecoins:coins 25", 12},
		{"wool:violet 10", "simplecoins:coins 25", 12},
		{"wool:brown 10", "simplecoins:coins 22", 10},
		{"wool:black 10", "simplecoins:coins 28", 15},
		{"wool:grey 10", "simplecoins:coins 22", 10},
		{"wool:pink 10", "simplecoins:coins 25", 12},
		{"wool:cyan 10", "simplecoins:coins 25", 12},
		{"wool:magenta 10", "simplecoins:coins 25", 12},
	},
	items_race = {
		{"wool:red 20", "simplecoins:coins 40", 12},
		{"wool:blue 20", "simplecoins:coins 40", 12},
		{"wool:green 20", "simplecoins:coins 40", 12},
		{"wool:yellow 20", "simplecoins:coins 40", 12},
		{"wool:orange 20", "simplecoins:coins 40", 12},
		{"wool:violet 20", "simplecoins:coins 40", 12},
		{"wool:brown 20", "simplecoins:coins 35", 10},
		{"wool:black 20", "simplecoins:coins 45", 15},
		{"wool:grey 20", "simplecoins:coins 35", 10},
		{"wool:pink 20", "simplecoins:coins 40", 12},
		{"wool:cyan 20", "simplecoins:coins 40", 12},
		{"wool:magenta 20", "simplecoins:coins 40", 12},
	},
	names = pigman_names,
	messages = {
		"Colors for every occasion!",
		"Brighten up your world with my dyes.",
		"From subtle to vibrant, I've got all colors.",
		"My dyes never fade!",
		"The finest pigments from across the land.",
	}
}

-- Default trader for professions not specifically defined
lottmobs.pigman_general = {
	items = {
		{"default:torch 15", "simplecoins:coins 12", 8},
		{"default:stick 20", "simplecoins:coins 10", 8},
		{"default:wood 20", "simplecoins:coins 18", 10},
		{"default:cobble 30", "simplecoins:coins 22", 10},
		{"default:coal_lump 15", "simplecoins:coins 18", 10},
		{"farming:bread 5", "simplecoins:coins 12", 10},
		{"default:apple 10", "simplecoins:coins 12", 10},
		{"default:paper 5", "simplecoins:coins 10", 12},
		{"wool:white 5", "simplecoins:coins 15", 12},
		{"default:clay_lump 10", "simplecoins:coins 12", 12},
	},
	items_race = {
		{"default:torch 30", "simplecoins:coins 18", 8},
		{"default:stick 40", "simplecoins:coins 15", 8},
		{"default:wood 40", "simplecoins:coins 28", 10},
		{"default:cobble 60", "simplecoins:coins 35", 10},
		{"default:coal_lump 30", "simplecoins:coins 28", 10},
		{"farming:bread 10", "simplecoins:coins 18", 10},
		{"default:apple 20", "simplecoins:coins 18", 10},
		{"default:paper 10", "simplecoins:coins 15", 12},
		{"wool:white 10", "simplecoins:coins 22", 12},
		{"default:clay_lump 20", "simplecoins:coins 18", 12},
	},
	names = pigman_names,
	messages = {
		"Welcome! Take a look around.",
		"I've got a bit of everything.",
		"Fair trades for fair folk.",
		"What can I help you with today?",
		"Quality goods at honest prices.",
	}
}

-- Mapping from profession titles to trader definitions
lottmobs.pigman_profession_map = {
	-- Smiths
	["blacksmith"] = lottmobs.pigman_blacksmith,
	["smith"] = lottmobs.pigman_blacksmith,
	["coppersmith"] = lottmobs.pigman_blacksmith,
	["bronzesmith"] = lottmobs.pigman_blacksmith,
	["tinsmith"] = lottmobs.pigman_blacksmith,
	["goldsmith"] = lottmobs.pigman_blacksmith,

	-- Food
	["baker"] = lottmobs.pigman_baker,
	["miller"] = lottmobs.pigman_miller,
	["farmer"] = lottmobs.pigman_farmer,
	["innkeeper"] = lottmobs.pigman_innkeeper,
	["barkeeper"] = lottmobs.pigman_innkeeper,
	["butcher"] = lottmobs.pigman_foodseller,
	["cook"] = lottmobs.pigman_foodseller,
	["chef"] = lottmobs.pigman_foodseller,
	["food seller"] = lottmobs.pigman_foodseller,
	["meat seller"] = lottmobs.pigman_foodseller,
	["grocer"] = lottmobs.pigman_foodseller,
	["fishmonger"] = lottmobs.pigman_foodseller,
	["tavern cook"] = lottmobs.pigman_foodseller,

	-- Building trades
	["stonemason"] = lottmobs.pigman_stonemason,
	["stoneminer"] = lottmobs.pigman_stonemason,
	["bricklayer"] = lottmobs.pigman_stonemason,
	["carpenter"] = lottmobs.pigman_carpenter,
	["toolmaker"] = lottmobs.pigman_carpenter,
	["doormaker"] = lottmobs.pigman_carpenter,
	["furnituremaker"] = lottmobs.pigman_carpenter,
	["stairmaker"] = lottmobs.pigman_carpenter,
	["cooper"] = lottmobs.pigman_carpenter,
	["wheelwright"] = lottmobs.pigman_carpenter,
	["roofer"] = lottmobs.pigman_roofer,

	-- Other trades
	["shopkeeper"] = lottmobs.pigman_shopkeeper,
	["seed seller"] = lottmobs.pigman_farmer,
	["flower seller"] = lottmobs.pigman_farmer,
	["ore seller"] = lottmobs.pigman_blacksmith,
	["fruit trader"] = lottmobs.pigman_foodseller,
	["wood trader"] = lottmobs.pigman_carpenter,
	["glassmaker"] = lottmobs.pigman_glassmaker,
	["dyemaker"] = lottmobs.pigman_dyemaker,
	["dyemakerl"] = lottmobs.pigman_dyemaker,
	["potterer"] = lottmobs.pigman_stonemason,
	["iceman"] = lottmobs.pigman_shopkeeper,
	["saddler"] = lottmobs.pigman_shopkeeper,
	["charachoal burner"] = lottmobs.pigman_shopkeeper,
	["teacher"] = lottmobs.pigman_shopkeeper,
	["schoolteacher"] = lottmobs.pigman_shopkeeper,
	["librarian"] = lottmobs.pigman_shopkeeper,
	["priest"] = lottmobs.pigman_shopkeeper,
	["guard"] = lottmobs.pigman_general,
	["soldier"] = lottmobs.pigman_general,
	["lumberjack"] = lottmobs.pigman_carpenter,
	["major"] = lottmobs.pigman_shopkeeper,
	["landlord"] = lottmobs.pigman_innkeeper,
	["sawmill owner"] = lottmobs.pigman_carpenter,
	["horsekeeper"] = lottmobs.pigman_farmer,
	["trader"] = lottmobs.pigman_shopkeeper,
}

-- Get the appropriate trader definition for a profession
function lottmobs.get_pigman_trader_for_profession(profession)
	if profession and lottmobs.pigman_profession_map[profession] then
		return lottmobs.pigman_profession_map[profession]
	end
	return lottmobs.pigman_general
end

-- The main lottmobs_trader function for pigman villagers
local function lottmobs_pigman_trader(self, clicker, race, image, priv)
	lottmobs.face_pos(self, clicker:get_pos())
	local player = clicker:get_player_name()

	-- Initialize or update self.game_name
	if not self.game_name or self.game_name == "mob" then
		self.game_name = tostring(race.names[math.random(1, #race.names)])
	end

	-- Ensuring self.id is properly initialized
	if not self.id or self.id == 0 then
		self.id = tostring(math.random(1, 1000) * math.random(1, 10000)) .. self.name .. tostring(math.random(1, 1000) ^ 2)
	end

	if self.game_name == "mob" then
		self.game_name = tostring(race.names[math.random(1, #race.names)])
	end

	local unique_entity_id = self.id

	if unique_entity_id then
		local is_inventory = minetest.get_inventory({ type = "detached", name = unique_entity_id })
		local same_race = false
		if priv and minetest.get_player_privs(player)[priv] ~= nil then
			same_race = true
		end
		local move_put_take = {
			allow_move = lottmobs.allow_move,
			allow_put = lottmobs.allow_put,
			allow_take = lottmobs.allow_take,
			on_move = function(inventory, from_list, from_index, to_list, to_index, count, player)
				if from_list == "goods" and to_list == "selection" then
					local inv = inventory
					local moved = inv.get_stack(inv, to_list, to_index)
					local goodname = moved.get_name(moved)
					local elements = moved.get_count(moved)
					if elements > count then
						inv.set_stack(inv, "selection", 1, goodname.." "..tostring(count))
						inv.set_stack(inv, "goods", from_index, goodname.." "..tostring(elements - count))
						elements = count
					end
					local good = nil
					if same_race == true then
						for i = 1, #race.items_race, 1 do
							local stackstring = goodname .." " .. count
							if race.items_race[i][1] == stackstring then
								good = race.items_race[i]
							end
						end
					else
						for i = 1, #race.items, 1 do
							local stackstring = goodname .." " .. count
							if race.items[i][1] == stackstring then
								good = race.items[i]
							end
						end
					end
					if good ~= nil then
						inventory.set_stack(inventory, "price", 1, good[2])
					else
						inventory.set_stack(inventory, "price", 1, nil)
					end
					lottmobs.update_takeaway(inv)
				end
			end,
			on_put = lottmobs.on_put,
			on_take = lottmobs.on_take
		}
		if is_inventory == nil then
			lottmobs.trader_inventory = minetest.create_detached_inventory(unique_entity_id, move_put_take)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "goods", 15)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "takeaway", 1)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "selection", 1)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "price", 1)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "payment", 1)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "selling", 1)
			lottmobs.trader_inventory.set_size(lottmobs.trader_inventory, "sellprice", 1)
			lottmobs.add_goods(nil, race)
		end

		-- Store context for formspec callbacks
		lottmobs.trader_context[player] = {
			inv_name = unique_entity_id,
			trader_name = self.game_name
		}

		-- Get a random message if available
		local greeting = "Hello, " .. player .. ", have a look at my wares."
		if race.messages and #race.messages > 0 then
			greeting = race.messages[math.random(1, #race.messages)]
		end

		minetest.chat_send_player(player, "[NPC] <Trader " .. self.game_name .. "> " .. greeting)
		minetest.show_formspec(player, "lottmobs:trade",
			"size[10,10.5;]" ..
			"background[5,5;1,1;" .. image .. ";true]" ..
			"label[0,0;Trader " .. self.game_name .. "'s stock:]" ..
			"list[detached:" .. unique_entity_id .. ";goods;0.25,0.5;3,5;]" ..

			-- Buy section
			"label[4,0;== BUY ==]" ..
			"label[4,0.5;Selection]" ..
			"list[detached:" .. unique_entity_id .. ";selection;4,1;1,1;]" ..
			"button[5.1,1;1.5,0.8;clear;Clear]" ..
			"label[6.7,0.5;Price]" ..
			"list[detached:" .. unique_entity_id .. ";price;6.7,1;1,1;]" ..
			"label[4,2.1;Payment]" ..
			"list[detached:" .. unique_entity_id .. ";payment;4,2.6;1,1;]" ..
			"label[5.5,2.1;You receive]" ..
			"list[detached:" .. unique_entity_id .. ";takeaway;5.5,2.6;1,1;]" ..

			-- Sell section
			"label[4,3.8;== SELL (1/2 price) ==]" ..
			"label[4,4.3;Your item]" ..
			"list[detached:" .. unique_entity_id .. ";selling;4,4.8;1,1;]" ..
			"label[5.5,4.3;You get]" ..
			"list[detached:" .. unique_entity_id .. ";sellprice;5.5,4.8;1,1;]" ..

			-- Player inventory
			"list[current_player;main;0,6.2;8,4;]" ..
			"listring[detached:" .. unique_entity_id .. ";goods]" ..
			"listring[detached:" .. unique_entity_id .. ";selection]" ..
			"listring[current_player;main]" ..
			"listring[detached:" .. unique_entity_id .. ";selling]"
		)
	else
		minetest.log("error", "unique_entity_id is nil in lottmobs_pigman_trader.")
	end
end

-- Register the pigman trader mob (uses same textures as mobf_trader villagers)
mobs:register_mob("lottmobs:pigman_trader", {
	type = "npc",
	race = "pigman",
	hp_min = 15,
	hp_max = 25,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	textures = {
		{"wheat_farmer_by_addi.png"},
		{"baeuerin.png"},
		{"kuhhaendler.png"},
		{"bauer_in_sonntagskleidung.png"},
		{"blacksmith.png"},
		{"holzfaeller.png"},
		{"character.png"},
	},
	visual = "mesh",
	visual_size = {x=1, y=1},
	mesh = "character.b3d",
	makes_footstep_sound = true,
	view_range = 12,
	walk_velocity = 1,
	run_velocity = 2,
	armor = 100,
	damage = 3,
	drops = {},
	light_resistant = true,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 10,
	light_damage = 0,
	attack_type = "dogfight",
	follow = {"default:apple", "farming:bread"},
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "default_punch2",
	},
	attacks_monsters = false,
	attack_npcs = false,
	attack_animals = false,
	peaceful = true,
	group_attack = {"lottmobs:pigman_trader", "zombies:buffpig"},
	step = 1,
	-- The profession will be set when spawned
	profession = nil,
	on_rightclick = function(self, clicker)
		local profession = self.profession or "shopkeeper"
		local race = lottmobs.get_pigman_trader_for_profession(profession)
		lottmobs_pigman_trader(self, clicker, race, "gui_formbg.png", "pigman")
	end,
})

-- Function to spawn a pigman trader with a specific profession (called by mg_villages)
function lottmobs.spawn_pigman_trader(pos, profession, name, gender)
	local obj = minetest.add_entity(pos, "lottmobs:pigman_trader")
	if obj then
		local ent = obj:get_luaentity()
		if ent then
			-- Generate a unique ID for this trader
			ent.id = "pigman_" .. tostring(math.random(1, 1000) * math.random(1, 10000)) .. tostring(os.time())

			ent.profession = profession or "shopkeeper"
			if name then
				ent.game_name = name
			end
			-- Set texture based on gender (matching mobf_trader behavior)
			local texture
			if gender == "f" then
				texture = "baeuerin.png"
			else
				-- Select texture based on profession for males
				if profession == "blacksmith" or profession == "smith" or profession == "coppersmith" or profession == "bronzesmith" then
					texture = "blacksmith.png"
				elseif profession == "lumberjack" or profession == "sawmill owner" then
					texture = "holzfaeller.png"
				elseif profession == "farmer" then
					texture = "wheat_farmer_by_addi.png"
				else
					-- Random selection from village trader textures
					local male_textures = {"kuhhaendler.png", "bauer_in_sonntagskleidung.png", "character.png", "wheat_farmer_by_addi.png"}
					texture = male_textures[math.random(1, #male_textures)]
				end
			end
			if texture then
				obj:set_properties({textures = {texture}})
			end
		end
		return obj
	end
	return nil
end

minetest.log("action", "[lottmobs] Pigman traders loaded")
