-- Seasonal foliage for dtrees canopies.
--
-- dtrees supplies nearly every tree in this game, so its constraints decide the
-- approach, and they are severe: growth is an ABM cellular automaton whose whole
-- state is the node NAME and the spatial arrangement. dt_apple_tree_growth.lua
-- alone contains 155 literal comparisons against "apple_tree_canopy_base".
-- Renaming a canopy to an autumn variant would permanently stall trunk growth,
-- stop canopy spread, and leave a sapling planted in autumn unable to ever
-- become a tree.
--
-- So the node name never changes. We tint param2 instead, which is completely
-- free: no dtrees growth file reads or writes param2, canopies declare no
-- paramtype2 and no palette, and dtrees stores no node metadata or timers at
-- all. Groups are left untouched, so tree_felling, leaf decay, x_farming's
-- apple/cocoa spawners and the snow_cover ABM all keep working unchanged.
--
-- This is the same mechanism always_greener already uses for grass.

local S = seasons.settings

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

--------------------------------------------------------------------------------
-- Which nodes
--------------------------------------------------------------------------------

-- Hand-written rather than a name regex: the full dtrees canopy inventory is
-- only 29 nodes, the deciduous subset is 9, and a wrong entry here is a visible
-- bug on every tree of that species. Easy to eyeball, easy to extend.
--
-- Excluded on purpose: jungle and palm (tropical, no autumn), pine and redwood
-- (conifers), bamboo (evergreen), dry and cactus (no canopy nodes at all).
local SPECIES = {
	["dynamic_trees:apple_tree_canopy_base"]  = "apple",
	["dynamic_trees:apple_tree_canopy_1"]     = "apple",
	["dynamic_trees:aspen_tree_canopy_base"]  = "aspen",
	["dynamic_trees:aspen_tree_canopy_1"]     = "aspen",
	["dynamic_trees:acacia_tree_canopy_base"] = "acacia",
	["dynamic_trees:acacia_tree_canopy_1"]    = "acacia",
	["dynamic_trees:acacia_tree_canopy_2"]    = "acacia",
	["dynamic_trees:sakura_tree_canopy_base"] = "sakura",
	["dynamic_trees:sakura_tree_canopy_1"]    = "sakura",
}

seasons.leaf_species = SPECIES

local STAGES = 32          -- quantisation of the foliage curve
local STAGE_STEP = 8       -- param2 = stage * STAGE_STEP, so 0..248

--------------------------------------------------------------------------------
-- Foliage stage at a position
--------------------------------------------------------------------------------

-- Deterministic per-mapblock jitter, so a forest turns in patches over a week
-- or two rather than every tree in the world flipping in the same instant.
-- Computed from block coordinates, so it is stable across restarts.
local function block_jitter(pos)
	local bx = math.floor(pos.x / 16)
	local by = math.floor(pos.y / 16)
	local bz = math.floor(pos.z / 16)
	-- Plain arithmetic hash: LuaJIT is 5.1 and has no bitwise operators.
	local n = (bx * 73856093 + by * 19349663 + bz * 83492791) % 1024
	return (n / 1024 - 0.5) * 0.12   -- +/- 6% of the year
end

--- Foliage stage, 0 (full summer green) .. STAGES-1 (dead winter brown).
function seasons.get_foliage_stage(pos)
	if not S.enabled or not S.leaves then return 0 end

	-- No autumn in the tropics. Uses the same biome heat everything else reads.
	if minetest.get_heat(pos) > 75 then return 0 end

	local f = clamp(seasons.get_foliage() + block_jitter(pos), 0, 1)
	return math.floor(f * (STAGES - 1) + 0.5)
end

--------------------------------------------------------------------------------
-- Node overrides
--------------------------------------------------------------------------------

minetest.register_on_mods_loaded(function()
	if not S.enabled or not S.leaves then return end
	if not minetest.get_modpath("dtrees") then return end

	local count = 0
	for name, sp in pairs(SPECIES) do
		local def = minetest.registered_nodes[name]
		if not def then
			minetest.log("warning", "[seasons] leaf node missing, skipping: " .. name)
		else
			-- override_item merges, so drawtype, node_box, groups, drops, sounds
			-- and waving all survive untouched. dtrees itself overrides these
			-- nodes again at minetest.after(0) to force walkable = false; that
			-- also merges and will not disturb the palette.
			--
			-- The base tile is a pre-baked bright greyscale rather than a runtime
			-- ^[hsl desaturation: a palette MULTIPLIES the tile, and the shipped
			-- textures are too dark to leave any headroom (apple's HSL lightness
			-- peaks at 64 while its green channel reaches 127). See
			-- tools/gen_leaf_assets.py.
			minetest.override_item(name, {
				tiles      = {"seasons_leaf_" .. sp .. ".png"},
				paramtype2 = "color",
				palette    = "seasons_leaf_" .. sp .. "_palette.png",
				color      = "#ffffff",
			})
			count = count + 1
		end
	end

	minetest.log("action", "[seasons] seasonal foliage enabled on " .. count .. " canopy nodes")
end)

--------------------------------------------------------------------------------
-- Repainting
--------------------------------------------------------------------------------

-- This must be a recurring ABM, not a one-shot sweep at the season boundary.
-- dtrees' growth ABMs inject fresh canopy nodes continuously, all year round,
-- and every one of their set_node calls omits param2 -- which forces param2 = 0.
-- That is also why palette index 0 is each species' summer colour: a leaf that
-- appears between repaints must not look broken.
--
-- Shape and cost deliberately mirror always_greener's own 'Grass Color Update'.
if S.enabled and S.leaves and minetest.get_modpath("dtrees") then
	local LEAF_NODES = {}
	for name in pairs(SPECIES) do
		LEAF_NODES[#LEAF_NODES + 1] = name
	end

	-- On its own the ABM averages ~5 minutes per node, so walking into a fresh
	-- forest in autumn would show green trees for a while. This LBM repaints a
	-- whole mapblock the moment it activates, which covers both newly generated
	-- chunks and re-entered terrain.
	--
	-- run_at_every_load is required: the season changes while blocks sit
	-- unloaded, and blocks written by older engine versions may carry no
	-- timestamp at all, so a once-only LBM would never fire on them.
	minetest.register_lbm({
		name = "seasons:leaf_colour",
		label = "Seasonal leaves on block load",
		nodenames = LEAF_NODES,
		run_at_every_load = true,
		bulk_action = function(pos_list)
			if #pos_list == 0 then return end
			-- One stage for the whole block: the jitter is per-mapblock anyway,
			-- so this is both cheaper and exactly equivalent.
			local p2 = seasons.get_foliage_stage(pos_list[1]) * STAGE_STEP
			for i = 1, #pos_list do
				local pos = pos_list[i]
				local node = minetest.get_node(pos)
				if SPECIES[node.name] and node.param2 ~= p2 then
					minetest.swap_node(pos, {name = node.name, param2 = p2})
				end
			end
		end,
	})

	minetest.register_abm({
		label = "Seasonal leaf colour",
		nodenames = {
			"group:dt_apple_leaves",
			"group:dt_aspen_leaves",
			"group:dt_acacia_leaves",
			"group:dt_sakura_leaves",
		},
		interval = 30,
		chance = 10,
		catch_up = true,
		action = function(pos, node)
			if not SPECIES[node.name] then return end
			local p2 = seasons.get_foliage_stage(pos) * STAGE_STEP
			if node.param2 ~= p2 then
				-- swap_node keeps metadata and fires no callbacks. set_node would
				-- also reset param2 unless passed explicitly.
				minetest.swap_node(pos, {name = node.name, param2 = p2})
			end
		end,
	})
end
