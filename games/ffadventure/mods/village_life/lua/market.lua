-- The village economy.
--
-- Three things move a price away from its base:
--
--   speciality  every village is good at one trade and short of another,
--               seeded from its id, so the iron village sells cheap steel and
--               dear bread and the next one over is the reverse
--   season      fresh food is cheap at harvest and dear in February; seed is
--               cheap in spring; wool and coal are dear in winter. Some goods
--               are simply not on sale out of season
--   demand      buying moves the price. It decays back towards base over a
--               few in-game days, so a village can be worked but not farmed
--
-- All three are multiplicative on the base price and clamped together, so no
-- combination can produce a free pickaxe or a 40-coin apple.

local util = village_life.util
local market = {}
village_life.market = market

local storage = minetest.get_mod_storage()

--------------------------------------------------------------------------------
-- Tag helpers
--------------------------------------------------------------------------------

local function has_tag(offer, tag)
	local tags = offer.tags
	if not tags or tags == "" then return false end
	return (" " .. tags .. " "):find(" " .. tag .. " ", 1, true) ~= nil
end
market.has_tag = has_tag

--------------------------------------------------------------------------------
-- Village character
--------------------------------------------------------------------------------

-- Broad trades a village can be known for. Deliberately the same vocabulary as
-- the goods tags, so no mapping table is needed.
local TRADES = {"metal", "wood", "stone", "food", "cloth", "glass", "grain", "dye"}

local character_cache = {}

-- A village's speciality and shortage, derived from its id. Nothing is stored:
-- the same village always has the same character, in this world and in a
-- rolled-back backup of it.
function market.character(village_id)
	if not village_id then return end
	local c = character_cache[village_id]
	if c then return c end

	local rng = util.rng("character", village_id)
	local a = rng:next(1, #TRADES)
	local b = rng:next(1, #TRADES - 1)
	if b >= a then b = b + 1 end          -- guarantee scarce ~= speciality

	c = {
		speciality = TRADES[a],
		scarce = TRADES[b],
		-- Overall cost of living: a prosperous village charges a little more
		-- for everything, a poor one less.
		wealth = util.rng_float(rng, 0.88, 1.14),
	}
	character_cache[village_id] = c
	return c
end

--------------------------------------------------------------------------------
-- Seasons
--------------------------------------------------------------------------------

function market.season()
	if minetest.global_exists("seasons") and seasons.get_season then
		local ok, name = pcall(seasons.get_season)
		if ok and name then return name end
	end
	return "summer"
end

-- {tag = multiplier} per season. A tag not listed is unaffected.
local SEASON_PRICE = {
	spring = {seed = 0.65, fresh = 1.25, berry = 1.3, grain = 1.3,
	          warm = 0.95, meat = 1.1, ice = 1.1},
	summer = {seed = 1.15, fresh = 0.8, berry = 0.85, grain = 1.05,
	          warm = 0.72, summer = 0.7, ice = 1.6},
	autumn = {seed = 1.1, fresh = 0.7, berry = 0.75, grain = 0.65,
	          warm = 1.1, autumn = 0.65, meat = 0.85, ice = 1.15},
	winter = {seed = 1.2, fresh = 1.65, berry = 1.8, grain = 1.25,
	          warm = 1.4, fuel = 1.45, meat = 1.2, ice = 0.55},
}

-- Goods that simply are not for sale in a given season. Salted meat keeps and
-- flour keeps; fresh berries and melons do not.
local SEASON_ABSENT = {
	winter = {"berry", "summer"},
	spring = {"autumn"},
}

function market.season_factor(offer)
	local season = market.season()

	local absent = SEASON_ABSENT[season]
	if absent then
		for _, tag in ipairs(absent) do
			if has_tag(offer, tag) then return 1, false end
		end
	end

	local table_ = SEASON_PRICE[season]
	if not table_ then return 1, true end

	-- Strongest applicable adjustment wins rather than compounding, so a
	-- "food fresh berry" entry is not priced three times over.
	local best = 1
	for tag, mult in pairs(table_) do
		if has_tag(offer, tag) and math.abs(mult - 1) > math.abs(best - 1) then
			best = mult
		end
	end
	return best, true
end

--------------------------------------------------------------------------------
-- Demand
--------------------------------------------------------------------------------

-- village_id -> {items = {[itemname] = units bought}, day = last decay day}
market.demand = {}

local DEMAND_PER_UNIT = 0.03   -- price rise per unit bought
local DEMAND_CAP      = 0.9    -- never more than +90%
local DECAY_PER_DAY   = 0.5    -- halve each in-game day

local function demand_table(village_id)
	local d = market.demand[village_id]
	if not d then
		d = {items = {}, day = minetest.get_day_count and minetest.get_day_count() or 0}
		market.demand[village_id] = d
	end
	return d
end

-- Decay lazily on read rather than on a timer: villages nobody is trading with
-- cost nothing, and the arithmetic is the same either way.
local function decayed(village_id)
	local d = demand_table(village_id)
	local today = minetest.get_day_count and minetest.get_day_count() or 0
	local elapsed = today - (d.day or today)
	if elapsed > 0 then
		local factor = DECAY_PER_DAY ^ elapsed
		for item, value in pairs(d.items) do
			local v = value * factor
			if v < 0.05 then
				d.items[item] = nil
			else
				d.items[item] = v
			end
		end
		d.day = today
	end
	return d
end

function market.demand_factor(village_id, offer)
	if not village_id then return 1 end
	local d = decayed(village_id)
	local value = d.items[offer.item] or 0
	return 1 + math.min(value * DEMAND_PER_UNIT, DEMAND_CAP)
end

function market.record_purchase(village_id, offer, units)
	if not village_id or not offer then return end
	local d = decayed(village_id)
	d.items[offer.item] = (d.items[offer.item] or 0) + (units or offer.count or 1)
	market.dirty = true
end

--------------------------------------------------------------------------------
-- The combined factors
--------------------------------------------------------------------------------

-- Returns multiplier, available.
function market.price_factor(village_id, offer)
	local season_mult, available = market.season_factor(offer)
	if not available then return 1, false end

	local mult = season_mult * market.demand_factor(village_id, offer)

	local c = market.character(village_id)
	if c then
		mult = mult * c.wealth
		if has_tag(offer, c.speciality) then mult = mult * 0.75 end
		if has_tag(offer, c.scarce) then mult = mult * 1.45 end
	end

	-- Clamp so no chain of modifiers produces a silly number.
	return math.max(0.45, math.min(mult, 2.6)), true
end

-- The climate a village sits in, read once off the map at its centre and cached.
-- What the ground round a village can actually grow bears on how much fresh
-- produce a shop keeps: an orchard's worth of apples in a bog is the thing that
-- reads as magical. heat/humidity are the same axes the biome grid uses.
local climate_cache = {}

function market.climate(village_id)
	if not village_id then return end
	local c = climate_cache[village_id]
	if c ~= nil then return c or nil end   -- false = looked up, nothing there

	local v = village_life.home.village(village_id)
	if not v or not v.vx then climate_cache[village_id] = false ; return end
	if not minetest.get_biome_data then climate_cache[village_id] = false ; return end

	local centre = {x = v.vx, y = v.vh or 0, z = v.vz}
	local data = minetest.get_biome_data(centre)
	if not data then return end            -- not loaded yet; try again later
	c = {heat = data.heat or 50, humidity = data.humidity or 50}
	climate_cache[village_id] = c
	return c
end

-- How well the ground here suits field and orchard crops. Temperate, middling
-- damp is best; the cold, the parched desert and the waterlogged swamp all thin
-- the shelf right down -- what fresh food there is has been carried in, so there
-- is little of it. 1 for anything that is not fresh produce, or when the climate
-- cannot be read.
function market.produce_climate_factor(village_id, offer)
	if not (has_tag(offer, "fresh") or has_tag(offer, "berry")
			or has_tag(offer, "grain")) then
		return 1
	end
	local cl = market.climate(village_id)
	if not cl then return 1 end

	local f = 1
	if cl.heat < 25 then f = f * 0.4          -- too cold to grow much
	elseif cl.heat > 80 then f = f * 0.55 end -- baked
	if cl.humidity > 72 then f = f * 0.5      -- bog: it rots on the branch
	elseif cl.humidity < 20 then f = f * 0.6 end
	return f
end

-- How deep the shelf is, on the same inputs.
function market.stock_factor(village_id, offer)
	local f = 1
	local c = market.character(village_id)
	if c then
		if has_tag(offer, c.speciality) then f = f * 1.6 end
		if has_tag(offer, c.scarce) then f = f * 0.55 end
	end
	local season = market.season()
	if season == "autumn" and (has_tag(offer, "fresh") or has_tag(offer, "grain")) then
		f = f * 1.5
	elseif season == "winter" and has_tag(offer, "fresh") then
		f = f * 0.5
	end
	-- The land itself: a swamp keeps few apples, however the village is otherwise.
	f = f * market.produce_climate_factor(village_id, offer)
	return f
end

-- A one-line description of what this village is like to trade in, shown in
-- the shop window. It is the only place the player is told any of this, so it
-- has to be readable rather than exact.
function market.blurb(village_id)
	local c = market.character(village_id)
	if not c then return "" end
	local season = market.season()
	return ("Known for %s, short of %s. (%s)"):format(c.speciality, c.scarce, season)
end

--------------------------------------------------------------------------------
-- Persistence
--------------------------------------------------------------------------------

-- Only demand is stored. Village character is derived from the id and stock is
-- derived from identity plus the day, so neither needs saving.
local function save()
	if not market.dirty then return end
	local out = {}
	for village_id, d in pairs(market.demand) do
		if next(d.items) then out[village_id] = d end
	end
	storage:set_string("demand", minetest.serialize(out))
	market.dirty = false
end

local function load()
	local raw = storage:get_string("demand")
	if raw == "" then return end
	local data = minetest.deserialize(raw)
	if type(data) == "table" then
		market.demand = data
		-- Tolerate tables written by an older version.
		for _, d in pairs(market.demand) do
			d.items = d.items or {}
		end
	end
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
