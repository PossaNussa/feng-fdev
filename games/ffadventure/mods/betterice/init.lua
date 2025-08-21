
minetest.register_node(":default:ice", {
    description = "Ice",
    tiles = {"default_ice.png"},
    groups = {
        cracky = 1,
        oddly_breakable_by_hand = 2,
        slippery = 3
    },

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local node_underneath = minetest.get_node({x=pos.x, y=pos.y - 1, z=pos.z})
        if node_underneath.name == "air" or node_underneath.name == "ignore" then
            return
        end
        
        minetest.set_node(pos, {name="default:water_source"})
    end
})

minetest.register_abm({
    label = "Ice Melting",
    nodenames = {"default:ice"},
    neighbors = {"default:torch"},
    interval = 2,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        if math.random(0, 100) <= 70 then
            return
        end
        
        minetest.set_node(pos, {name="default:water_source"})
    end
})