local marmot_spawns = {
"default:permafrost",
"default:permafrost_with_moss",
"mcl_core:dirt_with_grass",
"rp_default:tall_grass"
}

mobs:register_mob("pixel_animals:marmot", {
	type = "animal",
	passive = true,
	--attack_type = "dogfight",
	--attack_npcs = false,
	reach = 2,
        damage = 2,         
	pathfinding = true,
	hp_min = 8,
	hp_max = 8,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3,0.5, 0.3},
	visual = "mesh",
	mesh = "marmot.glb",
	visual_size = {x=8, y=8},
	--rotate = 180,
	textures = {
		{"marmot.png"},

	},
	makes_footstep_sound = false,
	sounds = {
		--random = "",
		--death = "",
	},
	walk_velocity = 3,
	walk_chance = 15,
	run_velocity = 5,
	stand1_chance = 50,
	runaway = true,
	jump = true,
	jump_height = 2,
	stepheight = 1.1, 
	fall_damage = 1,
	drops = {--{name = "", chance = 1, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 20,
		walk_start = 24,
		walk_end = 44,
		run_start =24,
		run_end = 44,
		--stoodup_start = 48,
		--stoodup_end = 68,
		stand_start = 0,
		stand_end = 20,
		stand1_start = 48,
		stand1_end = 68,
		
		
	},
	follow = {"default:blueberries","mcl_lush_caves:glow_berry","x_farming:corn","crops:corn_cob"},
	view_range = 45,
	owner = "", 
	order = "follow",
	runaway = true ,
	
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	end,				
})

mobs:spawn({
	name = "pixel_animals:marmot",
	nodes = marmot_spawns,
	min_light = 8,
	--max_light = 14,
	chance = 12000,
	min_height = 0,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,	
})

mobs:register_egg("pixel_animals:marmot", "marmot", "marmot_egg.png", 0)

