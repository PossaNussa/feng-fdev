local climb_node = { "default:ladder_wood" ,"default:ladder_steel"}

local zombienods = {
"default:dirt", 
"default:dirt_with_rainforest",
"default:dirt_with_grass",
"default:dirt_with_dry_grass",
"default:dry_dirt_with_dry_grass",
"default:dirt_with_coniferous_litter",
"default:stone",
"default:ice", 
"default:snowblock",
"default:dirt_with_snow",
"default:desert_sand",
"default:desert_stone",
"default:desert_stone",
"default:ice",
"nodex:road",
"nodex:road2",
"nodex:road3",
} 


mobs:register_mob("runner:runner", {
	--nametag = "Runner Zombie" ,
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	--attack_animals = true,
	attack_npcs = false,
	group_attack = true,
	pathfinding = true,
	reach = 3,
	damage = 3,
	hp_min = 20,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.4, 0, -0.4, 0.4, 1.8, 0.4},
	visual = "mesh",
	mesh = "runner.b3d",
	--rotate = 180,
	textures = {
		{"runner.png"},
		--{""},
		
	},
	--glow = 4,
	--blood_texture = " ",
	makes_footstep_sound = true,
	sounds = {
	        random ="zombie_angry",
		--attack = "zombie_hit",
		death = "zombie_death ",
	},
	walk_velocity = 2,
	run_velocity = 8,
	jump_height = 2,
	stepheight = 1.1,
	floats = 0,
	view_range = 35,
	drops = {
		{name = "default:coal_lump", chance = 2, min = 1, max = 1},
		{name = "farming:bread 3", chance = 2, min = 1, max = 1},
		{name = "foodx:canned_tomato", chance = 4, min = 1, max = 1},
		
	},
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 80,
		walk_start = 100,
		walk_end = 180,
		run_start = 200,
		run_end = 240,
		punch_start = 200,
		punch_end = 240,
		die_start = 280,
		die_end = 300,
	},
	
	do_custom = function(self, dtime)
	
	
				local pos = self.object:get_pos() -- consegue sua propia posição

			
						for _,players in pairs(minetest.get_objects_inside_radius(pos,5)) do -- jogador em raio

						if players:is_player() then -- se for player

				   		 local door_pos = minetest.find_node_near(pos, 1, { -- portas
				   		 "doors:door_wood_a" ,
				   		 "doors:door_wood_b",
				   		 "doors:door_wood_c",
				   		 "doors:door_wood_d",
				   		 "default:glass",
				   		 "doors:door_glass_a",
				   		 "doors:door_glass_b",
				   		 "doors:door_glass_c",
				   		 "doors:door_glass_d",
						 "doors:pine_door_a",
						 "doors:pine_door_b",
						 "doors:pine_door_c",
						 "doors:pine_door_d",
						 "doors:aspen_doors_a",
						 "doors:aspen_doors_b",
						 "doors:aspen_doors_c",
						 "doors:aspen_doors_d",
						 "doors:acacia_door_a",
						 "doors:acacia_door_b",
						 "doors:acacia_door_c",
						 "doors:acacia_door_d",
						 "doors:jungle_door_a",
						 "doors:jungle_door_b",
						 "doors:jungle_door_c",
						 "doors:jungle_door_d"


				   		})

				   		local ladders = minetest.find_node_near(pos, 1, { -- escadas

				   		"default:ladder_wood",
				   		"default:ladder_steel"

				   		})

					    if door_pos ~= nil then
					    		
							    minetest.after(3, function() -- remover depois de 3 segundos
							        	minetest.remove_node(door_pos)

							   	 end)


					    elseif ladders ~= nil then 
			    
							        self.object:set_pos({x=pos.x, y=pos.y+0.1, z=pos.z}) 
							        self.object:set_velocity({x=0, y=-0.5, z=0})
							        mobs:set_animation(self, "run")

			        		else
				   
					    end

					end
			end
	end
})



mobs:spawn({
	name = "runner:runner",
	nodes = hunternods,
	min_light = 0,
	max_light = 7, -- 14
	chance = 100000,
	min_height = -20000,
	max_height = 200,
	--max_height = 200,
	active_object_count = 1,
})


mobs:register_egg("runner:runner", "Runner Zombie", "zombies_egg.png", 0)








