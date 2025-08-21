local regfoodblock = foodblocks.regfoodblock

local melondef = minetest.registered_nodes["mcl_farming:melon"]

if minetest.get_modpath("mcl_sounds") then
	foodblocks.set_wood_sounds(mcl_sounds.node_sound_wood_defaults())
end
foodblocks.set_node_groups(melondef.groups)

local extra_node_def = {
	_mcl_blast_resistance = melondef._mcl_blast_resistance,
	_mcl_hardness = melondef._mcl_hardness,
	_mcl_silk_touch_drop = true,
}

local gold_apple_textures = {
	'(apple_cube.png^[sheet:1x3:0,0^[colorize:yellow:90^apple_top_overlay.png)', -- top
	'(apple_cube.png^[sheet:1x3:0,2^[colorize:yellow:90^apple_bottom_overlay.png)', -- bottom
	'(apple_cube.png^[sheet:1x3:0,1^[colorize:yellow:90)',
	'(apple_cube.png^[sheet:1x3:0,1^[colorize:yellow:90)',
	'(apple_cube.png^[sheet:1x3:0,1^[colorize:yellow:90)',
	'(apple_cube.png^[sheet:1x3:0,1^[colorize:yellow:90)',
},

-- mcl_core without mcl_farming is a bridge we can cross if anybody actually
-- ever comes to it. But vice versa is not possible.
regfoodblock("apple", "Apple", "mcl_core:apple", nil, extra_node_def)
regfoodblock("apple_gold", "Golden Apple", "mcl_core:apple_gold", 
	gold_apple_textures, extra_node_def)

-- Yes, the purple is deliberately applied over the overlay textures; it's part 
-- of the 'enchanted' look.
local gold_apple_textures_ench = {}
for k,v in pairs(gold_apple_textures) do
	gold_apple_textures_ench[k] = gold_apple_textures[k] .. "^[colorize:#9137bb30:"
end
regfoodblock("apple_gold_enchanted", "Enchanted Golden Apple",
		"mcl_core:apple_gold_enchanted", gold_apple_textures_ench, nil,
		extra_node_def)

regfoodblock("beetroot", "Beetroot", "mcl_farming:beetroot_item", nil,
	extra_node_def)
regfoodblock("carrot", "Carrot", "mcl_farming:carrot_item", nil, extra_node_def)
regfoodblock("potato", "Potato", "mcl_farming:potato_item", {"potato_cube.png"},
	extra_node_def)
regfoodblock("potato_green", "Poison Potato", "mcl_farming:potato_item_poison",
	{"potato_cube_green.png"}, extra_node_def)
