minetest.register_craftitem("golden_bread:golden_bread", {
        description = "golden bread",
        inventory_image = "golden_bread_golden_bread.png",
        on_use = minetest.item_eat(10),
})
minetest.register_craft({
        output = "golden_bread:golden_bread",
		 recipe = {
        { "default:gold_ingot", "farming:bread"},
    },
    })