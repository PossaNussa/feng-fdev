# Rockweed

Rockweed is a petrified plant which grows well in dark, empty
caves. It is similar in some ways to the default trees, but there are
many differences as well. Rockweed has no hard dependencies, but is
aware of other popular mods such as the ones included in dreambuilder
modpack.

Rockweed does not need light, water, or nutrient to grow, as it is
powered primarily by the dark energy, which permeates the dark places
of the world. Additionally, rockweed seeds manifest quantum mechanical
properties such as quantum tunneling, whereas they can slip into the
6th dimension and emerge on the other side of several meters of solid
rock.

Even though related to hemp plant, rockweed does not have any
appreciable amount of soft green plant matter in it. Rockweed can
neither be used to farm hemp, nor to extract any product normally
derived from hemp, and consuming rockweed in any way would be just as
pointless as eating sand.

## The Seed

There is a seed node, which can be crafted with mese blocks (M) and a
tree sapling (T):

`MTM`  
`TTT`  
`MTM`  

With blox and farming mods, there is a somewhat cheaper recipe using
hemp seed (S) and glowstone (G):

`GSG`  
`SSS`  
`GSG`  

The seed is leafy, glows slightly, and is most easily harvested with a
sharp tool such as a sword.

The seed can be built normally, and will attempt to grow into
something randomly and periodically. Like the tree saplings, the seed
is sensitive to the light level, but unlike the saplings, what it
really needs is darkness. Very bright light kills the seed; medium
light causes the seed to hibernate and do nothing until conditions
change; and low light allows the seed to grow normally.

Rockweed can grow into air, water, and lava, and it will never
overwrite any other type of node, except that growing a tree out of a
seed will also overwrite that seed. Air, water, and lava are
considered together as empty nodes, while everything else is
considered filled-in.

If the light is good for growing, the seed will look at the 26 closest
neighbor nodes to determine what to do. All together there are 2^26
different patterns of empty/filled-in neighbors a seed can encounter.
Some patterns cause the seed to sprout a tree, but most patterns will
not. Instead, faced with a generic pattern around it, the seed will
attempt to grow in a random direction, while leaving behind a single
trunk node.

## Quantum Walk

The seed's random walk is called a quantum walk because the seed can
seemingly teleport across several meters of solid matter and emerge
unharmed on the other side. The seed looks around randomly several
times, attempting to locate an empty node to grow into, with priority
given to closest nodes. If it finds an empty node, the seed jumps
there, and builds a trunk node at its old position. If it fails to
find an empty node, the seed either falls asleep to try again a
bit later, or sprouts a small star-like formation, which ends the
walk.  This latter behavior ensures that all walled-off seeds
eventually disappear, reducing the server load.

As the walk progresses normally and the seed feeds on the dark energy,
it will occasionally sprout a small flower and continue the walk.

## Rockweed Trunk

Rockweed grows a hard carbon-based trunk crowned with glowing
hemp. Unlike trees, rockweed does not have its own trunk
material. Instead it uses whatever acceptable material it finds
nearby, and replicates it on the molecular level. The list of
acceptable materials can be found in trunks.lua. This is an
intentionally large list which includes all common enough nodes which
are node-filling (perfect cubes), hard, and carbon-based (rock, glass,
plant). Additionally, trunks cannot be glowing, cannot be falling
(like sand), and can include at most a trace amount of metals. These
rules are not unbreakable, but exceptions are rare.

Whenever no suitable material can be found nearby, the default stone
trunk is used.

## Glowing Hemp

When a seed sprouts, it will typically crown the trunk with some
glowing and sparkling hemp. This kind of hemp is glassy and
transparent to sunlight. Digging glowing hemp will occasionally
convert it into a seed, which is a pretty good way to farm
seeds. Right-clicking sparkling hemp will dim/undim its light source.

Sparkling hemp (S) can be downgraded to glowing hemp by breaking the
glass casing:

`...`  
`.S.`  
`...`  

Glowing hemp (H) can be encased in glass (G) to make sparkling hemp:

`GHG`  
`HHH`  
`GHG`  

## Treeish Patterns

When the seed finds one of these patterns around it, it will end the
quantum walk and sprout something big. Each pattern is described here
in three 3x3 levels, from bottom to top. Patterns are absolute and
cannot be rotated, but that's mostly moot because they are highly
symmetric.

Legend:

  * . empty node (air/water/lava)
  * O filled-in node
  * s the seed (always in the very center of the 3x3x3 cube pattern)
  * t trunk material suggestion
  * b crystal base suggestion

Reference screenshots use glass to fill nodes around the yellow seed,
with cobble taking the place of the trunk material suggestion, and
wooden planks taking the place of the crystal base suggestion.

### Tree

Useful for looking neat and harvesting glowing hemp.

`OOO | ... | ...`  
`OtO | .s. | ...`  
`OOO | ... | ...`  

![Tree](./screenshots/tree.jpg?raw=true)

### Upward spire

Useful for climbing up.

`.O. | ... | ...`  
`OtO | .s. | ...`  
`.O. | ... | ...`  

![Upward spire](./screenshots/upward-spire.jpg?raw=true)

### Downward spire

Useful for climbing down.

`... | ... | .O.`  
`... | .s. | OtO`  
`... | ... | .O.`  

![Downward spire](./screenshots/downward-spire.jpg?raw=true)

### Upside-down mushroom

Useful for descending from the ceiling of a giant cave.

`... | ... | OOO`  
`... | .s. | OtO`  
`... | ... | OOO`  

![Downward mushroom](./screenshots/downward-mushroom.jpg?raw=true)

### Antibomb

Useful for... Nevermind, this one just splurges in all directions and
fills up a medium amount of space.

`... | .O. | ...`  
`.t. | OsO | .O.`  
`... | .O. | ...`  

![Antibomb](./screenshots/antibomb.jpg?raw=true)

### Floor

The floor extends on the same level as the seed.  Useful for paving
over flat horizontal surfaces. Note that the trunk suggestion is just
to the east from the seed: (x+1, y, z).

`OOO | OtO | ...`  
`OOO | OsO | ...`  
`OOO | OOO | ...`  

![Floor](./screenshots/floor.jpg?raw=true)

### Ceiling

The ceiling extends on the same level as the seed.  Useful for paving
under flat horizontal surfaces. Note that the trunk suggestion is just
to the east from the seed: (x+1, y, z).

`... | OtO | OOO`  
`... | OsO | OOO`  
`... | OOO | OOO`  

![Ceiling](./screenshots/ceiling.jpg?raw=true)

### Hanging floor

Just like the floor, but with all empty nodes below the seed. Useful
for extending the floor in the middle of a giant cave. Note that the
trunk suggestion is just to the east from the seed: (x+1, y, z).

`... | OtO | ...`  
`... | OsO | ...`  
`... | OOO | ...`  

![Hanging floor](./screenshots/hanging-floor.jpg?raw=true)

### Walls

Useful for building walls.

`... | ... | ...`  
`OtO | OsO | OOO`  
`... | ... | ...`  

`.O. | .O. | .O.`  
`.t. | .s. | .O.`  
`.O. | .O. | .O.`  

![Wall](./screenshots/wall.jpg?raw=true)

### Bridges

Constructs a bridge in the direction away from the trunk node
(t). Useful for moving laterally in empty space.

`... | ... | ...`  
`... | OsO | ...`  
`... | OtO | ...`  

`... | OtO | ...`  
`... | OsO | ...`  
`... | ... | ...`  

`... | OO. | ...`  
`... | ts. | ...`  
`... | OO. | ...`  

`... | .OO | ...`  
`... | .st | ...`  
`... | .OO | ...`  

![Bridge](./screenshots/bridge.jpg?raw=true)

### Stair up

Constructs a staircase up and in the direction away from the trunk
node (t). Useful for moving around in empty space.

`... | ... | ...`  
`... | OsO | ...`  
`OOO | OtO | ...`  

`OOO | OtO | ...`  
`... | OsO | ...`  
`... | ... | ...`  

`O.. | OO. | ...`  
`O.. | ts. | ...`  
`O.. | OO. | ...`  

`..O | .OO | ...`  
`..O | .st | ...`  
`..O | .OO | ...`  

![Stair up](./screenshots/stair-up.jpg?raw=true)

### Stair down

Constructs a staircase down and in the direction away from the trunk
node (t). Useful for moving around in empty space.

`... | ... | ...`  
`... | OsO | ...`  
`... | OtO | OOO`  

`... | OtO | OOO`  
`... | OsO | ...`  
`... | ... | ...`  

`... | OO. | O..`  
`... | ts. | O..`  
`... | OO. | O..`  

`... | .OO | ..O`  
`... | .st | ..O`  
`... | .OO | ..O`  

![Stair down](./screenshots/stair-down.jpg?raw=true)

### Upward crystal

Trunk material (t) is placed on top of every nearby node of the same
type as the crystal base (b). Useful for paving over nodes.

`OOO | ... | ...`  
`ObO | .s. | .t.`  
`OOO | ... | ...`  

![Upward crystal](./screenshots/upward-crystal.jpg?raw=true)

### Downward crystal

Trunk material (t) is placed below every nearby node of the same type
as the crystal base (b). Useful for paving rugged ceilings.

`... | ... | OOO`  
`.t. | .s. | ObO`  
`... | ... | OOO`  

![Downward crystal](./screenshots/downward-crystal.jpg?raw=true)

### Crystal

Trunk material (t) is placed next to every nearby node of the same
type as the crystal base (b). Any filled-in node can be used as the
base, but the crystal will not grow if the base and the trunk are the
same material.

Useful for encasing nodes or filling up crevices.

`OOO | .O. | ...`  
`ObO | OsO | .t.`  
`OOO | .O. | ...`  

![Crystal](./screenshots/crystal.jpg?raw=true)

### Flex wall

Similar to the upward-growing crystal, the flex wall will grow the
trunks (t) on top of base trunks (b) near the same horizontal plane,
making a wall of any shape several meters tall. Useful for growing
towers and zig-zagging walls.

`.O. | .O. | ...`  
`.b. | .s. | .t.`  
`.O. | .O. | ...`  

`... | ... | ...`  
`ObO | OsO | .t.`  
`... | ... | ...`  

![Flex wall](./screenshots/flex-wall.jpg?raw=true)

### Starburst

Attaches several hemp stars to the walls, floors, and ceilings in the
vicinity, if possible. Useful for lighting up varied terrain.

`O.. | O.. | O..`  
`O.. | ts. | O..`  
`O.. | O.. | O..`  

`..O | ..O | ..O`  
`..O | .st | ..O`  
`..O | ..O | ..O`  

`OOO | OtO | OOO`  
`... | .s. | ...`  
`... | ... | ...`  

`... | ... | ...`  
`... | .s. | ...`  
`OOO | OtO | OOO`  

![Starburst](./screenshots/starburst.jpg?raw=true)

### 3d-copier

Very slowly accumulates the dark energy, and then makes a perfect
3d-copy of a nearby node. Absolutely anything buildable can be copied
this way. Containers will be copied with their contents by default.

Even the smallest amount of light above that of the seed glow will
cause the 3d-copier to jam, so it won't work under the moonlight. The
average copying time of 16.8 minutes can be adjusted via the config
options by fiddling with rockweed.copier_chance. This pattern cannot
be rotated, and is shown here with the x-axis pointing up, and the
z-axis pointing left. In other words, you have to face the rising Sun
as you build it. If you can see the in-game compass, then the z-axis
is going north, and the x-axis is going east.

`OO. | ... | .OO`  
`.OO | .s. | O.O`  
`O.. | ... | ..O`  

The reference screenshot shows the bottom layer of the pattern with
dirt, and the top with glass. The stone brick to be copied is situated
4 meters from the seed along the z-axis; it has to be a filled-in
node, as rockweed won't copy air, water, or lava. The copy is to be
created 7 meters from the seed along the z-axis; this node has to be
empty, or else the copier will jam.

In the reference screenshot we are facing east, so that the x-axis
goes forward, and the z-axis goes to the left. The prototype and the
copy can just hang in the air if desired, but here shown with glass
support.

![3d-copier](./screenshots/3d-copier.jpg?raw=true)

## Privs

Node duplication is controlled with tiered privs:

  * **rockweed** allows to plant seeds, which will grow and duplicate
    acceptable trunks
  * **rockweed3d** also allows to use 3d-copier
  * **rockweed3dmeta** also allows to 3d-copy container contents

Granting more than one of these will work correctly, but is not
necessary: if you just grant **rockweed3d**, then planting will become
possible, and if you just grant **rockweed3dmeta**, then all rockweed
features will become available.

## Configuration

Many configuration options can be adjusted in rockweed-config.lua. If
touching the mod source code is undesireable, then the same
configuration options can be adjusted in WORLDPATH/rockweed-config.lua

Since the settings in WORLDPATH/rockweed-config.lua are applied last,
we recommend you start with empty WORLDPATH/rockweed-config.lua and
then insert modifications to the default settings as needed. This way,
when you update the mod, the defaults will be updated as well, unless
you changed them in WORLDPATH/rockweed-config.lua
