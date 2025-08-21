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

-- Register the sleeping bag as a bed
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

-- Register the hammock as a bed
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

-- Hammock placement logic
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if newnode.name == "beds:blanket" then
        local found_tree = false
        local end_pos = nil
        local distance = 0

        -- Search for trees
        for dx = -3, 3 do
            for dz = -3, 3 do
                if dx ~= 0 or dz ~= 0 then
                    local check_pos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                    local check_node = minetest.get_node(check_pos).name
                    if check_node == "default:tree" then
                        found_tree = true
                        end_pos = check_pos
                        distance = math.abs(dx) + math.abs(dz)
                        break
                    end
                end
            end
            if found_tree then break end
        end

        -- Place hammocks
        if found_tree and end_pos and distance >= 2 and distance <= 4 then
            local x_step = (end_pos.x - pos.x) / distance
            local z_step = (end_pos.z - pos.z) / distance

            for i = 1, distance - 1 do
                local hammock_pos = {x = pos.x + i * x_step, y = pos.y, z = pos.z + i * z_step}
                minetest.set_node(hammock_pos, {name="beds:hammock", param2=1})  -- param2=1 for 90 degree rotation
            end

            minetest.remove_node(pos)
            itemstack:take_item(1)
            return itemstack
        else
            return
        end
    end
end)

-- Handle hammock removal
minetest.register_on_dignode(function(pos, oldnode, digger)
    if oldnode.name == "beds:hammock" then
        for dx = -3, 3 do
            for dz = -3, 3 do
                local check_pos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                local check_node = minetest.get_node(check_pos).name
                if check_node == "beds:hammock" then
                    minetest.remove_node(check_pos)
                end
            end
        end
    end
end)
