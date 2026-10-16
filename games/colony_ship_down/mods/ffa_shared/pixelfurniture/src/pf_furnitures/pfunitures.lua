pixelfurniture.seat ("pixelfurniture:wooden_chair",{
description = "Wooden Chair",
mesh = "wooden_chair.obj",
tiles = {"wooden_chair.png"},
groups = {snappy = 3},
_mcl_hardness = 1,
})

pixelfurniture.double_seat ("pixelfurniture:wooden_bench",{
description = "Wooden Bench",
mesh = "wooden_bench.obj",
tiles = {"wooden_bench.png"},
groups = {snappy = 3},
_mcl_hardness = 1,
})

pixelfurniture.seat ("pixelfurniture:stool",{
description = "Wooden Stool",
mesh = "Stool.obj",
groups = {snappy = 3},
tiles = {"wooden_chair.png"},
_mcl_hardness = 1,
})

pixelfurniture.tables ("pixelfurniture:wooden_table",{
description = "Wooden Table",
mesh = "wooden_table.obj",
tiles = {"wooden_table.png"},
_mcl_hardness = 1,
})
--[[
pixelfurniture.large_tables ("pixelfurniture:large_wooden_table",{
description = "Large Wooden Table",
mesh = "big_table.obj",
tiles = {"wooden_table.png"},
_mcl_hardness = 1,
})
]]
pixelfurniture.storage ("pixelfurniture:wooden_closet",{
description = "Wooden Closet",
mesh = "Closet.obj",
tiles = {"Closet.png"},
_mcl_hardness = 1,
})

pixelfurniture.storage ("pixelfurniture:wooden_cabinet",{
description = "Wooden Cabinet",
mesh = "Closet.obj",
tiles = {"Cabinet.png"},
walkable = true,
_mcl_hardness = 1,
})

pixelfurniture.storage ("pixelfurniture:wooden_counter",{
description = "Wooden Counter",
mesh = "Cabinet.obj",
tiles = {"counter.png"},
walkable = true,
_mcl_hardness = 1,
})

pixelfurniture.nodes_deco ("pixelfurniture:crate",{
description = "Crate",
mesh = "Crate.obj",
tiles = {"Crate.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.5,-0.5,-0.5,0.5,0.5,0.5}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:hanging_pot",{
description = "Hanging Pot",
mesh = "hanging_pot.obj",
tiles = {"hanging_pot.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.3, -0.5, -0.3, 0.3,0.5, 0.3}},
 }	
})

pixelfurniture.lanterns ("pixelfurniture:lantern",{
description = "Lantern",
mesh = "pf_lantern", -- no ".pbj"
tiles = {"pf_lantern.png"},
_mcl_hardness = 1,	
})

pixelfurniture.nodes_deco ("pixelfurniture:small_vase",{
description = "Small Vase",
mesh = "small_vase.obj",
tiles = {"small_vase.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.25, -0.5, -0.25, 0.25,0.3, 0.25}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:item_shelf",{
description = "Item Shelf",
mesh = "item_shelf.obj",
tiles = {"item_shelf.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {
  {-0.5, -0.5, -0.1, 0.5,0.5, 0.5},
  {0.5, -0.5, -0.1, 1.5,0.5, 0.5}}}	
})

pixelfurniture.nodes_deco ("pixelfurniture:doormat",{
description = "Doormat",
mesh = "doormat.obj",
tiles = {"doormat.png"},
walkable = false,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.4, -0.5, -0.3, 0.4,-0.45, 0.3}},
 }	
})

pixelfurniture.register_sign_post ("pixelfurniture:sign_arrow",{
 description = "Sign Arrow",
 mesh = "arrow_sign.obj",
 tiles = {"arrow_sign.png"},
})

----- 0.3: ================================================================================
core.register_node("pixelfurniture:stacked_books", {  --- Books
	description = "Stacked Books",
	drawtype = "mesh",
	mesh = "Stacked_Books.obj",	
	tiles = {"Stacked_Books.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false, 
	floodable = false,
	groups = {dig_immediate=3},
	_mcl_hardness = 1,
	
	selection_box = {type = "fixed",fixed = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	},
	
	node_box = {type = "fixed",fixed = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	},
})

core.register_node("pixelfurniture:globe", { 
	description = "Globe",
	drawtype = "mesh",
	mesh = "globe.obj",	
	tiles = {"globe.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false, 
	floodable = false,
	groups = {dig_immediate=3},
	_mcl_hardness = 1,
	
	selection_box = {type = "fixed",fixed = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	},
	
	node_box = {type = "fixed",fixed = {-0.3, -0.5, -0.3, 0.3, 0.1, 0.3},
	},
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	  local pn = vector.floor(clicker:get_pos())
	  local pns  = core.pos_to_string(pn)
	  core.chat_send_player(clicker:get_player_name(),core.colorize("#dac838", "Pos : "..pns))
        end   
})

--- 0.4 : ================================================================================================
pixelfurniture.nodes_deco ("pixelfurniture:cookie_jar",{
description = "Cookie Jar",
mesh = "jar.obj",
tiles = {"pf_jar.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.3, -0.5, -0.3, 0.3,0.1, 0.3}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:broom",{
description = "Broom",
mesh = "broom.obj",
tiles = {"broom.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.2, -0.5, -0, 0.2,0.3, 0.5}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:statue",{
description = "Statue",
mesh = "pf_statue.obj",
tiles = {"default_stone.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.3, -0.5, -0.3, 0.3,0.5, 0.3}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:hourglass",{
description = "Hourglass",
mesh = "hourglass.obj",
tiles = {"hourglass.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.2,-0.5,-0.2,0.2,0.4,0.2}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:placeable_apple",{
description = "Placeable Apple",
mesh = "placeable_apple.obj",
tiles = {"placeable_apple.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.19, -0.5, -0.19, 0.19,-0.12, 0.19}},
 }	
})

-- 0.4.5 : ====================================================
pixelfurniture.nodes_deco ("pixelfurniture:chicken_on_a_board",{
description = "Chicken on a board",
mesh = "Chicken_on_a_board.obj",
tiles = {"Chicken_on_a_board.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.19, -0.5, -0.19, 0.19,-0.12, 0.19}},
 }	
})

pixelfurniture.nodes_deco ("pixelfurniture:bread_on_a_board",{
description = "Bread on a board",
mesh = "Bread_on_a_board.obj",
tiles = {"Bread_on_a_board.png"},
walkable = true,
_mcl_hardness = 1,
selection_box = {
  type = "fixed", 
  fixed = {{-0.19, -0.5, -0.19, 0.19,-0.12, 0.19}},
 }	
})


