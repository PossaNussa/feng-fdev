
mobs:spawn({
	name = "mobs_animal:cow",
	nodes = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass", "variety:japanese_dirt_with_grass"},
	neighbors = {"group:grass"},
	min_light = 14,
	interval = 60,
	chance = 8000,
	min_height = 5,
	max_height = 200,
	day_toggle = true,
})

-- Kitten

mobs:spawn({
	name = "mobs_animal:kitten",
	nodes = {"default:dirt_with_grass", "variety:japanese_dirt_with_grass"},
	neighbors = {"group:grass"},
	min_light = 14,
	interval = 60,
	chance = 10000,
	min_height = 5,
	max_height = 50,
	day_toggle = true,
})