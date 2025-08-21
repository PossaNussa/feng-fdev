local S = minetest.get_translator(yl_api_nodestages.modname)

local texts = {}

--function yl_api_nodestages.t(key, ...) return S(texts[key], ...) or "" end
function yl_api_nodestages.t(key, ...)
    if (texts[key] == nil) then
        minetest.log("warning","key " .. (key or "") .. " does not exist")
        return key
    end
    return S(texts[key], ...) or ""
end

-- Fixed texts

texts["log_prefix"] = "[MOD] @1 : @2"

texts["get_savepath"] = "get_savepath : @1"
texts["get_filepath"] = "get_filepath : @1"

-- Translateable texts

texts["information_additional"] = "YL Nodestages API"

texts["api_sent_x_to_y"] = "Sent @1 to @2"

-- Errormessages

texts["error_not_a_boolean_or_nil"] = "@1 must be a boolean or nil"
texts["error_not_a_string"] = "@1 must be a string"
texts["error_not_a_mod"] = "@1 must be a modname"
texts["error_not_a_table"] = "@1 must be a table"
texts["error_not_a_valid_table"] = "@1 must be a valid table"

texts["success_changed_num_stages"] = "Changed @1 amount of stages"

texts["error_item_exists"] = "@1 already exists, but overwrite was not specified"


texts["error_not_a_position"] = "@1 not a position"
texts["error_function_not_available"] = "@1 not available"

texts["target_nodestage_does_not_exist"] = "Target nodestage @1 does not exist. Source: @2 Pos: @3"

texts["undefined_state_abort"] = "Thing kaputt, aborting"

texts["stage_not_created"] = "Stage not created"

