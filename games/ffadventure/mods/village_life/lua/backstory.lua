-- A villager's backstory: where they came from, and what became of it.
--
-- Most people in a village were born in it. A few were not -- they kept a shop
-- somewhere else once, and something ended it, and they came here. That is a
-- fact about a person the census never had a place for, so it is written onto
-- the bed row itself (like a death, in succession.lua): a handful of small
-- fields that ride with the character, persist in mg_all_villages.data, and
-- survive an unload.
--
--   moved_from    the place they left (a former outpost, a lost town)
--   sold_to       who took it on, if they handed it over rather than lost it
--   moved_day     the in-game day they arrived here
--   arrival_told  set once the village has heard they came -- so it is news once
--
-- Reading it is what lets dialogue.lua offer "you've settled here recently,
-- haven't you?" to the one villager in the world with a past the player
-- actually watched happen -- and lets a village gossip about a new face.

local home = village_life.home

local backstory = {}
village_life.backstory = backstory

-- The record on this villager's bed, or nil. Kept tiny on purpose: a place they
-- left, whoever took it, and when they arrived. The bed itself is returned too,
-- so a caller that means to write back (the arrival rumour) has it to hand.
function backstory.of(self)
	if not (self and self.vl and self.vl.v) then return end
	local bed = home.bed_data(self.vl.v, self.vl.p, self.vl.b)
	if not bed or not bed.moved_from then return end
	return {
		from_place = bed.moved_from,
		sold_to    = bed.sold_to,
		moved_day  = bed.moved_day,
		bed        = bed,
	}
end

-- Stamp a backstory onto a bed row by identity. The one seam anything that
-- relocates a villager writes through -- save-surgery today, and succession
-- later, if a displaced trader is ever to resurface somewhere new rather than
-- simply be forgotten.
function backstory.set(village_id, plot_nr, bed_nr, rec)
	local bed = home.bed_data(village_id, plot_nr, bed_nr)
	if not bed then return false end
	bed.moved_from = rec.from_place
	bed.sold_to    = rec.sold_to
	bed.moved_day  = rec.moved_day
			or (minetest.get_day_count and minetest.get_day_count() or 0)
	-- A fresh arrival is news again.
	bed.arrival_told = nil
	if mg_villages.save_data then mg_villages.save_data() end
	return true
end

--------------------------------------------------------------------------------
-- The arrival becomes news
--------------------------------------------------------------------------------

-- The first time a moved-in villager is actually loaded and standing in their
-- new village, the village hears they have come. `arrival_told` on the bed keeps
-- it to a single telling; events.raise seeds it into the gossip network from
-- there, so it spreads and fades like any other piece of news.
--
-- Walks the roster (the villagers that exist right now), the same list
-- events.witnesses uses, and only acts on the rare bed that carries a backstory.
local CHECK = 30
local timer = 0

minetest.register_globalstep(function(dtime)
	if not village_life.settings.gossip then return end

	timer = timer + dtime
	if timer < CHECK then return end
	timer = 0

	for key, entry in pairs(home.roster or {}) do
		local obj = entry.obj
		local self = obj and obj:get_luaentity()
		if self and self.vl and self.vl.v then
			local bed = home.bed_data(self.vl.v, self.vl.p, self.vl.b)
			if bed and bed.moved_from and not bed.arrival_told then
				local pos = obj:get_pos()
				if pos then
					village_life.events.raise({
						kind = "arrival",
						village_id = self.vl.v,
						pos = pos,
						subject = key,
						subject_name = bed.first_name,
						detail = {from = bed.moved_from, title = bed.title},
					})
					bed.arrival_told = true
					if mg_villages.save_data then mg_villages.save_data() end
					village_life.log("action", ("%s has come to settle in %s, from %s"):format(
							tostring(bed.first_name), self.vl.v, bed.moved_from))
				end
			end
		end
	end
end)

return backstory
