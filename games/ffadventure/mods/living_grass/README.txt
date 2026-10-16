Living Grass
=====
A mod that makes grass grow, dry out, regrow, and die.

This makes worlds feel more alive, since the grass will change over time.

See license.txt for license information.

Seeding (ffadventure addition)
-----
The lifecycle above only ever consumes grass, and so does the rest of the game:
regional_weather's snow_griefing ABM replaces flora with snow that later melts
to nothing, and players harvest it. The only things that create a grass node
are mapgen decorations, which run once per chunk, and flowers.flower_spread,
which copies an existing plant onto nearby soil and so cannot restart from
nothing. A world that spends a winter with snow on the ground therefore comes
out of it permanently bare.

regrowth.lua closes the loop. Bare ground whose node name says it is grassy
sprouts single blades during the growing season, sparsely -- flower_spread
thickens each one into a patch and the grow ABMs raise it to full height. Snow,
forest litter, sand and anything under a roof or inside protection are left
alone.

When the `seasons` mod is present, seeding stops for the winter (roughly 26
March to 7 November in the default 360-day year), so snow still clears the
grass and spring still brings it back. Without `seasons` it runs all year.

`/regrow_grass [radius]` (server priv) seeds an area at once, for repairing a
world that has already been stripped. See settingtypes.txt for the rest.

Author of source code
-----
Written by karlexceed (LGPL-2.1-or-later)
