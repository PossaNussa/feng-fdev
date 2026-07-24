Mapgen v8 AIO package – make v8 first-class & default (v7 retained)
===================================================================

This bundle contains complete v8 sources and registration so "v8" is a normal
engine mapgen. v7 remains selectable for compatibility.

Files:
- src/mapgen/mapgen_v8.h
- src/mapgen/mapgen_v8.cpp
- src/mapgen/mapgen_register_v8.cpp     <- core registration
- builtin/settingtypes_mgv8.conf        <- add to your settingtypes UI

Install:
1) Copy files into your tree keeping the same paths.
2) Ensure src/mapgen/mapgen_register_v8.cpp is part of your build (CMake source list).
3) Append builtin/settingtypes_mgv8.conf to builtin/settingtypes.txt (or equivalent).

Build:
  git clean -xfd
  cmake -B build -S . -DRUN_IN_PLACE=1 -DBUILD_CLIENT=1 -DBUILD_SERVER=1 -DCMAKE_BUILD_TYPE=Release
  cmake --build build -j$(nproc)

Make v8 the default (non-breaking):
- Ship your config with:
    mg_name = v8
    mgv8_spflags = mountains, rivers, volcanoes
  Users can still select mg_name = v7 to get classic generation.

Notes:
- No external "shim" behavior: v8 is registered as a first-class mapgen name.
- The constructor passes MAPGEN_V7 to MapgenBasic only to satisfy base API;
  selection is controlled by the factory registration above.
- The code hardens caves/rivers/volcanoes to avoid the join-time segfault seen earlier.
