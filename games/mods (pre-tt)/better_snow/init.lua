-- Minetest Mod: "Better Snow"

-- Settings --
local snow_gen = true		-- (true/false) Generate snow.
local ice_gen = true		-- (true/false) Generate ice.
local snow_stairs = true	-- (true/false) Snow stairs.
local ice_stairs = true		-- (true/false) Ice stairs.
local freezing = true		-- (true/false) Freezing.
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
		nodenames = {"group:water"},
		neighbors = {"default:ice", "default:snow", "defualt:snowblock"},
		interval = 15,
		chance = 2,
		action = function(pos, node, active_object_count, active_object_count_wider)
			-- Don't freeze if near heat source.
			if minetest.find_node_near(pos, 1, "group:igniter")
				or minetest.find_node_near(pos, 1, "default:torch")
				or minetest.find_node_near(pos, 1, "default:furnace_active") then
					return
			end
			-- Water Source --> Ice; Flowing Water --> Snow
			if node.name == "default:water_source" then
				minetest.set_node(pos, {name = "default:ice"})
			elseif node.name == "default:water_flowing" then
				minetest.set_node(pos, {name = "default:snow"})
			end
		end,
	})
end

-- Melting
if melting then
	minetest.register_abm({
		nodenames = {"default:ice", "default:snow", "default:snowblock"},
		neighbors = {"group:igniter", "default:torch", "default:furnace_active"},
		interval = 15,
		chance = 2,
		action = function(pos, node, active_object_count, active_object_count_wider)
				-- Ice or Snowblock --> Water Source; Snow --> Flowing Water
				if node.name == "default:ice" then
					minetest.set_node(pos, {name = "default:water_source"})
				elseif node.name == "default:snowblock" then
					minetest.set_node(pos, {name = "default:water_source"})
				elseif node.name == "default:snow" then
					minetest.set_node(pos, {name = "default:water_flowing"})
				end
		end
	})
end
