pixel_animals.enable_vulture_spawn = core.settings:get_bool("enable_vulture_spawn", true)

mobs:register_mob("pixel_animals:vulture", {
	type = "monster",
	specific_attack = {"mobs_animal:rat"},
	-- runaway_from = {" "},
	attack_type = "dogfight",
	passive = false,
	attack_animals = false, 
	group_attack = true,	
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 16,
	hp_max = 16,
	armor = 100,
	collisionbox = {-0.3,-0,-0.3,0.3,0.5,0.3},
	visual = "mesh",
	mesh = "vulture.glb",
	textures = {
		{"vulture.png"},		
	},
	visual_size = {x = 6, y = 6},
	sounds = {
		random = "vulture_randon",
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
	replace_what = { },		
	drops = feather_drops,
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	animation = {
		speed_normal = 10,
		speed_fly = 15,		
		stand_start = 22,
		stand_end = 33,
		fly_start = 22,			
		fly_end = 33,
		walk_start = 22,
		walk_end = 33,
		run_start = 22,
		run_end = 33,
		punch_start = 22,
		punch_end = 33,
	},	
})

if pixel_animals.enable_vulture_spawn then
mobs:spawn({
	name = "pixel_animals:vulture",
	nodes = {"bakedclay:orange","mcl_colorblocks:hardened_clay"},
	min_light = 14, 
	chance = 14000,
	min_height = 20,
	max_height = 200,
})
end

mobs:register_egg("pixel_animals:vulture", "Vulture", "vulture_egg.png", 0)

