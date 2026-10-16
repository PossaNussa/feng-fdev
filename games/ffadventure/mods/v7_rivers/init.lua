-- v7_rivers: Carve physically-correct rivers into v7 mapgen terrain.
-- Uses a mapgen script so changes go directly into the mapgen VM — no write_to_map needed.

if core.get_mapgen_setting('mg_name') == 'singlenode' then return end

core.register_mapgen_script(core.get_modpath('v7_rivers') .. '/mapgen.lua')

-- Also load v7's base terrain field into the MAIN environment, and publish it.
--
-- mapgen_rivers' pregeneration runs here, on first world load, and needs this to
-- seed the erosion simulation with v7's own landscape instead of unrelated
-- noise.  It is published rather than required directly because the dependency
-- points the wrong way: mapgen_rivers knows nothing about v7_rivers, and must
-- keep working on its own.  Load order makes this safe — v7_rivers depends on
-- mapgen_rivers so it loads later, and pregeneration is deferred to
-- register_on_mods_loaded, by which time this is set.
v7_rivers = {
	base = dofile(core.get_modpath('v7_rivers') .. '/v7base.lua'),
}
