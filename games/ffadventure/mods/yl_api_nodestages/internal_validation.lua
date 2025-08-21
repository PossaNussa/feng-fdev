-- Validation
--
local function get_valid_copy_of_stage(p_stage)
    if (type(p_stage) ~= "table") then return false, yl_api_nodestages.t("stage_not_table") end

    local stage = table.copy(p_stage)

    if (yl_api_nodestages.is_valid_stage(stage) == false) then
        return false, yl_api_nodestages.t("stage_not_valid")
    end

    return true, stage

end

function yl_api_nodestages.get_valid_copy_of_stage(stage)
    return get_valid_copy_of_stage(stage)
end

local function is_valid_stage(stage)

    -- Softvalidation, we only exclude the most common mistakes

    if (stage == nil) then return false, yl_api_nodestages.t("node_does_not_have_stage") end

    if (type(stage) ~= "table") then return false, yl_api_nodestages.t("stage_not_table") end

    if (stage.stage_name == nil) then return false, yl_api_nodestages.t("stage_no_stagename") end

    if (type(stage.stage_name) ~= "string") then
        return false, yl_api_nodestages.t("stagename_not_string")
    end

    -- It's only invalid, when there's one, but not the other
    if (stage.next_stages == nil) and (stage.duration ~= nil) then
        return false, yl_api_nodestages.t("stage_no_next_stages")
    end
    if (stage.next_stages ~= nil) and (stage.duration == nil) then
        return false, yl_api_nodestages.t("stage_no_duration")
    end

    if (stage.next_stages and (type(stage.next_stages) ~= "table") and
        (type(stage.next_stages) ~= "string")) then
        return false, yl_api_nodestages.t("next_stages_not_table_or_string")
    end
    if (stage.next_stages and (type(stage.next_stages) == "table") and (next(stage.next_stages) == nil)) then
        return false, yl_api_nodestages.t("next_stages_no_members")
    end
    if (stage.next_stages and (type(stage.next_stages) == "table") and (type(stage.next_stages[1]) ~= "table")) then
        return false, yl_api_nodestages.t("next_stages_member_no_table")
    end

    if (stage.duration and (type(stage.duration) ~= "number")) then
        return false, yl_api_nodestages.t("duration_not_number")
    end
    if (stage.duration and (stage.duration < 0)) then
        return false, yl_api_nodestages.t("duration_not_positive_number")
    end

    if (stage.tiles and (type(stage.tiles) ~= "table")) then
        return false, yl_api_nodestages.t("tiles_not_table")
    end
    if (stage.description and (type(stage.description) ~= "string")) then
        return false, yl_api_nodestages.t("description_not_string")
    end

    if (stage.node_definition and (type(stage.node_definition) ~= "table")) then
        return false, yl_api_nodestages.t("node_definition_not_table")
    end

    if (stage.overwrite and (type(stage.overwrite) ~= "boolean")) then
        return false, yl_api_nodestages.t("overwrite_not_boolean")
    end

    if (stage._previous and (type(stage._previous) ~= "table")) then
        return false, yl_api_nodestages.t("_previous_not_table")
    end

    if (stage._version and
        (stage._version < yl_api_nodestages.datastructure_version)) then
        return false, yl_api_nodestages.t("version_outdated")
    end

    return true, yl_api_nodestages.t("all_good")
end

function yl_api_nodestages.is_valid_stage(stage) return is_valid_stage(stage) end

function yl_api_nodestages.is_valid(stages)

    local good, bad, total = 0, 0, 0
    local reasons = {}

    for _, stage in ipairs(stages) do
        total = total + 1
        local success, message = is_valid_stage(stage)
        if (success == true) then
            good = good + 1
        else
            bad = bad + 1
            table.insert(reasons, message)
        end
    end

    if (bad == 0) then
        minetest.log("action",
                     "[MOD] yl_api_nodestages : bad = " .. tostring(bad) ..
                         ", good = " .. tostring(good) .. ", total = " ..
                         tostring(total))
        return true, good, bad, total, reasons
    else
        minetest.log("warning",
                     "[MOD] yl_api_nodestages : bad = " .. tostring(bad) ..
                         ", good = " .. tostring(good) .. ", total = " ..
                         tostring(total))
        return false, good, bad, total, reasons
    end
end

function yl_api_nodestages.validate_all_stages()
    local stages = {}
    for _, def in pairs(minetest.registered_nodes) do
        local stage = def._stage
        table.insert(stages, stage)
    end
    return yl_api_nodestages.is_valid(stages)
end
