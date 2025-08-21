-- The functions and variables in this file are only for use in the mod itself.
-- Those that do real work should be local and wrapped in public functions
local function log(text)
    local logmessage = yl_api_nodestages.t("log_prefix",
                                           yl_api_nodestages.modname, text)
    if (yl_api_nodestages.settings.debug == true) then
        minetest.log("action", logmessage)
    end
    return logmessage
end

function yl_api_nodestages.log(text) return log(text) end

dofile(yl_api_nodestages.modpath .. "internal_nodefunctions.lua")
dofile(yl_api_nodestages.modpath .. "internal_validation.lua")
dofile(yl_api_nodestages.modpath .. "internal_lbm.lua")
