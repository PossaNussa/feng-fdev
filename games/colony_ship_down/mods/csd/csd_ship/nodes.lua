-- The ship's own building palette. Builders get all of these in the creative
-- inventory; the generator uses them for the starter ship.

local S = csd_ship.S

local metal_sounds = core.global_exists("default") and default.node_sound_metal_defaults
	and default.node_sound_metal_defaults() or nil
local glass_sounds = core.global_exists("default") and default.node_sound_glass_defaults
	and default.node_sound_glass_defaults() or nil

local function block(name, desc, tiles, extra)
	local def = {
		description = desc,
		tiles = type(tiles) == "table" and tiles or {tiles},
		-- metal = 1: DynamicSounds gives metal walls ringing echoes
		groups = {cracky = 2, csd_ship = 1, metal = 1},
		sounds = metal_sounds,
		is_ground_content = false,
	}
	for k, v in pairs(extra or {}) do def[k] = v end
	core.register_node("csd_ship:" .. name, def)
end

block("hull",          S("Hull Plating"),        "csd_ship_hull.png")
block("hull_rib",      S("Hull Rib"),            "csd_ship_hull_rib.png")
block("hull_vent",     S("Hull Vent"),           "csd_ship_hull_vent.png")
block("wall",          S("Wall Panel"),          "csd_ship_wall.png")
block("wall_trim",     S("Wall Panel (Trim)"),   "csd_ship_wall_trim.png")
block("wall_dark",     S("Dark Wall Panel"),     "csd_ship_wall_dark.png")
block("wall_pipes",    S("Pipework Wall"),       "csd_ship_wall_pipes.png")
block("wall_med",      S("Medbay Wall"),         "csd_ship_wall_med.png")
block("wall_med_cross",S("Medbay Wall (Cross)"), "csd_ship_wall_med_cross.png")
block("wall_hydro",    S("Hydroponics Wall"),    "csd_ship_wall_hydro.png")
block("floor",         S("Deck Plating"),        "csd_ship_floor.png")
block("floor_grate",   S("Floor Grating"),       "csd_ship_floor_grate.png")
block("floor_tile",    S("Floor Tiles"),         "csd_ship_floor_tile.png")
block("floor_carpet",  S("Cabin Carpet"),        "csd_ship_floor_carpet.png", {groups = {cracky = 3, csd_ship = 1, wool = 1}})
block("floor_hazard",  S("Hazard Floor"),        "csd_ship_floor_hazard.png")
block("ceiling",       S("Ceiling Panel"),       "csd_ship_ceiling.png")
block("reactor_casing",S("Reactor Casing"),      "csd_ship_reactor_casing.png")
block("engine",        S("Engine Housing"),      "csd_ship_engine.png")
block("crate",         S("Cargo Crate"),         {"csd_ship_crate_top.png", "csd_ship_crate_top.png", "csd_ship_crate.png"})
block("locker",        S("Locker"),              {"csd_ship_locker_top.png", "csd_ship_locker_top.png", "csd_ship_locker_side.png",
	"csd_ship_locker_side.png", "csd_ship_locker_side.png", "csd_ship_locker_front.png"}, {paramtype2 = "facedir"})

-- Lights. The generator remembers where it put them so the whole ship can
-- switch to red alert or go dark during malfunctions.
local function light(name, desc, tile, level, colour, extra)
	local def = {
		description = desc,
		tiles = {tile},
		paramtype = "light",
		light_source = level,
		light_colour = colour,
		groups = {cracky = 3, csd_ship = 1, csd_ship_light = 1},
		sounds = glass_sounds,
		is_ground_content = false,
	}
	for k, v in pairs(extra or {}) do def[k] = v end
	core.register_node("csd_ship:" .. name, def)
end

light("light",       S("Ceiling Light"),            "csd_ship_light.png",       13, "#f2f6ff")
light("light_alert", S("Ceiling Light (Red Alert)"),"csd_ship_light_alert.png", 10, "#ff2a1a",
	{groups = {cracky = 3, csd_ship_light = 1, not_in_creative_inventory = 1}, drop = "csd_ship:light"})
light("light_off",   S("Ceiling Light (Off)"),      "csd_ship_light_off.png",   2,  "#ff9050",
	{groups = {cracky = 3, csd_ship_light = 1, not_in_creative_inventory = 1}, drop = "csd_ship:light"})
light("light_strip", S("Light Strip"),              "csd_ship_light_strip.png", 9,  "#9fe8ff")
light("light_strip_alert", S("Light Strip (Red Alert)"), "csd_ship_light_strip_alert.png", 9, "#ff2a1a",
	{groups = {cracky = 3, csd_ship_light = 1, not_in_creative_inventory = 1}, drop = "csd_ship:light_strip"})
light("light_strip_off", S("Light Strip (Off)"), "csd_ship_light_strip_off.png", 1, "#ff9050",
	{groups = {cracky = 3, csd_ship_light = 1, not_in_creative_inventory = 1}, drop = "csd_ship:light_strip"})
light("engine_glow", S("Engine Exhaust"),           "csd_ship_engine_glow.png", 14, "#66aaff",
	{groups = {cracky = 3, csd_ship = 1}})
light("reactor_core",S("Reactor Core"),
	{name = "csd_ship_reactor_core.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.6}},
	14, "#44ffcc", {groups = {cracky = 1, csd_ship = 1}, drawtype = "glasslike", use_texture_alpha = "blend"})
light("running_red",   S("Running Light (Red)"),   "csd_ship_running_red.png",   8, "#ff2020")
light("running_green", S("Running Light (Green)"), "csd_ship_running_green.png", 8, "#20ff40")

core.register_node("csd_ship:window", {
	description = S("Hull Window"),
	drawtype = "glasslike_framed",
	tiles = {"csd_ship_window_frame.png", "csd_ship_window_detail.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {cracky = 3, csd_ship = 1},
	sounds = glass_sounds,
	is_ground_content = false,
})

core.register_node("csd_ship:forcefield", {
	description = S("Atmosphere Forcefield"),
	drawtype = "glasslike",
	tiles = {{name = "csd_ship_forcefield.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.2}}},
	use_texture_alpha = "blend",
	paramtype = "light",
	light_source = 5,
	light_colour = "#66ccff",
	sunlight_propagates = true,
	walkable = false, -- holds the air in, lets people through (airlock for EVA)
	pointable = true,
	groups = {cracky = 3, csd_ship = 1},
	is_ground_content = false,
})

-- Gravity lift: a glowing shaft you float in. Jump to rise, sneak to sink.
core.register_node("csd_ship:gravlift", {
	description = S("Gravity Lift Field"),
	drawtype = "glasslike",
	tiles = {{name = "csd_ship_gravlift.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1.0}}},
	use_texture_alpha = "blend",
	paramtype = "light",
	light_source = 7,
	light_colour = "#55aaff",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	climbable = true,
	buildable_to = true,
	move_resistance = 1,
	post_effect_color = {a = 40, r = 60, g = 140, b = 255},
	groups = {csd_ship = 1, not_in_creative_inventory = 0},
	is_ground_content = false,
})

-- Furniture (nodeboxes) -------------------------------------------------------

local function furniture(name, desc, boxes, tiles, extra)
	local def = {
		description = desc,
		drawtype = "nodebox",
		node_box = {type = "fixed", fixed = boxes},
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		groups = {cracky = 3, csd_ship = 1},
		sounds = metal_sounds,
		is_ground_content = false,
	}
	for k, v in pairs(extra or {}) do def[k] = v end
	core.register_node("csd_ship:" .. name, def)
end

local sit = csd_core.sit_on_node

furniture("bench", S("Bench"),
	{{-0.5, -0.1, -0.3, 0.5, 0.05, 0.3}, {-0.45, -0.5, -0.25, -0.35, -0.1, 0.25}, {0.35, -0.5, -0.25, 0.45, -0.1, 0.25}},
	{"csd_ship_seat.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png"}, {on_rightclick = sit, _csd_seat = {height = 0.05, back = 0, reverse = true}})
furniture("sofa", S("Lounge Sofa"),
	{{-0.5, -0.5, -0.4, 0.5, 0.0, 0.5}, {-0.5, 0.0, 0.25, 0.5, 0.5, 0.5}},
	{"csd_ship_sofa.png"}, {on_rightclick = sit, _csd_seat = {height = 0.0, back = 0.05}})
furniture("table", S("Mess Table"),
	{{-0.5, 0.3, -0.5, 0.5, 0.4, 0.5}, {-0.08, -0.5, -0.08, 0.08, 0.3, 0.08}},
	{"csd_ship_table_top.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png"})
furniture("bunk", S("Crew Bunk"),
	{{-0.5, -0.5, -0.5, 0.5, 0.1, 0.5}, {-0.5, 0.1, 0.3, 0.5, 0.5, 0.5}},
	{"csd_ship_bunk_top.png", "csd_ship_wall_dark.png", "csd_ship_bunk_side.png"}, {on_rightclick = sit, _csd_seat = {height = 0.1, back = 0}})
furniture("railing", S("Railing"),
	{{-0.5, 0.4, 0.4, 0.5, 0.5, 0.5}, {-0.45, -0.5, 0.42, -0.38, 0.4, 0.48}, {0.38, -0.5, 0.42, 0.45, 0.4, 0.48}},
	{"csd_ship_wall_dark.png"})
furniture("screen", S("Wall Screen"),
	{{-0.5, -0.35, 0.4, 0.5, 0.45, 0.5}},
	{"csd_ship_wall_dark.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png",
		"csd_ship_wall_dark.png", {name = "csd_ship_screen.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 4}}},
	{light_source = 6})
furniture("plant_pot", S("Potted Plant"),
	{{-0.25, -0.5, -0.25, 0.25, -0.1, 0.25}},
	{"csd_ship_pot_top.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png"})
core.register_node("csd_ship:plant", {
	description = S("Ship Fern"),
	drawtype = "plantlike",
	tiles = {"csd_ship_plant.png"},
	inventory_image = "csd_ship_plant.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {type = "fixed", fixed = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3}},
	groups = {snappy = 3, csd_ship = 1},
	is_ground_content = false,
})

-- A plaque that names the room you're entering (text set by the generator).
core.register_node("csd_ship:room_sign", {
	description = S("Room Sign"),
	drawtype = "nodebox",
	node_box = {type = "fixed", fixed = {{-0.5, -0.2, 0.44, 0.5, 0.2, 0.5}}},
	tiles = {"csd_ship_wall_dark.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png", "csd_ship_wall_dark.png",
		"csd_ship_wall_dark.png", "csd_ship_sign.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	sunlight_propagates = true,
	groups = {cracky = 3, csd_ship = 1},
	is_ground_content = false,
})

-- Room name plates with visible text (signs_lib). Two big lines so they stay
-- readable from across a corridor; white text that glows.
if core.global_exists("signs_lib") then
	signs_lib.register_sign("csd_ship:sign", {
		description = S("Ship Sign"),
		inventory_image = "csd_ship_sign_inv.png",
		tiles = {"csd_ship_sign_plate.png", "csd_ship_sign_edges.png"},
		groups = {cracky = 3, sign = 1},
		sounds = metal_sounds,
		entity_info = "standard",
		number_of_lines = 2,
		chars_per_line = 16,
		default_color = "f",
		allow_widefont = true,
		use_texture_alpha = "clip",
	})
end
