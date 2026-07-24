-- v7_rivers: Carve physically-correct rivers into v7 mapgen terrain.
-- Uses a mapgen script so changes go directly into the mapgen VM — no write_to_map needed.

if core.get_mapgen_setting('mg_name') == 'singlenode' then return end

core.register_mapgen_script(core.get_modpath('v7_rivers') .. '/mapgen.lua')
