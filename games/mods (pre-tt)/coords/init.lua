-- Mod-Definition
local coords_hud = {}

-- Funktion zur Aktualisierung des HUDs
function coords_hud.update_hud(player)
    local player_name = player:get_player_name()
    local pos = player:get_pos()
    local rounded_x = math.floor(pos.x + 0.5) -- Runde X auf die nächste ganze Zahl
    local rounded_y = math.floor(pos.y + 0.5) -- Runde Y auf die nächste ganze Zahl
    local rounded_z = math.floor(pos.z + 0.5) -- Runde Z auf die nächste ganze Zahl
    local coords_text = string.format("Position: X: %d Y: %d Z: %d", rounded_x, rounded_y, rounded_z)

    player:hud_change(coords_hud[player_name], "text", coords_text)
end

-- Spieler beitreten
minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()

    -- HUD hinzufügen
    coords_hud[player_name] = player:hud_add({
        hud_elem_type = "text",
        position = {x=0.01, y=0.2},
        offset = {x=0, y=0},
        text = "",
        alignment = {x=1, y=1},
        number = 0xFFFFFF,
        size = {x=1, y=1},
    })

    -- HUD initial aktualisieren
    coords_hud.update_hud(player)
end)

-- Spieler verlassen
minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()

    -- HUD entfernen
    player:hud_remove(coords_hud[player_name])
    coords_hud[player_name] = nil
end)

-- Timer zum Aktualisieren des HUDs
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        coords_hud.update_hud(player)
    end
end)

-- Mod aktivieren
minetest.log("action", "[coords_hud] Mod geladen")