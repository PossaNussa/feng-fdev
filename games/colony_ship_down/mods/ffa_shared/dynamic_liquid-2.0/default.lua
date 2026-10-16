local S = minetest.get_translator(minetest.get_current_modname())

local water_probability = dynamic_liquid.config.water_probability
local river_water_probability = dynamic_liquid.config.river_water_probability
local lava_probability = dynamic_liquid.config.lava_probability
local water_level = dynamic_liquid.config.water_level
local springs = dynamic_liquid.config.springs


if dynamic_liquid.config.lava then
	dynamic_liquid.liquid_abm("default:lava_source", "default:lava_flowing", lava_probability)
end

-- Switch the engine's own finite liquid flow OFF for water (liquid_range = 0) and
-- let the shallow-water system (shallow.lua) plus the movement ABM below be the
-- whole of the water physics.  The engine's flowing water was never spreading the
-- water in any way we wanted — it flung a wide animated sheet out ahead of the
-- real water, that sheet is invisible to the conservation-based shallow code, and
-- a source only turns into shallow once it is on its own, so the shallow water
-- could not form until the whole sheet had drained back and the sources
-- reconsolidated.  That is the lag that looked like water "taking forever" to
-- spread.  Worse, the ABM used to WAKE on that flowing water, so throttling the
-- flow down just left sources sitting still with nothing to trigger them.
--
-- With range 0 the engine creates no flowing water at all.  The movement ABM now
-- wakes on `air` instead (see dynamic_liquids.lua) and moves, drops and settles
-- sources itself with swap_node — no flowing node is ever created, so nothing is
-- lost: servermap.cpp only ever recalculates a *flowing* node down to air, a
-- *source* is always rewritten as a source.  Every bit of real spreading, downhill
-- running and thinning is handled by shallow.lua's 1/8 puddles.
--
-- The one thing given up is the flowing-liquid *animation* on a waterfall; the
-- water still falls (the ABM column-drops it) and pools as shallow at the bottom.

if dynamic_liquid.config.water then
	-- override water_source and water_flowing with liquid_renewable set to false
	local override_def = {liquid_renewable = false, liquid_range = 0}
	minetest.override_item("default:water_source", override_def)
	minetest.override_item("default:water_flowing", override_def)

	dynamic_liquid.liquid_abm("default:water_source", "default:water_flowing", water_probability)
end

if dynamic_liquid.config.river_water then
	local override_def = {liquid_renewable = false, liquid_range = 0}
	minetest.override_item("default:river_water_source", override_def)
	minetest.override_item("default:river_water_flowing", override_def)

	dynamic_liquid.liquid_abm("default:river_water_source", "default:river_water_flowing", river_water_probability)
end

-- Sailing's clear water is ordinary water as far as the player is concerned, so it
-- moves like ordinary water rather than sitting there as a static block.
if dynamic_liquid.config.water and minetest.registered_nodes["sailing:shallow_water_source"] then
	local override_def = {liquid_renewable = false, liquid_range = 0}
	minetest.override_item("sailing:shallow_water_source", override_def)
	minetest.override_item("sailing:shallow_water_flowing", override_def)

	dynamic_liquid.liquid_abm("sailing:shallow_water_source", "sailing:shallow_water_flowing", water_probability)
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
