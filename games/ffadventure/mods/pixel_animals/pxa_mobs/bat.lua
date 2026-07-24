-- SOUND: https://freesound.org/people/Breviceps/sounds/445958/
local timer = 0

mobs:register_mob("pixel_animals:bat", {
	type = "animal",
	passive = true,
	attack_type = "dogfight",
	attacks_monsters = true,
	attack_npcs = false, 
	owner_loyal = true,
	group_attack = true,
	pathfinding = true,
	reach = 1,
	damage = 2,
	hp_min = 30,
	hp_max = 30,
	armor = 100,
	collisionbox = {-0.08,0.05,-0.08,0.08,0.5,0.08},
	selectionbox = {-0.08,0.05,-0.08,0.08,0.5,0.08},
	visual = "mesh",
	mesh = "bat_sleeping.b3d",
	rotate = 180,
	textures = {
		{"bat.png"},
	},
	sounds = {
		random = "bat",
		--death = "",
	},
	fly = true , 
	fly_in = "air",
	walk_velocity = 3,
	run_velocity = 5,
	jump_height = 3,
	stepheight = 1.1,
	floats = 0,
	view_range = 35,
	owner = "", 
	order = "follow",
	--drops = {
		--{name = " ", chance = 3, min = 0, max = 1},
	--},
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	animation = {
		speed_normal = 45,
		stand_start = 0,
		stand_end = 9,
		fly_start = 0,			
		fly_end = 9,
		walk_start = 0,
		walk_end = 9,
		run_start = 0,
		run_end = 9,
	},
	
	follow = {
		"default:blueberries", 	 	
	},
	
	do_custom = function(self, dtime)
        self.timer = self.timer + dtime
        if self.timer >= 0.5 then
        
	local pos_above = vector.add(self.object:get_pos(), {x = 0, y = 1.1, z = 0})
	local pos_under = vector.add(self.object:get_pos(), {x = 0, y = -0.5, z = 0})
        local node_above = minetest.get_node_or_nil(pos_above)
        local node_under = minetest.get_node_or_nil(pos_under)
        local pos = self.object:get_pos()
      
	if (node_above and node_above.name ~= "air") and (node_under and node_under.name == "air") then

       		local time_of_day = minetest.get_timeofday()
					
		     if time_of_day >= 0.25 and time_of_day < 0.75 then 
			self.state = "sleep"
				             	
			minetest.after(0.2, function()
			 pos.y =  pos.y -  0.1
                         self.object:set_pos(pos)
			 self.object:set_animation({x=20, y=40},15, 1, false)
			 self.object:set_acceleration({x = 0, y = 0, z = 0})
			 self.object:set_velocity({x = 0, y = 0, z = 0})
			 self.object:set_properties({selectionbox = {-0.08,0.6,-0.08,0.08,1,0.08}})          
			 end)

		            else
			  self.state = "walk"				
			  minetest.after(0.1, function()
			   mobs:set_animation(self, "walk")
			   self.object:set_properties({selectionbox = {-0.08,0.05,-0.08,0.08,0.5,0.08}})
			  end)
			 end
		        end
   		
   	 	self.timer = 0
        end 
     end,
})

--========================= SPAWN ==============================================
mobs:spawn({
	name = "pixel_animals:bat",
	nodes = {"air"},
	neighbors = {"group:stone", "group:cracky", "default:stone"},
	min_light = 0,
	max_light = 7,
	chance = 70000,
	active_object_count = 4,
	min_height = -100,
	max_height = 50,
})

mobs:register_egg("pixel_animals:bat", "Bat", "bat_egg.png", 0)

