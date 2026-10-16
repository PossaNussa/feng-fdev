-- Snow and ice melt from a volcano's radiant heat.
--
-- The seasonal snow/ice melt ABMs (snow_cover.lua, ice.lua) gate on climate_api
-- heat, which is engine biome heat plus the seasonal offset -- and knows nothing
-- about volcanoes. A volcano's heat lives only in tempsurvive's body-temperature
-- model, so before this a player could stand on an active cone, beside the lava,
-- and the snow around them would sit there untouched because the weather system
-- never saw the heat. This closes that gap: near a volcano, snow and ice melt on
-- their own, independent of biome or season.
--
-- It is a plain ABM rather than a climate_api one on purpose. climate_api ABMs
-- only fire where their heat condition already passes, so in a genuinely cold
-- biome they would never run and could never react to the volcano. This one runs
-- everywhere and asks tempsurvive how hot the volcano makes each spot.

if not regional_weather.settings.snow and not regional_weather.settings.ice then
	return
end

-- No magma_conduits means no volcanoes to radiate; nothing to do.
if not minetest.get_modpath("magma_conduits") then return end

local SNOW_STEP = 8
local THIN_ICE = "regional_weather:ice"

-- Minimum volcano heat bonus (deg) at a spot before its snow/ice melts. The bonus
-- peaks at VOLCANO_CORE_HEAT on the axis and eases to zero at base_radius + 120,
-- so a small threshold would thaw snow far out onto the surrounding plain. ~8
-- keeps melting to the warm apron around the cone rather than a huge halo.
local VOLCANO_MELT_HEAT = 8

minetest.register_abm({
	label		= "melt snow and ice near volcanoes",
	nodenames	= { "default:snow", "default:snowblock", THIN_ICE, "default:ice" },
	neighbors	= { "air" },
	interval	= 10,
	chance		= 4,
	catch_up	= true,

	action = function (pos, node)
		-- tempsurvive owns the volcano heat model; if it is absent there is no
		-- volcano heat to read and this ABM is inert.
		if not (minetest.global_exists("tempsurvive")
				and tempsurvive.get_volcano_heat_at) then
			return
		end
		if tempsurvive.get_volcano_heat_at(pos) < VOLCANO_MELT_HEAT then return end

		local name = node.name
		if name == "default:snowblock" then
			minetest.set_node(pos, { name = "default:snow", param2 = 64 - SNOW_STEP })
		elseif name == "default:snow" then
			local level = minetest.get_node_level(pos)
			if level > SNOW_STEP then
				minetest.set_node_level(pos, level - SNOW_STEP)
			elseif regional_weather.settings.puddles then
				minetest.set_node(pos, regional_weather.get_random_puddle())
			else
				minetest.set_node(pos, { name = "air" })
			end
		elseif name == "default:ice" then
			-- Thick ice steps down to thin; thin melts to water on the next pass.
			minetest.set_node(pos, { name = THIN_ICE })
		elseif name == THIN_ICE then
			minetest.set_node(pos, { name = "default:river_water_source" })
		end
	end
})
