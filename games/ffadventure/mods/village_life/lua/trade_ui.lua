-- The shop window.
--
-- Structurally the same detached-inventory trade as lottmobs' -- goods on the
-- left, pick one into the selection slot, pay, take -- because that is what
-- players of this game already know how to use. What changes is where the
-- prices come from.
--
-- lottmobs matched the selected stack against `race.items` by building the
-- string "itemname count" and comparing it to the table entry, which meant the
-- price was a property of the profession, identical everywhere. Here the
-- selection is matched against *this villager's* stock table, so the price is a
-- property of the shop: it moves with the village's speciality, the season and
-- how much the player has already bought.

local util    = village_life.util
local economy = village_life.economy
local market  = village_life.market

local trade = {}
village_life.trade = trade

local COIN = "simplecoins:coins"

-- inv_name -> live session. Rebuilt every time a player opens a shop, so a
-- villager that unloaded and came back does not hand out yesterday's prices.
trade.sessions = {}

-- player name -> inv_name, so the formspec callbacks know whose shop this is.
trade.viewing = {}

--------------------------------------------------------------------------------
-- What a villager will pay for your things
--------------------------------------------------------------------------------

-- Cheapest per-unit base price for an item anywhere in the goods pools. Built
-- once, after pools are pruned, so selling is possible for anything any
-- profession sells rather than only what this particular shop stocks.
local buy_index = {}

local function build_buy_index()
	for _, pool in pairs(economy.pools) do
		for _, e in ipairs(pool) do
			local item, count, price = e[1], e[2], e[3]
			local per_unit = price / math.max(1, count)
			if not buy_index[item] or per_unit < buy_index[item].per_unit then
				buy_index[item] = {per_unit = per_unit, tags = e[5] or ""}
			end
		end
	end
end

minetest.register_on_mods_loaded(function()
	-- After economy.lua's own on_mods_loaded prune, which was registered
	-- first and therefore runs first.
	build_buy_index()
end)

-- Villagers pay half, and a little more for whatever their village is short
-- of -- which is the one place the player gets to profit from the speciality
-- system rather than pay for it.
--
-- `profession` biases it further: a smith pays properly for metal and hides,
-- and offers scrap for a sack of wheat.
function trade.sell_price(village_id, item_name, count, profession)
	local per_unit, tags

	-- A price somebody in the game actually charges is the best evidence of
	-- what a thing is worth; fall back to the valuation table for everything
	-- nobody happens to stock -- leather, hides, raw meat, ore.
	local listed = buy_index[item_name]
	if listed then
		per_unit, tags = listed.per_unit, listed.tags
	else
		per_unit, tags = economy.value_of(item_name)
	end

	if not per_unit or per_unit <= 0 then return 0 end

	local mult = 0.5
	local c = market.character(village_id)
	if c and market.has_tag({tags = tags}, c.scarce) then
		mult = 0.72
	elseif c and market.has_tag({tags = tags}, c.speciality) then
		mult = 0.35  -- they have plenty already
	end

	mult = mult * economy.interest(profession, tags)

	return math.max(1, math.floor(per_unit * count * mult))
end

--------------------------------------------------------------------------------
-- Session
--------------------------------------------------------------------------------

local function fill_goods(inv, session)
	for i = 1, 15 do
		local offer = session.stock[i]
		if offer and offer.stock > 0 then
			inv:set_stack("goods", i, offer.item .. " " .. offer.count)
		else
			inv:set_stack("goods", i, nil)
		end
	end
end

local function session_for(inv_name)
	return trade.sessions[inv_name]
end

-- Find the offer a selected stack refers to. Matching on name and bundle size
-- together is what lets a baker stock both "5 bread" and "20 bread" at
-- different unit prices.
local function offer_for(session, stack)
	if not session or stack:is_empty() then return end
	return economy.find_offer(session.stock, stack:get_name(), stack:get_count())
end

-- What this customer pays. The offer's own price is the village's asking
-- price; standing is applied per customer on top, which is why it lives here
-- and not in the stock table.
function trade.price_for(session, offer)
	if not offer then return end
	local mult = 1
	if village_life.settings.reputation then
		mult = village_life.reputation.price_factor(session.village_id,
				session.viewer)
	end
	return math.max(1, math.floor(offer.price * mult + 0.5))
end

local function set_price(inv, session)
	local selection = inv:get_stack("selection", 1)
	local offer = offer_for(session, selection)
	if offer then
		session.selected = offer
		inv:set_stack("price", 1, COIN .. " " .. trade.price_for(session, offer))
	else
		session.selected = nil
		inv:set_stack("price", 1, nil)
	end
	lottmobs.update_takeaway(inv)
end

--------------------------------------------------------------------------------
-- Returning the customer's own property
--------------------------------------------------------------------------------

-- The `payment` and `selling` slots hold items the *player* owns. Everything
-- else in the window belongs to the shop: `goods` and `selection` are stock,
-- and `price`, `takeaway` and `sellprice` are previews of a trade that has not
-- been completed -- handing those over would be handing out free goods.
local PLAYER_OWNED = {"payment", "selling"}

local function give_back(stack, player, fallback_pos)
	if stack:is_empty() then return end
	if player then
		local leftover = player:get_inventory():add_item("main", stack)
		if leftover:is_empty() then return end
		minetest.add_item(player:get_pos(), leftover)
		return
	end
	-- Nobody to hand it to (the owner logged out, or the trader died while
	-- the window was open). Drop it where the shop was rather than deleting
	-- it: the player can come back for it.
	if fallback_pos then minetest.add_item(fallback_pos, stack) end
end

-- Empty the working slots. Called on Clear, on closing the window, on
-- disconnect, when another customer opens the same shop, and when the trader
-- dies -- anything left behind used to sit in the detached inventory until the
-- trader died, and was then destroyed with it.
function trade.return_belongings(inv_name, pname, fallback_pos)
	local inv = minetest.get_inventory({type = "detached", name = inv_name})
	if not inv then return end
	local session = trade.sessions[inv_name]

	-- The selection is shop stock and goes back on the shelf, not to the
	-- player. Clearing the slot is enough: fill_goods below rebuilds the shelf
	-- from the stock table, whose count is only spent on a completed sale.
	inv:set_stack("selection", 1, nil)
	inv:set_stack("price", 1, nil)
	inv:set_stack("takeaway", 1, nil)
	inv:set_stack("sellprice", 1, nil)

	local player = pname and minetest.get_player_by_name(pname)
	fallback_pos = fallback_pos or (session and session.pos)

	for _, list in ipairs(PLAYER_OWNED) do
		local stack = inv:get_stack(list, 1)
		if not stack:is_empty() then
			inv:set_stack(list, 1, nil)
			give_back(stack, player, fallback_pos)
		end
	end

	if session then
		session.selected = nil
		if session.stock then fill_goods(inv, session) end
	end
end

--------------------------------------------------------------------------------
-- Inventory callbacks
--------------------------------------------------------------------------------

-- Lists a customer may take out of. `selling` is on this list and was not
-- before, which is why shift-clicking (and dragging) an item back out of the
-- sell slot silently did nothing: a move between two different inventories is
-- gated by allow_take on the source, not by allow_move.
local CAN_TAKE = {
	payment = true, selling = true, takeaway = true, sellprice = true,
}

-- ...and lists a customer may put into.
local CAN_PUT = {payment = true, selling = true}

-- Exported so the offline harness can exercise the permission rules without
-- standing up a whole detached inventory.
function trade.callbacks(inv_name)
	return {
		-- Same-inventory moves only: shelf to selection and back again.
		allow_move = function(inv, from_list, from_index, to_list, to_index, count)
			local stack = inv:get_stack(from_list, from_index)
			-- Part-stacks would desync the offer lookup, which matches on
			-- name *and* bundle size.
			if count ~= stack:get_count() then return 0 end
			if from_list == "goods" and to_list == "selection" then return count end
			if from_list == "selection" and to_list == "goods" then return count end
			return 0
		end,

		allow_put = function(inv, listname, index, stack)
			return CAN_PUT[listname] and stack:get_count() or 0
		end,

		allow_take = function(inv, listname, index, stack)
			return CAN_TAKE[listname] and stack:get_count() or 0
		end,

		on_move = function(inv, from_list, from_index, to_list)
			if from_list == "goods" and to_list == "selection" then
				set_price(inv, session_for(inv_name))
			elseif from_list == "selection" and to_list == "goods" then
				local session = session_for(inv_name)
				if session then session.selected = nil end
				inv:set_stack("price", 1, nil)
				inv:set_stack("takeaway", 1, nil)
			end
		end,

		on_put = function(inv, listname)
			if listname == "payment" then
				lottmobs.update_takeaway(inv)
			elseif listname == "selling" then
				trade.update_sellprice(inv, session_for(inv_name))
			end
		end,

		on_take = function(inv, listname, index, stack, player)
			local session = session_for(inv_name)

			if listname == "takeaway" then
				-- The goods have already left the inventory; charge for them
				-- and consume a unit of shelf stock.
				if lottmobs.check_pay(inv, true) then
					local offer = session and session.selected
					if offer then
						offer.stock = math.max(0, offer.stock - 1)
						-- Persist the depletion on the shop's bed row so it
						-- outlives this session -- a shelf sold down stays down,
						-- and refills only slowly (economy.stock).
						economy.record_sale(session.memory_key, offer)
						market.record_purchase(session.village_id, offer, offer.count)
						if village_life.settings.reputation then
							village_life.reputation.on_trade(session.village_id,
									session.viewer, "trade")
							-- Repaint the shop next step so the standing readout
							-- shows the gain. Deferred out of the take callback.
							minetest.after(0, trade.refresh, session.viewer)
						end
						-- The village notes a customer; the shopkeeper notes
						-- a customer of theirs.
						village_life.memory.remember_key(session.memory_key,
								session.viewer, "traded")
						fill_goods(inv, session)
					end
				end
				inv:set_stack("selection", 1, nil)
				inv:set_stack("price", 1, nil)
				inv:set_stack("takeaway", 1, nil)
				if session then session.selected = nil end

			elseif listname == "payment" then
				lottmobs.update_takeaway(inv)

			elseif listname == "sellprice" then
				-- Taking the coins completes the sale: the item is gone.
				local sold = inv:get_stack("selling", 1)
				if village_life.settings.reputation and session
						and not sold:is_empty() then
					-- Bringing a village what it is short of is worth more
					-- goodwill than buying from it.
					local c = market.character(session.village_id)
					local entry = buy_index[sold:get_name()]
					local needed = c and entry
							and market.has_tag({tags = entry.tags}, c.scarce)
					village_life.reputation.on_trade(session.village_id,
							session.viewer, needed and "sell_needed" or "trade")
					minetest.after(0, trade.refresh, session.viewer)
					village_life.memory.remember_key(session.memory_key,
							session.viewer, "traded", needed and 2 or 1)
				end
				inv:set_stack("selling", 1, nil)
				inv:set_stack("sellprice", 1, nil)

			elseif listname == "selling" then
				inv:set_stack("sellprice", 1, nil)
			end
		end,
	}
end

function trade.update_sellprice(inv, session)
	local selling = inv:get_stack("selling", 1)
	if selling:is_empty() then
		inv:set_stack("sellprice", 1, nil)
		return
	end
	local price = trade.sell_price(session and session.village_id,
			selling:get_name(), selling:get_count(), session and session.title)

	-- A village pays its friends better and its enemies worse.
	if price > 0 and village_life.settings.reputation and session then
		price = math.max(1, math.floor(price * village_life.reputation.sell_factor(
				session.village_id, session.viewer) + 0.5))
	end

	if price > 0 then
		inv:set_stack("sellprice", 1, COIN .. " " .. price)
	else
		inv:set_stack("sellprice", 1, nil)
	end
end

--------------------------------------------------------------------------------
-- Formspec
--------------------------------------------------------------------------------

local esc = minetest.formspec_escape

local function build_formspec(inv_name, session)
	local list = "detached:" .. inv_name
	local header = ("%s the %s"):format(session.trader_name,
			session.title or "trader")

	-- formspec_escape wraps colorize, never the other way round: the escape
	-- has to be the outermost call or the colour code's own characters get
	-- mangled and the label renders blank.
	local blurb = esc(minetest.colorize("#b0c4a0",
			market.blurb(session.village_id)))

	-- Standing, in words and in figures, so a trader can watch it climb rather
	-- than trading for days and never seeing the needle move. Shown here because
	-- this is where the player is looking while they deal.
	local standing = ""
	if village_life.settings.reputation and session.village_id and session.viewer then
		local rep = village_life.reputation
		local score = rep.get(session.village_id, session.viewer)
		local t = rep.tier(score)
		standing = "label[6.4,-0.1;" .. esc(minetest.colorize(t.colour,
				("Standing: %s (%+d)"):format(t.name, math.floor(score + 0.5)))) .. "]"
	end

	return table.concat({
		"size[10,10.5]",
		"label[0,-0.1;", esc(header), "]",
		standing,
		"label[0,0.25;", blurb, "]",
		"list[", list, ";goods;0.25,0.9;3,5;]",

		"label[4,0.4;== BUY ==]",
		"label[4,0.9;Selection]",
		"list[", list, ";selection;4,1.4;1,1;]",
		"button[5.1,1.4;1.5,0.8;clear;Clear]",
		"label[6.7,0.9;Price]",
		"list[", list, ";price;6.7,1.4;1,1;]",
		"label[4,2.5;Payment]",
		"list[", list, ";payment;4,3.0;1,1;]",
		"label[5.5,2.5;You receive]",
		"list[", list, ";takeaway;5.5,3.0;1,1;]",

		"label[4,4.2;== SELL ==]",
		"label[4,4.7;Your item]",
		"list[", list, ";selling;4,5.2;1,1;]",
		"label[5.5,4.7;You get]",
		"list[", list, ";sellprice;5.5,5.2;1,1;]",

		"list[current_player;main;0,6.4;8,4;]",

		-- Shift-click routing.
		--
		-- The client sends a quick-move to whatever list follows the clicked
		-- one in this ring, and it locates the clicked list by its *first*
		-- occurrence (guiFormSpecMenu::getNextInventoryRing). So repeating
		-- current_player;main gives every shop slot the player's inventory as
		-- its destination without changing where the player's own inventory
		-- sends things.
		--
		--   goods     -> selection    pick something to buy
		--   selection -> goods        put it back on the shelf
		--   main      -> selling      offer something for sale
		--   selling, payment, takeaway, sellprice -> main
		--
		-- A list that appears in no ring at all cannot be shift-clicked, which
		-- is why the sell and payment slots were a one-way trip before.
		"listring[", list, ";goods]",
		"listring[", list, ";selection]",
		"listring[", list, ";goods]",
		"listring[current_player;main]",
		"listring[", list, ";selling]",
		"listring[current_player;main]",
		"listring[", list, ";payment]",
		"listring[current_player;main]",
		"listring[", list, ";takeaway]",
		"listring[current_player;main]",
		"listring[", list, ";sellprice]",
		"listring[current_player;main]",
	})
end

--------------------------------------------------------------------------------
-- Opening the shop
--------------------------------------------------------------------------------

local CLOSED_LINES = {
	sleep = "Come back in the morning, %s.",
	flee  = "Not now! Get inside!",
}

-- Why this villager will not open their shop to this player right now, as the
-- line they would say, or nil if they will.
--
-- One predicate, because the conversation offers "Show me your wares" and has
-- to know whether that button would do anything. It used to decide for itself
-- on the standing band alone, and so offered a shop that was asleep, or that
-- would refuse on a threshold the conversation did not check -- the player
-- lost the conversation and got a one-line brush-off in chat instead.
function trade.refusal(self, pname)
	if village_life.settings.shop_hours then
		local goal = util.scratch(self).goal
		local line = goal and CLOSED_LINES[goal.kind]
		if line then return line:format(pname) end
	end

	local village_id = self.vl and self.vl.v
	if village_life.settings.reputation and village_id
			and not village_life.reputation.will_trade(village_id, pname) then
		return village_life.reputation.is_enemy(village_id, pname)
				and "Get away from me."
				or "I'll not deal with you. Not after what you've done."
	end
end

function trade.open(self, clicker)
	local pname = clicker:get_player_name()
	local r = village_life.home.resolve(self)
	-- Which village this trader belongs to. Without this the session carried a
	-- nil village_id, so on_trade, note_visit and the favoured-reserve check all
	-- silently no-opped -- which is why trading never moved standing.
	local village_id = self.vl and self.vl.v

	-- Shop hours and standing. A villager who has run indoors from a zombie is
	-- not going to sell you a hoe, one asleep in bed is asleep, and a village
	-- that wants nothing to do with you does not open its shops.
	local refusal = trade.refusal(self, pname)
	if refusal then
		minetest.chat_send_player(pname, "[NPC] <" ..
				(self.game_name or "Villager") .. "> " .. refusal)
		return
	end

	lottmobs.face_pos(self, clicker:get_pos())

	if not self.id or self.id == 0 then
		self.id = "vl_loose_" .. tostring(math.random(1, 1e9))
	end
	local inv_name = tostring(self.id)

	-- A detached inventory is global, so two customers at the same trader
	-- share these slots. Hand the previous one their coins back before the new
	-- one can see -- or pocket -- them.
	local previous = trade.sessions[inv_name]
	if previous and previous.viewer and previous.viewer ~= pname then
		trade.return_belongings(inv_name, previous.viewer, previous.pos)
	end

	-- The shelf this customer sees. A fresh array each time, but holding the
	-- *same* offer tables, so stock spent by one customer is spent for all --
	-- while letting a favoured customer see the reserve appended to the end.
	local shelf = {}
	for _, offer in ipairs(economy.stock(self)) do shelf[#shelf + 1] = offer end

	local favoured = village_life.settings.reputation and village_id
			and village_life.reputation.is_favoured(village_id, pname)
	if favoured then
		for _, offer in ipairs(economy.reserve(self)) do
			if #shelf >= 15 then break end
			shelf[#shelf + 1] = offer
		end
	end

	local session = {
		inv_name = inv_name,
		stock = shelf,
		village_id = village_id,
		-- The shopkeeper's memory key rather than the shopkeeper: a session
		-- outlives a mapblock unload, and holding the luaentity would keep a
		-- dead mob's table alive with it.
		memory_key = village_life.memory.key_of(self),
		trader_name = self.game_name or (r and r.name) or "Trader",
		title = self.profession or (r and r.title),
		viewer = pname,
		-- Where to drop anything we cannot hand back because the owner has
		-- gone offline.
		pos = self.object:get_pos(),
	}
	trade.sessions[inv_name] = session
	trade.viewing[pname] = inv_name

	-- lottmobs' own trader code keys its formspec callbacks off this table,
	-- so keep it in step: a player may have both kinds of trader open over a
	-- session and the Clear button is shared.
	lottmobs.trader_context[pname] = {
		inv_name = inv_name,
		trader_name = session.trader_name,
	}

	local inv = minetest.get_inventory({type = "detached", name = inv_name})
	if not inv then
		inv = minetest.create_detached_inventory(inv_name, trade.callbacks(inv_name))
		inv:set_size("goods", 15)
		inv:set_size("selection", 1)
		inv:set_size("price", 1)
		inv:set_size("payment", 1)
		inv:set_size("takeaway", 1)
		inv:set_size("selling", 1)
		inv:set_size("sellprice", 1)
	end

	-- Start clean. Anything still in the working slots is this customer's own
	-- abandoned trade, so it comes straight back to them.
	trade.return_belongings(inv_name, pname, session.pos)
	fill_goods(inv, session)

	if village_life.settings.reputation and village_id then
		village_life.reputation.note_visit(village_id, pname)
	end

	local greeting = trade.greeting(self, session, pname)
	if greeting then
		minetest.chat_send_player(pname, "[NPC] <" .. session.trader_name ..
				"> " .. greeting)
	end
	if favoured then
		minetest.chat_send_player(pname, minetest.colorize("#ffd970",
				"[NPC] <" .. session.trader_name ..
				"> For you, I've kept a few things back."))
	end

	minetest.show_formspec(pname, "village_life:trade",
			build_formspec(inv_name, session))
end

-- Repaint an open shop, so the standing readout ticks over the instant a trade
-- moves it instead of the player having to close and reopen to see it.
function trade.refresh(pname)
	local inv_name = trade.viewing[pname]
	if not inv_name then return end
	local session = session_for(inv_name)
	if session then
		minetest.show_formspec(pname, "village_life:trade",
				build_formspec(inv_name, session))
	end
end

-- Tear down a dead trader's shop. Detached inventories are global and live
-- forever otherwise, and a village that has been raided a few times would
-- accumulate one per corpse.
function trade.close(self)
	local inv_name = self.id and tostring(self.id)
	if not inv_name then return end

	local session = trade.sessions[inv_name]
	local corpse = (self.object and self.object:get_pos())
			or (session and session.pos)

	-- Give the customer their coins back *before* the inventory goes away with
	-- them in it. A trader dying mid-trade used to destroy whatever the player
	-- had put in the payment and sell slots.
	for pname, viewing in pairs(trade.viewing) do
		if viewing == inv_name then
			trade.return_belongings(inv_name, pname, corpse)
			trade.viewing[pname] = nil
			minetest.close_formspec(pname, "village_life:trade")
		end
	end
	trade.return_belongings(inv_name, session and session.viewer, corpse)

	trade.sessions[inv_name] = nil
	if minetest.remove_detached_inventory then
		minetest.remove_detached_inventory(inv_name)
	end
end

--------------------------------------------------------------------------------
-- Greetings
--------------------------------------------------------------------------------

-- Reuse lottmobs' per-profession lines where they exist, and add one about
-- what the village is short of so the economy is discoverable in play rather
-- than only in the shop header.
function trade.greeting(self, session, pname)
	local lines = {}

	-- Being recognised is most of the point of a reputation, so standing and
	-- familiarity get first refusal on the greeting.
	if village_life.settings.reputation and session.village_id then
		local score = village_life.reputation.get(session.village_id, pname)
		local visits = village_life.reputation.visits(session.village_id, pname)

		if village_life.reputation.flag(score, "favoured") then
			return ("Always a pleasure, %s. What can I do for you?"):format(pname)
		elseif score >= 15 then
			lines[#lines + 1] = ("Good to see you again, %s."):format(pname)
		elseif score <= -20 then
			lines[#lines + 1] = "Say your piece and be quick about it."
			lines[#lines + 1] = "I'm watching you."
		elseif visits > 8 then
			lines[#lines + 1] = "Back again? Take a look, then."
		end
	end

	local race = lottmobs.get_pigman_trader_for_profession(self.profession)
	if race and race.messages then
		for _, m in ipairs(race.messages) do lines[#lines + 1] = m end
	end

	local c = market.character(session.village_id)
	if c then
		lines[#lines + 1] = ("Not much %s to be had round here."):format(c.scarce)
		lines[#lines + 1] = ("If it's %s you want, you've come to the right village."):
				format(c.speciality)
	end

	local season = market.season()
	if season == "winter" then
		lines[#lines + 1] = "Long winter. Everything fresh costs dear."
	elseif season == "autumn" then
		lines[#lines + 1] = "Harvest is in. Good time to be buying."
	end

	if #lines == 0 then return "Have a look at my wares, " .. pname .. "." end
	return lines[math.random(#lines)]
end

--------------------------------------------------------------------------------
-- Buttons
--------------------------------------------------------------------------------

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "village_life:trade" then return end
	local pname = player:get_player_name()
	local inv_name = trade.viewing[pname]
	if not inv_name then return end

	-- Clear means clear the whole counter: the selection goes back on the
	-- shelf and the customer's own coins and goods come back to them. It used
	-- to only put the selection back, so anything in the payment or sell slot
	-- stayed in the shop.
	if fields.clear then
		trade.return_belongings(inv_name, pname)
	end

	-- Closing the window has to do the same, or the items are stranded in a
	-- detached inventory the player has no way to reach again.
	if fields.quit then
		trade.return_belongings(inv_name, pname)
		trade.viewing[pname] = nil
	end
end)

minetest.register_on_leaveplayer(function(player)
	local pname = player:get_player_name()
	local inv_name = trade.viewing[pname]
	if inv_name then
		-- Still online for this callback, so the items can go straight back
		-- into the inventory that is about to be saved.
		trade.return_belongings(inv_name, pname)
		trade.viewing[pname] = nil
	end
end)

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not village_life.settings.economy then return end
	local proto = minetest.registered_entities["lottmobs:pigman_trader"]
	if not proto then return end

	proto.on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then return end
		trade.open(self, clicker)
	end

	village_life.log("action", "trade UI attached to lottmobs:pigman_trader")
end)
