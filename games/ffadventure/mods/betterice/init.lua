-- Ice you can break by hand, which turns back into water when you do.
--
-- Done with override_item rather than a from-scratch register_node.
--
-- This mod used to re-register :default:ice listing only the fields it cared
-- about, which silently dropped everything else default declares for that node:
-- cools_lava = 1, sounds, drawtype = "glasslike_framed_optional",
-- use_texture_alpha, paramtype = "light" and is_ground_content = false. So ice
-- stopped quenching lava, stopped sounding like ice, rendered as a plain solid
-- cube, and became ground content again (which is what is_ground_content = false
-- exists to prevent: caves carving tunnels through sea ice and ice rivers).
-- Overriding changes only what this mod actually means to change, and will not
-- quietly undo whatever default declares next.
minetest.override_item("default:ice", {
    -- Harder with a pick than vanilla's cracky = 3, but breakable by hand.
    -- cools_lava and slippery have to be restated: overriding `groups` replaces
    -- the whole table rather than merging into it.
    groups = {
        cracky = 1,
        oddly_breakable_by_hand = 2,
        slippery = 3,
        cools_lava = 1,
    },

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local node_underneath = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
        if node_underneath.name == "air" or node_underneath.name == "ignore" then
            return
        end

        minetest.set_node(pos, {name = "default:water_source"})
    end
})

-- Torch melting.
--
-- better_snow already does this, at interval 15 / chance 2, across ice, snow and
-- snowblock, and keyed on the whole group:igniter plus furnace_active rather
-- than torches alone. Ours ran alongside it at interval 2 / chance 1 with a 30%
-- pass rate, so ice beside a torch was being rolled against roughly an order of
-- magnitude more often than either mod intended, with no defined ordering
-- between the two. Defer to better_snow when it is present, and only cover the
-- case where nothing else would.
if not minetest.get_modpath("better_snow") then
    minetest.register_abm({
        label = "Ice Melting",
        nodenames = {"default:ice"},
        neighbors = {"default:torch"},
        interval = 15,
        chance = 2,
        catch_up = false,
        action = function(pos, node, active_object_count, active_object_count_wider)
            minetest.set_node(pos, {name = "default:water_source"})
        end
    })
end
