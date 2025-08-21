-- Metal Melter for Minetest 0.5.0+
-- Copyright (c) 2018 Evert "Diamond" Prants <evert@lunasqu.ee>

local modpath = minetest.get_modpath("metal_melter")
metal_melter = {}

-- Melting database
dofile(modpath.."/meltable.lua")

-- Crafting components
dofile(modpath.."/components.lua")

-- Fluid bar for formspec
function metal_melter.fluid_bar(x, y, fluid_buffer)
	local texture = "default_water.png"
	local metric  = 0

	if fluid_buffer and fluid_buffer.fluid and fluid_buffer.fluid ~= "" and
		minetest.registered_nodes[fluid_buffer.fluid] ~= nil then
		texture = minetest.registered_nodes[fluid_buffer.fluid].tiles[1]
		if type(texture) == "table" then
			texture = texture.name
		end
		metric  = math.floor(100 * fluid_buffer.amount / fluid_buffer.capacity)
	end

	return "image["..x..","..y..";1,2.8;melter_gui_barbg.png"..
		   "\\^[lowpart\\:"..metric.."\\:"..texture.."\\\\^[resize\\\\:64x128]"..
		   "image["..x..","..y..";1,2.8;melter_gui_gauge.png]"
end

-- Melter
dofile(modpath.."/melter.lua")

-- Caster
dofile(modpath.."/caster.lua")


-- Register cracked brick variants for blocks with "Brick" in their description
-- Define the cracked texture overlay
local cracked_overlay = "^crack.png"

-- Replace 'your_mod_name' with the actual name of your mod
local modname = "metal_melter"

-- Function to register cracked bricks
local function register_cracked_bricks(node_name, node_def)
    -- Ensure node_name does not have extra colons
    local clean_node_name = node_name:match("([^:]+)$")
    local cracked_node_name = modname .. ":" .. clean_node_name .. "_cracked"

    -- Copy the node definition
    local cracked_def = table.copy(node_def)
    
    -- Modify the cracked brick's description
    cracked_def.description = node_def.description .. " (Cracked)"
    
    -- Modify the cracked brick's textures
    if type(cracked_def.tiles) == "table" then
        -- Handle case where tiles is an array of tables
        for i, tile in ipairs(cracked_def.tiles) do
            if type(tile) == "string" then
                cracked_def.tiles[i] = tile .. cracked_overlay
            else
                -- Handle case where tile is a table (e.g., {name = "texture.png"})
                local tile_str = tile.name or tile
                cracked_def.tiles[i] = tile_str .. cracked_overlay
            end
        end
    elseif type(cracked_def.tiles) == "string" then
        cracked_def.tiles = cracked_def.tiles .. cracked_overlay
    end
    
    -- Register the cracked variant
    minetest.register_node(cracked_node_name, cracked_def)
end

local function replace_with_cracked(pos, oldnode, digger)
    if oldnode and oldnode.name then
        local clean_old_name = oldnode.name:match("([^:]+)$")
        local cracked_name = modname .. ":" .. clean_old_name .. "_cracked"
        if minetest.registered_nodes[cracked_name] then
            minetest.set_node(pos, {name = cracked_name})
        end
    end
end
-- List of keywords to search for in node descriptions
local keywords = {
    "Brick", "Bricks", "Glass", "Frame", "bench", "Bench", "Box", "box", 
    "Container", "container", "Barrel", "barrel", "Shelf", "shelf", 
    "Stair", "Stairs", "stair", "stairs", "Granite", "brick", "bricks", "glass"
}

-- Helper function to check if the node's description contains any keyword
local function contains_keyword(description, keywords)
    for _, keyword in ipairs(keywords) do
        if description:find(keyword) then
        if not (description:find("Cracked") or description:find("cracked")) then
            return true
        end
        end
    end
    return false
end

-- Track registered cracked nodes to avoid duplicates
local registered_cracked_nodes = {}

-- Modified node registration to control excessive node creation
for node_name, node_def in pairs(minetest.registered_nodes) do
    if node_def.description and contains_keyword(node_def.description, keywords) then
        -- Avoid re-registering cracked nodes
        local clean_node_name = node_name:match("([^:]+)$")
        local cracked_node_name = modname .. ":" .. clean_node_name .. "_cracked"

        -- Register cracked nodes only if not already registered
        if not registered_cracked_nodes[cracked_node_name] then
            register_cracked_bricks(node_name, node_def)
            registered_cracked_nodes[cracked_node_name] = true

            -- Set callbacks only once to avoid excessive registrations
            minetest.override_item(node_name, {
                on_destruct = replace_with_cracked,
                on_dig = replace_with_cracked
            })
        end
    end
end



register_cracked_bricks("clay_bricks:dark_green", minetest.registered_nodes["clay_bricks:dark_green"])
