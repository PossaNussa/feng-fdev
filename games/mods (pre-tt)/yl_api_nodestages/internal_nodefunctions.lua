local function remove_timer(pos)
    local t = minetest.get_node_timer(pos)
    t:stop()
end

function yl_api_nodestages.remove_timer(pos) return remove_timer(pos) end

-- function yl_api_nodestages.on_destruct(pos) return remove_timer(pos) end

local function on_construct(pos)
    local node = minetest.get_node(pos)
    local nodename = node.name
    local stage = minetest.registered_nodes[nodename]._stage
    local duration = stage.duration or 0

    if (duration > 0) then
        local current_duration = duration
        local t = minetest.get_node_timer(pos)
        t:start(current_duration)
    end
end

function yl_api_nodestages.on_construct(pos) return on_construct(pos) end

local function get_target_nodename(node, pos, next_stages)
    local sum = 0
    for _, stage_chance in pairs(next_stages) do sum = sum + (stage_chance[2] or 1) end
    local dice = math.random(sum)
    for _, stage_chance in pairs(next_stages) do
        dice = dice - (stage_chance[2] or 1)
        if dice <= 0 then
            if (minetest.registered_nodes[stage_chance[1]] == nil) then
                minetest.log("warning",
                             yl_api_nodestages.t(
                                 "target_nodestage_does_not_exist",
                                 dump(stage_chance[1]), dump(node.name),
                                 dump(pos)))
                return nil
            elseif ((stage_chance[3] ~= nil) and
                (type(stage_chance[3].can_set) == "function") and
                (stage_chance[3].can_set(pos) == false)) then
                return node.name, {}
            else
                return stage_chance[1], stage_chance
            end
        end
    end

    -- should never return this
    return yl_api_nodestages.error
end

local function on_timer(pos, elapsed)

    local node = minetest.get_node(pos)

    local stage = minetest.registered_nodes[node.name]._stage

    if ((stage == nil) or (stage.next_stages == nil) or (stage.duration == nil)) then
        yl_api_nodestages.remove_timer(pos)
        return
    end

    local target_nodename
    local target_nodeparams
    local next_stage
    local timer = 0
    local duration

    repeat
        duration = stage.duration
        timer = timer + duration
        target_nodename, next_stage = get_target_nodename(node, pos,
                                                          stage.next_stages)
        target_nodeparams = {
            param1 = next_stage[4] and next_stage[4].param1 or 0,
            param2 = next_stage[4] and next_stage[4].param2 or 0
        }

        if (target_nodename == yl_api_nodestages.error) then
            -- Thing kaputt, stop it.
            minetest.log("error", yl_api_nodestages.t("undefined_state_abort"))
            yl_api_nodestages.remove_timer(pos)
            return
        end

        if (target_nodename == nil) then
            -- Fallback to last known target_nodename
            target_nodename = stage.stage_name
            break
        else
            -- Last stage most often does not have a _stage
            stage = minetest.registered_nodes[target_nodename] and
                        minetest.registered_nodes[target_nodename]._stage or nil
        end
    until ((timer >= elapsed) or (stage == nil) or (stage.duration == 0) or
        (stage.duration == nil))

    if (node.name == target_nodename) then return true end

    minetest.set_node(pos, {
        name = target_nodename,
        param1 = target_nodeparams.param1,
        param2 = target_nodeparams.param2
    })

    local remaining = timer - elapsed
    if (stage and stage.duration and (remaining > 0)) then
        local nodetimer = minetest.get_node_timer(pos)
        nodetimer:set(stage.duration, remaining)
    end
end

function yl_api_nodestages.on_timer(pos, elapsed) return on_timer(pos, elapsed) end
