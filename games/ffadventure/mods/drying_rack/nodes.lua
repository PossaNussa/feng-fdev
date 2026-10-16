local TICK     = drying_rack.TICK_INTERVAL
local BASE     = drying_rack.BASE_DRYING_TIME
local VIS_SIZE = 0.3

-- Build the hover-text shown while drying is in progress.
local function make_infotext(itemname, recipe, progress)
    local in_def  = minetest.registered_items[itemname]
    local out_def = minetest.registered_items[recipe.output]
    local in_desc  = (in_def  and in_def.description)  or itemname
    local out_desc = (out_def and out_def.description)  or recipe.output

    if progress and progress > 0 then
        local base_time = recipe.time or BASE
        local pct = math.min(99, math.floor(progress / base_time * 100))
        return ("Drying: %s → %s (%d%%)"):format(in_desc, out_desc, pct)
    end
    return ("Drying: %s → %s"):format(in_desc, out_desc)
end

-- ======================================================================
-- DRYING RACK NODE
-- ======================================================================
minetest.register_node("drying_rack:drying_rack", {
    description     = "Drying Rack",
    drawtype        = "mesh",
    is_ground_content = false,
    mesh            = "drying_rack.obj",
    tiles           = {"drying_rack.png"},
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
        meta:set_float("drying_progress", 0)
    end,

    -- Right-click: insert a valid meat/fish, or retrieve whatever is stored.
    on_rightclick = function(pos, node, clicker, itemstack)
        if not clicker:is_player() then return itemstack end
        local pname = clicker:get_player_name()

        if minetest.is_protected(pos, pname) then
            minetest.record_protection_violation(pos, pname)
            return itemstack
        end

        local meta    = minetest.get_meta(pos)
        local inv     = meta:get_inventory()
        local stored  = inv:get_stack("main", 1)
        local timer   = minetest.get_node_timer(pos)

        -- Rack has something in it → give it back.
        if not stored:is_empty() then
            local player_inv = clicker:get_inventory()
            if player_inv:room_for_item("main", stored) then
                inv:set_stack("main", 1, ItemStack(""))
                if timer:is_started() then timer:stop() end
                meta:set_string("infotext", "")
                meta:set_float("drying_progress", 0)
                drying_rack.remove_item_entity(pos)
                minetest.sound_play("default_place_node", {pos = pos, gain = 0.5})
                -- If the hand is empty, return the item as the new wielded stack.
                -- If the hand holds the same item type with room, merge directly
                -- into itemstack and return it; using add_item on the held slot
                -- then returning a stale count would destroy the added item.
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
        local put_stack = ItemStack(itemstack)
        put_stack:set_count(1)
        local itemname = put_stack:get_name()
        local recipe   = drying_rack.recipes[itemname]
        if not recipe then return itemstack end  -- not a drying ingredient

        if not minetest.is_creative_enabled(pname) then
            itemstack:take_item()
        end

        inv:set_stack("main", 1, put_stack)
        drying_rack.update_item_entity(pos, node)
        meta:set_float("drying_progress", 0)
        meta:set_string("infotext", make_infotext(itemname, recipe, 0))
        timer:start(TICK)
        minetest.sound_play("default_place_node", {pos = pos, gain = 0.5})
        return itemstack
    end,

    -- Timer fires every TICK seconds.
    -- Accumulates heat-weighted progress; transforms item when done.
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv  = meta:get_inventory()
        local item = inv:get_stack("main", 1)
        if item:is_empty() then return false end

        local itemname = item:get_name()
        local recipe   = drying_rack.recipes[itemname]
        if not recipe then return false end  -- item removed from recipes (shouldn't happen)

        local base_time = recipe.time or BASE
        local mult      = drying_rack.get_speed_multiplier(pos)
        local progress  = (meta:get_float("drying_progress") or 0) + TICK * mult

        if progress >= base_time then
            -- Done!
            inv:set_stack("main", 1, ItemStack(recipe.output))
            drying_rack.update_item_entity(pos, minetest.get_node(pos))
            meta:set_float("drying_progress", 0)
            local out_def  = minetest.registered_items[recipe.output]
            local out_desc = (out_def and out_def.description) or recipe.output
            meta:set_string("infotext", out_desc .. " (done — right-click to collect)")
            return false  -- stop timer; player must collect to restart
        end

        meta:set_float("drying_progress", progress)
        meta:set_string("infotext", make_infotext(itemname, recipe, progress))
        return true  -- restart for another TICK seconds
    end,

    -- Drop contents when the rack is broken.
    on_destruct = function(pos)
        local timer = minetest.get_node_timer(pos)
        if timer:is_started() then timer:stop() end
        drying_rack.drop_item(pos)
    end,

    -- Protection hooks for external inventory access (pipes, etc.)
    allow_metadata_inventory_move = function(pos, _, _, _, _, count, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        return count
    end,
    allow_metadata_inventory_take = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        return stack:get_count()
    end,
    allow_metadata_inventory_put = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            minetest.record_protection_violation(pos, player:get_player_name())
            return 0
        end
        return stack:get_count()
    end,
})

-- ======================================================================
-- ITEM-DISPLAY ENTITY
-- Shows a miniature wield-item floating on the rack.
-- ======================================================================
minetest.register_entity("drying_rack:drying_rack_item", {
    hp_max   = 1,
    visual   = "wielditem",
    visual_size = {x = VIS_SIZE, y = VIS_SIZE},
    physical = false,
    pointable = false,
    textures = {"blank.png"},
    _texture = "blank.png",
    _scale   = 1,
    groups   = {immortal = 1},

    on_activate = function(self, staticdata)
        if staticdata and staticdata ~= "" then
            local data        = staticdata:split(";")
            self._nodename    = data[1] or ""
            self._texture     = data[2] or "blank.png"
            self._scale       = tonumber(data[3]) or 1
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
