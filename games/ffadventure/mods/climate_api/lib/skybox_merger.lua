local mod_lighting_monoid = minetest.get_modpath("lighting_monoid") ~= nil

local default_sky = {
	sky_data = {
		base_color = nil,
		type = "regular",
		textures = nil,
		clouds = true,
		sky_color = {
			day_sky = "#8cbafa",
			day_horizon = "#9bc1f0",
			dawn_sky = "#b4bafa",
			dawn_horizon = "#bac1f0",
			night_sky = "#006aff",
			night_horizon = "#4090ff",
			indoors = "#646464",
			fog_tint_type = "default"
		}
	},
	cloud_data = {
		density = 0.4,
		color = "#fff0f0e5",
		ambient = "#000000",
		height = 120,
		thickness = 16,
		speed = {x=0, z=-2}
	},
	-- Textures are deliberately absent here. The astral mod owns the sun, moon and
	-- star textures -- blood moon, blue moon, super moon, solar eclipse -- and
	-- restating "sun.png" and "sun_tonemap.png" as a default erased whichever
	-- event was running the moment any weather layer changed. set_sun, set_moon
	-- and set_stars leave omitted fields at their current values
	-- (l_object.cpp:2332 reads getSunParams() before applying the table), so
	-- naming no texture means never touching astral's.
	--
	-- Visibility does have to be restated, though. deep_cave and nether hide the
	-- sun, moon and stars, and with no default to fall back to, removing those
	-- layers left them hidden: walking out of a deep cave used to leave you with
	-- no moon and no stars until astral's next day rollover happened to
	-- re-assert them. These cover exactly the fields those layers set, plus the
	-- sun scale that skygen varies.
	sun_data = {
		visible = true,
		sunrise_visible = true,
		scale = 1
	},
	moon_data = {
		visible = true
	},
	star_data = {
		visible = true
	},
}

local skybox = {}
local layers = {}

-- from https://stackoverflow.com/a/29133654
-- merges two tables together
-- if in conflict, b will override values of a
local function merge_tables(a, b)
	if type(a) == "table" and type(b) == "table" then
		for k,v in pairs(b) do
			if type(v)=="table" and type(a[k] or false)=="table" then
				merge_tables(a[k],v)
			else a[k]=v end
		end
	end
	return a
end

local function set_skybox(playername, sky)
	local player = minetest.get_player_by_name(playername)
	if player == nil or	not player.get_stars then return end
	player:set_sky(sky.sky_data)
	sky.cloud_data.density = 0
	player:set_clouds(sky.cloud_data)
	player:set_sun(sky.sun_data)
	-- Unconditional now that default_sky supplies visibility defaults: guarding
	-- these is what left the moon and stars stuck invisible after a deep_cave or
	-- nether layer was removed.
	player:set_moon(sky.moon_data)
	player:set_stars(sky.star_data)
end

function skybox.update(playername)
	local p_layers = layers[playername]
	local sky = table.copy(default_sky)
	if p_layers == nil then p_layers = {} end
	local numbered_layers = {}
	for layer, values in pairs(p_layers) do
		table.insert(numbered_layers, values)
	end
	table.sort(numbered_layers, function(left, right)
		if left.priority == nil then left.priority = 1 end
		if right.priority == nil then right.priority = 1 end
		return left.priority < right.priority
	end)
	for i = 1, #numbered_layers do
		sky = merge_tables(sky, numbered_layers[i])
	end
	set_skybox(playername, sky)
end

function skybox.add(playername, name, sky)
	if layers[playername] == nil then layers[playername] = {} end
	layers[playername][name] = sky
end

function skybox.remove(playername, name)
	if layers[playername] == nil or layers[playername][name] == nil then return end
	layers[playername][name] = nil
end

minetest.register_on_leaveplayer(function(player)
	local playername = player:get_player_name()
	layers[playername] = nil
end)

return skybox