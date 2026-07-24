
if minetest.settings: get_bool('awg.bushes', true) then
	minetest.override_item('default:blueberry_bush_leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_bush_leaves.obj',
		tiles = {'awg_blueberry_bush.png', 'awg_blueberry_bush_extra.png'}
	})

	minetest.override_item('default:blueberry_bush_leaves_with_berries', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_bush_leaves_berries.obj',
		tiles = {'awg_blueberry_bush.png', 'awg_blueberry_bush_extra.png', 'awg_blueberry.png'},
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local count = math.random(1, 4)
			local inv = clicker:get_inventory()
			local stack = ItemStack("default:blueberries " .. count)
			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else
				minetest.add_item(pos, stack)
			end
			minetest.set_node(pos, {name = "default:blueberry_bush_leaves"})
			minetest.get_node_timer(pos):start(math.random(300, 1500))
		end,
	})

	minetest.override_item('default:bush_leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_bush_leaves.obj',
		tiles = {'awg_bush.png', 'awg_bush_extra.png'}
	})

	minetest.override_item('default:acacia_bush_leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_bush_leaves.obj',
		tiles = {'awg_acacia_bush.png', 'awg_acacia_bush_extra.png'}
	})

	minetest.override_item('default:pine_bush_needles', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_bush_leaves.obj',
		tiles = {'awg_pine_bush.png', 'awg_pine_bush_extra.png'}
	})
end

local function leaves_after_place (pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	node.param2 = math.random(0, 239)
	minetest.swap_node(pos, node)
end

local climb = minetest.settings: get_bool('awg.tree_leaves_climbable', true)

if minetest.settings: get_bool('awg.tree_leaves', true) then
	minetest.override_item('default:leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_tree_leaves.obj',
		walkable = not climb,
		climbable = climb,
		move_resistance = 6,
		paramtype2 = 'degrotate',
		after_place_node = leaves_after_place,
		visual_scale = 0.8
	})
	
	minetest.override_item('default:acacia_leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_tree_leaves.obj',
		walkable = not climb,
		climbable = climb,
		move_resistance = 6,
		paramtype2 = 'degrotate',
		after_place_node = leaves_after_place,
		visual_scale = 0.8
	})
	
	minetest.override_item('default:aspen_leaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_tree_leaves.obj',
		walkable = not climb,
		climbable = climb,
		move_resistance = 6,
		paramtype2 = 'degrotate',
		after_place_node = leaves_after_place,
		visual_scale = 0.8
	})
	
	minetest.override_item('default:pine_needles', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_tree_leaves.obj',
		walkable = not climb,
		climbable = climb,
		move_resistance = 6,
		paramtype2 = 'degrotate',
		after_place_node = leaves_after_place,
		visual_scale = 0.8
	})
	
	minetest.override_item('default:jungleleaves', {
		drawtype = 'mesh',
		use_texture_alpha = 'clip',
		mesh = 'awg_tree_leaves.obj',
		walkable = not climb,
		climbable = climb,
		move_resistance = 6,
		paramtype2 = 'degrotate',
		after_place_node = leaves_after_place,
		visual_scale = 0.8
	})
end
