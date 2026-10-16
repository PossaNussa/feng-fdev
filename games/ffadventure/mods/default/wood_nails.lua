-- default/wood_nails.lua
--
-- Wooden nails are the consumable behind the hammer's wood-bracing system in
-- mud.lua.  Driving a nail into a plank swaps the node for a "nailed" clone
-- that carries a visible nail-head overlay and is exempt from the falling-wood
-- ABM.  One stick splits into one Wood Nails item (four nails' worth).

local S = default.get_translator

-- [plain node name] = nailed node name
default.nailed_wood = {}

local OVERLAY = "default_wood_nails_overlay.png"

--------------------------------------------------------------------- the item

minetest.register_craftitem("default:wood_nails", {
	description = S("Wood Nails"),
	inventory_image = "default_wood_nails.png",
	groups = {nails = 1, flammable = 2},
})

minetest.register_craft({
	output = "default:wood_nails",
	recipe = {
		{"default:stick"},
	},
})

-- `castle_tapestries` turns a lone stick into its tapestry rod, and a single
-- input can only feed one recipe (shaped always outranks shapeless).  The
-- nails take that slot, so hand the rod a two-stick shape instead.
minetest.register_on_mods_loaded(function()
	if not minetest.registered_items["castle_tapestries:tapestry_top"] then
		return
	end
	minetest.clear_craft({output = "castle_tapestries:tapestry_top"})
	minetest.register_craft({
		output = "castle_tapestries:tapestry_top",
		recipe = {
			{"default:stick", "default:stick"},
		},
	})
end)

------------------------------------------------------------- nailed variants

-- Stamp the nail heads onto every tile of a node definition.  Tiles may be
-- bare strings or tile tables; anything else is passed through untouched.
local function nail_tiles(tiles)
	if type(tiles) == "string" then
		return {tiles .. "^" .. OVERLAY}
	end
	if type(tiles) ~= "table" then
		return tiles
	end

	local out = {}
	for i, tile in ipairs(tiles) do
		if type(tile) == "string" then
			out[i] = tile .. "^" .. OVERLAY
		elseif type(tile) == "table" then
			local copy = table.copy(tile)
			local base = copy.name or copy.image
			if base then
				copy.name = base .. "^" .. OVERLAY
				copy.image = nil
			end
			out[i] = copy
		else
			out[i] = tile
		end
	end
	return out
end

local function register_nailed(name, def)
	local nailed_name = name .. "_nailed"
	if minetest.registered_nodes[nailed_name] then
		return
	end

	local ndef = table.copy(def)
	ndef.tiles = nail_tiles(def.tiles)
	ndef.description = (def.description or name) .. " " .. S("(Nailed)")
	ndef.groups = table.copy(def.groups or {})
	ndef.groups.not_in_creative_inventory = 1
	ndef.groups.nailed_wood = 1
	-- Nails do not survive being prised back out: a nailed node yields
	-- exactly what the plain node would have.
	ndef.drop = def.drop or name
	ndef._nailed_source = name

	minetest.register_node(":" .. nailed_name, ndef)
	default.nailed_wood[name] = nailed_name
end

minetest.register_on_mods_loaded(function()
	local candidates = {}
	for name, def in pairs(minetest.registered_nodes) do
		if def.groups
			and (def.groups.wood or 0) > 0
			and (def.groups.nailed_wood or 0) == 0
			and name ~= "air" and name ~= "ignore" then
			candidates[#candidates + 1] = name
		end
	end

	-- pairs() order varies between runs; sort so content ids stay stable
	table.sort(candidates)

	for _, name in ipairs(candidates) do
		register_nailed(name, minetest.registered_nodes[name])
	end

	minetest.log("action",
		"[default] registered " .. #candidates .. " nailed wood variants")
end)

---------------------------------------------------------------- driving nails

local last_message = {}

local function tell(player_name, message)
	local now = minetest.get_us_time()
	if last_message[player_name] and now - last_message[player_name] < 1500000 then
		return
	end
	last_message[player_name] = now
	minetest.chat_send_player(player_name, message)
end

minetest.register_on_leaveplayer(function(player)
	last_message[player:get_player_name()] = nil
end)

-- Returns true when a nail went in, otherwise false plus a short reason code.
function default.nail_wood(pos, node, player)
	local def = minetest.registered_nodes[node.name]
	if not def or not player or not player:is_player() then
		return false
	end

	local player_name = player:get_player_name()

	if (def.groups and (def.groups.nailed_wood or 0) > 0)
		or minetest.get_meta(pos):get_int("hammer_hit") ~= 0 then
		tell(player_name, S("This is already nailed down."))
		return false, "already"
	end

	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return false, "protected"
	end

	local nailed = default.nailed_wood[node.name]
	if not nailed then
		-- Tree trunks and anything registered after load have no nailed
		-- variant, so there is nothing to show and nothing to brace against.
		-- Keep the old metadata-only behaviour and charge nothing for it.
		minetest.get_meta(pos):set_int("hammer_hit", 1)
		return true, "novariant"
	end

	local creative = minetest.is_creative_enabled(player_name)
	local inv = player:get_inventory()
	if not creative then
		if not (inv and inv:contains_item("main", "default:wood_nails")) then
			tell(player_name, S("You need Wood Nails to hammer this down."))
			return false, "nonails"
		end
	end

	node.name = nailed
	minetest.swap_node(pos, node)
	-- The metadata flag is kept as well: worlds predating the nailed variants
	-- rely on it to decide what falls.
	minetest.get_meta(pos):set_int("hammer_hit", 1)

	if not creative then
		inv:remove_item("main", "default:wood_nails")
	end

	minetest.sound_play("default_place_node_hard",
		{pos = pos, gain = 0.7, max_hear_distance = 12}, true)

	return true
end
