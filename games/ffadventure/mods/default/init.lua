-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into game_api.txt

-- Load support for MT game translation.
local S = minetest.get_translator("default")

-- Definitions made by this mod that other mods can use too
default = {}

default.LIGHT_MAX = 14
default.get_translator = S

-- Food heal registry ---------------------------------------------------------
-- minetest.item_eat(hp_change) hides hp_change inside the on_use closure it
-- returns, so there is no supported way to read back "how much does this food
-- heal?" from a registered item. Several mods want that (e.g. drying_rack, which
-- derives dried-food HP from the raw ingredient). We capture it here, at the
-- point the closure is built, keyed weakly by the returned function. This must
-- run before any food is registered, hence its home at the top of `default`
-- (every food-providing mod depends on default and so loads after it). `core`
-- and `minetest` are the same table, so wrapping one wraps both.
do
	local orig_item_eat = minetest.item_eat
	local heal_by_fn = setmetatable({}, {__mode = "k"})

	function minetest.item_eat(hp_change, replace_with_item)
		local fn = orig_item_eat(hp_change, replace_with_item)
		if type(fn) == "function" then
			heal_by_fn[fn] = hp_change
		end
		return fn
	end

	-- Returns the HP a food item restores when eaten, or nil if unknown
	-- (item registered without minetest.item_eat, or via a custom on_use).
	function default.get_food_heal(itemname)
		local def = itemname and minetest.registered_items[itemname]
		local on_use = def and def.on_use
		if on_use then return heal_by_fn[on_use] end
		return nil
	end
end

-- Check for engine features required by MTG
-- This provides clear error behaviour when MTG is newer than the installed engine
-- and avoids obscure, hard to debug runtime errors.
-- This section should be updated before release and older checks can be dropped
-- when newer ones are introduced.
if ItemStack("").add_wear_by_uses == nil then
	error("\nThis version of Minetest Game is incompatible with your engine version "..
		"(which is too old). You should download a version of Minetest Game that "..
		"matches the installed engine version.\n")
end

-- GUI related stuff
minetest.register_on_joinplayer(function(player)
	-- Set formspec prepend
	local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)

	-- Set hotbar textures
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
end)

function default.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

default.gui_survival_form = "size[8,8.5]"..
			"list[current_player;main;0,4.25;8,1;]"..
			"list[current_player;main;0,5.5;8,3;8]"..
			"list[current_player;craft;1.75,0.5;3,3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			default.get_hotbar_bg(0,4.25)

-- Load files
local default_path = minetest.get_modpath("default")

dofile(default_path.."/functions.lua")
dofile(default_path.."/trees.lua")
dofile(default_path.."/nodes.lua")
dofile(default_path.."/chests.lua")
dofile(default_path.."/furnace.lua")
dofile(default_path.."/torch.lua")
dofile(default_path.."/wood_nails.lua")
dofile(default_path.."/mud.lua")
dofile(default_path.."/ai_module.lua")
dofile(default_path.."/decotest.lua")
dofile(default_path.."/concrete.lua")
dofile(default_path.."/tools.lua")
dofile(default_path.."/ropes.lua")
dofile(default_path.."/item_entity.lua")
dofile(default_path.."/craftitems.lua")
dofile(default_path.."/crafting.lua")
dofile(default_path.."/mapgen.lua")
dofile(default_path.."/aliases.lua")
dofile(default_path.."/ugrnd.lua")
dofile(default_path.."/legacy.lua")
