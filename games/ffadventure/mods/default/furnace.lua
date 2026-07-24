-- default/furnace.lua

-- support for MT game translation.
local S = default.get_translator

-- List of sound handles for active furnace
local furnace_fire_sounds = {}

--
-- Formspecs
--
-- Soot texture: dark-tinted ash
local soot_texture = "ash_ash.png^[colorize:#000000:204"
local soot_step = 8

-- Ceiling soot stage definitions
local ceiling_soot_stages = {
	{name = "default:soot_ceiling",   box = {-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}},
	{name = "default:soot_ceiling_2", box = {-0.5, 0.125, -0.5, 0.5, 0.5, 0.5}},
	{name = "default:soot_ceiling_3", box = {-0.5, -0.125, -0.5, 0.5, 0.5, 0.5}},
}

-- Map ceiling soot node name to stage index
local ceiling_soot_index = {}
for i, stage in ipairs(ceiling_soot_stages) do
	ceiling_soot_index[stage.name] = i
end

-- Register soot (floor, leveled)
minetest.register_node("default:soot", {
	description = "Soot",
	tiles = {soot_texture},
	inventory_image = soot_texture,
	wield_image = soot_texture,
	paramtype = "light",
	paramtype2 = "leveled",
	buildable_to = true,
	walkable = false,
	pointable = true,
	floodable = true,
	place_param2 = soot_step,
	leveled = soot_step,
	drawtype = "nodebox",
	node_box = {
		type = "leveled",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	groups = {crumbly = 3, falling_node = 1},
	sounds = default.node_sound_sand_defaults(),
	node_placement_prediction = "",

	on_dig = function(pos, node, digger)
		local level = minetest.get_node_level(pos)
		minetest.node_dig(pos, node, digger)
		if minetest.get_node(pos).name == node.name or
				not digger or not digger:is_player() then
			return
		end
		local extra = math.max(0, level / soot_step - 1)
		if extra > 0 then
			core.handle_node_drops(pos, {ItemStack("default:soot " .. tostring(extra))}, digger)
		end
	end,

	on_place = function(itemstack, placer, pointed_thing)
		-- Ceiling placement: pointing at underside of a block
		if pointed_thing.above.y < pointed_thing.under.y then
			local ceil_pos = pointed_thing.above
			local old_node = minetest.get_node(ceil_pos)
			local old_name = old_node.name
			local stage = ceiling_soot_index[old_name]
			if stage then
				-- Stack ceiling soot
				if stage >= 3 then
					minetest.swap_node(ceil_pos, {name = "default:sootblock"})
				else
					minetest.swap_node(ceil_pos, {name = ceiling_soot_stages[stage + 1].name})
				end
				itemstack:take_item()
				return itemstack
			elseif old_name == "air" then
				minetest.set_node(ceil_pos, {name = "default:soot_ceiling"})
				itemstack:take_item()
				return itemstack
			end
			return itemstack
		end

		-- Floor placement: stack on existing soot
		local place_to = pointed_thing.under
		local old_node = minetest.get_node(place_to)
		if old_node.name ~= "default:soot" then
			local node_def = minetest.registered_nodes[old_node.name]
			if node_def and node_def.buildable_to then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
			place_to = pointed_thing.above
			old_node = minetest.get_node(place_to)
			if old_node.name ~= "default:soot" then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		local player_name = placer and placer:is_player()
		player_name = player_name and placer:get_player_name() or ""
		if minetest.is_protected(place_to, player_name) and
				(player_name == "" or
				not minetest.check_player_privs(placer, "protection_bypass")) then
			if player_name == "" then return itemstack end
			minetest.record_protection_violation(place_to, player_name)
			return itemstack
		end
		local level = minetest.get_node_level(place_to)
		level = level + soot_step
		if level >= 64 then
			minetest.swap_node(place_to, {name = "default:sootblock"})
		else
			minetest.set_node_level(place_to, level)
		end
		itemstack:take_item()
		return itemstack
	end,
})

-- Register sootblock (full block)
minetest.register_node("default:sootblock", {
	description = "Soot Block",
	tiles = {soot_texture},
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults(),
	is_ground_content = false,
})

-- Register ceiling soot stages in a loop
for i, stage in ipairs(ceiling_soot_stages) do
	minetest.register_node(stage.name, {
		description = "Ceiling Soot",
		tiles = {soot_texture},
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = stage.box,
		},
		buildable_to = true,
		walkable = false,
		pointable = true,
		groups = {crumbly = 3, ceiling_soot = 1, not_in_creative_inventory = (i > 1 and 1 or nil)},
		sounds = default.node_sound_sand_defaults(),
		drop = "default:soot",
		is_ground_content = false,
	})
end

-- ABM: ceiling soot gravity check — if block above isn't solid, drop as item
minetest.register_abm({
	label = "Ceiling soot gravity check",
	nodenames = {"group:ceiling_soot"},
	interval = 30,
	chance = 1,
	action = function(pos)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local above_node = minetest.get_node(above)
		local above_def = minetest.registered_nodes[above_node.name]
		if not above_def or not above_def.walkable or above_def.buildable_to then
			minetest.remove_node(pos)
			minetest.add_item(pos, "default:soot")
		end
	end,
})

-- Convert smoke at pos into soot (ceiling or floor)
local function smoke_to_soot(pos)
	-- Check above BEFORE removing smoke to determine ceiling vs floor
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local above_node = minetest.get_node(above)
	local above_def = minetest.registered_nodes[above_node.name]
	local above_is_solid = above_def and above_def.walkable and not above_def.buildable_to
	local above_is_ceiling_soot = ceiling_soot_index[above_node.name] ~= nil

	-- Remove the smoke node
	minetest.remove_node(pos)

	-- Ceiling path: solid block above, or existing ceiling soot above (stack into it)
	if above_is_ceiling_soot then
		-- Stack into the ceiling soot node above
		local stage = ceiling_soot_index[above_node.name]
		if stage >= 3 then
			minetest.set_node(above, {name = "default:sootblock"})
		else
			minetest.set_node(above, {name = ceiling_soot_stages[stage + 1].name})
		end
		return
	end

	if above_is_solid then
		-- Place new ceiling soot at smoke's position
		minetest.set_node(pos, {name = "default:soot_ceiling"})
		return
	end

	-- Scan upward to find a ceiling (solid block with ceiling soot below it, or bare solid)
	for dy = 2, 10 do
		local scan = {x = pos.x, y = pos.y + dy, z = pos.z}
		local scan_node = minetest.get_node(scan)
		local scan_stage = ceiling_soot_index[scan_node.name]
		if scan_stage then
			-- Found existing ceiling soot higher up — stack into it
			if scan_stage >= 3 then
				minetest.set_node(scan, {name = "default:sootblock"})
			else
				minetest.set_node(scan, {name = ceiling_soot_stages[scan_stage + 1].name})
			end
			return
		end
		local scan_def = minetest.registered_nodes[scan_node.name]
		if scan_def and scan_def.walkable and not scan_def.buildable_to then
			-- Found a bare ceiling — place soot just below it
			local below_ceil = {x = pos.x, y = pos.y + dy - 1, z = pos.z}
			local below_node = minetest.get_node(below_ceil)
			if below_node.name == "air" then
				minetest.set_node(below_ceil, {name = "default:soot_ceiling"})
			end
			return
		end
		if scan_def and scan_def.walkable then
			break -- hit something solid but buildable_to, stop scanning up
		end
	end

	-- Floor soot: scan downward for walkable surface
	for dy = 0, 49 do
		local check_pos = {x = pos.x, y = pos.y - dy, z = pos.z}
		local check_node = minetest.get_node(check_pos)
		local check_def = minetest.registered_nodes[check_node.name]
		if check_def and check_def.walkable and not check_def.buildable_to then
			-- Place soot on top of this surface
			local soot_pos = {x = pos.x, y = pos.y - dy + 1, z = pos.z}
			local soot_node = minetest.get_node(soot_pos)
			if soot_node.name == "default:soot" then
				local level = minetest.get_node_level(soot_pos)
				level = level + soot_step
				if level >= 64 then
					minetest.swap_node(soot_pos, {name = "default:sootblock"})
				else
					minetest.set_node_level(soot_pos, level)
				end
			elseif soot_node.name == "air" or soot_node.name == "ignore" then
				minetest.set_node(soot_pos, {name = "default:soot", param2 = soot_step})
			end
			return
		end
	end
	-- No ground found within 50 blocks — just discard
end

-- Function to find the next position for the smoke to move to
local function find_next_smoke_position(pos)
	for dy = 1, 1 do
		local new_pos = {x = pos.x, y = pos.y + dy, z = pos.z}
		local node = minetest.get_node(new_pos)
		if node.name == "air" then
			return new_pos
		end
	end

	for dx = -1, 1 do
		local new_pos = {x = pos.x + dx, y = pos.y, z = pos.z}
		local node = minetest.get_node(new_pos)
		if node.name == "air" then
			return new_pos
		end
	end

	for dz = -1, 1 do
		local new_pos = {x = pos.x, y = pos.y, z = pos.z + dz}
		local node = minetest.get_node(new_pos)
		if node.name == "air" then
			return new_pos
		end
	end

	return nil
end

-- Function to move smoke
local function move_smoke(pos)
	local current_node = minetest.get_node(pos)
	if current_node.name ~= "default:smoke" then
		return
	end

	-- Check age via metadata
	local meta = minetest.get_meta(pos)
	local born = meta:get_int("smoke_born")
	if born == 0 then
		-- Missing birth time (shouldn't happen) — convert immediately
		smoke_to_soot(pos)
		return
	end

	local age = os.time() - born
	if age >= 120 then
		smoke_to_soot(pos)
		return
	end

	local next_pos = find_next_smoke_position(pos)

	if next_pos then
		-- Transfer birth time to new position
		minetest.remove_node(pos)
		minetest.set_node(next_pos, {name = "default:smoke"})
		local new_meta = minetest.get_meta(next_pos)
		new_meta:set_int("smoke_born", born)
		minetest.after(3.0, function() move_smoke(next_pos) end)
	else
		minetest.after(3.0, function() move_smoke(pos) end)
	end
end

-- Register the smoke node
minetest.register_node("default:smoke", {
	description = "Smoke",
	drawtype = "glasslike",
	use_texture_alpha = true,
	is_ground_content = false,
	paramtype = "light",
	tiles = {"default_smoke.png"},
	groups = {smoke = 1},
	walkable = false,
	pointable = false,
	damage_per_second = 1,
	buildable_to = true,
})

-- Function to handle smoke logic
local function spawn_smoke(pos)
	minetest.set_node(pos, {name = "default:smoke"})
	local meta = minetest.get_meta(pos)
	meta:set_int("smoke_born", os.time())
	minetest.after(1.0, function() move_smoke(pos) end)
end

-- LBM: convert stale smoke on server load (timer chain broken by restart)
minetest.register_lbm({
	label = "Convert stale smoke to soot",
	name = "default:stale_smoke_to_soot_v1",
	nodenames = {"default:smoke"},
	run_at_every_load = true,
	action = function(pos, node)
		smoke_to_soot(pos)
	end,
})

local function spawn_torchfire(pos)
	minetest.set_node(pos, {name = "fire:basic_flame"})
	end

-- ABM to spawn smoke above fire
minetest.register_abm({
    label = "Spawn Smoke",
    nodenames = {"fire:basic_flame"},
    interval = 30,
    chance = 1,
    action = function(pos)
        local smoke_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local node = minetest.get_node(smoke_pos)
        if node.name == "air" then
            spawn_smoke(smoke_pos)
        end
    end,
})
-- ABM to spawn smoke above fire (excludes enclosed lanterns like clantern)
minetest.register_abm({
    label = "Spawn Torchsmoke",
    nodenames = {"group:torch"},
    interval = 45,
    chance = 2,
    action = function(pos)
        -- Skip enclosed lanterns that don't produce smoke
        local torch_node = minetest.get_node(pos)
        if torch_node.name:find("clantern") then
            return
        end
        local smoke_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local node = minetest.get_node(smoke_pos)
        if node.name == "air" then
            spawn_smoke(smoke_pos)
        end
    end,
})
minetest.register_abm({
    label = "Spawn Torchlight",
    nodenames = {"group:torch"},
    interval = 45,
    chance = 111,
    action = function(pos)
        -- Skip enclosed lanterns that don't cause fires
        local torch_node = minetest.get_node(pos)
        if torch_node.name:find("clantern") then
            return
        end
        local smoke_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local node = minetest.get_node(smoke_pos)
        if node.name == "air" then
            spawn_torchfire(smoke_pos)
        end
    end,
})

function default.get_furnace_active_formspec(fuel_percent, item_percent)
	return "size[8,8.5]"..
		"list[context;src;2.75,0.5;1,1;]"..
		"list[context;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"..
		(fuel_percent)..":default_furnace_fire_fg.png]"..
		"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[lowpart:"..
		(item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
		"list[context;dst;4.75,0.96;2,2;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[context;dst]"..
		"listring[current_player;main]"..
		"listring[context;src]"..
		"listring[current_player;main]"..
		"listring[context;fuel]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0, 4.25)
end

function default.get_furnace_inactive_formspec()
	return "size[8,8.5]"..
		"list[context;src;2.75,0.5;1,1;]"..
		"list[context;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;default_furnace_fire_bg.png]"..
		"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
		"list[context;dst;4.75,0.96;2,2;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[context;dst]"..
		"listring[current_player;main]"..
		"listring[context;src]"..
		"listring[current_player;main]"..
		"listring[context;fuel]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0, 4.25)
end

--
-- Node callback functions that are the same for active and inactive furnace
--

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", S("Furnace is empty"))
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function stop_furnace_sound(pos, fadeout_step)
	local hash = minetest.hash_node_position(pos)
	local sound_ids = furnace_fire_sounds[hash]
	if sound_ids then
		for _, sound_id in ipairs(sound_ids) do
			minetest.sound_fade(sound_id, -1, 0)
		end
		furnace_fire_sounds[hash] = nil
	end
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end
local function kiln_node_timer(pos, elapsed)
	--
	-- Initialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist
	local dst_full = false

	local timer_elapsed = meta:get_int("timer_elapsed") or 0
	meta:set_int("timer_elapsed", timer_elapsed + 1)

	local cookable, cooked
	local fuel

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--
		-- Cooking
		--

		-- Check if we have cookable content
		local aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0

-- Make the kiln cook faster by using a factor less than 1 (e.g., 0.5 for twice as fast)
local speed_factor = 0.5
local el = math.min(elapsed, fuel_totaltime - fuel_time)

if cookable then -- fuel lasts long enough, adjust el to cooking duration
el = math.min(el, cooked.time - src_time)
end

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + el
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						src_time = src_time - cooked.time
						update = true
					else
						dst_full = true
					end
					-- Play cooling sound
					minetest.sound_play("default_cool_lava",
						{pos = pos, max_hear_distance = 16, gain = 0.07}, true)
local smoke_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
local node = minetest.get_node(smoke_pos)
if node.name == "air" then
    spawn_smoke(smoke_pos)
else
    smoke_pos.y = smoke_pos.y + 1
    node = minetest.get_node(smoke_pos)
    if node.name == "air" then
        spawn_smoke(smoke_pos)
    end
end
				else
					-- Item could not be cooked: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- prevent blocking of fuel inventory (for automatization mods)
					local is_fuel = minetest.get_craft_result({method = "fuel", width = 1, items = {afterfuel.items[1]:to_string()}})
					if is_fuel.time == 0 then
						table.insert(fuel.replacements, afterfuel.items[1])
						inv:set_stack("fuel", 1, "")
					else
						-- Take fuel from fuel list
						inv:set_stack("fuel", 1, afterfuel.items[1])
					end
					-- Put replacements in dst list or drop them on the furnace.
					local replacements = fuel.replacements
					if replacements[1] then
						local leftover = inv:add_item("dst", replacements[1])
						if not leftover:is_empty() then
							local above = vector.new(pos.x, pos.y + 1, pos.z)
							local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
							minetest.item_drop(replacements[1], nil, drop_pos)
						end
					end
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist and srclist[1]:is_empty() then
		src_time = 0
	end

	--
	-- Update formspec, infotext and node
	--
	local formspec
	local item_state
	local item_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if dst_full then
			item_state = S("100% (output full)")
		else
			item_state = S("@1%", item_percent)
		end
	else
		if srclist and not srclist[1]:is_empty() then
			item_state = S("Not cookable")
		else
			item_state = S("Empty")
		end
	end

	local fuel_state = S("Empty")
	local active = false
	local result = false

	if fuel_totaltime ~= 0 then
		active = true
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = S("@1%", fuel_percent)
		formspec = default.get_furnace_active_formspec(fuel_percent, item_percent)
		swap_node(pos, "default:kiln_active")
		-- make sure timer restarts automatically
		result = true

		-- Play sound every 5 seconds while the furnace is active
		if timer_elapsed == 0 or (timer_elapsed + 1) % 5 == 0 then
			local sound_id = minetest.sound_play("default_furnace_active",
				{pos = pos, max_hear_distance = 16, gain = 0.25})
			local hash = minetest.hash_node_position(pos)
			furnace_fire_sounds[hash] = furnace_fire_sounds[hash] or {}
			table.insert(furnace_fire_sounds[hash], sound_id)
			-- Only remember the 3 last sound handles
			if #furnace_fire_sounds[hash] > 3 then
				table.remove(furnace_fire_sounds[hash], 1)
			end
			-- Remove the sound ID automatically from table after 11 seconds
			minetest.after(11, function()
				if not furnace_fire_sounds[hash] then
					return
				end
				for f=#furnace_fire_sounds[hash], 1, -1 do
					if furnace_fire_sounds[hash][f] == sound_id then
						table.remove(furnace_fire_sounds[hash], f)
					end
				end
				if #furnace_fire_sounds[hash] == 0 then
					furnace_fire_sounds[hash] = nil
				end
			end)
		end
	else
		if fuellist and not fuellist[1]:is_empty() then
			fuel_state = S("@1%", 0)
		end
		formspec = default.get_furnace_inactive_formspec()
		swap_node(pos, "default:kiln")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
		meta:set_int("timer_elapsed", 0)

		stop_furnace_sound(pos)
	end


	local infotext
	if active then
		infotext = S("Furnace active")
	else
		infotext = S("Furnace inactive")
	end
	infotext = infotext .. "\n" .. S("(Item: @1; Fuel: @2)", item_state, fuel_state)

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)

	return result
end

local function furnace_node_timer(pos, elapsed)
	--
	-- Initialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist
	local dst_full = false

	local timer_elapsed = meta:get_int("timer_elapsed") or 0
	meta:set_int("timer_elapsed", timer_elapsed + 1)

	local cookable, cooked
	local fuel

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--
		-- Cooking
		--

		-- Check if we have cookable content
		local aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0

		local el = math.min(elapsed, fuel_totaltime - fuel_time)
		if cookable then -- fuel lasts long enough, adjust el to cooking duration
			el = math.min(el, cooked.time - src_time)
		end

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + el
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						src_time = src_time - cooked.time
						update = true
					else
						dst_full = true
					end
					-- Play cooling sound
					minetest.sound_play("default_cool_lava",
						{pos = pos, max_hear_distance = 16, gain = 0.07}, true)
local smoke_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
local node = minetest.get_node(smoke_pos)
if node.name == "air" then
    spawn_smoke(smoke_pos)
else
    smoke_pos.y = smoke_pos.y + 1
    node = minetest.get_node(smoke_pos)
    if node.name == "air" then
        spawn_smoke(smoke_pos)
    end
end
				else
					-- Item could not be cooked: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- prevent blocking of fuel inventory (for automatization mods)
					local is_fuel = minetest.get_craft_result({method = "fuel", width = 1, items = {afterfuel.items[1]:to_string()}})
					if is_fuel.time == 0 then
						table.insert(fuel.replacements, afterfuel.items[1])
						inv:set_stack("fuel", 1, "")
					else
						-- Take fuel from fuel list
						inv:set_stack("fuel", 1, afterfuel.items[1])
					end
					-- Put replacements in dst list or drop them on the furnace.
					local replacements = fuel.replacements
					if replacements[1] then
						local leftover = inv:add_item("dst", replacements[1])
						if not leftover:is_empty() then
							local above = vector.new(pos.x, pos.y + 1, pos.z)
							local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
							minetest.item_drop(replacements[1], nil, drop_pos)
						end
					end
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist and srclist[1]:is_empty() then
		src_time = 0
	end

	--
	-- Update formspec, infotext and node
	--
	local formspec
	local item_state
	local item_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if dst_full then
			item_state = S("100% (output full)")
		else
			item_state = S("@1%", item_percent)
		end
	else
		if srclist and not srclist[1]:is_empty() then
			item_state = S("Not cookable")
		else
			item_state = S("Empty")
		end
	end

	local fuel_state = S("Empty")
	local active = false
	local result = false

	if fuel_totaltime ~= 0 then
		active = true
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = S("@1%", fuel_percent)
		formspec = default.get_furnace_active_formspec(fuel_percent, item_percent)
		swap_node(pos, "default:furnace_active")
		-- make sure timer restarts automatically
		result = true

		-- Play sound every 5 seconds while the furnace is active
		if timer_elapsed == 0 or (timer_elapsed + 1) % 5 == 0 then
			local sound_id = minetest.sound_play("default_furnace_active",
				{pos = pos, max_hear_distance = 16, gain = 0.25})
			local hash = minetest.hash_node_position(pos)
			furnace_fire_sounds[hash] = furnace_fire_sounds[hash] or {}
			table.insert(furnace_fire_sounds[hash], sound_id)
			-- Only remember the 3 last sound handles
			if #furnace_fire_sounds[hash] > 3 then
				table.remove(furnace_fire_sounds[hash], 1)
			end
			-- Remove the sound ID automatically from table after 11 seconds
			minetest.after(11, function()
				if not furnace_fire_sounds[hash] then
					return
				end
				for f=#furnace_fire_sounds[hash], 1, -1 do
					if furnace_fire_sounds[hash][f] == sound_id then
						table.remove(furnace_fire_sounds[hash], f)
					end
				end
				if #furnace_fire_sounds[hash] == 0 then
					furnace_fire_sounds[hash] = nil
				end
			end)
		end
	else
		if fuellist and not fuellist[1]:is_empty() then
			fuel_state = S("@1%", 0)
		end
		formspec = default.get_furnace_inactive_formspec()
		swap_node(pos, "default:furnace")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
		meta:set_int("timer_elapsed", 0)

		stop_furnace_sound(pos)
	end


	local infotext
	if active then
		infotext = S("Furnace active")
	else
		infotext = S("Furnace inactive")
	end
	infotext = infotext .. "\n" .. S("(Item: @1; Fuel: @2)", item_state, fuel_state)

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)

	return result
end

--
-- Node definitions
--

minetest.register_node("default:furnace", {
	description = S("Kiln"),
    tiles = {
        "default_furnace_top.png^[colorize:d2b48c:80",
        "default_furnace_bottom.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_front.png^[colorize:d2b48c:80",
    },
	paramtype2 = "facedir",
	groups = {crumbly=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),

	can_dig = can_dig,

	on_timer = furnace_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 4)
		furnace_node_timer(pos, 0)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_take = function(pos)
		-- check whether the furnace is empty or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "fuel", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "default:furnace"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("default:furnace_active", {
	description = S("Kiln"),
    tiles = {
        "default_furnace_top.png^[colorize:d2b48c:80",
        "default_furnace_bottom.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_side.png^[colorize:d2b48c:80",
        "default_furnace_front.png^[colorize:d2b48c:80",
		{
			image = "default_furnace_front_active.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}
	},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:furnace",
	groups = {crumbly=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	on_timer = furnace_node_timer,
	on_destruct = function(pos)
		stop_furnace_sound(pos)
	end,

	can_dig = can_dig,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_craft({
	output = "default:furnace",
    recipe = {
        {"default:clay", "default:clay", "default:clay"},
        {"default:clay", "", "default:clay"},
        {"default:clay", "default:clay", "default:clay"},
    },
})

minetest.register_node("default:kiln", {
	description = S("Furnace"),
    tiles = {
        "default_furnace_top.png",
        "default_furnace_bottom.png",
        "default_furnace_side.png",
        "default_furnace_side.png",
        "default_furnace_side.png",
        "default_furnace_front.png",
    },
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),

	can_dig = can_dig,

	on_timer = kiln_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 2) -- changed size to 2 for two input slots
		inv:set_size('fuel', 1)
		inv:set_size('dst', 4)
		kiln_node_timer(pos, 0)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_take = function(pos)
		-- check whether the furnace is empty or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "fuel", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "default:kiln"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("default:kiln_active", {
	description = S("Kiln"),
    tiles = {
        "default_furnace_top.png",
        "default_furnace_bottom.png",
        "default_furnace_side.png",
        "default_furnace_side.png",
        "default_furnace_side.png",
        "default_furnace_front.png",
		{
			image = "default_furnace_front_active.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}
	},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "default:kiln",
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	on_timer = kiln_node_timer,
	on_destruct = function(pos)
		stop_furnace_sound(pos)
	end,

	can_dig = can_dig,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_craft({
	output = "default:kiln",
    recipe = {
        {"group:stone", "group:stone", "group:stone"},
        {"group:stone", "", "group:stone"},
        {"group:stone", "group:stone", "group:stone"},
    },
})

