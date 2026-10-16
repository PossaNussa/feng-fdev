tempsurvive={
	speed=0.01,
	step_timer=0,
	step_time=1,
	player={},
	armor=minetest.get_modpath("3d_armor"),
	perlin={
		offset=50,
		scale=50,
		spread={x=1000,y=1000,z=1000},
		seed=5349,
		octaves=3,
		persist=0.5,
		lacunarity=2,
		flags="default"
	},

	bar={
		hud_elem_type="statbar",
		position={x=0.5,y=1.025},
		text="tempsurvive_bar.png",
		number=40,
		size={x=24,y=4},
		direction=0,
		offset={x=-244, y=-88},
	},
	clothes={},
	screen={
		hud_elem_type = "image",
		text ="tempsurvive_screen.png",
		scale = {x=-100, y=-100},
		alignment = {x=1, y=1},
	},
	nodes={
		["snowy"]={add=-3,rad=2},
		["water"]={add=-2,rad=2},
		["puts_out_fire"]={add=-2,rad=3},
		["torch"]={add=3,rad=5},
		["default:steam"]={add=4,rad=2},
		["default:smoke"]={add=4,rad=1},
		["default:compressed_steam"]={add=5,rad=3},
		["default:ice"]={add=-3,rad=4},
		["default:fire"]={add=6,rad=10},
		["default:lava"]={add=12,rad=20},
		["default:river_water_source"]={add=-2,rad=2},
		["igniter"]={add=6,rad=5},
		["default:furnace_active"]={add=5,rad=10},
		["moretorches:clantern"]={add=2,rad=4},
		-- Volcano "hot obsidian" and lava-cooked stone: radiate heat nearby, and
		-- `burn` HP/sec to anything standing on them (see functions.lua). Only
		-- present when magma_conduits' glowing_rock is enabled; the override loop
		-- below skips names it can't find, so this is safe otherwise.
		["magma_conduits:glow_obsidian"]={add=8,rad=6,burn=2},
		["magma_conduits:hot_cobble"]={add=6,rad=5,burn=2},
	}
}

dofile(minetest.get_modpath("tempsurvive") .. "/functions.lua")
dofile(minetest.get_modpath("tempsurvive") .. "/nodes_items.lua")

minetest.register_on_mods_loaded(function()
	-- Hook into skinsdb/armor visual pipeline so clothing overlays
	-- persist through armor updates (skinsdb handles model + textures,
	-- we just append clothing overlays to the skin texture slot)
	if minetest.global_exists("skins") and minetest.global_exists("armor") then
		local orig_update_visuals = armor.update_player_visuals
		armor.update_player_visuals = function(self, player)
			orig_update_visuals(self, player)
			if not player then return end
			local name = player:get_player_name()
			local p = tempsurvive.player[name]
			if p and p.clothing_overlay and p.clothing_overlay ~= "" then
				local ok, cur = pcall(player_api.get_textures, player)
				if ok and cur then
					local new_textures = table.copy(cur)
					new_textures[1] = new_textures[1] .. p.clothing_overlay
					player_api.set_textures(player, new_textures)
				end
			end
		end
	end

	-- tempsurvive.nodes is keyed either by node name ("default:furnace_active") or
	-- by bare group name ("torch"). Split the two, apply the named ones, then
	-- expand each group across every node that carries it.
	local groups_to_change={}
	local named={}
	for i,v in pairs(tempsurvive.nodes) do
		if string.find(i,":")==nil then
			groups_to_change[i]=v
		elseif minetest.registered_nodes[i] then
			local group=table.copy(minetest.registered_nodes[i].groups or {})
			group.tempsurvive=1
			group.tempsurvive_add=v.add
			group.tempsurvive_rad=v.rad
			if v.burn then group.tempsurvive_burn=v.burn end
			minetest.override_item(i, {groups=group})
			-- Remember it: the group pass below runs afterwards and would otherwise
			-- overwrite it. moretorches:clantern is listed here at add=2/rad=4 *and*
			-- carries torch=1, so the generic torch entry (add=3/rad=5) was landing
			-- on top of it and its deliberately cooler, shorter-reach tuning never
			-- took effect. A name is more specific than a group and wins.
			named[i]=true
		end
	end
	-- Sorted, not pairs(): a node can carry two listed groups at once (water is
	-- also puts_out_fire), and iterating the hash would let whichever key came up
	-- last decide, differently from one run to the next. Alphabetical is arbitrary
	-- but it is at least the same every time.
	local group_names={}
	for ii in pairs(groups_to_change) do group_names[#group_names+1]=ii end
	table.sort(group_names)

	for i,v in pairs(minetest.registered_nodes) do
		if not named[i] then
			for _,ii in ipairs(group_names) do
				if v.groups and v.groups[ii] then
					local vv=groups_to_change[ii]
					local group=table.copy(v.groups or {})
					group.tempsurvive=1
					group.tempsurvive_add=vv.add
					group.tempsurvive_rad=vv.rad
					if vv.burn then group.tempsurvive_burn=vv.burn end
					minetest.override_item(i, {groups=group})
					tempsurvive.nodes[i]={add=vv.add,rad=vv.rad}
					break
				end
			end
		end
	end
	for ii,vv in pairs(groups_to_change) do
		tempsurvive.nodes[ii]=nil
	end
end)
