pixel_animals.enable_seals_spawn = core.settings:get_bool("enable_seals_spawn", true)

mobs:register_mob("pixel_animals:seals", {
	--nametag = "seals",
	type = "animal",
	passive = true,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
        damage = 3,
	pathfinding = true,
	hp_min = 25,
	hp_max = 25,
	armor = 100,
	collisionbox = {-0.4, -0, -0.4, 0.4, 0.2, 0.4},
	visual = "mesh",
	mesh = "seals.b3d",
	visual_size = {x=7, y=7},
	textures = {
		{"seals.png"},

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
		stoodup_start = 1,
		stoodup_end = 20,
		stand1_start = 60,
		stand1_end = 70,
		stand_start = 1,
		stand_end = 20,	
		walk_start = 25,
		walk_end = 55,
		run_start = 25,
		run_end = 55,
	},
	follow = {
		"pixel_animals:catfish_raw",
	},
	view_range = 45,
	owner = "", 
	order = "follow",
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

if pixel_animals.enable_seals_spawn then
mobs:spawn({
	name = "pixel_animals:seals",
	nodes = {"default:snowblock", "default_ice", "mcl_core:ice", "mcl_core:snow"},
	neighbors = {"default:water_source", "mcl_core:water_source"},
	min_light = 8,
	--max_light = 14,
	chance = 1000,
	min_height = -2,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,	
})
end

mobs:register_egg("pixel_animals:seals", "Seals", "sealsegg.png", 0)
