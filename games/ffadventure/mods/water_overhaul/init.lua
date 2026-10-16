-- Water Overhaul init.lua
-- This mod overrides default water walking sounds with customizable options and tweaks visuals
local mod_name = minetest.get_current_modname()
local mod_storage = minetest.get_mod_storage()

-- Table to track last sound play time for each player
local player_sound_timers = {}
local player_in_water = {} -- Track if player was in water last check
local player_head_underwater = {} -- Track if player's head was underwater last check

-- Game detection and fog control
local current_game = minetest.get_game_info().id
local fog_blacklist = {
    ["mineclone2"] = true,
    ["mineclonia"] = true,
    ["mineclone5"] = true,
    ["nodecore"] = true,
}

-- Check if fog effects should be enabled for this game
local fog_enabled = not fog_blacklist[current_game]

-- Default configuration
local default_config = {
    -- Footstep sound settings
    step_sound = "water_step_global",
    step_interval = 4.35,
    step_interval_randomize = 0.3,
    step_gain = 0.2,
    
    -- Enter/exit water sound settings
    enter_water_sound = "splash_in",
    exit_water_sound = "splash_out",
    enter_exit_gain = 0.1,
    
    -- Bubble sound settings
    bubble_sound = "bubble",
    bubble_chance = 0.010,
    bubble_gain = 0.10,
    
    -- Underwater fog settings (set to nil/0 if fog disabled)
    underwater_fog_distance = fog_enabled and 80 or 0,
    underwater_fog_color_day = fog_enabled and "#4a9fd8" or "",
    underwater_fog_color_night = fog_enabled and "#1a2d3d" or "",
    underwater_brightness_reduction = fog_enabled and 0.6 or 0,
    
    -- Performance settings
    check_interval = 0.2,
    movement_threshold = 0.1,
}

-- Per-player configuration
local player_configs = {}

-- Load player configuration from storage
local function load_player_config(player_name)
    local stored = mod_storage:get_string("config_" .. player_name)
    if stored and stored ~= "" then
        local config = minetest.deserialize(stored)
        if config then
            return config
        end
    end
    -- Return a copy of default config
    local config = {}
    for k, v in pairs(default_config) do
        config[k] = v
    end
    return config
end

-- Save player configuration to storage
local function save_player_config(player_name, config)
    mod_storage:set_string("config_" .. player_name, minetest.serialize(config))
end

-- Get player's active config
local function get_player_config(player_name)
    if not player_configs[player_name] then
        player_configs[player_name] = load_player_config(player_name)
    end
    return player_configs[player_name]
end

-- Cache for water node groups (avoids repeated lookups)
local water_node_cache = {}

-- Function to check if a node is water (with caching)
-- Multi-game compatible: checks for water, liquid groups, and liquidtype
local function is_water_node(node_name)
    if water_node_cache[node_name] ~= nil then
        return water_node_cache[node_name]
    end
    
    local node_def = minetest.registered_nodes[node_name]
    local is_water = node_def and (
        (node_def.groups and (node_def.groups.water or node_def.groups.liquid)) or
        node_def.liquidtype == "source" or
        node_def.liquidtype == "flowing"
    )
    
    water_node_cache[node_name] = is_water or false
    return water_node_cache[node_name]
end

-- Function to get randomized interval
local function get_random_interval(config)
    local base = config.step_interval
    local variance = config.step_interval_randomize
    local randomized = base + (math.random() * variance * 2 - variance)
    return math.max(randomized, 0.1) -- Minimum 0.1 seconds to prevent spam
end

-- Function to interpolate between two colors based on a factor (0.0 to 1.0)
local function interpolate_color(color1, color2, factor)
    -- Parse hex colors
    local r1 = tonumber(color1:sub(2, 3), 16)
    local g1 = tonumber(color1:sub(4, 5), 16)
    local b1 = tonumber(color1:sub(6, 7), 16)
    
    local r2 = tonumber(color2:sub(2, 3), 16)
    local g2 = tonumber(color2:sub(4, 5), 16)
    local b2 = tonumber(color2:sub(6, 7), 16)
    
    -- Interpolate
    local r = math.floor(r1 + (r2 - r1) * factor)
    local g = math.floor(g1 + (g2 - g1) * factor)
    local b = math.floor(b1 + (b2 - b1) * factor)
    
    -- Return as hex color
    return string.format("#%02x%02x%02x", r, g, b)
end

-- Function to set underwater fog (only called if fog_enabled is true)
local function set_underwater_fog(player, config)
    if not player or not player:is_player() then
        return
    end
    
    -- Get current time of day and reduce brightness
    local time_of_day = minetest.get_timeofday()
    local current_brightness
    if time_of_day < 0.5 then
        current_brightness = time_of_day * 2
    else
        current_brightness = (1.0 - time_of_day) * 2
    end
    
    -- Interpolate fog color based on time of day
    local fog_color = interpolate_color(
        config.underwater_fog_color_night,
        config.underwater_fog_color_day,
        current_brightness
    )
    
    -- Set sky color to match fog color
    player:set_sky({
        base_color = fog_color,
        type = "plain",
        fog = {
            fog_distance = config.underwater_fog_distance,
            fog_color = fog_color,
        }
    })
    
    -- Hide sunrise when underwater (stops visual bug of able to see texture through fog, may need to apply similar to sun and moon)
    player:set_sun({
        sunrise_visible = false
    })
    
    -- Reduce brightness underwater
    local underwater_brightness = current_brightness * config.underwater_brightness_reduction
    player:override_day_night_ratio(underwater_brightness)
end

-- Function to restore default fog (only called if fog_enabled is true)
local function restore_default_fog(player)
    if not player or not player:is_player() then
        return
    end
    
    player:set_sky()
    player:set_sun()
    player:set_clouds()
    player:override_day_night_ratio(nil)
end

-- Custom water sound function
local function play_water_footstep(player)
    if not player or not player:is_player() then
        return
    end
    
    local player_name = player:get_player_name()
    local config = get_player_config(player_name)
    local current_time = minetest.get_us_time() / 1000000
    
    -- Early check: Get velocity first (cheapest operation)
    local vel = player:get_velocity()
    if not vel then
        return
    end
    
    local is_moving = math.abs(vel.x) >= config.movement_threshold or 
                     math.abs(vel.z) >= config.movement_threshold
    
    -- Get player position
    local pos = player:get_pos()
    
    -- Check the node at player's feet and head (for full submersion)
    local node_pos = {x = pos.x, y = pos.y, z = pos.z}
    local node = minetest.get_node(node_pos)
    
    -- Check head position for underwater fog (player eyes level)
    local head_pos = {x = pos.x, y = pos.y + 1.5, z = pos.z}
    local head_node = minetest.get_node(head_pos)
    
    -- Check if player is in water (using cached lookup)
    local in_water = is_water_node(node.name)
    local head_in_water = is_water_node(head_node.name)
    
    -- Handle enter/exit water sounds (based on feet position)
    local was_in_water = player_in_water[player_name]
    
    if in_water and not was_in_water then
        -- Player just entered water
        if config.enter_water_sound and config.enter_water_sound ~= "" then
            minetest.sound_play(config.enter_water_sound, {
                pos = pos,
                gain = config.enter_exit_gain,
                max_hear_distance = 16,
                object = player,
            }, true)
        end
        player_in_water[player_name] = true
    elseif not in_water and was_in_water then
        -- Player just exited water
        if config.exit_water_sound and config.exit_water_sound ~= "" then
            minetest.sound_play(config.exit_water_sound, {
                pos = pos,
                gain = config.enter_exit_gain,
                max_hear_distance = 16,
                object = player,
            }, true)
        end
        player_in_water[player_name] = false
    end
    
    -- Handle underwater fog effects (based on head position)
    -- Only apply fog if fog_enabled is true for this game
    if fog_enabled then
        local was_head_underwater = player_head_underwater[player_name]
        
        if head_in_water then
            -- Player's head is underwater - update fog continuously
            set_underwater_fog(player, config)
            if not was_head_underwater then
                player_head_underwater[player_name] = true
            end
        elseif was_head_underwater then
            -- Player's head just came above water
            restore_default_fog(player)
            player_head_underwater[player_name] = false
        end
    end
    
    -- Play bubble sounds when fully submerged and moving
    -- This works regardless of fog_enabled status
    if head_in_water and is_moving and config.bubble_sound and config.bubble_sound ~= "" then
        if math.random() < config.bubble_chance then
            minetest.sound_play(config.bubble_sound, {
                pos = pos,
                gain = config.bubble_gain,
                max_hear_distance = 12,
                object = player,
            }, true)
        end
    end
    
    -- Play footstep sounds only if in water, moving, and sound is enabled
    if in_water and is_moving and config.step_sound and config.step_sound ~= "" then
        -- Check if enough time has passed since last sound
        local last_play_time = player_sound_timers[player_name]
        if last_play_time then
            local time_since_last = current_time - last_play_time
            
            -- Check against the last interval (which may have been randomized)
            local last_interval = player_sound_timers[player_name .. "_interval"] or config.step_interval
            if time_since_last < last_interval then
                return
            end
        end
        
        -- Always play the custom water footstep sound when in water
        minetest.sound_play(config.step_sound, {
            pos = pos,
            gain = config.step_gain,
            max_hear_distance = 16,
            object = player,
        }, true)
        
        -- Update timer with new randomized interval
        player_sound_timers[player_name] = current_time
        player_sound_timers[player_name .. "_interval"] = get_random_interval(config)
    end
end

-- Accumulator for throttling globalstep execution
local check_accumulator = 0

-- Register globalstep to check for water walking
minetest.register_globalstep(function(dtime)
    check_accumulator = check_accumulator + dtime
    
    -- Only run checks at configured interval (reduces CPU usage)
    -- Use the check_interval from default_config since this is global
    if check_accumulator < default_config.check_interval then
        return
    end
    check_accumulator = 0
    
    -- Process all connected players
    for _, player in ipairs(minetest.get_connected_players()) do
        play_water_footstep(player)
    end
end)

-- Clean up timer when player leaves
minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    player_sound_timers[player_name] = nil
    player_sound_timers[player_name .. "_interval"] = nil
    player_in_water[player_name] = nil
    player_head_underwater[player_name] = nil
    player_configs[player_name] = nil
    
    -- Clean up fog if it was enabled
    if fog_enabled then
        restore_default_fog(player)
    end
end)

-- Initialize player water state when they join
minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    player_in_water[player_name] = false
    player_head_underwater[player_name] = false
end)

-- GUI Functions
local function show_config_gui(player)
    local player_name = player:get_player_name()
    local config = get_player_config(player_name)
    
    local formspec = "formspec_version[4]" ..
        "size[12,13]" ..
        "label[0.3,0.5;Water Overhaul Configuration]" ..
        
        -- Footstep Sounds Section
        "label[0.3,1.2;Footstep Sounds:]" ..
        "field[0.3,1.6;5.5,0.8;step_sound;Sound Name;" .. minetest.formspec_escape(config.step_sound) .. "]" ..
        "field[6.3,1.6;2.5,0.8;step_interval;Interval (s);" .. config.step_interval .. "]" ..
        "field[9.3,1.6;2.5,0.8;step_interval_randomize;Randomness;" .. config.step_interval_randomize .. "]" ..
        "field[0.3,2.8;2.5,0.8;step_gain;Volume (gain);" .. config.step_gain .. "]" ..
        
        -- Enter/Exit Sounds Section
        "label[0.3,4.2;Enter/Exit Water Sounds:]" ..
        "field[0.3,4.6;5.5,0.8;enter_water_sound;Enter Sound;" .. minetest.formspec_escape(config.enter_water_sound) .. "]" ..
        "field[6.3,4.6;5.5,0.8;exit_water_sound;Exit Sound;" .. minetest.formspec_escape(config.exit_water_sound) .. "]" ..
        "field[0.3,5.8;2.5,0.8;enter_exit_gain;Volume (gain);" .. config.enter_exit_gain .. "]" ..
        
        -- Bubble Sounds Section
        "label[0.3,7.2;Underwater Bubble Sounds:]" ..
        "field[0.3,7.6;5.5,0.8;bubble_sound;Bubble Sound;" .. minetest.formspec_escape(config.bubble_sound) .. "]" ..
        "field[6.3,7.6;2.5,0.8;bubble_chance;Chance (0-1);" .. config.bubble_chance .. "]" ..
        "field[9.3,7.6;2.5,0.8;bubble_gain;Volume (gain);" .. config.bubble_gain .. "]" ..
        
        -- Underwater Fog Section
        "label[0.3,9.0;Underwater Visual Effects:]" ..
        "field[0.3,9.4;2.5,0.8;underwater_fog_distance;Fog Distance;" .. config.underwater_fog_distance .. "]" ..
        "field[3.3,9.4;2.5,0.8;underwater_fog_color_day;Day Color;" .. minetest.formspec_escape(config.underwater_fog_color_day) .. "]" ..
        "field[6.3,9.4;2.5,0.8;underwater_fog_color_night;Night Color;" .. minetest.formspec_escape(config.underwater_fog_color_night) .. "]" ..
        "field[9.3,9.4;2.5,0.8;underwater_brightness_reduction;Brightness;" .. config.underwater_brightness_reduction .. "]" ..
        
        -- Performance Section
        "label[0.3,10.8;Performance Settings:]" ..
        "field[0.3,11.2;2.5,0.8;movement_threshold;Move Threshold;" .. config.movement_threshold .. "]" ..
        
        -- Buttons
        "button[0.3,11.8;2.5,0.8;save;Save]" ..
        "button[3.1,11.8;2.5,0.8;reset;Reset to Defaults]" ..
        "button[5.9,11.8;2.5,0.8;close;Close]" ..
        
        -- Help text
        "label[0.3,12.8;Tip: Leave sound fields empty to disable that sound type]"
    
    minetest.show_formspec(player_name, "water_sounds:config", formspec)
end

-- Handle formspec submissions
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "water_sounds:config" then
        return
    end
    
    local player_name = player:get_player_name()
    
    if fields.close then
        minetest.close_formspec(player_name, formname)
        return true
    end
    
    if fields.quit then
        return true
    end
    
    if fields.reset then
        -- Reset to defaults
        local config = {}
        for k, v in pairs(default_config) do
            config[k] = v
        end
        player_configs[player_name] = config
        save_player_config(player_name, config)
        minetest.chat_send_player(player_name, "Water configuration reset to defaults.")
        show_config_gui(player)
        return true
    end
    
    if fields.save then
        local config = get_player_config(player_name)
        
        -- Update string values
        if fields.step_sound then config.step_sound = fields.step_sound end
        if fields.enter_water_sound then config.enter_water_sound = fields.enter_water_sound end
        if fields.exit_water_sound then config.exit_water_sound = fields.exit_water_sound end
        if fields.bubble_sound then config.bubble_sound = fields.bubble_sound end
        if fields.underwater_fog_color_day then config.underwater_fog_color_day = fields.underwater_fog_color_day end
        if fields.underwater_fog_color_night then config.underwater_fog_color_night = fields.underwater_fog_color_night end
        
        -- Update numeric values
        if fields.step_interval then config.step_interval = tonumber(fields.step_interval) or config.step_interval end
        if fields.step_interval_randomize then config.step_interval_randomize = tonumber(fields.step_interval_randomize) or config.step_interval_randomize end
        if fields.step_gain then config.step_gain = tonumber(fields.step_gain) or config.step_gain end
        if fields.enter_exit_gain then config.enter_exit_gain = tonumber(fields.enter_exit_gain) or config.enter_exit_gain end
        if fields.bubble_chance then config.bubble_chance = tonumber(fields.bubble_chance) or config.bubble_chance end
        if fields.bubble_gain then config.bubble_gain = tonumber(fields.bubble_gain) or config.bubble_gain end
        if fields.underwater_fog_distance then config.underwater_fog_distance = tonumber(fields.underwater_fog_distance) or config.underwater_fog_distance end
        if fields.underwater_brightness_reduction then config.underwater_brightness_reduction = tonumber(fields.underwater_brightness_reduction) or config.underwater_brightness_reduction end
        if fields.movement_threshold then config.movement_threshold = tonumber(fields.movement_threshold) or config.movement_threshold end
        
        save_player_config(player_name, config)
        minetest.chat_send_player(player_name, "Water configuration saved!")
        show_config_gui(player)
        return true
    end
end)

-- Register chat command
minetest.register_chatcommand("setwater", {
    description = "Open water configuration GUI",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            show_config_gui(player)
            return true, "Opening water configuration..."
        else
            return false, "Player not found"
        end
    end,
})

-- Override water node sound definitions after all mods have loaded
-- This safely handles different games (Minetest Game, MineClone2, etc.)
minetest.register_on_mods_loaded(function()
    -- List of water nodes to override from various games
    local water_nodes = {
        -- Minetest Game
        "default:water_source",
        "default:water_flowing",
        "default:river_water_source",
        "default:river_water_flowing",
        -- MineClone2/Mineclonia
        "mcl_core:water_source",
        "mcl_core:water_flowing",
        "mcl_core:river_water_source",
        "mcl_core:river_water_flowing",
        --NodeCore
        "nc_terrain:water_source",
        "nc_terrain:water_flowing",
        "nc_terrain:river_water_source",
        "nc_terrain:river_water_flowing",
        "nc_terrain:water_gray_source",
        "nc_terrain:water_gray_flowing",
    }
    
    -- Only override nodes that actually exist
    local overridden_count = 0
    for _, node_name in ipairs(water_nodes) do
        if minetest.registered_nodes[node_name] then
            minetest.override_item(node_name, {
                sounds = {}
            })
            overridden_count = overridden_count + 1
        end
    end
end)