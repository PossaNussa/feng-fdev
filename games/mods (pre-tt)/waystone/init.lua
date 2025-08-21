
local path = minetest.get_modpath("waystone")

scrolls = {}

dofile(path .. "/waystones.lua")
dofile(path .. "/scrolls.lua")

dofile(path .. "/waystrone_ore.lua")



--- SCROLLS
minetest.register_craft({
        type = "shaped",
	output = "waystone:Scroll",
	recipe = {
		{ "group:stick", "group:paper", "group:stick" },
		{ "group:stick", "waystone:astral", "group:stick" },
		{ "group:stick", "group:paper", "group:stick" },
	},
})

-- Stone :
minetest.register_craft({
	type = "shaped",
	output = "waystone:waystone",
	recipe = {
		{ "group:stone", "group:stone", "group:stone" },
		{ "group:stone", "waystone:astral", "group:stone" },
		{ "group:stone", "group:stone", "group:stone" },
	},
})




if minetest.get_modpath("mcl_core") then 

minetest.override_item("mcl_core:paper", {
   groups = { craftitem=1,paper=1},
})

end



if minetest.get_modpath("rp_crafting") then 
 
   crafting.register_craft(
  {
  output = "waystone:Scroll",
  items = {
  "rp_default:paper 8",
  "waystone:astral 1",
  
  
  
  
}
  })
  
  
    crafting.register_craft(
  {
  output = "waystone:waystone",
  items = {
  "group:stone 8",
  "waystone:astral 1",
  
  
  
  
}
  })

end


--- SUPORTE PARA MINETEST GAME E SEUS FILHOS : ===========
--[[
if minetest.get_modpath("mcl_core") then


minetest.register_craft({
	type = "shaped",
	output = "waystone:waystone",
	recipe = {
		{ "group:stone", "group:stone", "group:stone" },
		{ "group:stone", "mcl_core:diamond", "group:stone" },
		{ "group:stone", "group:stone", "group:stone" },
	},
})


--- SCROLLS
minetest.register_craft({
        type = "shaped",
	output = "waystone:scroll",
	recipe = {
		{ "group:stick", "mcl_core:paper", "group:stick" },
		{ "group:stick", "mcl_core:gold_ingot", "group:stick" },
		{ "group:stick", "mcl_core:paper", "group:stick" },
	},
})


minetest.register_craft({
	output = "waystone:scroll_blue",
	recipe = {
		{ "waystone:scroll", "mcl_dyes:blue"},
		
	},
})


minetest.register_craft({
	output = "waystone:scroll_green",
	recipe = {
		{ "waystone:scroll", "mcl_dyes:green"},
		
	},
})


minetest.register_craft({
	output = "waystone:scroll_yellow",
	recipe = {
		{ "waystone:scroll", "mcl_dyes:yellow"},
		
	},
})



end





---- SUPORTE PARA MINECLONIA ,VOXELIBRE :
if minetest.get_modpath("default") then


minetest.register_craft({
	output = "waystone:waystone",
	recipe = {
		{ "group:stone", "group:stone", "group:stone" },
		{ "group:stone", "default:diamond", "group:stone" },
		{ "group:stone", "group:stone", "group:stone" },
	},
})


--- SCROLLS
minetest.register_craft({
	output = "waystone:scroll",
	recipe = {
		{ "group:stick", "default:paper", "group:stick" },
		{ "group:stick", "default:gold_ingot", "group:stick" },
		{ "group:stick", "default:paper", "group:stick" },
	},
})


minetest.register_craft({
	output = "waystone:scroll_blue",
	recipe = {
		{ "waystone:scroll", "dye:blue"},
		
	},
})


minetest.register_craft({
	output = "waystone:scroll_green",
	recipe = {
		{ "waystone:scroll", "dye:green"},
		
	},
})


minetest.register_craft({
	output = "waystone:scroll_yellow",
	recipe = {
		{ "waystone:scroll", "dye:yellow"},
		
	},
})


end

]]
