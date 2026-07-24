-- Money Bag mod: drag-and-drop GUI bag holding up to 1000 simplecoins
-- Trader compatible: both item names kept, meta synced in real-time

minetest.override_item("simplecoins:coins", {
	stack_max = 100,
})

local BAG_SLOTS = 10  -- 10 slots × 100 coins each = 1,000 max

-- open_bags[player_name] = wield_index at time of open
local open_bags = {}

local function count_bag_inv(inv)
	local total = 0
	for i = 1, BAG_SLOTS do
		local s = inv:get_stack("coins", i)
		if s:get_name() == "simplecoins:coins" then
			total = total + s:get_count()
		end
	end
	return total
end

local function get_formspec(inv_name, total)
	return "size[8.5,8]" ..
		"label[0,0.1;Money Bag \226\128\148 " .. total .. " / 1000 coins]" ..
		"list[detached:" .. inv_name .. ";coins;0,0.7;5,2;]" ..
		"list[current_player;main;0.25,3.2;8,1;]" ..
		"list[current_player;main;0.25,4.45;8,3;8]" ..
		"listring[detached:" .. inv_name .. ";coins]" ..
		"listring[current_player;main]"
end

-- Find the open bag in the player's main inventory.
-- Checks hint_index first, then searches all slots.
local function find_bag_slot(player_inv, hint_index)
	if hint_index then
		local s = player_inv:get_stack("main", hint_index)
		local n = s:get_name()
		if n == "moneybag:bolsa_dinero_1" or n == "moneybag:bolsa_dinero_2" then
			return hint_index, s
		end
	end
	for i = 1, player_inv:get_size("main") do
		local s = player_inv:get_stack("main", i)
		local n = s:get_name()
		if n == "moneybag:bolsa_dinero_1" or n == "moneybag:bolsa_dinero_2" then
			return i, s
		end
	end
	return nil, nil
end

local function apply_coins_to_stack(stack, total)
	stack:set_name(total > 0 and "moneybag:bolsa_dinero_1" or "moneybag:bolsa_dinero_2")
	local meta = stack:get_meta()
	meta:set_int("coins", total)
	meta:set_string("description",
		total > 0 and ("Money Bag (" .. total .. " coins)") or "Empty Money Bag")
	return stack
end

-- Called after any change in the detached inv:
-- updates the bag item's metadata and refreshes the formspec label.
local function sync_to_bag(player_name)
	local player = minetest.get_player_by_name(player_name)
	if not player then return end

	local inv_name = "moneybag_" .. player_name
	local bag_inv = minetest.get_inventory({type = "detached", name = inv_name})
	if not bag_inv then return end

	local total = count_bag_inv(bag_inv)

	local player_inv = player:get_inventory()
	local slot, bag_stack = find_bag_slot(player_inv, open_bags[player_name])
	if slot then
		player_inv:set_stack("main", slot, apply_coins_to_stack(bag_stack, total))
	end

	minetest.show_formspec(player_name, "moneybag:bag", get_formspec(inv_name, total))
end

local function open_bag_gui(player, bag_stack)
	local pname = player:get_player_name()
	open_bags[pname] = player:get_wield_index()

	local meta = bag_stack:get_meta()
	local total = meta:get_int("coins") or 0

	local inv_name = "moneybag_" .. pname
	local inv = minetest.create_detached_inventory(inv_name, {
		allow_put = function(inv, listname, index, stack, player)
			if stack:get_name() == "simplecoins:coins" then
				return stack:get_count()
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
		on_put = function(inv, listname, index, stack, player)
			sync_to_bag(player:get_player_name())
		end,
		on_take = function(inv, listname, index, stack, player)
			sync_to_bag(player:get_player_name())
		end,
	})

	inv:set_size("coins", BAG_SLOTS)

	-- Distribute existing coins across slots (leftmost first)
	local remaining = total
	for i = 1, BAG_SLOTS do
		if remaining > 0 then
			local amount = math.min(remaining, 100)
			inv:set_stack("coins", i, ItemStack("simplecoins:coins " .. amount))
			remaining = remaining - amount
		else
			inv:set_stack("coins", i, ItemStack(""))
		end
	end

	minetest.show_formspec(pname, "moneybag:bag", get_formspec(inv_name, total))
end

local function close_bag_gui(player_name)
	if not open_bags[player_name] then return end
	open_bags[player_name] = nil
	-- Meta is kept in sync in real-time, nothing extra to write.
	-- Clean up the detached inventory.
	if minetest.remove_detached_inventory then
		minetest.remove_detached_inventory("moneybag_" .. player_name)
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "moneybag:bag" then return false end
	if fields.quit then
		close_bag_gui(player:get_player_name())
	end
	return true
end)

minetest.register_on_leaveplayer(function(player)
	close_bag_gui(player:get_player_name())
end)

-- ── Item definitions ─────────────────────────────────────────────────────────

local function use_bag(itemstack, user, pointed_thing)
	if not user or not user:is_player() then return itemstack end
	open_bag_gui(user, itemstack)
	return itemstack
end

minetest.register_craftitem("moneybag:bolsa_dinero_1", {
	description = "Money Bag",
	inventory_image = "bolsa_de_tesoro.png",
	stack_max = 1,
	on_use = use_bag,
	on_place = use_bag,
	on_secondary_use = use_bag,
})

minetest.register_craftitem("moneybag:bolsa_dinero_2", {
	description = "Empty Money Bag",
	inventory_image = "bolsa_de_tesoro2.png",
	stack_max = 1,
	on_use = use_bag,
	on_place = use_bag,
	on_secondary_use = use_bag,
})

-- ── Craft recipes ─────────────────────────────────────────────────────────────

minetest.register_craft({
	output = "moneybag:bolsa_dinero_2 10",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"wool:white",     "wool:white",     "wool:white"},
		{"",               "",               ""},
	},
})
