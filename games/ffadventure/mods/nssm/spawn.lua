--Before starting a new game write 6 or 7 in order to regulate the spawns
-- (7 works also with flat and fractal).

local v6 = nssm.mymapgenis == 6 -- true if set to 6
local mm = nssm.multimobs

-- Spawning parameters

if mm ~= 0 then

	-- V6 MAPGEN

	if v6 then

		-- ANTS (why only V6 mapgen ?)

		mobs:spawn({
			name = "nssm:ant_queen",
			nodes = {"nssm:ant_dirt"},
			interval = 60,
			chance = (200000 / mm)
		})

		mobs:spawn({
			name = "nssm:ant_soldier",
			nodes = {"nssm:ant_dirt"},
			interval = 7,
			chance = (30000 / mm),
			active_object_count = 4
		})

		mobs:spawn({
			name = "nssm:ant_worker",
			nodes = {"nssm:ant_dirt"},
			interval = 5,
			chance = (10000 / mm),
			active_object_count = 5
		})

	else -- ALL OTHER MAPGENS


	-- SEA

	mobs:spawn({
		name = "nssm:crab",
		nodes = {"default:sand"},
		neighbors = {"default:water_source"},
		interval = 60,
		chance = (4000000 / mm)
	})

	mobs:spawn({
		name = "nssm:crocodile",
		nodes = {"default:sand","default:water_source"},
		neighbors = {"default:water_source"},
		interval = 100,
		chance = (35000000 / mm)
	})

	mobs:spawn({
		name = "nssm:crocodile",
		nodes = {"default:sand","default:river_water_source"},
		neighbors = {"default:river_water_source"},
		interval = 60,
		chance = (12000000 / mm)
	})

	-- DESERT

	mobs:spawn({
		name = "nssm:sandworm",
		nodes = {"default:desert_sand", "default:desert_stone"},
		interval = 100,
		chance = (28000000 / mm)
	})

	mobs:spawn({
		name = "nssm:giant_sandworm",
		nodes = {"default:desert_sand", "default:desert_stone"},
		interval = 400,
		chance = (600000000 / mm)
	})
end
end