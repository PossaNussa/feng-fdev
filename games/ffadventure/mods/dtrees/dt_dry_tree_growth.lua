-- dynamic_trees/dt_dry_tree_growth.lua

-- This Is Where The Dynamic Dry Tree Growth Behavior Is

-- Tree Growth Starts Here With The Sapling
-- Sapling Growing A Canopy Base
function default.dt_dry_canopy_base_on_sapling(pos, node)
	while node.name == "dynamic_trees:dry_tree_sapling" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Canopy Base On Sapling",
	nodenames = {"dynamic_trees:dry_tree_sapling"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_canopy_base_on_sapling(...)
	end
})

-- This Spawns A Base Trunk That The Tree Will Grow From
function default.dt_dry_main_trunk_base_2x2_replace_sapling(pos, node)
	while node.name == "default:dry_shrub" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_sapling" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Replace Sapling",
	nodenames = {"default:dry_shrub"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_replace_sapling(...)
	end
})


-- The Main Trunk Base Grows On It's Own Accord
-- The Rest Of The Tree Will Grow With It
-- Main Trunk Base Grows To 16x16
function default.dt_dry_main_trunk_base_grows_to_16x16(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_14x14" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_16x16"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 16x16",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 105,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_16x16(...)
	end
})

-- Main Trunk Base Grows To 14x14
function default.dt_dry_main_trunk_base_grows_to_14x14(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 90,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_14x14(...)
	end
})

-- Main Trunk Base Grows To 12x12
function default.dt_dry_main_trunk_base_grows_to_12x12(pos, node)
	while node.name ==  "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 75,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_12x12(...)
	end
})

-- Main Trunk Base Grows To 10x10
function default.dt_dry_main_trunk_base_grows_to_10x10(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 10x10",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 60,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_10x10(...)
	end
})

-- Main Trunk Base Grows To 8x8
function default.dt_dry_main_trunk_base_grows_to_8x8(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 8x8",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 45,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_8x8(...)
	end
})

-- Main Trunk Base Grows To 6x6
function default.dt_dry_main_trunk_base_grows_to_6x6(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base grows to 6x6",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_6x6(...)
	end
})

-- Main Trunk Base Grows To 4x4
function default.dt_dry_main_trunk_base_grows_to_4x4(pos, node)
	while node.name == "soil" and node.name ~= "sand" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_base_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_base_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base Grows To 4x4",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_base_grows_to_4x4(...)
	end
})

-- This Is Where The New Growth Is Handled
-- Main Trunk Base 2x2 Grows 2x2 Trunk
function default.dt_dry_main_trunk_base_2x2_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork North
function default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork South
function default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork East
function default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 2x2 Grows 2x2 Fork West
function default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 2x2 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_2x2"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_base_2x2_grows_2x2_fork_west(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Trunk
function default.dt_dry_main_trunk_base_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_base_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork North
function default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork South
function default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork East
function default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk Base 4x4 Grows 2x2 Fork West
function default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Base 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_base_4x4_grows_2x2_fork_west(...)
	end
})





-- Main Trunk 4x4 Grows 2x2 Trunk
function default.dt_dry_main_trunk_4x4_grows_2x2_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk 4x4 Grows 2x2 Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_4x4_grows_2x2_trunk(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork North
function default.dt_dry_main_trunk_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_4x4_grows_2x2_fork_north(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork South
function default.dt_dry_main_trunk_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_4x4_grows_2x2_fork_south(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork East
function default.dt_dry_main_trunk_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_4x4_grows_2x2_fork_east(...)
	end
})

-- Main Trunk 4x4 Grows 2x2 Fork West
function default.dt_dry_main_trunk_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork North 4x4 Grows 2x2 Main Trunk
function default.dt_dry_fork_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_fork_north_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork South
function default.dt_dry_fork_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_north_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork East
function default.dt_dry_fork_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_north_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork North 4x4 Grows 2x2 Fork West
function default.dt_dry_fork_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_north_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_north_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork South 4x4 Grows 2x2 Main Trunk
function default.dt_dry_fork_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_fork_south_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork North
function default.dt_dry_fork_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_south_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork East
function default.dt_dry_fork_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_south_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Fork South 4x4 Grows 2x2 Fork West
function default.dt_dry_fork_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_south_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_south_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork East 4x4 Grows 2x2 Main Trunk
function default.dt_dry_fork_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_fork_east_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork North
function default.dt_dry_fork_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_east_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork South
function default.dt_dry_fork_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_east_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork East 4x4 Grows 2x2 Fork West
function default.dt_dry_fork_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_east_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_east_4x4_grows_2x2_fork_west(...)
	end
})

-- Fork West 4x4 Grows 2x2 Main Trunk
function default.dt_dry_fork_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_fork_west_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork North
function default.dt_dry_fork_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_west_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork South
function default.dt_dry_fork_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_west_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Fork West 4x4 Grows 2x2 Fork East
function default.dt_dry_fork_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_west_4x4"},
	interval = 10,
	chance = 4,
	action = function(...)
		default.dt_dry_fork_west_4x4_grows_2x2_fork_east(...)
	end
})

-- This Is Where The Rest Of The Tree Checks If It Should Be Growing

-- This Section Is For All The Nodes That Will Grow To 14x14 From The Tree Base
-- Main Trunk Grows To 14x14
function default.dt_dry_main_trunk_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_14x14(...)
	end
})

-- Fork North Grows To 14x14
function default.dt_dry_fork_north_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_fork_north_grows_to_14x14(...)
	end
})

-- Fork South Grows To 14x14
function default.dt_dry_fork_south_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_fork_south_grows_to_14x14(...)
	end
})

-- Fork East Grows To 14x14
function default.dt_dry_fork_east_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_fork_east_grows_to_14x14(...)
	end
})

-- Fork West Grows To 14x14
function default.dt_dry_fork_west_grows_to_14x14(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_16x16" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_12x12" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_14x14"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 14x14",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_16x16"},
	interval = 10,
	chance = 30,
	action = function(...)
		default.dt_dry_fork_west_grows_to_14x14(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Tree Base
-- Main Trunk Grows To 12x12 From Base
function default.dt_dry_main_trunk_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_base(...)
	end
})

-- Fork North Grows To 12x12 From Base
function default.dt_dry_fork_north_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_north_grows_to_12x12_from_base(...)
	end
})

-- Fork South Grows To 12x12 From Base
function default.dt_dry_fork_south_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_south_grows_to_12x12_from_base(...)
	end
})

-- Fork East Grows To 12x12 From Base
function default.dt_dry_fork_east_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_east_grows_to_12x12_from_base(...)
	end
})

-- Fork West Grows To 12x12 From Base
function default.dt_dry_fork_west_grows_to_12x12_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 12x12",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_west_grows_to_12x12_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Main Trunk
-- Main Trunk Grows To 12x12 From Main Trunk
function default.dt_dry_main_trunk_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork North Grows To 12x12 From Main Trunk
function default.dt_dry_fork_north_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_north_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork South Grows To 12x12 From Main Trunk
function default.dt_dry_fork_south_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_south_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork East Grows To 12x12 From Main Trunk
function default.dt_dry_fork_east_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_east_grows_to_12x12_from_main_trunk(...)
	end
})

-- Fork West Grows To 12x12 From Main Trunk
function default.dt_dry_fork_west_grows_to_12x12_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 12x12 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_west_grows_to_12x12_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork North
-- Main Trunk Grows To 12x12 From Fork North
function default.dt_dry_main_trunk_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork South Grows To 12x12 From Fork North
function default.dt_dry_fork_south_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_south_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork East Grows To 12x12 From Fork North
function default.dt_dry_fork_east_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_east_grows_to_12x12_from_fork_north(...)
	end
})

-- Fork West Grows To 12x12 From Fork North
function default.dt_dry_fork_west_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_west_grows_to_12x12_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork South
-- Main Trunk Grows To 12x12 From Fork South
function default.dt_dry_main_trunk_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork North Grows To 12x12 From Fork South
function default.dt_dry_fork_north_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_north_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork East Grows To 12x12 From Fork South
function default.dt_dry_fork_east_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_east_grows_to_12x12_from_fork_south(...)
	end
})

-- Fork West Grows To 12x12 From Fork South
function default.dt_dry_fork_west_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_west_grows_to_12x12_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork East
-- Main Trunk Grows To 12x12 From Fork East
function default.dt_dry_main_trunk_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork North Grows To 12x12 From Fork East
function default.dt_dry_fork_north_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_north_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork South Grows To 12x12 From Fork East
function default.dt_dry_fork_south_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_south_grows_to_12x12_from_fork_east(...)
	end
})

-- Fork West Grows To 12x12 From Fork East
function default.dt_dry_fork_west_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_west_grows_to_12x12_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 12x12 From The Fork West
-- Main Trunk Grows To 12x12 From Fork West
function default.dt_dry_main_trunk_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork North Grows To 12x12 From Fork West
function default.dt_dry_fork_north_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_north_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork South Grows To 12x12 From Fork West
function default.dt_dry_fork_south_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_south_grows_to_12x12_from_fork_west(...)
	end
})

-- Fork East Grows To 12x12 From Fork West
function default.dt_dry_fork_east_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_14x14" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_fork_east_grows_to_12x12_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Base
-- Main Trunk Grows To 10x10 From Base
function default.dt_dry_main_trunk_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_base(...)
	end
})

-- Fork North Grows To 10x10 From Base
function default.dt_dry_fork_north_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_north_grows_to_10x10_from_base(...)
	end
})

-- Fork South Grows To 10x10 From Base
function default.dt_dry_fork_south_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_south_grows_to_10x10_from_base(...)
	end
})

-- Fork East Grows To 10x10 From Base
function default.dt_dry_fork_east_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_east_grows_to_10x10_from_base(...)
	end
})

-- Fork West Grows To 10x10 From Base
function default.dt_dry_fork_west_grows_to_10x10_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 10x10 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_west_grows_to_10x10_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Main Trunk
-- Main Trunk Grows To 10x10 From Main Trunk
function default.dt_dry_main_trunk_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork North Grows To 10x10 From Main Trunk
function default.dt_dry_fork_north_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_north_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork South Grows To 10x10 From Main Trunk
function default.dt_dry_fork_south_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_south_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork East Grows To 10x10 From Main Trunk
function default.dt_dry_fork_east_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_east_grows_to_10x10_from_main_trunk(...)
	end
})

-- Fork West Grows To 10x10 From Main Trunk
function default.dt_dry_fork_west_grows_to_10x10_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 10x10 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_west_grows_to_10x10_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork North
-- Main Trunk Grows To 10x10 From Fork North
function default.dt_dry_main_trunk_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork South Grows To 10x10 From Fork North
function default.dt_dry_fork_south_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_south_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork East Grows To 10x10 From Fork North
function default.dt_dry_fork_east_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_east_grows_to_10x10_from_fork_north(...)
	end
})

-- Fork West Grows To 10x10 From Fork North
function default.dt_dry_fork_west_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_west_grows_to_10x10_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork South
-- Main Trunk Grows To 10x10 From Fork South
function default.dt_dry_main_trunk_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork North Grows To 10x10 From Fork South
function default.dt_dry_fork_north_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_north_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork East Grows To 10x10 From Fork South
function default.dt_dry_fork_east_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_east_grows_to_10x10_from_fork_south(...)
	end
})

-- Fork West Grows To 10x10 From Fork South
function default.dt_dry_fork_west_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_west_grows_to_10x10_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork East
-- Main Trunk Grows To 10x10 From Fork East
function default.dt_dry_main_trunk_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork North Grows To 10x10 From Fork East
function default.dt_dry_fork_north_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_north_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork South Grows To 10x10 From Fork East
function default.dt_dry_fork_south_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_south_grows_to_10x10_from_fork_east(...)
	end
})

-- Fork West Grows To 10x10 From Fork East
function default.dt_dry_fork_west_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_west_grows_to_10x10_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 10x10 From The Fork West
-- Main Trunk Grows To 10x10 From Fork West
function default.dt_dry_main_trunk_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork North Grows To 10x10 From Fork West
function default.dt_dry_fork_north_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_north_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork South Grows To 10x10 From Fork West
function default.dt_dry_fork_south_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_south_grows_to_10x10_from_fork_west(...)
	end
})

-- Fork East Grows To 10x10 From Fork West
function default.dt_dry_fork_east_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_12x12" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_fork_east_grows_to_10x10_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Base
-- Main Trunk Grows To 8x8 From Base
function default.dt_dry_main_trunk_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_base(...)
	end
})

-- Fork North Grows To 8x8 From Base
function default.dt_dry_fork_north_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_base(...)
	end
})

-- Fork South Grows To 8x8 From Base
function default.dt_dry_fork_south_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_base(...)
	end
})

-- Fork East Grows To 8x8 From Base
function default.dt_dry_fork_east_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_base(...)
	end
})

-- Fork West Grows To 8x8 From Base
function default.dt_dry_fork_west_grows_to_8x8_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Main Trunk
-- Main Trunk Grows To 8x8 From Main Trunk
function default.dt_dry_main_trunk_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork North Grows To 8x8 From Main Trunk
function default.dt_dry_fork_north_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork South Grows To 8x8 From Main Trunk
function default.dt_dry_fork_south_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork East Grows To 8x8 From Main Trunk
function default.dt_dry_fork_east_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_main_trunk(...)
	end
})

-- Fork West Grows To 8x8 From Main Trunk
function default.dt_dry_fork_west_grows_to_8x8_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork North
-- Main Trunk Grows To 8x8 From Fork North
function default.dt_dry_main_trunk_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork South Grows To 8x8 From Fork North
function default.dt_dry_fork_south_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork East Grows To 8x8 From Fork North
function default.dt_dry_fork_east_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_fork_north(...)
	end
})

-- Fork West Grows To 8x8 From Fork North
function default.dt_dry_fork_west_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork South
-- Main Trunk Grows To 8x8 From Fork South
function default.dt_dry_main_trunk_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork North Grows To 8x8 From Fork South
function default.dt_dry_fork_north_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork East Grows To 8x8 From Fork South
function default.dt_dry_fork_east_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_fork_south(...)
	end
})

-- Fork West Grows To 8x8 From Fork South
function default.dt_dry_fork_west_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork East
-- Main Trunk Grows To 8x8 From Fork East
function default.dt_dry_main_trunk_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork North Grows To 8x8 From Fork East
function default.dt_dry_fork_north_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork South Grows To 8x8 From Fork East
function default.dt_dry_fork_south_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_fork_east(...)
	end
})

-- Fork West Grows To 8x8 From Fork East
function default.dt_dry_fork_west_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 8x8 From The Fork West
-- Main Trunk Grows To 8x8 From Fork West
function default.dt_dry_main_trunk_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork North Grows To 8x8 From Fork West
function default.dt_dry_fork_north_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork South Grows To 8x8 From Fork West
function default.dt_dry_fork_south_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_fork_west(...)
	end
})

-- Fork East Grows To 8x8 From Fork West
function default.dt_dry_fork_east_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Base
-- Main Trunk Grows To 6x6 From Base
function default.dt_dry_main_trunk_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_base(...)
	end
})

-- Fork North Grows To 6x6 From Base
function default.dt_dry_fork_north_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_base(...)
	end
})

-- Fork South Grows To 6x6 From Base
function default.dt_dry_fork_south_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_base(...)
	end
})

-- Fork East Grows To 6x6 From Base
function default.dt_dry_fork_east_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_base(...)
	end
})

-- Fork West Grows To 6x6 From Base
function default.dt_dry_fork_west_grows_to_6x6_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Main Trunk
-- Main Trunk Grows To 6x6 From Main Trunk
function default.dt_dry_main_trunk_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork North Grows To 6x6 From Main Trunk
function default.dt_dry_fork_north_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork South Grows To 6x6 From Main Trunk
function default.dt_dry_fork_south_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork East Grows To 6x6 From Main Trunk
function default.dt_dry_fork_east_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_main_trunk(...)
	end
})

-- Fork West Grows To 6x6 From Main Trunk
function default.dt_dry_fork_west_grows_to_6x6_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork North
-- Main Trunk Grows To 6x6 From Fork North
function default.dt_dry_main_trunk_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork South Grows To 6x6 From Fork North
function default.dt_dry_fork_south_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork East Grows To 6x6 From Fork North
function default.dt_dry_fork_east_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_fork_north(...)
	end
})

-- Fork West Grows To 6x6 From Fork North
function default.dt_dry_fork_west_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork South
-- Main Trunk Grows To 6x6 From Fork South
function default.dt_dry_main_trunk_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork North Grows To 6x6 From Fork South
function default.dt_dry_fork_north_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork East Grows To 6x6 From Fork South
function default.dt_dry_fork_east_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_fork_south(...)
	end
})

-- Fork West Grows To 6x6 From Fork South
function default.dt_dry_fork_west_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork East
-- Main Trunk Grows To 6x6 From Fork East
function default.dt_dry_main_trunk_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork North Grows To 6x6 From Fork East
function default.dt_dry_fork_north_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork South Grows To 6x6 From Fork East
function default.dt_dry_fork_south_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_fork_east(...)
	end
})

-- Fork West Grows To 6x6 From Fork East
function default.dt_dry_fork_west_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 6x6 From The Fork West
-- Main Trunk Grows To 6x6 From Fork West
function default.dt_dry_main_trunk_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork North Grows To 6x6 From Fork West
function default.dt_dry_fork_north_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork South Grows To 6x6 From Fork West
function default.dt_dry_fork_south_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_fork_west(...)
	end
})

-- Fork East Grows To 6x6 From Fork West
function default.dt_dry_fork_east_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_8x8"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Base
-- Main Trunk Grows To 4x4 From Base
function default.dt_dry_main_trunk_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_base(...)
	end
})

-- Fork North Grows To 4x4 From Base
function default.dt_dry_fork_north_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_base(...)
	end
})

-- Fork South Grows To 4x4 From Base
function default.dt_dry_fork_south_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_base(...)
	end
})

-- Fork East Grows To 4x4 From Base
function default.dt_dry_fork_east_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_base(...)
	end
})

-- Fork West Grows To 4x4 From Base
function default.dt_dry_fork_west_grows_to_4x4_from_base(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_base_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Base",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_base_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_base(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Main Trunk
-- Main Trunk Grows To 4x4 From Main Trunk
function default.dt_dry_main_trunk_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork North Grows To 4x4 From Main Trunk
function default.dt_dry_fork_north_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork South Grows To 4x4 From Main Trunk
function default.dt_dry_fork_south_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork East Grows To 4x4 From Main Trunk
function default.dt_dry_fork_east_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_main_trunk(...)
	end
})

-- Fork West Grows To 4x4 From Main Trunk
function default.dt_dry_fork_west_grows_to_4x4_from_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_main_trunk(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork North
-- Main Trunk Grows To 4x4 From Fork North
function default.dt_dry_main_trunk_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork South Grows To 4x4 From Fork North
function default.dt_dry_fork_south_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork East Grows To 4x4 From Fork North
function default.dt_dry_fork_east_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_fork_north(...)
	end
})

-- Fork West Grows To 4x4 From Fork North
function default.dt_dry_fork_west_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_fork_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork South
-- Main Trunk Grows To 4x4 From Fork South
function default.dt_dry_main_trunk_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork North Grows To 4x4 From Fork South
function default.dt_dry_fork_north_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork East Grows To 4x4 From Fork South
function default.dt_dry_fork_east_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_fork_south(...)
	end
})

-- Fork West Grows To 4x4 From Fork South
function default.dt_dry_fork_west_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_fork_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork East
-- Main Trunk Grows To 4x4 From Fork East
function default.dt_dry_main_trunk_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork North Grows To 4x4 From Fork East
function default.dt_dry_fork_north_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork South Grows To 4x4 From Fork East
function default.dt_dry_fork_south_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_fork_east(...)
	end
})

-- Fork West Grows To 4x4 From Fork East
function default.dt_dry_fork_west_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_fork_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow To 4x4 From The Fork West
-- Main Trunk Grows To 4x4 From Fork West
function default.dt_dry_main_trunk_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork North Grows To 4x4 From Fork West
function default.dt_dry_fork_north_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork South Grows To 4x4 From Fork West
function default.dt_dry_fork_south_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_fork_west(...)
	end
})

-- Fork East Grows To 4x4 From Fork West
function default.dt_dry_fork_east_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_6x6"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_fork_west(...)
	end
})





-- North Facing Node Placement
-- Fork North 4x4 Grows 2x2 Arm North
function default.dt_dry_fork_north_4x4_grows_2x2_arm_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North 4x4 Grows 2x2 Arm North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_north_4x4_grows_2x2_arm_north(...)
	end
})

-- Arm North 4x4 Grows 2x2 Elbow North
function default.dt_dry_arm_north_4x4_grows_2x2_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_north_4x4" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North 4x4 Grows 2x2 Elbow North",
	nodenames = {"dynamic_trees:dry_tree_arm_north_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_arm_north_4x4_grows_2x2_elbow_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_west(...)
	end
})

-- South Facing Node Placement
-- Fork South 4x4 Grows 2x2 Arm South
function default.dt_dry_fork_south_4x4_grows_2x2_arm_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South 4x4 Grows 2x2 Arm South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_south_4x4_grows_2x2_arm_south(...)
	end
})

-- Arm South 4x4 Grows 2x2 Elbow South
function default.dt_dry_arm_south_4x4_grows_2x2_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_south_4x4" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South 4x4 Grows 2x2 Elbow South",
	nodenames = {"dynamic_trees:dry_tree_arm_south_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_arm_south_4x4_grows_2x2_elbow_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_west(...)
	end
})

-- East Facing Node Placement
-- Fork East 4x4 Grows 2x2 Arm East
function default.dt_dry_fork_east_4x4_grows_2x2_arm_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East 4x4 Grows 2x2 Arm East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_east_4x4_grows_2x2_arm_east(...)
	end
})

-- Arm East 4x4 Grows 2x2 Elbow East
function default.dt_dry_arm_east_4x4_grows_2x2_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_east_4x4" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East 4x4 Grows 2x2 Elbow East",
	nodenames = {"dynamic_trees:dry_tree_arm_east_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_arm_east_4x4_grows_2x2_elbow_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_west(...)
	end
})

-- West Facing Node Placement
-- Fork West 4x4 Grows 2x2 Arm West
function default.dt_dry_fork_west_4x4_grows_2x2_arm_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West 4x4 Grows 2x2 Arm West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_fork_west_4x4_grows_2x2_arm_west(...)
	end
})

-- Arm West 4x4 Grows 2x2 Elbow West
function default.dt_dry_arm_west_4x4_grows_2x2_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_west_4x4" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West 4x4 Grows 2x2 Elbow West",
	nodenames = {"dynamic_trees:dry_tree_arm_west_4x4"},
	interval = 10,
	chance = 1,
	action = function(...)
		default.dt_dry_arm_west_4x4_grows_2x2_elbow_west(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_west(...)
	end
})

-- North Arm Growth
-- Arm North Grows To 12x12 From Fork North
function default.dt_dry_arm_north_grows_to_12x12_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_14x14" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_north_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North Grows To 12x12 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_arm_north_grows_to_12x12_from_fork_north(...)
	end
})

-- Arm North Grows To 10x10 From Fork North
function default.dt_dry_arm_north_grows_to_10x10_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North Grows To 10x10 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_arm_north_grows_to_10x10_from_fork_north(...)
	end
})

-- Arm North Grows To 8x8 From Fork North
function default.dt_dry_arm_north_grows_to_8x8_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North Grows To 8x8 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_arm_north_grows_to_8x8_from_fork_north(...)
	end
})

-- Arm North Grows To 6x6 From Fork North
function default.dt_dry_arm_north_grows_to_6x6_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North Grows To 6x6 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_arm_north_grows_to_6x6_from_fork_north(...)
	end
})

-- Arm North Grows To 4x4 From Fork North
function default.dt_dry_arm_north_grows_to_4x4_from_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm North Grows To 4x4 From Fork North",
	nodenames = {"dynamic_trees:dry_tree_fork_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_arm_north_grows_to_4x4_from_fork_north(...)
	end
})

-- South Arm Growth
-- Arm South Grows To 12x12 From Fork South
function default.dt_dry_arm_south_grows_to_12x12_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_14x14" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_south_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South Grows To 12x12 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_arm_south_grows_to_12x12_from_fork_south(...)
	end
})

-- Arm South Grows To 10x10 From Fork South
function default.dt_dry_arm_south_grows_to_10x10_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South Grows To 10x10 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_arm_south_grows_to_10x10_from_fork_south(...)
	end
})

-- Arm South Grows To 8x8 From Fork South
function default.dt_dry_arm_south_grows_to_8x8_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South Grows To 8x8 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_arm_south_grows_to_8x8_from_fork_south(...)
	end
})

-- Arm South Grows To 6x6 From Fork South
function default.dt_dry_arm_south_grows_to_6x6_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South Grows To 6x6 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_arm_south_grows_to_6x6_from_fork_south(...)
	end
})

-- Arm South Grows To 4x4 From Fork South
function default.dt_dry_arm_south_grows_to_4x4_from_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm South Grows To 4x4 From Fork South",
	nodenames = {"dynamic_trees:dry_tree_fork_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_arm_south_grows_to_4x4_from_fork_south(...)
	end
})

-- East Arm Growth
-- Arm East Grows To 12x12 From Fork East
function default.dt_dry_arm_east_grows_to_12x12_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_14x14" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_east_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East Grows To 12x12 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_arm_east_grows_to_12x12_from_fork_east(...)
	end
})

-- Arm East Grows To 10x10 From Fork East
function default.dt_dry_arm_east_grows_to_10x10_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East Grows To 10x10 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_arm_east_grows_to_10x10_from_fork_east(...)
	end
})

-- Arm East Grows To 8x8 From Fork East
function default.dt_dry_arm_east_grows_to_8x8_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East Grows To 8x8 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_arm_east_grows_to_8x8_from_fork_east(...)
	end
})

-- Arm East Grows To 6x6 From Fork East
function default.dt_dry_arm_east_grows_to_6x6_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East Grows To 6x6 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_arm_east_grows_to_6x6_from_fork_east(...)
	end
})

-- Arm East Grows To 4x4 From Fork East
function default.dt_dry_arm_east_grows_to_4x4_from_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm East Grows To 4x4 From Fork East",
	nodenames = {"dynamic_trees:dry_tree_fork_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_arm_east_grows_to_4x4_from_fork_east(...)
	end
})

-- West Arm Growth
-- Arm West Grows To 12x12 From Fork West
function default.dt_dry_arm_west_grows_to_12x12_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_14x14" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_west_10x10" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_12x12"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West Grows To 12x12 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_14x14"},
	interval = 10,
	chance = 25,
	action = function(...)
		default.dt_dry_arm_west_grows_to_12x12_from_fork_west(...)
	end
})

-- Arm West Grows To 10x10 From Fork West
function default.dt_dry_arm_west_grows_to_10x10_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West Grows To 10x10 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_arm_west_grows_to_10x10_from_fork_west(...)
	end
})

-- Arm West Grows To 8x8 From Fork West
function default.dt_dry_arm_west_grows_to_8x8_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West Grows To 8x8 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_arm_west_grows_to_8x8_from_fork_west(...)
	end
})

-- Arm West Grows To 6x6 From Fork West
function default.dt_dry_arm_west_grows_to_6x6_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West Grows To 6x6 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_arm_west_grows_to_6x6_from_fork_west(...)
	end
})

-- Arm West Grows To 4x4 From Fork West
function default.dt_dry_arm_west_grows_to_4x4_from_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_arm_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_arm_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Arm West Grows To 4x4 From Fork West",
	nodenames = {"dynamic_trees:dry_tree_fork_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_arm_west_grows_to_4x4_from_fork_west(...)
	end
})

-- North Elbow Growth
-- Elbow North Grows To 10x10 From Arm North
function default.dt_dry_elbow_north_grows_to_10x10_from_arm_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_north_12x12" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_north_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_north_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North Grows To 10x10 From Arm North",
	nodenames = {"dynamic_trees:dry_tree_arm_north_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_elbow_north_grows_to_10x10_from_arm_north(...)
	end
})

-- Elbow North Grows To 8x8 From Arm North
function default.dt_dry_elbow_north_grows_to_8x8_from_arm_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_north_10x10" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North Grows To 8x8 From Arm North",
	nodenames = {"dynamic_trees:dry_tree_arm_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_elbow_north_grows_to_8x8_from_arm_north(...)
	end
})

-- Elbow North Grows To 6x6 From Arm North
function default.dt_dry_elbow_north_grows_to_6x6_from_arm_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_north_8x8" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North Grows To 6x6 From Arm North",
	nodenames = {"dynamic_trees:dry_tree_arm_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_elbow_north_grows_to_6x6_from_arm_north(...)
	end
})

-- Elbow North Grows To 4x4 From Arm North
function default.dt_dry_elbow_north_grows_to_4x4_from_arm_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_north_6x6" do
		pos.z = pos.z + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North Grows To 4x4 From Arm North",
	nodenames = {"dynamic_trees:dry_tree_arm_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_grows_to_4x4_from_arm_north(...)
	end
})

-- South Elbow Growth
-- Elbow South Grows To 10x10 From Arm South
function default.dt_dry_elbow_south_grows_to_10x10_from_arm_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_south_12x12" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_south_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_south_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South Grows To 10x10 From Arm South",
	nodenames = {"dynamic_trees:dry_tree_arm_south_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_elbow_south_grows_to_10x10_from_arm_south(...)
	end
})

-- Elbow South Grows To 8x8 From Arm South
function default.dt_dry_elbow_south_grows_to_8x8_from_arm_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_south_10x10" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South Grows To 8x8 From Arm South",
	nodenames = {"dynamic_trees:dry_tree_arm_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_elbow_south_grows_to_8x8_from_arm_south(...)
	end
})

-- Elbow South Grows To 6x6 From Arm South
function default.dt_dry_elbow_south_grows_to_6x6_from_arm_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_south_8x8" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South Grows To 6x6 From Arm South",
	nodenames = {"dynamic_trees:dry_tree_arm_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_elbow_south_grows_to_6x6_from_arm_south(...)
	end
})

-- Elbow South Grows To 4x4 From Arm South
function default.dt_dry_elbow_south_grows_to_4x4_from_arm_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_south_6x6" do
		pos.z = pos.z + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South Grows To 4x4 From Arm South",
	nodenames = {"dynamic_trees:dry_tree_arm_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_grows_to_4x4_from_arm_south(...)
	end
})

-- East Elbow Growth
-- Elbow East Grows To 10x10 From Arm East
function default.dt_dry_elbow_east_grows_to_10x10_from_arm_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_east_12x12" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_east_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_east_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East Grows To 10x10 From Arm East",
	nodenames = {"dynamic_trees:dry_tree_arm_east_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_elbow_east_grows_to_10x10_from_arm_east(...)
	end
})

-- Elbow East Grows To 8x8 From Arm East
function default.dt_dry_elbow_east_grows_to_8x8_from_arm_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_east_10x10" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East Grows To 8x8 From Arm East",
	nodenames = {"dynamic_trees:dry_tree_arm_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_elbow_east_grows_to_8x8_from_arm_east(...)
	end
})

-- Elbow East Grows To 6x6 From Arm East
function default.dt_dry_elbow_east_grows_to_6x6_from_arm_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_east_8x8" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East Grows To 6x6 From Arm East",
	nodenames = {"dynamic_trees:dry_tree_arm_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_elbow_east_grows_to_6x6_from_arm_east(...)
	end
})

-- Elbow East Grows To 4x4 From Arm East
function default.dt_dry_elbow_east_grows_to_4x4_from_arm_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_east_6x6" do
		pos.x = pos.x + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East Grows To 4x4 From Arm East",
	nodenames = {"dynamic_trees:dry_tree_arm_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_grows_to_4x4_from_arm_east(...)
	end
})

-- West Elbow Growth
-- Elbow West Grows To 10x10 From Arm West
function default.dt_dry_elbow_west_grows_to_10x10_from_arm_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_west_12x12" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_west_8x8" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_west_10x10"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West Grows To 10x10 From Arm West",
	nodenames = {"dynamic_trees:dry_tree_arm_west_12x12"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_dry_elbow_west_grows_to_10x10_from_arm_west(...)
	end
})

-- Elbow West Grows To 8x8 From Arm West
function default.dt_dry_elbow_west_grows_to_8x8_from_arm_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_west_10x10" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West Grows To 8x8 From Arm West",
	nodenames = {"dynamic_trees:dry_tree_arm_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_elbow_west_grows_to_8x8_from_arm_west(...)
	end
})

-- Elbow West Grows To 6x6 From Arm West
function default.dt_dry_elbow_west_grows_to_6x6_from_arm_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_west_8x8" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West Grows To 6x6 From Arm West",
	nodenames = {"dynamic_trees:dry_tree_arm_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_elbow_west_grows_to_6x6_from_arm_west(...)
	end
})

-- Elbow West Grows To 4x4 From Arm West
function default.dt_dry_elbow_west_grows_to_4x4_from_arm_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_arm_west_6x6" do
		pos.x = pos.x + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_elbow_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_elbow_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West Grows To 4x4 From Arm West",
	nodenames = {"dynamic_trees:dry_tree_arm_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_grows_to_4x4_from_arm_west(...)
	end
})

-- Elbows Grow Trunks Above Them
-- Elbow North 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_north_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow North 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_north_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow North 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_north_4x4_grows_2x2_fork_west(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_south_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow South 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_south_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow South 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_south_4x4_grows_2x2_fork_west(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_east_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow East 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_east_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow East 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_east_4x4_grows_2x2_fork_west(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Main Trunk
function default.dt_dry_elbow_west_4x4_grows_2x2_main_trunk(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Main Trunk",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_main_trunk(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork North
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork North",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_north(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork South
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork South",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_south(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork East
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork East",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_east(...)
	end
})

-- Elbow West 4x4 Grows 2x2 Fork West
function default.dt_dry_elbow_west_4x4_grows_2x2_fork_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "default:dry_shrub"
	and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Dry Elbow West 4x4 Grows 2x2 Fork West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_4x4"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_elbow_west_4x4_grows_2x2_fork_west(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow North
-- Main Trunk Grows To 8x8 From Elbow North
function default.dt_dry_main_trunk_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_elbow_north(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow North
function default.dt_dry_main_trunk_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_elbow_north(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow North
function default.dt_dry_main_trunk_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork North Grows To 8x8 From Elbow North
function default.dt_dry_fork_north_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork North Grows To 6x6 From Elbow North
function default.dt_dry_fork_north_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork North Grows To 4x4 From Elbow North
function default.dt_dry_fork_north_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork South Grows To 8x8 From Elbow North
function default.dt_dry_fork_south_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork South Grows To 6x6 From Elbow North
function default.dt_dry_fork_south_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork South Grows To 4x4 From Elbow North
function default.dt_dry_fork_south_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork East Grows To 8x8 From Elbow North
function default.dt_dry_fork_east_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork East Grows To 6x6 From Elbow North
function default.dt_dry_fork_east_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork East Grows To 4x4 From Elbow North
function default.dt_dry_fork_east_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_elbow_north(...)
	end
})

-- Fork West Grows To 8x8 From Elbow North
function default.dt_dry_fork_west_grows_to_8x8_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_elbow_north(...)
	end
})

-- Fork West Grows To 6x6 From Elbow North
function default.dt_dry_fork_west_grows_to_6x6_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_elbow_north(...)
	end
})

-- Fork West Grows To 4x4 From Elbow North
function default.dt_dry_fork_west_grows_to_4x4_from_elbow_north(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Elbow North",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_elbow_north(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow South
-- Main Trunk Grows To 8x8 From Elbow South
function default.dt_dry_main_trunk_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_elbow_south(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow South
function default.dt_dry_main_trunk_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_elbow_south(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow South
function default.dt_dry_main_trunk_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork North Grows To 8x8 From Elbow South
function default.dt_dry_fork_north_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork North Grows To 6x6 From Elbow South
function default.dt_dry_fork_north_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork North Grows To 4x4 From Elbow South
function default.dt_dry_fork_north_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork South Grows To 8x8 From Elbow South
function default.dt_dry_fork_south_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork South Grows To 6x6 From Elbow South
function default.dt_dry_fork_south_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork South Grows To 4x4 From Elbow South
function default.dt_dry_fork_south_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork East Grows To 8x8 From Elbow South
function default.dt_dry_fork_east_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork East Grows To 6x6 From Elbow South
function default.dt_dry_fork_east_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork East Grows To 4x4 From Elbow South
function default.dt_dry_fork_east_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_elbow_south(...)
	end
})

-- Fork West Grows To 8x8 From Elbow South
function default.dt_dry_fork_west_grows_to_8x8_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_elbow_south(...)
	end
})

-- Fork West Grows To 6x6 From Elbow South
function default.dt_dry_fork_west_grows_to_6x6_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_elbow_south(...)
	end
})

-- Fork West Grows To 4x4 From Elbow South
function default.dt_dry_fork_west_grows_to_4x4_from_elbow_south(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Elbow South",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_elbow_south(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow East
-- Main Trunk Grows To 8x8 From Elbow East
function default.dt_dry_main_trunk_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_elbow_east(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow East
function default.dt_dry_main_trunk_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_elbow_east(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow East
function default.dt_dry_main_trunk_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork North Grows To 8x8 From Elbow East
function default.dt_dry_fork_north_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork North Grows To 6x6 From Elbow East
function default.dt_dry_fork_north_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork North Grows To 4x4 From Elbow East
function default.dt_dry_fork_north_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork South Grows To 8x8 From Elbow East
function default.dt_dry_fork_south_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork South Grows To 6x6 From Elbow East
function default.dt_dry_fork_south_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork South Grows To 4x4 From Elbow East
function default.dt_dry_fork_south_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork East Grows To 8x8 From Elbow East
function default.dt_dry_fork_east_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork East Grows To 6x6 From Elbow East
function default.dt_dry_fork_east_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork East Grows To 4x4 From Elbow East
function default.dt_dry_fork_east_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_elbow_east(...)
	end
})

-- Fork West Grows To 8x8 From Elbow East
function default.dt_dry_fork_west_grows_to_8x8_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_elbow_east(...)
	end
})

-- Fork West Grows To 6x6 From Elbow East
function default.dt_dry_fork_west_grows_to_6x6_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_elbow_east(...)
	end
})

-- Fork West Grows To 4x4 From Elbow East
function default.dt_dry_fork_west_grows_to_4x4_from_elbow_east(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Elbow East",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_elbow_east(...)
	end
})

-- This Section Is For All The Nodes That Will Grow From The Elbow West
-- Main Trunk Grows To 8x8 From Elbow West
function default.dt_dry_main_trunk_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_8x8_from_elbow_west(...)
	end
})

-- Main Trunk Grows To 6x6 From Elbow West
function default.dt_dry_main_trunk_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_6x6_from_elbow_west(...)
	end
})

-- Main Trunk Grows To 4x4 From Elbow West
function default.dt_dry_main_trunk_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_main_trunk_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_main_trunk_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Main Trunk Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_main_trunk_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork North Grows To 8x8 From Elbow West
function default.dt_dry_fork_north_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_north_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork North Grows To 6x6 From Elbow West
function default.dt_dry_fork_north_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_north_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork North Grows To 4x4 From Elbow West
function default.dt_dry_fork_north_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_north_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_north_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork North Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_north_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork South Grows To 8x8 From Elbow West
function default.dt_dry_fork_south_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_south_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork South Grows To 6x6 From Elbow West
function default.dt_dry_fork_south_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_south_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork South Grows To 4x4 From Elbow West
function default.dt_dry_fork_south_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_south_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_south_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork South Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_south_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork East Grows To 8x8 From Elbow West
function default.dt_dry_fork_east_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_east_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork East Grows To 6x6 From Elbow West
function default.dt_dry_fork_east_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_east_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork East Grows To 4x4 From Elbow West
function default.dt_dry_fork_east_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_east_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_east_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork East Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_east_grows_to_4x4_from_elbow_west(...)
	end
})

-- Fork West Grows To 8x8 From Elbow West
function default.dt_dry_fork_west_grows_to_8x8_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_10x10" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_6x6" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 8x8 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_10x10"},
	interval = 10,
	chance = 15,
	action = function(...)
		default.dt_dry_fork_west_grows_to_8x8_from_elbow_west(...)
	end
})

-- Fork West Grows To 6x6 From Elbow West
function default.dt_dry_fork_west_grows_to_6x6_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_4x4" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 6x6 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_8x8"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_fork_west_grows_to_6x6_from_elbow_west(...)
	end
})

-- Fork West Grows To 4x4 From Elbow West
function default.dt_dry_fork_west_grows_to_4x4_from_elbow_west(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:dry_tree_fork_west_2x2" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:dry_tree_fork_west_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Dry Fork West Grows To 4x4 From Elbow West",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_6x6"},
	interval = 10,
	chance = 5,
	action = function(...)
		default.dt_dry_fork_west_grows_to_4x4_from_elbow_west(...)
	end
})

-- Dry Shrub Growth
-- Dry Shrubs Will Spawn Above The 2x2 Nodes Of The Tree
-- This Spawns Dry Shrub Above Main Trunk 2x2
function default.dt_dry_dry_shrub_above_main_trunk_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_main_trunk_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Main Trunk 2x2",
	nodenames = {"dynamic_trees:dry_tree_main_trunk_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_main_trunk_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Fork North 2x2
function default.dt_dry_dry_shrub_above_fork_north_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Fork North 2x2",
	nodenames = {"dynamic_trees:dry_tree_fork_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_fork_north_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Fork South 2x2
function default.dt_dry_dry_shrub_above_fork_south_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Fork South 2x2",
	nodenames = {"dynamic_trees:dry_tree_fork_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_fork_south_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Fork East 2x2
function default.dt_dry_dry_shrub_above_fork_east_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Fork East 2x2",
	nodenames = {"dynamic_trees:dry_tree_fork_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_fork_east_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Fork West 2x2
function default.dt_dry_dry_shrub_above_fork_west_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_fork_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Fork West 2x2",
	nodenames = {"dynamic_trees:dry_tree_fork_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_fork_west_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Elbow North 2x2
function default.dt_dry_dry_shrub_above_elbow_north_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_north_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Elbow North 2x2",
	nodenames = {"dynamic_trees:dry_tree_elbow_north_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_elbow_north_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Elbow South 2x2
function default.dt_dry_dry_shrub_above_elbow_south_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_south_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Elbow South 2x2",
	nodenames = {"dynamic_trees:dry_tree_elbow_south_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_elbow_south_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Elbow East 2x2
function default.dt_dry_dry_shrub_above_elbow_east_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_east_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Elbow East 2x2",
	nodenames = {"dynamic_trees:dry_tree_elbow_east_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_elbow_east_2x2(...)
	end
})

-- This Spawns Dry Shrub Above Elbow West 2x2
function default.dt_dry_dry_shrub_above_elbow_west_2x2(pos, node)
	while node.name == "dynamic_trees:dry_tree_elbow_west_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:dry_shrub"})
	return true
end

minetest.register_abm({
	label = "DT Dry Shrub Above Elbow West 2x2",
	nodenames = {"dynamic_trees:dry_tree_elbow_west_2x2"},
	interval = 10,
	chance = 10,
	action = function(...)
		default.dt_dry_dry_shrub_above_elbow_west_2x2(...)
	end
})