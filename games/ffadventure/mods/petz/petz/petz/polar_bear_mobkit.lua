-- POLAR BEAR
--
mobs:register_mob('petz:polar_bear', {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	damage = 14,
	reach = 4,
	hp_min = 20,
	hp_max = 80,
	armor = 40,
	collisionbox = petz.get_collisionbox({x = -0.25, y = -0.5, z = -0.4375}, {x = 0.25, y = 0.125, z = 0.5}, 2.25, nil),
	selectionbox = petz.get_collisionbox({x = -0.25, y = -0.5, z = -0.4375}, {x = 0.25, y = 0.125, z = 0.5}, 2.25, nil),
	visual = petz.settings.visual,
	mesh = 'petz_polar_bear.b3d',
	textures = {"petz_polar_bear.png"},
	visual_size = {x = petz.settings.visual_size.x * 2.25, y = petz.settings.visual_size.y * 2.25},
	makes_footstep_sound = true,
	sounds = {
		misc = "petz_polar_bear_growl",
		attack = "petz_polar_bear_attack",
	},
	walk_velocity = 1.0,
	run_velocity = 4.6,  -- Doubled the original run speed
	jump = true,
	view_range = 10,
	drops = {
		{name = "animalia:leather", chance = 15, min = 2, max = 4},
		{name = "animalia:venison_raw", chance = 25, min = 2, max = 6},
		{name = "petz:bone", chance = 10, min = 1, max = 5},
	},
	lava_damage = 5,
	light_damage = 0,
	fall_damage = 2,
	water_damage = 0,
	animation = {
		speed_normal = 25,
		speed_run = 25,
		stand_start = 26,
		stand_end = 46,
		walk_start = 1,
		walk_end = 12,
		run_start = 13,
		run_end = 25,
		punch_start = 47,
		punch_end = 59,
	},
})

mobs:register_spawn("petz:polar_bear", {"default:ice", "default:snow", "default:snowblock"}, 15, 0, 60000, 5, 31000)
