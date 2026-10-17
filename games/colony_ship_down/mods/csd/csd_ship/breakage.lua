-- Shooting out the lights.
--
-- A bullet that hits a ship light smashes it (rangedweapons calls the node's
-- on_bullet_hit). A broken light stays dark and spits the odd spark until
-- someone right-clicks it holding a Replacement Bulb, a new light of the same
-- kind, or a Mese lamp. Broken lights aren't part of the lighting modes, so a
-- red alert or blackout leaves them dark; once repaired they rejoin the ship's
-- current mode.

local S = csd_ship.S

local glass_sounds = core.global_exists("default") and default.node_sound_glass_defaults
	and default.node_sound_glass_defaults() or nil

-- light family -> its broken node
local BROKEN = {
	["csd_ship:light"] = "csd_ship:light_broken",
	["csd_ship:light_strip"] = "csd_ship:light_strip_broken",
}

-- What fixes what: any of these items, held while right-clicking.
local FIXES = {
	["csd_ship:light_broken"] = {"csd_ship:bulb", "csd_ship:light", "default:meselamp"},
	["csd_ship:light_strip_broken"] = {"csd_ship:bulb", "csd_ship:light_strip", "default:meselamp"},
}

core.register_craftitem("csd_ship:bulb", {
	description = S("Replacement Bulb") .. "\n" .. core.colorize("#9aa7c0", S("Right-click a broken light to fix it")),
	inventory_image = "csd_ship_bulb.png",
	groups = {csd_repair = 1},
})

core.register_craft({
	output = "csd_ship:bulb 2",
	recipe = {
		{"", "vessels:glass_fragments", ""},
		{"", "csd_tasks:scrap_metal", ""},
	},
})
core.register_craft({
	output = "csd_ship:bulb",
	recipe = {
		{"", "default:glass", ""},
		{"", "default:copper_ingot", ""},
	},
})

local function sparks(pos, amount)
	core.add_particlespawner({
		amount = amount, time = 0.3, pos = vector.offset(pos, 0, -0.45, 0),
		vel = {min = vector.new(-1.5, -2, -1.5), max = vector.new(1.5, 0, 1.5)}, acc = vector.new(0, -9, 0),
		exptime = {min = 0.3, max = 0.8}, size = {min = 0.5, max = 1.2}, glow = 14,
		collisiondetection = true, texture = "csd_ship_spark.png",
	})
end

local function repair(pos, node, clicker, itemstack)
	local fixes = FIXES[node.name]
	if not (clicker and clicker:is_player() and fixes) then return itemstack end
	local held = itemstack:get_name()
	local ok = false
	for _, f in ipairs(fixes) do
		if held == f then ok = true break end
	end
	if not ok then
		core.chat_send_player(clicker:get_player_name(),
			S("This light is smashed. Fix it with a Replacement Bulb or a new light."))
		return itemstack
	end
	local family = node.name == "csd_ship:light_broken" and "csd_ship:light" or "csd_ship:light_strip"
	local fam = csd_ship.light_families[family]
	core.swap_node(pos, {name = fam[csd_ship.lighting_mode] or family, param2 = node.param2})
	core.sound_play("csd_tasks_click", {pos = pos, gain = 0.6}, true)
	if not core.is_creative_enabled(clicker:get_player_name()) then itemstack:take_item() end
	return itemstack
end

local function register_broken(name, desc, tile, drop)
	core.register_node(name, {
		description = desc,
		tiles = {tile},
		paramtype = "light",
		light_source = 0,
		groups = {cracky = 3, csd_ship_light_broken = 1, not_in_creative_inventory = 1},
		sounds = glass_sounds,
		drop = drop,
		is_ground_content = false,
		on_rightclick = repair,
	})
end
register_broken("csd_ship:light_broken", S("Broken Ceiling Light"), "csd_ship_light_broken.png", "csd_ship:light")
register_broken("csd_ship:light_strip_broken", S("Broken Light Strip"), "csd_ship_light_strip_broken.png", "csd_ship:light_strip")

-- Every light of a family breaks into that family's broken node.
for name, fam in pairs(csd_ship.light_families) do
	local broken = BROKEN[fam.normal]
	if broken then
		core.override_item(name, {
			on_bullet_hit = function(pos, node)
				core.swap_node(pos, {name = broken, param2 = node.param2})
				core.sound_play("default_break_glass", {pos = pos, gain = 0.8, max_hear_distance = 24}, true)
				sparks(pos, 30)
			end,
		})
	end
end

-- Broken lights fizz now and then.
core.register_abm({
	label = "Broken light sparks",
	nodenames = {"group:csd_ship_light_broken"},
	interval = 4,
	chance = 3,
	action = function(pos)
		sparks(pos, 6)
		core.sound_play("csd_events_impact", {pos = pos, gain = 0.08, pitch = 2.2, max_hear_distance = 8}, true)
	end,
})
