--[[
(C) TPH/tph9677/TubberPupperHusker/TubberPupper/Damotrix
MIT License
https://opensource.org/license/mit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

return {
main = function(moddata, moduledata, events)
    -- show wielded item
    core.register_entity("tph_wielditem:handitem", {
        initial_properties = {
            physical = false,
            pointable = false,
            visual = "wielditem",
            static_save = false -- removes if in unloaded chunk
        },
        -- staticdata should be ItemStack:to_string()
        on_activate = function(self, staticdata, dtime_s)
            self.stackstring = staticdata
            -- despawn if we aren't set up after 1.2 seconds
            core.after(1.2, function()
                if self and self.object then
                    if self.stack and self.itemdef and self.wielder then return end -- don't delete, got set up
                    self.object:remove()
                end
            end)
        end,
        on_deactivate = function(self, removal)
            local plr = self.wielder
            local pdata = tph_wielditem.get_player_data(plr)
            -- run item callback and event of destruction
            local itemdef = self.itemdef
            if itemdef and type(itemdef.tph_wielditem_wield3d_despawn) == "function" then
                local stack = type(self.stack) == "userdata" and self.stack or nil
                local windex = type(self.wielder_windex) == "number" and self.wielder_windex or nil
                -- player, wield3d entity, the itemstack, the wield index, item's definition, player's data
                -- itemstack and wield index will be stored in the entity, and can thus be nil if modified
                itemdef.tph_wielditem_wield3d_despawn(plr, self, stack, windex, itemdef, pdata)
            end
            events.wield3d_despawn(plr, self, pdata) -- player, wield3d entity, player's data
            pdata.wield3d = nil -- erase from player's data
        end,
        -- itemstring can be ItemStack object
        convert = function(self, itemstring)
            local stack
            -- get itemstack, convert itemstring to a proper itemstring
            if type(itemstring) == "userdata" and itemstring.to_string then
                stack = itemstring
                itemstring = itemstring:to_string()
            end
            -- failed to convert, deleting
            if type(itemstring) ~= "string" or itemstring == "" then
                return self.object:remove()
            end
            stack = stack or ItemStack(itemstring)
            self.stack = stack
            self.stackstring = itemstring
            local itemdef = self.stack:get_definition()
            -- can't get item definition, yikes!
            if not itemdef then return self.object:remove() end
            self.itemdef = itemdef -- add to entity table
            -- shorthands for each
            local itemtype = itemdef.type
            local itemdraw = itemdef.drawtype or "normal"
            local hasim = itemdef.inventory_image ~= "" and true -- has inventory image
            -- modify initial proeprties
            local props = self.object:get_properties()
            -- use itemstring for wield
            props.wield_item = itemstring
            -- visual size
            local ws = itemdef.wield_scale and table.copy(itemdef.wield_scale) or {} -- wield scale
            ws.x = (ws.x or 1) * 0.25
            ws.y = (ws.y or 1) * 0.25
            ws.z = (ws.z or 1) * 0.25
            props.visual_size = ws
            -- set glow depending on `light_source`
            if itemdef.light_source ~= 0 then props.glow = itemdef.light_source end
            -- set properties
            self.object:set_properties(props)
            -- attach item
            -- pos
            local w3dap = itemdef.wield3d_attach_pos or {} -- wield 3d attach pos
            w3dap.x = w3dap.x or ( (itemdraw == "normal" and not hasim) and -0.5) or 0
            w3dap.y = w3dap.y or (itemtype == "tool" and 5.5) or 5.4
            w3dap.z = w3dap.z or (itemtype == "tool" and 3 or
              (itemdraw == "normal" and not hasim) and 2.8) or 3.3
            -- rotation
            local w3dar = itemdef.wield3d_attach_rot or {} -- wield 3d attach rotation
            w3dar.x = w3dar.x or -90
            w3dar.y = w3dar.y or (itemtype == "tool" and 225 or
              (itemdraw == "normal" and not hasim) and 230) or 200
            w3dar.z = w3dar.z or ( (itemdraw == "normal" and not hasim) and 100) or 90
            -- attaching
            self.object:set_attach(self.wielder, "Arm_Right", w3dap, w3dar)
        end
    })

    -- create wield3d entity for player, pdata parameter is optional
    -- returns entity on success
    local function createobj(plr, item, pdata)
        pdata = pdata or tph_wielditem.get_player_data(plr)
        if not pdata then return end -- failed to retrieve wielditem data for player
        local obj
        local ppos = plr:get_pos() -- player position
        -- try 20 times
        for i=1, 20 do
            -- add to player pos to prevent despawn
            obj = core.add_entity(ppos, "tph_wielditem:handitem", item:to_string())
            if obj and obj:get_pos() then break end -- successfully added without issue, break
            -- remove object on failure
            if not obj:get_pos() then
                obj:remove()
                obj = nil
            end
        end
        if not obj then return end -- could not create object successfully
        local ent = obj:get_luaentity()
        if not ent then return obj:remove() end -- failure somehow
        -- last bits of setup
        ent.wielder = plr -- add player object to wielder
        ent.wielder_windex = pdata.windex -- add wielded index to entity as well
        pdata.wield3d = ent -- add entity to player's data
        -- run convert function
        ent:convert(item)
        -- return entity
        return ent
    end

    -- remove from player
    local function remove_wield3d(plr, pdata)
        pdata = pdata or tph_wielditem.get_player_data(plr) -- get player's data to erase entity
        if not (pdata and pdata.wield3d) then return end
        return pdata.wield3d.object:remove()
    end

    -- add to player
    -- pdata and item are optional parameters
    local function add_wield3d(plr, pdata, item)
        pdata = pdata or tph_wielditem.get_player_data(plr) -- get player's data to erase previous entity
        remove_wield3d(plr, pdata) -- remove previous entity
        item = item or (pdata and pdata.item) or plr:get_wielded_item()
        if item:get_name() == "" then return end
        local ent = createobj(plr, item, pdata)
        -- return entity and player data on success
        -- run event as well
        if ent then
            -- run item callback too!
            local itemdef = pdata.itemdef
            if itemdef and type(itemdef.tph_wielditem_wield3d_spawn) == "function" then
                -- player, wield3d entity, current item, current wield index, item's definition, player's data
                itemdef.tph_wielditem_wield3d_spawn(plr, ent, pdata.itemstack, pdata.windex, itemdef, pdata)
            end
            events.wield3d_spawn(plr, ent, pdata) -- player, wield3d entity, player's data
            return ent, pdata
        end
    end

    -- namespace functions
    -- don't trust players to reliably send playerdata table (pdata)
    function tph_wielditem.wield3d_add(plr, itemstack) -- itemstack parameter is optional
        return add_wield3d(plr, nil, itemstack)
    end

    function tph_wielditem.wield3d_remove(plr)
        return remove_wield3d(plr)
    end

    -- events
    -- player equipping something new
    tph_wielditem.register_on_modify_now(function(plr, item, index, olditem, oldindex, dtime, defs, pdata)
        add_wield3d(plr, pdata, item)
    end)

    -- player joining
    tph_wielditem.register_on_joinplayer(function(plr, pdata)
        -- run on after so it gets properly added
        core.after(0, function() add_wield3d(plr, pdata) end)
    end)

    -- player dropped item
    tph_wielditem.register_on_empty(function(plr, oitem, index, dtime, def, pdata)
        remove_wield3d(plr, pdata)
    end)

    -- erase entity on player leave
    tph_wielditem.register_on_leaveplayer(function(plr, pdata)
        remove_wield3d(plr, pdata)
    end)

    -- consistently update the `stack` value on step
    tph_wielditem.register_on_step(function(plr, itemstack, index, dtime, def, pdata)
        if type(pdata.wield3d) == "table" then
            pdata.wield3d.stack = itemstack
        end
    end)
end,
-- custom events
events = {"spawn", "despawn"}
}

