core.register_node("analogue_clock:antique_clock", {
    description = "Antique Clock",
    drawtype        = "mesh",
    mesh            = "antique_clock.obj",
    tiles           = {'clock_texture.png^[combine:64x64:32,32=clock_numbers.png'},
    palette         = "clock_palette.png",
    paramtype       = "light",
    paramtype2      = "colorfacedir",
    drop            = {items = { {items = {"analogue_clock:antique_clock"}, inherit_color = true } }},
    groups          = {flammable = 1, choppy = 1},
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local flhour = math.floor((core.get_timeofday()*24) % 12)
        -- Setting the time:
        core.env:get_node_timer(pos):start(1)
        meta:set_int("last_sync_time", flhour)
        
        -- Positioning the clock hands:
        local node = core.get_node(pos)
        local dir  = node.param2 % 32       -- Take the direction values in the param2
        
        local posh = pos
        local poss = pos
        
        local delm = {p = -0.47, m = 0.47}  -- Offset of minutes hand.
        local delh = -0.01                  -- Offset of hours   hand from the minutes.
        local dels =  0.01                  -- Offset of seconds hand from the minutes.
        local offset_m = {
            [0] = {x =      0, z = delm.p, r = 0            }, -- Facing -Z
            [1] = {x = delm.p, z =      0, r = math.rad(-90)}, -- Facing -X
            [2] = {x =      0, z = delm.m, r = math.rad(180)}, -- Facing +Z
            [3] = {x = delm.m, z =      0, r = math.rad(90) }, -- Facing +X
        }
        pos.x = pos.x + offset_m[dir].x
        pos.z = pos.z + offset_m[dir].z
        
        if offset_m[dir].x == 0 then
            posh.z = pos.z + delh
            poss.z = pos.z + dels
        else
            posh.x = pos.x + delh
            poss.x = pos.x + dels
        end
        
        local mins_hand = core.add_entity(pos , "analogue_clock:minute_hand")
        local hour_hand = core.add_entity(posh, "analogue_clock:hour_hand")
        
        -- Rotating the clock hand entities to face the correct direction:
        mins_hand:set_yaw(offset_m[dir].r)
        hour_hand:set_yaw(offset_m[dir].r)
        
        -- At default set_speed the seconds are too fast to be of any use:
        if analogue_clock.settings.display_seconds then
            local secnd_hand = core.add_entity(poss, "analogue_clock:second_hand")
            secnd_hand:set_yaw(offset_m[dir].r)
        end
        
         -- Saving the position in the metadata:
        meta:set_string("clock_hand_position", core.serialize(pos))
        
    end,
    
    on_timer = function (pos, elapsed)
		local meta          = core.get_meta(pos)
        local last_synctime = meta:get_int("last_sync_time") or -1
		local current_time  = core.get_timeofday()*24
        local floor_hours   = math.floor((core.get_timeofday()*24) % 12)
        
        -- Synch the clock hands with the correct time every hour:
        if last_synctime == -1 or floor_hours ~= last_synctime then
            analogue_clock.update_clock_hands(pos, 'update')
            meta:set_int("last_sync_time", floor_hours)
        end
		-- Play sound:
        if not analogue_clock.settings.silent_clocks then
            local H, M, S   = analogue_clock.get_current_daytime(meta)
            -- Play special tune at noon or midnight:
            if (H == 0 or H == 12 ) and M < 1 then 
                core.sound_play("westminster_cropped", {gain = 1, max_hear_distance = 25, loop = false})
            end
            --Ticking the clock
            core.sound_play("clock_tick" , {gain = 1, max_hear_distance = 10, loop = false})
        end
		return true
	end,
    
    on_destruct = function(pos)
        analogue_clock.update_clock_hands(pos, 'destroy')
    end,
    
})
