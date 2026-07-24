local bear_spawns = { 
"default:dirt_with_coniferous_litter",
"mcl_core:podzol" ,
"rp_default:dirt_with_grass"
}

local bear_likes = {"mobs:honey","bees:honey_comb","x_farming:honeycomb","mcl_honey:honeycomb"}

mobs:register_mob("pixel_animals:bear", {
	type = "monster",
        damage = 5,
	attack_type = "dogfight",
	attack_animals = true,
	pathfinding = true, 
	reach = 3,
	passive = false,
	hp_min = 30,
	hp_max = 30,
	armor = 100,
	collisionbox = {-0.4, -0, -0.4, 0.6, 1.6, 0.6},
	visual = "mesh",
	visual_size = {x = 12, y = 12},
	mesh = "Grizzly_Bear.glb",
	textures = {
		{"Grizzly_Bear.png"},	
	},
	makes_footstep_sound = false,
	sounds = {
		random = "bear_roar",
		--death = " ",
	},
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 4,
	runaway = true,
	jump = true,
	jump_height = 3,
	stepheight = 2,
	fall_damage = 1,
	drops = {
		{name = "mobs:leather", chance = 2, min = 1, max = 1},
	},
	--follow = bear_likes,
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	animation = {
		speed_normal = 10,
		stoodup_speed = 5,
		--speed_run = 15,
		stand_start = 1,
		stand_end = 20,
		--stand1_start = 56,
		--stand1_end = 64,
		walk_start = 25,
		walk_end = 36,
		run_start = 25,
		run_end = 36,
		
		stoodup_start = 1,
		stoodup_end = 20,
		punch_start = 73, 
		punch_end =96,
		--punch_speed = 23, 
	},
	-- follow = { },
	view_range = 15, 
	
	on_spawn = function(self)
	   if not self.eating then
	      self.eating = false
	   end	
	end,

	on_rightclick = function(self, clicker)
	   local item_hand = clicker:get_wielded_item():get_name()
	   local inv = clicker:get_inventory()
	   
	   if self.eating then return end

	   for _, fd in pairs(bear_likes) do
	      if item_hand == fd then
		 inv:remove_item("main", fd)
		 self.eating = true	 
	         self.object:set_properties({textures = {"Grizzly_Bear_honey.png"}})
	         self.object:set_animation({x=56, y=64}, 10, 2, true) 
	      end
	   end

	   core.after(10, function()
	      self.eating = false
	      self.object:set_properties({textures = {"Grizzly_Bear.png"}})
	      mobs:set_animation(self, "walk")
	   end)
	end,	
})

mobs:spawn({
	name = "pixel_animals:bear",
	nodes = bear_spawns,
	neighbors = {"default:pine_tree", "default:pine_needles", "group:leaves"},
	min_light = 6,
	max_light = 14,
	chance = 45000,
	min_height = 0,
	max_height = 150,
	active_object_count = 2,
	day_toggle = true,
})

mobs:register_egg("pixel_animals:bear", "Bear", "bear_egg.png", 0)

