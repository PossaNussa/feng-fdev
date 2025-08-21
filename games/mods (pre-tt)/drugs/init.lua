minetest.register_node("drugs:weed_seeds", {
	description = "Weed Seeds",
	tiles = {"weed_seeds.png"},
	inventory_image = "weed_seeds.png",
	drawtype = "signlike",
	groups = {snappy = 3, oddly_breakable_by_hand = 1},
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
})

minetest.register_node("drugs:weed_stem", {
	description = "Weed Stem",
	tiles = {"weed_stem.png"},
	inventory_image = "weed_stem.png",
	drawtype = "plantlike",
	groups = {snappy = 3, oddly_breakable_by_hand = 1},
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
})

minetest.register_node("drugs:weed_plant", {
	description = "Weed Plant",
	tiles = {"weed_plant.png"},
	inventory_image = "weed_plant.png",
	drawtype = "plantlike",
	groups = {snappy = 3, oddly_breakable_by_hand = 1},
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
})

minetest.register_node("drugs:weed_bloom", {
	description = "Weed Plant (Bloomed)",
	tiles = {"weed_bloom.png"},
	inventory_image = "weed_bloom.png",
	drawtype = "plantlike",
	groups = {snappy = 3, oddly_breakable_by_hand = 1},
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	drop = {
		max_items = 5,
		items = {
			{items = {"drugs:weed_seeds"}},
			{items = {"drugs:weed_seeds"}, rarity = 2},
			{items = {"drugs:weed_seeds"}, rarity = 2},
			{items = {"drugs:weed_leaves"}},
			{items = {"drugs:weed_leaves"}, rarity = 2},
			{items = {"drugs:weed_leaves"}, rarity = 2},
		}
	},
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	fill_ratio = 0.001,
	height = 1,
	decoration = "drugs:weed_bloom",
})

minetest.register_craftitem("drugs:weed_leaves", {
	description = "Weed Leaves",
	inventory_image = "weed_leaves.png",
})

local roulette_of_nodes = {"default:water_source", "default:lava_source", "default:river_water_source", "default:mossycobble", "air"}
--[[minetest.register_on_mods_loaded(function()
	for node,def in pairs(minetest.registered_nodes) do
		if string.match(node, "default") then
			table.insert(roulette_of_nodes, node)
		end
	end
end)
--]]

local corrad = 69
--local coramt = 10
minetest.register_tool("drugs:weed_joint", {
	description = "Weed Joint",
	inventory_image = "joint.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:get_pos()
		--minetest.item_eat(2)
		local oldhp = user:get_hp()
		user:set_hp(oldhp + 3)
		--[[ -- old effect of randomizing nodes
		--for i=1,coramt do
			local corpos = {x=pos.x+math.random(-corrad,corrad), y=pos.y+math.random(-corrad,corrad), z=pos.z+math.random(-corrad,corrad)}
			minetest.set_node(corpos, {name=roulette_of_nodes[math.random(#roulette_of_nodes)]})
		--end
		--]]

		--more subtle 'randomizer'
		--for i=1,coramt do
			::retry1::
			local corpos1 = {x=pos.x+math.random(-corrad,corrad), y=pos.y+math.random(-corrad,corrad), z=pos.z+math.random(-corrad,corrad)}
			if minetest.get_node(corpos1).name == "air" or minetest.get_node(corpos1).name == "" or minetest.get_node(corpos1).name == "ignore" then goto retry1 end
			::retry2::
			local corpos2 = {x=pos.x+math.random(-corrad,corrad), y=pos.y+math.random(-corrad,corrad), z=pos.z+math.random(-corrad,corrad)}
			if minetest.get_node(corpos2).name == "air" or minetest.get_node(corpos2).name == "" or minetest.get_node(corpos2).name == "ignore" then goto retry2 end
			local cornod1 = minetest.get_node(corpos1).name
			local cornod2 = minetest.get_node(corpos2).name
			minetest.set_node(corpos1, {name=cornod2})
			minetest.set_node(corpos2, {name=cornod1})
		--end

		--random chance 1/1000 of being teleported to a random maze in the middle of nowhere
		if math.random(0,999) == 0 then
			local evilpos = {x=math.random(-30000,30000), y=math.random(-30000,30000), z=math.random(-30000,30000)}
			minetest.emerge_area({x=evilpos.x-20,y=evilpos.y-20,z=evilpos.z-20}, {x=evilpos.x+20,y=evilpos.y+20,z=evilpos.z+20})
			minetest.load_area({x=evilpos.x-20,y=evilpos.y-20,z=evilpos.z-20}, {x=evilpos.x+20,y=evilpos.y+20,z=evilpos.z+20})
			--generate safety toilet so player doesn't fall to death :)
			for i=evilpos.x-20,evilpos.x+20 do
			for j=evilpos.y-20,evilpos.y+20 do
			for k=evilpos.z-20,evilpos.z+20 do
				if math.random(0,2) < 2 then
					minetest.set_node({x=i,y=j,z=k}, {name="default:water_source"})
				else
					minetest.set_node({x=i,y=j,z=k}, {name="default:meselamp"})
				end
			end
			end
			end
			user:set_pos(evilpos)
		end

		itemstack:add_wear(15000)
		return itemstack
	end
})

minetest.register_craft({
	output = "drugs:weed_joint",
	recipe = {
		{"default:paper"},
		{"drugs:weed_leaves"},
		{"default:paper"},
	}
})

minetest.register_abm({ --TODO:light and ground and air checks? no
	nodenames = {"drugs:weed_seeds", "drugs:weed_stem", "drugs:weed_plant"},
	interval = 5,
	chance = 5 * 5,
	catch_up = false,
	action = function(pos)
		local old = minetest.get_node(pos).name
		if old == "drugs:weed_seeds" then
			minetest.set_node(pos, {name="drugs:weed_stem"})
		elseif old == "drugs:weed_stem" then
			minetest.set_node(pos, {name="drugs:weed_plant"})
		elseif old == "drugs:weed_plant" then
			minetest.set_node(pos, {name="drugs:weed_bloom"})
		end
	end
})
