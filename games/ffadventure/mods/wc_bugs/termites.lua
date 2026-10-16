-- Termites: wood rots from the inside out. Infested wood darkens through
-- four stages and then collapses into a nest, which infests what it touches.
--
-- Only the game's own trees and planks are given infested variants; that
-- keeps the node count sane and stops the mod from mangling every wood-like
-- node every other mod happens to register.

local S = wc_bugs.S

local mites = "wc_bugs_mites.png"

local sources = {
	"default:tree", "default:wood",
	"default:jungletree", "default:junglewood",
	"default:pine_tree", "default:pine_wood",
	"default:acacia_tree", "default:acacia_wood",
	"default:aspen_tree", "default:aspen_wood",
}

------------------------------------------------------------------------
-- infested variants
------------------------------------------------------------------------

-- Lay the mite speckles over whatever tiles the original node uses, at the
-- opacity for this stage.
local function speckle(tiles, opacity)
	local overlay = "(" .. mites .. "^[opacity:" .. opacity .. ")"
	local out = {}
	for i, tile in ipairs(tiles or {}) do
		local name = type(tile) == "table" and (tile.name or tile.image) or tile
		if name then
			out[i] = "(" .. name .. ")^" .. overlay
		end
	end
	if #out == 0 then
		out[1] = overlay
	end
	return out
end

local function copy_groups(groups, stage)
	local out = {}
	for k, v in pairs(groups or {}) do
		out[k] = v
	end
	out.infested = stage
	-- A stage of decay, not a building material.
	out.not_in_creative_inventory = 1
	return out
end

local stage_of = {}    -- infested node -> next stage node
local first_stage = {}  -- clean node -> stage 1 node
local infested_names = {}

local STAGES = 4

for _, source in ipairs(sources) do
	local sdef = minetest.registered_nodes[source]
	if sdef then
		local base = "wc_bugs:" .. source:gsub(":", "_") .. "_infested_"
		for stage = 1, STAGES do
			local name = base .. stage
			minetest.register_node(name, {
				description = S("Infested @1", sdef.description or source),
				drawtype = sdef.drawtype,
				tiles = speckle(sdef.tiles, stage * 52),
				paramtype = sdef.paramtype,
				paramtype2 = sdef.paramtype2,
				is_ground_content = sdef.is_ground_content,
				groups = copy_groups(sdef.groups, stage),
				sounds = sdef.sounds,
				-- Dig it out and the wood itself is still good.
				drop = source,
				on_place = sdef.on_place,
			})
			infested_names[#infested_names + 1] = name
			if stage > 1 then
				stage_of[base .. (stage - 1)] = name
			end
		end
		first_stage[source] = base .. 1
		stage_of[base .. STAGES] = "wc_bugs:mound"
	end
end

------------------------------------------------------------------------
-- the nest
------------------------------------------------------------------------
minetest.register_node("wc_bugs:mound", {
	description = S("Termite Nest"),
	tiles = {"(default_tree.png^[colorize:#3a3026:60)^(" .. mites .. ")"},
	groups = {
		choppy = 2,
		crumbly = 2,
		flammable = 3,
		infested = 5,
		falling_node = 1
	},
	drop = {
		max_items = 3,
		items = {
			{items = {"wc_bugs:termite"}},
			{items = {"wc_bugs:termite"}, rarity = 2},
			{items = {"default:stick"}, rarity = 2},
		}
	},
	sounds = default.node_sound_wood_defaults(),
})

------------------------------------------------------------------------
-- loose termites
------------------------------------------------------------------------
minetest.register_node("wc_bugs:termite", {
	description = S("Termite"),
	drawtype = "plantlike",
	tiles = {"wc_bugs_termite.png"},
	inventory_image = "wc_bugs_termite.png",
	wield_image = "wc_bugs_termite.png",
	visual_scale = 0.6,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	floodable = true,
	groups = {
		snappy = 3,
		oddly_breakable_by_hand = 3,
		bug = 1,
		termite = 1,
		crawling = 1,
		catchable = 1,
		attached_node = 1
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.15, -0.5, -0.15, 0.15, -0.2, 0.15},
	},
	sounds = default.node_sound_leaves_defaults()
})

-- A termite put next to bare wood gets straight to work.
minetest.register_abm({
	label = "Termite settles in",
	nodenames = {"wc_bugs:termite"},
	interval = 20,
	chance = 3,
	action = function(pos)
		for _, p in ipairs(minetest.find_nodes_in_area(
				vector.subtract(pos, 1), vector.add(pos, 1),
				{"group:tree", "group:wood"})) do
			local target = first_stage[minetest.get_node(p).name]
			if target then
				minetest.swap_node(p, {name = target})
				minetest.remove_node(pos)
				return
			end
		end
	end
})

------------------------------------------------------------------------
-- spread and decay
------------------------------------------------------------------------
local clean_names = {}
for name in pairs(first_stage) do
	clean_names[#clean_names + 1] = name
end

minetest.register_abm({
	label = "Termite infestation spreads",
	nodenames = clean_names,
	neighbors = {"group:infested"},
	interval = 300,
	chance = 20,
	action = function(pos, node)
		local target = first_stage[node.name]
		if target then
			minetest.swap_node(pos, {name = target})
		end
	end
})

minetest.register_abm({
	label = "Termite infestation worsens",
	nodenames = infested_names,
	interval = 300,
	chance = 15,
	action = function(pos, node)
		local target = stage_of[node.name]
		if target then
			minetest.set_node(pos, {name = target})
		end
	end
})

------------------------------------------------------------------------
local function termite_particles(pos)
	minetest.add_particlespawner({
		time = 10,
		amount = 20,
		minpos = pos,
		maxpos = pos,
		minacc = {x = -0.2, y = -0.2, z = -0.2},
		maxacc = {x = 0.2, y = 0.2, z = 0.2},
		minexptime = 2,
		maxexptime = 3,
		minsize = 0.3,
		maxsize = 0.5,
		texture = "wc_bugs_termite.png",
		collisiondetection = true,
		collision_removal = true,
	})
end

minetest.register_abm({
	label = "Termite particles",
	nodenames = {"group:infested"},
	interval = 10,
	chance = 3,
	action = termite_particles
})

------------------------------------------------------------------------
-- worldgen: a few trees start out already infested
------------------------------------------------------------------------
minetest.register_on_generated(function(minp, maxp)
	if maxp.y < -16 or minp.y > 256 then return end
	if math.random(40) ~= 1 then return end
	local found = minetest.find_nodes_in_area(minp, maxp, clean_names)
	if #found == 0 then return end
	local pos = found[math.random(#found)]
	local target = first_stage[minetest.get_node(pos).name]
	if target then
		minetest.swap_node(pos, {name = target})
	end
end)
