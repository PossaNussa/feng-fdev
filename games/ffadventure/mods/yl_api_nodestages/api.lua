-- get_stage
--
local function get_stage(modname, nodename)

    if (minetest.get_modpath(modname) == nil) then
        return false, yl_api_nodestages.t("modname_does_not_exist")
    end

    local def = minetest.registered_nodes[modname .. ":" .. nodename]

    if (def == nil) then
        return false, yl_api_nodestages.t("node_does_not_exist")
    end

    local stage = def._stage

    if (stage == nil) then
        return false, yl_api_nodestages.t("node_does_not_have_stage")
    end

    if (type(stage) ~= "table") then
        return false, yl_api_nodestages.t("stage_not_table")
    end

    if (yl_api_nodestages.is_valid_stage(stage) == false) then
        return false, yl_api_nodestages.t("stage_not_valid")
    end

    return true, stage

end

function yl_api_nodestages.get_stage(modname, nodename)
    return get_stage(modname, nodename)
end

-- create_stage
--

local function create_stagenode(p_stage)

    -- variable stage may be string errormessage or table stage
    local success, stage = yl_api_nodestages.get_valid_copy_of_stage(p_stage)

    if success == false then return false, stage end

    -- MT properties
    local nodename = stage.stage_name
    local node_definition = stage.node_definition
    node_definition.description = stage.description
    node_definition.tiles = stage.tiles

    minetest.register_node(":" .. nodename, node_definition)

    if (minetest.registered_nodes[nodename] == nil) then
        return false, yl_api_nodestages.t("node_not_created")
    end

    return true
end

function yl_api_nodestages.create_stagenode(stage) return
    create_stagenode(stage) end

-- add_stage
--

local function add_stage(p_stage)

    -- variable stage may be string errormessage or table stage
    local success, stage = yl_api_nodestages.get_valid_copy_of_stage(p_stage)

    if success == false then return false, stage end

    local nodename = stage.stage_name

    if (stage.overwrite == true) then
        return false, yl_api_nodestages.t("error_use_overwrite_instead",
                                          dump(nodename))
    end

    local target_def = {}

    if (target_def == nil) then
        return false,
               yl_api_nodestages.t("error_item_not_exists", dump(nodename))
    end

    if (target_def.on_timer ~= nil) then
        return false,
               yl_api_nodestages.t("error_item_has_timer", dump(nodename))
    end

    if (target_def.on_construct ~= nil) then
        return false,
               yl_api_nodestages.t("error_item_has_construct", dump(nodename))
    end

    if (target_def._stage ~= nil) then
        return false,
               yl_api_nodestages.t("error_item_has_stage", dump(nodename))
    end

    -- next_stage may be a string, convert to table
    if (type(stage.next_stages) == "string") then
        stage.next_stages = {{stage.next_stages, 1}}
    end

    -- next_stage may be incomplete
    for _, next_stage in ipairs(stage.next_stages or {}) do
        if (type(next_stage[1]) ~= "string") then
            return false, yl_api_nodestages.t("error_nextstage_not_string", dump(nodename))
        end
        if (type(next_stage[2]) ~= "number") then
            next_stage[2] = 1
        end
    end

    -- Add to lbm_nodenames
    if ((stage.restart == true) or (stage.restart == nil)) then
        yl_api_nodestages.lbm_add_to_restart(stage.stage_name)
    end

    target_def._stage = stage
    target_def.on_timer = yl_api_nodestages.on_timer
    target_def.on_construct = yl_api_nodestages.on_construct
    -- Do we really need a destruct? If we do, shouldn't we check for it?
    -- No, we don't, at least for now
    -- target_def.on_destruct = yl_api_nodestages.on_destruct

    minetest.override_item(nodename, target_def)

    if (minetest.registered_nodes[nodename]._stage == nil) then
        return false, yl_api_nodestages.t("stage_not_created")
    end

    return true
end

function yl_api_nodestages.add_stage(stage) return add_stage(stage) end

-- overwrite_stage
--

local function overwrite_stage(p_stage)

    -- variable stage may be string errormessage or table stage
    local success, stage = yl_api_nodestages.get_valid_copy_of_stage(p_stage)

    if success == false then return false, stage end

    local nodename = stage.stage_name

    if (stage.overwrite ~= true) then
        return false,
               yl_api_nodestages.t("error_use_add_instead", dump(nodename))
    end

    local target_def = {}

    if (target_def == nil) then
        return false,
               yl_api_nodestages.t("error_item_not_exists", dump(nodename))
    end

    --[[ Since this is the overwrite, we deliberately do not check for existing nodetimers, construct or stages
    if (target_def.on_timer ~= nil) then
        return false, yl_api_nodestages.t("error_item_has_timer", dump(nodename))
    end

    if (target_def.on_construct ~= nil) then
        return false, yl_api_nodestages.t("error_item_has_construct", dump(nodename))
    end

    if (target_def._stage ~= nil) then
        return false, yl_api_nodestages.t("error_item_has_stage", dump(nodename))
    end
    ]] --

    -- Cache the values we are going to overwrite

    local previous = {}
    previous.on_timer = minetest.registered_nodes[nodename].on_timer
    previous.on_construct = minetest.registered_nodes[nodename].on_construct
    previous.on_destruct = minetest.registered_nodes[nodename].on_destruct
    previous.stage = minetest.registered_nodes[nodename]._stage

    -- next_stage may be a string, convert to table
    if (type(stage.next_stages) == "string") then
        stage.next_stages = {{stage.next_stages, 1}}
    end

    -- next_stage may be incomplete
    for _, next_stage in ipairs(stage.next_stages) do
        if (type(next_stage[1]) ~= "string") then
            return false, yl_api_nodestages.t("error_nextstage_not_string", dump(nodename))
        end
        if (type(next_stage[2]) ~= "number") then
            next_stage[2] = 1
        end
    end

    -- Remove from lbm_nodenames
    yl_api_nodestages.lbm_remove_from_restart(stage.stage_name)
    -- Add to lbm_nodenames
    if ((stage.restart == true) or (stage.restart == nil)) then
        yl_api_nodestages.lbm_add_to_restart(stage.stage_name)
    end

    -- Assign the new values

    target_def._stage = stage
    target_def._stage._previous = previous
    target_def.on_timer = yl_api_nodestages.on_timer
    target_def.on_construct = yl_api_nodestages.on_construct
    -- Do we really need a destruct? If we do, shouldn't we check for it?
    -- No, we don't, at least for now
    -- target_def.on_destruct = yl_api_nodestages.on_destruct

    minetest.override_item(nodename, target_def)

    if (minetest.registered_nodes[nodename]._stage == nil) then
        return false, yl_api_nodestages.t("stage_not_created")
    end

    return true
end

function yl_api_nodestages.overwrite_stage(stage) return overwrite_stage(stage) end

-- rollback_stage
--

local function rollback_stage(modname, nodename)

    if (minetest.get_modpath(modname) == nil) then
        return false, yl_api_nodestages.t("modname_does_not_exist")
    end

    local def = minetest.registered_nodes[modname .. ":" .. nodename]

    if (def == nil) then
        return false, yl_api_nodestages.t("node_does_not_exist")
    end

    local stage = def._stage

    if (stage == nil) then
        return false, yl_api_nodestages.t("node_does_not_have_stage")
    end

    if (type(stage) ~= "table") then
        return false, yl_api_nodestages.t("stage_not_table")
    end

    local previous = def._stage._previous

    if (previous == nil) then
        def._stage = nil
        return true
    end

    if (type(previous) ~= "table") then
        return false, yl_api_nodestages.t("previous_not_table")
    end

    if (type(previous.stage) ~= "table") then
        return false, yl_api_nodestages.t("previous_stage_not_table")
    end

    -- Remove current from lbm_names
    yl_api_nodestages.lbm_remove_from_restart(modname .. ":" .. nodename)
    -- Add to lbm_nodenames
    if ((previous.stage.restart == true) or (previous.stage.restart == nil)) then
        yl_api_nodestages.lbm_add_to_restart(previous.stage.stage_name)
    end

    def._stage = previous.stage
    def.on_timer = previous.on_timer
    def.on_construct = previous.on_construct

    if (minetest.registered_nodes[modname .. ":" .. nodename]._stage == nil) then
        return false, yl_api_nodestages.t("stage_not_rolled_back")
    end

    return true
end

function yl_api_nodestages.rollback_stage(modname, nodename)
    return rollback_stage(modname, nodename)
end

-- delete_stage
--

local function delete_stage(modname, nodename)

    if (minetest.get_modpath(modname) == nil) then
        return false, yl_api_nodestages.t("modname_does_not_exist")
    end

    local def = minetest.registered_nodes[modname .. ":" .. nodename]

    if (def == nil) then
        return false, yl_api_nodestages.t("node_does_not_exist")
    end

    local stage = def._stage

    if (stage == nil) then
        return false, yl_api_nodestages.t("node_does_not_have_stage")
    end

    if (type(stage) ~= "table") then
        return false, yl_api_nodestages.t("stage_not_table")
    end

    -- Remove current from lbm_names
    yl_api_nodestages.lbm_remove_from_restart(modname .. ":" .. nodename)

    def._stage = nil
    def.on_timer = nil
    def.on_construct = nil
    -- Do we really need a destruct? If we do, shouldn't we check for it?
    -- No, we don't, at least for now
    -- def.on_destruct = nil

    if (minetest.registered_nodes[modname .. ":" .. nodename]._stage ~= nil) then
        return false, yl_api_nodestages.t("stage_not_deleted")
    end

    return true
end

function yl_api_nodestages.delete_stage(modname, nodename)
    return delete_stage(modname, nodename)
end

-- register_stage
--

local function register_stage(p_stage)

    -- variable stage may be string errormessage or table stage
    local success, stage = yl_api_nodestages.get_valid_copy_of_stage(p_stage)

    if (success == false) then return false, stage end

    -- Create the node
    local message
    success, message = yl_api_nodestages.create_stagenode(stage)

    if (success == false) then return false, message end

    -- Add or overwrite the stage
    if (stage.overwrite == true) then
        success, message = yl_api_nodestages.overwrite(stage)
    else
        success, message = yl_api_nodestages.add_stage(stage)
    end

    if (success == false) then return false, message end

    return true, nil
end

function yl_api_nodestages.register_stage(stage) return register_stage(stage) end

-- register_stages
--

local function register_stages(stages)

    local good, bad, total = 0, 0, 0
    local reasons = {}

    for _, stage in ipairs(stages) do
        total = total + 1
        local success, message = register_stage(stage)
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

function yl_api_nodestages.register_stages(stages) return
    register_stages(stages) end
