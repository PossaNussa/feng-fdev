-- dynamic_trees/dt_palm_tree_growth.lua

-- This Is Where The Dynamic palm Tree Growth Behavior Is

-- Tree Growth Starts Here With The Sapling
-- Sapling Growing A Canopy Base
function default.dt_palm_canopy_base_on_sapling(pos, node)
	while node.name == "dynamic_trees:palm_tree_sapling" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base On Sapling",
	nodenames = {"dynamic_trees:palm_tree_sapling"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_canopy_base_on_sapling(...)
	end
})

-- This Spawns A Base Trunk That The Tree Will Grow From
function default.dt_palm_main_trunk_base_2x2_replace_sapling(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_sapling" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Replace Sapling",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_replace_sapling(...)
	end
})


-- The Main Trunk Base Grows On It's Own Accord
-- The Rest Of The Tree Will Grow With It
-- Main Trunk Base Grows To 16x16
function default.dt_palm_main_trunk_base_grows_to_16x16(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 16x16",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 105,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_16x16(...)
	end
})

-- Main Trunk Base Grows To 14x14
function default.dt_palm_main_trunk_base_grows_to_14x14(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 90,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_14x14(...)
	end
})

-- Main Trunk Base Grows To 12x12
function default.dt_palm_main_trunk_base_grows_to_12x12(pos, node)
	while node.name ==  "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 75,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_12x12(...)
	end
})

-- Main Trunk Base Grows To 10x10
function default.dt_palm_main_trunk_base_grows_to_10x10(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 10x10",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 60,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_10x10(...)
	end
})

-- Main Trunk Base Grows To 8x8
function default.dt_palm_main_trunk_base_grows_to_8x8(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 8x8",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 45,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_8x8(...)
	end
})

-- Main Trunk Base Grows To 6x6
function default.dt_palm_main_trunk_base_grows_to_6x6(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base grows to 6x6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_6x6(...)
	end
})

-- Main Trunk Base Grows To 4x4
function default.dt_palm_main_trunk_base_grows_to_4x4(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_base_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_base_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base Grows To 4x4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_grows_to_4x4(...)
	end
})

-- This Is Where The New Growth Is Handled
-- Main Trunk Base 2x2 Grows 2x2 Trunk
function default.dt_palm_main_trunk_base_2x2_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork North
function default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork South
function default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork East
function default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork West
function default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 2x2 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_base_2x2_grows_2x2_fork_west(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Trunk
function default.dt_palm_main_trunk_base_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_base_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork North
function default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork South
function default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork East
function default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork West
function default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Base 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_base_4x4_grows_2x2_fork_west(...)
	end
})



-- Main Trunk 4x4 Grows 2x2 Trunk
function default.dt_palm_main_trunk_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork North
function default.dt_palm_main_trunk_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork South
function default.dt_palm_main_trunk_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork East
function default.dt_palm_main_trunk_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork West
function default.dt_palm_main_trunk_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_main_trunk_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork North 4x4 Grows 2x2 Main Trunk
function default.dt_palm_fork_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_fork_north_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork South
function default.dt_palm_fork_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_north_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork East
function default.dt_palm_fork_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_north_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork West
function default.dt_palm_fork_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_north_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_north_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork South 4x4 Grows 2x2 Main Trunk
function default.dt_palm_fork_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_fork_south_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork North
function default.dt_palm_fork_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_south_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork East
function default.dt_palm_fork_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_south_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork West
function default.dt_palm_fork_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_south_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_south_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork East 4x4 Grows 2x2 Main Trunk
function default.dt_palm_fork_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_fork_east_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork North
function default.dt_palm_fork_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_east_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork South
function default.dt_palm_fork_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_east_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork West
function default.dt_palm_fork_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_east_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_east_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork West 4x4 Grows 2x2 Main Trunk
function default.dt_palm_fork_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_fork_west_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork North
function default.dt_palm_fork_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_west_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork South
function default.dt_palm_fork_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_west_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork East
function default.dt_palm_fork_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_west_4x4"},
	interval = 10,
	chance = 3,
	action = function(...)
		default.dt_palm_fork_west_4x4_grows_2x2_fork_east(...)
	end
})

-- This Is Where The Rest Of The Tree Checks If It Should Be Growing

-- This Section Is For All The Nodes That Will Grow To 16x16 From The Tree Base
-- These Are The Sections Of The Main Trunk That Will Grow 7 Blocks Above It
-- Main Trunk Grows To 16x16 Section 1
function default.dt_palm_main_trunk_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_1(...)
	end
})

-- Fork North Grows To 16x16 Section 1
function default.dt_palm_fork_north_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_1(...)
	end
})

-- Fork South Grows To 16x16 Section 1
function default.dt_palm_fork_south_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_1(...)
	end
})

-- Fork East Grows To 16x16 Section 1
function default.dt_palm_fork_east_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_1(...)
	end
})

-- Fork West Grows To 16x16 Section 1
function default.dt_palm_fork_west_grows_to_16x16_section_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 1",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_1(...)
	end
})

-- Main Trunk Grows To 16x16 Section 2
function default.dt_palm_main_trunk_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_2(...)
	end
})

-- Fork North Grows To 16x16 Section 2
function default.dt_palm_fork_north_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_2(...)
	end
})

-- Fork South Grows To 16x16 Section 2
function default.dt_palm_fork_south_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_2(...)
	end
})

-- Fork East Grows To 16x16 Section 2
function default.dt_palm_fork_east_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_2(...)
	end
})

-- Fork West Grows To 16x16 Section 2
function default.dt_palm_fork_west_grows_to_16x16_section_2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_2(...)
	end
})

-- Main Trunk Grows To 16x16 Section 3
function default.dt_palm_main_trunk_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_3(...)
	end
})

-- Fork North Grows To 16x16 Section 3
function default.dt_palm_fork_north_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_3(...)
	end
})

-- Fork South Grows To 16x16 Section 3
function default.dt_palm_fork_south_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_3(...)
	end
})

-- Fork East Grows To 16x16 Section 3
function default.dt_palm_fork_east_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_3(...)
	end
})

-- Fork West Grows To 16x16 Section 3
function default.dt_palm_fork_west_grows_to_16x16_section_3(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 3",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_3(...)
	end
})

-- Main Trunk Grows To 16x16 Section 4
function default.dt_palm_main_trunk_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_4(...)
	end
})

-- Fork North Grows To 16x16 Section 4
function default.dt_palm_fork_north_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_4(...)
	end
})

-- Fork South Grows To 16x16 Section 4
function default.dt_palm_fork_south_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_4(...)
	end
})

-- Fork East Grows To 16x16 Section 4
function default.dt_palm_fork_east_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_4(...)
	end
})

-- Fork West Grows To 16x16 Section 4
function default.dt_palm_fork_west_grows_to_16x16_section_4(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 4",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_4(...)
	end
})

-- Main Trunk Grows To 16x16 Section 5
function default.dt_palm_main_trunk_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_5(...)
	end
})

-- Fork North Grows To 16x16 Section 5
function default.dt_palm_fork_north_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_5(...)
	end
})

-- Fork South Grows To 16x16 Section 5
function default.dt_palm_fork_south_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_5(...)
	end
})

-- Fork East Grows To 16x16 Section 5
function default.dt_palm_fork_east_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_5(...)
	end
})

-- Fork West Grows To 16x16 Section 5
function default.dt_palm_fork_west_grows_to_16x16_section_5(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 5",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_5(...)
	end
})

-- Main Trunk Grows To 16x16 Section 6
function default.dt_palm_main_trunk_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_6(...)
	end
})

-- Fork North Grows To 16x16 Section 6
function default.dt_palm_fork_north_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_6(...)
	end
})

-- Fork South Grows To 16x16 Section 6
function default.dt_palm_fork_south_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_6(...)
	end
})

-- Fork East Grows To 16x16 Section 6
function default.dt_palm_fork_east_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_6(...)
	end
})

-- Fork West Grows To 16x16 Section 6
function default.dt_palm_fork_west_grows_to_16x16_section_6(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 6",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_6(...)
	end
})

-- Main Trunk Grows To 16x16 Section 7
function default.dt_palm_main_trunk_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_16x16_section_7(...)
	end
})

-- Fork North Grows To 16x16 Section 7
function default.dt_palm_fork_north_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_north_grows_to_16x16_section_7(...)
	end
})

-- Fork South Grows To 16x16 Section 7
function default.dt_palm_fork_south_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_south_grows_to_16x16_section_7(...)
	end
})

-- Fork East Grows To 16x16 Section 7
function default.dt_palm_fork_east_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_east_grows_to_16x16_section_7(...)
	end
})

-- Fork West Grows To 16x16 Section 7
function default.dt_palm_fork_west_grows_to_16x16_section_7(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_16x16"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 16x16 Section 7",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 100,
	action = function(...)
		default.dt_palm_fork_west_grows_to_16x16_section_7(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Tree Base
-- Main Trunk Grows To 14x14
function default.dt_palm_main_trunk_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14(...)
	end
})

-- Fork North Grows To 14x14
function default.dt_palm_fork_north_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_north_grows_to_14x14(...)
	end
})

-- Fork South Grows To 14x14
function default.dt_palm_fork_south_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_south_grows_to_14x14(...)
	end
})

-- Fork East Grows To 14x14
function default.dt_palm_fork_east_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_east_grows_to_14x14(...)
	end
})

-- Fork West Grows To 14x14
function default.dt_palm_fork_west_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 14x14",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_west_grows_to_14x14(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Tree Base
-- Main Trunk Grows To 12x12 From Base
function default.dt_palm_main_trunk_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_base(...)
	end
})

-- Fork North Grows To 12x12 From Base
function default.dt_palm_fork_north_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_north_grows_to_12x12_from_base(...)
	end
})

-- Fork South Grows To 12x12 From Base
function default.dt_palm_fork_south_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_south_grows_to_12x12_from_base(...)
	end
})

-- Fork East Grows To 12x12 From Base
function default.dt_palm_fork_east_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_east_grows_to_12x12_from_base(...)
	end
})

-- Fork West Grows To 12x12 From Base
function default.dt_palm_fork_west_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 12x12",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_west_grows_to_12x12_from_base(...)
	end
})

-- This Is Where The Main Trunk 12x12 Nodes Grow To 14x14 From The Main Trunk
-- Main Trunk Grows To 14x14 From Main Trunk
function default.dt_palm_main_trunk_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork North Grows To 14x14 From Main Trunk
function default.dt_palm_fork_north_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_north_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork South Grows To 14x14 From Main Trunk
function default.dt_palm_fork_south_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_south_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork East Grows To 14x14 From Main Trunk
function default.dt_palm_fork_east_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_east_grows_to_14x14_from_main_trunk(...)
	end
})

-- Fork West Grows To 14x14 From Main Trunk
function default.dt_palm_fork_west_grows_to_14x14_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 14x14 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_west_grows_to_14x14_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork North
-- Main Trunk Grows To 14x14 From Fork North
function default.dt_palm_main_trunk_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork South Grows To 14x14 From Fork North
function default.dt_palm_fork_south_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_south_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork East Grows To 14x14 From Fork North
function default.dt_palm_fork_east_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_east_grows_to_14x14_from_fork_north(...)
	end
})

-- Fork West Grows To 14x14 From Fork North
function default.dt_palm_fork_west_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_west_grows_to_14x14_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork South
-- Main Trunk Grows To 14x14 From Fork South
function default.dt_palm_main_trunk_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork North Grows To 14x14 From Fork South
function default.dt_palm_fork_north_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_north_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork East Grows To 14x14 From Fork South
function default.dt_palm_fork_east_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_east_grows_to_14x14_from_fork_south(...)
	end
})

-- Fork West Grows To 14x14 From Fork South
function default.dt_palm_fork_west_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_12x12" then
		return
	end
	mi.etest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_west_grows_to_14x14_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork East
-- Main Trunk Grows To 14x14 From Fork East
function default.dt_palm_main_trunk_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_16x16"},
	ifterval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork North Grows To 14x14 From Fork East
function default.dt_palm_fork_north_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_north_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork South Grows To 14x14 From Fork East
function default.dt_palm_fork_south_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_south_grows_to_14x14_from_fork_east(...)
	end
})

-- Fork West Grows To 14x14 From Fork East
function default.dt_palm_fork_west_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_west_grows_to_14x14_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Fork West
-- Main Trunk Grows To 14x14 From Fork West
function default.dt_palm_main_trunk_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork North Grows To 14x14 From Fork West
function default.dt_palm_fork_north_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_north_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork South Grows To 14x14 From Fork West
function default.dt_palm_fork_south_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_south_grows_to_14x14_from_fork_west(...)
	end
})

-- Fork East Grows To 14x14 From Fork West
function default.dt_palm_fork_east_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_fork_east_grows_to_14x14_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Main Trunk
-- Main Trunk Grows To 12x12 From Main Trunk
function default.dt_palm_main_trunk_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork North Grows To 12x12 From Main Trunk
function default.dt_palm_fork_north_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_north_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork South Grows To 12x12 From Main Trunk
function default.dt_palm_fork_south_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_south_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork East Grows To 12x12 From Main Trunk
function default.dt_palm_fork_east_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_east_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork West Grows To 12x12 From Main Trunk
function default.dt_palm_fork_west_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_west_grows_to_12x12_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork North
-- Main Trunk Grows To 12x12 From Fork North
function default.dt_palm_main_trunk_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork South Grows To 12x12 From Fork North
function default.dt_palm_fork_south_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_south_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork East Grows To 12x12 From Fork North
function default.dt_palm_fork_east_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_east_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork West Grows To 12x12 From Fork North
function default.dt_palm_fork_west_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_west_grows_to_12x12_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork South
-- Main Trunk Grows To 12x12 From Fork South
function default.dt_palm_main_trunk_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork North Grows To 12x12 From Fork South
function default.dt_palm_fork_north_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_north_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork East Grows To 12x12 From Fork South
function default.dt_palm_fork_east_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_east_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork West Grows To 12x12 From Fork South
function default.dt_palm_fork_west_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_west_grows_to_12x12_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork East
-- Main Trunk Grows To 12x12 From Fork East
function default.dt_palm_main_trunk_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork North Grows To 12x12 From Fork East
function default.dt_palm_fork_north_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_north_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork South Grows To 12x12 From Fork East
function default.dt_palm_fork_south_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_south_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork West Grows To 12x12 From Fork East
function default.dt_palm_fork_west_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_west_grows_to_12x12_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork West
-- Main Trunk Grows To 12x12 From Fork West
function default.dt_palm_main_trunk_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork North Grows To 12x12 From Fork West
function default.dt_palm_fork_north_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_north_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork South Grows To 12x12 From Fork West
function default.dt_palm_fork_south_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_south_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork East Grows To 12x12 From Fork West
function default.dt_palm_fork_east_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_fork_east_grows_to_12x12_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Base
-- Main Trunk Grows To 10x10 From Base
function default.dt_palm_main_trunk_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_base(...)
	end
})

-- Fork North Grows To 10x10 From Base
function default.dt_palm_fork_north_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_north_grows_to_10x10_from_base(...)
	end
})

-- Fork South Grows To 10x10 From Base
function default.dt_palm_fork_south_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_south_grows_to_10x10_from_base(...)
	end
})

-- Fork East Grows To 10x10 From Base
function default.dt_palm_fork_east_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_east_grows_to_10x10_from_base(...)
	end
})

-- Fork West Grows To 10x10 From Base
function default.dt_palm_fork_west_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_west_grows_to_10x10_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Main Trunk
-- Main Trunk Grows To 10x10 From Main Trunk
function default.dt_palm_main_trunk_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork North Grows To 10x10 From Main Trunk
function default.dt_palm_fork_north_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_north_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork South Grows To 10x10 From Main Trunk
function default.dt_palm_fork_south_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_south_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork East Grows To 10x10 From Main Trunk
function default.dt_palm_fork_east_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_east_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork West Grows To 10x10 From Main Trunk
function default.dt_palm_fork_west_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_west_grows_to_10x10_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork North
-- Main Trunk Grows To 10x10 From Fork North
function default.dt_palm_main_trunk_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork South Grows To 10x10 From Fork North
function default.dt_palm_fork_south_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_south_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork East Grows To 10x10 From Fork North
function default.dt_palm_fork_east_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_east_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork West Grows To 10x10 From Fork North
function default.dt_palm_fork_west_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_west_grows_to_10x10_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork South
-- Main Trunk Grows To 10x10 From Fork South
function default.dt_palm_main_trunk_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork North Grows To 10x10 From Fork South
function default.dt_palm_fork_north_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_north_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork East Grows To 10x10 From Fork South
function default.dt_palm_fork_east_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_east_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork West Grows To 10x10 From Fork South
function default.dt_palm_fork_west_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_west_grows_to_10x10_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork East
-- Main Trunk Grows To 10x10 From Fork East
function default.dt_palm_main_trunk_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork North Grows To 10x10 From Fork East
function default.dt_palm_fork_north_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_north_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork South Grows To 10x10 From Fork East
function default.dt_palm_fork_south_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_south_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork West Grows To 10x10 From Fork East
function default.dt_palm_fork_west_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_west_grows_to_10x10_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork West
-- Main Trunk Grows To 10x10 From Fork West
function default.dt_palm_main_trunk_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork North Grows To 10x10 From Fork West
function default.dt_palm_fork_north_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_north_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork South Grows To 10x10 From Fork West
function default.dt_palm_fork_south_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_south_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork East Grows To 10x10 From Fork West
function default.dt_palm_fork_east_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_fork_east_grows_to_10x10_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Base
-- Main Trunk Grows To 8x8 From Base
function default.dt_palm_main_trunk_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_base(...)
	end
})

-- Fork North Grows To 8x8 From Base
function default.dt_palm_fork_north_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_north_grows_to_8x8_from_base(...)
	end
})

-- Fork South Grows To 8x8 From Base
function default.dt_palm_fork_south_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_south_grows_to_8x8_from_base(...)
	end
})

-- Fork East Grows To 8x8 From Base
function default.dt_palm_fork_east_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_east_grows_to_8x8_from_base(...)
	end
})

-- Fork West Grows To 8x8 From Base
function default.dt_palm_fork_west_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_west_grows_to_8x8_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Main Trunk
-- Main Trunk Grows To 8x8 From Main Trunk
function default.dt_palm_main_trunk_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork North Grows To 8x8 From Main Trunk
function default.dt_palm_fork_north_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_north_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork South Grows To 8x8 From Main Trunk
function default.dt_palm_fork_south_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_south_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork East Grows To 8x8 From Main Trunk
function default.dt_palm_fork_east_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_east_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork West Grows To 8x8 From Main Trunk
function default.dt_palm_fork_west_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_west_grows_to_8x8_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork North
-- Main Trunk Grows To 8x8 From Fork North
function default.dt_palm_main_trunk_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork South Grows To 8x8 From Fork North
function default.dt_palm_fork_south_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_south_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork East Grows To 8x8 From Fork North
function default.dt_palm_fork_east_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_east_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork West Grows To 8x8 From Fork North
function default.dt_palm_fork_west_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_west_grows_to_8x8_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork South
-- Main Trunk Grows To 8x8 From Fork South
function default.dt_palm_main_trunk_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork North Grows To 8x8 From Fork South
function default.dt_palm_fork_north_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_north_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork East Grows To 8x8 From Fork South
function default.dt_palm_fork_east_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_east_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork West Grows To 8x8 From Fork South
function default.dt_palm_fork_west_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_west_grows_to_8x8_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork East
-- Main Trunk Grows To 8x8 From Fork East
function default.dt_palm_main_trunk_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork North Grows To 8x8 From Fork East
function default.dt_palm_fork_north_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_north_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork South Grows To 8x8 From Fork East
function default.dt_palm_fork_south_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_south_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork West Grows To 8x8 From Fork East
function default.dt_palm_fork_west_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_west_grows_to_8x8_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork West
-- Main Trunk Grows To 8x8 From Fork West
function default.dt_palm_main_trunk_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork North Grows To 8x8 From Fork West
function default.dt_palm_fork_north_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_north_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork South Grows To 8x8 From Fork West
function default.dt_palm_fork_south_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_south_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork East Grows To 8x8 From Fork West
function default.dt_palm_fork_east_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_fork_east_grows_to_8x8_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Base
-- Main Trunk Grows To 6x6 From Base
function default.dt_palm_main_trunk_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_base(...)
	end
})

-- Fork North Grows To 6x6 From Base
function default.dt_palm_fork_north_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_6x6_from_base(...)
	end
})

-- Fork South Grows To 6x6 From Base
function default.dt_palm_fork_south_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_6x6_from_base(...)
	end
})

-- Fork East Grows To 6x6 From Base
function default.dt_palm_fork_east_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_6x6_from_base(...)
	end
})

-- Fork West Grows To 6x6 From Base
function default.dt_palm_fork_west_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_6x6_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Main Trunk
-- Main Trunk Grows To 6x6 From Main Trunk
function default.dt_palm_main_trunk_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork North Grows To 6x6 From Main Trunk
function default.dt_palm_fork_north_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork South Grows To 6x6 From Main Trunk
function default.dt_palm_fork_south_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork East Grows To 6x6 From Main Trunk
function default.dt_palm_fork_east_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork West Grows To 6x6 From Main Trunk
function default.dt_palm_fork_west_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_6x6_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork North
-- Main Trunk Grows To 6x6 From Fork North
function default.dt_palm_main_trunk_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork South Grows To 6x6 From Fork North
function default.dt_palm_fork_south_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork East Grows To 6x6 From Fork North
function default.dt_palm_fork_east_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork West Grows To 6x6 From Fork North
function default.dt_palm_fork_west_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_6x6_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork South
-- Main Trunk Grows To 6x6 From Fork South
function default.dt_palm_main_trunk_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork North Grows To 6x6 From Fork South
function default.dt_palm_fork_north_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork East Grows To 6x6 From Fork South
function default.dt_palm_fork_east_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork West Grows To 6x6 From Fork South
function default.dt_palm_fork_west_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_6x6_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork East
-- Main Trunk Grows To 6x6 From Fork East
function default.dt_palm_main_trunk_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork North Grows To 6x6 From Fork East
function default.dt_palm_fork_north_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork South Grows To 6x6 From Fork East
function default.dt_palm_fork_south_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork West Grows To 6x6 From Fork East
function default.dt_palm_fork_west_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_6x6_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork West
-- Main Trunk Grows To 6x6 From Fork West
function default.dt_palm_main_trunk_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork North Grows To 6x6 From Fork West
function default.dt_palm_fork_north_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork South Grows To 6x6 From Fork West
function default.dt_palm_fork_south_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork East Grows To 6x6 From Fork West
function default.dt_palm_fork_east_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_6x6_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Base
-- Main Trunk Grows To 4x4 From Base
function default.dt_palm_main_trunk_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_base(...)
	end
})

-- Fork North Grows To 4x4 From Base
function default.dt_palm_fork_north_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_4x4_from_base(...)
	end
})

-- Fork South Grows To 4x4 From Base
function default.dt_palm_fork_south_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_4x4_from_base(...)
	end
})

-- Fork East Grows To 4x4 From Base
function default.dt_palm_fork_east_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_4x4_from_base(...)
	end
})

-- Fork West Grows To 4x4 From Base
function default.dt_palm_fork_west_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_4x4_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Main Trunk
-- Main Trunk Grows To 4x4 From Main Trunk
function default.dt_palm_main_trunk_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork North Grows To 4x4 From Main Trunk
function default.dt_palm_fork_north_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork South Grows To 4x4 From Main Trunk
function default.dt_palm_fork_south_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork East Grows To 4x4 From Main Trunk
function default.dt_palm_fork_east_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork West Grows To 4x4 From Main Trunk
function default.dt_palm_fork_west_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_4x4_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork North
-- Main Trunk Grows To 4x4 From Fork North
function default.dt_palm_main_trunk_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork South Grows To 4x4 From Fork North
function default.dt_palm_fork_south_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork East Grows To 4x4 From Fork North
function default.dt_palm_fork_east_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork West Grows To 4x4 From Fork North
function default.dt_palm_fork_west_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_4x4_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork South
-- Main Trunk Grows To 4x4 From Fork South
function default.dt_palm_main_trunk_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork North Grows To 4x4 From Fork South
function default.dt_palm_fork_north_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork East Grows To 4x4 From Fork South
function default.dt_palm_fork_east_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork West Grows To 4x4 From Fork South
function default.dt_palm_fork_west_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_4x4_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork East
-- Main Trunk Grows To 4x4 From Fork East
function default.dt_palm_main_trunk_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork North Grows To 4x4 From Fork East
function default.dt_palm_fork_north_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork South Grows To 4x4 From Fork East
function default.dt_palm_fork_south_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork West Grows To 4x4 From Fork East
function default.dt_palm_fork_west_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_grows_to_4x4_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork West
-- Main Trunk Grows To 4x4 From Fork West
function default.dt_palm_main_trunk_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Main Trunk Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_main_trunk_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork North Grows To 4x4 From Fork West
function default.dt_palm_fork_north_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork South Grows To 4x4 From Fork West
function default.dt_palm_fork_south_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork East Grows To 4x4 From Fork West
function default.dt_palm_fork_east_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_grows_to_4x4_from_fork_west(...)
	end
})

-- North Facing Node Placement
-- Fork North 4x4 Grows 2x2 Elbow North
function default.dt_palm_fork_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Bend North
function default.dt_palm_elbow_north_4x4_grows_2x2_bend_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North 4x4 Grows 2x2 Bend North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_elbow_north_4x4_grows_2x2_bend_north(...)
	end
})

-- Bend North 4x4 Grows 2x2 Elbow North
function default.dt_palm_bend_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:palm_tree_bend_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- South Facing Node Placement
-- Fork South 4x4 Grows 2x2 Elbow South
function default.dt_palm_fork_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Bend South
function default.dt_palm_elbow_south_4x4_grows_2x2_bend_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South 4x4 Grows 2x2 Bend South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_elbow_south_4x4_grows_2x2_bend_south(...)
	end
})

-- Bend South 4x4 Grows 2x2 Elbow South
function default.dt_palm_bend_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:palm_tree_bend_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- East Facing Node Placement
-- Fork East 4x4 Grows 2x2 Elbow East
function default.dt_palm_fork_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Bend East
function default.dt_palm_elbow_east_4x4_grows_2x2_bend_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East 4x4 Grows 2x2 Bend East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_elbow_east_4x4_grows_2x2_bend_east(...)
	end
})

-- Bend East 4x4 Grows 2x2 Elbow East
function default.dt_palm_bend_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:palm_tree_bend_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- West Facing Node Placement
-- Fork West 4x4 Grows 2x2 Elbow West
function default.dt_palm_fork_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Fork West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_fork_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Bend West
function default.dt_palm_elbow_west_4x4_grows_2x2_bend_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West 4x4 Grows 2x2 Bend West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_palm_elbow_west_4x4_grows_2x2_bend_west(...)
	end
})

-- Bend West 4x4 Grows 2x2 Elbow West
function default.dt_palm_bend_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:palm_tree_bend_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 14x14 From Fork North
function default.dt_palm_elbow_north_grows_to_14x14_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_16x16" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 14x14 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_14x14_from_fork_north(...)
	end
})

-- Elbow North Grows To 12x12 From Fork North
function default.dt_palm_elbow_north_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_12x12_from_fork_north(...)
	end
})

-- Elbow North Grows To 10x10 From Fork North
function default.dt_palm_elbow_north_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_10x10_from_fork_north(...)
	end
})

-- Elbow North Grows To 8x8 From Fork North
function default.dt_palm_elbow_north_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_8x8_from_fork_north(...)
	end
})

-- Elbow North Grows To 6x6 From Fork North
function default.dt_palm_elbow_north_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_6x6_from_fork_north(...)
	end
})

-- Elbow North Grows To 4x4 From Fork North
function default.dt_palm_elbow_north_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:palm_tree_fork_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_4x4_from_fork_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 14x14 From Fork South
function default.dt_palm_elbow_south_grows_to_14x14_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_16x16" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 14x14 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_14x14_from_fork_south(...)
	end
})

-- Elbow South Grows To 12x12 From Fork South
function default.dt_palm_elbow_south_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_12x12_from_fork_south(...)
	end
})

-- Elbow South Grows To 10x10 From Fork South
function default.dt_palm_elbow_south_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_10x10_from_fork_south(...)
	end
})

-- Elbow South Grows To 8x8 From Fork South
function default.dt_palm_elbow_south_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_8x8_from_fork_south(...)
	end
})

-- Elbow South Grows To 6x6 From Fork South
function default.dt_palm_elbow_south_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_6x6_from_fork_south(...)
	end
})

-- Elbow South Grows To 4x4 From Fork South
function default.dt_palm_elbow_south_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:palm_tree_fork_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_4x4_from_fork_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 14x14 From Fork East
function default.dt_palm_elbow_east_grows_to_14x14_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_16x16" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 14x14 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_14x14_from_fork_east(...)
	end
})

-- Elbow East Grows To 12x12 From Fork East
function default.dt_palm_elbow_east_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_12x12_from_fork_east(...)
	end
})

-- Elbow East Grows To 10x10 From Fork East
function default.dt_palm_elbow_east_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_10x10_from_fork_east(...)
	end
})

-- Elbow East Grows To 8x8 From Fork East
function default.dt_palm_elbow_east_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_8x8_from_fork_east(...)
	end
})

-- Elbow East Grows To 6x6 From Fork East
function default.dt_palm_elbow_east_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_6x6_from_fork_east(...)
	end
})

-- Elbow East Grows To 4x4 From Fork East
function default.dt_palm_elbow_east_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:palm_tree_fork_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_4x4_from_fork_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 14x14 From Fork West
function default.dt_palm_elbow_west_grows_to_14x14_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_16x16" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 14x14 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_14x14_from_fork_west(...)
	end
})

-- Elbow West Grows To 12x12 From Fork West
function default.dt_palm_elbow_west_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_12x12_from_fork_west(...)
	end
})

-- Elbow West Grows To 10x10 From Fork West
function default.dt_palm_elbow_west_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_10x10_from_fork_west(...)
	end
})

-- Elbow West Grows To 8x8 From Fork West
function default.dt_palm_elbow_west_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_8x8_from_fork_west(...)
	end
})

-- Elbow West Grows To 6x6 From Fork West
function default.dt_palm_elbow_west_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_6x6_from_fork_west(...)
	end
})

-- Elbow West Grows To 4x4 From Fork West
function default.dt_palm_elbow_west_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:palm_tree_fork_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_4x4_from_fork_west(...)
	end
})

-- North Bend Growth
-- Bend North Grows To 12x12 From Elbow North
function default.dt_palm_bend_north_grows_to_12x12_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North Grows To 12x12 From Elbow North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_bend_north_grows_to_12x12_from_elbow_north(...)
	end
})

-- Bend North Grows To 10x10 From Elbow North
function default.dt_palm_bend_north_grows_to_10x10_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North Grows To 10x10 From Elbow North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_bend_north_grows_to_10x10_from_elbow_north(...)
	end
})

-- Bend North Grows To 8x8 From Elbow North
function default.dt_palm_bend_north_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_bend_north_grows_to_8x8_from_elbow_north(...)
	end
})

-- Bend North Grows To 6x6 From Elbow North
function default.dt_palm_bend_north_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_bend_north_grows_to_6x6_from_elbow_north(...)
	end
})

-- Bend North Grows To 4x4 From Elbow North
function default.dt_palm_bend_north_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend North Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_north_grows_to_4x4_from_elbow_north(...)
	end
})

-- South Bend Growth
-- Bend South Grows To 12x12 From Elbow South
function default.dt_palm_bend_south_grows_to_12x12_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South Grows To 12x12 From Elbow South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_bend_south_grows_to_12x12_from_elbow_south(...)
	end
})

-- Bend South Grows To 10x10 From Elbow South
function default.dt_palm_bend_south_grows_to_10x10_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South Grows To 10x10 From Elbow South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_bend_south_grows_to_10x10_from_elbow_south(...)
	end
})

-- Bend South Grows To 8x8 From Elbow South
function default.dt_palm_bend_south_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_bend_south_grows_to_8x8_from_elbow_south(...)
	end
})

-- Bend South Grows To 6x6 From Elbow South
function default.dt_palm_bend_south_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_bend_south_grows_to_6x6_from_elbow_south(...)
	end
})

-- Bend South Grows To 4x4 From Elbow South
function default.dt_palm_bend_south_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend South Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_south_grows_to_4x4_from_elbow_south(...)
	end
})

-- East Bend Growth
-- Bend East Grows To 12x12 From Elbow East
function default.dt_palm_bend_east_grows_to_12x12_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East Grows To 12x12 From Elbow East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_bend_east_grows_to_12x12_from_elbow_east(...)
	end
})

-- Bend East Grows To 10x10 From Elbow East
function default.dt_palm_bend_east_grows_to_10x10_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East Grows To 10x10 From Elbow East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_bend_east_grows_to_10x10_from_elbow_east(...)
	end
})

-- Bend East Grows To 8x8 From Elbow East
function default.dt_palm_bend_east_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_bend_east_grows_to_8x8_from_elbow_east(...)
	end
})

-- Bend East Grows To 6x6 From Elbow East
function default.dt_palm_bend_east_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_bend_east_grows_to_6x6_from_elbow_east(...)
	end
})

-- Bend East Grows To 4x4 From Elbow East
function default.dt_palm_bend_east_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend East Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_east_grows_to_4x4_from_elbow_east(...)
	end
})

-- West Bend Growth
-- Bend West Grows To 12x12 From Elbow West
function default.dt_palm_bend_west_grows_to_12x12_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West Grows To 12x12 From Elbow West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_palm_bend_west_grows_to_12x12_from_elbow_west(...)
	end
})

-- Bend West Grows To 10x10 From Elbow West
function default.dt_palm_bend_west_grows_to_10x10_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West Grows To 10x10 From Elbow West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_bend_west_grows_to_10x10_from_elbow_west(...)
	end
})

-- Bend West Grows To 8x8 From Elbow West
function default.dt_palm_bend_west_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_bend_west_grows_to_8x8_from_elbow_west(...)
	end
})

-- Bend West Grows To 6x6 From Elbow West
function default.dt_palm_bend_west_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_bend_west_grows_to_6x6_from_elbow_west(...)
	end
})

-- Bend West Grows To 4x4 From Elbow West
function default.dt_palm_bend_west_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_bend_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_bend_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Bend West Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_bend_west_grows_to_4x4_from_elbow_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 10x10 From Bend North
function default.dt_palm_elbow_north_grows_to_10x10_from_bend_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 10x10 From Bend North",
	nodenames = {"dynamic_trees:palm_tree_bend_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_10x10_from_bend_north(...)
	end
})

-- Elbow North Grows To 8x8 From Bend North
function default.dt_palm_elbow_north_grows_to_8x8_from_bend_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 8x8 From Bend North",
	nodenames = {"dynamic_trees:palm_tree_bend_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_8x8_from_bend_north(...)
	end
})

-- Elbow North Grows To 6x6 From Bend North
function default.dt_palm_elbow_north_grows_to_6x6_from_bend_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 6x6 From Bend North",
	nodenames = {"dynamic_trees:palm_tree_bend_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_6x6_from_bend_north(...)
	end
})

-- Elbow North Grows To 4x4 From Bend North
function default.dt_palm_elbow_north_grows_to_4x4_from_bend_north(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow North Grows To 4x4 From Bend North",
	nodenames = {"dynamic_trees:palm_tree_bend_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_north_grows_to_4x4_from_bend_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 10x10 From Bend South
function default.dt_palm_elbow_south_grows_to_10x10_from_bend_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 10x10 From Bend South",
	nodenames = {"dynamic_trees:palm_tree_bend_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_10x10_from_bend_south(...)
	end
})

-- Elbow South Grows To 8x8 From Bend South
function default.dt_palm_elbow_south_grows_to_8x8_from_bend_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 8x8 From Bend South",
	nodenames = {"dynamic_trees:palm_tree_bend_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_8x8_from_bend_south(...)
	end
})

-- Elbow South Grows To 6x6 From Bend South
function default.dt_palm_elbow_south_grows_to_6x6_from_bend_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 6x6 From Bend South",
	nodenames = {"dynamic_trees:palm_tree_bend_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_6x6_from_bend_south(...)
	end
})

-- Elbow South Grows To 4x4 From Bend South
function default.dt_palm_elbow_south_grows_to_4x4_from_bend_south(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow South Grows To 4x4 From Bend South",
	nodenames = {"dynamic_trees:palm_tree_bend_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_south_grows_to_4x4_from_bend_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 10x10 From Bend East
function default.dt_palm_elbow_east_grows_to_10x10_from_bend_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 10x10 From Bend East",
	nodenames = {"dynamic_trees:palm_tree_bend_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_10x10_from_bend_east(...)
	end
})

-- Elbow East Grows To 8x8 From Bend East
function default.dt_palm_elbow_east_grows_to_8x8_from_bend_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 8x8 From Bend East",
	nodenames = {"dynamic_trees:palm_tree_bend_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_8x8_from_bend_east(...)
	end
})

-- Elbow East Grows To 6x6 From Bend East
function default.dt_palm_elbow_east_grows_to_6x6_from_bend_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 6x6 From Bend East",
	nodenames = {"dynamic_trees:palm_tree_bend_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_6x6_from_bend_east(...)
	end
})

-- Elbow East Grows To 4x4 From Bend East
function default.dt_palm_elbow_east_grows_to_4x4_from_bend_east(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow East Grows To 4x4 From Bend East",
	nodenames = {"dynamic_trees:palm_tree_bend_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_east_grows_to_4x4_from_bend_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 10x10 From Bend West
function default.dt_palm_elbow_west_grows_to_10x10_from_bend_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 10x10 From Bend West",
	nodenames = {"dynamic_trees:palm_tree_bend_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_10x10_from_bend_west(...)
	end
})

-- Elbow West Grows To 8x8 From Bend West
function default.dt_palm_elbow_west_grows_to_8x8_from_bend_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 8x8 From Bend West",
	nodenames = {"dynamic_trees:palm_tree_bend_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_8x8_from_bend_west(...)
	end
})

-- Elbow West Grows To 6x6 From Bend West
function default.dt_palm_elbow_west_grows_to_6x6_from_bend_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 6x6 From Bend West",
	nodenames = {"dynamic_trees:palm_tree_bend_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_6x6_from_bend_west(...)
	end
})

-- Elbow West Grows To 4x4 From Bend West
function default.dt_palm_elbow_west_grows_to_4x4_from_bend_west(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT palm Elbow West Grows To 4x4 From Bend West",
	nodenames = {"dynamic_trees:palm_tree_bend_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_palm_elbow_west_grows_to_4x4_from_bend_west(...)
	end
})

-- Leaves Growth
-- Canopy Base Will Spawn Above And Around The 2x2 Nodes Of The Tree
-- This Spawns Canopy Base Above Main Trunk 2x2
function default.dt_palm_canopy_base_above_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Main Trunk 2x2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -x Main Trunk 2x2
function default.dt_palm_canopy_base_minus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +x Main Trunk 2x2
function default.dt_palm_canopy_base_plus_x_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Main Trunk 2x2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base -z Main Trunk 2x2
function default.dt_palm_canopy_base_minus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base +z Main Trunk 2x2
function default.dt_palm_canopy_base_plus_z_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_main_trunk_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Main Trunk 2x2",
	nodenames = {"dynamic_trees:palm_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_main_trunk_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork North 2x2
function default.dt_palm_canopy_base_above_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Fork North 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork North 2x2
function default.dt_palm_canopy_base_minus_x_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Fork North 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork North 2x2
function default.dt_palm_canopy_base_plus_x_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Fork North 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork North 2x2
function default.dt_palm_canopy_base_minus_z_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Fork North 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork North 2x2
function default.dt_palm_canopy_base_plus_z_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Fork North 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_fork_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork South 2x2
function default.dt_palm_canopy_base_above_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Fork South 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork South 2x2
function default.dt_palm_canopy_base_minus_x_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Fork South 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork South 2x2
function default.dt_palm_canopy_base_plus_x_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Fork South 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork South 2x2
function default.dt_palm_canopy_base_minus_z_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Fork South 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork South 2x2
function default.dt_palm_canopy_base_plus_z_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_south_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Fork South 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_fork_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork East 2x2
function default.dt_palm_canopy_base_above_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Fork East 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork East 2x2
function default.dt_palm_canopy_base_minus_x_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Fork East 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork East 2x2
function default.dt_palm_canopy_base_plus_x_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Fork East 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork East 2x2
function default.dt_palm_canopy_base_minus_z_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Fork East 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork East 2x2
function default.dt_palm_canopy_base_plus_z_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Fork East 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_fork_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Fork West 2x2
function default.dt_palm_canopy_base_above_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Fork West 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Fork West 2x2
function default.dt_palm_canopy_base_minus_x_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Fork West 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base +x Fork West 2x2
function default.dt_palm_canopy_base_plus_x_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Fork West 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Fork West 2x2
function default.dt_palm_canopy_base_minus_z_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Fork West 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Fork West 2x2
function default.dt_palm_canopy_base_plus_z_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_fork_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Fork West 2x2",
	nodenames = {"dynamic_trees:palm_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_fork_west_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow North 2x2
function default.dt_palm_canopy_base_above_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Elbow North 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow North 2x2
function default.dt_palm_canopy_base_minus_x_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Elbow North 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow North 2x2
function default.dt_palm_canopy_base_plus_x_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Elbow North 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow North 2x2
function default.dt_palm_canopy_base_plus_z_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Elbow North 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_elbow_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow South 2x2
function default.dt_palm_canopy_base_above_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Elbow South 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow South 2x2
function default.dt_palm_canopy_base_minus_x_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Elbow South 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow South 2x2
function default.dt_palm_canopy_base_plus_x_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Elbow South 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow South 2x2
function default.dt_palm_canopy_base_minus_z_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Elbow South 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_elbow_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow East 2x2
function default.dt_palm_canopy_base_above_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Elbow East 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Elbow East 2x2
function default.dt_palm_canopy_base_plus_x_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Elbow East 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow East 2x2
function default.dt_palm_canopy_base_minus_z_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Elbow East 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow East 2x2
function default.dt_palm_canopy_base_plus_z_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Elbow East 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_elbow_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Elbow West 2x2
function default.dt_palm_canopy_base_above_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Elbow West 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Elbow West 2x2
function default.dt_palm_canopy_base_minus_x_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Elbow West 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Elbow West 2x2
function default.dt_palm_canopy_base_minus_z_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Elbow West 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Elbow West 2x2
function default.dt_palm_canopy_base_plus_z_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_elbow_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Elbow West 2x2",
	nodenames = {"dynamic_trees:palm_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_elbow_west_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend North 2x2
function default.dt_palm_canopy_base_above_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Bend North 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend North 2x2
function default.dt_palm_canopy_base_minus_x_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Bend North 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend North 2x2
function default.dt_palm_canopy_base_plus_x_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Bend North 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend North 2x2
function default.dt_palm_canopy_base_plus_z_bend_north_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_north_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Bend North 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_bend_north_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend South 2x2
function default.dt_palm_canopy_base_above_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Bend South 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend South 2x2
function default.dt_palm_canopy_base_minus_x_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Bend South 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend South 2x2
function default.dt_palm_canopy_base_plus_x_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Bend South 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend South 2x2
function default.dt_palm_canopy_base_minus_z_bend_south_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_south_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Bend South 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_bend_south_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend East 2x2
function default.dt_palm_canopy_base_above_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Bend East 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base +x Bend East 2x2
function default.dt_palm_canopy_base_plus_x_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_2x2" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus X Bend East 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_x_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend East 2x2
function default.dt_palm_canopy_base_minus_z_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Bend East 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend East 2x2
function default.dt_palm_canopy_base_plus_z_bend_east_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_east_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Bend East 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_bend_east_2x2(...)
	end
})

-- This Spawns Canopy Base Above Bend West 2x2
function default.dt_palm_canopy_base_above_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Above Bend West 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_above_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base -x Bend West 2x2
function default.dt_palm_canopy_base_minus_x_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_2x2" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus X Bend West 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_x_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base -z Bend West 2x2
function default.dt_palm_canopy_base_minus_z_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_2x2" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Minus Z Bend West 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_minus_z_bend_west_2x2(...)
	end
})

-- This Spawns Canopy Base +z Bend West 2x2
function default.dt_palm_canopy_base_plus_z_bend_west_2x2(pos, node)
	while node.name == "dynamic_trees:palm_tree_bend_west_2x2" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_base"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy Base Plus Z Bend West 2x2",
	nodenames = {"dynamic_trees:palm_tree_bend_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_base_plus_z_bend_west_2x2(...)
	end
})

-- Canopy 1 Will Spawn Above And Around Canopy Base
-- This Spawns Canopy 1 Above Canopy Base
function default.dt_palm_canopy_1_above_canopy_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 1 Above Canopy Base",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_1_above_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -x Canopy Base
function default.dt_palm_canopy_1_minus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 1 Minus X Canopy Base",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_1_minus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +x Canopy Base
function default.dt_palm_canopy_1_plus_x_canopy_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 1 Plus X Canopy Base",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_1_plus_x_canopy_base(...)
	end
})

-- This Spawns Canopy 1 -z Canopy Base
function default.dt_palm_canopy_1_minus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 1 Minus Z Canopy Base",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_1_minus_z_canopy_base(...)
	end
})

-- This Spawns Canopy 1 +z Canopy Base
function default.dt_palm_canopy_1_plus_z_canopy_base(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_base" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_1"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 1 Plus Z Canopy Base",
	nodenames = {"dynamic_trees:palm_tree_canopy_base"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_palm_canopy_1_plus_z_canopy_base(...)
	end
})

-- Canopy 2 Will Spawn Around Canopy 1
-- This Spawns Canopy 2 -x Canopy 1
function default.dt_palm_canopy_2_minus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_1" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 2 Minus X Canopy 1",
	nodenames = {"dynamic_trees:palm_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_canopy_2_minus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +x Canopy 1
function default.dt_palm_canopy_2_plus_x_canopy_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_1" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 2 Plus X Canopy 1",
	nodenames = {"dynamic_trees:palm_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_canopy_2_plus_x_canopy_1(...)
	end
})

-- This Spawns Canopy 2 -z Canopy 1
function default.dt_palm_canopy_2_minus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_1" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 2 Minus Z Canopy 1",
	nodenames = {"dynamic_trees:palm_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_canopy_2_minus_z_canopy_1(...)
	end
})

-- This Spawns Canopy 2 +z Canopy 1
function default.dt_palm_canopy_2_plus_z_canopy_1(pos, node)
	while node.name == "dynamic_trees:palm_tree_canopy_1" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:palm_tree_canopy_2"})
	return true
end

minetest.register_abm({
	label = "DT palm Canopy 2 Plus Z Canopy 1",
	nodenames = {"dynamic_trees:palm_tree_canopy_1"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_palm_canopy_2_plus_z_canopy_1(...)
	end
})

-- Leaf Decay
-- This Is To Decay Any Leaves From The Bottom Or Top Using Air To Do So
-- The Reason Is To Allow For The Tree To Lose Excess Leaves
-- palm Leaves Decay Bottom
function default.dt_palm_leaves_decay_bottom(pos, node)
	while node.name == "air" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay Bottom",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_bottom(...)
	end
})

-- palm Leaves Decay Top
function default.dt_palm_leaves_decay_top(pos, node)
	while node.name == "air" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay Top",
	nodenames = {"air"},
	interval = 10,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_top(...)
	end
})

-- palm Leaves Decay North
function default.dt_palm_leaves_decay_north(pos, node)
	while node.name == "air" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay North",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_north(...)
	end
})

-- palm Leaves Decay South
function default.dt_palm_leaves_decay_south(pos, node)
	while node.name == "air" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay South",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_south(...)
	end
})

-- palm Leaves Decay East
function default.dt_palm_leaves_decay_east(pos, node)
	while node.name == "air" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay East",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_east(...)
	end
})

-- palm Leaves Decay West
function default.dt_palm_leaves_decay_west(pos, node)
	while node.name == "air" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:palm_tree_canopy_base" and node.name ~= "dynamic_trees:palm_tree_canopy_1"
	and node.name ~= "dynamic_trees:palm_tree_canopy_2" then
		return
	end
	minetest.set_node(pos, {name = "air"})
	return true
end

minetest.register_abm({
	label = "DT palm Leaves Decay West",
	nodenames = {"air"},
	interval = 15,
	chance = 2000,
	action = function(...)
		default.dt_palm_leaves_decay_west(...)
	end
})