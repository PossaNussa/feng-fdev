-- NODES FREE
function pixelfurniture.nodes_deco(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = def.walkable,
	groups = {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",
	drop = name,
	node_box= def.selection_box,
	selection_box = def.selection_box,	
	on_rightclick = def.on_rightclick,
})
end

function pixelfurniture.lanterns(name, def)
minetest.register_node(name.."_ceiling", {
	description = def.description,
	drawtype = "mesh",
	mesh = def.mesh.."_top.obj",
	tiles = def.tiles,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
	walkable = true,
	groups = {snappy = 3,not_in_creative_inventory=1},
	_mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 12,
	drop = name,
	node_box = {
	  type = "fixed", 
	  fixed = {{-0.15, 0.1, -0.15, 0.15,0.5, 0.15}},
	 },
	selection_box = {
	  type = "fixed", 
	  fixed = {{-0.15, -0.1, -0.15, 0.15,0.3, 0.15}},
	 },	
})

minetest.register_node(name, {
	description = def.description,
	drawtype = "mesh",
	mesh = def.mesh..".obj",
	tiles = def.tiles,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
	walkable = true,
	groups = {snappy = 3},
	_mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 12,
	drop = name,
	node_box = {
	  type = "fixed", 
	  fixed = {{-0.15, -0.5, -0.15, 0.15,-0.1, 0.15}},
	 },
	selection_box = {
	  type = "fixed", 
	  fixed = {{-0.15, -0.5, -0.15, 0.15,-0.1, 0.15}},
	 },
	
	on_place = function(itemstack, placer, pointed_thing)
	 if pointed_thing.type ~= "node" then return itemstack end
	 itemstack:set_name(name)
	 local under, above = pointed_thing.under, pointed_thing.above
	 local dy = above.y - under.y
	 local node_name = (dy == 1) and (name) or (dy == -1 and (name.."_ceiling") or (name))
	   if not minetest.registered_nodes[node_name] then return itemstack end
	   local n = minetest.get_node_or_nil(above) or minetest.get_node(above)
	   if not (n.name == "air") then return minetest.item_place_node(itemstack, placer, pointed_thing) end
	    minetest.item_place_node(ItemStack(node_name), placer, pointed_thing)
	      itemstack:take_item(1)
	    return itemstack
         end,
})
end


-- Seat (Chair / poltrona / Stool / puff..)
function pixelfurniture.seat(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = true,
	groups = def.groups,
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",	
        paramtype2 = "facedir",        
        selection_box = {
	type = "fixed", 
	fixed = {{-0.37, -0.5, -0.3, 0.43, -0.05, 0.3}},
	},
		
	node_box= {
	type = "fixed", 
	fixed = {{-0.37, -0.5, -0.3, 0.43, -0.05, 0.3}},
	},		
		
	 on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)	
	 pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}	
	 clicker:set_pos(pos)
	 minetest.after(0.3, function()
          clicker:set_animation({x = 81,  y = 160}, 30, 0)          
         end)
     
   	end,	
})
end

-- Double Seat (Benches - Bancos) / Sofa dual / sofa
function pixelfurniture.double_seat(name, def)
    minetest.register_node(name, {
        description = def.description,
        drawtype = "mesh",
        mesh = def.mesh,
        tiles = def.tiles,
        use_texture_alpha = "clip",
        wield_scale = {x = 1, y = 1, z = 1},
        walkable = true,
        groups = def.groups, -- {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
        paramtype = "light",
        paramtype2 = "facedir",

        node_box = {
            type = "fixed",
            fixed = {{-0.85, -0.5, -0.35, 1.4, -0.1, 0.3}},
        },

        selection_box = {
            type = "fixed",
            fixed = {{-0.5, -0.5, -0.35, 1.4, -0.1, 0.3}},
        },

        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local players_near = minetest.get_objects_inside_radius(pos, 0.5)
            local player_count = 0
            for _, player in ipairs(players_near) do
                if player:is_player() then
                    player_count = player_count + 1
                end
            end

            local dir = minetest.facedir_to_dir(node.param2) -- TENTATIVA DE CONSEGUI A DIREÇÃO DO NODE
            local sit_pos
            if player_count == 0 then
                sit_pos = {x = pos.x - dir.z * 0, y = pos.y + 0.2, z = pos.z + dir.x * 0}
            elseif player_count == 1 then
                sit_pos = {x = pos.x + dir.z * 0.9, y = pos.y + 0.2, z = pos.z - dir.x * 0.9}
            else
                return
            end

            clicker:set_pos(sit_pos)
            minetest.after(0.3, function()
                clicker:set_animation({x = 81, y = 160}, 30, 0)
            end)
        end,
    })
end

-- Desk / Tables
function pixelfurniture.tables(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = true,
	groups = {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",

		node_box= {
			type = "fixed", 
			fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
		},

		selection_box = {
			type = "fixed",
			fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
		},		
})
end

function pixelfurniture.large_tables(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = true,
	groups = {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",

		node_box= {
			type = "fixed", 
			fixed = {
			{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
			{-0.4, -0.5, 0.5, 0.4, 0.5, 1.4},
			{0.5, -0.5, -0.4, 1.4, 0.5, 0.4},
			{0.5, -0.5, 0.5, 1.4, 0.5, 1.4},
			},
		},

		selection_box = {
			type = "fixed",
			fixed = {
			{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
			{-0.4, -0.5, 0.5, 0.4, 0.5, 1.4},
			{0.5, -0.5, -0.4, 1.4, 0.5, 0.4},
			{0.5, -0.5, 0.5, 1.4, 0.5, 1.4},
			},
		},		
})
end

-- Storage 
function pixelfurniture.storage(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = true,
	groups = {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",

		node_box= {
			type = "fixed", 
			fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
		},

		selection_box = {
			type = "fixed",
			fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
		},
		
        on_construct = function(pos)              
	      local meta = core.get_meta(pos)
	       meta:set_string("formspec", "size[8,8.5]" ..          
              "listcolors[#000000BB;#000000BB]"..
              "list[current_name;main;0,0;8,4;]" ..  
              "list[current_player;main;0,4.5;8,4;]" ..  
              "listring[current_name;main]" ..
              "listring[current_player;main]"
       		 )
	      local inv = meta:get_inventory()
	      inv:set_size("main", 8*2)
	end,
	  
	on_dig = function(pos, node, digger)
		local meta = core.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("main") then
		    return
		end
		core.node_dig(pos, node, digger)
       end,
	 
       on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
         core.sound_play("pfstorages", {pos = pos,gain = 1.0,max_hear_distance = 10})
       end
	
})      
end

-- Curtains :
function pixelfurniture.curtains(name,def)
minetest.register_node(name.."l", {
	description = def.description.." Large", 
	drawtype = "mesh",
	mesh = "Curtain_b.obj",
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = false,
	groups = {snappy = 3,not_in_creative_inventory=1},
        _mcl_hardness = 1,
	paramtype = "light",
	paramtype2 = "facedir",
	drop = name.." 3",
	node_box= {
		type = "fixed", 
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},

	selection_box = {
		type = "fixed",
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},
		
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
          return
        end		
})

minetest.register_node(name.."m", {
	description = def.description.." Medium", 
	drawtype = "mesh",
	mesh = "Curtain_m.obj",
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = false,
	groups = {snappy = 3,not_in_creative_inventory=1},
        _mcl_hardness =  1,
	paramtype = "light",
	paramtype2 = "facedir",
	drop = name.." 2",
	node_box= {
		type = "fixed", 
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},

	selection_box = {
		type = "fixed",
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},
		
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	  local itemname = itemstack:get_name()
	  if itemname == name then  
            itemstack:take_item()
            minetest.swap_node(pos,{name = name.."l",param2=node.param2})
            -- core.sound_play("curtains", {pos = pos,gain = 1.0,max_hear_distance = 10})
         end
        end		
})

minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = "Curtain.obj",
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = false,
	groups = {snappy = 3,curtains=1},
        _mcl_hardness =  1,
	paramtype = "light",
	paramtype2 = "facedir",
	drop = name,
	node_box= {
		type = "fixed", 
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},

	selection_box = {
		type = "fixed",
		fixed = {{-0.5, -0.5, 0.25, 0.5, 0.5, 0.5}},
	},
		
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing) 
	  local itemname = itemstack:get_name()
	  if itemname == name then  
	     itemstack:take_item()   
             minetest.swap_node(pos,{name = name.."m",param2=node.param2})
             -- core.sound_play("curtains", {pos = pos,gain = 1.0,max_hear_distance = 10})
         end
        end		
})
end

function pixelfurniture.register_sign_post(name,def)
minetest.register_node(name, {
	description = def.description, 
	drawtype = "mesh",
	mesh = def.mesh,
	tiles = def.tiles ,
	use_texture_alpha = "clip",
	wield_scale = {x=1, y=1, z=1},
        walkable = true,
	groups = {snappy = 3},
        _mcl_hardness = def._mcl_hardness,
	paramtype = "light",
	paramtype2 = "facedir",

	node_box= {
		type = "fixed", 
		fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
	},

	selection_box = {
		type = "fixed",
		fixed = {{-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},},
	},
        
        on_construct = function(pos)
	   local meta = minetest.get_meta(pos)
	   local sign_menu =  "size[5,3]".."button_exit[1,2.1;3,0.8;sign_ok;Ok]".."field[0.8,1.5;4.0,1.0;guidance;;"
	   meta:set_string("formspec",sign_menu)
	   meta:set_string("owner", "")			
	end,
	
	after_place_node = function(pos, placer)
	   local meta = minetest.get_meta(pos)
	   meta:set_string("owner", placer:get_player_name() or "")
	end,
	
	on_receive_fields = function(pos, formname, fields, sender)
	        local meta = minetest.get_meta(pos)
	        local owner = meta:get_string("owner")
	        local pn = sender:get_player_name()
	        
		if fields.sign_ok and (owner == pn) then 				
		 meta:set_string("infotext",fields.guidance)
		end
	end,
})
end



