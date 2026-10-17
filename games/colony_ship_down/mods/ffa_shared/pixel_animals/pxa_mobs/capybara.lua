local capybara_spawns = {
"default:dirt_with_rainforest_litter",
"default:dirt_with_grass",
"mcl_mangrove:mangrove_mud_roots",
"default:mud"
}

mobs:register_mob("pixel_animals:capybara", {
	--nametag = "capybara",
	type = "animal",
	passive = true,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
        damage = 3,
	pathfinding = true,
	hp_min = 45,
	hp_max = 45,
	armor = 100,
	collisionbox = {-0.3, -0.4, -0.3, 0.3, 0.2, 0.3},
	visual = "mesh",
	mesh = "capivara.b3d",
	visual_size = {x=7, y=7},
	--rotate = 180,
	textures = {
		{"capybara.png"},

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
	drops = {
	  --{name = "", chance = 1, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 20,
		walk_start = 20,
		walk_end = 40,
		run_start = 50,
		run_end = 59,
		stoodup_start = 70,
		stoodup_end = 110,
		stand1_start = 120,
		stand1_end = 159,
		stand_start = 70,
		stand_end = 110,	
	},
	follow = {
		"default:apple",
		"mcl_core:apple",	
	},
	view_range = 45,
	owner = "",
	order = "",
	runaway = true ,
	
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
		---
		if self.owner and self.owner == clicker:get_player_name() then

			if self.order ~= "stand" then
				self.order = "stand"
				self.state = "stand"
				self.object:set_velocity({x = 0, y = 0, z = 0})
				mobs:set_animation(self, "stand")

			else
				self.order = "follow"
				mobs:set_animation(self, "walk")

			end
		end
	end,
})

mobs:spawn({
	name = "pixel_animals:capybara",
	nodes = capybara_spawns,
	neighbors = {"default:water_source", "default:river_water_source", "group:water"},
	min_light = 8,
	max_light = 14,
	chance = 35000,
	min_height = -2,
	max_height = 50,
	day_toggle = true,
	active_object_count = 4,
})

mobs:register_egg("pixel_animals:capybara", "Capybara", "capybaraegg.png", 0)
