-- Bug jars: a glass box with a specimen in it. Jarred bugs stop escaping,
-- stop dying of sunlight, and keep glowing, which is the whole point.

local S = wc_bugs.S

local glass = "default_glass.png"
local full_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}}

local function anim(texture, length)
	return {
		name = texture,
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = length
		},
	}
end

------------------------------------------------------------------------
local function register_bugjar(bug, desc, inside, light)
	local jar = "wc_bugs:jar_" .. bug
	local caught = "wc_bugs:" .. bug

	minetest.register_node(jar, {
		description = S("@1 Specimen", desc),
		drawtype = "mesh",
		mesh = "plantlikestorebox.obj",
		-- Model groups are sides, bottom, top, inside.
		tiles = {glass, glass, glass, inside},
		use_texture_alpha = "blend",
		selection_box = full_box,
		collision_box = full_box,
		paramtype = "light",
		sunlight_propagates = true,
		light_source = light,
		stack_max = 1,
		groups = {
			bugjar = 1,
			snappy = 3,
			oddly_breakable_by_hand = 3,
			vessel = 1
		},
		sounds = default.node_sound_glass_defaults(),
		-- Open it up and the occupant makes for the nearest gap.
		on_rightclick = function(pos, node, player)
			local pname = player and player:get_player_name() or ""
			if minetest.is_protected(pos, pname) then
				minetest.record_protection_violation(pos, pname)
				return
			end
			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			local free = minetest.get_node(above).name == "air"
					and not minetest.is_protected(above, pname)
			minetest.set_node(pos, {name = "default:glass"})
			if free then
				minetest.set_node(above, {name = caught})
			else
				minetest.add_item(pos, caught)
			end
			minetest.sound_play("default_break_glass",
				{pos = pos, gain = 0.2, max_hear_distance = 8}, true)
		end
	})

	minetest.register_craft({
		output = jar,
		recipe = {
			{"default:glass"},
			{caught},
		}
	})
end

------------------------------------------------------------------------
register_bugjar("luxmoth", S("Luxmoth"),
	anim("wc_bugs_luxmoth.png", 2.4), 7)
register_bugjar("torchbug", S("Torchbug"),
	anim("wc_bugs_torchbug.png", 1.8), 6)
register_bugjar("flamebug", S("Flamebug"),
	anim("wc_bugs_firebug.png", 0.8), 10)

register_bugjar("peatle", S("Peatle"),
	"(default_dirt.png^[colorize:#2b1c0a:60)^[mask:wc_bugs_bug_mask.png", nil)
register_bugjar("prillbug", S("Prillbug"),
	"(default_steel_block.png^[colorize:#4a3a2a:70)^[mask:wc_bugs_bug_mask.png",
	nil)

if minetest.registered_nodes["wc_bugs:termite"] then
	register_bugjar("termite", S("Termite"), "wc_bugs_termite.png", nil)
end
