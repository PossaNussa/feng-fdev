-- What to do with a plot you just bought.
--
-- mg_villages lets a player buy any plot for coin and then says nothing more
-- about it: it is simply "owned by you". But a player who has founded a town of
-- their own, or who has bought their way into a real village, has a decision to
-- make -- and this is where they make it.
--
-- On a successful purchase the player is asked:
--   * Part of {your town}   -- fold the plot into your settlement. Near enough,
--                              the town's border grows to include it and you
--                              dedicate its beds with the deed like any plot you
--                              founded. Too far for that to be sensible (see
--                              ANNEX_MAX_DIST), it is held as an outlying holding
--                              instead -- yours, listed, but not swallowing the
--                              map into one giant circle.
--   * Join {the village}    -- only when the plot is part of a real village, not
--                              a one-off outpost: you become a recognised member,
--                              warmly regarded and counted among its inhabitants.
--   * Personal property     -- keep it as a plain holding, the mg_villages default.
--
-- Nothing here edits mg_villages. mg_villages.form_input_handler calls
-- mg_villages.plotmarker_formspec *by name* every time, so wrapping that global
-- at load lets us run after a purchase without touching the mod -- the same
-- override technique settlement.lua uses on the deed book.

local home = village_life.home
local settlement = village_life.settlement

local plotclaim = {}
village_life.plotclaim = plotclaim

local function today()
	return minetest.get_day_count and minetest.get_day_count() or 0
end
local function iround(n) return math.floor(n + 0.5) end

-- Past this many blocks from a town's centre, folding a plot into the town's
-- circle is pointless -- the circle would balloon across everything between. A
-- plot bought further out than this is kept as an outlying holding instead.
local ANNEX_MAX_DIST = 500

-- A village with at least this many residents is "a real village" you can join,
-- as opposed to a lone outpost or a one-off building.
local VILLAGE_MIN_RESIDENTS = 3

-- Standing a new member is welcomed to: "trusted" on rep.tiers -- treated as one
-- of their own, with room above to become an honoured ally.
local MEMBER_SCORE = 40

local FORM = "village_life:plot_claim"
local esc = minetest.formspec_escape

-- Per-player scratch: the plot a just-finished purchase is asking about.
plotclaim.pending = {}

--------------------------------------------------------------------------------
-- Reading the plot
--------------------------------------------------------------------------------

-- The (village, plot) a plotmarker node stands for, from its own metadata --
-- exactly the fields mg_villages.plotmarker_formspec reads.
local function plot_at(pos)
	local meta = pos and minetest.get_meta(pos)
	if not meta then return end
	local village_id = meta:get_string("village_id")
	local plot_nr = meta:get_int("plot_nr")
	if village_id == "" then return end
	local v = mg_villages.all_villages and mg_villages.all_villages[village_id]
	local plot = v and v.to_add_data and v.to_add_data.bpos
			and v.to_add_data.bpos[plot_nr]
	if not plot then return end
	return v, plot, village_id, plot_nr
end

local function plot_centre(plot)
	return {
		x = plot.x + ((plot.bsizex or 1) - 1) / 2,
		y = plot.y or 0,
		z = plot.z + ((plot.bsizez or 1) - 1) / 2,
	}
end

-- The founder's nearest town to a point, by centre distance -- unlike
-- settlement.town_at this does not require the point to fall inside the circle,
-- because the whole question is what to do with a plot that is outside it.
local function nearest_town(pname, pos)
	local best, best_id, best_d
	for id, v in pairs(settlement.towns_of(pname)) do
		if v.vx and v.vz then
			local dx, dz = pos.x - v.vx, pos.z - v.vz
			local d = math.sqrt(dx * dx + dz * dz)
			if not best_d or d < best_d then best, best_id, best_d = v, id, d end
		end
	end
	return best, best_id, best_d
end

-- Named residents of a village (a bed with a first_name is a person). Used to
-- tell a real village from a one-off outpost.
local function resident_count(v)
	local n = 0
	for _, bpos in ipairs(v.to_add_data and v.to_add_data.bpos or {}) do
		for _, bed in ipairs(bpos.beds or {}) do
			if bed.first_name then n = n + 1 end
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- The choices, carried out
--------------------------------------------------------------------------------

-- Fold the plot into the player's town. Near enough, grow the town's circle to
-- reach it (a true annex -- the deed then works on its beds); too far, keep it
-- as an outlying holding without moving the border.
function plotclaim.annex(pname, pos, village_id, plot_nr)
	local _, plot = plot_at(pos)
	if not plot then return end
	local c = plot_centre(plot)
	local town, town_id, dist = nearest_town(pname, c)
	if not town then
		minetest.chat_send_player(pname, "[Plot] You have no town to add it to.")
		return
	end

	plot.vl_annexed_to = town_id
	if dist <= ANNEX_MAX_DIST then
		settlement.expand_town(town, c)
		plot.vl_annex_kind = "land"
		minetest.chat_send_player(pname, ("[Plot] Annexed into %s -- its border "
				.. "reaches here now. Punch the beds inside with the deed to say "
				.. "who lives in them."):format(town.name or "your town"))
	else
		plot.vl_annex_kind = "outlying"
		minetest.chat_send_player(pname, ("[Plot] It's %dm from %s -- too far to "
				.. "fold into the town proper, so it's held as an outlying property "
				.. "of %s."):format(iround(dist), town.name or "your town",
						town.name or "your town"))
	end
	settlement.save()
end

-- Become a recognised member of a real village: welcomed in its regard, and
-- counted among its people (the plot purchase already put the buyer on the
-- village ownerlist; this records the membership village_life reads).
function plotclaim.join(pname, village_id)
	local v = mg_villages.all_villages and mg_villages.all_villages[village_id]
	if not v then return end

	-- Formal inhabitant: on the ownerlist (mg_villages' own bookkeeping) and in
	-- our members roll.
	v.ownerlist = v.ownerlist or {}
	v.ownerlist[pname] = true
	v.vl_members = v.vl_members or {}
	v.vl_members[pname] = today()

	-- Welcomed in standing, and a lasting one (met past the earned floor), so the
	-- village treats a member as one of its own rather than a passing face.
	if village_life.settings.reputation then
		local rep = village_life.reputation
		rep.note_visit(village_id, pname)
		local e = rep.book[village_id] and rep.book[village_id][pname]
		if e then e.met = math.max(e.met or 0, 5) end
		local cur = rep.get(village_id, pname)
		if cur < MEMBER_SCORE then
			rep.adjust(village_id, pname, MEMBER_SCORE - cur, "joined the village")
		end
	end

	settlement.save()
	minetest.chat_send_player(pname, ("[Plot] You're one of %s now -- its people "
			.. "will treat you as their own."):format(v.name or "the village"))
end

function plotclaim.is_member(pname, village_id)
	local v = mg_villages.all_villages and mg_villages.all_villages[village_id]
	return v and v.vl_members and v.vl_members[pname] ~= nil
end

--------------------------------------------------------------------------------
-- The prompt
--------------------------------------------------------------------------------

-- Shown right after a purchase goes through. Returns true if it put a form up
-- (so the caller knows our window has replaced the "Congratulations" one), false
-- if there was nothing to ask.
function plotclaim.offer(player, pos, village_id, plot_nr)
	if not village_life.settings.settlement then return false end
	local pname = player:get_player_name()
	local v, plot = plot_at(pos)
	if not v or not plot then return false end

	-- A plot in one of the player's OWN towns is already theirs; nothing to ask.
	if v.is_player_town then return false end

	local c = plot_centre(plot)
	local town, town_id, tdist = nearest_town(pname, c)
	local has_town = town ~= nil
	local is_village = resident_count(v) >= VILLAGE_MIN_RESIDENTS

	-- No town to add it to, and not a village to join: leave mg_villages' own
	-- "Congratulations" message to stand.
	if not has_town and not is_village then return false end

	plotclaim.pending[pname] = {
		pos = pos, village_id = village_id, plot_nr = plot_nr,
		town_id = town_id,
	}

	local body = {
		"label[0.5,0.6;" .. esc("The plot is yours. What is it to be?") .. "]",
	}
	local y = 1.3
	if has_town then
		body[#body + 1] = ("label[0.5,%s;%s]"):format(y, esc(
				("It's %dm from your town, %s."):format(iround(tdist or 0),
						town.name or "your town")))
		y = y + 0.6
		local land = (tdist or 0) <= ANNEX_MAX_DIST
		body[#body + 1] = ("button[0.5,%s;7,0.7;annex;%s]"):format(y, esc(
				land and ("Make it part of %s"):format(town.name or "your town")
				or ("Hold it as an outlying property of %s"):format(town.name or "your town")))
		y = y + 0.95
	end
	if is_village then
		body[#body + 1] = ("button[0.5,%s;7,0.7;join;%s]"):format(y, esc(
				("Join %s as one of its own"):format(v.name or "the village")))
		y = y + 0.95
	end
	body[#body + 1] = ("button_exit[0.5,%s;7,0.7;personal;%s]"):format(y,
			esc("Keep it as personal property"))
	y = y + 1.1

	minetest.show_formspec(pname, FORM, table.concat({
		"formspec_version[4]", ("size[8,%s]"):format(y), table.concat(body),
	}))
	return true
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORM then return end
	local pname = player:get_player_name()
	local p = plotclaim.pending[pname]
	plotclaim.pending[pname] = nil
	if not p then return true end

	if fields.annex then
		plotclaim.annex(pname, p.pos, p.village_id, p.plot_nr)
	elseif fields.join then
		plotclaim.join(pname, p.village_id)
	elseif fields.personal then
		local _, plot = plot_at(p.pos)
		if plot then plot.vl_personal = true ; settlement.save() end
		minetest.chat_send_player(pname, "[Plot] Kept as your own personal property.")
	end
	return true
end)

minetest.register_on_leaveplayer(function(player)
	plotclaim.pending[player:get_player_name()] = nil
end)

--------------------------------------------------------------------------------
-- Catching the purchase
--------------------------------------------------------------------------------

-- Wrap mg_villages' plotmarker handler so a completed purchase opens the prompt.
-- Done at mods-loaded time, when mg_villages is certainly present, and only once.
minetest.register_on_mods_loaded(function()
	if not village_life.settings.settlement then return end
	if type(mg_villages) ~= "table"
			or type(mg_villages.plotmarker_formspec) ~= "function" then
		return
	end
	if mg_villages._vl_plotclaim_wrapped then return end
	mg_villages._vl_plotclaim_wrapped = true

	local orig = mg_villages.plotmarker_formspec
	mg_villages.plotmarker_formspec = function(pos, formname, fields, player)
		-- Only a "buy" click can turn an unowned plot into an owned one.
		local pname = player and player.get_player_name and player:get_player_name()
		local buying = fields and fields.buy and pos and pname
		local before
		if buying then
			local _, plot = plot_at(pos)
			before = plot and plot.owner
		end

		orig(pos, formname, fields, player)

		-- Did this click actually complete the purchase for this player?
		if buying then
			local _, plot, village_id, plot_nr = plot_at(pos)
			if plot and plot.owner == pname and before ~= pname then
				-- Our prompt replaces mg_villages' "Congratulations" formspec.
				plotclaim.offer(player, pos, village_id, plot_nr)
			end
		end
	end
	village_life.log("action", "plot-claim prompt attached to mg_villages plotmarker")
end)

return plotclaim
