-- creatura -- content mod
--
-- The API this mod used to carry now lives in `creaturemob`, which serves both
-- the `creatura.*` and `mobs.*` namespaces from one runtime. This mod stays in
-- place purely so that every `depends = creatura` in the game still resolves
-- and the mod's sounds and textures keep shipping.
--
-- See mods/creaturemob/README.md and doc.txt for the API itself.

assert(creatura, "[creatura] creaturemob did not load first -- check mod.conf depends")
