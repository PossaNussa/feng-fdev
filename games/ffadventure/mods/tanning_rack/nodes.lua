local PUNCHES_NEEDED = 8
local VIS_SIZE       = 0.3

-- ======================================================================
-- TANNED LEATHER
--
-- The tanning rack's finished product. It takes *cured* leather (produced by
-- the drying rack) and works it by hand into tanned leather, the material the
-- rewritten crafting recipes require. Formerly "worked leather" — the old id is
-- aliased below so existing saves keep their stacks.
-- ======================================================================
minetest.register_craftitem("tanning_rack:tanned_leather", {
    description = "Tanned Leather",
    inventory_image = "tanning_rack_tanned_leather.png",
    groups = {leather = 1, flammable = 1},
})

minetest.register_alias("tanning_rack:worked_leather", "tanning_rack:tanned_leather")

-- ======================================================================
-- UTILITY FUNCTIONS
-- ======================================================================

-- Returns true if an item can be tanned. Only cured leather (from the drying
-- rack) qualifies: raw hides must be cured first, tanned leather is finished.
local function is_tannable(itemname)
    if not itemname or itemname == "" then return false end
    local def = minetest.registered_items[itemname]
    if not def then return false end
    local g = def.groups or {}
    return (g.cured_leather or 0) > 0
end

function tanning_rack.remove_item_entity(pos)
    for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.5)) do
        local le = obj:get_luaentity()
        if le and le.name == "tanning_rack:tanning_rack_item" then
            obj:remove()
        end
    end
end

function tanning_rack.update_item_entity(pos, node)
    tanning_rack.remove_item_entity(pos)

    local meta = minetest.get_meta(pos)
    local item = meta:get_inventory():get_stack("main", 1)
    if item:is_empty() then return end

    local param2 = node.param2
    local off    = tanning_rack.facedir_offsets[param2] or {x = 0, y = 0, z = 0}
    local yaw    = math.pi * 2 - param2 * math.pi / 2

    local epos = {
        x = pos.x + off.x * 6.5 / 16,
        y = pos.y + off.y * 6.5 / 16,
        z = pos.z + off.z * 6.5 / 16,
    }

    local entity = minetest.add_entity(epos, "tanning_rack:tanning_rack_item")
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

function tanning_rack.drop_item(pos)
    local meta = minetest.get_meta(pos)
    local inv  = meta:get_inventory()
    local item = inv:get_stack("main", 1)
    if not item:is_empty() then
        minetest.add_item(pos, item)
        inv:set_stack("main", 1, ItemStack(""))
    end
    meta:set_string("infotext", "")
    meta:set_int("punches", 0)
    tanning_rack.remove_item_entity(pos)
end

-- ======================================================================
-- TANNING RACK NODE
-- ======================================================================
minetest.register_node("tanning_rack:tanning_rack", {
    description     = "Tanning Rack",
    drawtype        = "mesh",
    is_ground_content = false,
    mesh            = "drying_rack.obj",
    tiles           = {"tanning_rack.png"},
    selection_box   = {type = "fixed", fixed = {-0.5, -0.4375, 0.125, 0.5, -0.3125, 0.5}},
    collision_box   = {type = "fixed", fixed = {-0.5, -0.4375, 0.125, 0.5, -0.3125, 0.5}},
    use_texture_alpha = "opaque",
    paramtype       = "light",
    paramtype2      = "facedir",
    sunlight_propagates = true,
    groups          = {dig_immediate = 3, deco_block = 1},
    sounds          = default.node_sound_wood_defaults(),
    node_placement_prediction = "",

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:get_inventory():set_size("main", 1)
        meta:set_int("punches", 0)
    end,

    -- Right-click: insert a tannable item, or retrieve whatever is stored.
    on_rightclick = function(pos, node, clicker, itemstack)
        if not clicker:is_player() then return itemstack end
        local pname = clicker:get_player_name()

        if minetest.is_protected(pos, pname) then
            minetest.record_protection_violation(pos, pname)
            return itemstack
        end

        local meta   = minetest.get_meta(pos)
        local inv    = meta:get_inventory()
        local stored = inv:get_stack("main", 1)

        -- Rack has something → give it back.
        if not stored:is_empty() then
            local player_inv = clicker:get_inventory()
            if player_inv:room_for_item("main", stored) then
                inv:set_stack("main", 1, ItemStack(""))
                meta:set_int("punches", 0)
                meta:set_string("infotext", "")
                tanning_rack.remove_item_entity(pos)
                minetest.sound_play("default_place_node", {pos = pos, gain = 0.5})
                -- Merge into hand if possible, to avoid stale-copy overwrite bug.
                if itemstack:is_empty() then
                    return stored
                end
                if itemstack:get_name() == stored:get_name() and
                        itemstack:get_count() < itemstack:get_stack_max() then
                    itemstack:set_count(itemstack:get_count() + stored:get_count())
                    return itemstack
                end
                player_inv:add_item("main", stored)
            else
                minetest.chat_send_player(pname, "Your inventory is full!")
            end
            return itemstack
        end

        -- Rack is empty → try to insert the held item.
        if not is_tannable(itemstack:get_name()) then return itemstack end

        local put_stack = ItemStack(itemstack)
        put_stack:set_count(1)
        if not minetest.is_creative_enabled(pname) then
            itemstack:take_item()
        end

        inv:set_stack("main", 1, put_stack)
        meta:set_int("punches", 0)
        meta:set_string("infotext",
            "Tanning: 0/" .. PUNCHES_NEEDED .. " — punch to work the leather")
        tanning_rack.update_item_entity(pos, node)
        minetest.sound_play("default_place_node", {pos = pos, gain = 0.5})
        return itemstack
    end,

    -- Punch: increment work counter; at PUNCHES_NEEDED transform to worked leather.
    on_punch = function(pos, node, puncher)
        if not puncher or not puncher:is_player() then return end
        local pname = puncher:get_player_name()

        if minetest.is_protected(pos, pname) then
            minetest.record_protection_violation(pos, pname)
            return
        end

        local meta   = minetest.get_meta(pos)
        local inv    = meta:get_inventory()
        local stored = inv:get_stack("main", 1)
        if stored:is_empty() then return end

        local punches = meta:get_int("punches") + 1

        if punches >= PUNCHES_NEEDED then
            inv:set_stack("main", 1, ItemStack("tanning_rack:tanned_leather"))
            meta:set_int("punches", 0)
            meta:set_string("infotext", "Tanned Leather — right-click to collect")
            tanning_rack.update_item_entity(pos, node)
            minetest.sound_play("default_dig_choppy", {pos = pos, gain = 1.0})
        else
            meta:set_int("punches", punches)
            meta:set_string("infotext",
                "Tanning: " .. punches .. "/" .. PUNCHES_NEEDED .. " — keep punching!")
            minetest.sound_play("default_dig_choppy", {pos = pos, gain = 0.5})
        end
    end,

    -- Drop contents when broken.
    on_destruct = function(pos)
        tanning_rack.drop_item(pos)
    end,

    allow_metadata_inventory_move = function(pos, _, _, _, _, count, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        return count
    end,
    allow_metadata_inventory_put = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        if not is_tannable(stack:get_name()) then return 0 end
        return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        return stack:get_count()
    end,
})

-- ======================================================================
-- ITEM DISPLAY ENTITY
-- ======================================================================
minetest.register_entity("tanning_rack:tanning_rack_item", {
    hp_max      = 1,
    visual      = "wielditem",
    visual_size = {x = VIS_SIZE, y = VIS_SIZE},
    physical    = false,
    pointable   = false,
    textures    = {"blank.png"},
    _texture    = "blank.png",
    _scale      = 1,
    groups      = {immortal = 1},

    on_activate = function(self, staticdata)
        if staticdata and staticdata ~= "" then
            local data     = staticdata:split(";")
            self._nodename = data[1] or ""
            self._texture  = data[2] or "blank.png"
            self._scale    = tonumber(data[3]) or 1
        end
        self:_update_texture()
    end,

    get_staticdata = function(self)
        return table.concat({
            self._nodename or "",
            self._texture  or "blank.png",
            self._scale    or 1,
        }, ";")
    end,

    on_punch = function() return true end,

    _update_texture = function(self)
        if not self._texture then return end
        self.object:set_properties({
            textures    = {self._texture},
            visual_size = {
                x = VIS_SIZE / (self._scale or 1),
                y = VIS_SIZE / (self._scale or 1),
            },
        })
    end,
})
