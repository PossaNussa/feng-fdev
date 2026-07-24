-- sound : https://freesound.org/people/mrbubble110/sounds/70333/
core.register_craftitem("pixel_animals:antler", {
    description = "Moose Antler",
    inventory_image = "Antler.png"
})

core.register_node("pixel_animals:antler_mount", {
	description = "Antler Mount", 
	drawtype = "mesh",
	mesh = "Antler_Mount.obj",
	tiles = {"Antler_Mount.png"},
	use_texture_alpha = "clip",
	groups = {snappy = 3},
        _mcl_hardness = 1,
	paramtype = "light",
	paramtype2 = "facedir",
	drop = name,
	node_box= {
	  type = "fixed", 
	  fixed = {{-0.25, -0.25, 0.38, 0.25,0.25, 0.5}},
	 },	
	selection_box = {
	  type = "fixed", 
	  fixed = {{-0.25, -0.25, 0.38, 0.25,0.25, 0.5}},
	}			
})

core.register_craft({
    type = "shaped",
    output = "pixel_animals:antler_mount",
    recipe = {
        {"", "",""},
        {"pixel_animals:antler", "group:wood","pixel_animals:antler"},
        {"","",""}
    }
})

--- MOOSE :
mobs:register_mob("pixel_animals:moose", {
	--nametag = "bear",
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
	collisionbox = {-0.6, 0, -0.6, 0.6, 1.6, 0.6},
	visual = "mesh",
	visual_size = {x = 10, y = 10},
	mesh = "moose.glb",
	textures = {{"moose.png"}},
	makes_footstep_sound = false,
	sounds = {
		random = "bear_roar",
		--death = " ",
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
		{name = "mobs:meat_raw", chance = 2, min = 1, max = 1},
		{name = "pixel_animals:antler", chance = 5, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 5,
		speed_run = 5,
		stand_start = 1,
		stand_end = 20,
		walk_start = 22,
		walk_end = 42,
		run_start = 22,
		run_end = 42,		
		punch_start = 44, 
		punch_end = 67,
		punch_speed = 20, 
	},
	-- follow = { },
	view_range = 15, 	
})

mobs:spawn({
	name = "pixel_animals:moose",
	nodes = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
	neighbors = {"default:pine_tree", "default:pine_needles"},
	min_light = 6,
	max_light = 14,
	chance = 50000,
	min_height = 0,
	max_height = 120,
	active_object_count = 2,
	day_toggle = true,
})

mobs:register_egg("pixel_animals:moose", "Moose", "moose_egg.png", 0)
