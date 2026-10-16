
local S = farming.translate
local a = farming.recipe_items

-- wheat seeds
minetest.register_node("farming:seed_wheat", {
	description = S("Wheat Seed"),
	tiles = {"farming_wheat_seed.png"},
	inventory_image = "farming_wheat_seed.png",
	wield_image = "farming_wheat_seed.png",
	drawtype = "signlike",
	groups = {
		handy = 1, seed = 1, snappy = 3, attached_node = 1, flammable = 4, growing = 1
	},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	sunlight_propagates = true,
	selection_box = farming.select,
	next_plant = "farming:wheat_1",
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:seed_wheat")
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "farming:wheat_1", param2 = 3})
	end
})

-- harvested wheat
minetest.register_craftitem("farming:wheat", {
	description = S("Wheat"),
	inventory_image = "farming_wheat.png",
	groups = {food_wheat = 1, flammable = 4}
})

-- straw
minetest.register_node("farming:straw", {
	description = S("Straw"),
	tiles = {"farming_straw.png"},
	is_ground_content = false,
	groups = {handy = 1, snappy = 3, flammable = 4, fall_damage_add_percent = -30},
	sounds = farming.sounds.node_sound_leaves_defaults(),
	_mcl_hardness = 0.8,
	_mcl_blast_resistance = 1
})

minetest.register_craft({
	output = "farming:straw 3",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", "farming:wheat", "farming:wheat"}
	}
})

minetest.register_craft({
	output = "farming:wheat 3",
	recipe = {{"farming:straw"}}
})

-- check and register stairs
if minetest.global_exists("stairs") then

	if stairs.mod and stairs.mod == "redo" then

		stairs.register_all("straw", "farming:straw",
			{snappy = 3, flammable = 4},
			{"farming_straw.png"},
			"Straw",
			farming.sounds.node_sound_leaves_defaults())
	else

		stairs.register_stair_and_slab("straw", "farming:straw",
			{snappy = 3, flammable = 4},
			{"farming_straw.png"},
			"Straw Stair",
			"Straw Slab",
			farming.sounds.node_sound_leaves_defaults())
	end
end

-- flour
minetest.register_craftitem("farming:flour", {
	description = S("Flour"),
	inventory_image = "farming_flour.png",
	groups = {food_flour = 1, flammable = 1}
})

minetest.register_craft({
	output = "farming:flour",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"},
		{"farming:wheat", a.mortar_pestle, ""}
	},
	replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}}
})

-- bread
minetest.register_craftitem("farming:bread", {
	description = S("Bread"),
	inventory_image = "farming_bread.png",
	on_use = minetest.item_eat(5),
	groups = {food_bread = 1, flammable = 2}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:bread",
	recipe = "farming:flour"
})

-- wheat definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_wheat_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 3,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	waving = 1,
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 4, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = farming.sounds.node_sound_leaves_defaults(),
	_heat_min = 40, _heat_max = 70, _hum_min = 30, _hum_max = 75,
}

-- stage 1
minetest.register_node("farming:wheat_1", table.copy(def))

-- stage 2
def.tiles = {"farming_wheat_2.png"}
minetest.register_node("farming:wheat_2", table.copy(def))

-- stage 3
def.tiles = {"farming_wheat_3.png"}
minetest.register_node("farming:wheat_3", table.copy(def))

-- stage 4
def.tiles = {"farming_wheat_4.png"}
minetest.register_node("farming:wheat_4", table.copy(def))

-- stage 5
def.tiles = {"farming_wheat_5.png"}
def.drop = {
	items = {
		{items = {"farming:wheat"}, rarity = 2},
		{items = {"farming:seed_wheat"}, rarity = 2}
	}
}
minetest.register_node("farming:wheat_5", table.copy(def))

-- stage 6
def.tiles = {"farming_wheat_6.png"}
def.drop = {
	items = {
		{items = {"farming:wheat"}, rarity = 2},
		{items = {"farming:seed_wheat"}, rarity = 1}
	}
}
minetest.register_node("farming:wheat_6", table.copy(def))

-- stage 7
def.tiles = {"farming_wheat_7.png"}
def.drop = {
	items = {
		{items = {"farming:wheat"}, rarity = 1},
		{items = {"farming:wheat"}, rarity = 3},
		{items = {"farming:seed_wheat"}, rarity = 1},
		{items = {"farming:seed_wheat"}, rarity = 3}
	}
}
minetest.register_node("farming:wheat_7", table.copy(def))

-- stage 8 (final)
def.tiles = {"farming_wheat_8.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"farming:wheat"}, rarity = 1},
		{items = {"farming:wheat"}, rarity = 3},
		{items = {"farming:seed_wheat"}, rarity = 1},
		{items = {"farming:seed_wheat"}, rarity = 3}
	}
}
minetest.register_node("farming:wheat_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:wheat"] = {
	crop = "farming:wheat",
	seed = "farming:seed_wheat",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 8
}

-- fuels
minetest.register_craft({
	type = "fuel",
	recipe = "farming:straw",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:wheat",
	burntime = 1
})

-- mapgen
minetest.register_on_mods_loaded(function()
	-- temperate, moderate moisture (heat 40-70, hum 30-75)
	local place_on, biomes, seen = {}, {}, {}
	for bname, bdef in pairs(minetest.registered_biomes) do
		if not bname:find('_under') then
			local h = bdef.heat_point or -1
			local w = bdef.humidity_point or -1
			if h >= 40 and h <= 70 and w >= 30 and w <= 75 then
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
				scale = 0.001,
				spread = {x = 100, y = 100, z = 100},
				seed = 711,
				octaves = 3,
				persist = 0.6
			},
			y_min = 3,
			y_max = 50,
			decoration = "farming:wheat_8"
		})
	end
end)
