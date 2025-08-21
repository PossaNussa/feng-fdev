minetest.register_craftitem("zombies:rotten_flesh", {
	description = "Zombie Flesh",
	inventory_image = "mobs_rotten_flesh.png",
})
-- Helper function to generate random texture lists
local zombie_textures = {
		"summer.png",
		"scarecrow1.png",
		"scarecrow2.png",
		"bacon.png",
		"uncookedbacon.png", 
		"behe.png",
		"gasguy.png",
		"zombie_pigman.png",
		"mainzombie.png",
		"mobs_zombie.png",
		"skele.png",
		"Porkman-Pigman-from-Minecraft-2009-on-planetminecraft-com.png",
		"mochi.png",
    }
	
	local fzombie_textures = {
		"skele.png",
		"mochi.png",
		"viaven.png",
		"Frostbitten-Zombie-Draugr-Craft-on-planetminecraft-com.png",
		"draugr.png",
    }
	
local seazombie_textures = {
		"summer.png",
		"spirate.png",
		"lightninja2004.png",
		"HarabelBR.png",
		"GoshoHybavetza.png",
		"skele.png",
		"skelepirate.png",
		"skelepiratwo.png",
		"character_6.png",
    }
local seamonster_textures = {
		"2023_03_02_snake-21384405.png",
		"braxo.png",
		"progman.png",
		"orangun.png",
		"fishman.png",
		"character_beast_5.png",
		"character_beast_6.png",
		"character_beast_11.png",
		"warthog.png",
    }



local function get_random_texture(self)
    self.base_texture = zombie_textures[math.random(#zombie_textures)]
    self.object:set_properties({textures = {self.base_texture}})
end

-- Zombie by BlockMen

mobs:register_mob('zombies:zombie', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	damage = 3,
	reach = 3,
	hp_min = 12,
	hp_max = 35,
	armor = 150,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "creatures_mob.x",
    textures = {zombie_textures[1]},
    on_spawn = get_random_texture,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.25,
	run_velocity = 0.25,
	jump = true,
	view_range = 40,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 0,
        max = 3,
    },
{
        name = "goblins:goblins_goblin_bone_meaty",
        chance = 4,
        min = 0,
        max = 3,
    },
		{name = "default:rustysword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_shovel",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_axe",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:brown_woolhat",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:leather_gloves",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_pickaxe",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 0,
		max = 31,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})


-- 1 Arm

mobs:register_mob('zombies:1arm', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 2,
	hp_min = 3,
	hp_max = 15,
	armor = 80,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "zombie_one-arm.b3d",
   -- textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = zombie_textures[math.random(#zombie_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.5,
	run_velocity = 0.5,
	jump = true,
	runaway = true,
        runaway_from = {"default:torch"},
	view_range = 40,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 0,
        max = 3,
    },
{
        name = "goblins:goblins_goblin_bone_meaty",
        chance = 4,
        min = 0,
        max = 3,
    },
	
		{name = "default:rustysword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_shovel",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_axe",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:brown_woolhat",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:leather_gloves",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_pickaxe",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 0,
		max = 31,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 5,
		speed_run = 5,
		punch_speed = 20,
		walk_start = 0,
		walk_end = 20,
		run_start = 0,
		run_end = 20,
		punch_start = 21,
		punch_end = 51,
	},
})


-- Crawler

mobs:register_mob('zombies:crawler', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 10,
	runaway = true,
        runaway_from = {"default:torch"},
	armor = 80,
	collisionbox = {-0.5, -.5, -0.4, 0.5, 0.2, 0.4},
	visual = "mesh",
	mesh = "zombie_crawler.b3d",
   -- textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = zombie_textures[math.random(#zombie_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.1,
	run_velocity = 0.1, 
	jump = false,
	view_range = 24,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 0,
        max = 3,
    },
{
        name = "goblins:goblins_goblin_bone_meaty",
        chance = 4,
        min = 0,
        max = 3,
    },
	
		{name = "default:rustysword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_shovel",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_axe",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:brown_woolhat",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:leather_gloves",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_pickaxe",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 0,
		max = 31,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 10,
		speed_run = 10,
		punch_speed = 60,
		walk_start = 0,
		walk_end = 40,
		run_start = 0,
		run_end = 40,
		punch_start = 41,
		punch_end = 71,
	},
})


-- Normal

mobs:register_mob('zombies:normal', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 20,
	armor = 80,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "zombie_normal.b3d",
  --  textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = zombie_textures[math.random(#zombie_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.25,
	run_velocity = 0.25,
	jump = true,
	view_range = 50,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 0,
        max = 3,
    },
{
        name = "goblins:goblins_goblin_bone_meaty",
        chance = 4,
        min = 0,
        max = 3,
    },
	
		{name = "default:rustysword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_shovel",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_axe",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:brown_woolhat",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:leather_gloves",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tinkering:tin_pickaxe",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 0,
		max = 31,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

mobs:register_mob('zombies:draugr', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 20,
	armor = 80,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "zombie_normal.b3d",
  --  textures = {get_rfandom_texture()},
	on_spawn = function(self)
    local texture = fzombie_textures[math.random(#fzombie_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.25,
	run_velocity = 0.25,
	jump = true,
	view_range = 50,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 3,
        max = 5,
    },
		{name = "default:rustysword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "tempsurvive:leather_gloves",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 2,
		max = 16,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

-- Sea Zombie

mobs:register_mob('zombies:seazombie', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 20,
	armor = 80,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "creatures_mob.x",
  --  textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = seazombie_textures[math.random(#seazombie_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.25,
	run_velocity = 0.25,
	jump = true,
	view_range = 45,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 0,
        max = 3,
    },
{
        name = "goblins:goblins_goblin_bone_meaty",
        chance = 4,
        min = 0,
        max = 3,
    },
	
		{name = "default:gold_ingot",
		chance = 24,
		min = 0,
		max = 3,},
		{name = "tinkering:tin_shovel",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "default:emerald",
		chance = 24,
		min = 0,
		max = 3,},
		{name = "tinkering:tin_pickaxe",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "tinkering:steel_sword",
		chance = 24,
		min = 0,
		max = 1,},
		{name = "default:rustysword",
		chance = 12,
		min = 0,
		max = 1,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 0,
		max = 64,},
},
	lava_damage = 5,
	light_damage = 0,
	water_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

-- Sea Monster

mobs:register_mob('zombies:seamonster', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 20,
	water_damage = -1,
	armor = 80,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "creatures_mob.x",
  --  textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = seamonster_textures[math.random(#seamonster_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.5,
	run_velocity = 0.5,
	jump = true,
	view_range = 50,
	drops = {
    {
        name = "animalia:venison",
        chance = 2,
        min = 3,
        max = 5,
    },

		{name = "default:emerald",
		chance = 24,
		min = 0,
		max = 3,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})
-- Mummy

local mummy_textures = {
        "mummy-on-planetminecraft-com.png",
		"epharo.png"
    }
mobs:register_mob('zombies:mummy', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 2,
	damage = 1,
	hp_min = 1,
	hp_max = 20,
	armor = 80,
	runaway = true,
        runaway_from = {"default:torch"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "creatures_mob.x",
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_zombie",
		damage = "mobs_zombie_hit",
		attack = "groan",
		death = "mobs_zombie_death",
	},
	walk_velocity = 0.25,
	run_velocity = 0.25,
	jump = true,
	view_range = 50,
	on_spawn = function(self)
    local texture = mummy_textures[math.random(#mummy_textures)]
    self.object:set_properties({textures = {texture}})
end,
	drops = {
    {
        name = "zombies:rotten_flesh",
        chance = 2,
        min = 1,
        max = 3,
    },
    {
        name = "default:paper",
        chance = 2,
        min = 1,
        max = 3,
    },

		{name = "default:ruby",
		chance = 24,
		min = 0,
		max = 3,},
		{name = "simplecoins:coins",
		chance = 12,
		min = 2,
		max = 32,},
},

	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

local hamster_textures = {
        "rat.png",
		"hamster.png"
    }


local function get_ham_texture()
    return hamster_textures[math.random(#hamster_textures)]
end

mobs:register_mob('zombies:hamster', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 5,
	damage = 5,
	hp_min = 1,
	hp_max = 10,
	armor = 60,
	runaway = true,
        runaway_from = {"tinkering:silver_sword"},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "Zombielion.b3d",  -- Assuming you want to use the same model
    -- Set textures to a default lion skin or use the on_spawn callback to set it randomly
    textures = {
	"spears_spear_stone.png",
	"spears_spear_stone.png",
	hamster_textures[1]},
  --  textures = {get_random_texture()},
	on_spawn = function(self)
    local texture = hamster_textures[math.random(#hamster_textures)]
    self.object:set_properties({textures = {"spears_spear_stone.png", "spears_spear_stone.png", texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "animalia_bat",
		damage = "animalia_bat",
		attack = "animalia_bat_1",
		death = "animalia_bat_2",
	},
	walk_velocity = 1,
	run_velocity = 1.25,
	jump = true,
	view_range = 18,
	drops = {
    {
        name = "animalia:venison_raw",
        chance = 2,
        min = 1,
        max = 3,
    },
		{name = "spears:spear_stone",
		chance = 2, min = 0, max = 1,},
},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

-- Spawns
  -- Spawn conditions for 'zombie' with reduced active count
  mobs:register_spawn("zombies:mummy", {"default:sand", "default:desert_sand", "default:silver_sand", "badlands:red_sand"}, 5, 0, 100000, 2, 31000)
  
  mobs:register_spawn("zombies:seazombie", {"default:sand", "default:desert_sand", "default:mud", "biomes_island:dirt_with_island_litter", "default:water", "default:river_water"}, 5, 0, 100000, 2, 31000)
  mobs:register_spawn("zombies:seamonster", {"default:sand", "default:mud", "biomes_island:dirt_with_island_litter", "default:water", "default:river_water"}, 15, 0, 200000, 2, 31000)  
  -- Spawn conditions for '1arm' with increased rarity and reduced active count
  mobs:register_spawn("zombies:1arm", {"group:cracky", "group:crumbly"}, 15, 0, 120000, 2, 170, false)

  -- Spawn conditions for 'crawler' with increased rarity and reduced active count
  mobs:register_spawn("zombies:crawler", {"group:cracky", "group:crumbly"}, 15, 0, 120000, 2, 170, false)

  -- Spawn conditions for 'normal' with increased rarity and reduced active count
  mobs:register_spawn("zombies:normal", {"group:cracky", "group:crumbly"}, 15, 0, 120000, 2, 170, false)
  mobs:register_spawn("zombies:draugr", {"default:snow", "default:ice"}, 15, 0, 120000, 4, 170, false)

-- Eggs

mobs:register_egg("zombies:zombie", "Voodoo Head", "zombie_head.png", 0)
mobs:register_egg("zombies:1arm", "Damaged Voodoo Head", "zombie_head.png", 0)
mobs:register_egg("zombies:crawler", "Crippled Voodoo Head", "zombie_head.png", 0)
mobs:register_egg("zombies:normal", "Unseemly Voodoo Head", "zombie_head.png", 0)
local horde_active = false
local wave_size = 20
local wave_multiplier = 1.2
local horde_interval_days = 28
local last_horde_day = -1
local save_file = minetest.get_worldpath() .. "/last_horde_day.txt"

-- Function to break nodes
local function break_node(pos, time)
    minetest.after(time, function()
        minetest.remove_node(pos)
    end)
end

-- Function to start waves
local function start_wave(zombie_types)
    if not horde_active then return end

    -- Find all connected players
    local players = minetest.get_connected_players()

    -- Spawn zombies near each player
    for _, player in pairs(players) do
        local ppos = player:get_pos()
        for i = 1, wave_size do
            local x = ppos.x + math.random(-30, 30)
            local y = ppos.y + math.random(0, 3)
            local z = ppos.z + math.random(-30, 30)
            local zombie_type = zombie_types.regular[math.random(#zombie_types.regular)]
            minetest.add_entity({x=x, y=y, z=z}, zombie_type)
        end
    end

    -- Double the wave size for the next wave
    wave_size = wave_size * wave_multiplier

    minetest.chat_send_all("They're coming...")

    -- Schedule the next wave to start in 10 minutes
    minetest.after(600, function() start_wave(zombie_types) end)
end

-- Function to save the last horde day to a file
local function save_last_horde_day()
    local file = io.open(save_file, "w")
    if file then
        file:write(tostring(last_horde_day))
        file:close()
    end
end

-- Function to load the last horde day from a file
local function load_last_horde_day()
    local file = io.open(save_file, "r")
    if file then
        local content = file:read("*a")
        last_horde_day = tonumber(content) or -1
        file:close()
    end
end

-- Function to check if it's time to start the horde
local function check_horde_time()
    local current_day = minetest.get_day_count()
    local time_of_day = minetest.get_timeofday()

    -- Check if it's sunset (time_of_day between 0.2 and 0.5) and if enough days have passed since the last horde
    if time_of_day >= 0.2 and time_of_day <= 0.5 and (current_day - last_horde_day) >= horde_interval_days then
        if not horde_active then
            horde_active = true
            wave_size = 12
            last_horde_day = current_day
            save_last_horde_day()
            
            local rand = math.random(1, 10)
            local zombie_types = {regular = {}, bosses = {}}
            if rand <= 6 then
                zombie_types.regular = {"zombies:hamster"}
            elseif rand <= 8 then
                zombie_types.regular = {
                    "zombies:zombie",
                    "zombies:normal",
                    "zombies:crawler",
                    "zombies:1arm",
                    "ghosts:ghost",
                    "zombies:seazombie",
                    "zombies:draugr",
                    "zombies:mummy",
                    "spitterzombie:spitterzombie",
                    "runner:runner",
                    "lumberjackzombie:vampire",
                    "tankzombie:tankzombie",
                    "zombies:badguy",
                    "zombies:undeadknight"
                }
            elseif rand <= 9 then
                zombie_types.regular = {"zombies:gnoll", "zombies:lionman", "zombies:cheetahman", "zombies:cheetarcher", "zombies:lion_warrior", "zombies:cheetahwarrior"}
            else
                zombie_types.regular = {"lumberjackzombie:vampire", "petz:werewolf"}
            end
            
            start_wave(zombie_types)
        end
    else
        if horde_active then
            horde_active = false
        end
    end

    -- Check every minute
    minetest.after(60, check_horde_time)
end

-- Initialize by loading the saved day and start the timer
minetest.register_on_mods_loaded(function()
    load_last_horde_day()
    minetest.after(0, check_horde_time)
end)

-- Command to start horde
minetest.register_chatcommand("horde", {
    privs = {server = true},
    func = function(name)
        horde_active = true
        wave_size = 10
        start_wave()
    end,
})

-- Command to stop horde
minetest.register_chatcommand("hordeover", {
    privs = {server = true},
    func = function(name)
        horde_active = false
        minetest.chat_send_all("The horde is over.")
    end,
})

-- Modify existing zombie mobs
for name, def in pairs(minetest.registered_entities) do
    if string.match(name, "^zombies:") then
        local old_on_step = def.on_step
        def.on_step = function(self, dtime)
            local pos = self.object:get_pos()
            local all_objects = minetest.get_objects_inside_radius(pos, 1000)
            for _, obj in pairs(all_objects) do
                if obj:is_player() then
                    self.state = "attack"
                    self.attack = obj
                    break
                end
            end
            -- Ensure block breaking only happens when horde is active
            if horde_active then
                local pos = self.object:get_pos()
                local targets = {
                    {x = pos.x + 1, y = pos.y, z = pos.z},
                    {x = pos.x - 1, y = pos.y, z = pos.z},
                    {x = pos.x, y = pos.y, z = pos.z + 1},
                    {x = pos.x, y = pos.y, z = pos.z - 1},
                    {x = pos.x, y = pos.y - 1, z = pos.z},
                    {x = pos.x, y = pos.y + 1, z = pos.z}
                }

                for _, target in pairs(targets) do
                    local node = minetest.get_node(target)
                    local group = minetest.get_item_group(node.name, "wood") > 0 and "wood" or
                                  minetest.get_item_group(node.name, "tree") > 0 and "tree" or
                                  minetest.get_item_group(node.name, "stone") > 0 and "stone" or nil

                    local time
                    if string.find(node.name, "door_") then
                        time = 5
                    else
                        time = (group == "crumbly" and 5) or (group == "tree" and 10) or
                               (group == "cracky" and 20) or 10
                    end

                    if group or string.find(node.name, "door_") then
                        break_node(target, time)
                    end
                end

                local all_objects = minetest.get_objects_inside_radius(pos, 10)
                for _, obj in pairs(all_objects) do
                    if obj:is_player() then
                        self.state = "attack"
                        self.attack = obj
                    end
                end
            end

            if old_on_step then
                return old_on_step(self, dtime)
            end
        end

        minetest.register_entity(":"..name, def)
    end
end

-- Assume lion_skins is a table of lion textures
local lion_skins = {
  "lion.png",
  "lion2.png",
  "lion3.png",
  "lion4.png",
  "matelion.png",
  "matelion2.png",
  --"lion17.png",
}

local function set_random_lion_texture_on_spawn(self)
    self.base_texture = lion_skins[math.random(#lion_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end

-- LionMan by YourName

mobs:register_mob("zombies:lionman", {
	type = "monster",
	passive = false,
	pathfinding = true,
	attack_type = "dogfight",
	damage = 3,  -- Adjust damage if necessary for balance
	reach = 3,
	attack_animals = true,
	hp_min = 12,
	hp_max = 35,
	armor = 150,  -- Adjust armor if necessary for balance
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	visual = "mesh",
	mesh = "zombie_normal.b3d",  -- Assuming you want to use the same model

    -- Set textures to a default lion skin or use the on_spawn callback to set it randomly
    textures = {lion_skins[1]},
    on_spawn = set_random_lion_texture_on_spawn,
	makes_footstep_sound = true,
	sounds = {
		random = "lion_ambient",  -- Replace with your lion sounds
		damage = "lion_hurt",
		attack = "lion_roar",
		death = "lion_death",
	},
	walk_velocity = 1,  -- Adjust if you want different movement speed
	run_velocity = 1.5,  -- Lions are faster than zombies
	jump = true,
	floats = 0,
	view_range = 24,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 3,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 2,}
		-- Add any other drops specific to lions
	},
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})

mobs:register_mob("zombies:lion_warrior", {
	type = "monster",
	passive = false,
	pathfinding = true,
	attack_type = "dogfight",
	damage = 5,  -- Adjust damage if necessary for balance
	reach = 5,
	attack_animals = true,
	hp_min = 12,
	hp_max = 35,
	armor = 70,  -- Adjust armor if necessary for balance
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	visual = "mesh",
	mesh = "Zombielion.b3d",  -- Assuming you want to use the same model
    -- Set textures to a default lion skin or use the on_spawn callback to set it randomly
    textures = {
	"spears_spear_stone.png",
	"spears_spear_stone.png",
	"lion4.png"},
	makes_footstep_sound = true,
	sounds = {
		random = "lion_ambient",  -- Replace with your lion sounds
		damage = "lion_hurt",
		attack = "lion_roar",
		death = "lion_death",
	},
	walk_velocity = 1,  -- Adjust if you want different movement speed
	run_velocity = 1.5,  -- Lions are faster than zombies
	jump = true,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	floats = 0,
	view_range = 24,
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 3,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 2,},
		{name = "spears:spear_stone",
		chance = 2, min = 0, max = 1,}
		-- Add any other drops specific to lions
	},
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	animation = {
		speed_normal = 20,
		speed_run = 20,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})
  local cheetah_skins = {
  "cheeta1.png",
  "cheeta2.png",
  "cheeta3.png",
  "cheeta4.png",
  "cheeta5.png",
}

local function set_random_cheetah_texture_on_spawn(self)
    self.base_texture = cheetah_skins[math.random(#cheetah_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
  mobs:register_mob("zombies:cheetahman", {
	type = "monster",
	hp_min = 8,
	hp_max = 28,
	walk_velocity = 2,
	run_velocity = 2.6,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 3,
	knock_back = true,
	fear_height = 6,
	fall_damage = true,
	lava_damage = 9999,
	suffocation = 0,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	floats = 0,
	reach = 3,
	attack_chance = 1,
	attack_animals = true,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "cheeta",  -- Replace with your lion sounds
		damage = "cheeta",
		attack = "cheeta",
		death = "hyowl",
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		cheetah_skins[1]},
	mesh = "zombie_normal.b3d",
	
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 2,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,}
		-- Add any other drops specific to lions
	},
	
    on_spawn = function(self)
        local random_texture = cheetah_skins[math.random(#cheetah_skins)]
        self.object:set_properties({textures = {random_texture}})

        end
})

  mobs:register_mob("zombies:froghman", {
	type = "monster",
	hp_min = 6,
	hp_max = 16,
	walk_velocity = 1,
	run_velocity = 1.6,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 2.2,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 2,
	knock_back = true,
	fear_height = 12,
	fall_damage = true,
	lava_damage = 9999,
	suffocation = 0,
	floats = 0,
	reach = 3,
	attack_chance = 1,
	attack_animals = false,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		"frogman.png"},
	mesh = "zombie_normal.b3d",
	
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 1,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,}
		-- Add any other drops specific to lions
	},
})

  local cheetaw_skins = {
  "cheeta2.png",
  "cheeta7.png",
  "cheeta8.png",
}

local function set_random_cheetaw_texture_on_spawn(self)
    self.base_texture = cheetaw_skins[math.random(#cheetaw_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
  mobs:register_mob("zombies:cheetahwarrior", {
	type = "monster",
	hp_min = 8,
	hp_max = 28,
	walk_velocity = 2,
	run_velocity = 2.6,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	damage = 5,
	knock_back = true,
	fear_height = 6,
	fall_damage = true,
	lava_damage = 9999,
	suffocation = 0,
	floats = 0,
	reach = 3,
	attack_chance = 1,
	attack_animals = true,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "cheeta",  -- Replace with your lion sounds
		damage = "cheeta",
		attack = "mobs_skeletons_slash_attack",
		death = "hyowl",
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeleton_bow.png",
		cheetaw_skins[1]},
	mesh = "Zombielion.b3d",
	
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 2,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,},
		{name = "default:machete",
		chance = 9, min = 0, max = 1,}
		-- Add any other drops specific to lions
	},
	
    on_spawn = function(self)
        local random_texture = cheetaw_skins[math.random(#cheetaw_skins)]
        self.object:set_properties({textures = {"jmachete.png", "jmachete.png", random_texture}})

        end
})

  local cheetarcher_skins = {
  "cheeta2.png",
  "cheeta5.png",
  "cheeta6.png",
}

local function set_random_cheetarcher_texture_on_spawn(self)
    self.base_texture = cheetarcher_skins[math.random(#cheetarcher_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
  mobs:register_mob("zombies:cheetarcher", {
	type = "monster",
	hp_min = 8,
	hp_max = 28,
	walk_velocity = 2,
	run_velocity = 2.6,	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 2,
	knock_back = true,
	fear_height = 6,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	fall_damage = true,
	lava_damage = 9999,
	floats = 0,
	reach = 4,
	attack_chance = 1,
	attack_animals = true,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "shoot",
	arrow = "mobs_skeletons:arrow",
	shoot_interval = 1.5,
	shoot_offset = 1.0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
		random = "cheeta",  -- Replace with your lion sounds
		damage = "cheeta",
		attack = "cheeta",
		death = "hyowl",
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeleton_bow.png",
		cheetarcher_skins[1]},
	mesh = "Zombielion.b3d",
	
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 2,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,},
		{name = "x_bows:bow_wood",
		chance = 9, min = 0, max = 1,}
		-- Add any other drops specific to lions
	},
    on_spawn = function(self)
        local random_texture = cheetarcher_skins[math.random(#cheetarcher_skins)]
        self.object:set_properties({textures = {"mobs_skeleton_bow.png", "mobs_skeleton_bow.png", random_texture}})

        end
})

  mobs:register_mob("zombies:frarcher", {
	type = "monster",
	hp_min = 8,
	hp_max = 28,
	walk_velocity = 1,
	run_velocity = 1.6,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	jump_height = 2.2,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 2,
	knock_back = true,
	fear_height = 12,
	fall_damage = true,
	lava_damage = 9999,
	floats = 0,
	reach = 4,
	attack_chance = 1,
	attack_animals = false,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "shoot",
	arrow = "mobs_skeletons:arrow",
	shoot_interval = 1.5,
	shoot_offset = 1.0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeleton_bow.png",
		"farcher.png"},
	mesh = "Zombielion.b3d",
	
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 1,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,},
		{name = "x_bows:bow_wood",
		chance = 9, min = 0, max = 1,}
		-- Add any other drops specific to lions
	}
})
  local random_gnoll_textures = {
  "hy1.png",
  "hy2.png",
  "hy3.png",
  "hy4.png",
  "hy5.png",
  "hy6.png",
  "hy7.png",
	}
	
	

  local function get_gnoll_texture()
    return random_gnoll_textures[math.random(#random_gnoll_textures)]
end

mobs:register_mob("zombies:gnoll", {
	type = "monster",
	passive = false,
	pathfinding = true,
	attack_type = "dogfight",
	damage = 3,  -- Adjust damage if necessary for balance
	reach = 3,
	attack_animals = true,
	group_attack = true,
	hp_min = 6,
	hp_max = 40,
	armor = 175,  -- Adjust armor if necessary for balance
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	visual = "mesh",
	mesh = "zombie_normal.b3d",  -- Assuming you want to use the same model
    textures = {get_gnoll_texture()},
  on_spawn = function(self)
    local texture = random_gnoll_textures[math.random(#random_gnoll_textures)]
    self.object:set_properties({textures = {texture}})
end,
	makes_footstep_sound = true,
	sounds = {
		random = "hyena-laugh",  -- Replace with your lion sounds
		damage = "growl-101263",
		attack = "hyowl",
		death = "hyena-laugh",
	},
	walk_velocity = 1.2,  -- Adjust if you want different movement speed
	run_velocity = 1.8,  -- Lions are faster than zombies
	jump = true,
	floats = 0,
	view_range = 24,
	drops = {
		{name = "animalia:leather",
		chance = 2, min = 0, max = 2,},
		{name = "animalia:venison_raw",
		chance = 2, min = 0, max = 3,}
		-- Add any other drops specific to lions
	},
	water_damage = 0,
	lava_damage = 1,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	light_damage = 0,
	animation = {
		speed_normal = 22,
		speed_run = 22,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
})
mobs:register_mob("zombies:axolotl", {
	type = "animal",
	spawn_class = "axolotl",
	can_despawn = false,
	passive = false,
	hp_min = 14,
	hp_max = 14,
	xp_min = 1,
	xp_max = 7,

	head_swivel = "head.control",
	bone_eye_height = -1,
	head_eye_height = -0.5,
	horizontal_head_height = 0,
	curiosity = 10,
	head_yaw="z",

	armor = 100,
	rotate = 180,
	spawn_in_group_min = 1,
	spawn_in_group = 4,
	collisionbox = {-0.5, 0.0, -0.5, 0.5, 0.8, 0.5},
	visual = "mesh",
	mesh = "mobs_mc_axolotl.b3d",
	textures = {
		{"mobs_mc_axolotl_brown.png"},
		{"mobs_mc_axolotl_yellow.png"},
		{"mobs_mc_axolotl_green.png"},
		{"mobs_mc_axolotl_pink.png"},
		{"mobs_mc_axolotl_black.png"},
		{"mobs_mc_axolotl_purple.png"},
		{"mobs_mc_axolotl_white.png"}
	},
	sounds = {
		random = "mobs_mc_axolotl",
		damage = "mobs_mc_axolotl_hurt",
		distance = 16,
		},
	animation = {-- Stand: 1-20; Walk: 20-60; Swim: 61-81
		stand_start = 61, stand_end = 81, stand_speed = 15,
		walk_start = 61, walk_end = 81, walk_speed = 15,
		run_start = 61, run_end = 81, run_speed = 20,
	},

	follow = {
		"default:fish_item"
	},

	view_range = 16,
	fear_height = 4,

	on_rightclick = function(self, clicker)
		local bn = clicker:get_wielded_item():get_name()
		if self:feed_tame(clicker, 1, true, false) then return end
	end,
	makes_footstep_sound = false,
	tilt_swim = true,
	fly = true,
	fly_in = { "default:water_source", "default:river_water_source" },
	breathes_in_water = true,
	jump = true,
	damage = 2,
	reach = 2,
	attack_type = "dogfight",
	attack_animals = true,
	specific_attack = {
		"default:speckfish",
		"default:trout"
		 },
	runaway = true,
})


  local uk_skins = {
  "kcrusader.png",
  "rubuen.png",
  "dknight.png",
	"lknight.png",
  "unnamed.png",
		"zombiw.png",
  "uk1.png",
  "uk2.png",
  "uk3.png",
  "shadow.png",
  "lich.png",
  "uk4.png",
  "uk5.png",
  "uk6.png",
  "uk7.png",
}

local function set_random_uk_texture_on_spawn(self)
    self.base_texture = uk_skins[math.random(#uk_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
  mobs:register_mob("zombies:undeadknight", {
	type = "monster",
	hp_min = 25,
	hp_max = 75,
	walk_velocity = 1.2,
	run_velocity = 1.4,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 32,
	damage = 8,
	knock_back = true,
	fear_height = 6,
	fall_damage = true,
	lava_damage = 9999,
	suffocation = 0,
	floats = 0,
	reach = 3,
	attack_chance = 1,
	attack_animals = true,
	attack_npcs = true,
	attack_players = true,
	group_attack = true,
	attack_type = "dogfight",
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = {

		random = "mobs_zombie",
		attack = "mobs_skeletons_slash_attack",
	},
	visual = "mesh",
	animation = {
		speed_normal = 44,
		speed_run = 44,
		punch_speed = 20,
		stand_start = 0,
            	stand_end = 40,
		walk_start = 41,
		walk_end = 101,
		run_start = 41,
		run_end = 101,
		punch_start = 102,
		punch_end = 142,
	},
	collisionbox = {-0.25, -1, -0.3, 0.25, 0.75, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeleton_bow.png",
		cheetaw_skins[1]},
	mesh = "Zombielion.b3d",
	

	drops = {
		{name = "default:gold_ingot",
		chance = 1,
		min = 0,
		max = 9,},
		{name = "default:silverbar",
		chance = 12,
		min = 0,
		max = 9,},
		{name = "default:rustysword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:silver_sword",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:csteel_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
		{name = "default:copper_ingot",
		chance = 4,
		min = 0,
		max = 9,},		
		{name = "default:ironbar",
		chance = 5,
		min = 0,
		max = 9,},			
		{name = "default:coal",
		chance = 3,
		min = 0,
		max = 9,},
		{name = "default:fopal",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:diamond",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:peridot",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:ruby",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:emerald",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:btopaz",
		chance = 9,
		min = 0,
		max = 1,},	
		{name = "default:bronze_ingot",
		chance = 7,
		min = 1,
		max = 5,},
		{name = "default:steel_sword",
		chance = 10,
		min = 1,
		max = 1,},
		{name = "default:bronze_sword",
		chance = 35,
		min = 1,
		max = 1,},
		{name = "spears:spear_steel",
		chance = 10,
		min = 1,
		max = 1,},
		{name = ":3d_armor:helmet_bronze",
		chance = 30,
		min = 1,
		max = 1,},
		{name = ":3d_armor:chestplate_bronze",
		chance = 27,
		min = 1,
		max = 1,},
		{name = ":3d_armor:leggings_copper",
		chance = 25,
		min = 1,
		max = 1,},
		{name = ":3d_armor:boots_bronze",
		chance = 30,
		min = 1,
		max = 1,},
	},
	
    on_spawn = function(self)
        local random_texture = uk_skins[math.random(#uk_skins)]
        self.object:set_properties({textures = {"rustysword.png", "rustysword.png", random_texture}})

        end
})

  -- Spawn conditions for 'zombie' with reduced active count
  mobs:register_spawn("zombies:lionman", {"default:dry_dirt_with_dry_grass", "default:dry_dirt"}, 15, 0, 60000, 1, 31000, nil)
  mobs:register_spawn("zombies:hamster", {"default:dry_dirt_with_dry_grass", "default:dirt_with_grass"}, 15, 0, 91000, 1, 31000, nil)
  mobs:register_spawn("zombies:axolotl", {"default:water:source"}, 15, 0, 95000, 5, 31000, nil)
  -- Spawn conditions for 'zombie' with reduced active count
  mobs:register_spawn("zombies:lion_warrior", {"default:dry_dirt_with_dry_grass", "default:dry_dirt"}, 15, 0, 80000, 1, 31000, nil)
  -- Spawn conditions for 'zombie' with reduced active count
  mobs:register_spawn("zombies:cheetahman", {"default:dry_dirt_with_dry_grass", "default:dirt_with_rainforest_litter"}, 15, 0,91000, 1, 31000, nil)
  mobs:register_spawn("zombies:cheetarcher", {"default:dry_dirt_with_dry_grass", "default:dirt_with_rainforest_litter"}, 15, 0,91000, 1, 31000, nil)
  mobs:register_spawn("zombies:froghman", {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"}, 15, 0,120000, 1, 31000, nil)
  mobs:register_spawn("zombies:frarcher", {"default:dirt_with_rainforest_litter"}, 15, 0,120000, 3, 31000, nil)
  mobs:register_spawn("zombies:cheetahwarrior", {"default:dry_dirt_with_dry_grass", "default:dirt_with_rainforest_litter"}, 15, 0,91000, 1, 31000, nil)
 
  -- Spawn conditions for 'zombie' with reduced active count
  mobs:register_spawn("zombies:gnoll", {"default:dry_dirt_with_dry_grass", "default:dirt_with_grass", "default:dirt_with_coniferous_litter", "redw:dirt_with_grass", "default:snow", "default:dirt_with_snow"}, 15, 0, 19000, 5, 31000, false)
  mobs:register_spawn("zombies:undeadknight", {"bones:bones", "default:sand", "default:dirt_with_coniferous_litter", "default:dirt_with_grass", "default:cobble", "default:obsidian", "default:onyx", "default:slate", "default:gravel", "default:saprolite", "default:limestone", "default:sandstone"}, 15, 0, 21000, 3, 31000, false)
  
  local allow_nav_hacks = minetest.settings:get_bool("mcl_mob_allow_nav_hacks", false)

  local golem_skins = {
  "mobs_mc_iron_golem.png",
  "g2.png",
  "g3.png",
  "g4.png",
  "g5.png",
  "g6.png",
  "g7.png",
  "g8.png",
  "g10.png",
  "g11.png",
  "g12.png",
  "g13.png",
  "g14.png",
  "g15.png",
  "sg1.png",
}

local function set_random_golem_texture_on_spawn(self)
    self.base_texture = golem_skins[math.random(#golem_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end

mobs:register_mob("zombies:iron_golem", {
	description = ("Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 100,
	hp_max = 100,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	breath_max = -1,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{golem_skins[1]},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 16,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem", "zombies:wood_golem"},
	walk_velocity = 0.6,
	run_velocity = 1.2,
	-- Approximation
	damage = 14,
	knock_back = false,
	attack_npcs = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
    on_spawn = function(self)
        local random_texture = golem_skins[math.random(#golem_skins)]
        self.object:set_properties({textures = {random_texture}})

        end,
	_got_poppy = false,
	pick_up = {"default:cobble"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "default:cobble" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"default:cobble"},
	replace_with = {"default:rhyolitecobble"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:cobble" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:ironbar",
		chance = 1,
		min = 3,
		max = 5,},
		{name = "default:cobble",
		chance = 1,
		min = 0,
		max = 2,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:iron_golem", ("Golem"), "#3b3b3b", "#f57223", false)


-- Iron Golem summoning function
function check_iron_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "default:ironblock" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:iron_golem")
			break
		end
	end
end


mobs:register_mob("zombies:bronze_golem", {
	description = ("Bronze Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 80,
	hp_max = 80,
	attack_npcs = false,
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem"},
	breath_max = -1,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{"bro1.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 16,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	walk_velocity = 0.7,
	run_velocity = 1.3,
	-- Approximation
	damage = 12,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	_got_poppy = false,
	pick_up = {"default:cobble"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "default:cobble" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"default:cobble"},
	replace_with = {"default:onyxcobble"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:cobble" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:bronze_ingot",
		chance = 1,
		min = 3,
		max = 5,},
		{name = "default:cobble",
		chance = 1,
		min = 0,
		max = 2,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:bronze_golem", ("Bronze Golem"), "#3b3b3b", "#f57223", false)


-- Iron Golem summoning function
function check_bronze_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "default:bronzeblock" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:bronze_golem")
			break
		end
	end
end


mobs:register_mob("zombies:titan_golem", {
	description = ("Titanium Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 500,
	hp_max = 500,
	attack_npcs = false,
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem"},
	breath_max = -1,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{"ttbro.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 32,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	walk_velocity = 0.4,
	run_velocity = 1.3,
	-- Approximation
	damage = 24,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	_got_poppy = false,
	pick_up = {"default:cobble"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "default:cobble" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"default:cobble"},
	replace_with = {"default:onyxcobble"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:cobble" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:titaniumbar",
		chance = 1,
		min = 3,
		max = 5,},
		{name = "default:ruby",
		chance = 1,
		min = 0,
		max = 2,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:bronze_golem", ("Bronze Golem"), "#3b3b3b", "#f57223", false)


-- Iron Golem summoning function
function check_titan_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "default:titaniumblock" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:titan_golem")
			break
		end
	end
end

  local sgolem_skins = {
  "s1.png",
  "s2.png",
  "s3.png",
  "s4.png",
  "s5.png",
  "s6.png",
  "s7.png",
}

local function set_random_sgolem_texture_on_spawn(self)
    self.base_texture = sgolem_skins[math.random(#sgolem_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end

mobs:register_mob("zombies:stone_golem", {
	description = ("Stone Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 50,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	hp_max = 50,
	breath_max = -1,
	attack_npcs = false,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{sgolem_skins[1]},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 12,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem", "zombies:wood_golem"},
	walk_velocity = 0.5,
	run_velocity = 1.1,
	-- Approximation
	damage = 8,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
    on_spawn = function(self)
        local random_texture = sgolem_skins[math.random(#sgolem_skins)]
        self.object:set_properties({textures = {random_texture}})

        end,
	_got_poppy = false,
	pick_up = {"default:cobble"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "default:cobble" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"default:cobble"},
	replace_with = {"default:limestonecobble"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:cobble" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:cobble",
		chance = 1,
		min = 3,
		max = 5,},
		{name = "default:onyxcobble",
		chance = 1,
		min = 0,
		max = 2,},
		{name = "default:quartzcobble",
		chance = 1,
		min = 0,
		max = 2,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:stone_golem", ("Stone Golem"), "#3b3b3b", "#f57223", false)


-- Iron Golem summoning function
function check_stone_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "default:cobble" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:stone_golem")
			break
		end
	end
end

mobs:register_mob("zombies:dirt_golem", {
	description = ("Dirt Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 25,
	hp_max = 25,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	attack_npcs = false,
	breath_max = -1,
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem", "zombies:wood_golem"},
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{"dg1.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 12,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	walk_velocity = 0.8,
	run_velocity = 1.4,
	-- Approximation
	damage = 5,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	_got_poppy = false,
	pick_up = {"default:silt"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "default:silt" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"default:silt"},
	replace_with = {"default:air"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:silt" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:clay",
		chance = 1,
		min = 3,
		max = 5,},
		{name = "default:silt",
		chance = 1,
		min = 0,
		max = 2,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:dirt_golem", ("Dirt Golem"), "#3b3b3b", "#f57223", false)

-- Iron Golem summoning function
function check_dirt_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "x_farming:silt_loam_soil" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:dirt_golem")
			break
		end
	end
end

mobs:register_mob("zombies:wood_golem", {
	description = ("Wood Golem"),
	type = "npc",
	spawn_class = "passive",
	passive = false,
	hp_min = 30,
	hp_max = 40,
	attack_npcs = false,
	breath_max = -1,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	group_attack = { "zombies:iron_golem", "zombies:bronze_golem", "zombies:dirt_golem", "zombies:stone_golem", "zombies:wood_golem"},
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 10,
	textures = {
		{"wg1.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 12,
	stepheight = 1.1,
	owner = "",
	order = "follow",
	floats = 0,
	walk_velocity = 0.8,
	run_velocity = 1.1,
	-- Approximation
	damage = 5,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	_got_poppy = false,
	pick_up = {"group:wood"},
	on_pick_up = function(self,n)
		local it = ItemStack(n.itemstring)
		if it:get_name() == "group:wood" then
			if not self._got_poppy then
				self._got_poppy=true
				it:take_item(1)
			end
		end
		return it
	end,
	replace_what = {"group:wood"},
	replace_with = {"default:air"},
	on_replace = function(self, pos, oldnode, newnode)
		if not self.got_poppy and oldnode.name == "default:silt" then
			self._got_poppy=true
			return
		end
		return false
	end,
	drops = {
		{name = "default:wood",
		chance = 1,
		min = 3,
		max = 5,},
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
	do_custom = function(self, dtime)
		self.home_timer = (self.home_timer or 0) + dtime

		if self.home_timer > 10 then
			self.home_timer = 0
			if self._home and self.state ~= "attack" then
				local dist = vector.distance(self._home,self.object:get_pos())
				if allow_nav_hacks and dist >= tele_dist then
					self.object:set_pos(self._home)
					self.state = "stand"
					self.order = "follow"
				elseif dist >= walk_dist then
					self:gopath(self._home, function(self)
						self.state = "stand"
						self.order = "follow"
					end)
				end
			end
		end
	end,
})

-- Register spawn egg
mobs:register_egg("zombies:wood_golem", ("Wood Golem"), "#3b3b3b", "#f57223", false)

-- Iron Golem summoning function
function check_wood_golem_summon(pos)
	local checks = {
		-- These are the possible placement patterns, with offset from the pumpkin block.
		-- These tables include the positions of the iron blocks (1-4) and air blocks (5-8)
		-- 4th element is used to determine spawn position.
		-- If a 9th element is present, that one is used for the spawn position instead.
		-- Standing (x axis)
		{
			{x=-1, y=-1, z=0}, {x=1, y=-1, z=0}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0}, -- iron blocks
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=-2, z=0}, {x=1, y=-2, z=0}, -- air
		},
		-- Upside down standing (x axis)
		{
			{x=-1, y=1, z=0}, {x=1, y=1, z=0}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=2, z=0}, {x=1, y=2, z=0},
			{x=0, y=0, z=0}, -- Different offset for upside down pattern
		},

		-- Standing (z axis)
		{
			{x=0, y=-1, z=-1}, {x=0, y=-1, z=1}, {x=0, y=-1, z=0}, {x=0, y=-2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=-2, z=-1}, {x=0, y=-2, z=1},
		},
		-- Upside down standing (z axis)
		{
			{x=0, y=1, z=-1}, {x=0, y=1, z=1}, {x=0, y=1, z=0}, {x=0, y=2, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=0, y=2, z=-1}, {x=0, y=2, z=1},
			{x=0, y=0, z=0},
		},

		-- Lying
		{
			{x=-1, y=0, z=-1}, {x=0, y=0, z=-1}, {x=1, y=0, z=-1}, {x=0, y=0, z=-2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=-2}, {x=1, y=0, z=-2},
		},
		{
			{x=-1, y=0, z=1}, {x=0, y=0, z=1}, {x=1, y=0, z=1}, {x=0, y=0, z=2},
			{x=-1, y=0, z=0}, {x=1, y=0, z=0}, {x=-1, y=0, z=2}, {x=1, y=0, z=2},
		},
		{
			{x=-1, y=0, z=-1}, {x=-1, y=0, z=0}, {x=-1, y=0, z=1}, {x=-2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=-2, y=0, z=-1}, {x=-2, y=0, z=1},
		},
		{
			{x=1, y=0, z=-1}, {x=1, y=0, z=0}, {x=1, y=0, z=1}, {x=2, y=0, z=0},
			{x=0, y=0, z=-1}, {x=0, y=0, z=1}, {x=2, y=0, z=-1}, {x=2, y=0, z=1},
		},


	}

	for c=1, #checks do
		-- Check all possible patterns
		local ok = true
		-- Check iron block nodes
		for i=1, 4 do
			local cpos = vector.add(pos, checks[c][i])
			local node = minetest.get_node(cpos)
			if node.name ~= "default:junglewood" then
				ok = false
				break
			end
		end
		-- Check air nodes
		for a=5, 8 do
			local cpos = vector.add(pos, checks[c][a])
			local node = minetest.get_node(cpos)
			if node.name ~= "air" then
				ok = false
				break
			end
		end
		-- Pattern found!
		if ok then
			-- Remove the nodes
			minetest.remove_node(pos)
			core.check_for_falling(pos)
			for i=1, 4 do
				local cpos = vector.add(pos, checks[c][i])
				minetest.remove_node(cpos)
				core.check_for_falling(cpos)
			end
			-- Summon iron golem
			local place
			if checks[c][9] then
				place = vector.add(pos, checks[c][9])
			else
				place = vector.add(pos, checks[c][4])
			end
			place.y = place.y - 0.5
			minetest.add_entity(place, "zombies:wood_golem")
			break
		end
	end
end

-- Register callback for when a node is placed
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    -- Check if the placed node is 'default:ironblock'
    if newnode.name == "default:amethystblock" then
        -- Call the function 'mobs_mc.check_iron_golem_summon' with the position of the placed node
        check_iron_golem_summon(pos)
        check_bronze_golem_summon(pos)
        check_dirt_golem_summon(pos)
        check_stone_golem_summon(pos)
        check_wood_golem_summon(pos)
        check_titan_golem_summon(pos)
    end
end)


  local bguy_skins = {
  "g9.png",
  "bg1.png",
  "bg2.png",
  "bg4.png",
  "bg5.png",
  "bg7.png",
  "bg6.png",
  "bg8.png",
  "bg9.png",
  "bg10.png",
}

local function set_random_bguy_texture_on_spawn(self)
    self.base_texture = bguy_skins[math.random(#bguy_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end

  local cyskins = {
  "bg2.png",
  "bg10.png",
}

local function set_random_cy_texture_on_spawn(self)
    self.base_texture = cyskins[math.random(#cyskins)]
    self.object:set_properties({textures = {self.base_texture}})
end

mobs:register_mob("zombies:badguy", {
	description = ("Megabeast"),
	type = "monster",
	passive = false,
	hp_min = 50,
	hp_max = 500,
	attack_npcs = true,
	attack_animals = true,
	attack_players = true,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 8,
	textures = {
		{bguy_skins[1]},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 12,
	stepheight = 1.1,
	floats = 0,
	walk_velocity = 0.8,
	run_velocity = 1.5,
	-- Approximation
	damage = 8,
	    on_spawn = function(self)
        local random_texture = bguy_skins[math.random(#bguy_skins)]
        self.object:set_properties({textures = {random_texture}})

        end,
	knock_back = false,
	reach = 4,
	attacks_monsters = true,
	attack_type = "dogfight",
	replace = true,
	replace_what = {"default:saprolite"},
	replace_with = {"default:shale"},
	drops = {
		{name = "default:gold_ingot",
		chance = 1,
		min = 0,
		max = 19,},
		{name = "default:cobble",
		chance = 2,
		min = 0,
		max = 9,},
		{name = "tinkering:silver_sword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:bronze_axe",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:copper_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
		{name = "default:copper_ingot",
		chance = 4,
		min = 0,
		max = 19,},		
		{name = "default:ironbar",
		chance = 5,
		min = 0,
		max = 19,},			
		{name = "default:coal",
		chance = 3,
		min = 0,
		max = 19,},
		{name = "default:fopal",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:diamond",
		chance = 9,
		min = 0,
		max = 3,},		
		{name = "default:peridot",
		chance = 9,
		min = 0,
		max = 3,},		
		{name = "default:rubv",
		chance = 9,
		min = 0,
		max = 3,},		
		{name = "default:emerald",
		chance = 9,
		min = 0,
		max = 3,},		
		{name = "default:btopaz",
		chance = 9,
		min = 0,
		max = 1,},	
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})

mobs:register_mob("zombies:cyclops", {
	description = ("Cyclops"),
	type = "monster",
	passive = false,
	hp_min = 100,
	hp_max = 1000,
	attack_npcs = true,
	attack_animals = true,
	attack_players = true,
	collisionbox = {-2.4, -1.02, -2.4, 2.4, 6.38, 2.4},
	visual_size = {x=8, y=8},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 4,
	textures = {
		{cyskins[1]},
	},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 24,
	stepheight = 1.2,
	floats = 0,
	walk_velocity = 1,
	run_velocity = 1.2,
	-- Approximation
	damage = 12,
	    on_spawn = function(self)
        local random_texture = cyskins[math.random(#cyskins)]
        self.object:set_properties({textures = {random_texture}})

        end,
	knock_back = false,
	reach = 5,
	attacks_monsters = true,
	attack_type = "dogfight",
	replace_what = {"default:dirt_with_grass"},
	replace_with = {"default:dirt"},
	drops = {
		{name = "default:gold_ingot",
		chance = 1,
		min = 0,
		max = 24,},
		{name = "default:cobble",
		chance = 2,
		min = 0,
		max = 16,},
		{name = "tinkering:bronze_sword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:silver_axe",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "default:sword_iron",
		chance = 5,
		min = 0,
		max = 1,},		
		{name = "default:bronze_ingot",
		chance = 4,
		min = 0,
		max = 19,},		
		{name = "default:ironbar",
		chance = 5,
		min = 0,
		max = 19,},		
		{name = "default:silverbar",
		chance = 5,
		min = 0,
		max = 19,},					
		{name = "default:coal",
		chance = 3,
		min = 0,
		max = 38,},
		{name = "default:fopal",
		chance = 9,
		min = 0,
		max = 1,},		
		{name = "default:diamond",
		chance = 9,
		min = 0,
		max = 5,},		
		{name = "default:peridot",
		chance = 9,
		min = 0,
		max = 5,},		
		{name = "default:rubv",
		chance = 9,
		min = 0,
		max = 19,},		
		{name = "default:emerald",
		chance = 9,
		min = 0,
		max = 9,},		
		{name = "default:btopaz",
		chance = 9,
		min = 0,
		max = 19,},	
	},
	fall_damage = 1,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})
-- Register spawn egg
mobs:register_egg("zombies:badguy", ("Megabeast"), "#3b3b3b", "#f57223", false)

mobs:spawn({
	name = "zombies:badguy",
	nodes = {"group:crumbly", "group:cracky", "default:saprolite"},
	min_light = 0,
	max_light = 7, -- 14
	chance = 180400,
	active_object_count =3,
})
mobs:spawn({
	name = "zombies:cyclops",
	nodes = {"group:crumbly", "group:cracky", "default:saprolite"},
	min_light = 0,
	max_light = 7, -- 14
	chance = 181000,
	active_object_count =2,
})
mobs:register_mob("zombies:megaxol", {
	description = ("Megaxol"),
	type = "monster",
	passive = false,
	hp_min = 80,
	hp_max = 160,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 16,
	textures = {
		{"baxol.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 16,
	breath_max = -1,
	water_damage = 0,
	stepheight = 1.1,
	attack_animals = true,
	tilt_swim = true,
	fly = true,
	fly_in = { "default:water_source", "default:river_water_source" },
	breathes_in_water = true,
	specific_attack = {
		"default:speckfish",
		"default:trout"
		 },
	floats = 0,
	walk_velocity = 1.2,
	run_velocity = 1.5,
	-- Approximation
	damage = 8,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	drops = {
		{name = "default:silverbar",
		chance = 1,
		min = 0,
		max = 19,},
		{name = "default:coral_green",
		chance = 2,
		min = 0,
		max = 4,},
		{name = "default:coral_pink",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "default:sapphire",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "default:opal",
		chance = 5,
		min = 0,
		max = 1,},		
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})

-- Register spawn egg
mobs:register_egg("zombies:megaxol", ("Megabeast"), "#3b3b3b", "#f57223", false)

mobs:spawn({
	name = "zombies:megaxol",
	nodes = {"default:water_source"},
	min_light = 0,
	max_light = 15, -- 14
	chance = 184000,
	active_object_count =1,
})

mobs:register_mob("zombies:snowgolem", {
	description = ("Evil Snowman"),
	type = "monster",
	passive = false,
	hp_min = 40,
	hp_max = 160,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 8,
	textures = {
		{"snoway.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 13,
	breath_max = -1,
	stepheight = 1.1,
	floats = 0,
	attack_npcs = true,
	attack_animals = true,
	attack_players = true,
	walk_velocity = 0.8,
	run_velocity = 1.2,
	-- Approximation
	damage = 6,
	knock_back = false,
	reach = 3,
	attacks_monsters = true,
	attack_type = "dogfight",
	drops = {
		{name = "default:snow",
		chance = 1,
		min = 0,
		max = 19,},
		{name = "default:snowblock",
		chance = 2,
		min = 0,
		max = 4,},
		{name = "tinkering:silver_sword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:bronze_axe",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:copper_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})

-- Register spawn egg
mobs:register_egg("zombies:snowgolem", ("Snowman"), "#3b3b3b", "#f57223", false)

mobs:spawn({
	name = "zombies:snowgolem",
	nodes = {"default:snow", "default:snowblock"},
	min_light = 0,
	max_light = 15, -- 14
	chance = 180000,
	active_object_count =1,
})

mobs:register_mob("zombies:bigape", {
	description = ("Big Ape"),
	type = "monster",
	passive = false,
	hp_min = 80,
	hp_max = 250,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 8,
	textures = {
		{"bigape.png"},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 8,
	breath_max = -1,
	stepheight = 1.1,
	floats = 0,
	walk_velocity = 1.1,
	run_velocity = 1.2,
	-- Approximation
	damage = 12,
	knock_back = false,
	reach = 4,
	attacks_monsters = true,
	attack_type = "dogfight",
	drops = {
		{name = "x_farming:strawberry",
		chance = 1,
		min = 0,
		max = 19,},
		{name = "default:dirt_with_rainforest_litter",
		chance = 2,
		min = 0,
		max = 4,},
		{name = "tinkering:silver_sword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:bronze_axe",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:copper_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})

-- Register spawn egg
mobs:register_egg("zombies:bigape", ("Big Ape"), "#3b3b3b", "#f57223", false)

mobs:spawn({
	name = "zombies:bigape",
	nodes = {"default:dirt_with_rainforest_litter"},
	min_light = 0,
	max_light = 14, -- 14
	chance = 179000,
	active_object_count =1,
})

mobs:register_mob("zombies:buffpig", {
	description = ("Buff Pigman"),
	type = "npc",
	passive = false,
	hp_min = 40,
	hp_max = 250,
    runaway = true,
    runaway_from = {"group:water"},  -- Make the mob flee from nodes with the water group
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.69, 0.7},
	visual = "mesh",
	mesh = "mobs_mc_iron_golem.b3d",
	head_swivel = "head.control",
	bone_eye_height = 3.38,
	curiosity = 8,
	textures = {
		{"bpig.png"},
	},
	visual_size = {x=3.4, y=2.8},
	makes_footstep_sound = true,
	-- TODO: sounds
	view_range = 13,
	breath_max = -1,
	stepheight = 1.1,
	floats = 0,
	walk_velocity = 0.8,
	run_velocity = 1.2,
	-- Approximation
	damage = 6,
	knock_back = false,
	reach = 3,
	attack_monsters = true,
	attack_players = false,
	attack_animals = false,
	attack_npcs = false,
	attack_type = "dogfight",
	drops = {
		{name = "farming:wheat",
		chance = 1,
		min = 0,
		max = 19,},
		{name = "default:ironblock",
		chance = 2,
		min = 0,
		max = 4,},
		{name = "tinkering:silver_sword",
		chance = 3,
		min = 0,
		max = 1,},
		{name = "tinkering:bronze_axe",
		chance = 4,
		min = 0,
		max = 1,},
		{name = "tinkering:copper_shovel",
		chance = 5,
		min = 0,
		max = 1,},		
	},
	fall_damage = 0,
	animation = {
		stand_speed = 15, walk_speed = 15, run_speed = 25, punch_speed = 15,
		stand_start = 0,		stand_end = 0,
		walk_start = 0,		walk_end = 40,
		run_start = 0,		run_end = 40,
		punch_start = 40,  punch_end = 50,
	},
	jump = true,
})

-- Register spawn egg
mobs:register_egg("zombies:buffpig", ("Snowman"), "#3b3b3b", "#f57223", false)

mobs:spawn({
	name = "zombies:buffpig",
	nodes = {"mg_villages:plotmarker"},
	min_light = 0,
	max_light = 15, -- 14
	chance = 50000,
	active_object_count =3,
})
mobs:register_mob("default:mosasaurus", {
    type = "monster",
    spawn_class = "axolotl",
    can_despawn = false,
    passive = false,
    hp_min = 25,
    hp_max = 100,
    curiosity = 10,

    runaway = true,
    runaway_from = {"group:air"},  -- Make the mob flee from nodes with the water group
    armor = 100,
    collisionbox = {-1, -1, -1, 1, 1, 1},
    visual = "mesh",
    mesh = "mosa.b3d",
    textures = {
        {"mosa.png"}
    },

    view_range = 16,
    makes_footstep_sound = false,
    tilt_swim = true,
	static_save = true,
    fly = true,
    fly_in = {"default:water_source", "default:river_water_source"},
    breathes_in_water = true,
    jump = true,
    damage = 7,
    reach = 3,
    attack_type = "dogfight",
    attack_animals = true,
    attack_npcs = true,
    attack_players = true,
    attack_monsters = true,
	kill_count = 0,

	drops = {
		{name = "animalia:leather",
		chance = 1,
		min = 0,
		max = 4,
		looting = "common",},
		{name = "animalia:venison_raw",
		chance = 1,
		min = 0,
		max = 4,
		looting = "common",},
		{name = "animalia:venison_raw",
		chance = 10,
		min = 0,
		max = 5,
		looting = "common",},
		{name = "tinkering:flint_axe_head",
		chance = 50,
		min = 0,
		max = 1,
		looting = "common",},
		{name = "tinkering:silver_sword",
		chance = 50,
		min = 0,
		max = 1,
		looting = "common",},
	},
    on_spawn = function(self, staticdata)
        self.kill_count = tonumber(staticdata) or 0
        -- Ensure 'kill_count' is initialized to a number
        if not self.kill_count then
            self.kill_count = 0
        end

        -- Set initial size randomly between 1 and 5 times the default size
        local initial_size_factor = math.random(0.5, 10.0)
        self.object:set_properties({visual_size = {x=initial_size_factor, y=initial_size_factor}})
        minetest.after(2, function()
            self.can_despawn = false
        end)
    end,


    get_staticdata = function(self)
        return tostring(self.kill_count)
    end,


	
do_custom = function(self, dtime)
    self.kill_count = self.kill_count or 0
    local pos = self.object:get_pos()
    local all_objects = minetest.get_objects_inside_radius(pos, 30)

    for _, obj in ipairs(all_objects) do
        local ent = obj:get_luaentity()
        if ent then
            local new_target = obj:get_pos()
            local distance_to_target = vector.distance(pos, new_target)

            if distance_to_target < 3 then
                if ent.name == "default:fish" or ent.name == "default:trout" then
                    -- Handle fish and trout
                    local growth_factor = (ent.name == "default:fish") and 0.015 or 0.03
                    local hp_increase = (ent.name == "default:fish") and 2 or 4

                    self.kill_count = self.kill_count + 1
                    self.object:set_hp(self.object:get_hp() + hp_increase)
                    self.object:set_properties({visual_size = {x=1 + growth_factor*self.kill_count, y=1 + growth_factor*self.kill_count}})
                    obj:remove()
                elseif ent.name == "boats:boat" or ent.name == "sailing:canoe" then
                    -- Handle boats
                    if not ent._last_hit or ent._last_hit + 2 < minetest.get_gametime() then
                        ent._last_hit = minetest.get_gametime()

                        local boat_hp = ent.hp or 20 -- Default HP for boats
                        boat_hp = boat_hp - 5 -- Damage value; adjust as necessary

                        if boat_hp <= 0 then
                            obj:remove() -- Remove the boat if HP is depleted
                        else
                            ent.hp = boat_hp -- Update boat's HP
                        end
                    end
                end
            end

            -- Move towards fish, trout, or boats
            if ent.name == "default:fish" or ent.name == "default:trout" or 
               ent.name == "boats:boat" or ent.name == "sailing:canoe" or 
               ent.name == "sailing_kit:boat" then

                local velocity = vector.multiply(vector.direction(pos, new_target), 4)
                self.object:set_velocity(velocity)
                self.object:set_yaw(minetest.dir_to_yaw(velocity))
            end
        end
    end
end
})

function chasing_fish(self)
    -- Find nearby fish
    local pos = self.object:get_pos()
    local all_nearby_objects = minetest.get_objects_inside_radius(pos, 3)
    local nearby_fish = {}

    -- Filter for specific fish types
    for _, obj in ipairs(all_nearby_objects) do
        local obj_name = obj:get_luaentity() and obj:get_luaentity().name or ""
        if obj_name == "default:fish" or obj_name == "default:trout" then
            table.insert(nearby_fish, obj)
        end
    end

    local hp_increase = 2  -- Adjust as needed
    local growth_factor = 0.015  -- Adjust as needed

    if #nearby_fish > 0 then
        local target_fish = nearby_fish[math.random(#nearby_fish)]
        self.object:set_animation({x = 1}, 30, 0)

        -- Move towards the target fish
        local direction = target_fish:get_pos() - pos
        local distance = direction:length()

        if distance > 0.1 then
            local target_velocity = direction:normalize() * self.walk_velocity
            self.object:set_velocity(target_velocity)
        else
            -- Reached the target fish, so remove it and update size
            target_fish:remove()

            -- Increase mosasaurus size and HP
            local new_hp = math.min(self.object:get_hp() + hp_increase, self.hp_max)
            self.object:set_hp(new_hp)

            local current_size = self.object:get_properties().visual_size
            local new_size = {
                x = current_size.x + growth_factor,
                y = current_size.y + growth_factor
            }

            self.object:set_properties({visual_size = new_size})
        end
    end
end
mobs:spawn({
	name = "default:mosasaurus",
	nodes = {"group:water"},
	neighbors = {"air"},
	min_light = 0,
	max_light = 15,
	interval = 10,
	chance = 300,
	active_object_count = 5,
	min_height = -31000,
	max_height = 31000,
	day_toggle = false,
	   
})

--###################
--################### PARROT
--###################
local shoulders = {
	left = vector.new(-3.75,10.5,0),
	right = vector.new(3.75,10.5,0)
}

local function table_get_rand(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	return tbl[keys[math.random(#keys)]]
end

local function get_random_mob_sound()
	local t = table.copy(minetest.registered_entities)
	table.shuffle(t)
	for _,e in pairs(t) do
		if e.is_mob and e.sounds and #e.sounds > 0 then
			return table_get_rand(e.sounds)
		end
	end
	return minetest.registered_entities["zombies:parrot"].sounds.random
end

local function imitate_mob_sound(self,mob)
	local snd = mob.sounds.random
	if not snd or mob.name == "zombies:parrot" or math.random(20) == 1 then
		snd = get_random_mob_sound()
	end
	return minetest.sound_play(snd, {
		pos = self.object:get_pos(),
		gain = 1.0,
		pitch = 2.5,
		max_hear_distance = self.sounds and self.sounds.distance or 32
	}, true)
end

local function check_mobimitate(self,dtime)
	if not self._mobimitate_timer or self._mobimitate_timer > 30 then
		self._mobimitate_timer = 0
		for _,o in pairs(minetest.get_objects_inside_radius(self.object:get_pos(),20)) do
			local l = o:get_luaentity()
			if l and l.is_mob and l.name ~= "zombies:parrot" then
				imitate_mob_sound(self,l)
				return
			end
		end
	end
	self._mobimitate_timer = self._mobimitate_timer + dtime

end

--find a free shoulder or return nil
local function get_shoulder(player)
	local sh = "left"
	for _,o in pairs(player:get_children()) do
		local l = o:get_luaentity()
		if l and l.name == "zombies:parrot" then
			local _,_,a = l.object:get_attach()
			for _,s in pairs(shoulders) do
				if a and vector.equals(a,s) then
					if sh == "left" then
						sh = "right"
					else
						return
					end

				end
			end
		end
	end
	return shoulders[sh]
end

local function perch(self,player)
	if self.tamed and player:get_player_name() == self.owner and not self.object:get_attach() then
		local shoulder = get_shoulder(player)
		if not shoulder then return true end
		self.object:set_attach(player,"",shoulder,vector.new(0,0,0),true)
		self:set_animation("stand")
	end
end

local function check_perch(self,dtime)
	if self.object:get_attach() then
		for _,p in pairs(minetest.get_connected_players()) do
			for _,o in pairs(p:get_children()) do
				local l = o:get_luaentity()
				if l and l.name == "zombies:parrot" then
					local n1 = minetest.get_node(vector.offset(p:get_pos(),0,-0.6,0)).name
					local n2 = minetest.get_node(vector.offset(p:get_pos(),0,0,0)).name
					local n3 = minetest.get_node(vector.offset(p:get_pos(),0,1,0)).name
					if ( n1 == "air" or minetest.get_item_group(n2,"water") > 0 or minetest.get_item_group(n2,"lava") > 0) and
					not minetest.is_creative_enabled(p:get_player_name()) then
						o:set_detach()
						self.detach_timer = 0
						return
					end
				end
			end
		end
	elseif not self.detach_timer then
		for _,p in pairs(minetest.get_connected_players()) do
			if vector.distance(self.object:get_pos(),p:get_pos()) < 0.5 then
				perch(self,p)
				return
			end
		end
	elseif self.detach_timer then
		if self.detach_timer > 1 then
			self.detach_timer = nil
		else
			self.detach_timer = self.detach_timer + dtime
		end
	end
end

mobs:register_mob("zombies:parrot", {
	description = ("Parrot"),
	type = "animal",
	spawn_class = "passive",
	passive = true,
	pathfinding = 1,
	hp_min = 6,
	hp_max = 6,
	xp_min = 1,
	xp_max = 3,
	head_swivel = "head.control",
	bone_eye_height = 1.1,
	horizontal_head_height=0,
	curiosity = 10,
	collisionbox = {-0.25, -0.01, -0.25, 0.25, 0.89, 0.25},
	visual = "mesh",
	mesh = "mobs_mc_parrot.b3d",
	textures = {{"mobs_mc_parrot_blue.png"},{"mobs_mc_parrot_green.png"},{"mobs_mc_parrot_grey.png"},{"mobs_mc_parrot_red_blue.png"},{"mobs_mc_parrot_yellow_blue.png"}},
	visual_size = {x=3, y=3},
	walk_velocity = 3,
	run_velocity = 5,
	sounds = {
		random = "mobs_mc_parrot_random",
		damage = {name="mobs_mc_parrot_hurt", gain=0.3},
		death = {name="mobs_mc_parrot_death", gain=0.6},
		eat = "mobs_mc_animal_eat_generic",
		distance = 16,
	},
	drops = {
		{name = "animalia:feather",
		chance = 1,
		min = 1,
		max = 2,
		looting = "common",},
	},
   	animation = {
		stand_speed = 50,
		walk_speed = 50,
		fly_speed = 50,
		stand_start = 0,
		stand_end = 0,
		fly_start = 30,
		fly_end = 45,
		walk_start = 0,
		walk_end = 20,
		-- TODO: actual walk animation
		--walk_start = 0,
		--walk_end = 20,

		-- TODO: more unused animations between 45 and 130
	},
	fall_damage = 0,
	fall_speed = -2.25,
	attack_type = "dogfight",
	floats = 1,
	physical = true,
	fly = true,
	makes_footstep_sound = false,
	fear_height = 0,
	view_range = 16,
	follow = {
		"farming:wheat_seeds",
		"x_farming:melon_seeds",
		"x_farming:pumpkin_seeds",
		"x_farming:beetroot_seeds",
	},
	on_rightclick = function(self, clicker)
		if self._doomed then return end
		local item = clicker:get_wielded_item()
		-- Kill parrot if fed with cookie
		if item:get_name() == "mcl_farming:cookie" then
			minetest.sound_play("mobs_mc_animal_eat_generic", {object = self.object, max_hear_distance=16}, true)
			self.health = 0
			-- Doomed to die
			self._doomed = true
			if not minetest.is_creative_enabled(clicker:get_player_name()) then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			return
		end
		-- Feed to tame, but not breed
		if self:feed_tame(clicker, 1, false, true) then return end
		perch(self,clicker)
	end,
	do_custom = function(self,dtime)
		check_perch(self,dtime)
		check_mobimitate(self,dtime)
	end,
	do_punch = function(self,puncher) --do_punch is the mcl_mobs_redo variant - it gets called by on_punch later....
		if self.object:get_attach() == puncher then
			return false --return false explicitly here. mcl_mobs checks for that
		end
	end,
})


  mobs:register_spawn("zombies:parrot", {"biomes_island:dirt_with_island_litter"}, 15, 0, 3000, 1, 31000, nil)

-- spawn eggs
mobs:register_egg("zombies:parrot", ("Parrot"), "#0da70a", "#ff0000", 0)


local base_colors = {
	"#FF3855",
	"#FFF700",
	"#A7F432",
	"#FF5470",
	"#5DADEC",
	"#A83731",
	"#87FF2A",
	"#E936A7",
	"#FF007C",
	"#9C51B6",
	"#66FF66",
	"#AAF0D1",
	"#50BFE6",
	"#FFFF66",
	"#FF9966",
	"#FF00CC",
	"#1E90FF",  -- Dodger Blue
	"#006994", -- Deep Ocean Blue
	"#F4C542", -- Sandy Beige
	"#DAA520", -- Goldenrod Yellow
	"#8B4513", -- Dark Chocolate Brown
	"#8F9779", -- Grayish Olive
	"#FF6347", -- Tomato Red
	"#5F9EA0", -- Cadet Blue
	"#32CD32", -- Lime Green
	"#8A2BE2", -- Blue Violet
	"#3CB371", -- Medium Sea Green
	"#CD853F", -- Peru Brown
	"#8B008B", -- Dark Magenta
	"#4682B4", -- Steel Blue
	"#C71585", -- Medium Violet Red
	"#483D8B", -- Dark Slate Blue
	"#2E8B57", -- Sea Green
	"#20B2AA", -- Light Sea Green
	"#FF4500", -- Orange Red
	"#FFD700", -- Gold
	"#2F4F4F", -- Dark Slate Gray
	"#48D1CC", -- Medium Turquoise
	"#E9967A", -- Dark Salmon
	"#87CEEB", -- Sky Blue
	"#FA8072", -- Salmon
	"#00FA9A", -- Medium Spring Green
	"#7B68EE", -- Medium Slate Blue
	"#B22222", -- Fire Brick
	"#40E0D0", -- Turquoise
	"#7FFF00", -- Chartreuse Green
	"#B0C4DE", -- Light Steel Blue
	"#556B2F", -- Dark Olive Green
	"#9370DB", -- Medium Purple
	"#00CED1", -- Dark Turquoise
	"#FF8C00", -- Dark Orange
    "#66CDAA", -- Medium Aquamarine
}
local pattern_colors = {
	"#FF3855",
	"#FFF700",
	"#A7F432",
	"#FF5470",
	"#5DADEC",
	"#A83731",
	"#87FF2A",
	"#E936A7",
	"#FF007C",
	"#9C51B6",
	"#66FF66",
	"#AAF0D1",
	"#50BFE6",
	"#FFFF66",
	"#FF9966",
	"#FF00CC",
	"#1E90FF",  -- Dodger Blue
	"#006994", -- Deep Ocean Blue
	"#F4C542", -- Sandy Beige
	"#DAA520", -- Goldenrod Yellow
	"#8B4513", -- Dark Chocolate Brown
	"#8F9779", -- Grayish Olive
	"#FF6347", -- Tomato Red
	"#5F9EA0", -- Cadet Blue
	"#32CD32", -- Lime Green
	"#8A2BE2", -- Blue Violet
	"#3CB371", -- Medium Sea Green
	"#CD853F", -- Peru Brown
	"#8B008B", -- Dark Magenta
	"#4682B4", -- Steel Blue
	"#C71585", -- Medium Violet Red
	"#483D8B", -- Dark Slate Blue
	"#2E8B57", -- Sea Green
	"#20B2AA", -- Light Sea Green
	"#FF4500", -- Orange Red
	"#FFD700", -- Gold
	"#2F4F4F", -- Dark Slate Gray
	"#48D1CC", -- Medium Turquoise
	"#E9967A", -- Dark Salmon
	"#87CEEB", -- Sky Blue
	"#FA8072", -- Salmon
	"#00FA9A", -- Medium Spring Green
	"#7B68EE", -- Medium Slate Blue
	"#B22222", -- Fire Brick
	"#40E0D0", -- Turquoise
	"#7FFF00", -- Chartreuse Green
	"#B0C4DE", -- Light Steel Blue
	"#556B2F", -- Dark Olive Green
	"#9370DB", -- Medium Purple
	"#00CED1", -- Dark Turquoise
	"#FF8C00", -- Dark Orange
    "#66CDAA",  -- Medium Aquamarine
}

local function set_textures(self)
	if not self._type then
		self._type = "a"
		if math.random(2) == 1 then
			self.object:set_properties({})
			self._type="b"
		end
		self._base_color = base_colors[math.random(#base_colors)]
		self._pattern_color = pattern_colors[math.random(#pattern_colors)]
		self._pattern = "extra_mobs_tropical_fish_pattern_"..self._type.."_"..math.random(6)..".png"
	end
	self.object:set_properties({
		textures = {
			"(extra_mobs_tropical_fish_"..self._type..".png^[colorize:"..self._base_color..":127)^("..self._pattern.."^[colorize:"..self._pattern_color..")",
		},
		mesh="extra_mobs_tropical_fish_"..self._type..".b3d"
	})
end

local tropical_fish = {
	type = "animal",
	spawn_class = "water_ambient",
	can_despawn = true,
	passive = true,
	hp_min = 3,
	hp_max = 3,
	xp_min = 1,
	xp_max = 3,
	armor = 100,
    runaway = true,
    runaway_from = {"group:air"},  -- Make the mob flee from nodes with the water group
	spawn_in_group = 4, -- was 9. nerfed until aquatics use own cap rather than animal, and it represents pack size, not per spawn attempt
	tilt_swim = true,
	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.1, 0.2},
	visual = "mesh",
	mesh = "extra_mobs_tropical_fish_a.b3d",
	textures = { "extra_mobs_tropical_fish_a.png" }, -- to be populated on_spawn
	sounds = {},
	animation = {
		stand_start = 0,
		stand_end = 20,
		walk_start = 20,
		walk_end = 40,
		run_start = 20,
		run_end = 40,
	},
	drops = {
		{name = "zombies:clownfish_raw",
		chance = 1,
		min = 1,
		max = 1,},
		{name = "goblins:goblins_goblin_bone",
		chance = 20,
		min = 1,
		max = 1,},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = false,
	swim = true,
	fly = true,
	fly_in = {"default:water_source", "sailing:shallow_water_source"},
	breathes_in_water = true,
	jump = false,
	view_range = 16,
	runaway = true,
	fear_height = 4,
	on_spawn = set_textures,
}

mobs:register_mob("zombies:tropical_fish", tropical_fish)

  mobs:register_spawn("zombies:tropical_fish", {"default:water_source", "sailing:shallow_water_source"}, 15, 0,8000, 3, 31000, nil)

--spawn egg
mobs:register_egg("zombies:tropical_fish", ("Tropical fish"), "#ef6915", "#fff9ef", 0)

local salmon = {
	type = "animal",
	spawn_class = "water_ambient",
	can_despawn = true,
	passive = true,
	hp_min = 3,
	hp_max = 3,
	xp_min = 1,
	xp_max = 3,
	armor = 100,
    runaway = true,
    runaway_from = {"group:air"},  -- Make the mob flee from nodes with the water group
	spawn_in_group = 5,
	tilt_swim = true,
	collisionbox = {-0.4, 0.0, -0.4, 0.4, 0.79, 0.4},
	visual = "mesh",
	mesh = "extra_mobs_salmon.b3d",
	textures = {
		{"mobs_mc_salmon.png"}
	},
	sounds = {
	},
	animation = {
		stand_start = 1,
		stand_end = 20,
		walk_start = 1,
		walk_end = 20,
		run_start = 1,
		run_end = 20,
	},
	drops = {
		{name = "zombies:salmon_raw",
		chance = 1,
		min = 1,
		max = 1,},
		{name = "goblins:goblins_goblin_bone",
		chance = 20,
		min = 1,
		max = 1,},
	},
	visual_size = {x=3, y=3},
	makes_footstep_sound = false,
	swim = true,
	fly = true,
	fly_in = "default:water_source",
	breathes_in_water = true,
	jump = false,
	view_range = 16,
	runaway = true,
    on_spawn = function(self, staticdata)
        -- Set initial size randomly between 1 and 5 times the default size
        local initial_size_factor = math.random(0.8, 8.0)
        self.object:set_properties({visual_size = {x=initial_size_factor, y=initial_size_factor}})
    end,
	fear_height = 4,
}

mobs:register_mob("zombies:salmon", salmon)


-- Salmon
minetest.register_craftitem("zombies:salmon_raw", {
	description = ("Raw Salmon"),	inventory_image = "mcl_fishing_salmon_raw.png",
	on_use = minetest.item_eat(2),
	stack_max = 95,
	groups = { food=2, eatable = 2, smoker_cookable = 1, campfire_cookable = 1, meat = 1 },
})

minetest.register_craftitem("zombies:salmon_cooked", {
	description = ("Cooked Fish"),
	inventory_image = "mcl_fishing_salmon_cooked.png",
	on_use = minetest.item_eat(6),
	stack_max = 64,
	groups = { food=2, eatable=6, meat = 1 },
})

minetest.register_craft({
	type = "cooking",
	output = "zombies:salmon_cooked",
	recipe = "zombies:salmon_raw",
	cooktime = 10,
})

minetest.register_craft({
	type = "cooking",
	output = "zombies:salmon_cooked",
	recipe = "zombies:clownfish_raw",
	cooktime = 10,
})

minetest.register_craft({
	type = "cooking",
	output = "zombies:salmon_cooked",
	recipe = "default:trout_item",
	cooktime = 10,
})
minetest.register_craft({
	type = "cooking",
	output = "zombies:salmon_cooked",
	recipe = "default:fish_item",
	cooktime = 10,
})
-- Clownfish
minetest.register_craftitem("zombies:clownfish_raw", {
	description = ("Clownfish"),
	inventory_image = "mcl_fishing_clownfish_raw.png",
	on_place = minetest.item_eat(1),
	on_secondary_use = minetest.item_eat(1),
	stack_max = 95,
	groups = { food=2, eatable = 1 },
	_mcl_saturation = 0.2,
})

  mobs:register_spawn("zombies:salmon", {"default:water_source"}, 15, 0,8000, 3, 31000, nil)
--spawn egg
mobs:register_egg("zombies:salmon", ("Salmon"), "#a00f10", "#0e8474", 0)
minetest.override_item("default:steel_ingot", {
    description = "Steel Bar",
})
