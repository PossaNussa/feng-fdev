Drop-in fix for MAPGEN_V8 registration compile errors.

Install:
  1) Backup your current file:
       cp src/mapgen/mapgen.h src/mapgen/mapgen.h.bak
  2) Unzip this archive at the repo root so it overwrites:
       src/mapgen/mapgen.h

What it does:
  - Adds 'MAPGEN_V8' to the MapgenType enum so it matches the factory in mapgen.cpp.
  - Keeps all other content identical to your (15) header.

After that, build again:
       gmake -j$(nproc)
