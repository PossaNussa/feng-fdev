local fly_w = {
"default:water_source",
"default:river_water_source",
"rp_default:water_source",
"mcl_core:water_source",
}

-- Gelatin:
minetest.register_craftitem("pixel_animals:gelatin", {
	description = "Gelatin",
	inventory_image = "gelatin.png"
})

minetest.register_node("pixel_animals:gelatin_Block", {
	description = "Gelatin Block",
	tiles = {"gelatin_block.png"},
	drawtype = "glasslike_framed_optional",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	use_texture_alpha = "blend",
	groups ={dig_immediate=3,fall_damage_add_percent = -80,bouncy = 100},
        --sounds = 
})

minetest.register_craft({
    type = "shaped",
    output = "pixel_animals:gelatin_Block",
    recipe = {
        {"pixel_animals:gelatin", "pixel_animals:gelatin","pixel_animals:gelatin"},
        {"pixel_animals:gelatin", "pixel_animals:gelatin","pixel_animals:gelatin"},
        {"pixel_animals:gelatin", "pixel_animals:gelatin","pixel_animals:gelatin"}
    }
})

mobs:register_mob("pixel_animals:jellyfish", {
	--nametag = "jellyfish" ,
	type = "animal",
	passive = true,
	runaway_from = { "player"},
	pathfinding = true,
	-- reach = 0,
	-- damage = 0,
	hp_min = 5,
	hp_max = 5,
	armor = 100,
	collisionbox = {-0.2, -0.1, -0.2, 0.2, 0.5, 0.2},
	visual = "mesh",
	visual_size = {x = 7, y = 7},
	mesh = "jellyfish.glb",
	textures = {
		{"jellyfish.png"},
		{"jellyfish_blue.png"},
		{"jellyfish_green.png"},
		{"jellyfish_orange.png"},
		{"jellyfish_violet.png"},
		{"jellyfish_yellow.png"},		
	},
	--blood_texture = "",
	makes_footstep_sound = false,
	sounds = {
		--random = " ",
		--death = " ",
	},
	fly = true , 
	fly_in = fly_w,
	walk_velocity = 1,
	run_velocity = 3,
	jump_height = 0,
	stepheight = 0.0,
	fall_speed = 0,
	-- floats = 0,
	view_range = 10,
	drops = {
	  {name = "pixel_animals:gelatin", chance = 5, min = 1, max = 1},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
	glow = 5,
	animation = {
		speed_normal = 5,
		stand_end = 72,
		fly_start = 24,			
		fly_end = 72,
		walk_start = 24,
		walk_end = 72,
		run_start = 24,
		run_end = 72,
		--punch_start = 0,
		--punch_end = 0,
	},
	
	--on_rightclick = function(self, clicker)
	  --mobs:capture_mob(self, clicker, 50, 90, 0, true,"pixel_animals:jellyfish")
	 --end,
	
        on_flop = function(self)
	 	self.object:set_acceleration({
			x = math.random(-0.1, 0.1),
			y = -10,
			z = math.random(-0.1, 0.1)
		})

		self.object:set_velocity({x = 0, y = -10, z = 0})
		return true
	end
})

mobs:spawn({
	name       = "pixel_animals:jellyfish",
	nodes      = fly_w,
	-- no neighbors requirement: they float in open water, not next to stone
	min_light  = 0,
	max_light  = 14,
	chance     = 14000,
	min_height = -80,
	max_height = 0,
	min_heat   = 20,  -- temperate to tropical oceans
})

mobs:register_egg("pixel_animals:jellyfish", "jellyfish", "jellyfish_inv.png", 0)

