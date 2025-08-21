# Alone

[![ContentDB](https://content.luanti.org/packages/Codiac/alone/shields/title/)](https://content.luanti.org/packages/Codiac/alone/)

A Luanti mod to disperse players around the world.

**This mod is a WIP!**

Normally all players share the same default spawn point that is close to {0, 0,
0} or a server defined point. 

This mod changes it so that each player gets their own, random, spawn point.

When a player registers they get random X and Y coordinates between 1,000 and
30,000, each of these has a 50% chance to be negative.

This spawn point is stored in the players meta data and they will spawn here
unless they have registered another spawn point.

If you enable this feature on an existing world the existing registered player's
will not be affected. New players will be affected.

If you disable this feature on an existing world then spawning will revert to
the games normal spawn behavior.

[Luanti Forum](https://forum.luanti.org/viewtopic.php?t=31801)

## Supported Games

This mod has a chance of working with any game, however a lot of games have
extra spawn logic and may require some customization to work properly.

|Game|Testing|Comment|
|---|---|---|
|Mineclonia|A lot|Works well. Random House.|
|Minetest Game|Some|Works OK. No House.|
|VoxelLibre|Some|Works OK. Small house.|
|MeseCraft|Minimal|Appears to work out of the box. No house.|
|Age Of Mending|Minimal|Appears to work out of the box. No house.|
|Lord of the Test|Minimal|Appears to work out of the box. No house.|
|NodeCore|Minimal|Appears to work out of the box. No house.|
||||

### Failed testing

|Game|Testing|Comment|
|---|---|---|
|Repixture|Minimal|No effect. Spawning not exposed for mods to override.|
||||

## Supplying House Schematics

A server admin can override the schematics used for housing in two ways,
globally and per world.

If a world has it's own house schematics then global house schematics will be
ignored.

If either world or global schematics exist then any game supplied schematics
will be ignored.

The schematics are not cached so that admins can add more schematics without
having to restart the server.

### Global

An admin can create a `houses` directory in this mod's data directory and copy
`*.mts` files to it. These files will then be used as house schematics for new
players.

The mods data directory is usually `~/.minetest/mod_data/alone/` but may be
somewhere else on your system.

e.g. If a server admin had a directory of castle schematics and wanted players
to start with one, they could do something like this.

```bash
mkdir -p ~/.minetest/mod_data/alone/houses
cp ~/castles/*.mts ~/.minetest/mod_data/alone/houses/.
```

### Per World

An admin can create an `alone_houses` directory in a world's directory and copy
`*.mts` files to it. These files will then be used as house schematics for new
players.

The world directory is usually `~/.minetest/worlds/$your_worlds_name/` but may
be somewhere else on your system.

e.g. If a server admin had a directory of hovel schematics and wanted players in
the `pov` world to start with one, they could do something like this.

```bash
mkdir -p ~/.minetest/worlds/pov/alone_houses
cp ~/hovels/*.mts ~/.minetest/worlds/pov/alone_houses/.
```

## Settings

### Home Alone

If the `alone_home_alone` setting is enabled, and the game is supported, then a
house will spawn with the player. This defaults to false.

#### Games with supported homes

* **Mineclonia**: A random house, a building with a bed registered with
  `mcl_villages.register_building`, will be selected.
* **VoxelLibre**: The small, single bed, house.

### Players home has a teleport

If the `alone_home_teleport` setting is enabled, and a supported teleport mod is
active, then the player's home will have a teleport pad that the player owns.
This defaults to false.

Supported teleport mods: tpad.

### Players home has a waypoint

If the `alone_home_waypoint` setting is enabled, and a supported waypoint mod is
active, then the player's home will also have a named waypoint. This defaults to
false.

Supported waypoint mods: named_waypoints.

### Minimum distance from center

`alone_min_dist` controls the minium X and Y distance a player will spawn away
from {0, 0, 0}. This defaults to 1000.

### Maximum distance from center

`alone_max_dist` controls the maximum X and Y distance a player will spawn away
from {0, 0, 0}. This defaults to 30000.

### Distance from other players

`alone_player_dist` controls the minimum distance a player will spawn away from
other player spawns. This defaults to 500.

### Number of spawn attempts

`alone_spawn_attempts` setting controls the number of times to try an
randomly place a new. If this limit is reached then new players will
spawn at the default spawn point. This defaults to 5000.

### Predictable spawn positions

The `alone_predictable_spawns` setting controls the way random numbers are
generated when selection player spawn positions. This defaults to false.

If this is enabled then the random number generator will be seeded with the
player's name and world seed. This will make starting positions predictable.

Note that setting this on does not guarantee a specific spawn position for a
player. The minimum player distance is still used and if a player spawns close
to another player's spawn position before that player spawns, then the player
will be bounced to their next spawn position, and so on, until they get a clear
space.

The more players that have spawned in the world before a new player joins the
more likely it is they will collide and another position will be tried.

## To Do

### Definite

* ~~Fix endless loop in looking for random placement~~ Done.
* ~~Ensure that the default spawn point is used if random placement fails~~ Done.
	* It does.
* ~~Add setting to control use of teleport and waypoints~~ Done.
	* Admin may want them active but not automatically used in homes
* ~~Allow admins to provide schemas to use for houses~~ Done.

### Being Considered

* Support an area mod and grant the player ownership of their home and/or start
  area?
* Split up player spawns in someway so distance checking is more efficient?
	* A problem with this is player home locations become predictable ...
* Support float lands?
* Support subterranean spawns?
* A way to group players in an area?
	* e.g. your "team" might all be in the top left of the world
* Support more teleport mods?
	* travelnet? - Needs manual placement. Check if it works in schemas.
	* teleport potion? - Pad is a sender. How to use it?

### No Longer Being Considered

* Allow specifying kits to equip players with?
	* This should probably be a standalone mod.
* Support more games?
	* Not going to spend more time guessing on this. Players who want a specific
	game supported can request it.

## Dependencies

There are no mandatory mods.

### Optional

These mods can expand the experience this mod offers.

* [Named
  Waypoints](https://content.luanti.org/packages/FaceDeer/named_waypoints/)
  Install from ContentDB. Used for player's homes.
* [Teleport Pads](https://content.luanti.org/packages/entuland/tpad/) Install
  from ContentDB. Used for player's homes.

## Known Issues

* Sometimes mapgen (carving, structure placement, etc) can happen after the
  house is placed
* You can be placed close to, or even in, structures
	* With a house this can break stuff
	* Without a house sometimes you just need to run :D

## Legal

### Source Code License

The source code in this mod is licensed under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of
the License, or (at your option) any later version. See
[LICENSE.md](LICENSE.md).
