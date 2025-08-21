
minetest.register_craftitem("bloodmagic2:flask_hp", {
	description = "HP up Flask\n"..minetest.colorize("#9b1a1a", "Use to heal yourself"),
	inventory_image = "vessels_glass_bottle.png^bm2_potion_overlay.png",
	on_use = function(itemstack, user, pointed_thing)
		user:set_hp(20)
		itemstack:take_item()
		return itemstack
	end
})

minetest.register_craftitem("bloodmagic2:recipe_flask_hp", {
	description = "Flask Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Potion: Health up\nRecipe: red mushroom, glass bottle, stone of catalysis, 100 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_flask.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 99 then
				if inv:contains_item("main", "flowers:mushroom_red") and inv:contains_item("main", "vessels:glass_bottle") and inv:contains_item("main", "bloodmagic2:runestone_catalysis") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-100)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "flowers:mushroom_red")
					inv:remove_item("main", "vessels:glass_bottle")
					inv:remove_item("main", "bloodmagic2:runestone_catalysis")
					inv:add_item("main", "bloodmagic2:flask_hp")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})

minetest.register_craftitem("bloodmagic2:flask_float", {
	description = "Antimeteor Flask\n"..minetest.colorize("#9b1a1a", "Use to reverse gravity"),
	inventory_image = "vessels_glass_bottle.png^bm2_potion_overlay_2.png",
	on_use = function(itemstack, user, pointed_thing)
		playereffects.apply_effect_type("bm2:floating", "5", user, 1)
		local playerPhysics = user:get_physics_override()
		playerPhysics.gravity=-0.1
		user:set_physics_override(playerPhysics)
		minetest.after(5, function()
			local playerPhysics = user:get_physics_override()
			playerPhysics.gravity=1
			user:set_physics_override(playerPhysics)
		end)
		itemstack:take_item()
		return itemstack
	end
})

minetest.register_craftitem("bloodmagic2:recipe_flask_float", {
	description = "Flask Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Potion: Antimeteor\nRecipe: sap tube, glass bottle, stone of catalysis, 100 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_flask.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 99 then
				if inv:contains_item("main", "bloodmagic2:tube_sap") and inv:contains_item("main", "vessels:glass_bottle") and inv:contains_item("main", "bloodmagic2:runestone_catalysis") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-100)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "bloodmagic2:tube_sap")
					inv:remove_item("main", "vessels:glass_bottle")
					inv:remove_item("main", "bloodmagic2:runestone_catalysis")
					inv:add_item("main", "bloodmagic2:flask_float")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})
