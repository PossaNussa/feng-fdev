-- Mobs Redo -- content mod
--
-- The API this mod used to carry now lives in `creaturemob`, which serves both
-- the `mobs.*` and `creatura.*` namespaces from one runtime. This mod stays in
-- place so that every `depends = mobs` in the game still resolves and every
-- `mobs:*` itemstring keeps its prefix; it registers the items, crafts, spawner
-- and lucky blocks, and nothing else.
--
-- See mods/creaturemob/README.md.

local S = core.get_translator("mobs")

-- peaceful player privilege

core.register_privilege("peaceful_player", {
	description = "Prevents Mobs Redo mobs from attacking player",
	give_to_singleplayer = false
})

-- fallback node

core.register_node("mobs:fallback_node", {
	description = S("Fallback Node"),
	tiles = {"mobs_fallback.png"},
	is_ground_content = false,
	groups = {handy = 1, crumbly = 3, not_in_creative_inventory = 1},
	drop = ""
})

local path = core.get_modpath("mobs")

dofile(path .. "/crafts.lua") -- items and crafts

dofile(path .. "/spawner.lua") -- mob spawner

-- Lucky Blocks

if core.get_modpath("lucky_block") then
	dofile(path .. "/lucky_block.lua")
end

print("[MOD] Mobs Redo (creaturemob) loaded")
