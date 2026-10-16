-- Deep space: nothing generates but vacuum, the sky is a starfield, and in
-- vacuum you can't breathe and you float (zero-g).

csd_space = {}

local S = core.get_translator("csd_space")

-- Only take over the mapgen in CSD itself; in ffadventure this mod would just
-- provide the vacuum API.
if core.get_game_info and core.get_game_info().id == "colony_ship_down" then
	core.set_mapgen_setting("mg_name", "singlenode", true)
	core.set_mapgen_setting("mg_flags", "nocaves,nodungeons,light,nodecorations,nobiomes,noores", true)
end

local SKY = {
	"csd_space_sky_up.png", "csd_space_sky_down.png",
	"csd_space_sky_front.png", "csd_space_sky_back.png",
	"csd_space_sky_left.png", "csd_space_sky_right.png",
}

function csd_space.apply_sky(player)
	player:set_sky({
		type = "skybox",
		base_color = "#000005",
		textures = SKY,
		clouds = false,
		fog = {fog_distance = -1, fog_start = 0.85},
	})
	player:set_sun({visible = false, sunrise_visible = false})
	player:set_moon({visible = false})
	player:set_stars({visible = false})
	player:set_clouds({density = 0})
	-- Fixed light level: the ship is lit by its own lamps, not a day cycle.
	player:override_day_night_ratio(0.55)
	player:set_lighting({
		shadows = {intensity = 0.3},
		bloom = {intensity = 0.08},
		volumetric_light = {strength = 0.15},
	})
end

core.register_on_joinplayer(csd_space.apply_sky)

------------------------------------------------------------------------------
-- Vacuum
------------------------------------------------------------------------------

-- Space is filled with this node instead of air. It drowns you, so breath
-- drains and air tanks (airtanks mod) work as EVA tanks with no extra code.
-- The ship's interior is ordinary air.
core.register_node("csd_space:vacuum", {
	description = S("Vacuum"),
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	floodable = true,
	drop = "",
	drowning = 2,
	-- Zero-g: "swimming" movement (jump to rise, sneak to sink); sinking is
	-- switched off per player in vacuum, so you float instead of falling.
	liquid_move_physics = true,
	move_resistance = 1,
	groups = {not_in_creative_inventory = 1, vacuum = 1},
})

if core.get_game_info and core.get_game_info().id == "colony_ship_down" then
	core.register_alias("mapgen_singlenode", "csd_space:vacuum")

	-- Shared ffadventure mods bring terrain post-processing (caves, ores,
	-- decorations) that expects a real mapgen. Out here there's only vacuum,
	-- so drop every on_generated callback that isn't one of ours.
	core.register_on_mods_loaded(function()
		local kept, dropped = {}, {}
		for _, func in ipairs(core.registered_on_generateds) do
			local mod = core.callback_origins[func].mod or "??"
			if mod:sub(1, 4) == "csd_" then
				kept[#kept + 1] = func
			else
				dropped[mod] = true
			end
		end
		for i = #core.registered_on_generateds, 1, -1 do
			core.registered_on_generateds[i] = nil
		end
		for i, func in ipairs(kept) do
			core.registered_on_generateds[i] = func
		end
		local names = {}
		for mod in pairs(dropped) do names[#names + 1] = mod end
		table.sort(names)
		if #names > 0 then
			core.log("action", "[csd_space] ignoring terrain generators in space: " .. table.concat(names, ", "))
		end
	end)
end

function csd_space.is_pressurized(pos)
	local node = core.get_node_or_nil(pos)
	-- Unloaded (nil) counts as pressurised: never warn about what we can't see.
	return node == nil or core.get_item_group(node.name, "vacuum") == 0
end

local in_vacuum = {}
local joined = {}

local function set_low_gravity(player, on)
	-- In vacuum the node's liquid physics replace gravity; turn sinking off
	-- and let people glide a little more freely.
	player:set_physics_override({
		liquid_sink = on and 0 or 1,
		liquid_fluidity = on and 2.5 or 1,
		liquid_fluidity_smooth = on and 0.3 or 1,
	})
end

-- How far from the ship before a maintenance drone fetches you back.
local RESCUE_DISTANCE = tonumber(core.settings:get("csd_rescue_distance")) or 400

csd_space.ship_center = nil -- set by csd_ship

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then return end
	timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		local pos = player:get_pos()
		local head = vector.offset(pos, 0, 1.5, 0)
		local vacuum = not csd_space.is_pressurized(head)
		if vacuum ~= (in_vacuum[name] or false) then
			in_vacuum[name] = vacuum or nil
			set_low_gravity(player, vacuum)
			if vacuum and (joined[name] or 0) + 5e6 < core.get_us_time() then
				core.chat_send_player(name, core.colorize("#88ccff",
					S("You are in vacuum. Your breath will run out - carry air tanks and a breathing tube for EVA.")))
			end
		end
		if vacuum and csd_core.is_builder(name) then
			-- Builders work on the hull without juggling air tanks.
			player:set_breath(player:get_properties().breath_max)
		end
		local center = csd_space.ship_center
		if center and vector.distance(pos, center) > RESCUE_DISTANCE then
			if csd_core.send_to_spawn(player) then
				core.chat_send_player(name, core.colorize("#88ccff",
					S("A maintenance drone towed you back aboard.")))
			end
		end
	end
end)

core.register_on_joinplayer(function(player)
	-- New arrivals are moved to the ship a moment after joining; don't warn them.
	joined[player:get_player_name()] = core.get_us_time()
end)

core.register_on_leaveplayer(function(player)
	in_vacuum[player:get_player_name()] = nil
	joined[player:get_player_name()] = nil
end)

function csd_space.player_in_vacuum(name)
	return in_vacuum[name] == true
end
