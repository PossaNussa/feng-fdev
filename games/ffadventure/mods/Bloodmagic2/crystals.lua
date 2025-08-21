
armor:register_armor("bloodmagic2:gem_glitch", {
	description = "Bound Ambyryc Blood Gem\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Aen\nWear as armor\nAllows use of the sneak glitch"),
	inventory_image = "bm2_blood_gem_bound.png",
	texture = "bm2_null_hires.png",
	preview = "bm2_null_hires.png",
	groups = {armor_bm2_gem=1, armor_use=0},
	armor_groups = {},
	damage_groups = {},
})

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_armor"})
		if inv:contains_item("armor", "bloodmagic2:gem_glitch") then
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=true
			player:set_physics_override(playerPhysics)
		else
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=false
			player:set_physics_override(playerPhysics)
		end
	end
end)

minetest.register_craftitem("bloodmagic2:recipe_gem_glitch", {
	description = "Gem Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Aen\nRecipe: ladder, blood gem, stone of interference, 100 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_crystal.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 99 then
				if inv:contains_item("main", "default:ladder") and inv:contains_item("main", "bloodmagic2:blood_gem") and inv:contains_item("main", "bloodmagic2:runestone_interference") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-100)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "default:ladder")
					inv:remove_item("main", "bloodmagic2:blood_gem")
					inv:remove_item("main", "bloodmagic2:runestone_interference")
					inv:add_item("main", "bloodmagic2:gem_glitch")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})

armor:register_armor("bloodmagic2:gem_glitch_2", {
	description = "Bound Ambyryc Blood Gem\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Taen\nWear as armor\nAllows use of the sneak glitch\nand a 2 block jump height"),
	inventory_image = "bm2_blood_gem_bound_2.png",
	texture = "bm2_null_hires.png",
	preview = "bm2_null_hires.png",
	groups = {armor_bm2_gem=1, armor_use=0},
	armor_groups = {},
	damage_groups = {},
})

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_armor"})
		if inv:contains_item("armor", "bloodmagic2:gem_glitch_2") then
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=true
			playerPhysics.jump=1.5
			player:set_physics_override(playerPhysics)
		else
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=false
			playerPhysics.jump=1
			player:set_physics_override(playerPhysics)
		end
	end
end)

minetest.register_craftitem("bloodmagic2:recipe_gem_glitch_2", {
	description = "Gem Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Taen\nRecipe: ladder * 3, blood gem * 3, stone of interference * 3, 500 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_crystal.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 499 then
				if inv:contains_item("main", "default:ladder 3") and inv:contains_item("main", "bloodmagic2:blood_gem 3") and inv:contains_item("main", "bloodmagic2:runestone_interference 3") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-500)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "default:ladder 3")
					inv:remove_item("main", "bloodmagic2:blood_gem 3")
					inv:remove_item("main", "bloodmagic2:runestone_interference 3")
					inv:add_item("main", "bloodmagic2:gem_glitch_2")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})

armor:register_armor("bloodmagic2:gem_glitch_3", {
	description = "Bound Ambyryc Blood Gem\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Tethera\nWear as armor\nAllows use of the sneak glitch\nand a 3 block jump height"),
	inventory_image = "bm2_blood_gem_bound_3.png",
	texture = "bm2_null_hires.png",
	preview = "bm2_null_hires.png",
	groups = {armor_bm2_gem=1, armor_use=0},
	armor_groups = {},
	damage_groups = {},
})

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_armor"})
		if inv:contains_item("armor", "bloodmagic2:gem_glitch_3") then
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=true
			playerPhysics.jump=2
			player:set_physics_override(playerPhysics)
		else
			local playerPhysics = player:get_physics_override()
			playerPhysics.sneak_glitch=false
			playerPhysics.jump=1
			player:set_physics_override(playerPhysics)
		end
	end
end)

minetest.register_craftitem("bloodmagic2:recipe_gem_glitch_3", {
	description = "Gem Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Climbing Tethera\nRecipe: ladder * 5, blood gem * 5, stone of interference * 5, 1000 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_crystal.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 999 then
				if inv:contains_item("main", "default:ladder 5") and inv:contains_item("main", "bloodmagic2:blood_gem 5") and inv:contains_item("main", "bloodmagic2:runestone_interference 5") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-1000)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "default:ladder 5")
					inv:remove_item("main", "bloodmagic2:blood_gem 5")
					inv:remove_item("main", "bloodmagic2:runestone_interference 5")
					inv:add_item("main", "bloodmagic2:gem_glitch_3")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})

armor:register_armor("bloodmagic2:gem_protection_bypass", {
	description = "Bound Ambyryc Blood Gem\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Filch's Fethera\nWear as armor\nGrants protection_bypass"),
	inventory_image = "bm2_blood_gem_bound_4.png",
	texture = "bm2_null_hires.png",
	preview = "bm2_null_hires.png",
	groups = {armor_bm2_gem=1, armor_use=0},
	armor_groups = {},
	damage_groups = {},
})

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = minetest.get_inventory({type="detached", name=player:get_player_name().."_armor"})
		if inv:contains_item("armor", "bloodmagic2:gem_protection_bypass") or minetest.get_player_privs(player:get_player_name()).server then
			local playerPrivs = minetest.get_player_privs(player:get_player_name())
			playerPrivs["protection_bypass"] = true
			minetest.set_player_privs(player:get_player_name(), playerPrivs)
		else
			local playerPrivs = minetest.get_player_privs(player:get_player_name())
			playerPrivs["protection_bypass"] = nil
			minetest.set_player_privs(player:get_player_name(), playerPrivs)
		end
	end
end)

minetest.register_craftitem("bloodmagic2:recipe_gem_protection_bypass", {
	description = "Gem Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Crystal Structure: Filch's Fethera\nRecipe: diamond block * , skeleton key * 5, blood gem * 5, stone of interference * 5,  10000 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_crystal.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 9999 then
				if inv:contains_item("main", "bloodmagic2:runestone_interference 5") and inv:contains_item("main", "bloodmagic2:blood_gem 5") and inv:contains_item("main", "default:skeleton_key 5") and inv:contains_item("main", "default:diamondblock 5") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-10000)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "default:skeleton_key 5")
					inv:remove_item("main", "default:diamondblock 5")
					inv:remove_item("main", "bloodmagic2:blood_gem 5")
					inv:remove_item("main", "bloodmagic2:runestone_interference 5")
					inv:add_item("main", "bloodmagic2:gem_protection_bypass")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})