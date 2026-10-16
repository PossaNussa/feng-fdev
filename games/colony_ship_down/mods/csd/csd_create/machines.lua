-- The machines.

local S = csd_create.S
local ATLAS = "csd_create_atlas.png"
local has_tasks = core.get_modpath("csd_tasks") ~= nil

local function box(...) return {type = "fixed", fixed = {...}} end
local FULL = box({-0.5, -0.5, -0.5, 0.5, 0.5, 0.5})

local function rpm_text(pos)
	local rpm = csd_create.get_rpm(pos)
	if rpm == 0 then
		return csd_create.is_stalled(pos) and core.colorize("#ff6060", S("Overstressed!")) or S("Not turning")
	end
	return S("@1 RPM", math.abs(rpm)) .. (rpm < 0 and " (" .. S("reversed") .. ")" or "")
end

------------------------------------------------------------------------------
-- Hand Crank: hold right-click to turn it. Powers small machines (and the
-- emergency capacitor task).
------------------------------------------------------------------------------

local CRANK_RPM, CRANK_OUTPUT = 32, 512
local cranking = {} -- hash -> time the crank stops

csd_create.register_part("hand_crank_rotor", {
	mesh = "csd_create_hand_crank_rotor.glb", anim = "spin",
	speed = function(pos)
		return (cranking[core.hash_node_position(pos)] or 0) > core.get_us_time() and CRANK_RPM or 0
	end,
})

csd_create.register_machine("csd_create:hand_crank", {
	description = S("Hand Crank") .. "\n" .. core.colorize("#9aa7c0", S("Hold right-click to turn. @1 SU at @2 RPM", CRANK_OUTPUT, CRANK_RPM)),
	drawtype = "mesh",
	mesh = "csd_create_hand_crank_base.glb",
	tiles = {ATLAS},
	use_texture_alpha = "clip",
	selection_box = FULL, collision_box = box({-0.3, -0.3, -0.5, 0.3, 0.3, 0.5}),
	sunlight_propagates = true,
	on_place = csd_create.place_into_clicked,
	_parts = {"hand_crank_rotor"},
	_power = {
		component_type = "generator", rpm = CRANK_RPM, output = CRANK_OUTPUT,
		is_active = function(pos)
			return (cranking[core.hash_node_position(pos)] or 0) > core.get_us_time()
		end,
		infotext = function(pos, info)
			return S("Hand Crank") .. "\n" .. S("Load: @1 / @2 SU", info.stress, info.output)
		end,
	},
	on_rightclick = function(pos, _, clicker)
		local h = core.hash_node_position(pos)
		local was = (cranking[h] or 0) > core.get_us_time()
		cranking[h] = core.get_us_time() + 600000
		if not was then
			core.sound_play("csd_create_crank", {pos = pos, gain = 0.5, max_hear_distance = 12}, true)
		end
	end,
})

------------------------------------------------------------------------------
-- Reactor Turbine: the ship's mechanical power. Output follows the ship's
-- Power system, so when Power runs low the machines slow and stall.
------------------------------------------------------------------------------

local TURBINE_RPM, TURBINE_MAX = 64, 8192

local turbine_power = {
	component_type = "generator", rpm = TURBINE_RPM, output = TURBINE_MAX,
	is_active = function()
		return not has_tasks or csd_tasks.get_system("power") > 5
	end,
	infotext = function(_, info)
		return S("Reactor Turbine") .. "\n" .. S("Output: @1 SU at @2 RPM", info.output, info.rpm) ..
			"\n" .. S("Load: @1 SU", info.stress)
	end,
}

if has_tasks then
	local function retune()
		local p = csd_tasks.get_system("power")
		turbine_power.output = math.floor(TURBINE_MAX * math.max(0.1, p / 100))
	end
	retune()
	csd_tasks.register_on_system_change(function(id)
		if id == "power" then retune() end
	end)
end

csd_create.register_part("turbine_rotor", {mesh = "csd_create_turbine_rotor.glb", anim = "spin"})

csd_create.register_machine("csd_create:turbine", {
	description = S("Reactor Turbine") .. "\n" .. core.colorize("#9aa7c0", S("Drives the ship's machinery. Weakens when ship Power is low.")),
	drawtype = "mesh",
	mesh = "csd_create_turbine_base.glb",
	tiles = {ATLAS},
	selection_box = FULL, collision_box = FULL,
	light_source = 6,
	light_colour = "#66ddff",
	on_place = csd_create.place_across_view,
	_parts = {"turbine_rotor"},
	_power = turbine_power,
})

------------------------------------------------------------------------------
-- Encased Fan: pushes (or, turning backwards, pulls) players and items.
-- Point one up for a lift, along a corridor for a wind tunnel.
------------------------------------------------------------------------------

local FAN_LOAD = 256

csd_create.register_part("fan_rotor", {mesh = "csd_create_encased_fan_rotor.glb", anim = "spin", ratio = 2})

csd_create.register_machine("csd_create:encased_fan", {
	description = S("Encased Fan") .. "\n" .. core.colorize("#9aa7c0", S("Blows away from its shaft. Reverse the rotation to suck. @1 SU", FAN_LOAD)),
	drawtype = "mesh",
	mesh = "csd_create_encased_fan_base.glb",
	tiles = {ATLAS},
	selection_box = FULL, collision_box = FULL,
	on_place = csd_create.place_into_clicked,
	_parts = {"fan_rotor"},
	_power = {
		component_type = "consumer",
		get_load = function() return FAN_LOAD end,
		infotext = function(pos)
			return S("Encased Fan") .. "\n" .. rpm_text(pos)
		end,
	},
})

local fan_timer = 0
core.register_globalstep(function(dtime)
	fan_timer = fan_timer + dtime
	if fan_timer < 0.2 then return end
	local dt = fan_timer
	fan_timer = 0
	for _, entry in pairs(steamified.power_consumers) do
		if entry.name == "csd_create:encased_fan" then
			local pos = entry.pos
			local rpm = csd_create.get_rpm(pos)
			if rpm ~= 0 then
				local node = core.get_node(pos)
				local blow = vector.multiply(csd_create.shaft_dir(node.param2), rpm > 0 and -1 or 1)
				local range = 3 + 6 * math.min(1, math.abs(rpm) / 64)
				local center = vector.add(pos, vector.multiply(blow, range / 2 + 0.5))
				for _, obj in ipairs(core.get_objects_inside_radius(center, range / 2 + 0.6)) do
					local rel = vector.subtract(obj:get_pos(), pos)
					local along = vector.dot(rel, blow)
					local lateral = vector.length(vector.subtract(rel, vector.multiply(blow, along)))
					if along > 0 and along <= range + 0.5 and lateral < 1.2 and not obj:get_attach() then
						local strength = (1 - along / (range + 1)) * math.min(1, math.abs(rpm) / 32)
						local ent = obj:get_luaentity()
						if obj:is_player() or (ent and ent.name == "__builtin:item") then
							obj:add_velocity(vector.multiply(blow, strength * 30 * dt))
						end
					end
				end
				if math.random() < 0.5 then
					core.add_particlespawner({
						amount = 6, time = 0.2,
						pos = {min = vector.add(pos, vector.new(-0.35, -0.35, -0.35)), max = vector.add(pos, vector.new(0.35, 0.35, 0.35))},
						vel = {min = vector.multiply(blow, 4), max = vector.multiply(blow, 7)},
						exptime = range / 6, size = 0.6, texture = "csd_create_wind.png", glow = 4,
					})
				end
			end
		end
	end
end)

------------------------------------------------------------------------------
-- Flywheel: a big spinning wheel that passes rotation through.
------------------------------------------------------------------------------

csd_create.register_part("flywheel", {mesh = "csd_create_flywheel.glb", anim = "spin"})

csd_create.register_machine("csd_create:flywheel", {
	description = S("Flywheel") .. "\n" .. core.colorize("#9aa7c0", S("Passes rotation through. Looks great spinning. 64 SU")),
	drawtype = "airlike",
	inventory_image = "csd_create_flywheel_inv.png",
	wield_image = "csd_create_flywheel_inv.png",
	selection_box = box({-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}),
	collision_box = box({-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}),
	walkable = true, pointable = true, sunlight_propagates = true,
	on_place = csd_create.place_across_view,
	_parts = {"flywheel"},
	_power = {
		component_type = "consumer", passes_through = true,
		get_load = function() return 64 end,
		infotext = function(pos) return S("Flywheel") .. "\n" .. rpm_text(pos) end,
	},
})

------------------------------------------------------------------------------
-- Gauges: a speedometer and a stressometer.
------------------------------------------------------------------------------

local function stress_fraction(pos)
	local p = steamified.powered_positions[core.hash_node_position(pos)]
	if not p or not p.source then return 0 end
	local src = steamified.get_power_source(p.source)
	if not src then return 0 end
	local out = (src.def and src.def.output) or (steamified.motors[p.source] and steamified.config.MOTOR_OUTPUT) or 0
	if out == 0 or out == math.huge then return 0 end
	return math.min(1, (src.current_stress or 0) / out)
end

csd_create.register_part("speed_needle", {
	mesh = "csd_create_gauge_needle.glb", anim = "dial",
	speed = function(pos) return math.abs(csd_create.get_rpm(pos)) / 128 end,
})
csd_create.register_part("stress_needle", {
	mesh = "csd_create_gauge_needle.glb", anim = "dial",
	speed = function(pos) return stress_fraction(pos) end,
})

for _, g in ipairs({
	{"speedometer", S("Speedometer"), "speed_needle", function(pos) return rpm_text(pos) end},
	{"stressometer", S("Stressometer"), "stress_needle", function(pos)
		return S("Network load: @1%", math.floor(stress_fraction(pos) * 100))
	end},
}) do
	csd_create.register_machine("csd_create:" .. g[1], {
		description = g[2],
		drawtype = "mesh",
		mesh = "csd_create_gauge.glb",
		tiles = {ATLAS},
		selection_box = box({-0.38, -0.38, -0.5, 0.38, 0.38, 0.5}),
		collision_box = box({-0.38, -0.38, -0.5, 0.38, 0.38, 0.5}),
		sunlight_propagates = true,
		on_place = csd_create.place_across_view,
		_parts = {g[3]},
		_power = {
			component_type = "consumer", passes_through = true,
			get_load = function() return 0 end,
			infotext = function(pos) return g[2] .. "\n" .. g[4](pos) end,
		},
	})
end

------------------------------------------------------------------------------
-- Emergency Capacitor: a task station. Turn a connected crank to charge it;
-- when full, everyone nearby with the "Charge Capacitor" task gets credit.
------------------------------------------------------------------------------

local CAP_LOAD = 256
local charge = {} -- hash -> 0..100 (kept in node meta too)

local function cap_name(level)
	return level == 0 and "csd_create:capacitor" or "csd_create:capacitor_" .. level
end

local cap_nodes = {}
for level = 0, 3 do
	local name = cap_name(level)
	cap_nodes[#cap_nodes + 1] = name
	csd_create.register_machine(name, {
		description = S("Emergency Capacitor") .. "\n" .. core.colorize("#9aa7c0", S("Charge it with a hand crank. @1 SU", CAP_LOAD)),
		drawtype = "mesh",
		mesh = "csd_create_capacitor.glb",
		tiles = {"csd_create_atlas_charge" .. level .. ".png"},
		selection_box = FULL, collision_box = FULL,
		light_source = 2 + level * 3,
		light_colour = "#66ddff",
		drop = "csd_create:capacitor",
		groups = {csd_station = 1, not_in_creative_inventory = level > 0 and 1 or nil},
		on_place = csd_create.place_into_clicked,
		_power = {
			component_type = "consumer",
			get_load = function() return CAP_LOAD end,
			infotext = function(pos)
				local c = charge[core.hash_node_position(pos)] or core.get_meta(pos):get_float("charge")
				return S("Emergency Capacitor") .. "\n" .. S("Charge: @1%", math.floor(c)) .. "\n" .. rpm_text(pos)
			end,
		},
		on_construct = function(pos)
			if has_tasks then csd_tasks.add_station(pos, "capacitor", csd_tasks.room_name(pos)) end
		end,
		on_destruct = function(pos)
			-- Swapping charge levels uses swap_node, so this only runs on real removal.
			if has_tasks then csd_tasks.remove_station(pos, "capacitor") end
		end,
		on_rightclick = function(pos, _, clicker)
			if clicker and clicker:is_player() then
				local c = charge[core.hash_node_position(pos)] or core.get_meta(pos):get_float("charge")
				core.chat_send_player(clicker:get_player_name(),
					S("Capacitor at @1%. Turn the hand crank connected to it to charge it.", math.floor(c)))
			end
		end,
	})
end

if has_tasks then
	csd_tasks.register_station_kind("capacitor", {
		description = S("Emergency Capacitor"), node = "csd_create:capacitor", nodes = cap_nodes,
	})
	csd_tasks.register_task("charge_capacitor", {
		title = S("Charge Emergency Capacitor"), system = "power", jobs = {"engineer"},
		steps = {{kind = "capacitor"}}, reward = 15,
	})
end

local cap_timer = 0
core.register_globalstep(function(dtime)
	cap_timer = cap_timer + dtime
	if cap_timer < 0.5 then return end
	local dt = cap_timer
	cap_timer = 0
	local swaps = {}
	for h, entry in pairs(steamified.power_consumers) do
		if entry.name:find("^csd_create:capacitor") then
			local pos = entry.pos
			local node = core.get_node_or_nil(pos)
			if node and node.name:find("^csd_create:capacitor") then
				local c = charge[h] or core.get_meta(pos):get_float("charge")
				local rpm = math.abs(csd_create.get_rpm(pos))
				if rpm > 0 then
					c = c + rpm / 32 * 8 * dt
				else
					c = math.max(0, c - 0.5 * dt) -- slowly leaks
				end
				if c >= 100 then
					c = 0
					core.sound_play("csd_create_charged", {pos = pos, gain = 0.8, max_hear_distance = 16}, true)
					if has_tasks then
						for _, obj in ipairs(core.get_objects_inside_radius(pos, 12)) do
							if obj:is_player() then
								csd_tasks.progress_step(obj, "capacitor", pos)
							end
						end
						csd_tasks.add_system("power", 4)
					end
				end
				charge[h] = c
				core.get_meta(pos):set_float("charge", c)
				local level = math.min(3, math.floor(c / 25))
				local want = cap_name(level)
				if node.name ~= want then
					swaps[#swaps + 1] = {pos = pos, node = {name = want, param2 = node.param2}}
				end
			end
		end
	end
	-- Swap after the loop: steamified's tables can't change while we iterate them.
	for _, sw in ipairs(swaps) do
		core.swap_node(sw.pos, sw.node)
		steamified.add_power_node(sw.pos, sw.node.name)
	end
end)

------------------------------------------------------------------------------
-- Mechanical Pump: moves water. Pumps that are turning drain floods (burst
-- pipes) twice as fast.
------------------------------------------------------------------------------

csd_create.register_part("pump_rotor", {mesh = "csd_create_pump_rotor.glb", anim = "spin", ratio = 1.5})

csd_create.register_machine("csd_create:mechanical_pump", {
	description = S("Mechanical Pump") .. "\n" .. core.colorize("#9aa7c0", S("Moves water. Turning pumps drain floods faster. 256 SU")),
	drawtype = "mesh",
	mesh = "csd_create_pump_base.glb",
	tiles = {ATLAS},
	use_texture_alpha = "clip",
	selection_box = FULL, collision_box = FULL,
	on_place = csd_create.place_across_view,
	_parts = {"pump_rotor"},
	_power = {
		component_type = "consumer",
		get_load = function() return 256 end,
		infotext = function(pos) return S("Mechanical Pump") .. "\n" .. rpm_text(pos) end,
	},
})

-- How many pumps are turning right now (loaded ones).
function csd_create.pumps_running()
	local n = 0
	for _, entry in pairs(steamified.power_consumers) do
		if entry.name == "csd_create:mechanical_pump" and csd_create.get_rpm(entry.pos) ~= 0 then n = n + 1 end
	end
	return n
end

------------------------------------------------------------------------------
-- Irrigation Sprinkler: a spinning spray head. While any sprinkler turns,
-- the ship's Hydroponics wear down more slowly.
------------------------------------------------------------------------------

csd_create.register_part("sprinkler_head", {mesh = "csd_create_sprinkler_rotor.glb", anim = "spin", ratio = 0.5})

csd_create.register_machine("csd_create:sprinkler", {
	description = S("Irrigation Sprinkler") .. "\n" .. core.colorize("#9aa7c0", S("Waters the plants around it while turning. 128 SU")),
	drawtype = "mesh",
	mesh = "csd_create_sprinkler_base.glb",
	tiles = {ATLAS},
	selection_box = box({-0.45, -0.5, -0.45, 0.45, 0.2, 0.45}),
	collision_box = box({-0.25, -0.5, -0.25, 0.25, 0.2, 0.25}),
	sunlight_propagates = true,
	on_place = csd_create.place_into_clicked,
	_parts = {"sprinkler_head"},
	_power = {
		component_type = "consumer",
		get_load = function() return 128 end,
		infotext = function(pos) return S("Irrigation Sprinkler") .. "\n" .. rpm_text(pos) end,
	},
})

local water_timer = 0
core.register_globalstep(function(dtime)
	water_timer = water_timer + dtime
	if water_timer < 0.5 then return end
	water_timer = 0
	local sprinkling = false
	for _, entry in pairs(steamified.power_consumers) do
		local rpm = csd_create.get_rpm(entry.pos)
		if rpm ~= 0 then
			if entry.name == "csd_create:sprinkler" then
				sprinkling = true
				local node = core.get_node(entry.pos)
				-- the head is at the end opposite the shaft
				local head = vector.add(entry.pos, vector.multiply(csd_create.shaft_dir(node.param2), -0.3))
				core.add_particlespawner({
					amount = 14, time = 0.5, pos = head,
					vel = {min = vector.new(-3, 0.5, -3), max = vector.new(3, 2, 3)}, acc = vector.new(0, -9, 0),
					exptime = 1.2, size = 0.7, texture = "csd_ship_droplet.png",
				})
			elseif entry.name == "csd_create:mechanical_pump" and math.random() < 0.3 then
				core.add_particlespawner({
					amount = 5, time = 0.5, pos = {min = vector.offset(entry.pos, -0.3, -0.2, -0.45), max = vector.offset(entry.pos, 0.3, 0.3, -0.45)},
					vel = {min = vector.new(0, 0.3, 0), max = vector.new(0, 0.8, 0)}, exptime = 0.8, size = 0.5,
					texture = "csd_ship_droplet.png",
				})
			end
		end
	end
	if has_tasks then
		csd_tasks.decay_multiplier.hydroponics = sprinkling and 0.6 or nil
	end
end)
