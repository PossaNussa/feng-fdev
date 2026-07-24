-- =========================================================================
-- Boulders mod — stone-type-aware variants
-- Uses same nearby-stone detection as cs_pebbles
-- =========================================================================

local function add_fall_damage(node, damage)
	if minetest.registered_nodes[node] then
		local group = minetest.registered_nodes[node].groups
		group.falling_node_damage = damage
		minetest.override_item(node, {groups = group})
	end
end

function default.node_sound_boulder_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_cracky", gain = 0.35}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	table.place = table.place or
			{name = "falling_boulder", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

-- =========================================================================
-- Stone types (same list as cs_pebbles)
-- =========================================================================
local stone_types = {
	{name = "stone",     texture = "default_stone.png",     node = "default:stone"},
	{name = "limestone", texture = "default_limestone.png",  node = "default:limestone"},
	{name = "sandstone", texture = "default_sandstone.png",  node = "default:sandstone"},
	{name = "schist",    texture = "default_schist.png",     node = "default:schist"},
	{name = "shale",     texture = "default_shale.png",      node = "default:shale"},
	{name = "slate",     texture = "default_slate.png",      node = "default:slate"},
	{name = "granite",   texture = "default_granite.png",    node = "default:granite"},
	{name = "gneiss",    texture = "default_gneiss.png",     node = "default:gneiss"},
	{name = "quartz",    texture = "quartz.png",             node = "default:quartz"},
	{name = "marble",    texture = "default_marble.png",     node = "default:marble"},
	{name = "onyx",      texture = "onyx.png",               node = "default:onyx"},
	{name = "pumice",    texture = "nc_igneous_pumice.png",  node = "default:pumice"},
	{name = "basalt",    texture = "default_obsidian.png",   node = "default:basalt"},
	{name = "obsidian",  texture = "default_obsidian.png",   node = "default:obsidian"},
}

-- Lookup tables
local stone_to_boulder = {}   -- stone node name -> boulder node name
local stone_node_list = {}    -- list of stone node names for find_node_near
local all_boulder_names = {}  -- all boulder variant names (for tumble_off_of, touch, groups)
local boulder_group = {}      -- set of all boulder names for quick lookup

-- =========================================================================
-- Nearby stone detection (same pattern as cs_pebbles)
-- =========================================================================
local function get_typed_boulder(pos)
	local found_pos = minetest.find_node_near(pos, 30, stone_node_list)
	if found_pos then
		local node = minetest.get_node(found_pos)
		if stone_to_boulder[node.name] then
			return stone_to_boulder[node.name]
		end
	end
	return "boulders:stone_boulder"  -- fallback
end

-- =========================================================================
-- Tumbling and rolling (preserved from original)
-- =========================================================================
local function node_buildable_to(node)
	local node_def = minetest.registered_nodes[node.name]
	if node_def and node_def.buildable_to == true then
		return true
	else
		return false
	end
end

local function check_for_tumbling(pos, node_name, tumble_off_of, sound_name)
	local x_start = -1
	local x_end = 1
	local z_start = -1
	local z_end = 1

	for dx = x_start, x_end do
		for dy = 0, 0 do
			for dz = z_start, z_end do
				local node_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				local node = minetest.get_node(node_pos)
				local under_node_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z}
				local node_under_boulder = minetest.get_node(under_node_pos)

				if boulder_group[node.name] then
					local match_found = false
					for _, value in ipairs(tumble_off_of) do
						if node_under_boulder.name == value then
							match_found = true
							break
						end
					end
					-- Also tumble off any boulder
					if not match_found and boulder_group[node_under_boulder.name] then
						match_found = true
					end
					if match_found then
						local x_neg_pos = {x = node_pos.x - 1, y = node_pos.y - 1, z = node_pos.z}
						local x_neg_node = minetest.get_node(x_neg_pos)
						local x_pos_pos = {x = node_pos.x + 1, y = node_pos.y - 1, z = node_pos.z}
						local x_pos_node = minetest.get_node(x_pos_pos)
						local z_neg_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z - 1}
						local z_neg_node = minetest.get_node(z_neg_pos)
						local z_pos_pos = {x = node_pos.x, y = node_pos.y - 1, z = node_pos.z + 1}
						local z_pos_node = minetest.get_node(z_pos_pos)
						local above_x_neg_node = minetest.get_node({x = node_pos.x - 1, y = node_pos.y, z = node_pos.z})
						local above_x_pos_node = minetest.get_node({x = node_pos.x + 1, y = node_pos.y, z = node_pos.z})
						local above_z_neg_node = minetest.get_node({x = node_pos.x, y = node_pos.y, z = node_pos.z - 1})
						local above_z_pos_node = minetest.get_node({x = node_pos.x, y = node_pos.y, z = node_pos.z + 1})
						local x_neg_buildable = node_buildable_to(x_neg_node)
						local x_pos_buildable = node_buildable_to(x_pos_node)
						local z_neg_buildable = node_buildable_to(z_neg_node)
						local z_pos_buildable = node_buildable_to(z_pos_node)
						local start_tumble_pos = nil
						local boulder_tumbled = false

						local conditions = {
							{(x_neg_node.name == "air" or x_neg_buildable) and above_x_neg_node.name == "air", function()
								minetest.set_node(node_pos, {name = "air", param2 = node.param2})
								start_tumble_pos = {x = node_pos.x - 1, y = node_pos.y, z = node_pos.z}
								minetest.set_node(start_tumble_pos, {name = node.name, param2 = node.param2})
								boulder_tumbled = true
							end},
							{(x_pos_node.name == "air" or x_pos_buildable) and above_x_pos_node.name == "air", function()
								minetest.set_node(node_pos, {name = "air", param2 = node.param2})
								start_tumble_pos = {x = node_pos.x + 1, y = node_pos.y, z = node_pos.z}
								minetest.set_node(start_tumble_pos, {name = node.name, param2 = node.param2})
								boulder_tumbled = true
							end},
							{(z_neg_node.name == "air" or z_neg_buildable) and above_z_neg_node.name == "air", function()
								minetest.set_node(node_pos, {name = "air", param2 = node.param2})
								start_tumble_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z - 1}
								minetest.set_node(start_tumble_pos, {name = node.name, param2 = node.param2})
								boulder_tumbled = true
							end},
							{(z_pos_node.name == "air" or z_pos_buildable) and above_z_pos_node.name == "air", function()
								minetest.set_node(node_pos, {name = "air", param2 = node.param2})
								start_tumble_pos = {x = node_pos.x, y = node_pos.y, z = node_pos.z + 1}
								minetest.set_node(start_tumble_pos, {name = node.name, param2 = node.param2})
								boulder_tumbled = true
							end},
						}

						-- Shuffle for random tumble direction
						for i = #conditions, 2, -1 do
							local j = math.random(i)
							conditions[i], conditions[j] = conditions[j], conditions[i]
						end

						for _, condition in ipairs(conditions) do
							if condition[1] then
								condition[2]()
								break
							end
						end

						if boulder_tumbled then
							minetest.sound_play(sound_name, {pos = pos, gain = 0.5, max_hear_distance = 10})
							minetest.check_for_falling(start_tumble_pos)
						end
					end
				end
			end
		end
	end
end

-- =========================================================================
-- Boulder rolling (player push)
-- =========================================================================
local function boulderTouchAction(player)
	local pos = player:get_pos()
	local x_offset, z_offset = get_direction_offsets(player)

	local boulder_rolled = false
	local boulder_new_pos = nil

	for dx = x_offset, x_offset do
		for dy = 0, 0 do
			for dz = z_offset, z_offset do
				local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
				boulder_new_pos = {x = pos.x + dx + dx, y = pos.y + dy, z = pos.z + dz + dz}
				local node = minetest.get_node(neighbor_pos)
				local boulder_new_pos_node = minetest.get_node(boulder_new_pos)

				if boulder_group[node.name] and boulder_new_pos_node.name == "air" then
					minetest.set_node(neighbor_pos, {name = "air", param2 = node.param2})
					minetest.set_node(boulder_new_pos, {name = node.name, param2 = node.param2})
					boulder_rolled = true
				end
			end
		end
	end
	if boulder_rolled then
		minetest.sound_play("falling_boulder", {pos = pos, gain = 0.5, max_hear_distance = 10})
		for dx = x_offset, x_offset do
			for dy = -1, 2 do
				for dz = z_offset, z_offset do
					local neighbor_pos = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
					minetest.check_for_falling(neighbor_pos)
				end
			end
		end
	end
end

-- =========================================================================
-- Register boulder variants
-- =========================================================================
local boulder_shape = minetest.settings:get("boulder_shape") or "default"
local use_mesh = (boulder_shape ~= "block")

local wherein_boulders = {"default:stone", "default:dirt", "default:dry_dirt"}

local boulder_cluster_scarcity
if minetest.get_modpath("boulder_dig") then
	boulder_cluster_scarcity = 7 * 7 * 7
else
	boulder_cluster_scarcity = 9 * 9 * 9
end

for _, stone in ipairs(stone_types) do
	-- Only register if the stone node exists
	if minetest.registered_nodes[stone.node] then
		local boulder_name = "boulders:" .. stone.name .. "_boulder"

		stone_to_boulder[stone.node] = boulder_name
		stone_node_list[#stone_node_list + 1] = stone.node
		all_boulder_names[#all_boulder_names + 1] = boulder_name
		boulder_group[boulder_name] = true

		local def = {
			description = stone.name:gsub("^%l", string.upper) .. " Boulder",
			groups = {cracky = 2, falling_node = 1, falling_node_hurt = 1, boulder = 1},
			sounds = default.node_sound_boulder_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {boulder_name}}
				}
			},
			on_construct = function(pos)
				check_for_tumbling(pos, boulder_name, all_boulder_names, "falling_boulder")
			end,
		}

		if use_mesh then
			def.drawtype = "mesh"
			def.mesh = "boulder.obj"
			def.tiles = {stone.texture}
		else
			def.tiles = {stone.texture}
		end

		minetest.register_node(boulder_name, def)
		add_fall_damage(boulder_name, 4)
	end
end

-- Keep the old generic boulder as an alias to stone_boulder for compat
boulder_group["boulders:boulder"] = true

-- Register generic boulder as placeholder (scatter ore target)
minetest.register_node("boulders:boulder", {
	description = "Boulder",
	drawtype = use_mesh and "mesh" or nil,
	mesh = use_mesh and "boulder.obj" or nil,
	tiles = {use_mesh and "default_stone.png" or "boulder.png"},
	groups = {cracky = 2, falling_node = 1, falling_node_hurt = 1, boulder = 1,
	          not_in_creative_inventory = 1},
	sounds = default.node_sound_boulder_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {"boulders:stone_boulder"}}
		}
	},
	on_construct = function(pos)
		check_for_tumbling(pos, "boulders:boulder", all_boulder_names, "falling_boulder")
	end,
})
add_fall_damage("boulders:boulder", 4)

-- Ore registration: spawns generic boulders, converted by LBM
minetest.register_ore({
	ore_type = "scatter",
	ore = "boulders:boulder",
	wherein = wherein_boulders,
	clust_scarcity = boulder_cluster_scarcity,
	clust_num_ores = 7,
	clust_size = 4,
	height_min = -31000,
	height_max = 10000,
})

-- =========================================================================
-- Crafting (uses stone_boulder as the default craft result)
-- =========================================================================
minetest.register_craft({
	output = "default:stone 4",
	recipe = {
		{"group:boulder", "group:boulder"},
		{"group:boulder", "group:boulder"},
	}
})

minetest.register_craft({
	output = "boulders:stone_boulder 5",
	recipe = {
		{"", "default:stone", ""},
		{"default:stone", "default:stone", "default:stone"},
		{"", "default:stone", ""},
	}
})

-- =========================================================================
-- LBM: Convert generic boulders to typed variants based on nearby stone
-- =========================================================================
minetest.register_lbm({
	label = "Convert boulders to stone-typed variants",
	name = "boulders:type_boulders_v1",
	nodenames = {"boulders:boulder"},
	run_at_every_load = true,
	action = function(pos, node)
		local typed = get_typed_boulder(pos)
		minetest.swap_node(pos, {name = typed, param2 = node.param2})
	end,
})

-- =========================================================================
-- Register touch action for all boulder variants
-- =========================================================================
if minetest.global_exists("registerNodeTouchAction") then
	for _, bname in ipairs(all_boulder_names) do
		registerNodeTouchAction(bname, boulderTouchAction)
	end
	registerNodeTouchAction("boulders:boulder", boulderTouchAction)
end
