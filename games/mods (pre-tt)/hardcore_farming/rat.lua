local S = minetest.get_translator("hardcore_farming")
mobs:register_mob("hardcore_farming:rat", {
	type = "animal",
	stepheight = 3,
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	group_attack = true,
	reach = 2,
	damage = 3,
	hp_min = 2,
	hp_max = 5,
	armor = 100,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 0.6, 0.4},
	visual = "mesh",
	mesh = "Rat.b3d",
	textures = {
		{"texturerat.png"},
		{"texturerat.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "animalworld_rat",
		attack = "animalworld_rat",
	},
	walk_velocity = 2,
	run_velocity = 3,
	runaway = true,
	runaway_from = {"animalworld:bear"},
	jump = true,
	jump_height = 6,
	pushable = true,
	view_range = 35,
	      --[[  stay_near = {{"group:crop","default:dry_grass_1", "default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4", "naturalbiomes:bushland_grass", "naturalbiomes:bushland_grass2", "naturalbiomes:bushland_grass3", 
"naturalbiomes:bushland_grass4"}, 4},]]
		stay_near = {{"group:crop"}, 4},
	replace_rate = hardcore_farming.replace_rate,
		replace_what = { 
			"group:crop",
			"dfarm:potato_4",
			"dfarm:carrot_4"},
				replace_with = "air",
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},

	},
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	fear_height = 6,
	animation = {
		stand_start = 0,
		stand_end = 100,
		stand_speed = 50,
		walk_start = 100,
		walk_end = 200,
		walk_speed = 130,
		punch_start = 250,
		punch_end = 350,
		punch_speed = 125,
		die_start = 200,
		die_end = 300,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},
	follow = {"farming:wheat", "farming:beans", "farming:barley", "farming:oat", "farming:rye", "mobs:cheese", "farming:bread", "ethereal:banana_bread", "animalworld:cockroach", "farming:baked_potato", "farming:sunflower_bread", "farming:pumpkin_bread", "farming:garlic_bread", "farming:tomato_soup", "pie:brpd_0", "farming:bread", "farming:bread_multigrain", "farming:spanish_potatoes", "farming:beetroot_soup", "farming:blueberry_pie", "farming:porridge", "farming:bibimbap", "farming:burger", "farming:paella", "farming:mac_and_cheese", "livingcaves:healingsoup", "farming:spaghetti", "animalworld:escargots", "farming:rhubarb_pie", "farming:potato_omlet", "farming:potato_salad", "farming:corn_cob", "farming:seed_hemp", "farming:seed_barley", "farming:seed_oat", "farming:seed_cotton", "farming:seed_sunflower", "farming:seed_wheat", "farming:seed_rye", "naturalbiomes:coconut", "naturalbiomes:coconut_slice", "naturalbiomes:hazelnut", "naturalbiomes:hazelnut_cracked", "farming:sunflower_seeds_toasted", "livingfloatlands:roasted_pine_nuts", "livingfloatlands:giantforest_oaknut", "livingfloatlands:giantforest_oaknut_cracked", "livingfloatlands:coldsteppe_pine3_pinecone", "livingfloatlands:coldsteppe_pine_pinecone", "livingfloatlands:coldsteppe_pine2_pinecone"},
	view_range = 10,

})

if minetest.get_modpath("ethereal") then
	spawn_on = {"default:stone", "default:mossycobble", "ethereal:dry_dirt"}
end

if not mobs.custom_spawn_animalworld then
mobs:spawn({
	name = "hardcore_farming:rat",
	--nodes =  { "group:crop"},
	nodes =  { "default:dirt_with_grass", "default:dirt_with_coniferous_litter", "default:dirt_with_rainforest_litter", "default:dirt", "variety:meadow_dirt_with_grass", "variety:meadow_grass", "default:grass"},
	min_light = 0,
	interval = hardcore_farming.interval,
	chance = hardcore_farming.chance, -- 15000
	active_object_count = 2,
	min_height = 0,
	max_height = 6000,

})
end


mobs:register_egg("hardcore_farming:rat", S("Rat"), "arat.png")


mobs:alias_mob("hardcore_farming:rat", "hardcore_farming:rat") -- compatibility

-- cooked rat, yummy!
minetest.register_craftitem(":hardcore_farming:rat_cooked", {
	description = S("Cooked Rodent Meat"),
	inventory_image = "animalworld_cooked_rat.png",
	on_use = minetest.item_eat(3),
	groups = {food_rat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "hardcore_farming:rat_cooked",
	recipe = "hardcore_farming:rat",
	cooktime = 5,
})


