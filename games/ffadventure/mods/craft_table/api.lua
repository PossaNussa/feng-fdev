--[[
	Mod Craft Table for Minetest
	Copyright (C) 2020 BrunoMine (https://github.com/BrunoMine)

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.

	API
  ]]

-- Display entity for items on top of craft tables.
--
-- These are deliberately NOT static-saved. Persisting wielditem entities is
-- what left orphaned "unknown item" entities floating in the world: an entity
-- sitting just above the table can be written into a neighbouring mapblock, and
-- if that block unloads/reloads out of step with the table (or the table is dug
-- while it is unloaded) the entity survives with no node to belong to. Instead
-- the entities live only in memory and are rebuilt from the node inventory on
-- every block load by the LBM below, so nothing can ever orphan.
minetest.register_entity("craft_table:display_item", {
	initial_properties = {
		physical = false,
		collide_with_objects = false,
		pointable = false,
		visual = "wielditem",
		visual_size = {x = 0.15, y = 0.15},
		wield_item = "",
		static_save = false,
		glow = 5,
	},
	on_activate = function(self, staticdata)
		-- Any entity that activates carrying staticdata was persisted by an
		-- older version of this mod (static_save = true). It is a legacy orphan
		-- — drop it. Live displays are re-created from the node inventory by the
		-- LBM, so nothing is lost by removing it here.
		if staticdata and staticdata ~= "" then
			self.object:remove()
			return
		end
		-- Fresh spawn from add_entity(): the calling code configures us.
	end,
})

-- Grid offsets for 3x3 display on table top (slot 1-9)
local grid_offsets = {
	{x = -0.25, z = 0.25},  {x = 0, z = 0.25},  {x = 0.25, z = 0.25},
	{x = -0.25, z = 0},     {x = 0, z = 0},      {x = 0.25, z = 0},
	{x = -0.25, z = -0.25}, {x = 0, z = -0.25},  {x = 0.25, z = -0.25},
}

-- Remove and re-spawn display entities for a craft table
local function update_display(pos)
	local objs = minetest.get_objects_inside_radius(pos, 1.5)
	for _, obj in ipairs(objs) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "craft_table:display_item"
		   and ent._node_pos and vector.equals(ent._node_pos, pos) then
			obj:remove()
		end
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	for i = 1, 9 do
		local stack = inv:get_stack("craft_store", i)
		if not stack:is_empty() then
			local off = grid_offsets[i]
			local epos = vector.new(pos.x + off.x, pos.y + 0.6, pos.z + off.z)
			local obj = minetest.add_entity(epos, "craft_table:display_item")
			if obj then
				local ent = obj:get_luaentity()
				if ent then
					ent._node_pos = vector.new(pos)
					ent._slot = i
					obj:set_properties({wield_item = stack:get_name()})
				end
			end
		end
	end
end

-- Rebuild the floating item displays every time a craft table's mapblock loads.
-- Because the entities are not static-saved, this is the single source of truth
-- for what floats above a table. It also sweeps up any legacy orphaned entities:
-- update_display() removes stale displays near pos before re-spawning from the
-- current craft_store inventory.
minetest.register_lbm({
	label = "craft_table: restore item displays",
	name = "craft_table:restore_displays",
	nodenames = {"group:craft_table"},
	run_at_every_load = true,
	action = function(pos)
		update_display(pos)
	end,
})

-- Return any items currently in the player's craft grid to their main inventory
local function return_craft_to_inv(player)
	local inv = player:get_inventory()
	for i = 1, inv:get_size("craft") do
		local stack = inv:get_stack("craft", i)
		if not stack:is_empty() then
			local leftover = inv:add_item("main", stack)
			if not leftover:is_empty() then
				minetest.add_item(player:get_pos(), leftover)
			end
			inv:set_stack("craft", i, "")
		end
	end
end

-- Save player craft grid contents into the node's persistent inventory
local function save_to_node(player, pos)
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "craft_table") == 0 then
		-- Node is gone (exploded, etc.) — give items back to player
		return_craft_to_inv(player)
		return
	end

	local inv = player:get_inventory()
	local meta = minetest.get_meta(pos)
	local node_inv = meta:get_inventory()
	node_inv:set_size("craft_store", 9)

	for i = 1, 9 do
		node_inv:set_stack("craft_store", i, inv:get_stack("craft", i))
		inv:set_stack("craft", i, "")
	end

	meta:set_string("craft_table:user", "")
	update_display(pos)
end

-- Close a player's currently-open craft table (save items, resize grid, clear meta)
local function close_table(player)
	local pmeta = player:get_meta()
	local pos_str = pmeta:get_string("craft_table:craft_table_pos")
	if pos_str == "" then return end

	local pos = minetest.deserialize(pos_str)
	if pos then
		save_to_node(player, pos)
	end

	pmeta:set_string("craft_table:craft_table_pos", "")
	pmeta:set_string("craft_table:craft_table_node", "")
	pmeta:set_string("craft_table:craft_table_grid", "")

	-- Shrink craft grid back to 2x2 for i3
	local inv = player:get_inventory()
	inv:set_size("craft", 4)
	inv:set_width("craft", 2)
end

-- 9-wide hotbar background
local function get_hotbar_bg_9(x, y)
	local out = ""
	for i = 0, 8 do
		out = out .. "image[" .. (x + i) .. "," .. y .. ";1,1;gui_hb_bg.png]"
	end
	return out
end

-- Formspec with 9-wide inventory to match i3.
-- When the current craft grid matches multiple recipes, cycle buttons are shown
-- below the craftpreview slot so the player can choose which output they want.
local craft_table_base_form =
	"size[9,8.75]" ..
	default.gui_bg ..
	default.gui_bg_img ..
	default.gui_slots ..
	"list[current_player;craft;0.5,0.5;3,3;]" ..
	"image[3.7,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]" ..
	"list[current_player;craftpreview;4.8,1.5;1,1;]" ..
	"list[current_player;main;0,4.5;9,1;]" ..
	"list[current_player;main;0,5.75;9,3;9]" ..
	"listring[current_player;main]" ..
	"listring[current_player;craft]" ..
	get_hotbar_bg_9(0, 4.5)

local function make_craft_table_form(player)
	local st = recipe_cycle and player and recipe_cycle.get_state(player)
	if not st or #st.alts <= 1 then
		return craft_table_base_form
	end
	return craft_table_base_form ..
		"button[4.6,2.7;0.5,0.4;craft_cycle_prev;<]" ..
		"label[5.16,2.9;" .. st.idx .. "/" .. #st.alts .. "]" ..
		"button[5.5,2.7;0.5,0.4;craft_cycle_next;>]"
end

-- On_rightclick callback for craft tables
craft_table.on_rightclick = function(pos, node, player)
	-- Close any previously open table first (saves items back to that node)
	close_table(player)

	-- Return any stray items from i3's 2x2 grid to inventory
	return_craft_to_inv(player)

	-- Expand craft grid to 3x3
	local inv = player:get_inventory()
	inv:set_size("craft", 9)
	inv:set_width("craft", 3)

	-- Load stored items from node into player's craft grid
	local meta = minetest.get_meta(pos)
	local node_inv = meta:get_inventory()
	node_inv:set_size("craft_store", 9)

	for i = 1, 9 do
		inv:set_stack("craft", i, node_inv:get_stack("craft_store", i))
		node_inv:set_stack("craft_store", i, "")
	end

	-- Track which table is open
	local pmeta = player:get_meta()
	pmeta:set_string("craft_table:craft_table_pos", minetest.serialize(pos))
	pmeta:set_string("craft_table:craft_table_node", node.name)
	pmeta:set_string("craft_table:craft_table_grid", "3x3")
	meta:set_string("craft_table:user", player:get_player_name())

	update_display(pos)

	-- Pre-compute cycle alternatives so buttons appear immediately on open.
	if recipe_cycle then
		local grid9 = {}
		for i = 1, 9 do
			grid9[i] = inv:get_stack("craft", i):get_name()
		end
		recipe_cycle.refresh(player, grid9)
	end

	minetest.show_formspec(player:get_player_name(), "craft_table:craft_table", make_craft_table_form(player))
end

-- Node callbacks ---------------------------------------------------------

craft_table.on_construct = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size("craft_store", 9)
end

craft_table.can_dig = function(pos, player)
	local meta = minetest.get_meta(pos)
	-- Don't allow digging while a player has this table open
	if meta:get_string("craft_table:user") ~= "" then
		return false
	end
	local inv = meta:get_inventory()
	return inv:is_empty("craft_store")
end

craft_table.on_destruct = function(pos)
	local meta = minetest.get_meta(pos)

	-- If a player currently has this table open, return their craft items
	local user_name = meta:get_string("craft_table:user")
	if user_name ~= "" then
		local player = minetest.get_player_by_name(user_name)
		if player then
			return_craft_to_inv(player)
			local pmeta = player:get_meta()
			pmeta:set_string("craft_table:craft_table_pos", "")
			pmeta:set_string("craft_table:craft_table_node", "")
			pmeta:set_string("craft_table:craft_table_grid", "")
			local inv = player:get_inventory()
			inv:set_size("craft", 4)
			inv:set_width("craft", 2)
		end
	end

	-- Drop any stored items
	local inv = meta:get_inventory()
	for i = 1, 9 do
		local stack = inv:get_stack("craft_store", i)
		if not stack:is_empty() then
			minetest.add_item(pos, stack)
		end
	end

	-- Remove display entities
	local objs = minetest.get_objects_inside_radius(pos, 1.5)
	for _, obj in ipairs(objs) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "craft_table:display_item"
		   and ent._node_pos and vector.equals(ent._node_pos, pos) then
			obj:remove()
		end
	end
end

-- Formspec close handler + cycle button handler
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "craft_table:craft_table" then return end

	if fields.quit then
		close_table(player)
	elseif (fields.craft_cycle_prev or fields.craft_cycle_next) and recipe_cycle then
		recipe_cycle.cycle(player, fields.craft_cycle_prev and -1 or 1)
		-- Nudge craft slot 1 to trigger craft_predict so craftpreview updates.
		local inv = player:get_inventory()
		inv:set_stack("craft", 1, inv:get_stack("craft", 1))
		minetest.show_formspec(player:get_player_name(), "craft_table:craft_table",
			make_craft_table_form(player))
	end
end)

-- Player disconnect / death — save items back to node
minetest.register_on_leaveplayer(function(player)
	close_table(player)
end)

minetest.register_on_dieplayer(function(player)
	close_table(player)
end)

-- NOTE: do not register a pass-through craft_predict here. Craft predict
-- callbacks resolve to the last non-nil return, so a handler that simply hands
-- back the unmodified itemstack silently undoes the substitution made by
-- recipe_cycle.lua, and the cycle arrows stop changing anything.
