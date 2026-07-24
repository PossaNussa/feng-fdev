
local S = farming.translate

-- Strawberry (can also be planted as seed)
minetest.register_craftitem(":ethereal:strawberry", {
	description = S("Strawberry"),
	inventory_image = "ethereal_strawberry.png",
	groups = {
		compostability = 48, seed = 2, food_strawberry = 1, food_berry = 1, flammable = 2
	},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "ethereal:strawberry_1")
	end,
	on_use = minetest.item_eat(1)
})

-- Define Strawberry Bush growth stages
local def = {
	drawtype = "plantlike",
	tiles = {"ethereal_strawberry_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5}
	},
	groups = {
		handy = 1, snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = farming.sounds.node_sound_leaves_defaults(),
	_heat_min = 25, _heat_max = 62, _hum_min = 45, _hum_max = 78,
}

--stage 1
minetest.register_node(":ethereal:strawberry_1", table.copy(def))

-- stage 2
def.tiles = {"ethereal_strawberry_2.png"}
minetest.register_node(":ethereal:strawberry_2", table.copy(def))

-- stage 3
def.tiles = {"ethereal_strawberry_3.png"}
minetest.register_node(":ethereal:strawberry_3", table.copy(def))

-- stage 4
def.tiles = {"ethereal_strawberry_4.png"}
minetest.register_node(":ethereal:strawberry_4", table.copy(def))

-- stage 5
def.tiles = {"ethereal_strawberry_5.png"}
minetest.register_node(":ethereal:strawberry_5", table.copy(def))

-- stage 6
def.tiles = {"ethereal_strawberry_6.png"}
def.drop = {
	items = {
		{items = {"ethereal:strawberry 1"}, rarity = 2},
		{items = {"ethereal:strawberry 2"}, rarity = 3}
	}
}
minetest.register_node(":ethereal:strawberry_6", table.copy(def))

-- stage 7
def.tiles = {"ethereal_strawberry_7.png"}
def.drop = {
	items = {
		{items = {"ethereal:strawberry 1"}, rarity = 1},
		{items = {"ethereal:strawberry 2"}, rarity = 3}
	}
}
minetest.register_node(":ethereal:strawberry_7", table.copy(def))

-- stage 8
def.tiles = {"ethereal_strawberry_8.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"ethereal:strawberry 2"}, rarity = 1},
		{items = {"ethereal:strawberry 3"}, rarity = 3}
	}
}
minetest.register_node(":ethereal:strawberry_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["ethereal:strawberry"] = {
	crop = "ethereal:strawberry",
	seed = "ethereal:strawberry",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 8
}

-- mapgen
minetest.register_on_mods_loaded(function()
	-- cool temperate, good moisture (heat 25-62, hum 45-78)
	local place_on, biomes, seen = {}, {}, {}
	for bname, bdef in pairs(minetest.registered_biomes) do
		if not bname:find('_under') then
			local h = bdef.heat_point or -1
			local w = bdef.humidity_point or -1
			if h >= 25 and h <= 62 and w >= 45 and w <= 78 then
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
				scale = farming.strawberry,
				spread = {x = 100, y = 100, z = 100},
				seed = 143,
				octaves = 3,
				persist = 0.6
			},
			y_min = 5,
			y_max = 55,
			decoration = "ethereal:strawberry_7"
		})
	end
end)
