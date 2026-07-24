tempsurvive.new=function(player)
	local name=player:get_player_name()
	tempsurvive.player[name]={
		temp=0,
		warming=0,
		cooling=0,
		heat_resistance=40,
		coldness_resistance=-10,
		full_resistance=minetest.check_player_privs(name, {no_temperature=true}),
	}
end

minetest.register_on_joinplayer(function(player)
	tempsurvive.new(player)
	local name=player:get_player_name()
	if tempsurvive.player[name].full_resistance then return end
	player:get_inventory():set_size("clothes",9)
	-- Delay HUD creation to ensure player is fully loaded
	minetest.after(0.5, function()
		local p = minetest.get_player_by_name(name)
		if not p or not tempsurvive.player[name] then return end
		-- Remove old HUD elements if they exist (reconnect case)
		if tempsurvive.player[name].bar then
			pcall(function() p:hud_remove(tempsurvive.player[name].bar) end)
		end
		if tempsurvive.player[name].screen then
			pcall(function() p:hud_remove(tempsurvive.player[name].screen) end)
		end
		tempsurvive.player[name].bar = p:hud_add(tempsurvive.bar)
		tempsurvive.player[name].screen = p:hud_add(tempsurvive.screen)
		tempsurvive.cloth_update(p)
	end)
end)

minetest.register_on_respawnplayer(function(player)
	local t=tempsurvive.player[player:get_player_name()]
	if not t then return end
	t.temp=0
	if t.bar then
		player:hud_change(t.bar, "text", tempsurvive.bar.text .."^[colorize:#00ff00cc")
		player:hud_change(t.bar, "number", 20)
	end
	if t.screen then
		player:hud_change(t.screen, "text", tempsurvive.screen.text)
	end
end)

minetest.register_on_leaveplayer(function(player)
	tempsurvive.player[player:get_player_name()]=nil
end)

minetest.register_privilege("no_temperature", {
	description = "Not affected by temperatures (relogin to take effect)",
	give_to_singleplayer= false,
})

-- Bio temperature: uses engine biome heat, height, day/night cycle, underground geothermal
tempsurvive.get_bio_temperature=function(pos)
	-- Underground: progressively warmer with depth (geothermal)
	-- Comfortable near surface, hot approaching mantle at y=-1000
	if pos.y < -20 then
		local depth = math.abs(pos.y)
		return math.min(50, depth * 0.04)
	end

	-- Surface: use engine biome heat, scaled so cold biomes are cold but survivable
	-- Biome heat is roughly 0-100. Scale to roughly -25 to +25 range.
	local biome_heat = minetest.get_heat(pos)
	local temp = (biome_heat - 50) * 0.5

	-- Height effect: colder at altitude (mountains)
	if pos.y > 0 then
		temp = temp - pos.y * 0.04
	end

	-- Day/night cycle: +5 at noon, -5 at midnight
	local tod = minetest.get_timeofday()
	local day_factor = math.cos((tod - 0.5) * 2 * math.pi)
	temp = temp + day_factor * 5

	-- Light level warms slightly (sunlight, torchlight nearby)
	local l = minetest.get_node_light(pos) or 0
	temp = temp + l * 0.15

	return temp
end

-- Weather-based temperature modifier (requires climate_api / regional_weather)
-- Only applies outdoors (checks for roof above player)
tempsurvive.get_weather_temperature=function(player, temp)
	if not climate_api or not climate_api.environment then return temp end

	-- Shelter check: if there's a solid block within 10 nodes above, player is sheltered
	local pos = player:get_pos()
	for i = 1, 10 do
		local check = {x = math.floor(pos.x + 0.5), y = math.floor(pos.y) + 1 + i, z = math.floor(pos.z + 0.5)}
		local node = minetest.get_node(check)
		local ndef = minetest.registered_nodes[node.name]
		if ndef and ndef.walkable then
			return temp -- sheltered, no weather chill
		end
	end

	-- Outdoors: apply weather effects
	local weathers = climate_api.environment.get_weather_presets(player)
	local mod = 0
	for _, w in ipairs(weathers) do
		if w == "regional_weather:snow_heavy" then
			mod = math.min(mod, -12)
		elseif w == "regional_weather:snow" then
			mod = math.min(mod, -8)
		elseif w == "regional_weather:hail" then
			mod = math.min(mod, -6)
		elseif w == "regional_weather:rain_heavy" or w == "regional_weather:storm" then
			mod = math.min(mod, -5)
		elseif w == "regional_weather:rain" then
			mod = math.min(mod, -3)
		end
	end
	return temp + mod
end

-- Artificial temperature from nearby heat/cold source nodes
-- Simple distance falloff (replaces expensive flood-fill pathfinder)
tempsurvive.get_artificial_temperature=function(pos,temp)
	local r = 8
	local a=minetest.find_nodes_in_area(
		{x=pos.x-r, y=pos.y-r, z=pos.z-r},
		{x=pos.x+r, y=pos.y+r, z=pos.z+r},
		{"group:tempsurvive"})
	for _,no in pairs(a) do
		local name=minetest.get_node(no).name
		local add
		local rad=minetest.get_item_group(name,"tempsurvive_rad")
		if minetest.get_item_group(name,"tempsurvive_temp_by_meta")>0 then
			add=minetest.get_meta(no):get_int("temp")
		else
			add=minetest.get_item_group(name,"tempsurvive_add")
		end
		local dist = math.max(1, vector.distance(pos, no))
		if dist <= rad then
			temp = temp + add / dist
		end
	end
	return temp
end

minetest.register_globalstep(function(dtime)
	if tempsurvive.step_timer>tempsurvive.step_time then
		tempsurvive.step_timer=0
	else
		tempsurvive.step_timer=tempsurvive.step_timer+dtime
		return
	end
	for _,player in ipairs(minetest.get_connected_players()) do

		local ptemp=tempsurvive.player[player:get_player_name()]
		if ptemp and not ptemp.full_resistance then
			local pos=player:get_pos()
			local temp=tempsurvive.get_bio_temperature(pos)
			local itn=player:get_wielded_item():get_name()

			if tempsurvive.nodes[itn] then
				temp=temp+tempsurvive.nodes[itn].add*2
			end

			local cr=ptemp.coldness_resistance-ptemp.warming
			local hr=ptemp.heat_resistance+ptemp.cooling

			temp=tempsurvive.get_artificial_temperature(pos,temp)
			temp=tempsurvive.get_weather_temperature(player,temp)

			-- Water immersion: standing in water chills the player
			local pnode = minetest.get_node(pos)
			if minetest.get_item_group(pnode.name, "water") > 0 then
				temp = temp - 5
			end

			-- Smooth convergence toward target temperature (lerp)
			-- ~30s to feel significant change, ~60s to mostly stabilize
			ptemp.temp = ptemp.temp + (temp - ptemp.temp) * 0.03

			if ptemp.temp<cr then
				player:set_hp(player:get_hp()-(1+math.floor((ptemp.temp-ptemp.coldness_resistance)*-0.1)))
			elseif ptemp.temp>hr then
				player:set_hp(player:get_hp()-math.floor((ptemp.temp-ptemp.heat_resistance)*0.5))
			end

			if ptemp.bar and ptemp.screen then
				local pt=math.floor(math.abs(ptemp.temp))

				if ptemp.temp<0 and pt<=cr*-1 then
					local t=math.floor(pt/math.abs(cr)*15)
					local ht=tempsurvive.n2dhex(math.ceil(t/2))
					player:hud_change(ptemp.bar, "text", tempsurvive.bar.text .."^[colorize:#00" .. tempsurvive.n2dhex(15-t) .. tempsurvive.n2dhex(t) .."cc")
					player:hud_change(ptemp.bar, "number", 20-math.floor(pt/math.abs(cr)*20))
					player:hud_change(ptemp.screen, "text", tempsurvive.screen.text .."^[colorize:#00" .. ht .. tempsurvive.n2dhex(t) ..  ht)
				elseif ptemp.temp>=0 and pt<=hr then
					local t=math.floor(pt/math.abs(hr)*15)
					local ht=tempsurvive.n2dhex(math.ceil(t/2))
					player:hud_change(ptemp.bar, "text", tempsurvive.bar.text .."^[colorize:#" .. tempsurvive.n2dhex(t) ..tempsurvive.n2dhex(15-t) .."00cc")
					player:hud_change(ptemp.bar, "number", 20+math.floor(pt/math.abs(hr)*20))
					player:hud_change(ptemp.screen, "text", tempsurvive.screen.text .."^[colorize:#" .. tempsurvive.n2dhex(t) .. ht .. "00" ..  ht)
				end
			end
		end
	end
end)

tempsurvive.n2dhex=function(n)
	if n<0 then n=0 end
	local a={0,1,2,3,4,5,6,7,8,9,"a","b","c","d","e","f"}
	local a2=a[n+1] or "f"
	return a2 .. a2
end

minetest.register_on_player_receive_fields(function(player, form, p)
	if form=="tempsurvive.bag" and p.quit then
		local inv=player:get_inventory()
		local layers={}
		for i=1,9,1 do
			local name=inv:get_stack("clothes",i):get_name()
			local clothes=tempsurvive.clothes[name]
			if not clothes or layers[clothes.part .. " " .. clothes.layer] then
				if inv:room_for_item("main",name) then
					inv:add_item("main",inv:get_stack("clothes",i))
				else
					minetest.add_item(player:get_pos(), inv:get_stack("clothes",i))
				end
				inv:remove_item("clothes",inv:get_stack("clothes",i))
			else
				layers[clothes.part .. " " .. clothes.layer]=1
			end
		end
		tempsurvive.cloth_update(player)
	end
end)

tempsurvive.cloth_update=function(player)
	local p=tempsurvive.player[player:get_player_name()]
	if not p then return end
	local inv=player:get_inventory()
	local layer={}
	local layern={}

	p.warming=0
	p.cooling=0
	for i=1,9,1 do
		local clothe=tempsurvive.clothes[inv:get_stack("clothes",i):get_name()]
		if clothe then
			p.warming=p.warming+clothe.warming
			p.cooling=p.cooling+clothe.cooling
			if not layer[clothe.layer .. ""] then
				layer[clothe.layer .. ""]={}
				table.insert(layern,clothe.layer)
			end
			table.insert(layer[clothe.layer .. ""],clothe.texture)
		end
	end
	table.sort(layern)
	local clothing_overlays=""
	for i,n in ipairs(layern) do
		for ii,t in pairs(layer[n .. ""]) do
			clothing_overlays=clothing_overlays .. "^" .. t
		end
	end

	-- Store overlay for skinsdb visual hook
	p.clothing_overlay=clothing_overlays

	if minetest.global_exists("skins") then
		-- skinsdb path: let skinsdb handle model and textures properly
		skins.update_player_skin(player)
	elseif tempsurvive.armor then
		local skin=player:get_properties().textures[1]
		if not p.skin or (p.skin~=skin and not string.find(skin,"%^")) then
			p.skin=skin
		end
		local textures=p.skin .. clothing_overlays
		player:set_properties({
			mesh="3d_armor_character.b3d",
			textures={
				textures,
				player:get_properties().textures[3],
				"3d_armor_trans.png"
			}
		})
		armor:set_player_armor(player)
		armor:update_inventory(player)
	else
		local skin=player:get_properties().textures[1]
		if not p.skin or (p.skin~=skin and not string.find(skin,"%^")) then
			p.skin=skin
		end
		local textures=p.skin .. clothing_overlays
		player:set_properties({textures={textures}})
	end
end

tempsurvive.register_clothe=function(name,def)
	def.description=def.description or name
	local part
	local mn=minetest.get_current_modname()

	if def.part=="arm" or def.part=="leg" then
		part="tempsurvive_arm-leg.obj"
	elseif def.part=="chested" then
		part="tempsurvive_chested-head.obj"
	elseif def.part=="head" then
		part="tempsurvive_head.obj"
	else
		part="tempsurvive_body.obj"
		def.part="all"
	end

	if not (def.warming or def.cooling) then
		def.warming=2
	end

	if def.warming and not def.cooling then
		def.cooling=def.warming*-1
	elseif def.cooling and not def.warming then
		def.warming=def.cooling*-1
	end

	tempsurvive.clothes[mn .. ":cloth_" .. name]={
		warming=def.warming,
		cooling=def.cooling,
		part=def.part,
		layer=def.layer or 2,
		texture=def.texture
	}

	minetest.register_node(mn .. ":cloth_" .. name, {
		description = def.description .. " Warming: " .. def.warming ..", Cooling: " .. def.cooling,
		stack_max=1,
		drop="",
		tiles={def.texture},
		groups={dig_immediate=3,tempsurvive_cloths=1,cloth=1},
		drawtype="mesh",
		mesh=part,
		paramtype="light",
		on_use=function(itemstack, user, pointed_thing)
			minetest.registered_nodes["tempsurvive:clothes_bag"].on_use(1,user)
		end,
		on_place = function(itemstack, placer, pointed_thing)
			return
		end,
		on_construct = function(pos)
			minetest.after(0.01, function(pos)
				minetest.remove_node(pos)
			end,pos)
		end,
	})

	if def.craft then
		minetest.register_craft({
			output = mn .. ":cloth_" .. name,
			recipe = def.craft
		})
		minetest.register_craft({
			type = "fuel",
			recipe = mn .. ":cloth_" .. name,
			burntime = 2,
		})
	end
end

tempsurvive.register_cloth=function(name,hex,amount,craft)
	local itnam=minetest.get_current_modname() ..":cloth_" .. name
	minetest.register_craftitem(itnam, {
		description = string.upper(string.sub(name,1,1)) .. string.sub(name,2,string.len(name)) .." Cloth",
		inventory_image = "tempsurvive_bag.png^[colorize:#" .. hex .."^tempsurvive_cloth.png",
		groups = {cloth=1}
	})
	if craft then
	minetest.register_craft({
		type = "fuel",
		recipe = itnam,
		burntime = 2
	})
	minetest.register_craft({
		output = itnam .." " .. amount,
		recipe = craft
	})
	end
end
