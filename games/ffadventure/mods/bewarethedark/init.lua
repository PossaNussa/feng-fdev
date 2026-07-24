--[[

Beware the Dark [bewarethedark]
==========================

A mod where darkness drains your sanity, with smooth convergence.

Copyright (C) 2015 Ben Deutsch <ben@bendeutsch.de>

License
-------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
USA

]]


bewarethedark = {

    -- configuration in bewarethedark.default.conf

    -- per-player stash (not persistent)
    players = {
        --[[
        name = {
            pending_dmg = 0.0,
            last_hud_val = nil,
        }
        ]]
    },

    -- dtime accumulator
    timer = 0.0,
}
local M = bewarethedark

dofile(minetest.get_modpath('bewarethedark')..'/configuration.lua')
local C = M.config

dofile(minetest.get_modpath('bewarethedark')..'/persistent_player_attributes.lua')
local PPA = M.persistent_player_attributes

dofile(minetest.get_modpath('bewarethedark')..'/hud.lua')

PPA.register({
    name = 'bewarethedark_sanity',
    min  = 0,
    max  = 20,
    default = 20,
})

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if not M.players[name] then
        M.players[name] = { pending_dmg = 0.0, last_hud_val = nil }
        M.hud_init(player)
    end
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    M.players[name] = nil
end)

minetest.register_on_respawnplayer(function(player)
    local name = player:get_player_name()
    local pl = M.players[name]
    if pl then
        pl.pending_dmg = 0.0
        pl.last_hud_val = nil
    end
    PPA.set_value(player, "bewarethedark_sanity", 20)
    M.hud_update(player, 20)
end)

minetest.register_globalstep(function(dtime)
    M.timer = M.timer + dtime
    if M.timer < C.tick_time then return end
    M.timer = M.timer - C.tick_time

    local enable_damage = minetest.settings:get_bool("enable_damage", true)

    for _, player in ipairs(minetest.get_connected_players()) do
        if player:get_hp() > 0 then
            local name = player:get_player_name()
            local pl = M.players[name]
            if pl then
                local pos = player:get_pos()
                -- head position
                pos.y = math.floor(pos.y) + 1.5
                local node = minetest.get_node(pos)

                local light = minetest.get_node_light(pos) or 9
                if node.name == "ignore" then
                    light = 9
                end

                local target = C.target_for_light[light] or 14
                local sanity = PPA.get_value(player, "bewarethedark_sanity")
                local rate = (target < sanity) and C.drain_rate or C.recovery_rate

                local diff = target - sanity
                local step = diff * rate
                -- Prevent asymptotic stall: enforce minimum step toward target
                if math.abs(diff) > 0.01 and math.abs(step) < 0.15 then
                    step = diff > 0 and 0.15 or -0.15
                end
                sanity = sanity + step
                if math.abs(sanity - target) < 0.2 then sanity = target end
                if sanity < 0 then sanity = 0 end
                if sanity > 20 then sanity = 20 end
                PPA.set_value(player, "bewarethedark_sanity", sanity)

                -- HUD: only update when the displayed integer changes
                local hud_val = M.hud_clamp(sanity)
                if hud_val ~= pl.last_hud_val then
                    M.hud_update(player, sanity)
                    pl.last_hud_val = hud_val
                end

                -- HP damage when critically insane
                if sanity < C.dmg_threshold and enable_damage then
                    local dps = (C.dmg_threshold - sanity) / C.dmg_threshold * C.dmg_max_dps
                    pl.pending_dmg = pl.pending_dmg + dps * C.tick_time
                    if pl.pending_dmg >= 1 then
                        local dmg = math.floor(pl.pending_dmg)
                        pl.pending_dmg = pl.pending_dmg - dmg
                        player:set_hp(player:get_hp() - dmg)
                    end
                else
                    pl.pending_dmg = 0
                end
            end
        end
    end
end)
