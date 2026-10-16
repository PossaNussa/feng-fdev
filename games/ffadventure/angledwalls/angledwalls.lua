-- [MOD] Angled Walls [angledwalls] [1.3] by TumeniNodes 6-24-2016
--
-- Legacy hand-registration API, kept for mods that call it.  The material
-- list that used to live at the bottom of this file is gone: angled variants
-- are now generated for every ordinary block in the game (see api.lua and
-- autogen.lua) and placed by stance rather than picked from the inventory.
-- Old node names are aliased to the generated ones in autogen.lua.

-- Angled place function
-- To use put "on_place = angledwalls.angled_place" in the node def

function angledwalls.angled_place(itemstack, placer, pointed_thing)
	local placer_pos = placer:get_pos()
	local pos = pointed_thing.above
	local param2
	if pos.x > placer_pos.x then
		if pos.z > placer_pos.z then
			param2 = 1
		else
			param2 = 2
		end
	else
		if pos.z > placer_pos.z then
			param2 = 0
		else
			param2 = 3
		end
	end
	return core.item_place(itemstack, placer, pointed_thing, param2)
end

local ALPHA_OPAQUE = core.features.use_texture_alpha_string_modes and "opaque" or false
local function get_alpha(recipeitem)
	local def = core.registered_nodes[recipeitem]
	return def and def.use_texture_alpha or ALPHA_OPAQUE
end

--Register angledwalls.
--Node will be called angledwalls:angled_wall_<subname>

function angledwalls.register_angled_wall(subname, recipeitem, groups, images, description, sounds)
	groups.angledwall = 1
	core.register_node(":angledwalls:angled_wall" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "angled_wall.obj",
		tiles = images,
		paramtype = "light",
		sunlight_propogates = true,
		use_texture_alpha = get_alpha(recipeitem),
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = sounds,
		collision_box = {
			type = "fixed",
			fixed = {
				{0, -0.5, 0, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, 0, 0.5, 0},
				{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
				{-0.3125, -0.5, -0.1875, 0.3125, 0.5, 0.1875},
				{-0.1875, -0.5, -0.3125, 0.1875, 0.5, 0.3125},
				{-0.125, -0.5, -0.375, 0.125, 0.5, 0.375},
				{-0.0625, -0.5, -0.4375, 0.0625, 0.5, 0.4375},
				{-0.375, -0.5, -0.125, 0.375, 0.5, 0.125},
				{-0.4375, -0.5, -0.0625, 0.4375, 0.5, 0.0625},
			}
		},
		on_place = angledwalls.angled_place
	})
end

-- Register angledwalls.
-- Node will be called angledwalls:low_angled_wall_<subname>

function angledwalls.register_low_angled_wall(subname, recipeitem, groups, images, description, sounds)
	groups.lowangledwall = 1
	core.register_node(":angledwalls:low_angled_wall" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "low_angled_wall.obj",
		tiles = images,
		paramtype = "light",
		sunlight_propogates = true,
		use_texture_alpha = get_alpha(recipeitem),
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = sounds,
		collision_box = {
			type = "fixed",
			fixed = {
				{0, -0.5, 0, 0.5, 0, 0.5},
				{-0.5, -0.5, -0.5, 0, 0, 0},
				{-0.25, -0.5, -0.25, 0.25, 0, 0.25},
				{-0.3125, -0.5, -0.1875, 0.3125, 0, 0.1875},
				{-0.1875, -0.5, -0.3125, 0.1875, 0, 0.3125},
				{-0.125, -0.5, -0.375, 0.125, 0, 0.375},
				{-0.0625, -0.5, -0.4375, 0.0625, 0, 0.4375},
				{-0.375, -0.5, -0.125, 0.375, 0, 0.125},
				{-0.4375, -0.5, -0.0625, 0.4375, 0, 0.062},
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},
		on_place = angledwalls.angled_place
	})
end

--Register angledwalls.
--Node will be called angledwalls:corner_<subname>

function angledwalls.register_corner(subname, recipeitem, groups, images, description, sounds)
	groups.corner = 1
	core.register_node(":angledwalls:corner" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "angledwalls_corner.obj",
		tiles = images,
		paramtype = "light",
		sunlight_propogates = true,
		use_texture_alpha = get_alpha(recipeitem),
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups,
		sounds = sounds,
		collision_box = {
		type = "fixed",
			fixed = {
				{0, -0.5, 0, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, 0, 0.5, 0},
				{-0.1875, -0.5, -0.1875, 0.3125, 0.5, 0.3125},
				{-0.125, -0.5, -0.125, 0.375, 0.5, 0.375},
				{-0.375, -0.5, -0.375, 0.125, 0.5, 0.125},
				{-0.4375, -0.5, -0.4375, 0.0625, 0.5, 0.0625},
				{-0.0625, -0.5, -0.0625, 0.4375, 0.5, 0.4375},
				{-0.25, -0.5, -0.3125, 0.1875, 0.5, 0.25},
				{-0.5, -0.5, -0.25, 0.25, 0.5, 0.5},
			}
		},
		on_place = angledwalls.angled_place
	})
end

-- Angled wall/low wall/corner registration function.
-- Nodes will be called angledwalls:{angled_wall,low_angled_wall,corner}_<subname>

function angledwalls.register_angled_wall_and_low_angled_wall_and_corner(subname, recipeitem, groups, images,desc_angled_wall, desc_low_angled_wall, desc_corner, sounds)
	angledwalls.register_angled_wall(subname, recipeitem, groups, images, desc_angled_wall, sounds)
	angledwalls.register_low_angled_wall(subname, recipeitem, groups, images, desc_low_angled_wall, sounds)
	angledwalls.register_corner(subname, recipeitem, groups, images, desc_corner, sounds)
end
