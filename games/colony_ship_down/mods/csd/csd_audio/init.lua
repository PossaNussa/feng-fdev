-- Soundtrack and ambience.
--
-- Music: original tracks (tools/make_music.py) picked by the mood of the room
-- you're in - lounges and the mess get the jazz, engineering gets the low
-- engine piece - with quiet gaps between tracks. It dips during malfunctions.
-- Ambience: a looping hum that changes with the room (reactor throb, vent
-- hiss, bridge chatter), and silence out in vacuum.
--
-- Players: /music <0-100|off>, /ambience <0-100|off>.

csd_audio = {}
local S = core.get_translator("csd_audio")

-- name -> length in seconds (from make_music.py's output)
csd_audio.tracks = {
	csd_music_lounge = {length = 170, moods = {chill = 3}},
	csd_music_nightshift = {length = 105, moods = {chill = 2, calm = 2}},
	csd_music_drift = {length = 122, moods = {calm = 3, chill = 1, work = 1}},
	csd_music_engine = {length = 150, moods = {work = 3}},
}

local MOOD_OF_KIND = {
	lounge = "chill", mess = "chill", recreation = "chill", arrivals = "chill", observation = "chill",
	cabin = "chill", cabins = "chill", vacant = "chill", theatre = "chill", galley = "chill", gym = "chill",
	reactor = "work", electrical = "work", workshop = "work", engine_control = "work", fuel = "work",
	cargo = "work", waste = "work", water = "work", life_support = "work", maintenance = "work",
}

local AMB_OF_KIND = {
	reactor = "csd_amb_reactor", engine_control = "csd_amb_reactor", electrical = "csd_amb_reactor",
	bridge = "csd_amb_bridge", navigation = "csd_amb_bridge", comms = "csd_amb_bridge",
	shields = "csd_amb_bridge", weapons = "csd_amb_bridge", security = "csd_amb_bridge",
	life_support = "csd_amb_vents", water = "csd_amb_vents", waste = "csd_amb_vents",
	maintenance = "csd_amb_vents", hydroponics = "csd_amb_vents", lift_lobby = "csd_amb_vents",
}

local MUSIC_GAIN = 0.35
local AMB_GAIN = 0.22

local state = {} -- name -> {music = handle, music_until, next_at, amb = handle, amb_name, ducked}

local function vol(player, key, default)
	local v = player:get_meta():get_string("csd_audio:" .. key)
	return v == "" and default or tonumber(v)
end

local function where(player)
	local pos = player:get_pos()
	if core.global_exists("csd_space") and csd_space.player_in_vacuum(player:get_player_name()) then
		return "space", nil
	end
	local r = core.global_exists("csd_ship") and csd_ship.room_at(pos)
	return r and r.kind or "corridor", r
end

local function pick_track(mood, previous)
	local pool, total = {}, 0
	for name, t in pairs(csd_audio.tracks) do
		local w = t.moods[mood] or 0
		if name == previous then w = w * 0.15 end
		if w > 0 then
			pool[#pool + 1] = {name, w}
			total = total + w
		end
	end
	table.sort(pool, function(a, b) return a[1] < b[1] end)
	local r = math.random() * total
	for _, e in ipairs(pool) do
		r = r - e[2]
		if r <= 0 then return e[1] end
	end
	return pool[1] and pool[1][1]
end

local function now() return core.get_us_time() / 1e6 end

local function update(player)
	local name = player:get_player_name()
	local st = state[name]
	if not st then return end
	local kind = where(player)
	local mood = MOOD_OF_KIND[kind] or "calm"

	-- Music
	local mv = vol(player, "music", 1)
	local alert = core.global_exists("csd_events") and csd_events.active and csd_events.active.def.countdown
	if st.music and now() > (st.music_until or 0) then
		st.music = nil
	end
	if not st.music and mv > 0 and now() >= (st.next_at or 0) then
		local track = pick_track(mood, st.last)
		if track then
			st.music = core.sound_play(track, {to_player = name, gain = MUSIC_GAIN * mv, fade = 0.1})
			st.music_until = now() + csd_audio.tracks[track].length
			st.next_at = st.music_until + 20 + math.random() * 40 -- a breather between tracks
			st.last = track
			st.ducked = false
		end
	end
	if st.music then
		local want_duck = alert and true or false
		if want_duck ~= st.ducked then
			st.ducked = want_duck
			core.sound_fade(st.music, 0.5, MUSIC_GAIN * mv * (want_duck and 0.25 or 1))
		end
	end

	-- Ambience
	local av = vol(player, "ambience", 1)
	local amb = (kind ~= "space" and av > 0) and (AMB_OF_KIND[kind] or "csd_amb_hull") or nil
	if amb ~= st.amb_name then
		if st.amb then core.sound_fade(st.amb, 0.6, 0) end
		st.amb, st.amb_name = nil, amb
		if amb then
			st.amb = core.sound_play(amb, {to_player = name, gain = 0.01, loop = true})
			core.sound_fade(st.amb, 0.3, AMB_GAIN * av)
		end
	end
end

core.register_on_joinplayer(function(player)
	-- First track after a short welcome pause.
	state[player:get_player_name()] = {next_at = now() + 8}
end)

core.register_on_leaveplayer(function(player)
	state[player:get_player_name()] = nil
end)

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 1 then return end
	timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		update(player)
	end
end)

local function volume_command(key, label)
	return {
		params = "<0-100|off>",
		description = S("Set your @1 volume", label),
		func = function(name, param)
			local player = core.get_player_by_name(name)
			if not player then return false end
			param = param:trim():lower()
			local v = (param == "off") and 0 or tonumber(param)
			if not v then
				return true, S("@1 volume: @2%", label, math.floor(vol(player, key, 1) * 100))
			end
			v = math.max(0, math.min(100, v)) / 100
			player:get_meta():set_string("csd_audio:" .. key, tostring(v))
			local st = state[name]
			if st then
				if key == "music" and st.music then
					core.sound_fade(st.music, 1, math.max(0.001, MUSIC_GAIN * v))
					if v == 0 then st.music = nil end
				elseif key == "ambience" and st.amb then
					core.sound_fade(st.amb, 1, AMB_GAIN * v)
					if v == 0 then st.amb, st.amb_name = nil, nil end
				end
			end
			return true, S("@1 volume set to @2%.", label, math.floor(v * 100))
		end,
	}
end
core.register_chatcommand("music", volume_command("music", S("Music")))
core.register_chatcommand("ambience", volume_command("ambience", S("Ambience")))

------------------------------------------------------------------------------
-- Little sound effects around the ship
------------------------------------------------------------------------------

function csd_audio.sfx(name, pos, gain)
	core.sound_play(name, {pos = pos, gain = gain or 0.6, max_hear_distance = 14}, true)
end

-- Gravity lift whoosh when you step into the field.
local in_lift = {}
local lift_timer = 0
core.register_globalstep(function(dtime)
	lift_timer = lift_timer + dtime
	if lift_timer < 0.3 then return end
	lift_timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		local node = core.get_node_or_nil(vector.round(vector.offset(player:get_pos(), 0, 0.5, 0)))
		local lift = node and node.name == "csd_ship:gravlift"
		if lift and not in_lift[name] then
			csd_audio.sfx("csd_sfx_lift", player:get_pos(), 0.5)
		end
		in_lift[name] = lift or nil
	end
end)

-- Wrap a node's on_rightclick to play a sound first.
local function with_sound(node, sound, gain)
	local def = core.registered_nodes[node]
	if not def or not def.on_rightclick then return end
	local old = def.on_rightclick
	core.override_item(node, {
		on_rightclick = function(pos, ...)
			csd_audio.sfx(sound, pos, gain)
			return old(pos, ...)
		end,
	})
end

core.register_on_mods_loaded(function()
	with_sound("csd_ship:crate", "csd_sfx_crate", 0.6)
	with_sound("csd_eva:suit_locker", "csd_sfx_locker", 0.6)
	for _, seat in ipairs({"csd_ship:bench", "csd_ship:sofa", "csd_ship:bunk"}) do
		with_sound(seat, "csd_sfx_sit", 0.5)
	end
	-- Suit seals hiss when you put a spacesuit piece on.
	if core.global_exists("armor") and armor.register_on_equip then
		armor:register_on_equip(function(player, _, stack)
			if core.get_item_group(stack:get_name(), "csd_spacesuit") > 0 then
				csd_audio.sfx("csd_sfx_suit", player:get_pos(), 0.5)
			end
		end)
	end
	-- Every task station blips when you open it.
	for name, def in pairs(core.registered_nodes) do
		if def.groups and def.groups.csd_station and def.on_rightclick and name:find("^csd_tasks:") then
			with_sound(name, "csd_sfx_console", 0.4)
		end
	end
end)
