-- Lodewurms: iron-scaled worms that chew tunnels through rock, growing on
-- what they eat and voiding lumps of iron behind them. Ported from the
-- nodecore version's nc_snakes-derived behaviour (kimapr), with the
-- body-support flood fill replaced by a cheaper rule and the search radius
-- brought down to something a general-purpose server can carry.

local S = wc_bugs.S

local HEAD = "wc_bugs:wurm_head"
local BODY = "wc_bugs:wurm_body"
local HEAD_ORE = "wc_bugs:wurm_head_ore"
local BODY_ORE = "wc_bugs:wurm_body_ore"

local POOP_ITEM = "default:iron_lump"
local RUBBLE = "default:cobble"      -- what a severed segment collapses into
local STEP_TIME = 2                  -- seconds between moves
local MAX_LEN = 10                   -- segments behind the head
local SEARCH_R = 4                   -- how far ahead it sniffs for food
local BITE_DAMAGE = 3

local SIDES = {
	{x = 0, y = -1, z = 0}, {x = 0, y = 1, z = 0},
	{x = 1, y = 0, z = 0}, {x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1}, {x = 0, y = 0, z = -1},
}

------------------------------------------------------------------------
-- what a wurm will eat
------------------------------------------------------------------------

-- Returns food value and poop value, or nil if the node is not edible.
local function eatable(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then return end

	local def = minetest.registered_nodes[node.name]
	if not def then return end

	if def.buildable_to then
		-- Air and plants: passable, but no meal. It only moves into open
		-- space that touches something solid, so it crawls along walls
		-- rather than swimming across caverns.
		for _, dir in ipairs(SIDES) do
			local d = minetest.registered_nodes[
				minetest.get_node(vector.add(pos, dir)).name]
			if d and d.walkable and not d.buildable_to then
				return 0, 0.001
			end
		end
		return
	end

	if def.diggable == false then return end
	if def.is_ground_content == false then return end  -- player-made: off menu
	if minetest.get_item_group(node.name, "bug") > 0 then return end
	if minetest.get_item_group(node.name, "water") > 0 then return end
	if minetest.get_item_group(node.name, "lava") > 0 then return end
	if minetest.get_item_group(node.name, "unbreakable") > 0 then return end
	if minetest.is_protected(pos, "") then return end

	if node.name == "default:stone_with_iron" then
		return 1, 1 / 8
	end
	if minetest.get_item_group(node.name, "ore") > 0 then
		return 1, 1 / 16
	end

	local soft = 1 / 9
	if minetest.get_item_group(node.name, "crumbly") > 0
	or minetest.get_item_group(node.name, "cracky") > 0 then
		return soft, soft / 0.5
	end
end

wc_bugs.wurm_eatable = eatable

------------------------------------------------------------------------
-- where a wurm would rather be
------------------------------------------------------------------------
local function attractiveness(pos)
	local f = eatable(pos)
	if not f then return 0 end
	return (f * f) * 100
end

-- Sum the attractiveness of everything within SEARCH_R of pos, weighted by
-- distance, flattened vertically so it prefers to stay on a level. `cache`
-- is shared between the candidates of one step, so the overlapping parts of
-- those volumes are only scored once.
local function survey(pos, cache)
	local r = SEARCH_R
	local score = 0
	for x = pos.x - r, pos.x + r do
		for y = pos.y - r, pos.y + r do
			for z = pos.z - r, pos.z + r do
				local dx, dy, dz = x - pos.x, (y - pos.y) * 0.6, z - pos.z
				local d = dx * dx + dy * dy + dz * dz
				if d > 0 then
					d = d ^ 0.5
					if r - d > 0 then
						local p = {x = x, y = y, z = z}
						local h = minetest.hash_node_position(p)
						local v = cache[h]
						if not v then
							v = attractiveness(p)
							cache[h] = v
						end
						score = score + v * ((r - d) / r) ^ 1.5
					end
				end
			end
		end
	end
	score = score + (eatable(pos) or 0) * 10000
	return -score
end

------------------------------------------------------------------------
-- movement
------------------------------------------------------------------------
local function eat_sound(pos)
	local def = minetest.registered_nodes[minetest.get_node(pos).name]
	if def and def.sounds and def.sounds.dug then
		minetest.sound_play(def.sounds.dug,
			{pos = pos, gain = 1.0, max_hear_distance = 24}, true)
	end
end

local function bite(pos)
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, 1.2)) do
		if obj:is_player() then
			obj:punch(obj, 1.0, {
				full_punch_interval = 1.0,
				damage_groups = {fleshy = BITE_DAMAGE}
			})
		end
	end
end

local function step(pos, node)
	local meta = minetest.get_meta(pos)
	local len = meta:get_int("snake_len")

	-- Walk the body chain. A missing link means somebody dug the wurm in
	-- half; everything past the break falls in as rubble.
	local body = {{pos = pos, node = node}}
	local cut = false
	for n = 1, len do
		local bpos = minetest.string_to_pos(meta:get_string("snake_body" .. n))
		if bpos then
			local bnode = minetest.get_node(bpos)
			if bnode.name == "ignore" then
				return pos  -- part of it is unloaded; wait for the map
			end
			if minetest.get_item_group(bnode.name, "snake_body") == 0 then
				cut = true
				len = n - 1
				meta:set_int("snake_len", len)
			end
			if not cut then
				body[#body + 1] = {pos = bpos, node = bnode}
			elseif minetest.get_item_group(bnode.name, "snake_body") > 0 then
				minetest.set_node(bpos, {name = RUBBLE})
			end
		end
	end

	local occupied = {}
	for _, seg in ipairs(body) do
		occupied[minetest.hash_node_position(seg.pos)] = true
	end

	local food = meta:get_float("snake_food")
	local poop = meta:get_float("snake_poop")

	-- Candidates: the four horizontal facings, plus straight up, down and
	-- dead ahead. Turning is free, so it picks purely by smell.
	local facing = node.param2 % 4
	local candidates = {}
	for n = 0, 3 do
		candidates[#candidates + 1] = {
			dir = n,
			pos = vector.add(pos, minetest.facedir_to_dir(n))
		}
	end
	for _, d in ipairs({{x = 0, y = 1, z = 0}, {x = 0, y = -1, z = 0},
			minetest.facedir_to_dir(facing)}) do
		candidates[#candidates + 1] = {dir = facing, pos = vector.add(pos, d)}
	end

	local cache = {}
	local best, best_score
	for _, cand in ipairs(candidates) do
		if not occupied[minetest.hash_node_position(cand.pos)] then
			local f, p = eatable(cand.pos)
			if f then
				local score = survey(cand.pos, cache)
					+ math.random() * 0.2 - 0.1
				if not best_score or score < best_score then
					best_score = score
					best = {pos = cand.pos, dir = cand.dir, food = f, poop = p}
				end
			end
		end
	end

	if not best then return pos end

	food = food + best.food
	poop = poop + best.poop
	eat_sound(best.pos)

	local def = minetest.registered_nodes[node.name]
	local headname = def.alternative_head or HEAD
	local bodyname = def.alternative_body or BODY

	-- Head becomes the first body segment; the new head takes the meal.
	minetest.set_node(pos, {name = bodyname})
	minetest.set_node(best.pos, {name = headname, param2 = best.dir})
	bite(best.pos)

	local trail = {}
	for i, seg in ipairs(body) do
		trail[i] = seg.pos
	end

	-- Grow while there is food in the belly, otherwise shed the tail and
	-- leave the tunnel behind.
	if food >= 1 and #trail < MAX_LEN then
		food = food - 1
	else
		local tailpos = trail[#trail]
		local tailnode = minetest.get_node(tailpos)
		trail[#trail] = nil
		minetest.set_node(tailpos, {name = "air"})
		if minetest.get_item_group(tailnode.name, "snake_poop") > 0 then
			minetest.add_item(tailpos, POOP_ITEM)
		end
	end

	-- A full gut turns the segment right behind the head into the loaded
	-- variant, which is what eventually drops the iron.
	if poop >= 1 and trail[1]
	and minetest.get_item_group(
			minetest.get_node(trail[1]).name, "snake_poop") == 0 then
		poop = poop - 1
		minetest.set_node(trail[1], {name = BODY_ORE})
	end

	local nmeta = minetest.get_meta(best.pos)
	for i = 1, #trail do
		nmeta:set_string("snake_body" .. i, minetest.pos_to_string(trail[i]))
	end
	nmeta:set_int("snake_len", #trail)
	nmeta:set_float("snake_food", food)
	nmeta:set_float("snake_poop", poop)
	nmeta:set_int("snake_gen", 1)

	return best.pos
end

local function wurm_timer(pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "snake_head") == 0 then
		return false
	end
	local newpos = step(pos, node)
	minetest.get_node_timer(newpos):start(STEP_TIME)
	return false
end

------------------------------------------------------------------------
-- nodes
------------------------------------------------------------------------
local dark = "default_steel_block.png^[colorize:#0a0a12:150"
local scale = "(default_steel_block.png^[colorize:#c86400:90)" ..
	"^[mask:wc_bugs_pattern_scales.png"
local scale_ore = "(default_steel_block.png^[colorize:#ffb020:90)" ..
	"^[mask:wc_bugs_pattern_scales.png"
local maw = "(default_steel_block.png^[colorize:#ff3000:140)" ..
	"^[mask:wc_bugs_mask_wurm.png"

local function register_wurm(head, body, tile, glow, extra_groups)
	local groups = {
		cracky = 2,
		bug = 1,
		wurm = 1,
		metallic = 1,
		snake_body = 1,
		not_in_creative_inventory = 1
	}
	for k, v in pairs(extra_groups or {}) do
		groups[k] = v
	end

	local common = {
		tiles = {tile, tile, tile, tile, tile, tile},
		drop = RUBBLE,
		light_source = glow,
		is_ground_content = false,
		sounds = default.node_sound_metal_defaults(),
		alternative_head = head,
		alternative_body = body,
	}

	local hdef = table.copy(common)
	hdef.description = S("Lodewurm Head")
	hdef.paramtype2 = "facedir"
	-- Tile 5 is the front face, which faces the way it is travelling.
	hdef.tiles = {tile, tile, tile, tile, tile .. "^(" .. maw .. ")", tile}
	hdef.groups = table.copy(groups)
	hdef.groups.snake_head = 1
	hdef.on_timer = wurm_timer
	minetest.register_node(head, hdef)

	local bdef = table.copy(common)
	bdef.description = S("Lodewurm Body")
	bdef.groups = groups
	minetest.register_node(body, bdef)
end

register_wurm(HEAD, BODY, "(" .. dark .. ")^(" .. scale .. ")", 2)

-- The loaded variant: a segment carrying a lump of iron, which drops when
-- that segment is finally shed.
register_wurm(HEAD_ORE, BODY_ORE, "(" .. dark .. ")^(" .. scale_ore .. ")", 4,
	{snake_poop = 1})

-- Wurms loaded from disk that lost their node timer would sit frozen.
minetest.register_lbm({
	name = "wc_bugs:wurm_wake",
	nodenames = {"group:snake_head"},
	run_at_every_load = true,
	action = function(pos)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(STEP_TIME)
		end
	end
})

------------------------------------------------------------------------
function wc_bugs.hatch_wurm(pos)
	minetest.set_node(pos, {name = HEAD, param2 = math.random(0, 3)})
	local meta = minetest.get_meta(pos)
	meta:set_int("snake_len", 0)
	meta:set_int("snake_gen", 1)
	meta:set_float("snake_food", 2)
	minetest.get_node_timer(pos):start(STEP_TIME)
	minetest.sound_play("default_break_glass",
		{pos = pos, gain = 0.6, max_hear_distance = 24}, true)
	wc_bugs.smokeburst(pos, 8)
end

------------------------------------------------------------------------
-- eggs
------------------------------------------------------------------------
local egg_tile = "(default_steel_block.png^[colorize:#2a2118:150)^(" ..
	"(default_steel_block.png^[colorize:#c8a020:90)" ..
	"^[mask:wc_bugs_pattern_egg.png)"

minetest.register_node("wc_bugs:wurm_egg", {
	description = S("Lodewurm Egg"),
	tiles = {egg_tile},
	groups = {cracky = 3, wurm_egg = 1},
	is_ground_content = true,
	sounds = default.node_sound_metal_defaults(),
	-- Cracking one open is how you meet a wurm.
	on_dig = function(pos)
		wc_bugs.hatch_wurm(pos)
		return true
	end
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "wc_bugs:wurm_egg",
	wherein = {"default:stone"},
	random_factor = 0,
	noise_params = {
		offset = 0,
		scale = 4,
		spread = {x = 64, y = 64, z = 64},
		seed = 72031,
		octaves = 4,
		persist = 0.5,
		flags = "eased",
	},
	noise_threshold = 0.9,
	y_max = -128,
	y_min = -31000,
	clust_num_ores = 1,
	clust_size = 1,
	clust_scarcity = 8 * 8 * 8 * 4
})
