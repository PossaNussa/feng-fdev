

local alt_chill = minetest.settings: get_bool('awg.grass_alt_chill', true)
local alt_dry = minetest.settings: get_bool('awg.grass_alt_dry', true)
local grass_water_prox = minetest.settings: get_bool('awg.grass_water_prox', true)

function awg.get_biome_color (pos)
	local biomedat = minetest.get_biome_data(pos)
	
	local heat = biomedat.heat
	local humidity = biomedat.humidity
	
	if pos.y > 80 then
		heat = heat - (alt_chill and ((pos.y - 80) * 0.5) or 0)
		humidity = humidity - (alt_dry and ((pos.y - 80) * 0.75) or 0)
	end
	
	if grass_water_prox then
		local water = minetest.find_node_near(pos, 8, {
			'default:water_source', 'default:river_water_source',
			'default:water_flowing', 'default:river_water_flowing'
		})
		
		if water then
			local dist = pos: distance(water)
			humidity = humidity + (math.max(0, 8 - dist - math.random(0, 1)) * 4.5)
		end
	end
	
	local heat_scaled = math.floor((math.max(0, math.min(heat, 100)) / 100) * 16)
	local humidity_scaled = math.floor((math.max(0, math.min(humidity, 100)) / 100) * 16)
	
	return math.max(0, math.min(255, (16 * math.min(15, humidity_scaled)) + math.min(15, heat_scaled)))
end

local function grass_after_place (pos, placer, itemstack, pointed_thing)
	if placer: get_player_control().sneak then
		local node = minetest.get_node(pos)
		node.param2 = 136
		minetest.set_node(pos, node)
		
		local meta = minetest.get_meta(pos)
		meta: set_string('awg:no_recolor', 'true')
		
		return
	end
	
	local node = minetest.get_node(pos)
	node.param2 = awg.get_biome_color(pos)
	minetest.set_node(pos, node)
end

--minetest.override_item('default:dirt', {groups = {dirt = 1}})
--minetest.override_item('default:dirt_with_coniferous_litter', {groups = {dirt = 1}})
--minetest.override_item('default:dirt_with_rainforest_litter', {groups = {dirt = 1}})
--minetest.override_item('default:dirt_with_snow', {groups = {dirt = 1}})
--minetest.override_item('default:sand', {groups = {sand = 1}})
--minetest.override_item('default:silver_sand', {groups = {sand = 1}})
--minetest.override_item('default:desert_sand', {groups = {sand = 1}})
--minetest.override_item('default:gravel', {groups = {gravel = 1}})

minetest.override_item('default:dirt_with_grass', {
	tiles = {
		{name = 'awg_grass.png'},
		{name = 'default_dirt.png', color = 'white'},
		{name = 'default_dirt.png', color = 'white'}
	},
	overlay_tiles = {
		'',
		'',
		'awg_grass_side.png'
	},
	use_texture_alpha = 'blend',
	paramtype2 = 'color',
	color = '#4AA432',
	palette = 'awg_grass_colormap.png',
	after_place_node = grass_after_place
})

minetest.register_abm {
	label = 'Grass Color Update',
	nodenames = {
		'default:dirt_with_grass',
	},
	interval = 30,
	chance = 10,
	catch_up = true,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		if meta: get_string 'awg:no_recolor' == 'true' then return end
		
		node.param2 = awg.get_biome_color(pos)
		minetest.swap_node(pos, node)
	end
}

local dead_grass = minetest.settings: get_bool('awg.dead_grass', true)

if dead_grass then
	awg: inherit_item('default:dirt_with_grass', 'dirt_with_dead_grass', {
		displayname = 'Dirt with Dead Grass',
		description = '',
		groups = {crumbly = 3, soil = 1},
		palette = 'awg_dead_grass_colormap.png',
		color = '#594a28',
		tiles = {
			{name = 'default_dirt.png', color = 'white'},
			{name = 'default_dirt.png', color = 'white'},
			{name = 'default_dirt.png', color = 'white'}
		},
		overlay_tiles = {
			'awg_dead_grass.png',
			'',
			'awg_dead_grass_side.png'
		}
	})

local caught = 0

for i, abm in pairs(minetest.registered_abms) do
	if caught == 2 then break end
	
	if abm.label == 'Grass covered' then
		caught = caught + 1
		
if dead_grass then
    abm.action = function(pos, node)
        local above = vector.add(pos, {x = 0, y = 1, z = 0})
        local above_node = minetest.get_node_or_nil(above)

        -- Ensure node data is valid
        if not above_node then return end

        local name = above_node.name
        local def = minetest.registered_nodes[name]

        if name ~= 'ignore' and def and not (def.sunlight_propagates or def.paramtype == 'light') then
            -- Try-catch block to handle decompression issues
            local success, err = pcall(function()
                minetest.set_node(pos, {
                    name = 'always_greener:dirt_with_dead_grass',
                    param2 = awg.get_biome_color(pos)
                })
            end)

            -- Log error if decompression fails
            if not success then
                minetest.log("error", "Failed to set node at " .. minetest.pos_to_string(pos) .. ": " .. err)
            end
        end
    end
end
end

	
	if abm.label == 'Grass spread' then
		caught = caught + 1
		
		abm.action = function(pos, node)
			local above = pos + vector.new(0, 1, 0)
			if (minetest.get_node_light(above) or 0) < 13 then return end
			
			local pos2 = minetest.find_node_near(pos, 1, 'group:spreading_dirt_type')
			if pos2 then
				local near_node = minetest.get_node(pos2)
				near_node.param2 = awg.get_biome_color(pos)
				minetest.set_node(pos, near_node)
				return
			end

			local name = minetest.get_node(above).name
			if name == 'default:snow' then
				minetest.set_node(pos, {name = 'default:dirt_with_snow'})
			elseif minetest.get_item_group(name, 'grass') + minetest.get_item_group(name, 'dry_grass') ~= 0 then
				minetest.set_node(pos, {name = 'default:dirt_with_grass', param2 = awg.get_biome_color(pos)})
			end
		end
	end
end
end
