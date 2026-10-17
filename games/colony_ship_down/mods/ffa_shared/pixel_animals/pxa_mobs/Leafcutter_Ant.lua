core.register_node("pixel_animals:leafcutter_anthill", {
	description = "Leafcutter Anthill",
	tiles = {"Leafcutter_Anthill.png"},
	groups = {crumbly = 3},
	_mcl_hardness = 1,
        drop = " ",
        after_dig_node = function(pos)
	  for i = 1,3 do
	     pos.y = pos.y + 0.5
	     minetest.add_entity(pos, "pixel_animals:leafcutter_ant")
	  end
	end,
})

core.register_node("pixel_animals:leafcutter_anthill_2", {
	description = "Leafcutter Anthill 2",
	tiles = {"Leafcutter_Anthill_clear.png"},
	groups = {crumbly = 3},
	drop = " ",
})

mobs:register_mob("pixel_animals:leafcutter_ant", {
	--nametag = "Leafcutter_Ant",
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
        damage = 1,
	pathfinding = true,
	hp_min = 8,
	hp_max = 8,
	armor = 150,
	collisionbox = {-0.3, -0, -0.3, 0.3, 0.5, 0.3},
	visual = "mesh",
	mesh = "Leafcutter_An.glb",
	textures = {"Leafcutter_Ant.png"},
	visual_size = {x = 4.5, y = 4.5},
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
	drops = {{name = "pixel_animals:leafcutter_ant", chance = 1, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 1,
		stand1_start = 1,
		stand1_end = 1,
		walk_start = 1,
		walk_end = 1,	
	},
	
	follow = {--" ",	
	},
	
	view_range = 10,	
})

mobs:spawn({
	name = "pixel_animals:leafcutter_ant",
	nodes = {"pixel_animals:leafcutter_anthill","pixel_animals:leafcutter_anthill_2"},
	min_light = 8,
	--max_light = 14,
	chance = 500,
	min_height = 0,
	max_height = 200,
	--day_toggle = true,
	--active_object_count = 3,
	
})

mobs:register_egg("pixel_animals:leafcutter_ant","Leafcutter_Ant","Leafcutter_Ant_egg.png", 0)

core.register_decoration({ 
    name = "pixel_animals:leafcutter_anthill_dec",
    deco_type = "schematic",
    place_on = { "mcl_core:dirt_with_grass", "default:dry_dirt_with_dry_grass"},
    biomes = {"savanna","SavannaM"},
    sidelen = 16,
    fill_ratio = 0.0005,
    y_max = 5,
    y_min = 1,
    schematic = minetest.get_modpath("pixel_animals") .. "/schematics/spawn_ant.mts",
    place_offset_y = 1,
    flags = "place_center_x,place_center_z,all_floors",
    rotation = "random",
})
