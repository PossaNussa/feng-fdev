-- dynamic_trees/dt_jungle_tree_growth.lua

-- This Is Where The Dynamic Jungle Tree Growth Behavior Is

-- Tree Growth Starts Here With The Sapling
-- Sapling Growing A Canopy Base
function default.dt_jungle_canopy_base_on_sapling(pos, node)
	while node.name == "dynamic_trees:jungle_tree_sapling" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base On Sapling",
	nodenames = {"dynamic_trees:jungle_tree_sapling"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_canopy_base_on_sapling(...)
	end
})

-- This Spawns A Base Trunk That The Tree Will Grow From
function default.dt_jungle_main_trunk_base_2x2_replace_sapling(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_sapling" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Replace Sapling",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_replace_sapling(...)
	end
})


-- The Main Trunk Base Grows On It's Own Accord
-- The Rest Of The Tree Will Grow With It
-- Main Trunk Base Grows To 16x16
function default.dt_jungle_main_trunk_base_grows_to_16x16(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 16x16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 105,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_16x16(...)
	end
})

-- Main Trunk Base Grows To 14x14
function default.dt_jungle_main_trunk_base_grows_to_14x14(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 90,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_14x14(...)
	end
})

-- Main Trunk Base Grows To 12x12
function default.dt_jungle_main_trunk_base_grows_to_12x12(pos, node)
	while node.name ==  "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 75,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_12x12(...)
	end
})

-- Main Trunk Base Grows To 10x10
function default.dt_jungle_main_trunk_base_grows_to_10x10(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 10x10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 60,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_10x10(...)
	end
})

-- Main Trunk Base Grows To 8x8
function default.dt_jungle_main_trunk_base_grows_to_8x8(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 8x8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 45,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_8x8(...)
	end
})

-- Main Trunk Base Grows To 6x6
function default.dt_jungle_main_trunk_base_grows_to_6x6(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base grows to 6x6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_6x6(...)
	end
})

-- Main Trunk Base Grows To 4x4
function default.dt_jungle_main_trunk_base_grows_to_4x4(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_base_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_base_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base Grows To 4x4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_base_grows_to_4x4(...)
	end
})

-- This Is Where The New Growth Is Handled
-- Main Trunk Base 2x2 Grows 2x2 Trunk
function default.dt_jungle_main_trunk_base_2x2_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork North
function default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork South
function default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork East
function default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork West
function default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 2x2 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_jungle_main_trunk_base_2x2_grows_2x2_fork_west(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Trunk
function default.dt_jungle_main_trunk_base_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_main_trunk_base_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork North
function default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork South
function default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork East
function default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork West
function default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Base 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_base_4x4_grows_2x2_fork_west(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Trunk
function default.dt_jungle_main_trunk_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_main_trunk_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork North
function default.dt_jungle_main_trunk_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork South
function default.dt_jungle_main_trunk_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork East
function default.dt_jungle_main_trunk_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork West
function default.dt_jungle_main_trunk_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_4x4"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork North 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_fork_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork South
function default.dt_jungle_fork_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork East
function default.dt_jungle_fork_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork West
function default.dt_jungle_fork_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork South 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_fork_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork North
function default.dt_jungle_fork_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork East
function default.dt_jungle_fork_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork West
function default.dt_jungle_fork_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork East 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_fork_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork North
function default.dt_jungle_fork_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork South
function default.dt_jungle_fork_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork West
function default.dt_jungle_fork_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork West 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_fork_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork North
function default.dt_jungle_fork_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork South
function default.dt_jungle_fork_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork East
function default.dt_jungle_fork_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 8,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_fork_east(...)
	end
})

-- Arm North 4x4 Grows 2x2 Arm North
function default.dt_jungle_arm_north_4x4_grows_2x2_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 4x4 Grows 2x2 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_north_4x4_grows_2x2_arm_north(...)
	end
})

-- Arm South 4x4 Grows 2x2 Arm South
function default.dt_jungle_arm_south_4x4_grows_2x2_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 4x4 Grows 2x2 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_south_4x4_grows_2x2_arm_south(...)
	end
})

-- Arm East 4x4 Grows 2x2 Arm East
function default.dt_jungle_arm_east_4x4_grows_2x2_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 4x4 Grows 2x2 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_east_4x4_grows_2x2_arm_east(...)
	end
})

-- Arm West 4x4 Grows 2x2 Arm West
function default.dt_jungle_arm_west_4x4_grows_2x2_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 4x4 Grows 2x2 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_west_4x4_grows_2x2_arm_west(...)
	end
})

-- This Is Where The Rest Of The Tree Checks If It Should Be Growing

-- This Section Is For All The Nodes That Will Grow To 16x16 From The Tree Base
-- These Are The Sections Of The Main Trunk That Will Grow 80 Blocks Above It
-- Main Trunk Grows To 16x16 Section 1
function default.dt_jungle_main_trunk_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_1(...)
	end
})

-- Fork North Grows To 16x16 Section 1
function default.dt_jungle_fork_north_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_1(...)
	end
})

-- Fork South Grows To 16x16 Section 1
function default.dt_jungle_fork_south_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_1(...)
	end
})

-- Fork East Grows To 16x16 Section 1
function default.dt_jungle_fork_east_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_1(...)
	end
})

-- Fork West Grows To 16x16 Section 1
function default.dt_jungle_fork_west_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_1(...)
	end
})

-- Main Trunk Grows To 16x16 Section 2
function default.dt_jungle_main_trunk_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_2(...)
	end
})

-- Fork North Grows To 16x16 Section 2
function default.dt_jungle_fork_north_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_2(...)
	end
})

-- Fork South Grows To 16x16 Section 2
function default.dt_jungle_fork_south_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_2(...)
	end
})

-- Fork East Grows To 16x16 Section 2
function default.dt_jungle_fork_east_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_2(...)
	end
})

-- Fork West Grows To 16x16 Section 2
function default.dt_jungle_fork_west_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_2(...)
	end
})

-- Main Trunk Grows To 16x16 Section 3
function default.dt_jungle_main_trunk_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_3(...)
	end
})

-- Fork North Grows To 16x16 Section 3
function default.dt_jungle_fork_north_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_3(...)
	end
})

-- Fork South Grows To 16x16 Section 3
function default.dt_jungle_fork_south_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_3(...)
	end
})

-- Fork East Grows To 16x16 Section 3
function default.dt_jungle_fork_east_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_3(...)
	end
})

-- Fork West Grows To 16x16 Section 3
function default.dt_jungle_fork_west_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_3(...)
	end
})

-- Main Trunk Grows To 16x16 Section 4
function default.dt_jungle_main_trunk_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_4(...)
	end
})

-- Fork North Grows To 16x16 Section 4
function default.dt_jungle_fork_north_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_4(...)
	end
})

-- Fork South Grows To 16x16 Section 4
function default.dt_jungle_fork_south_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_4(...)
	end
})

-- Fork East Grows To 16x16 Section 4
function default.dt_jungle_fork_east_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_4(...)
	end
})

-- Fork West Grows To 16x16 Section 4
function default.dt_jungle_fork_west_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_4(...)
	end
})

-- Main Trunk Grows To 16x16 Section 5
function default.dt_jungle_main_trunk_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_5(...)
	end
})

-- Fork North Grows To 16x16 Section 5
function default.dt_jungle_fork_north_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_5(...)
	end
})

-- Fork South Grows To 16x16 Section 5
function default.dt_jungle_fork_south_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_5(...)
	end
})

-- Fork East Grows To 16x16 Section 5
function default.dt_jungle_fork_east_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_5(...)
	end
})

-- Fork West Grows To 16x16 Section 5
function default.dt_jungle_fork_west_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_5(...)
	end
})

-- Main Trunk Grows To 16x16 Section 6
function default.dt_jungle_main_trunk_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_6(...)
	end
})

-- Fork North Grows To 16x16 Section 6
function default.dt_jungle_fork_north_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_6(...)
	end
})

-- Fork South Grows To 16x16 Section 6
function default.dt_jungle_fork_south_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_6(...)
	end
})

-- Fork East Grows To 16x16 Section 6
function default.dt_jungle_fork_east_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_6(...)
	end
})

-- Fork West Grows To 16x16 Section 6
function default.dt_jungle_fork_west_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_6(...)
	end
})

-- Main Trunk Grows To 16x16 Section 7
function default.dt_jungle_main_trunk_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_7(...)
	end
})

-- Fork North Grows To 16x16 Section 7
function default.dt_jungle_fork_north_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_7(...)
	end
})

-- Fork South Grows To 16x16 Section 7
function default.dt_jungle_fork_south_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_7(...)
	end
})

-- Fork East Grows To 16x16 Section 7
function default.dt_jungle_fork_east_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_7(...)
	end
})

-- Fork West Grows To 16x16 Section 7
function default.dt_jungle_fork_west_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_7(...)
	end
})

-- Main Trunk Grows To 16x16 Section 8
function default.dt_jungle_main_trunk_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_8(...)
	end
})

-- Fork North Grows To 16x16 Section 8
function default.dt_jungle_fork_north_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_8(...)
	end
})

-- Fork South Grows To 16x16 Section 8
function default.dt_jungle_fork_south_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_8(...)
	end
})

-- Fork East Grows To 16x16 Section 8
function default.dt_jungle_fork_east_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_8(...)
	end
})

-- Fork West Grows To 16x16 Section 8
function default.dt_jungle_fork_west_grows_to_16x16_section_8(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 8",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_8(...)
	end
})

-- Main Trunk Grows To 16x16 Section 9
function default.dt_jungle_main_trunk_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_9(...)
	end
})

-- Fork North Grows To 16x16 Section 9
function default.dt_jungle_fork_north_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_9(...)
	end
})

-- Fork South Grows To 16x16 Section 9
function default.dt_jungle_fork_south_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_9(...)
	end
})

-- Fork East Grows To 16x16 Section 9
function default.dt_jungle_fork_east_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_9(...)
	end
})

-- Fork West Grows To 16x16 Section 9
function default.dt_jungle_fork_west_grows_to_16x16_section_9(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 9",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_9(...)
	end
})

-- Main Trunk Grows To 16x16 Section 10
function default.dt_jungle_main_trunk_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_10(...)
	end
})

-- Fork North Grows To 16x16 Section 10
function default.dt_jungle_fork_north_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_10(...)
	end
})

-- Fork South Grows To 16x16 Section 10
function default.dt_jungle_fork_south_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_10(...)
	end
})

-- Fork East Grows To 16x16 Section 10
function default.dt_jungle_fork_east_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_10(...)
	end
})

-- Fork West Grows To 16x16 Section 10
function default.dt_jungle_fork_west_grows_to_16x16_section_10(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 10",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_10(...)
	end
})

-- Main Trunk Grows To 16x16 Section 11
function default.dt_jungle_main_trunk_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_11(...)
	end
})

-- Fork North Grows To 16x16 Section 11
function default.dt_jungle_fork_north_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_11(...)
	end
})

-- Fork South Grows To 16x16 Section 11
function default.dt_jungle_fork_south_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_11(...)
	end
})

-- Fork East Grows To 16x16 Section 11
function default.dt_jungle_fork_east_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_11(...)
	end
})

-- Fork West Grows To 16x16 Section 11
function default.dt_jungle_fork_west_grows_to_16x16_section_11(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 11",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_11(...)
	end
})

-- Main Trunk Grows To 16x16 Section 12
function default.dt_jungle_main_trunk_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_12(...)
	end
})

-- Fork North Grows To 16x16 Section 12
function default.dt_jungle_fork_north_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_12(...)
	end
})

-- Fork South Grows To 16x16 Section 12
function default.dt_jungle_fork_south_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_12(...)
	end
})

-- Fork East Grows To 16x16 Section 12
function default.dt_jungle_fork_east_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_12(...)
	end
})

-- Fork West Grows To 16x16 Section 12
function default.dt_jungle_fork_west_grows_to_16x16_section_12(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_12(...)
	end
})

-- Main Trunk Grows To 16x16 Section 13
function default.dt_jungle_main_trunk_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_13(...)
	end
})

-- Fork North Grows To 16x16 Section 13
function default.dt_jungle_fork_north_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_13(...)
	end
})

-- Fork South Grows To 16x16 Section 13
function default.dt_jungle_fork_south_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_13(...)
	end
})

-- Fork East Grows To 16x16 Section 13
function default.dt_jungle_fork_east_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_13(...)
	end
})

-- Fork West Grows To 16x16 Section 13
function default.dt_jungle_fork_west_grows_to_16x16_section_13(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 13",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_13(...)
	end
})

-- Main Trunk Grows To 16x16 Section 14
function default.dt_jungle_main_trunk_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_14(...)
	end
})

-- Fork North Grows To 16x16 Section 14
function default.dt_jungle_fork_north_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_14(...)
	end
})

-- Fork South Grows To 16x16 Section 14
function default.dt_jungle_fork_south_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_14(...)
	end
})

-- Fork East Grows To 16x16 Section 14
function default.dt_jungle_fork_east_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_14(...)
	end
})

-- Fork West Grows To 16x16 Section 14
function default.dt_jungle_fork_west_grows_to_16x16_section_14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_14(...)
	end
})

-- Main Trunk Grows To 16x16 Section 15
function default.dt_jungle_main_trunk_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_15(...)
	end
})

-- Fork North Grows To 16x16 Section 15
function default.dt_jungle_fork_north_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_15(...)
	end
})

-- Fork South Grows To 16x16 Section 15
function default.dt_jungle_fork_south_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_15(...)
	end
})

-- Fork East Grows To 16x16 Section 15
function default.dt_jungle_fork_east_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_15(...)
	end
})

-- Fork West Grows To 16x16 Section 15
function default.dt_jungle_fork_west_grows_to_16x16_section_15(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 15",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_15(...)
	end
})

-- Main Trunk Grows To 16x16 Section 16
function default.dt_jungle_main_trunk_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_16(...)
	end
})

-- Fork North Grows To 16x16 Section 16
function default.dt_jungle_fork_north_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_16(...)
	end
})

-- Fork South Grows To 16x16 Section 16
function default.dt_jungle_fork_south_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_16(...)
	end
})

-- Fork East Grows To 16x16 Section 16
function default.dt_jungle_fork_east_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_16(...)
	end
})

-- Fork West Grows To 16x16 Section 16
function default.dt_jungle_fork_west_grows_to_16x16_section_16(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 16",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_16(...)
	end
})

-- Main Trunk Grows To 16x16 Section 17
function default.dt_jungle_main_trunk_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_17(...)
	end
})

-- Fork North Grows To 16x16 Section 17
function default.dt_jungle_fork_north_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_17(...)
	end
})

-- Fork South Grows To 16x16 Section 17
function default.dt_jungle_fork_south_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_17(...)
	end
})

-- Fork East Grows To 16x16 Section 17
function default.dt_jungle_fork_east_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_17(...)
	end
})

-- Fork West Grows To 16x16 Section 17
function default.dt_jungle_fork_west_grows_to_16x16_section_17(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 17",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_17(...)
	end
})

-- Main Trunk Grows To 16x16 Section 18
function default.dt_jungle_main_trunk_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_18(...)
	end
})

-- Fork North Grows To 16x16 Section 18
function default.dt_jungle_fork_north_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_18(...)
	end
})

-- Fork South Grows To 16x16 Section 18
function default.dt_jungle_fork_south_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_18(...)
	end
})

-- Fork East Grows To 16x16 Section 18
function default.dt_jungle_fork_east_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_18(...)
	end
})

-- Fork West Grows To 16x16 Section 18
function default.dt_jungle_fork_west_grows_to_16x16_section_18(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 18",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_18(...)
	end
})

-- Main Trunk Grows To 16x16 Section 19
function default.dt_jungle_main_trunk_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_19(...)
	end
})

-- Fork North Grows To 16x16 Section 19
function default.dt_jungle_fork_north_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_19(...)
	end
})

-- Fork South Grows To 16x16 Section 19
function default.dt_jungle_fork_south_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_19(...)
	end
})

-- Fork East Grows To 16x16 Section 19
function default.dt_jungle_fork_east_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_19(...)
	end
})

-- Fork West Grows To 16x16 Section 19
function default.dt_jungle_fork_west_grows_to_16x16_section_19(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 19",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_19(...)
	end
})

-- Main Trunk Grows To 16x16 Section 20
function default.dt_jungle_main_trunk_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_20(...)
	end
})

-- Fork North Grows To 16x16 Section 20
function default.dt_jungle_fork_north_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_20(...)
	end
})

-- Fork South Grows To 16x16 Section 20
function default.dt_jungle_fork_south_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_20(...)
	end
})

-- Fork East Grows To 16x16 Section 20
function default.dt_jungle_fork_east_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_20(...)
	end
})

-- Fork West Grows To 16x16 Section 20
function default.dt_jungle_fork_west_grows_to_16x16_section_20(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 20",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_20(...)
	end
})

-- Main Trunk Grows To 16x16 Section 21
function default.dt_jungle_main_trunk_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_21(...)
	end
})

-- Fork North Grows To 16x16 Section 21
function default.dt_jungle_fork_north_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_21(...)
	end
})

-- Fork South Grows To 16x16 Section 21
function default.dt_jungle_fork_south_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_21(...)
	end
})

-- Fork East Grows To 16x16 Section 21
function default.dt_jungle_fork_east_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_21(...)
	end
})

-- Fork West Grows To 16x16 Section 21
function default.dt_jungle_fork_west_grows_to_16x16_section_21(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 21",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_21(...)
	end
})

-- Main Trunk Grows To 16x16 Section 22
function default.dt_jungle_main_trunk_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_22(...)
	end
})

-- Fork North Grows To 16x16 Section 22
function default.dt_jungle_fork_north_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_22(...)
	end
})

-- Fork South Grows To 16x16 Section 22
function default.dt_jungle_fork_south_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_22(...)
	end
})

-- Fork East Grows To 16x16 Section 22
function default.dt_jungle_fork_east_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_22(...)
	end
})

-- Fork West Grows To 16x16 Section 22
function default.dt_jungle_fork_west_grows_to_16x16_section_22(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 22",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_22(...)
	end
})

-- Main Trunk Grows To 16x16 Section 23
function default.dt_jungle_main_trunk_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_23(...)
	end
})

-- Fork North Grows To 16x16 Section 23
function default.dt_jungle_fork_north_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_23(...)
	end
})

-- Fork South Grows To 16x16 Section 23
function default.dt_jungle_fork_south_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_23(...)
	end
})

-- Fork East Grows To 16x16 Section 23
function default.dt_jungle_fork_east_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_23(...)
	end
})

-- Fork West Grows To 16x16 Section 23
function default.dt_jungle_fork_west_grows_to_16x16_section_23(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 23",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_23(...)
	end
})

-- Main Trunk Grows To 16x16 Section 24
function default.dt_jungle_main_trunk_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_24(...)
	end
})

-- Fork North Grows To 16x16 Section 24
function default.dt_jungle_fork_north_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_24(...)
	end
})

-- Fork South Grows To 16x16 Section 24
function default.dt_jungle_fork_south_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_24(...)
	end
})

-- Fork East Grows To 16x16 Section 24
function default.dt_jungle_fork_east_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_24(...)
	end
})

-- Fork West Grows To 16x16 Section 24
function default.dt_jungle_fork_west_grows_to_16x16_section_24(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 24",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_24(...)
	end
})

-- Main Trunk Grows To 16x16 Section 25
function default.dt_jungle_main_trunk_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_25(...)
	end
})

-- Fork North Grows To 16x16 Section 25
function default.dt_jungle_fork_north_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_25(...)
	end
})

-- Fork South Grows To 16x16 Section 25
function default.dt_jungle_fork_south_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_25(...)
	end
})

-- Fork East Grows To 16x16 Section 25
function default.dt_jungle_fork_east_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_25(...)
	end
})

-- Fork West Grows To 16x16 Section 25
function default.dt_jungle_fork_west_grows_to_16x16_section_25(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 25",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_25(...)
	end
})

-- Main Trunk Grows To 16x16 Section 26
function default.dt_jungle_main_trunk_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_26(...)
	end
})

-- Fork North Grows To 16x16 Section 26
function default.dt_jungle_fork_north_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_26(...)
	end
})

-- Fork South Grows To 16x16 Section 26
function default.dt_jungle_fork_south_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_26(...)
	end
})

-- Fork East Grows To 16x16 Section 26
function default.dt_jungle_fork_east_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_26(...)
	end
})

-- Fork West Grows To 16x16 Section 26
function default.dt_jungle_fork_west_grows_to_16x16_section_26(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 26",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_26(...)
	end
})

-- Main Trunk Grows To 16x16 Section 27
function default.dt_jungle_main_trunk_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_27(...)
	end
})

-- Fork North Grows To 16x16 Section 27
function default.dt_jungle_fork_north_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_27(...)
	end
})

-- Fork South Grows To 16x16 Section 27
function default.dt_jungle_fork_south_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_27(...)
	end
})

-- Fork East Grows To 16x16 Section 27
function default.dt_jungle_fork_east_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_27(...)
	end
})

-- Fork West Grows To 16x16 Section 27
function default.dt_jungle_fork_west_grows_to_16x16_section_27(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 27",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_27(...)
	end
})

-- Main Trunk Grows To 16x16 Section 28
function default.dt_jungle_main_trunk_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_28(...)
	end
})

-- Fork North Grows To 16x16 Section 28
function default.dt_jungle_fork_north_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_28(...)
	end
})

-- Fork South Grows To 16x16 Section 28
function default.dt_jungle_fork_south_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_28(...)
	end
})

-- Fork East Grows To 16x16 Section 28
function default.dt_jungle_fork_east_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_28(...)
	end
})

-- Fork West Grows To 16x16 Section 28
function default.dt_jungle_fork_west_grows_to_16x16_section_28(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 28",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_28(...)
	end
})

-- Main Trunk Grows To 16x16 Section 29
function default.dt_jungle_main_trunk_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_29(...)
	end
})

-- Fork North Grows To 16x16 Section 29
function default.dt_jungle_fork_north_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_29(...)
	end
})

-- Fork South Grows To 16x16 Section 29
function default.dt_jungle_fork_south_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_29(...)
	end
})

-- Fork East Grows To 16x16 Section 29
function default.dt_jungle_fork_east_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_29(...)
	end
})

-- Fork West Grows To 16x16 Section 29
function default.dt_jungle_fork_west_grows_to_16x16_section_29(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 29",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_29(...)
	end
})

-- Main Trunk Grows To 16x16 Section 30
function default.dt_jungle_main_trunk_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_30(...)
	end
})

-- Fork North Grows To 16x16 Section 30
function default.dt_jungle_fork_north_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_30(...)
	end
})

-- Fork South Grows To 16x16 Section 30
function default.dt_jungle_fork_south_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_30(...)
	end
})

-- Fork East Grows To 16x16 Section 30
function default.dt_jungle_fork_east_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_30(...)
	end
})

-- Fork West Grows To 16x16 Section 30
function default.dt_jungle_fork_west_grows_to_16x16_section_30(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 30
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 30",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_30(...)
	end
})

-- Main Trunk Grows To 16x16 Section 31
function default.dt_jungle_main_trunk_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_31(...)
	end
})

-- Fork North Grows To 16x16 Section 31
function default.dt_jungle_fork_north_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_31(...)
	end
})

-- Fork South Grows To 16x16 Section 31
function default.dt_jungle_fork_south_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_31(...)
	end
})

-- Fork East Grows To 16x16 Section 31
function default.dt_jungle_fork_east_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_31(...)
	end
})

-- Fork West Grows To 16x16 Section 31
function default.dt_jungle_fork_west_grows_to_16x16_section_31(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 31
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 31",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_31(...)
	end
})

-- Main Trunk Grows To 16x16 Section 32
function default.dt_jungle_main_trunk_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_32(...)
	end
})

-- Fork North Grows To 16x16 Section 32
function default.dt_jungle_fork_north_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_32(...)
	end
})

-- Fork South Grows To 16x16 Section 32
function default.dt_jungle_fork_south_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_32(...)
	end
})

-- Fork East Grows To 16x16 Section 32
function default.dt_jungle_fork_east_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_32(...)
	end
})

-- Fork West Grows To 16x16 Section 32
function default.dt_jungle_fork_west_grows_to_16x16_section_32(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 32
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 32",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_32(...)
	end
})

-- Main Trunk Grows To 16x16 Section 33
function default.dt_jungle_main_trunk_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_33(...)
	end
})

-- Fork North Grows To 16x16 Section 33
function default.dt_jungle_fork_north_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_33(...)
	end
})

-- Fork South Grows To 16x16 Section 33
function default.dt_jungle_fork_south_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_33(...)
	end
})

-- Fork East Grows To 16x16 Section 33
function default.dt_jungle_fork_east_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_33(...)
	end
})

-- Fork West Grows To 16x16 Section 33
function default.dt_jungle_fork_west_grows_to_16x16_section_33(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 33
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 33",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_33(...)
	end
})

-- Main Trunk Grows To 16x16 Section 34
function default.dt_jungle_main_trunk_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_34(...)
	end
})

-- Fork North Grows To 16x16 Section 34
function default.dt_jungle_fork_north_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_34(...)
	end
})

-- Fork South Grows To 16x16 Section 34
function default.dt_jungle_fork_south_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_34(...)
	end
})

-- Fork East Grows To 16x16 Section 34
function default.dt_jungle_fork_east_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_34(...)
	end
})

-- Fork West Grows To 16x16 Section 34
function default.dt_jungle_fork_west_grows_to_16x16_section_34(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 34
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 34",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_34(...)
	end
})

-- Main Trunk Grows To 16x16 Section 35
function default.dt_jungle_main_trunk_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_35(...)
	end
})

-- Fork North Grows To 16x16 Section 35
function default.dt_jungle_fork_north_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_35(...)
	end
})

-- Fork South Grows To 16x16 Section 35
function default.dt_jungle_fork_south_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_35(...)
	end
})

-- Fork East Grows To 16x16 Section 35
function default.dt_jungle_fork_east_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_35(...)
	end
})

-- Fork West Grows To 16x16 Section 35
function default.dt_jungle_fork_west_grows_to_16x16_section_35(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 35
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 35",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_35(...)
	end
})

-- Main Trunk Grows To 16x16 Section 36
function default.dt_jungle_main_trunk_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_36(...)
	end
})

-- Fork North Grows To 16x16 Section 36
function default.dt_jungle_fork_north_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_36(...)
	end
})

-- Fork South Grows To 16x16 Section 36
function default.dt_jungle_fork_south_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_36(...)
	end
})

-- Fork East Grows To 16x16 Section 36
function default.dt_jungle_fork_east_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_36(...)
	end
})

-- Fork West Grows To 16x16 Section 36
function default.dt_jungle_fork_west_grows_to_16x16_section_36(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 36
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 36",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_36(...)
	end
})

-- Main Trunk Grows To 16x16 Section 37
function default.dt_jungle_main_trunk_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_37(...)
	end
})

-- Fork North Grows To 16x16 Section 37
function default.dt_jungle_fork_north_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_37(...)
	end
})

-- Fork South Grows To 16x16 Section 37
function default.dt_jungle_fork_south_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_37(...)
	end
})

-- Fork East Grows To 16x16 Section 37
function default.dt_jungle_fork_east_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_37(...)
	end
})

-- Fork West Grows To 16x16 Section 37
function default.dt_jungle_fork_west_grows_to_16x16_section_37(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 37
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 37",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_37(...)
	end
})

-- Main Trunk Grows To 16x16 Section 38
function default.dt_jungle_main_trunk_grows_to_16x16_section_38(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 38
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 38",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_38(...)
	end
})

-- Fork North Grows To 16x16 Section 38
function default.dt_jungle_fork_north_grows_to_16x16_section_38(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 38
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 38",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_38(...)
	end
})

-- Fork South Grows To 16x16 Section 38
function default.dt_jungle_fork_south_grows_to_16x16_section_38(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 38
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 38",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_38(...)
	end
})

-- Fork East Grows To 16x16 Section 38
function default.dt_jungle_fork_east_grows_to_16x16_section_38(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 38
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 38",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_38(...)
	end
})

-- Fork West Grows To 16x16 Section 38
function default.dt_jungle_fork_west_grows_to_16x16_section_38(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 38
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 38",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_38(...)
	end
})

-- Main Trunk Grows To 16x16 Section 39
function default.dt_jungle_main_trunk_grows_to_16x16_section_39(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 39
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 39",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_39(...)
	end
})

-- Fork North Grows To 16x16 Section 39
function default.dt_jungle_fork_north_grows_to_16x16_section_39(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 39
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 39",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_39(...)
	end
})

-- Fork South Grows To 16x16 Section 39
function default.dt_jungle_fork_south_grows_to_16x16_section_39(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 39
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 39",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_39(...)
	end
})

-- Fork East Grows To 16x16 Section 39
function default.dt_jungle_fork_east_grows_to_16x16_section_39(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 39
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 39",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_39(...)
	end
})

-- Fork West Grows To 16x16 Section 39
function default.dt_jungle_fork_west_grows_to_16x16_section_39(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 39
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 39",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_39(...)
	end
})

-- Main Trunk Grows To 16x16 Section 40
function default.dt_jungle_main_trunk_grows_to_16x16_section_40(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 40
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 40",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_40(...)
	end
})

-- Fork North Grows To 16x16 Section 40
function default.dt_jungle_fork_north_grows_to_16x16_section_40(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 40
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 40",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_40(...)
	end
})

-- Fork South Grows To 16x16 Section 40
function default.dt_jungle_fork_south_grows_to_16x16_section_40(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 40
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 40",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_40(...)
	end
})

-- Fork East Grows To 16x16 Section 40
function default.dt_jungle_fork_east_grows_to_16x16_section_40(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 40
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 40",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_40(...)
	end
})

-- Fork West Grows To 16x16 Section 40
function default.dt_jungle_fork_west_grows_to_16x16_section_40(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 40
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 40",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_40(...)
	end
})

-- Main Trunk Grows To 16x16 Section 41
function default.dt_jungle_main_trunk_grows_to_16x16_section_41(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 41
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 41",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_41(...)
	end
})

-- Fork North Grows To 16x16 Section 41
function default.dt_jungle_fork_north_grows_to_16x16_section_41(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 41
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 41",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_41(...)
	end
})

-- Fork South Grows To 16x16 Section 41
function default.dt_jungle_fork_south_grows_to_16x16_section_41(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 41
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 41",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_41(...)
	end
})

-- Fork East Grows To 16x16 Section 41
function default.dt_jungle_fork_east_grows_to_16x16_section_41(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 41
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 41",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_41(...)
	end
})

-- Fork West Grows To 16x16 Section 41
function default.dt_jungle_fork_west_grows_to_16x16_section_41(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 41
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 41",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_41(...)
	end
})

-- Main Trunk Grows To 16x16 Section 42
function default.dt_jungle_main_trunk_grows_to_16x16_section_42(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 42
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 42",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_42(...)
	end
})

-- Fork North Grows To 16x16 Section 42
function default.dt_jungle_fork_north_grows_to_16x16_section_42(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 42
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 42",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_42(...)
	end
})

-- Fork South Grows To 16x16 Section 42
function default.dt_jungle_fork_south_grows_to_16x16_section_42(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 42
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 42",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_42(...)
	end
})

-- Fork East Grows To 16x16 Section 42
function default.dt_jungle_fork_east_grows_to_16x16_section_42(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 42
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 42",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_42(...)
	end
})

-- Fork West Grows To 16x16 Section 42
function default.dt_jungle_fork_west_grows_to_16x16_section_42(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 42
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 42",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_42(...)
	end
})

-- Main Trunk Grows To 16x16 Section 43
function default.dt_jungle_main_trunk_grows_to_16x16_section_43(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 43
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 43",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_43(...)
	end
})

-- Fork North Grows To 16x16 Section 43
function default.dt_jungle_fork_north_grows_to_16x16_section_43(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 43
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 43",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_43(...)
	end
})

-- Fork South Grows To 16x16 Section 43
function default.dt_jungle_fork_south_grows_to_16x16_section_43(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 43
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 43",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_43(...)
	end
})

-- Fork East Grows To 16x16 Section 43
function default.dt_jungle_fork_east_grows_to_16x16_section_43(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 43
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 43",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_43(...)
	end
})

-- Fork West Grows To 16x16 Section 43
function default.dt_jungle_fork_west_grows_to_16x16_section_43(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 43
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 43",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_43(...)
	end
})

-- Main Trunk Grows To 16x16 Section 44
function default.dt_jungle_main_trunk_grows_to_16x16_section_44(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 44
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 44",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_44(...)
	end
})

-- Fork North Grows To 16x16 Section 44
function default.dt_jungle_fork_north_grows_to_16x16_section_44(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 44
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 44",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_44(...)
	end
})

-- Fork South Grows To 16x16 Section 44
function default.dt_jungle_fork_south_grows_to_16x16_section_44(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 44
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 44",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_44(...)
	end
})

-- Fork East Grows To 16x16 Section 44
function default.dt_jungle_fork_east_grows_to_16x16_section_44(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 44
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 44",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_44(...)
	end
})

-- Fork West Grows To 16x16 Section 44
function default.dt_jungle_fork_west_grows_to_16x16_section_44(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 44
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 44",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_44(...)
	end
})

-- Main Trunk Grows To 16x16 Section 45
function default.dt_jungle_main_trunk_grows_to_16x16_section_45(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 45
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 45",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_45(...)
	end
})

-- Fork North Grows To 16x16 Section 45
function default.dt_jungle_fork_north_grows_to_16x16_section_45(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 45
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 45",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_45(...)
	end
})

-- Fork South Grows To 16x16 Section 45
function default.dt_jungle_fork_south_grows_to_16x16_section_45(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 45
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 45",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_45(...)
	end
})

-- Fork East Grows To 16x16 Section 45
function default.dt_jungle_fork_east_grows_to_16x16_section_45(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 45
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 45",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_45(...)
	end
})

-- Fork West Grows To 16x16 Section 45
function default.dt_jungle_fork_west_grows_to_16x16_section_45(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 45
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 45",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_45(...)
	end
})

-- Main Trunk Grows To 16x16 Section 46
function default.dt_jungle_main_trunk_grows_to_16x16_section_46(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 46
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 46",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_46(...)
	end
})

-- Fork North Grows To 16x16 Section 46
function default.dt_jungle_fork_north_grows_to_16x16_section_46(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 46
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 46",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_46(...)
	end
})

-- Fork South Grows To 16x16 Section 46
function default.dt_jungle_fork_south_grows_to_16x16_section_46(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 46
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 46",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_46(...)
	end
})

-- Fork East Grows To 16x16 Section 46
function default.dt_jungle_fork_east_grows_to_16x16_section_46(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 46
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 46",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_46(...)
	end
})

-- Fork West Grows To 16x16 Section 46
function default.dt_jungle_fork_west_grows_to_16x16_section_46(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 46
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 46",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_46(...)
	end
})

-- Main Trunk Grows To 16x16 Section 47
function default.dt_jungle_main_trunk_grows_to_16x16_section_47(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 47
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 47",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_47(...)
	end
})

-- Fork North Grows To 16x16 Section 47
function default.dt_jungle_fork_north_grows_to_16x16_section_47(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 47
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 47",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_47(...)
	end
})

-- Fork South Grows To 16x16 Section 47
function default.dt_jungle_fork_south_grows_to_16x16_section_47(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 47
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 47",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_47(...)
	end
})

-- Fork East Grows To 16x16 Section 47
function default.dt_jungle_fork_east_grows_to_16x16_section_47(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 47
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 47",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_47(...)
	end
})

-- Fork West Grows To 16x16 Section 47
function default.dt_jungle_fork_west_grows_to_16x16_section_47(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 47
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 47",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_47(...)
	end
})

-- Main Trunk Grows To 16x16 Section 48
function default.dt_jungle_main_trunk_grows_to_16x16_section_48(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 48
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 48",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_48(...)
	end
})

-- Fork North Grows To 16x16 Section 48
function default.dt_jungle_fork_north_grows_to_16x16_section_48(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 48
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 48",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_48(...)
	end
})

-- Fork South Grows To 16x16 Section 48
function default.dt_jungle_fork_south_grows_to_16x16_section_48(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 48
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 48",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_48(...)
	end
})

-- Fork East Grows To 16x16 Section 48
function default.dt_jungle_fork_east_grows_to_16x16_section_48(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 48
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 48",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_48(...)
	end
})

-- Fork West Grows To 16x16 Section 48
function default.dt_jungle_fork_west_grows_to_16x16_section_48(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 48
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 48",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_48(...)
	end
})

-- Main Trunk Grows To 16x16 Section 49
function default.dt_jungle_main_trunk_grows_to_16x16_section_49(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 49
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 49",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_49(...)
	end
})

-- Fork North Grows To 16x16 Section 49
function default.dt_jungle_fork_north_grows_to_16x16_section_49(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 49
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 49",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_49(...)
	end
})

-- Fork South Grows To 16x16 Section 49
function default.dt_jungle_fork_south_grows_to_16x16_section_49(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 49
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 49",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_49(...)
	end
})

-- Fork East Grows To 16x16 Section 49
function default.dt_jungle_fork_east_grows_to_16x16_section_49(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 49
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 49",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_49(...)
	end
})

-- Fork West Grows To 16x16 Section 49
function default.dt_jungle_fork_west_grows_to_16x16_section_49(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 49
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 49",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_49(...)
	end
})

-- Main Trunk Grows To 16x16 Section 50
function default.dt_jungle_main_trunk_grows_to_16x16_section_50(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 50
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 50",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_50(...)
	end
})

-- Fork North Grows To 16x16 Section 50
function default.dt_jungle_fork_north_grows_to_16x16_section_50(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 50
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 50",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_50(...)
	end
})

-- Fork South Grows To 16x16 Section 50
function default.dt_jungle_fork_south_grows_to_16x16_section_50(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 50
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 50",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_50(...)
	end
})

-- Fork East Grows To 16x16 Section 50
function default.dt_jungle_fork_east_grows_to_16x16_section_50(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 50
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 50",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_50(...)
	end
})

-- Fork West Grows To 16x16 Section 50
function default.dt_jungle_fork_west_grows_to_16x16_section_50(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 50
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 50",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_50(...)
	end
})

-- Main Trunk Grows To 16x16 Section 51
function default.dt_jungle_main_trunk_grows_to_16x16_section_51(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 51
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 51",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_51(...)
	end
})

-- Fork North Grows To 16x16 Section 51
function default.dt_jungle_fork_north_grows_to_16x16_section_51(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 51
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 51",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_51(...)
	end
})

-- Fork South Grows To 16x16 Section 51
function default.dt_jungle_fork_south_grows_to_16x16_section_51(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 51
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 51",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_51(...)
	end
})

-- Fork East Grows To 16x16 Section 51
function default.dt_jungle_fork_east_grows_to_16x16_section_51(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 51
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 51",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_51(...)
	end
})

-- Fork West Grows To 16x16 Section 51
function default.dt_jungle_fork_west_grows_to_16x16_section_51(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 51
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 51",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_51(...)
	end
})

-- Main Trunk Grows To 16x16 Section 52
function default.dt_jungle_main_trunk_grows_to_16x16_section_52(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 52
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 52",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_52(...)
	end
})

-- Fork North Grows To 16x16 Section 52
function default.dt_jungle_fork_north_grows_to_16x16_section_52(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 52
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 52",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_52(...)
	end
})

-- Fork South Grows To 16x16 Section 52
function default.dt_jungle_fork_south_grows_to_16x16_section_52(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 52
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 52",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_52(...)
	end
})

-- Fork East Grows To 16x16 Section 52
function default.dt_jungle_fork_east_grows_to_16x16_section_52(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 52
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 52",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_52(...)
	end
})

-- Fork West Grows To 16x16 Section 52
function default.dt_jungle_fork_west_grows_to_16x16_section_52(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 52
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 52",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_52(...)
	end
})

-- Main Trunk Grows To 16x16 Section 53
function default.dt_jungle_main_trunk_grows_to_16x16_section_53(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 53
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 53",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_53(...)
	end
})

-- Fork North Grows To 16x16 Section 53
function default.dt_jungle_fork_north_grows_to_16x16_section_53(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 53
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 53",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_53(...)
	end
})

-- Fork South Grows To 16x16 Section 53
function default.dt_jungle_fork_south_grows_to_16x16_section_53(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 53
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 53",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_53(...)
	end
})

-- Fork East Grows To 16x16 Section 53
function default.dt_jungle_fork_east_grows_to_16x16_section_53(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 53
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 53",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_53(...)
	end
})

-- Fork West Grows To 16x16 Section 53
function default.dt_jungle_fork_west_grows_to_16x16_section_53(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 53
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 53",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_53(...)
	end
})

-- Main Trunk Grows To 16x16 Section 54
function default.dt_jungle_main_trunk_grows_to_16x16_section_54(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 54
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 54",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_54(...)
	end
})

-- Fork North Grows To 16x16 Section 54
function default.dt_jungle_fork_north_grows_to_16x16_section_54(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 54
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 54",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_54(...)
	end
})

-- Fork South Grows To 16x16 Section 54
function default.dt_jungle_fork_south_grows_to_16x16_section_54(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 54
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 54",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_54(...)
	end
})

-- Fork East Grows To 16x16 Section 54
function default.dt_jungle_fork_east_grows_to_16x16_section_54(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 54
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 54",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_54(...)
	end
})

-- Fork West Grows To 16x16 Section 54
function default.dt_jungle_fork_west_grows_to_16x16_section_54(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 54
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 54",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_54(...)
	end
})

-- Main Trunk Grows To 16x16 Section 55
function default.dt_jungle_main_trunk_grows_to_16x16_section_55(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 55
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 55",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_55(...)
	end
})

-- Fork North Grows To 16x16 Section 55
function default.dt_jungle_fork_north_grows_to_16x16_section_55(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 55
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 55",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_55(...)
	end
})

-- Fork South Grows To 16x16 Section 55
function default.dt_jungle_fork_south_grows_to_16x16_section_55(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 55
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 55",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_55(...)
	end
})

-- Fork East Grows To 16x16 Section 55
function default.dt_jungle_fork_east_grows_to_16x16_section_55(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 55
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 55",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_55(...)
	end
})

-- Fork West Grows To 16x16 Section 55
function default.dt_jungle_fork_west_grows_to_16x16_section_55(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 55
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 55",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_55(...)
	end
})

-- Main Trunk Grows To 16x16 Section 56
function default.dt_jungle_main_trunk_grows_to_16x16_section_56(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 56
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 56",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_56(...)
	end
})

-- Fork North Grows To 16x16 Section 56
function default.dt_jungle_fork_north_grows_to_16x16_section_56(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 56
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 56",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_56(...)
	end
})

-- Fork South Grows To 16x16 Section 56
function default.dt_jungle_fork_south_grows_to_16x16_section_56(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 56
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 56",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_56(...)
	end
})

-- Fork East Grows To 16x16 Section 56
function default.dt_jungle_fork_east_grows_to_16x16_section_56(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 56
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 56",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_56(...)
	end
})

-- Fork West Grows To 16x16 Section 56
function default.dt_jungle_fork_west_grows_to_16x16_section_56(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 56
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 56",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_56(...)
	end
})

-- Main Trunk Grows To 16x16 Section 57
function default.dt_jungle_main_trunk_grows_to_16x16_section_57(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 57
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 57",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_57(...)
	end
})

-- Fork North Grows To 16x16 Section 57
function default.dt_jungle_fork_north_grows_to_16x16_section_57(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 57
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 57",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_57(...)
	end
})

-- Fork South Grows To 16x16 Section 57
function default.dt_jungle_fork_south_grows_to_16x16_section_57(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 57
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 57",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_57(...)
	end
})

-- Fork East Grows To 16x16 Section 57
function default.dt_jungle_fork_east_grows_to_16x16_section_57(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 57
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 57",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_57(...)
	end
})

-- Fork West Grows To 16x16 Section 57
function default.dt_jungle_fork_west_grows_to_16x16_section_57(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 57
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 57",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_57(...)
	end
})

-- Main Trunk Grows To 16x16 Section 58
function default.dt_jungle_main_trunk_grows_to_16x16_section_58(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 58
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 58",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_58(...)
	end
})

-- Fork North Grows To 16x16 Section 58
function default.dt_jungle_fork_north_grows_to_16x16_section_58(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 58
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 58",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_58(...)
	end
})

-- Fork South Grows To 16x16 Section 58
function default.dt_jungle_fork_south_grows_to_16x16_section_58(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 58
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 58",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_58(...)
	end
})

-- Fork East Grows To 16x16 Section 58
function default.dt_jungle_fork_east_grows_to_16x16_section_58(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 58
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 58",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_58(...)
	end
})

-- Fork West Grows To 16x16 Section 58
function default.dt_jungle_fork_west_grows_to_16x16_section_58(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 58
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 58",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_58(...)
	end
})

-- Main Trunk Grows To 16x16 Section 59
function default.dt_jungle_main_trunk_grows_to_16x16_section_59(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 59
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 59",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_59(...)
	end
})

-- Fork North Grows To 16x16 Section 59
function default.dt_jungle_fork_north_grows_to_16x16_section_59(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 59
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 59",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_59(...)
	end
})

-- Fork South Grows To 16x16 Section 59
function default.dt_jungle_fork_south_grows_to_16x16_section_59(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 59
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 59",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_59(...)
	end
})

-- Fork East Grows To 16x16 Section 59
function default.dt_jungle_fork_east_grows_to_16x16_section_59(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 59
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 59",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_59(...)
	end
})

-- Fork West Grows To 16x16 Section 59
function default.dt_jungle_fork_west_grows_to_16x16_section_59(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 59
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 59",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_59(...)
	end
})

-- Main Trunk Grows To 16x16 Section 60
function default.dt_jungle_main_trunk_grows_to_16x16_section_60(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 60
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 60",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_60(...)
	end
})

-- Fork North Grows To 16x16 Section 60
function default.dt_jungle_fork_north_grows_to_16x16_section_60(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 60
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 60",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_60(...)
	end
})

-- Fork South Grows To 16x16 Section 60
function default.dt_jungle_fork_south_grows_to_16x16_section_60(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 60
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 60",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_60(...)
	end
})

-- Fork East Grows To 16x16 Section 60
function default.dt_jungle_fork_east_grows_to_16x16_section_60(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 60
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 60",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_60(...)
	end
})

-- Fork West Grows To 16x16 Section 60
function default.dt_jungle_fork_west_grows_to_16x16_section_60(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 60
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 60",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_60(...)
	end
})

-- Main Trunk Grows To 16x16 Section 61
function default.dt_jungle_main_trunk_grows_to_16x16_section_61(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 61
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 61",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_61(...)
	end
})

-- Fork North Grows To 16x16 Section 61
function default.dt_jungle_fork_north_grows_to_16x16_section_61(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 61
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 61",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_61(...)
	end
})

-- Fork South Grows To 16x16 Section 61
function default.dt_jungle_fork_south_grows_to_16x16_section_61(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 61
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 61",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_61(...)
	end
})

-- Fork East Grows To 16x16 Section 61
function default.dt_jungle_fork_east_grows_to_16x16_section_61(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 61
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 61",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_61(...)
	end
})

-- Fork West Grows To 16x16 Section 61
function default.dt_jungle_fork_west_grows_to_16x16_section_61(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 61
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 61",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_61(...)
	end
})

-- Main Trunk Grows To 16x16 Section 62
function default.dt_jungle_main_trunk_grows_to_16x16_section_62(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 62
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 62",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_62(...)
	end
})

-- Fork North Grows To 16x16 Section 62
function default.dt_jungle_fork_north_grows_to_16x16_section_62(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 62
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 62",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_62(...)
	end
})

-- Fork South Grows To 16x16 Section 62
function default.dt_jungle_fork_south_grows_to_16x16_section_62(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 62
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 62",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_62(...)
	end
})

-- Fork East Grows To 16x16 Section 62
function default.dt_jungle_fork_east_grows_to_16x16_section_62(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 62
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 62",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_62(...)
	end
})

-- Fork West Grows To 16x16 Section 62
function default.dt_jungle_fork_west_grows_to_16x16_section_62(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 62
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 62",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_62(...)
	end
})

-- Main Trunk Grows To 16x16 Section 63
function default.dt_jungle_main_trunk_grows_to_16x16_section_63(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 63
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 63",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_63(...)
	end
})

-- Fork North Grows To 16x16 Section 63
function default.dt_jungle_fork_north_grows_to_16x16_section_63(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 63
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 63",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_63(...)
	end
})

-- Fork South Grows To 16x16 Section 63
function default.dt_jungle_fork_south_grows_to_16x16_section_63(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 63
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 63",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_63(...)
	end
})

-- Fork East Grows To 16x16 Section 63
function default.dt_jungle_fork_east_grows_to_16x16_section_63(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 63
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 63",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_63(...)
	end
})

-- Fork West Grows To 16x16 Section 63
function default.dt_jungle_fork_west_grows_to_16x16_section_63(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 63
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 63",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_63(...)
	end
})

-- Main Trunk Grows To 16x16 Section 64
function default.dt_jungle_main_trunk_grows_to_16x16_section_64(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 64
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 64",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_64(...)
	end
})

-- Fork North Grows To 16x16 Section 64
function default.dt_jungle_fork_north_grows_to_16x16_section_64(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 64
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 64",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_64(...)
	end
})

-- Fork South Grows To 16x16 Section 64
function default.dt_jungle_fork_south_grows_to_16x16_section_64(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 64
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 64",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_64(...)
	end
})

-- Fork East Grows To 16x16 Section 64
function default.dt_jungle_fork_east_grows_to_16x16_section_64(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 64
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 64",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_64(...)
	end
})

-- Fork West Grows To 16x16 Section 64
function default.dt_jungle_fork_west_grows_to_16x16_section_64(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 64
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 64",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_64(...)
	end
})

-- Main Trunk Grows To 16x16 Section 65
function default.dt_jungle_main_trunk_grows_to_16x16_section_65(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 65
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 65",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_65(...)
	end
})

-- Fork North Grows To 16x16 Section 65
function default.dt_jungle_fork_north_grows_to_16x16_section_65(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 65
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 65",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_65(...)
	end
})

-- Fork South Grows To 16x16 Section 65
function default.dt_jungle_fork_south_grows_to_16x16_section_65(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 65
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 65",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_65(...)
	end
})

-- Fork East Grows To 16x16 Section 65
function default.dt_jungle_fork_east_grows_to_16x16_section_65(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 65
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 65",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_65(...)
	end
})

-- Fork West Grows To 16x16 Section 65
function default.dt_jungle_fork_west_grows_to_16x16_section_65(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 65
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 65",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_65(...)
	end
})

-- Main Trunk Grows To 16x16 Section 66
function default.dt_jungle_main_trunk_grows_to_16x16_section_66(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 66
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 66",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_66(...)
	end
})

-- Fork North Grows To 16x16 Section 66
function default.dt_jungle_fork_north_grows_to_16x16_section_66(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 66
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 66",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_66(...)
	end
})

-- Fork South Grows To 16x16 Section 66
function default.dt_jungle_fork_south_grows_to_16x16_section_66(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 66
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 66",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_66(...)
	end
})

-- Fork East Grows To 16x16 Section 66
function default.dt_jungle_fork_east_grows_to_16x16_section_66(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 66
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 66",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_66(...)
	end
})

-- Fork West Grows To 16x16 Section 66
function default.dt_jungle_fork_west_grows_to_16x16_section_66(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 66
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 66",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_66(...)
	end
})

-- Main Trunk Grows To 16x16 Section 67
function default.dt_jungle_main_trunk_grows_to_16x16_section_67(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 67
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 67",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_67(...)
	end
})

-- Fork North Grows To 16x16 Section 67
function default.dt_jungle_fork_north_grows_to_16x16_section_67(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 67
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 67",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_67(...)
	end
})

-- Fork South Grows To 16x16 Section 67
function default.dt_jungle_fork_south_grows_to_16x16_section_67(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 67
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 67",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_67(...)
	end
})

-- Fork East Grows To 16x16 Section 67
function default.dt_jungle_fork_east_grows_to_16x16_section_67(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 67
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 67",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_67(...)
	end
})

-- Fork West Grows To 16x16 Section 67
function default.dt_jungle_fork_west_grows_to_16x16_section_67(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 67
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 67",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_67(...)
	end
})

-- Main Trunk Grows To 16x16 Section 68
function default.dt_jungle_main_trunk_grows_to_16x16_section_68(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 68
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 68",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_68(...)
	end
})

-- Fork North Grows To 16x16 Section 68
function default.dt_jungle_fork_north_grows_to_16x16_section_68(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 68
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 68",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_68(...)
	end
})

-- Fork South Grows To 16x16 Section 68
function default.dt_jungle_fork_south_grows_to_16x16_section_68(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 68
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 68",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_68(...)
	end
})

-- Fork East Grows To 16x16 Section 68
function default.dt_jungle_fork_east_grows_to_16x16_section_68(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 68
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 68",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_68(...)
	end
})

-- Fork West Grows To 16x16 Section 68
function default.dt_jungle_fork_west_grows_to_16x16_section_68(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 68
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 68",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_68(...)
	end
})

-- Main Trunk Grows To 16x16 Section 69
function default.dt_jungle_main_trunk_grows_to_16x16_section_69(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 69
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 69",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_69(...)
	end
})

-- Fork North Grows To 16x16 Section 69
function default.dt_jungle_fork_north_grows_to_16x16_section_69(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 69
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 69",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_69(...)
	end
})

-- Fork South Grows To 16x16 Section 69
function default.dt_jungle_fork_south_grows_to_16x16_section_69(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 69
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 69",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_69(...)
	end
})

-- Fork East Grows To 16x16 Section 69
function default.dt_jungle_fork_east_grows_to_16x16_section_69(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 69
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 69",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_69(...)
	end
})

-- Fork West Grows To 16x16 Section 69
function default.dt_jungle_fork_west_grows_to_16x16_section_69(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 69
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 69",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_69(...)
	end
})

-- Main Trunk Grows To 16x16 Section 70
function default.dt_jungle_main_trunk_grows_to_16x16_section_70(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 70
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 70",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_70(...)
	end
})

-- Fork North Grows To 16x16 Section 70
function default.dt_jungle_fork_north_grows_to_16x16_section_70(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 70
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 70",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_70(...)
	end
})

-- Fork South Grows To 16x16 Section 70
function default.dt_jungle_fork_south_grows_to_16x16_section_70(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 70
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 70",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_70(...)
	end
})

-- Fork East Grows To 16x16 Section 70
function default.dt_jungle_fork_east_grows_to_16x16_section_70(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 70
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 70",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_70(...)
	end
})

-- Fork West Grows To 16x16 Section 70
function default.dt_jungle_fork_west_grows_to_16x16_section_70(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 70
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 70",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_70(...)
	end
})

-- Main Trunk Grows To 16x16 Section 71
function default.dt_jungle_main_trunk_grows_to_16x16_section_71(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 71
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 71",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_71(...)
	end
})

-- Fork North Grows To 16x16 Section 71
function default.dt_jungle_fork_north_grows_to_16x16_section_71(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 71
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 71",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_71(...)
	end
})

-- Fork South Grows To 16x16 Section 71
function default.dt_jungle_fork_south_grows_to_16x16_section_71(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 71
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 71",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_71(...)
	end
})

-- Fork East Grows To 16x16 Section 71
function default.dt_jungle_fork_east_grows_to_16x16_section_71(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 71
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 71",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_71(...)
	end
})

-- Fork West Grows To 16x16 Section 71
function default.dt_jungle_fork_west_grows_to_16x16_section_71(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 71
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 71",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_71(...)
	end
})

-- Main Trunk Grows To 16x16 Section 72
function default.dt_jungle_main_trunk_grows_to_16x16_section_72(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 72
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 72",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_72(...)
	end
})

-- Fork North Grows To 16x16 Section 72
function default.dt_jungle_fork_north_grows_to_16x16_section_72(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 72
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 72",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_72(...)
	end
})

-- Fork South Grows To 16x16 Section 72
function default.dt_jungle_fork_south_grows_to_16x16_section_72(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 72
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 72",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_72(...)
	end
})

-- Fork East Grows To 16x16 Section 72
function default.dt_jungle_fork_east_grows_to_16x16_section_72(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 72
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 72",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_72(...)
	end
})

-- Fork West Grows To 16x16 Section 72
function default.dt_jungle_fork_west_grows_to_16x16_section_72(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 72
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 72",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_72(...)
	end
})

-- Main Trunk Grows To 16x16 Section 73
function default.dt_jungle_main_trunk_grows_to_16x16_section_73(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 73
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 73",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_73(...)
	end
})

-- Fork North Grows To 16x16 Section 73
function default.dt_jungle_fork_north_grows_to_16x16_section_73(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 73
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 73",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_73(...)
	end
})

-- Fork South Grows To 16x16 Section 73
function default.dt_jungle_fork_south_grows_to_16x16_section_73(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 73
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 73",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_73(...)
	end
})

-- Fork East Grows To 16x16 Section 73
function default.dt_jungle_fork_east_grows_to_16x16_section_73(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 73
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 73",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_73(...)
	end
})

-- Fork West Grows To 16x16 Section 73
function default.dt_jungle_fork_west_grows_to_16x16_section_73(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 73
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 73",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_73(...)
	end
})

-- Main Trunk Grows To 16x16 Section 74
function default.dt_jungle_main_trunk_grows_to_16x16_section_74(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 74
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 74",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_74(...)
	end
})

-- Fork North Grows To 16x16 Section 74
function default.dt_jungle_fork_north_grows_to_16x16_section_74(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 74
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 74",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_74(...)
	end
})

-- Fork South Grows To 16x16 Section 74
function default.dt_jungle_fork_south_grows_to_16x16_section_74(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 74
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 74",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_74(...)
	end
})

-- Fork East Grows To 16x16 Section 74
function default.dt_jungle_fork_east_grows_to_16x16_section_74(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 74
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 74",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_74(...)
	end
})

-- Fork West Grows To 16x16 Section 74
function default.dt_jungle_fork_west_grows_to_16x16_section_74(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 74
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 74",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_74(...)
	end
})

-- Main Trunk Grows To 16x16 Section 75
function default.dt_jungle_main_trunk_grows_to_16x16_section_75(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 75
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 75",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_75(...)
	end
})

-- Fork North Grows To 16x16 Section 75
function default.dt_jungle_fork_north_grows_to_16x16_section_75(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 75
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 75",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_75(...)
	end
})

-- Fork South Grows To 16x16 Section 75
function default.dt_jungle_fork_south_grows_to_16x16_section_75(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 75
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 75",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_75(...)
	end
})

-- Fork East Grows To 16x16 Section 75
function default.dt_jungle_fork_east_grows_to_16x16_section_75(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 75
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 75",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_75(...)
	end
})

-- Fork West Grows To 16x16 Section 75
function default.dt_jungle_fork_west_grows_to_16x16_section_75(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 75
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 75",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_75(...)
	end
})

-- Main Trunk Grows To 16x16 Section 76
function default.dt_jungle_main_trunk_grows_to_16x16_section_76(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 76
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 76",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_76(...)
	end
})

-- Fork North Grows To 16x16 Section 76
function default.dt_jungle_fork_north_grows_to_16x16_section_76(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 76
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 76",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_76(...)
	end
})

-- Fork South Grows To 16x16 Section 76
function default.dt_jungle_fork_south_grows_to_16x16_section_76(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 76
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 76",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_76(...)
	end
})

-- Fork East Grows To 16x16 Section 76
function default.dt_jungle_fork_east_grows_to_16x16_section_76(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 76
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 76",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_76(...)
	end
})

-- Fork West Grows To 16x16 Section 76
function default.dt_jungle_fork_west_grows_to_16x16_section_76(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 76
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 76",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_76(...)
	end
})

-- Main Trunk Grows To 16x16 Section 77
function default.dt_jungle_main_trunk_grows_to_16x16_section_77(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 77
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 77",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_77(...)
	end
})

-- Fork North Grows To 16x16 Section 77
function default.dt_jungle_fork_north_grows_to_16x16_section_77(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 77
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 77",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_77(...)
	end
})

-- Fork South Grows To 16x16 Section 77
function default.dt_jungle_fork_south_grows_to_16x16_section_77(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 77
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 77",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_77(...)
	end
})

-- Fork East Grows To 16x16 Section 77
function default.dt_jungle_fork_east_grows_to_16x16_section_77(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 77
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 77",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_77(...)
	end
})

-- Fork West Grows To 16x16 Section 77
function default.dt_jungle_fork_west_grows_to_16x16_section_77(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 77
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 77",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_77(...)
	end
})

-- Main Trunk Grows To 16x16 Section 78
function default.dt_jungle_main_trunk_grows_to_16x16_section_78(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 78
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 78",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_78(...)
	end
})

-- Fork North Grows To 16x16 Section 78
function default.dt_jungle_fork_north_grows_to_16x16_section_78(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 78
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 78",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_78(...)
	end
})

-- Fork South Grows To 16x16 Section 78
function default.dt_jungle_fork_south_grows_to_16x16_section_78(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 78
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 78",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_78(...)
	end
})

-- Fork East Grows To 16x16 Section 78
function default.dt_jungle_fork_east_grows_to_16x16_section_78(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 78
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 78",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_78(...)
	end
})

-- Fork West Grows To 16x16 Section 78
function default.dt_jungle_fork_west_grows_to_16x16_section_78(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 78
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 78",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_78(...)
	end
})

-- Main Trunk Grows To 16x16 Section 79
function default.dt_jungle_main_trunk_grows_to_16x16_section_79(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 79
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 79",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_79(...)
	end
})

-- Fork North Grows To 16x16 Section 79
function default.dt_jungle_fork_north_grows_to_16x16_section_79(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 79
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 79",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_79(...)
	end
})

-- Fork South Grows To 16x16 Section 79
function default.dt_jungle_fork_south_grows_to_16x16_section_79(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 79
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 79",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_79(...)
	end
})

-- Fork East Grows To 16x16 Section 79
function default.dt_jungle_fork_east_grows_to_16x16_section_79(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 79
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 79",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_79(...)
	end
})

-- Fork West Grows To 16x16 Section 79
function default.dt_jungle_fork_west_grows_to_16x16_section_79(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 79
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 79",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_79(...)
	end
})

-- Main Trunk Grows To 16x16 Section 80
function default.dt_jungle_main_trunk_grows_to_16x16_section_80(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 80
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 16x16 Section 80",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_16x16_section_80(...)
	end
})

-- Fork North Grows To 16x16 Section 80
function default.dt_jungle_fork_north_grows_to_16x16_section_80(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 80
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 16x16 Section 80",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_16x16_section_80(...)
	end
})

-- Fork South Grows To 16x16 Section 80
function default.dt_jungle_fork_south_grows_to_16x16_section_80(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 80
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 16x16 Section 80",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_16x16_section_80(...)
	end
})

-- Fork East Grows To 16x16 Section 80
function default.dt_jungle_fork_east_grows_to_16x16_section_80(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 80
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 16x16 Section 80",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_16x16_section_80(...)
	end
})

-- Fork West Grows To 16x16 Section 80
function default.dt_jungle_fork_west_grows_to_16x16_section_80(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 80
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 16x16 Section 80",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_16x16_section_80(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Tree Base
-- Main Trunk Grows To 14x14
function default.dt_jungle_main_trunk_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14(...)
	end
})

-- Fork North Grows To 14x14
function default.dt_jungle_fork_north_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_14x14(...)
	end
})

-- Fork South Grows To 14x14
function default.dt_jungle_fork_south_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_14x14(...)
	end
})

-- Fork East Grows To 14x14
function default.dt_jungle_fork_east_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_14x14(...)
	end
})

-- Fork West Grows To 14x14
function default.dt_jungle_fork_west_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 14x14",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_14x14(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Tree Base
-- Main Trunk Grows To 12x12 From Base
function default.dt_jungle_main_trunk_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_base(...)
	end
})

-- Fork North Grows To 12x12 From Base
function default.dt_jungle_fork_north_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_12x12_from_base(...)
	end
})

-- Fork South Grows To 12x12 From Base
function default.dt_jungle_fork_south_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_12x12_from_base(...)
	end
})

-- Fork East Grows To 12x12 From Base
function default.dt_jungle_fork_east_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_12x12_from_base(...)
	end
})

-- Fork West Grows To 12x12 From Base
function default.dt_jungle_fork_west_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 12x12",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_12x12_from_base(...)
	end
})

-- This Is Where The Main Trunk 12x12 Nodes Grow To 14x14 From The Main Trunk
-- Main Trunk Grows To 14x14 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork North Grows To 14x14 From Main Trunk
function default.dt_jungle_fork_north_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork South Grows To 14x14 From Main Trunk
function default.dt_jungle_fork_south_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork East Grows To 14x14 From Main Trunk
function default.dt_jungle_fork_east_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork West Grows To 14x14 From Main Trunk
function default.dt_jungle_fork_west_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_14x14_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork North
-- Main Trunk Grows To 14x14 From Fork North
function default.dt_jungle_main_trunk_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork South Grows To 14x14 From Fork North
function default.dt_jungle_fork_south_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork East Grows To 14x14 From Fork North
function default.dt_jungle_fork_east_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork West Grows To 14x14 From Fork North
function default.dt_jungle_fork_west_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_14x14_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork South
-- Main Trunk Grows To 14x14 From Fork South
function default.dt_jungle_main_trunk_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork North Grows To 14x14 From Fork South
function default.dt_jungle_fork_north_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork East Grows To 14x14 From Fork South
function default.dt_jungle_fork_east_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork West Grows To 14x14 From Fork South
function default.dt_jungle_fork_west_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_14x14_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork East
-- Main Trunk Grows To 14x14 From Fork East
function default.dt_jungle_main_trunk_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork North Grows To 14x14 From Fork East
function default.dt_jungle_fork_north_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork South Grows To 14x14 From Fork East
function default.dt_jungle_fork_south_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork West Grows To 14x14 From Fork East
function default.dt_jungle_fork_west_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_14x14_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork West
-- Main Trunk Grows To 14x14 From Fork West
function default.dt_jungle_main_trunk_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork North Grows To 14x14 From Fork West
function default.dt_jungle_fork_north_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork South Grows To 14x14 From Fork West
function default.dt_jungle_fork_south_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork East Grows To 14x14 From Fork West
function default.dt_jungle_fork_east_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_14x14_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Main Trunk
-- Main Trunk Grows To 12x12 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork North Grows To 12x12 From Main Trunk
function default.dt_jungle_fork_north_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork South Grows To 12x12 From Main Trunk
function default.dt_jungle_fork_south_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork East Grows To 12x12 From Main Trunk
function default.dt_jungle_fork_east_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork West Grows To 12x12 From Main Trunk
function default.dt_jungle_fork_west_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_12x12_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork North
-- Main Trunk Grows To 12x12 From Fork North
function default.dt_jungle_main_trunk_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork South Grows To 12x12 From Fork North
function default.dt_jungle_fork_south_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork East Grows To 12x12 From Fork North
function default.dt_jungle_fork_east_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork West Grows To 12x12 From Fork North
function default.dt_jungle_fork_west_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_12x12_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork South
-- Main Trunk Grows To 12x12 From Fork South
function default.dt_jungle_main_trunk_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork North Grows To 12x12 From Fork South
function default.dt_jungle_fork_north_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork East Grows To 12x12 From Fork South
function default.dt_jungle_fork_east_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork West Grows To 12x12 From Fork South
function default.dt_jungle_fork_west_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_12x12_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork East
-- Main Trunk Grows To 12x12 From Fork East
function default.dt_jungle_main_trunk_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork North Grows To 12x12 From Fork East
function default.dt_jungle_fork_north_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork South Grows To 12x12 From Fork East
function default.dt_jungle_fork_south_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork West Grows To 12x12 From Fork East
function default.dt_jungle_fork_west_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_12x12_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork West
-- Main Trunk Grows To 12x12 From Fork West
function default.dt_jungle_main_trunk_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork North Grows To 12x12 From Fork West
function default.dt_jungle_fork_north_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork South Grows To 12x12 From Fork West
function default.dt_jungle_fork_south_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork East Grows To 12x12 From Fork West
function default.dt_jungle_fork_east_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_12x12_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Base
-- Main Trunk Grows To 10x10 From Base
function default.dt_jungle_main_trunk_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_base(...)
	end
})

-- Fork North Grows To 10x10 From Base
function default.dt_jungle_fork_north_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_base(...)
	end
})

-- Fork South Grows To 10x10 From Base
function default.dt_jungle_fork_south_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_base(...)
	end
})

-- Fork East Grows To 10x10 From Base
function default.dt_jungle_fork_east_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_base(...)
	end
})

-- Fork West Grows To 10x10 From Base
function default.dt_jungle_fork_west_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Main Trunk
-- Main Trunk Grows To 10x10 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork North Grows To 10x10 From Main Trunk
function default.dt_jungle_fork_north_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork South Grows To 10x10 From Main Trunk
function default.dt_jungle_fork_south_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork East Grows To 10x10 From Main Trunk
function default.dt_jungle_fork_east_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork West Grows To 10x10 From Main Trunk
function default.dt_jungle_fork_west_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork North
-- Main Trunk Grows To 10x10 From Fork North
function default.dt_jungle_main_trunk_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork South Grows To 10x10 From Fork North
function default.dt_jungle_fork_south_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork East Grows To 10x10 From Fork North
function default.dt_jungle_fork_east_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork West Grows To 10x10 From Fork North
function default.dt_jungle_fork_west_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork South
-- Main Trunk Grows To 10x10 From Fork South
function default.dt_jungle_main_trunk_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork North Grows To 10x10 From Fork South
function default.dt_jungle_fork_north_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork East Grows To 10x10 From Fork South
function default.dt_jungle_fork_east_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork West Grows To 10x10 From Fork South
function default.dt_jungle_fork_west_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork East
-- Main Trunk Grows To 10x10 From Fork East
function default.dt_jungle_main_trunk_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork North Grows To 10x10 From Fork East
function default.dt_jungle_fork_north_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork South Grows To 10x10 From Fork East
function default.dt_jungle_fork_south_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork West Grows To 10x10 From Fork East
function default.dt_jungle_fork_west_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork West
-- Main Trunk Grows To 10x10 From Fork West
function default.dt_jungle_main_trunk_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork North Grows To 10x10 From Fork West
function default.dt_jungle_fork_north_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork South Grows To 10x10 From Fork West
function default.dt_jungle_fork_south_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork East Grows To 10x10 From Fork West
function default.dt_jungle_fork_east_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Base
-- Main Trunk Grows To 8x8 From Base
function default.dt_jungle_main_trunk_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_base(...)
	end
})

-- Fork North Grows To 8x8 From Base
function default.dt_jungle_fork_north_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_base(...)
	end
})

-- Fork South Grows To 8x8 From Base
function default.dt_jungle_fork_south_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_base(...)
	end
})

-- Fork East Grows To 8x8 From Base
function default.dt_jungle_fork_east_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_base(...)
	end
})

-- Fork West Grows To 8x8 From Base
function default.dt_jungle_fork_west_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Main Trunk
-- Main Trunk Grows To 8x8 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork North Grows To 8x8 From Main Trunk
function default.dt_jungle_fork_north_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork South Grows To 8x8 From Main Trunk
function default.dt_jungle_fork_south_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork East Grows To 8x8 From Main Trunk
function default.dt_jungle_fork_east_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork West Grows To 8x8 From Main Trunk
function default.dt_jungle_fork_west_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork North
-- Main Trunk Grows To 8x8 From Fork North
function default.dt_jungle_main_trunk_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork South Grows To 8x8 From Fork North
function default.dt_jungle_fork_south_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork East Grows To 8x8 From Fork North
function default.dt_jungle_fork_east_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork West Grows To 8x8 From Fork North
function default.dt_jungle_fork_west_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork South
-- Main Trunk Grows To 8x8 From Fork South
function default.dt_jungle_main_trunk_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork North Grows To 8x8 From Fork South
function default.dt_jungle_fork_north_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork East Grows To 8x8 From Fork South
function default.dt_jungle_fork_east_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork West Grows To 8x8 From Fork South
function default.dt_jungle_fork_west_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork East
-- Main Trunk Grows To 8x8 From Fork East
function default.dt_jungle_main_trunk_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork North Grows To 8x8 From Fork East
function default.dt_jungle_fork_north_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork South Grows To 8x8 From Fork East
function default.dt_jungle_fork_south_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork West Grows To 8x8 From Fork East
function default.dt_jungle_fork_west_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork West
-- Main Trunk Grows To 8x8 From Fork West
function default.dt_jungle_main_trunk_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork North Grows To 8x8 From Fork West
function default.dt_jungle_fork_north_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork South Grows To 8x8 From Fork West
function default.dt_jungle_fork_south_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork East Grows To 8x8 From Fork West
function default.dt_jungle_fork_east_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Base
-- Main Trunk Grows To 6x6 From Base
function default.dt_jungle_main_trunk_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_base(...)
	end
})

-- Fork North Grows To 6x6 From Base
function default.dt_jungle_fork_north_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_base(...)
	end
})

-- Fork South Grows To 6x6 From Base
function default.dt_jungle_fork_south_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_base(...)
	end
})

-- Fork East Grows To 6x6 From Base
function default.dt_jungle_fork_east_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_base(...)
	end
})

-- Fork West Grows To 6x6 From Base
function default.dt_jungle_fork_west_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Main Trunk
-- Main Trunk Grows To 6x6 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork North Grows To 6x6 From Main Trunk
function default.dt_jungle_fork_north_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork South Grows To 6x6 From Main Trunk
function default.dt_jungle_fork_south_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork East Grows To 6x6 From Main Trunk
function default.dt_jungle_fork_east_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork West Grows To 6x6 From Main Trunk
function default.dt_jungle_fork_west_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork North
-- Main Trunk Grows To 6x6 From Fork North
function default.dt_jungle_main_trunk_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork South Grows To 6x6 From Fork North
function default.dt_jungle_fork_south_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork East Grows To 6x6 From Fork North
function default.dt_jungle_fork_east_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork West Grows To 6x6 From Fork North
function default.dt_jungle_fork_west_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork South
-- Main Trunk Grows To 6x6 From Fork South
function default.dt_jungle_main_trunk_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork North Grows To 6x6 From Fork South
function default.dt_jungle_fork_north_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork East Grows To 6x6 From Fork South
function default.dt_jungle_fork_east_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork West Grows To 6x6 From Fork South
function default.dt_jungle_fork_west_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork East
-- Main Trunk Grows To 6x6 From Fork East
function default.dt_jungle_main_trunk_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork North Grows To 6x6 From Fork East
function default.dt_jungle_fork_north_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork South Grows To 6x6 From Fork East
function default.dt_jungle_fork_south_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork West Grows To 6x6 From Fork East
function default.dt_jungle_fork_west_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork West
-- Main Trunk Grows To 6x6 From Fork West
function default.dt_jungle_main_trunk_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork North Grows To 6x6 From Fork West
function default.dt_jungle_fork_north_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork South Grows To 6x6 From Fork West
function default.dt_jungle_fork_south_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork East Grows To 6x6 From Fork West
function default.dt_jungle_fork_east_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Base
-- Main Trunk Grows To 4x4 From Base
function default.dt_jungle_main_trunk_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_base(...)
	end
})

-- Fork North Grows To 4x4 From Base
function default.dt_jungle_fork_north_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_base(...)
	end
})

-- Fork South Grows To 4x4 From Base
function default.dt_jungle_fork_south_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_base(...)
	end
})

-- Fork East Grows To 4x4 From Base
function default.dt_jungle_fork_east_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_base(...)
	end
})

-- Fork West Grows To 4x4 From Base
function default.dt_jungle_fork_west_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Main Trunk
-- Main Trunk Grows To 4x4 From Main Trunk
function default.dt_jungle_main_trunk_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork North Grows To 4x4 From Main Trunk
function default.dt_jungle_fork_north_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork South Grows To 4x4 From Main Trunk
function default.dt_jungle_fork_south_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork East Grows To 4x4 From Main Trunk
function default.dt_jungle_fork_east_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork West Grows To 4x4 From Main Trunk
function default.dt_jungle_fork_west_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork North
-- Main Trunk Grows To 4x4 From Fork North
function default.dt_jungle_main_trunk_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork South Grows To 4x4 From Fork North
function default.dt_jungle_fork_south_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork East Grows To 4x4 From Fork North
function default.dt_jungle_fork_east_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork West Grows To 4x4 From Fork North
function default.dt_jungle_fork_west_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork South
-- Main Trunk Grows To 4x4 From Fork South
function default.dt_jungle_main_trunk_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork North Grows To 4x4 From Fork South
function default.dt_jungle_fork_north_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork East Grows To 4x4 From Fork South
function default.dt_jungle_fork_east_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork West Grows To 4x4 From Fork South
function default.dt_jungle_fork_west_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork East
-- Main Trunk Grows To 4x4 From Fork East
function default.dt_jungle_main_trunk_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork North Grows To 4x4 From Fork East
function default.dt_jungle_fork_north_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork South Grows To 4x4 From Fork East
function default.dt_jungle_fork_south_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork West Grows To 4x4 From Fork East
function default.dt_jungle_fork_west_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork West
-- Main Trunk Grows To 4x4 From Fork West
function default.dt_jungle_main_trunk_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork North Grows To 4x4 From Fork West
function default.dt_jungle_fork_north_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork South Grows To 4x4 From Fork West
function default.dt_jungle_fork_south_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork East Grows To 4x4 From Fork West
function default.dt_jungle_fork_east_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_fork_west(...)
	end
})

-- North Facing Node Placement
-- Fork North 4x4 Grows 2x2 Elbow North
function default.dt_jungle_fork_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Bend North
function default.dt_jungle_elbow_north_4x4_grows_2x2_bend_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Bend North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_bend_north(...)
	end
})

-- Bend North 4x4 Grows 2x2 Elbow North
function default.dt_jungle_bend_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- South Facing Node Placement
-- Fork South 4x4 Grows 2x2 Elbow South
function default.dt_jungle_fork_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Bend South
function default.dt_jungle_elbow_south_4x4_grows_2x2_bend_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Bend South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_bend_south(...)
	end
})

-- Bend South 4x4 Grows 2x2 Elbow South
function default.dt_jungle_bend_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- East Facing Node Placement
-- Fork East 4x4 Grows 2x2 Elbow East
function default.dt_jungle_fork_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Bend East
function default.dt_jungle_elbow_east_4x4_grows_2x2_bend_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Bend East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_bend_east(...)
	end
})

-- Bend East 4x4 Grows 2x2 Elbow East
function default.dt_jungle_bend_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- West Facing Node Placement
-- Fork West 4x4 Grows 2x2 Elbow West
function default.dt_jungle_fork_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Bend West
function default.dt_jungle_elbow_west_4x4_grows_2x2_bend_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Bend West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_bend_west(...)
	end
})

-- Bend West 4x4 Grows 2x2 Elbow West
function default.dt_jungle_bend_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 14x14 From Fork North
function default.dt_jungle_elbow_north_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_14x14_from_fork_north(...)
	end
})

-- Elbow North Grows To 12x12 From Fork North
function default.dt_jungle_elbow_north_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_12x12_from_fork_north(...)
	end
})

-- Elbow North Grows To 10x10 From Fork North
function default.dt_jungle_elbow_north_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_10x10_from_fork_north(...)
	end
})

-- Elbow North Grows To 8x8 From Fork North
function default.dt_jungle_elbow_north_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_8x8_from_fork_north(...)
	end
})

-- Elbow North Grows To 6x6 From Fork North
function default.dt_jungle_elbow_north_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_6x6_from_fork_north(...)
	end
})

-- Elbow North Grows To 4x4 From Fork North
function default.dt_jungle_elbow_north_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_4x4_from_fork_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 14x14 From Fork South
function default.dt_jungle_elbow_south_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_14x14_from_fork_south(...)
	end
})

-- Elbow South Grows To 12x12 From Fork South
function default.dt_jungle_elbow_south_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_12x12_from_fork_south(...)
	end
})

-- Elbow South Grows To 10x10 From Fork South
function default.dt_jungle_elbow_south_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_10x10_from_fork_south(...)
	end
})

-- Elbow South Grows To 8x8 From Fork South
function default.dt_jungle_elbow_south_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_8x8_from_fork_south(...)
	end
})

-- Elbow South Grows To 6x6 From Fork South
function default.dt_jungle_elbow_south_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_6x6_from_fork_south(...)
	end
})

-- Elbow South Grows To 4x4 From Fork South
function default.dt_jungle_elbow_south_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_4x4_from_fork_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 14x14 From Fork East
function default.dt_jungle_elbow_east_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_14x14_from_fork_east(...)
	end
})

-- Elbow East Grows To 12x12 From Fork East
function default.dt_jungle_elbow_east_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_12x12_from_fork_east(...)
	end
})

-- Elbow East Grows To 10x10 From Fork East
function default.dt_jungle_elbow_east_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_10x10_from_fork_east(...)
	end
})

-- Elbow East Grows To 8x8 From Fork East
function default.dt_jungle_elbow_east_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_8x8_from_fork_east(...)
	end
})

-- Elbow East Grows To 6x6 From Fork East
function default.dt_jungle_elbow_east_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_6x6_from_fork_east(...)
	end
})

-- Elbow East Grows To 4x4 From Fork East
function default.dt_jungle_elbow_east_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_4x4_from_fork_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 14x14 From Fork West
function default.dt_jungle_elbow_west_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_14x14_from_fork_west(...)
	end
})

-- Elbow West Grows To 12x12 From Fork West
function default.dt_jungle_elbow_west_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_12x12_from_fork_west(...)
	end
})

-- Elbow West Grows To 10x10 From Fork West
function default.dt_jungle_elbow_west_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_10x10_from_fork_west(...)
	end
})

-- Elbow West Grows To 8x8 From Fork West
function default.dt_jungle_elbow_west_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_8x8_from_fork_west(...)
	end
})

-- Elbow West Grows To 6x6 From Fork West
function default.dt_jungle_elbow_west_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_6x6_from_fork_west(...)
	end
})

-- Elbow West Grows To 4x4 From Fork West
function default.dt_jungle_elbow_west_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_4x4_from_fork_west(...)
	end
})

-- North Bend Growth
-- Bend North Grows To 12x12 From Elbow North
function default.dt_jungle_bend_north_grows_to_12x12_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North Grows To 12x12 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_bend_north_grows_to_12x12_from_elbow_north(...)
	end
})

-- Bend North Grows To 10x10 From Elbow North
function default.dt_jungle_bend_north_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_bend_north_grows_to_10x10_from_elbow_north(...)
	end
})

-- Bend North Grows To 8x8 From Elbow North
function default.dt_jungle_bend_north_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_bend_north_grows_to_8x8_from_elbow_north(...)
	end
})

-- Bend North Grows To 6x6 From Elbow North
function default.dt_jungle_bend_north_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_bend_north_grows_to_6x6_from_elbow_north(...)
	end
})

-- Bend North Grows To 4x4 From Elbow North
function default.dt_jungle_bend_north_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend North Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_north_grows_to_4x4_from_elbow_north(...)
	end
})

-- South Bend Growth
-- Bend South Grows To 12x12 From Elbow South
function default.dt_jungle_bend_south_grows_to_12x12_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South Grows To 12x12 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_bend_south_grows_to_12x12_from_elbow_south(...)
	end
})

-- Bend South Grows To 10x10 From Elbow South
function default.dt_jungle_bend_south_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_bend_south_grows_to_10x10_from_elbow_south(...)
	end
})

-- Bend South Grows To 8x8 From Elbow South
function default.dt_jungle_bend_south_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_bend_south_grows_to_8x8_from_elbow_south(...)
	end
})

-- Bend South Grows To 6x6 From Elbow South
function default.dt_jungle_bend_south_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_bend_south_grows_to_6x6_from_elbow_south(...)
	end
})

-- Bend South Grows To 4x4 From Elbow South
function default.dt_jungle_bend_south_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend South Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_south_grows_to_4x4_from_elbow_south(...)
	end
})

-- East Bend Growth
-- Bend East Grows To 12x12 From Elbow East
function default.dt_jungle_bend_east_grows_to_12x12_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East Grows To 12x12 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_bend_east_grows_to_12x12_from_elbow_east(...)
	end
})

-- Bend East Grows To 10x10 From Elbow East
function default.dt_jungle_bend_east_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_bend_east_grows_to_10x10_from_elbow_east(...)
	end
})

-- Bend East Grows To 8x8 From Elbow East
function default.dt_jungle_bend_east_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_bend_east_grows_to_8x8_from_elbow_east(...)
	end
})

-- Bend East Grows To 6x6 From Elbow East
function default.dt_jungle_bend_east_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_bend_east_grows_to_6x6_from_elbow_east(...)
	end
})

-- Bend East Grows To 4x4 From Elbow East
function default.dt_jungle_bend_east_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend East Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_east_grows_to_4x4_from_elbow_east(...)
	end
})

-- West Bend Growth
-- Bend West Grows To 12x12 From Elbow West
function default.dt_jungle_bend_west_grows_to_12x12_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West Grows To 12x12 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_bend_west_grows_to_12x12_from_elbow_west(...)
	end
})

-- Bend West Grows To 10x10 From Elbow West
function default.dt_jungle_bend_west_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_bend_west_grows_to_10x10_from_elbow_west(...)
	end
})

-- Bend West Grows To 8x8 From Elbow West
function default.dt_jungle_bend_west_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_bend_west_grows_to_8x8_from_elbow_west(...)
	end
})

-- Bend West Grows To 6x6 From Elbow West
function default.dt_jungle_bend_west_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_bend_west_grows_to_6x6_from_elbow_west(...)
	end
})

-- Bend West Grows To 4x4 From Elbow West
function default.dt_jungle_bend_west_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_bend_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_bend_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Bend West Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_bend_west_grows_to_4x4_from_elbow_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 10x10 From Bend North
function default.dt_jungle_elbow_north_grows_to_10x10_from_bend_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 10x10 From Bend North",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_10x10_from_bend_north(...)
	end
})

-- Elbow North Grows To 8x8 From Bend North
function default.dt_jungle_elbow_north_grows_to_8x8_from_bend_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 8x8 From Bend North",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_8x8_from_bend_north(...)
	end
})

-- Elbow North Grows To 6x6 From Bend North
function default.dt_jungle_elbow_north_grows_to_6x6_from_bend_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 6x6 From Bend North",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_6x6_from_bend_north(...)
	end
})

-- Elbow North Grows To 4x4 From Bend North
function default.dt_jungle_elbow_north_grows_to_4x4_from_bend_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 4x4 From Bend North",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_4x4_from_bend_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 10x10 From Bend South
function default.dt_jungle_elbow_south_grows_to_10x10_from_bend_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 10x10 From Bend South",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_10x10_from_bend_south(...)
	end
})

-- Elbow South Grows To 8x8 From Bend South
function default.dt_jungle_elbow_south_grows_to_8x8_from_bend_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 8x8 From Bend South",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_8x8_from_bend_south(...)
	end
})

-- Elbow South Grows To 6x6 From Bend South
function default.dt_jungle_elbow_south_grows_to_6x6_from_bend_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 6x6 From Bend South",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_6x6_from_bend_south(...)
	end
})

-- Elbow South Grows To 4x4 From Bend South
function default.dt_jungle_elbow_south_grows_to_4x4_from_bend_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 4x4 From Bend South",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_4x4_from_bend_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 10x10 From Bend East
function default.dt_jungle_elbow_east_grows_to_10x10_from_bend_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 10x10 From Bend East",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_10x10_from_bend_east(...)
	end
})

-- Elbow East Grows To 8x8 From Bend East
function default.dt_jungle_elbow_east_grows_to_8x8_from_bend_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 8x8 From Bend East",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_8x8_from_bend_east(...)
	end
})

-- Elbow East Grows To 6x6 From Bend East
function default.dt_jungle_elbow_east_grows_to_6x6_from_bend_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 6x6 From Bend East",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_6x6_from_bend_east(...)
	end
})

-- Elbow East Grows To 4x4 From Bend East
function default.dt_jungle_elbow_east_grows_to_4x4_from_bend_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 4x4 From Bend East",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_4x4_from_bend_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 10x10 From Bend West
function default.dt_jungle_elbow_west_grows_to_10x10_from_bend_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 10x10 From Bend West",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_10x10_from_bend_west(...)
	end
})

-- Elbow West Grows To 8x8 From Bend West
function default.dt_jungle_elbow_west_grows_to_8x8_from_bend_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 8x8 From Bend West",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_8x8_from_bend_west(...)
	end
})

-- Elbow West Grows To 6x6 From Bend West
function default.dt_jungle_elbow_west_grows_to_6x6_from_bend_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 6x6 From Bend West",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_6x6_from_bend_west(...)
	end
})

-- Elbow West Grows To 4x4 From Bend West
function default.dt_jungle_elbow_west_grows_to_4x4_from_bend_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 4x4 From Bend West",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_4x4_from_bend_west(...)
	end
})

-- North Facing Node Placement
-- Fork North 4x4 Grows 2x2 Arm North
function default.dt_jungle_fork_north_4x4_grows_2x2_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North 4x4 Grows 2x2 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_4x4_grows_2x2_arm_north(...)
	end
})

-- Arm North 4x4 Grows 2x2 Elbow North
function default.dt_jungle_arm_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_elbow_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork North
function default.dt_jungle_elbow_north_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork South
function default.dt_jungle_elbow_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork East
function default.dt_jungle_elbow_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork West
function default.dt_jungle_elbow_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_4x4_grows_2x2_fork_west(...)
	end
})

-- South Facing Node Placement
-- Fork South 4x4 Grows 2x2 Arm South
function default.dt_jungle_fork_south_4x4_grows_2x2_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South 4x4 Grows 2x2 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_4x4_grows_2x2_arm_south(...)
	end
})

-- Arm South 4x4 Grows 2x2 Elbow South
function default.dt_jungle_arm_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_elbow_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork North
function default.dt_jungle_elbow_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork South
function default.dt_jungle_elbow_south_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork East
function default.dt_jungle_elbow_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork West
function default.dt_jungle_elbow_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_4x4_grows_2x2_fork_west(...)
	end
})

-- East Facing Node Placement
-- Fork East 4x4 Grows 2x2 Arm East
function default.dt_jungle_fork_east_4x4_grows_2x2_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East 4x4 Grows 2x2 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_4x4_grows_2x2_arm_east(...)
	end
})

-- Arm East 4x4 Grows 2x2 Elbow East
function default.dt_jungle_arm_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_elbow_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork North
function default.dt_jungle_elbow_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork South
function default.dt_jungle_elbow_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork East
function default.dt_jungle_elbow_east_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork West
function default.dt_jungle_elbow_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_4x4_grows_2x2_fork_west(...)
	end
})

-- West Facing Node Placement
-- Fork West 4x4 Grows 2x2 Arm West
function default.dt_jungle_fork_west_4x4_grows_2x2_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West 4x4 Grows 2x2 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_4x4_grows_2x2_arm_west(...)
	end
})

-- Arm West 4x4 Grows 2x2 Elbow West
function default.dt_jungle_arm_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Main Trunk
function default.dt_jungle_elbow_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork North
function default.dt_jungle_elbow_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork South
function default.dt_jungle_elbow_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork East
function default.dt_jungle_elbow_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork West
function default.dt_jungle_elbow_west_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_4x4_grows_2x2_fork_west(...)
	end
})

-- North Arm Growth
-- Arm North Grows To 14x14 From Fork North
function default.dt_jungle_arm_north_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_16x16" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_14x14_from_fork_north(...)
	end
})

-- Arm North Grows To 12x12 From Fork North
function default.dt_jungle_arm_north_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_12x12_from_fork_north(...)
	end
})

-- Arm North Grows To 10x10 From Fork North
function default.dt_jungle_arm_north_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_10x10_from_fork_north(...)
	end
})

-- Arm North Grows To 8x8 From Fork North
function default.dt_jungle_arm_north_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_8x8_from_fork_north(...)
	end
})

-- Arm North Grows To 6x6 From Fork North
function default.dt_jungle_arm_north_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_6x6_from_fork_north(...)
	end
})

-- Arm North Grows To 4x4 From Fork North
function default.dt_jungle_arm_north_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_north_grows_to_4x4_from_fork_north(...)
	end
})

-- South Arm Growth
-- Arm South Grows To 14x14 From Fork South
function default.dt_jungle_arm_south_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_16x16" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_14x14_from_fork_south(...)
	end
})

-- Arm South Grows To 12x12 From Fork South
function default.dt_jungle_arm_south_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_12x12_from_fork_south(...)
	end
})

-- Arm South Grows To 10x10 From Fork South
function default.dt_jungle_arm_south_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_10x10_from_fork_south(...)
	end
})

-- Arm South Grows To 8x8 From Fork South
function default.dt_jungle_arm_south_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_8x8_from_fork_south(...)
	end
})

-- Arm South Grows To 6x6 From Fork South
function default.dt_jungle_arm_south_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_6x6_from_fork_south(...)
	end
})

-- Arm South Grows To 4x4 From Fork South
function default.dt_jungle_arm_south_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_south_grows_to_4x4_from_fork_south(...)
	end
})

-- East Arm Growth
-- Arm East Grows To 14x14 From Fork East
function default.dt_jungle_arm_east_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_16x16" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_14x14_from_fork_east(...)
	end
})

-- Arm East Grows To 12x12 From Fork East
function default.dt_jungle_arm_east_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_12x12_from_fork_east(...)
	end
})

-- Arm East Grows To 10x10 From Fork East
function default.dt_jungle_arm_east_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_10x10_from_fork_east(...)
	end
})

-- Arm East Grows To 8x8 From Fork East
function default.dt_jungle_arm_east_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_8x8_from_fork_east(...)
	end
})

-- Arm East Grows To 6x6 From Fork East
function default.dt_jungle_arm_east_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_6x6_from_fork_east(...)
	end
})

-- Arm East Grows To 4x4 From Fork East
function default.dt_jungle_arm_east_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_east_grows_to_4x4_from_fork_east(...)
	end
})

-- West Arm Growth
-- Arm West Grows To 14x14 From Fork West
function default.dt_jungle_arm_west_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_16x16" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_14x14_from_fork_west(...)
	end
})

-- Arm West Grows To 12x12 From Fork West
function default.dt_jungle_arm_west_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_12x12_from_fork_west(...)
	end
})

-- Arm West Grows To 10x10 From Fork West
function default.dt_jungle_arm_west_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_10x10_from_fork_west(...)
	end
})

-- Arm West Grows To 8x8 From Fork West
function default.dt_jungle_arm_west_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_8x8_from_fork_west(...)
	end
})

-- Arm West Grows To 6x6 From Fork West
function default.dt_jungle_arm_west_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_6x6_from_fork_west(...)
	end
})

-- Arm West Grows To 4x4 From Fork West
function default.dt_jungle_arm_west_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_arm_west_grows_to_4x4_from_fork_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 12x12 From Arm North
function default.dt_jungle_elbow_north_grows_to_12x12_from_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 12x12 From Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_12x12_from_arm_north(...)
	end
})

-- Elbow North Grows To 10x10 From Arm North
function default.dt_jungle_elbow_north_grows_to_10x10_from_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 10x10 From Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_10x10_from_arm_north(...)
	end
})

-- Elbow North Grows To 8x8 From Arm North
function default.dt_jungle_elbow_north_grows_to_8x8_from_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 8x8 From Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_8x8_from_arm_north(...)
	end
})

-- Elbow North Grows To 6x6 From Arm North
function default.dt_jungle_elbow_north_grows_to_6x6_from_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 6x6 From Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_6x6_from_arm_north(...)
	end
})

-- Elbow North Grows To 4x4 From Arm North
function default.dt_jungle_elbow_north_grows_to_4x4_from_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow North Grows To 4x4 From Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_north_grows_to_4x4_from_arm_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 12x12 From Arm South
function default.dt_jungle_elbow_south_grows_to_12x12_from_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 12x12 From Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_12x12_from_arm_south(...)
	end
})

-- Elbow South Grows To 10x10 From Arm South
function default.dt_jungle_elbow_south_grows_to_10x10_from_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 10x10 From Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_10x10_from_arm_south(...)
	end
})

-- Elbow South Grows To 8x8 From Arm South
function default.dt_jungle_elbow_south_grows_to_8x8_from_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 8x8 From Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_8x8_from_arm_south(...)
	end
})

-- Elbow South Grows To 6x6 From Arm South
function default.dt_jungle_elbow_south_grows_to_6x6_from_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 6x6 From Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_6x6_from_arm_south(...)
	end
})

-- Elbow South Grows To 4x4 From Arm South
function default.dt_jungle_elbow_south_grows_to_4x4_from_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow South Grows To 4x4 From Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_south_grows_to_4x4_from_arm_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 12x12 From Arm East
function default.dt_jungle_elbow_east_grows_to_12x12_from_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 12x12 From Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_12x12_from_arm_east(...)
	end
})

-- Elbow East Grows To 10x10 From Arm East
function default.dt_jungle_elbow_east_grows_to_10x10_from_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 10x10 From Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_10x10_from_arm_east(...)
	end
})

-- Elbow East Grows To 8x8 From Arm East
function default.dt_jungle_elbow_east_grows_to_8x8_from_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 8x8 From Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_8x8_from_arm_east(...)
	end
})

-- Elbow East Grows To 6x6 From Arm East
function default.dt_jungle_elbow_east_grows_to_6x6_from_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 6x6 From Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_6x6_from_arm_east(...)
	end
})

-- Elbow East Grows To 4x4 From Arm East
function default.dt_jungle_elbow_east_grows_to_4x4_from_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow East Grows To 4x4 From Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_east_grows_to_4x4_from_arm_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 12x12 From Arm West
function default.dt_jungle_elbow_west_grows_to_12x12_from_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 12x12 From Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_12x12_from_arm_west(...)
	end
})

-- Elbow West Grows To 10x10 From Arm West
function default.dt_jungle_elbow_west_grows_to_10x10_from_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 10x10 From Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_10x10_from_arm_west(...)
	end
})

-- Elbow West Grows To 8x8 From Arm West
function default.dt_jungle_elbow_west_grows_to_8x8_from_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 8x8 From Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_8x8_from_arm_west(...)
	end
})

-- Elbow West Grows To 6x6 From Arm West
function default.dt_jungle_elbow_west_grows_to_6x6_from_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 6x6 From Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_6x6_from_arm_west(...)
	end
})

-- Elbow West Grows To 4x4 From Arm West
function default.dt_jungle_elbow_west_grows_to_4x4_from_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Elbow West Grows To 4x4 From Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_elbow_west_grows_to_4x4_from_arm_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow North
-- Main Trunk Grows To 10x10 From Elbow North
function default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_north(...)
	end
})

-- Main Trunk Grows To 8x8 From Elbow North
function default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_north(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow North
function default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_north(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow North
function default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork North Grows To 10x10 From Elbow North
function default.dt_jungle_fork_north_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_elbow_north(...)
	end
})

-- Fork North Grows To 8x8 From Elbow North
function default.dt_jungle_fork_north_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork North Grows To 6x6 From Elbow North
function default.dt_jungle_fork_north_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork North Grows To 4x4 From Elbow North
function default.dt_jungle_fork_north_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork South Grows To 10x10 From Elbow North
function default.dt_jungle_fork_south_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_elbow_north(...)
	end
})

-- Fork South Grows To 8x8 From Elbow North
function default.dt_jungle_fork_south_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork South Grows To 6x6 From Elbow North
function default.dt_jungle_fork_south_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork South Grows To 4x4 From Elbow North
function default.dt_jungle_fork_south_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork East Grows To 10x10 From Elbow North
function default.dt_jungle_fork_east_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_elbow_north(...)
	end
})

-- Fork East Grows To 8x8 From Elbow North
function default.dt_jungle_fork_east_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork East Grows To 6x6 From Elbow North
function default.dt_jungle_fork_east_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork East Grows To 4x4 From Elbow North
function default.dt_jungle_fork_east_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork West Grows To 10x10 From Elbow North
function default.dt_jungle_fork_west_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_elbow_north(...)
	end
})

-- Fork West Grows To 8x8 From Elbow North
function default.dt_jungle_fork_west_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork West Grows To 6x6 From Elbow North
function default.dt_jungle_fork_west_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork West Grows To 4x4 From Elbow North
function default.dt_jungle_fork_west_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_elbow_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow South
-- Main Trunk Grows To 10x10 From Elbow South
function default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_south(...)
	end
})

-- Main Trunk Grows To 8x8 From Elbow South
function default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_south(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow South
function default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_south(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow South
function default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork North Grows To 10x10 From Elbow South
function default.dt_jungle_fork_north_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_elbow_south(...)
	end
})

-- Fork North Grows To 8x8 From Elbow South
function default.dt_jungle_fork_north_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork North Grows To 6x6 From Elbow South
function default.dt_jungle_fork_north_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork North Grows To 4x4 From Elbow South
function default.dt_jungle_fork_north_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork South Grows To 10x10 From Elbow South
function default.dt_jungle_fork_south_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_elbow_south(...)
	end
})

-- Fork South Grows To 8x8 From Elbow South
function default.dt_jungle_fork_south_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork South Grows To 6x6 From Elbow South
function default.dt_jungle_fork_south_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork South Grows To 4x4 From Elbow South
function default.dt_jungle_fork_south_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork East Grows To 10x10 From Elbow South
function default.dt_jungle_fork_east_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_elbow_south(...)
	end
})

-- Fork East Grows To 8x8 From Elbow South
function default.dt_jungle_fork_east_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork East Grows To 6x6 From Elbow South
function default.dt_jungle_fork_east_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork East Grows To 4x4 From Elbow South
function default.dt_jungle_fork_east_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork West Grows To 10x10 From Elbow South
function default.dt_jungle_fork_west_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_elbow_south(...)
	end
})

-- Fork West Grows To 8x8 From Elbow South
function default.dt_jungle_fork_west_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork West Grows To 6x6 From Elbow South
function default.dt_jungle_fork_west_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork West Grows To 4x4 From Elbow South
function default.dt_jungle_fork_west_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_elbow_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow East
-- Main Trunk Grows To 10x10 From Elbow East
function default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_east(...)
	end
})

-- Main Trunk Grows To 8x8 From Elbow East
function default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_east(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow East
function default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_east(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow East
function default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork North Grows To 10x10 From Elbow East
function default.dt_jungle_fork_north_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_elbow_east(...)
	end
})

-- Fork North Grows To 8x8 From Elbow East
function default.dt_jungle_fork_north_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork North Grows To 6x6 From Elbow East
function default.dt_jungle_fork_north_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork North Grows To 4x4 From Elbow East
function default.dt_jungle_fork_north_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork South Grows To 10x10 From Elbow East
function default.dt_jungle_fork_south_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_elbow_east(...)
	end
})

-- Fork South Grows To 8x8 From Elbow East
function default.dt_jungle_fork_south_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork South Grows To 6x6 From Elbow East
function default.dt_jungle_fork_south_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork South Grows To 4x4 From Elbow East
function default.dt_jungle_fork_south_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork East Grows To 10x10 From Elbow East
function default.dt_jungle_fork_east_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_elbow_east(...)
	end
})

-- Fork East Grows To 8x8 From Elbow East
function default.dt_jungle_fork_east_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork East Grows To 6x6 From Elbow East
function default.dt_jungle_fork_east_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork East Grows To 4x4 From Elbow East
function default.dt_jungle_fork_east_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork West Grows To 10x10 From Elbow East
function default.dt_jungle_fork_west_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_elbow_east(...)
	end
})

-- Fork West Grows To 8x8 From Elbow East
function default.dt_jungle_fork_west_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork West Grows To 6x6 From Elbow East
function default.dt_jungle_fork_west_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork West Grows To 4x4 From Elbow East
function default.dt_jungle_fork_west_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_elbow_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow West
-- Main Trunk Grows To 10x10 From Elbow West
function default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_10x10_from_elbow_west(...)
	end
})

-- Main Trunk Grows To 8x8 From Elbow West
function default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_8x8_from_elbow_west(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow West
function default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_6x6_from_elbow_west(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow West
function default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Main Trunk Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_main_trunk_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork North Grows To 10x10 From Elbow West
function default.dt_jungle_fork_north_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_10x10_from_elbow_west(...)
	end
})

-- Fork North Grows To 8x8 From Elbow West
function default.dt_jungle_fork_north_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork North Grows To 6x6 From Elbow West
function default.dt_jungle_fork_north_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork North Grows To 4x4 From Elbow West
function default.dt_jungle_fork_north_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork North Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_north_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork South Grows To 10x10 From Elbow West
function default.dt_jungle_fork_south_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_10x10_from_elbow_west(...)
	end
})

-- Fork South Grows To 8x8 From Elbow West
function default.dt_jungle_fork_south_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork South Grows To 6x6 From Elbow West
function default.dt_jungle_fork_south_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork South Grows To 4x4 From Elbow West
function default.dt_jungle_fork_south_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork South Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_south_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork East Grows To 10x10 From Elbow West
function default.dt_jungle_fork_east_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_10x10_from_elbow_west(...)
	end
})

-- Fork East Grows To 8x8 From Elbow West
function default.dt_jungle_fork_east_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork East Grows To 6x6 From Elbow West
function default.dt_jungle_fork_east_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork East Grows To 4x4 From Elbow West
function default.dt_jungle_fork_east_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork East Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_east_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork West Grows To 10x10 From Elbow West
function default.dt_jungle_fork_west_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_10x10_from_elbow_west(...)
	end
})

-- Fork West Grows To 8x8 From Elbow West
function default.dt_jungle_fork_west_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork West Grows To 6x6 From Elbow West
function default.dt_jungle_fork_west_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork West Grows To 4x4 From Elbow West
function default.dt_jungle_fork_west_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Fork West Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_jungle_fork_west_grows_to_4x4_from_elbow_west(...)
	end
})

-- Arm North 14x14 Grows 12x12 Arm North
function default.dt_jungle_arm_north_14x14_grows_12x12_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 14x14 Grows 12x12 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_north_14x14_grows_12x12_arm_north(...)
	end
})

-- Arm South 14x14 Grows 12x12 Arm South
function default.dt_jungle_arm_south_14x14_grows_12x12_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 14x14 Grows 12x12 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_south_14x14_grows_12x12_arm_south(...)
	end
})

-- Arm East 14x14 Grows 12x12 Arm East
function default.dt_jungle_arm_east_14x14_grows_12x12_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 14x14 Grows 12x12 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_east_14x14_grows_12x12_arm_east(...)
	end
})

-- Arm West 14x14 Grows 12x12 Arm West
function default.dt_jungle_arm_west_14x14_grows_12x12_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 14x14 Grows 12x12 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_jungle_arm_west_14x14_grows_12x12_arm_west(...)
	end
})

-- Arm North 12x12 Grows 10x10 Arm North
function default.dt_jungle_arm_north_12x12_grows_10x10_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 12x12 Grows 10x10 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_north_12x12_grows_10x10_arm_north(...)
	end
})

-- Arm South 12x12 Grows 10x10 Arm South
function default.dt_jungle_arm_south_12x12_grows_10x10_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 12x12 Grows 10x10 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_south_12x12_grows_10x10_arm_south(...)
	end
})

-- Arm East 12x12 Grows 10x10 Arm East
function default.dt_jungle_arm_east_12x12_grows_10x10_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 12x12 Grows 10x10 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_east_12x12_grows_10x10_arm_east(...)
	end
})

-- Arm West 12x12 Grows 10x10 Arm West
function default.dt_jungle_arm_west_12x12_grows_10x10_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 12x12 Grows 10x10 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_jungle_arm_west_12x12_grows_10x10_arm_west(...)
	end
})

-- Arm North 10x10 Grows 8x8 Arm North
function default.dt_jungle_arm_north_10x10_grows_8x8_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 10x10 Grows 8x8 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_north_10x10_grows_8x8_arm_north(...)
	end
})

-- Arm South 10x10 Grows 8x8 Arm South
function default.dt_jungle_arm_south_10x10_grows_8x8_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 10x10 Grows 8x8 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_south_10x10_grows_8x8_arm_south(...)
	end
})

-- Arm East 10x10 Grows 8x8 Arm East
function default.dt_jungle_arm_east_10x10_grows_8x8_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 10x10 Grows 8x8 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_east_10x10_grows_8x8_arm_east(...)
	end
})

-- Arm West 10x10 Grows 8x8 Arm West
function default.dt_jungle_arm_west_10x10_grows_8x8_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 10x10 Grows 8x8 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_arm_west_10x10_grows_8x8_arm_west(...)
	end
})

-- Arm North 8x8 Grows 6x6 Arm North
function default.dt_jungle_arm_north_8x8_grows_6x6_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 8x8 Grows 6x6 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_north_8x8_grows_6x6_arm_north(...)
	end
})

-- Arm South 8x8 Grows 6x6 Arm South
function default.dt_jungle_arm_south_8x8_grows_6x6_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 8x8 Grows 6x6 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_south_8x8_grows_6x6_arm_south(...)
	end
})

-- Arm East 8x8 Grows 6x6 Arm East
function default.dt_jungle_arm_east_8x8_grows_6x6_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 8x8 Grows 6x6 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_east_8x8_grows_6x6_arm_east(...)
	end
})

-- Arm West 8x8 Grows 6x6 Arm West
function default.dt_jungle_arm_west_8x8_grows_6x6_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 8x8 Grows 6x6 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_west_8x8_grows_6x6_arm_west(...)
	end
})

-- Arm North 6x6 Grows 4x4 Arm North
function default.dt_jungle_arm_north_6x6_grows_4x4_arm_north(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm North 6x6 Grows 4x4 Arm North",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_north_6x6_grows_4x4_arm_north(...)
	end
})

-- Arm South 6x6 Grows 4x4 Arm South
function default.dt_jungle_arm_south_6x6_grows_4x4_arm_south(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm South 6x6 Grows 4x4 Arm South",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_south_6x6_grows_4x4_arm_south(...)
	end
})

-- Arm East 6x6 Grows 4x4 Arm East
function default.dt_jungle_arm_east_6x6_grows_4x4_arm_east(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm East 6x6 Grows 4x4 Arm East",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_east_6x6_grows_4x4_arm_east(...)
	end
})

-- Arm West 6x6 Grows 4x4 Arm West
function default.dt_jungle_arm_west_6x6_grows_4x4_arm_west(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_arm_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_arm_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Arm West 6x6 Grows 4x4 Arm West",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_jungle_arm_west_6x6_grows_4x4_arm_west(...)
	end
})

-- Leaves Growth
-- Canopy Base Will Spawn Above And Around The 2x2 Nodes Of The Tree
-- This Spawns Canopy Base Above Main Trunk 2x2
function default.dt_jungle_canopy_base_above_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Main Trunk 2x2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -x Main Trunk 2x2
function default.dt_jungle_canopy_base_minus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +x Main Trunk 2x2
function default.dt_jungle_canopy_base_plus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -z Main Trunk 2x2
function default.dt_jungle_canopy_base_minus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +z Main Trunk 2x2
function default.dt_jungle_canopy_base_plus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_main_trunk_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:jungle_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork North 2x2
function default.dt_jungle_canopy_base_above_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Fork North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork North 2x2
function default.dt_jungle_canopy_base_minus_x_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Fork North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork North 2x2
function default.dt_jungle_canopy_base_plus_x_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Fork North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork North 2x2
function default.dt_jungle_canopy_base_minus_z_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Fork North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork North 2x2
function default.dt_jungle_canopy_base_plus_z_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Fork North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork South 2x2
function default.dt_jungle_canopy_base_above_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Fork South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork South 2x2
function default.dt_jungle_canopy_base_minus_x_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Fork South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork South 2x2
function default.dt_jungle_canopy_base_plus_x_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Fork South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork South 2x2
function default.dt_jungle_canopy_base_minus_z_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Fork South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork South 2x2
function default.dt_jungle_canopy_base_plus_z_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_south_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Fork South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork East 2x2
function default.dt_jungle_canopy_base_above_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Fork East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork East 2x2
function default.dt_jungle_canopy_base_minus_x_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Fork East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork East 2x2
function default.dt_jungle_canopy_base_plus_x_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Fork East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork East 2x2
function default.dt_jungle_canopy_base_minus_z_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Fork East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork East 2x2
function default.dt_jungle_canopy_base_plus_z_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Fork East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork West 2x2
function default.dt_jungle_canopy_base_above_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Fork West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork West 2x2
function default.dt_jungle_canopy_base_minus_x_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Fork West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork West 2x2
function default.dt_jungle_canopy_base_plus_x_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Fork West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork West 2x2
function default.dt_jungle_canopy_base_minus_z_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Fork West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork West 2x2
function default.dt_jungle_canopy_base_plus_z_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_fork_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Fork West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base Above Arm North 2x2
function default.dt_jungle_canopy_base_above_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Arm North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm North 2x2
function default.dt_jungle_canopy_base_minus_x_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Arm North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm North 2x2
function default.dt_jungle_canopy_base_plus_x_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Arm North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm North 2x2
function default.dt_jungle_canopy_base_plus_z_arm_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Arm North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_arm_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Arm South 2x2
function default.dt_jungle_canopy_base_above_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Arm South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm South 2x2
function default.dt_jungle_canopy_base_minus_x_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Arm South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm South 2x2
function default.dt_jungle_canopy_base_plus_x_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Arm South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm South 2x2
function default.dt_jungle_canopy_base_minus_z_arm_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Arm South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_arm_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Arm East 2x2
function default.dt_jungle_canopy_base_above_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Arm East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Arm East 2x2
function default.dt_jungle_canopy_base_plus_x_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Arm East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm East 2x2
function default.dt_jungle_canopy_base_minus_z_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Arm East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm East 2x2
function default.dt_jungle_canopy_base_plus_z_arm_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Arm East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_arm_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Arm West 2x2
function default.dt_jungle_canopy_base_above_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Arm West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Arm West 2x2
function default.dt_jungle_canopy_base_minus_x_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Arm West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Arm West 2x2
function default.dt_jungle_canopy_base_minus_z_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Arm West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Arm West 2x2
function default.dt_jungle_canopy_base_plus_z_arm_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_arm_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Arm West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_arm_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_arm_west_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow North 2x2
function default.dt_jungle_canopy_base_above_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Elbow North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow North 2x2
function default.dt_jungle_canopy_base_minus_x_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Elbow North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow North 2x2
function default.dt_jungle_canopy_base_plus_x_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Elbow North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow North 2x2
function default.dt_jungle_canopy_base_plus_z_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Elbow North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow South 2x2
function default.dt_jungle_canopy_base_above_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Elbow South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow South 2x2
function default.dt_jungle_canopy_base_minus_x_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Elbow South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow South 2x2
function default.dt_jungle_canopy_base_plus_x_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Elbow South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow South 2x2
function default.dt_jungle_canopy_base_minus_z_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Elbow South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow East 2x2
function default.dt_jungle_canopy_base_above_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Elbow East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow East 2x2
function default.dt_jungle_canopy_base_plus_x_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Elbow East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow East 2x2
function default.dt_jungle_canopy_base_minus_z_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Elbow East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow East 2x2
function default.dt_jungle_canopy_base_plus_z_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Elbow East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow West 2x2
function default.dt_jungle_canopy_base_above_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Elbow West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow West 2x2
function default.dt_jungle_canopy_base_minus_x_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Elbow West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow West 2x2
function default.dt_jungle_canopy_base_minus_z_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Elbow West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow West 2x2
function default.dt_jungle_canopy_base_plus_z_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_elbow_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Elbow West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend North 2x2
function default.dt_jungle_canopy_base_above_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Bend North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend North 2x2
function default.dt_jungle_canopy_base_minus_x_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Bend North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend North 2x2
function default.dt_jungle_canopy_base_plus_x_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Bend North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend North 2x2
function default.dt_jungle_canopy_base_plus_z_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Bend North 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend South 2x2
function default.dt_jungle_canopy_base_above_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Bend South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend South 2x2
function default.dt_jungle_canopy_base_minus_x_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Bend South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend South 2x2
function default.dt_jungle_canopy_base_plus_x_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Bend South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend South 2x2
function default.dt_jungle_canopy_base_minus_z_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Bend South 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend East 2x2
function default.dt_jungle_canopy_base_above_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Bend East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend East 2x2
function default.dt_jungle_canopy_base_plus_x_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus X Bend East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_x_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend East 2x2
function default.dt_jungle_canopy_base_minus_z_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Bend East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend East 2x2
function default.dt_jungle_canopy_base_plus_z_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Bend East 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend West 2x2
function default.dt_jungle_canopy_base_above_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Above Bend West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_above_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend West 2x2
function default.dt_jungle_canopy_base_minus_x_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus X Bend West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_x_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend West 2x2
function default.dt_jungle_canopy_base_minus_z_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Minus Z Bend West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_minus_z_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend West 2x2
function default.dt_jungle_canopy_base_plus_z_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:jungle_tree_bend_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy Base Plus Z Bend West 2x2",
	nodenames = {"dynamic_trees:jungle_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_base_plus_z_bend_west_2x2(...)
	end
})

-- Canopy 1 Will Spawn Above And Around Canopy Base
-- This Spawns Canopy 1 Above Canopy Base
function default.dt_jungle_canopy_1_above_canopy_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 1 Above Canopy Base",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_1_above_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -x Canopy Base
function default.dt_jungle_canopy_1_minus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 1 Minus X Canopy Base",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_1_minus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +x Canopy Base
function default.dt_jungle_canopy_1_plus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 1 Plus X Canopy Base",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_1_plus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -z Canopy Base
function default.dt_jungle_canopy_1_minus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 1 Minus Z Canopy Base",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_1_minus_z_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +z Canopy Base
function default.dt_jungle_canopy_1_plus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_base" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 1 Plus Z Canopy Base",
	nodenames = {"dynamic_trees:jungle_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_jungle_canopy_1_plus_z_canopy_base(...)
	end
})

-- Canopy 2 Will Spawn Around Canopy 1
-- This Spawns Canopy 2 -x Canopy 1
function default.dt_jungle_canopy_2_minus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_1" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 2 Minus X Canopy 1",
	nodenames = {"dynamic_trees:jungle_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_canopy_2_minus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +x Canopy 1
function default.dt_jungle_canopy_2_plus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_1" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 2 Plus X Canopy 1",
	nodenames = {"dynamic_trees:jungle_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_canopy_2_plus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 -z Canopy 1
function default.dt_jungle_canopy_2_minus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_1" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 2 Minus Z Canopy 1",
	nodenames = {"dynamic_trees:jungle_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_canopy_2_minus_z_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +z Canopy 1
function default.dt_jungle_canopy_2_plus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:jungle_tree_canopy_1" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:jungle_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Canopy 2 Plus Z Canopy 1",
	nodenames = {"dynamic_trees:jungle_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_jungle_canopy_2_plus_z_canopy_1(...)
	end
})

-- Leaf Decay
-- This Is To Decay Any Leaves From The Bottom Or Top Using Air To Do So
-- The Reason Is To Allow For The Tree To Lose Excess Leaves
-- Jungle Leaves Decay Bottom
function default.dt_jungle_leaves_decay_bottom(pos, node)
	while node.name == "air" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay Bottom",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_bottom(...)
	end
})

-- Jungle Leaves Decay Top
function default.dt_jungle_leaves_decay_top(pos, node)
	while node.name == "air" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay Top",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_top(...)
	end
})

-- Jungle Leaves Decay North
function default.dt_jungle_leaves_decay_north(pos, node)
	while node.name == "air" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay North",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_north(...)
	end
})

-- Jungle Leaves Decay South
function default.dt_jungle_leaves_decay_south(pos, node)
	while node.name == "air" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay South",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_south(...)
	end
})

-- Jungle Leaves Decay East
function default.dt_jungle_leaves_decay_east(pos, node)
	while node.name == "air" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay East",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_east(...)
	end
})

-- Jungle Leaves Decay West
function default.dt_jungle_leaves_decay_west(pos, node)
	while node.name == "air" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:jungle_tree_canopy_base" and node.name ~= "dynamic_trees:jungle_tree_canopy_1"
	and node.name ~= "dynamic_trees:jungle_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT Jungle Leaves Decay West",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_jungle_leaves_decay_west(...)
	end
})