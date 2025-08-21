--[[
	Mod Craft Table for Minetest
	Copyright (C) 2020 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	API
  ]]


-- Drop residual items from craft list
local function drop_craft(player, pos) 
	local invref = player:get_inventory()
	if not pos then pos = player:get_pos() end
	local size = invref:get_size("craft")
	for i = 1, size do
		local item = invref:get_stack("craft", i)
		if item ~= nil then 
			minetest.env:add_item({x = pos.x + (((math.random(1, 70)/100)-0.35)), y = pos.y+1, z = pos.z + (((math.random(1, 70)/100)-0.35))}, item)
		end
		invref:set_stack("craft", i, '')
	end
end

-- Formspec for craft table
local craft_table_form = 
	"size[8,8.3]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"list[current_player;craft;1.75,0.5;3,3;]"..
	"image[4.85,1.45;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_player;craftpreview;5.75,1.5;1,1;]"..
	default.get_hotbar_bg(0,4.25)

-- On_rightclick callback for craft tables
craft_table.on_rightclick = function(pos, node, player)
	local meta = player:get_meta()
	meta:set_string("craft_table:craft_table_pos", minetest.serialize(pos))
	meta:set_string("craft_table:craft_table_node", node.name)
	meta:set_string("craft_table:craft_table_grid", "3x3")
	minetest.show_formspec(player:get_player_name(), "craft_table:craft_table", craft_table_form)
	drop_craft(player)
end

-- Clear metadata when exit from craft table formspec
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "craft_table:craft_table" and fields.quit then
		local meta = player:get_meta()
		drop_craft(player, minetest.deserialize(meta:get_string("craft_table:craft_table_pos")))
		meta:set_string("craft_table:craft_table_pos", "")
	end
end)

-- Check craft table
local check_craft_table = function(player)
	local meta = player:get_meta()
	if meta:get_string("craft_table:craft_table_pos") == ""
		or meta:get_string("craft_table:craft_table_node") == ""
	then
		return false
	end
	
	-- Current node
	local node = minetest.get_node(minetest.deserialize(meta:get_string("craft_table:craft_table_pos")))
	
	-- Check node
	if node.name ~= meta:get_string("craft_table:craft_table_node") then
		return false
	end
	
	return true
end

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	return itemstack
end)
