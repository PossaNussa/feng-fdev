
	local nodes = {
		{name="wool:black", description=("Black Carpet")},
		{name="wool:blue", description=("Blue Carpet")},
		{name="wool:brown", description=("Brown Carpet")},
		{name="wool:cyan", description=("Cyan Carpet")},
		{name="wool:dark_green", description=("Dark Green Carpet")},
		{name="wool:dark_grey", description=("Dark Grey Carpet")},
		{name="wool:green", description=("Green Carpet")},
		{name="wool:grey", description=("Grey Carpet")},
		{name="wool:magenta", description=("Magenta Carpet")},
		{name="wool:orange", description=("Orange Carpet")},
		{name="wool:pink", description=("Pink Carpet")},
		{name="wool:red", description=("Red Carpet")},
		{name="wool:violet", description=("Violet Carpet")},
		{name="wool:white", description=("White Carpet")},
		{name="wool:yellow", description=("Yellow Carpet")},
	}
	for _, node in ipairs(nodes) do
		local name = "carpet:" .. (node.name:gsub(":", "_"))
		minetest.override_item(name, {
			
		node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5}
		},
		selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -7/16, 0.5}
		},

		on_place = function(itemstack, placer, pointed_thing)

			node_below = minetest.get_node(pointed_thing.above - vector.new(0, 1, 0))
			nodedef_below = minetest.registered_nodes[node_below.name]				old_itemstack = itemstack

			if node_below.param2 > 3 then

			minetest.item_place(itemstack, placer, pointed_thing)
			return old_itemstack

			end

			if (nodedef_below.groups.slab == 1) then
				itemstack = ItemStack(name .. "_slab")
			elseif (nodedef_below.groups.stair == 1) then
				if nodedef_below.name:find("outer") then
					itemstack = ItemStack(name .. "_stair_outer")
				elseif nodedef_below.name:find("inner") then
					itemstack = ItemStack(name .. "_stair_inner")
				else
					itemstack = ItemStack(name .. "_stair")
				end
			end

			

			minetest.item_place(itemstack, placer, pointed_thing, node_below.param2)
			return old_itemstack

		end
		
		})


		minetest.register_node(":" .. name .. "_slab", {

		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = minetest.registered_nodes[node.name].tiles,
		drop = name,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -15/16, -0.5, 0.5, -1, 0.5}
		},
		groups = {
			snappy = 2,
			flammable = 3,
			oddly_breakable_by_hand = 3,
			choppy = 2,
			carpet = 1,
			not_in_creative_inventory = 1,
		},
		sounds = default.node_sound_defaults(),

		})

		minetest.register_node(":" .. name .. "_stair", {

		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = minetest.registered_nodes[node.name].tiles,
		drop = name,
		node_box = {
			type = "fixed",
			fixed = {{-0.5, -15/16, -0.5, 0.5, -1, 0},
			{-0.5, -7/16, -1/16, 0.5, -0.5, 0.5},
			{-0.5, -15/16, 0, 0.5, -0.5, -1/16},
			{-0.5, -15/16, -0.5, 0.5, -1.5, -9/16}}
		},
		groups = {
			snappy = 2,
			flammable = 3,
			oddly_breakable_by_hand = 3,
			choppy = 2,
			carpet = 1,
			not_in_creative_inventory = 1,
		},
		sounds = default.node_sound_defaults(),

		})

		minetest.register_node(":" .. name .. "_stair_outer", {

		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = minetest.registered_nodes[node.name].tiles,
		drop = name,
		node_box = {
			type = "fixed",
			fixed = {{-0.5, -15/16, -0.5, 0.5, -1, 0.5},
			{-0.5, -7/16, -1/16, 1/16, -0.5, 0.5},
			{-0.5, -15/16, 0, 1/16, -0.5, -1/16},
			{0, -15/16, 0.5, 1/16, -0.5, 0},
			{-0.5, -15/16, -0.5, 9/16, -1.5, -9/16},
			{0.5, -15/16, 0.5, 9/16, -1.5, -0.5}}
		},
		groups = {
			snappy = 2,
			flammable = 3,
			oddly_breakable_by_hand = 3,
			choppy = 2,
			carpet = 1,
			not_in_creative_inventory = 1,
		},
		sounds = default.node_sound_defaults(),

		})

		minetest.register_node(":" .. name .. "_stair_inner", {

		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = minetest.registered_nodes[node.name].tiles,
		drop = name,
		node_box = {
			type = "fixed",
			fixed = {{0, -15/16, -0.5, 0.5, -1, 0},
			{-0.5, -7/16, -1/16, 0.5, -0.5, 0.5},
			{-0.5, -7/16, -0.5, 1/16, -0.5, -1/16},
			{0, -15/16, 0, 0.5, -0.5, -1/16},
			{0, -15/16, 0, 1/16, -0.5, -0.5}}
		},
		groups = {
			snappy = 2,
			flammable = 3,
			oddly_breakable_by_hand = 3,
			choppy = 2,
			carpet = 1,
			not_in_creative_inventory = 1,
		},
		sounds = default.node_sound_defaults(),

		})


	end