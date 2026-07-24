-- Craft recipe for the tanning rack itself.
minetest.register_craft({
    output = "tanning_rack:tanning_rack",
    recipe = {
        {"default:stick", "default:stick", "default:stick"},
        {"group:wood",    "",              "group:wood"},
        {"default:stick", "default:stick", "default:stick"},
    }
})

-- ======================================================================
-- REPLACE LEATHER INGREDIENTS IN EXISTING RECIPES WITH WORKED LEATHER
-- ======================================================================
-- Any recipe that used raw leather/hide now requires worked leather
-- instead, forcing players to tan the material first.

local W = "tanning_rack:worked_leather"

local function replace_leather_recipe(output, new_recipe)
    if not minetest.registered_items[output] then return end
    minetest.clear_craft({output = output})
    minetest.register_craft({output = output, recipe = new_recipe})
    minetest.log("action", "[tanning_rack] Updated recipe for " .. output)
end

minetest.register_on_mods_loaded(function()
    -- Saddles
    replace_leather_recipe("mobs:saddle", {
        {W, W, W},
        {W, "default:steel_ingot", W},
        {W, "default:steel_ingot", W},
    })

    replace_leather_recipe("petz:saddle", {
        {W, W, W},
        {W, "default:steel_ingot", W},
        {W, "default:steel_ingot", W},
    })

    replace_leather_recipe("petz:saddlebag", {
        {W, W, W},
        {W, "", W},
        {W, W, W},
    })

    replace_leather_recipe("petz:parchment", {
        {"", "", ""},
        {"", "", ""},
        {W,  W,  W},
    })

    -- Backpack
    replace_leather_recipe("backpacks:backpack_leather", {
        {W, W, W},
        {W, "", W},
        {W, W, W},
    })

    -- Leather armor
    replace_leather_recipe("armor_expanded:helmet_leather", {
        {W, W, W},
        {W, "", W},
        {"", "", ""},
    })

    replace_leather_recipe("armor_expanded:chestplate_leather", {
        {W, "", W},
        {W, W,  W},
        {W, W,  W},
    })

    replace_leather_recipe("armor_expanded:leggings_leather", {
        {W, W, W},
        {W, "", W},
        {W, "", W},
    })

    replace_leather_recipe("armor_expanded:boots_leather", {
        {W, "", W},
        {W, "", W},
    })

    -- Crocodile bag (water_life uses its own leather type)
    replace_leather_recipe("water_life:croc_bag", {
        {"farming:string", W, "farming:string"},
        {W,                W, W              },
        {"farming:string", W, "farming:string"},
    })
end)
