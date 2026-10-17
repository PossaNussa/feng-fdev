-- sound : https://freesound.org/people/JarredGibb/sounds/233123/
local snail_spawns = {
"default:dirt_with_grass",
"mcl_core:dirt_with_grass",
"rp_default:dirt_with_grass"
}

mobs:register_mob("pixel_animals:snail", {
	stepheight = 0.6,
	type = "animal",
	passive = false,
	hp_min = 10,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3, 0.5, 0.3},
	visual = "mesh",
	mesh = "snail.b3d",
	textures = {{"snail.png"}},
	visual_size = {x=7, y=7},
	child_texture = {
		{"snail.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "snail_randon"
	},
	walk_velocity = 1,
	run_velocity = 3,
	--runaway = true,
	--runaway_from = {"player","pixel_animals:pumba"},
	drops = {
		--{name = " ", chance = 1, min = 1, max = 1},
		--{name = " r", chance = 1, min = 0, max = 2}
	},
	jump = true,
	jump_height = 1,
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -4,
	fear_height = 5,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 29,
		stand_speed = 28,
		stand1_start = 31,
		stand1_end = 69,
		stand1_speed = 32,
		walk_start = 71,
		walk_end = 89,
		walk_speed = 24,
		run_start = 91,
		run_end = 109,
		run_speed = 24,
	},
	--follow = {"farming:seed_wheat","mcl_farming:wheat_seeds","x_farming:seed_rice","crops:tomato_seed"},
	view_range = 5,
        --[[
	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 16, true, true) then return end
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
	]]	
})

mobs:spawn({
 name = "pixel_animals:snail",
 nodes = snail_spawns,
 biomes = {"BirchForest","BirchForestM","deciduous_forest","Forest"},
 min_light = 14,
 interval = 60,
 chance = 1000,
 active_object_count = 3,
 min_height = 5,
 max_height = 200,
 day_toggle = true
})

mobs:register_egg("pixel_animals:snail","snail","snail_egg.png", 0)
