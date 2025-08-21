--[[

	Mobs Skeletons - Adds skeletons.
	Copyright © 2021 Hamlet and contributors.

	Licensed under the EUPL, Version 1.2 or – as soon they will be
	approved by the European Commission – subsequent versions of the
	EUPL (the "Licence");
	You may not use this work except in compliance with the Licence.
	You may obtain a copy of the Licence at:

	https://joinup.ec.europa.eu/software/page/eupl
	https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863

	Unless required by applicable law or agreed to in writing,
	software distributed under the Licence is distributed on an
	"AS IS" basis,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.
	See the Licence for the specific language governing permissions
	and limitations under the Licence.

--]]

---
--- Variables
---

-- Global mod's namespace
mobs_skeletons = {}

-- Used for localization
local S = minetest.get_translator("mobs_skeletons")

-- Setting to enable direct sunlight only death of skeletons
local sunlight = minetest.settings:get_bool("mobs_skeletons.sunlight_kill") == true
local light_damage_min = sunlight and 14 or (default.LIGHT_MAX / 2)
local light_damage_max = sunlight and 16 or (default.LIGHT_MAX + 1)

-- Sounds
local sounds = {
	random = "mobs_skeletons_skeleton_random",
	attack = "mobs_skeletons_slash_attack",
	damage = "mobs_skeletons_skeleton_hurt",
	death = "mobs_skeletons_skeleton_death"
}

---
--- Functions
---

-- Used to calculate the damage per second
mobs_skeletons.fn_DamagePerSecond = function(self)

	-- direct sunlight returns full damage
	if sunlight then
		return 7
	end

	-- Constants
	local i_SECONDS_PER_DAY = 86400
	local i_SECONDS_PER_5_MINUTES = 300

	local i_hitPoints = self.health
	local i_timeSpeed = tonumber(minetest.settings:get("i_timeSpeed")) or 72

	if i_timeSpeed == 0 then
		i_timeSpeed = 1
	end

	local i_inGameDayLength = i_SECONDS_PER_DAY / i_timeSpeed
	local i_fiveInGameMinutes =
			(i_inGameDayLength * i_SECONDS_PER_5_MINUTES) / i_SECONDS_PER_DAY

	local i_damagePerSecond = i_hitPoints / i_fiveInGameMinutes

	return i_damagePerSecond
end


---
--- Arrow
---

-- Arrow item
minetest.register_craftitem("mobs_skeletons:arrow", {
	description = S("Rough Arrow"),
	inventory_image = "mobs_skeletons_arrow.png",
	groups = {not_in_creative_inventory = 1}
})

-- Arrow entity
mobs:register_arrow("mobs_skeletons:arrow", {
	visual = "wielditem",
	visual_size = {x = 0.25, y = 0.25},
	textures = {"mobs_skeletons:arrow"},
	velocity = 35,
	rotate = 0,
	drop = false,

	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 6},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 6},
		}, nil)
	end,

	hit_node = function(self, pos, node)
		self.object:remove()
	end
})

---
--- Skeleton Entities
---
-- Assume lion_skins is a table of lion textures
local skele_skins = {
  "skele.png",
  "skele2.png",
  "skele3.png",
  "skele4.png",
  "skele5.png",
  "skele6.png",
  "skele7.png",
  "skele8.png",
  "skele9.png",
  "skele10.png",
  "skele11.png",
  "skele12.png",
  "skele13.png",
  "skele15.png",
  "skele16.png",
}

local gskele_skins = {
  "skele14.png",
  "gbone.png",
  }
local function set_random_skele_texture_on_spawn(self)
    self.base_texture = skele_skins[math.random(#skele_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
local function set_random_gskele_texture_on_spawn(self)
    self.base_texture = gskele_skins[math.random(#gskele_skins)]
    self.object:set_properties({textures = {self.base_texture}})
end
mobs:register_mob("mobs_skeletons:skeleton", {
	type = "monster",
	hp_min = (minetest.PLAYER_MAX_HP_DEFAULT - 10),
	hp_max = (minetest.PLAYER_MAX_HP_DEFAULT + 10),
	walk_velocity = 2,
	run_velocity = 2.6,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 7,
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
	blood_amount = 0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = sounds,
	visual = "mesh",
	visual_size = {x = 2.7, y = 2.7},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	textures = {
		"default_tool_steelsword.png",
		skele_skins[1]},
	mesh = "mobs_skeletons_skeleton.b3d",
	animation = {
		stand_start = 0,
		stand_end = 40,
		stand_speed = 15,
		walk_start = 40,
		walk_end = 60,
		walk_speed = 15,
		run_start = 40,
		run_end = 60,
		run_speed = 30,
		shoot_start = 70,
		shoot_end = 90,
		punch_start = 110,
		punch_end = 130,
		punch_speed = 25,
		die_start = 160,
		die_end = 170,
		die_speed = 15,
		die_loop = false,
	},
	drops = {
		{name = "goblins:goblins_goblin_bone", chance = 3, min = 1, max = 2}
	},
    on_spawn = function(self)
        local random_texture = skele_skins[math.random(#skele_skins)]
        self.object:set_properties({textures = {"default_tool_steelsword.png", random_texture}})

        end
})

mobs:register_mob("mobs_skeletons:metalskeleton", {
	type = "monster",
	hp_min = 20,
	hp_max = 40,
	armor = 190,
	walk_velocity = 1,
	run_velocity = 1.3,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 7,
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
	blood_amount = 0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = sounds,
	visual = "mesh",
	visual_size = {x = 2.7, y = 2.7},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	textures = {
		"default_tool_steelsword.png",
		skele_skins[1]},
	mesh = "mobs_skeletons_skeleton.b3d",
	animation = {
		stand_start = 0,
		stand_end = 40,
		stand_speed = 15,
		walk_start = 40,
		walk_end = 60,
		walk_speed = 15,
		run_start = 40,
		run_end = 60,
		run_speed = 30,
		shoot_start = 70,
		shoot_end = 90,
		punch_start = 110,
		punch_end = 130,
		punch_speed = 25,
		die_start = 160,
		die_end = 170,
		die_speed = 15,
		die_loop = false,
	},
	drops = {
		{name = "default:gold_ingot", chance = 3, min = 1, max = 2},
		{name = "default:tin_ingot", chance = 3, min = 1, max = 2},
	},
    on_spawn = function(self)
        local random_texture = gskele_skins[math.random(#gskele_skins)]
        self.object:set_properties({textures = {"default_tool_steelsword.png", random_texture}})

        end
})
mobs:register_mob("mobs_skeletons:skeleton_archer", {
	type = "monster",
	hp_min = (minetest.PLAYER_MAX_HP_DEFAULT - 10),
	hp_max = (minetest.PLAYER_MAX_HP_DEFAULT + 10),
	walk_velocity = 4,
	run_velocity = 5.2,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 2,
	knock_back = true,
	fear_height = 6,
	fall_damage = true,
	lava_damage = 9999,
	light_damage = 1,
	light_damage_min = light_damage_min,
	light_damage_max = light_damage_max,
	suffocation = 0,
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
	blood_amount = 0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = sounds,
	visual = "mesh",
	visual_size = {x = 2.7, y = 2.7},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeletons_skeleton_archer.png"
	},
	mesh = "mobs_skeletons_skeleton_archer.b3d",
	animation = {
		stand_speed = 15,
		stand_start = 0,
		stand_end = 40,
		walk_speed = 15,
		walk_start = 40,
		walk_end = 60,
		run_speed = 30,
		shoot_start = 70,
		shoot_end = 90,
		die_start = 160,
		die_end = 170,
		die_speed = 15,
		die_loop = false,
	},
	drops = {
		{name = "bonemeal:bone", chance = 3, min = 1, max = 2}
	},

	on_spawn = function(self)
		self.light_damage = mobs_skeletons.fn_DamagePerSecond(self)
	end
})

mobs:register_mob("mobs_skeletons:skeleton_archer_dark", {
	type = "monster",
	hp_min = (minetest.PLAYER_MAX_HP_DEFAULT - 10),
	hp_max = (minetest.PLAYER_MAX_HP_DEFAULT + 10),
	walk_velocity = 4,
	run_velocity = 5.2,
	stand_chance = 50,
	walk_chance = 50,
	jump = true,
	jump_height = 1.1,
	stepheight = 1.1,
	pushable = true,
	view_range = 16,
	damage = 2,
	knock_back = true,
	fear_height = 6,
	fall_damage = true,
	lava_damage = 9999,
	light_damage = 1,
	light_damage_min = light_damage_min,
	light_damage_max = light_damage_max,
	suffocation = 0,
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
	blood_amount = 0,
	pathfinding = 1,
	makes_footstep_sound = true,
	sounds = sounds,
	visual = "mesh",
	visual_size = {x = 2.7, y = 2.7},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	textures = {
		"mobs_skeleton_bow.png",
		"mobs_skeletons_skeleton_archer_dark.png",
		"mobs_skeletons_skeleton_archer_dark_overlay.png"
	},
	mesh = "mobs_skeletons_skeleton_archer_dark.b3d",
	animation = {
		stand_speed = 15,
		stand_start = 0,
		stand_end = 40,
		walk_speed = 15,
		walk_start = 40,
		walk_end = 60,
		run_speed = 30,
		shoot_start = 70,
		shoot_end = 90,
		die_start = 160,
		die_end = 170,
		die_speed = 15,
		die_loop = false,
	},
	drops = {
		{name = "bonemeal:bone", chance = 3, min = 1, max = 2}
	},

	on_spawn = function(self)
		self.light_damage = mobs_skeletons.fn_DamagePerSecond(self)
	end
})


---
--- Skeletons spawning (check for custom spawn.lua)
---

local MP = minetest.get_modpath(minetest.get_current_modname()) .. "/"
local input = io.open(MP .. "spawn.lua", "r")

if input then
	input:close()
	input = nil
	dofile(MP .. "spawn.lua")
else


mobs:spawn({
	name = "mobs_skeletons:skeleton",
	nodes = {"default:sand"},
	neighbors = "air",
	chance = 5000,
	active_object_count = 2,
	min_height = -31000,
	max_height = 31000,
	max_light = 6,
})

end


---
--- Spawn Eggs
---

mobs:register_egg("mobs_skeletons:skeleton", S("Skeleton"),
		"mobs_skeletons_skeleton_egg.png")

mobs:register_egg("mobs_skeletons:skeleton_archer", S("Skeleton Archer"),
	"mobs_skeletons_skeleton_archer_egg.png")

mobs:register_egg("mobs_skeletons:skeleton_archer_dark", S("Dark Skeleton Archer"),
		"mobs_skeletons_skeleton_archer_dark_egg.png")


---
--- Aliases
---

mobs:alias_mob("mobs:skeleton", "mobs_skeletons:skeleton")
mobs:alias_mob("mobs:skeleton_archer", "mobs_skeletons:skeleton_archer")
mobs:alias_mob("mobs:dark_skeleton_archer", "mobs_skeletons:skeleton_archer_dark")


print("[MOD] Mobs Skeletons loaded")
