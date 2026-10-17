-- sound : https://freesound.org/people/JarredGibb/sounds/233123/
pixel_animals.enable_turkey_spawn = core.settings:get_bool("enable_turkey_spawn", true)

local turkey_spawns = {
"default:dirt_with_grass",
"mcl_core:dirt_with_grass",
"rp_default:dirt_with_grass"
}

mobs:register_mob("pixel_animals:turkey", {
	stepheight = 0.6,
	type = "animal",
	passive = false,
	hp_min = 10,
	hp_max = 10,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3, 0.5, 0.3},
	visual = "mesh",
	mesh = "Turkey.b3d",
	textures = {{"Turkey.png"}},
	child_texture = {
		{"Turkey.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "turkey_randon"
	},
	walk_velocity = 1,
	run_velocity = 3,
	runaway = true,
	runaway_from = {"player","pixel_animals:pumba"},
	drops = ostrich_drops,
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -4,
	fear_height = 5,
	view_range = 5,
	follow = {"farming:seed_wheat","mcl_farming:wheat_seeds","x_farming:seed_rice","crops:tomato_seed"},
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
})

if pixel_animals.enable_turkey_spawn then
mobs:spawn({
 name = "pixel_animals:turkey",
 nodes = turkey_spawns,
 biomes = {"BirchForest","BirchForestM","deciduous_forest","Forest"},
 min_light = 14,
 interval = 60,
 chance = 4000,
 active_object_count = 3,
 min_height = 5,
 max_height = 200,
 day_toggle = true
})
end

mobs:register_egg("pixel_animals:turkey","Turkey","Turkey_egg.png", 0)
