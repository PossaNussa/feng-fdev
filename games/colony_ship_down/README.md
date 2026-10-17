# Colony Ship Down

A multiplayer hangout aboard the colony ship **CSV Meridian**, adrift in deep space.
Crew do short Among Us-style tasks to keep the ship's systems running, fix
malfunctions together, and otherwise make their own fun. Building isn't the
point: anyone can place what they find or craft, but nobody can damage the
ship itself. Claim a cabin or vacant room and it's yours to furnish.

## Running it

Make a world with the game **Colony Ship Down**. On first start the ship is
generated automatically (about half a second). New players spawn in the
Arrivals Lounge and pick a job.

## Admin / builder

| Command | What it does |
|---|---|
| `/grant <name> builder` | Full building rights (can change the ship itself); also grants creative, fly, fast, noclip |
| `/robots respawn` | Put the robot crew back at their posts |
| `/regenship confirm` | Rebuild the starter ship from `csd_ship/layout.lua` (overwrites its whole volume) |
| `/setshipspawn` | Spawn point = where you stand |
| `/malfunction <id>` / `/malfunction stop` | Start/stop a malfunction |
| `/setsystem <system> <0-100>` | Set a ship system's condition |
| `/shiplights normal\|alert\|off` | Ship lighting mode |
| `/stations` | Count task stations aboard |
| `/tasks new` | Re-roll your tasks |

Crew commands: `/job`, `/tasks`, `/ship`, `/crewstats`, `/whereami`, `/spawn`,
`/claim`, `/unclaim`, `/myroom`, `/global <msg>` (ship intercom; normal chat is
proximity chat), `/music <0-100|off>`, `/ambience <0-100|off>`,
`/particles full|low|off` (decorative particles: star drift, haze, sparks; the
engine's own cap is the `max_particles` client setting).

Things to do aboard: tasks (every unfinished one has a waypoint), malfunctions
(the fix stations get red waypoints), loot crates (they restock), crafting,
claiming a room, a cryopod of your own (right-click a free pod; you respawn
there, and if you log out inside it you wake there), sitting down (right-click a
bench/sofa/bunk; jump to stand), talking to the robots (right-click; punch them
and they complain), EVA (suit lockers in the Shuttle & EVA Bay; a full suit lets
you breathe outside, where you float in zero-g: jump to rise, sneak to sink),
eating at the mess hall, and watching the stars drift past the windows. Mind
the dark: sanity drains without lamplight (power failures, EVA).

Tasks do things: fuel pumps hand out fuel cells for the engine ports, comms
terminals give data chips for the uplinks, planters need a watering can (fill it
at a Hydroponics tap), galley rations go onto the mess hall serving counters,
vents and filters clog and come clean, and damaged hull panels need a hull patch
(press scrap metal from the crates in the Machine Shop - the Create press).
Data chips carry a snippet of the ship's logs (hover over one). Shooting
asteroids fires the hull's laser turrets - watch from the Weapons Bay windows.
Cabins and vacant suites have vertical sliding doors that lock for everyone but
the owner once claimed. Machinery aboard: reactor turbines, flywheels and
gauges, the Machine Shop press, Life Support air handlers, Water Reclamation
pumps (they drain floods faster) and Hydroponics sprinklers (slow its wear).
New tasks arrive 30 s after you finish your list; any station can be used again
as a small voluntary repair after 90 s. Systems wear about 1.5%/minute.

Settings (minetest.conf): `csd_tasks_per_player` (5),
`csd_system_decay` (1.5 per minute), `csd_malfunctions` (true),
`csd_malfunction_interval` (600 s),
`csd_rescue_distance` (400), `csd_claim_limit` (1), `csd_crate_restock` (7200 s).

## Mods

`mods/csd/` holds the game's own mods. They are written against the Minetest Game
API, so they also load in ffadventure.

- **csd_core**: building rules (the ship can't be damaged), the `builder` privilege, jobs, chat tags, real seats, spawn, crawling (hold Aux1 - Ctrl in the launcher; automatic under low ceilings)
- **csd_space**: vacuum mapgen (a drowning `csd_space:vacuum` node), starfield sky, low gravity, rescue drone
- **csd_tasks**: 7 ship systems, 17 station kinds, mini-games, task lists, HUD, awards
- **csd_events**: reactor meltdown, O2 depletion, power failure, comms blackout, hull breach, asteroid storm,
  burst pipe (floods a room with finite water via dynamic_liquid until the valve is shut)
- **csd_ship**: building palette, data-driven layout, generator, room decorators, room HUD, ship lighting, air ducts in the crawlspace above every deck (hatches in the maintenance closets, pipes to every vent), shoot-out lights (fix with a Replacement Bulb, a new light or a Mese lamp), hydroponics soil beds with every farming / x_farming crop under grow lamps,
  room claims, loot crates, visible system effects (flicker, wilt, static, sparks, haze), star drift, exterior
- **csd_eva**: wearable spacesuit (3d_armor) and suit lockers
- **csd_robots**: the robot crew (patrols, reactions, dialogue, skins for players via skinsdb); guns knock them offline, a Robot Repair Kit / scrap metal / steel ingots fix them (they also reboot themselves after 15 min)
- **csd_zoo**: the zoological deck (deck 5): sealed glass habitats (big cats, elephants, aviary, aquarium, grasslands) and a petting zoo, kept stocked from animalia, pixel_animals and animalworld (wild spawning is off); `/zoo restock`
- **csd_audio**: room-aware soundtrack, ambience loops, sound effects
- **csd_create**: Create-style machines on steamified's stress/RPM network (hand crank, reactor turbine, encased fan, flywheel, speedometer/stressometer, mechanical press + depot, mechanical pump, irrigation sprinkler, emergency capacitor task)

`mods/ffa_shared/` holds mods copied from ffadventure. **Don't edit them here.**
Edit them in ffadventure, then:

    python3 tools/sync_shared_mods.py status   # what differs, and on which side
    python3 tools/sync_shared_mods.py pull     # ffadventure -> CSD
    python3 tools/sync_shared_mods.py push X   # CSD -> ffadventure (for fixes made here)
    python3 tools/sync_shared_mods.py deps     # check hard dependencies resolve

The list lives in `shared_mods.txt`. An entry like `3d_armor/3d_armor` takes one
mod out of a modpack.

## Art

All textures, models and sounds are original and generated by scripts:

    python3 tools/make_art.py             # textures, skybox, menu art, sounds
    python3 tools/make_create_assets.py   # csd_create .glb models + atlas
    python3 tools/make_music.py           # soundtrack, ambience loops, SFX (a few minutes)

The soundtrack is composed and synthesised by make_music.py, so it's original
and royalty-free.

Create's own models and textures are "All Rights Reserved" (only its code is
MIT), so none of them are included here.

## Engine settings (this fork)

- `colored_lighting_saturation` (default 1.8): how vivid coloured light is.
- `lod_mode` (`solid` default, or `top`): far-away blocks keep all their solid
  faces (`top` only draws upward faces - cheaper, but walls and hulls vanish).

## Launcher (download-and-play client)

`launcher/` holds a stripped-down client that only joins Colony Ship Down
servers, with the official server (45.143.196.182:30000) pre-filled:
a custom main menu, client defaults and `package.sh`, which builds a flat
portable folder + zip (`ColonyShipDown.exe` next to its data, no installer).

* CI: `.github/workflows/csd-launcher.yml` (repo root) builds the Windows and Linux zips from
  this repo's engine and attaches them to a GitHub release when you
  push a `csd-v*` tag (e.g. `csd-v1.0.0`).
* Locally: `launcher/package.sh <engine_root> <engine_root>/bin/luanti dist`.
* Windows SmartScreen will warn about any new unsigned program; the workflow
  has an optional code-signing step (Azure Trusted Signing) that switches on
  when its secrets are set. No packers, installers or downloaders are used,
  which is what keeps antivirus false positives away.

Running the official server: see SERVER.md.
