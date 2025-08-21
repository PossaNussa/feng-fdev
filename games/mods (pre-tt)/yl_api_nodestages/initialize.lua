local function run_each_serverstart()
    yl_api_nodestages.lbm_nodenames = {}
    minetest.after(0.0, yl_api_nodestages.validate_all_stages)
end

run_each_serverstart()
