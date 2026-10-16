-- bones/init.lua

-- Minetest 0.4 mod: bones
-- See README.txt for licensing and other information.

-- Load support for MT game translation.
local S = minetest.get_translator("bones")

bones = {}

local function is_owner(pos, name)
	local owner = minetest.get_meta(pos):get_string("owner")
	if owner == "" or owner == name or minetest.check_player_privs(name, "protection_bypass") then
		return true
	end
	return false
end

-- Dynamic formspec: adapts to the player's actual hotbar width (8 for legacy, 9 for i3)
local function make_bones_formspec(cols)
	cols = cols or 8
	return
		"size[" .. cols .. ",9]" ..
		"list[current_name;main;0,0.3;" .. cols .. ",4;]" ..
		"list[current_player;main;0,4.85;" .. cols .. ",1;]" ..
		"list[current_player;main;0,6.08;" .. cols .. ",3;" .. cols .. "]" ..
		"listring[current_name;main]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0, 4.85)
end

-- Fallback for old bones placed before this fix
local bones_formspec = make_bones_formspec(8)

local share_bones_time = tonumber(minetest.settings:get("share_bones_time")) or 1200
local share_bones_time_early = tonumber(minetest.settings:get("share_bones_time_early")) or share_bones_time / 4

--------------------------------------------------------------------------------
-- Named corpses (shared by village_life and mob_remains)
--
-- A body is a public `bones:bones` node -- owner deliberately blank so anybody
-- may loot and dig it -- carrying the dead thing's belongings and its name. The
-- name is kept on the node as `bones:display` ("Thorn", "Zombie"); when the body
-- is emptied the reclaimed bones item is stamped with it, so the thing in your
-- pack reads "Thorn's Bones" rather than a generic "Bones".
--------------------------------------------------------------------------------

-- The bones item a looter gets when a body is emptied, stamped with the dead
-- thing's name if the node carried one.
local function corpse_item(meta)
	local stack = ItemStack("bones:bones")
	local display = meta:get_string("bones:display")
	if display ~= "" then
		stack:get_meta():set_string("description", display .. "'s Bones")
	end
	return stack
end

-- Where a body dropped at `pos` can rest: air, a replaced liquid, or any
-- buildable_to node. Falls a couple of nodes first, then looks nearby, so a
-- thing that dies in the air still leaves a body on the ground.
local function may_replace(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then return false end
	if node.name == "air" then return true end
	local def = minetest.registered_nodes[node.name]
	if not def then return false end
	if def.liquidtype and def.liquidtype ~= "none" then return true end
	return def.buildable_to == true
end

local function find_corpse_spot(pos)
	if may_replace(pos) then return pos end
	for dy = -1, -2, -1 do
		local p = {x = pos.x, y = pos.y + dy, z = pos.z}
		if may_replace(p) then return p end
	end
	return minetest.find_node_near(pos, 2, {"air"})
end
bones.find_corpse_spot = find_corpse_spot

-- Lay a body at (or just below) `pos`.
--   opts.display  -- name stamped onto the reclaimed bones item ("Zombie")
--   opts.infotext -- hover text (defaults to "Remains of <display>")
--   opts.items    -- list of itemstrings / ItemStacks the body carries
-- Returns the node position, or nil if no spot was free (the caller should then
-- drop the items loose so nothing is lost).
function bones.place_corpse(pos, opts)
	opts = opts or {}
	if not minetest.registered_nodes["bones:bones"] then return end
	pos = vector.round(pos)

	local spot = find_corpse_spot(pos)
	if not spot then return end

	local items = opts.items or {}
	minetest.set_node(spot, {name = "bones:bones", param2 = 0})

	local meta = minetest.get_meta(spot)
	local inv = meta:get_inventory()
	-- 8x4, matching the formspec below. Anything that doesn't fit spills loose so
	-- it isn't lost in slots the looter can never see.
	inv:set_size("main", 8 * 4)
	for _, it in ipairs(items) do
		local stack = ItemStack(it)
		if not stack:is_empty() then
			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else
				minetest.add_item(spot, stack)
			end
		end
	end

	-- Owner blank == public: anybody may open and dig it, which is what looting
	-- and burying a corpse needs. (See is_owner above.)
	meta:set_string("owner", "")
	if opts.display and opts.display ~= "" then
		meta:set_string("bones:display", opts.display)
	end
	meta:set_string("infotext", opts.infotext
			or (opts.display and ("Remains of " .. opts.display))
			or "Remains")
	meta:set_string("formspec", make_bones_formspec(8))

	return spot
end

local bones_def = {
	description = S("Bones"),
	tiles = {
		"bones_top.png^[transform2",
		"bones_bottom.png",
		"bones_side.png",
		"bones_side.png",
		"bones_rear.png",
		"bones_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	groups = {dig_immediate = 2},
	sounds = default.node_sound_gravel_defaults(),

	can_dig = function(pos, player)
		local inv = minetest.get_meta(pos):get_inventory()
		local name = ""
		if player then
			name = player:get_player_name()
		end
		return is_owner(pos, name) and inv:is_empty("main")
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if is_owner(pos, player:get_player_name()) then
			return count
		end
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if is_owner(pos, player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if meta:get_inventory():is_empty("main") then
			local inv = player:get_inventory()
			local item = corpse_item(meta)
			if inv:room_for_item("main", item) then
				inv:add_item("main", item)
			else
				minetest.add_item(pos, item)
			end
			minetest.remove_node(pos)
		end
	end,

	on_punch = function(pos, node, player)
		if not is_owner(pos, player:get_player_name()) then
			return
		end

		if minetest.get_meta(pos):get_string("infotext") == "" then
			return
		end

		local inv = minetest.get_meta(pos):get_inventory()
		local player_inv = player:get_inventory()
		local has_space = true

		for i = 1, inv:get_size("main") do
			local stk = inv:get_stack("main", i)
			if player_inv:room_for_item("main", stk) then
				inv:set_stack("main", i, nil)
				player_inv:add_item("main", stk)
			else
				has_space = false
				break
			end
		end

		-- remove bones if player emptied them
		if has_space then
			local item = corpse_item(minetest.get_meta(pos))
			if player_inv:room_for_item("main", item) then
				player_inv:add_item("main", item)
			else
				minetest.add_item(pos, item)
			end
			minetest.remove_node(pos)
		end
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local time = meta:get_int("time") + elapsed
		if time >= share_bones_time then
			meta:set_string("infotext", S("@1's old bones", meta:get_string("owner")))
			meta:set_string("owner", "")
		else
			meta:set_int("time", time)
			return true
		end
	end,
	on_blast = function(pos)
	end,
}

default.set_inventory_action_loggers(bones_def, "bones")

minetest.register_node("bones:bones", bones_def)

local function may_replace(pos, player)
	local node_name = minetest.get_node(pos).name
	local node_definition = minetest.registered_nodes[node_name]

	-- if the node is unknown, we return false
	if not node_definition then
		return false
	end

	-- allow replacing air
	if node_name == "air" then
		return true
	end

	-- don't replace nodes inside protections
	if minetest.is_protected(pos, player:get_player_name()) then
		return false
	end

	-- allow replacing liquids
	if node_definition.liquidtype ~= "none" then
		return true
	end

	-- don't replace filled chests and other nodes that don't allow it
	local can_dig_func = node_definition.can_dig
	if can_dig_func and not can_dig_func(pos, player) then
		return false
	end

	-- default to each nodes buildable_to; if a placed block would replace it, why shouldn't bones?
	-- flowers being squished by bones are more realistical than a squished stone, too
	return node_definition.buildable_to
end

local drop = function(pos, itemstack)
	local obj = minetest.add_item(pos, itemstack:take_item(itemstack:get_count()))
	if obj then
		obj:set_velocity({
			x = math.random(-10, 10) / 9,
			y = 5,
			z = math.random(-10, 10) / 9,
		})
	end
end

local player_inventory_lists = { "main", "craft" }
bones.player_inventory_lists = player_inventory_lists

local function is_all_empty(player_inv)
	for _, list_name in ipairs(player_inventory_lists) do
		if not player_inv:is_empty(list_name) then
			return false
		end
	end
	return true
end

minetest.register_on_dieplayer(function(player)
	local bones_mode = minetest.settings:get("bones_mode") or "bones"
	if bones_mode ~= "bones" and bones_mode ~= "drop" and bones_mode ~= "keep" then
		bones_mode = "bones"
	end

	local bones_position_message = minetest.settings:get_bool("bones_position_message") == true
	local player_name = player:get_player_name()
	local pos = vector.round(player:get_pos())
	local pos_string = minetest.pos_to_string(pos)

	-- return if keep inventory set or in creative mode
	if bones_mode == "keep" or minetest.is_creative_enabled(player_name) then
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". No bones placed")
		if bones_position_message then
			minetest.chat_send_player(player_name, S("@1 died at @2.", player_name, pos_string))
		end
		return
	end

	local player_inv = player:get_inventory()
	if is_all_empty(player_inv) then
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". No bones placed")
		if bones_position_message then
			minetest.chat_send_player(player_name, S("@1 died at @2.", player_name, pos_string))
		end
		return
	end

	-- check if it's possible to place bones, if not find space near player
	if bones_mode == "bones" and not may_replace(pos, player) then
		local air = minetest.find_node_near(pos, 1, {"air"})
		if air then
			pos = air
		else
			bones_mode = "drop"
		end
	end

	if bones_mode == "drop" then
		for _, list_name in ipairs(player_inventory_lists) do
			for i = 1, player_inv:get_size(list_name) do
				drop(pos, player_inv:get_stack(list_name, i))
			end
			player_inv:set_list(list_name, {})
		end
		drop(pos, ItemStack("bones:bones"))
		minetest.log("action", player_name .. " dies at " .. pos_string ..
			". Inventory dropped")
		if bones_position_message then
			minetest.chat_send_player(player_name, S("@1 died at @2, and dropped their inventory.", player_name, pos_string))
		end
		return
	end

	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	minetest.set_node(pos, {name = "bones:bones", param2 = param2})

	minetest.log("action", player_name .. " dies at " .. pos_string ..
		". Bones placed")
	if bones_position_message then
		minetest.chat_send_player(player_name, S("@1 died at @2, and bones were placed.", player_name, pos_string))
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	-- Calculate the actual inventory dimensions.
	-- i3 uses a 9-wide hotbar (main = 9*4 = 36), vanilla/legacy uses 8-wide (32).
	local main_size = player_inv:get_size("main")
	local craft_size = player_inv:get_size("craft")
	local cols = math.max(8, math.floor(main_size / 4))

	-- Reserve space for 3d_armor items, which are injected into bones via
	-- minetest.after(1) after this handler returns. Without reservation the
	-- bones chest can be completely full by then and all armor pieces scatter.
	local armor_reserve = 0
	if minetest.get_modpath("3d_armor") and
			(not armor or not armor.config or armor.config.drop ~= false) then
		armor_reserve = 6  -- head, torso, legs, feet, shield + gloves
	end

	inv:set_size("main", main_size + craft_size + armor_reserve)

	for _, list_name in ipairs(player_inventory_lists) do
		for i = 1, player_inv:get_size(list_name) do
			local stack = player_inv:get_stack(list_name, i)
			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else -- no space left
				drop(pos, stack)
			end
		end
		player_inv:set_list(list_name, {})
	end

	local armor_inv = minetest.get_inventory({type = "detached", name = player_name .. "_armor"})
	if armor_inv then
		for i = 1, armor_inv:get_size("armor") do
			local stack = armor_inv:get_stack("armor", i)
			if stack:get_count() > 0 then
				if inv:room_for_item("main", stack) then
					inv:add_item("main", stack)
				else
					drop(pos, stack)
				end
				armor_inv:set_stack("armor", i, ItemStack(""))
			end
		end
		if armor and armor.save_armor_inventory then
			armor:save_armor_inventory(player)
			armor:set_player_armor(player)
		end
	end

	meta:set_string("formspec", make_bones_formspec(cols))
	meta:set_string("owner", player_name)

	if share_bones_time ~= 0 then
		meta:set_string("infotext", S("@1's fresh bones", player_name))

		if share_bones_time_early == 0 or not minetest.is_protected(pos, player_name) then
			meta:set_int("time", 0)
		else
			meta:set_int("time", (share_bones_time - share_bones_time_early))
		end

		minetest.get_node_timer(pos):start(10)
	else
		meta:set_string("infotext", S("@1's bones", player_name))
	end
end)
