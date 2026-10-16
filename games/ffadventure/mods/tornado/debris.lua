-- Debris: a node the funnel has torn loose.
--
-- Two lives. First it orbits the funnel, climbing the vortex. Then it is thrown
-- clear and flies ballistically until it hits something, at which point it is
-- put back into the world as a node.
--
-- That second half is the whole reason this is a custom entity rather than a
-- __builtin:falling_node handed an initial velocity: the tornado has to give
-- the map back. Nodes it lifts are moved, never deleted, so a passing funnel
-- leaves a mess you can clean up instead of a hole you have to refill.

local S = tornado.settings

local GRAVITY = tonumber(minetest.settings:get("movement_gravity")) or 9.81
-- LuaJIT keeps math.atan2; guard anyway so this survives a 5.4 host
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
local MAX_ORBIT_AGE = 14      -- seconds before a piece is thrown clear regardless
local MAX_FLIGHT_AGE = 25     -- seconds before a piece gives up and drops
local HIT_SPEED = 9           -- below this, flying debris is harmless
local HIT_INTERVAL = 0.4
local ORBIT_INTERVAL = 0.12   -- how often an orbiting piece re-aims
local MAX_ORBIT_SPEED = 18

local function drop_as_item(pos, node)
	for _, item in ipairs(minetest.get_node_drops(node, "")) do
		minetest.add_item(pos, item)
	end
end

-- Put the node back into the world at the first free spot at or above `pos`.
-- Falls back to dropping the item so nothing is silently lost.
local function deposit(pos, node)
	local target = vector.round(pos)
	for offset = 0, 3 do
		local check = { x = target.x, y = target.y + offset, z = target.z }
		local existing = minetest.get_node_or_nil(check)
		if existing then
			local def = minetest.registered_nodes[existing.name]
			if def and def.buildable_to then
				if S.respect_protection and minetest.is_protected(check, "") then
					drop_as_item(check, node)
				else
					minetest.add_node(check, node)
				end
				return
			end
		end
	end
	drop_as_item(target, node)
end

minetest.register_entity("tornado:debris", {
	initial_properties = {
		visual = "wielditem",
		visual_size = { x = 0.4, y = 0.4, z = 0.4 },
		textures = {},
		physical = false,
		collide_with_objects = false,
		collisionbox = { -0.25, -0.25, -0.25, 0.25, 0.25, 0.25 },
		pointable = false,
		-- an airborne tornado has no business surviving a restart
		static_save = false,
		automatic_rotate = 2.5,
	},

	node = nil,
	funnel = nil,
	mode = "orbit",
	age = 0,
	hit_timer = 0,
	counted = false,

	set_node = function(self, node)
		local def = minetest.registered_nodes[node.name]
		if not def or node.name == "air" then
			self:die()
			return
		end
		self.node = node
		local itemstring = node.name
		if minetest.is_colored_paramtype(def.paramtype2) then
			itemstring = minetest.itemstring_with_palette(itemstring, node.param2 or 0)
		end
		self.object:set_properties({
			is_visible = true,
			wield_item = itemstring,
			glow = def.light_source,
		})
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({ immortal = 1 })
		self.age = 0
		self.mode = "orbit"
		self.counted = true
		tornado.debris_count = tornado.debris_count + 1

		local node = minetest.deserialize(staticdata)
		if node and node.name then
			self:set_node(node)
		end

		-- orbit geometry, jittered so a lifted wall doesn't rise as a wall
		self.orbit_radius = 1.5 + math.random() * 3
		self.rise = 5 + math.random() * 5
		-- Orbit velocity is recomputed on a timer rather than every step: with
		-- a full debris cap that is the difference between a few hundred and a
		-- few thousand object updates a second on the wire. The random start
		-- offset spreads the recomputes across steps instead of bunching them.
		self.orbit_timer = math.random() * ORBIT_INTERVAL
	end,

	on_deactivate = function(self)
		if self.counted then
			self.counted = false
			tornado.debris_count = math.max(0, tornado.debris_count - 1)
		end
	end,

	die = function(self)
		if self.counted then
			self.counted = false
			tornado.debris_count = math.max(0, tornado.debris_count - 1)
		end
		self.object:remove()
	end,

	-- Leave the vortex on a tangent, which is what makes the damage arrive from
	-- a direction rather than from directly overhead.
	eject = function(self, extra_speed)
		if self.mode == "thrown" then return end
		self.mode = "thrown"
		self.age = 0

		local vel = self.object:get_velocity() or vector.new(0, 0, 0)
		local boost = 1 + (extra_speed or 0)
		self.object:set_properties({ physical = true })
		self.object:set_velocity({
			x = vel.x * boost,
			y = math.max(vel.y * 0.4, 1),
			z = vel.z * boost,
		})
		self.object:set_acceleration({ x = 0, y = -GRAVITY, z = 0 })
	end,

	land = function(self)
		local pos = self.object:get_pos()
		if pos and self.node then
			deposit(pos, self.node)
		end
		self:die()
	end,

	-- Anything in the way of a flying node gets hit. Damage scales with speed,
	-- so a piece of grass drifting past is harmless and a fence post at terminal
	-- velocity is not.
	hurt_nearby = function(self, pos, speed)
		if not S.damage or speed < HIT_SPEED then return end
		local damage = math.min(6, math.max(1, math.floor(speed / 5)))
		for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 1.4)) do
			local ent = obj:get_luaentity()
			if obj:is_player() or (ent and ent.name ~= "tornado:debris"
					and ent.name ~= "tornado:funnel" and ent.name ~= "__builtin:item") then
				obj:punch(self.object, HIT_INTERVAL, {
					full_punch_interval = HIT_INTERVAL,
					damage_groups = { fleshy = damage, falling_node = damage },
				}, nil)
				self.hit_timer = -HIT_INTERVAL
				return
			end
		end
	end,

	on_step = function(self, dtime, moveresult)
		self.age = self.age + dtime

		local pos = self.object:get_pos()
		if not pos or not self.node then
			self:die()
			return
		end

		if self.mode == "orbit" then
			local funnel = self.funnel
			local fent = funnel and funnel:get_luaentity()
			if not fent then
				self:eject(0)
				return
			end

			local fpos = funnel:get_pos()
			local rel = vector.subtract(pos, fpos)
			local dist = math.sqrt(rel.x * rel.x + rel.z * rel.z)

			-- thrown clear at the top of the funnel, or when it has been in
			-- there long enough that it would just be visual noise
			if rel.y > fent.height or self.age > MAX_ORBIT_AGE or dist > fent.radius * 4 then
				self:eject(0.4)
				return
			end

			self.orbit_timer = self.orbit_timer + dtime
			if self.orbit_timer < ORBIT_INTERVAL then return end
			self.orbit_timer = 0

			-- The orbit tightens as debris climbs, which is what reads as a
			-- funnel shape rather than a cylinder of junk.
			local climb = math.max(0, math.min(1, rel.y / math.max(fent.height, 1)))
			local target_radius = self.orbit_radius * (1 - 0.45 * climb) + fent.radius * 0.35
			local spin = 4.5 * fent.intensity

			local angle = atan2(rel.z, rel.x)

			-- tangential + a spring pulling towards the ideal radius, both
			-- clamped: a piece that drifts wide would otherwise be handed a
			-- three-figure velocity and disappear over the horizon
			local tangential = math.min(spin * math.max(dist, 1), MAX_ORBIT_SPEED)
			local inward = math.max(-12, math.min(12, (target_radius - dist) * 2.5))

			local vx = -math.sin(angle) * tangential + math.cos(angle) * inward
			local vz = math.cos(angle) * tangential + math.sin(angle) * inward
			local vy = self.rise * fent.intensity

			self.object:set_velocity({ x = vx, y = vy, z = vz })
			self.object:set_acceleration({ x = 0, y = 0, z = 0 })
			return
		end

		-- thrown
		local vel = self.object:get_velocity() or vector.new(0, 0, 0)
		local speed = vector.length(vel)

		self.hit_timer = self.hit_timer + dtime
		if self.hit_timer >= HIT_INTERVAL then
			self.hit_timer = 0
			self:hurt_nearby(pos, speed)
		end

		if self.age > MAX_FLIGHT_AGE then
			self:land()
			return
		end

		if moveresult and (moveresult.touching_ground or moveresult.collides) then
			self:land()
			return
		end

		-- Belt and braces: a physical entity can end up resting without ever
		-- reporting a collision if it spawned inside geometry.
		if speed < 0.6 and self.age > 1 then
			self:land()
		end
	end,
})

-- Lift the node at `pos` into the given funnel. Returns true if it went up.
function tornado.lift_node(pos, funnel_obj)
	if tornado.debris_count >= S.max_debris then return false end

	local node = minetest.get_node_or_nil(pos)
	if not node then return false end

	minetest.remove_node(pos)

	local spawn_pos = { x = pos.x, y = pos.y + 0.2, z = pos.z }
	local obj = minetest.add_entity(spawn_pos, "tornado:debris",
		minetest.serialize({ name = node.name, param2 = node.param2 }))
	if not obj then
		-- entity limit hit; put it straight back rather than losing it
		minetest.add_node(pos, node)
		return false
	end

	local ent = obj:get_luaentity()
	if ent then ent.funnel = funnel_obj end
	return true
end
