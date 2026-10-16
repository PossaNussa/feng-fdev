-- Carriage Mod for Minetest
-- Author: ronrob-lu
-- License: CC-BY-SA 4.0

local MP = minetest.get_modpath(minetest.get_current_modname())
local S = minetest.get_translator("carriage")

local mcl = minetest.get_modpath("mcl_core") ~= nil
local item_wood = mcl and "mcl_core:wood" or "default:wood"
local item_steel = mcl and "mcl_core:iron_ingot" or "default:steel_ingot"
local item_wool = mcl and "mcl_wool:white" or "wool:white"

--
-- Craftitems
--


--
-- Recipes
--

minetest.register_craft({
	output = "carriage:carriage",
	recipe = {
		{item_wood, item_wood, item_wood},
		{item_wood, item_wood, item_wood},
		{"", "", ""},
	}
})

minetest.register_craftitem("carriage:model_k", {
	description = S("Carriage Model K"),
	inventory_image = "carriage-model-k-icon.png",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		local def = minetest.registered_nodes[node.name]
		if def and def.buildable_to then
			-- place in node
		else
			pos.y = pos.y + 1
		end

		local ent = minetest.add_entity(pos, "carriage:model_k_ent")
		if ent and placer then
			local yaw = placer:get_look_horizontal()
			ent:set_yaw(yaw)
		end
		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "carriage:model_k",
	recipe = {
		{item_steel, item_steel, item_steel},
		{item_steel, item_steel, item_steel},
		{"", "", ""},
	}
})

minetest.register_craftitem("carriage:model_kt", {
	description = S("Carriage Model KT (Transport)"),
	inventory_image = "carriage-model-kt-icon.png",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		local def = minetest.registered_nodes[node.name]
		if def and def.buildable_to then
			-- place in node
		else
			pos.y = pos.y + 1
		end

		local ent = minetest.add_entity(pos, "carriage:model_kt_ent")
		if ent and placer then
			local yaw = placer:get_look_horizontal()
			ent:set_yaw(yaw)

			-- Save owner for following logic
			local luaent = ent:get_luaentity()
			if luaent then
				luaent.owner_name = placer:get_player_name()
			end
		end
		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "carriage:model_kt",
	recipe = {
		{item_wool, item_wool, item_wool},
		{item_steel, item_steel, item_steel},
		{"", "", ""},
	}
})


-- The carriage itself
minetest.register_craftitem("carriage:carriage", {
	description = S("Horse Carriage"),
	inventory_image = "carriage-icon.png",

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		local def = minetest.registered_nodes[node.name]
		if def and def.buildable_to then
			-- place in node
		else
			pos.y = pos.y + 1
		end

		local ent = minetest.add_entity(pos, "carriage:carriage_ent")
		if ent and placer then
			local yaw = placer:get_look_horizontal()
			ent:set_yaw(yaw)
		end
		if not minetest.is_creative_enabled(placer:get_player_name()) then
			itemstack:take_item()
		end
		return itemstack
	end,
})



--
-- Entity Basics
--

local carriage_def = {
	initial_properties = {
		physical = true,
		collisionbox = {-1.25, 0, -1.25, 1.25, 1.5, 1.25},
		visual = "mesh",
		mesh = "carriage.obj",
		textures = {"carriage_wood.png"},
		visual_size = {x = -10, y = 10, z = -10},
		stepheight = 1.1,
		hp_max = 10,
	},

	driver1 = nil,
	driver2 = nil,
	horse = nil,
	v = 0, -- velocity (speed setting 0, 1, 2, 3)

	driver1_offset = {x=-0.4, y=0.2, z=0},
	driver2_offset = {x=0.4, y=0.2, z=-0},

	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal = 1})

		-- FIX: ensure driver fields are empty on load (ObjectRefs are invalidated on restart)
		self.driver1 = nil
		self.driver2 = nil
		self.horse = nil

		local data = {}
		if staticdata ~= "" then
			data = minetest.deserialize(staticdata) or {}
		end

		self.id = data.id or (tostring(math.random(1, 999999)) .. "_" .. tostring(os.time()))
	end,

	get_staticdata = function(self)
		local data = {
			id = self.id,
		}

		local s = minetest.serialize(data)
		return s or ""
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if not puncher or not puncher:is_player() then return true end

		local pos = self.object:get_pos()
		if not pos then return true end

		local hp = self.object:get_hp()
		hp = hp - 1
		self.object:set_hp(hp)
		if hp > 0 then return true end

		-- If players are attached, detach them
		if self.driver1 then
			local name = self.driver1:get_player_name()
			self.driver1:set_detach()
			self.driver1:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			if self.driver1_orig_size then
				self.driver1:set_properties({visual_size = self.driver1_orig_size})
			end
			if player_api then
				player_api.player_attached[name] = false
				player_api.set_animation(self.driver1, "stand")
			elseif default and default.player_attached then
				default.player_attached[name] = false
				default.player_set_animation(self.driver1, "stand")
			end
			self.driver1 = nil
			self.driver1_orig_size = nil
		end
		if self.driver2 then
			local name = self.driver2:get_player_name()
			self.driver2:set_detach()
			self.driver2:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
			if self.driver2_orig_size then
				self.driver2:set_properties({visual_size = self.driver2_orig_size})
			end
			if player_api then
				player_api.player_attached[name] = false
				player_api.set_animation(self.driver2, "stand")
			elseif default and default.player_attached then
				default.player_attached[name] = false
				default.player_set_animation(self.driver2, "stand")
			end
			self.driver2 = nil
			self.driver2_orig_size = nil
		end

		-- Destroyed like wood, get back wood
		minetest.add_item(pos, item_wood .. " 6")

		-- Detach horse if present
		if self.horse then
			self.horse:set_detach()
			local h_ent = self.horse:get_luaentity()
			if h_ent and h_ent.carriage_orig_size then
				self.horse:set_properties({visual_size = h_ent.carriage_orig_size})
			end
			self.horse = nil
		end

		self.object:remove()
		return true
	end,
}

minetest.register_entity("carriage:carriage_ent", carriage_def)

local animal_speeds = {
	["mob_horse:horse"] = 3,
	["mobs_andes:donkey"] = 2,
	["mobs_mc:horse"] = 3,
	["mobs_mc:donkey"] = 2,
	["mobs_animal:cow"] = 1,
	["people:ridehorse"] = 3,
	["mobs_mc:cow"] = 1,
	["animalia:horse"] = 3,
	["animalia:reindeer"] = 2,
	["animalia:cow"] = 1,
}

-- Helper to check if an entity is a valid mount
local function is_valid_horse(ent)
	if not ent then return false end
	local luaent = ent:get_luaentity()
	if not luaent then return false end
	return animal_speeds[luaent.name] ~= nil
end

-- Mounting and Horse logic
carriage_def.on_rightclick = function(self, clicker)
	if not clicker or not clicker:is_player() then return end

	-- Attach player
	local name = clicker:get_player_name()
	if self.driver1 and self.driver1:get_player_name() == name then
		-- Detach driver1
		self.driver1:set_detach()
		self.driver1:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
		if self.driver1_orig_size then
			self.driver1:set_properties({visual_size = self.driver1_orig_size})
		end
		if player_api then
			player_api.player_attached[name] = false
			player_api.set_animation(self.driver1, "stand")
		elseif default and default.player_attached then
			default.player_attached[name] = false
			default.player_set_animation(self.driver1, "stand")
		end
		self.driver1 = nil
		self.driver1_orig_size = nil
		return
	elseif self.driver2 and self.driver2:get_player_name() == name then
		-- Detach driver2
		self.driver2:set_detach()
		self.driver2:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
		if self.driver2_orig_size then
			self.driver2:set_properties({visual_size = self.driver2_orig_size})
		end
		if player_api then
			player_api.player_attached[name] = false
			player_api.set_animation(self.driver2, "stand")
		elseif default and default.player_attached then
			default.player_attached[name] = false
			default.player_set_animation(self.driver2, "stand")
		end
		self.driver2 = nil
		self.driver2_orig_size = nil
		return
	end

	if not self.driver1 then
		self.driver1 = clicker
		local props = clicker:get_properties()
		self.driver1_orig_size = props.visual_size or {x=1, y=1, z=1}
		local orig = self.driver1_orig_size
		local c_size = self.object:get_properties().visual_size or {x=1, y=1, z=1}
		clicker:set_properties({visual_size = {x = orig.x / c_size.x, y = orig.y / c_size.y, z = orig.z / c_size.z}})

		-- Fix scale multiplication effect on position by reducing offset, and remove 180 rotation since parent scales implicitly rotates child
		clicker:set_attach(self.object, "", self.driver1_offset, {x=0, y=0, z=0})
		clicker:set_eye_offset({x=0, y=5, z=0}, {x=0, y=5, z=0})
		if player_api then
			player_api.player_attached[name] = true
			player_api.set_animation(clicker, "sit")
		elseif default and default.player_attached then
			default.player_attached[name] = true
			default.player_set_animation(clicker, "sit")
		end
	elseif not self.driver2 then
		self.driver2 = clicker
		local props = clicker:get_properties()
		self.driver2_orig_size = props.visual_size or {x=1, y=1, z=1}
		local orig = self.driver2_orig_size
		local c_size = self.object:get_properties().visual_size or {x=1, y=1, z=1}
		clicker:set_properties({visual_size = {x = orig.x / c_size.x, y = orig.y / c_size.y, z = orig.z / c_size.z}})

		clicker:set_attach(self.object, "", self.driver2_offset, {x=0, y=0, z=0})
		clicker:set_eye_offset({x=0, y=5, z=0}, {x=0, y=5, z=0})
		if player_api then
			player_api.player_attached[name] = true
			player_api.set_animation(clicker, "sit")
		elseif default and default.player_attached then
			default.player_attached[name] = true
			default.player_set_animation(clicker, "sit")
		end
	end
end

local function find_and_attach_horse(self)
	if self.horse and self.horse:get_pos() then
		-- Check if still valid and alive
		if self.horse:get_hp() > 0 then
			return
		end
		self.horse = nil
	end

	local pos = self.object:get_pos()
	local yaw = self.object:get_yaw() or 0
	-- Front direction
	local dir = minetest.yaw_to_dir(yaw)
	-- Look for horse in front
	local search_pos = vector.add(pos, vector.multiply(dir, 1.5))

	local objs = minetest.get_objects_inside_radius(search_pos, 2.5)
	for _, obj in ipairs(objs) do
		if is_valid_horse(obj) then
			self.horse = obj

			local h_ent = obj:get_luaentity()
			local props = obj:get_properties()
			h_ent.carriage_orig_size = h_ent.carriage_orig_size or props.visual_size

			-- Counteract inherited scale from carriage
			local orig = h_ent.carriage_orig_size
			local c_size = self.object:get_properties().visual_size or {x=1, y=1, z=1}
			local new_size = {x = orig.x / c_size.x, y = orig.y / c_size.y, z = orig.z / c_size.z}
			obj:set_properties({visual_size = new_size})

			local rot = {x=0, y=0, z=0}
			if h_ent.name == "mobs_andes:donkey" then
				rot = {x=0, y=180, z=0}
			end

			local attach_rot_offset = self.animal_attach_rot or 0
			rot.y = rot.y + attach_rot_offset
			local attach_z = self.horse_attach_z or -2

			-- We don't attach the horse to the carriage because the horse needs to walk.
			-- Instead, we will attach the carriage to the horse?
			-- Wait, if we attach the carriage to the horse, we can't control the carriage.
			-- Actually, it's better to just keep a reference to the horse and move the horse with the carriage,
			-- OR move the carriage and teleport/attach the horse.
			-- Let's attach the horse to the carriage! The user says "it only drives if donkey or horse is mounted".
			-- If we attach the horse, we can play its walk animation when moving.
			self.horse:set_attach(self.object, "", {x=0, y=0, z=attach_z}, rot)
			break
		end
	end
end

-- Update base carriage
carriage_def.find_and_attach_horse = find_and_attach_horse

-- Driving Logic
local function get_sign(i)
	if i == 0 then return 0 end
	if i < 0 then return -1 end
	return 1
end

carriage_def.on_step = function(self, dtime)
	-- Gravity
	local vel = self.object:get_velocity()
	vel.y = vel.y - 9.81 * dtime

	-- Horse logic
	self:find_and_attach_horse()

	-- Validate drivers
	if self.driver1 and (not self.driver1:is_player() or not self.driver1:get_pos()) then
		self.driver1 = nil
	end
	if self.driver2 and (not self.driver2:is_player() or not self.driver2:get_pos()) then
		self.driver2 = nil
	end

	-- Control logic
	if self.driver1 then
		local ctrl = self.driver1:get_player_control()

		-- Determine max speed based on animal
		local max_v = 3
		if self.horse then
			local h_ent = self.horse:get_luaentity()
			if h_ent and animal_speeds[h_ent.name] then
				max_v = animal_speeds[h_ent.name]
			end
		end

		self.v = math.min(self.v, max_v)

		-- Throttle
		if ctrl.up and not self.was_up then
			self.v = math.min(self.v + 1, max_v)
		elseif ctrl.down and not self.was_down then
			self.v = math.max(self.v - 1, 0)
		end
		self.was_up = ctrl.up
		self.was_down = ctrl.down

		-- Steering
		local turn_speed = 0
		if self.v > 0 then
			if ctrl.left then
				turn_speed = 1.5
			elseif ctrl.right then
				turn_speed = -1.5
			end
		end

		local yaw = self.object:get_yaw()
		yaw = yaw + turn_speed * dtime
		self.object:set_yaw(yaw)

		-- Set horse animation if moving
		if self.horse then
			local h_ent = self.horse:get_luaentity()
			if h_ent and h_ent.set_animation then
				if self.v > 0 then
					h_ent:set_animation("walk")
				else
					h_ent:set_animation("stand")
				end
			end
		end

		-- Calculate target velocity based on yaw and v
		local speed_mult = {0, 2, 4, 6} -- speeds 0, 1, 2, 3
		local current_speed = speed_mult[self.v + 1]

		if not self.horse then
			current_speed = 0 -- Cannot drive without horse
			self.v = 0
		end

		local dir = minetest.yaw_to_dir(yaw)
		local target_vel = vector.multiply(dir, current_speed)
		vel.x = target_vel.x
		vel.z = target_vel.z

		-- Obstacle detection (cliff, lava, wall)
		if current_speed > 0 then
			local pos = self.object:get_pos()
			local front_pos = vector.add(pos, vector.multiply(dir, 3))
			front_pos.y = front_pos.y + 0.5

			local node_front = minetest.get_node(front_pos)
			local def_front = minetest.registered_nodes[node_front.name]

			local stop = false
			-- Solid wall in front
			if def_front and def_front.walkable then
				-- Check if we can step over it (stepheight)
				local top_pos = vector.add(front_pos, {x=0, y=1, z=0})
				local node_top = minetest.get_node(top_pos)
				local def_top = minetest.registered_nodes[node_top.name]
				if def_top and def_top.walkable then
					stop = true
				end
			end

			-- Lava in front
			local node_ground = minetest.get_node({x=front_pos.x, y=pos.y-0.5, z=front_pos.z})
			if minetest.get_item_group(node_ground.name, "lava") > 0 then
				stop = true
			end

			-- Cliff (drop > 1 block)
			local def_ground = minetest.registered_nodes[node_ground.name]
			local node_below1 = minetest.get_node({x=front_pos.x, y=pos.y-1.5, z=front_pos.z})
			local node_below2 = minetest.get_node({x=front_pos.x, y=pos.y-2.5, z=front_pos.z})
			local def_below1 = minetest.registered_nodes[node_below1.name]
			local def_below2 = minetest.registered_nodes[node_below2.name]

			if (not def_ground or not def_ground.walkable) and (not def_below1 or not def_below1.walkable) and (not def_below2 or not def_below2.walkable) then
				-- It's a deep drop, water might be okay if drowning logic handles it
				if node_below1.name ~= "air" and minetest.get_item_group(node_below1.name, "water") > 0 then
					-- Water is fine
				else
					stop = true
				end
			end

			if stop then
				vel.x = 0
				vel.z = 0
			end
		end

	else
		-- No driver1
		self.v = 0
		vel.x = 0
		vel.z = 0
		if self.horse then
			local h_ent = self.horse:get_luaentity()
			if h_ent and h_ent.set_animation then
				h_ent:set_animation("stand")
			end
		end
	end

	self.object:set_velocity(vel)
end



-- Helper to clone tables shallowly
local function copy_table(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

local function create_inventory(self)
	local inv = minetest.create_detached_inventory(self.inv_id, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
		allow_put = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
	})
	inv:set_size("main", 64) -- 2 chests

	return inv
end

-------------------------------------------------------------------------------
-- Carriage Model K
-------------------------------------------------------------------------------
local model_k_def = copy_table(carriage_def)
model_k_def.initial_properties = copy_table(carriage_def.initial_properties)
model_k_def.initial_properties.mesh = "model-k.gltf"
model_k_def.initial_properties.textures = {"colormap.png"}
model_k_def.initial_properties.visual_size = {x = 25, y = 25, z = 25}
model_k_def.horse_attach_z = 0.8
model_k_def.animal_attach_rot = 0
model_k_def.driver1_offset = {x=-0.2, y=0.33, z=0}
model_k_def.driver2_offset = {x=0.2, y=0.33, z=0}

model_k_def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if not puncher or not puncher:is_player() then return true end

	local pos = self.object:get_pos()
	if not pos then return true end

	local hp = self.object:get_hp()
	hp = hp - 1
	self.object:set_hp(hp)
	if hp > 0 then return true end

	-- If players are attached, detach them
	if self.driver1 then
		local name = self.driver1:get_player_name()
		self.driver1:set_detach()
		self.driver1:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
		if self.driver1_orig_size then
			self.driver1:set_properties({visual_size = self.driver1_orig_size})
		end
		if player_api then
			player_api.player_attached[name] = false
			player_api.set_animation(self.driver1, "stand")
		elseif default and default.player_attached then
			default.player_attached[name] = false
			default.player_set_animation(self.driver1, "stand")
		end
		self.driver1 = nil
		self.driver1_orig_size = nil
	end
	if self.driver2 then
		local name = self.driver2:get_player_name()
		self.driver2:set_detach()
		self.driver2:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
		if self.driver2_orig_size then
			self.driver2:set_properties({visual_size = self.driver2_orig_size})
		end
		if player_api then
			player_api.player_attached[name] = false
			player_api.set_animation(self.driver2, "stand")
		elseif default and default.player_attached then
			default.player_attached[name] = false
			default.player_set_animation(self.driver2, "stand")
		end
		self.driver2 = nil
		self.driver2_orig_size = nil
	end

	-- Return materials
	minetest.add_item(pos, item_steel .. " 6")

	-- Detach horse if present
	if self.horse then
		self.horse:set_detach()
		local h_ent = self.horse:get_luaentity()
		if h_ent and h_ent.carriage_orig_size then
			self.horse:set_properties({visual_size = h_ent.carriage_orig_size})
		end
		self.horse = nil
	end

	self.object:remove()
	return true
end

model_k_def.on_step = function(self, dtime)
	carriage_def.on_step(self, dtime)

	local vel = self.object:get_velocity()
	if vel and (vel.x ~= 0 or vel.z ~= 0) then
		if self._wheel_anim_state ~= "spin" then
			self.object:set_animation({x=0, y=30}, 30, 0, true)
			self._wheel_anim_state = "spin"
		end
	else
		if self._wheel_anim_state ~= "stop" then
			self.object:set_animation({x=0, y=0}, 0, 0)
			self._wheel_anim_state = "stop"
		end
	end
end

minetest.register_entity("carriage:model_k_ent", model_k_def)

-------------------------------------------------------------------------------
-- Carriage Model KT (Transport)
-------------------------------------------------------------------------------
local model_kt_def = copy_table(carriage_def)
model_kt_def.initial_properties = copy_table(carriage_def.initial_properties)
model_kt_def.initial_properties.mesh = "model-kt.gltf"
model_kt_def.initial_properties.textures = {"colormap.png"}
model_kt_def.initial_properties.visual_size = {x = 25, y = 25, z = 25}
model_kt_def.horse_attach_z = 0.8
model_kt_def.animal_attach_rot = 0

-- Reset player mounting logic for KT
model_kt_def.on_rightclick = function(self, clicker)
	if not clicker or not clicker:is_player() then return end

	if not self.inv_id then
		self.inv_id = "carriage_inv_" .. self.id
		create_inventory(self)
	end

	local formspec
	if mcl and mcl_formspec then
		local label_color = mcl_formspec.label_color or "#313131"

		if mcl_formspec.get_itemslot_bg_v4 then
			local label = "label[0.375,0.375;" .. minetest.formspec_escape(minetest.colorize(label_color, S("Carriage Model KT"))) .. "]"
			local inv_label = "label[0.375,10.95;" .. minetest.formspec_escape(minetest.colorize(label_color, S("Inventory"))) .. "]"

			-- Center 8x8 inventory in 11.75 width -> (11.75 - (8 * 1.25)) / 2 = 0.875
			local inv_bg = mcl_formspec.get_itemslot_bg_v4(0.875, 0.75, 8, 8)

			-- Standard Mineclone offset for 11.75 width is 0.375.
			local player_bg1 = mcl_formspec.get_itemslot_bg_v4(0.375, 11.35, 9, 3)
			local player_bg2 = mcl_formspec.get_itemslot_bg_v4(0.375, 15.3, 9, 1)

			formspec = "formspec_version[4]size[11.75,16.675]" ..
				label ..
				inv_bg ..
				"list[detached:" .. self.inv_id .. ";main;0.875,0.75;8,8;]" ..
				inv_label ..
				player_bg1 ..
				"list[current_player;main;0.375,11.35;9,3;9]" ..
				player_bg2 ..
				"list[current_player;main;0.375,15.3;9,1;]" ..
				"listring[detached:" .. self.inv_id .. ";main]" ..
				"listring[current_player;main]"
		else
			local label = "label[0,0;" .. minetest.formspec_escape(minetest.colorize(label_color, S("Carriage Model KT"))) .. "]"
			local inv_label = "label[0,8.7;" .. minetest.formspec_escape(minetest.colorize(label_color, S("Inventory"))) .. "]"
			local get_bg = mcl_formspec.get_itemslot_bg
			local player_bg1 = get_bg(0, 9.2, 9, 3)
			local player_bg2 = get_bg(0, 12.4, 9, 1)
			local inv_bg = get_bg(0.5, 0.5, 8, 8)

			formspec = "size[9,13.65]" ..
				label ..
				inv_bg ..
				"list[detached:" .. self.inv_id .. ";main;0.5,0.5;8,8;]" ..
				inv_label ..
				player_bg1 ..
				"list[current_player;main;0,9.2;9,3;9]" ..
				player_bg2 ..
				"list[current_player;main;0,12.4;9,1;]" ..
				"listring[detached:" .. self.inv_id .. ";main]" ..
				"listring[current_player;main]"
		end
	else
		formspec = "size[8,13]" ..
			"list[detached:" .. self.inv_id .. ";main;0,0;8,8;]" ..
			"list[current_player;main;0,9;8,4;]"
	end

	minetest.show_formspec(clicker:get_player_name(), "carriage:inv_" .. self.id, formspec)
end

model_kt_def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if not puncher or not puncher:is_player() then return true end

	local pos = self.object:get_pos()
	if not pos then return true end

	local hp = self.object:get_hp()
	hp = hp - 1
	self.object:set_hp(hp)
	if hp > 0 then return true end

	-- Drop stored items
	if self.inv_id then
		local inv = minetest.get_inventory({type="detached", name=self.inv_id})
		if inv then
			local list = inv:get_list("main")
			if list then
				for _, item in ipairs(list) do
					if item and not item:is_empty() then
						minetest.add_item(pos, item)
					end
				end
			end
		end
	end

	-- Return materials
	minetest.add_item(pos, item_wool .. " 3")
	minetest.add_item(pos, item_steel .. " 3")

	-- Detach horse if present
	if self.horse then
		self.horse:set_detach()
		local h_ent = self.horse:get_luaentity()
		if h_ent and h_ent.carriage_orig_size then
			self.horse:set_properties({visual_size = h_ent.carriage_orig_size})
		end
		self.horse = nil
	end

	self.object:remove()
	return true
end

model_kt_def.on_activate = function(self, staticdata, dtime_s)
	self.object:set_armor_groups({immortal = 1})

	self.driver1 = nil
	self.driver2 = nil
	self.horse = nil

	local data = {}
	if staticdata ~= "" then
		data = minetest.deserialize(staticdata) or {}
	end

	self.id = data.id or (tostring(math.random(1, 999999)) .. "_" .. tostring(os.time()))
	self.owner_name = data.owner_name or ""

	self.inv_id = "carriage_inv_" .. self.id
	local inv = create_inventory(self)

	if data.inv_list then
		inv:set_list("main", data.inv_list)
	end
end

model_kt_def.get_staticdata = function(self)
	local inv_list = {}
	if self.inv_id then
		local inv = minetest.get_inventory({type="detached", name=self.inv_id})
		if inv then
			local list = inv:get_list("main")
			if list then
				for i, item in ipairs(list) do
					inv_list[i] = item:to_string()
				end
			end
		end
	end

	local data = {
		id = self.id,
		owner_name = self.owner_name,
		inv_list = inv_list
	}

	return minetest.serialize(data) or ""
end

model_kt_def.on_step = function(self, dtime)
	-- Gravity
	local vel = self.object:get_velocity()
	vel.y = vel.y - 9.81 * dtime

	-- Horse logic
	find_and_attach_horse(self)

	-- Autonomous Follow Logic
	if self.horse and self.owner_name and self.owner_name ~= "" then
		local player_obj = nil
		local pos = self.object:get_pos()
		local objs = minetest.get_objects_inside_radius(pos, 50)
		for _, obj in ipairs(objs) do
			if obj:is_player() and obj:get_player_name() == self.owner_name then
				player_obj = obj
				break
			end
		end

		if player_obj then
			local target_pos = player_obj:get_pos()
			local dist = vector.distance(pos, target_pos)

			local yaw = self.object:get_yaw() or 0
			local dir = minetest.yaw_to_dir(yaw)

			local target_dir = vector.direction(pos, target_pos)
			local target_yaw = minetest.dir_to_yaw(target_dir)

			-- Steering
			if dist > 8 then
				local diff = target_yaw - yaw
				if diff > math.pi then diff = diff - 2*math.pi end
				if diff < -math.pi then diff = diff + 2*math.pi end

				local turn_speed = math.max(-1.5, math.min(1.5, diff * 2))
				yaw = yaw + turn_speed * dtime
				self.object:set_yaw(yaw)
			end

			-- Throttle/Speed
			local max_v = 3
			if self.horse then
				local h_ent = self.horse:get_luaentity()
				if h_ent and animal_speeds[h_ent.name] then
					max_v = animal_speeds[h_ent.name]
				end
			end

			if dist > 10 then
				self.v = 3
			elseif dist > 9 then
				self.v = 2
			elseif dist > 8 then
				self.v = 1
			else
				self.v = 0
			end

			self.v = math.min(self.v, max_v)
		else
			self.v = 0
		end
	else
		self.v = 0
	end

	-- Set horse animation if moving
	if self.horse then
		local h_ent = self.horse:get_luaentity()
		if h_ent and h_ent.set_animation then
			if self.v > 0 then
				h_ent:set_animation("walk")
			else
				h_ent:set_animation("stand")
			end
		end
	end

	-- Calculate target velocity based on yaw and v
	local speed_mult = {0, 2, 4, 6} -- speeds 0, 1, 2, 3
	local current_speed = speed_mult[self.v + 1]

	if not self.horse then
		current_speed = 0 -- Cannot drive without horse
		self.v = 0
	end

	local yaw = self.object:get_yaw() or 0
	local dir = minetest.yaw_to_dir(yaw)
	local target_vel = vector.multiply(dir, current_speed)
	vel.x = target_vel.x
	vel.z = target_vel.z

	-- Obstacle detection (cliff, lava, wall)
	if current_speed > 0 then
		local pos = self.object:get_pos()
		local front_pos = vector.add(pos, vector.multiply(dir, 3))
		front_pos.y = front_pos.y + 0.5

		local node_front = minetest.get_node(front_pos)
		local def_front = minetest.registered_nodes[node_front.name]

		local stop = false
		-- Solid wall in front
		if def_front and def_front.walkable then
			-- Check if we can step over it (stepheight)
			local top_pos = vector.add(front_pos, {x=0, y=1, z=0})
			local node_top = minetest.get_node(top_pos)
			local def_top = minetest.registered_nodes[node_top.name]
			if def_top and def_top.walkable then
				stop = true
			end
		end

		-- Lava in front
		local node_ground = minetest.get_node({x=front_pos.x, y=pos.y-0.5, z=front_pos.z})
		if minetest.get_item_group(node_ground.name, "lava") > 0 then
			stop = true
		end

		-- Cliff (drop > 1 block)
		local def_ground = minetest.registered_nodes[node_ground.name]
		local node_below1 = minetest.get_node({x=front_pos.x, y=pos.y-1.5, z=front_pos.z})
		local node_below2 = minetest.get_node({x=front_pos.x, y=pos.y-2.5, z=front_pos.z})
		local def_below1 = minetest.registered_nodes[node_below1.name]
		local def_below2 = minetest.registered_nodes[node_below2.name]

		if (not def_ground or not def_ground.walkable) and (not def_below1 or not def_below1.walkable) and (not def_below2 or not def_below2.walkable) then
			-- It's a deep drop, water might be okay if drowning logic handles it
			if node_below1.name ~= "air" and minetest.get_item_group(node_below1.name, "water") > 0 then
				-- Water is fine
			else
				stop = true
			end
		end

		if stop then
			vel.x = 0
			vel.z = 0
		end
	end

	self.object:set_velocity(vel)

	if vel and (vel.x ~= 0 or vel.z ~= 0) then
		if self._wheel_anim_state ~= "spin" then
			self.object:set_animation({x=0, y=30}, 30, 0, true)
			self._wheel_anim_state = "spin"
		end
	else
		if self._wheel_anim_state ~= "stop" then
			self.object:set_animation({x=0, y=0}, 0, 0)
			self._wheel_anim_state = "stop"
		end
	end
end

minetest.register_entity("carriage:model_kt_ent", model_kt_def)
