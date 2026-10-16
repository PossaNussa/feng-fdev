analogue_clock = {}
analogue_clock.modpath  = minetest.get_modpath("analogue_clock")

-- Retrieve settings (default to false):
analogue_clock.settings = {
    silent_clocks   = core.settings:get_bool("clocks_are_silent"    , false),
    allow_debug     = core.settings:get_bool("clocks_in_debug_mode" , true),
    display_seconds = core.settings:get_bool("display_seconds"      , false),
}

-- - Synchronizing the time with the game:
--
local hrs_length    = math.floor(3600/core.settings:get('time_speed')) or 50 

analogue_clock.time = {
    hours   = hrs_length,
    minutes = hrs_length/60,
    seconds = hrs_length/3600,
}

-- - Palette of colors for each default wood type:
--
analogue_clock.wood_palette_map = {
    ["default:acacia_wood"] = 0,  -- Acacia tree wood is at index 0
    ["default:aspen_wood"]  = 1,  -- Aspen tree  wood is at index 1
    ["default:wood"]        = 2,  -- Apple tree  wood is at index 2
    ["default:junglewood"]  = 3,  -- Jungle tree wood is at index 3
    ["default:pine_wood"]   = 4,  -- Pine tree   wood is at index 4
}

-- - Function to get correct index for the wood:
--
analogue_clock.get_wood_palette_index = function(wood_name)
    return analogue_clock.wood_palette_map[wood_name] or 2
end


-- - Function to get hours, minutes and seconds at runtime, display as digital if in debug mode:
--
analogue_clock.get_current_daytime = function(meta)
    local Dh = core.get_timeofday() * 24
    local H  = math.floor(Dh)
    local Ms = (Dh - H) * 60
    local M  = math.floor(Ms)
    local S  = math.floor((Ms - M) * 60)
    -- Displaying:
    if meta and analogue_clock.settings.allow_debug then
        meta:set_string("infotext", string.format("%02d:%02d:%02d", H, M, S))
    end
    return H, M, S
end


-- - Recipe for each wod type in the palette (max of 8 values):
--
for wood_name, palette_index in pairs(analogue_clock.wood_palette_map) do
    core.register_craft({
        output = core.itemstring_with_palette("analogue_clock:antique_clock", palette_index*32),
        type = "shapeless",
        recipe = {
            wood_name,
            "default:steel_ingot",
        },
    })
end


-- Clock Node and Clock hand entites:
dofile(analogue_clock.modpath .. "/clock_hands.lua")
dofile(analogue_clock.modpath .. "/clock_node.lua")

