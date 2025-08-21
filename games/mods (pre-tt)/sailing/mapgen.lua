
minetest.register_decoration({
  deco_type = "schematic",
  place_on = "default:dirt_with_grass",
  sidelen = 5,
  fill_ratio = 0.01,
  schematic = palm_tree_schematic,
  rotation = 'random',
	biomes = {"islands", "islands_hot", "naturalbiomes:palmbeach"},
  flags = {place_center_z = true, place_center_x = true},
})

minetest.register_decoration({
  deco_type = "simple",
  place_on = "default:dirt_with_grass",
  sidelen = 5,
  fill_ratio = 0.01,
	biomes = {"islands", "islands_hot", "naturalbiomes:palmbeach"},
  decoration = "sailing:kukui_bush_full",
  flags = {place_center_z = true, place_center_x = true},
})
