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


-- Cracking system for bricks and glass
-- Uses explicit list of nodes instead of keyword matching

local cracked_overlay = "^crack.png"
local modname = "metal_melter"

-- Explicit list of nodes that should have cracked variants
-- Bricks from mud.lua
local crackable_bricks = {
    "default:mud_brick",
    "default:rhyolitebrick",
    "default:slatebrick",
    "default:limestonebrick",
    "default:shobblebrick",
    "default:scobblebrick",
    "default:quartzbrick",
    "default:onyxbrick",
    "default:marblebrick",
    "default:schistbrick",
    "default:basaltbrick",
    "default:gneissbrick",
    "default:granitebrick",
    "default:sstonebrick",
    "default:stonebrick",
    "default:bricks",
}

-- Glass/windows that should have cracked variants
local crackable_glass = {
    "default:glass",
    "default:obsidian_glass",
    "xpanes:pane_flat",
    "xpanes:pane",
    "xpanes:obsidian_pane_flat",
    "xpanes:obsidian_pane",
}

-- Function to register a cracked variant of a node
local function register_cracked_variant(node_name)
    local node_def = minetest.registered_nodes[node_name]
    if not node_def then
        return false
    end

    local clean_node_name = node_name:match("([^:]+)$")
    local cracked_node_name = modname .. ":" .. clean_node_name .. "_cracked"

    -- Copy the node definition
    local cracked_def = table.copy(node_def)

    -- Modify description
    cracked_def.description = (node_def.description or clean_node_name) .. " (Cracked)"

    -- Modify textures to add crack overlay
    if type(cracked_def.tiles) == "table" then
        for i, tile in ipairs(cracked_def.tiles) do
            if type(tile) == "string" then
                cracked_def.tiles[i] = tile .. cracked_overlay
            elseif type(tile) == "table" and tile.name then
                cracked_def.tiles[i] = table.copy(tile)
                cracked_def.tiles[i].name = tile.name .. cracked_overlay
            end
        end
    elseif type(cracked_def.tiles) == "string" then
        cracked_def.tiles = cracked_def.tiles .. cracked_overlay
    end

    -- Register the cracked variant
    minetest.register_node(cracked_node_name, cracked_def)
    return true
end

-- Replace node with cracked version (used by on_destruct/on_dig)
local function replace_with_cracked(pos, oldnode, digger)
    if oldnode and oldnode.name then
        local clean_old_name = oldnode.name:match("([^:]+)$")
        local cracked_name = modname .. ":" .. clean_old_name .. "_cracked"
        if minetest.registered_nodes[cracked_name] then
            minetest.set_node(pos, {name = cracked_name})
        end
    end
end

-- Global function for zombies/hordes to use when breaking nodes
function metal_melter.crack_node(pos)
    local node = minetest.get_node(pos)
    if node and node.name then
        local clean_name = node.name:match("([^:]+)$")
        local cracked_name = modname .. ":" .. clean_name .. "_cracked"
        if minetest.registered_nodes[cracked_name] then
            minetest.set_node(pos, {name = cracked_name})
            return true
        end
    end
    return false
end

-- on_blast handler for bricks - crack instead of destroy
local function brick_on_blast(pos, intensity)
    local node = minetest.get_node(pos)
    if node and node.name then
        -- If already cracked, let it be destroyed normally
        if node.name:find("_cracked$") then
            return
        end
        local clean_name = node.name:match("([^:]+)$")
        local cracked_name = modname .. ":" .. clean_name .. "_cracked"
        if minetest.registered_nodes[cracked_name] then
            minetest.set_node(pos, {name = cracked_name})
            return {}
        end
    end
end

-- Register cracked variants for bricks
for _, node_name in ipairs(crackable_bricks) do
    if register_cracked_variant(node_name) then
        -- Bricks: crack on dig/destruct AND explosion
        minetest.override_item(node_name, {
            on_destruct = replace_with_cracked,
            on_dig = replace_with_cracked,
            on_blast = brick_on_blast
        })
    end
end

-- Register cracked variants for glass
for _, node_name in ipairs(crackable_glass) do
    if register_cracked_variant(node_name) then
        -- Glass: crack on dig/destruct, shatter on explosion (default behavior)
        minetest.override_item(node_name, {
            on_destruct = replace_with_cracked,
            on_dig = replace_with_cracked
        })
    end
end
