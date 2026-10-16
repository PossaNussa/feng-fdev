if not regional_weather.settings.ice
or not minetest.get_modpath("default")
or default.node_sound_glass_defaults == nil
then return end

local BLOCK_NAME = "regional_weather:ice"

local S = regional_weather.i18n

minetest.register_node(BLOCK_NAME, {
	description = S("Thin Ice"),
	tiles = {"(default_ice.png^[colorize:#ffffff:50)^[opacity:200"},
	paramtype = "light",
	groups = {
		cracky = 3,
		cools_lava = 1,
		slippery = 3,
		dig_immediate = 2,
		melts = 1
	},
	freezemelt = "default:river_water_source",
	sounds = default.node_sound_glass_defaults(),
	use_texture_alpha = "blend",
	drop = "",
	on_destruct = function(pos)
		-- asynchronous to avoid destruction loop
		minetest.after(0, function(pos)
			if minetest.get_node(pos).name ~= "air" then return end
			minetest.set_node(pos, { name = "default:river_water_source" })
		end, pos)
	end
})

-- Thin ice breaks when a player jumps on it
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		if pos then
			local under = {
				x = math.floor(pos.x + 0.5),
				y = math.floor(pos.y - 0.1),
				z = math.floor(pos.z + 0.5)
			}
			if minetest.get_node(under).name == BLOCK_NAME then
				local ctrl = player:get_player_control()
				if ctrl.jump then
					minetest.sound_play("default_break_glass", {
						pos = under, gain = 0.5, max_hear_distance = 12
					})
					minetest.remove_node(under)
				end
			end
		end
	end
end)

climate_api.register_abm({
	label			= "freeze river water",
	nodenames = { "default:river_water_source" },
	neighbors	= { "air" },
	interval	= 25,
	chance		= 3,
	catch_up	= false,

	conditions	= {
		min_height		= regional_weather.settings.min_height,
		max_height		= regional_weather.settings.max_height,
		max_heat		= 35,
		indoors			= false
	},

	action = function (pos, node, env)
		minetest.set_node(pos, { name = BLOCK_NAME })
	end
})

climate_api.register_abm({
	label			= "thicken thin ice",
	nodenames = { BLOCK_NAME },
	interval	= 60,
	chance		= 4,
	catch_up	= false,

	conditions	= {
		min_height		= regional_weather.settings.min_height,
		max_height		= regional_weather.settings.max_height,
		max_heat		= 30,
		indoors			= false
	},

	action = function (pos, node, env)
		minetest.set_node(pos, { name = "default:ice" })
	end
})

climate_api.register_abm({
	label			= "unfreeze river water",
	nodenames = { BLOCK_NAME },
	interval	= 25,
	chance		= 4,
	catch_up	= true,

	conditions	= {
		min_height		= regional_weather.settings.min_height,
		max_height		= regional_weather.settings.max_height,
		-- 36, not 35: river water freezes to thin ice at max_heat 35, so melting
		-- at exactly 35 too meant a tile at heat 35 froze and thawed on alternating
		-- ticks forever. 36 leaves a one-degree hysteresis band so thin ice settles.
		min_heat		= 36
	},

	action = function (pos, node, env)
		minetest.set_node(pos, { name = "default:river_water_source" })
	end
})

-- Thaw thick ice back to thin ice as it warms. Without this the freeze pipeline
-- was one-way: river water -> thin ice (max_heat 35) -> thick ice (max_heat 30),
-- but thick ice had no seasonal melt, so a river that froze solid in deep winter
-- stayed frozen forever. This is the reverse of "thicken thin ice"; the existing
-- "unfreeze river water" ABM above then finishes thin ice -> river water.
--
-- The heat window (>=33) sits between "thicken" (<=30) and "unfreeze" (>=35) so
-- the two ice tiers can't oscillate. Surface-only (air neighbour) and
-- height-gated like the other ice ABMs, so buried glacier ice and deep/polar
-- ocean ice -- which never reaches this heat anyway -- are left alone.
climate_api.register_abm({
	label			= "thaw thick ice to thin ice",
	nodenames = { "default:ice" },
	neighbors	= { "air" },
	interval	= 30,
	chance		= 5,
	catch_up	= true,

	conditions	= {
		min_height		= regional_weather.settings.min_height,
		max_height		= regional_weather.settings.max_height,
		min_heat		= 33,
		indoors			= false
	},

	action = function (pos, node, env)
		minetest.set_node(pos, { name = BLOCK_NAME })
	end
})
