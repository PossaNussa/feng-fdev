core.register_node(
   "rockweed:seed",
   { tiles = {"rockweed_seed_" .. rockweed.resolution .. ".png"},
     sounds = default.node_sound_leaves_defaults(),
     description = "Rockweed seed",
     groups = rockweed.node_groups,
     paramtype = "light",
     sunlight_propagates = true,
     light_source = rockweed.seed_light,
     after_place_node = function(pos, placer)
        local player_name = placer:get_player_name()
        local tier1 = not rockweed.strict_priv
           or core.check_player_privs(player_name, {rockweed=true})
        local tier2 = core.check_player_privs(player_name, {rockweed3d=true})
        local tier3 = core.check_player_privs(player_name, {rockweed3dmeta=true})
        if tier1 or tier2 or tier3 then
           local n_seed = core.get_node(pos)
           n_seed.param2 = rockweed.dormant
           if tier2 or tier3 then
              n_seed.param2 = rockweed.arm3d
              if tier3 then
                 n_seed.param2 = rockweed.arm3d + 1
              end
           end
           core.add_node(pos, n_seed)
        else
           core.add_node(pos, {name = "rockweed:glow_hemp"})
           return
        end
     end,
   }
)

core.register_node(
   "rockweed:glow_hemp",
   { tiles = {"glow_hemp_" .. rockweed.resolution .. ".png"},
     sounds = default.node_sound_glass_defaults(),
     description = "Glowing hemp",
     groups = rockweed.node_groups,
     paramtype = "light",
     sunlight_propagates = true,
     light_source = rockweed.hemp_light,
     drop = {
        max_items = 1,
        items = {
           {
              -- player will get seed with 1/rarity chance
              items = {'rockweed:seed'},
              rarity = rockweed.rarity,
           },
           {
              -- player will get hemp only if he get no seeds,
              -- this is because max_items is 1
              items = {'rockweed:glow_hemp'},
           }
        }
     },
     on_rightclick = function(pos, node)
        core.add_node(pos, {name = "rockweed:glow_hemp_off"})
        core.sound_play("default_hard_footstep",
                            {pos = pos, gain = rockweed.toggle_sound_gain,
                             max_hear_distance = 32,})
        rockweed.fix_light(pos, 3)
     end,
   }
)

core.register_node(
   "rockweed:glow_hemp_off",
   { tiles = {"glow_hemp_alpha_" .. rockweed.resolution .. ".png"},
     sounds = default.node_sound_glass_defaults(),
     description = "Glowing hemp (off)",
     groups = rockweed.off_node_groups,
     drawtype = "glasslike",
     paramtype = "light",
     sunlight_propagates = true,
     light_source = rockweed.seed_light,
     use_texture_alpha = "blend",
     drop = {
        max_items = 1,
        items = {
           {
              -- player will get seed with 1/rarity chance
              items = {'rockweed:seed'},
              rarity = rockweed.rarity,
           },
           {
              -- player will get hemp only if he get no seeds,
              -- this is because max_items is 1
              items = {'rockweed:glow_hemp'},
           }
        }
     },
     on_rightclick = function(pos, node)
        core.add_node(pos, {name = "rockweed:glow_hemp"})
        core.sound_play("default_glass_footstep",
                            {pos = pos, gain = rockweed.toggle_sound_gain,
                             max_hear_distance = 32,})
        rockweed.fix_light(pos, 3)
     end,
   }
)

core.register_craft({
	output = 'rockweed:seed',
	recipe = {
           {'blox:glowstone', 'farming:seed_hemp', 'blox:glowstone'},
           {'farming:seed_hemp', 'farming:seed_hemp', 'farming:seed_hemp'},
           {'blox:glowstone', 'farming:seed_hemp', 'blox:glowstone'},
	}
})

core.register_craft({
	output = 'rockweed:seed',
	recipe = {
		{'default:mese_block', 'group:sapling', 'default:mese_block'},
		{'group:sapling', 'group:sapling', 'group:sapling'},
		{'default:mese_block', 'group:sapling', 'default:mese_block'},
	}
})

core.register_node(
   "rockweed:hq_hemp",
   { tiles = {"hq_hemp_" .. rockweed.resolution .. ".png"},
     sounds = default.node_sound_glass_defaults(),
     description = "Sparkling hemp",
     groups = rockweed.node_groups,
     paramtype = "light",
     sunlight_propagates = true,
     light_source = rockweed.hemp_bright_light,
     drop = {
        max_items = 1,
        items = {
           {
              items = {'rockweed:hq_hemp'},
              rarity = 1,
           },
        }
     },
     on_rightclick = function(pos, node)
        core.add_node(pos, {name = "rockweed:hq_hemp_off"})
        core.sound_play("default_hard_footstep",
                            {pos = pos, gain = rockweed.toggle_sound_gain,
                             max_hear_distance = 32,})
        rockweed.fix_light(pos, 3)
     end,
   }
)

core.register_node(
   "rockweed:hq_hemp_off",
   { tiles = {"hq_hemp_alpha_" .. rockweed.resolution .. ".png"},
     sounds = default.node_sound_glass_defaults(),
     description = "Sparkling hemp (off)",
     groups = rockweed.off_node_groups,
     drawtype = "glasslike",
     paramtype = "light",
     sunlight_propagates = true,
     light_source = rockweed.seed_light,
     use_texture_alpha = "blend",
     drop = {
        max_items = 1,
        items = {
           {
              items = {'rockweed:hq_hemp'},
              rarity = 1,
           },
        }
     },
     on_rightclick = function(pos, node)
        core.add_node(pos, {name = "rockweed:hq_hemp"})
        core.sound_play("default_glass_footstep",
                            {pos = pos, gain = rockweed.toggle_sound_gain,
                             max_hear_distance = 32,})
        rockweed.fix_light(pos, 3)
     end,
   }
)

core.register_craft({
	output = 'rockweed:hq_hemp',
	recipe = {
           {'default:glass', 'rockweed:glow_hemp', 'default:glass'},
           {'rockweed:glow_hemp', 'rockweed:glow_hemp', 'rockweed:glow_hemp'},
           {'default:glass', 'rockweed:glow_hemp', 'default:glass'},
	}
})

core.register_craft({
	output = 'rockweed:glow_hemp',
	recipe = {{'rockweed:hq_hemp'}}
})
