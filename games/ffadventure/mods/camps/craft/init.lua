
_c.cache.craft = {
    air = "",

    iron_ingot = "default:steel_ingot",
    iron_block = "default:steelblock",
    gold_ingot = "default:gold_ingot",
    gold_block = "default:goldblock",
    diamond = "default:diamond",
    diamond_block = "default:diamondblock",
    chest = "default:chest",

    storage_node = "camps:storage_node",
    constructor = "camps:constructor",
    destructor = "camps:destructor",
    diamond_alloy = "camps:diamond_alloy"
}

if _c.cache.gamemode == "VL" then
    _c.cache.craft.iron_ingot = "mcl_core:iron_ingot"
    _c.cache.craft.iron_block = "mcl_core:ironblock"
    _c.cache.craft.gold_ingot = "mcl_core:gold_ingot"
    _c.cache.craft.gold_block = "mcl_core:goldblock"
    _c.cache.craft.diamond = "mcl_core:diamond"
    _c.cache.craft.diamond_block = "mcl_core:diamondblock"
    _c.cache.craft.chest = "mcl_chests:chest"
end

_c.dofile("craft", "craft_items")
_c.dofile("craft", "camp")
