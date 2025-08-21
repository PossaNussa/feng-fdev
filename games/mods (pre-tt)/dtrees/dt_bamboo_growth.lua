-- dynamic_trees/dt_bamboo_growth.lua

-- This Is Where The Growth Of The Bamboo Is Handled

-- Bamboo Growth Starts Here With The Bamboo Shoot Growing
-- One Of The 4 Bamboo Canopies
-- Bamboo Shoot Growing A Canopy 1 Base
function default.dt_bamboo_canopy_1_base_on_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_shoot" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_1_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 1 Base On Shoot",
	nodenames = {"dynamic_trees:bamboo_shoot"},
	interval = 10,
	chance = 80,
	action = function(...)
		default.dt_bamboo_canopy_1_base_on_shoot(...)
	end
})

-- Bamboo Shoot Growing A Canopy 2 Base
function default.dt_bamboo_canopy_2_base_on_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_shoot" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_2_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 2 Base On Shoot",
	nodenames = {"dynamic_trees:bamboo_shoot"},
	interval = 10,
	chance = 80,
	action = function(...)
		default.dt_bamboo_canopy_2_base_on_shoot(...)
	end
})

-- Bamboo Shoot Growing A Canopy 3 Base
function default.dt_bamboo_canopy_3_base_on_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_shoot" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_3_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 3 Base On Shoot",
	nodenames = {"dynamic_trees:bamboo_shoot"},
	interval = 10,
	chance = 80,
	action = function(...)
		default.dt_bamboo_canopy_3_base_on_shoot(...)
	end
})

-- Bamboo Shoot Growing A Canopy 4 Base
function default.dt_bamboo_canopy_4_base_on_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_shoot" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_4_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 4 Base On Shoot",
	nodenames = {"dynamic_trees:bamboo_shoot"},
	interval = 10,
	chance = 80,
	action = function(...)
		default.dt_bamboo_canopy_4_base_on_shoot(...)
	end
})

-- The Type Of Canopy Base Will Determine What Size The
-- Bamboo Will Grow To Be
-- This Spawns A Bamboo 2x2 Base That The Bamboo Will Grow From
function default.dt_bamboo_2x2_base_replace_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_1_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_shoot" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Base Replace Shoot",
	nodenames = {"dynamic_trees:bamboo_canopy_1_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_2x2_base_replace_shoot(...)
	end
})

-- This Spawns A Bamboo 4x4 Base That The Bamboo Will Grow From
function default.dt_bamboo_4x4_base_replace_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_2_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_shoot" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Base Replace Shoot",
	nodenames = {"dynamic_trees:bamboo_canopy_2_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_4x4_base_replace_shoot(...)
	end
})

-- This Spawns A Bamboo 6x6 Base That The Bamboo Will Grow From
function default.dt_bamboo_6x6_base_replace_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_3_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_shoot" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Base Replace Shoot",
	nodenames = {"dynamic_trees:bamboo_canopy_3_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_6x6_base_replace_shoot(...)
	end
})

-- This Spawns A Bamboo 8x8 Base That The Bamboo Will Grow From
function default.dt_bamboo_8x8_base_replace_shoot(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_4_base" do
		pos.y = pos.y + -1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_shoot" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Base Replace Shoot",
	nodenames = {"dynamic_trees:bamboo_canopy_4_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_8x8_base_replace_shoot(...)
	end
})

-- The Bamboo Above The Base Bamboo Will Generate Bamboo Canopies As The Bamboo grows
-- This Spawns Bamboo Canopy 1 Base Above Bamboo 2x2
function default.dt_bamboo_2x2_place_bamboo_canopy_1_base(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_top" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_1_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place Bamboo Canopy 1 Base",
	nodenames = {"dynamic_trees:bamboo_2x2"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_2x2_place_bamboo_canopy_1_base(...)
	end
})

-- This Spawns Bamboo Canopy 2 Base Above Bamboo 4x4
function default.dt_bamboo_4x4_place_bamboo_canopy_2_base(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_top" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_2_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place Bamboo Canopy 2 Base",
	nodenames = {"dynamic_trees:bamboo_4x4"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_4x4_place_bamboo_canopy_2_base(...)
	end
})

-- This Spawns Bamboo Canopy 3 Base Above Bamboo 6x6
function default.dt_bamboo_6x6_place_bamboo_canopy_3_base(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_top" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_3_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place Bamboo Canopy 3 Base",
	nodenames = {"dynamic_trees:bamboo_6x6"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_6x6_place_bamboo_canopy_3_base(...)
	end
})

-- This Spawns Bamboo Canopy 4 Base Above Bamboo 8x8
function default.dt_bamboo_8x8_place_bamboo_canopy_4_base(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_top" and node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_4_base"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place Bamboo Canopy 4 Base",
	nodenames = {"dynamic_trees:bamboo_8x8"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_8x8_place_bamboo_canopy_4_base(...)
	end
})

-- The Canopy Bases Will Generate Canopy Tops To Fill The
-- Space Above Them For A More Lush Appearance
-- This Spawns A Canopy 1 Top Above The Canopy 1 Base
function default.dt_bamboo_canopy_1_base_place_bamboo_canopy_1_top(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_1_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_1_top"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 1 Base Grow Canopy 1 Top",
	nodenames = {"dynamic_trees:bamboo_canopy_1_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_canopy_1_base_place_bamboo_canopy_1_top(...)
	end
})

-- This Spawns A Canopy 2 Top Above The Canopy 2 Base
function default.dt_bamboo_canopy_2_base_place_bamboo_canopy_2_top(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_2_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_2_top"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 2 Base Grow Canopy 2 Top",
	nodenames = {"dynamic_trees:bamboo_canopy_2_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_canopy_2_base_place_bamboo_canopy_2_top(...)
	end
})

-- This Spawns A Canopy 3 Top Above The Canopy 3 Base
function default.dt_bamboo_canopy_3_base_place_bamboo_canopy_3_top(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_3_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_3_top"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 3 Base Grow Canopy 3 Top",
	nodenames = {"dynamic_trees:bamboo_canopy_3_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_canopy_3_base_place_bamboo_canopy_3_top(...)
	end
})

-- This Spawns A Canopy 4 Top Above The Canopy 4 Base
function default.dt_bamboo_canopy_4_base_place_bamboo_canopy_4_top(pos, node)
	while node.name == "dynamic_trees:bamboo_canopy_4_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_canopy_4_top"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo Canopy 4 Base Grow Canopy 4 Top",
	nodenames = {"dynamic_trees:bamboo_canopy_4_base"},
	interval = 10,
	chance = 20,
	action = function(...)
		default.dt_bamboo_canopy_4_base_place_bamboo_canopy_4_top(...)
	end
})

-- This Section Is For The Growth Of The 2x2 Bamboo
-- This Spawns A 2x2 Bamboo 1 Block Above
function default.dt_bamboo_2x2_place_1_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 1 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_1_block_above(...)
	end
})

-- This Spawns A 2x2 Bamboo 2 Block Above
function default.dt_bamboo_2x2_place_2_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 2 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_2_block_above(...)
	end
})

-- This Spawns A 2x2 Bamboo 3 Block Above
function default.dt_bamboo_2x2_place_3_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 3 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_3_block_above(...)
	end
})

-- This Spawns A 2x2 Bamboo 4 Block Above
function default.dt_bamboo_2x2_place_4_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 4 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_4_block_above(...)
	end
})

-- This Spawns A 2x2 Bamboo 5 Block Above
function default.dt_bamboo_2x2_place_5_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 5 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_5_block_above(...)
	end
})

-- This Spawns A 2x2 Bamboo 6 Block Above
function default.dt_bamboo_2x2_place_6_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_2x2_base" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_1_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_2x2"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 2x2 Place 6 Block Above",
	nodenames = {"dynamic_trees:bamboo_2x2_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_2x2_place_6_block_above(...)
	end
})

-- This Section Is For The Growth Of The 4x4 Bamboo
-- This Spawns A 4x4 Bamboo 1 Block Above
function default.dt_bamboo_4x4_place_1_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 1 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_1_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 2 Block Above
function default.dt_bamboo_4x4_place_2_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 2 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_2_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 3 Block Above
function default.dt_bamboo_4x4_place_3_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 3 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_3_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 4 Block Above
function default.dt_bamboo_4x4_place_4_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 4 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_4_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 5 Block Above
function default.dt_bamboo_4x4_place_5_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 5 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_5_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 6 Block Above
function default.dt_bamboo_4x4_place_6_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 6 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_6_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 7 Block Above
function default.dt_bamboo_4x4_place_7_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 7 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_7_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 8 Block Above
function default.dt_bamboo_4x4_place_8_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 8 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_8_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 9 Block Above
function default.dt_bamboo_4x4_place_9_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 9 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_9_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 10 Block Above
function default.dt_bamboo_4x4_place_10_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 10 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_10_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 11 Block Above
function default.dt_bamboo_4x4_place_11_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 11 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_11_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 12 Block Above
function default.dt_bamboo_4x4_place_12_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 12 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_12_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 13 Block Above
function default.dt_bamboo_4x4_place_13_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 13 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_13_block_above(...)
	end
})

-- This Spawns A 4x4 Bamboo 14 Block Above
function default.dt_bamboo_4x4_place_14_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_4x4_base" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_2_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_4x4"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 4x4 Place 14 Block Above",
	nodenames = {"dynamic_trees:bamboo_4x4_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_4x4_place_14_block_above(...)
	end
})

-- This Section Is For The Growth Of The 6x6 Bamboo
-- This Spawns A 6x6 Bamboo 1 Block Above
function default.dt_bamboo_6x6_place_1_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 1 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_1_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 2 Block Above
function default.dt_bamboo_6x6_place_2_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 2 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_2_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 3 Block Above
function default.dt_bamboo_6x6_place_3_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 3 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_3_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 4 Block Above
function default.dt_bamboo_6x6_place_4_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 4 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_4_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 5 Block Above
function default.dt_bamboo_6x6_place_5_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 5 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_5_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 6 Block Above
function default.dt_bamboo_6x6_place_6_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 6 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_6_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 7 Block Above
function default.dt_bamboo_6x6_place_7_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 7 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_7_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 8 Block Above
function default.dt_bamboo_6x6_place_8_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 8 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_8_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 9 Block Above
function default.dt_bamboo_6x6_place_9_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 9 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_9_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 10 Block Above
function default.dt_bamboo_6x6_place_10_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 10 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_10_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 11 Block Above
function default.dt_bamboo_6x6_place_11_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 11 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_11_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 12 Block Above
function default.dt_bamboo_6x6_place_12_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 12 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_12_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 13 Block Above
function default.dt_bamboo_6x6_place_13_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 13 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_13_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 14 Block Above
function default.dt_bamboo_6x6_place_14_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 14 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_14_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 15 Block Above
function default.dt_bamboo_6x6_place_15_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 15 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_15_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 16 Block Above
function default.dt_bamboo_6x6_place_16_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 16 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_16_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 17 Block Above
function default.dt_bamboo_6x6_place_17_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 17 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_17_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 18 Block Above
function default.dt_bamboo_6x6_place_18_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 18 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_18_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 19 Block Above
function default.dt_bamboo_6x6_place_19_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 19 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_19_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 20 Block Above
function default.dt_bamboo_6x6_place_20_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 20 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_20_block_above(...)
	end
})

-- This Spawns A 6x6 Bamboo 21 Block Above
function default.dt_bamboo_6x6_place_21_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_6x6_base" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_3_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_6x6"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 6x6 Place 21 Block Above",
	nodenames = {"dynamic_trees:bamboo_6x6_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_6x6_place_21_block_above(...)
	end
})

-- This Section Is For The Growth Of The 8x8 Bamboo
-- This Spawns A 8x8 Bamboo 1 Block Above
function default.dt_bamboo_8x8_place_1_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 1 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_1_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 2 Block Above
function default.dt_bamboo_8x8_place_2_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 2
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 2 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_2_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 3 Block Above
function default.dt_bamboo_8x8_place_3_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 3
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 3 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_3_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 4 Block Above
function default.dt_bamboo_8x8_place_4_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 4
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 4 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_4_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 5 Block Above
function default.dt_bamboo_8x8_place_5_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 5
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 5 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_5_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 6 Block Above
function default.dt_bamboo_8x8_place_6_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 6
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 6 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_6_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 7 Block Above
function default.dt_bamboo_8x8_place_7_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 7
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 7 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_7_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 8 Block Above
function default.dt_bamboo_8x8_place_8_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 8
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 8 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_8_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 9 Block Above
function default.dt_bamboo_8x8_place_9_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 9
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 9 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_9_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 10 Block Above
function default.dt_bamboo_8x8_place_10_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 10
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 10 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_10_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 11 Block Above
function default.dt_bamboo_8x8_place_11_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 11
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 11 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_11_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 12 Block Above
function default.dt_bamboo_8x8_place_12_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 12
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 12 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_12_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 13 Block Above
function default.dt_bamboo_8x8_place_13_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 13
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 13 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_13_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 14 Block Above
function default.dt_bamboo_8x8_place_14_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 14
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 14 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_14_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 15 Block Above
function default.dt_bamboo_8x8_place_15_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 15
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 15 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_15_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 16 Block Above
function default.dt_bamboo_8x8_place_16_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 16
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 16 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_16_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 17 Block Above
function default.dt_bamboo_8x8_place_17_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 17
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 17 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_17_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 18 Block Above
function default.dt_bamboo_8x8_place_18_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 18
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 18 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_18_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 19 Block Above
function default.dt_bamboo_8x8_place_19_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 19
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 19 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_19_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 20 Block Above
function default.dt_bamboo_8x8_place_20_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 20
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 20 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_20_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 21 Block Above
function default.dt_bamboo_8x8_place_21_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 21
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 21 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_21_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 22 Block Above
function default.dt_bamboo_8x8_place_22_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 22
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 22 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_22_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 23 Block Above
function default.dt_bamboo_8x8_place_23_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 23
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 23 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_23_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 24 Block Above
function default.dt_bamboo_8x8_place_24_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 24
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 24 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_24_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 25 Block Above
function default.dt_bamboo_8x8_place_25_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 25
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 25 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_25_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 26 Block Above
function default.dt_bamboo_8x8_place_26_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 26
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 26 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_26_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 27 Block Above
function default.dt_bamboo_8x8_place_27_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 27
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 27 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_27_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 28 Block Above
function default.dt_bamboo_8x8_place_28_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 28
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 28 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_28_block_above(...)
	end
})

-- This Spawns A 8x8 Bamboo 29 Block Above
function default.dt_bamboo_8x8_place_29_block_above(pos, node)
	while node.name == "dynamic_trees:bamboo_8x8_base" do
		pos.y = pos.y + 29
		node = minetest.get_node(pos)
	end
	if node.name ~= "dynamic_trees:bamboo_canopy_4_base" then
		return
	end
	minetest.set_node(pos, {name = "dynamic_trees:bamboo_8x8"})
	return true
end

minetest.register_abm({
	label = "DT Bamboo 8x8 Place 29 Block Above",
	nodenames = {"dynamic_trees:bamboo_8x8_base"},
	interval = 10,
	chance = 50,
	action = function(...)
		default.dt_bamboo_8x8_place_29_block_above(...)
	end
})