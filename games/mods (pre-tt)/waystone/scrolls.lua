
-- SCROLL  : =====================================================================================================
local S = minetest.get_translator("waystone")

minetest.register_craftitem("waystone:Scroll", {
    description = S("Scroll"),
    inventory_image = "scroll_waystone.png",
    wield_image = "scroll_waystone.png",

    on_place = function(itemstack, user, pointed_thing)
        if pointed_thing and pointed_thing.type == "node" then
            local pos = pointed_thing.under
            local node = minetest.get_node(pos)

            if node.name == "waystone:waystone" then
                local meta = itemstack:get_meta()
                local pos_str = minetest.pos_to_string(pos)
                meta:set_string("waystone_pos", pos_str)

               -- renomear sroll
                minetest.show_formspec(user:get_player_name(), "waystone:rename_scroll", 
                    "size[8,4]" ..
                    "background[-1,-2;10,8;scroll_bg.png;false]" .. 
                    "label[2.1,0.5;"..S("Choose a name to the Scroll :").."]" ..
                    "field[2.3,2.5;4.0,1.0;new_name;"..S("Name")..";]" ..
                    "button_exit[2.5,3.0;3.0,1.0;submit;"..S("Ok").."]")

                return itemstack
            else
                --minetest.chat_send_player(user:get_player_name(), "Isso não é um WayStone!")
            end
        end
    end,

    on_use = function(itemstack, user, pointed_thing)
        local meta = itemstack:get_meta()
          local pos_str = meta:get_string("waystone_pos")

        if pos_str and pos_str ~= "" then
            local target_pos = minetest.string_to_pos(pos_str)

            user:set_pos(target_pos)
            minetest.sound_play("teleporter_fx", {pos = target_pos, max_hear_distance = 16, gain = 1.0}) 
            minetest.chat_send_player(user:get_player_name(), S("You have been teleported to the WayStone!"))

        else
            minetest.chat_send_player(user:get_player_name(), S("No WayStone position has been recorded!"))
            return
        end
        
            itemstack:take_item()
            return itemstack
            
    end,
})


minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "waystone:rename_scroll" then
        local itemstack = player:get_wielded_item()
        if fields.submit and fields.new_name and itemstack:get_name() == "waystone:Scroll" then
            local meta = itemstack:get_meta()
             local new_name = fields.new_name


                 meta:set_string("description", "Scroll: " .. new_name)


                 itemstack:set_name("waystone:Scroll")
            
              
               itemstack:get_meta():set_string("description", "Scroll  " .. new_name)
               player:set_wielded_item(itemstack) 
               minetest.sound_play("write", {pos = target_pos, max_hear_distance = 16, gain = 1.0}) 

           -- minetest.chat_send_player(player:get_player_name(), "The Scroll has been renamed to : " .. new_name)
        end
    end
end)














