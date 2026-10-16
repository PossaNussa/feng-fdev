-- /petroglyphs - a finder and a demonstrator.
--
-- Panels only carve onto exposed rock faces, in newly generated terrain, in
-- the fraction of the world that was "worked".  That makes them easy to walk
-- past for weeks.  This command lets you see one on demand, and points you at
-- the real ones.

local RADIUS = 24  -- how far the demo/scan reaches around you

-- rebuild a glyph node name for a given rock index + glyph number
local function glyph_node(si, glyph)
	local stone = petroglyphs.stones[si]
	return "petroglyphs:" .. stone.short .. "_" .. string.format("%02d", glyph)
end

-- param2 that turns a 4dir glyph to look out of a wall, given the direction
-- from the rock into the open air in front of it.  Matches mapgen.lua.
local function facing_param2(frontdir)
	return minetest.dir_to_fourdir({ x = -frontdir.x, y = 0, z = -frontdir.z })
end

local HDIRS = {
	{ x = 1, z = 0 }, { x = -1, z = 0 }, { x = 0, z = 1 }, { x = 0, z = -1 },
}

-- Find (rock, frontdir) faces near a position: a strata rock with two nodes of
-- open air out one horizontal side.  Returned nearest first.
local function faces_near(center, radius)
	local rock_of = petroglyphs.rock_of or {}
	local found = {}
	for dx = -radius, radius do
		for dy = -radius, radius do
			for dz = -radius, radius do
				local p = { x = center.x + dx, y = center.y + dy, z = center.z + dz }
				local si = rock_of[minetest.get_content_id(minetest.get_node(p).name)]
				if si then
					for _, d in ipairs(HDIRS) do
						local a1 = minetest.get_node({ x = p.x + d.x, y = p.y, z = p.z + d.z }).name
						local a2 = minetest.get_node({ x = p.x + 2 * d.x, y = p.y, z = p.z + 2 * d.z }).name
						if a1 == "air" and a2 == "air" then
							found[#found + 1] = {
								pos = p, front = d, si = si,
								dist = dx * dx + dy * dy + dz * dz,
							}
							break
						end
					end
				end
			end
		end
	end
	table.sort(found, function(a, b) return a.dist < b.dist end)
	return found
end

-- Build a free-standing sandstone slab facing the player, so the demo always
-- has a wall even in open grassland.
local function raise_wall(player)
	local pos = vector.round(player:get_pos())
	local yaw = player:get_look_horizontal()
	local look = minetest.yaw_to_dir(yaw)
	-- snap look to a cardinal so the wall is axis-aligned
	local front
	if math.abs(look.x) > math.abs(look.z) then
		front = { x = (look.x < 0) and -1 or 1, z = 0 }
	else
		front = { x = 0, z = (look.z < 0) and -1 or 1 }
	end
	local base = { x = pos.x + front.x * 3, y = pos.y, z = pos.z + front.z * 3 }
	local tu = (front.x ~= 0) and { x = 0, z = 1 } or { x = 1, z = 0 }
	for du = -3, 3 do
		for dv = -1, 4 do
			minetest.set_node({
				x = base.x + tu.x * du, y = base.y + dv, z = base.z + tu.z * du,
			}, { name = "default:sandstone" })
		end
	end
	-- the face the player sees points back toward them, i.e. -front
	return { x = base.x, y = base.y + 1, z = base.z }, { x = -front.x, z = -front.z }
end

-- Carve a small cluster onto a wall: a seed rock cell + open air in `front`.
local function carve_panel(seed_pos, front, si, culture, want)
	local rock_of = petroglyphs.rock_of
	local glyph_of = petroglyphs.glyph_of
	if not (glyph_of and glyph_of[si]) then
		return 0
	end
	local param2 = facing_param2(front)
	local tu = (front.x ~= 0) and { x = 0, z = 1 } or { x = 1, z = 0 }
	local placed = 0
	local pr = PcgRandom(seed_pos.x * 13 + seed_pos.y * 71 + seed_pos.z * 131 + os.time())
	for du = -3, 3 do
		for dv = -1, 3 do
			if placed >= want then break end
			-- space them out so the wall reads as figures
			if (du % 2 == 0) and (dv % 2 == 0) then
				local p = {
					x = seed_pos.x + tu.x * du, y = seed_pos.y + dv, z = seed_pos.z + tu.z * du,
				}
				local here = rock_of[minetest.get_content_id(minetest.get_node(p).name)]
				local air = minetest.get_node({ x = p.x + front.x, y = p.y, z = p.z + front.z }).name
				if here == si and air == "air" then
					local glyph
					if pr:next(1, 100) <= 3 then
						glyph = petroglyphs.anomalies[pr:next(1, #petroglyphs.anomalies)]
					else
						glyph = pr:next(culture.first, culture.last)
					end
					minetest.set_node(p, { name = glyph_node(si, glyph), param2 = param2 })
					placed = placed + 1
				end
			end
		end
	end
	return placed
end

---------------------------------------------------------------------------

local function report_here(name, pos)
	local v = petroglyphs.site_value(pos.x, pos.z)
	local worked = v >= petroglyphs.site_threshold
	local culture = petroglyphs.culture_at(pos.x, pos.z)
	return string.format(
		"Here: site value %.2f (threshold %.2f) -> %s. Carving hand: %s.",
		v, petroglyphs.site_threshold,
		worked and "WORKED COUNTRY - panels generate in new chunks here"
			or "barren - travel until the value clears the threshold",
		culture.name)
end

minetest.register_chatcommand("petroglyphs", {
	params = "here | find | demo | wall",
	description = "Locate or demonstrate petroglyph panels",
	privs = { server = true },
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "in-game only"
		end
		local pos = vector.round(player:get_pos())
		param = (param or ""):gsub("%s+", ""):lower()

		if param == "" or param == "here" then
			return true, report_here(name, pos)

		elseif param == "find" then
			local faces = faces_near(pos, RADIUS)
			-- look for existing glyphs first
			local glyphs = minetest.find_nodes_in_area(
				vector.subtract(pos, RADIUS), vector.add(pos, RADIUS), "group:petroglyph")
			if #glyphs > 0 then
				table.sort(glyphs, function(a, b)
					return vector.distance(pos, a) < vector.distance(pos, b)
				end)
				local g = glyphs[1]
				return true, string.format(
					"Nearest existing petroglyph: %d,%d,%d (%.0f nodes away). %d in range.",
					g.x, g.y, g.z, vector.distance(pos, g), #glyphs)
			end
			return true, string.format(
				"No existing petroglyphs within %d nodes. %d bare rock faces here that could carry one. %s Try '/petroglyphs demo'.",
				RADIUS, #faces, report_here(name, pos))

		elseif param == "demo" then
			local faces = faces_near(pos, RADIUS)
			if #faces == 0 then
				return false,
					"No exposed rock face within reach - stand by a cliff or cave wall, or use '/petroglyphs wall' to raise one."
			end
			local f = faces[1]
			local culture = petroglyphs.culture_at(f.pos.x, f.pos.z)
			local n = carve_panel(f.pos, f.front, f.si, culture, 6)
			return true, string.format(
				"Carved %d marks (%s hand) into the %s at %d,%d,%d.",
				n, culture.name, petroglyphs.stones[f.si].short,
				f.pos.x, f.pos.y, f.pos.z)

		elseif param == "wall" then
			local seed_pos, front = raise_wall(player)
			local si = petroglyphs.rock_of[minetest.get_content_id("default:sandstone")]
			if not si then
				return false, "sandstone has no glyph set registered"
			end
			local culture = petroglyphs.culture_at(seed_pos.x, seed_pos.z)
			local n = carve_panel(seed_pos, front, si, culture, 9)
			return true, string.format(
				"Raised a sandstone face and carved %d marks (%s hand). Turn around.",
				n, culture.name)
		end

		return false, "usage: /petroglyphs here | find | demo | wall"
	end,
})
