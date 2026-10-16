-- Part 1: Concrete (Liquid)
-- Register liquid concrete source
minetest.register_node("default:liquid_concrete", {
	description = "Liquid Concrete Source",
	drawtype = "liquid",
	tiles = {"soft_concrete.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquidtype = "source",
	liquid_alternative_flowing = "default:liquid_concrete_flowing",
	liquid_alternative_source = "default:liquid_concrete",
	liquid_viscosity = 16,
	liquid_range = 4,
	post_effect_color = {a = 100, r = 100, g = 100, b = 100},
	groups = {liquid = 3},
})

-- Register liquid concrete flowing
minetest.register_node("default:liquid_concrete_flowing", {
	description = "Flowing Concrete",
	drawtype = "flowingliquid",
	tiles = {"soft_concrete.png"},
	special_tiles = {"soft_concrete.png", "soft_concrete.png"},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:liquid_concrete_flowing",
	liquid_alternative_source = "default:liquid_concrete",
	liquid_viscosity = 16,
	liquid_range = 4,
	post_effect_color = {a = 100, r = 100, g = 100, b = 100},
	groups = {liquid = 3, not_in_creative_inventory = 1},
})

-- Slow player down when swimming in concrete
minetest.register_abm({
	nodenames = {"default:liquid_concrete"},
	interval = 1.0,  -- Run every 1 second
	chance = 1, -- Always run
	action = function(pos, node, active_object_count, active_object_count_wider)
		for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 1.0)) do
			if obj:is_player() then
				local physics_o = obj:get_physics_override()
				physics_o.speed = 0.2  -- 80% slower
				obj:set_physics_override(physics_o)
			end
		end
	end
})

-- Transition liquid concrete to soft concrete after half an in-game day
minetest.register_abm({
	nodenames = {"default:liquid_concrete", "default:liquid_concrete_flowing"},
	interval = 1200, -- Half an in-game day
	chance = 1,
	action = function(pos, node)
		minetest.set_node(pos, {name = "default:soft_concrete"})
	end,
})


-- Part 2: Soft Concrete and Ruined Concrete
minetest.register_node("default:soft_concrete", {
	description = "Soft Concrete",
	tiles = {"soft_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "default:soft_broomswept_concrete"})
	end,
})

minetest.register_node("default:soft_broomswept_concrete", {
	description = "Soft Broomswept Concrete",
	tiles = {"soft_broomswept_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "default:soft_concrete"})
	end,
})

minetest.register_node("default:ruined_soft_concrete", {
    description = "Ruined Soft Concrete",
    tiles = {"ruined_soft_concrete.png"},
    groups = {oddly_breakable_by_hand = 2},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        minetest.set_node(pos, {name = "default:soft_concrete"})
    end,
})

minetest.register_node("default:ruined_soft_broomswept_concrete", {
    description = "Ruined Soft Broomswept Concrete",
    tiles = {"ruined_soft_broomswept_concrete.png"},
    groups = {oddly_breakable_by_hand = 2},
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        minetest.set_node(pos, {name = "default:soft_broomswept_concrete"})
    end,
})

-- If player steps on soft concrete, it turns into ruined concrete
minetest.register_abm({
	nodenames = {"default:soft_concrete", "default:soft_broomswept_concrete"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 1.0)) do
			if obj:is_player() then
				local new_node_name = "default:ruined_" .. string.gsub(node.name, "default:", "")
				minetest.set_node(pos, {name = new_node_name})
			end
		end
	end
})


--Hardened concrete nodes

minetest.register_node("default:concrete", {
	description = "Concrete",
	tiles = {"concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:broomswept_concrete", {
	description = "Broomswept Concrete",
	tiles = {"broomswept_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:ruined_concrete", {
	description = "Ruined Concrete",
	tiles = {"ruined_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:ruined_broomswept_concrete", {
	description = "Ruined Broomswept Concrete",
	tiles = {"ruined_broomswept_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:cracked_concrete", {
	description = "Cracked Concrete",
	tiles = {"cracked_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:cracked_broomswept_concrete", {
	description = "Cracked Broomswept Concrete",
	tiles = {"cracked_broomswept_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:cracked_ruined_concrete", {
	description = "Cracked, Ruined Concrete",
	tiles = {"cracked_ruined_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})

minetest.register_node("default:ruined_broomswept_concrete", {
	description = "Cracked, Ruined Broomswept Concrete",
	tiles = {"cracked_ruined_broomswept_concrete.png"},
	groups = {oddly_breakable_by_hand = 2},
})


-- ABM to harden soft concrete
minetest.register_abm({
	nodenames = {"default:soft_concrete", "default:soft_broomswept_concrete", "default:ruined_soft_concrete", "default:ruined_soft_broomswept_concrete"},
	interval = 1200,  -- another half in-game day
	chance = 1,
	action = function(pos, node)
		local new_node_name = string.gsub(node.name, "soft_", "")
		new_node_name = string.gsub(new_node_name, "ruined_soft_", "ruined_")
		minetest.set_node(pos, {name = new_node_name})
	end
})



-- ABM to crack concrete under load
minetest.register_abm({
	nodenames = {"default:concrete", "default:broomswept_concrete", "default:ruined_concrete", "default:ruined_broomswept_concrete"},
	interval = 7200,
	chance = 100,
	action = function(pos, node)
		local above_count = 0
		for y = 1, 5 do
			local new_pos = {x = pos.x, y = pos.y + y, z = pos.z}
			if minetest.get_node(new_pos).name ~= "air" then
				above_count = above_count + 1
			end
		end
		if above_count > 5 then
			local new_node_name = "cracked_" .. string.gsub(node.name, "ruined_", "")
			minetest.set_node(pos, {name = new_node_name})
		end
	end
})

-- Part 3: Crafting Recipe
minetest.register_craft({
	output = "bucket:bucket_cement",
	recipe = {
		{"", "default:gravel", "default:gravel"},
		{"default:gravel", "bucket:bucket_water", "default:sand"},
	},
})

