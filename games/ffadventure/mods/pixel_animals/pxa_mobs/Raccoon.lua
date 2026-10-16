local raccoon_spawns = {
"default:dirt_with_grass",
--"mcl_core:grass_path",
"mcl_core:dirt_with_grass",
"mcl_mangrove:mangrove_mud_roots",
"rp_default:tall_grass"
}

mobs:register_mob("pixel_animals:raccoon", {
	--nametag = "capybara",
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	--owner_loyal = true,
	--attack_npcs = false,
	reach = 2,
        damage = 2, attack_chance = 98,
	pathfinding = true,
	hp_min = 16,
	hp_max = 16,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3, 0.45, 0.3},
	visual = "mesh",
	mesh = "Raccoon.b3d",
	--visual_size = {x=10, y=10},
	--rotate = 180,
	textures = {
		{"Raccoon.png"},

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
	drops = {--{name = "", chance = 1, min = 0, max = 1},
	},
	glow=0,
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 20,
		walk_start = 30,
		walk_end = 70,
		run_start = 30,
		run_end = 70,
		stand_start = 1,
		stand_end = 20
		-- pedindo : 80 - 120		
	},
	follow = {
		"default:apple",
		"mcl_core:apple",		
	},
	view_range = 35,
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
	name = "pixel_animals:raccoon",
	nodes = raccoon_spawns,
	neighbors = {
	"default:aspen_tree",
	"default:dirt_with_coniferous_litter",
	"default:dirt_with_snow",
	"mcl_trees:bark_birch",
	"mcl_core:podzol"},
	min_light = 8,
	--max_light = 14,
	chance = 12000,
	min_height = 0,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,	
})

mobs:register_egg("pixel_animals:raccoon", "Raccoon", "Raccoon_egg.png", 0)
