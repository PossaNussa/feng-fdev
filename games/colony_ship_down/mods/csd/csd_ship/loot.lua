-- Cargo crates hold supplies. A crate fills itself the first time someone
-- opens it (with things that fit the room it's in), and restocks a while
-- after it's been emptied. Crates in a claimed room are the owner's.

local S = csd_ship.S
local RESTOCK = tonumber(core.settings:get("csd_crate_restock")) or 3600 * 2

-- Loot pools, filled in after all mods load from whatever items exist.
-- Each entry: {item, max_count, weight}
csd_ship.loot_pools = {food = {}, materials = {}, medical = {}, eva = {}, fun = {}, tools = {},
	essentials = {}, weapons = {}, weapons_rare = {}, weapons_epic = {}, ammo = {}}
local pools = csd_ship.loot_pools

local function add(pool, item, max, weight)
	if core.registered_items[item] then
		table.insert(pools[pool], {item, max or 1, weight or 1})
	end
end

core.register_on_mods_loaded(function()
	-- Food: anything edible from the galley mods.
	for name, def in pairs(core.registered_items) do
		local mod = name:match("^(.-):")
		if (mod == "farming" or mod == "x_farming" or mod == "pizza" or mod == "pie" or mod == "sandwiches" or mod == "waffles")
				and def.on_use and def.type == "craft" then
			table.insert(pools.food, {name, 4, 1})
		end
		-- seeds for the hydroponics beds (and anyone's own planters)
		if (mod == "farming" or mod == "x_farming") and name:find(":seed_") then
			table.insert(pools.essentials, {name, 5, 0.5})
			table.insert(pools.food, {name, 4, 0.3})
		end
	end
	for _, it in ipairs({"default:steel_ingot", "default:copper_ingot", "default:tin_ingot", "default:paper",
			"default:glass", "basic_materials:plastic_sheet", "basic_materials:steel_strip",
			"basic_materials:copper_wire", "basic_materials:steel_wire", "basic_materials:motor",
			"basic_materials:ic", "basic_materials:empty_spool", "basic_materials:energy_crystal_simple",
			"wool:white", "wool:blue", "wool:red", "dye:white", "dye:blue", "dye:red", "dye:yellow", "dye:green"}) do
		add("materials", it, 6)
	end
	for _, it in ipairs({"bandages:bandage_1", "bandages:bandage_2", "bandages:bandage_3"}) do
		add("medical", it, 3)
	end
	add("eva", "airtanks:breathing_tube", 1, 2)
	add("eva", "airtanks:steel_tank", 1, 3)
	add("eva", "airtanks:copper_tank", 1, 2)
	for name in pairs(core.registered_items) do
		if name:find("^goodtorch:") and core.registered_tools[name] then add("eva", name, 1, 2) end
		if name:find("^dice2:") then add("fun", name, 1) end
		if name:find("^cups:") then add("fun", name, 2) end
		if name:find("^instruments:") then add("fun", name, 1) end
		if name:find("^carpets:") then add("fun", name, 8) end
	end
	add("fun", "signs_lib:sign_wall_steel", 2)
	add("materials", "csd_tasks:scrap_metal", 5, 6)
	add("tools", "csd_tasks:scrap_metal", 4, 4)
	add("tools", "csd_tasks:hull_patch", 1, 1)
	add("food", "csd_tasks:ration", 2, 2)
	add("tools", "wateringcan:wateringcan_empty", 1, 1)
	add("tools", "csd_ship:bulb", 3, 4)
	add("tools", "csd_robots:repair_kit", 1, 1)
	add("essentials", "csd_ship:bulb", 2, 2)
	-- Crafting essentials: wood (no trees grow aboard), metals, basics
	for _, it in ipairs({"default:wood", "default:pine_wood", "default:acacia_wood", "default:aspen_wood", "default:junglewood"}) do
		add("essentials", it, 12, 3)
	end
	for _, it in ipairs({"default:tree", "default:pine_tree"}) do add("essentials", it, 4, 2) end
	add("essentials", "default:stick", 12, 3)
	add("essentials", "default:coal_lump", 8, 3)
	add("essentials", "default:steel_ingot", 6, 3)
	add("essentials", "default:copper_ingot", 6, 2)
	add("essentials", "default:tin_ingot", 4, 2)
	add("essentials", "default:bronze_ingot", 3, 1)
	add("essentials", "default:gold_ingot", 2, 0.5)
	add("essentials", "default:mese_crystal_fragment", 3, 0.5)
	add("essentials", "default:diamond", 1, 0.15)
	add("essentials", "default:obsidian_shard", 2, 0.5)
	add("essentials", "default:flint", 3, 1)
	add("essentials", "default:glass", 8, 2)
	add("essentials", "default:paper", 6, 1)
	add("essentials", "default:clay_lump", 6, 1)
	add("essentials", "farming:seed_wheat", 6, 1)
	add("essentials", "farming:seed_cotton", 6, 1)
	add("essentials", "farming:cotton", 6, 1)
	add("essentials", "farming:string", 4, 1)
	add("essentials", "default:torch", 6, 1)
	add("essentials", "default:chest", 1, 0.6)

	-- Weapons (rangedweapons). Lasers suit the ship, so they're less rare.
	for _, it in ipairs({"glock17", "beretta", "makarov", "m1991", "luger", "uzi", "mp5", "tec9", "tmp"}) do
		add("weapons", "rangedweapons:" .. it, 1, 2)
	end
	add("weapons", "rangedweapons:laser_blaster", 1, 2)
	add("weapons", "rangedweapons:hand_grenade", 2, 1)
	for _, it in ipairs({"ak47", "m16", "scar", "g36", "spas12", "remington", "benelli", "thompson", "mp40",
			"ump", "kriss_sv", "deagle", "python", "taurus"}) do
		add("weapons_rare", "rangedweapons:" .. it, 1, 1)
	end
	add("weapons_rare", "rangedweapons:laser_rifle", 1, 2)
	add("weapons_rare", "rangedweapons:laser_shotgun", 1, 1.5)
	for _, it in ipairs({"awp", "svd", "m200", "rpg", "m79", "minigun", "forcegun", "golden_deagle", "jackhammer", "aa12", "rpk", "m60", "milkor"}) do
		add("weapons_epic", "rangedweapons:" .. it, 1, 1)
	end
	for _, it in ipairs({"9mm", "45acp", "10mm", "357", "44", "50ae", "556mm", "762mm", "308winchester", "shell"}) do
		add("ammo", "rangedweapons:" .. it, 40, 3)
	end
	for _, it in ipairs({"handgun_mag_black", "machinepistol_mag", "rifle_mag", "assaultrifle_mag"}) do
		add("ammo", "rangedweapons:" .. it, 2, 1.5)
	end
	add("ammo", "rangedweapons:power_particle", 30, 3)  -- laser weapons
	add("ammo", "rangedweapons:40mm", 4, 0.6)
	add("ammo", "rangedweapons:rocket", 2, 0.4)
	add("ammo", "rangedweapons:gun_power_core", 1, 0.5)

	add("tools", "csd_ship:door", 1, 2)
	add("tools", "screwdriver:screwdriver", 1)
	add("tools", "wrench:wrench", 1)
	add("tools", "default:sign_wall_steel", 2)
	add("tools", "csd_create:hand_crank", 1)
	add("tools", "csd_create:depot", 2)
	add("tools", "steamified:axle", 4)
end)

-- What a crate in each kind of room holds: {pool = weight}
csd_ship.loot_by_room = {
	galley = {food = 6, materials = 1, essentials = 1},
	storage = {food = 3, materials = 3, fun = 2, medical = 1, essentials = 3, ammo = 0.5},
	cargo = {materials = 4, food = 2, tools = 1, fun = 1, eva = 1, essentials = 4, weapons = 0.6, ammo = 1},
	fuel = {materials = 3, eva = 1, essentials = 1},
	workshop = {materials = 4, tools = 3, essentials = 3},
	maintenance = {materials = 3, tools = 2, eva = 1, essentials = 2, ammo = 0.3},
	medbay = {medical = 6},
	weapons = {weapons = 3, weapons_rare = 1.5, weapons_epic = 0.3, ammo = 4, materials = 1},
	security = {weapons = 3, weapons_rare = 1, weapons_epic = 0.15, ammo = 3, medical = 1},
	shuttle = {eva = 3, materials = 1, essentials = 1, ammo = 1},
}
local DEFAULT_LOOT = {materials = 2, food = 2, fun = 1, essentials = 2}
-- Any crate, anywhere, has a small chance of a gun with ammo.
local SURPRISE_WEAPON = 0.05

local function weighted(t)
	local total = 0
	for _, w in pairs(t) do total = total + w end
	local r = math.random() * total
	local keys = {}
	for k in pairs(t) do keys[#keys + 1] = k end
	table.sort(keys)
	for _, k in ipairs(keys) do
		r = r - t[k]
		if r <= 0 then return k end
	end
	return keys[1]
end

local function pick_from(pool)
	local list = pools[pool]
	if not list or #list == 0 then return nil end
	local total = 0
	for _, e in ipairs(list) do total = total + e[3] end
	local r = math.random() * total
	for _, e in ipairs(list) do
		r = r - e[3]
		if r <= 0 then return ItemStack(e[1] .. " " .. math.random(1, e[2])) end
	end
end

local function fill(pos)
	local meta = core.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("main", 16)
	local r = csd_ship.room_at(pos)
	local table_ = csd_ship.loot_by_room[r and r.kind or ""] or DEFAULT_LOOT
	for _ = 1, math.random(3, 6) do
		local stack = pick_from(weighted(table_))
		if stack then inv:add_item("main", stack) end
	end
	if math.random() < SURPRISE_WEAPON then
		local gun = pick_from(math.random() < 0.2 and "weapons_rare" or "weapons")
		local ammo = pick_from("ammo")
		if gun then inv:add_item("main", gun) end
		if ammo then inv:add_item("main", ammo) end
	end
	meta:set_int("filled_at", os.time())
end

local function may_use(pos, player)
	local owner = csd_ship.claim_owner_at(pos)
	local name = player:get_player_name()
	return not owner or owner == name or csd_core.is_builder(name)
end

local function crate_formspec(pos)
	local spos = ("%d,%d,%d"):format(pos.x, pos.y, pos.z)
	return table.concat({
		"formspec_version[6]size[10.5,10]",
		"label[0.4,0.5;", core.formspec_escape(S("Cargo Crate")), "]",
		"list[nodemeta:", spos, ";main;0.4,1;8,2;]",
		"list[current_player;main;0.4,4.6;8,4;]",
		"listring[nodemeta:", spos, ";main]listring[current_player;main]",
	})
end

core.override_item("csd_ship:crate", {
	description = S("Cargo Crate"),
	on_rightclick = function(pos, _, clicker)
		if not clicker or not clicker:is_player() then return end
		if not may_use(pos, clicker) then
			core.chat_send_player(clicker:get_player_name(), S("This crate is in someone else's room."))
			return
		end
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:get_size("main") == 0 then
			fill(pos)
		elseif inv:is_empty("main") and os.time() - meta:get_int("filled_at") > RESTOCK then
			fill(pos)
		end
		core.show_formspec(clicker:get_player_name(), "csd_ship:crate", crate_formspec(pos))
	end,
	allow_metadata_inventory_put = function(pos, _, _, stack, player)
		return may_use(pos, player) and stack:get_count() or 0
	end,
	allow_metadata_inventory_take = function(pos, _, _, stack, player)
		return may_use(pos, player) and stack:get_count() or 0
	end,
	allow_metadata_inventory_move = function(pos, _, _, _, _, count, player)
		return may_use(pos, player) and count or 0
	end,
	can_dig = function(pos)
		return core.get_meta(pos):get_inventory():is_empty("main")
	end,
})
