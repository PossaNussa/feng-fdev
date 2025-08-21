-- engine const
local SUNLIGHT = 15

-- mod config
local night_light = 0  -- Set night_light to 0 for complete darkness
local dawn = ({0.1979, 0.2049, 0.2118, 0.2170, 0.2216, 0.2259, 0.2299, 0.2339, 0.2374, 0.2409, 0.2443, 0.2497, 0.25})[3]  -- Fixed index to avoid error
local dusk = ({0.7952, 0.7882, 0.7831, 0.7784, 0.7741, 0.7702, 0.7662, 0.7626, 0.7592, 0.7557, 0.7503, 0.7402, 0.74})[3]  -- Fixed index to avoid error

-- mod active values
local night_mode = false

local function set_night(player)
	player:override_day_night_ratio(night_light / SUNLIGHT)  -- This will be 0 / 15, effectively making it 0
end

local function unset_night(player)
	player:override_day_night_ratio(nil)
end

minetest.register_on_joinplayer(function(player)
	if night_mode then
		set_night(player)
	end
end)

minetest.register_globalstep(function()
	local time = minetest.get_timeofday()
	if time < dawn or time > dusk then
		if not night_mode then
			night_mode = true
			for _, player in ipairs(minetest.get_connected_players()) do
				set_night(player)
			end
		end
	elseif night_mode then
		night_mode = false
		for _, player in ipairs(minetest.get_connected_players()) do
			unset_night(player)
		end
	end
end)

-- brighter_lights/init.lua

-- Define a function to increase the brightness of light sources by 50%
local function increase_light_brightness()
    -- Loop through all registered nodes
    for name, def in pairs(minetest.registered_nodes) do
        -- Check if the node is a light source and its light level is greater than 0
        if def.light_source and def.light_source > 0 then
            -- Increase light brightness by 50%
            def.light_source = math.min(def.light_source * 1.5, 15)  -- Ensure max brightness is 15
        end
    end
end

-- Call the function to apply the changes
increase_light_brightness()

-- Add a simple on_load to ensure the mod runs when Minetest loads
minetest.register_on_mods_loaded(function()
    increase_light_brightness()
end)


