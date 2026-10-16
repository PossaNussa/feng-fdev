-- A room for the night.
--
-- An inn already stands in the village, with beds a player can walk in and lie
-- down on for nothing. That is the shape of scenery, not of a business: the
-- innkeeper sold bed *furniture* off a shelf while the actual rooms behind them
-- were free.
--
-- This turns the rooms into the thing being sold. You ask the innkeeper for a
-- room, you pay, and the bed is yours for the night. Sleep in one you have not
-- paid for and it is the same rule as everything else in this village -- not
-- forbidden, but an offence if somebody sees you do it. An empty inn at night is
-- an opportunity; an inn with the keeper awake behind the counter is not.
--
-- Nothing here blocks a bed or edits the beds mod. It watches the same
-- on_rightclick the beds mod already registered, exactly as crime.lua watches
-- the take handler a container already had.

local util = village_life.util
local home = village_life.home

local lodging = {}
village_life.lodging = lodging

local storage = minetest.get_mod_storage()
local dirty = false

--------------------------------------------------------------------------------
-- Tuning
--------------------------------------------------------------------------------

-- Coins for a night, before standing is taken into account. A modest sum: this
-- is a bed, not a boon, and the point is the choice to pay it rather than the
-- dent it leaves.
local BASE_PRICE = 10

-- Nights the rental covers. "A room for the night" clears at the end of the
-- following day, so tonight's sleep is paid for and tomorrow you ask again.
local STAY_DAYS = 1

-- How far a keeper or a guest can be and still see whose head is on the pillow.
local SEE = 14

-- Which mg_villages building types are lodging you rent rather than homes you
-- trespass in. Kept narrow on purpose: a stranger's house is a different matter,
-- and not this module's.
local LODGING_TYPES = {
	inn = true, tavern = true, hotel = true, hostel = true, guesthouse = true,
}

--------------------------------------------------------------------------------
-- Storage
--------------------------------------------------------------------------------

-- pname -> { ["village_id/plot_nr"] = expiry_day }
lodging.rooms = {}

local function load()
	local raw = storage:get_string("lodging")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then lodging.rooms = data end
end

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end

-- Drop rentals that have run out, so the book does not grow for the life of the
-- world. Applied on save; a lapsed room simply reads as "not rented".
local function prune()
	local now = today()
	for pname, book in pairs(lodging.rooms) do
		for key, expiry in pairs(book) do
			if expiry < now then book[key] = nil end
		end
		if next(book) == nil then lodging.rooms[pname] = nil end
	end
end

local function save()
	if not dirty then return end
	prune()
	storage:set_string("lodging", minetest.serialize(lodging.rooms))
	dirty = false
end

load()

local save_timer = 0
minetest.register_globalstep(function(dtime)
	save_timer = save_timer + dtime
	if save_timer < 300 then return end
	save_timer = 0
	save()
end)

minetest.register_on_shutdown(save)
lodging.save = save

--------------------------------------------------------------------------------
-- Which plots are lodging
--------------------------------------------------------------------------------

function lodging.is_lodging(bpos)
	if not bpos or not bpos.btype then return false end
	local b = mg_villages.BUILDINGS and mg_villages.BUILDINGS[bpos.btype]
	return b ~= nil and LODGING_TYPES[b.typ] == true
end

-- The lodging plot a position sits inside, if any. Returns plot_nr, bpos. Walks
-- the village's own plot list, which is small; the same list home.lua binds
-- villagers to.
function lodging.plot_at(village_id, pos)
	local village = home.village(village_id)
	if not village or not village.to_add_data or not village.to_add_data.bpos then
		return
	end
	for nr, bpos in ipairs(village.to_add_data.bpos) do
		if lodging.is_lodging(bpos) and util.inside_plot(pos, bpos) then
			return nr, bpos
		end
	end
end

-- Does this villager keep an inn -- i.e. is their own plot lodging? Read off the
-- plot rather than the job title, so it is true of whoever actually stands
-- behind the counter whatever mg_villages happened to call them.
function lodging.is_keeper(self)
	if not (self and self.vl and self.vl.v and self.vl.p) then return false end
	return lodging.is_lodging(home.plot(self.vl.v, self.vl.p))
end

--------------------------------------------------------------------------------
-- Rentals
--------------------------------------------------------------------------------

local function room_key(village_id, plot_nr)
	return tostring(village_id) .. "/" .. tostring(plot_nr)
end

function lodging.has_room(pname, village_id, plot_nr)
	if not pname or not village_id or not plot_nr then return false end
	local book = lodging.rooms[pname]
	local expiry = book and book[room_key(village_id, plot_nr)]
	return expiry ~= nil and expiry >= today()
end

function lodging.grant(pname, village_id, plot_nr, days)
	if not pname or not village_id or not plot_nr then return end
	local book = lodging.rooms[pname]
	if not book then book = {} ; lodging.rooms[pname] = book end
	book[room_key(village_id, plot_nr)] = today() + (days or STAY_DAYS)
	dirty = true
end

--------------------------------------------------------------------------------
-- Paying
--------------------------------------------------------------------------------

function lodging.price(village_id, pname)
	local p = BASE_PRICE
	if village_life.settings.reputation and village_id and pname then
		-- A welcome face pays a little less, a barely-tolerated one a little
		-- more -- the same factor the shop counter charges by.
		p = math.floor(p * village_life.reputation.price_factor(village_id, pname)
				+ 0.5)
	end
	return math.max(3, p)
end

-- The coin the shops price in (trade_ui.lua), and the money bag that holds it.
-- A bag records its amount in item meta; the moneybag mod keeps that in step
-- with what the bag actually contains.
local COIN = "simplecoins:coins"
local BAG_FULL = "moneybag:bolsa_dinero_1"
local BAG_EMPTY = "moneybag:bolsa_dinero_2"

-- What a stack is worth in coin: a coin stack by its count, a full money bag by
-- the amount recorded in its meta, anything else nothing.
local function stack_coins(stack)
	local name = stack:get_name()
	if name == COIN then return stack:get_count() end
	if name == BAG_FULL then return stack:get_meta():get_int("coins") end
	return 0
end

-- Set a money bag to a coin total, emptying and renaming it at zero -- the same
-- shape the moneybag mod's own GUI writes, so a spent bag reads as empty there.
local function set_bag(stack, total)
	stack:set_name(total > 0 and BAG_FULL or BAG_EMPTY)
	local meta = stack:get_meta()
	meta:set_int("coins", total)
	meta:set_string("description",
			total > 0 and ("Money Bag (" .. total .. " coins)") or "Empty Money Bag")
	return stack
end

-- Every coin the player can reach: loose coins and money bags in their main
-- inventory. Paying with a wielded item was the old way and confused everyone --
-- you hold your coin, you do not brandish it.
local function purse(inv)
	local total = 0
	for i = 1, inv:get_size("main") do
		total = total + stack_coins(inv:get_stack("main", i))
	end
	return total
end

-- Every coin a named player can reach, loose and in money bags. Public so the
-- hiring flow can price an offer against what is actually in the purse rather
-- than only what is being held up. Same reckoning the room rental uses.
function lodging.purse(pname)
	local player = pname and minetest.get_player_by_name(pname)
	local inv = player and player:get_inventory()
	if not inv then return 0 end
	return purse(inv)
end

-- Take `price` coins from the player, loose coins first and then out of their
-- money bags. Returns true, or false with a reason. No change is made because
-- coins are the unit -- the exact price is removed and nothing is owed back.
function lodging.take_payment(pname, price)
	local player = minetest.get_player_by_name(pname)
	if not player then return false, "gone" end
	local inv = player:get_inventory()
	if not inv then return false, "gone" end

	if purse(inv) < price then return false, "short" end

	local owed = price
	local size = inv:get_size("main")

	-- Loose coins first.
	for i = 1, size do
		if owed <= 0 then break end
		local s = inv:get_stack("main", i)
		if s:get_name() == COIN then
			local take = math.min(owed, s:get_count())
			s:take_item(take)
			inv:set_stack("main", i, s)
			owed = owed - take
		end
	end

	-- Then draw the rest out of money bags.
	for i = 1, size do
		if owed <= 0 then break end
		local s = inv:get_stack("main", i)
		if s:get_name() == BAG_FULL then
			local have = s:get_meta():get_int("coins")
			local take = math.min(owed, have)
			set_bag(s, have - take)
			inv:set_stack("main", i, s)
			owed = owed - take
		end
	end

	return owed <= 0
end

-- What the keeper says when the coin does not add up. Kept here so the reasons
-- and their lines live together.
function lodging.cannot_pay_line(why)
	if why == "short" then
		return "That's more than you're carrying. Come back when you've the coin for it."
	end
	return "Let's leave it for now."
end

--------------------------------------------------------------------------------
-- Sleeping where you shouldn't
--------------------------------------------------------------------------------

-- Per-player-per-bed cooldown, so one long night is one offence and not one per
-- click. Mirrors crime.lua's `too_soon`.
local recent = {}
local REPORT_COOLDOWN = 8

local function too_soon(pname, pos)
	local key = pname .. "@" .. minetest.pos_to_string(pos)
	local now = util.now()
	local last = recent[key]
	if last and now - last < REPORT_COOLDOWN then return true end
	recent[key] = now
	return false
end

-- A player lay down on a bed. If it is an inn's bed and they have not paid for a
-- room, and somebody with line of sight is awake to see it, it is an offence --
-- witnessed, not forbidden. Anything else (their own bed, a bed in the wild, a
-- rented room) passes silently.
function lodging.on_sleep(pos, player)
	if not village_life.settings.lodging then return end
	if not player or not player.is_player or not player:is_player() then return end

	-- A click that stands them up again is not a fresh night's sleep.
	local pname = player:get_player_name()
	if beds and beds.player and beds.player[pname] then return end

	local village, village_id = home.village_at(pos, 8, 12)
	if not village_id then return end

	-- Your own town is your own: the founder of a player-settled town never
	-- trespasses in it -- every bed there is theirs to lie in.
	if village and village.is_player_town and village.founder == pname then return end

	local plot_nr = lodging.plot_at(village_id, pos)
	if not plot_nr then return end                 -- not an inn bed: sleep free
	if lodging.has_room(pname, village_id, plot_nr) then return end

	if not village_life.settings.crime then return end
	local witnesses = village_life.events.witnesses(village_id, pos, SEE)
	if #witnesses == 0 then return end             -- nobody awake to see it
	if too_soon(pname, pos) then return end

	local ev
	if village_life.settings.gossip then
		ev = village_life.events.raise({
			kind = "trespass",
			village_id = village_id,
			pos = pos,
			actor = pname,
			witnesses = witnesses,
		})
	end

	if village_life.settings.reputation then
		-- Milder than theft: a bed is not a chest. Capped at a handful of
		-- witnesses like every other public offence.
		village_life.reputation.adjust(village_id, pname,
				-2 * math.min(#witnesses, 3), "slept at the inn unpaid")
	end

	for _, key in ipairs(witnesses) do
		village_life.memory.remember_key(key, pname, "trespassed")
	end

	return ev
end

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

-- Wrap the on_rightclick every bed already carries, in the same late-override
-- style crime.lua uses for container take handlers. The beds mod's own handler
-- runs untouched; ours only watches. Nothing in the beds mod is edited.
minetest.register_on_mods_loaded(function()
	if not village_life.settings.lodging then return end

	local wrapped = 0
	for name, def in pairs(minetest.registered_nodes) do
		if def.on_rightclick and minetest.get_item_group(name, "bed") > 0 then
			local prev = def.on_rightclick
			def.on_rightclick =
					function(pos, node, clicker, itemstack, pointed_thing)
				pcall(lodging.on_sleep, pos, clicker)
				return prev(pos, node, clicker, itemstack, pointed_thing)
			end
			wrapped = wrapped + 1
		end
	end

	village_life.log("action", ("lodging watching %d bed type(s)"):format(wrapped))
end)

return lodging
