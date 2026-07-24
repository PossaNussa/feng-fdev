--[[
(C) TPH/tph9677/TubberPupperHusker/TubberPupper/Damotrix
MIT License
https://opensource.org/license/mit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

events_api = {

    --- function for creating events and their handling
    ---@param name string name of the event, do NOT include "on_" in the name if you opt for autosetup
    ---@param def? table optional definition for additional automated setup
    ---@return table eventdata provides data.funcs (table), data.handler + data.register functions for handling events. Provides data.name as the name the event was registered with.
    create = function(name, def)
        if type(name) ~= "string" then
            error("events_api: attempted to register event without a string name.")
        end
        local data = {
            name = name, -- name of the event
            -- funcs should be an array table, use `table.remove` to reliably remove certain functions
            funcs = {} -- list of functions to be ran by `data.handler`
        }
        -- what should be called to add functions to `data.funcs`
        -- should be added to your mod global as `mymod.register_on_myevent`
        data.register = function(func)
            if type(func) ~= "function" then return end
            data.funcs[#data.funcs + 1] = func
            -- function for disconnecting from list of functions
            return function()
                for ind,ffunc in ipairs(data.funcs) do -- index, found func
                    -- if we have the same ID
                    if ffunc == func then
                        return table.remove(data.funcs, ind)
                    end
                end
            end
        end
        -- what will be called to each function in `data.funcs`
        data.handler = function(...)
            if #data.funcs == 0 then return end
            -- iterates over, calling each function
            for _,func in ipairs(data.funcs) do
                func(...)
            end
        end
        -- if setup wanted and globals given for setup
        if type(def) == "table" then
            -- add to provided funcs table
            -- optional table, can be used to add data.funcs to a provided table
            if type(def.funcsgroup) == "table" then
                def.funcsgroup[name] = data.funcs
            end
            -- add to provided handlers table
            -- optional table, can be used to add data.handler to a provided table
            if type(def.handlers) == "table" then
                def.handlers[name] = data.handler
            end
            -- create function for registration in mod's global
            if type(def.global) == "table" then
                -- add register function
                def.global["register_on_"..name] = data.register
            end
        end
        -- give data a special metatable to permit calling the data to run the handler
        data = setmetatable(data, {
            __call = function(t, ...)
                return data.handler(...)
            end
        })
        -- return created event data
        return data
    end,
}