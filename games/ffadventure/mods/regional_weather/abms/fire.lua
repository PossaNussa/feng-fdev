if not regional_weather.settings.fire then return end
if not minetest.get_modpath("fire") then return end

climate_api.register_abm({
	label			= "extinguish fire at high humidity",
	nodenames = { "fire:basic_flame" },
	neighbors	= { "air" },
	interval	= 10,
	chance		= 2,
	catch_up	= false,

	 -- No daylight condition. It used to require daylight == 15, which meant rain
	 -- only ever put a fire out in broad daylight -- a fire lit outdoors at night
	 -- in a downpour burned on regardless. `indoors = false` is what actually
	 -- wants checking here, and it already covers being under a roof.
	 conditions	= {
		 min_height		= regional_weather.settings.min_height,
		 max_height		= regional_weather.settings.max_height,
		 min_humidity	= 50,
		 min_biome_humidity = 26,
		 max_heat			= 85,
		 indoors			= false
	 },

	 action = function (pos, node, env)
		 minetest.set_node(pos, { name = "air" })
	 end
})