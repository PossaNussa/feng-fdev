local S = minetest.get_translator("hardcore_farming")
--[[minetest.log("test", "replace_rate:".. replace_rate)
minetest.log("test", "interval:".. interval)
minetest.log("test", "chance:".. chance)]]

mobs:register_mob("hardcore_farming:locust", {
stepheight = 3,
	type = "animal",
	passive = true,
        attack_type = "dogfight",
	attack_animals = false,
	reach = 2,
        damage = 0,
	hp_min = 1,
	hp_max = 4,
	armor = 20,
	collisionbox = {-0.1, -0.01, -0.1, 0.1, 0.2, 0.1},
	visual = "mesh",
	mesh = "Locust.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"texturelocust.png"},
	},
	sounds = {
		random = "animalworld_locust",
		distance = 16,
	},
	makes_footstep_sound = false,
	walk_velocity = 2,
       -- walk_chance = 15,
	run_velocity = 3,
	runaway = true,
        runaway_from = {"animalworld:bear", "animalworld:crocodile", "animalworld:tiger", "animalworld:spider", "animalworld:spidermale", "animalworld:shark", "animalworld:hyena", "animalworld:kobra", "animalworld:monitor", "animalworld:snowleopard", "animalworld:volverine", "livingfloatlands:deinotherium", "livingfloatlands:carnotaurus", "livingfloatlands:lycaenops", "livingfloatlands:smilodon", "livingfloatlands:tyrannosaurus", "livingfloatlands:velociraptor", "animalworld:divingbeetle", "animalworld:scorpion", "animalworld:polarbear", "animalworld:leopardseal", "animalworld:stellerseagle", "player", "animalworld:wolf", "animalworld:panda", "animalworld:stingray", "marinaramobs:jellyfish", "marinaramobs:octopus", "livingcavesmobs:biter", "livingcavesmobs:flesheatingbacteria"},
	jump = true,
        jump_height = 6,
	stepheight = 3,
	view_range = 35,
       --[[ stay_near = {{"group:crop","default:dry_grass_1", "default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4", "naturalbiomes:bushland_grass", "naturalbiomes:bushland_grass2", "naturalbiomes:bushland_grass3", 
"naturalbiomes:bushland_grass4"}, 4},  --"farming:wheat_8"]]
		stay_near = {{"group:crop"}, 4},  --"farming:wheat_8"
	replace_rate = hardcore_farming.replace_rate,
		replace_what = { 
			"group:crop",
			"dfarm:potato_4",
			"dfarm:carrot_4"},
				replace_with = "air",
	drops = {
		{name = "hardcore_farming:locust", chance = 1, min = 1, max = 1},
	
	},
	water_damage = 1,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 10,
	animation = {
		speed_normal = 100,
		stand_start = 0,
		stand_end = 100,
		stand2_start = 0,
		stand2_end = 1,
		walk_start = 100,
		walk_end = 200,
		fly_start = 250, -- swim animation
		fly_end = 350,
		die_start = 200,
		die_end = 300,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

fly_in = {"air"},
	floats = 0,
	follow = {"default:dry_shrub ", "default:grass_1", "ethereal:dry_shrub", "farming:seed_wheat", "farming:seed_rye", "default:junglegrass", "ethereal:banana_single", "farming:corn_cob", "farming:cabbage",
		"default:apple", "farming:cabbage", "farming:carrot", "farming:cucumber", "farming:grapes", "farming:pineapple", "ethereal:orange", "ethereal:coconut", "ethereal:coconut_slice", "group:grass", "group:normal_grass"},
	
view_range = 4,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 15, 25, 0, false, nil) then return end
	end,
})

if not mobs.custom_spawn_animalworld then
mobs:spawn({
	name = "hardcore_farming:locust",
	nodes = {"naturalbiomes:heath_grass", "naturalbiomes:heath_grass2", "naturalbiomes:heath_grass3", "naturalbiomes:heatherflower", "naturalbiomes:heatherflower2", "naturalbiomes:heatherflower3", "group:grass", "group:normal_grass", "naturalbiomes:med_flower2", "naturalbiomes:med_grass1", "naturalbiomes:med_grass2", "naturalbiomes:med_flower3", "naturalbiomes:bushland_grass4", "naturalbiomes:bushland_grass5", "naturalbiomes:bushland_grass6", "group:grass", "group:normal_grass"},
	min_light = 0,
	interval = hardcore_farming.interval,
	chance = hardcore_farming.chance, -- 15000
	active_object_count = 2,
	min_height = 0,
	max_height = 6000,
	day_toggle = true,
})
end

mobs:register_egg("hardcore_farming:locust", S("Locust"), "alocust.png")


minetest.register_craftitem(":hardcore_farming:locust_roasted", {
	description = S("Roasted Locust"),
	inventory_image = "animalworld_locust_roasted.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "hardcore_farming:locust_roasted",
	recipe = "hardcore_farming:locust",
	cooktime = 2,
})

