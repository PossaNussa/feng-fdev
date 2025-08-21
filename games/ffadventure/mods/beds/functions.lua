-- beds/functions.lua (full replacement)
-- Daytime sleep enabled: players can enter beds at any time; if everyone (or a majority via Force) is in bed:
--   - Daytime → skip to night
--   - Night-time → skip to morning
-- Movement requirement removed: no need to stop before entering bed.
-- Spawnpoints are saved on entering a bed (unchanged flow).

local pi = math.pi
local is_sp = minetest.is_singleplayer()
local enable_respawn = minetest.settings:get_bool("enable_bed_respawn")
if enable_respawn == nil then
	enable_respawn = true
end

-- support for MT game translation.
local S = beds.get_translator

-- Helper functions

local function get_look_yaw(pos)
	local rotation = minetest.get_node(pos).param2
	if rotation > 3 then
		rotation = rotation % 4 -- Mask colorfacedir values
	end

	local yaw = 0
	if rotation == 1 then
		yaw = pi / 2
	elseif rotation == 3 then
		yaw = 3 * pi / 2
	elseif rotation == 2 then
		yaw = pi
	end

	return yaw, rotation
end

local function is_night_skip_enabled()
	local enable_night_skip = minetest.settings:get_bool("enable_bed_night_skip")
	if enable_night_skip == nil then
		enable_night_skip = true
	end
	return enable_night_skip
end

local function is_day()
	local tod = minetest.get_timeofday()
	return (tod > beds.day_interval.start) and (tod < beds.day_interval.finish)
end

local function check_in_beds(players)
	local in_bed = beds.player
	if not players then
		players = minetest.get_connected_players()
	end

	for n, player in ipairs(players) do
		local name = player:get_player_name()
		if not in_bed[name] then
			return false
		end
	end

	return #players > 0
end

local function lay_down(player, pos, bed_pos, state, skip)
	local name = player:get_player_name()
	local hud_flags = player:hud_get_flags()

	if not player or not name then
		return
	end

	-- stand up
	if state ~= nil and not state then
		if not beds.player[name] then
			-- player not in bed, do nothing
			return false
		end
		beds.bed_position[name] = nil
		-- skip here to prevent sending player specific changes (used for leaving players)
		if skip then
			return
		end
		player:set_pos(beds.pos[name])

		-- physics, eye_offset, etc
		local physics_override = beds.player[name].physics_override
		beds.player[name] = nil
		player:set_physics_override({
			speed = physics_override.speed,
			jump = physics_override.jump,
			gravity = physics_override.gravity
		})
		player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
		player:set_look_horizontal(math.random(1, 180) / 100)
		player_api.player_attached[name] = false
		hud_flags.wielditem = true
		player_api.set_animation(player, "stand" , 30)

	-- lay down
	else

		-- Check if bed is occupied
		for _, other_pos in pairs(beds.bed_position) do
			if vector.distance(bed_pos, other_pos) < 0.1 then
				minetest.chat_send_player(name, S("This bed is already occupied!"))
				return false
			end
		end

		-- movement check removed: allow entering bed while moving

		-- Check if player is attached to an object
		if player:get_attach() then
			return false
		end

		if beds.player[name] then
			-- player already in bed, do nothing
			return false
		end

		beds.pos[name] = pos
		beds.bed_position[name] = bed_pos
		beds.player[name] = {physics_override = player:get_physics_override()}

		local yaw, param2 = get_look_yaw(bed_pos)
		player:set_look_horizontal(yaw)
		local dir = minetest.facedir_to_dir(param2)
		-- p.y is just above the nodebox height of the 'Simple Bed' (the highest bed),
		-- to avoid sinking down through the bed.
		local p = {
			x = bed_pos.x + dir.x / 2,
			y = bed_pos.y + 0.07,
			z = bed_pos.z + dir.z / 2
		}
		player:set_physics_override({speed = 0, jump = 0, gravity = 0})
		player:set_pos(p)
		player_api.player_attached[name] = true
		hud_flags.wielditem = false
		player_api.set_animation(player, "lay" , 0)
	end
	return true
end

local function get_player_in_bed_count()
	local c = 0
	for _, _ in pairs(beds.player) do
		c = c + 1
	end
	return c
end

local function update_formspecs(finished)
	local ges = #minetest.get_connected_players()
	local player_in_bed = get_player_in_bed_count()
	local is_majority = (ges / 2) < player_in_bed

	local form_n
	local esc = minetest.formspec_escape
	if finished then
		form_n = beds.formspec .. "label[2.7,9;" .. esc(S("Good morning.")) .. "]"
	else
		form_n = beds.formspec .. "label[2.2,9;" ..
			esc(S("@1 of @2 players are in bed", player_in_bed, ges)) .. "]"
		if is_majority and is_night_skip_enabled() then
			form_n = form_n .. "button[2,9.1;4,0.75;force;" ..
				esc(S("Force night skip")) .. "]"
		end
	end

	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if beds.player[name] then
			minetest.show_formspec(name, "beds_form", form_n)
		else
			minetest.close_formspec(name, "beds_form")
		end
	end
end

local function dtime_to_daynight_ratio(dtime)
	return (math.floor(dtime) + 0.5) / 1440
end

function beds.kick_players()
	for name, _ in pairs(beds.player) do
		local player = minetest.get_player_by_name(name)
		lay_down(player, nil, nil, false)
	end
end

function beds.skip_night()
	minetest.set_timeofday(0.23)
end

function beds.skip_day()
	minetest.set_timeofday(beds.day_interval.finish)
end

-- helper (award unlock)
local function ZA_unlock(player_name, award_id)
	if not player_name or not award_id then return end
	if awards and awards.unlock then
		awards.unlock(player_name, award_id)
	elseif awards and awards.give_achievement then
		awards.give_achievement(player_name, award_id)
	end
end

local function do_time_advance_for_current_period()
	if is_day() then
		beds.skip_day()
		for name, _ in pairs(beds.player) do
			ZA_unlock(name, "beds:sleep_day")
		end
	else
		beds.skip_night()
	end
end

function beds.on_rightclick(pos, player)
	local name = player:get_player_name()
	local ppos = player:get_pos()
	local tod = minetest.get_timeofday()
	-- daytime allowed: no guard

	-- move to bed
	if not beds.player[name] then
		lay_down(player, ppos, pos)
		beds.set_spawns() -- save respawn positions when entering bed
	else
		lay_down(player, nil, nil, false)
	end

	if not is_sp then
		update_formspecs(false)
	end

	-- skip time and let all players stand up
	if check_in_beds() then
		minetest.after(2, function()
			if not is_sp then
				update_formspecs(true)
			end
			do_time_advance_for_current_period()
			beds.kick_players()
		end)
	end
end

function beds.can_dig(bed_pos)
	-- Check all players in bed which one is at the expected position
	for _, player_bed_pos in pairs(beds.bed_position) do
		if vector.equals(bed_pos, player_bed_pos) then
			return false
		end
	end
	return true
end

-- Callbacks
-- Only register respawn callback if respawn enabled
if enable_respawn then
	-- respawn player at bed if enabled and valid position is found
	minetest.register_on_respawnplayer(function(player)
		local name = player:get_player_name()
		local pos = beds.spawn[name]
		if pos then
			player:set_pos(pos)
			return true
		end
	end)
end

-- Only react to digging beds; ignore all other nodes
minetest.register_on_dignode(function(pos, oldnode, digger)
	-- Guard: only handle nodes in the "bed" group
	if not oldnode or minetest.get_item_group(oldnode.name, "bed") ~= 1 then
		return
	end

	-- If the dug bed is the one the digger is lying in, force them out and clear state
	if digger and digger:is_player() then
		local name = digger:get_player_name()
		local bp = beds.bed_position[name]
		if bp then
			-- Compute the other half of the bed safely
			local param2 = (oldnode.param2 or 0)
			local dir = minetest.facedir_to_dir(param2)
			local other = vector.add(pos, dir)

			if vector.equals(pos, bp) or vector.equals(other, bp) then
				lay_down(digger, nil, nil, false, true)
				beds.player[name] = nil
				beds.bed_position[name] = nil
				update_formspecs(false)
			end
		end
	end

	-- Removing a bed should drop its spawnpoints
	beds.remove_spawns_at(pos)
end)


minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	lay_down(player, nil, nil, false, true)
	beds.player[name] = nil
	if check_in_beds() then
		minetest.after(2, function()
			update_formspecs(true)
			do_time_advance_for_current_period()
			beds.kick_players()
		end)
	end
end)

minetest.register_on_dieplayer(function(player)
	local name = player:get_player_name()
	local in_bed = beds.player
	local pos = player:get_pos()
	local yaw = get_look_yaw(pos)

	if in_bed[name] then
		lay_down(player, nil, pos, false)
		player:set_look_horizontal(yaw)
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "beds_form" then
		return
	end

	-- Because "Force night skip" button is a button_exit, it will set fields.quit
	-- and lay_down call will change value of player_in_bed, so it must be taken
	-- earlier.
	local last_player_in_bed = get_player_in_bed_count()

	if fields.quit or fields.leave then
		lay_down(player, nil, nil, false)
		update_formspecs(false)
	end

	if fields.force then
		local is_majority = (#minetest.get_connected_players() / 2) < last_player_in_bed
		if is_majority then
			update_formspecs(true)
			do_time_advance_for_current_period()
			beds.kick_players()
		else
			update_formspecs(false)
		end
	end
end)

-- Globalstep handle automatic skip night
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime_to_daynight_ratio(dtime)
	if timer < 0.5 then
		return
	end
	timer = 0

	local players = minetest.get_connected_players()
	local in_bed = beds.player
	if #players > 0 and check_in_beds(players) then
		if is_sp then
			beds.skip_night()
			beds.kick_players()
		else
			update_formspecs(is_night_skip_enabled())
		end
	end
end)

