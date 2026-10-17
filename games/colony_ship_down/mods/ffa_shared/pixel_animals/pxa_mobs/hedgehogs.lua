local hedgehogs_spawns = { 
"default:dirt_with_coniferous_litter",
"mcl_core:podzol" ,
"rp_default:dirt_with_grass"
}

pixel_animals.enable_hedgehogs_spawn = core.settings:get_bool("enable_hedgehogs_spawn", true)

mobs:register_mob("pixel_animals:hedgehogs", {
	--nametag = "hedgehogs",
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
    damage = 1,
	pathfinding = true,
	hp_min = 8,
	hp_max = 8,
	armor = 100,
	collisionbox = {-0.4, -0, -0.4, 0.4, 0.5, 0.4},
	visual = "mesh",
	mesh = "hedgehogs.b3d",
	textures = {"hedgehogs.png"},
	visual_size = {x = 10, y = 10},
	makes_footstep_sound = false,
	sounds = {
		--random = "",
		--death = "",
	},
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 3,
	stand1_chance = 50,
	runaway = true,
	jump = true,
	jump_height = 1,
	stepheight = 1.1, 
	fall_damage = 1,
	--drops = {{name = "pixel_animals:hedgehogs", chance = 1, min = 0, max = 1},
    follow = {
		"pixel_farming:carrot",
		"farming:carrot",
		"x_farming:carrot",
		"mcl_farming:carrot_item"	
	},
	
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 20,
		--stand1_start = 1,
		--stand1_end = 1,
		walk_start = 25,
		walk_end = 55,	
	},	
	view_range = 10,	
})

if pixel_animals.enable_hedgehogs_spawn then
mobs:spawn({
	name = "pixel_animals:hedgehogs",
	nodes = hedgehogs_spawns,
	min_light = 8,
	chance = 500,
	biomes = {"coniferous_forest","Taiga","MegaTaiga"},
	min_height = 0,
	max_height = 200,
})
end

mobs:register_egg("pixel_animals:hedgehogs","Hedgehogs","hedgehogs_egg.png", 0)

