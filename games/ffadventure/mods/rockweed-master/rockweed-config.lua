---------------------------------------------------------------------
-- the best place to store settings without affecting the addon repo
-- is WORLDPATH/rockweed-config.lua
---------------------------------------------------------------------

---------------------------------------------------------------------
-- materials & properties
---------------------------------------------------------------------

rockweed.resolution = core.settings:get("rockweed_resolution") or 16
rockweed.strict_priv = core.settings:get("rockweed_strict_priv") or false
rockweed.node_groups = {snappy=2, oddly_breakable_by_hand=1}
rockweed.off_node_groups = {snappy=2, oddly_breakable_by_hand=1,
                            not_in_creative_inventory=1}

rockweed.seed_light = 6
rockweed.hemp_light = 10
rockweed.hemp_bright_light = 14

rockweed.toggle_sound_gain = 2

rockweed.default_trunk = "default:stone"
rockweed.n_trunk = {name = rockweed.default_trunk}

rockweed.rarity = 6 -- seed drop rarity

---------------------------------------------------------------------
-- glow hemp odds
---------------------------------------------------------------------

rockweed.hq_hemp_chance = 6
-- stars have anywhere between 6 and 8 hemp petals, but blockage
-- easily reduces this number by half. we want something like 2 lights
-- per star.
rockweed.star_hemp_percent = 28

---------------------------------------------------------------------
-- quantum walk
---------------------------------------------------------------------

-- going over the dim light cap one makes the seed pause. it is at
-- least rockweed.seed_light + 1 to cancel moonlight, which seems to
-- be 2, and yet it mysteriously brightens the seed. the seed itself
-- won't dare to grow into the node over this cap.
rockweed.light_cap = 7

-- going over the bright light cap kills the seed (turns it into hemp)
rockweed.bright_light_cap = 10

-- rockweed seed attempts to grow with
rockweed.abm_interval = 6
rockweed.abm_chance = 6

rockweed.qw_star_chance = 28
rockweed.qw_trunk_tries = 28
rockweed.tunnel_cap = 3

---------------------------------------------------------------------
-- 3d-copier
---------------------------------------------------------------------

rockweed.copier_chance = 28
-- if true, 3d-copier will dupe container contents
rockweed.copy_inventory = true


-- be careful with the following settings. the drawing functions are
-- brittle, and making these settings too high or too low may result
-- in unusual behavior. consult the corresponding patterns for
-- details.

---------------------------------------------------------------------
-- floor / ceiling
---------------------------------------------------------------------

rockweed.flat_mr = 6 -- max radius

---------------------------------------------------------------------
-- hanging floor
---------------------------------------------------------------------

rockweed.hanging_floor_mr = 6 -- max radius

---------------------------------------------------------------------
-- wall
---------------------------------------------------------------------

rockweed.wall_sh = 4 -- small height
rockweed.wall_sr = 5 -- small radius

---------------------------------------------------------------------
-- bridge
---------------------------------------------------------------------

rockweed.bridge_ml = 15 -- max length
rockweed.bridge_mr = 2 -- max radius

---------------------------------------------------------------------
-- antibomb
---------------------------------------------------------------------

rockweed.antibomb_sr = 2 -- small radius

---------------------------------------------------------------------
-- spire
---------------------------------------------------------------------

rockweed.spire_mh = 17 -- max height

---------------------------------------------------------------------
-- mushroom
---------------------------------------------------------------------

rockweed.mushroom_sh = 5 -- small height
rockweed.mushroom_sr = 2 -- small radius

---------------------------------------------------------------------
-- upward/downward and normal crystals
---------------------------------------------------------------------

rockweed.u_crystal_sr = 6 -- small radius
rockweed.crystal_sr = 6 -- small radius

---------------------------------------------------------------------
-- flexible wall
---------------------------------------------------------------------

rockweed.flex_wall_sr = 7 -- small radius
rockweed.flex_wall_myr = 3 -- max z radius for activation
rockweed.flex_wall_sh = 6 -- small height

---------------------------------------------------------------------
-- starburst
---------------------------------------------------------------------

rockweed.starburst_mr = 12 -- max radius
-- increase tries to get closer to max stars
rockweed.starburst_tries = 28
rockweed.starburst_max_stars = 6

---------------------------------------------------------------------
-- stair
---------------------------------------------------------------------

rockweed.stair_ml = 15 -- max length
