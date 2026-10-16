-- skygen's per-biome sky, pushed as a climate_api layer instead of by calling
-- player:set_sky directly.
--
-- Three things write the player's sky in this game: skygen (biome colours),
-- regional_weather (rain, fog, sandstorm, deep_cave) and nether. climate_api's
-- skybox merger exists to arbitrate exactly that, priority-ordered, and nether
-- already goes through it. skygen calling set_sky from its own globalstep meant
-- whichever ran last won, so walking between biomes during rain flickered the
-- weather sky back off again.
--
-- Priority 0 puts the biome sky below every weather layer (ambient 10, rain and
-- snow 11, fog 50, sandstorm 60, deep_cave 100) and below nether's default of 1.
-- That is the right place for it: it is the base the others tint.
--
-- The sun *texture* is never set here. astral owns it -- solar eclipse, blood
-- moon, blue moon, super moon -- and skygen restating "sun.png" on every biome
-- change was wiping those events out. Only the scale is skygen's, and only when
-- its `scaling` option is on.
local LAYER = "skygen:biome"
local LAYER_PRIORITY = 0

-- One layer table per player, mutated in place: set_biome_sky supplies colours
-- and scale, set_sky_colors supplies colours alone, and apply_transition_step
-- animates the scale. skybox.add replaces a whole layer rather than merging into
-- it, so without this the transition would drop the colours and vice versa.
local layer_cache = {}

local function layer_for(name)
    local layer = layer_cache[name]
    if not layer then
        layer = {
            priority = LAYER_PRIORITY,
            sky_data = { type = "regular" },
        }
        layer_cache[name] = layer
    end
    return layer
end

local function push(player, layer)
    local name = player:get_player_name()
    if minetest.global_exists("climate_api") and climate_api.skybox then
        climate_api.skybox.add(name, LAYER, layer)
        climate_api.skybox.update(name)
        return
    end
    -- No climate_api. Apply directly, as before -- minus the sun texture and the
    -- redundant set_clouds({density = 0}); cloudcraft turns engine clouds off on
    -- join and the merger forces density 0 itself.
    player:set_sky(layer.sky_data)
    if layer.sun_data then
        player:set_sun(layer.sun_data)
    end
end

minetest.register_on_leaveplayer(function(player)
    layer_cache[player:get_player_name()] = nil
end)

--- Drop skygen's contribution entirely, so weather and nether are left to it.
function skygen.clear_sky_layer(name)
    layer_cache[name] = nil
    if minetest.global_exists("climate_api") and climate_api.skybox then
        climate_api.skybox.remove(name, LAYER)
        climate_api.skybox.update(name)
    end
end

local function sky_color_for(biome_name)
    local base_values = skygen.biomes[biome_name].colors
    if skygen.storage:get_string("event") ~= "none" then
        base_values = skygen.biomes[biome_name].event_colors
    end
    return {
        day_sky         = base_values.day,
        day_horizon     = base_values.day_horizon,
        dawn_sky        = base_values.dawn,
        dawn_horizon    = base_values.dawn_horizon,
        night_sky       = base_values.night,
        night_horizon   = base_values.night_horizon,
        indoors         = base_values.indoors,
        fog_sun_tint    = base_values.sun_tint,
        fog_moon_tint   = base_values.moon_tint,
        fog_tint_type   = "custom"
    }
end

-- nil when skygen's scaling option is off, in which case the sun is left alone
-- and the merger's default scale of 1 applies.
local function sun_scale_from_heat(heat)
    return ((heat / 100) + 0.1) * 2
end

function skygen.set_biome_sky(player, biome_name)
    local name = player:get_player_name()
    local layer = layer_for(name)
    layer.sky_data.sky_color = sky_color_for(biome_name)

    if skygen.read(name, "scaling") == "true" then
        local heat = skygen.get_heat_humidity(biome_name)
        layer.sun_data = { scale = sun_scale_from_heat(heat) }
    else
        layer.sun_data = nil
    end

    push(player, layer)
end

function skygen.set_sky_colors(player, biome_name)
    local layer = layer_for(player:get_player_name())
    layer.sky_data.sky_color = sky_color_for(biome_name)
    push(player, layer)
end

function skygen.init_transition(player, prev_biome_name, biome_name)
    local name = player:get_player_name()
    skygen.write(name, "sky_state", "transition")

    local base_data = {}
    local diff_data = {}

    if skygen.storage:get_string("event") == "none" then
        base_data.sun_tint = skygen.biomes[prev_biome_name].colors.sun_tint
        base_data.moon_tint = skygen.biomes[prev_biome_name].colors.moon_tint
    else
        base_data.sun_tint = skygen.biomes[prev_biome_name].event_colors.sun_tint
        base_data.moon_tint = skygen.biomes[prev_biome_name].event_colors.moon_tint
    end

    base_data.heat, base_data.humidity = skygen.get_heat_humidity(prev_biome_name)
    diff_data.sun_tint, diff_data.moon_tint = skygen.get_color_diffs(prev_biome_name, biome_name)
    diff_data.heat, diff_data.humidity = skygen.get_param_diffs(prev_biome_name, biome_name)

    local transition_start = 0
    skygen.loop_transition(player, base_data, diff_data, biome_name, transition_start)
end

function skygen.loop_transition(player, base_data, diff_data, biome, step)
    if step > skygen.biome_transition_frames then
        skygen.write(player:get_player_name(), "sky_state", "biome")
        skygen.active_biome[player:get_player_name()] = biome
    else
        step = step + 1
        minetest.after(1 / skygen.biome_transition_frames, function()
            skygen.apply_transition_step(player, step, base_data, diff_data)
            skygen.loop_transition(player, base_data, diff_data, biome, step)
        end)
    end
end

-- Animates the sun scale across a biome change. Note this has never animated the
-- sky colours -- set_sky_colors applies those in one step before the transition
-- starts -- so the interpolated tints computed by get_color_diffs feed nothing.
-- Left as-is rather than "fixed": applying them would change how biome
-- transitions look, which is not what this change is for.
function skygen.apply_transition_step(player, step, base_data, diff_data)
    local name = player:get_player_name()
    if skygen.read(name, "scaling") ~= "true" then return end

    local heat = base_data.heat + (diff_data.heat * step)
    local layer = layer_for(name)
    layer.sun_data = { scale = sun_scale_from_heat(heat) }
    push(player, layer)
end

function skygen.get_param_diffs(prev_biome_name, biome_name)
    local prev_heat,prev_humidity = skygen.get_heat_humidity(prev_biome_name)
    local heat,humidity = skygen.get_heat_humidity(biome_name)
    local results = {}
    results.heat = (heat - prev_heat) / skygen.biome_transition_frames
    results.humidity = (humidity - prev_humidity) / skygen.biome_transition_frames
    return results.heat, results.humidity
end

function skygen.get_color_diffs(prev_biome_name, biome_name)
    local prev_colorset = {}
    local colorset = {}
    local result = {}
    if skygen.storage:get_string("event") == "none" then
        prev_colorset.sun_tint = skygen.biomes[prev_biome_name].colors.sun_tint
        prev_colorset.moon_tint = skygen.biomes[prev_biome_name].colors.moon_tint
        colorset.sun_tint = skygen.biomes[biome_name].colors.sun_tint
        colorset.moon_tint = skygen.biomes[biome_name].colors.moon_tint
    else
        prev_colorset.sun_tint = skygen.biomes[prev_biome_name].event_colors.sun_tint
        prev_colorset.moon_tint = skygen.biomes[prev_biome_name].event_colors.moon_tint
        colorset.sun_tint = skygen.biomes[biome_name].event_colors.sun_tint
        colorset.moon_tint = skygen.biomes[biome_name].event_colors.moon_tint
    end
    result.sun_tint = {
        r = (colorset.sun_tint.r - prev_colorset.sun_tint.r) / skygen.biome_transition_frames,
        g = (colorset.sun_tint.g - prev_colorset.sun_tint.g) / skygen.biome_transition_frames,
        b = (colorset.sun_tint.b - prev_colorset.sun_tint.b) / skygen.biome_transition_frames
    }
    result.moon_tint = {
        r = (colorset.moon_tint.r - prev_colorset.moon_tint.r) / skygen.biome_transition_frames,
        g = (colorset.moon_tint.g - prev_colorset.moon_tint.g) / skygen.biome_transition_frames,
        b = (colorset.moon_tint.b - prev_colorset.moon_tint.b) / skygen.biome_transition_frames
    }
    return result.sun_tint, result.moon_tint
end
