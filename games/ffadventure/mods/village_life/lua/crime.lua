-- Being seen doing it.
--
-- A village that only reacted to violence had one crime. Taking things out of
-- other people's chests was free, which made the whole settlement feel like
-- scenery with loot in it.
--
-- The rule here is *witnessed*, not *forbidden*. Nothing is protected, nothing
-- is blocked, and an empty street costs you nothing. What matters is whether
-- somebody with line of sight watched you do it -- which is the only version of
-- this that is worth playing around, and the only one that makes a guard patrol
-- mean something.
--
-- Deliberately NOT a crime: corpses. `bones:bones` and anything else a dead
-- villager leaves behind is free to open and free to dig, because burying the
-- dead means destroying that node, and a village that treated its own funerals
-- as theft would be unplayable.

local util = village_life.util
local home = village_life.home

local crime = {}
village_life.crime = crime

--------------------------------------------------------------------------------
-- What counts
--------------------------------------------------------------------------------

-- Nodes whose contents nobody minds you taking. Corpses first, for the reason
-- above; the rest are things the player put down or that are nobody's.
crime.EXEMPT_NODES = {
	["bones:bones"] = true,
	["ancient_bones:ancient_bones"] = true,
}

-- Node name patterns that are exempt. Cheaper to state than to enumerate every
-- mod's grave variant.
crime.EXEMPT_PATTERNS = {
	"^bones:",
	"bones$",
	"grave",
	"corpse",
	"remains",
}

function crime.is_exempt(node_name)
	if not node_name then return true end
	if crime.EXEMPT_NODES[node_name] then return true end
	for _, pattern in ipairs(crime.EXEMPT_PATTERNS) do
		if node_name:find(pattern) then return true end
	end
	return false
end

-- How far a witness can be and still see whose hand was in the chest.
local SEE = 14

-- What a villager would call the thing that was taken. `get_short_description`
-- is not on every engine version, and cannot be probed with `:` -- that syntax
-- is a call, not a lookup.
local function item_label(stack)
	local get = stack.get_short_description
	if get then
		local ok, desc = pcall(get, stack)
		if ok and desc and desc ~= "" then return desc end
	end
	return stack:get_name()
end

--------------------------------------------------------------------------------
-- Value
--------------------------------------------------------------------------------

-- Roughly what was taken, so pocketing a stack of diamonds is not the same
-- offence as taking a loaf. Item value is not something this game models, so
-- this is a count with a nod to rarity rather than a price.
local function severity(stack)
	if not stack or stack:is_empty() then return 0 end
	local count = stack:get_count()
	local name = stack:get_name()

	local worth = 1
	if name:find("diamond") or name:find("gold") or name:find("mese") then
		worth = 4
	elseif name:find("steel") or name:find("copper") or name:find("bronze")
			or name:find("coin") then
		worth = 2
	end

	-- Sublinear in count: the second loaf is worth less outrage than the first.
	return worth * (1 + math.log(count) / 2)
end

--------------------------------------------------------------------------------
-- Reporting
--------------------------------------------------------------------------------

-- Rate limit per player per container. Emptying a 32-slot chest is one theft,
-- not thirty-two, and without this a single shift-click would end a village.
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

-- Someone took something out of a container. Raise it as a crime if, and only
-- if, a villager saw.
function crime.on_take(pos, stack, player)
	if not player or not player.is_player or not player:is_player() then return end
	if not village_life.settings.crime then return end

	local pname = player:get_player_name()
	local node = minetest.get_node_or_nil(pos)
	if not node or crime.is_exempt(node.name) then return end

	-- Whose village is this? Something in the wilderness belongs to nobody.
	-- The height bound matters: `vs` describes a cylinder of infinite height,
	-- so without it a chest in a cave a hundred nodes down is village property.
	local village, village_id = home.village_at(pos, 8, 12)
	if not village_id then return end

	-- Your own town is your own. The founder of a player-settled town owns its
	-- ground and everything on it, so taking from a chest there is never theft --
	-- Throg does not report the man who built his house for helping himself to his
	-- own stores. (Another player doing it in your town still answers for it.)
	if village and village.is_player_town and village.founder == pname then return end

	local weight = severity(stack)
	if weight <= 0 then return end

	local witnesses = village_life.events.witnesses(village_id, pos, SEE)
	if #witnesses == 0 then
		-- Nobody saw. This is the whole point: an empty street is an
		-- opportunity, and the player can find that out by looking around.
		return
	end

	if too_soon(pname, pos) then return end

	local ev = village_life.events.raise({
		kind = "theft",
		village_id = village_id,
		pos = pos,
		actor = pname,
		detail = {
			item = stack:get_name(),
			item_name = item_label(stack),
			count = stack:get_count(),
		},
		witnesses = witnesses,
	})

	-- The village's own reckoning, on top of the personal one each witness
	-- makes for themselves.
	if village_life.settings.reputation then
		village_life.reputation.adjust(village_id, pname,
				-crime.COST_PER_WITNESS * math.min(#witnesses, 4) * weight,
				"theft")
	end

	for _, key in ipairs(witnesses) do
		village_life.memory.remember_key(key, pname, "robbed")
	end

	return ev
end

-- Per witness, per unit of severity. Four witnesses is the cap: after that it
-- is common knowledge and more onlookers add nothing.
crime.COST_PER_WITNESS = 2.5

--------------------------------------------------------------------------------
-- Attachment
--------------------------------------------------------------------------------

-- Wraps `on_metadata_inventory_take` on every registered node that has one, in
-- the same late-override style the rest of this mod uses for entity
-- prototypes. Nothing in any other mod is edited.
--
-- `allow_metadata_inventory_take` is deliberately not touched: this does not
-- prevent the theft, it notices it.
minetest.register_on_mods_loaded(function()
	if not village_life.settings.crime then return end

	local wrapped = 0
	for name, def in pairs(minetest.registered_nodes) do
		if def.on_metadata_inventory_take and not crime.is_exempt(name) then
			local prev = def.on_metadata_inventory_take
			def.on_metadata_inventory_take =
					function(pos, listname, index, stack, player)
				-- The mod's own handler first: ours only observes, and must not
				-- be the reason a container misbehaves if it errors.
				local ok, err = pcall(prev, pos, listname, index, stack, player)
				if not ok then
					village_life.log("warning", "container take handler: " ..
							tostring(err))
				end
				pcall(crime.on_take, pos, stack, player)
			end
			wrapped = wrapped + 1
		end
	end

	village_life.log("action", ("crime watching %d container type(s)"):format(
			wrapped))
end)
