
local dust_step = 8

minetest.register_node('etcetera:dust', {
	description = 'Dust',
	drawtype = 'nodebox',
	tiles = {{
		name = 'etc_dust.png',
		backface_culling = false,
		align_style = 'world',
	}},
	inventory_image = 'etc_dust.png',
	wield_image = 'etc_dust.png',
	paramtype = 'light',
	paramtype2 = 'leveled',
	use_texture_alpha = 'blend',
	buildable_to = true,
	walkable = false,
	pointable = true,
	floodable = true,
	place_param2 = dust_step,
	leveled = dust_step,
	groups = {crumbly = 3, falling_node = 1},
	sounds = default.node_sound_sand_defaults(),
	node_box = {
		type = 'leveled',
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	node_placement_prediction = '',

	on_dig = function(pos, node, digger)
		local level = minetest.get_node_level(pos)
		minetest.node_dig(pos, node, digger)
		if minetest.get_node(pos).name == node.name or
				not digger or not digger:is_player() then
			return
		end
		local extra = math.max(0, level / dust_step - 1)
		if extra > 0 then
			core.handle_node_drops(pos, {ItemStack("etcetera:dust " .. tostring(extra))}, digger)
		end
	end,

	on_place = function(itemstack, placer, pointed_thing)
		local place_to = pointed_thing.under
		local old_node = minetest.get_node(place_to)
		if old_node.name ~= "etcetera:dust" then
			local node_def = minetest.registered_nodes[old_node.name]
			if node_def and node_def.buildable_to then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
			place_to = pointed_thing.above
			old_node = minetest.get_node(place_to)
			if old_node.name ~= "etcetera:dust" then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		local player_name = placer and placer:is_player()
		player_name = player_name and placer:get_player_name() or ""
		if minetest.is_protected(place_to, player_name) and
				(player_name == "" or
				not minetest.check_player_privs(placer, "protection_bypass")) then
			if player_name == "" then return itemstack end
			minetest.record_protection_violation(place_to, player_name)
			return itemstack
		end
		local level = minetest.get_node_level(place_to)
		level = level + dust_step
		if level >= 64 then
			minetest.swap_node(place_to, {name = "etcetera:dustblock"})
		else
			minetest.set_node_level(place_to, level)
		end
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_node('etcetera:dustblock', {
	description = 'Dust Block',
	tiles = {'etc_dust.png'},
	use_texture_alpha = 'blend',
	groups = {crumbly = 3},
	sounds = default.node_sound_sand_defaults(),
	is_ground_content = false,
})

minetest.register_craft {
	type ='shapeless',
	output = 'default:clay',
	recipe = {'bucket:bucket_water', 'etcetera:dust'},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'}}
}

minetest.register_craft {
	type ='shapeless',
	output = 'default:clay 8',
	recipe = {'bucket:bucket_water', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust', 'etcetera:dust'},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'}}
}

-- Helper: place or stack dust at a position (used by ABMs)
local function place_or_stack_dust(pos)
	local node = minetest.get_node(pos)
	if node.name == "etcetera:dust" then
		local level = minetest.get_node_level(pos)
		level = level + dust_step
		if level >= 64 then
			minetest.swap_node(pos, {name = "etcetera:dustblock"})
		else
			minetest.set_node_level(pos, level)
		end
		return true
	elseif node.name == "air" then
		minetest.set_node(pos, {name = "etcetera:dust", param2 = dust_step})
		return true
	end
	return false
end

minetest.register_abm({
	label = "Spawn dust in room corners",
	nodenames = {"group:stone", "group:wood"},
	interval = 900,
	chance = 80,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local above_node = minetest.get_node(above)

		if above_node.name == "air" or above_node.name == "etcetera:dust" then
			local x_plus = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
			local x_minus = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
			local z_plus = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
			local z_minus = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})

			if (x_plus.name ~= "air" and z_plus.name ~= "air") or
			   (x_minus.name ~= "air" and z_minus.name ~= "air") or
			   (x_plus.name ~= "air" and z_minus.name ~= "air") or
			   (x_minus.name ~= "air" and z_plus.name ~= "air") then
				place_or_stack_dust(above)
			end
		end
	end
})

minetest.register_abm({
	label = "Spread dust",
	nodenames = {"etcetera:dust"},
	interval = 900,
	chance = 100,
	action = function(pos, node)
		local possible_positions = {
			{x = pos.x + 1, y = pos.y, z = pos.z},
			{x = pos.x - 1, y = pos.y, z = pos.z},
			{x = pos.x, y = pos.y, z = pos.z + 1},
			{x = pos.x, y = pos.y, z = pos.z - 1},
		}

		for _, new_pos in ipairs(possible_positions) do
			-- Only spread to air on top of a walkable surface
			local below = {x = new_pos.x, y = new_pos.y - 1, z = new_pos.z}
			local below_def = minetest.registered_nodes[minetest.get_node(below).name]
			if minetest.get_node(new_pos).name == "air" and
					below_def and below_def.walkable then
				place_or_stack_dust(new_pos)
				break
			end
		end
	end
})

-- LBM: fix old dust nodes that used raw param2 values (1-5) instead of leveled steps
minetest.register_lbm({
	label = "Fix dust node levels",
	name = "etcetera:fix_dust_levels_v1",
	nodenames = {"etcetera:dust"},
	run_at_every_load = true,
	action = function(pos, node)
		if node.param2 >= 1 and node.param2 <= 5 then
			-- Old format used param2 = 1..5 for height stages
			minetest.swap_node(pos, {name = "etcetera:dust", param2 = dust_step})
		elseif node.param2 == 0 then
			minetest.swap_node(pos, {name = "etcetera:dust", param2 = dust_step})
		end
	end,
})
