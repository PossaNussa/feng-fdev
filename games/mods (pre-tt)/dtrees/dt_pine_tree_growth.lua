-- dynamic_trees/dt_pine_tree_growth.lua

-- This Is Where The Dynamic Pine Tree Growth Behavior Is

-- Tree Growth Starts Here With The Sapling
-- Sapling Growing A Canopy Base
function default.dt_pine_canopy_base_on_sapling(pos, node)
	while node.name == "dynamic_trees:pine_tree_sapling" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base On Sapling",
	nodenames = {"dynamic_trees:pine_tree_sapling"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_canopy_base_on_sapling(...)
	end
})

-- This Spawns A Base Trunk That The Tree Will Grow From
function default.dt_pine_main_trunk_base_2x2_replace_sapling(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_sapling" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base 2x2 Replace Sapling",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_main_trunk_base_2x2_replace_sapling(...)
	end
})


-- The Main Trunk Base Grows On It's Own Accord
-- The Rest Of The Tree Will Grow With It
-- Main Trunk Base Grows To 16x16
function default.dt_pine_main_trunk_base_grows_to_16x16(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 16x16",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 105,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_16x16(...)
	end
})

-- Main Trunk Base Grows To 14x14
function default.dt_pine_main_trunk_base_grows_to_14x14(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 14x14",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 90,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_14x14(...)
	end
})

-- Main Trunk Base Grows To 12x12
function default.dt_pine_main_trunk_base_grows_to_12x12(pos, node)
	while node.name ==  "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 12x12",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 75,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_12x12(...)
	end
})

-- Main Trunk Base Grows To 10x10
function default.dt_pine_main_trunk_base_grows_to_10x10(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 10x10",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 60,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_10x10(...)
	end
})

-- Main Trunk Base Grows To 8x8
function default.dt_pine_main_trunk_base_grows_to_8x8(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 8x8",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 45,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_8x8(...)
	end
})

-- Main Trunk Base Grows To 6x6
function default.dt_pine_main_trunk_base_grows_to_6x6(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base grows to 6x6",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_6x6(...)
	end
})

-- Main Trunk Base Grows To 4x4
function default.dt_pine_main_trunk_base_grows_to_4x4(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_base_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_base_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base Grows To 4x4",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_main_trunk_base_grows_to_4x4(...)
	end
})

-- This Is Where The New Growth Is Handled
-- Main Trunk Base 2x2 Grows 2x2 Trunk
function default.dt_pine_main_trunk_base_2x2_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base 2x2 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_main_trunk_base_2x2_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Axial Trunk
function default.dt_pine_main_trunk_base_2x2_grows_2x2_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base 2x2 Grows 2x2 Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_pine_main_trunk_base_2x2_grows_2x2_axial_trunk(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Trunk
function default.dt_pine_main_trunk_base_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_pine_main_trunk_base_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Axial Trunk
function default.dt_pine_main_trunk_base_4x4_grows_2x2_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Base 4x4 Grows 2x2 Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_main_trunk_base_4x4_grows_2x2_axial_trunk(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Trunk
function default.dt_pine_main_trunk_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_pine_main_trunk_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Axial Trunk
function default.dt_pine_main_trunk_4x4_grows_2x2_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk 4x4 Grows 2x2 Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_main_trunk_4x4_grows_2x2_axial_trunk(...)
	end
})

-- Axial Trunk 4x4 Grows 2x2 Main Trunk
function default.dt_pine_axial_trunk_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_main_trunk(...)
	end
})

-- Axial Trunk 4x4 Grows 2x2 Axial Trunk
function default.dt_pine_axial_trunk_4x4_grows_2x2_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_axial_trunk(...)
	end
})

-- This Is Where The Rest Of The Tree Checks If It Should Be Growing

-- This Section Is For All The Nodes That Will Grow To 16x16 From The Tree Base
-- These Are The Sections Of The Main Trunk That Will Grow 37 Blocks Above It
-- Main Trunk Grows To 16x16 Section 1
function default.dt_pine_main_trunk_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_1(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 1
function default.dt_pine_axial_trunk_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_1(...)
	end
})

-- Main Trunk Grows To 16x16 Section 2
function default.dt_pine_main_trunk_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_2(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 2
function default.dt_pine_axial_trunk_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_2(...)
	end
})

-- Main Trunk Grows To 16x16 Section 3
function default.dt_pine_main_trunk_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_3(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 3
function default.dt_pine_axial_trunk_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_3(...)
	end
})

-- Main Trunk Grows To 16x16 Section 4
function default.dt_pine_main_trunk_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_4(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 4
function default.dt_pine_axial_trunk_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_4(...)
	end
})

-- Main Trunk Grows To 16x16 Section 5
function default.dt_pine_main_trunk_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_5(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 5
function default.dt_pine_axial_trunk_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_5(...)
	end
})

-- Main Trunk Grows To 16x16 Section 6
function default.dt_pine_main_trunk_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_6(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 6
function default.dt_pine_axial_trunk_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_6(...)
	end
})

-- Main Trunk Grows To 16x16 Section 7
function default.dt_pine_main_trunk_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_7(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 7
function default.dt_pine_axial_trunk_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_7(...)
	end
})

-- Main Trunk Grows To 16x16 Section 8
function default.dt_pine_main_trunk_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_8(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 8
function default.dt_pine_axial_trunk_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_8(...)
	end
})

-- Main Trunk Grows To 16x16 Section 9
function default.dt_pine_main_trunk_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_9(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 9
function default.dt_pine_axial_trunk_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_9(...)
	end
})

-- Main Trunk Grows To 16x16 Section 10
function default.dt_pine_main_trunk_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_10(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 10
function default.dt_pine_axial_trunk_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_10(...)
	end
})

-- Main Trunk Grows To 16x16 Section 11
function default.dt_pine_main_trunk_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_11(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 11
function default.dt_pine_axial_trunk_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_11(...)
	end
})

-- Main Trunk Grows To 16x16 Section 12
function default.dt_pine_main_trunk_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_12(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 12
function default.dt_pine_axial_trunk_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_12(...)
	end
})

-- Main Trunk Grows To 16x16 Section 13
function default.dt_pine_main_trunk_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_13(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 13
function default.dt_pine_axial_trunk_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_13(...)
	end
})

-- Main Trunk Grows To 16x16 Section 14
function default.dt_pine_main_trunk_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_14(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 14
function default.dt_pine_axial_trunk_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_14(...)
	end
})

-- Main Trunk Grows To 16x16 Section 15
function default.dt_pine_main_trunk_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_15(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 15
function default.dt_pine_axial_trunk_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_15(...)
	end
})

-- Main Trunk Grows To 16x16 Section 16
function default.dt_pine_main_trunk_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_16(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 16
function default.dt_pine_axial_trunk_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_16(...)
	end
})

-- Main Trunk Grows To 16x16 Section 17
function default.dt_pine_main_trunk_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_17(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 17
function default.dt_pine_axial_trunk_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_17(...)
	end
})

-- Main Trunk Grows To 16x16 Section 18
function default.dt_pine_main_trunk_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_18(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 18
function default.dt_pine_axial_trunk_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_18(...)
	end
})

-- Main Trunk Grows To 16x16 Section 19
function default.dt_pine_main_trunk_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_19(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 19
function default.dt_pine_axial_trunk_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_19(...)
	end
})

-- Main Trunk Grows To 16x16 Section 20
function default.dt_pine_main_trunk_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_20(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 20
function default.dt_pine_axial_trunk_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_20(...)
	end
})

-- Main Trunk Grows To 16x16 Section 21
function default.dt_pine_main_trunk_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_21(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 21
function default.dt_pine_axial_trunk_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_21(...)
	end
})

-- Main Trunk Grows To 16x16 Section 22
function default.dt_pine_main_trunk_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_22(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 22
function default.dt_pine_axial_trunk_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_22(...)
	end
})

-- Main Trunk Grows To 16x16 Section 23
function default.dt_pine_main_trunk_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_23(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 23
function default.dt_pine_axial_trunk_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_23(...)
	end
})

-- Main Trunk Grows To 16x16 Section 24
function default.dt_pine_main_trunk_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_24(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 24
function default.dt_pine_axial_trunk_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_24(...)
	end
})

-- Main Trunk Grows To 16x16 Section 25
function default.dt_pine_main_trunk_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_25(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 25
function default.dt_pine_axial_trunk_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_25(...)
	end
})

-- Main Trunk Grows To 16x16 Section 26
function default.dt_pine_main_trunk_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_26(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 26
function default.dt_pine_axial_trunk_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_26(...)
	end
})

-- Main Trunk Grows To 16x16 Section 27
function default.dt_pine_main_trunk_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_27(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 27
function default.dt_pine_axial_trunk_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_27(...)
	end
})

-- Main Trunk Grows To 16x16 Section 28
function default.dt_pine_main_trunk_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_28(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 28
function default.dt_pine_axial_trunk_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_28(...)
	end
})

-- Main Trunk Grows To 16x16 Section 29
function default.dt_pine_main_trunk_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_29(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 29
function default.dt_pine_axial_trunk_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_29(...)
	end
})

-- Main Trunk Grows To 16x16 Section 30
function default.dt_pine_main_trunk_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_30(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 30
function default.dt_pine_axial_trunk_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_30(...)
	end
})

-- Main Trunk Grows To 16x16 Section 31
function default.dt_pine_main_trunk_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_31(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 31
function default.dt_pine_axial_trunk_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_31(...)
	end
})

-- Main Trunk Grows To 16x16 Section 32
function default.dt_pine_main_trunk_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_32(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 32
function default.dt_pine_axial_trunk_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_32(...)
	end
})

-- Main Trunk Grows To 16x16 Section 33
function default.dt_pine_main_trunk_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_33(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 33
function default.dt_pine_axial_trunk_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_33(...)
	end
})

-- Main Trunk Grows To 16x16 Section 34
function default.dt_pine_main_trunk_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_34(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 34
function default.dt_pine_axial_trunk_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_34(...)
	end
})

-- Main Trunk Grows To 16x16 Section 35
function default.dt_pine_main_trunk_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_35(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 35
function default.dt_pine_axial_trunk_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_35(...)
	end
})

-- Main Trunk Grows To 16x16 Section 36
function default.dt_pine_main_trunk_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_36(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 36
function default.dt_pine_axial_trunk_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_36(...)
	end
})

-- Main Trunk Grows To 16x16 Section 37
function default.dt_pine_main_trunk_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_16x16_section_37(...)
	end
})

-- Axial Trunk Grows To 16x16 Section 37
function default.dt_pine_axial_trunk_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_16x16_section_37(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Tree Base
-- Main Trunk Grows To 14x14
function default.dt_pine_main_trunk_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 14x14",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_14x14(...)
	end
})

-- Axial Trunk Grows To 14x14
function default.dt_pine_axial_trunk_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 14x14",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_14x14(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Tree Base
-- Main Trunk Grows To 12x12
function default.dt_pine_main_trunk_grows_to_12x12(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 12x12",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_12x12(...)
	end
})

-- Axial Trunk Grows To 12x12
function default.dt_pine_axial_trunk_grows_to_12x12(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 12x12",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_12x12(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Tree Base
-- Main Trunk Grows To 10x10
function default.dt_pine_main_trunk_grows_to_10x10(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 10x10",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_10x10(...)
	end
})

-- Axial Trunk Grows To 10x10
function default.dt_pine_axial_trunk_grows_to_10x10(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 10x10",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_10x10(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Tree Base
-- Main Trunk Grows To 8x8
function default.dt_pine_main_trunk_grows_to_8x8(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 8x8",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_8x8(...)
	end
})

-- Axial Trunk Grows To 8x8
function default.dt_pine_axial_trunk_grows_to_8x8(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 8x8",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_8x8(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Tree Base
-- Main Trunk Grows To 6x6
function default.dt_pine_main_trunk_grows_to_6x6(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 6x6",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_6x6(...)
	end
})

-- Axial Trunk Grows To 6x6
function default.dt_pine_axial_trunk_grows_to_6x6(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 6x6",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_6x6(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Tree Base
-- Main Trunk Grows To 4x4
function default.dt_pine_main_trunk_grows_to_4x4(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 4x4",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_4x4(...)
	end
})

-- Axial Trunk Grows To 4x4
function default.dt_pine_axial_trunk_grows_to_4x4(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 4x4",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_4x4(...)
	end
})

-- This Is Where The Main Trunk 12x12 Nodes Grow To 14x14 From The Main Trunk
-- Main Trunk Grows To 14x14 From Main Trunk
function default.dt_pine_main_trunk_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_14x14_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 14x14 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_14x14_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 12x12 Nodes Grow To 14x14 From The Axial Trunk
-- Main Trunk Grows To 14x14 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_14x14_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 14x14 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_14x14_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 14x14 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_14x14_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 14x14 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_14x14_from_axial_trunk(...)
	end
})

-- This Is Where The Main Trunk 10x10 Nodes Grow To 12x12 From The Main Trunk
-- Main Trunk Grows To 12x12 From Main Trunk
function default.dt_pine_main_trunk_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_12x12_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 12x12 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_12x12_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 10x10 Nodes Grow To 12x12 From The Axial Trunk
-- Main Trunk Grows To 12x12 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_12x12_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 12x12 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_12x12_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 12x12 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_12x12_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 12x12 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_12x12_from_axial_trunk(...)
	end
})

-- This Is Where The Main Trunk 8x8 Nodes Grow To 10x10 From The Main Trunk
-- Main Trunk Grows To 10x10 From Main Trunk
function default.dt_pine_main_trunk_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_10x10_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 10x10 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_10x10_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 8x8 Nodes Grow To 10x10 From The Axial Trunk
-- Main Trunk Grows To 10x10 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_10x10_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 10x10 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_10x10_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 10x10 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_10x10_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 10x10 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_10x10_from_axial_trunk(...)
	end
})

-- This Is Where The Main Trunk 6x6 Nodes Grow To 8x8 From The Main Trunk
-- Main Trunk Grows To 8x8 From Main Trunk
function default.dt_pine_main_trunk_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_8x8_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 8x8 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_8x8_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 6x6 Nodes Grow To 8x8 From The Axial Trunk
-- Main Trunk Grows To 8x8 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_8x8_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 8x8 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_8x8_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 8x8 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_8x8_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 8x8 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_8x8_from_axial_trunk(...)
	end
})

-- This Is Where The Main Trunk 4x4 Nodes Grow To 6x6 From The Main Trunk
-- Main Trunk Grows To 6x6 From Main Trunk
function default.dt_pine_main_trunk_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_6x6_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 6x6 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_6x6_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 4x4 Nodes Grow To 6x6 From The Axial Trunk
-- Main Trunk Grows To 6x6 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_6x6_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 6x6 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_6x6_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 6x6 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_6x6_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 6x6 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_6x6_from_axial_trunk(...)
	end
})

-- This Is Where The Main Trunk 2x2 Nodes Grow To 4x4 From The Main Trunk
-- Main Trunk Grows To 4x4 From Main Trunk
function default.dt_pine_main_trunk_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_4x4_from_main_trunk(...)
	end
})

-- Axial Trunk Grows To 4x4 From Main Trunk
function default.dt_pine_axial_trunk_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_4x4_from_main_trunk(...)
	end
})

-- This Is Where The Main Trunk 2x2 Nodes Grow To 4x4 From The Axial Trunk
-- Main Trunk Grows To 4x4 From Axial Trunk
function default.dt_pine_main_trunk_grows_to_4x4_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Main Trunk Grows To 4x4 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_main_trunk_grows_to_4x4_from_axial_trunk(...)
	end
})

-- Axial Trunk Grows To 4x4 From Axial Trunk
function default.dt_pine_axial_trunk_grows_to_4x4_from_axial_trunk(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_axial_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_axial_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk Grows To 4x4 From Axial Trunk",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_grows_to_4x4_from_axial_trunk(...)
	end
})


-- This Is Where The Axial Trunk Grows New Branches
-- North Facing Node Placement
-- Axial Trunk 4x4 Grows 2x2 Arm North
function default.dt_pine_axial_trunk_4x4_grows_2x2_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_arm_north(...)
	end
})

-- Arm North 4x4 Grows 2x2 Arm North
function default.dt_pine_arm_north_4x4_grows_2x2_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 4x4 Grows 2x2 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_north_4x4_grows_2x2_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 4x4 Grows 2x2 Arm South
function default.dt_pine_axial_trunk_4x4_grows_2x2_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_arm_south(...)
	end
})

-- Arm South 4x4 Grows 2x2 Arm South
function default.dt_pine_arm_south_4x4_grows_2x2_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 4x4 Grows 2x2 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_south_4x4_grows_2x2_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 4x4 Grows 2x2 Arm East
function default.dt_pine_axial_trunk_4x4_grows_2x2_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_arm_east(...)
	end
})

-- Arm East 4x4 Grows 2x2 Arm East
function default.dt_pine_arm_east_4x4_grows_2x2_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 4x4 Grows 2x2 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_east_4x4_grows_2x2_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 4x4 Grows 2x2 Arm West
function default.dt_pine_axial_trunk_4x4_grows_2x2_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 4x4 Grows 2x2 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_4x4_grows_2x2_arm_west(...)
	end
})

-- Arm West 4x4 Grows 2x2 Arm West
function default.dt_pine_arm_west_4x4_grows_2x2_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 4x4 Grows 2x2 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_west_4x4_grows_2x2_arm_west(...)
	end
})

-- This Is Where The Axial Trunk Grows The Branches
-- North Facing Node Placement
-- Axial Trunk 16x16 Grows 14x14 Arm North
function default.dt_pine_axial_trunk_16x16_grows_14x14_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 16x16 Grows 14x14 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_16x16_grows_14x14_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 16x16 Grows 14x14 Arm South
function default.dt_pine_axial_trunk_16x16_grows_14x14_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 16x16 Grows 14x14 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_16x16_grows_14x14_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 16x16 Grows 14x14 Arm East
function default.dt_pine_axial_trunk_16x16_grows_14x14_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 16x16 Grows 14x14 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_16x16_grows_14x14_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 16x16 Grows 14x14 Arm West
function default.dt_pine_axial_trunk_16x16_grows_14x14_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_16x16" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 16x16 Grows 14x14 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_pine_axial_trunk_16x16_grows_14x14_arm_west(...)
	end
})

-- North Facing Node Placement
-- Axial Trunk 14x14 Grows 12x12 Arm North
function default.dt_pine_axial_trunk_14x14_grows_12x12_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 14x14 Grows 12x12 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_14x14_grows_12x12_arm_north(...)
	end
})

-- Arm North 14x14 Grows 12x12 Arm North
function default.dt_pine_arm_north_14x14_grows_12x12_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 14x14 Grows 12x12 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_arm_north_14x14_grows_12x12_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 14x14 Grows 12x12 Arm South
function default.dt_pine_axial_trunk_14x14_grows_12x12_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 14x14 Grows 12x12 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_14x14_grows_12x12_arm_south(...)
	end
})

-- Arm South 14x14 Grows 12x12 Arm South
function default.dt_pine_arm_south_14x14_grows_12x12_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 14x14 Grows 12x12 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_arm_south_14x14_grows_12x12_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 14x14 Grows 12x12 Arm East
function default.dt_pine_axial_trunk_14x14_grows_12x12_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 14x14 Grows 12x12 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_14x14_grows_12x12_arm_east(...)
	end
})

-- Arm East 14x14 Grows 12x12 Arm East
function default.dt_pine_arm_east_14x14_grows_12x12_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 14x14 Grows 12x12 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_arm_east_14x14_grows_12x12_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 14x14 Grows 12x12 Arm West
function default.dt_pine_axial_trunk_14x14_grows_12x12_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 14x14 Grows 12x12 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_axial_trunk_14x14_grows_12x12_arm_west(...)
	end
})

-- Arm West 14x14 Grows 12x12 Arm West
function default.dt_pine_arm_west_14x14_grows_12x12_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 14x14 Grows 12x12 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_pine_arm_west_14x14_grows_12x12_arm_west(...)
	end
})

-- North Facing Node Placement
-- Axial Trunk 12x12 Grows 10x10 Arm North
function default.dt_pine_axial_trunk_12x12_grows_10x10_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 12x12 Grows 10x10 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_12x12_grows_10x10_arm_north(...)
	end
})

-- Arm North 12x12 Grows 10x10 Arm North
function default.dt_pine_arm_north_12x12_grows_10x10_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 12x12 Grows 10x10 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_arm_north_12x12_grows_10x10_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 12x12 Grows 10x10 Arm South
function default.dt_pine_axial_trunk_12x12_grows_10x10_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 12x12 Grows 10x10 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_12x12_grows_10x10_arm_south(...)
	end
})

-- Arm South 12x12 Grows 10x10 Arm South
function default.dt_pine_arm_south_12x12_grows_10x10_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 12x12 Grows 10x10 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_arm_south_12x12_grows_10x10_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 12x12 Grows 10x10 Arm East
function default.dt_pine_axial_trunk_12x12_grows_10x10_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 12x12 Grows 10x10 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_12x12_grows_10x10_arm_east(...)
	end
})

-- Arm East 12x12 Grows 10x10 Arm East
function default.dt_pine_arm_east_12x12_grows_10x10_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 12x12 Grows 10x10 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_arm_east_12x12_grows_10x10_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 12x12 Grows 10x10 Arm West
function default.dt_pine_axial_trunk_12x12_grows_10x10_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 12x12 Grows 10x10 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_axial_trunk_12x12_grows_10x10_arm_west(...)
	end
})

-- Arm West 12x12 Grows 10x10 Arm West
function default.dt_pine_arm_west_12x12_grows_10x10_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 12x12 Grows 10x10 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_pine_arm_west_12x12_grows_10x10_arm_west(...)
	end
})

-- North Facing Node Placement
-- Axial Trunk 10x10 Grows 8x8 Arm North
function default.dt_pine_axial_trunk_10x10_grows_8x8_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 10x10 Grows 8x8 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_10x10_grows_8x8_arm_north(...)
	end
})

-- Arm North 10x10 Grows 8x8 Arm North
function default.dt_pine_arm_north_10x10_grows_8x8_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 10x10 Grows 8x8 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_arm_north_10x10_grows_8x8_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 10x10 Grows 8x8 Arm South
function default.dt_pine_axial_trunk_10x10_grows_8x8_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 10x10 Grows 8x8 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_10x10_grows_8x8_arm_south(...)
	end
})

-- Arm South 10x10 Grows 8x8 Arm South
function default.dt_pine_arm_south_10x10_grows_8x8_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 10x10 Grows 8x8 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_arm_south_10x10_grows_8x8_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 10x10 Grows 8x8 Arm East
function default.dt_pine_axial_trunk_10x10_grows_8x8_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 10x10 Grows 8x8 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_10x10_grows_8x8_arm_east(...)
	end
})

-- Arm East 10x10 Grows 8x8 Arm East
function default.dt_pine_arm_east_10x10_grows_8x8_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 10x10 Grows 8x8 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_arm_east_10x10_grows_8x8_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 10x10 Grows 8x8 Arm West
function default.dt_pine_axial_trunk_10x10_grows_8x8_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 10x10 Grows 8x8 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_axial_trunk_10x10_grows_8x8_arm_west(...)
	end
})

-- Arm West 10x10 Grows 8x8 Arm West
function default.dt_pine_arm_west_10x10_grows_8x8_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 10x10 Grows 8x8 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_arm_west_10x10_grows_8x8_arm_west(...)
	end
})

-- North Facing Node Placement
-- Axial Trunk 8x8 Grows 6x6 Arm North
function default.dt_pine_axial_trunk_8x8_grows_6x6_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 8x8 Grows 6x6 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_8x8_grows_6x6_arm_north(...)
	end
})

-- Arm North 8x8 Grows 6x6 Arm North
function default.dt_pine_arm_north_8x8_grows_6x6_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 8x8 Grows 6x6 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_north_8x8_grows_6x6_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 8x8 Grows 6x6 Arm South
function default.dt_pine_axial_trunk_8x8_grows_6x6_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 8x8 Grows 6x6 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_8x8_grows_6x6_arm_south(...)
	end
})

-- Arm South 8x8 Grows 6x6 Arm South
function default.dt_pine_arm_south_8x8_grows_6x6_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 8x8 Grows 6x6 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_south_8x8_grows_6x6_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 8x8 Grows 6x6 Arm East
function default.dt_pine_axial_trunk_8x8_grows_6x6_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 8x8 Grows 6x6 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_8x8_grows_6x6_arm_east(...)
	end
})

-- Arm East 8x8 Grows 6x6 Arm East
function default.dt_pine_arm_east_8x8_grows_6x6_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 8x8 Grows 6x6 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_east_8x8_grows_6x6_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 8x8 Grows 6x6 Arm West
function default.dt_pine_axial_trunk_8x8_grows_6x6_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 8x8 Grows 6x6 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_8x8_grows_6x6_arm_west(...)
	end
})

-- Arm West 8x8 Grows 6x6 Arm West
function default.dt_pine_arm_west_8x8_grows_6x6_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 8x8 Grows 6x6 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_west_8x8_grows_6x6_arm_west(...)
	end
})

-- North Facing Node Placement
-- Axial Trunk 6x6 Grows 4x4 Arm North
function default.dt_pine_axial_trunk_6x6_grows_4x4_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 6x6 Grows 4x4 Arm North",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_6x6_grows_4x4_arm_north(...)
	end
})

-- Arm North 6x6 Grows 4x4 Arm North
function default.dt_pine_arm_north_6x6_grows_4x4_arm_north(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm North 6x6 Grows 4x4 Arm North",
	nodenames = {"dynamic_trees:pine_tree_arm_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_north_6x6_grows_4x4_arm_north(...)
	end
})

-- South Facing Node Placement
-- Axial Trunk 6x6 Grows 4x4 Arm South
function default.dt_pine_axial_trunk_6x6_grows_4x4_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 6x6 Grows 4x4 Arm South",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_6x6_grows_4x4_arm_south(...)
	end
})

-- Arm South 6x6 Grows 4x4 Arm South
function default.dt_pine_arm_south_6x6_grows_4x4_arm_south(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm South 6x6 Grows 4x4 Arm South",
	nodenames = {"dynamic_trees:pine_tree_arm_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_south_6x6_grows_4x4_arm_south(...)
	end
})

-- East Facing Node Placement
-- Axial Trunk 6x6 Grows 4x4 Arm East
function default.dt_pine_axial_trunk_6x6_grows_4x4_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 6x6 Grows 4x4 Arm East",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_6x6_grows_4x4_arm_east(...)
	end
})

-- Arm East 6x6 Grows 4x4 Arm East
function default.dt_pine_arm_east_6x6_grows_4x4_arm_east(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm East 6x6 Grows 4x4 Arm East",
	nodenames = {"dynamic_trees:pine_tree_arm_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_east_6x6_grows_4x4_arm_east(...)
	end
})

-- West Facing Node Placement
-- Axial Trunk 6x6 Grows 4x4 Arm West
function default.dt_pine_axial_trunk_6x6_grows_4x4_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Axial Trunk 6x6 Grows 4x4 Arm West",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_axial_trunk_6x6_grows_4x4_arm_west(...)
	end
})

-- Arm West 6x6 Grows 4x4 Arm West
function default.dt_pine_arm_west_6x6_grows_4x4_arm_west(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_arm_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_arm_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Pine Arm West 6x6 Grows 4x4 Arm West",
	nodenames = {"dynamic_trees:pine_tree_arm_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_pine_arm_west_6x6_grows_4x4_arm_west(...)
	end
})

-- Leaves Growth
-- Canopy Base Will Spawn Above And Around The 2x2 Nodes Of The Tree
-- This Spawns Canopy Base Above Main Trunk 2x2
function default.dt_pine_canopy_base_above_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Above Main Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_above_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -x Main Trunk 2x2
function default.dt_pine_canopy_base_minus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +x Main Trunk 2x2
function default.dt_pine_canopy_base_plus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -z Main Trunk 2x2
function default.dt_pine_canopy_base_minus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +z Main Trunk 2x2
function default.dt_pine_canopy_base_plus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_main_trunk_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base Above Axial Trunk 2x2
function default.dt_pine_canopy_base_above_axial_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Above Axial Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_above_axial_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -x Axial Trunk 2x2
function default.dt_pine_canopy_base_minus_x_axial_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus X Axial Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_x_axial_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +x Axial Trunk 2x2
function default.dt_pine_canopy_base_plus_x_axial_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus X Axial Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_x_axial_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -z Axial Trunk 2x2
function default.dt_pine_canopy_base_minus_z_axial_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus Z Axial Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_z_axial_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +z Axial Trunk 2x2
function default.dt_pine_canopy_base_plus_z_axial_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_axial_trunk_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus Z Axial Trunk 2x2",
	nodenames = {"dynamic_trees:pine_tree_axial_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_z_axial_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm North 2x2
function default.dt_pine_canopy_base_minus_x_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus X Arm North 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_x_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm North 2x2
function default.dt_pine_canopy_base_plus_x_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus X Arm North 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_x_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm North 2x2
function default.dt_pine_canopy_base_plus_z_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus Z Arm North 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_z_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm South 2x2
function default.dt_pine_canopy_base_minus_x_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus X Arm South 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_x_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm South 2x2
function default.dt_pine_canopy_base_plus_x_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus X Arm South 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_x_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm South 2x2
function default.dt_pine_canopy_base_minus_z_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus Z Arm South 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_z_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm East 2x2
function default.dt_pine_canopy_base_plus_x_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus X Arm East 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_x_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm East 2x2
function default.dt_pine_canopy_base_minus_z_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus Z Arm East 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_z_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm East 2x2
function default.dt_pine_canopy_base_plus_z_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus Z Arm East 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_z_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm West 2x2
function default.dt_pine_canopy_base_minus_x_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus X Arm West 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_x_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm West 2x2
function default.dt_pine_canopy_base_minus_z_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Minus Z Arm West 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_minus_z_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm West 2x2
function default.dt_pine_canopy_base_plus_z_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:pine_tree_arm_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy Base Plus Z Arm West 2x2",
	nodenames = {"dynamic_trees:pine_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_base_plus_z_arm_west_2x2(...)
	end
})

-- Canopy 1 Will Spawn Above And Around Canopy Base
-- This Spawns Canopy 1 Above Canopy Base
function default.dt_pine_canopy_1_above_canopy_base(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 1 Above Canopy Base",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_1_above_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -x Canopy Base
function default.dt_pine_canopy_1_minus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 1 Minus X Canopy Base",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_1_minus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +x Canopy Base
function default.dt_pine_canopy_1_plus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 1 Plus X Canopy Base",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_1_plus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -z Canopy Base
function default.dt_pine_canopy_1_minus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 1 Minus Z Canopy Base",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_1_minus_z_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +z Canopy Base
function default.dt_pine_canopy_1_plus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_base" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 1 Plus Z Canopy Base",
	nodenames = {"dynamic_trees:pine_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_pine_canopy_1_plus_z_canopy_base(...)
	end
})

-- Canopy 2 Will Spawn Above And Around Canopy 1
-- This Spawns Canopy 2 Above Canopy 1
function default.dt_pine_canopy_2_above_canopy_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_1" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 2 Above Canopy 1",
	nodenames = {"dynamic_trees:pine_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_canopy_2_above_canopy_1(...)
	end
})

-- This Spawns Canopy 2 -x Canopy 1
function default.dt_pine_canopy_2_minus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_1" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 2 Minus X Canopy 1",
	nodenames = {"dynamic_trees:pine_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_canopy_2_minus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +x Canopy 1
function default.dt_pine_canopy_2_plus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_1" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 2 Plus X Canopy 1",
	nodenames = {"dynamic_trees:pine_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_canopy_2_plus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 -z Canopy 1
function default.dt_pine_canopy_2_minus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_1" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 2 Minus Z Canopy 1",
	nodenames = {"dynamic_trees:pine_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_canopy_2_minus_z_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +z Canopy 1
function default.dt_pine_canopy_2_plus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:pine_tree_canopy_1" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:pine_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Pine Canopy 2 Plus Z Canopy 1",
	nodenames = {"dynamic_trees:pine_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_pine_canopy_2_plus_z_canopy_1(...)
	end
})

-- Leaf Decay
-- This Is To Decay Any Leaves From The Bottom Or Top Using Air To Do So
-- The Reason Is To Allow For The Tree To Lose Excess Leaves
-- Pine Leaves Decay Bottom
function default.dt_pine_leaves_decay_bottom(pos, node)
	while node.name == "air" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay Bottom",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_bottom(...)
	end
})

-- Pine Leaves Decay Top
function default.dt_pine_leaves_decay_top(pos, node)
	while node.name == "air" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay Top",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_top(...)
	end
})

-- Pine Leaves Decay North
function default.dt_pine_leaves_decay_north(pos, node)
	while node.name == "air" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay North",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_north(...)
	end
})

-- Pine Leaves Decay South
function default.dt_pine_leaves_decay_south(pos, node)
	while node.name == "air" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay South",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_south(...)
	end
})

-- Pine Leaves Decay East
function default.dt_pine_leaves_decay_east(pos, node)
	while node.name == "air" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay East",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_east(...)
	end
})

-- Pine Leaves Decay West
function default.dt_pine_leaves_decay_west(pos, node)
	while node.name == "air" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:pine_tree_canopy_base" and node.name ~= "dynamic_trees:pine_tree_canopy_1"
	and node.name ~= "dynamic_trees:pine_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Pine Leaves Decay West",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_pine_leaves_decay_west(...)
	end
})