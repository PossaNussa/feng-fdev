-- This file supplies jungle grass for the plantlife modpack

local spawn_delay = 2000 -- 2000
local spawn_chance = 100 -- 100
local grow_delay = 1000 -- 1000
local grow_chance = 10 -- 10

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
	groups = { snappy = 3, flammable=2, junglegrass=1 },
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
	groups = { snappy = 3, flammable=2, junglegrass=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',
	selection_box = {
		type = "fixed",
		fixed = {-0.4, -0.5, -0.4, 0.4, 0.3, 0.4},
	},
})

minetest.register_node(':junglegrass:shortest', {
	description = "Jungle Grass (very short)",
	drawtype = 'plantlike',
	tiles = { 'junglegrass_shortest.png' },
	inventory_image = 'junglegrass_shortest.png',
	wield_image = 'junglegrass_shortest.png',
	sunlight_propagates = true,
	paramtype = 'light',
	walkable = false,
	groups = { snappy = 3, flammable=2, junglegrass=1 },
	sounds = default.node_sound_leaves_defaults(),
	drop = 'default:junglegrass',
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
    decoration = "junglegrass:shortest",
})


-- 1) Hide/block player placement of default:junglegrass
minetest.after(0, function()
  local def = minetest.registered_nodes["default:junglegrass"] or {}
  local g = def.groups and table.copy and table.copy(def.groups) or {}
  g.not_in_creative_inventory = 1
  minetest.override_item("default:junglegrass", {
    groups = g,
    -- Do nothing on place (prevents manual placement)
    on_place = function(itemstack, placer, pt) return itemstack end,
  })
end)

-- 2) New terrain: replace any default mapgen junglegrass as chunks generate
minetest.register_on_generated(function(minp, maxp)
  local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
  local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
  local data = vm:get_data()
  local c_def  = minetest.get_content_id("default:junglegrass")
  local c_new  = minetest.get_content_id("junglegrass:shortest") -- start at your shortest
  local changed = false

  for i in area:iter(minp.x, minp.y, minp.z, maxp.x, maxp.y, maxp.z) do
    if data[i] == c_def then
      data[i] = c_new
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
  name = "junglegrass:replace_default_in_old_mapblocks",
  nodenames = {"default:junglegrass"},
  run_at_every_load = false,  -- convert once; then allow your ABM to grow to default:junglegrass if desired
  action = function(pos, node)
    minetest.swap_node(pos, {name = "junglegrass:shortest"})
  end,
})

