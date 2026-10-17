pixel_animals.enable_seagull_spawn = core.settings:get_bool("enable_seagull_spawn", true)

mobs:register_mob("pixel_animals:seagull", {
	type = "monster",
	specific_attack = {"pixel_animals:catfish"},
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
	mesh = "Seagull.glb",
	textures = {
		{"Seagull.png"},		
	},
	visual_size = {x = 6, y = 6},
	sounds = {
		--random = "seagull_randon",
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
		stand_start = 48,
		stand_end = 68,
		fly_start = 48,			
		fly_end = 68,
		walk_start = 48,
		walk_end = 48,
		run_start = 48,
		run_end = 48,
		punch_start = 48,
		punch_end = 68,
	},	
})

if pixel_animals.enable_seagull_spawn  then
mobs:spawn({
	name = "pixel_animals:seagull",
	nodes = {"default:sand","mcl_core:sand","rp_default:sand"},
	neighbors = {"default:water_source","mcl_core:water_source","rp_default:water_source"},
	min_light = 14, 
	chance = 8000,
	--active_object_count = 5,
	min_height = 0,
	max_height = 20,
})
end

mobs:register_egg("pixel_animals:seagull","Seagull", "seagull_egg.png", 0)

