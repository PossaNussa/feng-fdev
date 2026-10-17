-- Air ducts. Above every deck's ceiling there's a one-node crawlspace filled
-- with duct casing; the generator carves a duct network through it:
--   * a two-wide trunk running the length of the ship over each corridor
--   * a branch to every air vent and oxygen filter, which shows in the room as
--     a pipe running up the wall from the vent into a ceiling grate
--   * hatches with ladders in every maintenance closet to climb in
-- Inside, duct lamps glow every few metres and grates in the floor let you
-- peek into the rooms below. Crawl (Aux1 / Ctrl) to fit.

local S = csd_ship.S
local L = csd_ship.layout

local metal_sounds = core.global_exists("default") and default.node_sound_metal_defaults
	and default.node_sound_metal_defaults() or nil

core.register_node("csd_ship:duct_casing", {
	description = S("Air Duct Casing"),
	tiles = {"csd_ship_duct.png"},
	groups = {cracky = 2, csd_ship = 1, metal = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

-- See-through grating: the floor of a duct over a room, or a ceiling vent.
core.register_node("csd_ship:duct_grate", {
	description = S("Duct Grate"),
	drawtype = "glasslike",
	tiles = {"csd_ship_duct_grate.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky = 2, csd_ship = 1, metal = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

-- Where a duct opens onto a big hall: a grille you can look through.
core.register_node("csd_ship:duct_grille", {
	description = S("Duct Grille"),
	drawtype = "glasslike",
	tiles = {"csd_ship_duct_grate.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky = 2, csd_ship = 1, metal = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

-- Ceiling hatch: climb straight through it from the ladder below.
core.register_node("csd_ship:duct_hatch", {
	description = S("Duct Hatch"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {
		{-0.5, 0.4, -0.5, 0.5, 0.5, -0.4}, {-0.5, 0.4, 0.4, 0.5, 0.5, 0.5},
		{-0.5, 0.4, -0.4, -0.4, 0.5, 0.4}, {0.4, 0.4, -0.4, 0.5, 0.5, 0.4},
	}},
	selection_box = {type = "fixed", fixed = {-0.5, 0.4, -0.5, 0.5, 0.5, 0.5}},
	tiles = {"csd_ship_hatch.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	groups = {cracky = 2, csd_ship = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

-- An exposed air pipe running up a wall (or along a ceiling).
core.register_node("csd_ship:air_pipe", {
	description = S("Air Pipe"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {{-0.18, -0.5, 0.14, 0.18, 0.5, 0.5}, {-0.24, -0.06, 0.1, 0.24, 0.06, 0.5}}},
	tiles = {"csd_ship_air_pipe.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {cracky = 2, csd_ship = 1, metal = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

-- Solid ceiling vent, for detail where there's no duct to see into.
core.register_node("csd_ship:ceiling_vent", {
	description = S("Ceiling Vent"),
	tiles = {"csd_ship_ceiling.png", "csd_ship_ceiling_vent.png", "csd_ship_ceiling.png"},
	groups = {cracky = 2, csd_ship = 1, metal = 1},
	sounds = metal_sounds,
	is_ground_content = false,
})

core.register_node("csd_ship:duct_light", {
	description = S("Duct Lamp"),
	tiles = {"csd_ship_light_strip.png"},
	paramtype = "light",
	light_source = 8,
	light_colour = "#ffb060",
	groups = {cracky = 3, csd_ship = 1},
	is_ground_content = false,
})

------------------------------------------------------------------------------
-- The network
------------------------------------------------------------------------------

local TRUNK_Z = {0, 1}

local function deck_of(rel_y)
	for deck = 1, L.decks do
		local y = L.floor_y(deck)
		if rel_y >= y and rel_y <= y + 5 then return deck end
	end
end

function csd_ship.build_ducts(b)
	local G = csd_ship.geometry
	local casing, window, air = b:id("csd_ship:duct_casing"), b:id("csd_ship:window"), b:id("air")
	local carved = {}
	local function key(x, y, z) return x .. "," .. y .. "," .. z end

	-- Turn casing (or a skylight's middle pane) into duct; false if blocked.
	local function carve(x, y, z)
		local k = key(x, y, z)
		if carved[k] then return true end
		local c = b:get(x, y, z)
		if c == casing or c == window then
			b:set(x, y, z, "air")
			carved[k] = true
			return true
		end
		return false
	end

	-- A straight run along Z at (x, cy) from z0 to z1; stops at anything solid
	-- that isn't casing (a lift shaft, say).
	local function run_z(x, cy, z0, z1)
		local step = z1 >= z0 and 1 or -1
		for z = z0, z1, step do
			if not carve(x, cy, z) then return false end
		end
		return true
	end

	-- 1. Trunks
	for deck = 1, L.decks do
		local y = L.floor_y(deck)
		local cy = y + 7
		for x = G.X0 + 1, G.X1 - 1 do
			for _, z in ipairs(TRUNK_Z) do carve(x, cy, z) end
		end
		-- Where the trunk runs into open space (the reactor hall), a grille.
		for x = G.X0 + 1, G.X1 - 1 do
			for _, z in ipairs(TRUNK_Z) do
				if b:get(x, cy, z) == air and not carved[key(x, cy, z)] then
					for _, dx in ipairs({-1, 1}) do
						if carved[key(x + dx, cy, z)] then
							b:set(x + dx, cy, z, "csd_ship:duct_grille")
							carved[key(x + dx, cy, z)] = nil
						end
					end
				end
			end
		end
		-- Lamps in the duct wall, peek grates in the floor over the corridor
		for x = G.X0 + 4, G.X1 - 4, 8 do
			if b:get(x, cy, -1) == casing and carved[key(x, cy, 0)] then
				b:set(x, cy, -1, "csd_ship:duct_light")
			end
		end
		for x = G.X0 + 7, G.X1 - 7, 10 do
			if carved[key(x, cy, 1)] and b:is(x, y + 6, 1, "csd_ship:ceiling") then
				b:set(x, y + 6, 1, "csd_ship:duct_grate")
			end
		end
		-- Solid vents along the corridor ceilings, for texture
		for x = G.X0 + 3, G.X1 - 3, 12 do
			for _, z in ipairs({-2, 3}) do
				if b:is(x, y + 6, z, "csd_ship:ceiling") then b:set(x, y + 6, z, "csd_ship:ceiling_vent") end
			end
		end
	end

	-- 2. A branch to every vent and filter, with a pipe up the wall to it
	local O = b.o
	for _, st in ipairs(b.stations) do
		if st.kind == "air_vent" or st.kind == "o2_filter" then
			local vx, vy, vz = st.pos.x - O.x, st.pos.y - O.y, st.pos.z - O.z
			local deck = deck_of(vy)
			if deck then
				local y = L.floor_y(deck)
				local cy = y + 7
				local from = vz >= 1 and 1 or 0
				if run_z(vx, cy, from, vz) and st.wall_dir then
					local p2 = core.dir_to_facedir(st.wall_dir)
					local top = y + 5
					for py = vy + 1, top do
						if b:get(vx, py, vz) ~= air then top = py - 1 break end
						b:set(vx, py, vz, "csd_ship:air_pipe", p2)
					end
					if top == y + 5 and (b:is(vx, y + 6, vz, "csd_ship:ceiling") or b:is(vx, y + 6, vz, "csd_ship:ceiling_vent")) then
						b:set(vx, y + 6, vz, "csd_ship:duct_grate")
					end
				end
			end
		end
	end

	-- 3. Hatches and ladders in the maintenance closets
	local ladder = csd_ship.pick("default:ladder_steel", "default:ladder_wood")
	for _, r in ipairs(b.rooms) do
		if r.kind == "maintenance" and ladder then
			local y = r.y
			local hx = r.x0
			local hz = r.side == "S" and r.z1 or r.z0 -- the corner by the corridor
			local cy = y + 7
			if run_z(hx, cy, hz, hz > 0 and 1 or 0) then
				for py = y, y + 5 do
					b:set(hx, py, hz, ladder, core.dir_to_wallmounted(vector.new(-1, 0, 0)))
				end
				b:set(hx, y + 6, hz, "csd_ship:duct_hatch")
			end
		end
	end
end
