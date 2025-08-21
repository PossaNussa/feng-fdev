local S = minetest.get_translator("variety")

---------------------------------------------
-------------MAPGENS
---------------------------------------------
minetest.register_decoration({
    name = "variety:baobab_tree_1",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    place_offset_y = -8,
    sidelen = 16,
    fill_ratio = 0.000365,
    biomes = {"baobab_savanna"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/baobab_tree_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

minetest.register_decoration({
    name = "variety:baobab_tree_2",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    place_offset_y = -2,
    sidelen = 16,
    fill_ratio = 0.000155,
    biomes = {"baobab_savanna"},
    y_max = 31000,
    y_min = -20,
    schematic = minetest.get_modpath("variety").."/schematics/baobab_tree_2.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

---------------------------------------------
-------------BLOCKS
---------------------------------------------
minetest.register_node("variety:baobab_leaves", {
	description = S("Baobab Tree Leaves"),
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"baobab_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"variety:baobab_sapling"}, rarity = 20},
			{items = {"variety:baobab_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("variety:baobab_tree", {
	description = S("Baobab Tree"),
	tiles = {"baobab_tree_top.png", "baobab_tree_top.png",
		"baobab_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("variety:baobab_wood", {
	description = S("Baobab Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"baobab_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("variety:baobab_sapling", {
	description = S("Baobab Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"baobab_trees.png"},
	inventory_image = "baobab_trees.png",
	wield_image = "baobab_trees.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_new_baobab_tree,
	selection_box = {
		type = "fixed",
		fixed = {-2 / 16, -0.5, -2 / 16, 2 / 16, 5 / 16, 2 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2, attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
			minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"variety:baobab_sapling",
			{x = -1, y = 0, z = -1}, -- minp, maxp to be checked, relative to sapling pos
			{x = 1, y = 3, z = 1},
			2 -- maximum interval of interior volume check
		)

		return itemstack
	end,
})

local function grow_new_baobab_tree(pos)
	if not default.can_grow(pos) then
		-- Essayer un peu plus tard
			minetest.get_node_timer(pos):start(math.random(300, 1500))
		return
	end

	minetest.remove_node(pos)

	local random_tree = "baobab_tree_" .. math.random(1, 2) .. ".mts"
	minetest.place_schematic({x = pos.x - 8, y = pos.y - 8, z = pos.z - 8}, minetest.get_modpath("variety") .. "/schematics/" .. random_tree, "0", nil, false)
end


if minetest.get_modpath("bonemeal") ~= nil then
	bonemeal:add_sapling({
		{"variety:baobab_sapling", grow_new_baobab_tree, "soil"},
	})
end

	default.register_leafdecay({
		trunks = {"variety:baobab_tree"},
		leaves = {"variety:baobab_leaves"},
		radius = 3,
	})

	stairs.register_stair_and_slab("baobab_wood", "variety:baobab_wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"baobab_wood.png"},
		S("Baobab Wood Stair"),
		S("Baobab Wood Slab"),
		default.node_sound_wood_defaults())


default.register_mesepost("variety:mese_post_light_baobab_wood", {
	description = S("Baobab Wood Mese Post Light"),
	texture = "baobab_wood.png",
	material = "variety:baobab_wood",
})

doors.register_fencegate("variety:gate_baobab", {
	description = S("Baobab Wood Fence Gate"),
	texture = "baobab_wood_fence.png",
	material = "variety:baobab_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2}
})

	default.register_fence("variety:fence_baobab_wood", {
		description = S("Baobab Wood Fence"),
		texture = "baobab_wood_fence.png",
		inventory_image = "default_fence_overlay.png^baobab_wood_fence.png^" ..
					"default_fence_overlay.png^[makealpha:255,126,126",
		wield_image = "default_fence_overlay.png^baobab_wood_fence.png^" ..
					"default_fence_overlay.png^[makealpha:255,126,126",
		material = "variety:baobab_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

	default.register_fence_rail("variety:fence_rail_baobab_wood", {
		description = S("Baobab Wood Fence Rail"),
		texture = "baobab_wood_fence.png",
		inventory_image = "default_fence_rail_overlay.png^baobab_wood_fence.png^" ..
					"default_fence_rail_overlay.png^[makealpha:255,126,126",
		wield_image = "default_fence_rail_overlay.png^baobab_wood_fence.png^" ..
					"default_fence_rail_overlay.png^[makealpha:255,126,126",
		material = "variety:baobab_wood",
		groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = default.node_sound_wood_defaults()
	})

---------------------------------------------
-------------CRAFTS
---------------------------------------------
minetest.register_craft({
	output = "variety:baobab_wood 4",
	recipe = {
		{"variety:baobab_tree"},
	}
})

	minetest.register_biome({
		name = "baobab_savanna",
		node_top = "default:dry_dirt_with_dry_grass",
		depth_top = 1,
		node_filler = "default:dry_dirt",
		depth_filler = 1,
		node_riverbed = "default:sand",
		depth_riverbed = 2,
		node_dungeon = "default:cobble",
		node_dungeon_alt = "default:mossycobble",
		node_dungeon_stair = "stairs:stair_cobble",
		y_max = 31000,
		y_min = 1,
		heat_point = 88,
		humidity_point = 46,
	})
	
-- Function to apply biome variation during terrain generation
local function apply_biome_variation(vm, area, data, a, b, c, data_param1, flags, params)
    local baobab_savanna_chance = 50 -- 50% chance for variation

    for z = a.z, b.z do
        for x = a.x, b.x do
            for y = a.y, b.y do
                local index = area:index(x, y, z)
                
                -- Check if it's a savanna biome and apply variation
                if data[index] == minetest.get_biome_id("savanna") then
                    if math.random(100) <= baobab_savanna_chance then
                        data[index] = minetest.get_biome_id("baobab_savanna")
                    end
                end
            end
        end
    end
end

-- Register the biome variation callback
minetest.register_on_generated(function(minp, maxp, seed)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})
    local data = vm:get_data()

    apply_biome_variation(vm, area, data, minp, maxp, nil, nil, nil, nil)

    vm:set_data(data)
    vm:calc_lighting()
    vm:write_to_map(data)
end)


minetest.register_entity("variety:item_on_table", {
    initial_properties = {
        visual = "wielditem",
        visual_size = {x = 0.20, y = 0.20},
        textures = {"air"},
        collisionbox = {0},
        physical = false,
    },
    itemname = "",
    rotation = 0,

on_activate = function(self, staticdata)
    local data = minetest.deserialize(staticdata) or {}
    self.itemname = data.itemname or ""
    local pos = self.object:get_pos()
    local node_pos = {x = pos.x, y = pos.y - 0.5, z = pos.z}
    local meta = minetest.get_meta(node_pos)
    self.rotation = meta:get_float("rotation") or 0
    self.y_rotation = meta:get_float("y_rotation") or 0
    local type = meta:get_string("type")  -- Read the type from metadata

    if self.itemname ~= "" then
        self.object:set_properties({textures = {self.itemname}})
        if type == "weapon_stand" then
            self.object:set_rotation({x = 0, y = self.y_rotation, z = self.rotation})
        elseif type == "table" then
            self.object:set_rotation({x = math.pi/2, y = self.rotation, z = 0})
        end
    end
end,

get_staticdata = function(self)
    return minetest.serialize({
        itemname = self.itemname,
        rotation = self.rotation,
        y_rotation = self.y_rotation
    })
end,
})


-- Function to register a table node
local function register_table(name, description, texture)
    minetest.register_node("variety:table_" .. name, {
        description = description .. " Table",
        drawtype = "mesh",
		visual_scale = 0.5,
        mesh = "table.obj", -- Ensure this is correct and the model exists in your mod folder.
        tiles = {texture},
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        overlay_tiles = {"blank.png"}, -- Start with a blank overlay.
        paramtype = "light",
        paramtype2 = "facedir",
after_place_node = function(pos, placer, itemstack, pointed_thing)
    local meta = minetest.get_meta(pos)
    meta:set_string("item", "")
    meta:set_float("rotation", 0)
    meta:set_string("type", "table")  -- Add this line
end,

        on_rightclick = function(pos, node, clicker, itemstack)
            local meta = minetest.get_meta(pos)
            local item = meta:get_string("item")

            -- Read and update the rotation angle
            local current_rotation = meta:get_float("rotation")
            local new_rotation = current_rotation + math.pi/4
            meta:set_float("rotation", new_rotation)

            if item and item ~= "" then
                -- If an item exists, find and update its rotation
                for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                    if obj and obj:get_luaentity() and obj:get_luaentity().name == "variety:item_on_table" then
                        obj:set_rotation({x = math.pi/2, y = new_rotation, z = 0})
                        return itemstack
                    end
                end
            else
                -- Else place a new item on the table
                local wield_item = clicker:get_wielded_item()
                local wield_item_name = wield_item:get_name()

                if wield_item:is_empty() or not wield_item_name then return end

                meta:set_string("item", wield_item_name)
                local item_entity = minetest.add_entity({x = pos.x, y = pos.y + 0.5, z = pos.z}, "variety:item_on_table")
    if item_entity then
        item_entity:set_rotation({x = math.pi/2, y = new_rotation, z = 0})
        local lua_entity = item_entity:get_luaentity()
        if lua_entity then
            lua_entity.itemname = wield_item_name
            lua_entity.rotation = new_rotation
            item_entity:set_properties({textures = {wield_item_name}})
        end
    end
    meta:set_float("rotation", new_rotation)  -- Store rotation in node's metadata


                itemstack:take_item(1)
                clicker:set_wielded_item(itemstack)
            end

            return itemstack
        end,

		on_punch = function(pos, node, puncher, pointed_thing)
			local meta = minetest.get_meta(pos)
			local item = meta:get_string("item")

			if not item or item == "" then return end

			puncher:get_inventory():add_item("main", item)
			meta:set_string("item", "")

    for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
        if obj and obj:get_luaentity() and obj:get_luaentity().name == "variety:item_on_table" then
            obj:remove()
        end
    end
    meta:set_float("rotation", 0)  -- Reset rotation in node's metadata
		end,
	})
end


-- Register crafts for a given wood type
local function register_table_craft(name, node_name)
    minetest.register_craft({
        output = "variety:table_" .. name,
        recipe = {
            {node_name, node_name, node_name},
            {"", node_name, ""},
            {"", node_name, ""}
        }
    })
end

-- Function to register a display stand node
local function register_weapon_stand(name, description, texture)
    minetest.register_node("variety:weapon_stand_" .. name, {
        description = description .. " Weapon Stand",
        drawtype = "mesh",
        mesh = "weaponstand.obj", -- Make sure this model exists in your mod folder.
		visual_scale = 0.6,
        tiles = {texture},
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        paramtype = "light",
        paramtype2 = "facedir",
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local meta = minetest.get_meta(pos)
			meta:set_string("item", "")
            meta:set_float("rotation", 0)
			meta:set_float("z_rot", 3)
    meta:set_float("y_rotation", 0)
    meta:set_string("type", "weapon_stand")  -- Add this line
end,

on_rightclick = function(pos, node, clicker, itemstack)
    local meta = minetest.get_meta(pos)
    local item = meta:get_string("item")
    local current_rotation = meta:get_float("rotation") or 0
	local zcurrot = meta:get_float("z_rot")
    local y_rotation = meta:get_float("y_rotation") or 0
	local newcurrot = zcurrot + math.pi/4
    local new_rotation = current_rotation + math.pi/4
    local new_y_rotation = y_rotation + math.pi/4

    local player_dir = minetest.dir_to_facedir(clicker:get_look_dir())

    if item and item ~= "" then
        for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
            if obj and obj:get_luaentity() and obj:get_luaentity().name == "variety:item_on_table" then
                if player_dir == 0 or player_dir == 2 then
                    obj:set_rotation({x = current_rotation, y = new_y_rotation, z = newcurrot})
                    meta:set_float("y_rotation", new_y_rotation)
                else
                    obj:set_rotation({x = new_rotation, y = y_rotation, z = zcurrot})
                    meta:set_float("rotation", new_rotation)
                end
                return itemstack
            end
        end
    else
        local wield_item = clicker:get_wielded_item()
        local wield_item_name = wield_item:get_name()

        if wield_item:is_empty() or not wield_item_name then return end

        meta:set_string("item", wield_item_name)
        local item_entity = minetest.add_entity({x = pos.x, y = pos.y + 0.5, z = pos.z}, "variety:item_on_table")
        if item_entity then
            item_entity:set_rotation({x = math.pi/2, y = 0, z = 0})
            local lua_entity = item_entity:get_luaentity()
            if lua_entity then
                lua_entity.itemname = wield_item_name
                lua_entity.rotation = 0
                item_entity:set_properties({textures = {wield_item_name}})
            end
        end
        meta:set_float("rotation", 0)
        meta:set_float("y_rotation", 0)
        itemstack:take_item(1)
        clicker:set_wielded_item(itemstack)
    end

    return itemstack
end,



        on_punch = function(pos, node, puncher, pointed_thing)
            local meta = minetest.get_meta(pos)
            local item = meta:get_string("item")

            if not item or item == "" then return end

            puncher:get_inventory():add_item("main", item)
            meta:set_string("item", "")
            meta:set_float("rotation", 0)
            meta:set_float("y_rotation", 0)

            for _, obj in pairs(minetest.get_objects_inside_radius(pos, 1)) do
                if obj and obj:get_luaentity() and obj:get_luaentity().name == "variety:item_on_table" then
                    obj:remove()
                end
            end
        end,
    })
end

-- Helper function to check for exclusions based on specific keywords and their cases
local function should_exclude_node(node_name)
    -- List of excluded keywords in various capitalizations
    local excluded_keywords = {
        "cracked", "Cracked", 
        "stair", "Stair", 
        "stairs", "Stairs", 
        "fence", "Fence", "frame", "Frame", "Box", "box", "shelf", "Shelf", "gate", "Gate", "Slab", "slab", "Brick", "brick", "_onc", "copper", "Copper", "dynamic", "x", "dynamic_trees", "cactus", "Cactus", "Table", "table", "weapon", "Weapon", "Rack", "rack", "coral", "1", "2", "3", "4", "5", "6", "mushroom", "Mushroom" , "Cap", "cap", "Goblin", "goblin", "ice", "Ice"
    }

    -- Check if node name contains any excluded keyword
    for _, keyword in ipairs(excluded_keywords) do
        if node_name:find(keyword) then
        if not (node_name:find("wood") or node_name:find("Wood") or node_name:find("planks") or node_name:find("Planks")) then
            return true
        end
        end
    end
    return false
end

-- Function to register crafts for weapon stand
local function register_weapon_stand_craft(name, node_name)
    minetest.register_craft({
        output = "variety:weapon_stand_" .. name,
        recipe = {
            {node_name, node_name, node_name},
            {"group:stick", "", "group:stick"},
            {"group:stick", "group:stick", "group:stick"}
        }
    })
end
-- Helper function to check if the node name should be excluded
local function should_register_node(node_name)
    -- Convert the node name to lowercase for consistent matching
    local lower_name = node_name:lower()

    -- Check if node name contains "wood" or "planks" and does not contain "table" or similar
    if (lower_name:find("wood") or lower_name:find("planks")) and 
       not (lower_name:find("table") or lower_name:find("stand") or lower_name:find("slab") or lower_name:find("stairs") or lower_name:find("fence")) then
        return true
    end
    return false
end

-- Loop through all registered nodes to find wood types and register corresponding tables, weapon stands, and crafts
for node_name, def in pairs(minetest.registered_nodes) do
    -- Skip nodes that do not meet registration criteria
    if not should_register_node(node_name) then
        goto continue
    end

    -- Extract the wood type from the node name, ignoring mod prefix
    local wood_type = node_name:match(":([^:]+)$")

    if wood_type then
        local description = def.description or "Wooden"
        local texture = def.tiles and def.tiles[1] or "unknown_texture.png"
        
        -- Register tables
        register_table(wood_type, description, texture)  
        register_table_craft(wood_type, node_name) 
        
        -- Register weapon stands
        register_weapon_stand(wood_type, description, texture)  
        register_weapon_stand_craft(wood_type, node_name)  
    end

    ::continue::
end


