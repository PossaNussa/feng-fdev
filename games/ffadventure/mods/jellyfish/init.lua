-- Minetest mod: jellyfish
-- (c) Kai Gerd Müller — See README.txt for licensing.

minetest.register_craftitem("jellyfish:jelly", {
	description = "Jelly",
	inventory_image = "jelly.png",
	on_use = minetest.item_eat(10),
})

local FLY_IN = {
	"default:water_source",
	"default:water_flowing",
	"default:river_water_source",
	"default:river_water_flowing",
}

local function register_jellyfish(def)
	local name   = def.name
	local size   = def.size
	local defbox = size / 2
	local speed  = def.speed or 2
	local side2  = name .. "3.png"
	local side   = name .. "2.png"
	local front  = name .. "1.png"

	mobs:register_mob("jellyfish:" .. name, {
		type         = "monster",
		passive      = false,
		attack_type      = "dogfight",
		reach            = math.max(0.5, size * 2),
		attack_monsters  = true,
		damage           = def.damage,
		hp_min       = def.max_hp,
		hp_max       = def.max_hp,
		armor        = 100,
		collisionbox = {-defbox, -defbox, -defbox, defbox, defbox, defbox},
		visual       = "cube",
		visual_size  = {x = size, y = size},
		textures     = {{side, side, front, "empty.png", side2, side}},
		makes_footstep_sound = false,
		sounds       = {},
		fly          = true,
		fly_in       = FLY_IN,
		fall_speed   = 0,
		floats       = 0,
		jump         = false,
		walk_velocity = speed * 0.6,
		run_velocity  = speed,
		view_range   = 20,
		water_damage = 0,
		air_damage   = 1,
		lava_damage  = 4,
		light_damage = 0,
		glow         = 3,
		drops = {
			{name = "jellyfish:jelly", chance = 1, min = 1, max = 3},
		},
		animation = {
			speed_normal = 0,
			stand_start  = 0, stand_end  = 0,
			walk_start   = 0, walk_end   = 0,
			run_start    = 0, run_end    = 0,
		},
	})

	mobs:spawn({
		name       = "jellyfish:" .. name,
		nodes      = {"default:water_source"},
		min_light  = 0,
		max_light  = 14,
		interval   = 60,
		chance     = def.chanche,
		min_height = -200,
		max_height = 0,
		min_heat   = 20,
	})
end

-- Chances scaled for 60s interval (was 3000s).
-- 3000/60=50 → divide old chance by 50, then halve again for desired frequency.
-- Rare (old 80000→800), medium (old 40000→400), common (old 20000→200).
register_jellyfish({ name = "a", size = 0.25, max_hp = 5,  damage = 5, chanche = 800, speed = 3   })
register_jellyfish({ name = "b", size = 0.3,  max_hp = 7,  damage = 4, chanche = 400, speed = 2   })
register_jellyfish({ name = "c", size = 0.5,  max_hp = 12, damage = 2, chanche = 200, speed = 2   })
register_jellyfish({ name = "d", size = 0.25, max_hp = 5,  damage = 1, chanche = 200, speed = 2   })
register_jellyfish({ name = "e", size = 0.2,  max_hp = 5,  damage = 5, chanche = 800, speed = 1.5 })
register_jellyfish({ name = "f", size = 0.1,  max_hp = 2,  damage = 4, chanche = 400, speed = 1   })
register_jellyfish({ name = "g", size = 0.75, max_hp = 10, damage = 2, chanche = 200, speed = 2.5 })
register_jellyfish({ name = "h", size = 0.75, max_hp = 10, damage = 5, chanche = 800, speed = 3   })
