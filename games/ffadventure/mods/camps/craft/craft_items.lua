
core.register_craftitem("camps:storage_node", {
    short_description = "Storage Node",
    description = "Storage Node\nProvides a Camp storage to hold blocks in it",
    inventory_image = core.inventorycube("camps_storagenode.png")
})

core.register_craftitem("camps:constructor", {
    short_description = "Constructor",
    description = "Constructor\nProvides a Camp the ability to place blocks",
    inventory_image = "camps_constructor.png"
})

core.register_craftitem("camps:destructor", {
    short_description = "Destructor",
    description = "Destructor\nProvides a Camp the ability to break blocks",
    inventory_image = "camps_destructor.png"
})

core.register_craftitem("camps:diamond_alloy", {
    short_description = "Diamond Alloy",
    description = "Diamond Alloy\nBlends gold with diamond to make a circuit",
    inventory_image = "camps_diamondalloy.png"
})

core.register_craft({
    type = "shaped",
    output = "camps:diamond_alloy",
    recipe = {
        {_c.cache.craft.air, _c.cache.craft.gold_ingot, _c.cache.craft.air},
        {_c.cache.craft.gold_ingot, _c.cache.craft.diamond, _c.cache.craft.gold_ingot},
        {_c.cache.craft.air, _c.cache.craft.gold_ingot, _c.cache.craft.air},
    }
})

core.register_craft({
    type = "shaped",
    output = "camps:destructor",
    recipe = {
        {_c.cache.craft.gold_block, _c.cache.craft.diamond, _c.cache.craft.gold_block},
        {_c.cache.craft.gold_block, _c.cache.craft.diamond, _c.cache.craft.gold_block},
        {_c.cache.craft.air, _c.cache.craft.gold_block, _c.cache.craft.air},
    }
})

core.register_craft({
    type = "shaped",
    output = "camps:constructor",
    recipe = {
        {_c.cache.craft.air, _c.cache.craft.iron_block, _c.cache.craft.air},
        {_c.cache.craft.iron_block, _c.cache.craft.diamond, _c.cache.craft.iron_block},
        {_c.cache.craft.iron_block, _c.cache.craft.diamond, _c.cache.craft.iron_block},
    }
})

core.register_craft({
    type = "shaped",
    output = "camps:storage_node",
    recipe = {
        {_c.cache.craft.iron_ingot, _c.cache.craft.chest, _c.cache.craft.iron_ingot},
        {_c.cache.craft.chest, _c.cache.craft.diamond_alloy, _c.cache.craft.chest},
        {_c.cache.craft.iron_ingot, _c.cache.craft.chest, _c.cache.craft.iron_ingot},
    }
})
