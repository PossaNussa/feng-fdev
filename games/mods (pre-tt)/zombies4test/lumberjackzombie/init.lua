local zombienods = {



} 


mobs:register_mob("lumberjackzombie:vampire", {
	--nametag = "Lumberjack Zombie" ,
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	--attack_animals = true,
	attack_npcs = false,
	group_attack = true,
	pathfinding = true,
	reach = 3,
	damage = 3,
	hp_min = 5,
	hp_max = 350,
	light_damage = 1,
	armor = 100,
	visual = "mesh",
	mesh = "zombie_normal.b3d",
	--rotate = 180,
	textures = {
		{"v1.png"},
	},
	--glow = 4,
	--blood_texture = " ",
	makes_footstep_sound = true,
	sounds = {
		random ="zombie_angry",
		--attack = "zombie_hit",
		death = "zombie_death ",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump_height = 2,
	stepheight = 1.1,
	floats = 0,
	view_range = 35,
	drops = {
		{name = "default:gold_ingot",
		chance = 1,
		min = 0,
		max = 9,},
		{name = "default:silverbar",
		chance = 12,
		min = 0,
		max = 9,},
		{name = "default:rustysword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:silver_sword",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:csteel_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
		{name = "default:copper_ingot",
		chance = 4,
		min = 0,
		max = 9,},		
		{name = "default:ironbar",
		chance = 5,
		min = 0,
		max = 9,},			
		{name = "default:coal",
		chance = 3,
		min = 0,
		max = 9,},
		{name = "default:fopal",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:diamond",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:peridot",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:ruby",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:emerald",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:btopaz",
		chance = 9,
		min = 0,
		max = 1,},
		},
	water_damage = 0,
	lava_damage = 1,
	light_damage = 19,
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},

})




  mobs:register_spawn("lumberjackzombie:vampire", {"group:crumbly", "default:dirt_with_grass"}, 15, 0, 12000, 1, 31000, false)
  

mobs:register_egg("lumberjackzombie:lumberjackzombie", "Vampire", "zombies_egg.png", 0)






