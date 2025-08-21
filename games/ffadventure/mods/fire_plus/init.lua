fire_plus = {
	burn_interval = 1,
	tnt_explode_radius = 1.5,
	burning = {--[[
		["playername"] = {
			burns_left = <number>,
			hud_id     = <hud id>,
			sound_id   = <sound id>,
			particlespawner_id = <particlespawner id>
		}
	]]},
	-- Keys may be exact node names/prefix fragments (matched with string.find)
	-- or groups using the form "group:<groupname>".
	ignition_nodes = {
		["default:lava"]         = {burns = 2, damage = 4},
		["fire:"]                = {burns = 4, damage = 2},
		["default:torch_ceiling"]= {burns = 4, damage = 1},
		["default:torch_wall"]   = {burns = 4, damage = 1},
		["default:torch"]        = {burns = 4, damage = 1},
		["group:torch"]          = {burns = 4, damage = 1}, -- works with any node that has group torch
		["group:lava"]           = {burns = 2, damage = 4}, -- if your game defines a lava group
	},
	-- Entries may be exact/prefix strings or "group:<groupname>"
	extinguishers = {
		"default:water",
		"default:river_water",
		"default:snow",
		"group:water",  -- treat any water-like node as extinguisher if grouped
		"group:snowy",  -- if your game uses 'snowy' group
	}
}

dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/api.lua")

-- Helpers --------------------------------------------------------------------

local function node_in_group(nodename, groupname)
	return minetest.get_item_group(nodename, groupname) > 0
end

local function match_list_with_groups(nodename, list)
	for _, key in pairs(list) do
		if type(key) == "string" then
			if key:sub(1, 6) == "group:" then
				local grp = key:sub(7)
				if node_in_group(nodename, grp) then
					return true
				end
			else
				-- substring/prefix match (keeps prior behavior)
				if nodename:find(key, 1, true) then
					return true
				end
			end
		end
	end
	return false
end

local function match_map_with_groups(nodename, map)
	for key, def in pairs(map) do
		if type(key) == "string" then
			if key:sub(1, 6) == "group:" then
				local grp = key:sub(7)
				if node_in_group(nodename, grp) then
					return def
				end
			else
				-- substring/prefix match (keeps prior behavior)
				if nodename:find(key, 1, true) then
					return def
				end
			end
		end
	end
	return nil
end

-- Logic ----------------------------------------------------------------------

local time = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime

	if time < 0.1 then
		return
	else
		time = 0
	end

	-- Put out players in extinguisher nodes
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if fire_plus.burning[name] then
			local ppos = player:get_pos()
			local node_feet = minetest.get_node(ppos).name
			local node_head = minetest.get_node(vector.add(ppos, {x=0, y=1, z=0})).name

			if match_list_with_groups(node_feet, fire_plus.extinguishers)
			or match_list_with_groups(node_head, fire_plus.extinguishers) then

				minetest.sound_play("fire_extinguish_flame", {
					to_player = name,
					gain = 1.0,
				})

				fire_plus.extinguish_player(name)
				return
			end
		end
	end
end)

-- Ignite players in ignition nodes
minetest.register_on_player_hpchange(function(player, _, reason)
	if reason.type == "node_damage" and reason.node then
		local def = match_map_with_groups(reason.node, fire_plus.ignition_nodes)
		if def then
			fire_plus.burn_player(player, def.burns or 4, def.damage or 2)
		end
	end
end)

minetest.register_on_punchplayer(function(player, hitter, _, toolcaps, _, dmg)
	if hitter and hitter:is_player()
		and toolcaps and toolcaps.damage_groups
		and toolcaps.damage_groups.burns
		and player and player:get_hp() - dmg > 0 then
		fire_plus.burn_player(player, toolcaps.damage_groups.burn_time or 4, toolcaps.damage_groups.burns)
	end
	return false
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	if fire_plus.burning[name] then
		fire_plus.extinguish_player(name)
	end
end)

