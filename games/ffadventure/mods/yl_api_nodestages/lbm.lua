if yl_api_nodestages.settings.run_lbm ~= true then
    return false
end

local function action(pos, node, dtime_s)
    return yl_api_nodestages.lbm_action(pos, node, dtime_s)
end

local def = {
    label = "Nodetimer Restart",
    -- Descriptive label for profiling purposes (optional).
    -- Definitions with identical labels will be listed as one.

    name = "yl_api_nodestages:nodetimer_restart",
    -- Identifier of the LBM, should follow the modname:<whatever> convention

    nodenames = yl_api_nodestages.lbm_nodenames,
    -- List of node names to trigger the LBM on.
    -- Names of non-registered nodes and groups (as group:groupname)
    -- will work as well.

    run_at_every_load = true,
    -- Whether to run the LBM's action every time a block gets activated,
    -- and not only the first time the block gets activated after the LBM
    -- was introduced.

    action = action,
    -- Function triggered for each qualifying node.
    -- `dtime_s` is the in-game time (in seconds) elapsed since the block
    -- was last active
}

minetest.register_lbm(def)
