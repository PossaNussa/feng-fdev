-- tree_felling: Multi-stage tree chopping with sideways toppling

-- Section A: Standard tree list (facedir trunks)
-- Same as plank_splitting minus bush stems and bamboo
local standard_trees = {
	"default:tree",
	"default:jungletree",
	"default:pine_tree",
	"default:acacia_tree",
	"default:aspen_tree",
	"moretrees:spruce_trunk",
	"moretrees:cedar_trunk",
	"moretrees:poplar_trunk",
	"moretrees:rubber_tree_trunk",
	"moretrees:rubber_tree_trunk_empty",
	"variety:baobab_tree",
	"variety:cypress_tree",
	"variety:redwood_tree",
	"variety:cherry_tree",
	"variety:darkforest_tree",
	"variety:frost_land_tree",
	"variety:tropical_rainforest_tree",
	"variety:autumn_forest_tree",
	"maple:maple_tree",
	"oak:trunk",
	"cherrytree:trunk",
	"lemontree:trunk",
	"lemontree:trunk_nobark",
	"hollytree:trunk",
	"chestnuttree:trunk",
	"spruce_tree:spruce_tree",
	"larch:trunk",
	"sequoia:trunk",
	"paleotest:metasequoia_tree",
	-- swamp
	"swamp:mangrove_tree",
	-- naturalbiomes
	"naturalbiomes:olive_trunk",
	"naturalbiomes:acacia_trunk",
	"naturalbiomes:outback_trunk",
	"naturalbiomes:alder_trunk",
	"naturalbiomes:palm_trunk",
	"naturalbiomes:pine_trunk",
	"naturalbiomes:banana_trunk",
	"naturalbiomes:heath_birch_trunk",
	"naturalbiomes:heath_juniper_trunk",
	"naturalbiomes:heath_willow_trunk",
	-- livingdesert
	"livingdesert:date_palm_trunk",
	"livingdesert:pine_trunk",
	"livingdesert:saxaul_trunk",
	-- aotearoa
	"aotearoa:pohutukawa_tree",
	"aotearoa:kauri_tree",
	"aotearoa:karaka_tree",
	"aotearoa:rimu_tree",
	"aotearoa:totara_tree",
	"aotearoa:miro_tree",
	"aotearoa:kahikatea_tree",
	"aotearoa:tawa_tree",
	"aotearoa:black_beech_tree",
	"aotearoa:kamahi_tree",
	"aotearoa:mountain_beech_tree",
	"aotearoa:pahautea_tree",
	"aotearoa:kowhai_tree",
	"aotearoa:silver_beech_tree",
	"aotearoa:black_maire_tree",
	"aotearoa:hinau_tree",
}

-- Mapping from chopped variant safe_name back to original tree name
local chopped_source = {}  -- safe_name -> tree_name
-- Mapping from tree name to its stage 1 chopped variant
local stg1_for = {}  -- tree_name -> "tree_felling:stg1_safe_name"
-- Mapping from stage 1 to stage 2
local stg2_for = {}  -- stg1_name -> stg2_name

-- Dynamic tree base node lookup: node_name -> {group, size, sizes_list, drop}
local dt_bases = {}

-- Dynamic tree drop mapping
local dt_drops = {
	dynamic_tree_apple   = "default:tree",
	dynamic_tree_acacia  = "default:acacia_tree",
	dynamic_tree_aspen   = "default:aspen_tree",
	dynamic_tree_jungle  = "default:jungletree",
	dynamic_tree_pine    = "default:pine_tree",
	dynamic_tree_redwood = "sequoia:trunk",
	dynamic_tree_sakura  = "default:cherry_tree",
	dynamic_tree_dry     = "dynamic_trees:dry_tree",
	dynamic_tree_palm    = "default:palm_tree",
	dynamic_tree_bamboo  = nil,  -- handled per-size below
}

-- Section B: Helper functions

-- 18 neighbors used for BFS scanning (face + edge diagonals)
local leaf_offsets = {
	-- 6 face directions
	{0,1,0}, {0,-1,0}, {1,0,0}, {-1,0,0}, {0,0,1}, {0,0,-1},
	-- 12 edge diagonals (two-axis) — needed for diagonally-stepping branches
	{1,1,0}, {-1,1,0}, {1,-1,0}, {-1,-1,0},
	{1,0,1}, {-1,0,1}, {1,0,-1}, {-1,0,-1},
	{0,1,1}, {0,-1,1}, {0,1,-1}, {0,-1,-1},
}

local function is_upright(node)
	local ndef = minetest.registered_nodes[node.name]
	if not ndef then return false end
	if ndef.paramtype2 ~= "facedir" and ndef.paramtype2 ~= "colorfacedir" then
		return true
	end
	return (node.param2 % 24) < 4
end

local function scan_tree(base_pos, tree_name, dt_group)
	-- BFS upward from base, collecting trunk nodes
	-- Returns list of {pos=, node=} sorted by ascending Y
	local trunks = {}
	local visited = {}
	local queue = {}
	local base_x, base_z = base_pos.x, base_pos.z

	-- Start scanning from 1 above base
	table.insert(queue, {x = base_pos.x, y = base_pos.y + 1, z = base_pos.z})

	while #queue > 0 do
		local pos = table.remove(queue, 1)
		local key = pos.x .. "," .. pos.y .. "," .. pos.z

		if not visited[key] and #trunks < 200 then
			visited[key] = true

			-- Check horizontal spread limit (8 blocks handles wide branching trees)
			local dx = math.abs(pos.x - base_x)
			local dz = math.abs(pos.z - base_z)
			if dx <= 8 and dz <= 8 then
				local node = minetest.get_node(pos)
				local is_trunk = false

				if dt_group then
					-- Dynamic tree: match by group
					local ndef = minetest.registered_nodes[node.name]
					if ndef and ndef.groups and ndef.groups[dt_group]
							and ndef.groups[dt_group] > 0 then
						is_trunk = true
					end
				else
					-- Standard tree: match exact name
					if node.name == tree_name then
						is_trunk = true
					end
				end

				if is_trunk then
					table.insert(trunks, {pos = {x=pos.x, y=pos.y, z=pos.z}, node = node})
					-- Queue all 18 neighbors (6 face + 12 edge-diagonal).
					-- Guard downward directions against crossing below the cut point.
					for _, off in ipairs(leaf_offsets) do
						local ny = pos.y + off[2]
						if off[2] >= 0 or ny > base_pos.y then
							table.insert(queue, {x=pos.x+off[1], y=ny, z=pos.z+off[3]})
						end
					end
				end
			end
		end
	end

	-- Sort by ascending Y
	table.sort(trunks, function(a, b) return a.pos.y < b.pos.y end)
	return trunks
end

local function get_fall_direction(base_pos, player)
	if not player or not player:is_player() then
		return {x = 1, y = 0, z = 0}
	end
	local ppos = player:get_pos()
	local dx = base_pos.x - ppos.x
	local dz = base_pos.z - ppos.z
	-- Pick the axis with the larger offset (away from player)
	if math.abs(dx) >= math.abs(dz) then
		return {x = dx >= 0 and 1 or -1, y = 0, z = 0}
	else
		return {x = 0, y = 0, z = dz >= 0 and 1 or -1}
	end
end

local function get_side_param2(fall_dir)
	-- Facedir param2 for horizontal trunks lying on their side
	if fall_dir.x > 0 then return 12 end      -- +X
	if fall_dir.x < 0 then return 16 end      -- -X
	if fall_dir.z > 0 then return 4 end       -- +Z
	return 8                                   -- -Z
end

local function apply_tool_wear(digger, tree_name)
	if not digger or not digger:is_player() then return end
	local tool = digger:get_wielded_item()
	local tool_def = tool:get_definition()
	if not tool_def or not tool_def.tool_capabilities then return end
	local tp = tool_def.tool_capabilities
	local ndef = minetest.registered_nodes[tree_name]
	local choppy = ndef and ndef.groups and ndef.groups.choppy or 1
	local uses = tp.groupcaps and tp.groupcaps.choppy
			and tp.groupcaps.choppy.uses or 0
	local maxlevel = tp.groupcaps and tp.groupcaps.choppy
			and tp.groupcaps.choppy.maxlevel or 0
	if uses > 0 then
		local wear = math.ceil(65535 / (uses * math.pow(3, math.max(0, maxlevel - choppy))))
		tool:add_wear(wear)
		digger:set_wielded_item(tool)
	end
end

-- BFS from trunk positions outward to collect nearby leaf nodes
local function scan_leaves(trunk_list, min_y)
	local leaves = {}
	local visited = {}
	local queue = {}

	-- Seed from all trunk positions
	for _, tp in ipairs(trunk_list) do
		local key = tp.pos.x .. "," .. tp.pos.y .. "," .. tp.pos.z
		visited[key] = true  -- mark trunk positions as visited so we skip them
		for _, off in ipairs(leaf_offsets) do
			local p = {x = tp.pos.x + off[1], y = tp.pos.y + off[2], z = tp.pos.z + off[3]}
			if p.y >= min_y then
				table.insert(queue, p)
			end
		end
	end

	while #queue > 0 and #leaves < 400 do
		local pos = table.remove(queue, 1)
		local key = pos.x .. "," .. pos.y .. "," .. pos.z

		if not visited[key] then
			visited[key] = true
			local node = minetest.get_node(pos)
			local ndef = minetest.registered_nodes[node.name]
			if ndef and ndef.groups and ndef.groups.leaves and ndef.groups.leaves > 0 then
				table.insert(leaves, {pos = {x=pos.x, y=pos.y, z=pos.z}, node = node})
				-- Continue BFS through connected leaves
				for _, off in ipairs(leaf_offsets) do
					local p = {x = pos.x + off[1], y = pos.y + off[2], z = pos.z + off[3]}
					if p.y >= min_y then
						table.insert(queue, p)
					end
				end
			end
		end
	end

	return leaves
end

-- Ballistics: a rigid trunk tipping over carries the piece that started h
-- nodes above the pivot to roughly h nodes out from it.  Free fall from
-- height h takes t = sqrt(2h/g), so the launch speed is h/t = sqrt(g*h/2).
-- FRICTION_COMP offsets the horizontal drag falling_item applies to every
-- falling entity (x0.95 per 0.1 s tick), which would otherwise make the
-- upper pieces land short and pile up on the lower ones.
local GRAVITY = tonumber(minetest.settings:get("movement_gravity")) or 9.81
local FRICTION_COMP = 1.35

local function launch_speed(h)
	if h <= 0 then return 0 end
	return math.sqrt(GRAVITY * h / 2) * FRICTION_COMP
end

local function fell_tree(base_pos, tree_name, digger, dt_group, forced_dir)
	local fall_dir = forced_dir or get_fall_direction(base_pos, digger)
	local side_param2 = get_side_param2(fall_dir)

	-- Shared per-felling domino table: every piece of this tree writes into
	-- the same table, so each standing neighbour gets exactly ONE domino
	-- roll per felled tree instead of one per flying piece.
	local domino_hits = {}

	-- Scan tree above base
	local trunks = scan_tree(base_pos, tree_name, dt_group)

	-- Scan leaves connected to the felled trunks (at or above cut point)
	local leaves = scan_leaves(trunks, base_pos.y)

	-- Track every world position we clear so we can sweep neighbors afterwards
	-- for attached nodes (fruit, nuts, etc.) that lost their support.
	local removed_positions = {}

	-- Remove the chopped base node
	minetest.remove_node(base_pos)
	table.insert(removed_positions, base_pos)

	-- Spawn falling entities for each trunk node
	for i, trunk in ipairs(trunks) do
		local h = trunk.pos.y - base_pos.y  -- height above base
		local node = trunk.node

		-- Remove from world
		minetest.remove_node(trunk.pos)
		table.insert(removed_positions, trunk.pos)

		-- For standard facedir trees, rotate to lie on side
		local ndef = minetest.registered_nodes[node.name]
		if ndef and (ndef.paramtype2 == "facedir" or ndef.paramtype2 == "colorfacedir") then
			node.param2 = side_param2
		end

		-- Spawn falling_node entity on a tipping arc
		local entity = minetest.add_entity(trunk.pos, "__builtin:falling_node")
		if entity then
			local luaent = entity:get_luaentity()
			if luaent then
				luaent:set_node(node)
				luaent._domino_hit = domino_hits
			end
			local speed = launch_speed(h)
			entity:set_velocity({
				x = fall_dir.x * speed,
				y = 0,
				z = fall_dir.z * speed,
			})
		end
	end

	-- Spawn falling entities for leaves — same tipping arc as the trunks so
	-- the canopy travels with the tree, with a little jitter so it spreads
	-- naturally instead of landing in a perfect line.
	for i, leaf in ipairs(leaves) do
		local h = leaf.pos.y - base_pos.y

		minetest.remove_node(leaf.pos)
		table.insert(removed_positions, leaf.pos)

		local entity = minetest.add_entity(leaf.pos, "__builtin:falling_node")
		if entity then
			local luaent = entity:get_luaentity()
			if luaent then
				luaent:set_node(leaf.node)
			end
			local speed = launch_speed(h) * (0.85 + math.random() * 0.3)
			entity:set_velocity({
				x = fall_dir.x * speed,
				y = 0,
				z = fall_dir.z * speed,
			})
		end
	end

	-- Sweep all neighbors of removed nodes and trigger falling for any attached
	-- nodes (fruit, nuts, hanging decorations, etc.) that have lost their support.
	local checked = {}
	for _, rpos in ipairs(removed_positions) do
		for _, off in ipairs(leaf_offsets) do
			local p = {x = rpos.x + off[1], y = rpos.y + off[2], z = rpos.z + off[3]}
			local key = p.x .. "," .. p.y .. "," .. p.z
			if not checked[key] then
				checked[key] = true
				minetest.check_single_for_falling(p)
			end
		end
	end

	-- Play cracking/falling sound
	minetest.sound_play("default_break_glass", {
		pos = base_pos,
		gain = 0.7,
		max_hear_distance = 32,
	}, true)
end

-- Domino: a falling trunk crashing into a standing tree has a 30% chance to
-- knock that tree over too, in the direction the trunk was travelling.
--
-- The falling entity is physical, so it collides with a standing trunk and
-- never actually enters its cell — checking our own cell (the old approach)
-- always saw air and the domino never fired.  Instead we look 1 and 2 cells
-- AHEAD along the direction of travel each tick; by the time the engine
-- zeroes our velocity on impact, one of those probes has already covered the
-- trunk cell.  The per-felling _domino_hit table (shared by every piece of
-- one felled tree) guarantees a single 30% roll per standing tree.
-- Felling is deferred via minetest.after(0) so chains through dense forests
-- don't blow the call stack in a single tick.
local DOMINO_CHANCE = 0.3

local function try_domino_at(self, rpos, vel)
	local key = rpos.x .. "," .. rpos.y .. "," .. rpos.z
	if self._domino_hit[key] then return end
	self._domino_hit[key] = true

	local node = minetest.get_node(rpos)
	-- Skip air and our own chop-stage nodes
	if node.name == "air" or node.name:sub(1, 13) == "tree_felling:" then return end
	local ndef = minetest.registered_nodes[node.name]
	if not ndef or not ndef.groups or (ndef.groups.tree or 0) == 0 then return end
	if not is_upright(node) then return end

	-- Must have another tree trunk directly above — standing tree, not a lone log
	local above = minetest.get_node({x = rpos.x, y = rpos.y + 1, z = rpos.z})
	local andef = minetest.registered_nodes[above.name]
	if not andef or not andef.groups or (andef.groups.tree or 0) == 0 then return end

	if math.random() > DOMINO_CHANCE then return end

	-- Determine dt_group for dynamic tree trunks
	local dt_group
	for g, v in pairs(ndef.groups) do
		if v > 0 and g:sub(1, 13) == "dynamic_tree_" then
			dt_group = g
			break
		end
	end

	-- Fell it away from the impact: dominant axis of our travel direction
	local fall_dir
	if math.abs(vel.x) >= math.abs(vel.z) then
		fall_dir = {x = vel.x >= 0 and 1 or -1, y = 0, z = 0}
	else
		fall_dir = {x = 0, y = 0, z = vel.z >= 0 and 1 or -1}
	end

	local rpos_snap = {x = rpos.x, y = rpos.y, z = rpos.z}
	local node_name  = node.name
	minetest.after(0, function()
		-- Re-verify the tree is still standing (another entity may have already felled it)
		if minetest.get_node(rpos_snap).name ~= node_name then return end

		local function is_trunk(p)
			local n = minetest.get_node(p)
			if dt_group then
				local d = minetest.registered_nodes[n.name]
				return d and d.groups and (d.groups[dt_group] or 0) > 0
			end
			return n.name == node_name
		end

		-- The impact may be partway up the trunk; walk down to the lowest
		-- trunk node so the whole tree topples from its stump instead of
		-- snapping off above the impact and leaving a bare pole standing.
		local base = {x = rpos_snap.x, y = rpos_snap.y, z = rpos_snap.z}
		local steps = 0
		while steps < 30 and is_trunk({x = base.x, y = base.y - 1, z = base.z}) do
			base.y = base.y - 1
			steps = steps + 1
		end
		-- Break one above the lowest trunk: that node is guaranteed trunk
		-- (base <= rpos and rpos has trunk above), and the stump survives
		-- just like a player-felled tree.
		fell_tree({x = base.x, y = base.y + 1, z = base.z},
			node_name, nil, dt_group, fall_dir)
	end)
end

local function try_domino(self, pos)
	local obj = self.object
	local vel = obj and obj:get_velocity()
	if not vel then return end
	local speed = math.sqrt(vel.x * vel.x + vel.z * vel.z)
	-- Only trunks still carrying real sideways momentum knock trees over
	if speed < 2 then return end

	if not self._domino_hit then self._domino_hit = {} end

	local dir_x, dir_z = vel.x / speed, vel.z / speed
	for dist = 1, 2 do
		try_domino_at(self, vector.round({
			x = pos.x + dir_x * dist,
			y = pos.y,
			z = pos.z + dir_z * dist,
		}), vel)
	end
end

-- Section C: Register chopped variants for standard trees (at init time)

for _, tree_name in ipairs(standard_trees) do
	local orig = minetest.registered_nodes[tree_name]
	if orig then
		local safe_name = tree_name:gsub(":", "_")
		local stg1_name = "tree_felling:stg1_" .. safe_name
		local stg2_name = "tree_felling:stg2_" .. safe_name

		chopped_source[safe_name] = tree_name
		stg1_for[tree_name] = stg1_name
		stg2_for[stg1_name] = stg2_name

		local choppy_level = orig.groups and orig.groups.choppy or 1

		-- Stage 1: 75% width
		minetest.register_node(stg1_name, {
			description = orig.description .. " (Chopped 1)",
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375},
			},
			tiles = orig.tiles,
			sounds = orig.sounds,
			groups = {choppy = choppy_level, tree = 1, not_in_creative_inventory = 1},
			drop = "",
			on_construct = function(pos)
				minetest.get_meta(pos):set_string("tree_felling:source", tree_name)
			end,
			on_dig = function(pos, node, digger)
				-- Stage 1 -> Stage 2
				minetest.swap_node(pos, {name = stg2_name, param2 = node.param2})
				apply_tool_wear(digger, tree_name)
				minetest.sound_play("default_wood_footstep", {
					pos = pos, gain = 0.8, max_hear_distance = 16,
				}, true)
			end,
		})

		-- Stage 2: 50% width
		minetest.register_node(stg2_name, {
			description = orig.description .. " (Chopped 2)",
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
			},
			tiles = orig.tiles,
			sounds = orig.sounds,
			groups = {choppy = choppy_level, tree = 1, not_in_creative_inventory = 1},
			drop = "",
			on_construct = function(pos)
				minetest.get_meta(pos):set_string("tree_felling:source", tree_name)
			end,
			on_dig = function(pos, node, digger)
				-- Stage 2 -> fell!
				apply_tool_wear(digger, tree_name)
				fell_tree(pos, tree_name, digger, nil)
			end,
		})
	end
end

-- Section D: Override on_dig for standard trees (in on_mods_loaded, after plank_splitting)

minetest.register_on_mods_loaded(function()
	for _, tree_name in ipairs(standard_trees) do
		if not minetest.registered_nodes[tree_name] then
			goto continue
		end
		if not stg1_for[tree_name] then
			goto continue
		end

		local old_on_dig = minetest.registered_nodes[tree_name].on_dig
		local stg1_name = stg1_for[tree_name]

		-- Add falling_node_damage to original tree groups
		local orig_groups = table.copy(minetest.registered_nodes[tree_name].groups or {})
		orig_groups.falling_node_damage = 4

		minetest.override_item(tree_name, {
			groups = orig_groups,
			falling_step = function(self, pos, dtime)
				try_domino(self, pos)
			end,
			on_dig = function(pos, node, digger)
				-- Check felling conditions
				local meta = minetest.get_meta(pos)

				-- Not player-placed (those go to plank_splitting)
				if meta:get_int("player_placed") == 1 then
					if old_on_dig then
						return old_on_dig(pos, node, digger)
					else
						return minetest.node_dig(pos, node, digger)
					end
				end

				-- Must be upright
				if not is_upright(node) then
					if old_on_dig then
						return old_on_dig(pos, node, digger)
					else
						return minetest.node_dig(pos, node, digger)
					end
				end

				-- Must have trunk above (same type)
				local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
				if above.name ~= tree_name then
					if old_on_dig then
						return old_on_dig(pos, node, digger)
					else
						return minetest.node_dig(pos, node, digger)
					end
				end

				-- Is this the base? (no same-type trunk below)
				local below = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
				if below.name ~= tree_name then
					-- Base of standing tree: stump, invincible
					return
				end

				-- Mid-tree trunk with trunk above: start chopping sequence
				minetest.swap_node(pos, {name = stg1_name, param2 = node.param2})
				apply_tool_wear(digger, tree_name)
				minetest.sound_play("default_wood_footstep", {
					pos = pos, gain = 0.8, max_hear_distance = 16,
				}, true)
			end,
		})

		::continue::
	end
end)

-- Section E: Dynamic tree support

-- Build lookup of all dynamic tree base nodes
-- Two naming patterns:
--   "dynamic_trees:{type}_main_trunk_base_{size}x{size}" (most trees)
--   "dynamic_trees:bamboo_{size}_base" (bamboo)

local dt_size_list = {2, 4, 6, 8, 10, 12, 14, 16}
local bamboo_sizes = {2, 4, 6, 8}

-- Dynamic tree types (excluding cactus)
local dt_types = {
	{prefix = "apple_tree",  group = "dynamic_tree_apple"},
	{prefix = "acacia_tree", group = "dynamic_tree_acacia"},
	{prefix = "aspen_tree",  group = "dynamic_tree_aspen"},
	{prefix = "jungle_tree", group = "dynamic_tree_jungle"},
	{prefix = "pine_tree",   group = "dynamic_tree_pine"},
	{prefix = "redwood_tree", group = "dynamic_tree_redwood"},
	{prefix = "sakura_tree", group = "dynamic_tree_sakura"},
	{prefix = "dry_tree",    group = "dynamic_tree_dry"},
	{prefix = "palm_tree",   group = "dynamic_tree_palm"},
}

for _, dt in ipairs(dt_types) do
	for _, sz in ipairs(dt_size_list) do
		local name = "dynamic_trees:" .. dt.prefix .. "_main_trunk_base_" .. sz .. "x" .. sz
		if minetest.registered_nodes[name] then
			dt_bases[name] = {
				group = dt.group,
				size = sz,
				drop = dt_drops[dt.group] or "default:tree",
			}
		end
	end
end

-- Bamboo bases
for _, sz in ipairs(bamboo_sizes) do
	local name = "dynamic_trees:bamboo_" .. sz .. "x" .. sz .. "_base"
	if minetest.registered_nodes[name] then
		dt_bases[name] = {
			group = "dynamic_tree_bamboo",
			size = sz,
			drop = "dynamic_trees:bamboo_" .. sz .. "x" .. sz,
		}
	end
end

-- Check if pos has a same-group trunk above
local function dt_has_trunk_above(pos, group)
	local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
	local ndef = minetest.registered_nodes[above.name]
	return ndef and ndef.groups and ndef.groups[group] and ndef.groups[group] > 0
end

-- True when this trunk node has a same-group trunk beside it at the same
-- height, i.e. it belongs to a thick (2x2 or larger) trunk cross-section.
-- A lone column has no horizontal neighbour and topples on the cut; a thick
-- trunk must be whittled down to its last standing column before it falls, so
-- chopping just one of a 2x2's four blocks no longer brings the whole tree down.
local function dt_trunk_is_thick(pos, group)
	for _, h in ipairs({{1, 0}, {-1, 0}, {0, 1}, {0, -1}}) do
		local p = {x = pos.x + h[1], y = pos.y, z = pos.z + h[2]}
		local ndef = minetest.registered_nodes[minetest.get_node(p).name]
		if ndef and ndef.groups and ndef.groups[group]
				and ndef.groups[group] > 0 then
			return true
		end
	end
	return false
end

-- Override on_dig for all dynamic tree base nodes
for base_name, info in pairs(dt_bases) do
	local orig_groups = table.copy(minetest.registered_nodes[base_name].groups or {})
	orig_groups.falling_node_damage = 4

	minetest.override_item(base_name, {
		groups = orig_groups,
		on_dig = function(pos, node, digger)
			-- Base with trunk above: stump, invincible
			if dt_has_trunk_above(pos, info.group) then
				return
			end
			-- No trunk above: normal dig (isolated stump)
			return minetest.node_dig(pos, node, digger)
		end,
	})
end

-- Add falling_node_damage and fell-on-dig to all dynamic tree trunk nodes
minetest.register_on_mods_loaded(function()
	for name, ndef in pairs(minetest.registered_nodes) do
		if name:sub(1, 14) == "dynamic_trees:" and not name:find("canopy")
				and ndef.groups and ndef.groups.tree and ndef.groups.tree > 0 then

			-- Add falling_node_damage if missing
			local needs_groups = not ndef.groups.falling_node_damage
			local new_groups
			if needs_groups then
				new_groups = table.copy(ndef.groups)
				new_groups.falling_node_damage = 4
			end

			-- Non-base trunks: override on_dig for immediate felling
			if not dt_bases[name] then
				-- Find this node's dynamic_tree_* group
				local dt_group
				for g, v in pairs(ndef.groups) do
					if v > 0 and g:sub(1, 13) == "dynamic_tree_" then
						dt_group = g
						break
					end
				end

				if dt_group then
					local old_on_dig = ndef.on_dig
					local overrides = {
						falling_step = function(self, pos, dtime)
							try_domino(self, pos)
						end,
						on_dig = function(pos, node, digger)
							-- Has same-group trunk above: candidate to fell
							if dt_has_trunk_above(pos, dt_group) then
								-- Thick trunk: this cut just lops off one column;
								-- the tree only topples once its cross-section is
								-- down to the last standing block.
								if dt_trunk_is_thick(pos, dt_group) then
									if old_on_dig then
										return old_on_dig(pos, node, digger)
									end
									return minetest.node_dig(pos, node, digger)
								end
								apply_tool_wear(digger, name)
								fell_tree(pos, name, digger, dt_group)
								return
							end
							-- No trunk above: normal dig
							if old_on_dig then
								return old_on_dig(pos, node, digger)
							end
							return minetest.node_dig(pos, node, digger)
						end,
					}
					if needs_groups then
						overrides.groups = new_groups
					end
					minetest.override_item(name, overrides)
				elseif needs_groups then
					minetest.override_item(name, {groups = new_groups})
				end
			elseif needs_groups then
				minetest.override_item(name, {groups = new_groups})
			end
		end
	end
end)
