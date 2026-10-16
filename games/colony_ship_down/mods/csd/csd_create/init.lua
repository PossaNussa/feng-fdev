-- Create-style machinery for Colony Ship Down, built on steamified's
-- stress/RPM network (shafts, cogs and gearboxes come from steamified).
--
-- Moving parts are glTF models animated on the client. The server only
-- changes an entity's animation speed when the network's RPM at that spot
-- changes, so a room full of spinning machines costs almost no traffic.
--
-- The art is original. A private overlay mod (csd_create_overlay, built by
-- tools/build_create_overlay.py from your own Create checkout) can swap
-- meshes/textures through csd_create.parts and csd_create.override_look().

csd_create = {}
csd_create.S = core.get_translator("csd_create")

local ATLAS = "csd_create_atlas.png"

------------------------------------------------------------------------------
-- Orientation
--
-- Models are built with the shaft along +Z; the glTF loader mirrors Z, so in
-- the engine a model's shaft points along -Z. `shaft_dir` is the world
-- direction a machine's shaft points.
------------------------------------------------------------------------------

function csd_create.param2_for(shaft_dir)
	return core.dir_to_facedir(vector.multiply(shaft_dir, -1), true)
end

function csd_create.shaft_dir(param2)
	return vector.multiply(core.facedir_to_dir(param2 % 32), -1)
end

function csd_create.axis(param2)
	local d = core.facedir_to_dir(param2 % 32)
	return {x = math.abs(d.x), y = math.abs(d.y), z = math.abs(d.z)}
end

-- Rotation for an entity whose model should line up with the node.
local function entity_rotation(param2)
	return vector.dir_to_rotation(vector.multiply(csd_create.shaft_dir(param2), -1))
end

-- Placement helpers ---------------------------------------------------------

-- Shaft goes into the block you clicked (cranks, fans). Sneak flips it.
function csd_create.place_into_clicked(itemstack, placer, pointed)
	if pointed.type ~= "node" then return itemstack end
	local dir = vector.subtract(pointed.under, pointed.above)
	if placer and placer:get_player_control().sneak then dir = vector.multiply(dir, -1) end
	return core.item_place(itemstack, placer, pointed, csd_create.param2_for(dir))
end

-- Shaft runs left-right as seen by the player (turbines, flywheels, gauges, presses).
function csd_create.place_across_view(itemstack, placer, pointed)
	if pointed.type ~= "node" or not placer then return itemstack end
	local look = placer:get_look_dir()
	local dir
	if math.abs(look.x) > math.abs(look.z) then
		dir = vector.new(0, 0, 1)
	else
		dir = vector.new(1, 0, 0)
	end
	return core.item_place(itemstack, placer, pointed, csd_create.param2_for(dir))
end

-- Place one of steamified's horizontal shafts the way its own placement does
-- (for generators and schematics, where after_place_node never runs).
function csd_create.place_shaft(pos, axis_dir)
	local p2 = core.dir_to_facedir(axis_dir)
	core.set_node(pos, {name = "steamified:axle_node", param2 = p2})
	local obj = core.add_entity(pos, "steamified:baked_entity")
	if obj then
		local ent = obj:get_luaentity()
		ent._param2 = p2
		ent._mesh_prefix = "shaft"
		ent._custom_textures = {"steamified_shaft.png"}
		ent:refresh_properties()
	end
end

-- A vertical steamified shaft (steamified uses param2 20 for "up").
function csd_create.place_vertical_shaft(pos)
	core.set_node(pos, {name = "steamified:axle_node", param2 = 20})
	local obj = core.add_entity(pos, "steamified:baked_entity")
	if obj then
		local ent = obj:get_luaentity()
		ent._param2 = 20
		ent._mesh_prefix = "shaft"
		ent._custom_textures = {"steamified_shaft.png"}
		ent:refresh_properties()
	end
end

-- A steamified gearbox (turns rotation through 90 degrees).
function csd_create.place_gearbox(pos)
	core.set_node(pos, {name = "steamified:gearbox"})
	local def = core.registered_nodes["steamified:gearbox"]
	if def and def.after_place_node then def.after_place_node(pos) end
end

------------------------------------------------------------------------------
-- Network speed
------------------------------------------------------------------------------

-- Signed RPM at pos (0 if unpowered or the network is overstressed).
function csd_create.get_rpm(pos)
	local h = core.hash_node_position(pos)
	local p = steamified.powered_positions[h]
	if not p or not p.source then return 0 end
	local src = steamified.get_power_source(p.source)
	if not src then return 0 end
	local stress = src.current_stress or 0
	if steamified.motors[p.source] then
		if stress > steamified.config.STRESS_THRESHOLD then return 0 end
	elseif steamified.power_generators[p.source] then
		if src.def and src.def.output and stress > src.def.output then return 0 end
	elseif stress == math.huge then
		return 0
	end
	return (p.rpm or 0) * ((p.direction or 1) < 0 and -1 or 1)
end

function csd_create.is_stalled(pos)
	local p = steamified.powered_positions[core.hash_node_position(pos)]
	return p ~= nil and csd_create.get_rpm(pos) == 0
end

------------------------------------------------------------------------------
-- Moving parts
------------------------------------------------------------------------------

-- csd_create.parts[name] = {
--   mesh = "x.glb", textures = {...}, anim = "spin" | "stroke" | "dial" | nil,
--   offset = vector,             -- from the node centre
--   speed = function(pos) -> rpm (spin/stroke) or 0..1 (dial)
-- }
csd_create.parts = {}

function csd_create.register_part(name, def)
	def.name = name
	def.textures = def.textures or {ATLAS}
	csd_create.parts[name] = def
end

-- Let an overlay replace a part's or node's look without touching logic.
function csd_create.override_look(name, look)
	local part = csd_create.parts[name]
	if part then
		for k, v in pairs(look) do part[k] = v end
	elseif core.registered_nodes[name] then
		core.override_item(name, look)
	end
end

local active_parts = {}

core.register_entity("csd_create:part", {
	initial_properties = {
		visual = "mesh",
		mesh = "csd_create_flywheel.glb",
		textures = {ATLAS},
		visual_size = {x = 10, y = 10, z = 10},
		physical = false,
		pointable = false,
		static_save = false,
		shaded = true,
		backface_culling = true,
	},
	on_activate = function(self, staticdata)
		local data = core.deserialize(staticdata or "") or {}
		self._part = data.part
		self._node_pos = data.node_pos
		local def = csd_create.parts[self._part or ""]
		if not def or not self._node_pos then
			self.object:remove()
			return
		end
		self.object:set_properties({mesh = def.mesh, textures = def.textures, visual_size = def.visual_size or {x = 10, y = 10, z = 10}})
		self.object:set_rotation(entity_rotation(data.param2 or 0))
		self._speed = nil
		active_parts[self.object] = self
		if def.anim == nil then
			self.object:set_animation({x = 0, y = 0}, 0, 0, false)
		end
	end,
	on_deactivate = function(self)
		active_parts[self.object] = nil
	end,
	get_staticdata = function(self)
		return core.serialize({part = self._part, node_pos = self._node_pos})
	end,
})

local function remove_parts(pos)
	for _, obj in ipairs(core.get_objects_inside_radius(pos, 0.9)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "csd_create:part" and ent._node_pos and vector.equals(ent._node_pos, pos) then
			obj:remove()
		end
	end
end
csd_create.remove_parts = remove_parts

function csd_create.spawn_parts(pos, part_names)
	remove_parts(pos)
	local node = core.get_node(pos)
	for _, pname in ipairs(part_names) do
		local def = csd_create.parts[pname]
		local at = def.offset and vector.add(pos, def.offset) or pos
		core.add_entity(at, "csd_create:part", core.serialize({part = pname, node_pos = pos, param2 = node.param2}))
	end
end

local function apply_speed(ent, def, value)
	if ent._speed == value then return end
	ent._speed = value
	local obj = ent.object
	if def.anim == "spin" then
		local fps = math.abs(value) / 60 * 4 * (def.ratio or 1)
		if value >= 0 then
			obj:set_animation({x = 0, y = 4}, fps, 0, true)
		else
			obj:set_animation({x = 4, y = 8}, fps, 0, true)
		end
	elseif def.anim == "stroke" then
		obj:set_animation({x = 0, y = 2}, math.abs(value) / 64 * 2, 0, true)
	elseif def.anim == "dial" then
		local f = math.max(0, math.min(1, value)) * 100
		obj:set_animation({x = f, y = f}, 0, 0, false)
	end
end

local part_timer = 0
core.register_globalstep(function(dtime)
	part_timer = part_timer + dtime
	if part_timer < 0.25 then return end
	part_timer = 0
	for obj, ent in pairs(active_parts) do
		if not obj:get_pos() then
			active_parts[obj] = nil
		else
			local def = csd_create.parts[ent._part]
			if def and def.anim then
				local v = def.speed and def.speed(ent._node_pos) or csd_create.get_rpm(ent._node_pos)
				-- Quantise so tiny changes don't resend animations.
				v = math.floor(v * 100 + 0.5) / 100
				apply_speed(ent, def, v)
			end
		end
	end
end)

------------------------------------------------------------------------------
-- Machine registration
------------------------------------------------------------------------------

-- Registers the node, its steamified power role and its moving parts.
-- def = node definition plus:
--   _parts = {"part names"},
--   _power = steamified power node def (component_type = "generator"/"consumer", ...)
function csd_create.register_machine(name, def)
	local parts = def._parts or {}
	local power = def._power
	def.paramtype = def.paramtype or "light"
	def.paramtype2 = def.paramtype2 or "facedir"
	-- The engine doesn't apply node scale (BS) to static glTF node meshes, so
	-- models built in node units need visual_scale 10.
	if def.drawtype == "mesh" and def.mesh and def.mesh:find("%.glb$") then
		def.visual_scale = def.visual_scale or 10
	end
	def.groups = def.groups or {}
	def.groups.csd_create_machine = 1
	def.groups.kinetic_component = 1
	def.groups.cracky = def.groups.cracky or 2
	def.groups.oddly_breakable_by_hand = def.groups.oddly_breakable_by_hand or 2
	if power and power.passes_through then
		def.groups.kinetic_axle = 1
	end

	local old_construct, old_destruct = def.on_construct, def.on_destruct
	def.on_construct = function(pos)
		if old_construct then old_construct(pos) end
		if power then steamified.add_power_node(pos, name) end
		csd_create.spawn_parts(pos, parts)
	end
	def.on_destruct = function(pos)
		if old_destruct then old_destruct(pos) end
		if power then steamified.remove_power_node(pos) end
		remove_parts(pos)
	end
	core.register_node(name, def)

	if power then
		power.get_axis = power.get_axis or function(node) return csd_create.axis(node.param2) end
		power.has_shaft, power.has_cog, power.has_wheel = false, false, false
		steamified.register_power_node(name, power)
	end
	csd_create.machine_parts = csd_create.machine_parts or {}
	csd_create.machine_parts[name] = parts
end

-- Parts are not saved with the map; rebuild them (and steamified's
-- in-memory power node tables) whenever a block loads.
core.register_lbm({
	label = "Restore CSD Create machines",
	name = "csd_create:restore",
	nodenames = {"group:csd_create_machine"},
	run_at_every_load = true,
	action = function(pos, node)
		if steamified.power_node_defs[node.name] then
			-- Re-adding a live entry would reset its stress mid-update.
			local h = core.hash_node_position(pos)
			local e = steamified.power_generators[h] or steamified.power_consumers[h]
			if not (e and e.name == node.name) then
				steamified.add_power_node(pos, node.name)
			end
		end
		local parts = csd_create.machine_parts[node.name]
		if parts and #parts > 0 then
			csd_create.spawn_parts(pos, parts)
		end
		local def = core.registered_nodes[node.name]
		if def and def._on_load then def._on_load(pos, node) end
	end,
})

local path = core.get_modpath("csd_create")
dofile(path .. "/machines.lua")
dofile(path .. "/processing.lua")
