
local S = farming.translate

-- item definition
minetest.register_craftitem("farming:parsley", {
	description = S("Parsley"),
	inventory_image = "farming_parsley.png",
	groups = {compostability = 48, seed = 2, food_parsley = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:parsley_1")
	end
})

-- crop definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_parsley_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop =  "",
	waving = 1,
	selection_box = farming.select,
	groups = {
		handy = 1, snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = farming.sounds.node_sound_leaves_defaults(),
	_heat_min = 40, _heat_max = 70, _hum_min = 38, _hum_max = 75,
}

-- stage 1
minetest.register_node("farming:parsley_1", table.copy(def))

-- stage 2
def.tiles = {"farming_parsley_2.png"}
minetest.register_node("farming:parsley_2", table.copy(def))

-- stage 3 (final)
def.tiles = {"farming_parsley_3.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"farming:parsley 2"}, rarity = 1},
		{items = {"farming:parsley"}, rarity = 2},
		{items = {"farming:parsley"}, rarity = 3}
	}
}
minetest.register_node("farming:parsley_3", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:parsley"] = {
	crop = "farming:parsley",
	seed = "farming:parsley",
	minlight = 13,
	maxlight = 15,
	steps = 3
}

-- mapgen
minetest.register_on_mods_loaded(function()
	-- temperate, moderate moisture (heat 40-70, hum 38-75)
	local place_on, biomes, seen = {}, {}, {}
	for bname, bdef in pairs(minetest.registered_biomes) do
		if not bname:find('_under') then
			local h = bdef.heat_point or -1
			local w = bdef.humidity_point or -1
			if h >= 40 and h <= 70 and w >= 38 and w <= 75 then
				biomes[#biomes + 1] = bname
				local top = bdef.node_top
				if top and minetest.registered_nodes[top] and not seen[top] then
					seen[top] = true
					place_on[#place_on + 1] = top
				end
			end
		end
	end
	if next(place_on) then
		minetest.register_decoration({
			deco_type = "simple",
			place_on = place_on,
			sidelen = 16,
			biomes = biomes,
			noise_params = {
				offset = 0,
				scale = farming.parsley,
				spread = {x = 100, y = 100, z = 100},
				seed = 23,
				octaves = 3,
				persist = 0.6
			},
			y_min = 5,
			y_max = 50,
			decoration = "farming:parsley_3"
		})
	end
end)
