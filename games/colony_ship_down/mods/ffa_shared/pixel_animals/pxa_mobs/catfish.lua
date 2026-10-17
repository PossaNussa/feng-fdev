local fly_w = {
"default:water_source",
"default:river_water_source",
"rp_default:water_source",
"mcl_core:water_source",
}

core.register_craftitem("pixel_animals:catfish_raw", {
	description = "Catfish Raw",
	inventory_image = "catfish_raw.png",
	on_use = minetest.item_eat(1),
})

core.register_craftitem("pixel_animals:catfish_cooked", {
	description = "Catfish Cooked",
	inventory_image = "catfish_cooked.png",
	on_use = minetest.item_eat(7),
})

mobs:register_mob("pixel_animals:catfish", {
	type = "animal",
	passive = true,
	runaway_from = {"player"},
	pathfinding = true,
	-- reach = 0,
	-- damage = 0,
	hp_min = 5,
	hp_max = 5,
	armor = 100,
	collisionbox = {-0.3, -0.1, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	mesh = "catfish.b3d",
	rotate = 180,
	textures = {
		{"catfish.png"},
		
	},
	makes_footstep_sound = false,
	sounds = {
		--random = " ",
		--death = " ",
	},
	fly = true , 
	fly_in = fly_w,
	walk_velocity = 2,
	run_velocity = 4,
	jump_height = 0,
	stepheight = 0.0,
	fall_speed = 0,
	-- floats = 0,
	view_range = 10,	
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
	animation = {
		speed_normal = 20,
		stand_start = 0,
		stand_end = 40,
		fly_start = 50,			
		fly_end = 89,
		walk_start = 50,
		walk_end = 89,
		run_start = 100,
		run_end = 140,
		--punch_start = 0,
		--punch_end = 0,
	},

	on_rightclick = function(self, clicker)
	  mobs:capture_mob(self, clicker, 50, 90, 0, true,"pixel_animals:catfish")
	end,
	
	on_flop = function(self)
	 	self.object:set_acceleration({
			x = math.random(-0.1, 0.1),
			y = -10,
			z = math.random(-0.1, 0.1)
		})

		self.object:set_velocity({x = 0, y = -10, z = 0})
	   return true
	end,
	
	on_die = function(self, pos) 
	   if minetest.get_modpath("x_farming") then
	       core.add_item(pos, "x_farming:catfish")
              else 
               core.add_item(pos, "pixel_animals:catfish_raw")             
           end
	end
})

mobs:spawn({
	name = "pixel_animals:catfish",
	nodes = fly_w,
	max_light = 7, 
	chance = 14000,
	active_object_count = 3,
	max_height = 2,
})

mobs:register_egg("pixel_animals:catfish", "catfish", "catfish_egg.png", 1)

