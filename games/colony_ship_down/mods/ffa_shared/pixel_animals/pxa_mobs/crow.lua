-- SOUND: https://freesound.org/people/straget/sounds/404687/
pixel_animals.enable_crow_spawn = core.settings:get_bool("enable_crow_spawn", true)

local crow_neighbors = { 
"farming:wheat_8",
"rp_farming:wheat",
"rp_farming:potato",
"rp_farming:carrot",
"mcl_farming:wheat",
"mcl_farming:carrot",
"mcl_farming:potato"
 }

feather_drops = {}

if core.get_modpath("mcl_mobitems")then
      feather_drops = {{name = "mcl_mobitems:feather", chance = 2, min = 1, max = 1}}
   else
	  feather_drops = {{name = "mobs:chicken_feather", chance = 2, min = 1, max = 1}}
end

mobs:register_mob("pixel_animals:crow", {
	type = "animal",
	specific_attack = {"mobs_animal:rat"},
	-- runaway_from = {"dfarm:scarecrow"},
	passive = false,
	attack_type = "dogfight",
	attack_animals = true, 
	group_attack = true,
	owner_loyal = true,
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 8,
	hp_max = 8,
	armor = 100,
	collisionbox = {-0.1,-0.15,-0.1,0.1,0.12,0.1},
	selectionbox = {-0.1,-0.15,-0.1,0.1,0.12,0.1},
	visual = "mesh",
	mesh = "Crow.b3d",
	rotate = 180,
	textures = {
		{"Crow.png"},
	},
	sounds = {
		random = "crow",
		--death = "",
	},
	fly = true , 
	fly_in = "air",
	walk_velocity = 2,
	run_velocity = 4,
	jump_height = 3,
	stepheight = 1.1,
	floats = 0,
	view_range = 35,
	replace_rate = 10,
	replace_what = {
		{"farming:wheat_8", "air",-2},
		{"mcl_farming:wheat","air",-2},
		{"rp_farming:wheat", "air",-2},
	},	
	drops = feather_drops,
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	animation = {
		speed_normal = 40,
		stand_start = 0,
		stand_end = 19,
		fly_start = 0,			
		fly_end = 19,
		walk_start = 0,
		walk_end = 19,
		run_start = 0,
		run_end = 19,
		--punch_start = 0,
		--punch_end = 0,
		},
	
	follow = {
		--"farming:seed_wheat", 	 	
	},
})

if pixel_animals.enable_crow_spawn then
mobs:spawn({
	name = "pixel_animals:crow",
	nodes = "air",
	neighbors = crow_neighbors,
	min_light = 14, 
	chance = 8000,
	active_object_count = 5,
	min_height = 0,
	max_height = 200,
})
end

mobs:register_egg("pixel_animals:crow", "Crow", "crow_egg.png", 0)

