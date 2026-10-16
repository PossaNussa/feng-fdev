# creaturemob

One mob runtime serving two APIs. `mobs.*` (Mobs Redo) and `creatura.*` both come
from this mod. Nothing that depends on either had to be rewritten.

## Why

creatura mobs stayed smooth under load; Mobs Redo mobs rubberbanded constantly.
The cause was never the AI — it was the actuation layer.

| | Mobs Redo (before) | creatura | creaturemob |
|---|---|---|---|
| velocity written | from ~12 call sites, on 1 Hz and 4 Hz timers | buffered, flushed once per step | buffered, flushed once per step, skipped when unchanged |
| turning | `delay` counted **server steps**, never read `dtime`; final step assigned the target outright | `dtime`-scaled interpolation | `dtime`-scaled, terminates exactly on target |
| heading vs. motion | velocity derived from the yaw at call time, then yaw kept turning | re-derived each step | re-derived each step |
| gravity / buoyancy | `set_acceleration` from a `core.after(0.3)` callback outside the step loop | acceleration, set in-step | acceleration, set in-step |
| push-out force | recomputed inside every `set_velocity`, then stale for a second | n/a | own 2 Hz cadence, one player-only scan |

A client dead-reckons the velocity the server last sent it. Send a contradictory
one a second later and the only way to reconcile is a snap. That snap is the
rubberband, and every row above was producing one.

## Layout

```
core/motion.lua      the only writer of velocity, acceleration and rotation
core/scheduler.lua   brain cadence + distance LOD (bodies always update)
core/sensors.lua     throttled sampling: push-out, cached props, nearest player
core/world.lua       node/neighbourhood queries shared by everything
core/pathfind.lua    creatura's time-sliced A*/Theta*, used by both front-ends
core/navigate.lua    shared route service on top of it: budget, smoothing, cache
core/spawn.lua       shared spawn predicates: clearance, light, biome, climate
compat/creatura.lua  the creatura.* façade  + back-compat shims
compat/mobs.lua      the mobs.* façade      + restored legacy surface
compat/mount.lua     mobs.attach / detach / drive / fly
creatura/            vendored upstream creatura (Dec 2025), rewired
mobs/                vendored upstream Mobs Redo (20260730), rewired + forked
test/harness.lua     offline symbol + behaviour checks (`luajit test/harness.lua`)
```

`mods/mobs` and `mods/creatura` still exist as content mods — items, crafts,
textures, sounds — so every `depends = mobs` / `depends = creatura` in the game
resolves unchanged and `mobs:*` itemstrings keep their prefix.

## Navigation

`core/pathfind.lua` is the search. `core/navigate.lua` is what mods should
actually call, and it adds the three things that separate "there is a
pathfinder" from "mobs stop walking into walls":

- **A shared budget in microseconds per step**, not per call. Searches are
  time-sliced and resume next step, so a crowded village spreads its searches
  over more steps instead of handing most of its mobs no route at all — which
  is the failure mode that leaves them steering straight at the goal.
- **Width awareness.** The engine pathfinder solves for a point; a 0.7-wide
  collisionbox handed a point-width route clips every corner it is sent round.
  `navigate.shape()` reads the mob's own collisionbox and the search uses it.
- **String-pulled smoothing.** An A* route on a grid is a staircase, and a
  follower aiming at each step of a staircase spends its whole time steering
  diagonally into block corners. Smoothing collapses it into the few long
  straight runs a mob can actually walk — refusing to merge across a change in
  height, because a long diagonal through a staircase jams a mob against the
  riser.

Plus a route cache (villagers walk the same journeys all day, so the second one
to make a trip pays nothing) and `navigate.clear_ahead()`, the cheap per-step
probe that lets a follower sidestep rather than grind.

`find_path` returns `nil, "searching"` and `nil, "budget"` as well as
`nil, "failed"`. Only the last means give up; the other two mean ask again next
step and keep steering at the goal meanwhile.

### Obstacle avoidance is opt-out

`do_smart_path` — scan for a heading that is clear at head height *and* solid
underfoot, instead of turning a random amount and hoping — has been here since
the merge, but `smart_path` defaulted to false and **nothing ever set it**, so
every mob in the game still flailed against walls the stock Mobs Redo way.

It now defaults on. A mob that is meant to look stupid sets
`smart_path = false`, and `mobs_smart_path_exclude` (default `zombies:`)
excludes whole mods by name prefix, because the undead shambling into things is
the point of them.

## Compatibility guarantees

**The Mobs Redo FSM is untouched.** `do_states`, `self.state`, the
`stand`/`walk`/`runaway`/`attack` names and every private `mob_class` method keep
their exact signatures. Five mods in this game drive them directly — `goblins`
(including a custom `tunnel`/`room` state machine), `lottmobs`, `zombies-master`,
`spidermob`, `pixel_animals` — so only what those functions *write to* changed.

**Restored, after upstream deleted them:** `mobs:register_spawn` (48 call sites),
`mobs:yaw`, `mobs:set_animation`, `mobs:line_of_sight`, `mobs:yaw_to_pos`,
`mobs:explosion`, `mobs.invis`.

**Shimmed, after upstream renamed them:** `bouyancy_multiplier` /
`hydrodynamics_multiplier` → `liquid_submergence` / `liquid_drag` (without this,
animalia's tropical fish and frogs would float); `creatura:theta_pathfind` →
`creatura:pathfind_theta` (both names registered); `creatura.get_next_move` /
`get_next_move_3d` restored from the previous release; `block_protected` and
`block_protected_spawn` both accepted.

**`mobs` stays a plain, writable table.** 120+ spawn blocks across five mods
communicate through `mobs.custom_spawn_*` flags, including a cross-mod read
(`hardcore_farming` reads a flag owned by `animalworld`).

**creatura mobs still carry `_creatura_mob`, never `_cmi_is_mob`.** That is
load-bearing: `waterdragon` rewrites `on_punch` on every registered entity
carrying `_cmi_is_mob`, and stamping it here would silently attach waterdragon's
punch handler to every animalia and draconis mob.

## ffadventure fork features, carried forward

Selective persistence: pets (tamed), NPCs, named mobs and `def.persistent` mobs
are saved permanently and never despawn; anonymous wildlife recycles when far
from players so mapblocks stay under the engine's `max_objects_per_block` cap
(exceeding it makes the engine silently drop saved entities, pets included).
`mobs_all_persistent` (default off) forces wildlife persistent too. Swimmers (auto-detected from a
liquid `fly_in`; strict `flight_check`, wide beached search, `at_shore` stop,
drift instead of being pinned), `smart_path` obstacle steering, and biome +
heat/humidity spawn filters on `mobs:spawn`.

Two fork changes were **not** carried forward because upstream had since solved
them another way: `follow_stop` (upstream's fake `"standing"` state), and the
`base_colbox` hot-path optimisation (upstream caches into `self.prop` at 1 Hz).

## Bugs fixed on the way through

- **`creatura.get_node_def` mutated the node registry.** It set
  `walkable = false` on the live `core.registered_nodes` entry for any node
  shorter than 0.26, so one pathfinding query permanently redefined
  `default:snow` for the entire game. Unknown nodes shared a single default
  table, so one unknown node turned all of them non-solid. Now memoized in a
  private table.
- **`creatura.is_pos_moveable` scanned the wrong place.** It added `pos` to loop
  variables that were already absolute world coordinates, so it tested a box
  around `2 * pos`.
- **creatura's mapgen spawning was dead code.** `spawning.lua` hardcoded
  `local mapgen_spawning = false`; mobs with `spawn_on_load` were collected into
  a table nothing ever read. Now follows the `creatura_mapgen_spawning` setting
  it was always documented to.
- **`mobs:spawn` silently ignored foreign entities.** It bailed out for any name
  missing from `mobs.spawning_mobs`, and `can_spawn` required a `base_colbox`
  that only `mobs:register_mob` sets. `paleotest`'s 17 dinosaur spawns were
  therefore no-ops since the day they were written. `foreign = true` opts an
  entity in and resolves its collision box from the ordinary entity definition.
- **Mobs Redo pathfinding blocked the step.** `core.find_path()` ran the whole
  search inline, every step, for every attacking mob. Now uses the shared
  time-sliced search (500/700 µs budget, resumable) — `nil` was already a valid
  answer there.

## Settings

`creaturemob_smooth_motion` (default on) turns the shared controller off
globally; `legacy_motion = true` on a mob definition opts that one mob out and
restores the original actuation verbatim. `creaturemob_lod` /
`creaturemob_lod_near` / `creaturemob_lod_far` control the brain-rate falloff for
mobs no player is near. `mob_use_lvm_pathfinding` picks the time-sliced
pathfinder over `core.find_path`, and `creaturemob_path_budget_us` (default
3000) caps how much of each server step every mob in the world may spend
searching between them. `mobs_smart_path` (default on) and
`mobs_smart_path_exclude` (default `zombies:`) control obstacle avoidance.
Every pre-existing `mobs_*` and `creatura_*` setting keeps its name.

Two fork defaults differ from upstream and are preserved: `mob_height_fix` is on,
and `mob_pathfinding_algorithm` is `Dijkstra`.

## Two gotchas of serving foreign namespaces

Both of these bit during the migration and both now fail offline in
`test/harness.lua` or in a one-line check, rather than at server start.

1. **Registered names need the `:` escape.** The engine requires an item or
   entity name to start with the current mod name, and this mod registers under
   two foreign prefixes. Anything named `mobs:…` or `creatura:…` from here must
   be written `":mobs:…"` / `":creatura:…"`. The harness reproduces
   `check_modname_prefix` and reports violations.
2. **Mods resolve by `mod.conf` name, not folder name.** A spare copy of a mod
   anywhere under `games/ffadventure/mods/` — however the folder is named —
   declares a second mod of the same name and the game aborts with "unresolved
   name conflicts".

## Pre-merge copies

The original `mods/mobs` and `mods/creatura` are kept at
`backups/creaturemob-premerge/` (repo root), for A/B comparison against the old
movement. **Do not put them back under `games/ffadventure/mods/`** even under a
different folder name: Luanti resolves mods by the `name` field in `mod.conf`,
not by directory name, so a copy there declares a second mod called `mobs` and
the game refuses to start with "unresolved name conflicts".

## Scope

`mobkit`, `mob_core`, `kitz` and `waterdragon` still run on their own engines.
`core/` is deliberately front-end agnostic so a `compat/mobkit.lua` could be
added later without redesign.
