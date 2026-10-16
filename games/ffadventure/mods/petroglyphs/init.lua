-- Petroglyphs
-- Original mod and glyphs 1-7 Copyright 2024 Neuromancer
--
-- Marks pecked and painted into rock faces.  Every stone in the strata can
-- carry them; the pigment is picked per rock so a pale mark sits on dark
-- stone and a dark one on pale stone, the way it works on a real wall.

petroglyphs = {}

local modpath = minetest.get_modpath("petroglyphs")

-- Show every rock's set in the creative inventory.  Off by default: with the
-- full strata that is several hundred entries, so only the desert stone set
-- is listed and the rest are found in the world.
local CREATIVE_ALL = minetest.settings:get_bool("petroglyphs_all_in_creative", false)
local CREATIVE_STONE = "default:desert_stone"

---------------------------------------------------------------------------
-- Glyphs
---------------------------------------------------------------------------
--
-- Each glyph is a white mask with an alpha channel; the pigment colour is
-- applied at load time with [colorize.  Adding one means dropping in
-- petroglyphs_glyph_NN.png and extending this list.

petroglyphs.glyphs = {
	"Lizard", "Horned Figure", "Wandering Line", "Spiral", "Handprint",
	"Hunting Hound", "Weathered Mark",
	"Labyrinth", "Rings", "Rayed Sun", "Crewed Boat", "Bighorn Ram",
	"Bowman", "Great Bird", "Dancers", "Serpent",
	"Runic Lintel", "Runic Inscription", "Helm of Awe", "Bind-Rune",
	"Boundary Stave", "Cut Runes",
	"Trident", "Lotus", "Wheel of Law", "Sacred Syllable", "Elephant",
	"Humped Bull", "Seal Script",
	"Ankh", "Watching Eye", "Scarab", "Cartouche", "Winged Disc",
	"Raven", "Orca", "Salmon", "Flute Player", "Mask", "Bear's Paw",
	"Two Suns", "The Walker",
}

petroglyphs.glyph_count = #petroglyphs.glyphs

-- Whoever cut a panel cut it in one hand.  A region picks a culture and its
-- panels stay in that style, so travelling far enough changes what you find.
petroglyphs.cultures = {
	{ name = "archaic",  first =  1, last = 16, weight = 40 },
	{ name = "runic",    first = 17, last = 22, weight = 16 },
	{ name = "vedic",    first = 23, last = 29, weight = 15 },
	{ name = "nilotic",  first = 30, last = 34, weight = 14 },
	{ name = "northern", first = 35, last = 40, weight = 15 },
}

-- These two belong to nobody.  They turn up as single marks inside somebody
-- else's panel, which is the unsettling part.
petroglyphs.anomalies = { 41, 42 }

---------------------------------------------------------------------------
-- Rock faces
---------------------------------------------------------------------------
--
-- Every stratum from default/ugrnd.lua plus the surface rocks.  The pigment
-- is chosen against the rock's own tone: pale where the mark was pecked
-- through a dark patina, dark ochre or charcoal where it was painted onto
-- pale stone.

petroglyphs.stones = {
	{ node = "default:stone",         pigment = "#cfc2a8" },
	{ node = "default:desert_stone",  pigment = "#7c3a20" },
	{ node = "default:sandstone",     pigment = "#7c3a20" },
	{ node = "default:limestone",     pigment = "#3a3330" },
	{ node = "default:shale",         pigment = "#c9c0b0" },
	{ node = "default:slate",         pigment = "#bfc6cc" },
	{ node = "default:schist",        pigment = "#d6cf9e" },
	{ node = "default:saprolite",     pigment = "#d5c4ae" },
	{ node = "default:granite",       pigment = "#6e3520" },
	{ node = "default:gneiss",        pigment = "#c8c8c8" },
	{ node = "default:marble",        pigment = "#33302c" },
	{ node = "default:quartz",        pigment = "#3a3a3a" },
	{ node = "default:onyx",          pigment = "#d0d0d0" },
	{ node = "default:obsidian",      pigment = "#cdd0e0" },
	{ node = "default:mantle",        pigment = "#d8cf8a" },
	{ node = "default:pumice",        pigment = "#4a463c" },
	-- optional; skipped in silence if the mod is not enabled
	{ node = "badlands:red_sandstone", pigment = "#e8d9c0" },
}

---------------------------------------------------------------------------
-- Registration
---------------------------------------------------------------------------

-- Side texture of the parent rock, whatever shape its tiles table takes.
local function side_texture(def)
	local tiles = def and def.tiles
	if type(tiles) == "string" then
		return tiles
	end
	if type(tiles) ~= "table" then
		return nil
	end
	local tile = tiles[3] or tiles[1]
	if type(tile) == "string" then
		return tile
	end
	if type(tile) == "table" then
		return tile.name
	end
	return nil
end

local touched = {}

-- A glyph answers when you put a hand on it.  No message, just the sound.
local function touch(pos, node, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local pname = clicker:get_player_name()
	local now = minetest.get_us_time() / 1000000
	if touched[pname] and now - touched[pname] < 6 then
		return
	end
	touched[pname] = now

	local def = minetest.registered_nodes[node.name]
	local glyph = (def and def._petroglyph_glyph) or 1
	minetest.sound_play("petroglyph" .. (((glyph - 1) % 7) + 1), {
		pos = pos,
		to_player = pname,
		gain = 0.7,
		max_hear_distance = 12,
	}, true)
end

minetest.register_on_leaveplayer(function(player)
	touched[player:get_player_name()] = nil
end)

for _, stone in ipairs(petroglyphs.stones) do
	local parent = minetest.registered_nodes[stone.node]
	local base = side_texture(parent)
	if not parent then
		minetest.log("info", "[petroglyphs] no such rock: " .. stone.node)
	elseif not base then
		minetest.log("warning", "[petroglyphs] cannot read tiles of " .. stone.node)
	else
		stone.short = stone.node:match(":(.+)$")
		local rock_name = parent.description or stone.short

		for i = 1, petroglyphs.glyph_count do
			local id = string.format("%02d", i)
			-- ratio "alpha" keeps the mask's own alpha and takes only the
			-- pigment's RGB, so the mark weathers into the rock at its edges
			local mark = "(petroglyphs_glyph_" .. id .. ".png^[colorize:"
				.. stone.pigment .. "ff:alpha)"
			local face = base .. "^" .. mark

			local groups = table.copy(parent.groups or { cracky = 3, stone = 1 })
			groups.petroglyph = 1
			if not CREATIVE_ALL and stone.node ~= CREATIVE_STONE then
				groups.not_in_creative_inventory = 1
			end

			minetest.register_node("petroglyphs:" .. stone.short .. "_" .. id, {
				description = petroglyphs.glyphs[i] .. " Petroglyph (" .. rock_name .. ")",
				-- tiles are +Y, -Y, +X, -X, +Z, -Z; the mark is on the front
				-- face (-Z) and 4dir turns it to look at open air
				tiles = { base, base, base, base, base, face },
				paramtype2 = "4dir",
				is_ground_content = false,
				groups = groups,
				sounds = parent.sounds,
				_petroglyph_glyph = i,
				_petroglyph_stone = stone.node,
				on_rightclick = touch,
			})
		end
	end
end

-- The old mod registered seven desert-stone nodes with no rock in the name.
for i = 1, 7 do
	minetest.register_alias("petroglyphs:petroglyph" .. i,
		"petroglyphs:desert_stone_" .. string.format("%02d", i))
end

dofile(modpath .. "/mapgen.lua")
dofile(modpath .. "/commands.lua")
