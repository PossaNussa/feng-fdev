pixel_animals.enable_bear_spawn = core.settings:get_bool("enable_bear_spawn", true)

local bear_spawns = { 
"default:dirt_with_coniferous_litter",
"mcl_core:podzol" ,
"rp_default:dirt_with_grass"
}

local bear_likes = {"mobs:honey","bees:honey_comb","x_farming:honeycomb","mcl_honey:honeycomb"}

local bear_drops = {}

if core.get_modpath("mcl_mobitems")then
      bear_drops = {name = "mcl_mobitems:leather", chance = 2, min = 1, max = 1}
   else
	  bear_drops = {name = "mobs:leather", chance = 2, min = 1, max = 1}
end

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
	drops = bear_drops,
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
		eating_speed = 10,
		eating_start = 56,
		eating_end =  64
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
	         self:set_animation("eating", true)
	      end
	   end

	   core.after(10, function()
	      self.eating = false
	      self.object:set_properties({textures = {"Grizzly_Bear.png"}})
	      self:set_animation("walk", true)
	   end)
	end,	
})

if pixel_animals.enable_bear_spawn then
mobs:spawn({
	name = "pixel_animals:bear",
	nodes = bear_spawns,
	min_light = 8,
	--max_light = 14,
	chance = 8000,
	biomes = {"coniferous_forest","Taiga","MegaTaiga","Oak Forest"},
	min_height = 0,
	max_height = 200,
	
})
end

mobs:register_egg("pixel_animals:bear", "Bear", "bear_egg.png", 0)

