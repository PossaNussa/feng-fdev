FlashEng Update — Colored Lighting (tint), Particle Cap, Settings

Files to overwrite in your repo (relative to repo root):
- src/nodedef.h
- src/nodedef.cpp
- src/script/common/c_content.cpp
- src/defaultsettings.cpp
- builtin/settingtypes.txt
- src/client/particles.cpp
- src/client/mapblock_mesh.cpp

Notes:
- Colored lighting tint is enabled by default and only applies in the LOD shell (beyond 'viewing_range' up to 'viewing_range + lod_distance').
- Mods can optionally set 'light_colour = "#rrggbb"' (or 'light_color') in nodedefs of light-emitting nodes.
- Particle cap is controlled by 'max_particles' in the Settings UI.
- New settings were added to 'builtin/settingtypes.txt' and defaults to 'src/defaultsettings.cpp'.

Drop these files into your repo, rebuild, and test.