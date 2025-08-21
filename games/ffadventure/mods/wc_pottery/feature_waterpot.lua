local modname = minetest.get_current_modname()

local cpotwet = "wc_pottery:pottery_waterpot_glazed"
local cpotdry = "wc_pottery:pottery_claypot_glazed"
local cpot_chip = "wc_pottery:chip"

local water_texture = "(default_water.png^[verticalframe:32:8)^[opacity:160"
local ceramic_texture = "wc_pottery_ceramic.png"
local glaze_texture = "wc_pottery_glaze.png"
local glaze_pattern_texture = "wc_pottery_glaze_pattern.png^[opacity:40"
local storebox_frame_texture = "default_furnace_side.png^[opacity:40"
local glaze_ceramic_texture = "(" .. ceramic_texture .. ")^(" .. glaze_texture .. ")"
local glaze_side_texture = "(" .. glaze_ceramic_texture .. ")^(" .. glaze_pattern_texture .. ")"
local glaze_top_texture = "(" .. glaze_ceramic_texture .. ")^(" .. storebox_frame_texture .. ")^[mask:default_furnace_side.png"
local glaze_water_texture = "(" .. water_texture .. ")^(" .. glaze_top_texture .. ")"

local cpotdirs = {
    {x = 1, y = 0, z = 0},
    {x = -1, y = 0, z = 0},
    {x = 0, y = 0, z = 1},
    {x = 0, y = 0, z = -1}
}

local function find_water(pos)
    return minetest.find_nodes_in_area(
        {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
        {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
        {"group:water_source"}
    )
end

local function soak_up_water(pos)
    local any = false
    for _, p in pairs(find_water(pos)) do
        minetest.remove_node(p)
        any = true
    end
    return any
end

minetest.register_node("wc_pottery:pottery_waterpot_glazed", {
    description = "Glazed Ceramic Waterpot",
    tiles = {
        glaze_side_texture,
        glaze_ceramic_texture,
        glaze_water_texture
    },
    use_texture_alpha = "blend",
    drawtype = "nodebox",
    paramtype = "light",
    groups = {
        cracky = 3,
        moist = 1,
        coolant = 1,
        storebox = 1,
        waterpot = 1,
        not_in_creative_inventory = 1,
    },
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    on_rightclick = function(pos, _, clicker, itemstack)
        local item_name = itemstack:get_name()
        if item_name:find("^bucket:bucket_empty") then
            minetest.set_node(pos, {name = cpotwet})
            itemstack:take_item()
            clicker:set_wielded_item(itemstack)
            return true
        end
    end,
    on_punch = function(pos, _, puncher)
        minetest.set_node(pos, {name = cpotdry})
        minetest.sound_play("default_punch_note", {pos = pos, gain = 1.0})
    end,
    drop = {
        max_items = 1,
        items = {
            {items = {cpot_chip .. " 8"}}
        }
    }
})

minetest.register_abm({
    label = "ceramic waterpot fill",
    interval = 1,
    chance = 10,
    nodenames = {cpotdry},
    neighbors = {"group:water_source"},
    action = function(pos)
        if soak_up_water(pos) then
            minetest.set_node(pos, {name = cpotwet})
        end
    end
})

minetest.register_craft({
    output = "wc_pottery:pottery_waterpot_glazed",
    recipe = {
        {"group:clay_lump", "group:clay_lump", "group:clay_lump"},
        {"", "group:glass", ""},
        {"", "", ""},
    },
})

minetest.register_craft({
    type = "fuel",
    recipe = "wc_pottery:pottery_waterpot_glazed",
    burntime = 30,
})

minetest.register_on_dignode(function(pos, oldnode, digger)
    if oldnode.name == cpotwet then
        minetest.set_node(pos, {name = cpotdry})
        local drops = minetest.get_node_drops(cpotwet, "")
        for _, item in ipairs(drops) do
            minetest.add_item(pos, ItemStack(item))
        end
        minetest.add_item(pos, ItemStack(cpot_chip .. " 8"))
    end
end)