pixel_animals.enable_hummingbird_spawn = core.settings:get_bool("enable_hummingbird_spawn", true)

mobs:register_mob("pixel_animals:hummingbird", {
	type = "monster",	
	attack_type = "dogfight",
	passive = true,
	attack_animals = false, 
	group_attack = true,	
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 16,
	hp_max = 16,
	armor = 100,
	collisionbox = {-0.2,-0,-0.2,0.2,0.5,0.2},
	visual = "mesh",
	mesh = "Hummingbird.glb",
	textures = {
		{"Hummingbird.png"},	
		{"Hummingbird_blue.png"},
		{"Hummingbird_violet.png"},	
	},
	visual_size = {x = 6, y = 6},
	sounds = {
		--random = "hummingbird_randon",
		--death = "",
	},
	fly = true , 
	fly_in = "air",
	walk_velocity = 2,
	run_velocity = 4,
	jump_height = 3,
	stepheight = 1.1,
	floats = 0,
	view_range = 15,
	replace_rate = 10,
	replace_what = { },		
	drops = {
	    --{name = "", chance = 3, min = 0, max = 1},		
	},
	follow = {"group:flora"},
	owner = "", 
	order = "follow",
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	animation = {
		speed_normal = 35,
		speed_fly = 35,		
		stand_start = 24,
		stand_end = 28,
		fly_start = 24,			
		fly_end = 28,
		walk_start = 24,
		walk_end = 28,
		run_start = 24,
		run_end = 28,
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

if pixel_animals.enable_hummingbird_spawn then
mobs:spawn({
	name = "pixel_animals:hummingbird",
	nodes = {"group:flora"},
	min_light = 14, 
	chance = 8000,
	min_height = 0,
	max_height = 2000,
})
end

mobs:register_egg("pixel_animals:hummingbird","Hummingbird", "hummingbird_egg.png", 0)

