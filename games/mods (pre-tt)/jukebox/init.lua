local S = minetest.get_translator("jukebox")

jukebox = {}
jukebox.registered_discs = {}

function jukebox.register_disc(name, def)
	def.stack_max = 1
	
	local music_name = def.music_name
	def.music_name = nil

	minetest.register_craftitem(":" .. name, def)

	jukebox.registered_discs[name] = music_name
end

-- +-----------+
-- |  The Box  |
-- +-----------+


local handlers = {}

minetest.register_node("jukebox:box", {
	description = S("Record Player"),
	paramtype2 = "facedir",
	stack_max = 1,
	tiles = {
		"jukebox_top.png", "default_wood.png", "jukebox_side.png",
		"jukebox_side.png", "jukebox_side.png", "jukebox_front.png"
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
	end,

	on_destruct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if inv:is_empty("main") then return end

		local drop_pos = minetest.find_node_near(pos, 1, "air")
		if not drop_pos then drop_pos = {x = pos.x, y = pos.y + 1, z = pos.z} end

		minetest.add_item(drop_pos, inv:get_stack("main", 1))
		inv:remove_item("main", inv:get_stack("main", 1))

		local pos_string = minetest.pos_to_string(pos)

		if handlers[pos_string] then
			minetest.sound_stop(handlers[pos_string])
		end
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local pos_string = minetest.pos_to_string(pos)

		if inv:is_empty("main") then
			local item_name = itemstack:get_name()
			local music_name = jukebox.registered_discs[item_name]

			if not music_name then return end

			inv:set_stack("main", 1, itemstack:take_item())

			local handle = minetest.sound_play(music_name, {
				pos = pos,
				gain = 0.5,
				max_hear_distance = 25,
				loop = true
			})

			handlers[pos_string] = handle

			meta:set_string("music_name", music_name) -- for LBM
		else
			local drop_pos = minetest.find_node_near(pos, 1, "air")
			if not drop_pos then drop_pos = {x = pos.x, y = pos.y + 1, z = pos.z} end

			minetest.add_item(drop_pos, inv:get_stack("main", 1))
			inv:remove_item("main", inv:get_stack("main", 1))

			if handlers[pos_string] then
				minetest.sound_stop(handlers[pos_string])
			end
		end
	end
})

minetest.register_lbm({
	name = "jukebox:resume_playing",
	nodenames = "jukebox:box",
	action = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local pos_string = minetest.pos_to_string(pos)

		if inv:is_empty("main") then return end
		if handlers[pos_string] then return end

		local music_name = meta:get_string("music_name")
		local handle = minetest.sound_play(music_name, {
			pos = pos,
			gain = 0.5,
			max_hear_distance = 25,
			loop = true
		})

		handlers[pos_string] = handle
	end
})

minetest.register_craft({
	output = "jukebox:box",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "mesecons_luacontroller:luacontroller0000", "group:wood"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

-- +---------+
-- |  Discs  |
-- +---------+

-- Registering disc 1
minetest.register_craftitem("jukebox:disc_1", {
    description = "Midnight at The Park by M.C. Monarch",
    inventory_image = "jukebox_disc_1.png",
    music_name = "jukebox_disc_1"
})
jukebox.registered_discs["jukebox:disc_1"] = "jukebox_disc_1"

-- Registering disc 2
minetest.register_craftitem("jukebox:disc_2", {
    description = "It's Dangerous Out There by M.C. Monarch",
    inventory_image = "jukebox_disc_2.png",
    music_name = "jukebox_dangerous"
})
jukebox.registered_discs["jukebox:disc_2"] = "jukebox_disc_2"

-- Registering disc 3
minetest.register_craftitem("jukebox:disc_3", {
    description = "Sunrise, Coffee, Joint by M.C. Monarch",
    inventory_image = "jukebox_disc_3.png",
    music_name = "jukebox_sunrise"
})
jukebox.registered_discs["jukebox:disc_3"] = "jukebox_disc_3"

-- Registering disc 4
minetest.register_craftitem("jukebox:disc_4", {
    description = "Mafia Talk by M.C. Monarch",
    inventory_image = "jukebox_disc_4.png",
    music_name = "jukebox_mafia"
})
jukebox.registered_discs["jukebox:disc_4"] = "jukebox_disc_4"

-- Registering disc 5
minetest.register_craftitem("jukebox:disc_5", {
    description = "Music Disc 5",
    inventory_image = "jukebox_disc_5.png",
    music_name = "jukebox_disc_5"
})
jukebox.registered_discs["jukebox:disc_5"] = "jukebox_disc_5"

-- Registering disc 6
minetest.register_craftitem("jukebox:disc_6", {
    description = "Music Disc 6",
    inventory_image = "jukebox_disc_6.png",
    music_name = "jukebox_disc_6"
})
jukebox.registered_discs["jukebox:disc_6"] = "jukebox_disc_6"

-- Registering disc 7
minetest.register_craftitem("jukebox:disc_7", {
    description = "Music Disc 7",
    inventory_image = "jukebox_disc_7.png",
    music_name = "jukebox_disc_7"
})
jukebox.registered_discs["jukebox:disc_7"] = "jukebox_disc_7"

-- Registering disc 8
minetest.register_craftitem("jukebox:disc_8", {
    description = "Music Disc 8",
    inventory_image = "jukebox_disc_8.png",
    music_name = "jukebox_disc_8"
})
jukebox.registered_discs["jukebox:disc_8"] = "jukebox_disc_8"

-- Registering disc 9
minetest.register_craftitem("jukebox:disc_9", {
    description = "Music Disc 9",
    inventory_image = "jukebox_disc_9.png",
    music_name = "jukebox_disc_9"
})
jukebox.registered_discs["jukebox:disc_9"] = "jukebox_disc_9"

minetest.register_craft({
	output = "jukebox:disc_1",
	recipe = {
		{"", "default:coal_lump", ""},
		{"default:coal_lump", "default:gold_lump", "default:coal_lump"},
		{"", "default:coal_lump", ""}
	}
})

