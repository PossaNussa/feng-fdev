-- The country a village stands in.
--
-- Villagers could not see out of their own front door. Somebody living on the
-- flank of a named volcano had nothing to say about it; somebody on a coast had
-- nothing to say about the sea. The world this game generates is the most
-- interesting thing in it and none of it reached the people standing in it.
--
-- The rule from traits.lua is the whole design here: **a topic exists only if
-- the thing it is about exists.** Nobody is asked about the mountain if there
-- is no mountain. Everything below is either read off the map with the same
-- calls a player could make, or read out of another mod's own generator -- so
-- the volcano a villager names is the volcano that is there, under the name
-- that mod gave it, in the state that mod says it is in.
--
-- The survey is per village, not per villager, and cached: it is a handful of
-- node lookups and a ring of surface probes, and everybody in one settlement is
-- looking at the same horizon.

local util = village_life.util
local home = village_life.home

local land = {}
village_life.land = land

--------------------------------------------------------------------------------
-- Directions and distances, as a person would give them
--------------------------------------------------------------------------------

local COMPASS = {
	"north", "north-east", "east", "south-east",
	"south", "south-west", "west", "north-west",
}

function land.bearing(from, to)
	local dx, dz = to.x - from.x, to.z - from.z
	if dx * dx + dz * dz < 1 then return "right here" end
	-- Engine convention: +Z is north. Sixteenths of a turn, so the boundary
	-- falls in the middle of each named sector rather than on its edge.
	local a = math.atan2(dx, dz)
	local i = math.floor((a / (math.pi / 4)) + 0.5) % 8
	return COMPASS[i + 1]
end

-- Nobody says "eight hundred and twelve nodes". A day's walk is the unit a
-- person who has actually made the journey would use.
function land.distance_phrase(d)
	if d < 40 then return "a stone's throw" end
	if d < 120 then return "a short walk" end
	if d < 300 then return "half a morning's walk" end
	if d < 700 then return "the better part of a day" end
	if d < 1500 then return "a day and a half, if the weather holds" end
	return "further than I've ever been"
end

--------------------------------------------------------------------------------
-- Climate, in words
--------------------------------------------------------------------------------

-- Biome names are internal ids ("snowy_grassland", "naturalbiomes:alpine").
-- Strip the mod prefix and the underscores and they read as English almost
-- always, which is better than a hand-written table of two hundred entries
-- that goes stale the moment somebody installs another biome mod.
function land.biome_name(pos)
	if not minetest.get_biome_data then return end
	local data = minetest.get_biome_data(pos)
	if not data or not data.biome then return end
	local name = minetest.get_biome_name and minetest.get_biome_name(data.biome)
	if not name then return end
	name = name:gsub("^[%w_]+:", ""):gsub("_", " ")
	if name == "" then return end
	return name, data
end

-- Heat and humidity are the two axes the whole biome grid is laid out on, so
-- they are the honest way to say what the weather is like here without
-- pretending to know more than the map does.
local function climate_phrase(heat, humidity)
	local warmth
	if heat < 15 then warmth = "bitter"
	elseif heat < 35 then warmth = "cold"
	elseif heat < 55 then warmth = "temperate"
	elseif heat < 75 then warmth = "warm"
	else warmth = "hot" end

	local wet
	if humidity < 20 then wet = "and dry as a bone"
	elseif humidity < 40 then wet = "and dry"
	elseif humidity < 62 then wet = ""
	elseif humidity < 82 then wet = "and wet"
	else wet = "and wet through half the year" end

	if wet == "" then return warmth end
	return warmth .. " " .. wet
end

--------------------------------------------------------------------------------
-- The survey
--------------------------------------------------------------------------------

-- How far a villager's own eyes reach for the physical checks. Larger than the
-- village so the fields and the treeline count, small enough that this is a
-- handful of node lookups.
local LOOK = 48

-- The ring of surface probes that decides whether this is a plain or a valley.
local RELIEF_RING = 40
local RELIEF_SAMPLES = 12

-- How far the surface is searched for, up and down, from the village floor.
local SURFACE_SPAN = 40

local surveys = {}

-- The ground height at x,z, or nil if that column is not loaded. Walks down
-- from well above the village floor, so a village in a valley still finds the
-- hilltops around it.
local function surface_y(x, z, base)
	local air = nil
	for y = base + SURFACE_SPAN, base - SURFACE_SPAN, -1 do
		local node = minetest.get_node_or_nil({x = x, y = y, z = z})
		if not node then return end
		local def = minetest.registered_nodes[node.name]
		if def and def.walkable then
			-- Only count it as ground if there was open air above it, or a
			-- cave roof reads as the surface.
			if air then return y end
		else
			air = true
		end
	end
end

local function survey_relief(centre)
	local highest, lowest, found = nil, nil, 0
	for i = 1, RELIEF_SAMPLES do
		local a = (i / RELIEF_SAMPLES) * math.pi * 2
		local y = surface_y(
				math.floor(centre.x + math.cos(a) * RELIEF_RING),
				math.floor(centre.z + math.sin(a) * RELIEF_RING),
				centre.y)
		if y then
			found = found + 1
			if not highest or y > highest then highest = y end
			if not lowest or y < lowest then lowest = y end
		end
	end
	-- Too little loaded to say anything. Returning nil rather than "flat" is
	-- the difference between not knowing and being wrong.
	if found < RELIEF_SAMPLES / 2 then return end

	local spread = highest - lowest
	local above = highest - centre.y
	local below = centre.y - lowest

	if spread < 6 then return {kind = "plain", spread = spread} end
	if above > 18 and below < 6 then
		return {kind = "valley", spread = spread, above = above}
	end
	if above > 14 then return {kind = "hills", spread = spread, above = above} end
	if below > 14 then return {kind = "bluff", spread = spread, below = below} end
	return {kind = "rolling", spread = spread}
end

local function survey_water(centre)
	local found = minetest.find_node_near(centre, LOOK, {"group:water"})
	if not found then return end

	local out = {pos = found, dist = util.dist_flat(found, centre)}

	-- Salt water is the sea wherever it is; fresh water at this size is a
	-- river or a lake, and the difference is not worth guessing at, so the
	-- word used is the vague one a person would use.
	local node = minetest.get_node_or_nil(found)
	local name = node and node.name or ""
	if name:find("river") then
		out.kind = "river"
	elseif minetest.get_item_group(name, "water") > 0 and out.dist > 30 then
		out.kind = "water"
	else
		out.kind = "water"
	end
	return out
end

local function survey_volcano(centre)
	if not minetest.global_exists("magma_conduits")
			or not magma_conduits.get_volcano then
		return
	end

	local ok, v = pcall(magma_conduits.get_volcano, centre)
	if not ok or not v or not v.location then return end

	local peak = {x = v.location.x, y = v.depth_peak or centre.y,
			z = v.location.z}
	local dist = util.dist_flat(peak, centre)

	-- Out of sight is out of mind. The mod's regions are thousands of nodes
	-- across, so without this every village in the region would mention a cone
	-- nobody there has ever seen.
	if dist > 900 then return end

	local state = "extinct"
	if v.state and magma_conduits.volcano_state_dormant then
		if v.state >= magma_conduits.volcano_state_dormant then
			state = "active"
		elseif v.state >= magma_conduits.volcano_state_extinct then
			state = "dormant"
		end
	end

	return {
		name = v.name,
		state = state,
		pos = peak,
		dist = dist,
		height = (v.depth_peak or centre.y) - centre.y,
	}
end

-- Other settlements. mg_villages keys every village by "vx:vz", so the whole
-- map of the world is already in memory and every entry carries its own
-- position in its id -- no scan, no storage, and it only ever lists villages
-- that have really been generated.
local NEIGHBOUR_VILLAGE_RANGE = 1400

local function survey_villages(village_id, centre)
	local out = {}
	for id, v in pairs(mg_villages.all_villages or {}) do
		if id ~= village_id and v.name and v.name ~= "" and v.name ~= "unknown" then
			local pos = {x = v.vx or 0, y = v.vh or centre.y, z = v.vz or 0}
			local dist = util.dist_flat(pos, centre)
			if dist <= NEIGHBOUR_VILLAGE_RANGE then
				out[#out + 1] = {
					id = id, name = v.name, kind = v.village_type,
					pos = pos, dist = dist,
				}
			end
		end
	end
	table.sort(out, function(a, b) return a.dist < b.dist end)
	return out
end

-- The commonest thing of a kind actually growing or lying about near the
-- village, read straight off the map. One bounded find_nodes_in_area, ranked by
-- count, cleaned to English -- run once per village and cached in the survey, so
-- the cost lands on the first person asked and never again.
local MATERIAL_RADIUS = 28
local MATERIAL_YSPAN = 14

-- The word a person would use for a node: its description reads better than its
-- id ("Pine Tree" beats "pine_tree"), stripped of the "Trunk"/"Wood" a stack of
-- logs is labelled with. Falls back to the cleaned id for anything undescribed.
local function material_word(name)
	local def = minetest.registered_nodes[name]
	local desc = def and def.description
	if desc and desc ~= "" then
		desc = desc:match("^[^\n]*")
		desc = desc:gsub("%s*[Tt]runk$", ""):gsub("%s*[Ww]ood$", "")
		desc = desc:gsub("%s+$", "")
		if desc ~= "" then return desc:lower() end
	end
	name = name:gsub("^[%w_]+:", ""):gsub("_", " ")
	return name ~= "" and name or nil
end

local function survey_material(centre, filter)
	if not minetest.find_nodes_in_area then return end
	local min = {x = centre.x - MATERIAL_RADIUS, y = centre.y - MATERIAL_YSPAN,
			z = centre.z - MATERIAL_RADIUS}
	local max = {x = centre.x + MATERIAL_RADIUS, y = centre.y + MATERIAL_YSPAN,
			z = centre.z + MATERIAL_RADIUS}
	local found = minetest.find_nodes_in_area(min, max, filter)
	if not found or #found == 0 then return end

	local tally = {}
	for _, p in ipairs(found) do
		local word = material_word(minetest.get_node(p).name)
		if word then tally[word] = (tally[word] or 0) + 1 end
	end

	local ranked = {}
	for word, n in pairs(tally) do ranked[#ranked + 1] = {word = word, n = n} end
	if #ranked == 0 then return end
	table.sort(ranked, function(a, b) return a.n > b.n end)
	-- How lopsided the mix is decides whether they name one thing or two.
	ranked.abundant = #found
	return ranked
end

-- Join the top one or two into a phrase: "oak", or "oak, and some birch". A
-- clear runaway winner is named alone; a close second gets a mention.
local function material_phrase(ranked)
	if not ranked or #ranked == 0 then return end
	if #ranked == 1 or ranked[2].n * 3 < ranked[1].n then
		return ranked[1].word
	end
	return ("%s, and some %s"):format(ranked[1].word, ranked[2].word)
end

-- Everything about where this village is. Built once, on the first person who
-- is asked, and only when enough of the map is loaded to answer honestly.
function land.of(village_id)
	if not village_id then return end
	local cached = surveys[village_id]
	if cached then return cached end

	local village = home.village(village_id)
	if not village then return end
	local centre = home.village_centre(village)
	if not centre then return end

	local s = {centre = centre, village_id = village_id}

	s.biome = land.biome_name(centre)
	if minetest.get_heat then s.heat = minetest.get_heat(centre) end
	if minetest.get_humidity then s.humidity = minetest.get_humidity(centre) end
	if s.heat and s.humidity then
		s.climate = climate_phrase(s.heat, s.humidity)
	end

	s.relief = survey_relief(centre)
	s.water = survey_water(centre)
	s.volcano = survey_volcano(centre)
	s.villages = survey_villages(village_id, centre)

	-- What the working trades are asked about: the timber and the rock actually
	-- in reach. Cheap enough to fold into the one cached survey.
	s.trees = survey_material(centre, "group:tree")
	s.stone = survey_material(centre, "group:stone")

	-- The physical half of the survey needs loaded mapblocks. If the ring came
	-- back unreadable, do not cache: the next person asked, with the village
	-- properly loaded, should get a real answer rather than this one forever.
	if s.relief then surveys[village_id] = s end
	return s
end

function land.forget(village_id)
	if village_id then surveys[village_id] = nil else surveys = {} end
end

--------------------------------------------------------------------------------
-- Who knows what
--------------------------------------------------------------------------------

-- Trades that take a person out of the village. They know the country; a baker
-- knows the weather and the next village along, which is all a baker would.
local OUTDOOR = {
	hunter = true, lumberjack = true, shepherd = true, forester = true,
	farmer = true, miner = true, ranger = true, fisher = true, fisherman = true,
	herbalist = true, trapper = true, ["sawmill owner"] = true,
	guard = true, soldier = true,
}

function land.travelled(r)
	if not r then return false end
	if OUTDOOR[r.title] then return true end
	return r.role == "guard"
end

--------------------------------------------------------------------------------
-- Saying it
--------------------------------------------------------------------------------

function land.line_climate(ctx, s)
	local bits = {}
	if s.biome then
		bits[#bits + 1] = ("They call this %s country."):format(s.biome)
	end
	if s.climate then
		bits[#bits + 1] = ("It's %s, and it doesn't change much."):format(
				s.climate)
	end
	if #bits == 0 then return "It's land. What else do you want me to say?" end
	return table.concat(bits, " ")
end

function land.line_relief(ctx, s)
	local rel = s.relief
	if not rel then return "Flat enough where I'm standing." end
	local lines = {
		plain = "Flat as a table, all the way out. You can see somebody coming for an hour.",
		valley = "We're down in it. The high ground's all round us -- %d paces up on the worst side.",
		hills = "Hilly. Everything here is uphill from somewhere, and my knees know it.",
		bluff = "We're up on the shoulder of it. Mind the drop on the far side.",
		rolling = "Up and down. Nothing you'd call a mountain, nothing you'd call flat.",
	}
	local line = lines[rel.kind] or lines.rolling
	if rel.kind == "valley" then
		return line:format(math.floor(rel.above))
	end
	return line
end

function land.line_water(ctx, s)
	local w = s.water
	if not w then
		return "Not a drop that isn't in the well. We've argued about it for years."
	end
	local where = land.bearing(s.centre, w.pos)
	if w.kind == "river" then
		return ("The river runs %s of here. Good water, and it's never once dried up."):format(where)
	end
	if w.dist < 20 then
		return "You're standing next to it. Careful in the dark."
	end
	return ("There's water %s, a few minutes out. We fetch from it when the well sulks."):format(where)
end

function land.line_volcano(ctx, s)
	local v = s.volcano
	if not v then return end

	local where = land.bearing(s.centre, v.pos)
	local how_far = land.distance_phrase(v.dist)
	local who = v.name or "that mountain"

	if v.state == "active" then
		local line = ("%s. %s of here, %s."):format(who, where:gsub("^%l", string.upper), how_far)
		line = line .. " It's awake. Some mornings you can taste it on the wind, and every few years it reminds us."
		if v.height > 60 then
			line = line .. (" Stands a good %d above us."):format(
					math.floor(v.height))
		end
		return line
	elseif v.state == "dormant" then
		return ("%s, %s of here. Sleeping, they say. My grandmother said the same and she was wrong twice."):format(
				who, where)
	end
	return ("%s, %s of here. Dead as a stone. The soil round its foot is the best in the valley, mind."):format(
			who, where)
end

function land.line_villages(ctx, s)
	local list = s.villages
	if not list or #list == 0 then
		return "Nothing. We're the last house before the wild, near enough."
	end

	local out = {}
	-- Two, at most. A villager reciting a gazetteer is a signpost, not a
	-- person, and the ones further off are the ones they know least about.
	for i = 1, math.min(2, #list) do
		local v = list[i]
		out[#out + 1] = ("%s, %s of here -- %s"):format(
				v.name, land.bearing(s.centre, v.pos),
				land.distance_phrase(v.dist))
	end
	local line = "There's " .. table.concat(out, ", and ") .. "."
	if #list > 2 then
		line = line .. (" And %d others further out that I've only heard of."):format(
				#list - 2)
	end
	return line
end

-- The working trades, each answering about the thing their hands are on all
-- day. Read off the same survey as everything else, so a lumberjack names the
-- trees that are really there and a miner the rock that is really under them.

function land.line_trees(ctx, s)
	local what = material_phrase(s.trees)
	if not what then
		return "Precious little worth felling close by. It's a walk to a decent stand, and I make it most days."
	end
	if s.trees.abundant and s.trees.abundant > 200 then
		return ("Good timber, and plenty of it -- %s, mostly. I'll not run short in my lifetime."):format(what)
	end
	return ("%s, mostly. Enough to keep me in work, if you don't mind walking for the rest."):format(
			what:gsub("^%l", string.upper))
end

function land.line_stone(ctx, s)
	local what = material_phrase(s.stone)
	if not what then
		return "Soft ground, all soil and no bones to it. You dig a way down before you hit anything worth a pick."
	end
	return ("It's %s under us, near enough all the way down. You learn the feel of a place by what your pick throws back."):format(
			what)
end

-- What a farmer grows, from the climate the fields actually sit in rather than a
-- crop table that would lie the moment the biome changed. The warmth and wet
-- buckets are the same two axes the whole biome grid is laid on.
function land.line_crops(ctx, s)
	local heat, hum = s.heat, s.humidity
	local crop
	if not heat then
		crop = "whatever the ground will give in a given year"
	elseif heat < 25 then
		crop = (hum and hum > 55)
				and "rye and hardy greens, and not much that's tender -- the season's short and mean"
				or "barley and roots, mostly. The frost has the last word on anything else"
	elseif heat < 55 then
		crop = "wheat and barley, turnips and beans -- honest crops for honest ground"
	elseif heat < 75 then
		crop = (hum and hum > 60)
				and "maize and beans, and squashes down the wet end of the field"
				or "wheat, and grapes on the south wall, and melons when the summer's kind"
	else
		crop = (hum and hum > 55)
				and "rice in the wet ground, and beans -- it all comes on fast down here"
				or "little that doesn't want watering -- beans, some dates, whatever the well will carry"
	end
	return ("I work the fields. %s."):format(crop)
end

-- A miller grinds; they do not grow. Grounded in the same climate as the crops
-- so the grain named suits the ground, but phrased as someone the harvest comes
-- *to* rather than someone who raised it -- a miller answering "what do you
-- grow?" with "I work the fields" was the plainest lie in the set, since a
-- miller has no fields, only a mill.
function land.line_mill(ctx, s)
	local heat, hum = s.heat, s.humidity
	local grain
	if not heat then
		grain = "whatever grain the year brings in"
	elseif heat < 25 then
		grain = "rye and barley, what the short season allows"
	elseif heat < 75 then
		grain = "wheat and barley, in a good year both"
	else
		grain = (hum and hum > 55) and "rice, more of it than wheat down here"
				or "what little wheat the dry ground gives"
	end
	return ("I grind, I don't grow -- %s comes in from the fields round about, and goes out as flour."):format(
			grain)
end

-- What is actually out there, taken from what has actually been seen. The
-- sightings are real events with real witnesses, so this is a villager
-- repeating something rather than reciting a bestiary.
function land.line_dangers(ctx, s)
	local seen = {}
	local key = village_life.memory.key_of(ctx.self)
	for _, item in ipairs((key and village_life.gossip.book[key]) or {}) do
		local ev = item.ev
		if ev and (ev.kind == "sighting" or ev.kind == "raid")
				and ev.detail and ev.detail.what then
			seen[ev.detail.what] = true
		end
	end

	local names = {}
	for what in pairs(seen) do names[#names + 1] = what end
	table.sort(names)

	if #names == 0 then
		return "Wolves, same as anywhere. Nothing I've seen myself lately, and long may it last."
	end
	if #names == 1 then
		return ("%s. I'd not go out after dark, whatever anyone tells you."):format(
				names[1]:gsub("^%l", string.upper))
	end
	return ("%s, for a start. And that's only what's come close enough to see."):format(
			table.concat(names, ", "))
end

return land
