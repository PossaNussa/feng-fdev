
-- Biome-tinted water.
-- Source nodes use paramtype2 = "color": full 256-entry palette, laid out as a
-- 16x16 humidity x heat grid (param2 = hum_bucket * 16 + heat_bucket).
-- NOTE: v7_rivers/mapgen.lua colours generated river water with the same
-- encoding — keep the two formulas in sync.
local function get_biome_water_color(pos)
	local biomedat = minetest.get_biome_data(pos)

	local heat = biomedat.heat
	local humidity = biomedat.humidity

	-- Deep water reads progressively drier/darker
	if pos.y < -15 then
		humidity = math.max(0, humidity + (pos.y * 0.25))
	end

	local heat_scaled = math.min(15, math.floor((math.max(0, math.min(heat, 100)) / 100) * 16))
	local humidity_scaled = math.min(15, math.floor((math.max(0, math.min(humidity, 100)) / 100) * 16))

	return humidity_scaled * 16 + heat_scaled
end

-- Flowing water uses colorflowingliquid: 4-bit color (0-15) in upper nibble of
-- param2, flow data in lower nibble.  Palette has 16 entries sampled from the
-- full 256-entry source palette at 4x4 coarser resolution.
local function get_biome_flowing_water_color(pos)
	local biomedat = minetest.get_biome_data(pos)
	local heat     = biomedat.heat
	local humidity = biomedat.humidity

	if pos.y < -15 then
		humidity = math.max(0, humidity + (pos.y * 0.25))
	end

	local heat_bucket = math.min(3, math.floor((math.max(0, math.min(heat,     100)) / 100) * 4))
	local hum_bucket  = math.min(3, math.floor((math.max(0, math.min(humidity, 100)) / 100) * 4))
	return hum_bucket * 4 + heat_bucket  -- 0-15
end

local function water_on_construct(pos)
	local node = minetest.get_node(pos)
	node.param2 = get_biome_water_color(pos)
	minetest.swap_node(pos, node)
end

local alt_map = minetest.settings:get_bool('awg.water_color_dull', false)

local src_palette  = alt_map and 'awg_water_colormap_2.png'      or 'awg_water_colormap.png'
local flow_palette = alt_map and 'awg_water_colormap_2_flow.png'  or 'awg_water_colormap_flow.png'

local source_nodes  = {}
local flowing_nodes = {}

local function register_source(name)
	minetest.override_item(name, {
		paramtype2 = 'color',
		color = '#ffffff',
		palette = src_palette,
		on_construct = water_on_construct
	})
	source_nodes[name] = true
end

local function register_flowing(name)
	minetest.override_item(name, {
		paramtype2 = 'colorflowingliquid',
		color = '#ffffff',
		palette = flow_palette,
	})
	flowing_nodes[name] = true
end

register_source('default:water_source')
register_source('default:river_water_source')
register_flowing('default:water_flowing')
register_flowing('default:river_water_flowing')

if minetest.registered_nodes['sailing:shallow_water_source'] then
	register_source('sailing:shallow_water_source')
end

if minetest.registered_nodes['sailing:shallow_water_flowing'] then
	register_flowing('sailing:shallow_water_flowing')
end

-- The engine rebuilds param2 from scratch whenever it updates a flowing liquid
-- node (level | flow-down bit), which zeroes the colour nibble, and new sources
-- formed from flowing water inherit a stale nibble.  Recolour exactly the nodes
-- the transform touched — they are all listed in pos_list, so no area scan is
-- needed.
minetest.register_on_liquid_transformed(function(pos_list)
	for i = 1, #pos_list do
		local pos = pos_list[i]
		local node = minetest.get_node(pos)
		local name = node.name

		if source_nodes[name] then
			local color = get_biome_water_color(pos)
			if node.param2 ~= color then
				node.param2 = color
				minetest.swap_node(pos, node)
			end
		elseif flowing_nodes[name] then
			local color = get_biome_flowing_water_color(pos)
			local new_p2 = bit.bor(bit.band(node.param2, 0x0F), bit.lshift(color, 4))
			if node.param2 ~= new_p2 then
				node.param2 = new_p2
				minetest.swap_node(pos, node)
			end
		end
	end
end)
