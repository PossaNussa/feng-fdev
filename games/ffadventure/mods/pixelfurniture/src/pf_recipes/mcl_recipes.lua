--- BASIC :
core.register_craft({
    type = "shaped",
    output = "pixelfurniture:crate",
    recipe = {
        {"group:wood", "group:wood","group:wood"},
        {"group:wood", "group:stick","group:wood"},
        {"group:wood", "group:wood","group:wood"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:wooden_chair",
    recipe = {
        {"", "","group:stick"},
        {"group:stick", "group:wood","group:stick"},
        {"group:stick","","group:stick"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:stool",
    recipe = {
        {"", "",""},
        {"group:stick", "group:wood","group:stick"},
        {"group:stick","","group:stick"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:wooden_table",
    recipe = {
        {"group:wood","group:wood","group:wood"},
        {"group:stick", "","group:stick"},
        {"group:stick","","group:stick"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:wooden_closet",
    recipe = {
        {"group:wood","group:stick","group:wood"},
        {"group:wood","pixelfurniture:crate","group:wood"},
        {"group:wood","group:stick","group:wood"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:wooden_counter",
    recipe = {
        {"group:wood","group:wood","group:wood"},
        {"group:stick","pixelfurniture:crate","group:stick"},
        {"group:wood","group:wood","group:wood"}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:wooden_cabinet 2",
    recipe = {
        {"pixelfurniture:wooden_closet","pixelfurniture:wooden_closet",""},
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:curtain 2",
    recipe = {
        {"group:stick","group:stick","group:stick"},
        {"group:wool","","group:wool"},
        {"group:wool","","group:wool"}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:hanging_pot",
    recipe = {
        {"","group:flower",""},
        {"mcl_core:brick","group:soil","mcl_core:brick"},
        {"","mcl_core:brick",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:small_vase",
    recipe = {
        {"","group:flower",""},
        {"","group:soil",""},
        {"","mcl_core:brick",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:item_shelf",
    recipe = {
        {"","",""},
        {"group:wood","group:stick","group:wood"},
        {"","",""}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:doormat 2",
    recipe = {
        {"","",""},
        {"group:wool","group:wool",""},
        {"","",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:lantern",
    recipe = {
        {"","mcl_core:glass",""},
        {"","mcl_torches:torch",""},
        {"","mcl_core:glass",""}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:wooden_bench",
    recipe = {
        {"","",""},
        {"pixelfurniture:wooden_chair","pixelfurniture:wooden_chair",""},
        {"","",""}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:doormat 2",
    recipe = {
        {"","",""},
        {"group:wool","group:wool",""},
        {"","",""}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:upholstered_chair_red",
    recipe = {
        {"","",""},
        {"pixelfurniture:wooden_chair","group:wool",""},
        {"","",""}
    }
})
-- 0.3
core.register_craft({
    type = "shaped",
    output = "pixelfurniture:globe",
    recipe = {
        {"","mcl_core:dirt",""},
        {"","mcl_copper:copper_ingot",""},
        {"","mcl_copper:copper_ingot",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:sign_arrow",
    recipe = {
        {"","group:wood","group:stick"},
        {"","group:stick",""},
        {"","group:stick",""}
    }
})

core.register_craft({
    --type = "shaped",
    output = "pixelfurniture:stacked_books",
    recipe = {
        {"","",""},
        {"mcl_books:book","mcl_books:book","mcl_books:book"},
        {"","",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:wooden_window",
    recipe = {
        {"group:stick","group:stick","group:stick"},
        {"group:stick","mcl_core:glass","group:stick"},
        {"group:stick","group:stick","group:stick"}
    }
})
-- 0.4
core.register_craft({
    type = "shaped",
    output = "pixelfurniture:cookie_jar",
    recipe = {
        {"mcl_core:glass","group:wood","mcl_core:glass"},
        {"mcl_core:glass","","mcl_core:glass"},
        {"","mcl_core:glass",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:broom",
    recipe = {
        {"","group:stick",""},
        {"","group:stick",""},
        {"","mcl_farming:wheat_item",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:statue",
    recipe = {
        {"","mcl_core:stone",""},
        {"group:stick","mcl_core:stone","group:stick"},
        {"","mcl_core:stone",""}
    }
})

core.register_craft({
    type = "shaped",
    output = "pixelfurniture:hourglass",
    recipe = {
        {"","mcl_core:gold_ingot",""},
        {"","mcl_core:glass",""},
        {"","mcl_core:gold_ingot",""}
    }
})

core.register_craft({
   -- type = "shaped",
    output = "pixelfurniture:placeable_apple",
    recipe = {
        {"","",""},
        {"","mcl_core:apple",""},
        {"","",""}
    }
})
