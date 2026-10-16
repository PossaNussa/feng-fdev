-- This file supplies jungle grass for the plantlife modpack

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 300 -- 300
local grow_chance = 3 -- 3

local grasses_list = {
        {"junglegrass:shortest","junglegrass:short" },
        {"junglegrass:short"   ,"junglegrass:medium" },
        {"junglegrass:medium"  ,"default:junglegrass" },
        {"default:junglegrass" , nil}
}

minetest.register_node(':junglegrass:medium', {
	description = "Jungle Grass (medium height)",
	drawtype = 'plantlike',
	tiles = { 'junglegrass_medium.png' },
	inventory_image = 'junglegrass_medium.png',
	wield_image = 'junglegrass_medium.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1, attached_node = 1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',

	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
	},
})

minetest.register_node(':junglegrass:short', {
	description = "Jungle Grass (short)",
	drawtype = 'plantlike',
	tiles = { 'junglegrass_short.png' },
	inventory_image = 'junglegrass_short.png',
	wield_image = 'junglegrass_short.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1, attached_node = 1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',
	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.3, 0.4},
	},
})

minetest.register_node(':junglegrass:shortest', {
	description = "Jungle Grass",
	drawtype = 'plantlike',
	tiles = { 'junglegrass_shortest.png' },
	inventory_image = 'junglegrass_shortest.png',
	wield_image = 'junglegrass_shortest.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1, attached_node = 1 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3},
	},
})

-- ABM for growing jungle grass
minetest.register_abm({
    label = "Grow jungle grass",
    nodenames = {"junglegrass:shortest", "junglegrass:short", "junglegrass:medium"},
    neighbors = {"default:dirt_with_rainforest_litter", "default:dirt_with_grass", "default:sand", "default:desert_sand"},
    interval = grow_delay,
    chance = grow_chance,
    action = function(pos, node)
        for _,grass in ipairs(grasses_list) do
            if node.name == grass[1] and grass[2] ~= nil then
                minetest.set_node(pos, {name = grass[2]})
                break
            end
        end
    end,
})

-- Decoration for spawning jungle grass
minetest.register_decoration({
    name = "Spawn junglegrass",
    deco_type = "simple",
    place_on = {"default:dirt_with_rainforest_litter"},
    sidelen = 80,
    fill_ratio = 0.1,
    biomes = {"rainforest"},
    y_max = 31000,
    y_min = 1,
    -- Seed as the tall/default form; the on_generated pass below rerolls every
    -- default:junglegrass into a random stage, so this feeds the same randomiser
    -- as the default mapgen's own junglegrass decoration.
    decoration = "default:junglegrass",
})

-- Weighted starting stages, so newly generated / converted junglegrass has a
-- natural spread of heights instead of every plant being pinned to the smallest
-- form. Tuned toward the taller end so a rainforest reads as mature. The grow
-- ABM still nudges the shorter forms upward in blocks near the player.
local stage_names = {
  "junglegrass:shortest",  -- 15%
  "junglegrass:short",     -- 25%
  "junglegrass:medium",    -- 30%
  "default:junglegrass",   -- 30% (tall / final)
}
local function pick_stage_name()
  local r = math.random(100)
  if r <= 15 then return stage_names[1]
  elseif r <= 40 then return stage_names[2]
  elseif r <= 70 then return stage_names[3]
  else return stage_names[4] end
end


-- Hide default:junglegrass from creative inventory (players collect junglegrass:shortest instead)
minetest.after(0, function()
  local def = minetest.registered_nodes["default:junglegrass"] or {}
  local g = def.groups and table.copy and table.copy(def.groups) or {}
  g.not_in_creative_inventory = 1
  minetest.override_item("default:junglegrass", {
    groups = g,
    drop = "junglegrass:shortest",
  })
end)

-- 2) New terrain: reroll any default mapgen junglegrass into a random stage as
--    chunks generate, giving a natural spread of heights.
local c_stage = {}
minetest.register_on_generated(function(minp, maxp)
  local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
  local data = vm:get_data()
  local c_def = minetest.get_content_id("default:junglegrass")
  -- Cache the content ids for each weighted stage on first run.
  if not c_stage[1] then
    for idx, name in ipairs(stage_names) do
      c_stage[idx] = minetest.get_content_id(name)
    end
  end
  local changed = false

  for i in area:iter(minp.x, minp.y, minp.z, maxp.x, maxp.y, maxp.z) do
    if data[i] == c_def then
      local r = math.random(100)
      if r <= 15 then data[i] = c_stage[1]
      elseif r <= 40 then data[i] = c_stage[2]
      elseif r <= 70 then data[i] = c_stage[3]
      else data[i] = c_stage[4] end
      changed = true
    end
  end

  if changed then
    vm:set_data(data)
    vm:write_to_map(false)
  end
end)

-- 3) Existing worlds: one-time conversion of any old/default junglegrass
minetest.register_lbm({
  name = "junglegrass:reroll_stages_in_old_mapblocks",
  nodenames = {"default:junglegrass"},
  run_at_every_load = false,  -- reroll once; the ABM then grows shorter forms over time
  action = function(pos, node)
    local name = pick_stage_name()
    -- Only touch the map if the roll actually changes the node.
    if name ~= node.name then
      minetest.swap_node(pos, {name = name})
    end
  end,
})

