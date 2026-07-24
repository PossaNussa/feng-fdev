skygen.set_skybox = function(player, skybox)
    local name = player:get_player_name()
    skygen.write(name, "skybox", skybox)
    skygen.write(name, "sky_state", "skybox")
    local skybox_data = skygen.skyboxes[skybox]
    local skybox_textures = {}
    for i=1,6 do
        skybox_textures[i] = "skygen_" .. skybox .. i .. ".png"
    end
    player:set_sky({
        type = "skybox",
        base_color = skybox_data.color,
        textures = skybox_textures,
        clouds =  skybox_data.clouds,
    })
    if skybox_data.time ~= nil then
        local time = minetest.get_timeofday()
        if not (time < 0.22 or time > 0.78) then
            player:override_day_night_ratio(skybox_data.time / 12000)
        end
    end
    if skybox_data.change_sun == true then
        local sun_texture
        local sunrisebg_texture
        if (skybox_data.sun_texture == "default") or (skybox_data.sun_texture == nil) then
            sun_texture = "sun.png"
        else
            sun_texture = "skygen_" .. skybox .. "_sun.png"
        end
        if (skybox_data.sunrisebg_texture == "default") or (skybox_data.sunrisebg_texture == nil) then
            sunrisebg_texture = "sunrisebg.png"
        else
            sunrisebg_texture = "skygen_" .. skybox .. "_sunrisebg.png"
        end
        player:set_sun({
            texture = sun_texture,
            sunrise = sunrisebg_texture,
            sunrise_visible = skybox_data.sunrise_visible,
            scale = skybox_data.sun_scale,
        })
    elseif skybox_data.change_sun == "none" then
        player:set_sun({
            visible = false,
            sunrise_visible = false,
        })
    else
        player:set_sun()
    end
    -- moon/stars owned by astral mod
    player:set_clouds({density = 0})
end
