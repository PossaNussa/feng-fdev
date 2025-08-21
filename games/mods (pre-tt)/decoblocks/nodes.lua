

minetest.register_node("decoblocks:old_stone_tiles", {
    description = "Old Stone Tiles",
    tiles = {"decoblocks_old_stone_tiles.png"},
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:old_stone_tiles_with_dirt", {
    description = "Old Stone Tiles With Dirt",
    tiles = {"decoblocks_old_stone_tiles_with_dirt.png"},
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:moss_old_stone_tiles", {
    description = "Mossy Old Stone Tiles",
    tiles = {"decoblocks_mossy_old_stone_tiles.png"},
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:moss_stonebrick", {
    description = "Mossy Stone Brick",
    paramtype2 = "facedir",
    place_param2 = 0,
    tiles = {"decoblocks_moss_stone_brick.png"},
    is_ground_content = false,
    groups = {cracky = 2, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:scarecrow", {
    description = "Scarecrow",
    drawtype = "mesh",
    mesh = "scarecrow.obj",
    paramtype2 = "facedir",
    tiles = {
        "decoblocks_scarecrow.png",
    },
    visual_scale = 0.5,
    wield_image = "decoblocks_scarecrow_item.png",
    wield_scale = {x=1.0, y=1.0, z=1.0},
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
    },
    inventory_image = "decoblocks_scarecrow_item.png",
    groups = {choppy = 1, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_wood_defaults()
})




minetest.register_node("decoblocks:vase", {
    description = "Vase",
    drawtype = "mesh",
    mesh = "vase.obj",
    tiles = {
        "vase.png",
    },
    visual_scale = 0.5,
    wield_scale = {x=0.5, y=0.5, z=0.5},
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {cracky = 2, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("decoblocks:Ancient_vase", {
    description = "Ancient Vase",
    drawtype = "mesh",
    mesh = "vase.obj",
    tiles = {
        "Ancient_vase.png",
    },
    visual_scale = 0.5,
    wield_scale = {x=0.5, y=0.5, z=0.5},
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {cracky = 2, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:Ancient_vase_sand", {
    description = "Sandstone Vase",
    drawtype = "mesh",
    mesh = "vase.obj",
    tiles = {
        "Ancient_vase_sand.png",
    },
    visual_scale = 0.5,
    wield_scale = {x=0.5, y=0.5, z=0.5},
    paramtype = "light",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {cracky = 2, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

chest_items = {
    {"default:gold_ingot", 3},
}

minetest.register_node("decoblocks:chest", {
    description = "Treasure Chest",
    tiles = {"decoblocks_chest_top.png", "decoblocks_chest_top.png", "decoblocks_chest_side.png",
        "decoblocks_chest_side.png", "decoblocks_chest_side.png", "decoblocks_chest_front.png"},
    paramtype2 = "facedir",
    groups = {cracky = 2, oddly_breakable_by_hand = 1},
    is_ground_content = false,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        for _, row in ipairs(chest_items) do
        local item = row[1]
        local rarity = row[2]
        if math.random(1,rarity) == 1 then
            meta:set_string("item", item)
        else
            meta:set_string("item", "default:steel_ingot 3")
        end
        end
        inv:set_size("main", 1*1)
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("main")
    end,
    on_rightclick = function(pos, node, clicker, item, _)
        local name = clicker:get_player_name()
        --if clicker:get_wielded_item():get_name() == "hyruletools:key" then
            item:take_item()
            local meta = minetest.get_meta(pos)
            local item = meta:get_string("item")
            if item == nil then
                for _, row in ipairs(chest_items) do
                local item = row[1]
                local rarity = row[2]
                if math.random(1,rarity) == 1 then
                    meta:set_string("item", item)
                    return
                else
                    meta:set_string("item", "default:steel_ingot 3")
                end
                end
            end
            minetest.env:add_item(pos, item)
            minetest.env:remove_node(pos)
        --else
        --minetest.chat_send_player(name, "It is locked, you need a key!")
        --end
    end,
})

minetest.register_node("decoblocks:dartblock", {
    description = "Dart Trap",
    tiles = {
        "decoblocks_dartblock_top.png",
        "decoblocks_dartblock_top.png",
        "decoblocks_dartblock_sides.png",
        "decoblocks_dartblock_sides.png",
        "decoblocks_dartblock_sides.png",
        "decoblocks_dartblock_front.png",
    },
    groups = {cracky = 1,},
    paramtype2 = "facedir",
    drop = "decoblocks:dart_item2 5"
})

minetest.register_entity("decoblocks:dart", {
    visual = "cube",
    textures = {
    "decoblocks_dart.png",
    "decoblocks_dart.png",
    "decoblocks_dart.png",
    "decoblocks_dart.png",
    "decoblocks_dart.png",
    "decoblocks_dart.png",
    },
    visual_size={x=0.1,y=0.1},
    collisionbox = {0, 0, 0, 0, 0, 0},
    physical = false,
    automatic_rotate = true,
    automatic_face_movement_dir = 0,
    on_activate = function(self)
        minetest.after(3, function()
            self.object:remove()
        end)
    end,
    on_step = function(self, dtime)
        local pos = self.object:getpos()
        local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y-0.5,z=pos.z}, 0.5) 
            for k, obj in pairs(objs) do
                if obj:is_player() then
                    obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        self.object:remove()
                end
                if obj:get_luaentity() ~= nil then
                    if obj:get_luaentity().name ~= "decoblocks:dart" and obj:get_luaentity().name ~= "__builtin:item" then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        self.object:remove()
                    end
                end
            end
    end
})

minetest.register_entity("decoblocks:dart2", {
    visual = "cube",
    textures = {
    "decoblocks_dart2.png",
    "decoblocks_dart2.png",
    "decoblocks_dart2.png",
    "decoblocks_dart2.png",
    "decoblocks_dart2.png",
    "decoblocks_dart2.png",
    },
    visual_size={x=0.1,y=0.1},
    collisionbox = {0, 0, 0, 0, 0, 0},
    physical = false,
    automatic_rotate = true,
    automatic_face_movement_dir = 0,
    on_activate = function(self)
        minetest.after(3, function()
            self.object:remove()
        end)
    end,
    on_step = function(self, dtime)
        local pos = self.object:getpos()
        local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y-0.5,z=pos.z}, 0.5) 
            for k, obj in pairs(objs) do
                if obj:is_player() then
                    obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                    minetest.after(1, function()
                    if obj:is_player() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                    end
                    end)
                    minetest.after(2, function()
                    if obj:is_player() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                    end
                    end)
                    minetest.after(3, function()
                    if obj:is_player() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                    end
                    end)
                        self.object:remove()
                end
                if obj:get_luaentity() ~= nil then
                    if obj:get_luaentity().name ~= "decoblocks:dart" and obj:get_luaentity().name ~= "__builtin:item" then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        minetest.after(1, function()
                        if obj:get_luaentity() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        end
                        end)
                        minetest.after(2, function()
                        if obj:get_luaentity() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        end
                        end)
                        minetest.after(3, function()
                        if obj:get_luaentity() ~= nil then
                        obj:punch(self.object, 1.0, {
                            full_punch_interval=1.0,
                            damage_groups={fleshy=3},
                        }, nil)
                        end
                        end)
                        self.object:remove()
                    end
                end
            end
    end
})

minetest.register_abm({
    nodenames = {"decoblocks:dartblock"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        local x = 0
        local z = 0
        if node.param2 == 0 then
            z = -1
        elseif node.param2 == 2 then
            z = 1
        elseif node.param2 == 1 then
            x = -1
        elseif node.param2 == 3 then
            x = 1
        end
        --minetest.chat_send_all(node.param2)
        local numbers = {
        {1},
        {2},
        {3},
        {4},
        }
        for _, number in ipairs(numbers) do
        local num = number[1]
        local objs = minetest.get_objects_inside_radius({x=pos.x+x*num, y=pos.y-0.5, z=pos.z+z*num}, 1.5)
        for _, obj in ipairs(objs) do
            if obj:is_player() then
                local ent = minetest.env:add_entity(pos, "decoblocks:dart")
                ent:setvelocity({x=7*x, y=0, z=7*z})
            end
        end
        end
    end
})


minetest.register_tool("decoblocks:blowpipe", {
    description = "Dart Blow Pipe",
    inventory_image = "decoblocks_blowdart.png",
    on_use = function(itemstack, placer)
        local dir = placer:get_look_dir()
        local pos = placer:getpos()
        local pname = placer:get_player_name();
        inv = minetest.get_inventory({type="player", name=pname})
        if inv:contains_item("main", "decoblocks:dart_item2") then
        local ent = minetest.env:add_entity({x=pos.x+1*dir.x, y=pos.y+1.5, z=pos.z+1*dir.z}, "decoblocks:dart2")
        ent:setvelocity({x=15*dir.x, y=15*dir.y, z=15*dir.z})
        local remov = inv:remove_item("main", "decoblocks:dart_item2")
        elseif inv:contains_item("main", "decoblocks:dart_item") then
        local ent = minetest.env:add_entity({x=pos.x+1*dir.x, y=pos.y+1.5, z=pos.z+1*dir.z}, "decoblocks:dart")
        ent:setvelocity({x=15*dir.x, y=15*dir.y, z=15*dir.z})
        local remov = inv:remove_item("main", "decoblocks:dart_item")
        end
    end,
})

minetest.register_craftitem("decoblocks:dart_item", {
    description = "Dart",
    inventory_image = "decoblocks_dart_item.png",
})

minetest.register_craftitem("decoblocks:dart_item2", {
    description = "Dart",
    inventory_image = "decoblocks_dart_item2.png",
})


minetest.register_node("decoblocks:human_skull", {
    description = "Human Skull",
    drawtype = "mesh",
    mesh = "human_skull.obj",
    tiles = {
        "human_skull.png",
    },
    visual_scale = 0.5,
    wield_image = "decoblocks_skull_item.png",
    wield_scale = {x=1.0, y=1.0, z=1.0},
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    inventory_image = "decoblocks_skull_item.png",
    groups = {choppy = 1, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_wood_defaults()
})
minetest.register_node("decoblocks:old_skeleton", {
    description = "Old Human Skeleton",
    drawtype = "mesh",
    mesh = "decoblocks_old_skeleton.obj",
    tiles = {
        "decoblocks_old_skeleton.png",
    },
    visual_scale = 0.5,
    wield_image = "decoblocks_skull_item.png",
    wield_scale = {x=1.0, y=1.0, z=1.0},
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    inventory_image = "decoblocks_skull_item.png",
    groups = {choppy = 1, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_wood_defaults()
})

minetest.register_node("decoblocks:old_skeleton_alt", {
    description = "Old Human Skeleton alt",
    drawtype = "mesh",
    mesh = "decoblocks_old_skeleton2.obj",
    tiles = {
        "decoblocks_old_skeleton.png",
    },
    visual_scale = 0.5,
    wield_image = "decoblocks_skull_item.png",
    wield_scale = {x=1.0, y=1.0, z=1.0},
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}
    },
    inventory_image = "decoblocks_skull_item.png",
    groups = {choppy = 1, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_wood_defaults()
})

minetest.register_node("decoblocks:paper_lantern", {
    description = "Paper Lantern",
    tiles = {"decoblocks_paper_lantern_top.png", "decoblocks_paper_lantern_top.png", "decoblocks_paper_lantern.png"},
    paramtype = "light",
    light_source = 13,
    is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
                flammable = 3, wool = 1},
        sounds = default.node_sound_defaults(),
})

minetest.register_abm({
    nodenames = {"decoblocks:paper_lantern"},
    interval = 5,
    chance = 1,
    action = function(pos, node)
        minetest.add_particle({
            pos = {x=pos.x, y=pos.y, z=pos.z},
            velocity = {x=0, y=0, z=0},
            acceleration = {x=0, y=0, z=0},
            expirationtime = 5,
            size = 25,
            collisiondetection = false,
            collisionremoval = false,
            vertical = true,
            texture = "decoblocks_glow.png",
            animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 2.00},
            glow = 9
        })
    end
})

minetest.register_node("decoblocks:mammoth_wool", {
    description = "Mammoth Wool",
    tiles = {"decoblocks_mammoth_wool.png"},
    groups = {crumbly = 3, soil = 1},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("decoblocks:bone_pillar", {
    description = "Bone Pillar",
    tiles = {"decoblocks_bone_pillar_top.png", "decoblocks_bone_pillar_top.png", "decoblocks_bone_pillar.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),

    on_place = minetest.rotate_node
})

minetest.register_node("decoblocks:framed_glass", {
    description = "Glass With Wooden Frame",
    drawtype = "glasslike_framed_optional",
    tiles = {"decoblocks_framed_glass.png", "decoblocks_framed_glass_detail.png"},
    paramtype = "light",
    light_source = 4,
    sunlight_propagates = true,
    is_ground_content = false,
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("decoblocks:stucco", {
    description = "Stucco",
    tiles = {"decoblocks_stucco.png"},
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("decoblocks:altar", {
    description = "Altar",
    drawtype = "mesh",
    mesh = "decoblocks_altar.obj",
    tiles = {
        "decoblocks_altar.png",
    },
    visual_scale = 0.5,
    wield_scale = {x=1.0, y=1.0, z=1.0},
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = {
        type = "fixed",
        fixed = {-0.31, -0.5, -0.33, 0.31, 0.6, 0.31}
    },
    collision_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.7, 0.3}
    },
    groups = {choppy = 1, oddly_breakable_by_hand = 1},
    sounds = default.node_sound_wood_defaults()
})

minetest.register_node("decoblocks:roof_corner", {
    description = "Sloped Roof Corner",
    tiles = {
        "default_obsidian.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0, -0.5, 0.0625, 0.0625, 0.5}, -- NodeBox1
            {-0.5, 0.0625, -0.3125, 0.0625, 0.125, 0.5}, -- NodeBox2
            {-0.5, 0.125, -0.125, 0.0625, 0.1875, 0.5}, -- NodeBox3
            {-0.5, 0.1875, 0.0625, -0.0625, 0.25, 0.5}, -- NodeBox4
            {-0.5, 0.25, 0.1875, -0.1875, 0.3125, 0.5}, -- NodeBox5
            {-0.5, 0.3125, 0.3125, -0.3125, 0.375, 0.5}, -- NodeBox6
            {-0.5, 0, -0.0625, 0.5, -0.4375, 0.5}, -- NodeBox7
            {-0.5, 0.0625, -0.0625, 0.3125, 0.125, 0.5}, -- NodeBox8
            {-0.5, 0.125, -0.0625, 0.125, 0.1875, 0.5}, -- NodeBox9
            {0.0625, 0, -0.5, 0.5, 0.0625, -0.0625}, -- NodeBox10
            {-0.5, 0, -0.3125, 0.3125, 0.125, 0.5}, -- NodeBox11
            {0.0625, 0.0625, -0.5, 0.5, 0.125, -0.0625}, -- NodeBox12
            {0.25, 0.125, -0.5, 0.5, 0.1875, -0.25}, -- NodeBox13
            {0.375, 0.1875, -0.5, 0.5, 0.25, -0.375}, -- NodeBox14
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
        }
    },
    groups = {cracky=1},
})

minetest.register_node("decoblocks:roof_slope", {
    description = "Sloped Roof",
    tiles = {
        "default_obsidian.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0, -0.5, 0.5, 0.0625, 0.5}, -- NodeBox1
            {-0.5, 0.0625, -0.3125, 0.5, 0.125, 0.5}, -- NodeBox2
            {-0.5, 0.125, -0.125, 0.5, 0.1875, 0.5}, -- NodeBox3
            {-0.5, 0.1875, 0.0625, 0.5, 0.25, 0.5}, -- NodeBox4
            {-0.5, 0.25, 0.1875, 0.5, 0.3125, 0.5}, -- NodeBox5
            {-0.5, 0.3125, 0.3125, 0.5, 0.375, 0.5}, -- NodeBox6
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
        }
    },
    groups = {cracky=1},
})

minetest.register_node("decoblocks:sandstone_window", {
    description = "Sandstone Window",
    tiles = {
        "default_sandstone.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}, -- NodeBox1
            {-0.5, 0.25, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
            {0.25, -0.25, -0.5, 0.5, 0.25, 0.5}, -- NodeBox3
            {-0.5, -0.25, -0.5, -0.25, 0.25, 0.5}, -- NodeBox4
            {0.1875, 0.1875, -0.5, 0.25, 0.25, 0.5}, -- NodeBox5
            {-0.25, 0.1875, -0.5, -0.1875, 0.25, 0.5}, -- NodeBox6
            {-0.375, -0.375, -0.5625, 0.375, -0.25, 0.4375}, -- NodeBox7
            {-0.1875, 0.25, -0.5625, 0.1875, 0.3125, -0.5}, -- NodeBox8
            {-0.25, 0.1875, -0.5625, -0.1875, 0.25, -0.5}, -- NodeBox9
            {0.1875, 0.1875, -0.5625, 0.25, 0.25, -0.5}, -- NodeBox10
        }
    },
    groups = {cracky=1}
})

minetest.register_node("decoblocks:sandstone_ledge", {
    description = "Sandstone Ledge",
    tiles = {
        "default_sandstone.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
            {-0.5, 0.3125, -0.5625, 0.5, 0.5, 0.5}, -- NodeBox2
            {-0.5, 0.4375, -0.625, 0.5, 0.5, 0.5}, -- NodeBox3
        }
    },
    groups = {cracky=1}
})

minetest.register_node("decoblocks:sandstone_rail", {
    description = "Sandstone Rail",
    tiles = {
        "default_sandstone.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
            {-0.5, -0.0625, -0.5625, 0.5, 0.125, 0.5}, -- NodeBox2
            {-0.5, 0, -0.625, 0.5, 0.0625, 0.5}, -- NodeBox3
        }
    },
    groups = {cracky=1}
})

minetest.register_node("decoblocks:sandstone_rail_corner", {
    description = "Sandstone Rail Corner",
    tiles = {
        "default_sandstone.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
            {-0.5625, -0.0625, -0.5625, 0.5, 0.125, 0.5}, -- NodeBox2
            {-0.625, 0, -0.625, 0.5, 0.0625, 0.5}, -- NodeBox3
        }
    },
    groups = {cracky=1}
})


minetest.register_node("decoblocks:sandstone_ledge_corner", {
    description = "Sandstone Ledge Corner",
    tiles = {
        "default_sandstone.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
            {-0.5, 0.3125, -0.5625, 0.5625, 0.5, 0.5}, -- NodeBox2
            {-0.5, 0.4375, -0.625, 0.625, 0.5, 0.5}, -- NodeBox3
        }
    },
    groups = {cracky=1}
})

minetest.register_node("decoblocks:sandstone_pillar_base", {
    description = "Sandstone Pillar Base",
    tiles = {
    "decoblocks_sandstone_pillar_top.png",
    "decoblocks_sandstone_pillar_top.png",
    "decoblocks_sandstone_pillar.png",
    },
    paramtype2 = "facedir",
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
            {-0.5625, -0.5, -0.5625, 0.5625, -0.3125, 0.5625}, -- NodeBox2
            {-0.625, -0.5, -0.625, 0.625, -0.4375, 0.625}, -- NodeBox3
        }
    },
    on_place = minetest.rotate_node
})

minetest.register_node("decoblocks:rusty_steel_plating", {
    description = "Rusty Plating",
    tiles = {"decoblocks_rusty_steel_plating.png"},
    groups = {cracky = 1, level = 2},
    sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("decoblocks:broken_glass", {
    description = "Broken Glass",
    drawtype = "glasslike_framed_optional",
    tiles = {"decoblocks_broken_glass.png", "decoblocks_broken_glass_detail.png"},
    paramtype = "light",
    sunlight_propagates = true,
    is_ground_content = false,
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("decoblocks:plank_walkway", {
    description = "Wood Plank Walkway",
    tiles = {
        "decoblocks_wood_planks.png",
        "decoblocks_wood_planks.png",
        "default_wood.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.4375, -0.5, -0.3125, 0.5, 0.5}, -- NodeBox1
            {-0.25, 0.4375, -0.4375, -0.0625, 0.5, 0.5}, -- NodeBox2
            {0, 0.4375, -0.5, 0.1875, 0.5, 0.5}, -- NodeBox3
            {0.25, 0.4375, -0.375, 0.4375, 0.5, 0.5}, -- NodeBox4
        }
    },
    sounds = default.node_sound_wood_defaults(),
    groups = {choppy=1,}
})

local skull_mesh = "human_skull.obj"
local skull_texture = "human_skull.png"
local skull_selection_box = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}

local skeleton_mesh = "decoblocks_old_skeleton.obj"
local skeleton_texture = "decoblocks_old_skeleton.png"
local skeleton_selection_box = {-0.3, -0.5, -0.3, 0.3, 0.0, 0.3}

local skeleton_alt_mesh = "decoblocks_old_skeleton2.obj"


minetest.override_item("bones:bones", {
    description = "Bones",
    drawtype = "mesh",
    visual_scale = 0.5,
    paramtype = "light",
	use_texture_alpha = clip,
    mesh = skeleton_mesh,  -- Default to skull mesh
    tiles = {skeleton_texture},  -- Default to skull texture
    visual_scale = 0.5,
    paramtype = "light",
    paramtype2 = "facedir",
    selection_box = skeleton_selection_box, -- Default to skull selection box
    collision_box = skeleton_selection_box, -- Default to skull collision box
    paramtype2 = "facedir",
    on_place = function(itemstack, placer, pointed_thing)
        local pos = pointed_thing.above
        local meta = minetest.get_meta(pos)
        -- Randomly choose a mesh and texture
        local random_index = math.random(3)
        if random_index == 2 then
            meta:set_string("mesh", skeleton_mesh)
            meta:set_string("textures", skeleton_texture)
            meta:set_string("selection_box", minetest.serialize(skeleton_selection_box))
            meta:set_string("collision_box", minetest.serialize(skeleton_selection_box))
        elseif random_index == 3 then
            meta:set_string("mesh", skeleton_alt_mesh)
            meta:set_string("textures", skeleton_texture)
            meta:set_string("selection_box", minetest.serialize(skeleton_selection_box))
            meta:set_string("collision_box", minetest.serialize(skeleton_selection_box))
        else
            meta:set_string("mesh", skull_mesh)
            meta:set_string("textures", skull_texture)
            meta:set_string("selection_box", minetest.serialize(skull_selection_box))
            meta:set_string("collision_box", minetest.serialize(skull_selection_box))
        end
        return minetest.item_place(itemstack, placer, pointed_thing)
    end,
})