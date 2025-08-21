nebula_combat = {}

local player_info = {}
local config_cache_enabled = core.settings:get_bool("nebula_combat_config_cache_enabled", false)
local cached_config = nil

local function get_config()
    -- We might as well check if they enable the cache if it isn't already on, won't affect much
    -- but if they are having issues this could stop lag without a server restart
    if not config_cache_enabled then
        config_cache_enabled = core.settings:get_bool("nebula_combat_config_cache_enabled", false)
    end

    if config_cache_enabled and cached_config then
        return cached_config
    end

    cached_config = {
        -- Defaults must be put here due to the issue below
        -- https://github.com/minetest/minetest/issues/6711

        custom_knockback_enabled = core.settings:get_bool("nebula_combat_custom_knockback_enabled", false),
        custom_interact_distance_enabled = core.settings:get_bool("nebula_combat_custom_interact_distance_enabled", false),
        custom_attack_interval_enabled = core.settings:get_bool("nebula_combat_custom_attack_interval_enabled", false),

        -- Knockback - Horizontal
        horizontal_momentum = tonumber(core.settings:get("nebula_combat_horizontal_momentum") or 0.5),
        horizontal_force = tonumber(core.settings:get("nebula_combat_horizontal_force") or 8.0),

        -- Knockback - Horizontal - Sprinting
        horizontal_different_when_sprinting = core.settings:get_bool("nebula_combat_horizontal_different_when_sprinting", true),
        horizontal_momentum_sprinting = tonumber(core.settings:get("nebula_combat_horizontal_momentum_sprinting") or 0.5),
        horizontal_force_sprinting = tonumber(core.settings:get("nebula_combat_horizontal_force_sprinting") or 10.0),

        -- Knockback - Vertical
        vertical_momentum = tonumber(core.settings:get("nebula_combat_vertical_momentum") or 0.5),
        vertical_force = tonumber(core.settings:get("nebula_combat_vertical_force") or 6.0),

        -- Knockback - Vertical - Sprinting
        vertical_different_when_sprinting = core.settings:get_bool("nebula_combat_vertical_different_when_sprinting", false),
        vertical_momentum_sprinting = tonumber(core.settings:get("nebula_combat_vertical_momentum_sprinting") or 0.5),
        vertical_force_sprinting = tonumber(core.settings:get("nebula_combat_vertical_force_sprinting") or 6.0),

        -- Knockback - Physics
        physics_duration = tonumber(core.settings:get("nebula_combat_knockback_physics_duration") or 0.0),
        speed_mult = tonumber(core.settings:get("nebula_combat_knockback_speed_mult") or 1.0),
        gravity_mult = tonumber(core.settings:get("nebula_combat_knockback_gravity_mult") or 1.0),
        air_accel_mult = tonumber(core.settings:get("nebula_combat_knockback_air_accel_mult") or 1.0),

        -- Misc
        use_player_monoids_for_physics = core.settings:get_bool("nebula_combat_use_player_monoids_for_physics", false),
        use_pova_for_physics = core.settings:get_bool("nebula_combat_use_pova_for_physics", false),
        interact_distance = tonumber(core.settings:get("nebula_combat_interact_distance") or 3.0),
        attack_interval_multiplier = tonumber(core.settings:get("nebula_combat_attack_interval_multiplier") or 1.0),
        attack_interval = tonumber(core.settings:get("nebula_combat_attack_interval") or 0.5),
        damage_multiplier = tonumber(core.settings:get("nebula_combat_damage_multiplier") or 1.0),
        full_attack_only = core.settings:get_bool("nebula_combat_full_attack_only", false)
    }

    return cached_config
end

-- Checks if a player is sprinting
function nebula_combat.is_sprinting(player)
    -- This checks if any mods claim the player is sprinting

    -- Some sprint mods allow sprinting while standing still, which shouldn't be the case
    -- We could also verify that they are moving forwards but we don't incase sideways/backwards sprint is desired
    -- If that's not the case, that should be fixed in the sprint mod
    local control = player:get_player_control()
    if control.movement_x and control.movement_x == 0 and control.movement_y == 0 then
        return false
    elseif ((not control.up and not control.down) or (control.up and control.down))
        and ((not control.left and not control.right) or (control.left and control.right)) then
        -- movement_x/y is new (5.10) so we have this fallback
        return false
    end

    -- For Stamina (Fork), not regular Stamina
    if stamina and stamina.players then
        if stamina.players[player:get_player_name()].sprint then
            return true
        end
    end

    if minetest_wadsprint then
        local stats = minetest_wadsprint.api.stats(player:get_player_name())
        if stats.is_sprinting then
            return true
        end
    end

    if player:get_meta():get_int("real_stamina:sprinting") == 1 then
        return true
    end

    -- Covers mods that don't have a direct way to query sprinting, but also falls back to false
    return player_info[player:get_player_name()].sprinting
end


-- Sets a player to sprinting (or not sprinting)
-- ID might be used in the future to support multiple sprint mods at once, so they don't conflict
function nebula_combat.set_sprinting(player, sprinting, id)
    player_info[player:get_player_name()].sprinting = sprinting
end

-- Allows custom knockback from other mods
local registered_on_knockback = {}
function nebula_combat.register_on_knockback(cb)
	table.insert(registered_on_knockback, cb)
end

-- Stamina doesn't have an api to check if a player is sprinting, but it has a callback for it
-- The stamina.players check is for Stamina (Fork)
if stamina and not stamina.players then
    stamina.register_on_sprinting(function(player, sprinting)
        nebula_combat.set_sprinting(player, sprinting, "stamina")
    end)
end


-- For mods that use player_monoids and don't have a way to check sprinting
if player_monoids then
    local orig_monoids_speed_add_change = player_monoids.speed.add_change
    function player_monoids.speed.add_change(monoid, player, value, id)
        if id == "hbsprint:speed" then
            nebula_combat.set_sprinting(player, true, "hbsprint")
        elseif id == "sprint_lite_sprinting" then
            nebula_combat.set_sprinting(player, true, "sprint_lite")
        end
        return orig_monoids_speed_add_change(monoid, player, value, id)
    end

    local orig_monoids_speed_del_change = player_monoids.speed.del_change
    function player_monoids.speed.del_change(monoid, player, id)
        if id == "hbsprint:speed" then
            nebula_combat.set_sprinting(player, false, "hbsprint")
        elseif id == "sprint_lite_sprinting" then
            nebula_combat.set_sprinting(player, false, "sprint_lite")
        end
        return orig_monoids_speed_del_change(monoid, player, id)
    end
end

core.register_on_joinplayer(function(player, last_login)
    player_info[player:get_player_name()] = {
        sprinting = false,
        physics_applied = 0
    }
end)


core.register_on_leaveplayer(function(player, timed_out)
    player_info[player:get_player_name()] = nil
end)


-- Replaces the built-in knockback
local orig_calculate_knockback = core.calculate_knockback
function core.calculate_knockback(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
    if damage == 0 or player:get_armor_groups().immortal then return 0 end

    local config = get_config()

    if config.full_attack_only then
        if time_from_last_punch < tool_capabilities.full_punch_interval then
            return 0
        end
    end

    local horizontal_momentum = 1.0
    local horizontal_force = 0.0
    local vertical_momentum = 1.0
    local vertical_force = 0.0
    local physics_duration = config.physics_duration
    local speed_mult = config.speed_mult
    local gravity_mult = config.gravity_mult
    local air_accel_mult = config.air_accel_mult

    if config.custom_knockback_enabled then
        if config.horizontal_different_when_sprinting and nebula_combat.is_sprinting(hitter) then
            horizontal_momentum = config.horizontal_momentum_sprinting
            horizontal_force = config.horizontal_force_sprinting
        else
            horizontal_momentum = config.horizontal_momentum
            horizontal_force = config.horizontal_force
        end

        if config.vertical_different_when_sprinting and nebula_combat.is_sprinting(hitter) then
            vertical_momentum = config.vertical_momentum_sprinting
            vertical_force = config.vertical_force_sprinting
        else
            vertical_momentum = config.vertical_momentum
            vertical_force = config.vertical_force
        end
    end

    for _, cb in ipairs(registered_on_knockback) do
        local value = cb(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
        if value then
            horizontal_momentum = value.horizontal_momentum or horizontal_momentum
            horizontal_force = value.horizontal_force or horizontal_force
            vertical_momentum = value.vertical_momentum or vertical_momentum
            vertical_force = value.vertical_force or vertical_force
            physics_duration = value.physics_duration or physics_duration
            speed_mult = value.speed_mult or speed_mult
            gravity_mult = value.gravity_mult or gravity_mult
            air_accel_mult = value.air_accel_mult or air_accel_mult
        end
    end

    if physics_duration > 0 and (speed_mult ~= 1 or gravity_mult ~= 1 or air_accel_mult ~= 1) then
        player_info[player:get_player_name()].physics_applied = player_info[player:get_player_name()].physics_applied + 1
        if playerphysics then
            playerphysics.add_physics_factor(player, "speed", "nebula_combat:knockback_physics", speed_mult)
            playerphysics.add_physics_factor(player, "gravity", "nebula_combat:knockback_physics", gravity_mult)
            playerphysics.add_physics_factor(player, "acceleration_air", "nebula_combat:knockback_physics", air_accel_mult)

            core.after(physics_duration, function()
                if player:is_valid() then
                    player_info[player:get_player_name()].physics_applied = player_info[player:get_player_name()].physics_applied - 1
                    if player_info[player:get_player_name()].physics_applied == 0 then
                        playerphysics.remove_physics_factor(player, "speed", "nebula_combat:knockback_physics")
                        playerphysics.remove_physics_factor(player, "gravity", "nebula_combat:knockback_physics")
                        playerphysics.remove_physics_factor(player, "acceleration_air", "nebula_combat:knockback_physics")
                    end
                end
            end)
        elseif pova and config.use_pova_for_physics then
            pova.add_override(name, "nebula_combat:knockback_physics", {
                speed = speed_mult,
                gravity = gravity_mult,
                acceleration_air = air_accel_mult -- Doesn't support air accel but left here incase a future version does
            })
            pova.do_override(player)

            core.after(physics_duration, function()
                if player:is_valid() then
                    player_info[player:get_player_name()].physics_applied = player_info[player:get_player_name()].physics_applied - 1
                    if player_info[player:get_player_name()].physics_applied == 0 then
                        pova.del_override(name, "nebula_combat:knockback_physics")
                        pova.do_override(player)
                    end
                end
            end)
        elseif player_monoids and config.use_player_monoids_for_physics then
            player_monoids.speed:add_change(player, speed_mult, "nebula_combat:knockback_physics")
            player_monoids.gravity:add_change(player, gravity_mult, "nebula_combat:knockback_physics")

            core.after(physics_duration, function()
                if player:is_valid() then
                    player_info[player:get_player_name()].physics_applied = player_info[player:get_player_name()].physics_applied - 1
                    if player_info[player:get_player_name()].physics_applied == 0 then
                        player_monoids.speed:del_change(player, "nebula_combat:knockback_physics")
                        player_monoids.gravity:del_change(player, "nebula_combat:knockback_physics")
                    end
                end
            end)
        else
            local orig_physics = player:get_physics_override()
            player:set_physics_override({
                speed = orig_physics.speed * speed_mult,
                gravity = orig_physics.gravity * gravity_mult,
                acceleration_air = orig_physics.acceleration_air * air_accel_mult
            })

            core.after(physics_duration, function()
                if player:is_valid() then
                    player_info[player:get_player_name()].physics_applied = player_info[player:get_player_name()].physics_applied - 1
                    if player_info[player:get_player_name()].physics_applied == 0 then
                        -- We don't just set it to the old table since it may have changed during the duration time
                        orig_physics = player:get_physics_override()
                        if speed_mult == 0 or gravity_mult == 0 or air_accel_mult == 0 then
                            -- More of a work-around than a fix, but not much we can do
                            player:set_physics_override({
                                speed = 1,
                                gravity = 1,
                                acceleration_air = 1
                            })
                        else
                            player:set_physics_override({
                                speed = orig_physics.speed / speed_mult,
                                gravity = orig_physics.gravity / gravity_mult,
                                acceleration_air = orig_physics.acceleration_air / air_accel_mult
                            })
                        end
                    end
                end
            end)
        end
    end

    if horizontal_momentum == 1.0 and horizontal_force == 0.0
        and vertical_momentum == 1.0 and vertical_force == 0.0 then
        if config.custom_knockback_enabled then
            return 0
        else
            return orig_calculate_knockback(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
        end
    end

    local dist_x = -(dir.x * distance)
    local dist_z = -(dir.z * distance)
    local dist_horizontal = math.sqrt(dist_x * dist_x + dist_z * dist_z) -- The argument-provided distance includes the vertical axis
    local velo = player:get_velocity()

    velo.x = velo.x * horizontal_momentum
    velo.x = velo.x - (dist_x / dist_horizontal * horizontal_force)

    velo.z = velo.z * horizontal_momentum
    velo.z = velo.z - (dist_z / dist_horizontal * horizontal_force)

    velo.y = (velo.y * vertical_momentum) + vertical_force

    player:add_velocity(-player:get_velocity() + velo)
    return 0
end

local config = get_config()

if config.full_attack_only then
    core.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
        -- The time_from_last_punch resets even if they can't hit yet, but we can't do anything about that
        -- since even if we don't cancel the hit, the damage wouldn't be correct

        if time_from_last_punch < tool_capabilities.full_punch_interval then
            return true
        end
    end)
end

if config.custom_interact_distance_enabled then
    -- Overrides the hand to change the attack distance
    core.override_item("", {
        range = config.interact_distance
    })
end

if config.custom_attack_interval_enabled or (not config.custom_attack_interval_enabled and config.attack_interval_multiplier ~= 1.0) or config.damage_multiplier ~= 1.0 then
    core.register_on_mods_loaded(function()
        for item_name, item_def in pairs(core.registered_items) do
            -- Items that don't have tool_capabilities will be covered by the hand, which is in the registered_items list
            if item_def.tool_capabilities then
                local override_def = {
                    tool_capabilities = table.copy(item_def.tool_capabilities)
                }

                if config.custom_attack_interval_enabled then
                    -- Constant attack interval
                    -- Scale the damage
                    if override_def.tool_capabilities.damage_groups then
                        for k, v in pairs(override_def.tool_capabilities.damage_groups) do
                            -- We might need to save the hand full punch interval for items that dont explicitly set one
                            -- Although, it hasn't caused an issue yet
                            override_def.tool_capabilities.damage_groups[k] = v * (config.attack_interval / override_def.tool_capabilities.full_punch_interval)
                        end
                    end
                    
                    -- Change the attack interval
                    override_def.tool_capabilities.full_punch_interval = config.attack_interval
                elseif config.attack_interval_multiplier ~= 1.0 then
                    -- Attack interval multiplier
                    -- Scale the damage
                    if override_def.tool_capabilities.damage_groups then
                        for k, v in pairs(override_def.tool_capabilities.damage_groups) do
                            override_def.tool_capabilities.damage_groups[k] = v * config.attack_interval_multiplier
                        end
                    end
                    
                    -- Change the attack interval
                    override_def.tool_capabilities.full_punch_interval = override_def.tool_capabilities.full_punch_interval * config.attack_interval_multiplier
                end

                if config.damage_multiplier ~= 1.0 then
                    if override_def.tool_capabilities.damage_groups then
                        for k, v in pairs(override_def.tool_capabilities.damage_groups) do
                            override_def.tool_capabilities.damage_groups[k] = v * config.damage_multiplier
                        end
                    end
                end

                -- Update the item
                core.override_item(item_name, override_def)
            end
        end
    end)
end
