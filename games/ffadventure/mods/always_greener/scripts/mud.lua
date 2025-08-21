awg: inherit_item('default:mud', 'mud_with_grass', {
	displayname = 'Mud With Grass',
	description = '',
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	tiles = {'awg_grass.png^[multiply:#2d591d', 'mud.png', 'mud.png^(awg_dead_grass_side.png^[multiply:#2d591d)'}
})

if minetest.settings: get_bool('awg.craft_grass_blocks', true) then
	minetest.register_craft {
		type = 'shapeless',
		output = 'awg:mud_with_grass',
		recipe = {
			'always_greener:cutting_grass_1', 'always_greener:cutting_grass_1', 'always_greener:cutting_grass_1',
			'always_greener:cutting_grass_1', 'default:mud', 'always_greener:cutting_grass_1',
			'always_greener:cutting_grass_1', 'always_greener:cutting_grass_1', 'always_greener:cutting_grass_1'
		}
	}
end

minetest.register_abm({
    label = "Mud Water Detection",
    nodenames = {"default:dirt_with_grass", "variety:meadow_dirt_with_grass", "biomes_island:island_dirt_with_grass", "default:dirt_with_rainforest_litter"},
    interval = 24,  -- Time between each ABM execution (in seconds)
    chance = 1,  -- Chance of the ABM being executed (1 = always)
    action = function(pos, node)
        -- Search for water within 5 nodes in all directions
        local found_water = false
        for dx = -3, 3 do
            for dy = -3, 3 do
                for dz = -3, 3 do
                    local check_pos = vector.add(pos, {x=dx, y=dy, z=dz})
                    local check_node = minetest.get_node(check_pos)
                    if minetest.get_item_group(check_node.name, "water") > 0 then
                        found_water = true
                        break
                    end
                end
                if found_water then break end
            end
            if found_water then break end
        end

        if found_water then
            -- Turn the soil into wet soil
            minetest.set_node(pos, {name = "awg:mud_with_grass"})
        end
    end
})


minetest.register_abm({
	label = "Grass spread",
	nodenames = {"default:mud"},
	neighbors = {
		"air",
		"group:grass",
		"awg:mud_with_grass",
		"default:dirt_with_grass",
		"variety:meadow_dirt_with_grass"
	},
	interval = 12,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		-- Check for darkness: night, shadow or under a light-blocking node
		-- Returns if ignore above
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 13 then
			return
		end

		-- Look for spreading dirt-type neighbours
		local p2 = minetest.find_node_near(pos, 1, "group:spreading_dirt_type")
		if p2 then
			local n3 = minetest.get_node(p2)
			minetest.set_node(pos, {name = "awg:mud_with_grass"})
			return
		end

		-- Else, any seeding nodes on top?
		local name = minetest.get_node(above).name
		-- Snow check is cheapest, so comes first
		if minetest.get_item_group(name, "grass") ~= 0 then
			minetest.set_node(pos, {name = "awg:mud_with_grass"})
		end
	end
})
