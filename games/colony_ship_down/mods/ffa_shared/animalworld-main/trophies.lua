local S = minetest.get_translator("animalworld")

 -- Anteater

minetest.register_craftitem("animalworld:anteatercorpse", {
	description = S("Anteater Corpse"),
	inventory_image = "animalworld_anteatercorpse.png",
})

 -- Crocodile


minetest.register_node("animalworld:crocodiletrophy", {
    description = S"Crocodile Trophy",
    visual_scale = 1.0,
    mesh = "Crocodiletrophy.b3d",
    tiles = {"texturecrocodiletrophy.png"},
    inventory_image = "acrocodiletrophy.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.35, -0.3, -0.6, 0.35, 0.3, 0.5},
            --[[{-0.35, -0.3, -0.6, 0.35, 0.3, 0.5},
            {-0.35, -0.3, -0.6, 0.35, 0.3, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.35, -0.3, -0.6, 0.35, 0.3, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:crocodiletrophy",
	burntime = 2,
})


minetest.register_craft({
	output = "animalworld:crocodiletrophy",
	type = "shapeless",
	recipe = 
		{"nssm:crocodile_skin", "default:axe_stone", "group:wood"}

	
})

minetest.register_node("animalworld:crocodileskin", {
    description = S"Crocodile Skin",
    visual_scale = 1.0,
    mesh = "Reptileskin.b3d",
    tiles = {"texturecrocodileskin.png"},
    inventory_image = "acrocodileskin.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-1, -0.5, -1.2, 1, -0.5, 1.2},
            --[[{-1, -0.5, -1.2, 1, -0.5, 1.2},
            {-1, -0.5, -1.2, 1, -0.5, 1.2}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1, -0.5, -1.2, 1, -0.5, 1.2}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	output = "animalworld:crocodileskinhanging",
	type = "shapeless",
	recipe = 
		{"animalworld:crocodileskin"}

	
})

minetest.register_craft({
	output = "animalworld:crocodileskin",
	type = "shapeless",
	recipe = 
		{"nssm:crocodile_skin", "nssm:crocodile_tail"}

	
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:crocodileskin",
	burntime = 2,
})

minetest.register_node("animalworld:crocodileskinhanging", {
    description = S"Crocodile Skin hanging",
    visual_scale = 1.0,
    mesh = "Reptileskinhanging.b3d",
    tiles = {"texturecrocodileskin.png"},
    inventory_image = "acrocodileskin.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5},
            --[[{-0.8, -0.9, 0.4, 0.8, 0.8, 0.5},
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:crocodileskinhanging",
	burntime = 2,
})


 -- elephant

minetest.register_node("animalworld:elephanttrophy", {
    description = S"Elephant Trophy",
    visual_scale = 1.0,
    mesh = "Elephanttrophy.b3d",
    tiles = {"textureelephanttrophy.png"},
    inventory_image = "aelephanttrophy.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.5, -1.6, 0.8, 0.9, 0.5},
            --[[{-0.8, -0.5, -1.6, 0.8, 0.9, 0.5},
            {-0.8, -0.5, -1.6, 0.8, 0.9, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.5, -1.6, 0.8, 0.9, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:elephantrophy",
	burntime = 2,
})

minetest.register_craftitem("animalworld:elephantcorpse", {
	description = S("Elephant Corpse"),
	inventory_image = "animalworld_elephantcorpse.png",
})

minetest.register_craft({
	output = "animalworld:elephanttrophy",
	type = "shapeless",
	recipe = 
		{"animalworld:elephantcorpse", "default:axe_stone", "group:wood"}

	
})

minetest.register_node("animalworld:ivorytable", {
    description = S"Ivory Table",
    visual_scale = 1,
    mesh = "Ivorytable.b3d",
    tiles = {"textureivorytable.png"},
    inventory_image = "aivorytable.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
		collisionbox = {-0.4, -0.01, -0.4, 0.4, 0.4, 0.4},
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:ivorytable",
	burntime = 3

})

minetest.register_node("animalworld:ivorychair", {
    description = S"Ivory Chair",
    visual_scale = 1,
    mesh = "Ivorychair.b3d",
    tiles = {"textureivorychair.png"},
    inventory_image = "aivorychair.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.35, 0.5},
            --[[{-0.5, -0.5, -0.5, 0.5, 0.35, 0.5},
            {-0.5, -0.5, -0.5, 0.5, 0.35, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.35, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:ivorychair",
	burntime = 3

})


minetest.register_node("animalworld:ivoryvase", {
    description = S"Ivory Vase",
    visual_scale = 1,
    mesh = "Ivoryvase.b3d",
    tiles = {"textureivoryvase.png"},
    inventory_image = "aivoryvase.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1},
            --[[{-0.1, -0.5, -0.1, 0.1, 0.1, 0.1},
            {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:ivoryvase",
	burntime = 1

})

minetest.register_craft({
	output = "animalworld:ivorytable",
	type = "shapeless",
	recipe = 
		{"animalworld:elephantcorpse", "default:axe_stone"}

	
})

minetest.register_craft({
	output = "animalworld:ivorychair",
	type = "shapeless",
	recipe = 
		{"animalworld:elephantcorpse", "default:sword_stone"}

	
})

minetest.register_craft({
	output = "animalworld:ivoryvase",
	type = "shapeless",
	recipe = 
		{"animalworld:elephantcorpse", "default:shovel_stone"}

	
})



 -- Hippo


minetest.register_craftitem("animalworld:hippocorpse", {
	description = S("Hippo Corpse"),
	inventory_image = "animalworld_hippocorpse.png",
})


 -- Shark

minetest.register_node("animalworld:sharktrophy", {
    description = S"Shark Trophy",
    visual_scale = 1.0,
    mesh = "Sharktrophy.b3d",
    tiles = {"texturesharktrophy.png"},
    inventory_image = "asharktrophy.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:sharktrophy",
	burntime = 2,
})

minetest.register_craftitem("animalworld:sharkcorpse", {
	description = S("Shark Corpse"),
	inventory_image = "animalworld_sharkcorpse.png",
})

minetest.register_craft({
	output = "animalworld:sharktrophy",
	type = "shapeless",
	recipe = 
		{"animalworld:sharkcorpse", "default:axe_stone", "group:wood"}

	
})

 -- Vulture

minetest.register_craftitem("animalworld:vulturecorpse", {
	description = S("Vulture Corpse"),
	inventory_image = "animalworld_vulturecorpse.png",
})






 -- Muskox

minetest.register_node("animalworld:muskoxtrophy", {
    description = S"Muskox Trophy",
    visual_scale = 1.0,
    mesh = "Muskoxtrophy.b3d",
    tiles = {"texturemuskoxtrophy.png"},
    inventory_image = "amuskoxtrophy.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.7, 0.5, 0.8, 0.5},
            --[[{-0.5, -0.5, -0.7, 0.5, 0.8, 0.5},
            {-0.5, -0.5, -0.7, 0.5, 0.8, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.7, 0.5, 0.8, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:muskoxtrophy",
	burntime = 2,
})

minetest.register_node("animalworld:muskoxpelt", {
    description = S"Muskox Pelt",
    visual_scale = 1.0,
    mesh = "Bearpelt.b3d",
    tiles = {"texturemuskoxpelt.png"},
    inventory_image = "amuskoxpelt.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-1, -0.5, -1.2, 1, -0.5, 1.2},
            --[[{-1, -0.5, -1.2, 1, -0.5, 1.2},
            {-1, -0.5, -1.2, 1, -0.5, 1.2}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1, -0.5, -1.2, 1, -0.5, 1.2}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:muskoxpelt",
	burntime = 2,
})

minetest.register_node("animalworld:muskoxpelthanging", {
    description = S"Muskox Pelt hanging",
    visual_scale = 1.0,
    mesh = "Bearpelthanging.b3d",
    tiles = {"texturemuskoxpelt.png"},
    inventory_image = "amuskoxpelt.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5},
            --[[{-0.8, -0.9, 0.4, 0.8, 0.8, 0.5},
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.8, -0.9, 0.4, 0.8, 0.8, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "fuel",
	recipe = "animalworld:muskoxpelthanging",
	burntime = 2,
})

minetest.register_craftitem("animalworld:muskoxcorpse", {
	description = S("Muskox Corpse"),
	inventory_image = "animalworld_muskoxcorpse.png",
})

minetest.register_craft({
	output = "animalworld:muskoxtrophy",
	type = "shapeless",
	recipe = 
		{"animalworld:muskoxcorpse", "default:axe_stone", "group:wood"}

	
})

minetest.register_craft({
	output = "animalworld:muskoxpelt",
	type = "shapeless",
	recipe = 
		{"animalworld:muskoxcorpse", "default:sword_stone"}

	
})

minetest.register_craft({
	output = "animalworld:muskoxpelthanging",
	type = "shapeless",
	recipe = 
		{"animalworld:muskoxcorpse", "default:sword_stone", "default:sign_wall_wood"}

	
})
