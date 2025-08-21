local S = minetest.get_translator(minetest.get_current_modname())

local water_probability = dynamic_liquid.config.water_probability
local river_water_probability = dynamic_liquid.config.river_water_probability
local lava_probability = dynamic_liquid.config.lava_probability
local water_level = dynamic_liquid.config.water_level
local springs = dynamic_liquid.config.springs


if dynamic_liquid.config.lava then
	dynamic_liquid.liquid_abm("default:lava_source", "default:lava_flowing", lava_probability)
end

if dynamic_liquid.config.water then
	-- override water_source and water_flowing with liquid_renewable set to false
	local override_def = {liquid_renewable = false}
	minetest.override_item("default:water_source", override_def)
	minetest.override_item("default:water_flowing", override_def)

	dynamic_liquid.liquid_abm("default:water_source", "default:water_flowing", water_probability)
	dynamic_liquid.liquid_abm("default:river_water_source", "default:river_water_flowing", river_water_probability)
end

if dynamic_liquid.config.river_water then	
	dynamic_liquid.liquid_abm("default:river_water_source", "default:river_water_flowing", river_water_probability)
end

-- Flow-through nodes
-----------------------------------------------------------------------------------------------------------------------

if dynamic_liquid.config.flow_through then

	local flow_through_nodes = {"group:flow_through", "group:leaves", "group:sapling", "group:grass", "group:dry_grass", "group:flora", "groups:rail", "groups:flower",

	"default:apple", "default:papyrus", "default:dry_shrub", "default:bush_stem", "default:acacia_bush_stem","default:sign_wall_wood", "default:sign_wall_steel", "default:ladder_wood", "default:ladder_steel", "default:fence_wood", "default:fence_acacia_wood", "default:fence_junglewood", "default:fence_pine_wood","default:fence_aspen_wood"}
	
	if minetest.get_modpath("xpanes") then
		table.insert(flow_through_nodes, "xpanes:bar")
		table.insert(flow_through_nodes, "xpanes:bar_flat")
	end
	
	if minetest.get_modpath("carts") then
		table.insert(flow_through_nodes, "carts:rail")
		table.insert(flow_through_nodes, "carts:powerrail")
		table.insert(flow_through_nodes, "carts:brakerail")
	end
	
	dynamic_liquid.flow_through_abm({nodenames = flow_through_nodes})
end

if dynamic_liquid.config.mapgen_prefill then
	dynamic_liquid.mapgen_prefill({liquid="default:water_source", liquid_level=water_level})
end

-- Springs
-----------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------
-- Cooling lava
if dynamic_liquid.config.new_lava_cooling then
	default.cool_lava = function(pos, node)
		-- no-op disables default cooling ABM
	end
	
	dynamic_liquid.cooling_lava({
		flowing_destroys = {"default:water_flowing", "default:river_water_flowing", "default:snow", "default:snowblock"},
		source_destroys = {	"default:water_source",
			"default:river_water_source",
			"default:water_flowing",
			"default:river_water_flowing",
			"default:ice",
			"default:snow",
			"default:snowblock",
		},
		lava_source = "default:lava_source",
		lava_flowing = "default:lava_flowing",
		obsidian = "default:obsidian",
		cooling_sound = "default_cool_lava",
	})
end