-- Minetest Mod: "Better Snow"

-- Settings --
local snow_gen = true		-- (true/false) Generate snow.
local ice_gen = true		-- (true/false) Generate ice.
local snow_stairs = true	-- (true/false) Snow stairs.
local ice_stairs = true		-- (true/false) Ice stairs.
local freezing = false		-- disabled: cascading freeze solidifies oceans. regional_weather handles ice.
local melting = true		-- (true/false) Melting.

-- Torch + Snowblock --> Water + Torch
minetest.register_craft({
	type = "shapeless",
	output = "default:water_source",
	recipe = {"default:snowblock", "default:torch"},
	replacements = {{"default:torch", "default:torch"}},
})

-- Dirt + Snow --> Dirt w/Snow
minetest.register_craft({
	type = "shapeless",
	output = "default:dirt_with_snow",
	recipe = {"default:dirt", "default:snow"},
})

-- Freezing
if freezing then
	minetest.register_abm({
		label = "better_snow: freeze water",
		nodenames = {"group:water"},
		neighbors = {"default:ice", "default:snow", "default:snowblock"},
		interval = 15,
		chance = 2,
		catch_up = false,
		action = function(pos, node)
			-- Don't freeze if near heat source.
			if minetest.find_node_near(pos, 1, "group:igniter")
				or minetest.find_node_near(pos, 1, "default:torch")
				or minetest.find_node_near(pos, 1, "default:furnace_active") then
					return
			end
			-- Water Source --> Ice; Flowing Water --> Snow (one step)
			if node.name == "default:water_source" then
				minetest.set_node(pos, {name = "default:ice"})
			elseif node.name == "default:water_flowing" then
				minetest.set_node(pos, {name = "default:snow", param2 = 8})
			end
		end,
	})
end

-- Melting
if melting then
	minetest.register_abm({
		label = "better_snow: melt near heat sources",
		nodenames = {"default:ice", "default:snow", "default:snowblock"},
		neighbors = {"group:igniter", "default:torch", "default:furnace_active"},
		interval = 15,
		chance = 2,
		catch_up = false,
		action = function(pos, node)
			-- Ice or Snowblock --> Water Source; Snow --> Air (not water_flowing —
			-- thin leveled snow evaporates near heat, it doesn't flood)
			if node.name == "default:ice" then
				minetest.set_node(pos, {name = "default:water_source"})
			elseif node.name == "default:snowblock" then
				minetest.set_node(pos, {name = "default:water_source"})
			elseif node.name == "default:snow" then
				minetest.set_node(pos, {name = "air"})
			end
		end
	})
end
