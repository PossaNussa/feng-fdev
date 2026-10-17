
-- sound random: https://freesound.org/people/D.jones/sounds/527844/
local crocodile_spawns = {
"default:dirt_with_rainforest_litter",
"mcl_mangrove:mangrove_mud_roots",
"rp_default:tall_grass"
}

core.register_craftitem("pixel_animals:crocodile_scutes", {
    description = "Crocodile Scutes",
    inventory_image = "crocodile_scutes.png"
})

mobs:register_mob("pixel_animals:crocodile", {
	--nametag = "crocodile",
	type = "monster",
        damage = 5,
	attack_type = "dogfight",
	attack_animals = true,
	pathfinding = true, 
	reach = 3,
	passive = false,
	hp_min = 30,
	hp_max = 30,
	armor = 100,
	--physical = true,
	collisionbox = {-0.8, -0.3, -0.4, 0.4, 0.1, 0.4},
	visual = "mesh",
	visual_size = {x = 8, y = 7},
	mesh = "crocodile.b3d",
	--rotate = 180,
	textures = {
		{"crocodile.png"},
		
	},
	makes_footstep_sound = false,
	sounds = {
		random = "alligator",
		--death = " ",
	},
	--fly = true , 
	--fly_in = "water",
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 4,
	runaway = true,
	jump = true,
	jump_height = 3,
	stepheight = 2,
	fall_damage = 1,
	-- follow = { },
	view_range = 15, 
	drops = {
	  {name = "pixel_animals:crocodile_scutes", chance = 2, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 15,
		--speed_run = 15,
		stand_start = 0,
		stand_end = 0,
		--stand1_start = 100,
		--stand1_end = 100,
		walk_start = 20,
		walk_end = 59,
		run_start = 70,
		run_end = 89,
		stoodup_speed = 5,
		stoodup_start = 100,
		stoodup_end = 110,
		punch_start = 120, 
		punch_end =160,
		--punch_speed = 23, 
		--fly_start = 20,			
		--fly_end = 59,
	},	
})

mobs:spawn({
	name = "pixel_animals:crocodile",
	nodes = crocodile_spawns,
	neighbors = {"default:water_source", "default:river_water_source", "group:water"},
	min_light = 5,
	max_light = 14,
	chance = 55000,
	min_height = -2,
	max_height = 10,
	active_object_count = 2,
})

mobs:register_egg("pixel_animals:crocodile", "Crocodile", "crocodilegg.png", 0)

