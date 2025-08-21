lottmobs = {}
lottmobs.connected_player_names = {}
lottmobs.player_guards = {}


minetest.register_on_joinplayer(function(player)
                lottmobs.connected_player_names[player:get_player_name()] = true
end)

minetest.register_on_leaveplayer(function(player)
                lottmobs.connected_player_names[player:get_player_name()] = nil
end)

minetest.register_globalstep(function(dtime)
                lottmobs.do_guard_hunger(dtime)
end)



dofile(minetest.get_modpath("lottmobs").."/functions.lua")
dofile(minetest.get_modpath("lottmobs").."/craftitems.lua")
dofile(minetest.get_modpath("lottmobs").."/elves.lua")
dofile(minetest.get_modpath("lottmobs").."/dwarves.lua")
dofile(minetest.get_modpath("lottmobs").."/trader_goods.lua")
dofile(minetest.get_modpath("lottmobs").."/trader.lua")
dofile(minetest.get_modpath("lottmobs").."/special_mobs.lua")

-- Mobs

mobs:register_mob("lottmobs:nune_guard", {
        type = "npc",
        race = "GAMEman",
	hp_min = 20,
	hp_max = 30,
	collisionbox = {-0.3,-1.0,-0.3, 0.3,0.8,0.3},
	textures = {
		{"lottmobs_rohan_guard.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
		{"lottmobs_rohan_guard_1.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
		{"lottmobs_rohan_guard_2.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
		{"lottmobs_rohan_guard_3.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png", "lottarmor_trans.png"},
	},
	visual = "mesh",
	mesh = "lottarmor_character.b3d",
	makes_footstep_sound = true,
	view_range = 12,
    game_name = "Default Name",
    order = "stand",
    whitelist = {},
    blacklist = {},
	walk_velocity = 2,
	run_velocity = 3.5,
	armor = 100,
	damage = 5,
	drops = {
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
	light_resistant = true,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 10,
	attack_monsters = true,
	light_damage = 0,
	attack_type = "dogfight",
	follow = "x_farming:corn",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189,
		punch_end = 198,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "default_punch2",
	},
on_rightclick = function(self, clicker)
    -- Additional checks or initializations if needed
    lottmobs.guard(self, clicker, "default:gold_ingot", "Human", "human")
end,
	do_custom = lottmobs.do_custom_guard,
	attack_animals = false,
	attack_npcs = false,
	group_attack = true,
	step = 1,
	on_die = lottmobs.guard_die,
})
mobs:register_spawn("lottmobs:nune_guard", {"default:dirt_with_grass"}, 20, -1, 80000, 3, 31000)
lottmobs.register_guard_craftitem("lottmobs:nune_guard", "Nune Guard", "lottmobs_rohan_guard_inv.png")

mobs:register_mob("lottmobs:troll", {
	type = "npc",
        race = "GAMEorc",
        hp_min = 50,
	hp_max = 65,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.6, 0.7},
	visual = "mesh",
	mesh = "troll_model.x",
	textures = {
		{"lottmobs_troll.png"},
		{"lottmobs_troll_1.png"},
		{"lottmobs_troll_2.png"},
		{"lottmobs_troll_3.png"},
	},
	visual_size = {x=8, y=8},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 1,
	damage = 10,
	armor = 100,
	drops = {
		{name = "default:stone",
		chance = 5,
		min = 1,
		max = 7,},
		{name = "default:axe_steel",
		chance = 10,
		min = 1,
		max = 1,},
		{name = "default:axe_bronze",
		chance = 10,
		min = 1,
		max = 1,},
	},
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 60,
	on_rightclick = nil,
        do_custom = lottmobs.do_custom_guard,
	attack_type = "dogfight",
	animation = {
		stand_start = 0,
		stand_end = 19,
		walk_start = 20,
		walk_end = 35,
		punch_start = 36,
		punch_end = 48,
		speed_normal = 15,
		speed_run = 15,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_barbarian_yell1",
		death = "mobs_barbarian_yell1",
		attack = "mobs_stone_death",
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
})
-- mobs:register_spawn("lottmobs:troll", {"default:stone", "default:dry_dirt_with_dry_grass", "group:soil", "default:grass"}, 2, -1, 98000, 1, -10)
mobs:spawn({
    name = "lottmobs:troll",
    nodes = {"default:stone", "default:dry_dirt_with_dry_grass", "group:soil", "default:grass"},
    min_light = 0,
    max_light = 7, -- 14
    chance = 182000,
    active_object_count = 3,
})
-- Arrows

mobs:register_mob("lottmobs:mung_guard", {
	type = "npc",
	race = "mung",
	hp_min = 20,
	hp_max = 30,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 1.94, 0.3},  -- Same collision box as the villager
	textures = {
		{"mobs_mc_villager.png"},  -- Using the same texture as mobs_mc:villager
	},
	visual = "mesh",
	mesh = "mobs_mc_villager.b3d",  -- Using the same model as mobs_mc:villager
	makes_footstep_sound = true,
	view_range = 12,
	walk_velocity = 2,
	run_velocity = 3.5,
	armor = 100,
	damage = 5,
	drops = {
		{name = "default:stone", chance = 7, min = 1, max = 5,},
		{name = "default:wood", chance = 10, min = 1, max = 3,},
		{name = "default:stick", chance = 15, min = 2, max = 5,},
		{name = "default:flint", chance = 20, min = 1, max = 3,},
		{name = "spears:spear_wood", chance = 25, min = 1, max = 1,},
		{name = "spears:spear_stone", chance = 30, min = 1, max = 1,},
		{name = "default:bone", chance = 35, min = 1, max = 2,},
	},
	light_resistant = true,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 10,
	light_damage = 0,
	attack_monsters = true,
	attack_type = "dogfight",
	follow = "default:apple",
	animation = {
		stand_start = 0, stand_end = 0,
		walk_start = 0, walk_end = 40, walk_speed = 25,
		run_start = 0, run_end = 40, run_speed = 25,
		head_shake_start = 60, head_shake_end = 70, head_shake_loop = false,
		head_nod_start = 50, head_nod_end = 60, head_nod_loop = false,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_die_yell",
		death = "default_death",
		attack = "default_punch2",
	},
	attacks_monsters = true,
	peaceful = false,
	group_attack = true,
	step = 1,
	on_rightclick = function(self, clicker)
		-- Use the same function as Nune Guard, with no changes
		lottmobs.guard(self, clicker, "default:ruby", "Mung", "mung_trader")
	end,
	do_custom = lottmobs.do_custom_guard,
	attack_animals = false,
	attack_npcs = false,
	on_die = lottmobs.guard_die,
})
mobs:register_spawn("lottmobs:mung_guard", {"default:dirt_with_grass", "default:sand"}, 20, -1, 80000, 3, 31000)


mobs:register_arrow("lottmobs:darkball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"lottmobs_darkball.png"},
	velocity = 5,
	hit_player = function(self, player)
		local s = self.object:get_pos()
		local p = player:get_pos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=4},
		}, vec)
		local pos = self.object:get_pos()
                local node1def = minetest.get_node(pos)
                local n = node1def.name
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                                        local node2def = minetest.get_node(p)
                                        local n2 = node2def.name
					if minetest.registered_nodes[n].groups.flammable or n2 == "air" then
						minetest.set_node(p, {name="fire:basic_flame"})
					end
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
                local node1def = minetest.get_node(pos)
                local n = node1def.name
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                                        local node2def = minetest.get_node(p)
                                        local n2 = node2def.name
					if minetest.registered_nodes[n].groups.flammable or n2 == "air" then
						minetest.set_node(p, {name="fire:basic_flame"})
					end
				end
			end
		end
	end
})


mobs:register_mob("lottmobs:battle_troll", {
	type = "npc",
        race = "GAMEorc",
        hp_min = 45,
	hp_max = 60,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.6, 0.7},
	visual = "mesh",
	mesh = "troll_model.x",
	textures = {
		{"lottmobs_battle_troll.png"},
	},
	visual_size = {x=8, y=8},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 1,
	damage = 6,
	drops = {
		{name = "bones:bone",
		chance = 5,
		min = 1,
		max = 5,},
		{name = "tinkering:steel_axe",
		chance = 10,
		min = 1,
		max = 1,},
		{name = "tinkering:bronze_axe",
		chance = 10,
		min = 1,
		max = 5,},
		{name = "tinkering:silver_axe",
		chance = 10,
		min = 1,
		max = 5,},
		{name = "tinkering:copper_axe",
		chance = 10,
		min = 1,
		max = 5,},
	},
	light_resistant = true,
	armor = 100,
	drawtype = "front",
	water_damage = 5,
	lava_damage = 1,
	light_damage = 0,
	on_rightclick = nil,
        do_custom = lottmobs.do_custom_guard,
	attack_type = "dogfight",
	animation = {
		stand_start = 0,
		stand_end = 19,
		walk_start = 20,
		walk_end = 35,
		punch_start = 36,
		punch_end = 48,
		speed_normal = 15,
		speed_run = 15,
	},
	jump = true,
	sounds = {
		war_cry = "mobs_barbarian_yell1",
		death = "mobs_howl",
		attack = "mobs_stone_death",
	},
	attacks_monsters = true,
	peaceful = true,
	group_attack = true,
	step = 1,
})
mobs:register_spawn("lottmobs:battle_troll", {"default:dry_dirt_with_grass"}, 10, -1, 200000, 5, 31000)