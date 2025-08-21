
camps = {}
_c = {
    version = function ()
        return "1.1"
    end,
    REPO = "https://gitlab.com/ApolloX939/camps",
    store = core.get_mod_storage(),
    cache = {},
    log = function (msg)
        if type(msg) == "table" then
            msg = core.serialize(msg)
        end
        core.log("action", "[camps] " .. tostring(msg))
    end,
    error = function (msg)
        _c.log("!! ERROR !!")
        _c.log(msg)
        local m = "Please report this at " .. _c.REPO .. "/issues/new"
        _c.log(m)
        error("Camps: " .. m)
    end,
    dofile = function (dir, file)
        local modpath = core.get_modpath("camps")
        if file == nil then
            dofile(modpath .. DIR_DELIM .. dir .. ".lua")
        else
            dofile(modpath .. DIR_DELIM .. dir .. DIR_DELIM .. file .. ".lua")
        end
    end
}

_c.log("** Camps v".._c.version().." **")

if core.registered_items["default:stone"] ~= nil then
    _c.cache.gamemode = "MTG"
elseif core.registered_items["mcl_core:stone"] ~= nil then
    -- VoxeLibre (Mineclone 2, Mineclone 5, and Mineclonia)
    _c.cache.gamemode = "VL"
else
    _c.error("No detected gamemode, expected 'Minetest Game' or 'VoxeLibre' (Mineclone 2, Mineclone 5, and Mineclonia)")
end
_c.log(".gamemode = '" .. _c.cache.gamemode .. "'")

_c.log(".settings")
_c.dofile("settings")
_c.log(".api")
_c.dofile("api", "init")
_c.log(".nodes")
_c.dofile("nodes", "init")
--_c.log(".globalstep")
--_c.dofile("globalstep")
if _c.cache.settings.craft == true then
    _c.log(".craft")
    _c.dofile("craft", "init")
end
