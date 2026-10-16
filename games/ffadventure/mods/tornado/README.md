# tornado

Rare supercell storms, and once in a long while a tornado that walks out of one
and rearranges the landscape.

**This mod moves nodes.** Set `tornado_griefing = false` on any world you are not
prepared to see chewed up.

## How an event runs

Nothing is ever announced in chat. The storm tells you it is coming the way a
real one does, using the wind system you already have:

1. **The wind dies.** For the first half of the build-up the global wind is
   forced to almost nothing. The sails go slack, `sum_air_currents`' particles
   and wind loop stop, the weather's rain slant goes vertical. Dead calm on a
   humid afternoon is the first tell, and because it is an absence it is
   unsettling rather than decorative.
2. **The light goes.** A green-black sky and heavy low cloud, registered through
   `climate_api` like any other weather, so it merges and fades properly with
   rain, fog and everything else. Lightning frequency climbs.
3. **The air starts moving the wrong way.** Dust, leaf litter and grit lift off
   the ground and stream *towards* the storm — all of it pointing the same way.
   Roughly half of it is particles of whatever the ground is actually made of
   underfoot, so it is grass over a field and sand over dunes. That direction is
   the bearing. It is the only "message" the mod sends and it is a picture.
4. **You can see it.** If a funnel forms it drops in `tornado_approach_distance`
   nodes upwind and walks in, roaring, taking most of a minute to arrive.

Most supercells stop after stage 3. `tornado_funnel_chance` (default 0.15)
decides, and it is rolled when the storm starts, so a build-up that fizzles is
the common case — which is the point. The sky stays worth reading because
reading it is usually survivable.

## What the funnel does

* Lifts nodes from the surface within its core, hardest at the axis. Resistance
  is group-based: grass and leaves go instantly, dirt and sand readily, planks
  and fences with effort, **stone effectively never**. That last one is the
  safety property that stops a funnel carving a trench across the world, and it
  is why a stone-walled cellar is genuinely shelter.
* Never deletes anything. Every lifted node becomes a debris entity that orbits
  up the vortex, is thrown clear, flies, hurts whatever it hits, and is **placed
  back into the world** where it lands. A funnel leaves a mess you can tidy, not
  a hole you have to refill.
* Skips containers, furnaces, machines and anything with a formspec, so no
  inventory is ever eaten.
* Skips protected areas while `tornado_respect_protection` is on, and drops
  debris as items rather than placing it if it lands in one.
* Drags players and mobs into a spiral and lifts them.

## Integration

* `climate_api` — the sky, the ambient sound, the blowing particles and the
  lightning are all registered weather presets. `/weather` reports the supercell
  like anything else.
* The event forces `climate_mod.forced_enviroment.wind`, which is the shared
  field that `sum_air_currents`, `airutils`, the cloud drift and the weather
  particles all read. That is what makes the calm, the inflow and the funnel's
  own heading agree with each other. Note that this field is global: during a
  storm the wind does what the storm says everywhere, not only near it. Turn it
  off with `tornado_force_wind = false`.
* `lightning` — used for the strikes during the build-up, if installed.
* `regional_weather` — the ambient wind sound and the lightning effect are
  borrowed from it, if installed.
* No hard dependencies. Without `climate_api` the funnels still work, driven by
  whatever wind `sum_air_currents` reports, but the sky and sound do not.

## Commands

`/tornado` (needs the `server` priv):

| | |
|---|---|
| `status` | current phase, live funnels, debris count, key settings |
| `storm` | start a build-up here that will produce a funnel |
| `now` | skip the build-up; the funnel comes in upwind immediately |
| `spawn [strength]` | drop a funnel on your position, 0..1 strength |
| `stop` | remove all funnels, cancel the event, clear the cooldown |

There is deliberately no item that summons one.

## Tuning

Frequency is `tornado_storm_chance` (per 15-second scan, one roll for the whole
server, only while somebody is standing outdoors in warm, damp, already-windy
weather) times `tornado_funnel_chance`, with `tornado_cooldown` seconds of quiet
afterwards. At the defaults that is a storm every couple of hours of qualifying
weather and a funnel from about one in seven of them.

Damage output is mostly `tornado_node_rate` (nodes lifted per second) and
`tornado_radius`. See `settingtypes.txt` for the rest.
