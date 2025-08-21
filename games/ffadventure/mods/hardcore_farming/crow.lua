-- Function to check for nearby scarecrows and despawn the crow
local function check_for_scarecrows(crow)
    local pos = crow.object:get_pos()
    if pos then
        -- Check within a radius of 10 blocks (adjust as needed)
        local radius = 30
        local objs = minetest.get_objects_inside_radius(pos, radius)
        for _, obj in ipairs(objs) do
            if obj:get_luaentity() and obj:get_luaentity().name == "x_farming:scarecrow" or obj:get_luaentity().name == "x_farming:scarecrow_2" or obj:get_luaentity().name == "hardcore_farming:scarecrow" or obj:get_luaentity().name == "group:scarecrow" then
                -- Despawn the crow
                crow.object:remove()
                return
            end
        end
    end
end
-- =============================================================================
-- SOUND: https://freesound.org/people/straget/sounds/404687/
-- =============================================================================
mobs:register_mob("hardcore_farming:crow", {
	--nametag = "crow" ,
	type = "animal",
	specific_attack = {"mobs_animal:rat"},
	passive = false,
	attack_type = "dogfight",
	attack_animals = true, --- para atarcar os ratos
	group_attack = true,
	owner_loyal = true,
	---------------------------<<
	pathfinding = true,
	reach = 2,
	damage = 3,
	hp_min = 3,
	hp_max = 14,
	armor = 100,
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	visual = "mesh",
	mesh = "Crow.b3d",
	rotate = 180,
	textures = {
		{"Crow.png"},
		
	},
	--blood_texture = "",
	sounds = {
		random = "crow",
		--death = "",
	},
	--fly = true , 
	fly_in = "air",
	walk_velocity = 2,
	run_velocity = 4,
	runaway = true,
        runaway_from = {"animalworld:bear","x_farming:scarecrow","x_farming:scarecrow_2", "hardcore_farming:scarecrow", "group:scarecrow"},
	fall_speed = -1,
	jump_height = 4,
	stepheight = 1.1,
	floats = 0,
	view_range = 35,
	    --[[    stay_near = {{"group:crop","default:dry_grass_1", "default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4", "naturalbiomes:bushland_grass", "naturalbiomes:bushland_grass2", "naturalbiomes:bushland_grass3", 
"naturalbiomes:bushland_grass4"}, 4},  --"farming:wheat_8"]]
			stay_near = {{"group:crop"}, 4},  --"farming:wheat_8"
	replace_rate = hardcore_farming.replace_rate,
	replace_what = { ---- remove o n e coloca outro no caso ar :)
	"group:crop",
	"dfarm:potato_4",
	"dfarm:carrot_4"},
		replace_with = "air",
	drops = {
	
		{name = "animalia:feather", chance = 3, min = 0, max = 1},
		
	},
	water_damage = 1,
	lava_damage = 2,
	light_damage = 0,
	animation = {
		speed_normal = 40,
		stand_start = 0,
		stand_end = 19,
		fly_start = 0,			
		fly_end = 19,
		walk_start = 0,
		walk_end = 19,
		run_start = 0,
		run_end = 19,
		--punch_start = 0,
		--punch_end = 0,
		},
	
	follow = {
		"farming:seed_wheat", 
		"dfarm:seed_potato", 
		"dfarm:seed_carrot",
	 	
	},
	on_step = function(self, dtime)
        -- Call the function to check for scarecrows every step
        check_for_scarecrows(self)
    end,
	on_rightclick = function(self, clicker)

		if mobs:feed_tame(self, clicker, 8, true, true) then return end  -- 8 sementes
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 50, 50, 90, false, nil) then return end

		-- by right-clicking owner can switch between staying and walking
		if self.owner and self.owner == clicker:get_player_name() then

			if self.order ~= "stand" then
				self.order = "stand"
				self.state = "stand"
				self.object:set_velocity({x = 0, y = 0, z = 0})
				mobs:set_animation(self, "stand")
			else
				self.order = ""
				mobs:set_animation(self, "fly")
			end
		end
	end,



})


--==============================================================================
--========================= SPAWN ==============================================

mobs:spawn({
	name = "hardcore_farming:crow",
	--nodes =  { "group:crop"},
	nodes =  { "group:tree"},
	--neighbors = { "group:crops", "dfarm:carrot_4" ,"dfarm:potato_4" },
	min_light = 1, 
	interval = 480,
	chance = 120000,
	active_object_count = 5,
	min_height = 0,
	max_height = 26000,
})






mobs:register_egg("hardcore_farming:crow", "Crow", "crow_egg.png", 1)

-- =====================================================================



