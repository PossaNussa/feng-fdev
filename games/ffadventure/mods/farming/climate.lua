-- farming/climate.lua
-- Applies heat/humidity grow-speed ranges to every farming crop stage.
-- Crops that already set _heat_min directly (wheat, strawberry, parsley,
-- pineapple) are listed here too — override_item is idempotent so it's fine.
--
-- Heat 0=arctic, 100=tropical.  Humidity 0=arid, 100=saturated.
-- Ranges based on real-world agroclimate data.

local crop_climate = {
	-- grain / cereal
	artichoke  = { 30,  60,  30,  65 }, -- Mediterranean coast / temperate
	asparagus  = { 30,  65,  30,  65 }, -- temperate, tolerates dry
	barley     = { 20,  55,  25,  65 }, -- cool, hardy grain
	beans      = { 45,  75,  40,  75 }, -- warm temperate
	beetroot   = { 25,  60,  30,  65 }, -- cool temperate
	blackberry = { 30,  60,  45,  80 }, -- cool moist, hedgerow
	blueberry  = { 25,  55,  50,  85 }, -- cool moist acidic
	cabbage    = { 20,  55,  35,  70 }, -- cool temperate brassica
	carrot     = { 30,  60,  35,  70 }, -- cool temperate root
	chili      = { 60,  90,  35,  70 }, -- warm–hot capsicum
	cocoa      = { 75, 100,  70, 100 }, -- tropical tree crop
	coffee     = { 65,  95,  60, 100 }, -- subtropical / tropical
	corn       = { 50,  85,  40,  80 }, -- warm temperate maize
	cotton     = { 55,  95,  25,  65 }, -- warm–hot, drought tolerant
	cucumber   = { 55,  85,  45,  80 }, -- warm cucurbit
	eggplant   = { 60,  90,  45,  75 }, -- warm subtropical solanum
	garlic     = { 30,  60,  25,  60 }, -- temperate, prefers drier soil
	ginger     = { 65,  95,  65, 100 }, -- tropical / subtropical rhizome
	grapes     = { 45,  80,  20,  60 }, -- Mediterranean, drier summers
	hemp       = { 35,  70,  35,  70 }, -- adaptable temperate
	lettuce    = { 20,  55,  40,  75 }, -- cool season leafy green
	melon      = { 60,  90,  35,  75 }, -- warm–hot cucurbit
	mint       = { 25,  60,  50,  85 }, -- cool moist aromatic
	oat        = { 15,  50,  40,  80 }, -- cool moist cereal
	onion      = { 35,  65,  30,  65 }, -- temperate bulb
	parsley    = { 30,  60,  40,  75 }, -- cool temperate herb
	peas       = { 20,  55,  35,  70 }, -- cool season legume
	pepper     = { 55,  90,  40,  75 }, -- warm capsicum
	pineapple  = { 65, 100,  60, 100 }, -- tropical / subtropical
	potato     = { 25,  55,  40,  75 }, -- cool tuber
	pumpkin    = { 50,  80,  40,  75 }, -- warm cucurbit
	raspberry  = { 25,  55,  45,  80 }, -- cool moist cane fruit
	rhubarb    = { 15,  50,  40,  75 }, -- cool rhizome
	rice       = { 55,  90,  70, 100 }, -- warm–tropical paddy
	rye        = { 10,  55,  20,  70 }, -- cool hardy cereal
	soy        = { 45,  80,  45,  80 }, -- warm temperate legume
	spinach    = { 20,  55,  40,  75 }, -- cool season leafy green
	strawberry = { 30,  65,  40,  80 }, -- cool–temperate berry
	sunflower  = { 45,  80,  30,  70 }, -- warm temperate
	tomato     = { 50,  85,  40,  75 }, -- warm solanaceae
	vanilla    = { 70, 100,  70, 100 }, -- tropical vine orchid
	-- wheat is handled directly in crops/wheat.lua (_heat_min already set)
}

minetest.register_on_mods_loaded(function()
	for crop, c in pairs(crop_climate) do
		for stage = 1, 12 do
			local node = "farming:" .. crop .. "_" .. stage
			if minetest.registered_nodes[node] then
				minetest.override_item(node, {
					_heat_min = c[1],
					_heat_max = c[2],
					_hum_min  = c[3],
					_hum_max  = c[4],
				})
			end
		end
	end
end)
