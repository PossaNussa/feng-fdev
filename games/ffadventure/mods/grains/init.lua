minetest.override_item("farming:bread", {
	description = "Wheat Bread",
})

minetest.override_item("farming:flour", {
	description = "Wheat Flour",
})

-- RYE

farming.register_plant("grains:rye", {
	description = "Rye seed",
	paramtype2 = "meshoptions",
	inventory_image = "grains_rye_seed.png",
	steps = 8,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"savannah"},
	groups = {flammable = 4},
	place_param2 = 3,
	heat_min = 10, heat_max = 55,
	hum_min  = 20, hum_max  = 75,
})

minetest.register_craftitem("grains:rye_bread", {
	description = "Rye Bread",
	inventory_image = "grains_rye_bread.png",
	on_use = minetest.item_eat(5),
	groups = {flammable = 2},
})

minetest.register_craftitem("grains:rye_flour", {
	description = "Rye Flour",
	inventory_image = "grains_rye_flour.png",
	groups = {flammable = 1},
})

-- OAT

farming.register_plant("grains:oat", {
	description = "Oat seed",
	paramtype2 = "meshoptions",
	inventory_image = "grains_oat_seed.png",
	steps = 8,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"savannah"},
	groups = {flammable = 4},
	place_param2 = 3,
	heat_min = 15, heat_max = 50,
	hum_min  = 40, hum_max  = 85,
})

minetest.register_craftitem("grains:oat_bread", {
	description = "Oatbread",
	inventory_image = "grains_oat_bread.png",
	on_use = minetest.item_eat(5),
	groups = {flammable = 2},
})

minetest.register_craftitem("grains:oat_flour", {
	description = "Oat Flour",
	inventory_image = "grains_oat_flour.png",
	groups = {flammable = 1},
})

-- NOTE: grains:barley removed — x_farming:barley covers it with the same stats.

-- Cooking

minetest.register_craft({
	type = "shapeless",
	output = "grains:rye_flour",
	recipe = {"grains:rye", "grains:rye", "grains:rye", "grains:rye"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "grains:rye_bread",
	recipe = "grains:rye_flour"
})

minetest.register_craft({
	type = "shapeless",
	output = "grains:oat_flour",
	recipe = {"grains:oat", "grains:oat", "grains:oat", "grains:oat"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "grains:oat_bread",
	recipe = "grains:oat_flour"
})

-- Fuels
minetest.register_craft({
	type = "fuel",
	recipe = "farming:bread",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "grains:rye_bread",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "grains:oat_bread",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:wheat",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "grains:rye",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "grains:oat",
	burntime = 1,
})

-- Seed gathering from grass
-- x_farming:barley replaces the old grains:seed_barley drop.

for i = 1, 5 do
	minetest.override_item("default:grass_"..i, {drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'}, rarity = 10},
			{items = {'x_farming:barley'},   rarity = 20},
			{items = {'default:grass_1'}},
		}
	}})
end

for i = 1, 5 do
	minetest.override_item("default:dry_grass_"..i, {drop = {
		max_items = 1,
		items = {
			{items = {'grains:seed_rye'}, rarity = 10},
			{items = {'grains:seed_oat'}, rarity = 15},
			{items = {'default:dry_grass_1'}},
		}
	}})
end

-- ============================================================
-- Worldgen: scatter fully-grown rye and oat across suitable
-- climate zones using the same heatmap/humiditymap technique
-- as elysflowers and paleotest/decorations.lua.
-- Heat 0=arctic, 100=tropical.  Humidity 0=arid, 100=saturated.
-- ============================================================

local crop_defs = {
	-- Rye: hardy cool-climate grain, tolerates poor soils and cold.
	-- Real range: temperate-cool, low-to-moderate moisture.
	{
		node     = "grains:rye_8",
		heat_min = 10, heat_max = 55,
		hum_min  = 20, hum_max  = 75,
		step     = 12,
		chance   = 30,
		y_min    = 1,  y_max = 200,
	},
	-- Oat: cool-moist grain, less cold-hardy than rye, needs moisture.
	{
		node     = "grains:oat_8",
		heat_min = 15, heat_max = 50,
		hum_min  = 40, hum_max  = 85,
		step     = 12,
		chance   = 35,
		y_min    = 1,  y_max = 200,
	},
}

local crops         = {}   -- compiled with content IDs
local plantable_cids = {}  -- soil-group content IDs
local c_air_grains

minetest.register_on_mods_loaded(function()
	c_air_grains = minetest.CONTENT_AIR

	for name, def in pairs(minetest.registered_nodes) do
		if (def.groups.soil or 0) > 0 then
			plantable_cids[minetest.get_content_id(name)] = true
		end
	end

	for _, d in ipairs(crop_defs) do
		if minetest.registered_nodes[d.node] then
			crops[#crops + 1] = {
				cid      = minetest.get_content_id(d.node),
				heat_min = d.heat_min, heat_max = d.heat_max,
				hum_min  = d.hum_min,  hum_max  = d.hum_max,
				step     = d.step,
				chance   = d.chance,
				y_min    = d.y_min,    y_max    = d.y_max,
			}
		end
	end
end)

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 1 or #crops == 0 then return end

	local heatmap     = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local heightmap   = minetest.get_mapgen_object("heightmap")
	if not (heatmap and humiditymap and heightmap) then return end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
	local data = vm:get_data()

	local w  = maxp.x - minp.x + 1
	local pr = PseudoRandom(seed + 7741)

	for _, p in ipairs(crops) do
		local step = p.step
		local ox   = pr:next(0, step - 1)
		local oz   = pr:next(0, step - 1)

		for dz = oz, (maxp.z - minp.z), step do
			for dx = ox, (maxp.x - minp.x), step do
				local idx   = dz * w + dx + 1
				local heat  = heatmap[idx]
				local humid = humiditymap[idx]

				if heat and humid
				and heat  >= p.heat_min and heat  <= p.heat_max
				and humid >= p.hum_min  and humid <= p.hum_max then

					local y = heightmap[idx]
					if y and y >= p.y_min and y <= p.y_max then
						local px = minp.x + dx
						local pz = minp.z + dz

						local below_vi = area:index(px, y,     pz)
						local above_vi = area:index(px, y + 1, pz)

						if plantable_cids[data[below_vi]]
						and data[above_vi] == c_air_grains
						and pr:next(1, p.chance) == 1 then
							data[above_vi] = p.cid
						end
					end
				end
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end)
