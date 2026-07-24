-----------------------------------------------------------------------------
-- configuration values which you can adjust according to your liking
-----------------------------------------------------------------------------
-- set to false if you do not want to have any villages spawning
mg_villages.ENABLE_VILLAGES = true;

-- generate one random building for each mg_villages.INVERSE_HOUSE_DENSITY th mapchunk;
-- set to 0 in order to disable spawning of these lone buildings outside villages
mg_villages.INVERSE_HOUSE_DENSITY = 94;

-- cover some villages with artificial snow; probability: 1/mg_villages.artificial_snow_probability
mg_villages.artificial_snow_probability = 10;

-- if set to true, soil around villaes will get special soil-snow instead of plant + snow cover
mg_villages.use_soil_snow = false;

-- only place roads if there are at least that many buildings in the village
mg_villages.MINIMAL_BUILDUNGS_FOR_ROAD_PLACEMENT = 4;


-- players without the mg_villages priv can only see villages which are less than that many blocks away
-- from them when using the /vmap command
mg_villages.VILLAGE_DETECT_RANGE = 400;

-- if set to true, only players which have the mg_villages priv can use the "/visit <village nr>"
-- command which allows teleporting to the village with the given number
mg_villages.REQUIRE_PRIV_FOR_TELEPORT = false;

-- if set to true, players cannot modify spawned villages without buying the house from the village first
mg_villages.ENABLE_PROTECTION = false;

-- the first village - the one the player spawns in - will be of this type
mg_villages.FIRST_VILLAGE_TYPE = 'medieval';

-- the mapgen will disregard mapchunks where min.y > mg_villages.MAX_HEIGHT_TREATED;
-- you can set this value to 64 if you have a slow machine and a mapgen which does not create extreme mountains
-- (or if you don't care if extreme mountains may create burried villages occasionally)
mg_villages.MAX_HEIGHT_TREATED = 250;

-- choose the debug level you want
mg_villages.DEBUG_LEVEL = mg_villages.DEBUG_LEVEL_NORMAL
--mg_villages.DEBUG_LEVEL = mg_villages.DEBUG_LEVEL_TIMING

-- if set to true, a water source will be added all 2-3 blocks on a field for farming;
-- as long as you do not plan to dig up all fields, hoe them and use them manually,
-- better keep this to "false" as that is much faster
mg_villages.PLACE_WATER_FOR_FARMING = false

-- if set to true (or anything else but nil or false), highlandpools by paramat (see
-- https://forum.minetest.net/viewtopic.php?t=8400) will be created
mg_villages.CREATE_HIGHLANDPOOLS = true

-- Torches are replaced by mg_villages:torch - which does not melt snow. If you want to use the normal
-- torches from minetest_game, set this to true.:w!
mg_villages.USE_DEFAULT_3D_TORCHES = true;

-- background image for the /vmap command
-- RealTest comes with a diffrent texture
if(     minetest.get_modpath('grounds') and minetest.get_modpath('joiner_table')) then
	mg_villages.MAP_BACKGROUND_IMAGE = "default_dirt_grass.png";
elseif( minetest.registered_nodes[ 'default:dirt_with_grass'] ) then
	mg_villages.MAP_BACKGROUND_IMAGE = "default_grass.png";
else
	mg_villages.MAP_BACKGROUND_IMAGE = "";
end

-- if set to true, the outer buildings in medieval villages will be fields; this is not very convincing yet
-- currently not really used; does not look as good as expected
mg_villages.medieval_subtype = false;

-- set this to true if you want to use normal lava - but beware: charachoal villages may cause bushfires!
--mg_villages.use_normal_unsafe_lava = false;

-----------------------------------------------------------------------------
-- decrese these values slightly if you want MORE trees around your villages;
-- increase it if you want to DECREASE the amount of trees around villages
-----------------------------------------------------------------------------
-- on average, every n.th node inside a village area may be one of these trees - and it will be a relatively dense packed forrest
mg_villages.sapling_probability = {};

if(minetest.registered_nodes['default:sapling']) then
	mg_villages.sapling_probability[ minetest.get_content_id( 'default:sapling' )       ] = 25; -- suitable for a relatively dense forrest of normal trees
end
if(minetest.registered_nodes['default:junglesapling']) then
	mg_villages.sapling_probability[ minetest.get_content_id( 'default:junglesapling' ) ] = 40; -- jungletrees are a bit bigger and need more space
end
if(minetest.registered_nodes['default:pine_sapling']) then
	mg_villages.sapling_probability[ minetest.get_content_id( 'default:pine_sapling' )   ] = 30;
end
if( minetest.get_modpath( 'mg' )) then
	mg_villages.sapling_probability[ minetest.get_content_id( 'mg:savannasapling'     ) ] = 30; 
	mg_villages.sapling_probability[ minetest.get_content_id( 'mg:pinesapling'        ) ] = 35; 
end
mg_villages.moretrees_treelist = nil;
if( minetest.get_modpath( 'moretrees' )) then
	mg_villages.moretrees_treelist = moretrees.treelist;
	mg_villages.sapling_probability[ minetest.get_content_id( 'moretrees:spruce_sapling_ongen'      ) ] = 200;
end


-----------------------------------------------------------------------------
-- no need to change this, unless you add new farming_plus fruits
-----------------------------------------------------------------------------
-- the schematics for buildings of type 'farm_tiny' grow cotton; the farming_plus fruits would be far more fitting
mg_villages.fruit_list = {'carrot','potatoe','orange','rhubarb','strawberry','tomato','cotton'};
-- is farming_plus available? If not, we can't use this
if( not( minetest.get_modpath("farming_plus"))) then
	mg_villages.fruit_list = nil;
end


-----------------------------------------------------------------------------
-- players can buy plots in villages with houses on for this  price;
-- set according to your liking
-----------------------------------------------------------------------------
-- how much does the player have to pay for a plot with a building?
-- Uses gold coins (simplecoins:coins) - medieval fantasy pricing
-- Land ownership was a BIG deal in medieval times
mg_villages.prices = {
	empty          = "simplecoins:coins 800", -- plot to build on

	-- building types which usually have inhabitants (and thus allow the player
	-- who bought the building to modifiy the entire village area minus other
	-- buildings)
	tent           = "simplecoins:coins 200",
	hut            = "simplecoins:coins 600",
	farm_full      = "simplecoins:coins 3500",
	farm_tiny      = "simplecoins:coins 1800",
	lumberjack     = "simplecoins:coins 2200",
	house          = "simplecoins:coins 2500",
	house_large    = "simplecoins:coins 4500",
	tavern         = "simplecoins:coins 8000",
	trader         = "simplecoins:coins 3000",

	-- more or less community buildings
	well           = "simplecoins:coins 1200",
	village_square = "simplecoins:coins 25000",
	secular        = "simplecoins:coins 12000", -- secular buildings, such as libraries etc.
	church         = "simplecoins:coins 35000",

	-- places for mobs to work at; usually without inhabitants
	tower          = "simplecoins:coins 5000",
	shed           = "simplecoins:coins 900",
	pit            = "simplecoins:coins 1100", -- claytrader pit
	mill           = "simplecoins:coins 7000",
	forge          = "simplecoins:coins 6500",
	bakery         = "simplecoins:coins 5500",
	shop           = "simplecoins:coins 9000",
	sawmill        = "simplecoins:coins 8500",

	-- decoration
	wagon          = "simplecoins:coins 150",
	bench          = "simplecoins:coins 80",

	-- seperate fields
	pasture        = "simplecoins:coins 1500",
	field          = "simplecoins:coins 1400",

	-- chateaus are expensive - noble estates
	chateau        = "simplecoins:coins 75000",

	-- larger plots cost more
	empty6x12      = "simplecoins:coins 2800",
	empty8x8       = "simplecoins:coins 2500",
	-- a large plot costs even more
	empty16x16     = "simplecoins:coins 6000",
	-- this is just enough space to grow a tree
        empty5x5       = "default:mese_crystal 12",
	-- nobody is supposed to buy the spawn building...except for the admin
	spawn          = "nyancat:nyancat 99",
}


-----------------------------------------------------------------------------
-- The values below seldom need adjustment; don't change them unless you
-- know exactly what you are doing.
-----------------------------------------------------------------------------
-- if set to false, villages will not be integrated into the terrain - which looks very bad
mg_villages.ENABLE_TERRAIN_BLEND = true;
-- if set to false, holes digged by cavegen and mudflow inside the village will not be repaired; houses will be destroyed
mg_villages.UNDO_CAVEGEN_AND_MUDFLOW = true;

-- internal variables for village generation

mg_villages.VILLAGE_CHECK_RADIUS = 2
mg_villages.VILLAGE_CHECK_COUNT = 1
--mg_villages.VILLAGE_CHANCE = 28
--mg_villages.VILLAGE_MIN_SIZE = 20
--mg_villages.VILLAGE_MAX_SIZE = 40
mg_villages.VILLAGE_CHANCE = 94
-- min and max size are only used in case of them beeing not provided by the village type (see buildings.lua)
mg_villages.VILLAGE_MIN_SIZE = 15
mg_villages.VILLAGE_MAX_SIZE = 95 --55
mg_villages.FIRST_ROADSIZE = 3
mg_villages.BIG_ROAD_CHANCE = 0

-- Enable that for really big villages (there are also really slow to generate)
--[[mg_villages.VILLAGE_CHECK_RADIUS = 3
mg_villages.VILLAGE_CHECK_COUNT = 3
mg_villages.VILLAGE_CHANCE = 28
mg_villages.VILLAGE_MIN_SIZE = 100
mg_villages.VILLAGE_MAX_SIZE = 150
mg_villages.FIRST_ROADSIZE = 5
mg_villages.BIG_ROAD_CHANCE = 50]]
