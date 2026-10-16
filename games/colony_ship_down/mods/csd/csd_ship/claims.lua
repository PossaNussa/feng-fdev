-- Claiming a room: crew can make a cabin or vacant room their own. Inside a
-- claimed room only the owner (and builders) can place or dig.

local S = csd_ship.S
local storage = core.get_mod_storage()

local claims = core.deserialize(storage:get_string("claims")) or {} -- room id -> owner
local LIMIT = tonumber(core.settings:get("csd_claim_limit")) or 1

local function save()
	storage:set_string("claims", core.serialize(claims))
end

function csd_ship.claim_owner(room)
	return room and room.id and claims[room.id] or nil
end

function csd_ship.claim_owner_at(pos)
	local r = csd_ship.room_at(pos)
	return csd_ship.claim_owner(r), r
end

local function claims_of(name)
	local out = {}
	local data = csd_ship.get_ship_data()
	for _, r in ipairs(data and data.rooms or {}) do
		if claims[r.id] == name then out[#out + 1] = r end
	end
	return out
end

csd_core.register_protection_check(function(pos, name)
	local owner = csd_ship.claim_owner_at(pos)
	if owner then
		return owner ~= name -- inside a claimed room: only the owner may build
	end
end)

-- Show ownership in the location label ("Deck 2 - Cabin 2N-03 (Alice's)").
local old_label = csd_ship.location_label
csd_ship.room_label = old_label -- plain room name, for task stations
function csd_ship.location_label(pos)
	local label, r = old_label(pos)
	local owner = csd_ship.claim_owner(r)
	if label and owner then
		label = label .. " " .. S("[@1's room]", owner)
	elseif label and r and r.claimable then
		label = label .. " " .. S("[vacant - /claim it]")
	end
	return label, r
end

core.register_chatcommand("claim", {
	description = S("Claim the cabin or vacant room you're standing in"),
	func = function(name)
		local player = core.get_player_by_name(name)
		if not player then return false end
		local r = csd_ship.room_at(player:get_pos())
		if not r or not r.claimable then
			return false, S("You can only claim crew cabins and vacant rooms.")
		end
		local owner = claims[r.id]
		if owner == name then return true, S("This room is already yours.") end
		if owner then return false, S("This room belongs to @1.", owner) end
		if not csd_core.is_builder(name) and #claims_of(name) >= LIMIT then
			return false, S("You already have a room. /unclaim it first.")
		end
		claims[r.id] = name
		save()
		return true, S("@1 is now yours. Only you can build here.", r.name)
	end,
})

core.register_chatcommand("unclaim", {
	description = S("Give up the room you're standing in (or your room)"),
	func = function(name)
		local player = core.get_player_by_name(name)
		if not player then return false end
		local r = csd_ship.room_at(player:get_pos())
		if not (r and claims[r.id]) then
			r = claims_of(name)[1]
		end
		if not r or not claims[r.id] then return false, S("You don't have a room.") end
		if claims[r.id] ~= name and not csd_core.is_builder(name) then
			return false, S("That's not your room.")
		end
		claims[r.id] = nil
		save()
		return true, S("@1 is vacant again.", r.name)
	end,
})

core.register_chatcommand("myroom", {
	description = S("Where is my room?"),
	func = function(name)
		local mine = claims_of(name)
		if #mine == 0 then return true, S("You don't have a room yet. Find a vacant one and /claim it.") end
		return true, S("Your room: Deck @1 - @2", mine[1].deck, mine[1].name)
	end,
})
