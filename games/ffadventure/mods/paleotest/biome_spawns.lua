-- paleotest/biome_spawns.lua
-- Biome-aware mob spawning using mobs:spawn() with heat/humidity filters.
-- Replaces the old mobs:register_spawn() block that had no climate constraints.
-- Heat: 0=arctic, 50=temperate, 100=tropical.  Humidity: 0=arid, 100=saturated.
--
-- `foreign = true` is required on every entry. paleotest's dinosaurs are mobkit
-- entities, registered with core.register_entity(), never mobs:register_mob() --
-- and mobs:spawn_specific() used to bail out immediately for any name missing
-- from mobs.spawning_mobs. Every call in this file was silently a no-op until
-- creaturemob added the flag, so these spawns have never actually run: treat the
-- chances below as untested and tune them against observed density.

-- ============================================================
-- Dinosaurs
-- ============================================================

-- Brachiosaurus: Jurassic tropical/subtropical, warm and humid
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:brachiosaurus",
	nodes             = {"default:dirt_with_rainforest_litter", "livingjungle:jungleground",
	                     "aotearoa:dirt_with_dark_litter", "naturalbiomes:savannalitter"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 20000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 60,
	max_heat          = 100,
	min_humidity      = 55,
	max_humidity      = 100,
})

-- Carnotaurus: Late Cretaceous South America, warm semi-arid scrubland
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:carnotaurus",
	nodes             = {"naturalbiomes:savannalitter", "naturalbiomes:mediterranean_litter",
	                     "default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 55,
	max_heat          = 90,
	min_humidity      = 15,
	max_humidity      = 55,
})

-- Stegosaurus: Late Jurassic warm temperate/subtropical grasslands
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:stegosaurus",
	nodes             = {"default:dirt_with_grass", "naturalbiomes:mediterranean_litter",
	                     "naturalbiomes:savannalitter", "default:dirt_with_dry_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 45,
	max_heat          = 80,
	min_humidity      = 30,
	max_humidity      = 70,
})

-- Spinosaurus: Cretaceous North Africa, tropical riparian/swamp specialist
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:spinosaurus",
	nodes             = {"swamp:dirt_with_swamp_grass", "default:sand", "default:mud",
	                     "default:dirt_with_rainforest_litter"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 20000,
	active_object_count = 2,
	min_height        = -10,
	max_height        = 31000,
	min_heat          = 70,
	max_heat          = 100,
	min_humidity      = 60,
	max_humidity      = 100,
})

-- Triceratops: Late Cretaceous, warm humid subtropical forests and plains
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:triceratops",
	nodes             = {"default:dirt_with_grass", "naturalbiomes:savannalitter",
	                     "naturalbiomes:mediterranean_litter", "aotearoa:dirt_with_dark_litter",
	                     "default:dirt_with_dry_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 50,
	max_heat          = 85,
	min_humidity      = 35,
	max_humidity      = 80,
})

-- Tyrannosaurus: Late Cretaceous warm temperate/subtropical (rare apex predator)
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:tyrannosaurus",
	nodes             = {"swamp:dirt_with_swamp_grass", "naturalbiomes:savannalitter",
	                     "aotearoa:dirt_with_dark_litter", "naturalbiomes:mediterranean_litter",
	                     "default:dirt_with_dry_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 22000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 50,
	max_heat          = 88,
	min_humidity      = 30,
	max_humidity      = 75,
})

-- Velociraptor: Late Cretaceous Gobi Desert, semi-arid open terrain, pack hunter
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:velociraptor",
	nodes             = {"default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass",
	                     "badlands:red_sand", "naturalbiomes:savannalitter",
	                     "default:sand"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 16000,
	active_object_count = 3,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 60,
	max_heat          = 100,
	min_humidity      = 5,
	max_humidity      = 45,
})

-- ============================================================
-- Reptiles / Flying
-- ============================================================

-- Pteranodon: Late Cretaceous coastal/inland warm areas (no spawn registration previously)
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:pteranodon",
	nodes             = {"default:sand", "default:dirt_with_grass",
	                     "naturalbiomes:savannalitter", "default:dirt_with_dry_grass",
	                     "naturalbiomes:mediterranean_litter"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 20000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 50,
	max_heat          = 90,
	min_humidity      = 20,
	max_humidity      = 70,
})

-- Quetzalcoatlus: Late Cretaceous inland semi-arid, largest flying animal
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:quetzalcoatlus",
	nodes             = {"badlands:red_sand", "default:dry_dirt_with_dry_grass",
	                     "aotearoa:volcanic_sand", "naturalbiomes:savannalitter",
	                     "default:sand"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 22000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 55,
	max_heat          = 95,
	min_humidity      = 5,
	max_humidity      = 50,
})

-- Sarcosuchus: Early Cretaceous tropical river systems, ambush crocodilian
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:sarcosuchus",
	nodes             = {"default:water_source", "swamp:dirt_with_swamp_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = -10,
	max_height        = 31000,
	min_heat          = 70,
	max_heat          = 100,
	min_humidity      = 65,
	max_humidity      = 100,
})

-- ============================================================
-- Aquatic
-- ============================================================

-- Dunkleosteus: Devonian armoured fish, warm shallow to open seas
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:dunkleosteus",
	nodes             = {"default:water_source"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 5,
	chance            = 18000,
	active_object_count = 2,
	min_height        = -31000,
	max_height        = 0,
	min_heat          = 35,
	max_heat          = 80,
})

-- Plesiosaurus: Jurassic/Cretaceous open seas, cool to warm waters
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:plesiosaurus",
	nodes             = {"default:water_source"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 5,
	chance            = 20000,
	active_object_count = 2,
	min_height        = -31000,
	max_height        = 0,
	min_heat          = 20,
	max_heat          = 75,
})

-- ============================================================
-- Pleistocene Mammals
-- ============================================================

-- Dire Wolf: Pleistocene North/South America, temperate grasslands and forests
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:dire_wolf",
	nodes             = {"default:dirt_with_grass", "naturalbiomes:mediterranean_litter",
	                     "naturalbiomes:savannalitter", "default:dirt_with_dry_grass",
	                     "default:dirt_with_coniferous_litter"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 15000,
	active_object_count = 3,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 15,
	max_heat          = 60,
	min_humidity      = 25,
	max_humidity      = 70,
})

-- Elasmotherium: Pleistocene Eurasian cold steppe giant rhinoceros
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:elasmotherium",
	nodes             = {"default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass",
	                     "naturalbiomes:mediterranean_litter", "naturalbiomes:savannalitter",
	                     "naturalbiomes:bushland_bushlandlitter",
	                     "livingdesert:coldsteppe_ground"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 10,
	max_heat          = 50,
	min_humidity      = 10,
	max_humidity      = 50,
})

-- Mammoth: Pleistocene cold tundra, steppe and boreal grasslands
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:mammoth",
	nodes             = {"default:dirt_with_snow", "default:snow",
	                     "default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 16000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 0,
	max_heat          = 35,
	min_humidity      = 10,
	max_humidity      = 55,
})

-- Smilodon: Pleistocene warm to temperate grasslands and savannas
mobs:spawn({
	foreign           = true,   -- mobkit entity, not registered via mobs:register_mob
	name              = "paleotest:smilodon",
	nodes             = {"default:dirt_with_grass", "default:dirt_with_dry_grass",
	                     "default:dry_dirt_with_dry_grass", "naturalbiomes:savannalitter",
	                     "naturalbiomes:mediterranean_litter"},
	neighbors         = {"air"},
	min_light         = 0,
	max_light         = 15,
	chance            = 18000,
	active_object_count = 2,
	min_height        = 1,
	max_height        = 31000,
	min_heat          = 30,
	max_heat          = 75,
	min_humidity      = 10,
	max_humidity      = 55,
})
