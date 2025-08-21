local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_craftitem("simplecoins:coins", {
	description = ("Coins"),
	inventory_image = "coin.png",
	stack_max = 9999,
	groups = { coinvalue=1 },
})

minetest.register_craft({
    output = "simplecoins:coins 9",
    type = "shapeless",
    recipe = {"default:gold_ingot"}
})