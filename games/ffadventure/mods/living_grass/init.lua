-- living_grass/init.lua


-- Namespace
living_grass = {}

-- flower spread has interval 13, chance 300
grow_interval = 20
grow_chance = 500
dry_interval = 40
dry_chance = 1500
regrow_interval = 40
regrow_chance = 800
death_interval = 60
death_chance = 1800


-- GROW
-- Grow grass_1 to grass_2
core.register_abm({
	label = "Grass 1 to 2",
	nodenames = {"default:grass_1"},
	interval = grow_interval,
	chance = grow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_2"})
	end,
})

-- Grow grass_2 to grass_3
core.register_abm({
	label = "Grass 2 to 3",
	nodenames = {"default:grass_2"},
	interval = grow_interval,
	chance = grow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_3"})
	end,
})

-- Grow grass_3 to grass_4
core.register_abm({
	label = "Grass 3 to 4",
	nodenames = {"default:grass_3"},
	interval = grow_interval,
	chance = grow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_4"})
	end,
})

-- Grow grass_4 to grass_5
core.register_abm({
	label = "Grass 4 to 5",
	nodenames = {"default:grass_4"},
	interval = grow_interval,
	chance = grow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_5"})
	end,
})


-- DRY
-- Dry grass_2
core.register_abm({
	label = "Dry Grass 2",
	nodenames = {"default:grass_2"},
	interval = dry_interval,
	chance = dry_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:dry_grass_1"})
	end,
})

-- Dry grass_3
core.register_abm({
	label = "Dry Grass 3",
	nodenames = {"default:grass_3"},
	interval = dry_interval,
	chance = dry_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:dry_grass_2"})
	end,
})

-- Dry grass_4
core.register_abm({
	label = "Dry Grass 4",
	nodenames = {"default:grass_4"},
	interval = dry_interval,
	chance = dry_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:dry_grass_3"})
	end,
})

-- Dry grass_5
core.register_abm({
	label = "Dry Grass 5",
	nodenames = {"default:grass_5"},
	interval = dry_interval,
	chance = dry_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:dry_grass_4"})
	end,
})

-- REGROW
-- Regrow dry_grass_1
core.register_abm({
	label = "Regrow Dry Grass 1",
	nodenames = {"default:dry_grass_1"},
	neighbors = {"default:dirt_with_grass"},
	interval = regrow_interval,
	chance = regrow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_1"})
	end,
})

-- Regrow dry_grass_2
core.register_abm({
	label = "Regrow Dry Grass 2",
	nodenames = {"default:dry_grass_2"},
	neighbors = {"default:dirt_with_grass"},
	interval = regrow_interval,
	chance = regrow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_1"})
	end,
})

-- Regrow dry_grass_3
core.register_abm({
	label = "Regrow Dry Grass 3",
	nodenames = {"default:dry_grass_3"},
	neighbors = {"default:dirt_with_grass"},
	interval = regrow_interval,
	chance = regrow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_2"})
	end,
})

-- Regrow dry_grass_4
core.register_abm({
	label = "Regrow Dry Grass 4",
	nodenames = {"default:dry_grass_4"},
	neighbors = {"default:dirt_with_grass"},
	interval = regrow_interval,
	chance = regrow_chance,
	action = function(pos)
		core.set_node(pos, {name = "default:grass_2"})
	end,
})

-- DIE
-- Kill dry_grass on normal grass blocks
core.register_abm({
	label = "Kill Dry Grass",
	nodenames = {"group:dry_grass"},
	neighbors = {"default:dirt_with_grass"},
	interval = death_interval,
	chance = death_chance,
	action = function(pos)
		core.set_node(pos, {name = "air"})
	end,
})
