-- Laser turrets on the hull. Shooting asteroids at a weapons console makes
-- the nearest turret fire: a beam out into space and an explosion, with
-- sound - visible through the windows of the Weapons Bay.

local S = csd_ship.S

core.register_node("csd_ship:laser_turret", {
	description = S("Laser Turret"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {
		{-0.45, -0.5, -0.45, 0.45, -0.1, 0.45},   -- base
		{-0.25, -0.1, -0.25, 0.25, 0.25, 0.25},   -- head
		{-0.07, 0.0, -0.5, 0.07, 0.14, -0.25},    -- barrel
	}},
	tiles = {"csd_ship_turret.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 3,
	groups = {cracky = 1, csd_ship = 1},
	is_ground_content = false,
})

local function turrets()
	local data = csd_ship.get_ship_data()
	return data and data.turrets or {}
end

local function beam(from, to)
	local d = vector.distance(from, to)
	local dir = vector.direction(from, to)
	for k = 0, math.floor(d), 1 do
		core.add_particle({
			pos = vector.add(from, vector.multiply(dir, k)),
			expirationtime = 0.25 + k * 0.004, size = 2.2, glow = 14,
			texture = "csd_ship_laser.png",
		})
	end
end

local function explode(pos)
	core.add_particlespawner({
		amount = 40, time = 0.2, pos = pos,
		vel = {min = vector.new(-6, -6, -6), max = vector.new(6, 6, 6)},
		exptime = {min = 0.4, max = 1.0}, size = {min = 2, max = 6}, glow = 14,
		texture = "csd_ship_explosion.png",
	})
	core.add_particlespawner({
		amount = 14, time = 0.2, pos = pos,
		vel = {min = vector.new(-4, -4, -4), max = vector.new(4, 4, 4)},
		exptime = 3, size = {min = 2, max = 4}, texture = "csd_tasks_asteroid.png",
	})
	core.sound_play("csd_sfx_explosion", {pos = pos, gain = 0.8, max_hear_distance = 120}, true)
end

if core.get_modpath("csd_tasks") then
	table.insert(csd_tasks.on_asteroid_shot, function(sess)
		local best, bd
		for _, t in ipairs(turrets()) do
			local d = vector.distance(t.pos, sess.pos)
			if not bd or d < bd then best, bd = t, d end
		end
		if not best then return end
		local out = vector.normalize(vector.add(best.out, vector.new((math.random() - 0.5) * 0.8, (math.random() - 0.6) * 0.5, (math.random() - 0.5) * 0.8)))
		local target = vector.add(best.pos, vector.multiply(out, 25 + math.random() * 30))
		beam(vector.add(best.pos, vector.multiply(best.out, 0.6)), target)
		core.sound_play("csd_sfx_laser", {pos = best.pos, gain = 0.7, max_hear_distance = 100}, true)
		core.sound_play("csd_sfx_laser", {to_player = sess.name, gain = 0.25}, true)
		core.after(0.25, function()
			explode(target)
			core.sound_play("csd_sfx_explosion", {to_player = sess.name, gain = 0.2}, true)
		end)
	end)
end

-- Rocks tumbling past during an asteroid storm.
local storm_timer = 0
core.register_globalstep(function(dtime)
	storm_timer = storm_timer + dtime
	if storm_timer < 1 then return end
	storm_timer = 0
	local a = core.global_exists("csd_events") and csd_events.active
	if not (a and a.id == "asteroid_storm") then return end
	local data = csd_ship.get_ship_data()
	if not data then return end
	for _, player in ipairs(core.get_connected_players()) do
		local p = player:get_pos()
		local amount = math.floor(12 * csd_core.particle_level(player:get_player_name()))
		if amount > 0 then
			for _, side in ipairs({1, -1}) do
				local z0 = side > 0 and data.hull_max.z + 3 or data.hull_min.z - 30
				core.add_particlespawner({
					amount = amount, time = 1, playername = player:get_player_name(),
					pos = {min = vector.new(p.x + 30, p.y - 6, z0), max = vector.new(p.x + 60, p.y + 10, z0 + 27)},
					vel = {min = vector.new(-30, -3, -3), max = vector.new(-18, 3, 3)},
					exptime = 4, size = {min = 3, max = 8}, texture = "csd_tasks_asteroid.png",
				})
			end
		end
	end
end)

-- Generator helper: a turret on the outside of the hull, firing along `out`.
function csd_ship.place_turret(b, x, y, z, out)
	b:set(x, y, z, "csd_ship:laser_turret", core.dir_to_facedir(vector.multiply(out, -1), true))
	b.turrets = b.turrets or {}
	b.turrets[#b.turrets + 1] = {pos = b:abs(x, y, z), out = out}
end
