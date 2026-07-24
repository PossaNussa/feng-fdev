
local grassnodes = {
	[minetest.get_content_id 'default:dirt_with_grass'] = true,
}

-- Source nodes use paramtype2='color' (256-entry palette).  Flowing nodes are
-- coloured at runtime via colorflowingliquid (see water.lua); mapgen output
-- contains virtually no flowing nodes, so only sources are handled here.
local waternodes = {
	[minetest.get_content_id 'default:water_source'] = true,
	[minetest.get_content_id 'default:river_water_source'] = true,
	[minetest.get_content_id 'sailing:shallow_water_source'] = true,
}

local alt_chill = minetest.settings: get_bool('awg.grass_alt_chill', true)
local alt_dry = minetest.settings: get_bool('awg.grass_alt_dry', true)

local water_depth_dry = minetest.settings: get_bool('awg.water_depth_dry', true)
local water_alt_chill = minetest.settings: get_bool('awg.water_alt_chill', true)

local water_color = minetest.settings: get_bool('awg.water_color', true)

local floor, min, max = math.floor, math.min, math.max

local function scale_index(heat, humidity)
	local heat_scaled = min(15, floor((max(0, min(heat, 100)) / 100) * 16))
	local humidity_scaled = min(15, floor((max(0, min(humidity, 100)) / 100) * 16))
	return humidity_scaled * 16 + heat_scaled
end

local function grass_color_at(heat, humidity, y)
	if y > 80 then
		if alt_chill then heat = heat - (y - 80) * 0.5 end
		if alt_dry then humidity = humidity - (y - 80) * 0.75 end
	end
	return scale_index(heat, humidity)
end

local function water_color_at(heat, humidity, y)
	if water_alt_chill and y > 90 then
		heat = heat - (y - 90) * 0.75
		humidity = humidity - (y - 90) * 0.75
	end
	-- Deep water reads progressively drier/darker
	if water_depth_dry and y < -15 then
		humidity = max(0, humidity + y * 0.25)
	end
	return scale_index(heat, humidity)
end

minetest.register_on_generated(function(vm, minp, maxp, blockseed)
	local dat = vm: get_data()
	local p2dat = vm: get_param2_data()

	local emin, emax = vm: get_emerged_area()
	local area = VoxelArea(emin, emax)
	local ystride = area.ystride

	local biome_pos = {x = 0, y = 0, z = 0}
	local touched = false

	for z = emin.z, emax.z do
		for x = emin.x, emax.x do
			-- Heat/humidity noise is 2D: fetch it once per column, lazily.
			local heat0, hum0
			local vi = area: index(x, emin.y, z)
			for y = emin.y, emax.y do
				local id = dat[vi]
				local is_grass = grassnodes[id]
				local is_water = water_color and waternodes[id]
				if is_grass or is_water then
					if not heat0 then
						biome_pos.x, biome_pos.y, biome_pos.z = x, y, z
						local biomedat = minetest.get_biome_data(biome_pos)
						heat0, hum0 = biomedat.heat, biomedat.humidity
					end
					if is_grass then
						p2dat[vi] = grass_color_at(heat0, hum0, y)
					else
						p2dat[vi] = water_color_at(heat0, hum0, y)
					end
					touched = true
				end
				vi = vi + ystride
			end
		end
	end

	if touched then
		vm: set_param2_data(p2dat)
	end
end)
