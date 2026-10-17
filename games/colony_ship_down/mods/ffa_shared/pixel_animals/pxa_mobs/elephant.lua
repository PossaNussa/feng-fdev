pixel_animals.enable_elephant_spawn = core.settings:get_bool("enable_elephant_spawn", true)

mobs:register_mob("pixel_animals:elephant", {
	--nametag = "elephant",
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	attack_npcs = false,
	--group_attack = true,
	reach = 3,
        damage = 3, attack_chance = 100,
	pathfinding = true,
	hp_min = 50,
	hp_max = 50,
	armor = 100,
	visual = "mesh",
	mesh = "elephant.b3d",
	textures = {{"elephant.png"}},
	--visual_size = {x = 12, y = 12},
	collisionbox = {-1.5, -0, -1.5, 1.5, 4.3, 1.5},
	makes_footstep_sound = false,
	sounds = {
		--random = "",
		--death = "",
	},
	walk_velocity = 2,
	walk_chance = 15,
	run_velocity = 5,
	stand1_chance = 50,
	runaway = true,
	jump = true,
	jump_height = 1,
	stepheight = 1.1, 
	fall_damage = 1,
	drops = {{name = "mobs:meat_raw", chance = 1, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 5,
	fear_height = 3,
	stand1_chance = 50,
	animation = {
		speed_normal = 15,
		stand_start = 1,
		stand_end = 40,
		walk_start = 50,
		walk_end = 90,
		run_start = 100,
		run_end = 120	
	},
	follow = {"pixel_farming:melon_slice","x_farming:melon","farming:melon_slice","mcl_farming:melon_item"},
	view_range = 15,
	owner = "", 
	order = "follow",
	runaway = true ,
	
	on_rightclick = function(self, clicker)
	if mobs:feed_tame(self, clicker, 12, true, true) then return end
	if mobs:protect(self, clicker) then return end
	if mobs:capture_mob(self, clicker, 30, 50, 80, false, nil) then return end
	
	local item_hand = clicker:get_wielded_item():get_name()
	
	if self.tamed and self.owner == clicker:get_player_name() and item_hand ~= "" then
		if not clicker or not clicker:is_player() then return end
		----	
		if self.driver and clicker == self.driver then
			clicker:set_detach()
			clicker:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
			self.driver = nil
		elseif not self.driver then
			clicker:set_attach(self.object,"",{x=0,y=45,z=-2},{x=0,y=0,z=0}) -- anexar
			clicker:set_eye_offset({x=0,y=46,z=0},{x=0,y=46,z=0})
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

if pixel_animals.enable_elephant_spawn then
mobs:spawn({
	name = "pixel_animals:elephant",
	nodes = {"default:dry_dirt_with_dry_grass","mcl_core:dirt_with_grass"},
	min_light = 8,
	--max_light = 14,
	chance = 8000,
	biomes = {"savanna","Savanna"},
	min_height = 0,
	max_height = 200,
	day_toggle = true,
	active_object_count = 3,	
})
end

mobs:register_egg("pixel_animals:elephant","Elephant","elephant_egg.png", 0)
