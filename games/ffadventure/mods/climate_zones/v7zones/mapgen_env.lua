-- Runs in the mapgen env. Anything sampling climate in the emerge thread
-- (v7_rivers tints river water via core.get_heat) must see the zone climate,
-- not the engine's climate noise.

local climate = dofile(core.get_modpath("climate_zones_v7") .. "/climate.lua")

function core.get_heat(pos)
	return climate.get_heat(pos)
end

function core.get_humidity(pos)
	return climate.get_humidity(pos)
end
