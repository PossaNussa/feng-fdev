
table.insert(armor.elements, "bm2_gem")

minetest.register_craftitem("bloodmagic2:needle", {
	description = "Needle\n"..minetest.colorize("#9b1a1a", "Use to extract blood from thine own veins"),
	inventory_image = "bm2_needle.png",
	on_use = function(itemstack, user, pointed_thing)
		itemstack:set_count(itemstack:get_count()-1)
		if playereffects.has_effect_type(user:get_player_name(), "bm2:blood_poisoning") then
			user:get_inventory():add_item("main", "bloodmagic2:needle_blood_contaminated")
		else
			user:get_inventory():add_item("main", "bloodmagic2:needle_blood")
		end
		user:set_hp(user:get_hp()-1)
		playereffects.apply_effect_type("bm2:blood_poisoning", "30", user, 2)
		return itemstack
	end,
})

minetest.register_craftitem("bloodmagic2:needle_sterile", {
	description = "Sterile Needle\n"..minetest.colorize("#9b1a1a", "Use to safely extract blood from thine own veins"),
	inventory_image = "bm2_needle.png",
	on_use = function(itemstack, user, pointed_thing)
		itemstack:set_count(itemstack:get_count()-1)
		if playereffects.has_effect_type(user:get_player_name(), "bm2:blood_poisoning") then
			user:get_inventory():add_item("main", "bloodmagic2:needle_blood_contaminated")
		else
			user:get_inventory():add_item("main", "bloodmagic2:needle_blood")
		end
		user:set_hp(user:get_hp()-1)
		return itemstack
	end,
})

minetest.register_craftitem("bloodmagic2:needle_blood", {
	description = "Blood-Filled Needle\n"..minetest.colorize("#9b1a1a", "'Berry Juice?'"),
	inventory_image = "bm2_needle_blood.png",
})

minetest.register_craftitem("bloodmagic2:needle_blood_contaminated", {
	description = "Septic Blood Filled Needle\n"..minetest.colorize("#9b1a1a", "'Broccoli Juice?'"),
	inventory_image = "bm2_needle_blood_contaminated.png",
})

minetest.register_craftitem("bloodmagic2:tube", {
	description = "Extricable Tube\n"..minetest.colorize("#9b1a1a", "Craft with a needle to Extract its liquid"),
	inventory_image = "bm2_extri_tube.png",
})

minetest.register_craftitem("bloodmagic2:tube_blood", {
	description = "Blood-Filled Tube\n"..minetest.colorize("#9b1a1a", "Used for blood stuff"),
	inventory_image = "bm2_extri_tube_blood.png",
})

minetest.register_craftitem("bloodmagic2:tube_blood_contaminated", {
	description = "Contaminated Blood Filled Tube\n"..minetest.colorize("#9b1a1a", "Used for painful blood stuff"),
	inventory_image = "bm2_extri_tube_blood_contaminated.png",
})

minetest.register_craftitem("bloodmagic2:tube_serum", {
	description = "Blood Serum Filled Tube\n"..minetest.colorize("#9b1a1a", "Used for suspicious stuff"),
	inventory_image = "bm2_extri_tube_serum.png",
})

minetest.register_craftitem("bloodmagic2:tube_leaf", {
	description = "Tube With A Leaf\n"..minetest.colorize("#9b1a1a", "Used for vege stuff"),
	inventory_image = "bm2_extri_tube_leaf.png",
})

minetest.register_craftitem("bloodmagic2:tube_sap", {
	description = "Sap-Filled Tube\n"..minetest.colorize("#9b1a1a", "Used for sappy stuff"),
	inventory_image = "bm2_extri_tube_sap.png",
})

minetest.register_craftitem("bloodmagic2:knife", {
	description = "Hymyrian Knife\n"..minetest.colorize("#9b1a1a", "Use to place a bloody rune"),
	inventory_image = "bm2_knife.png",
	stack_max=1,
	on_use = function(itemstack, user, pointed_thing)
		user:set_hp(user:get_hp()-2)
		if minetest.get_node(user:get_pos()).name=="air" then
			minetest.set_node(user:get_pos(), {name="bloodmagic2:rune_"..math.random(1,5)})
		end
	end,
})

minetest.register_craftitem("bloodmagic2:knife_2", {
	description = "Ilvaryan Knife\n"..minetest.colorize("#9b1a1a", "Use to throw a magic bolt"),
	inventory_image = "bm2_knife_t.png",
	stack_max=15,
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:getpos()
		local dir = user:get_look_dir()
		local yaw = user:get_look_yaw()
		if pos and dir and yaw then
			pos.y = pos.y + 1.6
			local obj = minetest.add_entity(pos, "bloodmagic2:knife_prj")
			if obj then
				obj:setvelocity({x=dir.x * 45, y=dir.y * 45, z=dir.z * 45})
				obj:setacceleration({x=dir.x * 0, y=0, z=dir.z * 0})
				obj:setyaw(yaw + math.pi)
				local ent = obj:get_luaentity()
				if ent then
					ent.player = ent.player or user
				end
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})

minetest.register_craftitem("bloodmagic2:knife_22", {
	wield_scale = {x=2,y=2,z=1.0},
	inventory_image = "bm2_knife_t2.png",
})

local proj = {
	physical = false,
	timer = 0,
	visual = "wielditem",
	visual_size = {x=0.3, y=0.3},
	textures = {"bloodmagic2:knife_22"},
	lastpos= {},
	collisionbox = {0, 0, 0, 0, 0, 0},
}
proj.on_step = function(self, dtime)
	self.timer = self.timer + dtime
	local pos = self.object:getpos()
	local node = minetest.get_node(pos)
	if self.timer > 0.065 then
		local objs = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 1.5)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "bloodmagic2:knife_prj" and obj:get_luaentity().name ~= "__builtin:item" then
					local damage = 14
					obj:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups= {fleshy = damage},
					}, nil)
					self.object:remove()
				end
			else
				local damage = 14
				obj:punch(self.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups= {fleshy = damage},
				}, nil)
				self.object:remove()
			end
		end
	end

	if self.lastpos.x ~= nil then
		if minetest.registered_nodes[node.name].walkable then
			self.object:remove()
		end
	end
	self.lastpos= {x = pos.x, y = pos.y, z = pos.z}
end

minetest.register_entity("bloodmagic2:knife_prj", proj)


minetest.register_craftitem("bloodmagic2:transfuser", {
	description = "Transfuser\n"..minetest.colorize("#9b1a1a", "Use to cure septicimia.\nRequires clean blood tubes"),
	inventory_image = "bm2_transfuser.png",
	stack_max=1,
	on_use = function(itemstack, user, pointed_thing)
		if user:get_inventory():contains_item("main", "bloodmagic2:tube_blood") then
			user:get_inventory():remove_item("main", "bloodmagic2:tube_blood")
			user:get_inventory():add_item("main", "bloodmagic2:tube")
			playereffects.cancel_effect_type("bm2:blood_poisoning", true, user:get_player_name())
		end
		user:set_hp(user:get_hp()-1)
	end,
})

minetest.register_craftitem("bloodmagic2:blood_gem", {
	description = "Ambyryc Blood Gem\n"..minetest.colorize("#9b1a1a", "The heart of any visceral machination"),
	inventory_image = "bm2_blood_gem.png",
})

minetest.register_craftitem("bloodmagic2:runestone", {
	description = "Blank Stone\n"..minetest.colorize("#9b1a1a", "A stone shaped perfectly for runic carvings"),
	inventory_image = "bm2_rune_blank.png",
})

minetest.register_craftitem("bloodmagic2:runestone_catalysis", {
	description = "Stone of Catalysis\n"..minetest.colorize("#9b1a1a", "Activates alchemical processes"),
	inventory_image = "bm2_rune_catalysis.png",
})

minetest.register_craftitem("bloodmagic2:runestone_interference", {
	description = "Stone of Interference\n"..minetest.colorize("#9b1a1a", "Modifies non-physical properties"),
	inventory_image = "bm2_rune_interference.png",
})

minetest.register_craftitem("bloodmagic2:runestone_template", {
	description = "Stone of Bearing\n"..minetest.colorize("#9b1a1a", "Holds configurations of energy"),
	inventory_image = "bm2_rune_holding.png",
})

minetest.register_craftitem("bloodmagic2:ritual_dagger", {
	description = "Ritual Dagger\n"..minetest.colorize("#9b1a1a", "Click on an altar to add Viscera Vapor"),
	inventory_image = "bm2_dagger.png",
	stack_max=1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			
			minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")+10)
			minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
		end
		user:set_hp(user:get_hp()-2)
	end,
})

minetest.register_craftitem("bloodmagic2:god_dagger", {
	description = "Deitic Dagger\n"..minetest.colorize("#9b1a1a", "Click on an altar to add Viscera Vapor"),
	inventory_image = "bm2_dagger_d.png",
	stack_max=1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			
			minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")+100)
			minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
		end
		user:set_hp(user:get_hp()-2)
	end,
})

minetest.register_craftitem("bloodmagic2:recipe_god_dagger", {
	description = "Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Alchemical Construct: Deitic Dagger\nRecipe: ritual dagger, blood gem * 2, stone of bearing, hp up flask * 50, hemoglod ingot * 10, 1000 viscera vapor\nuse on altar with these items to craft"),
	inventory_image = "bm2_parchment_alk.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type=="node" and minetest.get_node(pointed_thing.under).name=="bloodmagic2:altar" then
			local inv=user:get_inventory()
			local sb=minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")
			if sb > 999 then
				if inv:contains_item("main", "bloodmagic2:ritual_dagger") and inv:contains_item("main", "bloodmagic2:blood_gem 2") and inv:contains_item("main", "bloodmagic2:runestone_template") and inv:contains_item("main", "bloodmagic2:hemoglod 10") and inv:contains_item("main", "bloodmagic2:flask_hp 50") then
					minetest.get_meta(pointed_thing.under):set_int("BM2_BLOOD_STORAGE", minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE")-1000)
					minetest.get_meta(pointed_thing.under):set_string("infotext", "Viscera Vapor: "..minetest.get_meta(pointed_thing.under):get_int("BM2_BLOOD_STORAGE"))
					inv:remove_item("main", "bloodmagic2:ritual_dagger")
					inv:remove_item("main", "bloodmagic2:blood_gem 2")
					inv:remove_item("main", "bloodmagic2:runestone_template")
					inv:remove_item("main", "bloodmagic2:hemoglod 10")
					inv:remove_item("main", "bloodmagic2:flask_hp 50")
					inv:add_item("main", "bloodmagic2:god_dagger")
					itemstack:take_item()
					return itemstack
				end
			end
			
		end
	end,
})

minetest.register_craftitem("bloodmagic2:parchment", {
	description = "Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Good for marking with blood"),
	inventory_image = "bm2_parchment.png",
})

minetest.register_craftitem("bloodmagic2:parchment_flask", {
	description = "Flask Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Used for making potions"),
	inventory_image = "bm2_parchment_flask.png",
})

minetest.register_craftitem("bloodmagic2:parchment_gem", {
	description = "Gem Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Used for making magic gems"),
	inventory_image = "bm2_parchment_crystal.png",
})

minetest.register_craftitem("bloodmagic2:parchment_alchemical", {
	description = "Alchemy Ritual Recipe Parchment\n"..minetest.colorize("#9b1a1a", "Used for making alchemical constructs"),
	inventory_image = "bm2_parchment_alk.png",
})

minetest.register_craftitem("bloodmagic2:hemoglod", {
	description = "Hemoglod Ingot\n"..minetest.colorize("#9b1a1a", "Used for making alchemical constructs"),
	inventory_image = "bm2_hemoglod_ingot.png",
})

minetest.register_tool("bloodmagic2:scramrax", {
	description = "Hemoglod Scramrax",
	inventory_image = "bm2_scramrax.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.20, [2]=0.60, [3]=0.30}, uses=80, maxlevel=3},
			choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=80, maxlevel=3},
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=160, maxlevel=3},
			cracky = {times={[1]=2.4, [2]=1.2, [3]=0.60}, uses=80, maxlevel=3},
		},
		damage_groups = {fleshy=14},
	},
	sound = {breaks = "default_tool_breaks"},
})