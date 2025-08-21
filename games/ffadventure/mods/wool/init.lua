-- wool/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator("wool")

local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name

	minetest.register_node("wool:" .. name, {
		description = S(desc .. " Wool"),
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1, [color_group] = 1},
		sounds = default.node_sound_defaults(),
	})

	minetest.register_craft{
		type = "shapeless",
		output = "wool:" .. name,
		recipe = {"group:dye," .. color_group, "group:wool"},
	}
end

-- Legacy
-- Backwards compatibility with jordach's 16-color wool mod
minetest.register_alias("wool:dark_blue", "wool:blue")
minetest.register_alias("wool:gold", "wool:yellow")

-- Dummy calls to S() to allow translation scripts to detect the strings.
-- To update this run:
-- for _,e in ipairs(dye.dyes) do print(("S(%q)"):format(e[2].." Wool")) end

--[[
S("White Wool")
S("Grey Wool")
S("Dark Grey Wool")
S("Black Wool")
S("Violet Wool")
S("Blue Wool")
S("Cyan Wool")
S("Dark Green Wool")
S("Green Wool")
S("Yellow Wool")
S("Brown Wool")
S("Orange Wool")
S("Red Wool")
S("Magenta Wool")
S("Pink Wool")
--]]

local player_sitting = {}  -- To keep track of sitting players
local sitting_positions = {}  -- To keep track of where players are sitting

-- Function to teleport player back to sitting position
local function reset_position(player_name)
    local player = minetest.get_player_by_name(player_name)
    if player and player_sitting[player_name] then
        player:set_velocity({x=0, y=0, z=0})
        minetest.after(0.1, reset_position, player_name)
    end
end
-- Function to register a couch node
local function register_couch(name, description, texture)
    minetest.register_node("wool:couch_" .. name, {
        description = description .. " Couch",
        drawtype = "mesh",
        mesh = "couch.obj",
        visual_scale = 0.4,
        tiles = {texture},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- Full node collision
                {-1, -0.5, -0.5, -0.5, 0.5, 0.5}, -- Left node collision
            },
        },
    on_rightclick = function(pos, node, clicker)
        local player_name = clicker:get_player_name()
        if not player_sitting[player_name] then
            -- Disable player movement and jumping
            clicker:set_physics_override({speed = 0, jump = 0})
            player_sitting[player_name] = true
            sitting_positions[player_name] = {x = pos.x, y = pos.y - 0.5, z = pos.z}
            clicker:set_pos(sitting_positions[player_name])
            minetest.after(0.1, reset_position, player_name)
        else
            -- Enable player movement and jumping
            clicker:set_physics_override({speed = 1, jump = 1})
            player_sitting[player_name] = nil
            sitting_positions[player_name] = nil
        end
    end,
        after_place_node = function(pos, placer)
            local meta = minetest.get_meta(pos)
            meta:set_string("sitting_player", "")
        end,
    })
end

-- Function to register crafts for couch
local function register_couch_craft(name, wool_node_name)
    minetest.register_craft({
        output = "wool:couch_" .. name,
        recipe = {
            {"", "", ""},
            {wool_node_name, wool_node_name, ""},
            {"group:wood", "group:wood", ""}
        }
    })
end

-- Loop through all registered nodes to find wool types and register corresponding couches and crafts
for wool_node_name, def in pairs(minetest.registered_nodes) do
    if def.groups and def.groups.wool and not def.groups.not_in_craft_guide then
        local wool_type = wool_node_name:match(":([^:]+)$") -- Extracts the wool type from the wool_node_name
        if wool_type then
            local description = def.description or "Woolen"
            local texture = def.tiles and def.tiles[1] or "unknown_texture.png"
            
            -- Register couches
            register_couch(wool_type, description, texture)
            register_couch_craft(wool_type, wool_node_name)
        end
    end
end

