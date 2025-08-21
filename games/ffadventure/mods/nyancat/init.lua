
local node_sound
if minetest.global_exists("default") then
	node_sound = default.node_sound_defaults()
elseif minetest.global_exists("sounds") then
	node_sound = sounds.node()
end

minetest.register_node("nyancat:nyancat", {
	description = "Nyan Cat",
	tiles = {"nyancat_side.png", "nyancat_side.png", "nyancat_side.png",
		"nyancat_side.png", "nyancat_back.png", "nyancat_front.png"},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = node_sound,
})

minetest.register_node("nyancat:nyancat_rainbow", {
	description = "Nyan Cat Rainbow",
	tiles = {
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png"
	},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = node_sound,
})


minetest.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat_rainbow",
	burntime = 1,
})

