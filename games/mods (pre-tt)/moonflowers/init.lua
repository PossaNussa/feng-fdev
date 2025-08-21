-- moonflowers

-- Load support for MT game translation.
local S = minetest.get_translator(minetest.get_current_modname())

-- Map Generation
dofile(minetest.get_modpath("moonflowers") .. "/mapgen.lua")

minetest.register_node("moonflowers:moonflower", {
	description= S("Moonflower"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"moonflower_v1.png"},
	inventory_image = "moonflower_v1.png",
	wield_image = "moonflower_v1.png",
	sunlight_propagates = true,
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	groups = {snappy = 3, flower = 1, flora = 1, attached_node = 1, flammable = 1, color_cyan = 1},
	sounds = default.node_sound_leaves_defaults(),
	light_source = 3,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, -0.5+0.7, 0.3},
	},
})

-- Add support for the flowerpot mod
if minetest.get_modpath("flowerpot") then
	flowerpot.register_node("moonflowers:moonflower")
end
