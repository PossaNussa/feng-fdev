--[[
    X Farming. Extends Minetest farming mod with new plants, crops and ice fishing.
    Copyright (C) 2023 SaKeL <juraj.vajda@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it pos the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to juraj.vajda@gmail.com
--]]

local mod_start_time = minetest.get_us_time()
local path = minetest.get_modpath('x_farming')

-- Legacy backwards compatibility
minetest.register_alias('x_farming:hog_stew', 'x_farming:fish_stew')

-- MineClone2 support
if minetest.get_modpath('mcl_core') and minetest.global_exists('mcl_core') then
    dofile(path .. '/mod_support_mcl_aliases.lua')
end

dofile(path .. '/api.lua')
dofile(path .. '/craftitems.lua')
dofile(path .. '/nodes.lua')

dofile(path .. '/melon.lua')
dofile(path .. '/pumpkin.lua')
dofile(path .. '/coffee.lua')
dofile(path .. '/corn.lua')
dofile(path .. '/obsidian_wart.lua')
dofile(path .. '/potato.lua')
dofile(path .. '/beetroot.lua')
dofile(path .. '/carrot.lua')
dofile(path .. '/cocoa.lua')
dofile(path .. '/seeds.lua')
dofile(path .. '/kiwi_tree.lua')
dofile(path .. '/cactus.lua')
dofile(path .. '/strawberry.lua')
dofile(path .. '/pine_nut.lua')
dofile(path .. '/christmas_tree.lua')
dofile(path .. '/stevia.lua')
dofile(path .. '/soybean.lua')
dofile(path .. '/salt.lua')
dofile(path .. '/cotton.lua')
dofile(path .. '/barley.lua')
dofile(path .. '/bees.lua')
dofile(path .. '/rice.lua')
dofile(path .. '/stove.lua')

dofile(path .. '/hoes.lua')

dofile(path .. '/ice_fishing.lua')
dofile(path .. '/bonemeal.lua')
dofile(path .. '/crates.lua')
dofile(path .. '/bags.lua')
--dofile(path .. '/composter.lua')
dofile(path .. '/crafting.lua')

if not x_farming.vessels then
    dofile(path .. '/vessels.lua')
end

---timer for crates
minetest.register_lbm({
    label = 'x_farming timer for crates',
    name = 'x_farming:start_nodetimer_crates',
    nodenames = x_farming.lbm_nodenames_crates,
    action = function(pos, node)
        x_farming.tick_again_crates(pos)
    end
})

-- MOD support

if minetest.get_modpath('default') then
    dofile(path .. '/mod_support_default.lua')
end

-- hbhunger
if x_farming.hbhunger ~= nil then
    if hbhunger.register_food ~= nil then
        dofile(path .. '/mod_support_hbhunger.lua')
    end
end

-- hunger_ng
if x_farming.hunger_ng then
    dofile(path .. '/mod_support_hunger_ng.lua')
end

-- candles_3d
if minetest.get_modpath('candles_3d') then
    dofile(path .. '/mod_support_candles_3d.lua')
end

local mod_end_time = (minetest.get_us_time() - mod_start_time) / 1000000

print('[Mod] x_farming loaded.. [' .. mod_end_time .. 's]')

minetest.register_on_mods_loaded(function()
    -- Only target final-stage crops (groups.growing = nil) so we don't
    -- clobber farming's growth timer on mid-growth stages.
    local crop_to_foodblock = {
        -- farming redo crops (final stages only)
        ["farming:beetroot_5"]   = "foodblocks:beetroot_cube",
        ["farming:blackberry_4"] = "foodblocks:blackberry_cube",
        ["farming:cabbage_6"]    = "foodblocks:cabbage_cube",    -- was _5, but 6 is final
        ["farming:carrot_8"]     = "foodblocks:carrot_cube",
        ["farming:chili_8"]      = "foodblocks:chili_cube",
        ["farming:corn_8"]       = "foodblocks:corn_cube",
        ["farming:cucumber_4"]   = "foodblocks:cucumber_cube",
        ["farming:garlic_5"]     = "foodblocks:garlic_cube",
        ["farming:lettuce_5"]    = "foodblocks:lettuce_cube",
        ["farming:onion_5"]      = "foodblocks:onion_cube",
        ["farming:pineapple_8"]  = "foodblocks:pineapple_cube",
        ["farming:potato_4"]     = "foodblocks:potato_cube",
        ["farming:raspberry_4"]  = "foodblocks:raspberry_cube",
        ["farming:tomato_8"]     = "foodblocks:tomato_cube",
        -- pepper: only stage 7 (red) is truly final (growing=nil)
        -- stages 5 (green) and 6 (yellow) still have growing group
        ["farming:pepper_7"]     = "foodblocks:capsicum_r_cube",

        -- x_farming equivalents
        ["x_farming:beetroot_8"] = "foodblocks:beetroot_cube",
        ["x_farming:carrot_8"]   = "foodblocks:carrot_cube",
        ["x_farming:corn_10"]    = "foodblocks:corn_cube",
        ["x_farming:potato_8"]   = "foodblocks:potato_cube",
    }

    -- Automatically turn final-stage crops into food blocks.
    -- Uses an ABM instead of overriding on_construct/on_timer, so we
    -- never clobber farming's growth timer on any stage.
    local crop_names = {}
    local crop_map = {}
    for crop, foodblock in pairs(crop_to_foodblock) do
        if minetest.registered_nodes[crop] and minetest.registered_nodes[foodblock] then
            table.insert(crop_names, crop)
            crop_map[crop] = foodblock
        else
            minetest.log("warning", "[x_farming] foodblock target " .. crop .. " does not exist, skipping")
        end
    end

    if #crop_names > 0 then
        minetest.register_abm({
            label = "Crops overgrow into foodblocks",
            nodenames = crop_names,
            interval = 900,   -- check every 15 minutes
            chance = 6,       -- ~1/6 chance each check ≈ 30% per 30 min
            catch_up = false,
            action = function(pos, node)
                local foodblock = crop_map[node.name]
                if foodblock then
                    minetest.set_node(pos, {name = foodblock})
                end
            end,
        })
    end
end)
