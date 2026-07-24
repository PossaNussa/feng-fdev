-- craft_table/recipe_cycle.lua
-- Detects when the current craft grid can produce multiple different item outputs
-- and provides a prev/next API for cycling between alternatives.
-- Used by craft_table formspec and i3 inventory.

recipe_cycle = {}

-- Flat list of all shaped + shapeless recipes, built after all mods load.
local recipe_db = {}

-- Per-player state: name → {grid_hash=string, alts={output_string,...}, idx=number}
local player_state = {}

-- ── Database construction ─────────────────────────────────────────────────────

minetest.register_on_mods_loaded(function()
	for name in pairs(minetest.registered_items) do
		local recipes = minetest.get_all_craft_recipes(name)
		if recipes then
			for _, rcp in ipairs(recipes) do
				if rcp.type == "normal" or rcp.type == "shapeless" then
					table.insert(recipe_db, {
						output = rcp.output or name,
						type   = rcp.type,
						width  = rcp.width or 0,
						items  = rcp.items or {},
					})
				end
			end
		end
	end
end)

-- ── Item matching ─────────────────────────────────────────────────────────────

-- Returns true if a grid item name satisfies a recipe ingredient specification.
local function item_matches(gname, ritem)
	ritem = ritem or ""
	gname = gname or ""
	if ritem == "" then return gname == "" end
	if gname == "" then return false end
	if ritem:sub(1, 6) == "group:" then
		return minetest.get_item_group(gname, ritem:sub(7)) > 0
	end
	return gname == ritem
end

-- Try to match a shaped recipe in the 3×3 grid at one specific offset.
local function shaped_at(grid9, items, rw, rh, dx, dy)
	for gy = 0, 2 do
		for gx = 0, 2 do
			local gname = grid9[gy * 3 + gx + 1] or ""
			local rx, ry = gx - dx, gy - dy
			if rx >= 0 and rx < rw and ry >= 0 and ry < rh then
				if not item_matches(gname, items[ry * rw + rx + 1]) then
					return false
				end
			elseif gname ~= "" then
				return false
			end
		end
	end
	return true
end

local function shaped_match(grid9, rcp)
	local rw = rcp.width
	if rw == 0 then return false end
	local rh = math.ceil(#rcp.items / rw)
	if rh == 0 then return false end
	for dy = 0, 3 - rh do
		for dx = 0, 3 - rw do
			if shaped_at(grid9, rcp.items, rw, rh, dx, dy) then
				return true
			end
		end
	end
	return false
end

local function shapeless_match(grid9, rcp)
	local avail = {}
	for _, n in ipairs(grid9) do
		if n ~= "" then
			table.insert(avail, n)
		end
	end
	if #avail ~= #rcp.items then return false end
	local used = {}
	for _, ri in ipairs(rcp.items) do
		local found = false
		for j, gi in ipairs(avail) do
			if not used[j] and item_matches(gi, ri) then
				used[j] = true
				found = true
				break
			end
		end
		if not found then return false end
	end
	return true
end

-- ── Grid helpers ──────────────────────────────────────────────────────────────

local function grid_hash(grid9)
	return table.concat(grid9, "|")
end

-- Find all distinct output item strings whose recipes match grid9.
local function find_alts(grid9)
	local any = false
	for _, n in ipairs(grid9) do
		if n ~= "" then any = true; break end
	end
	if not any then return {} end

	local seen, result = {}, {}
	for _, rcp in ipairs(recipe_db) do
		local ok
		if rcp.type == "normal" then
			ok = shaped_match(grid9, rcp)
		else
			ok = shapeless_match(grid9, rcp)
		end
		if ok then
			-- Deduplicate by item name (strip count suffix)
			local out_name = rcp.output:match("^%S+")
			if out_name and not seen[out_name] then
				seen[out_name] = true
				table.insert(result, rcp.output)
			end
		end
	end
	return result
end

-- Build a 3×3 grid9 from old_craft_grid ItemStack array and craft width.
local function make_grid9(old_craft_grid, width)
	local grid9 = {"","","","","","","","",""}
	if width == 3 then
		for i = 1, math.min(9, #old_craft_grid) do
			grid9[i] = old_craft_grid[i] and old_craft_grid[i]:get_name() or ""
		end
	elseif width == 2 then
		-- 2×2 placed in the top-left corner of the 3×3
		local src_to_dst = {1, 2, 4, 5}
		for k = 1, 4 do
			local si = k
			if old_craft_grid[si] then
				grid9[src_to_dst[k]] = old_craft_grid[si]:get_name()
			end
		end
	end
	return grid9
end

-- ── Public API ────────────────────────────────────────────────────────────────

-- Force-refresh the player's cycle state for the given 3×3 grid9 array of
-- item name strings (call this from on_rightclick after loading items).
function recipe_cycle.refresh(player, grid9)
	local name = player:get_player_name()
	local h = grid_hash(grid9)
	local st = player_state[name]
	if not st or st.grid_hash ~= h then
		player_state[name] = {grid_hash = h, alts = find_alts(grid9), idx = 1}
	end
end

-- Return the current state table (or nil if not yet computed).
-- Fields: alts={output_string,...}, idx=number, grid_hash=string
function recipe_cycle.get_state(player)
	return player_state[player:get_player_name()]
end

-- Advance the selected alternative; dir = 1 (next) or -1 (prev).
function recipe_cycle.cycle(player, dir)
	local st = player_state[player:get_player_name()]
	if not st or #st.alts <= 1 then return end
	local n = #st.alts
	st.idx = ((st.idx - 1 + dir) % n) + 1
end

-- ── craft_predict hook ────────────────────────────────────────────────────────

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	local name = player:get_player_name()
	local width = craft_inv:get_width("craft")
	local grid9 = make_grid9(old_craft_grid, width)
	local h = grid_hash(grid9)
	local st = player_state[name]

	if not st or st.grid_hash ~= h then
		local alts = find_alts(grid9)
		st = {grid_hash = h, alts = alts, idx = 1}
		player_state[name] = st
	end

	if #st.alts <= 1 then return itemstack end
	local alt = st.alts[st.idx]
	return alt and ItemStack(alt) or itemstack
end)

minetest.register_on_leaveplayer(function(player)
	player_state[player:get_player_name()] = nil
end)
