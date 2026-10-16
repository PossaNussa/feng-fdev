Petroglyphs mod Copyright (c) 2023 Neuromancer

-------------------------------------------------------------------------------

Licenses:

Code: MIT
Texture and models: CC BY-SA 3.0

see LICENSE.txt

-------------------------------------------------------------------------------

This mod adds petroglyphs to Luanti.

Marks pecked and painted into rock faces.  Every stone in the strata carries
its own set: stone, desert stone, sandstone, limestone, shale, slate, schist,
saprolite, granite, gneiss, marble, quartz, onyx, basalt, mantle rock and
pumice, plus badlands red sandstone if that mod is enabled.  The pigment is
picked against the rock's own tone, so a pale pecked mark sits on dark stone
and a dark ochre or charcoal one on pale stone.

Rocks are listed in petroglyphs.stones in init.lua and are skipped in silence
if the node does not exist, so the list is safe to extend.

Forty-two designs, in six hands:

  1-16   archaic  - animals, figures, hands, spirals, boats, mazes
  17-22  runic    - staves, inscriptions, bind-runes, the helm of awe
  23-29  vedic    - trident, lotus, wheel, elephant, humped bull, seal script
  30-34  nilotic  - ankh, the watching eye, scarab, cartouche, winged disc
  35-40  northern - raven, orca, salmon, flute player, mask, bear's paw
  41-42  ...      - two marks that belong to no known culture

Finding them
------------

Panels are rare, but they are not scattered.  A low-frequency noise picks out
the handful of regions that were ever worked; inside one, roughly one mapchunk
in four carries a panel, and a panel runs from two marks to a gallery of two
dozen across the same wall.  So the first one you find is never the only one.

A region carves in one hand.  Cross far enough and the style changes.

Panels are cut on vertical rock faces with open air in front of them: cliff
walls, gorges, cave walls, quarry cuts, mountain sides, anywhere a person could
have stood back and worked.  Rolling grassland has none, because it has no bare
rock -- if you travel overland you will walk past worked country and see
nothing.  Look where stone is exposed, and go underground.

They are also written only into newly generated terrain, so land you explored
before this mod was added will never have them.

Finding one, in game (needs the 'server' priv):

  /petroglyphs here   report whether you stand in worked country, and which
                      carving hand this region uses
  /petroglyphs find   name the nearest existing panel within range, if any
  /petroglyphs demo   carve a real panel onto the nearest exposed rock face
  /petroglyphs wall   raise a sandstone face and carve one, for when you are
                      standing in open ground with no rock in reach

Set petroglyphs_log = true to have every naturally placed panel logged to
debug.txt as you explore, to confirm generation.

Put a hand on one and it answers.

Tuning
------

See settingtypes.txt, or the mod's settings page.  petroglyphs_site_threshold
controls how much of the world was ever worked; petroglyphs_chunk_chance how
dense the panels are inside it.  Both are independent, so you can have them
very rare and still tightly clustered.

The strata heights themselves come from default/ugrnd.lua; the mod reads each
rock's own texture and sounds, so retexturing a stratum retextures its glyphs.

Textures
--------

petroglyphs_glyph_NN.png are white masks with an alpha channel, recoloured per
rock at load time with [colorize.  Glyphs 1-7 are Neuromancer's original art,
separated from the desert stone background it was drawn over
(petroglyphs_source_stone.png, kept for reference; petroglyph1-7.png are the
untouched originals).  Glyphs 8-42 were drawn for this game.

To add a design: drop in the next petroglyphs_glyph_NN.png and add its name to
petroglyphs.glyphs in init.lua, then extend the culture range it belongs to.

Have fun!
