
-- These are default settings
_c.cache.settings = {
    -- Can camps be crafted, useful if you only wanted them bought or sold from a shop (Or given only a limited number)
    -- This will include the parts needed for crafting (else the craft items won't be craft-able either)
    craft = true,
    --[[
    -- These features are currently not available, still needs to be developed
    -- Can camp upgrades be crafted, independent of craft, some upgrades are: phase shift (allow plants to grow even while it's "packed")
    craft_upgrades = true,
    -- On camps upgraded with phase shift, perform an artificial plant growth (This is different than normal because it's in mod_storage)
    hook_plants = true,
    -- On camps upgraded with phase shift, perform an artificial "cook" for furnaces (This is slightly different than normal because it's in mod_storage)
    hook_furnaces = true,
    -- How many seconds to perform 1 phase shift event (This can NOT ever be lower than 1.0)
    phase_shift = 4.0,
    ]]
}

_c.cache.settings.craft = core.settings:get_bool("camps.craft", true)
