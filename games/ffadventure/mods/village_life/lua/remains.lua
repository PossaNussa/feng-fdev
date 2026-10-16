-- What a villager leaves behind.
--
-- Villagers died and nothing happened. `drops = {}` on the pigman trader, so no
-- items; the census put an identical person in the same bed four minutes later,
-- so no absence. Killing someone was a reputation transaction with no object in
-- the world attached to it.
--
-- Now they leave a body. It is a `bones:bones` node with their name on it and
-- the things they were carrying inside, and it belongs to nobody -- anybody may
-- open it, and anybody may dig it.
--
-- That last part is deliberate and load-bearing. Looting and digging a corpse
-- must never be a crime, because burying the dead means destroying that node.
-- crime.lua exempts it explicitly; nothing here raises a theft event; and if a
-- funeral system is ever built on top of this, it inherits a node it is allowed
-- to remove.
--
-- No edit to the `bones` mod is needed. Its placement logic is all inline in a
-- `register_on_dieplayer` handler and thoroughly player-coupled, but the *node*
-- is fine: `is_owner` (bones/init.lua:11) treats an empty owner string as
-- public, so every callback on it behaves correctly for a corpse that is
-- nobody's property.

local util = village_life.util
local home = village_life.home

local remains = {}
village_life.remains = remains

local BONES = "bones:bones"

--------------------------------------------------------------------------------
-- What they were carrying
--------------------------------------------------------------------------------

-- Villagers have no persistent inventory -- shop stock is regenerated from a
-- seed on demand and lives in the weak scratch table. So what a body holds is
-- built at the moment of death from what that person plausibly had on them:
-- their trade, their tools, the coins of a day's takings.
--
-- Deterministic per villager and per day, so reloading a mapblock cannot be
-- farmed for a second corpse's worth of loot.
local TOOLS_BY_TITLE = {
	smith = {"default:pick_steel", "default:hammer"},
	blacksmith = {"default:pick_steel"},
	goldsmith = {"default:gold_ingot"},
	coppersmith = {"default:copper_ingot"},
	tinsmith = {"default:tin_ingot"},
	miller = {"farming:flour"},
	baker = {"farming:bread"},
	priest = {"default:torch"},
	guard = {"default:sword_steel"},
	soldier = {"default:sword_steel"},
	lumberjack = {"default:axe_steel"},
	farmer = {"farming:hoe_steel"},
	carpenter = {"default:axe_steel"},
	stonemason = {"default:pick_steel"},
	fisher = {"default:stick"},
	innkeeper = {"vessels:drinking_glass"},
	barkeeper = {"vessels:drinking_glass"},
	shopkeeper = {"default:paper"},
	librarian = {"default:book"},
	schoolteacher = {"default:book"},
}

local COIN = "simplecoins:copper"

local function add(list, itemstring, count)
	if not itemstring then return end
	if not minetest.registered_items[itemstring] then return end
	list[#list + 1] = itemstring .. (count and (" " .. count) or "")
end

-- The contents of one villager's body.
function remains.belongings(self, r)
	local key = village_life.memory.key_of(self) or "unknown"
	local day = minetest.get_day_count and minetest.get_day_count() or 0
	local rng = util.rng("remains", key, day)

	local out = {}
	local title = r and r.title

	-- Their trade, if they had one.
	for _, item in ipairs(TOOLS_BY_TITLE[title] or {}) do
		if rng:next(1, 100) <= 55 then add(out, item) end
	end

	-- A day's takings. A shopkeeper carries more than a child.
	local purse = 0
	if title then purse = rng:next(1, 9) end
	if r and r.role == "child" then purse = 0 end
	if purse > 0 then add(out, COIN, purse) end

	-- The wares they were selling that day -- not one token item but a spread of
	-- what was on the shelf. A killed shopkeeper's body is their stall.
	if village_life.settings.economy then
		local stock = village_life.economy.stock(self)
		if stock and #stock > 0 then
			-- Shuffle the shelf and take a handful of distinct lines, a few of
			-- each. The bones inventory is 32 slots, so a whole day's stock fits.
			local idx = {}
			for i = 1, #stock do idx[i] = i end
			for i = #idx, 2, -1 do
				local j = rng:next(1, i)
				idx[i], idx[j] = idx[j], idx[i]
			end
			for i = 1, math.min(#idx, rng:next(3, 6)) do
				local offer = stock[idx[i]]
				if offer and offer.item then
					add(out, offer.item, math.min(offer.count or 1, rng:next(1, 4)))
				end
			end
		end
	end

	-- Whatever their hobby makes. The beekeeper dies with honey on them.
	local product = village_life.traits.product(self)
	if product and rng:next(1, 100) <= 60 then add(out, product) end

	-- Everybody has something in their pockets.
	if #out == 0 then
		add(out, "farming:bread")
		if #out == 0 then add(out, "default:stick") end
	end

	return out
end

--------------------------------------------------------------------------------
-- Placing the body
--------------------------------------------------------------------------------

-- Can a corpse go here? Same shape as the bones mod's own `may_replace`, minus
-- everything that needs a player object.
local function may_replace(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then return false end
	if node.name == "air" then return true end
	local def = minetest.registered_nodes[node.name]
	if not def then return false end
	if def.liquidtype and def.liquidtype ~= "none" then return true end
	return def.buildable_to == true
end

local function find_spot(pos)
	if may_replace(pos) then return pos end
	-- Straight down first: a body falls.
	for dy = 0, -2, -1 do
		local p = {x = pos.x, y = pos.y + dy, z = pos.z}
		if may_replace(p) then return p end
	end
	local air = minetest.find_node_near(pos, 2, {"air"})
	return air
end

-- Lay out `self`, dead at `pos`. Returns the node position, or nil if the body
-- could not be placed (in which case the belongings are dropped loose).
function remains.place(self, pos)
	if not village_life.settings.remains then return end
	if not minetest.registered_nodes[BONES] then return end

	pos = pos or (self.object and self.object:get_pos())
	if not pos then return end
	pos = vector.round(pos)

	local r = home.resolve(self)
	local name = self.game_name or (r and r.name) or "a villager"
	local title = r and r.title
	local items = remains.belongings(self, r)

	local spot = find_spot(pos)
	if not spot then
		for _, itemstring in ipairs(items) do
			minetest.add_item(pos, itemstring)
		end
		return
	end

	minetest.set_node(spot, {name = BONES, param2 = 0})

	local meta = minetest.get_meta(spot)
	local inv = meta:get_inventory()
	inv:set_size("main", 8 * 4)
	for _, itemstring in ipairs(items) do
		local stack = ItemStack(itemstring)
		if inv:room_for_item("main", stack) then
			inv:add_item("main", stack)
		else
			minetest.add_item(spot, stack)
		end
	end

	-- Owner deliberately blank. `is_owner` reads an empty string as public, so
	-- anybody may open it and anybody may dig it -- which is what a burial
	-- needs, and why crime.lua never counts this as theft.
	meta:set_string("owner", "")
	-- Individualise the reclaimed bones item: emptying this body yields
	-- "<name>'s Bones" rather than a generic one. (bones mod stamps it from here.)
	meta:set_string("bones:display", name)
	meta:set_string("infotext", title
			and ("Remains of %s the %s"):format(name, title)
			or ("Remains of %s"):format(name))

	-- The bones mod's own formspec is a local function, so this is the one
	-- thing that has to be restated rather than reused. Eight wide, to match
	-- the inventory size above.
	meta:set_string("formspec",
			"size[8,9]" ..
			"list[current_name;main;0,0.3;8,4;]" ..
			"list[current_player;main;0,4.85;8,1;]" ..
			"list[current_player;main;0,6.08;8,3;8]" ..
			"listring[current_name;main]" ..
			"listring[current_player;main]")

	village_life.log("info", ("%s left remains at %s"):format(
			name, minetest.pos_to_string(spot)))

	return spot
end
