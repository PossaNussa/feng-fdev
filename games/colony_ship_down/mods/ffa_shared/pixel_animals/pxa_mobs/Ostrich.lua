pixel_animals.enable_ostrich_spawn = core.settings:get_bool("enable_ostrich_spawn", true)

ostrich_drops = {}

if core.get_modpath("mcl_mobitems")then
      ostrich_drops = {
		{name = "mcl_mobitems:feather", chance = 2, min = 1, max = 1},
		{name = "mobs:chicken_raw", chance = 1, min = 0, max = 1}
	}
   else
	  ostrich_drops = {
		{name = "mobs:chicken_feather", chance = 2, min = 1, max = 1},
		{name = "mobs:chicken_raw", chance = 1, min = 0, max = 1}
	}
end

mobs:register_mob("pixel_animals:ostrich", {
	--nametag = "Ostrich",
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	--group_attack = true,
	reach = 2,
    damage = 3, 
	attack_chance = 50,
	pathfinding = true,
	hp_min = 25,
	hp_max = 25,
	armor = 100,
	collisionbox = {-0.3, -0.4, -0.3, 0.3, 0.5, 0.3},
	visual = "mesh",
	mesh = "Ostrich.b3d",
	textures = {{"Ostrich.png"}},
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
	drops = ostrich_drops,
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 19,
		stand1_start = 65,
		stand1_end = 74,
		walk_start = 25,
		walk_end = 44,
		--run_start = 50,
		--run_end = 59
		--stoodup_start = 70,	
		--stoodup_end = 110,	
	},
	follow = {"farming:seed_wheat","mcl_farming:wheat_seeds","x_farming:seed_potato","crops:corn"},
	view_range = 15,
	owner = "", 
	order = "follow",
	runaway = true ,
	
	on_rightclick = function(self, clicker)
	if mobs:feed_tame(self, clicker, 8, true, true) then return end
	if mobs:protect(self, clicker) then return end
	if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	
	local item_hand = clicker:get_wielded_item():get_name()
	
	if self.tamed and self.owner == clicker:get_player_name() and item_hand ~= "" then
		if not clicker or not clicker:is_player() then return end
		----	
		if self.driver and clicker == self.driver then
			clicker:set_detach()
			--clicker:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
			self.driver = nil
		elseif not self.driver then
			clicker:set_attach(self.object,"",{x=0,y=9,z=-2},{x=0,y=0,z=0}) -- anexar
			--clicker:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
			self.driver = clicker
		end
		----	
	end
       end,
	
	do_custom = function(self, dtime)
	if self.driver then
		local vel = 5
		local dir = self.driver:get_look_dir()
		local ctrl = self.driver:get_player_control()
		local pos = self.object:get_pos()
		local node = core.get_node({x=pos.x, y=pos.y-0.7, z=pos.z})
		local def = core.registered_nodes[node.name]
		

		self:set_animation("walk")
		self.object:set_velocity({x = dir.x * vel,y = self.object:get_velocity().y,z = dir.z * vel})
		self.object:set_yaw(math.atan2(dir.z, dir.x) - math.pi/2)
		self.driver:set_animation({x = 81, y = 160}, 30, 0)

		if ctrl.jump and def and def.walkable then
		  self.object:set_velocity({x = self.object:get_velocity().x,y = 5,z = self.object:get_velocity().z})
		end

		if self.state == "attack" then
			self.state = nil
		end
		return false
	end
    end

	    
})

if pixel_animals.enable_ostrich_spawn then
mobs:spawn({
	name = "pixel_animals:ostrich",
	nodes = {"default:dry_dirt_with_dry_grass","mcl_core:dirt_with_grass"},
	biomes = {"savanna","Savanna"},
	min_light = 8,
	--max_light = 14,
	chance = 8000,
	min_height = 0,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,
	
})
end

mobs:register_egg("pixel_animals:ostrich","Ostrich","Ostrich_egg.png", 0)
