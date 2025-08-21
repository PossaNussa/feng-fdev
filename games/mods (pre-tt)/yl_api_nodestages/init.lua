-- Version 1.0.0
-- Author AliasAlreadyTaken
-- License MIT

-- Changelog

local mod_start_time = minetest.get_us_time()
minetest.log("action", "[MOD] yl_api_nodestages loading")

yl_api_nodestages = {}
yl_api_nodestages.error = {}
yl_api_nodestages.modname = minetest.get_current_modname()
yl_api_nodestages.modstorage = minetest.get_mod_storage()
yl_api_nodestages.modpath = minetest.get_modpath("yl_api_nodestages") .. DIR_DELIM
yl_api_nodestages.worldpath = minetest.get_worldpath() .. DIR_DELIM

dofile(yl_api_nodestages.modpath .. "texts.lua")
dofile(yl_api_nodestages.modpath .. "information.lua")
dofile(yl_api_nodestages.modpath .. "config.lua")
dofile(yl_api_nodestages.modpath .. "internal.lua")
dofile(yl_api_nodestages.modpath .. "api.lua")
dofile(yl_api_nodestages.modpath .. "initialize.lua")
dofile(yl_api_nodestages.modpath .. "lbm.lua")

local mod_end_time = (minetest.get_us_time() - mod_start_time) / 1000000
minetest.log("action", "[MOD] yl_api_nodestages loaded in [" .. mod_end_time .. "s]")
