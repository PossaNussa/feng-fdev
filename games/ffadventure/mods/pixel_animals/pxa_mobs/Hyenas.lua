-- sound : https://freesound.org/people/mrbubble110/sounds/70333/
pixel_animals.enable_hyenas_spawn = core.settings:get_bool("enable_hyenas_spawn", true)

mobs:register_mob("pixel_animals:hyenas", {
	type = "monster",
    damage = 5,
	attack_type = "dogfight",
	attack_animals = true,
	pathfinding = true, 
	reach = 3,
	passive = false,
	hp_min = 20,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.5, 0, -0.5, 0.5, 1.0, 0.5},
	visual = "mesh",
	visual_size = {x = 12, y = 12},
	mesh = "Hyenas.glb",
	textures = {{"Hyenas.png"}},
	makes_footstep_sound = false,
	sounds = {
		random = "bear_roar",
	},
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 4,
	runaway = true,
	jump = true,
	jump_height = 3,
	stepheight = 2,
	fall_damage = 1,
	drops = {
		--{name = "mobs:leather", chance = 2, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 10,
		speed_run = 15,
		stand_start = 1,
		stand_end = 20,
		walk_start = 22,
		walk_end = 36,
		run_start = 38,
		run_end = 50,
	},
	view_range = 15, 	
})

if pixel_animals.enable_hyenas_spawn then
mobs:spawn({
	name = "pixel_animals:hyenas",
	nodes = {"default:desert_sand","mcl_core:sand","mcl_core:cactus"},
	--neighbors = {"",""},
	min_light = 8,
	--max_light = 14,
	chance = 8000,
	biomes = {"Desert","desert"},
	min_height = 0,
	max_height = 200,	
})
end

mobs:register_egg("pixel_animals:hyenas", "Hyenas", "hyenas_egg.png", 0)
