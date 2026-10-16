-- Mechanical Press + Depot: put an item on the depot, a powered press above
-- stamps it into something else.

local S = csd_create.S
local ATLAS = "csd_create_atlas.png"

csd_create.pressing = {} -- input item -> output item

function csd_create.register_pressing(input, output)
	csd_create.pressing[input] = output
end

core.register_on_mods_loaded(function()
	for input, output in pairs({
		["default:steel_ingot"] = "basic_materials:steel_strip",
		["default:copper_ingot"] = "basic_materials:copper_strip",
		["default:gold_ingot"] = "basic_materials:gold_strip",
		["default:papyrus"] = "default:paper",
		["farming:wheat"] = "farming:flour",
		["farming:rice"] = "farming:rice_flour",
		["csd_tasks:scrap_metal"] = "csd_tasks:hull_patch",
	}) do
		if core.registered_items[input] and core.registered_items[output] and not csd_create.pressing[input] then
			csd_create.register_pressing(input, output)
		end
	end
end)

------------------------------------------------------------------------------
-- Depot
------------------------------------------------------------------------------

core.register_entity("csd_create:depot_item", {
	initial_properties = {
		visual = "wielditem", wield_item = "air", visual_size = {x = 0.22, y = 0.22},
		physical = false, pointable = false, static_save = false, automatic_rotate = 0.6,
	},
	on_activate = function(self, staticdata)
		if staticdata and staticdata ~= "" then
			self.object:set_properties({wield_item = staticdata})
		end
	end,
})

local function refresh_depot(pos)
	local top = vector.offset(pos, 0, -0.02, 0)
	for _, obj in ipairs(core.get_objects_inside_radius(top, 0.3)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "csd_create:depot_item" then obj:remove() end
	end
	local stack = core.get_meta(pos):get_inventory():get_stack("main", 1)
	if not stack:is_empty() then
		core.add_entity(top, "csd_create:depot_item", stack:get_name())
	end
end
csd_create.refresh_depot = refresh_depot

csd_create.register_machine("csd_create:depot", {
	description = S("Depot") .. "\n" .. core.colorize("#9aa7c0", S("Holds an item for a press above it.")),
	drawtype = "mesh",
	mesh = "csd_create_depot.glb",
	tiles = {ATLAS},
	paramtype2 = "none",
	selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.15, 0.5}},
	collision_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.15, 0.5}},
	on_construct = function(pos)
		core.get_meta(pos):get_inventory():set_size("main", 1)
	end,
	_on_load = refresh_depot,
	on_rightclick = function(pos, _, clicker, itemstack)
		if not clicker or not clicker:is_player() then return itemstack end
		local inv = core.get_meta(pos):get_inventory()
		local held = inv:get_stack("main", 1)
		if held:is_empty() then
			if not itemstack:is_empty() then
				inv:set_stack("main", 1, itemstack)
				itemstack = ItemStack("")
			end
		else
			local leftover = clicker:get_inventory():add_item("main", held)
			inv:set_stack("main", 1, leftover)
		end
		refresh_depot(pos)
		return itemstack
	end,
	can_dig = function(pos)
		return core.get_meta(pos):get_inventory():is_empty("main")
	end,
	on_destruct = function(pos)
		for _, obj in ipairs(core.get_objects_inside_radius(pos, 0.6)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "csd_create:depot_item" then obj:remove() end
		end
	end,
})

------------------------------------------------------------------------------
-- Mechanical Press
------------------------------------------------------------------------------

local PRESS_LOAD = 512

local function press_target(pos)
	local below = vector.offset(pos, 0, -1, 0)
	if core.get_node(below).name ~= "csd_create:depot" then return nil end
	local stack = core.get_meta(below):get_inventory():get_stack("main", 1)
	if stack:is_empty() or not csd_create.pressing[stack:get_name()] then return nil end
	return below, stack
end

csd_create.register_part("press_head", {
	mesh = "csd_create_press_rotor.glb", anim = "stroke",
	speed = function(pos)
		if not press_target(pos) then return 0 end
		return csd_create.get_rpm(pos)
	end,
})

csd_create.register_machine("csd_create:mechanical_press", {
	description = S("Mechanical Press") .. "\n" .. core.colorize("#9aa7c0", S("Presses the item on a depot below. @1 SU", PRESS_LOAD)),
	drawtype = "mesh",
	mesh = "csd_create_press_base.glb",
	tiles = {ATLAS},
	selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}},
	collision_box = {type = "fixed", fixed = {-0.5, 0.05, -0.5, 0.5, 0.5, 0.5}},
	sunlight_propagates = true,
	on_place = csd_create.place_across_view,
	_parts = {"press_head"},
	_power = {
		component_type = "consumer",
		get_load = function() return PRESS_LOAD end,
		infotext = function(pos)
			local rpm = csd_create.get_rpm(pos)
			local _, stack = press_target(pos)
			return S("Mechanical Press") .. "\n" .. (rpm == 0 and S("Not turning") or S("@1 RPM", math.abs(rpm))) ..
				(stack and ("\n" .. S("Pressing: @1", stack:get_short_description())) or "")
		end,
	},
})

-- One stroke takes 64/rpm seconds (matches the head animation); the item
-- converts at the bottom of a stroke.
local progress = {}
local press_timer = 0
core.register_globalstep(function(dtime)
	press_timer = press_timer + dtime
	if press_timer < 0.25 then return end
	local dt = press_timer
	press_timer = 0
	for h, entry in pairs(steamified.power_consumers) do
		if entry.name == "csd_create:mechanical_press" then
			local pos = entry.pos
			local rpm = math.abs(csd_create.get_rpm(pos))
			local depot, stack = press_target(pos)
			if rpm > 0 and depot then
				progress[h] = (progress[h] or 0) + dt * rpm / 64
				if progress[h] >= 0.5 then
					progress[h] = progress[h] - 1
					local out = ItemStack(csd_create.pressing[stack:get_name()])
					out:set_count(stack:get_count())
					core.get_meta(depot):get_inventory():set_stack("main", 1, out)
					refresh_depot(depot)
					core.sound_play("csd_create_press", {pos = pos, gain = 0.7, max_hear_distance = 16}, true)
					core.add_particlespawner({
						amount = 12, time = 0.1, pos = vector.offset(depot, 0, 0.0, 0),
						vel = {min = vector.new(-1.5, 0.5, -1.5), max = vector.new(1.5, 1.5, 1.5)},
						acc = vector.new(0, -6, 0), exptime = 0.5, size = 0.8, texture = "csd_create_spark.png", glow = 10,
					})
				end
			else
				progress[h] = nil
			end
		end
	end
end)
