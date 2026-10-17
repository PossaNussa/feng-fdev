pixel_animals.enable_skunk_spawn = core.settings:get_bool("enable_skunk_spawn", true)

local skunk_spawns = {
"default:dirt_with_grass",
"mcl_core:dirt_with_grass",
"rp_default:dirt_with_grass"
}

mobs:register_mob("pixel_animals:skunk", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	reach = 2,
    damage = 2, 
    attack_chance = 50,
	pathfinding = true,
	hp_min = 16,
	hp_max = 16,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3,0.4, 0.3},
	visual = "mesh",
	mesh = "Skunk.b3d",
	visual_size = {x=8, y=8},
	textures = {
		{"Skunk.png"},

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
	--drops = {{name = "", chance = 1, min = 0, max = 1}},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 20,
		walk_start = 30,
		walk_end = 80,
		run_start =30,
		run_end = 80,
		--stoodup_start = 70,
		--stoodup_end = 110,
		--stand1_start = 120,
		--stand1_end = 159,
		stand_start = 1,
		stand_end = 20,
	},
	follow = {"default:blueberries","mcl_core:apple"},
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

if pixel_animals.enable_skunk_spawn then
mobs:spawn({
	name = "pixel_animals:skunk",
	nodes = skunk_spawns,
	biomes = {"BirchForest","BirchForestM","deciduous_forest","Forest"},
	min_light = 8,
	--max_light = 14,
	chance = 12000,
	min_height = 0,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,	
})
end

mobs:register_egg("pixel_animals:skunk", "Skunk", "skunk_egg.png", 0)

