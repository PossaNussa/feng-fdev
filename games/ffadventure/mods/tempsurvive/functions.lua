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

-- Volcano heat tuning ----------------------------------------------------------
-- Grouped so the volcano's thermal footprint can be retuned in one place.
local VOLCANO_CORE_HEAT      = 40   -- peak ambient bonus (deg) right at the axis
local VOLCANO_HEAT_REACH_EXTRA = 120 -- how far past the cone's base the heat reaches
local VOLCANO_DORMANT_WEIGHT = 0.35 -- dormant volcanoes are only mildly warm
local VOLCANO_BOIL_DPS       = 2    -- HP/tick burn from standing in boiling water
local VOLCANO_STEAM_INTERVAL = 1.5  -- min seconds between steam bursts per player

-- Nearby volcanoes, cached per player and refreshed only when the player crosses
-- into a new volcano region (regions are ~1280 nodes wide, so this recomputes
-- rarely). Returns the list of volcano descriptors in the 3x3 block of regions
-- around the player -- the same sweep /findvolcano uses.
tempsurvive.nearby_volcanoes=function(pos, ptemp)
	if not (minetest.global_exists("magma_conduits") and magma_conduits.get_volcano) then
		return nil
	end
	local rs = magma_conduits.volcano_region_size
	local ckey = math.floor((pos.x+32)/rs) .. ":" .. math.floor((pos.z+32)/rs)
	if ptemp and ptemp.volc_corner == ckey and ptemp.volc_list then
		return ptemp.volc_list
	end

	local list = {}
	for dx = -1, 1 do
		for dz = -1, 1 do
			local v = magma_conduits.get_volcano({x=pos.x+dx*rs, y=0, z=pos.z+dz*rs})
			if v then list[#list+1] = v end
		end
	end
	if ptemp then
		ptemp.volc_corner = ckey
		ptemp.volc_list = list
	end
	return list
end

-- Weight of a volcano by state: active radiates fully, dormant is mild, extinct
-- is thermally dead (a cold cone in a cold biome stays cold).
local function volcano_weight(state)
	if state >= magma_conduits.volcano_state_dormant then
		return 1.0                       -- active
	elseif state >= magma_conduits.volcano_state_extinct then
		return VOLCANO_DORMANT_WEIGHT    -- dormant
	end
	return 0                             -- extinct
end

-- Ambient heat bonus + whether the player is standing in the boiling-water zone
-- of an ACTIVE volcano. Returns (heat_bonus, boiling).
tempsurvive.get_volcano_effect=function(pos, volcanoes)
	if not volcanoes then return 0, false end
	local best_heat = 0
	local boiling = false
	for _, v in ipairs(volcanoes) do
		local w = volcano_weight(v.state)
		if w > 0 then
			local dx = pos.x - v.location.x
			local dz = pos.z - v.location.z
			local d = math.sqrt(dx*dx + dz*dz)
			local reach = v.base_radius + VOLCANO_HEAT_REACH_EXTRA
			if d < reach then
				-- Ease-in falloff: hot core, softens toward the edge.
				local f = 1 - d / reach
				local heat = VOLCANO_CORE_HEAT * f * f * w
				if heat > best_heat then best_heat = heat end
			end
			-- Boiling water only within the cone footprint of an active volcano.
			if w >= 1.0 and d < v.base_radius then
				boiling = true
			end
		end
	end
	return best_heat, boiling
end

-- Volcano heat bonus at an ARBITRARY position, for callers with no player to
-- hang a cache on (the snow/ice melt ABMs). get_volcano() has a waypoint
-- side-effect and reseeds the RNG, so it must never be called per-node; the
-- volcano descriptors for a region are static, so cache the 3x3 sweep per region
-- corner and reuse it. Returns just the ambient heat bonus (deg).
local volc_heat_cache = {}       -- ckey -> { list = {...}, t = seconds }
local VOLC_CACHE_TTL = 60        -- refresh a region's sweep at most this often
tempsurvive.get_volcano_heat_at = function(pos)
	if not (minetest.global_exists("magma_conduits") and magma_conduits.get_volcano) then
		return 0
	end
	local rs = magma_conduits.volcano_region_size
	local ckey = math.floor((pos.x + 32) / rs) .. ":" .. math.floor((pos.z + 32) / rs)
	local now = minetest.get_gametime() or 0
	local c = volc_heat_cache[ckey]
	if not c or (now - c.t) > VOLC_CACHE_TTL then
		local list = {}
		for dx = -1, 1 do
			for dz = -1, 1 do
				local v = magma_conduits.get_volcano({ x = pos.x + dx * rs, y = 0, z = pos.z + dz * rs })
				if v then list[#list + 1] = v end
			end
		end
		-- Keep the table from growing without bound as the player roams: clear it
		-- wholesale when it gets large. Regions are ~1280 nodes wide so this is rare.
		local n = 0
		for _ in pairs(volc_heat_cache) do n = n + 1 end
		if n > 64 then volc_heat_cache = {} end
		c = { list = list, t = now }
		volc_heat_cache[ckey] = c
	end
	local heat = tempsurvive.get_volcano_effect(pos, c.list)
	return heat
end

-- Visible "boiling" cue: a short burst of steam around the player, throttled so
-- it isn't re-spawned every step. Telegraph via particles, never chat.
tempsurvive.emit_steam=function(player, ptemp, pos)
	local now = minetest.get_us_time() / 1e6
	if ptemp.last_steam and now - ptemp.last_steam < VOLCANO_STEAM_INTERVAL then
		return
	end
	ptemp.last_steam = now
	minetest.add_particlespawner({
		amount = 12,
		time = VOLCANO_STEAM_INTERVAL,
		minpos = {x=pos.x-1.5, y=pos.y-0.4, z=pos.z-1.5},
		maxpos = {x=pos.x+1.5, y=pos.y+0.2, z=pos.z+1.5},
		minvel = {x=-0.2, y=0.6, z=-0.2},
		maxvel = {x=0.2, y=1.4, z=0.2},
		minacc = {x=0, y=0.2, z=0},
		maxacc = {x=0, y=0.5, z=0},
		minexptime = 1.5,
		maxexptime = 3,
		minsize = 2,
		maxsize = 5,
		collisiondetection = false,
		texture = "default_smoke.png^[colorize:white:128",
		playername = player:get_player_name(),
	})
end

-- Bio temperature: uses engine biome heat, height, day/night cycle, underground geothermal
-- volcano_heat is the precomputed ambient volcano bonus (see get_volcano_effect).
tempsurvive.get_bio_temperature=function(pos, volcano_heat)
	volcano_heat = volcano_heat or 0
	-- Underground: progressively warmer with depth (geothermal)
	-- Comfortable near surface, hot approaching mantle at y=-1000
	if pos.y < -20 then
		local depth = math.abs(pos.y)
		-- Near the deep magma pipe it reads hot on top of the geothermal gradient.
		return math.min(60, depth * 0.04 + volcano_heat)
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

	-- Volcano proximity: overrides the cold-biome bias so climbing an active
	-- volcano is hot, not freezing.
	temp = temp + volcano_heat

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
			local volcanoes=tempsurvive.nearby_volcanoes(pos, ptemp)
				local vheat, vboil=tempsurvive.get_volcano_effect(pos, volcanoes)
				local temp=tempsurvive.get_bio_temperature(pos, vheat)
				local burn=0 -- immediate HP loss this tick (bypasses temp smoothing)
			local itn=player:get_wielded_item():get_name()

			if tempsurvive.nodes[itn] then
				temp=temp+tempsurvive.nodes[itn].add*2
			end

			local cr=ptemp.coldness_resistance-ptemp.warming
			local hr=ptemp.heat_resistance+ptemp.cooling

			temp=tempsurvive.get_artificial_temperature(pos,temp)
			temp=tempsurvive.get_weather_temperature(player,temp)

			-- Water immersion. Near an active volcano the water boils and scalds
				-- (covers dynamic_liquid shallows too -- they carry group:water);
				-- everywhere else it chills. get_item_group matches source, flowing
				-- and shallow variants alike.
			local pnode = minetest.get_node(pos)
			if minetest.get_item_group(pnode.name, "water") > 0 then
				if vboil then
						temp = temp + 30
						burn = burn + VOLCANO_BOIL_DPS
						tempsurvive.emit_steam(player, ptemp, pos)
					else
						temp = temp - 5
					end
			end

			-- Scorching ground: standing on hot obsidian / lava-cooked stone burns.
				-- A solid floor node never intersects the player's box, so the
				-- engine's damage_per_second can't fire -- check the feet node.
				local feet = minetest.get_node({
					x = math.floor(pos.x + 0.5),
					y = math.floor(pos.y - 0.5),
					z = math.floor(pos.z + 0.5),
				})
				local bf = minetest.get_item_group(feet.name, "tempsurvive_burn")
				if bf > 0 then
					burn = burn + bf
					temp = temp + 15
				end

				-- Direct contact burns (boiling water, scorching ground) apply
				-- immediately, on top of the slow heat convergence below.
				if burn>0 then
					player:set_hp(player:get_hp()-burn)
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
