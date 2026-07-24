local attack_mobs = {"mobs_animal:bee"}

local fly_nodes = {
"default:water_source", 
"default:water_flowing",
"rp_default:water_source",
"rp_default:river_water_source",
"mcl_core:water_source",
"hades_core:water_source"}

local spawn_nodes = {
"default:dirt_with_rainforest_litter",
"mcl_mangrove:mangrove_mud_roots",
"mcl_mangrove:mangrove_roots",
"rp_default:dirt_with_swamp_grass"}

mobs:register_mob("pixel_animals:frog", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_animals = true,
	specific_attack = attack_mobs,
	pathfinding = true,
	reach = 2,
	damage = 5,
	hp_min = 5,
	hp_max = 5,
	armor = 150,
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	mesh = "frog.b3d",
	textures = {
		{"frog.png"},
		--{"frog_brown.png"},				
	},
	makes_footstep_sound = true,
	sounds = {
		random = "frog",
	},
	walk_velocity = 2,
	run_velocity = 3,
	jump = true,
	jump_height = 6,
	fly_in = fly_nodes,
	floats = 0,
	stepheight = 1.1,
	fall_damage = 1,
	view_range = 20,
	drops = {--{name = " ", chance = 2, min = 1, max = 1},	
	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	follow = {"mobs_animal:bee","pixel_animals:leafcutter_ant"}, 
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 0,	
		walk_start = 20,
		walk_end = 59,
		run_start = 70,
		run_end = 89,
		stoodup_speed = 5,
		stoodup_start = 100,
		stoodup_end = 110,
		punch_start = 120, 
		punch_end =160,	
	},
	
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end		
	end,	
})

mobs:spawn({
	name = "pixel_animals:frog",
	nodes = spawn_nodes,
	min_light = 8,
	--max_light = 14,
	chance = 8000,
	min_height = 0,
	max_height = 200,
	active_object_count = 3,	
})

mobs:register_egg("pixel_animals:frog", "Frog", "frogegg.png", 0)
