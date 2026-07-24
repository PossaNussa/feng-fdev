-- START RAW MATERIALS

local texture_style = minetest.setting_get("birthstones_texture_style") or "classic"
-- can also be "realistic" if all block textures are implemented

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then
        io.close(f)
        return true
    else return false
    end
end

local function get_block_tiles(name)
    local this_texture_style = texture_style
    local path = nil
    if this_texture_style == "realistic" then
        -- if file_exists("birthstones_" .. name .. "_block_top.png") then
            path = { "birthstones_" .. name .. "_block_top.png", "birthstones_" .. name .. "_block_top.png", "birthstones_" .. name .. "_block_east.png", "birthstones_" .. name .. "_block_east.png", "birthstones_" .. name .. "_block_north.png", "birthstones_" .. name .. "_block_north.png" }
        -- else
        --  this_texture_style = "classic"
        -- end
    end
    -- intentionally don't use else since fallback to classic may have been performed above:
    if this_texture_style == "classic" then
        path = { "birthstones_" .. name .. "_block.png" }
    end
    return path
end

minetest.register_node( "birthstones:stone_with_alexandrite", {
    description = "Stone with Alexandrite",
    tiles = { "default_stone.png^birthstones_mineral_alexandrite.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = "birthstones:alexandrite",
})
minetest.register_node( "birthstones:stone_with_aquamarine", {
    description = "Stone with Aquamarine",
    tiles = { "default_stone.png^birthstones_mineral_aquamarine.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = "birthstones:aquamarine",
})
minetest.register_node( "birthstones:stone_with_diamond", {
    description = "Stone with White Diamond",
    tiles = { "default_stone.png^birthstones_mineral_diamond.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = "birthstones:diamond",
})
minetest.register_node( "birthstones:stone_with_topaz", {
    description = "Stone with Topaz",
    tiles = { "default_stone.png^birthstones_mineral_topaz.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = "birthstones:topaz",
})
minetest.register_node( "birthstones:stone_with_zircon", {
    description = "Stone with Zircon",
    tiles = { "default_stone.png^birthstones_mineral_zircon.png" },
    is_ground_content = true,
    groups = {cracky=1},
    sounds = default.node_sound_stone_defaults(),
    drop = "birthstones:zircon",
})

-- END RAW MATERIALS


-- START BLOCKS


minetest.register_node( "birthstones:alexandriteblock", {
    description = "Alexandrite Block",
    tiles = get_block_tiles("alexandrite"),
    is_ground_content = true,
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "birthstones:aquamarineblock", {
    description = "Aquamarine Block",
    tiles = get_block_tiles("aquamarine"),
    is_ground_content = true,
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "birthstones:diamondblock", {
    description = "White Diamond Block",
    tiles = get_block_tiles("diamond"),
    is_ground_content = true,
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),
})
-- tiles: +Y, -Y, +X, -X, +Z, -Z. In English: top, bottom, right, left, back, front.  - http://dev.minetest.net/minetest.register_node
minetest.register_node( "birthstones:topazblock", {
    description = "Topaz Block",
    tiles = get_block_tiles("topaz"),
    is_ground_content = true,
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),
})
minetest.register_node( "birthstones:zirconblock", {
    description = "Zircon Block",
    tiles = get_block_tiles("zircon"),
    is_ground_content = true,
    groups = {cracky = 1, level = 3},
    sounds = default.node_sound_stone_defaults(),
})
