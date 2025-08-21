--[[ Performance test
local bucket = 0
local numz = 0

local function gs(dtime)
    if bucket > 0 then
        minetest.log("action",
                 "dtime =" .. dump(dtime) .. ", bucket= " .. dump(bucket) ..
                     ", numz=" .. dump(numz) .. ", avg=" .. dump(bucket / numz))
    end
    bucket = 0
    numz = 0
end

core.register_globalstep(gs)

-- on_timer

local function on_timer(pos, elapsed)

    local t1 = core.get_us_time()
    numz = numz + 1

    local node = minetest.get_node(pos)

    local stage = minetest.registered_nodes[node.name]._stage
    local target_nodename
    local timer = 0
    local duration

    if (stage == nil) or (stage.next_stages == nil) then
        yl_api_nodestages.remove_timer(pos)
        bucket = bucket + (core.get_us_time() - t1)
        return
    end

    repeat
        duration = stage.duration
        timer = timer + duration
        target_nodename = get_target_nodename(node, pos, stage.next_stages)

        if (target_nodename == yl_api_nodestages.error) then
            -- Thing kaputt, stop it.
            minetest.log("error", yl_api_nodestages.t("undefined_state_abort"))
            yl_api_nodestages.remove_timer(pos)
            bucket = bucket + (core.get_us_time() - t1)
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
    until ((timer >= elapsed) or (stage == nil) or (stage.duration == 0))

    if (node.name == target_nodename) then
        bucket = bucket + (core.get_us_time() - t1)
        return true
    end

    minetest.set_node(pos, {name = target_nodename})

    local remaining = timer - elapsed
    if (stage and stage.duration and (remaining > 0)) then
        local nodetimer = minetest.get_node_timer(pos)
        nodetimer:set(stage.duration, remaining)
    end
    bucket = bucket + (core.get_us_time() - t1)
end

]]--