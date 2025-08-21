minetest.register_craftitem("resurrection_cross:resurrection_cross", {
    description = "resurrection cross",
    inventory_image = "resurrection_cross.png", 
    stack_max = 1, 
    on_drop = function(itemstack)
        return itemstack
    end
})

function revive_player(player)
    local pos = player:get_pos()
    player:set_pos(pos)
    local hp = player:get_hp()
    if hp <= 0 then
        player:set_hp(20) 
    end  

    minetest.sound_play("resurrection_cross", {
        to_player = player:get_player_name(),
        gain = 4, 
    })

    minetest.add_particlespawner({
        amount = 15, 
        time = 1.5,
        minpos = {x = pos.x - 1, y = pos.y, z = pos.z - 1},
        maxpos = {x = pos.x + 1, y = pos.y + 2, z = pos.z + 1},
        minvel = {x = -1, y = 1, z = -1},
        maxvel = {x = 1, y = 2, z = 1},
        minacc = {x = 0, y = 0, z = 0},
        maxacc = {x = 0, y = 0, z = 0},
        minexptime = 2,
        maxexptime = 3,
        minsize = 1,
        maxsize = 3,
        texture = "resurrection_cross.png", 
    })
end

minetest.register_playerevent(function(player, eventname)
    if eventname == "health_changed" then
    local inv = player:get_inventory()
         local hp = player:get_hp()
    if hp <= 0 then   
     if inv:contains_item("main", "resurrection_cross:resurrection_cross") then
       revive_player(player)
       inv:remove_item("main", "resurrection_cross:resurrection_cross")

    end
end
  end
end)
