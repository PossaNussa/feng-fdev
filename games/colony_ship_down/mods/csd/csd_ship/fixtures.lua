-- Fixtures tasks interact with: serving counters (the galley stocks them,
-- anyone eats from them) and water taps (fill watering cans for the planters).

local S = csd_ship.S

------------------------------------------------------------------------------
-- Serving counter
------------------------------------------------------------------------------

local counter_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.375, 0.5}}}

local function counter_formspec(pos)
	local spos = ("%d,%d,%d"):format(pos.x, pos.y, pos.z)
	return table.concat({
		"formspec_version[6]size[10.5,9]",
		"label[0.4,0.5;", core.formspec_escape(S("Serving Counter - help yourself")), "]",
		"list[nodemeta:", spos, ";main;0.4,1;8,1;]",
		"list[current_player;main;0.4,3.6;8,4;]",
		"listring[nodemeta:", spos, ";main]listring[current_player;main]",
	})
end

-- Where the counters are (so the galley can find the mess hall's, however far).
local storage = core.get_mod_storage()
local counters = core.deserialize(storage:get_string("counters")) or {}

local function remember_counter(pos, on)
	counters[core.pos_to_string(pos)] = on or nil
	storage:set_string("counters", core.serialize(counters))
end

function csd_ship.nearest_counter(pos)
	local best, bd
	for key in pairs(counters) do
		local p = core.string_to_pos(key)
		local d = vector.distance(p, pos)
		if not bd or d < bd then best, bd = p, d end
	end
	if best then core.load_area(best) end
	if best and core.get_item_group(core.get_node(best).name, "csd_serving") == 0 then
		remember_counter(best, false)
		return csd_ship.nearest_counter(pos)
	end
	return best
end

function csd_ship.refresh_counter(pos)
	local node = core.get_node(pos)
	local inv = core.get_meta(pos):get_inventory()
	local want = inv:is_empty("main") and "csd_ship:serving_counter" or "csd_ship:serving_counter_full"
	if node.name ~= want then core.swap_node(pos, {name = want, param2 = node.param2}) end
	local n = 0
	for _, st in ipairs(inv:get_list("main")) do n = n + st:get_count() end
	core.get_meta(pos):set_string("infotext", n > 0 and S("Serving Counter: @1 rations", n)
		or S("Serving Counter (empty - the cook prepares rations in the galley)"))
end

for _, full in ipairs({false, true}) do
	local name = full and "csd_ship:serving_counter_full" or "csd_ship:serving_counter"
	core.register_node(name, {
		description = S("Serving Counter"),
		drawtype = "nodebox",
		node_box = counter_box,
		selection_box = counter_box,
		tiles = {full and "csd_ship_counter_top_full.png" or "csd_ship_counter_top.png",
			"csd_ship_wall_dark.png", "csd_ship_counter_side.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {cracky = 2, csd_ship = 1, csd_serving = 1, not_in_creative_inventory = full and 1 or nil},
		drop = "csd_ship:serving_counter",
		is_ground_content = false,
		on_construct = function(pos)
			core.get_meta(pos):get_inventory():set_size("main", 8)
			csd_ship.refresh_counter(pos)
			remember_counter(pos, true)
		end,
		on_destruct = function(pos)
			-- swapping full/empty uses swap_node, so this is only real removal
			remember_counter(pos, false)
		end,
		on_rightclick = function(pos, _, clicker)
			if not clicker or not clicker:is_player() then return end
			local inv = core.get_meta(pos):get_inventory()
			if inv:get_size("main") == 0 then inv:set_size("main", 8) end
			core.show_formspec(clicker:get_player_name(), "csd_ship:counter", counter_formspec(pos))
		end,
		on_metadata_inventory_take = function(pos) csd_ship.refresh_counter(pos) end,
		on_metadata_inventory_put = function(pos) csd_ship.refresh_counter(pos) end,
		can_dig = function(pos)
			return core.get_meta(pos):get_inventory():is_empty("main")
		end,
	})
end

------------------------------------------------------------------------------
-- Water tap
------------------------------------------------------------------------------

core.register_node("csd_ship:water_tap", {
	description = S("Water Tap") .. "\n" .. core.colorize("#9aa7c0", S("Right-click to get or fill a watering can.")),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {
		{-0.3, -0.3, 0.35, 0.3, 0.3, 0.5},       -- wall plate
		{-0.06, 0.0, -0.1, 0.06, 0.12, 0.35},    -- spout
		{-0.06, -0.2, -0.1, 0.06, 0.12, 0.0},
	}},
	tiles = {"csd_ship_tap.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {cracky = 2, csd_ship = 1},
	is_ground_content = false,
	on_rightclick = function(pos, _, clicker, itemstack)
		if not clicker or not clicker:is_player() then return itemstack end
		local name = clicker:get_player_name()
		if not core.registered_items["wateringcan:wateringcan_water"] then return itemstack end
		local inv = clicker:get_inventory()
		local wielded = itemstack:get_name()
		core.sound_play("csd_sfx_locker", {pos = pos, gain = 0.4, pitch = 1.6}, true)
		core.add_particlespawner({
			amount = 12, time = 0.6, pos = vector.offset(pos, 0, -0.2, 0),
			vel = {min = vector.new(0, -2, 0), max = vector.new(0, -1, 0)},
			exptime = 0.5, size = 0.8, texture = "csd_ship_droplet.png",
		})
		if wielded == "wateringcan:wateringcan_empty" or wielded == "wateringcan:wateringcan_water" then
			core.chat_send_player(name, S("Watering can filled."))
			return ItemStack("wateringcan:wateringcan_water")
		end
		if not inv:contains_item("main", "wateringcan:wateringcan_water") and not inv:contains_item("main", "wateringcan:wateringcan_empty") then
			local left = inv:add_item("main", "wateringcan:wateringcan_water")
			if left:is_empty() then
				core.chat_send_player(name, S("You took a full watering can. Use the planters to water them."))
			end
			return itemstack
		end
		core.chat_send_player(name, S("Hold your watering can and right-click to fill it."))
		return itemstack
	end,
})
