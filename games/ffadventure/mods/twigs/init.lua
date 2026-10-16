math.randomseed(os.time())
local S = core.get_translator("twigs")
local tree2trunk = minetest.get_modpath("tree2trunk")

function string:endswith(suffix)
	return self:sub(-#suffix) == suffix
end

-- Grouped as saplings but they grow into cacti and bamboo, neither of which
-- has anything a twig could be
local no_twigs = {
	["dynamic_trees:cactus_seedling"] = true,
	["dynamic_trees:bamboo_shoot"] = true,
}

local saplings = {}
local nodes = core.registered_nodes
for name, def in pairs(nodes) do
	if core.get_item_group(name, "sapling") > 0 and not no_twigs[name] then
		table.insert(saplings, name)
	end
end

-- A twig is built out of its sapling's texture and description, so any sapling
-- missing either of those has to be skipped rather than crash the mod
local function twiggable(def)
	if def == nil or def.groups == nil then return false end
	if type(def.description) ~= "string" or def.description == "" then return false end
	local texture = def.tiles and def.tiles[1]
	return type(texture) == "string"
end

local function make_twig(name)
	local texture = core.registered_nodes[name].tiles[1]
	local tiles = "([combine:16x16" --
	local def = table.copy(core.registered_nodes[name])
	for i = 0, 15 do
		tiles = tiles .. ": " .. (i - 8) * -1 .. "," .. i .. "=" .. texture .. "\\^[sheet\\:1x16\\:0," .. i
	end
	tiles = tiles .. ")^[transformR90"
	if name:find("pine") then
		tiles = tiles .. "^[transformFY"
	end
	-- get_translated_string can come back empty handed for some descriptions,
	-- in which case the untranslated one is still perfectly good
	local description = core.get_translated_string("en", def.description) or def.description
	def.description = description:gsub("Sapling", "Twig")
	def.description = S(def.description)
	def.inventory_image = tiles
	def.drawtype = "torchlike"
	def.paramtype2 = "wallmounted"
	def.tiles = { tiles }
	def.groups["dig_immediate"] = nil
	def.groups["snappy"] = 3
	def.groups["twig"] = 1
	def.on_construct = table.copy(core.registered_nodes["default:stone"].on_construct)
	def.on_place = table.copy(core.registered_nodes["default:stone"].on_place)
	def.on_timer = table.copy(core.registered_nodes["default:stone"].on_timer)
	def.drop = "default:stick"
	core.register_node("twigs:" .. name:gsub("sapling", "twig"):match(":(.+)"), def)
end

for _, name in pairs(saplings) do
	if not twiggable(core.registered_nodes[name]) then
		core.log("info", "[twigs] skipping sapling without a usable texture "
			.. "or description: " .. name)
	else
		-- one badly behaved sapling from some other mod must not take the
		-- whole game down with it
		local ok, err = pcall(make_twig, name)
		if not ok then
			core.log("warning", "[twigs] could not build a twig for " .. name
				.. ": " .. tostring(err))
		end
	end
end

-- Map tree node IDs to twig node IDs
local cids = {}
core.register_on_mods_loaded(function()
	for name, def in pairs(core.registered_nodes) do
		local twig
		if tree2trunk then
			if core.get_item_group(name, "trunk") > 0 and name:endswith("trunk") then
				twig = "twigs:" .. name:gsub("trunk", "twig"):match(":(.+)")
			end
		else
			if core.get_item_group(name, "tree") > 0 and name:endswith("tree") then
				twig = "twigs:" .. name:gsub("tree", "twig"):match(":(.+)")
			end
		end
		-- a tree whose sapling could not be turned into a twig simply grows none
		if twig and core.registered_nodes[twig] then
			cids[core.get_content_id(name)] = core.get_content_id(twig)
		end
	end
end)
local place_on = {}
local spawn_by = {}
if tree2trunk then
	place_on = { "group:soil", "group:trunk" }
	spawn_by = { "group:trunk" }
else
	place_on = { "group:soil", "group:tree" }
	spawn_by = { "group:tree" }
end
abdecor.register_advanced_decoration("twigs_mapgen", {
	target = {
		place_on = place_on,
		spawn_by = spawn_by,
		num_spawn_by = 1,
		fill_ratio = 0.8,
		y_min = 1,
		y_max = 31000,
		flags = "all_floors", -- needed to prevent mapgen marker nodes from abdecor from overwriting tree trunks
	},
	fn = function(mapgen)
		-- Get provided mapgen values
		local pos = mapgen.pos
		local va = mapgen.voxelarea
		local vdata = mapgen.data
		local vparam2 = mapgen.param2

		-- Get stride values and adjust position
		local zstride = va.zstride
		pos = va:index(pos.x, pos.y + (math.abs(pos.x + pos.z) % 4 + 3), pos.z) -- randomize y value based on x/z values, consistent mapgen for any given coordinate
		-- TODO: Use PcgRandom instead of weird y offset calculation for more randomy randomness

		-- List of cardinal directions adjacent to decoration position
		local cardinal = {
			1,
			-1,
			zstride,
			-zstride,
		}

		-- Look for tree node in each cardinal direction
		for i = 1, 4 do -- TODO: Iterate in random order for less predictable twigs in some situations
			local treepos = pos + cardinal[i] -- look in the current direction for a tree
			local twig = cids[vdata[treepos]] -- attempt to look up the twig for the found tree type
			if twig then -- we found a valid tree/twig, set current position to twig with appropriate param2
				-- Ensure that the current position is air, we don't want twigs to overwrite leaves or anything else in the mapgen
				if vdata[pos] ~= core.CONTENT_AIR then
					return
				end
				vdata[pos] = twig
				vparam2[pos] = i + 1
			end
		end
	end,
	flags = {
		param2 = true, -- param2 manipulation requires param2 flag in order to load param2 data for each chunk in which this decoration is placed
	},
})

if core.get_modpath("dynamic_trees") then
	dofile(core.get_modpath("twigs") .. "/dynamic_trees.lua")
end

-- Treeless cold biomes get sparse deadfall, since the decoration above needs a
-- tree to stand next to and the arctic has none. Loaded last so its
-- on_mods_loaded runs after the twig nodes above exist.
dofile(core.get_modpath("twigs") .. "/deadfall.lua")
