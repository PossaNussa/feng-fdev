local fly_w = {
"default:water_source",
"default:river_water_source",
"rp_default:water_source",
"mcl_core:water_source",
}

pixel_animals.enable_shark_spawn = core.settings:get_bool("enable_shark_spawn", true)

core.register_craftitem("pixel_animals:shark_tooth", {
    description = "Shark Tooth",
    inventory_image = "shark_tooth.png"
})

core.register_tool("pixel_animals:shark_tooth_spear", {
	description = core.colorize("#0c5da7", "Shark Tooth Spear"),
	range = 8,
	wield_scale = {x = 1, y = 1.5, z = 1},
	inventory_image = "Shark_tooth_spear.png",
	tool_capabilities = {
		full_punch_interval = 0.6,
		max_drop_level=1,
		groupcaps={
			snappy={times={[1]=1.8, [2]=1.0, [3]=0.35}, uses=0, maxlevel=2},
		},
		damage_groups = {fleshy=8},
	},
	
	sound = {
	--breaks = "breaks",
	--punch_use = "swoosh1",
	--punch_use_air ="swoosh1",
	},
	groups = {lance = 1},
	on_drop = function() end,	
})

core.register_craft({
    type = "shaped",
    output = "pixel_animals:shark_tooth_spear",
    recipe = {
        {"", "pixel_animals:shark_tooth",""},
        {"", "group:stick",""},
        {"","group:stick",""}
    }
})

mobs:register_mob("pixel_animals:shark", {
	type = "monster",
	attack_type = "dogfight",
	passive = false,
	attack_animals = true , 
	attack_players = true,
	pathfinding = true,
	reach = 1,
	damage = 3,
	hp_min = 20,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.4, -0.0, -0.4, 0.4, 0.5, 0.4},
	visual = "mesh",
	mesh = "shark.b3d",
	textures = {{"shark.png"}},
	makes_footstep_sound = false,
	sounds = {},
	fly = true , 
	fly_in = fly_w,
	walk_velocity = 2,
	run_velocity = 4,
	jump_height = 0,
	stepheight = 0.0,
	fall_speed = 0,
	-- floats = 0,
	view_range = 15,
	drops = {	
	    {name = "pixel_animals:shark_tooth", chance = 5, min = 1, max = 1},		
	},
	water_damage = 0,
	lava_damage = 6,
	light_damage = 0,
	animation = {
		speed_normal = 20,
		stand_start = 1,
		stand_end = 20,
		fly_start = 30,			
		fly_end = 50,
		walk_start = 30,
		walk_end = 50,
		run_start = 30,
		run_end = 50,
		punch_start = 55,
		punch_end = 75,
	},
})

if pixel_animals.enable_shark_spawn then
mobs:register_spawn("pixel_animals:shark", {"default:water_flowing", "default:water_source"}, 14, 5, 6000, 5, 10,-5, true)
end

mobs:register_egg("pixel_animals:shark","Shark","shark_egg.png", 0)
