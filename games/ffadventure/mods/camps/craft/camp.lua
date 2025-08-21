
core.register_craft({
    type = "shaped",
    output = "camps:camp",
    recipe = {
        {_c.cache.craft.constructor, _c.cache.craft.diamond_alloy, _c.cache.craft.destructor},
        {_c.cache.craft.diamond_alloy, _c.cache.craft.diamond_block, _c.cache.craft.diamond_alloy},
        {_c.cache.craft.storage_node, _c.cache.craft.diamond_alloy, _c.cache.craft.storage_node},
    }
})
