-- sound by fstagi : https://freesound.org/people/fstagi/sounds/405391/
pixel_animals.enable_rattlesnake_spawn = core.settings:get_bool("enable_rattlesnake_spawn", true)

--[[
core.register_craftitem("pixel_animals:snake_rattle", {
    description = "Snake Rattle",
    inventory_image = "snake_rattle.png"
})
]]

mobs:register_mob("pixel_animals:rattlesnake", {
	--nametag = "rattlesnake",
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
	collisionbox = {-0.4, -0, -0.4, 0.4, 0.1, 0.4},
	visual = "mesh",
	visual_size = {x = 8, y = 7},
	mesh = "rattlesnake.b3d",
	--rotate = 180,
	textures = {
		{"rattlesnake.png"},	
	},
	makes_footstep_sound = false,
	sounds = {
		random = "rattlesnake",
		--death = " ",
	},
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 4,
	runaway = true,
	jump = true,
	jump_height = 1,
	stepheight = 2,
	fall_damage = 1,
	view_range = 15, 
	drops = {
	 -- {name = "pixel_animals:rattlesnake_scutes", chance = 2, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 15,
		speed_stand = 9,
		stand_start = 1,
		stand_end = 19,
		stand1_start = 25,
		stand1_end = 55,
		walk_start = 60,
		walk_end = 90,
		run_start = 60,
		run_end = 90,
		--stoodup_speed = 5,
		--stoodup_start = 100,
		--stoodup_end = 110,
		punch_start = 60, 
		punch_end =90,
		--punch_speed = 23, 
		--fly_start = 20,			
		--fly_end = 59,
	},	
})

if pixel_animals.enable_rattlesnake_spawn then
mobs:spawn({
	name = "pixel_animals:rattlesnake",
	nodes = {"default:desert_sand","mcl_core:sand"},
	biomes = {"Desert","desert"},
	min_light = 7,
	max_light = 14,
	chance = 2000,
	min_height = 0,
	max_height = 5,
	active_object_count = 3,	
})
end

mobs:register_egg("pixel_animals:rattlesnake", "Rattlesnake", "rattlesnakegg.png", 0)

