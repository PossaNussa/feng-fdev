-- Shallow water: water that is less tall.
--
-- Height is stored in the NODE NAME (eight variants, _1 .. _8, one per 1/8 block)
-- rather than in param2.  That is a deliberate change from the leveled paramtype2
-- the old version used, and the reason is colour: the game's water is biome-tinted
-- through a 256-entry palette indexed by param2 (always_greener/scripts/water.lua),
-- and a leveled node spends its whole param2 byte on the level, leaving nothing for
-- the palette -- so a leveled puddle rendered as the bare, near-white texture.  With
-- the level moved into the node name, param2 is free to carry the palette index, and
-- a puddle keeps the exact colour of the water it came from.  Conversions in and out
-- of a source are still lossless (8 units == one full source block), so the water is
-- conserved exactly as before.
--
-- Nothing here touches the existing source-moving ABM's handling of oceans, lakes
-- or rivers.  A source only becomes shallow water once it is on its own with
-- somewhere to go, which never happens inside a body of water.

local UNIT = 8                      -- 1/8-block steps per full block (unit currency)
local MAX_UNITS = 8                 -- units in a full block

-- Water that merges into a body of water has to be rounded to a whole node:
-- there is no way to express "the lake is now 3/8 of a node deeper".  Rounding
-- each merge to whichever side is nearer would quietly drain the world — every
-- dribble that runs into a pool is a small one — so instead the roundings are
-- kept on a ledger and each new one is settled against it.  Round up while the
-- ledger is in debt, round down while it is in credit, and the running error
-- never exceeds a single node of water for the entire map.
dynamic_liquid.shallow_merge_delta = 0

local interval = tonumber(minetest.settings:get("dynamic_liquid_shallow_interval")) or 0.25

local get_node = minetest.get_node
local set_node = minetest.set_node
local remove_node = minetest.remove_node
local get_timer = minetest.get_node_timer
local registered_nodes = minetest.registered_nodes
local get_item_group = minetest.get_item_group

-- A liquid that is not this water's own kind — mud, lava, dirty water, oil, or even a
-- different dynamic liquid.  These are `buildable_to = true` (as liquids normally are),
-- which without this check made the flow code treat them as empty space to drain and
-- spread into: water poured itself into every mud cell it touched and the body thinned
-- out.  Treated as a solid wall instead, water rests on and against them.  Our own
-- source and shallow variants are handled by units_at before this is ever reached, so
-- anything in group:liquid here belongs to some other liquid.
local function foreign_liquid(name)
	return get_item_group(name, "liquid") > 0
end

-- source node name -> info table.  Also keyed by every shallow variant name so a
-- timer can find its own info without a second lookup.
local info_by_name = {}

dynamic_liquid.shallow_variants = dynamic_liquid.shallow_variants or {}
-- Any shallow variant name -> how many 1/8 units of water it represents.  Exposed so
-- other mods (e.g. regional_weather's evaporation ABM) can ask how deep a puddle is.
dynamic_liquid.shallow_units_by_name = dynamic_liquid.shallow_units_by_name or {}

local horizontal = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1},
}

local surrounding = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1},
	{x = 0, y = 1, z = 0},
	{x = 0, y = -1, z = 0},
}

-----------------------------------------------------------------------------------------
-- Colour
--
-- The colour a cell should take is a pure function of position (biome heat/humidity/
-- depth), so the "right" answer is always available.  In order of preference:
--   1. if the cell already holds our water, keep the param2 it has;
--   2. copy an adjacent source's param2 — the authoritative colour for right here;
--   3. copy an adjacent puddle's param2 — the water this one is flowing from;
--   4. ask always_greener for the biome colour at this exact position;
--   5. fall back to 0 (the palette's default entry).
-- 2 and 3 are the cheap "sample nearby colour" path that covers ordinary flow; 4 is
-- the exact fallback for a cell with no watery neighbour yet (a fresh rain puddle).

local awg_water_param2  -- resolved lazily; always_greener may load after us

local function pick_color(pos, info)
	if not info.colored then return 0 end

	local here = get_node(pos)
	if here.name == info.source or info.units_by_name[here.name] then
		return here.param2
	end

	local best
	for i = 1, 6 do
		local d = surrounding[i]
		local m = get_node({x = pos.x + d.x, y = pos.y + d.y, z = pos.z + d.z})
		if m.name == info.source then
			return m.param2
		elseif info.units_by_name[m.name] and not best then
			best = m.param2
		end
	end
	if best then return best end

	if awg_water_param2 == nil then
		local ag = rawget(_G, "always_greener")
		awg_water_param2 = (ag and ag.water_param2) or false
	end
	if awg_water_param2 then
		return awg_water_param2(pos)
	end

	return info.default_color
end

-----------------------------------------------------------------------------------------
-- Reading and writing levels

-- Units of liquid in a cell: nil if the cell holds something that is not this
-- liquid, 0 for empty space we are allowed to spread into.
local function units_at(pos, info)
	local name = get_node(pos).name
	local u = info.units_by_name[name]
	if u then return u end
	if name == info.source then return MAX_UNITS end
	return nil
end

-- Write a cell back.  Zero removes it, a full cell becomes an ordinary source again
-- so the rest of the game sees normal water wherever the depth allows it.  Every
-- write picks up the right palette colour for the cell.
local function write_units(pos, info, units)
	if units <= 0 then
		if info.units_by_name[get_node(pos).name] then
			remove_node(pos)
		end
		return
	end
	if units >= MAX_UNITS then
		set_node(pos, {name = info.source, param2 = pick_color(pos, info)})
		return
	end
	set_node(pos, {name = info.heights[units], param2 = pick_color(pos, info)})
end

local function wake(pos)
	local info = info_by_name[get_node(pos).name]
	if info then
		local timer = get_timer(pos)
		if not timer:is_started() then
			timer:start(interval)
		end
	end
end

-- Called at every cell this file changes, so it is also the place to tell the
-- movement ABM that its "this source has nowhere to go" cache is out of date
-- here: set_node fires none of the hooks that would otherwise clear it.
local function wake_around(pos)
	wake(pos)
	local x, y, z = pos.x, pos.y, pos.z
	for i = 1, 6 do
		local dir = surrounding[i]
		wake({x = x + dir.x, y = y + dir.y, z = z + dir.z})
	end
	if dynamic_liquid.invalidate_stability then
		dynamic_liquid.invalidate_stability(pos)
	end
end

dynamic_liquid.wake_shallow = wake_around

-----------------------------------------------------------------------------------------
-- Can liquid rest in this cell?

-- Empty space only counts as somewhere to spread if something holds the water up
-- there.  Otherwise it belongs one cell down, which the falling step handles.
--
-- A full source underneath IS support: water resting on the surface of a lake is
-- held up by the water below it, so it spreads out level across that surface as a
-- thin film — the 1..8 gradient.  (It used to be treated as unsupported so the
-- water would "join" the body by dissolving into it; that dissolve rounded whole
-- nodes away into the ledger and is what made bodies of water vanish.  A film
-- resting on water is now simply conserved, never dissolved.)
local function is_supported(pos, info)
	local below = {x = pos.x, y = pos.y - 1, z = pos.z}
	local name = get_node(below).name
	if name == "ignore" then return false end
	if name == info.source then return true end
	local u = info.units_by_name[name]
	if u then
		-- Only a full puddle is a solid shelf; a part-filled one is not.
		return u >= MAX_UNITS
	end
	-- Resting on mud (or any other liquid): treat it as a shelf so the water sits on
	-- top instead of counting it as a drop and pouring down into it.
	if foreign_liquid(name) then return true end
	local def = registered_nodes[name]
	return def ~= nil and def.walkable == true
end

-- NOTE: water resting on a body of its own kind is NEVER merged/dissolved into
-- it.  That "merge" rounded a part-node of water into the shallow_merge_delta
-- ledger every time, and on a surface it did so cell after cell — the mechanism
-- that made whole lakes cascade away.  A film on the surface is instead conserved
-- exactly (is_supported treats the water below as a shelf, so the film spreads
-- level as the 1..8 gradient), and a film that fills out to a whole node hands
-- itself back to a source in on_timer.  Nothing here ever destroys water.
-- shallow_merge_delta is kept defined (always 0 now) only for save/API compat.

-- A cell we may move liquid into.  Returns how much is in it already, and whether
-- anything holds water up there; an unsupported cell is a drop, which water goes
-- down rather than across.  nil means liquid cannot enter at all.
--
-- Cells sitting over unloaded map are refused outright: pouring into them would
-- lose the water for good.
local function inspect_cell(pos, info)
	local units = units_at(pos, info)
	if units then
		-- A full source is not somewhere we can add to.
		if units >= MAX_UNITS then return nil end
		return units, true
	end
	local name = get_node(pos).name
	if name == "ignore" then return nil end
	-- A foreign liquid (mud, lava, …) is a wall, not somewhere to spread into.
	if foreign_liquid(name) then return nil end
	local def = registered_nodes[name]
	if not (def and def.buildable_to) then return nil end
	if get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name == "ignore" then
		return nil
	end
	return 0, is_supported(pos, info)
end

-----------------------------------------------------------------------------------------
-- The flow step

-- Give as much as will fit to the cell below.  Water falls before it spreads.
local function try_fall(pos, info, units)
	local below = {x = pos.x, y = pos.y - 1, z = pos.z}
	local there = units_at(below, info)

	if there == nil then
		local name = get_node(below).name
		-- Never fall into unloaded map: the water would simply be lost.
		if name == "ignore" then return false end
		-- Never fall into mud or another liquid — it rests on top instead.
		if foreign_liquid(name) then return false end
		local def = registered_nodes[name]
		if not (def and def.buildable_to) then return false end
		there = 0
	elseif there >= MAX_UNITS then
		return false
	end

	local moved = math.min(MAX_UNITS - there, units)
	if moved <= 0 then return false end

	write_units(below, info, there + moved)
	write_units(pos, info, units - moved)
	wake_around(below)
	wake_around(pos)
	return true
end

-- Tip liquid over the edge into cells that have nothing under them.  Averaging is
-- wrong here — water does not come to rest level with thin air — so this pours as
-- much as will fit and lets the falling step carry it down from there.  This is
-- also what stops a last lonely unit stranding itself at the top of a drop.
local function try_pour(pos, info, units, drops)
	local remaining = units
	local changed = false

	for i = 1, #drops do
		if remaining <= 0 then break end
		local cell = drops[i]
		-- Stop one unit short of full: a full cell becomes an ordinary source, and
		-- a source hanging over a drop is exactly what we are trying to avoid. Held
		-- just below that it stays shallow water and falls on its own next tick.
		local moved = math.min(MAX_UNITS - 1 - cell.units, remaining)
		if moved > 0 then
			write_units(cell.pos, info, cell.units + moved)
			wake_around(cell.pos)
			remaining = remaining - moved
			changed = true
		end
	end

	if changed then
		write_units(pos, info, remaining)
		wake_around(pos)
	end
	return changed
end

-- Share this cell's liquid out evenly across itself and the shallower cells
-- beside it.  The total is preserved exactly: everyone gets floor(sum / n), and
-- the remainder goes to the fullest cells so an already level patch produces no
-- change and settles instead of oscillating.
--
-- Only cells holding LESS than this one take part.  Water runs downhill; a
-- fuller neighbour will come and even us out on its own tick, and letting it
-- happen from both ends at once is how a patch ends up trading single units back
-- and forth forever.
--
-- There is deliberately no floor on how thin the result may be.  A node of water
-- tipped onto flat ground is supposed to run out into the widest, shallowest
-- sheet it can reach — down to a single unit, one eighth of a node, which is as
-- thin as a level can be stored.  It stops there because a cell holding one unit
-- has nothing left to share: floor(1/n) is zero for every neighbour it could
-- reach, so the patch goes still on its own.
local function try_spread(pos, info, units)
	local lower, drops = {}, {}

	for i = 1, 4 do
		local dir = horizontal[i]
		local npos = {x = pos.x + dir.x, y = pos.y, z = pos.z + dir.z}
		local there, supported = inspect_cell(npos, info)
		if there then
			if not supported then
				drops[#drops + 1] = {pos = npos, units = there}
			elseif there < units then
				lower[#lower + 1] = {pos = npos, units = there}
			end
		end
	end

	-- A drop beside us wins: water heads for it instead of spreading out thin.
	if #drops > 0 then
		return try_pour(pos, info, units, drops)
	end

	if #lower == 0 then return false end

	table.sort(lower, function(a, b) return a.units > b.units end)

	-- This cell is fuller than every candidate, so the list stays sorted.
	local cells = {{pos = {x = pos.x, y = pos.y, z = pos.z}, units = units}}
	local sum, count = units, 1

	for i = 1, #lower do
		count = count + 1
		cells[count] = lower[i]
		sum = sum + lower[i].units
	end

	local share = math.floor(sum / count)
	local remainder = sum % count
	local changed = false

	for i = 1, count do
		local want = share
		if i <= remainder then want = want + 1 end
		local cell = cells[i]
		if want ~= cell.units then
			write_units(cell.pos, info, want)
			changed = true
		end
	end

	if changed then
		for i = 1, count do
			wake_around(cells[i].pos)
		end
	end
	return changed
end

local function on_timer(pos)
	local info = info_by_name[get_node(pos).name]
	if not info then return false end

	local units = units_at(pos, info)
	if not units or units <= 0 then return false end

	-- Against unloaded map: hold still until it loads.  Spreading or merging on
	-- the strength of the loaded half alone is what makes the frontier drain "into"
	-- the void — the neighbouring chunk's water is continuous, just not in memory.
	-- Keep the timer alive (return true) so it re-checks once the map catches up.
	if get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name == "ignore" then
		return true
	end
	for i = 1, 4 do
		local d = horizontal[i]
		if get_node({x = pos.x + d.x, y = pos.y, z = pos.z + d.z}).name == "ignore" then
			return true
		end
	end

	if try_fall(pos, info, units) then
		-- This node may no longer exist; whatever is left has been woken.
		return false
	end

	-- Water below can't take any more (a full source, or the fall step already
	-- topped it up), so this cell does NOT dissolve into the body it is riding on
	-- — that was the whole-lake-eating loss.  It spreads out level across the
	-- surface instead (is_supported counts the water below as a shelf), which is
	-- how 1/8 lands on 8/8 and simply rests on top, and how a fuller film thins
	-- into the 1..8 gradient.  Every unit is conserved as a visible node.
	if try_spread(pos, info, units) then
		-- Keep running while something is still moving.
		return true
	end

	-- Boxed in at full height with nowhere to go, so it is simply a block of water.
	-- Hand it back to the ordinary source node.
	if units >= MAX_UNITS then
		set_node(pos, {name = info.source, param2 = pick_color(pos, info)})
	end
	return false
end

-----------------------------------------------------------------------------------------
-- Turning a stranded source into a puddle

-- Somewhere for a puddle to go: open space beside it, or a drop below it.
local function can_spread(pos, info)
	if inspect_cell({x = pos.x, y = pos.y - 1, z = pos.z}, info) then
		return true
	end
	for i = 1, 4 do
		local dir = horizontal[i]
		if inspect_cell({x = pos.x + dir.x, y = pos.y, z = pos.z + dir.z}, info) then
			return true
		end
	end
	return false
end

-- Called from the source-moving ABM once it knows this source has no liquid of its
-- own kind touching it.  A block inside an ocean, a lake or a river always has a
-- neighbour, so it never reaches here.  The source is turned into a full (8/8)
-- puddle that keeps its own param2, so the puddle starts life the exact colour of
-- the water it was, then spreads and thins from there.
function dynamic_liquid.settle_as_shallow(pos, source_name)
	local info = info_by_name[source_name]
	if not info then return false end
	if not can_spread(pos, info) then return false end

	local p2 = info.colored and get_node(pos).param2 or 0
	set_node(pos, {name = info.heights[MAX_UNITS], param2 = p2})
	wake_around(pos)
	return true
end

-- Place shallow water of a given depth (1..8 units) at a position, giving it the
-- right biome colour and starting its flow timer.  Used by mods that want to pour
-- their own thin water into the system (e.g. regional_weather's rain puddles).
function dynamic_liquid.place_shallow(pos, source_name, units)
	local info = info_by_name[source_name]
	if not info then return false end
	units = units or 1
	if units < 1 then return false end
	if units >= MAX_UNITS then
		set_node(pos, {name = info.source, param2 = pick_color(pos, info)})
	else
		set_node(pos, {name = info.heights[units], param2 = pick_color(pos, info)})
	end
	wake_around(pos)
	return true
end

-----------------------------------------------------------------------------------------
-- Registration

-- Build the shallow companions for a liquid that is already registered.  Eight height
-- variants are made, _1 (1/8) through _8 (a full block), everything visual inherited
-- from the source node so each liquid keeps its own look and, crucially, its palette.
function dynamic_liquid.register_shallow(source_name, def)
	local source_def = registered_nodes[source_name]
	if not source_def then
		minetest.log("warning", "[dynamic_liquid] no such node to make shallow: " .. source_name)
		return
	end
	def = def or {}

	local base = def.name or ("dynamic_liquid:shallow_" ..
		source_name:gsub("[^%w]", "_"))

	-- Inherit the source's groups so everything that already asks "is this water?"
	-- still gets the same answer for a puddle.
	local groups = {}
	for group, value in pairs(source_def.groups or {}) do
		groups[group] = value
	end
	groups.not_in_creative_inventory = 1
	groups.dynamic_liquid_shallow = 1

	-- If the source is palette-coloured (it is, in this game — see
	-- always_greener/scripts/water.lua) the puddles carry the same palette and take
	-- their colour from param2.  If not, they simply inherit the source's tiles and
	-- param2 goes unused.
	--
	-- We must NOT add a load-order dependency on always_greener to guarantee its
	-- override has already run: always_greener sits upstream of us through
	-- bucket -> dynamic_liquid, so depending on it closes a dependency cycle and the
	-- server refuses to start.  So handle both orders: if the source has already been
	-- given the palette, inherit it; otherwise, if always_greener is installed, use its
	-- known water palette directly (matching the same setting it keys off).  The runtime
	-- colour lookup (always_greener.water_param2) is resolved lazily either way.
	local colored = false
	local palette = nil
	if source_def.paramtype2 == "color" and source_def.palette then
		colored, palette = true, source_def.palette
	elseif minetest.get_modpath("always_greener") then
		colored = true
		palette = minetest.settings:get_bool("awg.water_color_dull", false)
			and "awg_water_colormap_2.png" or "awg_water_colormap.png"
	end

	local heights = {}
	local units_by_name = {}
	local desc = def.description or ("Shallow " .. (source_def.description or source_name))

	for u = 1, MAX_UNITS do
		local name = base .. "_" .. u
		heights[u] = name
		units_by_name[name] = u
		dynamic_liquid.shallow_units_by_name[name] = u

		minetest.register_node(name, {
			description = desc,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = colored and "color" or "none",
			palette = colored and palette or nil,
			color = colored and "#ffffff" or nil,
			node_box = {
				type = "fixed",
				fixed = {-0.5, -0.4375, -0.5, 0.5, -0.4375 + (u / MAX_UNITS), 0.5},
			},
			tiles = def.tiles or source_def.tiles,
			special_tiles = source_def.special_tiles,
			use_texture_alpha = source_def.use_texture_alpha or "blend",
			waving = source_def.waving,
			sunlight_propagates = true,
			walkable = false,
			pointable = false,
			diggable = false,
			buildable_to = true,
			-- Deliberately NOT floodable.  The engine's own liquid flow replaces a
			-- floodable node with a throwaway flowing node whenever a source turns up
			-- next to it, and that node evaporates again the moment the source moves —
			-- so every puddle the engine touched would quietly lose its water.  Marked
			-- solid to the engine, a puddle is simply left alone, and merging back into
			-- full water is handled here instead.
			floodable = false,
			is_ground_content = false,
			drop = "",
			drowning = 0,
			-- You walk and jump through a puddle, you do not swim in one.
			--
			-- The wading slowdown is NOT done with move_resistance.  That drags on the
			-- whole velocity vector, the vertical part included (clientenvironment.cpp,
			-- "Movement resistance"), and for a node that is not a real liquid the drag
			-- is not clamped by liquid_fluidity_smooth either — so it kills a jump
			-- outright.  The globalstep further down slows walking speed instead, which
			-- leaves jumping completely alone.
			liquid_move_physics = false,
			move_resistance = 0,
			post_effect_color = source_def.post_effect_color,
			groups = groups,
			sounds = source_def.sounds,
			node_placement_prediction = "",
			on_construct = function(pos)
				get_timer(pos):start(interval)
			end,
			on_timer = on_timer,
		})
	end

	-- Older worlds may still hold the previous single *leveled* puddle node, whose depth
	-- lived in param2.  DO NOT drop it — that would delete real water from existing
	-- saves.  Keep the old name registered as a lightweight legacy node so the world
	-- still loads those puddles as water, then migrate each one to the new height
	-- variants on load, reading its old level straight out of param2 so nothing is lost.
	if not registered_nodes[base] then
		minetest.register_node(base, {
			description = desc,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "leveled",
			node_box = {
				type = "leveled",
				fixed = {-0.5, -0.5, -0.5, 0.5, -0.5 + (UNIT / 64), 0.5},
			},
			leveled = UNIT,
			tiles = def.tiles or source_def.tiles,
			use_texture_alpha = source_def.use_texture_alpha or "blend",
			sunlight_propagates = true,
			walkable = false,
			pointable = false,
			diggable = false,
			buildable_to = true,
			floodable = false,
			is_ground_content = false,
			drop = "",
			drowning = 0,
			groups = {not_in_creative_inventory = 1, dynamic_liquid_shallow_legacy = 1},
		})
	end
	minetest.register_lbm({
		label = "migrate legacy shallow " .. source_name,
		name = "dynamic_liquid:migrate_" .. source_name:gsub("[^%w]", "_"),
		nodenames = {base},
		run_at_every_load = true,
		action = function(pos, node)
			-- old leveled param2 -> units (old set_level wrote units*UNIT; 0 meant the
			-- nodedef's leveled fallback, i.e. one unit).
			local lvl = (node.param2 or 0) % 128
			if lvl == 0 then lvl = UNIT end
			local units = math.floor(lvl / UNIT)
			if units < 1 then units = 1 elseif units > MAX_UNITS then units = MAX_UNITS end
			dynamic_liquid.place_shallow(pos, source_name, units)
		end,
	})

	local info = {
		source = source_name,
		colored = colored,
		heights = heights,
		units_by_name = units_by_name,
		default_color = 0,
	}
	info_by_name[source_name] = info
	for _, name in pairs(heights) do
		info_by_name[name] = info
	end
	-- Kept truthy for the movement ABM's "does this liquid thin?" gate; the value is
	-- the full-height variant, a valid node name for anyone who wants one.
	dynamic_liquid.shallow_variants[source_name] = heights[MAX_UNITS]

	return base
end

-----------------------------------------------------------------------------------------
-- Digging or building next to a puddle can open a way out for it.

local function wake_neighbours(pos)
	local x, y, z = pos.x, pos.y, pos.z
	for i = 1, 6 do
		local dir = surrounding[i]
		wake({x = x + dir.x, y = y + dir.y, z = z + dir.z})
	end
end

minetest.register_on_dignode(function(pos)
	wake_neighbours(pos)
end)

minetest.register_on_placenode(function(pos)
	wake_neighbours(pos)
end)

-----------------------------------------------------------------------------------------
-- Liquids that move around run the stranded-block check inside their movement ABM
-- (see dynamic_liquids.lua), so they need nothing here.  This is the fallback for a
-- liquid whose movement has been switched off — river water with
-- `dynamic_liquid_river_water = false`, say: a stranded block still settles into a
-- puddle, but no source ever moves, so nothing can drain.
--
-- Same trick as the movement ABM for cost: `neighbors` is the liquid's own flowing
-- form, which the engine only creates where the liquid is genuinely unsettled, so
-- a river or a lake at rest never fires this at all.
function dynamic_liquid.shallow_only_abm(source_name, flowing_name, chance)
	minetest.register_abm({
		label = "dynamic_liquid shallow " .. source_name,
		nodenames = {source_name},
		neighbors = {flowing_name},
		interval = 2,
		chance = chance or 10,
		catch_up = false,
		action = function(pos)
			-- Same rule as the movement ABM: water anywhere within one cell,
			-- diagonals included, means this is the edge of a body of water and
			-- not a stranded block.  Settling those makes a puddle that merges
			-- straight back into the water it came from, over and over.
			local px, py, pz = pos.x, pos.y, pos.z
			for y = py - 1, py + 1 do
			for x = px - 1, px + 1 do
			for z = pz - 1, pz + 1 do
				if not (x == px and y == py and z == pz) and
						get_node({x = x, y = y, z = z}).name == source_name then
					return
				end
			end
			end
			end
			dynamic_liquid.settle_as_shallow(pos, source_name)
		end,
	})
end

-- Every water type gets the same treatment, so they all behave the same way.
-- A liquid that already has a movement ABM only needs the node registering.
local function enable(source_name, flowing_name, description)
	if not registered_nodes[source_name] then return end
	if not dynamic_liquid.register_shallow(source_name, {description = description}) then
		return
	end
	if not dynamic_liquid.registered_liquids[source_name] then
		dynamic_liquid.shallow_only_abm(source_name, flowing_name)
	end
end

if minetest.get_modpath("default") then
	enable("default:water_source", "default:water_flowing", "Shallow Water")
	enable("default:river_water_source", "default:river_water_flowing", "Shallow River Water")
end

enable("sailing:shallow_water_source", "sailing:shallow_water_flowing", "Shallow Clear Water")

-----------------------------------------------------------------------------------------
-- Wading.  Walking through a puddle slows you down; jumping is untouched.
--
-- Done with the player's speed multiplier rather than the node's move_resistance,
-- because move_resistance also drags the player's vertical velocity and would eat
-- the jump (see the note on the node definition above).  The deeper the water the
-- more it slows: ankle-deep is barely noticeable, knee-deep is a real wade.

local wade_max = tonumber(minetest.settings:get("dynamic_liquid_shallow_wade")) or 0.35
local applied = {}   -- player name -> the factor we last multiplied in

local function set_wade_factor(player, name, factor)
	if math.abs((applied[name] or 1) - factor) < 0.001 then return end
	local override = player:get_physics_override()
	-- Divide our own previous factor back out first, so we compose with whatever
	-- else has changed the player's speed rather than overwriting it.
	override.speed = (override.speed / (applied[name] or 1)) * factor
	player:set_physics_override(override)
	applied[name] = factor
end

if wade_max > 0 then
	local timer = 0
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < 0.2 then return end
		timer = 0

		for _, player in ipairs(minetest.get_connected_players()) do
			local pos = player:get_pos()
			local feet = {x = pos.x, y = math.floor(pos.y + 0.5), z = pos.z}
			local name = get_node(feet).name
			local info = info_by_name[name]
			local factor = 1

			local u = info and info.units_by_name[name]
			if u then
				-- proportional to depth: 1/8 puddle barely slows, a full block slows most
				factor = 1 - (wade_max * (u / MAX_UNITS))
			end

			set_wade_factor(player, player:get_player_name(), factor)
		end
	end)

	minetest.register_on_leaveplayer(function(player)
		applied[player:get_player_name()] = nil
	end)
end

-----------------------------------------------------------------------------------------
-- Puddles in a mapblock that was unloaded mid-flow have no timer when it comes
-- back.  Restart them once on load; settled ones stop again on their first tick.
minetest.register_lbm({
	label = "dynamic_liquid shallow water resume",
	name = "dynamic_liquid:shallow_resume",
	nodenames = {"group:dynamic_liquid_shallow"},
	run_at_every_load = true,
	action = function(pos)
		get_timer(pos):start(interval)
	end,
})
