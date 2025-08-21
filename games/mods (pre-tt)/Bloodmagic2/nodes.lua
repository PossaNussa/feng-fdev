
for i=1,5 do
	minetest.register_node("bloodmagic2:rune_"..i, {
		description = "",
		drawtype = "nodebox",
		tiles = {"bm2_rune_"..i..".png"},
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory=1},
		drop="",
		selection_box = {
			type = "fixed",
			fixed =  {{-1/2, -1/2, -1/2, 1/2, -1/2.1, 1/2}}
		},
		node_box = {
			type = "fixed",
			fixed =  {{-1/2, -1/2, -1/2, 1/2, -1/2.1, 1/2}}
		},
		on_punch = function(pos, node, player, pointed_thing)
			if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name=="bloodmagic2:altar_stone" then
				minetest.set_node(pos, {name="air"})
				minetest.set_node({x=pos.x, y=pos.y-1, z=pos.z}, {name="bloodmagic2:altar"})
			end
		end,
	})
end

minetest.register_node("bloodmagic2:altar_stone", {
	description = "Altar Stone"..minetest.colorize("#9b1a1a", "\nUse a hymyrian knife while standing on top, then punch the rune"),
	tiles = {"default_stone.png^bm2_altar_proto.png", "default_stone.png^bm2_altar_proto.png", "default_stone.png^bm2_altar_proto.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		minetest.get_meta(pos):set_int("BM2_BLOOD_STORAGE", 0)
		minetest.get_meta(pos):set_string("infotext", "Viscera Vapor: 0")
	end
})

minetest.register_node("bloodmagic2:altar", {
	description = "Blood Altar",
	tiles = {"default_stone.png^bm2_altar_top.png", "default_stone.png", "default_stone.png^bm2_altar_side.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		minetest.get_meta(pos):set_int("BM2_BLOOD_STORAGE", 0)
		minetest.get_meta(pos):set_string("infotext", "Viscera Vapor: 0")
	end
})