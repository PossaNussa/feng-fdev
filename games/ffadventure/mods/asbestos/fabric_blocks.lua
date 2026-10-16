
-- This uses code from Minetest Game which was originally made by celeron55, 
-- which is a pretty cool dude by the way.

-- Load support for MT game translation.
-- local S = minetest.get_translator("idk")



local dyes = dye.dyes

for i = 1, #dyes do
	local name, desc = unpack(dyes[i])

	local color_group = "color_" .. name

	minetest.register_node("asbestos:fabric_block_" .. name, {
		description = (desc .. " Asbestos Fabric Wool"),
		tiles = {"asbestos_fabric_block_" .. name .. ".png"},
		is_ground_content = false,
		groups = {oddly_breakable_by_hand = 1, snappy = 1, asbestos_fabric = 1, [color_group] = 1},
		sounds = default.node_sound_leaves_defaults(),
	})


	minetest.register_craft{
		type = "shapeless",
		output = "asbestos:fabric_block_" .. name,
		recipe = {"group:dye," .. color_group, "group:asbestos_fabric"},
	}
end

-- Dummy calls to S() to allow translation scripts to detect the strings.
-- To update this run:
-- for _,e in ipairs(dye.dyes) do print(("S(%q)"):format(e[2].." button")) end

--[[
S("White Button")
S("Grey Button")
S("Dark Grey Button")
S("Black Button")
S("Violet Button")
S("Blue Button")
S("Cyan Button")
S("Dark Green Button")
S("Green Button")
S("Yellow Button")
S("Brown Button")
S("Orange Button")
S("Red Button")
S("Magenta Button")
S("Pink Button")
--]]

minetest.register_craft({
	output = "asbestos:fabric_block_grey",
	recipe = {
		{"asbestos:fabric", "asbestos:fabric"},
		{"asbestos:fabric", "asbestos:fabric"},
	}
})