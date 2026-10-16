-- beds/beds.lua

-- support for MT game translation.
local S = beds.get_translator

-- Fancy shaped bed

beds.register_bed("beds:fancy_bed", {
	description = S("Fancy Bed"),
	inventory_image = "beds_bed_fancy.png",
	wield_image = "beds_bed_fancy.png",
	tiles = {
		bottom = {
			"beds_bed_top1.png",
			"beds_bed_under.png",
			"beds_bed_side1.png",
			"beds_bed_side1.png^[transformFX",
			"beds_bed_foot.png",
			"beds_bed_foot.png",
		},
		top = {
			"beds_bed_top2.png",
			"beds_bed_under.png",
			"beds_bed_side2.png",
			"beds_bed_side2.png^[transformFX",
			"beds_bed_head.png",
			"beds_bed_head.png",
		}
	},
	nodebox = {
		bottom = {
			{-0.5, -0.5, -0.5, -0.375, -0.065, -0.4375},
			{0.375, -0.5, -0.5, 0.5, -0.065, -0.4375},
			{-0.5, -0.375, -0.5, 0.5, -0.125, -0.4375},
			{-0.5, -0.375, -0.5, -0.4375, -0.125, 0.5},
			{0.4375, -0.375, -0.5, 0.5, -0.125, 0.5},
			{-0.4375, -0.3125, -0.4375, 0.4375, -0.0625, 0.5},
		},
		top = {
			{-0.5, -0.5, 0.4375, -0.375, 0.1875, 0.5},
			{0.375, -0.5, 0.4375, 0.5, 0.1875, 0.5},
			{-0.5, 0, 0.4375, 0.5, 0.125, 0.5},
			{-0.5, -0.375, 0.4375, 0.5, -0.125, 0.5},
			{-0.5, -0.375, -0.5, -0.4375, -0.125, 0.5},
			{0.4375, -0.375, -0.5, 0.5, -0.125, 0.5},
			{-0.4375, -0.3125, -0.5, 0.4375, -0.0625, 0.4375},
		}
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"", "", "group:stick"},
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

-- Simple shaped bed

beds.register_bed("beds:bed", {
	description = S("Simple Bed"),
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {
		bottom = {
			"beds_bed_top_bottom.png^[transformR90",
			"beds_bed_under.png",
			"beds_bed_side_bottom_r.png",
			"beds_bed_side_bottom_r.png^[transformfx",
			"beds_transparent.png",
			"beds_bed_side_bottom.png"
		},
		top = {
			"beds_bed_top_top.png^[transformR90",
			"beds_bed_under.png",
			"beds_bed_side_top_r.png",
			"beds_bed_side_top_r.png^[transformfx",
			"beds_bed_side_top.png",
			"beds_transparent.png",
		}
	},
	nodebox = {
		bottom = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
		top = {-0.5, -0.5, -0.5, 0.5, 0.0625, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.0625, 1.5},
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"}
	},
})

-- Aliases for PilzAdam's beds mod

minetest.register_alias("beds:bed_bottom_red", "beds:bed_bottom")
minetest.register_alias("beds:bed_top_red", "beds:bed_top")

-- Fuel

minetest.register_craft({
	type = "fuel",
	recipe = "beds:fancy_bed_bottom",
	burntime = 13,
})

minetest.register_craft({
	type = "fuel",
	recipe = "beds:bed_bottom",
	burntime = 12,
})

-- Register the blanket item
minetest.register_craftitem("beds:blanket", {
    description = "Blanket",
    inventory_image = "blanket.png",
})

-- Register the sleeping bag as a bed (no spawn setting)
beds.register_bed("beds:sleeping_bag", {
    description = "Sleeping Bag",
    inventory_image = "wool_green.png",
    wield_image = "wool_green.png",
    recipe = {
        {"beds:blanket", "beds:blanket"}
    },
    tiles = {
        bottom = {
            "wool_green.png", "wool_green.png", "wool_green.png",
            "wool_green.png", "wool_green.png", "wool_green.png",
        },
        top = {
            "wool_green.png", "wool_green.png", "wool_green.png",
            "wool_green.png", "wool_green.png", "wool_green.png",
        },
    },
    nodebox = {
        bottom = {-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5},
        top = {-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5},
    },
    selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.0625, 1.5},
})
-- Mark sleeping bag as no-spawn
minetest.override_item("beds:sleeping_bag_bottom", {
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, bed_no_spawn = 1},
})

-- Register the hammock as a bed (no spawn setting)
-- The hammock is placed by right-clicking a tree trunk with the hammock item.
-- It searches along the 4 cardinal axes for a second tree trunk 3 blocks away,
-- placing the 2-node bed between the two trees with air required below.
beds.register_bed("beds:hammock", {
    description = "Hammock",
    inventory_image = "wool_green.png",
    wield_image = "wool_green.png",
    recipe = {
        {"beds:blanket"}
    },
    tiles = {
        bottom = {
            "wool_green.png", "wool_green.png", "wool_green.png",
            "wool_green.png", "wool_green.png", "wool_green.png",
        },
        top = {
            "wool_green.png", "wool_green.png", "wool_green.png",
            "wool_green.png", "wool_green.png", "wool_green.png",
        },
    },
    nodebox = {
        bottom = {-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5},
        top = {-0.5, -0.5, -0.5, 0.5, -0.0625, 0.5},
    },
    selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.0625, 1.5},
})
-- Hammock placement: override on_place to require two trees with air below
-- Layout: tree | bed_bottom | bed_top | tree (3 blocks apart along one axis)
-- Player right-clicks a tree trunk. We search the 4 cardinal directions for a
-- second tree trunk exactly 3 blocks away. The two nodes between them become
-- the hammock, and both must have air below.
local cardinal_dirs = {
    {x =  1, z =  0},
    {x = -1, z =  0},
    {x =  0, z =  1},
    {x =  0, z = -1},
}

-- Map cardinal direction to facedir so the hammock aligns head-to-foot along the axis
-- facedir: 0 = +Z, 1 = +X, 2 = -Z, 3 = -X
local dir_to_facedir = {
    [{x =  1, z =  0}] = 1,
    [{x = -1, z =  0}] = 3,
    [{x =  0, z =  1}] = 0,
    [{x =  0, z = -1}] = 2,
}
-- Build a lookup by string key since table keys don't match by value
local facedir_lookup = {}
for d, f in pairs(dir_to_facedir) do
    facedir_lookup[d.x .. "," .. d.z] = f
end

local function is_tree(pos)
    return minetest.get_item_group(minetest.get_node(pos).name, "tree") > 0
end

minetest.override_item("beds:hammock_bottom", {
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, bed_no_spawn = 1},
    on_place = function(itemstack, placer, pointed_thing)
        if not placer or not placer:is_player() then return itemstack end
        if pointed_thing.type ~= "node" then return itemstack end

        local tree1 = pointed_thing.under
        if not is_tree(tree1) then
            minetest.chat_send_player(placer:get_player_name(),
                "Place the hammock against a tree trunk.")
            return itemstack
        end

        local player_name = placer:get_player_name()

        -- Try each cardinal direction from tree1 to find a second tree 3 blocks away
        local placed = false
        for _, d in ipairs(cardinal_dirs) do
            local tree2 = {x = tree1.x + d.x * 3, y = tree1.y, z = tree1.z + d.z * 3}
            if is_tree(tree2) then
                -- The two hammock positions between the trees
                local pos1 = {x = tree1.x + d.x,     y = tree1.y, z = tree1.z + d.z}
                local pos2 = {x = tree1.x + d.x * 2, y = tree1.y, z = tree1.z + d.z * 2}
                local below1 = {x = pos1.x, y = pos1.y - 1, z = pos1.z}
                local below2 = {x = pos2.x, y = pos2.y - 1, z = pos2.z}

                -- Both hammock positions must be air, and air below them
                local n1 = minetest.get_node(pos1).name
                local n2 = minetest.get_node(pos2).name
                local b1 = minetest.get_node(below1).name
                local b2 = minetest.get_node(below2).name
                if (n1 == "air" and n2 == "air" and b1 == "air" and b2 == "air") then
                    -- Protection check
                    if minetest.is_protected(pos1, player_name) or
                       minetest.is_protected(pos2, player_name) then
                        minetest.record_protection_violation(pos1, player_name)
                        return itemstack
                    end

                    -- facedir: bed_bottom at pos1, bed_top at pos2
                    -- facedir_to_dir(param2) points from bottom toward top
                    local facedir = facedir_lookup[d.x .. "," .. d.z]
                    minetest.set_node(pos1, {name = "beds:hammock_bottom", param2 = facedir})
                    minetest.set_node(pos2, {name = "beds:hammock_top",    param2 = facedir})

                    if not minetest.is_creative_enabled(player_name) then
                        itemstack:take_item()
                    end
                    placed = true
                    break
                end
            end
        end

        if not placed then
            minetest.chat_send_player(player_name,
                "Need two tree trunks 3 blocks apart with air between and below.")
        end
        return itemstack
    end,
})
