-- Water Overhaul (simple globalstep version)
-- this version of the code is a short clean implementation just altering water footstep sound interval. This is provided for creators in the scenario you would like to work off it to build your own logic.
--todo: add accumulator timers to reduce CPU overhead during globalstep (already done in main version)
local mod_name = minetest.get_current_modname()

-- Table to track last sound play time for each player
local player_sound_timers = {}

-- Configuration
local WATER_STEP_INTERVAL = 2.35 -- Time between footstep sounds (in seconds)
local WATER_STEP_GAIN = 0.2 -- Volume of water footstep sounds

-- Custom water sound function
local function play_water_footstep(player)
    if not player or not player:is_player() then
        return
    end
    
    local player_name = player:get_player_name()
    local current_time = minetest.get_us_time() / 1000000
    
    -- Check if enough time has passed since last sound
    if player_sound_timers[player_name] and 
       (current_time - player_sound_timers[player_name]) < WATER_STEP_INTERVAL then
        return
    end
    
    -- Get player position
    local pos = player:get_pos()
    
    -- Check if player is moving (has velocity)
    local vel = player:get_velocity()
    if not vel or (math.abs(vel.x) < 0.1 and math.abs(vel.z) < 0.1) then
        return -- Player is standing still
    end
    
    -- Check the node at player's feet
    local node_pos = {x = pos.x, y = pos.y, z = pos.z}
    local node = minetest.get_node(node_pos)
    local node_def = minetest.registered_nodes[node.name]
    
    -- Check if player is in water
    if node_def and node_def.groups and 
       (node_def.groups.water or node_def.liquidtype == "source" or 
        node_def.liquidtype == "flowing") then
        
        -- Play custom water sound
        minetest.sound_play("water_footstep", {
            pos = pos,
            gain = WATER_STEP_GAIN,
            max_hear_distance = 16,
            object = player,
        }, true)
        
        -- Update timer
        player_sound_timers[player_name] = current_time
    end
end

-- Register globalstep to check for water walking
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        play_water_footstep(player)
    end
end)

-- Clean up timer when player leaves
minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    player_sound_timers[player_name] = nil
end)

-- Override the default water node sound definitions after all mods have loaded
-- This completely removes footstep sounds from water nodes
minetest.register_on_mods_loaded(function()
    -- Get the current node definitions
-- Override water source
minetest.override_item("default:water_source", {
	sounds = {}
})

-- Override flowing water
minetest.override_item("default:water_flowing", {
	sounds = {}
})

-- Override river water source
minetest.override_item("default:river_water_source", {
	sounds = {}
})

-- Override flowing river water
minetest.override_item("default:river_water_flowing", {
	sounds = {}
})
    
    minetest.log("action", "[" .. mod_name .. "] Custom water sounds loaded and default footsteps disabled")
end)
