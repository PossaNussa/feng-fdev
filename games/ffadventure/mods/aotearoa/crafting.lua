---------------------------------------------------------
-- Crafts

local default_loaded = minetest.get_modpath("default")
local zero_loaded = minetest.get_modpath("zr_wood")

------------------
-- Substitutes
-- Replacements for default/zero veg that didn't make it here.

-- Paper
if default_loaded then
	minetest.register_craft({
		output = "default:paper",
		recipe = {
			{"aotearoa:kauri_grass", "aotearoa:kauri_grass", "aotearoa:kauri_grass"},
		}
	})

	minetest.register_craft({
		output = "default:paper",
		recipe = {
			{"aotearoa:flax", "aotearoa:flax", "aotearoa:flax"},
		}
	})

	minetest.register_craft({
		output = "default:paper",
		recipe = {
			{"aotearoa:raupo", "aotearoa:raupo", "aotearoa:raupo"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_paper:paper",
		recipe = {
			{"aotearoa:kauri_grass", "aotearoa:kauri_grass", "aotearoa:kauri_grass"},
		}
	})

	minetest.register_craft({
		output = "zr_paper:paper",
		recipe = {
			{"aotearoa:flax", "aotearoa:flax", "aotearoa:flax"},
		}
	})

	minetest.register_craft({
		output = "zr_paper:paper",
		recipe = {
			{"aotearoa:raupo", "aotearoa:raupo", "aotearoa:raupo"},
		}
	})
end


---------------------------------------------------------
-- Furnace from soft sedimentary rocks
if default_loaded then
	minetest.register_craft({
		output = "default:furnace",
		recipe = {
			{"group:soft_stone", "group:soft_stone", "group:soft_stone"},
			{"group:soft_stone", "", "group:soft_stone"},
			{"group:soft_stone", "group:soft_stone", "group:soft_stone"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_furnace:furnace",
		recipe = {
			{"group:soft_stone", "group:soft_stone", "group:soft_stone"},
			{"group:soft_stone", "", "group:soft_stone"},
			{"group:soft_stone", "group:soft_stone", "group:soft_stone"},
		}
	})
end

-----------------------------------------
-- Stone axe recipe from gravel, to make up for unbreakable trees.
if default_loaded then
	minetest.register_craft({
		output = "default:axe_stone",
		recipe = {
			{"default:gravel", "default:gravel"},
			{"default:gravel", "group:stick"},
			{"", "group:stick"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_stone:axe",
		recipe = {
			{"zr_gravel:gravel", "zr_gravel:gravel"},
			{"zr_gravel:gravel", "group:stick"},
			{"", "group:stick"},
		}
	})
end

-------------------------
-- Kauri Gum
minetest.register_craftitem("aotearoa:kauri_gum", {
	description = "Kauri Gum",
	inventory_image = "aotearoa_kauri_gum.png",
})

minetest.register_craft({
	type = "fuel",
	recipe = "aotearoa:kauri_gum",
	burntime = 3,
})

------------
-- Kauri gum torch
if default_loaded then
	minetest.register_craft({
		output = "default:torch 4",
		recipe = {
			{"aotearoa:kauri_gum"},
			{"group:stick"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_torch:torch 4",
		recipe = {
			{"aotearoa:kauri_gum"},
			{"group:stick"},
		}
	})
end


------------------------------
--[[
Dyes

TODO
- Orange dye, green dye, purple dye

- Tanekaha for tan?

- Red ochre, drop from clay. Cook togive red dye?

----------------
White Dye
--]]
-- Taioma. White, from burnt clay with shark oil.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "bakedclay:natural",
		recipe = "default:clay",
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_dye:white 4",
		recipe = "zr_clay:clay",
	})
end

-------------
--[[
Red Dye

Kauri grass (technically the berries)
--]]
if default_loaded then
	minetest.register_craft({
		type = "shapeless",
		output = "dye:red 4",
		recipe = {"aotearoa:kauri_grass"},
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "shapeless",
		output = "zr_dye:red 4",
		recipe = {"aotearoa:kauri_grass"},
	})
end

---------------------------
--[[
Dyes from tree soot, etc.
Traditionally used for tattoos.
Blues, browns, blacks... multiple colors for same species.

------------
Blue Dye

--------------
From tree soot
--]]
-- From Kauri soot
if default_loaded then
	minetest.register_craft({
		output = "dye:blue 4",
		recipe = {
			{"aotearoa:kauri_tree"},
			{"default:torch"},
		},
		replacements = {{"default:torch", "default:torch"}}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:blue 4",
		recipe = {
			{"aotearoa:kauri_tree"},
			{"zr_torch:torch"},
		},
		replacements = {{"zr_torch:torch", "zr_torch:torch"}}
	})
end

-- From Rimu soot
if default_loaded then
	minetest.register_craft({
		output = "dye:blue 4",
		recipe = {
			{"aotearoa:rimu_tree"},
			{"default:torch"},
		},
		replacements = {{"default:torch", "default:torch"}}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:blue 4",
		recipe = {
			{"aotearoa:rimu_tree"},
			{"zr_torch:torch"},
		},
		replacements = {{"zr_torch:torch", "zr_torch:torch"}}
	})
end

--------------
--[[
Black Dye

TODO
- Karo, but don't know how it is made.

------------------
From tree soot
--]]
-- From kauri gum soot
if default_loaded then
	minetest.register_craft({
		output = "dye:black 4",
		recipe = {
			{"aotearoa:kauri_gum"},
			{"default:torch"},
		},
		replacements = {{"default:torch", "default:torch"}}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:black 4",
		recipe = {
			{"aotearoa:kauri_gum"},
			{"zr_torch:torch"},
		},
		replacements = {{"zr_torch:torch", "zr_torch:torch"}}
	})
end

-- From Kahikatea soot
if default_loaded then
	minetest.register_craft({
		output = "dye:black 4",
		recipe = {
			{"aotearoa:kahikatea_tree"},
			{"default:torch"},
		},
		replacements = {{"default:torch", "default:torch"}}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:black 4",
		recipe = {
			{"aotearoa:kahikatea_tree"},
			{"zr_torch:torch"},
		},
		replacements = {{"zr_torch:torch", "zr_torch:torch"}}
	})
end

----------
--[[
Disabled because makes it too easy.
From mahoe (technically the berries)

minetest.register_craft({
	output = "dye:black 4",
	recipe = {
		{"aotearoa:mahoe_leaves"},
	},
})
--]]

-- From hinau bark. Not sure how done. Possibly boiled.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "dye:black 4",
		recipe = "aotearoa:hinau_tree",
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_dye:black 4",
		recipe = "aotearoa:hinau_tree",
	})
end

------------
--[[
Brown Dye

---------------
From tree soot
--]]
-- From Kahikatea soot
if default_loaded then
	minetest.register_craft({
		output = "dye:brown 4",
		recipe = {
			{"aotearoa:miro_tree"},
			{"default:torch"},
		},
		replacements = {{"default:torch", "default:torch"}}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:brown 4",
		recipe = {
			{"aotearoa:miro_tree"},
			{"zr_torch:torch"},
		},
		replacements = {{"zr_torch:torch", "zr_torch:torch"}}
	})
end

----------------
-- Red Dye

-- By boiling kamahi.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "dye:red 4",
		recipe = "aotearoa:kamahi_tree",
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_dye:red 4",
		recipe = "aotearoa:kamahi_tree",
	})
end

----------------
-- Yellow Dye

-- By boiling rangiora bark.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "dye:yellow 4",
		recipe = "aotearoa:rangiora_tree",
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_dye:yellow 4",
		recipe = "aotearoa:rangiora_tree",
	})
end

-- From kowhai flowers
if default_loaded then
	minetest.register_craft({
		output = "dye:yellow 4",
		recipe = {{"aotearoa:kowhai_leaves"}},
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dye:yellow 4",
		recipe = {{"aotearoa:kowhai_leaves"}},
	})
end


--------------------------------------------
-- Wooden Fences
for i in ipairs(aotearoa.treelist) do
	local treename = aotearoa.treelist[i][1]
	minetest.register_craft({
		output = "aotearoa:fence_"..treename.."_wood 4",
		recipe = {
			{
				"aotearoa:"..treename.."_wood",
				"group:stick",
				"aotearoa:"..treename.."_wood",
			},
			{
				"aotearoa:"..treename.."_wood",
				"group:stick",
				"aotearoa:"..treename.."_wood",
			},
		}
	})
end

-------------------------------
-- Ponga fence from tree ferns
minetest.register_craft({
	output = "aotearoa:ponga_fence",
	recipe = {
		{"", "", ""},
		{"", "", ""},
		{"aotearoa:wheki_tree", "aotearoa:wheki_tree", "aotearoa:wheki_tree"},
	}
})

minetest.register_craft({
	output = "aotearoa:ponga_fence",
	recipe = {
		{"", "", ""},
		{"", "", ""},
		{"aotearoa:silver_fern_tree", "aotearoa:silver_fern_tree", "aotearoa:silver_fern_tree"},
	}
})

minetest.register_craft({
	output = "aotearoa:ponga_fence",
	recipe = {
		{"", "", ""},
		{"", "", ""},
		{"aotearoa:mamaku_tree", "aotearoa:mamaku_tree", "aotearoa:mamaku_tree"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "aotearoa:ponga_fence",
	burntime = 3,
})


------------------------------------------------
-- Food

-------------
-- Bracken root
minetest.register_craftitem("aotearoa:cooked_bracken_root", {
	description = "Cooked Bracken Root",
	inventory_image = "aotearoa_cooked_bracken_root.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_bracken_root",
	recipe = "aotearoa:bracken",
})

---------
-- Raupo root
minetest.register_craftitem("aotearoa:cooked_raupo_root", {
	description = "Cooked Raupo Root",
	inventory_image = "aotearoa_cooked_bracken_root.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_raupo_root",
	recipe = "aotearoa:raupo",
})

-------------
-- Raupo pollen cake
minetest.register_craftitem("aotearoa:pungapunga", {
	description = "Pungapunga Pollen Cake",
	inventory_image = "aotearoa_pungapunga.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:pungapunga",
	recipe = "aotearoa:raupo_flower",
})

--------
--[[
Tree seeds

Slight simplification... but...
->berry (some edible) ->seed meal (useless) ->seed cake
raw fruit = 1. Cooking releases a little value. 4 go into a cake.
cake = 1.25 * 4 = 5 (same as default bread).
--]]
minetest.register_craftitem("aotearoa:seed_meal", {
	description = "Seed Meal",
	inventory_image = "aotearoa_cooked_karaka_kernels.png",
	--on_use = minetest.item_eat(2),
})

minetest.register_craftitem("aotearoa:seed_cake", {
	description = "Seed Cake",
	inventory_image = "aotearoa_pungapunga.png",
	on_use = minetest.item_eat(5),
})

-- Craft seed meal.

-- Karaka
minetest.register_craft({
	type = "shapeless",
	output = "aotearoa:seed_meal",
	recipe = {
		"aotearoa:karaka_fruit",
		"aotearoa:karaka_fruit",
		"aotearoa:karaka_fruit",
		"aotearoa:karaka_fruit",
	}
})

-- Tawa
minetest.register_craft({
	type = "shapeless",
	output = "aotearoa:seed_meal",
	recipe = {
		"aotearoa:tawa_fruit",
		"aotearoa:tawa_fruit",
		"aotearoa:tawa_fruit",
		"aotearoa:tawa_fruit",
	}
})

-- Hinau
minetest.register_craft({
	type = "shapeless",
	output = "aotearoa:seed_meal",
	recipe = {
		"aotearoa:hinau_fruit",
		"aotearoa:hinau_fruit",
		"aotearoa:hinau_fruit",
		"aotearoa:hinau_fruit",
	}
})

-- Cook seed meal to seed cake.
minetest.register_craft({
	type = "cooking",
	output = "aotearoa:seed_cake",
	recipe = "aotearoa:seed_meal",
})

--[[
Redundant 0.1 code and items...
-- Cook karaka.
minetest.register_craftitem("aotearoa:cooked_karaka_kernels", {
	description = "Cooked Karaka Kernels",
	inventory_image = "aotearoa_cooked_karaka_kernels.png",
  on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_karaka_kernels",
	recipe = "aotearoa:karaka_fruit",
})

----------
-- Cook Tawa.
minetest.register_craftitem("aotearoa:cooked_tawa_kernels", {
	description = "Cooked Tawa Kernels",
	inventory_image = "aotearoa_cooked_karaka_kernels.png",
  on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_tawa_kernels",
	recipe = "aotearoa:tawa_fruit",
})
--]]

---------------
-- Fern fiddleheads
minetest.register_craftitem("aotearoa:cooked_fiddlehead", {
	description = "Cooked fiddlehead",
	inventory_image = "aotearoa_cooked_fiddlehead.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_fiddlehead",
	recipe = "aotearoa:mamaku_crown",
})

------------
-- Mamaku pith
minetest.register_craftitem("aotearoa:cooked_mamaku_pith", {
	description = "Cooked Mamaku Pith",
	inventory_image = "aotearoa_cooked_mamaku_pith.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_mamaku_pith",
	recipe = "aotearoa:mamaku_tree",
})

------------
-- Cabbage tree root
minetest.register_craftitem("aotearoa:cooked_cabbage_tree_root", {
	description = "Cooked Cabbage Tree Root",
	inventory_image = "aotearoa_cooked_cabbage_tree_root.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_cabbage_tree_root",
	recipe = "aotearoa:cabbage_tree_tree",
})

--------------
-- Cabbage tree shoots
minetest.register_craftitem("aotearoa:cooked_cabbage_tree_shoots", {
	description = "Cooked Cabbage Tree Shoots",
	inventory_image = "aotearoa_cooked_cabbage_tree_shoots.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_cabbage_tree_shoots",
	recipe = "aotearoa:cabbage_tree_crown",
})

------------
-- Nikau shoots
minetest.register_craftitem("aotearoa:cooked_nikau_shoots", {
	description = "Cooked Nikau Shoots",
	inventory_image = "aotearoa_cooked_cabbage_tree_shoots.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:cooked_nikau_shoots",
	recipe = "aotearoa:nikau_palm_skirt",
})


--------------------------------------------------
--[[
Some traditional uses

TODO
- Woven bags/mats from pingao, flax, kauri grass, cabbage tree, nikau?
--]]
---------------------------------
-- Flax rope
minetest.register_craft({
	output = "aotearoa:flax_rope 3",
	recipe = {
		{"aotearoa:flax"},
		{"aotearoa:flax"},
		{"aotearoa:flax"},
	},
})


-------------------------------------------
-- Soils

-- Peat as a fuel source
minetest.register_craft({
	type = "fuel",
	recipe = "aotearoa:peat",
	burntime = 30,
})

-- Make dirt.
if default_loaded then
	minetest.register_craft({
		output = "default:dirt 4",
		recipe = {
			{"group:sand", "default:clay"},
			{"aotearoa:silt", "aotearoa:peat"},
		}
	})

	minetest.register_craft({
		output = "default:dirt 4",
		recipe = {
			{"group:sand", "default:clay"},
			{"aotearoa:silt", "aotearoa:rotten_wood"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_dirt:dirt 4",
		recipe = {
			{"group:sand", "zr_clay:clay"},
			{"aotearoa:silt", "aotearoa:peat"},
		}
	})

	minetest.register_craft({
		output = "zr_dirt:dirt 4",
		recipe = {
			{"group:sand", "zr_clay:clay"},
			{"aotearoa:silt", "aotearoa:rotten_wood"},
		}
	})
end

----------------------------------------
-- Iron sand
-- Iron sand is famously difficult to smelt.
if default_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "default:iron_lump",
		recipe = "aotearoa:iron_sand",
		cooktime = 30,
	})
elseif zero_loaded then
	minetest.register_craft({
		type = "cooking",
		output = "zr_iron:lump",
		recipe = "aotearoa:iron_sand",
		cooktime = 30,
	})
end

----------
--[[
Roman style concrete
Because we have the materials...

lime source -> crushed lime -> cook -> quicklime (-> hydrated lime) ->
+ volcanic sand + gravel -> concrete
Need crushing stage to avoid conflicts with other crafts.
Could drop slaking stage as makes it too complicted.
Needs some benefit to justify such a complicated process.
Its actual benefit cant be captured (e.g flexibility of form).
So... double number of nodes you get.
3 starting nodes: lime source + vol. sand + gravel. = 6 concrete.
--]]
--Lime sources to crushed lime
--Needs a little odd recipe to avoid recipe conflicts... two steel crushers.
minetest.register_craftitem("aotearoa:crushed_lime", {
	description = "Crushed Lime",
	inventory_image = "aotearoa_crushed_lime.png",
})

--[[
4 shells = 1 limestone... doesn't fit the pattern...
Just force them to make coquina.
--]]
-- From coquina
if default_loaded then
	minetest.register_craft({
		output = "aotearoa:crushed_lime",
		recipe = {
			{"default:steel_ingot",},
			{"aotearoa:coquina_limestone",},
			{"default:steel_ingot",},
		},
		replacements = {
			{"default:steel_ingot", "default:steel_ingot",},
			{"default:steel_ingot", "default:steel_ingot",}
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "aotearoa:crushed_lime",
		recipe = {
			{"zr_iron:ingot",},
			{"aotearoa:coquina_limestone",},
			{"zr_iron:ingot",},
		},
		replacements = {
			{"zr_iron:ingot", "zr_iron:ingot",},
			{"zr_iron:ingot", "zr_iron:ingot",}
		}
	})
end

-- From limestone
if default_loaded then
	minetest.register_craft({
		output = "aotearoa:crushed_lime",
		recipe = {
			{"default:steel_ingot",},
			{"aotearoa:limestone",},
			{"default:steel_ingot",},
		},
		replacements = {
			{"default:steel_ingot", "default:steel_ingot",},
			{"default:steel_ingot", "default:steel_ingot",}
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "aotearoa:crushed_lime",
		recipe = {
			{"zr_iron:ingot",},
			{"aotearoa:limestone",},
			{"zr_iron:ingot",},
		},
		replacements = {
			{"zr_iron:ingot", "zr_iron:ingot",},
			{"zr_iron:ingot", "zr_iron:ingot",}
		}
	})
end

-- Cook to quicklime.
minetest.register_craftitem("aotearoa:quicklime", {
	description = "Quicklime",
	inventory_image = "aotearoa_quicklime.png",
})

minetest.register_craft({
	type = "cooking",
	output = "aotearoa:quicklime",
	recipe = "aotearoa:crushed_lime",
})

-- Make concrete.
if default_loaded then
	minetest.register_craft({
		output = "aotearoa:concrete 6",
		recipe = {
			{"aotearoa:quicklime", "group:sand", "default:gravel",},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "aotearoa:concrete 6",
		recipe = {
			{"aotearoa:quicklime", "group:sand", "zr_gravel:gravel",},
		}
	})
end


----------------------------------------------
--[[
Artificial diamonds...
Because NZ has no diamonds.
It is slow.

minetest.register_craft({
	type = "cooking",
	output = "default:diamond",
	recipe = "default:coalblock",
	cooktime = 360,
})

----------------------------------------------
Artificial mese...
Because... it's... mese.
Something hocus pocus!?
Pounamu is the most mystical rock... so it can be transformed.
--]]
if default_loaded then
	minetest.register_craft({
		output = "default:mese",
		recipe = {
			{"aotearoa:granite", "default:gold_ingot", "aotearoa:gneiss"},
			{"default:copper_ingot", "aotearoa:pounamu", "default:steel_ingot"},
			{"aotearoa:andesite", "default:tin_ingot", "aotearoa:limestone"},
		}
	})
elseif zero_loaded then
	minetest.register_craft({
		output = "zr_mese:block",
		recipe = {
			{"aotearoa:granite", "zr_gold:ingot", "aotearoa:gneiss"},
			{"zr_copper:ingot", "aotearoa:pounamu", "zr_iron:ingot"},
			{"aotearoa:andesite", "zr_tin:ingot", "aotearoa:limestone"},
		}
	})
end
