
-- Setting a configuration, switch the order in which the settings shall take precedence. First valid one taken.

yl_api_nodestages.settings = {}

yl_api_nodestages.settings.debug = minetest.settings:get_bool("yl_api_nodestages.debug", true)

yl_api_nodestages.settings.run_lbm = minetest.settings:get_bool("yl_api_nodestages.run_lbm", true)
