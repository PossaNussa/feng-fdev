
minetest.register_node('etcetera:dust', {
	displayname = 'Dust',
	drawtype = 'nodebox',
	tiles = {{
		name = 'etc_dust.png',
		animation = nil,
		scale = 1,
		backface_culling = false,
		align_style = 'world',
	}},
	paramtype = 'light',
	use_texture_alpha = 'blend', -- Makes the texture rendered with transparency
	alpha = 128, -- Sets 50% transparency (255 is fully opaque, 0 is fully transparent)
	groups = {crumbly = 3, falling_node = 1},
	sounds = default.node_sound_sand_defaults(),
	node_box = {
		type = 'fixed',
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}, -- 1/5 block height
	},
	selection_box = {
		type = 'fixed',
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}, -- Matches the node's collision box
	},
})

minetest.register_craft {
	type ='shapeless',
	output = 'default:clay',
	recipe = {'bucket:bucket_water', 'etcetera:dust'},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'}}
}

minetest.register_craft {
	type ='shapeless',
	output = 'default:clay 8',
	recipe = {'bucket:bucket_water', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust'},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'}}
}

minetest.register_abm({
    label = "Spawn dust in room corners",
    nodenames = {"group:stone", "group:wood"}, -- assume walls are made of stone or wood
    interval = 900, -- every 15 minutes
    chance = 80, -- 1 in 50 chance per eligible node
    action = function(pos, node)
        local above = {x = pos.x, y = pos.y + 1, z = pos.z}
        local air_node = minetest.get_node(above)
        
        if air_node.name == "air" then
            -- Check surrounding nodes
            local x_plus = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
            local x_minus = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
            local z_plus = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
            local z_minus = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})

            -- Check for corner condition
            if (x_plus.name ~= "air" and z_plus.name ~= "air") or
               (x_minus.name ~= "air" and z_minus.name ~= "air") or
               (x_plus.name ~= "air" and z_minus.name ~= "air") or
               (x_minus.name ~= "air" and z_plus.name ~= "air") then
               
               -- Place dust
               minetest.set_node(above, {name = "etcetera:dust"})
            end
        end
    end
})

minetest.register_abm({
    label = "Spread dust",
    nodenames = {"etcetera:dust"},
    interval = 900, -- every 15 minutes
    chance = 100, -- 1 in 100 chance per dust node
    action = function(pos, node)
        local possible_positions = {
            {x = pos.x + 1, y = pos.y, z = pos.z},
            {x = pos.x - 1, y = pos.y, z = pos.z},
            {x = pos.x, y = pos.y, z = pos.z + 1},
            {x = pos.x, y = pos.y, z = pos.z - 1},
            {x = pos.x, y = pos.y - 1, z = pos.z}, -- allows dust to spawn below
        }

        for _, new_pos in ipairs(possible_positions) do
            if minetest.get_node(new_pos).name == "air" then
                minetest.set_node(new_pos, {name = "etcetera:dust"})
                break
            end
        end
    end
})

minetest.register_abm({
	nodenames = {'etcetera:dust'},
	interval = 1.0,
	chance = 1,
	action = function(pos, node)
		local height = 1 -- Default to 1/5 block
		local neighbors = 0
		for _, dir in ipairs({
			{x = 1, y = 0, z = 0}, {x = -1, y = 0, z = 0},
			{x = 0, y = 1, z = 0}, {x = 0, y = -1, z = 0},
			{x = 0, y = 0, z = 1}, {x = 0, y = 0, z = -1},
		}) do
			local npos = vector.add(pos, dir)
			local nn = minetest.get_node(npos)
			if nn.name == 'etcetera:dust' then
				local nn_height = nn.param2 or 0
				if nn_height > height then
					height = nn_height
				end
				neighbors = neighbors + 1
			end
		end

		local new_height = math.min(height + 1, 5) -- Limit height to 5/5
		if neighbors >= 2 and new_height > height then
			local meta = minetest.get_meta(pos)
			if meta then
				meta:set_int("height", new_height)
			end
			minetest.set_node(pos, {name = 'etcetera:dust', param2 = new_height})
		end
	end,
})