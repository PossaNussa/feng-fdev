-- Angled Walls: stance-driven placement.
--
-- Face roughly along an axis and blocks go down as plain cubes, exactly as
-- always.  Face roughly along a diagonal and the block you place turns into its
-- angled variant, chamfer towards you, so a wall you build while walking a
-- diagonal comes out as one continuous 45 degree surface.  Holding the modifier
-- key (sneak by default) places the corner piece instead, which is what joins a
-- diagonal run to an axis-aligned wall.

local settings = core.settings

local DEFAULT_ON = settings:get_bool("angledwalls.enabled_by_default", true)

local MODIFIERS = {sneak = true, aux1 = true, none = true}
local MODIFIER = settings:get("angledwalls.corner_modifier") or "sneak"
if not MODIFIERS[MODIFIER] then
	core.log("warning", "[angledwalls] unknown angledwalls.corner_modifier '" ..
		MODIFIER .. "', using 'sneak'")
	MODIFIER = "sneak"
end

-- How far from a true 45 degrees still counts as "standing at an angle".  Kept
-- well under 45 so that facing an axis is unambiguous: with the default of 20
-- degrees, a third of the compass places angled blocks and the rest places
-- cubes.
local TOLERANCE = math.min(math.max(tonumber(settings:get("angledwalls.tolerance")) or 20, 1), 44)
local RATIO_MIN = math.tan(math.rad(45 - TOLERANCE))
local RATIO_MAX = math.tan(math.rad(45 + TOLERANCE))

-- Which diagonal the player is facing, as the signs of the look direction, or
-- nil when they are facing close enough to an axis.
function angledwalls.stance(player)
	local dir = core.yaw_to_dir(player:get_look_horizontal())
	local ax, az = math.abs(dir.x), math.abs(dir.z)
	if ax < az * RATIO_MIN or ax > az * RATIO_MAX then
		return nil
	end
	return dir.x >= 0 and 1 or -1, dir.z >= 0 and 1 or -1
end

-- Per-player preference, mirrored in player meta: 0 unset, 1 on, 2 off.
local pref = {}

local function enabled(name, player)
	local state = pref[name]
	if state == nil then
		local mode = player:get_meta():get_int("angledwalls:mode")
		state = (mode == 0) and DEFAULT_ON or (mode == 1)
		pref[name] = state
	end
	return state
end

core.register_on_leaveplayer(function(player)
	pref[player:get_player_name()] = nil
end)

-- Placement runs through the normal item_place path first -- protection, node
-- replacement, after_place_node and the plain cube's own on_place all behave as
-- usual -- and only then is the shape swapped in.  Nothing about how blocks are
-- obtained or placed changes; only what the placed block looks like.
core.register_on_placenode(function(pos, newnode, placer)
	local variants = angledwalls.variants[newnode.name]
	if not variants or not placer or not placer.is_player or not placer:is_player() then
		return
	end
	local name = placer:get_player_name()
	if not enabled(name, placer) then
		return
	end
	local sx, sz = angledwalls.stance(placer)
	if not sx then
		return
	end

	local shape = "diag"
	if variants.corner and MODIFIER ~= "none"
			and placer:get_player_control()[MODIFIER] then
		shape = "corner"
	end
	local target = variants[shape]
	if not target then
		return
	end

	-- Read the map rather than trusting the callback's copy: after_place_node
	-- has already run and may have written param2 (a palette colour, say).
	local placed = core.get_node(pos)
	if placed.name ~= newnode.name then
		return
	end

	local param2 = angledwalls.shapes[shape].param2(sx, sz)
	if variants.colordiv then
		-- replace the rotation bits, keep the palette colour
		param2 = param2 + placed.param2 - (placed.param2 % variants.colordiv)
	end
	-- swap_node keeps node metadata that after_place_node may just have written
	core.swap_node(pos, {name = target, param2 = param2})
end)

core.register_chatcommand("angled", {
	params = "[on | off]",
	description = "Place blocks at an angle while standing at an angle",
	func = function(name, param)
		local player = core.get_player_by_name(name)
		if not player then
			return false, "You need to be online."
		end
		param = param:trim():lower()
		local state
		if param == "" then
			state = not enabled(name, player)
		elseif param == "on" or param == "off" then
			state = param == "on"
		else
			return false, "Usage: /angled [on | off]"
		end
		pref[name] = state
		player:get_meta():set_int("angledwalls:mode", state and 1 or 2)
		if not state then
			return true, "Angled placement off: blocks always go down square."
		end
		return true, "Angled placement on: face a diagonal to place at 45 degrees" ..
			(MODIFIER == "none" and "." or (", hold " .. MODIFIER .. " for a corner piece."))
	end,
})
