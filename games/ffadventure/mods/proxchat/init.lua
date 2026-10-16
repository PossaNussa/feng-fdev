local MODNAME = minetest.get_current_modname()

-- Public API, so mobs (villagers, pigmen) can speak into proximity chat and be
-- counted as listeners. Everything else stays module-local.
proxchat = {}

-- Setting defaults
local defaults = {
    distance = 32,
    show_distance = false,
    global_privs = "shout",
    player_config = false,
}

-- Get setting or default
local function setting(key)
    local s, d = minetest.settings:get(MODNAME .. "." .. key), defaults[key]
    -- "Cast" the value because settings:get() always returns a string
    return ({string = tostring, number = tonumber, boolean = minetest.is_yes})[type(d)](s or d)
end

-- Get player-configured distance
local function player_config_dist(name)
    return minetest.get_player_by_name(name):get_meta():get_int(MODNAME .. ":chat_distance")
end

-- The radius a message from `sender` carries. Depends on the sender and the
-- message (shouting and exclamation reach further), not on the recipient, so it
-- is the same for everyone and computed once.
local function hearing_distance(sender, msg)
    local config_dist = player_config_dist(sender)
    local max_dist = (setting("player_config") and config_dist > 0 and config_dist)
            or tonumber(setting("distance"))
    if msg:gsub("[^A-Z]", ""):len() > msg:gsub("[^a-zA-Z]", ""):len() then
        max_dist = max_dist * 2
    end
    return max_dist + 2 * msg:gsub("[^!]", ""):len()
end

-- Per-recipient message filters: fn(from, to_name, msg, dist) -> msg or nil
-- (nil = don't deliver). Lets other mods garble, translate or block lines.
proxchat.message_filters = {}

function proxchat.register_message_filter(fn)
    proxchat.message_filters[#proxchat.message_filters + 1] = fn
end

-- Send one line to every player within `max_dist` of `pos`. Returns how many
-- players received it. `from` is the speaker label (a player or a villager).
-- Player lines go through minetest.format_chat_message so chat-format mods
-- (rank/job tags) still apply.
local function deliver(pos, from, msg, max_dist, from_player)
    local count = 0
    for _, player in ipairs(minetest.get_connected_players()) do
        local dist = vector.distance(pos, player:get_pos())
        if dist <= max_dist then
            local to = player:get_player_name()
            local line = msg
            for _, fn in ipairs(proxchat.message_filters) do
                if line then line = fn(from, to, line, dist) end
            end
            if line then
                local show_dist = setting("show_distance") and ("(%sm) "):format(math.floor(dist)) or ""
                local text = from_player and minetest.format_chat_message(from, line)
                    or ("<%s> %s"):format(from, line)
                minetest.chat_send_player(to, show_dist .. text)
                count = count + 1
            end
        end
    end
    return count
end

-- Non-player listeners. A mob mod registers a check answering "is one of my
-- mobs in earshot of this position?", so a player standing among a talkative
-- crowd of villagers is not told they are all alone.
proxchat.listener_checks = {}

function proxchat.register_listener_check(fn)
    proxchat.listener_checks[#proxchat.listener_checks + 1] = fn
end

local function npc_in_range(pos, max_dist)
    for _, fn in ipairs(proxchat.listener_checks) do
        if fn(pos, max_dist) then return true end
    end
    return false
end

-- Make a position speak into proximity chat, heard by nearby players. Used for
-- ambient villager gossip. Returns how many players heard it.
function proxchat.speak(pos, from, msg)
    if not pos or not from or not msg then return 0 end
    return deliver(pos, from, msg, tonumber(setting("distance")))
end

-- Intercept chat messages and send to players in range (including self)
minetest.register_on_chat_message(function(name, msg)
    local player = minetest.get_player_by_name(name)
    if not player then return end
    local pos = player:get_pos()
    local max_dist = hearing_distance(name, msg)

    -- deliver counts the speaker too, so one recipient means only the speaker
    -- heard it. They are "alone" only if no other player and no nearby villager
    -- or pigman heard them either.
    local heard = deliver(pos, name, msg, max_dist, true)
    if heard <= 1 and not npc_in_range(pos, max_dist) then
        minetest.chat_send_player(name, "Nobody can hear you. You are all alone.")
    end

    return true
end)

-- Global chat
minetest.register_chatcommand("global", {
    func = function(name, msg)
        -- Require these privileges if defined
        local can_use, missing = minetest.check_player_privs(name, unpack(setting("global_privs"):split("[, ]", false, -1, true)))
        if can_use then
            if msg ~= "" then
                minetest.chat_send_all(("(Global) <%s> %s"):format(name, msg))
            else
                return false, "Cannot send empty message."
            end
        else
            return false, "You are missing the required privs: " .. table.concat(missing, ", ")
        end
    end,
})

minetest.register_chatcommand("chat_distance", {
    func = function(name, param)
        local res, notice

        if param == "" then -- Get current distance
            local config_dist = player_config_dist(name)
            res, notice = true, "Chat distance is currently " .. (config_dist > 0 and config_dist or "not set") .. "."
        elseif tonumber(param) and tonumber(param) > 0 then -- Set distance if valid
            minetest.get_player_by_name(name):get_meta():set_int(MODNAME .. ":chat_distance", tonumber(param))
            res, notice = true, "Chat distance set to " .. param .. "."
        else -- Bad input
            res, notice = false, "Chat distance must be a number greater than 0."
        end

        return res, notice .. (setting("player_config") and "" or " Per-player distance is not enabled by the server.")
    end,
})
