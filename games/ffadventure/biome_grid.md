# FFAdventure Biome Grid Reference

Heat (0–100) = temperature axis, cold → hot.
Humidity (0–100) = moisture axis, dry → wet.
Biomes are assigned by nearest-neighbour (Voronoi) in heat × humidity space.
Adding a new biome: place its point at least ~8 units from its nearest neighbour
to give it a meaningful territory.

---

## Active Surface Biomes — Coordinates After Remapping

| Biome | Mod | Heat | Humid | y_min | y_max | Notes |
|-------|-----|------|-------|-------|-------|-------|
| **ice_land** | Variety | 0 | 100 | 1 | 31000 | Glacial ice cap, maximum cold+wet |
| **icesheet** | default | 0 | 73 | 2 | 31000 | Ice sheet, cold+humid |
| **tundra_highland** | default | 5 | 40 | 47 | 31000 | High tundra plateau |
| **tundra** | default | 5 | 40 | 2 | 46 | Permafrost tundra surface |
| **tundra_beach** | default | 5 | 40 | -3 | 1 | Tundra shore |
| **frost_land** | Variety | 6 | 91 | 4 | 31000 | Permafrost bog, very cold+wet |
| **mountain** | Variety | 8 | 40 | 40 | 31000 | High cold mountain, y_min=40 restricts it |
| **awuuwa_biomes_shield** | awuuwa_biomes | 8 | 50 | 9 | 160 | Boreal shield (Canadian/Scandinavian) |
| **arctic** | awuuwa_biomes | 10 | 53 | 2 | 40 | Arctic coastal tundra |
| **naturalbiomes:alpine** | naturalbiomes | 15 | 55 | 30 | 31000 | Alpine mountain meadow |
| **snowy_grassland** | default | 20 | 35 | 2 | 31000 | Cold dry grassland |
| **balsa_woods** (fungi forest) | awuuwa_biomes | 20 | 60 | 5 | 40 | Cold boreal fungi/mushroom forest |
| **taiga** | default | 25 | 70 | 2 | 31000 | Cold boreal forest (spruce/pine) |
| **awuuwa_biomes_wetlands** | awuuwa_biomes | 35 | 80 | 1 | 31 | Cool-temperate bog/wetland |
| **livingfloatlands:coldsteppe** | livingfloatlands | 36 | 22 | 1 | 31000 | Cold dry steppe/grassland |
| **cherry** | Variety | 40 | 45 | 1 | 31000 | Cool-temperate cherry blossom forest |
| **cold_desert** | default | 40 | 0 | 2 | 31000 | Cold dry desert (Gobi, Patagonia) |
| **coniferous_forest** | default | 42 | 70 | 2 | 31000 | Cool coniferous (Douglas fir, larch) |
| **awuuwa_biomes_prairie** | awuuwa_biomes | 45 | 25 | 1 | 40 | Dry temperate prairie/steppe |
| **livingfloatlands:coldgiantforest** | livingfloatlands | 46 | 57 | 1 | 31000 | Cool giant conifer forest |
| **naturalbiomes:heath** | naturalbiomes | 45 | 88 | 0 | 50 | Wet moorland (UK/Irish heathland) |
| **grassland** | default | 50 | 35 | 2 | 31000 | Temperate grassland |
| **livingfloatlands:giantforest** | livingfloatlands | 52 | 63 | 1 | 31000 | Warm giant deciduous forest |
| **redwood_forest** | redw | 52 | 96 | 1 | 31000 | Coastal fog forest (extreme wet coast) |
| **wildflowers** | wildflower_fields | 54 | 43 | 6 | 31000 | Temperate wildflower meadow |
| **naturalbiomes:alderswamp** | naturalbiomes | 55 | 70 | 0 | 5 | Temperate riparian/alder swamp |
| **kudzu** | kudzu | 56 | 82 | -31000 | 31000 | Subtropical humid vine forest |
| **meadow** | Variety | 57 | 28 | 1 | 31000 | Warm dry meadow |
| **Variety:redwood** | Variety | 59 | 77 | 1 | 31000 | Pacific coast redwood grove |
| **deciduous_forest** | default | 60 | 68 | 2 | 31000 | Temperate deciduous (oak, maple) |
| **grove** | default | 65 | 55 | 2 | 31000 | Warm temperate mixed grove |
| **sandstone_desert** | default | 65 | 3 | 4 | 31000 | Warm sandstone desert (Colorado Plateau) |
| **sakura_forest** | default | 65 | 70 | 1 | 165 | Japanese sakura/cherry blossom forest |
| **naturalbiomes:bushland** | naturalbiomes | 68 | 83 | 1 | 500 | Warm wet bushland (Australian wet sclerophyll) |
| **cypress** | Variety | 70 | 80 | 1 | 32 | Coastal cypress (y_max=32, sea-level only) |
| **autumn_forest** | Variety | 71 | 84 | 6 | 31000 | Warm wet autumn/mixed hardwood forest |
| **tropical_rainforest** | Variety | 80 | 87 | 1 | 31000 | Tropical rainforest (hot+wet) |
| **naturalbiomes:mediterranean** | naturalbiomes | 78 | 55 | 5 | 100 | Mediterranean scrub forest |
| **swamp** | swamp | 80 | 98 | -20 | 10 | Tropical mangrove/cypress swamp |
| **naturalbiomes:outback** | naturalbiomes | 82 | 20 | 1 | 60 | Hot semi-arid scrubland (Australian outback); occasional red sand patches from badlands |
| **badlands** | badlands | 83 | 2 | 30 | 31000 | Hot ultra-dry badlands highland |
| **naturalbiomes:palmbeach** | naturalbiomes | 86 | 78 | -1 | 5 | Tropical palm beach (shore biome) |
| **naturalbiomes:wetsavanna** | naturalbiomes | 86 | 60 | 5 | 31000 | Tropical wet savanna |
| **savanna** | default | 88 | 42 | 2 | 31000 | African-style dry savanna |
| **bamboo_forest** | Variety | 87 | 73 | 5 | 31000 | Subtropical bamboo grove |
| **bambooforest** | naturalbiomes | 89 | 82 | 5 | 31000 | Tropical bamboo forest (denser) |
| **rainforest** | default | 90 | 65 | 2 | 31000 | Tropical rainforest (main default) |
| **desert** | default | 92 | 16 | 2 | 31000 | Hot sandy desert |
| **darkforest** | Variety | 95 | 97 | 1 | 31000 | Ultra-hot ultra-wet dark canopy jungle |
| **livingfloatlands:paleojungle** | livingfloatlands | 97 | 58 | 1 | 31000 | Hot prehistoric jungle |
| **livingfloatlands:paleodesert** | livingfloatlands | 98 | 10 | 1 | 31000 | Hot prehistoric barren desert |

---

## Floatland Biomes (now in regular terrain — y_min = 1)

These were originally restricted to y ≥ 1000. They now appear in regular terrain.
Heat/humidity were adjusted to avoid Voronoi conflicts with adjacent biomes.

| Biome | Mod | Heat | Humid | y_min | y_max | Notes |
|-------|-----|------|-------|-------|-------|-------|
| **livingfloatlands:coldsteppe** | livingfloatlands | 36 | 22 | 1 | 31000 | Cold dry steppe; adjusted from (38,27) to clear prairie (45,25) |
| **livingfloatlands:coldgiantforest** | livingfloatlands | 46 | 57 | 1 | 31000 | Cool giant conifer; adjusted from (47,66) to clear coniferous_forest (42,70) |
| **livingfloatlands:giantforest** | livingfloatlands | 52 | 63 | 1 | 31000 | Warm giant deciduous; adjusted from (52,71) to clear alderswamp (55,70) |
| **livingfloatlands:paleojungle** | livingfloatlands | 97 | 58 | 1 | 31000 | Hot prehistoric jungle; adjusted from (95,63) to clear rainforest (90,65) |
| **livingfloatlands:paleodesert** | livingfloatlands | 98 | 10 | 1 | 31000 | Hot prehistoric desert; adjusted from (96,15) to clear desert (92,16) |

---

## Water / Ocean / Underground Biomes (shared heat+humid with surface parent)

These share the same heat/humidity point as their surface parent and are
separated by y-range only. No separate Voronoi territory.

| Biome | Parent surface biome | y range |
|-------|---------------------|---------|
| icesheet_ocean / icesheet_under | icesheet | ocean / cave |
| tundra_ocean / tundra_under | tundra | ocean / cave |
| taiga_ocean / taiga_under | taiga | ocean / cave |
| snowy_grassland_ocean / _under | snowy_grassland | ocean / cave |
| coniferous_forest_ocean / _under | coniferous_forest | ocean / cave |
| deciduous_forest_ocean / _shore / _under | deciduous_forest | ocean / shore / cave |
| grassland_ocean / _dunes / _under | grassland | ocean / dunes / cave |
| sandstone_desert_ocean / _under | sandstone_desert | ocean / cave |
| cold_desert_ocean / _under | cold_desert | ocean / cave |
| sakura_forest_ocean / _shore / _under | sakura_forest | ocean / shore / cave |
| desert_ocean / _under | desert | ocean / cave |
| savanna_ocean / _shore / _under | savanna | ocean / shore / cave |
| rainforest_ocean / _swamp / _under | rainforest | ocean / swamp / cave |
| swamp_ocean / swamp_under | swamp | ocean / deep cave |

---

## Aotearoa Biomes (NZ-specific, uses high heat values for volcanic zones)

Aotearoa registers ~70 NZ-flavoured biomes across all y strata using
its own internal heat/humidity variables (see `aotearoa/mapgen.lua`).
Key ranges: volcanic (heat 110–120), subtropical (heat 85–110),
temperate (heat 30–85), subantarctic (heat 0–20).
These do not conflict with global biomes because aotearoa is designed
as a standalone island continent mod with its own coordinate design.

---

## Heat × Humidity Grid (rough spatial layout)

```
Humid  ← DRY ──────────────────────── WET →
 ↑     0    10   20   30   40   50   60   70   80   90   100
HOT
 95    -    -    -    -    -    -    -    -    -    -    DRK
 92    -    -    -    -    -    -    -    -    -    DST   -
 90    -    -    -    -    -    -    -    RNF   -    -    -
 88    -    -    -    -    -    -    -    -    NMB   -    -
 87    -    -    -    -    -    -    -    BMV   -    -    -
 87    -    -    -    -    -    -    TRF   -    -    -    -
 86    -    -    -    -    -    -    -    -    WSV  PLM   -
 83    -    BDL   -    -    -    -    -    -    -    -    -
 82    -    -    -    -    -    -    -    -    -    -    -
 80    -    -    -    -    -    -    -    -    -    -    SWP
 78    -    -    -    -    -    -    -    -    MED   -    -
WARM
 77    -    -    -    -    -    -    -    BMD   -    -    -
 73    -    -    -    -    -    -    -    -    -    -    -
 70    -    -    -    -    -    -    -    AUT   -    -    -
 68    -    -    -    -    -    -    -    -    BSH   -    -
 65    -    -    -    -    -    -    -    -    -    -    -
 60    -    -    -    -    -    -    -    -    -    -    -
TEMP
 55    -    -    -    -    -    MED   -    GRV  SKR   -    -
 43    -    -    -    -    CHR   -    WLD   -    -    -    -
 42    -    -    -    -    -    -    -    -    SAV   -    -
 40    -    TND  MTN  SHD   -    -    -    -    -    -    -
 35    -    -    SGR   -    PRA  GRS   -    -    -    -    -
 30    -    -    -    -    -    -    -    -    OUT   -    -
 28    -    -    -    -    -    -    MEA   -    -    -    -
COOL
 25    -    -    -    -    PRA   -    -    -    -    -    -
 20    -    -    -    -    -    -    -    -    -    -    -
  3    -    -    -    -    CDT   -    SND   -    BDL   -    -
COLD
  0    ICE  -    -    -    CDT   -    SND   -    BDL  DST   -
```

Key: ICE=ice_land, ICE2=icesheet, TND=tundra, FRS=frost_land,
     MTN=mountain, SHD=shield, ARC=arctic, ALP=alpine, SGR=snowy_grassland,
     BAL=balsa_woods, TAG=taiga, WTL=wetlands, CHR=cherry, CDT=cold_desert,
     CNF=coniferous_forest, PRA=prairie, HTH=heath, GRS=grassland,
     RFW=redwood_forest(redw), WLD=wildflowers, ALD=alderswamp,
     KDZ=kudzu, MEA=meadow, RDW=redwood(Variety), DCF=deciduous_forest,
     GRV=grove, SND=sandstone_desert, SKR=sakura_forest, BSH=bushland,
     CYP=cypress, AUT=autumn_forest, TRF=tropical_rainforest(Variety),
     MED=mediterranean, SWP=swamp, OUT=outback, BDL=badlands,
     PLM=palmbeach, WSV=wetsavanna, SAV=savanna, BMV=bamboo_forest(Variety),
     NMB=bambooforest(naturalbiomes), RNF=rainforest, DST=desert,
     DRK=darkforest

---

## Rules for Adding New Biomes

1. **Minimum separation**: place at least 8–10 units from any existing point
   (Euclidean distance in heat×humidity space) to guarantee visible territory.
2. **Family pattern**: for surface biomes add `_ocean` (y<-1), `_shore` or
   `_beach` (y-3 to y1), and `_under` (y<-256) variants at the same heat/humid
   point with appropriate y ranges — this fills caves/oceans seamlessly.
3. **Underground/cave biomes**: use extreme y_min (≤ -256). Heat/humidity still
   determines which underground biome appears in which column of the world.
4. **Floatland biomes**: use y_min ≥ 1000. Can share heat/humid with surface
   biomes since y-range separation prevents conflicts.
5. **Water biomes** (marsh, ocean floors): use y_max ≤ -1.
6. **Restricted biomes** (like palmbeach y_max=5): these only appear near
   specific elevations — good for shorelines, alpine, etc.
7. **Humidity > 100 or < 0**: valid Lua numbers but place biome outside the
   normal 0–100 Voronoi space. Avoid — use 0–99 instead.
