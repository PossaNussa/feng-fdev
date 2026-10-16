
--[[

  grass - biome colored grass

  (C) LGPL-2.1+ Auke Kok <sofar@foo-projects.org>

  Textures are licensed according to their respective origin
  from github.com/minetest/minetest_game, generally CC-BY-SA-4.0
  or similar.

]]--

local wp = minetest.get_worldpath() .. "/luscious"
minetest.mkdir(wp)

local mgp = minetest.get_mapgen_params()
local chunksize = 16 * mgp.chunksize

-- Palette index for a column. `p2` comes from a byte lookup into the biome map
-- and is nil whenever that lookup lands outside the stored data, so callers must
-- pass a fallback rather than let nil reach the arithmetic below.
local DEFAULT_P2 = 1

local function cmpy(p2, y)
	if not p2 then
		return DEFAULT_P2
	end
	if y > 0 then
		local h1 = p2 % 16
		local h2 = math.floor(p2 / 16) * 16

		h1 = h1 - math.max(math.min(h1, math.floor(y / 16)), 0)
		return math.max(1, h1 + h2)
	else
		return math.max(1, p2)
	end
end
local function on_construct(pos)
	-- get chunk from pos
	local v = vector.apply(pos, function(a) return math.floor((a - 48) / chunksize) end)
	local o = vector.subtract(pos, vector.apply(v, function(a) return (a * chunksize) + 48 end))
	local l = o.z * (chunksize) + o.x
	local p = minetest.hash_node_position(v)

	local f = io.open(wp .. "/" .. string.format("%d", p), "r")
	if not f then
		minetest.log("error", "unable to find map for " .. string.format("%d", p))
		return
	end

	local z = f:read("*a")
	f:close()
	local map = minetest.decompress(z)

	-- A chunk whose biome map came out empty (see the on_generated guard) has
	-- nothing to say about this column; leave the node's existing colour alone
	-- rather than repainting it with the fallback.
	local b = string.byte(map, l + 1)
	if not b then
		return
	end

	local node = minetest.get_node(pos)
	node.param2 = cmpy(b, pos.y)
	minetest.swap_node(pos, node)
end

minetest.override_item("default:dirt_with_grass", {
	paramtype2 = "color",
	drawtype = "color",
	palette_index = 136,
	color = "#7dea1eff",
	palette = "luscious_grass_palette.png",
	tiles = {"luscious_grass.png", {name = "default_dirt.png", color = "white"}, "luscious_grass.png"},
	overlay_tiles = {"", "", {name = "luscious_dirt_overlay.png", color = "white"}},
	place_param2 = 136,
	on_construct = on_construct,
})

for _, v in pairs({
	"default:leaves",
	"default:aspen_leaves",
	"default:jungleleaves",
	"default:pine_needles",
	"default:acacia_leaves",
	"default:bush_leaves",
	"default:acacia_bush_leaves",
}) do
	local def = minetest.registered_nodes[v]
	local tile, _ = def.tiles[1]:gsub("default_", "luscious_")
	minetest.override_item(v, {
		paramtype2 = "color",
		palette_index = 136,
		palette = "luscious_leaves_palette.png",
		color = "#8afb94ff",
		tiles = {tile},
		place_param2 = 136,
		on_construct = on_construct,
	})
end

minetest.register_alias_force("default:dirt_with_dry_grass", "default:dirt_with_grass")
minetest.register_alias_force("default:dirt_with_rainforest_litter", "default:dirt_with_grass")
minetest.register_alias_force("default:dirt_with_snow", "default:dirt_with_grass")

for _, v in pairs({
	"default:grass_1",
	"default:grass_2",
	"default:grass_3",
	"default:grass_4",
	"default:grass_5",
	"nettle:nettle",
	"default:dry_grass_4",
	"default:dry_grass_5",
	"default:junglegrass",
}) do
	local def = minetest.registered_nodes[v]
	local tile, _ = def.tiles[1]:gsub("dry_", ""):gsub("default_", "luscious_")
	-- No on_construct here: always_greener's mapcolors pass owns tall-grass
	-- colouring now (whole-chunk, after the biome painter, on the painted zone
	-- climate). luscious's on_construct read a per-chunk biome map file that is
	-- never written under climate_zones_v7's `nobiomes` (its on_generated bails
	-- on the empty engine heatmap), so it only error-spammed. The palette and
	-- tiles stay -- that is the gradient mapcolors indexes into.
	minetest.override_item(v, {
		paramtype2 = "color",
		palette_index = 136,
		palette = "luscious_grass_palette.png",
		color = "#7dea1eff",
		tiles = {tile},
		place_param2 = 136,
	})
end
for i = 1, 3 do
	minetest.register_alias_force("default:dry_grass_" .. i, "default:grass_" .. i)
end

-- content ids
--
-- Tall grass (grass_*, dry_grass_*, junglegrass, nettle) is deliberately absent:
-- always_greener's mapcolors pass colours it now, from the main env after the
-- biome painter, so the tufts cover the whole chunk on the painted zone climate
-- instead of the lattice this heatmap-based pass produced under `nobiomes`.
-- Only leaves remain here.
local cn = {
	["default:leaves"] = 1,
	["default:aspen_leaves"] = 1,
	["default:jungleleaves"] = 1,
	["default:pine_needles"] = 1,
	["default:acacia_leaves"] = 1,
	["default:bush_leaves"] = 1,
	["default:acacia_bush_leaves"] = 1,
}
local cs = {}
for k, _ in pairs(cn) do
	cs[minetest.get_content_id(k)] = 1
end

local warned_empty = false

minetest.register_on_generated(function(minp, maxp, blockseed)
	local v = vector.apply(minp, function(a) return (a - 48) / chunksize end)
	local heatmap = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")

	-- Both maps must be dense arrays of one entry per column. They come back
	-- empty (not nil) when the mapgen reports a zero-area chunk, and a mod that
	-- publishes its own map via gennotify can hand us a sparse one -- in which
	-- case `#` returns an arbitrary border and indexing inside it still yields
	-- nil. Writing a map file built from those would poison this chunk for
	-- on_construct forever, so bail out and leave the chunk uncoloured.
	local columns = chunksize * chunksize
	if not heatmap or not humiditymap
			or #heatmap < columns or #humiditymap < columns then
		if not warned_empty then
			warned_empty = true
			minetest.log("warning", "[luscious] mapgen heat/humidity maps are unusable" ..
				" (heatmap=" .. (heatmap and #heatmap or "nil") ..
				", humiditymap=" .. (humiditymap and #humiditymap or "nil") ..
				", expected " .. columns .. ") at minp=" .. minetest.pos_to_string(minp) ..
				" maxp=" .. minetest.pos_to_string(maxp) ..
				"; grass colouring disabled for affected chunks")
		end
		return
	end

	local parts = {}
	for i = 1, columns do
		local h1 = heatmap[i]
		local h2 = humiditymap[i]
		if not h1 or not h2 then
			if not warned_empty then
				warned_empty = true
				minetest.log("warning", "[luscious] mapgen heat/humidity maps have a" ..
					" hole at index " .. i .. " of " .. columns ..
					" at minp=" .. minetest.pos_to_string(minp) ..
					"; grass colouring disabled for affected chunks")
			end
			return
		end
		h1 = math.floor(math.min(math.max(math.floor(h1), 0), 100) / 6.6)
		h2 = math.floor(math.min(math.max(math.floor(h2), 0), 100) / 6.6)
		parts[i] = string.char(h1 + (h2 * 16))
	end
	local map = table.concat(parts)
	local p = string.format("%d", minetest.hash_node_position(v))

	local f = assert(io.open(wp .. "/" .. p, "w"), wp .. "/" .. p)
	f:write(minetest.compress(map))
	f:close()

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data()
	local p2data = vm:get_param2_data()
	for z = minp.z, maxp.z do
	for y = minp.y, maxp.y do
		local vi = area:index(minp.x, y, z)
		for x = minp.x, maxp.x do
			local vv = (x - minp.x) + ((z - minp.z) * chunksize)
			if cs[data[vi]] then
				local mv = cmpy(string.byte(map, vv + 1), y)
				p2data[vi] = mv
			end
			vi = vi + 1
		end
	end
	end
	vm:set_param2_data(p2data)
	vm:write_to_map()
end)

local function update_p2(pos, size)
	local minp = {x = pos.x - size[1], y = pos.y, z = pos.z - size[1]}
	local maxp = {x = pos.x + size[1], y = pos.y + size[2], z = pos.z + size[1]}
	for x = minp.x, maxp.x do
	for y = minp.y, maxp.y do
	for z = minp.z, maxp.z do
		local p = vector.new(x, y, z)
		local node = minetest.get_node(p)
		if cn[node.name] then
			on_construct(p)
		end
	end
	end
	end
end

local saplings = {
	["default:sapling"] = {2, 8},
	["default:junglesapling"] = {2, 17},
	["default:pine_sapling"] = {2, 14},
	["default:acacia_sapling"] = {4, 8},
	["default:aspen_sapling"] = {2, 12},
	["default:bush_sapling"] = {1, 3},
	["default:acacia_bush_sapling"] = {1, 3},
}

for k, v in pairs(saplings) do
end

