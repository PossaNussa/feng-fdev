CHANGELOG
=========

## `v1.1.0` (2026-02-21)
- Moved mapgen to separate threads, which speeds up game and reduces lag
- Added a margin (ocean) near the border of the map
- Reworked river shape a bit
- Various optimizations at pre-generation step
- Use only the last digits of map seed, to avoid converting 64-bit integers to double

## `v1.0.2` (2022-01-10)
- Use builtin logging system and appropriate loglevels
- Skip empty chunks, when generating high above ground (~20% speedup)
- Minor optimizations (turning global variables to local...)

## `v1.0.1` (2021-09-14)
- Automatically switch to `singlenode` mapgen at init time

## `v1.0` (2021-08-01)
- Rewritten pregen code (terrainlib) in pure Lua
- Optimized grid loading
- Load grid nodes on request by default
- Changed river width settings
- Added map size in settings
- Added logs
