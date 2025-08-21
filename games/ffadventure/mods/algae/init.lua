-- Translation support
local S = minetest.get_translator("algae")

--
-- Algae
--

local algae_thin_def = {
	description = S("Thin algae"),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"algae_thin_1.png", "algae_thin_1.png"},
	inventory_image = "algae_thin_1.png",
	wield_image = "algae_thin_1.png",
    	use_texture_alpha = clip,
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.75, -0.5, 0.6, -0.5, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer, itemstack,
					pointed_thing)
		end

		if def and def.liquidtype == "source" and
				(minetest.get_item_group(node.name, "water") > 0 or node.name == "default:liquid_mud_source") then
			local player_name = placer and placer:get_player_name() or ""
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "algae:algae_thin",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, S("Node is protected."))
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
}

local algae_medium_def = {
	description = S("Medium algae"),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"algae_medium_1.png", "algae_medium_1.png"},
	inventory_image = "algae_medium_1.png",
	wield_image = "algae_medium_1.png",
    	use_texture_alpha = clip,
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.75, -0.5, 0.5, -0.5, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer, itemstack,
					pointed_thing)
		end

		if def and def.liquidtype == "source" and
				(minetest.get_item_group(node.name, "water") > 0 or node.name == "default:liquid_mud_source") then
			local player_name = placer and placer:get_player_name() or ""
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "algae:algae_medium",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, S("Node is protected."))
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
}

local algae_thick_def = {
	description = S("Thick algae"),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"algae_thick_1.png", "algae_thick_1.png"},
	inventory_image = "algae_thick_1.png",
	wield_image = "algae_thick_1.png",
    	use_texture_alpha = clip,
	liquids_pointable = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flower = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.75, -0.5, 0.5, -0.5, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, -15 / 32, 7 / 16}
	},

	on_place = function(itemstack, placer, pointed_thing)
        if placer == nil then
            minetest.log("decorations have no placer")
        end
		local pos = pointed_thing.above
		local node = minetest.get_node(pointed_thing.under)
		local def = minetest.registered_nodes[node.name]

		if def and def.on_rightclick then
			return def.on_rightclick(pointed_thing.under, node, placer, itemstack,
					pointed_thing)
		end

		if def and def.liquidtype == "source" and
				(minetest.get_item_group(node.name, "water") > 0 or node.name == "default:liquid_mud_source") then
			local player_name = placer and placer:get_player_name() or ""
			if not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "algae:algae_thick",
					param2 = math.random(0, 3)})
				if not (creative and creative.is_enabled_for
						and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, S("Node is protected."))
				minetest.record_protection_violation(pos, player_name)
			end
		end

		return itemstack
	end
}




minetest.register_node("algae:algae_thin", algae_thin_def)
minetest.register_node("algae:algae_medium", algae_medium_def)
minetest.register_node("algae:algae_thick", algae_thick_def)



---
--- Mapgen for algae
---

minetest.register_biome({
		name = "deciduous_forest_oceansurface",
		y_max = 5,
		y_min = -5,
		heat_point = 60,
		humidity_point = 68,
	})

minetest.register_decoration({
		name = "algae_thick1",
		deco_type = "simple",
		place_on = {"default:dirt"},
        spawn_by = {"default:dirt_with_grass"},
        num_spawn_by = 3,        
		sidelen = 8,
		fill_ratio = 0.7,
		biomes = {"rainforest_swamp", "savanna_shore", "deciduous_forest_shore"},
		y_max = 0,
		y_min = 0,
		decoration = "algae:algae_thick",
		param2 = 0,
		param2_max = 3,
		place_offset_y = 1,
})

minetest.register_decoration({
		name = "algae_thick_rainforest",
		deco_type = "simple",
		place_on = {"default:water_source"},
        spawn_by = {"default:papyrus"},
        num_spawn_by = 3,        
		sidelen = 16,
		fill_ratio = 0.7,
		biomes = {"rainforest_swamp", "swamp", "savanna_shore", "deciduous_forest_shore"},
		y_max = 1,
		y_min = 1,
		decoration = "algae:algae_thick",
		param2 = 0,
		param2_max = 3,
		place_offset_y = 0,
        flags = "liquid_surface",
})


minetest.register_decoration({
		name = "algae_medium",
		deco_type = "simple",
		place_on = {"default:water_source"},
		sidelen = 16,
		fill_ratio = 2,
        spawn_by = {"algae:algae_thick"},
        num_spawn_by = 1,   
		y_max = 1,
		y_min = 1,
        param2 = 0,
		param2_max = 3,
		decoration = "algae:algae_medium",
		flags = "liquid_surface",
})

minetest.register_decoration({
		name = "algae_thick2",
		deco_type = "simple",
		place_on = {"default:water_source"},
		sidelen = 16,
		fill_ratio = 0.7,
        spawn_by = {"algae:algae_medium"},
        num_spawn_by = 2,   
		y_max = 1,
		y_min = 1,
        param2 = 0,
		param2_max = 3,
		decoration = "algae:algae_thick",
		flags = "liquid_surface",
})

minetest.register_decoration({
		name = "algae_thin",
		deco_type = "simple",
		place_on = {"default:water_source"},
		sidelen = 16,
		fill_ratio = 3,
        spawn_by = {"algae:algae_medium"},
        num_spawn_by = 1,   
		y_max = 1,
		y_min = 1,
        param2 = 0,
		param2_max = 3,
		decoration = "algae:algae_thin",
		flags = "liquid_surface",
})

minetest.register_decoration({
		name = "algae_thin2",
		deco_type = "simple",
		place_on = {"default:water_source"},
		sidelen = 16,
		fill_ratio = 3,
        spawn_by = {"algae:algae_thick"},
        num_spawn_by = 1,   
		y_max = 1,
		y_min = 1,
        param2 = 0,
		param2_max = 3,
		decoration = "algae:algae_thin",
		flags = "liquid_surface",
})


minetest.register_abm({
    label = "Algae growth on mud",
    nodenames = {"default:liquid_mud_source"},
    interval = 600,  -- 15 minutes (900 seconds)
    chance = 100,   -- 15% chance (approximately 1 in 6.66)
    catch_up = false,
    action = function(pos, node)
        -- Get the position above the mud
        local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
        local above_node = minetest.get_node(above_pos)

        -- Check if the position above is air (or water if you want it to spread in water too)
        if above_node.name == "air" then
            -- Check for light conditions (optional, remove if not needed)
            local light = minetest.get_node_light(above_pos, nil)
            if light and light >= 10 then
                -- Place light algae if none is present
                minetest.set_node(above_pos, {name = "algae:algae_thin"})
            end
        elseif above_node.name == "algae:algae_thin" then
            -- Upgrade to medium algae
            minetest.set_node(above_pos, {name = "algae:algae_medium"})
        elseif above_node.name == "algae:algae_medium" then
            -- Upgrade to thick algae
            minetest.set_node(above_pos, {name = "algae:algae_thick"})
        end
    end
})

minetest.register_abm({
    label = "Rare Algae Upgrade",
    nodenames = {"algae:algae_thin", "algae:algae_medium"},
    interval = 650,  -- 10 minutes (600 seconds)
    chance = 100,     -- 2% chance (approximately 1 in 50)
    catch_up = false,
    action = function(pos, node)
        if node.name == "algae:algae_thin" then
            minetest.set_node(pos, {name = "algae:algae_medium"})
        elseif node.name == "algae:algae_medium" then
            minetest.set_node(pos, {name = "algae:algae_thick"})
        end
    end
})

minetest.register_abm({
    label = "Medium Algae Spreading",
    nodenames = {"algae:algae_medium"},
    neighbors = {"default:liquid_mud_source", "default:water_source"},
    interval = 300,  -- 5 minutes (300 seconds)
    chance = 95,     -- 10% chance to spread
    catch_up = false,
    action = function(pos, node)
        -- Define positions around the medium algae
        local positions = {
            {x = pos.x + 1, y = pos.y, z = pos.z},
            {x = pos.x - 1, y = pos.y, z = pos.z},
            {x = pos.x, y = pos.y, z = pos.z + 1},
            {x = pos.x, y = pos.y, z = pos.z - 1},
        }

        for _, p in ipairs(positions) do
            local below = minetest.get_node(p)
            local above = minetest.get_node({x = p.x, y = p.y + 1, z = p.z})

            if (below.name == "default:liquid_mud_source" or below.name == "default:water_source") and above.name == "air" then
                minetest.set_node({x = p.x, y = p.y + 1, z = p.z}, {name = "algae:algae_thin"})
            end
        end
    end
})

minetest.register_abm({
    label = "Thick Algae Spreading",
    nodenames = {"algae:algae_thick"},
    neighbors = {"default:liquid_mud_source", "default:water_source"},
    interval = 300,  -- 5 minutes (300 seconds)
    chance = 50,     -- 15% chance to spread
    catch_up = false,
    action = function(pos, node)
        -- Define positions around the thick algae
        local positions = {
            {x = pos.x + 1, y = pos.y, z = pos.z},
            {x = pos.x - 1, y = pos.y, z = pos.z},
            {x = pos.x, y = pos.y, z = pos.z + 1},
            {x = pos.x, y = pos.y, z = pos.z - 1},
        }

        for _, p in ipairs(positions) do
            local below = minetest.get_node(p)
            local above = minetest.get_node({x = p.x, y = p.y + 1, z = p.z})

            if (below.name == "default:liquid_mud_source" or below.name == "default:water_source") and above.name == "air" then
                minetest.set_node({x = p.x, y = p.y + 1, z = p.z}, {name = "algae:algae_medium"})
            end
        end
    end
})
