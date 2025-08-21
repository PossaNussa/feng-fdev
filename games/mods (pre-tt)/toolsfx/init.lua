-- SWORD WOSH : https://freesound.org/people/Wdfourtee/sounds/192055/
-- AXE WOSH :


-- ========================== MINETEST GAMES ========================================================
if minetest.get_modpath("default") then

	-- SWORDS :
	minetest.override_item ("default:sword_wood",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

	minetest.override_item ("default:sword_stone",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

	minetest.override_item ("default:sword_bronze",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

	minetest.override_item ("default:sword_steel",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("default:sword_mese",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

	minetest.override_item ("default:sword_diamond",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})
	-- AXES :

	minetest.override_item ("default:axe_wood",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("default:axe_stone",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("default:axe_bronze",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("default:axe_steel",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("default:axe_mese",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("default:axe_diamond",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


end



-- ============================= MINECLONE2 =======================================================

if minetest.get_modpath("mcl_tools") then

	-- AXES :

	minetest.override_item ("mcl_tools:axe_wood",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	minetest.override_item ("mcl_tools:axe_stone",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	minetest.override_item ("mcl_tools:axe_iron",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	minetest.override_item ("mcl_tools:axe_gold",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	minetest.override_item ("mcl_tools:axe_diamond",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	minetest.override_item ("mcl_tools:axe_netherite",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	-- Swords :

	minetest.override_item ("mcl_tools:sword_wood",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("mcl_tools:sword_stone",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("mcl_tools:sword_iron",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("mcl_tools:sword_gold",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("mcl_tools:sword_diamond",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("mcl_tools:sword_netherite",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})



end





-- ============================= RAINBOW ORE =======================================================

if minetest.get_modpath("rainbow_ore") then

	minetest.override_item ("rainbow_ore:rainbow_ore_axe",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})


	minetest.override_item ("rainbow_ore:rainbow_ore_sword",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

end



-- ============================= LAVASTUFF =======================================================

if minetest.get_modpath("lavastuff") then


	minetest.override_item ("lavastuff:axe",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	
	minetest.override_item ("lavastuff:sword",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})

end


-- ============================= MORE ORES : =======================================================

if minetest.get_modpath("moreores") then


	minetest.override_item ("moreores:axe_silver",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	
	minetest.override_item ("moreores:sword_silver",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("moreores:axe_mithril",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	
	minetest.override_item ("moreores:sword_mithril",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


end


-- ============================= Mobs Ethreal Boss =======================================================

if minetest.get_modpath("eamoretools") then


	minetest.override_item ("eamoretools:axe_mushroom",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	
	minetest.override_item ("eamoretools:sword_mushroom",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("eamoretools:naturerod",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})



end


-- ============================= Zombies4test =======================================================

if minetest.get_modpath("toolx") then


	minetest.override_item ("toolx:fireaxe",{
	sound = {
	breaks = "default_tool_breaks",
	--punch_use = "swoosh2",
	punch_use_air ="swoosh3",
	},

	})

	
	minetest.override_item ("toolx:knife",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


	minetest.override_item ("toolx:baseball_bat",{
	sound = {
	breaks = "default_tool_breaks",
	punch_use = "swoosh2",
	punch_use_air ="swoosh2",
	},

	})


end