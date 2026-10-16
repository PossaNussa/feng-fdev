-- The funnel itself.
--
-- It is not a physical entity. A physical one snags on terrain, gets shoved out
-- of the world by its own collision box, and cannot climb a hill; this one is a
-- moving reference point that the particles, the debris and the object pull all
-- hang off. Its only job is to be in the right place.
--
-- It walks the shared wind field rather than picking random headings, so the
-- direction it comes from is the direction the clouds have been moving all
-- storm. That is what makes the warning messages honest.

local S = tornado.settings

local PARTICLE_INTERVAL = 0.12
local GROUND_INTERVAL = 0.4
local PULL_INTERVAL = 0.25
local DAMAGE_INTERVAL = 1.0
local CHECK_INTERVAL = 2.0
local WANDER_MIN, WANDER_MAX = 3, 7
local VIEW_DISTANCE = 180   -- beyond this nobody can see the particles anyway
local MAX_LIFTS_PER_STEP = 25
local MAX_PULL_SPEED = 16   -- ceiling on what the vortex will accelerate you to

-- No file of its own; borrow the closest thing the game already ships and pitch
-- it down into a roar.
local ROAR = (minetest.get_modpath("sum_air_currents") and "sum_air_currents_wind_low03")
	or (minetest.get_modpath("regional_weather") and "weather_wind")
	or nil

local function normalize_h(v)
	local length = math.sqrt(v.x * v.x + v.z * v.z)
	if length < 0.001 then return nil, 0 end
	return { x = v.x / length, y = 0, z = v.z / length }, length
end

minetest.register_entity("tornado:funnel", {
	initial_properties = {
		physical = false,
		collide_with_objects = false,
		collisionbox = { -0.2, -0.2, -0.2, 0.2, 0.2, 0.2 },
		visual = "sprite",
		visual_size = { x = 0.01, y = 0.01 },
		textures = { "blank.png" },
		is_visible = false,
		pointable = false,
		-- deliberately not saved: a tornado is an event, not a fixture, and one
		-- resuming mid-rampage after a server restart would be a nasty surprise
		static_save = false,
	},

	age = 0,
	lifetime = 180,
	peak = 1,
	intensity = 0,
	radius = 1,
	height = 10,

	on_activate = function(self)
		self.object:set_armor_groups({ immortal = 1 })
		self.age = 0
		self.intensity = 0.1
		self.radius = S.radius * 0.4
		self.height = S.height
		self.dir = { x = 0, y = 0, z = 1 }
		self.wander = { x = 0, z = 0 }
		self.wander_timer = 0
		self.wander_next = WANDER_MIN
		self.node_budget = 0
		self.t_particle = 0
		self.t_ground = 0
		self.t_pull = 0
		self.t_damage = 0
		self.t_check = CHECK_INTERVAL
		self.ground = nil
		self.nearest_player = 0

		if ROAR then
			self.sound = minetest.sound_play(ROAR, {
				object = self.object,
				loop = true,
				gain = 1.8,
				pitch = 0.45,
				max_hear_distance = 220,
			})
		end

		tornado.funnels[#tornado.funnels + 1] = self
	end,

	on_deactivate = function(self)
		if self.sound then
			minetest.sound_stop(self.sound)
			self.sound = nil
		end
	end,

	dissipate = function(self, quiet)
		if not quiet then
			minetest.log("action", "[tornado] funnel dissipated at "
				.. minetest.pos_to_string(vector.round(self.object:get_pos())))
		end
		if self.sound then
			minetest.sound_stop(self.sound)
			self.sound = nil
		end
		-- debris left in the air notices its funnel is gone and throws itself
		self.object:remove()
	end,

	-- 0..1 over the lifetime: spin-up, mature, rope-out.
	update_intensity = function(self)
		local t = self.age / self.lifetime
		local envelope
		if t < 0.12 then
			envelope = t / 0.12
		elseif t > 0.72 then
			envelope = math.max(0, (1 - t) / 0.28)
		else
			envelope = 1
		end
		envelope = 0.15 + 0.85 * envelope
		self.intensity = self.peak * envelope
		self.radius = math.max(1.5, S.radius * self.peak * (0.35 + 0.65 * envelope))
		self.height = S.height * (0.5 + 0.5 * envelope)
	end,

	move = function(self, dtime, pos)
		-- heading: the wind, nudged by a slow wander so the track is not a
		-- ruler-straight line across the map
		self.wander_timer = self.wander_timer + dtime
		if self.wander_timer >= self.wander_next then
			self.wander_timer = 0
			self.wander_next = math.random(WANDER_MIN, WANDER_MAX)
			self.wander = {
				x = (math.random() * 2 - 1) * 0.5,
				z = (math.random() * 2 - 1) * 0.5,
			}
		end

		local wind = tornado.wind(pos)
		local wind_dir = normalize_h(wind)
		if wind_dir then
			-- ease towards the wind rather than snapping to it
			self.dir = {
				x = self.dir.x * 0.96 + wind_dir.x * 0.04,
				y = 0,
				z = self.dir.z * 0.96 + wind_dir.z * 0.04,
			}
		end
		local dir = normalize_h({
			x = self.dir.x + self.wander.x,
			y = 0,
			z = self.dir.z + self.wander.z,
		}) or { x = 0, y = 0, z = 1 }
		self.dir = dir

		local speed = S.speed * (0.6 + 0.4 * self.intensity)

		-- follow the terrain, keeping the base on the ground
		self.t_ground = self.t_ground + dtime
		if self.t_ground >= GROUND_INTERVAL then
			self.t_ground = 0
			-- the tight window covers ordinary terrain; the wide one catches a
			-- cliff edge or a ravine without paying for it every time
			self.ground = tornado.ground_y(pos.x, pos.z, pos.y)
				or tornado.ground_y(pos.x, pos.z, pos.y, 40, 70)
			-- what it is currently chewing through, so the debris cloud at the
			-- base is the colour of the ground rather than generic grey
			self.material = nil
			if self.ground then
				local node = minetest.get_node({
					x = math.floor(pos.x + 0.5), y = self.ground, z = math.floor(pos.z + 0.5) })
				local def = minetest.registered_nodes[node.name]
				if def and def.walkable and def.drawtype ~= "airlike"
						and (not def.liquidtype or def.liquidtype == "none") then
					self.material = { name = node.name, param2 = node.param2 }
				end
			end
		end

		local vy = 0
		if self.ground then
			vy = math.max(-8, math.min(8, (self.ground + 1 - pos.y) * 2))
		end

		self.object:set_velocity({ x = dir.x * speed, y = vy, z = dir.z * speed })
	end,

	scour = function(self, dtime, pos)
		if not S.griefing then return end

		self.node_budget = self.node_budget + dtime * S.node_rate * self.intensity
		local reach = self.radius * 1.15
		local lifts = 0

		while self.node_budget >= 1 and lifts < MAX_LIFTS_PER_STEP do
			self.node_budget = self.node_budget - 1
			lifts = lifts + 1

			-- uniform over the disc, not over the radius, or everything gets
			-- eaten out of the middle
			local angle = math.random() * math.pi * 2
			local dist = math.sqrt(math.random()) * reach
			local x = pos.x + math.cos(angle) * dist
			local z = pos.z + math.sin(angle) * dist

			local ground = tornado.ground_y(x, z, pos.y)
			if ground then
				local npos = { x = math.floor(x + 0.5), y = ground, z = math.floor(z + 0.5) }
				local node = minetest.get_node(npos)
				-- force falls off towards the edge, so the rim only strips
				-- grass while the core can take a wall apart
				local force = self.intensity * (1 - 0.5 * (dist / reach))
				if tornado.can_lift(npos, node, force) then
					tornado.lift_node(npos, self.object)
				end
			end
		end

		-- a lag spike must not bank a debt that gets spent in one burst
		self.node_budget = math.min(self.node_budget, MAX_LIFTS_PER_STEP)
	end,

	pull = function(self, pos)
		local reach = self.radius * 3.5
		for _, obj in ipairs(minetest.get_objects_inside_radius(pos, reach)) do
			local ent = obj:get_luaentity()
			local skip = ent and (ent.name == "tornado:debris" or ent.name == "tornado:funnel")
			-- add_velocity accumulates, so without a ceiling a player held in
			-- the pull for twenty seconds ends up moving faster than the
			-- client can render
			local vel = obj:get_velocity()
			if vel and vector.length(vel) > MAX_PULL_SPEED then skip = true end

			if not skip then
				local opos = obj:get_pos()
				local rel = vector.subtract(opos, pos)
				local dist = math.sqrt(rel.x * rel.x + rel.z * rel.z)
				local closeness = 1 - math.min(1, dist / reach)

				local dir = normalize_h(rel) or { x = 1, y = 0, z = 0 }
				-- tangential dominates: things caught in a tornado go round,
				-- and only then up
				local swirl = 7 * closeness * self.intensity
				local inward = 3 * closeness * self.intensity
				local lift = 9 * closeness * closeness * self.intensity

				obj:add_velocity({
					x = (-dir.z * swirl - dir.x * inward) * PULL_INTERVAL,
					y = lift * PULL_INTERVAL,
					z = (dir.x * swirl - dir.z * inward) * PULL_INTERVAL,
				})
			end
		end
	end,

	hurt = function(self, pos)
		if not S.damage then return end
		local reach = self.radius * 0.9
		for _, obj in ipairs(minetest.get_objects_inside_radius(pos, reach)) do
			local ent = obj:get_luaentity()
			if obj:is_player() or (ent and ent.name ~= "tornado:debris"
					and ent.name ~= "tornado:funnel" and ent.name ~= "__builtin:item") then
				local damage = math.max(1, math.floor(3 * self.intensity))
				obj:punch(self.object, DAMAGE_INTERVAL, {
					full_punch_interval = DAMAGE_INTERVAL,
					damage_groups = { fleshy = damage },
				}, nil)
			end
		end
	end,

	draw = function(self, pos)
		if S.particles <= 0 then return end
		-- nobody close enough to see it; the map still gets rearranged, but
		-- there is no point paying for the visuals
		if self.nearest_player > VIEW_DISTANCE then return end

		local spin = minetest.get_us_time() / 400000
		local count = math.floor(16 * S.particles * (0.4 + self.intensity))

		for i = 1, count do
			-- bias towards the bottom, where the interesting part is
			local climb = math.random() ^ 0.7
			local radius = self.radius * (0.3 + 0.9 * climb) * (0.8 + math.random() * 0.4)
			local angle = spin * 2.2 + climb * 2.6 + math.random() * 0.5
			local height = climb * self.height

			local px = pos.x + math.cos(angle) * radius
			local pz = pos.z + math.sin(angle) * radius
			local tangential = 9 * self.intensity

			minetest.add_particle({
				pos = { x = px, y = pos.y + height, z = pz },
				velocity = {
					x = -math.sin(angle) * tangential,
					y = 3 + 4 * math.random(),
					z = math.cos(angle) * tangential,
				},
				acceleration = { x = 0, y = 1.5, z = 0 },
				expirationtime = 0.5 + math.random() * 0.7,
				size = 3 + climb * 7,
				collisiondetection = false,
				vertical = false,
				texture = "tornado_dust.png^[colorize:#3a352c:190",
			})
		end

		-- the debris cloud kicked up around the base, which is what you
		-- actually see first from a distance
		for _ = 1, math.floor(6 * S.particles) do
			local angle = math.random() * math.pi * 2
			local radius = self.radius * (1 + math.random() * 0.8)
			local particle = {
				pos = {
					x = pos.x + math.cos(angle) * radius,
					y = pos.y + math.random() * 2,
					z = pos.z + math.sin(angle) * radius,
				},
				velocity = {
					x = math.cos(angle) * 2 - math.sin(angle) * 6,
					y = 1 + math.random() * 2,
					z = math.sin(angle) * 2 + math.cos(angle) * 6,
				},
				acceleration = { x = 0, y = -1, z = 0 },
				expirationtime = 0.6 + math.random() * 0.8,
				collisiondetection = false,
				vertical = false,
			}
			if self.material and math.random() < 0.6 then
				particle.node = self.material
				particle.size = 1 + math.random() * 1.5
			else
				particle.texture = "tornado_dust.png^[colorize:#5a5140:150"
				particle.size = 6 + math.random() * 8
			end
			minetest.add_particle(particle)
		end
	end,

	on_step = function(self, dtime)
		self.age = self.age + dtime
		if self.age >= self.lifetime then
			self:dissipate()
			return
		end

		local pos = self.object:get_pos()
		if not pos then return end

		if pos.y < S.min_y or pos.y > S.max_y then
			self:dissipate(true)
			return
		end

		-- One player sweep every couple of seconds serves both the "is anyone
		-- watching" test for the particles and the "has everyone left" test
		-- that stops a funnel churning away in unloaded map forever.
		self.t_check = self.t_check + dtime
		if self.t_check >= CHECK_INTERVAL then
			self.t_check = 0
			local nearest = math.huge
			for _, player in ipairs(minetest.get_connected_players()) do
				local ppos = player:get_pos()
				if ppos then
					nearest = math.min(nearest, vector.distance(ppos, pos))
				end
			end
			self.nearest_player = nearest
			if nearest > S.alert_radius * 1.5 then
				self:dissipate(true)
				return
			end
		end

		self:update_intensity()
		self:move(dtime, pos)
		self:scour(dtime, pos)

		self.t_pull = self.t_pull + dtime
		if self.t_pull >= PULL_INTERVAL then
			self.t_pull = 0
			self:pull(pos)
		end

		self.t_damage = self.t_damage + dtime
		if self.t_damage >= DAMAGE_INTERVAL then
			self.t_damage = 0
			self:hurt(pos)
		end

		self.t_particle = self.t_particle + dtime
		if self.t_particle >= PARTICLE_INTERVAL then
			self.t_particle = 0
			self:draw(pos)
		end
	end,
})
