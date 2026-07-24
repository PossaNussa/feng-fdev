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

-- Climate-aware wild spawn: warm (heat 55-88) + moderately humid (42-82)
-- mirrors the elysflowers on_generated pattern so the plant only appears in
-- appropriate subtropical/warm-temperate biomes.
minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y < 1 then return end

	local heatmap     = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local heightmap   = minetest.get_mapgen_object("heightmap")
	if not (heatmap and humiditymap and heightmap) then return end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({ MinEdge = emin, MaxEdge = emax })

	local c_air     = minetest.CONTENT_AIR
	local c_weed    = minetest.get_content_id("drugs:weed_bloom")
	local c_grass   = minetest.get_content_id("default:dirt_with_grass")
	local c_drgrass = minetest.get_content_id("default:dirt_with_dry_grass")

	local w  = maxp.x - minp.x + 1
	local d  = maxp.z - minp.z + 1
	local pr = PseudoRandom(seed + 5791)

	local STEP      = 8
	local CHANCE    = 800
	local HEAT_MIN  = 55
	local HEAT_MAX  = 88
	local HUMID_MIN = 42
	local HUMID_MAX = 82

	local ox = pr:next(0, STEP - 1)
	local oz = pr:next(0, STEP - 1)

	for dz = oz, d - 1, STEP do
		for dx = ox, w - 1, STEP do
			local idx   = dz * w + dx + 1
			local heat  = heatmap[idx]
			local humid = humiditymap[idx]
			if heat and humid
					and heat  >= HEAT_MIN and heat  <= HEAT_MAX
					and humid >= HUMID_MIN and humid <= HUMID_MAX then
				local y = heightmap[idx]
				if y and y >= 1 then
					local px = minp.x + dx
					local pz = minp.z + dz
					local vi_below = area:index(px, y,     pz)
					local vi_above = area:index(px, y + 1, pz)
					local cid_below = data[vi_below]
					if (cid_below == c_grass or cid_below == c_drgrass)
							and data[vi_above] == c_air
							and pr:next(1, CHANCE) == 1 then
						data[vi_above] = c_weed
					end
				end
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
end)

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

		-- Smoke puff from the player's head
		minetest.add_particlespawner({
			amount   = 10,
			time     = 4,
			minpos   = {x=pos.x-0.1, y=pos.y+1.4, z=pos.z-0.1},
			maxpos   = {x=pos.x+0.1, y=pos.y+1.7, z=pos.z+0.1},
			minvel   = {x=-0.1, y=0.3, z=-0.1},
			maxvel   = {x= 0.1, y=0.7, z= 0.1},
			minacc   = {x=0, y=0.03, z=0},
			maxacc   = {x=0, y=0.08, z=0},
			minexptime = 1.5,
			maxexptime = 3.0,
			minsize  = 0.6,
			maxsize  = 1.8,
			collisiondetection = false,
			texture  = "default_smoke.png",
		})

		-- Achievement: Red-eyed & Bleary
		if minetest.global_exists("awards") then
			awards.give_achievement(user:get_player_name(), "drugs_red_eyed_bleary")
		end
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

if minetest.global_exists("awards") then
	awards.register_achievement("drugs_red_eyed_bleary", {
		title       = "Red-eyed & Bleary",
		description = "Smoke a joint.",
		image       = "joint.png",
		icon        = "joint.png",
	})
end

minetest.register_abm({ --TODO:light and ground and air checks? no
	nodenames = {"drugs:weed_seeds", "drugs:weed_stem", "drugs:weed_plant"},
	interval = 5,
	chance = 5 * 5,
	catch_up = false,
	action = function(pos)
		-- Only grow within the same heat band the wild spawner uses (55-88).
		-- Outside that range the plant simply stalls; it won't die.
		local bd = minetest.get_biome_data(pos)
		if bd then
			local heat = bd.heat
			if heat < 55 or heat > 88 then return end
		end

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
