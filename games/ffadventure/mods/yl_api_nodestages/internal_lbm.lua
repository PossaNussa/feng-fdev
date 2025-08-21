-- lbm_remove_from_restart
--

local function lbm_remove_from_restart(target)
    for i=#yl_api_nodestages.lbm_nodenames,1,-1 do
        if (yl_api_nodestages.lbm_nodenames[i] == target) then
            table.remove(yl_api_nodestages.lbm_nodenames, i)
            return true
        end
    end
    return false
end

function yl_api_nodestages.lbm_remove_from_restart(target)
    return lbm_remove_from_restart(target)
end

-- lbm_add_to_restart
--

local function lbm_add_to_restart(target)
    local found = false
    for _, nodename in ipairs(yl_api_nodestages.lbm_nodenames) do
        if (nodename == target) then
            found = true
        end
    end
    if (found == false) then
        table.insert(yl_api_nodestages.lbm_nodenames, target)
        return true
    end
    return false
end

function yl_api_nodestages.lbm_add_to_restart(target)
    return lbm_add_to_restart(target)
end

-- lbm_action
--

local function lbm_action(pos, node, _dtime_s)
    local t = minetest.get_node_timer(pos)
    if t:is_started() == false then
        local stage = minetest.registered_nodes[node.name]._stage
        if (stage and stage.duration and (type(stage.duration) == "number") and (stage.duration > 0)) then
            t:start(stage.duration)
        end
    end
end

function yl_api_nodestages.lbm_action(pos, node, dtime_s)
    return lbm_action(pos, node, dtime_s)
end