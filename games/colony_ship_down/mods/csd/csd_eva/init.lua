-- Spacesuits: four 3d_armor pieces. Wearing all four keeps you breathing in
-- vacuum. Suit lockers (EVA bay) hand out a fresh suit.

csd_eva = {}
local S = core.get_translator("csd_eva")

if not core.global_exists("armor") then
	core.log("warning", "[csd_eva] 3d_armor not loaded; spacesuits disabled")
	return
end

local PIECES = {
	{"helmet",     S("EVA Helmet"),   "armor_head"},
	{"chestplate", S("EVA Suit"),     "armor_torso"},
	{"leggings",   S("EVA Leggings"), "armor_legs"},
	{"boots",      S("EVA Boots"),    "armor_feet"},
}
csd_eva.pieces = {}

for _, p in ipairs(PIECES) do
	-- 3d_armor wants "<piece>_<material>"; textures follow the item name.
	local name = "csd_eva:" .. p[1] .. "_eva"
	csd_eva.pieces[#csd_eva.pieces + 1] = name
	armor:register_armor(name, {
		description = p[2] .. "\n" .. core.colorize("#9aa7c0", S("Wear all four pieces to breathe in vacuum.")),
		inventory_image = "csd_eva_inv_" .. p[1] .. ".png",
		groups = {[p[3]] = 1, armor_heal = 0, armor_use = 0, csd_spacesuit = 1},
		armor_groups = {fleshy = 3},
		damage_groups = {cracky = 3, snappy = 3, level = 1},
	})
end

function csd_eva.wearing_full_suit(player)
	local _, inv = armor:get_valid_player(player, "[csd_eva]")
	if not inv then return false end
	local have = {}
	for _, stack in ipairs(inv:get_list("armor") or {}) do
		have[stack:get_name()] = true
	end
	for _, name in ipairs(csd_eva.pieces) do
		if not have[name] then return false end
	end
	return true
end

-- Breathing: a full suit tops up your air while you're in vacuum.
local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 0.5 then return end
	timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		local in_vacuum = core.global_exists("csd_space") and csd_space.player_in_vacuum(player:get_player_name())
		if in_vacuum and csd_eva.wearing_full_suit(player) then
			player:set_breath(player:get_properties().breath_max)
		end
	end
end)

-- Suit locker -----------------------------------------------------------------

local COOLDOWN = 60
local last_taken = {}

local function has_suit(player)
	local inv = player:get_inventory()
	local _, worn = armor:get_valid_player(player, "[csd_eva]")
	for _, name in ipairs(csd_eva.pieces) do
		if not inv:contains_item("main", name) and not (worn and worn:contains_item("armor", name)) then
			return false
		end
	end
	return true
end

core.register_node("csd_eva:suit_locker", {
	description = S("Spacesuit Locker"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {{-0.45, -0.5, -0.1, 0.45, 1.45, 0.5}}},
	selection_box = {type = "fixed", fixed = {{-0.45, -0.5, -0.1, 0.45, 1.45, 0.5}}},
	collision_box = {type = "fixed", fixed = {{-0.45, -0.5, -0.1, 0.45, 1.45, 0.5}}},
	tiles = {"csd_eva_locker_top.png", "csd_eva_locker_top.png", "csd_eva_locker_side.png",
		"csd_eva_locker_side.png", "csd_eva_locker_side.png", "csd_eva_locker_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 3,
	groups = {cracky = 2, csd_ship = 1},
	is_ground_content = false,
	on_rightclick = function(pos, _, clicker)
		if not clicker or not clicker:is_player() then return end
		local name = clicker:get_player_name()
		local inv = clicker:get_inventory()
		if has_suit(clicker) then
			core.chat_send_player(name, S("You already have a spacesuit. Wear it from your inventory (armor)."))
			return
		end
		if last_taken[name] and os.time() - last_taken[name] < COOLDOWN then
			core.chat_send_player(name, S("The locker is restocking. Try again in a minute."))
			return
		end
		last_taken[name] = os.time()
		for _, item in ipairs(csd_eva.pieces) do
			local left = inv:add_item("main", item)
			if not left:is_empty() then core.add_item(clicker:get_pos(), left) end
		end
		core.sound_play("csd_tasks_click", {pos = pos, gain = 0.5}, true)
		core.chat_send_player(name, S("You took a spacesuit. Put all four pieces on (inventory, armor) before going outside."))
	end,
})
