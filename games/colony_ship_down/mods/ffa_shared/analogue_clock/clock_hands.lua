-- Define the total number of animation frames for each clock hand (hour, minute, second)
local total_animation_frames = {
    hours   = 24,  -- 24 frames to represent the 12-hour cycle (2 frames per hour)
    minutes = 24,  -- 24 frames to represent the 60-minute cycle
    seconds = 24,  -- 24 frames to represent the 60-second cycle
}


--- Function to update or remove the clock hands at a specific position
-- This searches for the clock hand entities (hour, minute, second) at the given position
-- and either updates their sprite or removes them based on the 'method' parameter.
analogue_clock.update_clock_hands = function(pos, method)
    local meta      = core.get_meta(pos)
    local serialpos = meta:get_string("clock_hand_position")
    
    if serialpos and serialpos ~= "" then
        -- Deserialize the stored clock hand position:
        local hand_pos  = core.deserialize(serialpos)
        -- Valid clock hand entities to look for:
        local valid_ent = {
            ["analogue_clock:hour_hand"]   = true,
            ["analogue_clock:minute_hand"] = true,
            ["analogue_clock:second_hand"] = true
        }
        -- Search for entities at the specified position:
        local found_objects = core.get_objects_inside_radius(hand_pos, 0.02)
        
        -- Loop through found objects and update or destroy them:
        for _, obj in ipairs(found_objects) do
            if obj and not obj:is_player() then
                local entity = obj:get_luaentity()
                -- Check if the entity is a clock hand and perform the appropriate action:
                if entity and valid_ent[entity.name] and entity.update_sprite then
                        if     method == 'destroy' then  obj:remove()
                        elseif method == 'update'  then  entity:update_sprite()
                        end
                end
            end
        end
    end
end

-- - Clock hands for hours, minutes and seconds:
core.register_entity( "analogue_clock:hour_hand" , {
    initial_properties = {
        physical                = false,
        collide_with_objects    = false,
        collisionbox            = {-0.0, -0.0, -0.0, 0.0, 0.0, 0.0},
        visual                  = "upright_sprite",
        drawtype                = "front",
        visual_size             = {x=0.9, y=0.8},
        textures                = {"clock_hands.png", "clock_hands.png"},
        initial_sprite_basepos  = {x = 0, y = 0},
        spritediv               = {x = 1, y = 24},
    },
    -- Update the hour hand sprite based on the current game-time:
    update_sprite = function(self)
        local interval_in_s = analogue_clock.time.hours                 -- Animation speed for hour hand
        local total_frames  = total_animation_frames.hours
        local H, M, S       = analogue_clock.get_current_daytime()
        local current_frame = total_frames * (((H % 12) + M / 60) / 12) -- Frame is based on fractional hour
        -- Set the sprite to the calculated frame:
        self.object:set_sprite({x=0, y=current_frame}, total_frames, interval_in_s)
    end,
    on_activate = function(self)
        self:update_sprite()
    end,
})

core.register_entity( "analogue_clock:minute_hand", {
    initial_properties = {
        physical                = false,
        collide_with_objects    = false,
        collisionbox            = {-0.0, -0.0, -0.0, 0.0, 0.0, 0.0},
        visual                  = "upright_sprite",
        drawtype                = "front",
        visual_size             = {x=1, y=1},
        textures                = {"clock_hands.png", "clock_hands.png"},
        initial_sprite_basepos  = {x = 0, y = 0},
        spritediv               = {x = 1, y = 24},
    },
    update_sprite = function(self)
        local interval_in_s = 2.5*analogue_clock.time.minutes       -- 2.5 min per frame
        local total_frames  = total_animation_frames.minutes
        local H, M, S       = analogue_clock.get_current_daytime()
        local current_frame = math.floor(total_frames * (M / 60))   -- Calculate minute frame
        
        self.object:set_sprite({x=0, y=current_frame}, total_frames, interval_in_s)
    end,
    on_activate = function(self)
        self:update_sprite()
    end,
})

core.register_entity( "analogue_clock:second_hand", {
    initial_properties = {
        physical                = false,
        collide_with_objects    = false,
        collisionbox            = {-0.0, -0.0, -0.0, 0.0, 0.0, 0.0},
        visual                  = "upright_sprite",
        drawtype                = "front",
        visual_size             = {x=1, y=1},
        textures                = {"clock_hands.png", "clock_hands.png"},
        initial_sprite_basepos  = {x = 0, y = 0},
        spritediv               = {x = 1, y = 24},
    },
    update_sprite = function(self)
        local interval_in_s = 2.5*analogue_clock.time.seconds         -- Sync with minute hand cycle, each cycle of animation for the minutes is actually 2.5 minutes.
        local total_frames  = total_animation_frames.seconds
        local H, M, S       = analogue_clock.get_current_daytime()
        local current_frame = total_frames * S                        -- Calculate second frame
        
        self.object:set_sprite({x=0, y=current_frame}, total_frames, interval_in_s)
    end,
    on_activate = function(self)
        self:update_sprite()
    end,
})

