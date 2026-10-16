-- foreverpet
-- Every time a pet is tamed or named, its full saved state is quietly written
-- to persistent storage under its owner. If the pet ever dies or vanishes, the
-- record survives and the owner can bring it back as an egg with /petrecall.
--
-- The mob runtime (creaturemob) calls foreverpet.log(self) at the moment of
-- taming and of (re)naming. self:snapshot() returns the same clean staticdata
-- an egg carries, so a recalled pet is byte-for-byte the pet that was logged.

foreverpet = {}

local storage = core.get_mod_storage()

local function kkey(owner) return "pets:" .. owner end

local function load_pets(owner)
	local raw = storage:get_string(kkey(owner))
	if raw == "" then return {} end
	return core.deserialize(raw) or {}
end

local function save_pets(owner, list)
	storage:set_string(kkey(owner), core.serialize(list))
end

-- record (or refresh) one pet
function foreverpet.log(self)
	if type(self) ~= "table" then return end

	local owner = self.owner
	if not owner or owner == "" then return end
	if type(self.snapshot) ~= "function" then return end

	local ok, data = pcall(self.snapshot, self)
	if not ok or type(data) ~= "string" then return end

	-- a stable id so re-logging the same pet updates its entry instead of
	-- piling up duplicates (persists in the mob's staticdata via clean_staticdata)
	local id = self._fp_id
	if not id then
		id = tostring(core.get_us_time()) .. "-" .. math.random(1000, 9999)
		self._fp_id = id
	end

	local entity = self.name or "?"
	local list = load_pets(owner)
	list[id] = {
		id = id,
		entity = entity,
		label = (self._nametag and self._nametag ~= "") and self._nametag or nil,
		species = entity:match(":(.+)$") or entity,
		data = data,
		day = (core.get_day_count and core.get_day_count()) or 0,
	}
	save_pets(owner, list)
end

local function display(e)
	return (e.label and e.label ~= "") and e.label or ("(unnamed " .. e.species .. ")")
end

core.register_chatcommand("petlog", {
	description = "List every pet you have ever tamed or named",
	func = function(name)
		local list = load_pets(name)
		local lines = {}
		for _, e in pairs(list) do
			lines[#lines + 1] = ("%s  -  %s  (day %s)"):format(display(e), e.species, tostring(e.day))
		end
		if #lines == 0 then
			return true, "You have no logged pets yet. Tame or name one and it is recorded automatically."
		end
		table.sort(lines)
		return true, "Your pets (use /petrecall <name>):\n- " .. table.concat(lines, "\n- ")
	end,
})

core.register_chatcommand("petrecall", {
	params = "<name>",
	description = "Get a logged pet back as an egg",
	func = function(name, param)
		param = (param or ""):match("^%s*(.-)%s*$")
		if param == "" then return false, "Usage: /petrecall <pet name>  (see /petlog)" end

		local list = load_pets(name)
		local found
		-- exact name match first, then species
		for _, e in pairs(list) do
			if e.label and e.label:lower() == param:lower() then found = e; break end
		end
		if not found then
			for _, e in pairs(list) do
				if e.species and e.species:lower() == param:lower() then found = e; break end
			end
		end
		if not found then
			return true, "No logged pet called '" .. param .. "'. Try /petlog."
		end

		local player = core.get_player_by_name(name)
		if not player then return false, "You must be online to recall a pet." end

		if not core.registered_items[found.entity] then
			return true, "The egg item for '" .. found.species .. "' no longer exists in this game."
		end

		-- rebuild the egg: the logged pet, stamped to you and set to stay put
		local mob = core.deserialize(found.data) or {}
		mob.owner = name
		mob.tamed = true
		mob.protected = true
		mob.order = "stand"
		mob.state = "stand"

		local stack = ItemStack(found.entity)
		stack:get_meta():set_string("", core.serialize(mob))

		local inv = player:get_inventory()
		if not inv:room_for_item("main", stack) then
			return true, "Your inventory is full - make room and try /petrecall again."
		end
		inv:add_item("main", stack)
		return true, display(found) .. " is back in your inventory as an egg. Place it to bring them home."
	end,
})
