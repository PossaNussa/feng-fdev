local S = minetest.get_translator("waystone")

local add_fortune_mod

if minetest.get_modpath("mcl_core") then 

add_fortune_mod =  mcl_core.fortune_drop_ore
-- minetest.log ("fortuna test")

end

minetest.register_node("waystone:stones_with_astral", {
	description = S("Stones With Astral"),
	tiles = {"astral_stone.png"},
	paramtype2 = "facedir",
    -- Suporte MCLs by : N Freeman 
	groups = {cracky = 3, pickaxey = 1},
    _mcl_hardness = 1,
	_mcl_blast_resistance = 1,
    _mcl_silk_touch_drop = true,
    _mcl_fortune_drop = add_fortune_mod,
    _mcl_cooking_output = "waystone:astral",
    ---
    drop = "waystone:astral",
    light_source = 4,

    sounds = {
        footstep = {name = "stone_magic_step", gain = 0.5},
        dig = {name = "stone_magic", gain = 0.5},
        dug = {name = "stone_magic_dugg", gain = 1.0},
        --place = {name = " ", gain = 1.0},
    	}
        
	
})


minetest.register_ore({
    ore_type       = "scatter",
    ore            = "waystone:stones_with_astral",
    wherein        = {"group:stone", "mcl_core:stone", "mcl_deepslate:deepslate"}, -- by : N Freeman 
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_min          = -1000,
    y_max          = -20,
    noise_threshold = 0.5,
    noise_params = {
        offset = 0,
        scale = 1,
        spread = {x = 100, y = 100, z = 100},
        seed = 6789,
        octaves = 3,
        persist = 0.5
    },
})

minetest.register_craftitem("waystone:astral", {
    description = S("Astral"),
    inventory_image = "astral.png",
})
