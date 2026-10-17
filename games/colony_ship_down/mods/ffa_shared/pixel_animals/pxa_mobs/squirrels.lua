-- sound : https://freesound.org/people/JarredGibb/sounds/233123/
local squirrels_spawns = {
"default:pine_needles",
"mcl_trees:leaves",
"rp_default:leaves"
}

pixel_animals.enable_squirrels_spawn = core.settings:get_bool("enable_squirrels_spawn", true)

mobs:register_mob("pixel_animals:squirrels", {
	stepheight = 0.6,
	type = "animal",
	passive = false,
	hp_min = 15,
	hp_max = 15,
	armor = 100,
	collisionbox = {-0.3, -0, -0.3, 0.3, 0.5, 0.3},
	visual = "mesh",
	mesh = "squirrels.b3d",
	textures = {{"squirrels.png"}},
	visual_size = {x=7, y=7},
	child_texture = {
		{"squirrels.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "squirrels_randon"
	},
	walk_velocity = 2,
	run_velocity = 4,
	--runaway = true,
	--runaway_from = {"player","pixel_animals:pumba"},
	drops = {
		--{name = "", chance = 1, min = 1, max = 1},
		--{name = "", chance = 1, min = 0, max = 2}
	},
	jump = true,
	jump_height = 2,
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -4,
	fear_height = 5,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 20,
		walk_start = 30,
		walk_end = 70,
		walk_speed = 25,
		run_start = 80,
		run_end = 120,
		run_speed = 25,
		eat_start = 130,
		eat_end  = 170,
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

if pixel_animals.enable_squirrels_spawn then
mobs:spawn({
 name = "pixel_animals:squirrels",
 nodes = squirrels_spawns,
 biomes = {"coniferous_forest","Taiga","MegaTaiga","Oak Forest"},
 min_light = 14,
 interval = 60,
 chance = 1000,
 active_object_count = 2,
 min_height = 5,
 max_height = 200,
 day_toggle = true
})
end

mobs:register_egg("pixel_animals:squirrels","Squirrels","squirrels_egg.png", 0)
