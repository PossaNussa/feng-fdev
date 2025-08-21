local S = minetest.get_translator("waystone")

local how_to_use = S("See how to use it on the Wiki")


minetest.register_node("waystone:waystone", {
	description = S("WayStone"),
	drawtype = "mesh",
	mesh = "waystone.obj",
	--tiles = {"waystones.png"},
	tiles = {{
		name = "waystone_animate.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 64,
			aspect_h = 64,
			length = 1
		}}
	},
	paramtype = "light",
	paramtype2 = "facedir",
	--on_place = minetest.rotate_node,
	sunlight_propagates = true,
	walkable = true, 
	floodable = false,
	groups = {cracky = 3, pickaxey = 1, stone = 1},
	-- Suporte MCLs by : N Freeman 
	_mcl_hardness = 3,
	_mcl_blast_resistance = 10,
	--
	drop = "waystone:waystone",
	light_source = 8,
	sounds = {
        footstep = {name = "stone_magic_step", gain = 0.5},
        dig = {name = "stone_magic", gain = 0.5},
        dug = {name = "stone_magic_dugg", gain = 1.0},
        --place = {name = " ", gain = 1.0},
    	},
	
	selection_box = {
		type = "fixed",
		--    esqueda,altura,tras..,direita ,negativo aumenta para baixo, positivo aumenta para cima
		fixed = {-0.4, -0.5, -0.4, 0.4,1.3, 0.4},
	},
	
	node_box = {
		type = "fixed", 
		fixed = {-0.4, -0.5, -0.4, 0.4,1.3, 0.4},
	},
	
	
	
	--- callbacks : =====================
	 on_construct = function(pos)
         
         local meta = minetest.get_meta(pos)
         meta:set_string("owner", "")
         local owner = meta:get_string("owner")
         
        

        end,
    
    
	    after_place_node = function(pos, placer) -- REGISTRAR DONO 
	    
				local meta = minetest.get_meta(pos)
				meta:set_string("owner", placer:get_player_name() or "")
				
				local owner = meta:get_string("owner")
				-- minetest.log(owner)
				
	   end,
	   
	   
	   
	    can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		local owner = meta:get_string("owner")
		local name = player:get_player_name()
		local bypasser = minetest.check_player_privs(name, "protection_bypass")
		
		--if player:get_player_name() == owner then
		if owner == "" or owner == name or bypasser then -- by : N Freeman 
		    return true  -- SOMENTE O DONO PODE CAVAR
		else
			minetest.chat_send_player(name, S("You can't dig that waystone, is owned by @1", owner))
		    return false  -- SE NÃO FOR O DONO, ENTÃO É FALSO
		end
	    end,
	    
	    
	    
	    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)	   	  
	   	    
	   	    local player_name = clicker:get_player_name()

			local meta = minetest.get_meta(pos)
			local owner = meta:get_string("owner")

	   	    
	   	    local formspec_waystone = "size[6,2]"..
			--"background[-0.8,-0.5;7.5,3.5;bg_waystone.png;false]" ..
			"label[1.5,0.7;"..how_to_use.."]"..
		    "button_url[2,1;2,2;wiki;Wiki;https://codeberg.org/pixelzone/waystone/src/branch/main/README.md]"
		   	
			-- by : N Freeman 
			if owner and owner ~= "" then
			    formspec_waystone = formspec_waystone
				    .."label[1.5,0.2;"..S("Owned by: @1", owner).."]"
		    end  

	      		
		     minetest.show_formspec(player_name, "waystone:wayform", formspec_waystone)
    
           end,
    
	  
	  
	  on_blast = function() end
	
	
})
