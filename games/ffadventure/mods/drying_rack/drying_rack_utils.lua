drying_rack = {}
drying_rack.recipes = {}

-- Drying time constants
drying_rack.TICK_INTERVAL   = 10   -- timer fires every N seconds
drying_rack.BASE_DRYING_TIME = 600 -- base seconds to fully dry (10 minutes)

-- Heat-source detection ranges
local TORCH_RADIUS = 5
local FIRE_RADIUS  = 3
local FIRE_NODES   = {"fire:basic_flame", "default:lava_source", "default:lava_flowing"}

-- Populated by drying_rack.init()
local facedir_offsets = {}

-- Returns multiplicative speed factor from nearby heat sources (stacks).
--   torch within 5 nodes → ×1.5
--   fire/lava within 3 nodes → ×2.0
--   both → ×3.0
function drying_rack.get_speed_multiplier(pos)
    local mult = 1.0
    if minetest.find_node_near(pos, TORCH_RADIUS, {"group:torch"}) then
        mult = mult * 1.5
    end
    if minetest.find_node_near(pos, FIRE_RADIUS, FIRE_NODES) then
        mult = mult * 2.0
    end
    return mult
end

-- Remove any drying_rack item-display entities near pos.
function drying_rack.remove_item_entity(pos)
    for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
        local le = obj:get_luaentity()
        if le and le.name == "drying_rack:drying_rack_item" then
            obj:remove()
        end
    end
end

-- Spawn / refresh the floating wielditem entity showing what is in the rack.
function drying_rack.update_item_entity(pos, node)
    drying_rack.remove_item_entity(pos)

    local meta = minetest.get_meta(pos)
    local inv  = meta:get_inventory()
    local item = inv:get_stack("main", 1)
    if item:is_empty() then return end

    local param2 = node.param2
    local off    = facedir_offsets[param2] or {x = 0, y = 0, z = 0}
    local yaw    = math.pi * 2 - param2 * math.pi / 2

    -- Use a fresh vector so we don't mutate the caller's pos table
    local epos = {
        x = pos.x + off.x * 6.5 / 16,
        y = pos.y + off.y * 6.5 / 16,
        z = pos.z + off.z * 6.5 / 16,
    }

    local entity = minetest.add_entity(epos, "drying_rack:drying_rack_item")
    if not entity then return end
    local le = entity:get_luaentity()
    if not le then return end

    local item_name = item:get_name()
    local reg = minetest.registered_items[item_name]
    le._nodename = node.name
    le._texture  = (item_name ~= "") and item_name or "blank.png"
    le._scale    = (reg and reg.wield_scale and reg.wield_scale.x) or 1
    le:_update_texture()
    entity:set_yaw(yaw)
end

-- Drop whatever is stored in the rack as a world item, then clear metadata.
function drying_rack.drop_item(pos)
    local meta = minetest.get_meta(pos)
    local inv  = meta:get_inventory()
    local item = inv:get_stack("main", 1)
    if not item:is_empty() then
        minetest.add_item(pos, item)
        inv:set_stack("main", 1, ItemStack(""))
    end
    meta:set_string("infotext", "")
    meta:set_float("drying_progress", 0)
    drying_rack.remove_item_entity(pos)
end

function drying_rack.init()
    facedir_offsets[0] = {x =  0, y = 0, z =  1}
    facedir_offsets[1] = {x =  1, y = 0, z =  0}
    facedir_offsets[2] = {x =  0, y = 0, z = -1}
    facedir_offsets[3] = {x = -1, y = 0, z =  0}
end
