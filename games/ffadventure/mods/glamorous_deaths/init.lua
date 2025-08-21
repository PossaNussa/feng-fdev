--[[
Glamorous Deaths - Announce players' deaths server-wide with
colorful messages

Copyright (C) 2022 Brett Cornwall
Copyright (C) 2016 EvergreenTree

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local title = "Glamorous Deaths"
local version = "0.1.0"
local mname = minetest.get_current_modname()

dofile(minetest.get_modpath(mname).."/settings.txt")

-- A table of quips for death messages. The first item in each sub table is
-- the default message used when RANDOM_MESSAGES is disabled.
local messages = {}

-- These messages must make sense for both "You […]" and "SomePlayerName […]"

messages.lava = {
    " burned to a crisp.",
    " got a little too close to lava.",
    " burned up in lava.",
    " turned into molten char.",
    " let their intrusive thoughts win.",
    " burned to char.",
    " burned to ash.",
    " was incinerated by molten rock.",
    " couldn't escape the fiery abyss.",
    " was consumed by the lava's wrath.",
    " melted away in the searing heat.",
    " met a fiery demise.",
}

messages.water = {
    " drowned.",
    " struggled for air.",
    " suffocated.",
    " ran out of oxygen.",
    " embraced the deep.",
    " was swallowed by the waves.",
    " couldn't keep afloat.",
    " sank to the bottom of the ocean.",
    " was engulfed by the watery depths.",
    " was claimed by the sea.",
    " perished beneath the waves.",
    " succumbed to the water's embrace.",
}

messages.fire = {
    " burned to a crisp.",
    " burned up.",
    " didn't stop, drop, and roll.",
    " got roasted, and not just by their friends.",
    " got barbecued.",
    " got toasty.",
    " got roasted.",
    " played with fire.",
    " was consumed by flames.",
    " became one with the fire.",
    " was reduced to ashes.",
    " met a fiery end.",
}

messages.fall = {
    " fell.",
    " had a tumble.",
    " lost footing.",
    " went splat.",
    " took a dive.",
    " took a tumble. OOF!",
    " plummeted to their death.",
    " took a fatal fall.",
    " fell to their doom.",
    " couldn't find solid ground.",
    " crashed down.",
    " missed a step and paid the price.",
}

messages.punch = {
    " got knocked out.",
    " was beaten to a pulp.",
    " took a heavy blow.",
    " couldn't withstand the punch.",
    " was floored by a powerful strike.",
    " was knocked senseless.",
    " was overpowered.",
    " was taken out with a punch.",
    " didn't see the punch coming.",
    " got clocked in the jaw.",
    " was sent flying by a hit.",
    " met their end with a punch.",
}

messages.cyclops = {
    " had all his blood punched out.",
    " was squashed by a monster.",
    " didn't heed the tales of the Megabeasts...",
    " was crushed by a towering beast.",
    " was pulverized by a massive creature.",
    " couldn't escape the fury of a beast.",
    " was trampled by a gigantic monster.",
    " was obliterated by a colossal brute.",
    " was smashed into the ground by a monstrous beast.",
    " fell victim to the overwhelming power of a creature.",
    " was flattened by a hulking monstrosity.",
    " was torn apart by a savage beast.",
    " was overpowered by the sheer strength of a monster.",
    " was pounded into oblivion by a massive brute.",
    " was destroyed by an unstoppable force.",
}

messages.vampire = {
    " was eaten by a vampire.",
    " will soon be found lifeless and drained of blood.",
    " got a taste of a vampire's fangs.",
    " should have worn garlic.",
    " has joined the vampire ranks!",
    " had their blood sucked by a vampire.",
    " became a meal to a creature of the night.",
    " was drained dry by a vampire.",
    " succumbed to the vampire's hunger.",
    " was turned into a lifeless husk by the vampire.",
    " couldn't escape the vampire's embrace.",
    " fell victim to the vampire's bite.",
}

messages.zombies = {
    " was eaten by a zombie.",
    " became a zombie.",
    " succumbed to the horde.",
    " was claimed by the horde.",
    " was overwhelmed by zombies.",
    " was eaten by the undead.",
    " joined the ranks of the undead.",
    " was devoured by the zombie swarm.",
    " couldn't escape the zombie horde.",
    " was consumed by the undead.",
    " fell to the ravenous horde.",
    " was overrun by the walking dead.",
}

-- Adding custom messages for specific zombie types

messages.draugr = {
    " was dragged to the depths by a draugr.",
    " was slain by the undead might of a draugr.",
    " could not escape the curse of the draugr.",
    " was pulled into the underworld by a draugr.",
    " was torn apart by a draugr's claws.",
    " was ensnared by the draugr's curse.",
    " was ripped to shreds by a draugr.",
    " couldn't withstand the draugr's wrath.",
    " fell to the draugr's relentless attack.",
    " was no match for the draugr's power.",
    " was dragged into the darkness by the draugr.",
    " was torn asunder by the draugr's fury.",
}

messages.seamonster = {
    " was pulled under by the seafolk.",
    " met a watery grave at the hands of the seafolk.",
    " was taken by the seafolk, never to be seen again.",
    " was dragged into the depths by the seafolk.",
    " was claimed by the seafolk.",
    " was crushed by the seafolk's grip.",
    " was devoured by the seafolk.",
    " was torn apart by the seafolk.",
    " was consumed by the seafolk's wrath.",
    " couldn't escape the seafolk's grasp.",
    " was drowned by the seafolk.",
    " was pulled into the abyss by the seafolk.",
}

messages.hamster = {
    " was killed by a band of raiding hamsters.",
    " fell to the spears of hamster raiders.",
    " was overrun by raiding hamsters.",
    " couldn't fend off the hamsterfolk.",
    " was ambushed by a group of hamsters.",
    " was slain by a band of hamsterfolk.",
    " was caught off guard by hamster raiders.",
    " was no match for the raiding hamsters.",
    " was taken down by the hamsterfolk.",
    " was overwhelmed by the hamster raiders.",
    " was speared by a group of hamsterfolk.",
    " fell victim to the hamster raid.",
}

messages.lionmen = {
    " was mauled by a lionman.",
    " could not escape the claws of a lionman.",
    " fell prey to the ferocity of the lionmen.",
    " was torn apart by a lionman.",
    " couldn't outrun the lionmen.",
    " was savaged by the lionmen.",
    " was clawed to death by a lionman.",
    " was brought down by a lionman.",
    " was mauled by the lionmen's powerful claws.",
    " fell victim to the lionmen's rage.",
    " was hunted down by a lionman.",
    " was defeated by the lionman's strength.",
}

messages.cheetahmen = {
    " was outpaced and slain by a cheetahman.",
    " couldn't outrun the swift cheetahman.",
    " was struck down by the rapid cheetahman.",
    " was taken down by a cheetahman.",
    " couldn't escape the cheetahman's speed.",
    " was outmaneuvered by a cheetahman.",
    " was brought down by the cheetahman's agility.",
    " was no match for the cheetahman's swiftness.",
    " was caught off guard by the cheetahman.",
    " was felled by the cheetahman's quick strikes.",
    " couldn't react in time to the cheetahman's attack.",
    " was overwhelmed by the cheetahmen's speed.",
}

messages.froghmen = {
    " was ambushed by a frogman.",
    " was struck down by a frogman archer.",
    " couldn't leap away from the frogman.",
    " was slain by a frogman.",
    " couldn't escape the frogman's ambush.",
    " was brought down by a frogman archer.",
    " was caught off guard by a lurking frogman.",
    " was shot down by a frogman archer.",
    " was overwhelmed by the frogmen.",
    " was outwitted by the frogmen.",
    " was struck by the frogman's quick attack.",
    " was outjumped by a frogman.",
}

messages.gnoll = {
    " was torn apart by a gnoll.",
    " fell to the savage fury of a gnoll.",
    " was no match for the gnoll's ferocity.",
    " was ripped to shreds by a gnoll.",
    " couldn't withstand the gnoll's attack.",
    " was overpowered by the gnoll's strength.",
    " was brought down by the gnoll's claws.",
    " was eaten by gnolls.",
    " was devoured by gnolls.",
    " was overrun by the gnoll's ferocity.",
    " was defeated by a gnoll.",
    " couldn't fend off the gnoll's attack.",
    " fell victim to the gnoll's savage assault.",
}

messages.undeadknight = {
    " was cut down by an undead knight.",
    " couldn't withstand the might of the undead knight.",
    " was slain by the cursed blade of an undead knight.",
    " was struck down by the undead knight.",
    " couldn't escape the undead knight's wrath.",
    " was brought low by the undead knight's sword.",
    " was overpowered by the undead knight.",
    " was felled by the undead knight's cursed steel.",
    " was defeated by the undead knight's relentless attack.",
    " was no match for the undead knight's strength.",
    " succumbed to the undead knight's blade.",
    " was crushed by the undead knight's power.",
}

local function get_message(mtype)
    if RANDOM_MESSAGES then
        return messages[mtype][math.random(1, #messages[mtype])]
    else
        return messages[1] -- 1 is the index for the non-random message
    end
end

local function split_mt_object_name(input)
    local mod, obj = string.match(input, "(.*):(.*)")
    if obj then
        return string.gsub(obj, "_", " ")
    else
        return string.gsub(input, "_", " ")
    end
end

minetest.register_on_dieplayer(function(player, reason)
    local player_name = player:get_player_name()
    local was_were = "was"  -- to be changed if in singleplayer

    if minetest.is_singleplayer() then
        player_name = "You"
        was_were = "were"
    end

    if reason["type"] == "node_damage" then
        if reason["node"]:find("lava") then
            minetest.chat_send_all(player_name .. get_message("lava"))
        elseif reason["node"]:match("fire") or reason["node"]:match("flame") then
            minetest.chat_send_all(player_name .. get_message("fire"))
        else
            -- Try to make something out of the node that killed the player as
            -- a last-ditch effort. Strip the mod name from the item and
            -- sentence-case it to make it seem a little more natural.
            if reason["node"] ~= nil then
                local obj_name_pretty = split_mt_object_name(reason["node"])
                minetest.chat_send_all(
                    player_name .. " " .. was_were .. " killed by " .. obj_name_pretty .. "."
                )
            else
                minetest.chat_send_all(player_name .. " died.")
            end
        end
    elseif reason["type"] == "drown" then
        minetest.chat_send_all(player_name .. get_message("water"))
    elseif reason["type"] == "fall" then
        minetest.chat_send_all(player_name .. get_message("fall"))
    elseif reason["type"] == "punch" then
        local killer_obj = reason["object"]
        local killer_name

        if minetest.is_player(killer_obj) then
            killer_name = killer_obj:get_player_name()
        else
            local entity = killer_obj:get_luaentity()
            killer_name = entity.name or "unknown"
        end

        killer_name = split_mt_object_name(killer_name):lower()

  
    -- Modifying the punch section to include the new messages
if string.find(killer_name, "vampire") then
    minetest.chat_send_all(player_name .. get_message("vampire"))
elseif string.find(killer_name, "cyclops") or
       string.find(killer_name, "badguy") then
    minetest.chat_send_all(player_name .. get_message("cyclops"))
elseif string.find(killer_name, "zombie") or 
       string.find(killer_name, "seazombie") or 
       string.find(killer_name, "mummy") or 
       string.find(killer_name, "1arm") or 
       string.find(killer_name, "crawler") then 
    minetest.chat_send_all(player_name .. get_message("zombies"))
elseif string.find(killer_name, "draugr") then
    minetest.chat_send_all(player_name .. get_message("draugr"))
elseif string.find(killer_name, "seamonster") then
    minetest.chat_send_all(player_name .. get_message("seamonster"))
elseif string.find(killer_name, "hamster") then
    minetest.chat_send_all(player_name .. get_message("hamster"))
elseif string.find(killer_name, "lionman") or string.find(killer_name, "lion_warrior") then
    minetest.chat_send_all(player_name .. get_message("lionmen"))
elseif string.find(killer_name, "cheetahman") or string.find(killer_name, "cheetahwarrior") or string.find(killer_name, "cheetarcher") then
    minetest.chat_send_all(player_name .. get_message("cheetahmen"))
elseif string.find(killer_name, "froghman") or string.find(killer_name, "frarcher") then
    minetest.chat_send_all(player_name .. get_message("froghmen"))
elseif string.find(killer_name, "gnoll") then
    minetest.chat_send_all(player_name .. get_message("gnoll"))
elseif string.find(killer_name, "undeadknight") then
    minetest.chat_send_all(player_name .. get_message("undeadknight"))
elseif killer_name ~= "unknown" then
    minetest.chat_send_all(player_name .. " " .. was_were .. " killed by " .. killer_name .. ".")
else
    minetest.chat_send_all(player_name .. get_message("punch"))
end
    else
        minetest.chat_send_all(player_name .. " died.")
    end
end)

print("[Mod] "..title.." ["..version.."] ["..mname.."] loaded.")