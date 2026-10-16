-- Stars drifting past: the ship isn't really moving, so each player gets
-- particle "stars" streaming aft just outside the hull. The hull hides them;
-- you see them through windows (or all around you on EVA). Navigation
-- health sets the speed - a failing nav system and the ship drifts.

local INTERVAL = 4
local SPAN_X = 90

local function speed()
	local nav = core.get_modpath("csd_tasks") and csd_tasks.get_system("navigation") or 100
	return (6 + 26 * nav / 100) * 0.3
end

local function spawn(player, minp, maxp, amount, v)
	-- (stars are slow now, so each lives longer on screen: half as many)
	amount = math.floor(amount * 0.5 * csd_core.particle_level(player:get_player_name()))
	if amount < 1 then return end
	core.add_particlespawner({
		amount = amount, time = INTERVAL, playername = player:get_player_name(),
		pos = {min = minp, max = maxp},
		vel = {min = vector.new(-v * 1.2, 0, 0), max = vector.new(-v * 0.8, 0, 0)},
		exptime = {min = SPAN_X * 2 / v * 0.5, max = SPAN_X * 2 / v},
		size = {min = 1.6, max = 3.6}, glow = 14, collisiondetection = false,
		texture = "csd_ship_star_streak.png", -- (alpha_tween made them invisible)
	})
end

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < INTERVAL then return end
	timer = 0
	local data = csd_ship.get_ship_data()
	if not data then return end
	local hmin, hmax = data.hull_min, data.hull_max
	local v = speed()
	for _, player in ipairs(core.get_connected_players()) do
		local p = player:get_pos()
		-- Particles start ahead (fore) and stream past towards the stern.
		local x0, x1 = p.x - SPAN_X * 0.2, p.x + SPAN_X
		-- mostly at window height (the hull's own span), a few above/below
		local ylo, yhi = hmin.y - 4, hmax.y + 4
		if csd_space and csd_space.player_in_vacuum(player:get_player_name()) then
			spawn(player, vector.new(x0, p.y - 60, p.z - 60), vector.new(x1, p.y + 60, p.z + 60), 160, v)
		else
			-- A dense stream right outside the player's own side, at their height:
			-- whatever window they look through has stars sliding past.
			local O = csd_ship.layout.origin
			for _, side in ipairs({1, -1}) do
				if (p.z - O.z) * side > -6 then
					local z0 = side > 0 and hmax.z + 2 or hmin.z - 26
					spawn(player, vector.new(p.x - 15, p.y - 3, z0), vector.new(p.x + 60, p.y + 7, z0 + 24), 380, v)
				end
			end
			if p.y > hmax.y - 9 then -- top deck: skylights
				spawn(player, vector.new(p.x - 15, hmax.y + 2, p.z - 20), vector.new(p.x + 60, hmax.y + 20, p.z + 20), 260, v)
			end
			-- Close to the hull (strong parallax past the windows) and further out.
			spawn(player, vector.new(x0, ylo, hmax.z + 2), vector.new(x1, yhi, hmax.z + 18), 420, v)   -- starboard, near
			spawn(player, vector.new(x0, ylo, hmax.z + 18), vector.new(x1, yhi, hmax.z + 70), 120, v * 0.6)
			spawn(player, vector.new(x0, ylo, hmin.z - 18), vector.new(x1, yhi, hmin.z - 2), 420, v)   -- port, near
			spawn(player, vector.new(x0, ylo, hmin.z - 70), vector.new(x1, yhi, hmin.z - 18), 120, v * 0.6)
			spawn(player, vector.new(x0, hmax.y + 2, hmin.z - 40), vector.new(x1, hmax.y + 40, hmax.z + 40), 160, v) -- above
			-- ahead of the bow, for the bridge windows
			if p.x > hmax.x - 60 then
				spawn(player, vector.new(hmax.x + 6, ylo, hmin.z - 30), vector.new(hmax.x + 120, yhi, hmax.z + 30), 60, v)
			end
		end
	end
end)
