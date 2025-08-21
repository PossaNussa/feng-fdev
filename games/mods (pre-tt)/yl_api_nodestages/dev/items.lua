
local example = {}
example.modpath = minetest.get_modpath("example") .. DIR_DELIM

function example.get_node_definition()
    local t = {
        drawtype = "plantlike",
        paramtype = "light",
        is_ground_content = false,
        walkable = false,
        selection_box = {
            type = "fixed",
            fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
        },
        groups = {
            attached_node = 1,
            dig_immediate = 3,
            canned_food = 1,
            vessel = 1
        }
    }
    return t
end

dofile(example.modpath .. "example_item_melon.lua")
dofile(example.modpath .. "example_item_chair.lua")
dofile(example.modpath .. "example_item_cobble.lua")
dofile(example.modpath .. "example_item_sand.lua")
dofile(example.modpath .. "example_item_remove.lua")
dofile(example.modpath .. "example_item_remove_remove.lua")
