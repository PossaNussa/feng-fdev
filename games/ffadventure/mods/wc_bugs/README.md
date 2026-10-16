# wc_bugs

A variety of bugs. Originally written by Winter94 for NodeCore; ported to
Minetest Game (this game's `default`).

## What's in it

| Bug | Where it comes from | What it does |
| --- | --- | --- |
| Torchbug | Spawns above soil/sand at worldgen; craft coal + staffbug | Blinks on and off in the dark, gives off warm light. Dig one bare-handed and it flares into a flamebug |
| Flamebug | An angry torchbug | Glows brightly, hurts to touch, sets fires near flammable nodes, calms back down after a while |
| Luxmoth | Break a chrysalis (cave ceilings below y=-16) | Cold blue glow. Direct sunlight kills it |
| Peatle | 1 in 80 dirt digs | Camouflaged as a clod of earth. Four of them pack back into a dirt node |
| Prillbug | 1 in 16 iron-ore digs | Squash for an iron lump |
| Stickbug | 1 in 60 leaf digs | Squash for a stick; burns as fuel |
| Termite | Dropped by a termite nest | Put one next to bare wood and an infestation starts |
| Lodewurm | Crack a lodewurm egg (stone below y=-128) | Tunnels through rock eating it, bites what it meets, drops iron lumps as it sheds its tail |
| Staffbug / framebug / ladderbug / adzebug / rakebug | Assembled from stickbugs | Work like a stick pair, a wooden fence, a ladder, an axe and a shovel — squash them for the honest wooden version |

Bugs in group `catchable`, so the `fireflies` bug net picks them up. Bugs left
in your main inventory get restless and escape after a minute or two — faster
in bright light, faster while you run, slower if you are carrying something
that reassures them. Put one in a **bug jar** (glass + bug) and it settles
down for good; jarred bugs keep glowing and stop dying of sunlight. Bugs
dropped on the ground skitter about and eventually wander off.

`/killbugs [radius]` (server priv) clears bugs nearby; radius defaults to 20.

## Settings

See `settingtypes.txt`. `wc_bugs.termites` (on by default) lets infestations
spread into player-built wood — turn it off if that is unwelcome.
`wc_bugs.torch_hatching` (off by default) restores the NodeCore behaviour
where a lit torch standing in soil turns out to have been a torchbug.

## Port notes

The NodeCore original was built on facilities Minetest Game does not have.
What replaced them:

- **`nodecore.register_aism`** (per-item-stack callbacks) → a 2-second
  globalstep in `api.lua` that walks connected players' main inventories and
  nudges loose item entities near them. `wc_bugs.register_escape` registers
  per-bug temperament.
- **`nodecore.register_craft`** (in-world pummel/stacking recipes) → ordinary
  grid recipes. "Smushing" a bug into its wooden or metal equivalent is a
  shapeless one-slot recipe.
- **`drop_in_place`** → `on_dig` handlers that swap the node instead of
  dropping an item (torchbug → flamebug, chrysalis → luxmoth, wurm egg →
  hatched wurm).
- **`nodecore.register_dnt`** (delayed node timers) → node timers, plus an
  LBM that restarts a wurm's timer if it was lost.
- **`nodecore.register_mapgen_shared`** → a `register_on_generated` pass that
  infests one tree node in roughly every fortieth mapchunk.
- **`nodecore.register_leaf_drops`** / ore drop overrides → `on_dignode`
  hooks (`wc_bugs.register_dig_spawn`), so no other mod's drop tables are
  rewritten.
- **`nodecore.sounds`, `smokeburst`, `is_full_sun`, `quenched`, `toolcaps`** →
  `default.node_sound_*` and the helpers in `api.lua`.
- **Item mapping**: `nc_lode:prill` → `default:iron_lump`,
  `nc_tree:stick` → `default:stick`, `nc_woodwork:{staff,frame,ladder,adze,rake}`
  → `default:stick 2` / `fence_wood` / `ladder_wood` / `axe_wood` /
  `shovel_wood`, `nc_optics:shelf_float` → `default:glass`.
- **Textures**: everything the original composed out of `nc_*` base textures
  now uses `default_*` textures plus five new 16×16 pieces
  (`wc_bugs_bug_mask`, `wc_bugs_mites`, `wc_bugs_pattern_scales`,
  `wc_bugs_pattern_egg`, `wc_bugs_chrysalis`) and a drawn
  `wc_bugs_termite`. The original's own bug sprites are unchanged.
- **Termites** only get infested variants for this game's own trees and
  planks (10 nodes × 4 stages), driven by two ABMs rather than one ABM per
  node per stage. Infested wood still drops the clean wood when you dig it.
- **Lodewurms**: the nc_snakes body-support flood fill was replaced by a
  cheaper rule (it will only enter open space that touches something solid),
  the search radius dropped from 10 to 4, body length is capped at 10
  segments, and it refuses to eat protected nodes or anything with
  `is_ground_content = false` — so it chews through terrain, not through
  buildings.

Dropped in the port: `leech.lua` (a player-attached parasite built entirely
on NodeCore's virtual-item and health-effect HUD, and already disabled
upstream), `generation.lua` (dead code referencing a node that was never
registered), and `lodewurm.lua` (an earlier unused wurm implementation). The
leech textures are kept in case someone wants to finish that.
