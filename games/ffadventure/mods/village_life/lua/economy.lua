-- Goods, and what any given villager has on the shelf today.
--
-- The old system had two problems that made every shop feel the same. First,
-- lottmobs.add_goods() walked `race.items[1..15]` in order, so a profession's
-- shelf was always the first fifteen entries of a fixed list -- the same
-- fifteen in every village, in the same slots. Second, there was no per-mob
-- state at all: two blacksmiths a hundred nodes apart were the same shop.
--
-- Here a shop is a *sample* from a much larger pool, drawn with a generator
-- seeded on the villager's identity (village, plot, bed) and the current
-- restock epoch. Same villager, same shelf, all session; different villager or
-- a new day, different shelf.
--
-- Entry format: {item, count, price, rarity, tags}
--   rarity  0..100, higher means it turns up less often
--   tags    space-separated; drives seasonal and speciality pricing (market.lua)

local util = village_life.util
local home = village_life.home
local economy = {}
village_life.economy = economy

local SLOTS = 15  -- the detached inventory's "goods" list is 3x5

-- How much of a ware's full shelf comes back per in-game day. A merchant you
-- clean out is not restocked to the brim by morning: he sells down, and refills
-- from what the country round him actually produces, a portion at a time. At a
-- third a day a bought-out staple takes about three days to fill again, and a
-- treasure (shelf of one or two) the best part of a week.
local RESTOCK_FRACTION = 0.34

--------------------------------------------------------------------------------
-- Pools
--------------------------------------------------------------------------------

local P = {}
economy.pools = P

P.smith = {
	{"default:pick_steel", 1, 45, 10, "tool metal"},
	{"default:axe_steel", 1, 45, 10, "tool metal"},
	{"default:shovel_steel", 1, 30, 10, "tool metal"},
	{"default:sword_steel", 1, 50, 12, "tool metal weapon"},
	{"default:pick_bronze", 1, 60, 25, "tool metal"},
	{"default:axe_bronze", 1, 58, 25, "tool metal"},
	{"default:sword_bronze", 1, 65, 28, "tool metal weapon"},
	{"default:pick_mese", 1, 220, 60, "tool metal rare"},
	{"default:sword_mese", 1, 240, 65, "tool metal weapon rare"},
	{"spears:real_spear_steel", 1, 55, 15, "weapon metal"},
	{"farming:hoe_steel", 1, 35, 15, "tool metal farm"},
	{"default:steel_ingot", 5, 25, 8, "metal bulk"},
	{"default:steel_ingot", 20, 90, 12, "metal bulk"},
	{"default:bronze_ingot", 5, 30, 10, "metal bulk"},
	{"default:copper_ingot", 10, 40, 10, "metal bulk"},
	{"default:tin_ingot", 10, 38, 14, "metal bulk"},
	{"default:gold_ingot", 3, 95, 40, "metal rare"},
	{"default:steelblock", 2, 70, 22, "metal bulk"},
	{"3d_armor:helmet_steel", 1, 120, 25, "armor metal"},
	{"3d_armor:chestplate_steel", 1, 200, 30, "armor metal"},
	{"3d_armor:leggings_steel", 1, 160, 28, "armor metal"},
	{"3d_armor:boots_steel", 1, 80, 22, "armor metal"},
	{"3d_armor:helmet_bronze", 1, 140, 35, "armor metal"},
	{"3d_armor:chestplate_bronze", 1, 230, 40, "armor metal"},
	{"shields:shield_steel", 1, 150, 25, "armor metal"},
	{"shields:shield_bronze", 1, 170, 35, "armor metal"},
	{"bucket:bucket_empty", 1, 35, 15, "tool metal"},
	{"default:furnace", 1, 55, 20, "build"},
	{"castle:anvil", 1, 180, 45, "build metal"},
	{"tinkering:silver_sword", 1, 260, 70, "weapon metal rare"},
	{"default:coal_lump", 20, 26, 10, "fuel warm"},
	-- The smith works the deep-ore metals too, so there is somewhere to both
	-- buy and sell them. Gems pass over the same counter for want of a jeweller.
	{"default:silverbar", 5, 110, 30, "metal rare bulk"},
	{"default:ironbar", 10, 60, 12, "metal bulk"},
	{"default:cobaltsteel_ingot", 5, 130, 35, "metal rare"},
	{"default:opal", 1, 55, 45, "rare gem"},
	{"default:ruby", 1, 95, 60, "rare gem"},
	{"default:sapphire", 1, 90, 58, "rare gem"},
}

P.baker = {
	{"farming:bread", 5, 15, 5, "food fresh"},
	{"farming:bread", 20, 55, 8, "food fresh"},
	{"bushes:blueberry_pie_cooked", 1, 20, 15, "food fresh sweet"},
	{"bushes:strawberry_pie_cooked", 1, 20, 15, "food fresh sweet"},
	{"bushes:raspberry_pie_cooked", 1, 20, 15, "food fresh sweet"},
	{"bushes:gooseberry_pie_cooked", 1, 22, 20, "food fresh sweet"},
	{"bushes:basket_blueberry", 1, 35, 20, "food fresh berry"},
	{"bushes:basket_strawberry", 1, 35, 20, "food fresh berry"},
	{"bushes:basket_raspberry", 1, 35, 22, "food fresh berry"},
	{"farming:flour", 10, 25, 12, "grain"},
	{"farming:flour", 40, 90, 15, "grain bulk"},
	{"default:apple", 10, 15, 10, "food fresh"},
	{"x_farming:corn", 5, 12, 12, "food grain"},
	{"x_farming:strawberry", 10, 18, 15, "food fresh berry"},
	{"x_farming:donut", 5, 20, 12, "food sweet"},
	{"x_farming:donut_chocolate", 3, 25, 15, "food sweet"},
	{"x_farming:pumpkin_pie", 2, 30, 15, "food sweet autumn"},
	{"x_farming:cake", 1, 45, 25, "food sweet"},
	{"farming:sugar", 10, 22, 12, "food sweet"},
	{"default:furnace", 1, 50, 30, "build"},
}

P.farmer = {
	{"farming:seed_wheat", 20, 15, 8, "seed grain"},
	{"farming:seed_cotton", 10, 12, 10, "seed cloth"},
	{"farming:wheat", 20, 20, 8, "grain"},
	{"farming:cotton", 10, 18, 10, "cloth"},
	{"farming:string", 10, 16, 12, "cloth"},
	{"default:apple", 15, 18, 8, "food fresh"},
	{"x_farming:carrot", 10, 15, 12, "food fresh"},
	{"x_farming:potato", 10, 15, 12, "food fresh"},
	{"x_farming:corn", 8, 14, 10, "food grain"},
	{"x_farming:melon_item", 5, 20, 15, "food fresh summer"},
	{"x_farming:pumpkin", 3, 22, 18, "food fresh autumn"},
	{"x_farming:beetroot", 10, 16, 14, "food fresh"},
	{"x_farming:kiwi", 8, 20, 18, "food fresh"},
	{"farming:hoe_wood", 1, 10, 10, "tool farm"},
	{"farming:hoe_stone", 1, 18, 12, "tool farm"},
	{"farming:hoe_steel", 1, 34, 20, "tool farm metal"},
	{"cottages:straw_mat", 10, 15, 10, "build"},
	{"default:papyrus", 15, 20, 12, "fresh"},
	{"bonemeal:fertiliser", 10, 30, 18, "farm"},
	{"default:dirt", 30, 14, 8, "build bulk"},
	{"default:sapling", 5, 24, 20, "wood seed"},
}

P.miller = {
	{"farming:flour", 20, 30, 8, "grain"},
	{"farming:flour", 50, 70, 10, "grain bulk"},
	{"farming:flour", 99, 130, 12, "grain bulk"},
	{"farming:seed_wheat", 30, 20, 10, "seed grain"},
	{"farming:wheat", 30, 25, 10, "grain"},
	-- The other grains as they actually exist in this game: barley is x_farming's,
	-- rye and oat are the grains mod's. The old farming:barley/oat/rye names were
	-- never registered (farming/crops/ryeoatrice.lua is not loaded), so prune()
	-- dropped all three -- which is why a miller stocked no rye and, through the
	-- buy index, why nobody would buy rye off the player either.
	{"x_farming:barley", 20, 24, 16, "grain"},
	{"grains:oat", 20, 24, 16, "grain"},
	{"grains:rye", 20, 24, 16, "grain"},
	{"cottages:straw_mat", 20, 25, 12, "build"},
	{"cottages:handmill", 1, 120, 25, "tool"},
	{"farming:bread", 8, 22, 14, "food fresh"},
}

P.stonemason = {
	{"default:stone", 50, 40, 8, "stone bulk build"},
	{"default:cobble", 50, 30, 8, "stone bulk build"},
	{"default:stonebrick", 30, 45, 10, "stone build"},
	{"default:desert_stonebrick", 30, 50, 12, "stone build"},
	{"default:sandstonebrick", 30, 48, 14, "stone build"},
	{"default:brick", 20, 40, 12, "stone build"},
	{"default:obsidian_block", 4, 110, 45, "stone rare"},
	{"stairs:stair_stone", 20, 35, 15, "stone build"},
	{"stairs:stair_cobble", 20, 30, 15, "stone build"},
	{"stairs:slab_stone", 30, 35, 15, "stone build"},
	{"stairs:stair_stonebrick", 20, 42, 18, "stone build"},
	{"default:gravel", 30, 25, 10, "stone bulk"},
	{"default:sand", 30, 20, 10, "stone bulk"},
	{"default:sandstone", 30, 35, 12, "stone build"},
	{"default:furnace", 1, 50, 20, "build"},
	{"default:pick_stone", 1, 16, 12, "tool stone"},
	{"castle:stonewall", 20, 55, 25, "stone build"},
	{"default:clay_lump", 20, 24, 14, "stone"},
	{"default:mese_crystal", 1, 180, 70, "rare"},
}

P.carpenter = {
	{"default:wood", 30, 25, 8, "wood bulk build"},
	{"default:junglewood", 20, 30, 10, "wood build"},
	{"default:pine_wood", 20, 28, 12, "wood build"},
	{"default:acacia_wood", 20, 30, 14, "wood build"},
	{"default:aspen_wood", 20, 28, 14, "wood build"},
	{"default:fence_wood", 20, 30, 12, "wood build"},
	{"doors:door_wood", 2, 25, 12, "wood build"},
	{"default:chest", 1, 35, 15, "wood build"},
	{"default:chest_locked", 1, 55, 18, "wood build"},
	{"default:bookshelf", 1, 45, 18, "wood build"},
	{"default:ladder_wood", 10, 20, 10, "wood build"},
	{"default:sign_wall_wood", 5, 15, 12, "wood"},
	{"cottages:bench", 2, 25, 15, "wood build"},
	{"cottages:table", 1, 30, 15, "wood build"},
	{"cottages:shelf", 1, 35, 18, "wood build"},
	{"stairs:stair_wood", 20, 30, 12, "wood build"},
	{"stairs:slab_wood", 30, 30, 12, "wood build"},
	{"default:axe_wood", 1, 10, 10, "tool wood"},
	{"default:stick", 40, 14, 8, "wood bulk"},
	{"boats:boat", 1, 60, 30, "wood"},
	{"default:tree", 20, 26, 12, "wood bulk"},
}

P.shopkeeper = {
	{"default:torch", 20, 15, 5, "light warm"},
	{"moretorches:clantern", 5, 35, 10, "light"},
	{"default:paper", 10, 18, 12, "misc"},
	{"default:book", 3, 30, 15, "misc"},
	{"default:coal_lump", 20, 25, 8, "fuel warm"},
	{"default:stick", 30, 12, 8, "wood bulk"},
	{"default:clay_lump", 20, 22, 12, "stone"},
	{"wool:white", 10, 30, 12, "cloth warm"},
	{"vessels:glass_bottle", 5, 20, 15, "glass"},
	{"vessels:drinking_glass", 5, 18, 15, "glass"},
	{"default:flint", 10, 15, 12, "misc"},
	{"bones:bones", 5, 20, 18, "misc"},
	{"bucket:bucket_empty", 1, 32, 16, "tool metal"},
	{"default:rope", 5, 28, 20, "misc"},
	{"binoculars:binoculars", 1, 150, 60, "misc rare"},
	{"default:mese_crystal_fragment", 5, 60, 40, "rare"},
	{"farming:string", 10, 18, 14, "cloth"},
	{"dye:black", 8, 20, 16, "dye"},
	{"default:ladder_wood", 8, 18, 14, "wood build"},
	{"default:apple", 10, 14, 10, "food fresh"},
}

P.innkeeper = {
	{"farming:bread", 10, 25, 8, "food fresh"},
	{"default:apple", 15, 18, 10, "food fresh"},
	{"bushes:blueberry_pie_cooked", 2, 30, 15, "food sweet"},
	-- An innkeeper rents rooms (see lodging.lua); they no longer sell the beds
	-- themselves off the shelf. A rolled-up mat to carry on the road is fair
	-- game -- that is trail kit, not a room.
	{"cottages:sleeping_mat", 1, 35, 15, "build"},
	{"vessels:drinking_glass", 5, 18, 12, "glass"},
	{"vessels:glass_bottle", 5, 20, 12, "glass"},
	{"default:torch", 15, 12, 8, "light warm"},
	{"moretorches:clantern", 3, 25, 12, "light"},
	{"x_farming:coffee_cup_hot", 3, 25, 15, "food warm"},
	{"x_farming:fish_stew", 2, 35, 18, "food warm"},
	{"x_farming:beetroot_soup", 2, 28, 15, "food warm"},
	{"animalia:bucket_milk", 1, 25, 15, "food fresh"},
	{"wool:white", 6, 24, 16, "cloth warm"},
	{"drying_rack:dried_meat", 4, 34, 14, "food meat preserved"},
	-- Tavern plates.
	{"x_farming:bowl_baked_fish", 1, 20, 14, "food fish warm"},
	{"x_farming:sushi_nigiri", 3, 26, 16, "food fish"},
	{"x_farming:slice_strawberry_pie", 2, 20, 15, "food sweet berry"},
}

P.foodseller = {
	{"animalia:beef_cooked", 5, 45, 12, "food meat"},
	{"animalia:mutton_cooked", 5, 38, 12, "food meat"},
	{"animalia:porkchop_cooked", 5, 40, 12, "food meat"},
	{"animalia:poultry_cooked", 5, 35, 12, "food meat"},
	{"animalia:venison_cooked", 3, 50, 15, "food meat"},
	{"animalia:bucket_milk", 1, 25, 15, "food fresh"},
	{"animalia:chicken_egg", 10, 20, 10, "food fresh"},
	{"x_farming:carrot", 10, 15, 8, "food fresh"},
	{"x_farming:carrot_golden", 3, 45, 20, "food rare"},
	{"x_farming:potato_baked", 5, 25, 10, "food warm"},
	{"x_farming:corn", 10, 18, 10, "food grain"},
	{"x_farming:popcorn", 5, 22, 12, "food"},
	{"x_farming:fries", 3, 28, 15, "food warm"},
	{"x_farming:pumpkin_pie", 2, 30, 15, "food sweet autumn"},
	{"x_farming:beetroot_soup", 2, 28, 15, "food warm"},
	{"x_farming:fish_stew", 2, 35, 18, "food warm"},
	{"x_farming:melon", 8, 18, 10, "food fresh summer"},
	{"x_farming:strawberry", 15, 22, 10, "food fresh berry"},
	{"x_farming:kiwi", 10, 20, 12, "food fresh"},
	{"x_farming:cactus_fruit_item", 8, 15, 12, "food fresh"},
	{"x_farming:coffee_cup_hot", 3, 25, 15, "food warm"},
	{"x_farming:bottle_honey", 2, 35, 18, "food sweet"},
	{"farming:bread", 6, 18, 10, "food fresh"},
	{"cheese:caciocavallo", 4, 30, 18, "food dairy"},
	-- Preserved trail food: keeps on the road where fresh meat spoils.
	{"drying_rack:dried_meat", 5, 40, 14, "food meat preserved"},
	{"drying_rack:dried_venison", 3, 45, 20, "food meat preserved"},
	-- Prepared dishes off the cook's stove. x_farming builds these dynamically,
	-- so prune() drops the lot cleanly if the mod is ever pulled.
	{"x_farming:bowl_baked_fish", 2, 32, 15, "food fish warm"},
	{"x_farming:bowl_french_potatoes", 2, 30, 15, "food warm"},
	{"x_farming:bowl_melon_slush", 2, 28, 18, "food fresh summer"},
	{"x_farming:sushi_maki", 4, 34, 18, "food fish"},
	{"x_farming:sushi_nigiri", 4, 34, 18, "food fish"},
	{"x_farming:slice_strawberry_pie", 3, 26, 15, "food sweet berry"},
	{"x_farming:slice_chocolate_pie", 3, 28, 16, "food sweet"},
	{"x_farming:slice_honey_kiwi_pie", 3, 28, 18, "food sweet"},
	{"x_farming:cookie", 6, 20, 12, "food sweet"},
	{"x_farming:chocolate", 4, 30, 18, "food sweet"},
	{"x_farming:pine_nut_roasted", 8, 18, 14, "food"},
}

-- The dairy. Everything the cheese mod turns milk into -- the hung and stretched
-- cheeses off the rack, the soft fresh curds, butter and cream, and the churn
-- and separator to make your own. "dairy" is a speciality tag of its own so a
-- cheesemaker pays best for milk and the fresh goods sit under the season's
-- fresh-food pricing.
P.cheesemaker = {
	{"cheese:caciocavallo", 4, 30, 10, "food dairy"},
	{"cheese:fresh_caciocavallo", 4, 28, 12, "food dairy fresh"},
	{"cheese:mozzarella", 6, 26, 8, "food dairy fresh"},
	{"cheese:scamorza", 4, 30, 12, "food dairy"},
	{"cheese:smoked_scamorza", 4, 34, 16, "food dairy"},
	{"cheese:stretched_cheese", 6, 24, 10, "food dairy"},
	{"cheese:ricotta", 6, 22, 10, "food dairy fresh"},
	{"cheese:curd", 8, 18, 8, "food dairy fresh"},
	{"cheese:whey", 8, 12, 10, "food dairy"},
	{"cheese:butter", 6, 24, 12, "food dairy"},
	{"cheese:milk_cream", 6, 22, 12, "food dairy fresh"},
	{"cheese:fondue", 2, 35, 20, "food dairy warm"},
	{"cheese:banana_split", 2, 30, 18, "food sweet"},
	{"cheese:neapolitan_ice_cream", 2, 40, 25, "food sweet"},
	{"cheese:noxious_cheddar", 1, 60, 45, "food dairy rare"},
	{"animalia:bucket_milk", 1, 25, 12, "food fresh dairy"},
	{"cheese:churn", 1, 90, 30, "tool"},
	{"cheese:cream_separator", 1, 110, 35, "tool"},
}

P.roofer = {
	{"cottages:roof_straw", 30, 35, 10, "build"},
	{"cottages:roof_wood", 30, 40, 10, "wood build"},
	{"cottages:roof_red", 30, 45, 12, "stone build"},
	{"cottages:roof_brown", 30, 45, 12, "stone build"},
	{"cottages:roof_black", 30, 45, 12, "stone build"},
	{"cottages:roof_slate", 30, 50, 15, "stone build"},
	{"cottages:roof_flat_straw", 20, 25, 12, "build"},
	{"cottages:roof_flat_wood", 20, 28, 12, "wood build"},
	{"cottages:roof_connector_straw", 10, 22, 18, "build"},
	{"default:ladder_wood", 10, 20, 12, "wood build"},
}

P.glassmaker = {
	{"default:glass", 20, 35, 10, "glass build"},
	{"default:glass", 50, 80, 12, "glass bulk"},
	{"default:obsidian_glass", 10, 50, 15, "glass rare"},
	{"cottages:glass_pane", 20, 30, 12, "glass build"},
	{"vessels:glass_bottle", 10, 25, 10, "glass"},
	{"vessels:drinking_glass", 10, 22, 10, "glass"},
	{"xpanes:pane_flat", 12, 34, 16, "glass build"},
	{"default:sand", 40, 24, 10, "stone bulk"},
	{"vessels:steel_bottle", 5, 40, 22, "glass metal"},
	{"default:meselamp", 2, 90, 40, "light rare"},
}

P.dyemaker = {
	{"wool:red", 10, 25, 12, "cloth dye warm"},
	{"wool:blue", 10, 25, 12, "cloth dye warm"},
	{"wool:green", 10, 25, 12, "cloth dye warm"},
	{"wool:yellow", 10, 25, 12, "cloth dye warm"},
	{"wool:orange", 10, 25, 12, "cloth dye warm"},
	{"wool:violet", 10, 25, 12, "cloth dye warm"},
	{"wool:brown", 10, 22, 10, "cloth dye warm"},
	{"wool:black", 10, 28, 15, "cloth dye warm"},
	{"wool:grey", 10, 22, 10, "cloth dye warm"},
	{"wool:pink", 10, 25, 12, "cloth dye warm"},
	{"wool:cyan", 10, 25, 12, "cloth dye warm"},
	{"wool:magenta", 10, 25, 12, "cloth dye warm"},
	{"dye:red", 8, 18, 10, "dye"},
	{"dye:blue", 8, 18, 10, "dye"},
	{"dye:yellow", 8, 18, 10, "dye"},
	{"dye:green", 8, 18, 10, "dye"},
	{"dye:white", 8, 16, 8, "dye"},
	{"dye:black", 8, 16, 8, "dye"},
	{"farming:cotton", 15, 26, 12, "cloth"},
	{"farming:string", 12, 20, 12, "cloth"},
}

-- The tannery. Raw hides off the kill floor, the same hides worked soft on the
-- rack, and the leather armour and kit that only tanned leather can be made
-- into. "Dried leather" is tanning_rack's tanned_leather -- the finished hide
-- every leather recipe was rerouted to require (tanning_rack/craft.lua), worked
-- up from drying_rack's cured leather.
-- prune() drops whatever mod is absent, so an item from an optional leather mod
-- simply does not appear rather than erroring at the counter.
P.tanner = {
	{"tanning_rack:tanned_leather", 10, 22, 8, "leather"},
	{"tanning_rack:tanned_leather", 30, 55, 12, "leather bulk"},
	{"animalia:leather", 12, 18, 10, "leather"},
	{"mobs:leather", 12, 18, 12, "leather"},
	{"water_life:crocleather", 5, 32, 24, "leather rare"},
	{"armor_expanded:helmet_leather", 1, 40, 16, "armor leather"},
	{"armor_expanded:chestplate_leather", 1, 72, 20, "armor leather"},
	{"armor_expanded:leggings_leather", 1, 55, 18, "armor leather"},
	{"armor_expanded:boots_leather", 1, 30, 14, "armor leather"},
	{"3d_armor:boots_leather", 1, 30, 15, "armor leather"},
	{"backpacks:backpack_leather", 1, 60, 24, "leather"},
	{"mobs:saddle", 1, 85, 32, "leather rare"},
	{"farming:string", 12, 14, 10, "cloth"},
	{"default:rope", 4, 26, 18, "misc"},
}

P.librarian = {
	{"default:book", 5, 45, 10, "misc"},
	{"default:paper", 20, 30, 8, "misc"},
	{"default:bookshelf", 1, 48, 18, "wood build"},
	{"default:book_written", 1, 60, 30, "misc rare"},
	{"dye:black", 6, 18, 12, "dye"},
	{"default:torch", 12, 12, 10, "light warm"},
	{"vessels:glass_bottle", 4, 18, 15, "glass"},
	{"default:sign_wall_wood", 4, 14, 14, "wood"},
}

P.priest = {
	{"default:torch", 20, 14, 8, "light warm"},
	{"moretorches:clantern", 4, 30, 14, "light"},
	{"default:book", 2, 28, 18, "misc"},
	{"flowers:rose", 6, 18, 14, "fresh"},
	{"flowers:white_dandelion", 6, 16, 14, "fresh"},
	{"vessels:glass_bottle", 4, 18, 14, "glass"},
	{"wool:white", 6, 24, 16, "cloth warm"},
	{"bones:bones", 3, 22, 25, "misc"},
	{"default:goldblock", 1, 260, 70, "metal rare"},
}

P.horsekeeper = {
	{"farming:wheat", 25, 24, 8, "grain"},
	{"cottages:straw_mat", 15, 20, 10, "build"},
	{"farming:hay_bale", 6, 30, 16, "grain build"},
	{"farming:string", 12, 20, 12, "cloth"},
	{"default:rope", 4, 26, 20, "misc"},
	{"animalia:bucket_milk", 1, 25, 18, "food fresh"},
	{"x_farming:carrot", 12, 18, 10, "food fresh"},
	{"default:apple", 12, 16, 10, "food fresh"},
	{"3d_armor:boots_leather", 1, 45, 25, "armor"},
}

-- The iceman cuts and hauls ice. Before, "iceman" fell through to the general
-- shopkeeper pool and sold torches and string like everyone else -- the one
-- trade named for its stock had none of it. Ice is a summer luxury (see the
-- season pricing in market.lua), packed snow keeps a cellar cold, and the odd
-- cold-stored perishable rounds out the cart.
P.iceman = {
	{"default:ice", 20, 30, 8, "ice cold build"},
	{"default:ice", 50, 65, 12, "ice cold bulk"},
	{"default:cave_ice", 10, 45, 22, "ice cold rare build"},
	{"default:snowblock", 20, 22, 8, "ice cold build"},
	{"default:snow", 30, 16, 8, "ice cold bulk"},
	{"animalia:bucket_milk", 1, 25, 15, "food fresh"},
	{"cheese:caciocavallo", 3, 28, 18, "food dairy"},
	{"vessels:glass_bottle", 5, 20, 15, "glass"},
	{"default:torch", 10, 12, 12, "light warm"},
}

P.general = {
	{"default:torch", 15, 12, 8, "light warm"},
	{"default:stick", 20, 10, 8, "wood bulk"},
	{"default:wood", 20, 18, 10, "wood bulk"},
	{"default:cobble", 30, 22, 10, "stone bulk"},
	{"default:coal_lump", 15, 18, 10, "fuel warm"},
	{"farming:bread", 5, 12, 10, "food fresh"},
	{"default:apple", 10, 12, 10, "food fresh"},
	{"default:paper", 5, 10, 12, "misc"},
	{"wool:white", 5, 15, 12, "cloth warm"},
	{"default:clay_lump", 10, 12, 12, "stone"},
	{"default:flint", 8, 14, 14, "misc"},
	{"vessels:glass_bottle", 4, 16, 15, "glass"},
	{"farming:string", 8, 14, 12, "cloth"},
	{"default:sapling", 3, 20, 22, "wood seed"},
}

--------------------------------------------------------------------------------
-- Profession -> pool
--------------------------------------------------------------------------------

-- Every title mg_villages can hand out (inhabitants.jobs_in_buildings plus the
-- ones assigned inline for lumberjacks, soldiers, servants and guests).
economy.profession_pool = {
	smith = "smith", blacksmith = "smith", coppersmith = "smith",
	bronzesmith = "smith", tinsmith = "smith", goldsmith = "smith",
	["ore seller"] = "smith",

	baker = "baker", miller = "miller", farmer = "farmer",
	["seed seller"] = "farmer", ["flower seller"] = "farmer",
	horsekeeper = "horsekeeper",

	innkeeper = "innkeeper", barkeeper = "innkeeper", landlord = "innkeeper",
	butcher = "foodseller", cook = "foodseller", chef = "foodseller",
	["food seller"] = "foodseller", ["meat seller"] = "foodseller",
	grocer = "foodseller", fishmonger = "foodseller",
	["tavern cook"] = "foodseller", ["fruit trader"] = "foodseller",

	cheesemaker = "cheesemaker", cheesemonger = "cheesemaker",
	dairymaid = "cheesemaker", ["cheese maker"] = "cheesemaker",

	stonemason = "stonemason", stoneminer = "stonemason",
	bricklayer = "stonemason", potterer = "stonemason",
	carpenter = "carpenter", toolmaker = "carpenter", doormaker = "carpenter",
	furnituremaker = "carpenter", stairmaker = "carpenter", cooper = "carpenter",
	wheelwright = "carpenter", lumberjack = "carpenter",
	["sawmill owner"] = "carpenter", ["wood trader"] = "carpenter",
	roofer = "roofer", glassmaker = "glassmaker",
	dyemaker = "dyemaker", dyemakerl = "dyemaker",

	shopkeeper = "shopkeeper", trader = "shopkeeper",
	iceman = "iceman",
	["charachoal burner"] = "shopkeeper",

	-- the tannery: saddler moves here from the general counter, since a saddler
	-- works hide, and the leatherworker/currier titles land here too.
	tanner = "tanner", leatherworker = "tanner", currier = "tanner",
	saddler = "tanner",
	major = "shopkeeper", teacher = "librarian", schoolteacher = "librarian",
	librarian = "librarian", priest = "priest",

	-- Household members with no trade of their own still sell the odd thing
	-- from the pantry, which is how a village of thirty people stops feeling
	-- like a village of six shopkeepers and twenty-four mutes.
	guard = "general", soldier = "general", servant = "general",
	housemaid = "general", guest = "general",
}

function economy.pool_for(title)
	local key = title and economy.profession_pool[title]
	return P[key or "general"] or P.general
end

--------------------------------------------------------------------------------
-- Validation
--------------------------------------------------------------------------------

-- Pools name items from a dozen optional mods. Drop whatever is not registered
-- once, at load, rather than handing ItemStack an unknown name every time a
-- player opens a shop.
local function prune()
	local dropped, kept = 0, 0
	for name, pool in pairs(P) do
		local out = {}
		for _, e in ipairs(pool) do
			if minetest.registered_items[e[1]] then
				out[#out + 1] = e
				kept = kept + 1
			else
				dropped = dropped + 1
			end
		end
		if #out == 0 then
			village_life.log("warning",
					"goods pool '" .. name .. "' is empty after pruning")
		end
		P[name] = out
	end
	village_life.log("action", "goods pools: " .. kept .. " offers, "
			.. dropped .. " dropped for missing items")
end

minetest.register_on_mods_loaded(prune)

--------------------------------------------------------------------------------
-- Stock
--------------------------------------------------------------------------------

-- Which restock period we are in. Shops turn over on the in-game day, so a
-- player who cleans out the smith can come back tomorrow.
function economy.epoch()
	local day = minetest.get_day_count and minetest.get_day_count() or 0
	return math.floor(day / math.max(1, village_life.settings.restock_days))
end

-- A stable identity string for a villager, used to seed its shelf. Falls back
-- to the entity's own id for pigmen that are not village inhabitants, which
-- still gives them a distinct shop -- just one that changes if they are
-- reloaded from a spawn egg.
function economy.identity(self)
	if self.vl and self.vl.v then
		return village_life.home.key(self.vl.v, self.vl.p, self.vl.b)
	end
	return tostring(self.id or self.game_name or "wanderer")
end

-- Weighted draw without replacement. Rarity is the old field's meaning
-- inverted into a weight: rarity 5 is common, rarity 70 is a treat.
local function draw(pool, count, rng)
	local bag, total = {}, 0
	for _, e in ipairs(pool) do
		local weight = math.max(1, 100 - (e[4] or 10))
		bag[#bag + 1] = {entry = e, weight = weight}
		total = total + weight
	end

	local out = {}
	for _ = 1, count do
		if #bag == 0 then break end

		local roll = util.rng_float(rng, 0, total)
		local acc, pick = 0, #bag
		for j = 1, #bag do
			acc = acc + bag[j].weight
			if roll <= acc then
				pick = j
				break
			end
		end

		out[#out + 1] = bag[pick].entry
		total = total - bag[pick].weight
		table.remove(bag, pick)
	end
	return out
end

-- Build this villager's shelf. Deterministic in (identity, epoch, village), so
-- it can be thrown away and rebuilt at any time -- which is exactly what
-- happens when a shop is reopened after the entity unloaded.
function economy.build_stock(self)
	local title = self.profession
	local pool = economy.pool_for(title)
	if #pool == 0 then return {} end

	local id = economy.identity(self)
	local epoch = economy.epoch()
	local village_id = self.vl and self.vl.v

	-- The catalogue -- which wares this shop keeps -- is stable per villager, so a
	-- merchant sells the same goods day to day (which is both more believable and
	-- what lets a depleted shelf be tracked ware by ware, below). Only the prices
	-- drift, with the day, the season and demand.
	local rng = util.rng("stock_items", id)
	local price_rng = util.rng("stock_price", id, epoch)
	local picked = draw(pool, math.min(SLOTS, #pool), rng)

	local stock = {}
	for _, e in ipairs(picked) do
		local item, count, base, _, tags = e[1], e[2], e[3], e[4], e[5]

		local offer = {
			item = item,
			count = count,
			base = base,
			tags = tags or "",
		}

		-- Village speciality, scarcity, season and demand all fold into one
		-- multiplier; market.lua owns the actual economics.
		local mult, avail = village_life.market.price_factor(village_id, offer)
		if avail then
			offer.price = math.max(1, math.floor(base * mult
					* util.rng_float(price_rng, 0.9, 1.12) + 0.5))
			-- The full shelf: how many times this offer can be bought when fully
			-- stocked. Cheap staples run deep, treasures do not. `max` is the
			-- ceiling the daily restock refills towards; `stock` (the live count)
			-- is set from the persisted quantity in economy.stock().
			local depth = base <= 25 and 6 or (base <= 80 and 4 or 2)
			offer.max = math.max(1, math.floor(depth
					* village_life.market.stock_factor(village_id, offer) + 0.5))
			offer.stock = offer.max
			stock[#stock + 1] = offer
		end
	end

	-- Whatever their own hobby produces goes on the shelf beside the trade
	-- goods. This is what closes the loop on a claim like "I keep bees": there
	-- is a hive on their plot, they walk out to it, and you can buy the honey.
	local product = village_life.traits.product(self)
	if product then
		local hmax = rng:next(1, 3)
		stock[#stock + 1] = {
			item = product,
			count = 1,
			base = 12,
			tags = "hobby",
			price = math.max(1, math.floor(12
					* util.rng_float(price_rng, 0.85, 1.15) + 0.5)),
			-- A sideline, not a trade: a few at a time.
			max = hmax,
			stock = hmax,
			hobby = true,
		}
	end

	return stock
end

--------------------------------------------------------------------------------
-- Depleting and refilling the shelf
--------------------------------------------------------------------------------

-- A shop's bed row is where its depletion is kept, so it survives the villager
-- unloading and reloading (the scratch table does not) and rides mg_villages'
-- own save of the village. Bedless traders -- there are none in normal play --
-- fall back to a full shelf every time.
local function shop_row(self)
	if not self.vl or not self.vl.v then return end
	return home.bed_data(self.vl.v, self.vl.p, self.vl.b)
end

-- Bring the persisted per-ware counts forward to `epoch`, refilling each ware by
-- RESTOCK_FRACTION of its full shelf per in-game day since it was last touched,
-- and write the live count onto each offer. First sight of a ware starts it
-- full: a shop the player has never traded at is fully stocked.
local function apply_depletion(offers, store, epoch)
	local elapsed = math.max(0, epoch - (store.e or epoch))
	local q = store.q or {}
	local seen = {}

	for _, o in ipairs(offers) do
		seen[o.item] = true
		local held = q[o.item]
		if held == nil then
			held = o.max
		elseif elapsed > 0 then
			local step = math.max(1, math.floor(o.max * RESTOCK_FRACTION + 0.5))
			held = math.min(o.max, held + elapsed * step)
		end
		held = math.min(held, o.max)
		q[o.item] = held
		o.stock = held
	end

	-- Forget wares no longer on the catalogue, so the table cannot grow without
	-- bound over a very long-lived world.
	for item in pairs(q) do
		if not seen[item] then q[item] = nil end
	end

	store.q = q
	store.e = epoch
end

-- Record a completed sale of one unit of `offer` against the persisted shelf, so
-- the depletion outlives this trading session. Keyed by the shop's identity
-- string ("village/plot/bed") rather than the entity, because the trade session
-- deliberately holds the key and not the luaentity. trade_ui has already dropped
-- the live `offer.stock`; this mirrors it into the bed row.
function economy.record_sale(key, offer)
	if not key or not offer then return end
	local v, p, b = key:match("^(.-)/(%d+)/(%d+)$")
	if not v then return end
	local bed = home.bed_data(v, tonumber(p), tonumber(b))
	if not bed or not bed.shop then return end
	bed.shop.q[offer.item] = math.max(0, offer.stock or 0)
	bed.shop.e = economy.epoch()
	economy.dirty = true
end

--------------------------------------------------------------------------------
-- Live stock per villager
--------------------------------------------------------------------------------

-- Purchases consume stock, and the shelf now persists across days and reloads on
-- the bed row rather than resetting full every morning: a merchant sells down
-- and refills slowly (apply_depletion). The catalogue is still rebuilt per epoch
-- so prices and season move, but the quantities carry over.
function economy.stock(self)
	local s = util.scratch(self)
	local epoch = economy.epoch()
	if not s.stock or s.stock_epoch ~= epoch then
		s.stock = economy.build_stock(self)
		s.stock_epoch = epoch

		local bed = shop_row(self)
		if bed then
			bed.shop = bed.shop or {e = epoch, q = {}}
			apply_depletion(s.stock, bed.shop, epoch)
		end
	end
	return s.stock
end

function economy.invalidate(self)
	local s = util.scratch(self)
	s.stock = nil
	s.reserve = nil
end

-- The stock kept under the counter, shown only to customers the village
-- thinks well of. Drawn from the same pool but biased hard towards the rare
-- end, and deliberately small: it is a favour, not a second shop.
local RESERVE_SLOTS = 3

function economy.build_reserve(self)
	local pool = economy.pool_for(self.profession)
	if #pool == 0 then return {} end

	-- Only the things that hardly ever turn up on the open shelf.
	local rare = {}
	for _, e in ipairs(pool) do
		if (e[4] or 10) >= 18 then rare[#rare + 1] = e end
	end
	if #rare == 0 then return {} end

	local rng = util.rng("reserve", economy.identity(self), economy.epoch())
	local village_id = self.vl and self.vl.v
	local picked = draw(rare, math.min(RESERVE_SLOTS, #rare), rng)

	local out = {}
	for _, e in ipairs(picked) do
		local offer = {
			item = e[1], count = e[2], base = e[3], tags = e[5] or "",
			reserved = true,
		}
		local mult, avail = village_life.market.price_factor(village_id, offer)
		if avail then
			offer.price = math.max(1, math.floor(e[3] * mult
					* util.rng_float(rng, 0.9, 1.05) + 0.5))
			offer.stock = 1
			out[#out + 1] = offer
		end
	end
	return out
end

function economy.reserve(self)
	local s = util.scratch(self)
	local epoch = economy.epoch()
	if not s.reserve or s.reserve_epoch ~= epoch then
		s.reserve = economy.build_reserve(self)
		s.reserve_epoch = epoch
	end
	return s.reserve
end

-- Find the offer matching an itemstack the player has selected from the goods
-- list. Matching on name *and* count is what makes two different bundle sizes
-- of the same item ("5 bread" and "20 bread") price separately.
function economy.find_offer(stock, item_name, count)
	for _, offer in ipairs(stock) do
		if offer.item == item_name and offer.count == count then
			return offer
		end
	end
end

--------------------------------------------------------------------------------
-- What a villager will buy
--------------------------------------------------------------------------------

-- Valuing only what somebody in the game happens to *sell* is far too narrow.
-- Nobody's shelf stocks leather, hides, raw meat or feathers, so a player
-- coming back from a hunt with a full bag found there was nobody to sell it to
-- -- which is exactly backwards, since those are the things a village wants.
--
-- So: pool prices where they exist, an explicit table for the obvious things
-- they miss, and group heuristics underneath that, in that order.

-- item name -> {value = per-unit coins, tags = space separated}
economy.item_values = {
	["animalia:leather"]      = {value = 6,  tags = "leather hide"},
	["animalia:feather"]      = {value = 1,  tags = "hide"},
	["animalia:bucket_guano"] = {value = 4,  tags = "farm"},
	["animalia:beef_raw"]     = {value = 4,  tags = "food meat raw"},
	["animalia:mutton_raw"]   = {value = 3,  tags = "food meat raw"},
	["animalia:porkchop_raw"] = {value = 4,  tags = "food meat raw"},
	["animalia:poultry_raw"]  = {value = 3,  tags = "food meat raw"},
	["animalia:venison_raw"]  = {value = 5,  tags = "food meat raw"},
	["animalia:rat_raw"]      = {value = 1,  tags = "food meat raw"},

	["default:diamond"]       = {value = 90, tags = "rare gem"},
	["default:mese_crystal"]  = {value = 60, tags = "rare"},
	["default:mese_crystal_fragment"] = {value = 7, tags = "rare"},
	["default:gold_ingot"]    = {value = 26, tags = "metal rare"},
	["default:gold_lump"]     = {value = 20, tags = "metal rare"},
	["default:diamond_block"] = {value = 800, tags = "rare gem"},
	["default:iron_lump"]     = {value = 4,  tags = "metal ore"},
	["default:copper_lump"]   = {value = 4,  tags = "metal ore"},
	["default:tin_lump"]      = {value = 4,  tags = "metal ore"},
	["default:coal_lump"]     = {value = 2,  tags = "fuel warm"},
	["default:obsidian_shard"] = {value = 8, tags = "stone rare"},

	-- The underground ore set (default/ugrnd.lua): cut gems, precious-metal
	-- bars and the metal lumps they smelt from. Every one of these is a bare
	-- craftitem with no groups at all, so before this table a player back from
	-- a deep dig with a bag of opals and silver found nobody in the game would
	-- give a coin for any of it. Gems carry "rare gem", worked bars "metal"
	-- (precious ones "metal rare"), raw lumps "metal ore" so the smith's
	-- interest and a village's metal speciality/shortage both bite.
	["default:opal"]          = {value = 40, tags = "rare gem"},
	["default:fopal"]         = {value = 55, tags = "rare gem"},
	["default:ruby"]          = {value = 70, tags = "rare gem"},
	["default:emerald"]       = {value = 70, tags = "rare gem"},
	["default:sapphire"]      = {value = 65, tags = "rare gem"},
	["default:garnet"]        = {value = 45, tags = "rare gem"},
	["default:peridot"]       = {value = 40, tags = "rare gem"},
	["default:amethyst"]      = {value = 35, tags = "rare gem"},
	["default:btopaz"]        = {value = 45, tags = "rare gem"},
	["default:kyawthuite"]    = {value = 120, tags = "rare gem"},
	["default:raw_kyawthuite"] = {value = 40, tags = "rare gem"},
	["default:amber_lump"]    = {value = 14, tags = "rare gem"},

	["default:silverbar"]     = {value = 18, tags = "metal rare"},
	["default:silver_lump"]   = {value = 12, tags = "metal ore rare"},
	["default:platinumbar"]   = {value = 45, tags = "metal rare"},
	["default:platinum_lump"] = {value = 30, tags = "metal ore rare"},
	["default:fgoldbar"]      = {value = 30, tags = "metal rare"},
	["default:fgold_lump"]    = {value = 22, tags = "metal ore rare"},
	["default:titaniumbar"]   = {value = 30, tags = "metal"},
	["default:titanium_lump"] = {value = 20, tags = "metal ore"},
	["default:cobaltbar"]     = {value = 22, tags = "metal"},
	["default:cobalt_lump"]   = {value = 14, tags = "metal ore"},
	["default:cobaltsteel_ingot"] = {value = 20, tags = "metal"},
	["default:chromebar"]     = {value = 14, tags = "metal"},
	["default:chrome_lump"]   = {value = 9,  tags = "metal ore"},
	["default:nickelbar"]     = {value = 10, tags = "metal"},
	["default:nickel_lump"]   = {value = 6,  tags = "metal ore"},
	["default:zbar"]          = {value = 8,  tags = "metal"},
	["default:zinc_lump"]     = {value = 5,  tags = "metal ore"},
	["default:ironbar"]       = {value = 5,  tags = "metal"},
	["default:uranium_lump"]  = {value = 25, tags = "metal ore rare"},
	["default:malachite_lump"] = {value = 4, tags = "metal ore"},

	-- Ice and packed snow: what the iceman deals in, and worth a little to any
	-- village in high summer (season pricing in market.lua lifts "ice").
	["default:ice"]           = {value = 2,  tags = "ice cold"},
	["default:cave_ice"]      = {value = 3,  tags = "ice cold rare"},
	["default:snowblock"]     = {value = 1,  tags = "ice cold"},
	["default:snow"]          = {value = 1,  tags = "ice cold"},

	["bonemeal:bone"]         = {value = 2,  tags = "farm"},
	["farming:string"]        = {value = 2,  tags = "cloth"},
	["farming:cotton"]        = {value = 2,  tags = "cloth"},
	["default:paper"]         = {value = 2,  tags = "misc"},
	["default:book"]          = {value = 9,  tags = "misc"},

	-- x_farming crops that no shop happens to stock and whose harvested item
	-- carries no food group (barley is overridden down to only a compost
	-- group), so they resolved to 0 -- which is why a village crying out for
	-- grain would not take the barley in your pack. Tagged "grain" so the
	-- grain shortage actually pays out.
	["x_farming:barley"]      = {value = 3,  tags = "grain food"},
	["x_farming:rice"]        = {value = 3,  tags = "grain food"},
	["x_farming:rice_grains"] = {value = 2,  tags = "grain food"},
	["x_farming:cocoa_bean"]  = {value = 4,  tags = "food"},
	-- Strawberry jam is a preserve with no food group of its own; bonemeal is
	-- fertiliser a farmer will always take. The rest of x_farming's foods carry
	-- a food/eatable/seed group and resolve through value_of on their own.
	["x_farming:sjam"]        = {value = 4,  tags = "food sweet"},
	["x_farming:bonemeal"]    = {value = 2,  tags = "farm"},

	-- The grains mod's rye and oat products. register_plant handed the milled
	-- flour and the baked bread only a "flammable" group -- no food, no grain --
	-- so a baker offered nothing for a sack of rye flour or a rye loaf. Raw rye
	-- and oat are priced through the miller pool above; these are the two steps
	-- past it. Flour tracks a touch above the raw grain, bread above the flour.
	["grains:rye_flour"]      = {value = 4,  tags = "grain food"},
	["grains:oat_flour"]      = {value = 4,  tags = "grain food"},
	["grains:rye_bread"]      = {value = 5,  tags = "food grain"},
	["grains:oat_bread"]      = {value = 5,  tags = "food grain"},

	-- Dried mushroom is preserved produce, not jerky: without this it would fall
	-- to the generic "drying_rack:dried_" rule below and sell as "food meat".
	-- Raw and roasted brown mushroom resolve through value_of's food scan already.
	["drying_rack:dried_mushroom"] = {value = 6, tags = "food preserved"},
}

-- Checked in order; the first group the item belongs to decides. Ordered
-- specific to general, because almost everything edible is also in `food`.
local GROUP_VALUES = {
	{"leather",   6, "leather hide"},
	{"feather",   1, "hide"},
	{"food_milk", 7, "food fresh"},
	{"food_egg",  2, "food fresh"},
	{"meat",      4, "food meat"},
	{"food_meat", 4, "food meat"},
	{"wool",      3, "cloth warm"},
	{"flower",    2, "dye fresh"},
	{"sapling",   4, "wood seed"},
	{"seed",      2, "seed"},
	{"food",      2, "food"},
	{"tree",      1, "wood"},
	{"wood",      1, "wood"},
	{"stick",     1, "wood"},
	{"sand",      1, "stone"},
	{"soil",      1, "farm"},
	{"stone",     1, "stone"},
}

local value_cache = {}

-- Per-unit worth of an item to a village, and the tags that worth is filed
-- under. Returns 0 for anything nobody has a use for.
function economy.value_of(item_name)
	local hit = value_cache[item_name]
	if hit ~= nil then return hit.value, hit.tags end

	local entry

	local explicit = economy.item_values[item_name]
	if explicit then
		entry = {value = explicit.value, tags = explicit.tags}
	elseif item_name:sub(1, 18) == "drying_rack:dried_" then
		-- Preserved trail food. Dried meat and fish keep where the raw kill
		-- rots, so it is worth more than the raw meat group's value, not less
		-- -- which is what a "food meat" match alone would have given it.
		entry = {value = 6, tags = "food meat preserved"}
	elseif minetest.registered_items[item_name] then
		local def = minetest.registered_items[item_name]

		-- Named groups first, specific to general.
		for _, g in ipairs(GROUP_VALUES) do
			if minetest.get_item_group(item_name, g[1]) > 0 then
				entry = {value = g[2], tags = g[3]}
				break
			end
		end

		-- The long tail. Many crops and foods only carry a specific edible
		-- group (food_barley, food_wheat, eatable...) that no fixed list can
		-- enumerate, and organic matter a farmer would compost carries none of
		-- the above -- yet all of it is worth a coin or two to somebody. Scan
		-- the item's own group table rather than probing names one by one.
		if not entry and def.groups then
			for gname in pairs(def.groups) do
				if gname:sub(1, 4) == "food" or gname == "eatable" then
					entry = {value = 2, tags = "food"}
					break
				end
			end
		end
		if not entry and (minetest.get_item_group(item_name, "compost") > 0
				or minetest.get_item_group(item_name, "compostability") > 0
				or minetest.get_item_group(item_name, "flora") > 0) then
			entry = {value = 1, tags = "farm food"}
		end
	end

	entry = entry or {value = 0, tags = ""}
	value_cache[item_name] = entry
	return entry.value, entry.tags
end

function economy.forget_values()
	value_cache = {}
end

-- Which tags each trade actually cares about. A smith pays properly for metal
-- and hides; take a sack of wheat to the forge and you will be offered scrap.
economy.interests = {
	smith      = "metal ore leather rare fuel",
	carpenter  = "wood",
	stonemason = "stone",
	roofer     = "stone wood build",
	glassmaker = "glass stone",
	dyemaker   = "dye cloth flower",
	baker      = "grain food",
	miller     = "grain seed",
	farmer     = "seed grain farm food",
	foodseller = "food meat fresh",
	innkeeper  = "food meat fresh",
	horsekeeper = "leather hide grain farm",
	-- The tannery works hide: it sells tanned leather (P.tanner) and, brought a
	-- fresh hide or a length of croc leather, pays the specialist premium for it.
	-- Without this the tanner fell through to no-interest and valued leather no
	-- more than the baker would.
	tanner     = "leather hide rare",
	librarian  = "misc rare",
	priest     = "rare misc",
	shopkeeper = "leather hide misc rare cloth",
	iceman     = "ice cold fresh food",
	cheesemaker = "food fresh dairy milk",
	general    = "",
}

local INTEREST_BONUS = 1.35

function economy.interest(profession, tags)
	local key = economy.profession_pool[profession or ""] or "general"
	local wanted = economy.interests[key]
	if not wanted or wanted == "" or not tags or tags == "" then return 1 end

	for tag in wanted:gmatch("%S+") do
		if (" " .. tags .. " "):find(" " .. tag .. " ", 1, true) then
			return INTEREST_BONUS
		end
	end
	return 1
end

-- Shop depletion lives on the bed rows, which only reach disk through
-- mg_villages' own save. In a session it survives villager unload and the change
-- of day because the rows stay in memory; this flushes it at shutdown so a
-- cleaned-out merchant is still cleaned out after a server restart.
minetest.register_on_shutdown(function()
	if economy.dirty and mg_villages and mg_villages.save_data then
		pcall(mg_villages.save_data)
	end
end)
