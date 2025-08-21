-------------
-- Altitude splits of biomes

-- Basement
local basement_max = -400
local basement_min = -15000
-- Ocean
local ocean_max = -21
local ocean_min = basement_max - 2
------------
-- Beaches
local beach_max = 3
local beach_min = ocean_max - 2
-- Dunes
local dune_max = 5
local dune_min = beach_max - 2
-- Coastal forest etc.
local coastf_max = 14
local coastf_min = dune_max - 2
-- Lowland forest etc.
local lowf_max = 80
local lowf_min = coastf_max - 2
-- Highland forest etc.
local highf_max = 120
local highf_min = lowf_max - 2
-- Alpine
local alp_max = 140
local alp_min = highf_max - 2
-- High alpine
local high_alp_max = 31000
local high_alp_min = alp_max - 2

------------
-- Temp and Humidity
-- Many here for re-use and access!

-- Basement rock

-- Greywacke
local gw_heat = 50
local gw_hum  = 40
-- Schist
local sch_heat = 40
local sch_hum  = 50
-- Gneiss
local gn_heat = 10
local gn_hum  = 70
-- Granite
local gr_heat = 10
local gr_hum  = 90

-- Oceans

-- Kermadec ocean
local kerm_o_heat = 120
local kerm_o_hum  = 0
-- North eastern ocean
local n_east_o_heat = 90
local n_east_o_hum  = 50
-- West coast north ocean
local wc_nth_o_heat = 50
local wc_nth_o_hum  = 85
-- East coast north ocean
local ec_nth_o_heat = 50
local ec_nth_o_hum  = 0
-- North Cook straight
local n_cook_o_heat = 50
local n_cook_o_hum  = 50
-- South Cook straight
local s_cook_o_heat = 30
local s_cook_o_hum  = 50
-- West coast south ocean
local wc_sth_o_heat = 30
local wc_sth_o_hum  = 100
-- East coast south ocean
local ec_sth_o_heat = 15
local ec_sth_o_hum  = 5
-- Fiordland ocean
local fiord_o_heat = 0
local fiord_o_hum  = 90
-- Southern ocean
local sth_o_heat = 20
local sth_o_hum  = 70
-- Subantarctic ocean
local subant_o_heat = 0
local subant_o_hum  = 100


-- Shorelines... (from beach to dunes)

-- Normal sandy
local sandy_temp = 50
local sandy_hum  = 50
-- Shelly beach
local shelly_temp = 80
local shelly_hum  = 40
-- Gravel beach
local gravel_temp = 30
local gravel_hum = 10
-- Subantarctic shore (bare rock)
local subantartic_temp = 0
local subantartic_hum  = 100
-- Volcanic isle shore (bare rock and volcanic)
local volcanic_isle_temp = 120
local volcanic_isle_hum  = 0
-- Volcanic field (bare basaltic volcanism)
local volcanic_field_temp = 120
local volcanic_field_hum  = 48
-- Iron sands
local iron_temp = 50
local iron_hum  = 85
-- Estuary
local estuary_temp = 85
local estuary_hum  = 100
-- Southern estuary
local sth_estuary_temp = 30
local sth_estuary_hum  = 100
-- Salt marsh
local s_marsh_temp = 50
local s_marsh_hum  = 95

-- Coastal forest etc...
-- (i.e warm, subtropical ..also kauri, mangroves t,)

-- Pohutukawa
local pohutukawa_temp = 90
local pohutukawa_hum  = 50
-- Coastal scrub
local c_scrub_temp = 50
local c_scrub_hum  = 50
-- Muttonbird scrub
local muttonbird_temp = 20
local muttonbird_hum  = 70
-- Tussock (also higher alt tussock)
local tussock_temp = 15
local tussock_hum  = 5

-- Kahikatea swamp
local kahi_swamp_temp = 30
local kahi_swamp_hum  = 100
-- Raupo swamp
local raupo_swamp_temp = 50
local raupo_swamp_hum  = 145
-- Gumland
local gumland_temp = 110
local gumland_hum  = 85
-- Fen
local fen_temp = 90
local fen_hum  = 110
-- Peat bog
local peat_temp = 50
local peat_hum  = 100

---------------------
-- Lowland forests etc...
-- (Kauri uses pohutukawa).

-- Northern podocarp
local npodo_temp = 70
local npodo_hum  = 50
-- Southern podocarp
local spodo_temp = 30
local spodo_hum  = 50
-- Fiordland forest
local fiord_temp = 0
local fiord_hum  = 90
-- Kamahi
local kamahi_temp = 35
local kamahi_hum  = 100

-- Shrublands...

-- Broadleaf scrub
local bl_scrub_temp = 50
local bl_scrub_hum  = 50
-- Geothermal scrub
local geo_scrub_temp = 60
local geo_scrub_hum  = -10
-- Manuka scrub
local ma_scrub_temp = 50
local ma_scrub_hum  = 0
-- Matagouri scrub... uses tussock.

-- Highlands...

-- Pahautea forest
local pahautea_temp = 90
local pahautea_hum  = 70
-- Rangipo desert
local rangipo_temp = 90
local rangipo_hum  = 0
-- Mountain beech
local mt_beech_temp = 40
local mt_beech_hum  = 70
-- Mountain tussock
local mt_tussock_temp = 30
local mt_tussock_hum  = 30
-- Scree
local scree_temp = 10
local scree_hum  = 0
-- Alpine peat bog
local alpine_peat_temp = 50
local alpine_peat_hum  = 100

------------------------------------------------------------
-- Biome registration

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

-----------------------------
-- Mantle
-- These occassionally turn up in caves below basement rock level.

-- Cold mantle
if default_loaded then
	minetest.register_biome({
		name = "cold_mantle",
		--node_dust = "",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 10,
		node_filler = "default:gravel",
		depth_filler = 3,
		--node_stone = "default:lava_source",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "default:river_water_source",
		y_min = -31000,
		y_max = basement_min + 6000,
		heat_point = 50,
		humidity_point = 50,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "cold_mantle",
		--node_dust = "",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 10,
		node_filler = "zr_gravel:gravel",
		depth_filler = 3,
		--node_stone = "zr_lava:source",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "zr_water:river_source",
		y_min = -31000,
		y_max = basement_min + 6000,
		heat_point = 50,
		humidity_point = 50,
	})
end

-- Wet mantle
minetest.register_biome({
	name = "wet_mantle",
	--node_dust = "",
	node_top = "aotearoa:boiling_mud_source",
	depth_top = 10,
	node_filler = "aotearoa:boiling_mud_source",
	depth_filler = 3,
	--node_stone = "default:lava_source",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = -31000,
	y_max = basement_min + 3000,
	heat_point = 60,
	humidity_point = 60,
})

-- Mantle
if default_loaded then
	minetest.register_biome({
		name = "mantle",
		--node_dust = "default:lava_source",
		node_top = "default:lava_source",
		depth_top = 10,
		node_filler = "default:lava_source",
		depth_filler = 3,
		--node_stone = "default:lava_source",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "default:river_water_source",
		y_min = -31000,
		y_max = basement_min + 1500,
		heat_point = 70,
		humidity_point = 30,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "mantle",
		--node_dust = "zr_lava:source",
		node_top = "zr_lava:source",
		depth_top = 10,
		node_filler = "zr_lava:source",
		depth_filler = 3,
		--node_stone = "zr_lava:source",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "zr_water:river_source",
		y_min = -31000,
		y_max = basement_min + 1500,
		heat_point = 70,
		humidity_point = 30,
	})
end


--------------------------------------------------------------
-- Basement rocks

-- Greywacke basement
minetest.register_biome({
	name = "greywacke_basement",
	--node_dust = "",
	node_top = "aotearoa:greywacke",
	depth_top = 5,
	node_filler = "aotearoa:greywacke",
	depth_filler = 5,
	node_stone = "aotearoa:greywacke",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = -340,
	y_max = -124,
	heat_point = gw_heat,
	humidity_point = gw_hum,
})

-- Schist basement
minetest.register_biome({
	name = "schist_basement",
	--node_dust = "",
	node_top = "default:schist",
	depth_top = 5,
	node_filler = "default:schist",
	depth_filler = 5,
	node_stone = "default:schist",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = -540,
	y_max = -240,
	heat_point = sch_heat,
	humidity_point = sch_hum,
})

-- Gneiss basement
minetest.register_biome({
	name = "gneiss_basement",
	--node_dust = "",
	node_top = "default:gneiss",
	depth_top = 5,
	node_filler = "default:gneiss",
	depth_filler = 5,
	node_stone = "default:gneiss",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = -1224,
	y_max = -750,
	heat_point = gn_heat,
	humidity_point = gn_hum,
})

-- Granite basement
minetest.register_biome({
	name = "granite_basement",
	--node_dust = "",
	node_top = "default:granite",
	depth_top = 5,
	node_filler = "default:granite",
	depth_filler = 5,
	node_stone = "default:granite",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = -1224,
	y_max = basement_max,
	heat_point = gr_heat,
	humidity_point = gr_hum,
})


------------------------------------------------------------
-- Marine
-- This also controls the shallow rocks.

-- Kermadec ocean
if default_loaded then
	minetest.register_biome({
		name = "kermadec_ocean",
		--node_dust = "",
		node_top = "biomes_island:seabed",
		depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 2,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "default:river_water_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = kerm_o_heat,
		humidity_point = kerm_o_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "kermadec_ocean",
		--node_dust = "",
		node_top = "default:sandstone",
		depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 2,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		--node_river_water = "zr_water:river_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = kerm_o_heat,
		humidity_point = kerm_o_hum,
	})
end

-- North Cook straight
minetest.register_biome({
	name = "north_cook_straight",
	--node_dust = "",
	node_top = "default:mud",
	depth_top = 1,
	node_filler = "default:mud",
	depth_filler = 3,
	node_stone = "aotearoa:greywacke",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		--depth_water_top = ,
	--node_water = "",
	--node_river_water = "default:river_water_source",
	y_min = ocean_min,
	y_max = ocean_max,
	heat_point = n_cook_o_heat,
	humidity_point = n_cook_o_hum,
})

-- South Cook straight
if default_loaded then
	minetest.register_biome({
		name = "south_cook_straight",
		--node_dust = "",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = s_cook_o_heat,
		humidity_point = s_cook_o_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "south_cook_straight",
		--node_dust = "",
		node_top = "zr_sand:sand",
		depth_top = 1,
		node_filler = "zr_sand:sand",
		depth_filler = 3,
		node_stone = "default:schist",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		--node_river_water = "zr_water:river_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = s_cook_o_heat,
		humidity_point = s_cook_o_hum,
	})
end

-- Fiordland ocean
minetest.register_biome({
	name = "fiordland_ocean",
	--node_dust = "",
	node_top = "default:mud",
	depth_top = 1,
	node_filler = "default:mud",
	depth_filler = 2,
	node_stone = "default:gneiss",
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		--node_river_water = "default:river_water_source",
	y_min = ocean_min,
	y_max = ocean_max,
	heat_point = fiord_o_heat,
	humidity_point = fiord_o_hum,
})

-- Subantarctic ocean
if default_loaded then
	minetest.register_biome({
		name = "subantarctic_ocean",
		--node_dust = "",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = subant_o_heat,
		humidity_point = subant_o_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "subantarctic_ocean",
		--node_dust = "",
		node_top = "zr_gravel:gravel",
		depth_top = 1,
		node_filler = "zr_gravel:gravel",
		depth_filler = 1,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		y_min = ocean_min,
		y_max = ocean_max,
		heat_point = subant_o_heat,
		humidity_point = subant_o_hum,
	})
end


----------------------------------------------------
-- Seashore

-- Sandy beach
if default_loaded then
	minetest.register_biome({
		name = "sandy_beach",
		--node_dust = "",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "aotearoa:pale_sandstone",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = sandy_temp,
		humidity_point = sandy_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "sandy_beach",
		--node_dust = "",
		node_top = "zr_sand:sand",
		depth_top = 1,
		node_filler = "zr_sand:sand",
		depth_filler = 3,
		node_stone = "aotearoa:pale_sandstone",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = sandy_temp,
		humidity_point = sandy_hum,
	})
end

-- Subantarctic shore
if default_loaded then
	minetest.register_biome({
		name = "subantarctic_shore",
		--node_dust = "default:snow",
		--node_top = "",
		--depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 4,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = beach_min/2,
		y_max = beach_max,
		heat_point = subantartic_temp,
		humidity_point = subantartic_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "subantarctic_shore",
		--node_dust = "zr_snow:snow",
		--node_top = "",
		--depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 4,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = beach_min/2,
		y_max = beach_max,
		heat_point = subantartic_temp,
		humidity_point = subantartic_hum,
	})
end

-- Volcanic isle shore
if default_loaded then
	minetest.register_biome({
		name = "volcanic_isle_shore",
		--node_dust = "default:gravel",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = volcanic_isle_temp,
		humidity_point = volcanic_isle_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "volcanic_isle_shore",
		--node_dust = "default:gravel",
		node_top = "zr_gravel:gravel",
		depth_top = 1,
		node_filler = "zr_gravel:gravel",
		depth_filler = 1,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = volcanic_isle_temp,
		humidity_point = volcanic_isle_hum,
	})
end

-- Volcanic field
minetest.register_biome({
	name = "volcanic_field",
	--node_dust = "default:gravel",
	node_top = "aotearoa:scoria",
	depth_top = 1,
	node_filler = "aotearoa:scoria",
	depth_filler = 8,
	node_stone = "default:obsidian",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	node_river_water = "default:obsidian",
	node_riverbed = "default:obsidian",
	depth_riverbed = 5,
	y_min = beach_min,
	y_max = lowf_max/2,
	heat_point = volcanic_field_temp,
	humidity_point = volcanic_field_hum,
})

-- Iron sand
if default_loaded then
	minetest.register_biome({
		name = "iron_sand_beach",
		--node_dust = "",
		node_top = "aotearoa:iron_sand",
		depth_top = 3,
		node_filler = "aotearoa:iron_sand",
		depth_filler = 3,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 1,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = iron_temp,
		humidity_point = iron_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "iron_sand_beach",
		--node_dust = "",
		node_top = "aotearoa:iron_sand",
		depth_top = 3,
		node_filler = "aotearoa:iron_sand",
		depth_filler = 3,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 1,
		y_min = beach_min,
		y_max = beach_max,
		heat_point = iron_temp,
		humidity_point = iron_hum,
	})
end


---------------
-- Dunelands

-- Pohutukawa dunes
if default_loaded then
	minetest.register_biome({
		name = "pohutukawa_dunes",
		--node_dust = "",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_stone = "aotearoa:pale_sandstone",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = dune_max,
		heat_point = pohutukawa_temp,
		humidity_point = pohutukawa_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "pohutukawa_dunes",
		--node_dust = "",
		node_top = "zr_sand:sand",
		depth_top = 1,
		node_filler = "zr_sand:sand",
		depth_filler = 3,
		node_stone = "aotearoa:pale_sandstone",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = dune_max,
		heat_point = pohutukawa_temp,
		humidity_point = pohutukawa_hum,
	})
end

-- Iron sand dunes
if default_loaded then
	minetest.register_biome({
		name = "iron_sand_dunes",
		--node_dust = "",
		node_top = "aotearoa:iron_sand",
		depth_top = 3,
		node_filler = "aotearoa:iron_sand",
		depth_filler = 3,
		node_stone = "aotearoa:grey_sandstone",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = dune_max,
		heat_point = iron_temp,
		humidity_point = iron_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "iron_sand_dunes",
		--node_dust = "",
		node_top = "aotearoa:iron_sand",
		depth_top = 3,
		node_filler = "aotearoa:iron_sand",
		depth_filler = 3,
		node_stone = "aotearoa:grey_sandstone",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = dune_max,
		heat_point = iron_temp,
		humidity_point = iron_hum,
	})
end

-- Subantarctic coast
if default_loaded then
	minetest.register_biome({
		name = "subantarctic_coast",
		node_dust = "default:snow",
		node_top = "aotearoa:dirt_with_moss",
		depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 4,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = coastf_max,
		heat_point = subantartic_temp,
		humidity_point = subantartic_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "subantarctic_coast",
		node_dust = "zr_snow:snow",
		node_top = "aotearoa:dirt_with_moss",
		depth_top = 1,
		node_filler = "default:sandstone",
		depth_filler = 4,
		node_stone = "default:granite",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = coastf_max,
		heat_point = subantartic_temp,
		humidity_point = subantartic_hum,
	})
end

-- White Island (volcanic dunes)
if default_loaded then
	minetest.register_biome({
		name = "white_island",
		--node_dust = "",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 1,
		node_filler = "aotearoa:volcanic_sand",
		depth_filler = 5,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = lowf_max/2,
		heat_point = volcanic_isle_temp,
		humidity_point = volcanic_isle_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "white_island",
		--node_dust = "",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 1,
		node_filler = "aotearoa:volcanic_sand",
		depth_filler = 5,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = dune_min,
		y_max = lowf_max/2,
		heat_point = volcanic_isle_temp,
		humidity_point = volcanic_isle_hum,
	})
end


------------------------------------------
-- Coastal Forests

-- Pohutukawa forest
if default_loaded then
	minetest.register_biome({
		name = "pohutukawa_forest",
		--node_dust = "",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 2,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = pohutukawa_temp,
		humidity_point = pohutukawa_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "pohutukawa_forest",
		--node_dust = "",
		node_top = "zr_dirt:litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 2,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:river_sand",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = pohutukawa_temp,
		humidity_point = pohutukawa_hum,
	})
end

-- Muttonbird scrub
if default_loaded then
	minetest.register_biome({
		name = "muttonbird_scrub",
		--node_dust = "",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 2,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = muttonbird_temp,
		humidity_point = muttonbird_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "muttonbird_scrub",
		--node_dust = "",
		node_top = "zr_dirt:litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 2,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = muttonbird_temp,
		humidity_point = muttonbird_hum,
	})
end
------------------------------
-- Wetlands

-- Raupo swamp
if default_loaded then
	minetest.register_biome({
		name = "raupo_swamp",
		--node_dust = "",
		node_top = "aotearoa:mud_sinking",
		depth_top = 1,
		node_filler = "default:mud",
		depth_filler = 3,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "default:mud",
		depth_riverbed = 1,
		y_min = coastf_min + 2,
		y_max = lowf_max/2,
		heat_point = 30,
		humidity_point = raupo_swamp_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "raupo_swamp",
		--node_dust = "",
		node_top = "aotearoa:mud_sinking",
		depth_top = 1,
		node_filler = "default:mud",
		depth_filler = 3,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "default:mud",
		depth_riverbed = 1,
		y_min = coastf_min + 2,
		y_max = lowf_max/2,
		heat_point = 30,
		humidity_point = raupo_swamp_hum,
	})
end

-- Gumland
if default_loaded then
	minetest.register_biome({
		name = "gumland",
		--node_dust = "",
		node_top = "aotearoa:gumland_soil",
		depth_top = 1,
		node_filler = "aotearoa:gumland_hardpan",
		depth_filler = 4,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "default:silt",
		depth_riverbed = 3,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = 100,
		humidity_point = gumland_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "gumland",
		--node_dust = "",
		node_top = "aotearoa:gumland_soil",
		depth_top = 1,
		node_filler = "aotearoa:gumland_hardpan",
		depth_filler = 4,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "default:silt",
		depth_riverbed = 3,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = 100,
		humidity_point = gumland_hum,
	})
end

-- Peat bog
if default_loaded then
	minetest.register_biome({
		name = "peat_bog",
		--node_dust = "",
		node_top = "aotearoa:restiad_peat",
		depth_top = 1,
		node_filler = "aotearoa:peat",
		depth_filler = 15,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:peat",
		depth_riverbed = 4,
		y_min = lowf_min,
		y_max = lowf_max/2,
		heat_point = peat_temp,
		humidity_point = peat_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "peat_bog",
		--node_dust = "",
		node_top = "aotearoa:restiad_peat",
		depth_top = 1,
		node_filler = "aotearoa:peat",
		depth_filler = 15,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:peat",
		depth_riverbed = 4,
		y_min = lowf_min,
		y_max = lowf_max/2,
		heat_point = peat_temp,
		humidity_point = peat_hum,
	})
end


-- Tawa forest
if default_loaded then
	minetest.register_biome({
		name = "tawa_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_dark_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 3,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = npodo_temp,
		humidity_point = npodo_hum + 15,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "tawa_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_dark_litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 3,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = npodo_temp,
		humidity_point = npodo_hum + 15,
	})
end

-- Maire forest
if default_loaded then
	minetest.register_biome({
		name = "maire_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_dry_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 3,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = npodo_temp,
		humidity_point = npodo_hum - 15,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "maire_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_dry_litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 3,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = npodo_temp,
		humidity_point = npodo_hum - 15,
	})
end

-------------------
-- Fiordland forest
if default_loaded then
	minetest.register_biome({
		name = "fiordland_forest",
		node_dust = "default:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = fiord_temp,
		humidity_point = fiord_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "fiordland_forest",
		node_dust = "zr_snow:snow",
		node_top = "default:dirt_with_snow",
		depth_top = 1,
		node_filler = "zr_gravel:gravel",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = fiord_temp,
		humidity_point = fiord_hum,
	})
end

-- Kamahi forest
if default_loaded then
	minetest.register_biome({
		name = "kamahi_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_moss",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 3,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_max/2,
		y_max = lowf_max,
		heat_point = kamahi_temp,
		humidity_point = kamahi_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "kamahi_forest",
		--node_dust = "",
		node_top = "aotearoa:dirt_with_moss",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 3,
		node_water_top = "default:river_water_source",
		--depth_water_top = ,
		node_water = "default:river_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_max/2,
		y_max = lowf_max,
		heat_point = kamahi_temp,
		humidity_point = kamahi_hum,
	})
end


------------------------------------
-- Shrublands
-- Lowland

-- Broadleaf scrub
if default_loaded then
	minetest.register_biome({
		name = "broadleaf_scrub",
		--node_dust = "",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 4,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = (lowf_max/4) -4,
		y_max = lowf_max/2,
		heat_point = bl_scrub_temp,
		humidity_point = bl_scrub_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "broadleaf_scrub",
		--node_dust = "",
		node_top = "zr_dirt:litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 4,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = (lowf_max/4) -4,
		y_max = lowf_max/2,
		heat_point = bl_scrub_temp,
		humidity_point = bl_scrub_hum,
	})
end

-- Geothermal scrub
if default_loaded then
	minetest.register_biome({
		name = "geothermal_scrub",
		--node_dust = "",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 4,
		node_stone = "aotearoa:pale_sandstone",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max/3,
		heat_point = geo_scrub_temp,
		humidity_point = geo_scrub_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "geothermal_scrub",
		--node_dust = "",
		node_top = "zr_dirt:litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 4,
		node_stone = "aotearoa:pale_sandstone",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max/3,
		heat_point = geo_scrub_temp,
		humidity_point = geo_scrub_hum,
	})
end

-- Manuka scrub
if default_loaded then
	minetest.register_biome({
		name = "manuka_scrub",
		--node_dust = "",
		node_top = "default:dirt_with_rainforest_litter",
		depth_top = 1,
		node_filler = "default:clay",
		depth_filler = 4,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = ma_scrub_temp,
		humidity_point = ma_scrub_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "manuka_scrub",
		--node_dust = "",
		node_top = "zr_dirt:litter",
		depth_top = 1,
		node_filler = "zr_clay:clay",
		depth_filler = 4,
		node_water_top = "default:liquid_mud_source",
		--depth_water_top = ,
		node_water = "default:liquid_mud_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 2,
		y_min = lowf_min,
		y_max = lowf_max,
		heat_point = ma_scrub_temp,
		humidity_point = ma_scrub_hum,
	})
end

--------------------------------
-- Highland

-- Mountain tussock
if default_loaded then
	minetest.register_biome({
		name = "tussock",
		node_dust = "default:snow",
		node_top = "default:dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 4,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = tussock_temp,
		humidity_point = tussock_hum,
		
	})
	
			minetest.register_biome({
		name = "prairie",
		node_top = "default:dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 4,
		node_water_top = "sailing:river_water_source",
		--depth_water_top = ,
		node_water = "sailing:river_water_source",
		node_river_water = "default:shallow_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		node_dungeon = "default:schistbrick",
		node_dungeon_alt = "default:shobblebrick",
		heat_point = 65,
		humidity_point = 40,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "tussock",
		node_dust = "default:snow",
		node_top = "default:dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dirt",
		depth_filler = 4,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = coastf_min,
		y_max = coastf_max,
		heat_point = tussock_temp,
		humidity_point = tussock_hum,
	})
		

end


-- Scree
if default_loaded then
	minetest.register_biome({
		name = "scree",
		--node_dust = "",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:silt",
		depth_filler = 1,
		node_stone = "aotearoa:greywacke",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = highf_min,
		y_max = alp_max,
		heat_point = scree_temp,
		humidity_point = scree_hum,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "scree",
		--node_dust = "",
		node_top = "zr_gravel:gravel",
		depth_top = 1,
		node_filler = "default:silt",
		depth_filler = 1,
		node_stone = "aotearoa:greywacke",
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = highf_min,
		y_max = alp_max,
		heat_point = scree_temp,
		humidity_point = scree_hum,
	})
end


----------------
-- Alpine
-- On the way from forest to icy death.

-- Fellfield
if default_loaded then
	minetest.register_biome({
		name = "fellfield",
		node_dust = "default:snow",
		--node_top = "",
		--depth_top = 1,
		node_filler = "default:schist",
		depth_filler = 4,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = alp_min,
		y_max = alp_max,
		heat_point = 50,
		humidity_point = 50,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "fellfield",
		node_dust = "zr_snow:snow",
		--node_top = "",
		--depth_top = 1,
		node_filler = "default:schist",
		depth_filler = 4,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = alp_min,
		y_max = alp_max,
		heat_point = 50,
		humidity_point = 50,
	})
end


----------------
-- High Alpine
-- Permanent snow and ice.

-- Snow (and ice...)
if default_loaded then
	minetest.register_biome({
		name = "alpine_snow",
		node_dust = "default:snow",
		node_top = "default:snowblock",
		depth_top = 5,
		node_filler = "default:ice",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = high_alp_min,
		y_max = high_alp_max,
		heat_point = 50,
		humidity_point = 50,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "alpine_snow",
		node_dust = "zr_snow:snow",
		node_top = "zr_snow:block",
		depth_top = 5,
		node_filler = "zr_snow:ice",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:gravel_with_algae",
		depth_riverbed = 1,
		y_min = high_alp_min,
		y_max = high_alp_max,
		heat_point = 50,
		humidity_point = 50,
	})
end

-- Glacier
if default_loaded then
	minetest.register_biome({
		name = "glacier",
		node_dust = "default:snow",
		node_top = "default:ice",
		depth_top = 10,
		node_filler = "default:ice",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "default:river_water_source",
		node_riverbed = "default:ice",
		depth_riverbed = 1,
		y_min = alp_min + 4,
		y_max = high_alp_max,
		heat_point = 0,
		humidity_point = 100,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "glacier",
		node_dust = "zr_snow:snow",
		node_top = "zr_snow:ice",
		depth_top = 10,
		node_filler = "zr_snow:ice",
		depth_filler = 1,
		node_water_top = "sailing:shallow_water_source",
		--depth_water_top = ,
		node_water = "sailing:shallow_water_source",
		node_river_water = "zr_water:river_source",
		node_riverbed = "zr_snow:ice",
		depth_riverbed = 1,
		y_min = alp_min + 4,
		y_max = high_alp_max,
		heat_point = 0,
		humidity_point = 100,
	})
end

-- Volcano
if default_loaded then
	minetest.register_biome({
		name = "volcano",
		node_dust = "default:snow",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 2,
		node_filler = "default:gravel",
		depth_filler = 5,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "default:river_water_source",
		node_riverbed = "aotearoa:volcanic_sand",
		depth_riverbed = 3,
		y_min = alp_min,
		y_max = high_alp_max,
		heat_point = 100,
		humidity_point = 0,
	})
elseif zero_loaded then
	minetest.register_biome({
		name = "volcano",
		node_dust = "zr_snow:snow",
		node_top = "aotearoa:volcanic_sand",
		depth_top = 2,
		node_filler = "zr_gravel:gravel",
		depth_filler = 5,
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		node_river_water = "zr_water:river_source",
		node_riverbed = "aotearoa:volcanic_sand",
		depth_riverbed = 3,
		y_min = alp_min,
		y_max = high_alp_max,
		heat_point = 100,
		humidity_point = 0,
	})
end
