--[[
(C) TPH/tph9677/TubberPupperHusker/TubberPupper/Damotrix
MIT License
https://opensource.org/license/mit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

tph_wielditem = {
    -- use this to control lag
    -- controls whether or not to iterate through list of players on a timely basis
    -- e.g. 0.5 will check every 0.5 seconds
    -- 0 means "every server tick, per player" which is needlessly heavy under load;
    -- 0.05s (20Hz) is imperceptible for wield mechanics and cuts the per-player CPU floor.
    -- Wield-light responsiveness is preserved by leading the light along velocity (see modules/wieldlight.lua).
    mincheck = 0.05,
    -- CANNOT BE MODIFIED
    -- features table
    features = {
        -- 1.1
        fix_v1_item_callbacks = true, -- crash with wrong defs being indexed, wield3d despawn not running
        wield3d_despawn_fix = true, -- fix parameters with wield3d_despawn being current instead of previous
    }
}

-- names of events to be added to an "events" table
-- automatically has "on" added e.g. "on_empty"
local eventnames = {
    -- index changed
    "select", "deselect",
    -- lost
    "empty",
    -- overall modified
    -- `modify_now` does not run for `empty` (if person drops item, `modify_now` won't be ran)
    "modify_now","modify_ago",
    -- passes player wielditem's data
    -- if adding stuff (such as entity) to player on join, run on a `core.after`
    "joinplayer", "leaveplayer",
    -- to run on our own globalstep, callback is ran for each connected player
    "step",
    -- a "setting" was modified - likely `mincheck`
    "setting_changed"
}

-- list of event datas, each with their own register, table of funcs, and handler functionality
local events = {}

for _,ename in ipairs(eventnames) do
    -- name, automatic setup definition: add register function to `tph_wielditem`
    -- return will be data of this event
    events[ename] = events_api.create(ename, {global = tph_wielditem})
end
eventnames = nil -- clear

local plist = {} -- player list
local pnlist = {} -- player name list, correlated to plist

-- add to table
core.register_on_joinplayer(function(plr)
    local data = {
        obj = plr,
        name = plr:get_player_name(),
        itemstack = plr:get_wielded_item(),
        windex = plr:get_wield_index() -- wield index
    }
    local itemdef = data.itemstack:get_definition()
    data.itemdef = itemdef
    plist[#plist + 1] = data
    pnlist[data.name] = data -- reference
    -- permit event and item callback for handling player wield data on join
    if type(itemdef.tph_wielditem_on_joinplayer) == "function" then
        -- player, current item, current wield index, item definition, player's data
        itemdef.tph_wielditem_on_joinplayer(plr, data.itemstack, data.windex, itemdef, data)
    end
    events.joinplayer(plr, data) -- player, player's data
end)

-- erase from table
-- 3rd custom player parameter
local function on_leaveplayer(pdata, index, plr)
    -- not important beyond events/callbacks
    plr = plr or pdata.obj
    local itemdef = pdata.itemdef
    -- permit event and item callback for handling player wield data on leave
    if plr and itemdef and type(itemdef.tph_wielditem_on_leaveplayer) == "function" then
        -- player, current item, current wield index, item definition, player's data
        itemdef.tph_wielditem_on_leaveplayer(plr, pdata.itemstack, pdata.windex, itemdef, pdata)
    end
    events.leaveplayer(plr, pdata) -- player, player's data
    -- erase data
    table.remove(plist, index)
    pnlist[pdata.name] = nil
end
-- erase data on player leave
core.register_on_leaveplayer(function(plr)
    for index,pdata in ipairs(plist) do -- player data
        if pdata.obj == plr then
            on_leaveplayer(pdata, index, plr)
        end
    end
end)
-- doesn't call `on_leaveplayer` in singleplayer, so let's make our own
core.register_on_shutdown(function()
    -- remove data for everyone
    for index,pdata in ipairs(plist) do
        on_leaveplayer(pdata, index)
    end
end)

tph_wielditem.get_player_data = function(plr)
    local pname = type(plr) == "string" and plr -- playername
    plr = core.is_player(plr) and plr or type(plr) == "string" and core.get_player_by_name(plr)
    if not plr then return end -- couldn't get player
    pname = pname or plr:get_player_name()
    return pnlist[pname] -- return saved data
end

-- only important if mincheck is changed
-- used for counting
local gdtime = 0 -- global dtime
-- main block of code for wield mechanics
core.register_globalstep(function(dtime)
    gdtime = gdtime + dtime
    -- you're putting a limit on us
    if tph_wielditem.mincheck ~= 0 then
        if gdtime < tph_wielditem.mincheck then return end -- too quick, check later
    end
    -- good to proceed
    for _,data in ipairs(plist) do
        -- old item, old index
        local oitem, oindex = data.itemstack, data.windex
        -- current item, current index
        local citem, cindex = data.obj:get_wielded_item(), data.obj:get_wield_index()
        -- player might've left and this would thusly become nil
        -- only proceed if neither are nil
        if oitem and citem then
            -- old item definition, new item def
            local odef, def = data.itemdef, citem:get_definition()
            -- first condition, became empty
            -- index is the same, but name is different
            if oindex == cindex and odef.name ~= def.name then
                -- update data
                data.itemstack = citem
                data.itemdef = def
                -- events + callbacks
                -- emptied
                if def.name == "" then
                    if type(odef.tph_wielditem_on_empty) == "function" then
                        -- player, old itemstack, wield index, dtime, item definition, player data
                        odef.tph_wielditem_on_empty(data.obj, oitem, cindex, gdtime, odef, data)
                    end
                    -- run event
                    events.empty(data.obj, oitem, cindex, gdtime, odef, data)
                -- picked up? replaced item? what? idk what happened
                else
                    -- callbacks and events get special auxiliary dual definition argument
                    local defs = {new=def, old=odef}
                    -- for whom has left us
                    if type(odef.tph_wielditem_on_modify_ago) == "function" then
                        -- player, old itemstack, old wield index, current itemstack, current wield index, dtime
                        -- definitions of both old and new items (index `old` for prior), player data
                        odef.tph_wielditem_on_modify_ago(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)
                    end
                    events.modify_ago(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)
                    -- newcomer
                    if type(def.tph_wielditem_on_modify_now) == "function" then
                        -- player, current itemstack, current wield index, old item, old wield index, dtime
                        -- definitions of both old and new items (index `new` for current), player data
                        def.tph_wielditem_on_modify_now(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
                    end
                    events.modify_now(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
                end
            -- index changed
            elseif oindex ~= cindex then
                -- update data
                data.itemstack, data.windex = citem, cindex
                data.itemdef = def
                -- events + callbacks
                -- callbacks and events get special auxiliary dual definition argument
                local defs = {new=def, old=odef}

                -- former selected (now deselected)
                if type(odef.tph_wielditem_on_deselect) == "function" then
                    -- player, old itemstack, old wield index, current item, current wield index, dtime
                    odef.tph_wielditem_on_deselect(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)
                end
                events.deselect(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)
                -- overall modification
                if type(odef.tph_wielditem_on_modify_ago) == "function" then
                    -- ditto to deselect
                    odef.tph_wielditem_on_modify_ago(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)
                end
                events.modify_ago(data.obj, oitem, oindex, citem, cindex, gdtime, defs, data)


                -- now selected
                if type(def.tph_wielditem_on_select) == "function" then
                    -- player, current itemstack, current wield index, old item, old wield index, dtime
                    -- old item, old wield index, dtime, defs, and data are for auxiliary purposes
                    def.tph_wielditem_on_select(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
                end
                events.select(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
                -- overall modification
                if type(def.tph_wielditem_on_modify_now) == "function" then
                    -- ditto to selected
                    def.tph_wielditem_on_modify_now(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
                end
                events.modify_now(data.obj, citem, cindex, oitem, oindex, gdtime, defs, data)
            end
            -- on step handling
            if type(def.tph_wielditem_on_step) == "function" then
                -- player, current item, current wield index, dtime, item definition, player data
                def.tph_wielditem_on_step(data.obj, citem, cindex, gdtime, def, data)
            end
            -- event
            events.step(data.obj, citem, cindex, gdtime, def, data)
        end -- items not nil check
    end
    -- refresh dtime count
    gdtime = 0
end)

-- permit code modularization
do
    local modpath = core.get_modpath("tph_wielditem")
    -- modules time!
    -- get modules information
    local modules = modpath.."/modules"
    modules = {path = modules, list = core.get_dir_list(modules, false)}
    -- unsorted misc, active and loaded modules
    local unsorted, active = {}, {}
    -- unsolved: data with prerequisites not fulfilled, impossible: cannot be loaded
    local unsolved, impossible = {}, {}
    for _,file in ipairs(modules.list) do
        local path = file:sub(-4) == ".lua" and modules.path.."/"..file
        local data = path and dofile(path)
        -- only run data that is a table and has a `main` function
        if type(data) == "table" and type(data.main) == "function" then
            data.name = file:sub(1,-5) -- grab from file name
            data.path = path -- add path
            -- add to table to sort
            unsorted[#unsorted + 1] = data
        end
    end
    -- load data function
    local function load_data(data)
        if active[data.name] then return end -- already active!
        -- returned to mod, a table of `events_api.create` results, key being the event's names
        local eventsdata
        -- create refined list of events, should be an array of event names
        if type(data.events) == "table" then
            eventsdata = {}
            for _,ename in ipairs(data.events) do
                -- appends the module's name to the event, e.g. a `wielditem` would have `wielditem_myevent`
                ename = table.concat({data.name,"_",ename})
                -- create event name, automated setup definition: add `register_on_myevent` function to mod
                eventsdata[ename] = events_api.create(ename, {global = tph_wielditem})
            end
        end
        -- run main thread
        -- provide moddata, clone of gathered module's data, table of events information if was provided
        data.main(tph_wielditem, table.copy(data), eventsdata)
        -- add data to active table
        active[data.name] = data
        -- remove from unsolved
        unsolved[data.name] = nil
    end
    -- now to properly sort!
    for _,data in ipairs(unsorted) do
        -- permit singular string "required"
        data.depends = type(data.depends) == "string" and {data.depends} or data.depends
        -- needs extra!
        if type(data.depends) == "table" then
            unsolved[data.name] = data
        -- requires nothing, seamless!
        else
            load_data(data)
        end
    end
    -- iterate through the dependencies, to ensure they load!
    -- run them on success
    local seek_dependencies -- declare so we can use it inside
    seek_dependencies = function(data)
        -- can't even check!
        if type(data) ~= "table" then return end
        -- already active, so we're good
        if active[data.name] then return true end
        -- check through our depends
        for _,dname in ipairs(data.depends) do -- dname: dependency name
            -- can't ever be fulfilled
            if impossible[dname] then
                data.missing_dependency = dname -- note that it's a missing dependency for it
                return
            end
            -- if dependency is not active, then try to resolve that!
            if not active[dname] then
                local d_data = unsolved[dname]
                -- ok, we can at least load this possibly
                -- success!
                if seek_dependencies(d_data) then
                    load_data(d_data)
                -- ensure anything else knows that dependency is impossible!
                else
                    impossible[dname] = d_data or {name=dname} -- use unsolved data, or set as a table with just name
                    --[[
                    this caused issues with a module requiring the same thing as a module it requires
                    testmodule: wield3d, wieldlight | wieldlight: wield3d
                    testmodule got checked first, then seemed to erase wieldlight from unsolved, causing it
                    to disappear? did not appear in any debug messages even here
                    --unsolved[dname] = nil
                    --]]
                    data.missing_dependency = dname -- for debugging purposes
                    return -- we ourselves are impossible too lol
                end
            end
        end
        return true -- successfully set up
    end
    -- go through unsolved (depends on another module)
    for mname,data in pairs(unsolved) do -- module name, data
        -- success! successfully activated
        -- if not noted as impossible
        if not impossible[mname] and seek_dependencies(data) then
            load_data(data)
        -- could not load properly!
        else
            unsolved[mname] = nil
            impossible[mname] = data -- just ensure it's set properly, again
        end
    end
    -- print warnings for the "impossible"
    for mname, data in pairs(impossible) do -- module name, data
        if data.missing_dependency then
            core.log("error", "tph_wielditem: module '"..mname.."' is missing module '"..
              data.missing_dependency.."', and is unable to be ran.")
        end
    end
    -- active modules table
    tph_wielditem.active_modules = active
    -- unsolved, could not get required
    tph_wielditem.unresolved_modules = impossible
end

-- for error handling
-- get current modname, but with handling for nil
local function get_cmn()
    return core.get_current_modname() or "unknown mod"
end

-- metatable protection!
local writingchecks = {
    -- ensure never below 0
    mincheck = function(value)
        return value >= 0 and value or 0
    end
}

-- declare `moddata`
local moddata = table.copy(tph_wielditem)

tph_wielditem = setmetatable({}, {
    __index = function(data, key)
        -- I'm lazy, you get a copy of these special tables instead of an error
        return type(moddata[key]) == "table" and table.copy(moddata[key]) or moddata[key]
    end,
    __newindex = function(data, key, value)
        local oldvalue = moddata[key]
        if type(oldvalue) == "nil" then -- no writing to this mod with unique values
            return core.log("warning", "tph_wielditem: attempted to add "..type(value).." type '"..tostring(key)..
              "' to tph_eating global. Blocked write from mod: "..get_cmn())
        end
        if type(value) == "nil" then return end -- can't set to nil
        -- an unwritable!
        if key == "features" then
            error("tph_wielditem: cannot write to features table, write blocked")
        end
        -- now to continue on as we were doing
        local checkfunc = writingchecks[key]
        -- a function for checking this value needs to exist
        if not checkfunc then
            return core.log("error", "tph_wielditem: attempted to modify 'tph_wielditem."..key..
              "'. Blocked write from mod: "..get_cmn())
        end
        value = checkfunc(value) or value -- return nil to not modify
        if oldvalue == value then return end -- don't modify something that's already been modified
        moddata[key] = value -- set now
        -- run events for setting change
        events.setting_changed(key, value, oldvalue) -- name of index, changing value to, prior value
    end,
    -- below requires https://content.luanti.org/packages/TPH/metatable_metamethods/
    -- iteration, at last!
    __pairs = function(t)
        return pairs(moddata)
    end,
    -- no ipairs needed
    -- prevent metatable overwrite
    __setmetatable = function(t, met)
        return false
    end
})

-- test
--[[
tph_wielditem.register_on_wieldlight_alit(function(pos, node, itemdef, pdata)
    core.log(core.pos_to_string(pos).." alit by "..pdata.name)
end)
tph_wielditem.register_on_wieldlight_unlit(function(pos, pdata)
    pdata = pdata or {name="unknown"}
    core.log(core.pos_to_string(pos).." has lost its light after "..pdata.name.." left")
end)
tph_wielditem.register_on_wield3d_spawn(function(plr, wield3d, pdata)
    core.log("HOLDING "..wield3d.stackstring)
end)
tph_wielditem.register_on_wield3d_despawn(function(plr, wield3d, pdata)
    core.log("LETTING GO OF "..wield3d.stackstring)
end)
tph_wielditem.register_on_modify_now(function(plr, item, index, oitem, oindex, dtime, defs)
    core.log(defs.new.name.." ;; "..index.."  :  "..dtime)
end)
tph_wielditem.register_on_modify_ago(function(plr, oitem, oindex, item, index, dtime, defs)
    core.log(defs.old.name.." ;; "..oindex.."  :  "..dtime)
end)
--]]
-- setting callback test
--[[
tph_wielditem.register_on_setting_changed(function(key, value, oldvalue)
    core.log(key.." changed to "..value.." from "..oldvalue)
end)
local change_time
change_time = function(num)
    tph_wielditem.mincheck = num
    core.after(2, change_time, math.random())
end
change_time()
--]]