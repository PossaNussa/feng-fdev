-- The warning system, which says nothing.
--
-- A tornado that simply appears is a random death; one that spends five minutes
-- telling you it is coming is a decision about whether to finish the roof or get
-- in the cellar. But nothing here is written in words. The storm announces
-- itself the way a real one does, through things the player already knows how to
-- read from the wind system:
--
--   1. the wind dies.       The sails go slack, the wind particles stop, the
--                           ambient wind loop fades. Dead calm is the first
--                           tell, and it is an absence, so it is unsettling.
--   2. the light goes.      Green-black sky and cloud, via climate_api.
--   3. the air starts to    Dust, leaf litter and grit lift off the ground and
--      move the wrong way.  stream *towards* the storm, all of it pointing the
--                           same way. That direction is the bearing; it is the
--                           only "message" this mod sends, and it is a picture.
--   4. you can see it.      The funnel spawns upwind at a distance and walks in,
--                           roaring, for the better part of a minute before it
--                           can reach anyone.
--
-- Most supercells stop after stage 3. tornado_funnel_chance decides, and it is
-- rolled at the start so the whole storm can be written towards it.

local S = tornado.settings

local PHASE = { WATCH = 1, ACTIVE = 2 }
tornado.PHASE = PHASE

local SCAN_INTERVAL = 15
local TICK_INTERVAL = 1
local TELEGRAPH_INTERVAL = 0.25
local CALM_FRACTION = 0.55   -- how much of the watch is spent dead still
local FIZZLE_COOLDOWN = 0.35 -- share of the cooldown a storm with no funnel costs

tornado.event = nil
local cooldown_until = 0

-- Dirt, leaf and straw. Everything the wind can pick up off a field.
local LITTER = {
	"tornado_dust.png^[colorize:#4a4238:175",
	"tornado_dust.png^[colorize:#5d7238:150",
	"tornado_dust.png^[colorize:#8a7a52:145",
	"tornado_dust.png^[colorize:#6b6156:160",
}

local function nearby(pos)
	return tornado.players_near(pos, S.alert_radius)
end

--------------------------------------------------------------------------------
-- how strongly a given player is inside the event
--------------------------------------------------------------------------------

-- 0 none, 1 the sky is turning, 2 it is close, 3 the funnel is on top of you.
-- Called from the weather presets on every climate tick, so it stays cheap.
function tornado.alert_level(player)
	local event = tornado.event
	if not event or not player then return 0 end
	local pos = player:get_pos()
	if not pos then return 0 end

	if event.phase == PHASE.ACTIVE then
		local _, dist = tornado.nearest_funnel(pos)
		if dist and dist < 90 then return 3 end
	end

	if vector.distance(pos, event.epicenter) > S.alert_radius then return 0 end
	if event.phase == PHASE.ACTIVE then return 2 end
	return (event.t / S.watch_time > 0.75) and 2 or 1
end

--------------------------------------------------------------------------------
-- the wind during an event
--------------------------------------------------------------------------------

-- A supercell drags the whole wind field with it. Forcing climate_api's wind
-- means the rain slant, the cloud drift, the sails, sum_air_currents' push, its
-- particles and its sound loop all move together -- which is what turns the
-- dead calm and the inflow that follows it into something a player can notice
-- without being told.
local saved_wind, wind_forced = nil, false

local function force_wind(dir, strength)
	if not S.force_wind or not minetest.global_exists("climate_mod") then return end
	if not wind_forced then
		saved_wind = climate_mod.forced_enviroment.wind
		wind_forced = true
	end
	climate_mod.forced_enviroment.wind = vector.new(dir.x * strength, 0, dir.z * strength)
end

local function release_wind()
	if not wind_forced then return end
	climate_mod.forced_enviroment.wind = saved_wind
	wind_forced, saved_wind = false, nil
end

--------------------------------------------------------------------------------
-- the telegraph: litter in the air, pointing at the storm
--------------------------------------------------------------------------------

-- What the ground here is made of, so the litter matches it: grass flecks over
-- a field, sand over dunes, snow over tundra. One node lookup per player per
-- quarter second.
local function ground_material(ppos)
	local ground = tornado.ground_y(ppos.x, ppos.z, ppos.y)
	if not ground then return nil end
	local node = minetest.get_node({
		x = math.floor(ppos.x + 0.5), y = ground, z = math.floor(ppos.z + 0.5) })
	local def = minetest.registered_nodes[node.name]
	if not def or not def.walkable or def.drawtype == "airlike" then return nil end
	if def.liquidtype and def.liquidtype ~= "none" then return nil end
	return { name = node.name, param2 = node.param2 }
end

-- Everything loose gets drawn towards the storm. Early on that is a few motes
-- hanging almost still in dead air; by the end it is a stream of grit all
-- running the same way, and the way it runs is where the funnel is.
local function telegraph()
	local event = tornado.event
	if not event or S.particles <= 0 then return end

	local fraction = math.min(1, event.t / S.watch_time)
	local calm = event.phase == PHASE.WATCH and fraction < CALM_FRACTION

	for _, player in ipairs(nearby(event.epicenter)) do
		local ppos = player:get_pos()
		if ppos then
			local level = tornado.alert_level(player)
			local material = ground_material(ppos)
			-- during the calm, a handful of motes that will not settle
			local count = calm and 3 or math.floor((6 + 14 * (level - 1)) * S.particles)
			local pname = player:get_player_name()

			-- towards the storm: the epicenter during the build-up, the funnel
			-- itself once there is one to point at
			local target = event.epicenter
			if event.phase == PHASE.ACTIVE then
				local funnel = tornado.nearest_funnel(ppos)
				if funnel then target = funnel.object:get_pos() end
			end

			local to_storm = vector.subtract(target, ppos)
			to_storm.y = 0
			local length = math.sqrt(to_storm.x * to_storm.x + to_storm.z * to_storm.z)
			local dir = length > 0.5
				and { x = to_storm.x / length, z = to_storm.z / length }
				or { x = 0, z = 0 }

			local speed = calm and 0.3 or (2 + 5 * (level - 1) + math.random() * 3)

			for _ = 1, count do
				local particle = {
					pos = {
						x = ppos.x + math.random(-14, 14),
						y = ppos.y + math.random(-2, 7) + math.random(),
						z = ppos.z + math.random(-14, 14),
					},
					velocity = {
						x = dir.x * speed + (math.random() - 0.5) * 1.5,
						y = (calm and 0.15 or 0.6) + math.random() * (calm and 0.3 or 2),
						z = dir.z * speed + (math.random() - 0.5) * 1.5,
					},
					acceleration = { x = dir.x * speed * 0.4, y = 0.2, z = dir.z * speed * 0.4 },
					expirationtime = calm and (2 + math.random() * 2) or (1 + math.random()),
					collisiondetection = false,
					vertical = false,
					playername = pname,
				}
				-- roughly half real material off the ground underfoot, half
				-- generic grit, so it reads as this field rather than as fog
				if material and math.random() < 0.5 then
					particle.node = material
					particle.size = 0.6 + math.random() * 1.2
				else
					particle.texture = LITTER[math.random(#LITTER)]
					particle.size = 2 + math.random() * (calm and 2 or 5)
				end
				minetest.add_particle(particle)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- phases
--------------------------------------------------------------------------------

local function storm_origin(event)
	-- the weather comes from upwind
	return { x = -event.dir.x, y = 0, z = -event.dir.z }
end

function tornado.start_event(pos, opts)
	opts = opts or {}
	if tornado.event then return false, "an event is already running" end

	local wind = tornado.wind(pos)
	local length = math.sqrt(wind.x * wind.x + wind.z * wind.z)
	local dir
	if length < 0.05 then
		local angle = math.random() * math.pi * 2
		dir = { x = math.cos(angle), y = 0, z = math.sin(angle) }
	else
		dir = { x = wind.x / length, y = 0, z = wind.z / length }
	end

	local will_touch_down = opts.force_funnel
	if will_touch_down == nil then
		will_touch_down = math.random() < S.funnel_chance
	end

	tornado.event = {
		phase = PHASE.WATCH,
		t = opts.skip_watch and S.watch_time or 0,
		epicenter = vector.new(pos),
		dir = dir,
		will_touch_down = will_touch_down,
	}

	minetest.log("action", string.format(
		"[tornado] supercell building at %s, heading %s, funnel=%s",
		minetest.pos_to_string(vector.round(pos)),
		tornado.compass(dir), tostring(will_touch_down)))

	return true
end

local function begin_touchdown()
	local event = tornado.event
	local origin = storm_origin(event)
	local distance = S.approach_distance
	local spawn = {
		x = event.epicenter.x + origin.x * distance,
		-- tornado.spawn() does a wide search for the real ground here; this is
		-- only the height it starts looking from
		y = event.epicenter.y,
		z = event.epicenter.z + origin.z * distance,
	}

	local funnel = tornado.spawn(spawn, {})
	if not funnel then
		-- unloaded ground under the spawn point; treat it as a near miss
		minetest.log("action", "[tornado] touchdown aborted, ground not loaded at "
			.. minetest.pos_to_string(vector.round(spawn)))
		tornado.end_event(FIZZLE_COOLDOWN)
		return
	end

	event.phase = PHASE.ACTIVE
	event.t = 0
	event.funnel = funnel
	force_wind(event.dir, 4.0)
end

-- `cooldown_scale` shortens the quiet period after a storm that never produced
-- anything, so a fizzle does not lock the weather down for the full stretch.
function tornado.end_event(cooldown_scale)
	if not tornado.event then return end
	release_wind()
	tornado.event = nil
	cooldown_until = minetest.get_gametime() + S.cooldown * (cooldown_scale or 1)
end

-- For testing: lets the next scan roll immediately.
function tornado.clear_cooldown()
	cooldown_until = 0
end

--------------------------------------------------------------------------------
-- per-phase updates
--------------------------------------------------------------------------------

local function tick_watch(dt)
	local event = tornado.event
	local fraction = event.t / S.watch_time

	-- The wind curve is the whole warning. It falls to nothing, holds there
	-- long enough to be conspicuous, then comes back turned and rising.
	if fraction < CALM_FRACTION then
		force_wind(event.dir, 0.15)
	else
		local ramp = (fraction - CALM_FRACTION) / (1 - CALM_FRACTION)
		force_wind(event.dir, 0.3 + 3.2 * ramp)
	end

	if minetest.get_modpath("lightning") and fraction > 0.5
			and math.random() < dt * 0.1 * (fraction - 0.5) * 2 then
		local origin = storm_origin(event)
		lightning.strike({
			x = event.epicenter.x + origin.x * (70 + math.random(0, 110)) + math.random(-25, 25),
			y = event.epicenter.y,
			z = event.epicenter.z + origin.z * (70 + math.random(0, 110)) + math.random(-25, 25),
		})
	end

	if event.t >= S.watch_time then
		if event.will_touch_down then
			begin_touchdown()
		else
			minetest.log("action", "[tornado] supercell passed without a funnel")
			tornado.end_event(FIZZLE_COOLDOWN)
		end
	end
end

local function tick_active(dt)
	local event = tornado.event
	local funnel = event.funnel
	local alive = funnel and funnel.object and funnel.object:get_pos()

	if not alive then
		tornado.end_event(1)
		return
	end

	-- the epicenter follows the funnel, so the alert radius, the sky and the
	-- litter all travel with it instead of staying where the storm was sighted
	event.epicenter = funnel.object:get_pos()
	force_wind(event.dir, 4.0)
end

--------------------------------------------------------------------------------
-- qualification and the scan loop
--------------------------------------------------------------------------------

-- Does this player's patch of world look like tornado weather? Warm, damp and
-- already windy, outdoors, near the surface. Deserts fail on humidity, which is
-- the right answer for the wrong reason and happens to match reality.
local function qualifies(player)
	local pos = player:get_pos()
	if not pos then return false end
	if pos.y < S.min_y or pos.y > S.max_y then return false end

	local light = minetest.get_natural_light({ x = pos.x, y = pos.y + 1, z = pos.z }, 0.5) or 0
	if light < 12 then return false end

	if minetest.global_exists("climate_api") and climate_api.environment then
		local heat = climate_api.environment.get_heat(pos)
		local humidity = climate_api.environment.get_humidity(pos)
		local windspeed = vector.length(tornado.wind(pos))
		return heat >= 40 and humidity >= 45 and windspeed >= 2.0
	end

	-- no climate_api: fall back to whatever wind we can see
	if minetest.global_exists("sum_air_currents") then
		return sum_air_currents.wind_speed >= sum_air_currents.max_wind_speed * 0.6
	end
	return false
end

local function scan()
	if tornado.event then return end
	if minetest.get_gametime() < cooldown_until then return end

	local candidates = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		if qualifies(player) then candidates[#candidates + 1] = player end
	end
	if #candidates == 0 then return end

	-- one roll per scan regardless of how many people are online, so a busy
	-- server does not get proportionally more weather
	if math.random() >= S.storm_chance then return end

	local player = candidates[math.random(#candidates)]
	tornado.start_event(player:get_pos())
end

--------------------------------------------------------------------------------

local scan_timer, tick_timer, telegraph_timer = 0, 0, 0

minetest.register_globalstep(function(dtime)
	if #minetest.get_connected_players() == 0 then return end

	scan_timer = scan_timer + dtime
	if scan_timer >= SCAN_INTERVAL then
		scan_timer = 0
		scan()
	end

	if not tornado.event then return end

	telegraph_timer = telegraph_timer + dtime
	if telegraph_timer >= TELEGRAPH_INTERVAL then
		telegraph_timer = 0
		telegraph()
	end

	tick_timer = tick_timer + dtime
	if tick_timer < TICK_INTERVAL then return end
	local dt = tick_timer
	tick_timer = 0

	local event = tornado.event
	event.t = event.t + dt

	if event.phase == PHASE.WATCH then
		tick_watch(dt)
	else
		tick_active(dt)
	end
end)
