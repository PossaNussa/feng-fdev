-- craft_table/recipe_cycle.lua
-- Detects when the current craft grid can produce multiple different item outputs
-- and provides a prev/next API for cycling between alternatives.
-- Used by craft_table formspec and i3 inventory.

recipe_cycle = {}

-- Flat list of all shaped + shapeless recipes, built after all mods load.
local recipe_db = {}

-- Per-player state: name → {grid_hash=string, alts={output_string,...}, idx=number}
local player_state = {}

-- ── Helpers ───────────────────────────────────────────────────────────────────

-- get_all_craft_recipes hands back a SPARSE items table -- empty grid cells are
-- simply absent -- so `#items` stops at the first hole and undercounts. Every
-- length here has to be taken the long way round.
local function highest_index(t)
	local n = 0
	for k in pairs(t) do
		if type(k) == "number" and k > n then n = k end
	end
	return n
end

-- ── Database construction ─────────────────────────────────────────────────────

minetest.register_on_mods_loaded(function()
	local names = {}
	for name in pairs(minetest.registered_items) do
		names[#names + 1] = name
	end
	-- Sorted, so the alternatives come out in the same order every restart
	table.sort(names)

	for _, name in ipairs(names) do
		for _, rcp in ipairs(minetest.get_all_craft_recipes(name) or {}) do
			-- The craft kind is reported as `method` by the engine; accept
			-- `type` as well since mods that synthesise recipe tables use that
			-- name. Cooking and fuel recipes are not craft-grid recipes.
			local kind = rcp.method or rcp.type
			if kind == nil or kind == "normal" or kind == "shapeless" then
				local items = rcp.items or {}
				local top = highest_index(items)
				local ningredients = 0
				for i = 1, top do
					local it = items[i]
					if it and it ~= "" then
						ningredients = ningredients + 1
					end
				end
				if ningredients > 0 then
					recipe_db[#recipe_db + 1] = {
						output       = rcp.output or name,
						-- A shapeless recipe is reported with width 0. There is
						-- no "shapeless" kind string to test against.
						width        = rcp.width or 0,
						items        = items,
						top          = top,
						ningredients = ningredients,
					}
				end
			end
		end
	end

	minetest.log("action", "[craft_table] recipe cycle: indexed "
		.. #recipe_db .. " craft recipes")
end)

-- ── Item matching ─────────────────────────────────────────────────────────────

-- Returns true if a grid item name satisfies a recipe ingredient specification.
local function item_matches(gname, ritem)
	ritem = ritem or ""
	gname = gname or ""
	if ritem == "" then return gname == "" end
	if gname == "" then return false end
	if ritem:sub(1, 6) == "group:" then
		-- An ingredient may demand several groups at once, e.g. "group:wood,flammable"
		for group in ritem:sub(7):gmatch("[^,]+") do
			if minetest.get_item_group(gname, group) == 0 then
				return false
			end
		end
		return true
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
	if rw < 1 or rw > 3 then return false end
	local rh = math.ceil(rcp.top / rw)
	if rh < 1 or rh > 3 then return false end
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
	local need = {}
	for i = 1, rcp.top do
		local ri = rcp.items[i]
		if ri and ri ~= "" then
			need[#need + 1] = ri
		end
	end

	local avail = {}
	for _, n in ipairs(grid9) do
		if n ~= "" then
			avail[#avail + 1] = n
		end
	end
	if #avail ~= #need then return false end

	local used = {}
	for _, ri in ipairs(need) do
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
	local filled = 0
	for _, n in ipairs(grid9) do
		if n ~= "" then filled = filled + 1 end
	end
	if filled == 0 then return {} end

	local seen, result = {}, {}

	-- Whatever the engine itself would produce goes first, so index 1 always
	-- behaves exactly as if this mod were not installed.
	local stacks = {}
	for i = 1, 9 do
		stacks[i] = ItemStack(grid9[i])
	end
	local res = minetest.get_craft_result({
		method = "normal", width = 3, items = stacks,
	})
	if res and res.item and not res.item:is_empty() then
		seen[res.item:get_name()] = true
		result[#result + 1] = res.item:to_string()
	end

	for _, rcp in ipairs(recipe_db) do
		-- Cheap reject first: a recipe can only match if it uses exactly as
		-- many cells as the grid has filled. This runs on every grid change,
		-- so the full match must not be attempted thousands of times.
		if rcp.ningredients == filled then
			local ok
			if rcp.width == 0 then
				ok = shapeless_match(grid9, rcp)
			else
				ok = shaped_match(grid9, rcp)
			end
			if ok then
				-- Deduplicate by item name (strip count suffix)
				local out_name = rcp.output:match("^%S+")
				if out_name and not seen[out_name] then
					seen[out_name] = true
					result[#result + 1] = rcp.output
				end
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

-- InvRef:get_width returns 0 unless somebody explicitly called set_width, which
-- most mods never do. Falling back on the grid size keeps this working in a
-- plain 2×2 player inventory as well as in a craft table.
local function craft_width(craft_inv, old_craft_grid)
	local w = craft_inv and craft_inv:get_width("craft") or 0
	if not w or w < 2 or w > 3 then
		w = (#old_craft_grid <= 4) and 2 or 3
	end
	return w
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

-- ── Engine hooks ──────────────────────────────────────────────────────────────

local function current_choice(player, old_craft_grid, craft_inv)
	local st = player_state[player:get_player_name()]
	if not st or #st.alts <= 1 then return nil, st end
	-- Make sure the remembered choice still belongs to what is in the grid
	local grid9 = make_grid9(old_craft_grid, craft_width(craft_inv, old_craft_grid))
	if grid_hash(grid9) ~= st.grid_hash then return nil, st end
	return st.alts[st.idx], st
end

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	if not player or not player:is_player() then return end
	local name = player:get_player_name()
	local grid9 = make_grid9(old_craft_grid, craft_width(craft_inv, old_craft_grid))
	local h = grid_hash(grid9)
	local st = player_state[name]

	if not st or st.grid_hash ~= h then
		st = {grid_hash = h, alts = find_alts(grid9), idx = 1}
		player_state[name] = st
	end

	-- Return nothing unless we are actually substituting, so this handler
	-- never overwrites what another mod's craft_predict decided.
	if #st.alts <= 1 then return end
	local alt = st.alts[st.idx]
	if not alt then return end
	local chosen = ItemStack(alt)
	if chosen:is_empty() or chosen:get_name() == itemstack:get_name() then return end
	return chosen
end)

-- Without this the arrows only ever changed the preview: taking the item runs
-- the engine's own recipe resolution, which always hands back the first
-- matching recipe no matter what the preview showed.
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not player or not player:is_player() then return end
	local alt = current_choice(player, old_craft_grid, craft_inv)
	if not alt then return end
	local chosen = ItemStack(alt)
	if chosen:is_empty() or chosen:get_name() == itemstack:get_name() then return end
	return chosen
end)

minetest.register_on_leaveplayer(function(player)
	player_state[player:get_player_name()] = nil
end)
