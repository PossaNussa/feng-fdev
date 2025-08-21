-- wc_pottery — single-file full replacement (steam behaves like default; flowerpot has 1-slot GUI)
-- Includes previous features (chips/crafts, ceramic nodes & tiles, pots/waterpot with dye logic, bucket returns),
-- plus: moving/aging steam & compressed steam, and flowerpot inventory.
-- wc_pottery — single-file full replacement
-- Fixes:
--  • Pot inventory: GUI on CERAMIC POTS (fired + variants) only; 1-slot; opens when not using a dye
--  • Flowerpot: no GUI; "pot" flowers on top (no floating) via a render entity; dye sides still works
--  • Keeps prior features (chips, crafts, ceramic blocks/tiles, waterpot with steam & hydration, dye logic)

local modname = minetest.get_current_modname()

----------------------------------------------------------------
-- Utilities
----------------------------------------------------------------
local function S(s) return s end
local function play(pos, name, gain) minetest.sound_play(name, {pos=pos,gain=gain or 0.4}, true) end
local function is_sneak(p) return p and p.is_player and p:is_player() and p:get_player_control().sneak end
local function consume_one(stack, player) if player and player:is_player() then stack:take_item(1); player:set_wielded_item(stack) end end
local function face_from_pointed(pointed)
	if not (pointed and pointed.under and pointed.above) then return "side" end
	local d = {x=pointed.above.x - pointed.under.x, y=pointed.above.y - pointed.under.y, z=pointed.above.z - pointed.under.z}
	if d.y== 1 then return "top"    elseif d.y==-1 then return "bottom"
	elseif d.x== 1 then return "+x" elseif d.x==-1 then return "-x"
	elseif d.z== 1 then return "+z" elseif d.z==-1 then return "-z" end
	return "side"
end
local function find_in_inv(inv, name)
	for i=1, inv:get_size("main") do local st=inv:get_stack("main",i); if not st:is_empty() and st:get_name()==name then return i,st end end
end
local function vec_add(a,b) return {x=a.x+b.x, y=a.y+b.y, z=a.z+b.z} end

----------------------------------------------------------------
-- Dyes
----------------------------------------------------------------
local DYES = {
	["dye:white"]={hex="#FFFFFF",id="white"},["dye:grey"]={hex="#7F7F7F",id="grey"},
	["dye:dark_grey"]={hex="#555555",id="dark_grey"},["dye:black"]={hex="#000000",id="black"},
	["dye:red"]={hex="#FF0000",id="red"},["dye:orange"]={hex="#FFA500",id="orange"},
	["dye:yellow"]={hex="#FFFF00",id="yellow"},["dye:green"]={hex="#00FF00",id="green"},
	["dye:dark_green"]={hex="#006400",id="dark_green"},["dye:cyan"]={hex="#00FFFF",id="cyan"},
	["dye:blue"]={hex="#0000FF",id="blue"},["dye:magenta"]={hex="#FF00FF",id="magenta"},
	["dye:violet"]={hex="#A020F0",id="violet"},["dye:brown"]={hex="#8B4513",id="brown"},
	["dye:pink"]={hex="#FFC0CB",id="pink"},
}
local DYE_KEYS = {}; for k in pairs(DYES) do table.insert(DYE_KEYS, k) end
local function dyeinfo(name) return DYES[name] end
local function is_dye(name) return name and name:sub(1,4)=="dye:" end

----------------------------------------------------------------
-- Textures
----------------------------------------------------------------
local T = {
	ceramic = "wc_pottery_ceramic.png",
	pattern = "wc_pottery_glaze_pattern.png", -- used on ceramic blocks & patterned pots
	frame   = "nc_api_storebox_frame.png",    -- ONLY for ceramic tiles
	clay    = "default_clay.png",
	dirt    = "default_dirt.png",
	pot_top = "basket_inner.png",             -- pot/waterpot top (no frame)
	water   = "(default_water.png^[verticalframe:32:8)^[opacity:160",
}
local function tint(tex, hex) return "("..tex..")^[multiply:"..hex end
local function patt(hex, opacity) return "("..T.pattern..")^[opacity:"..(opacity or 55).."^[multiply:"..hex end

----------------------------------------------------------------
-- Items / Basic crafts
----------------------------------------------------------------
minetest.register_craftitem(modname..":chip", { description=S("Ceramic Chip"), inventory_image=T.ceramic })

minetest.clear_craft({ type="cooking", recipe="default:clay_lump" })
minetest.register_craft({ type="cooking", recipe="default:clay_lump", output=modname..":chip", cooktime=3 })

minetest.register_craft({
	output = modname..":ceramic",
	recipe = {
		{modname..":chip", modname..":chip", modname..":chip"},
		{modname..":chip", modname..":chip", modname..":chip"},
		{modname..":chip", modname..":chip", modname..":chip"},
	}
})

minetest.register_craft({
	output = modname..":ceramic_tile 4",
	recipe = { {modname..":ceramic", modname..":ceramic"}, {modname..":ceramic", modname..":ceramic"} }
})

----------------------------------------------------------------
-- Ceramic blocks (base + pattern)
----------------------------------------------------------------
local CERAMIC_BASES = { none={hex=false,id="none"} }
for _,k in ipairs(DYE_KEYS) do local i=DYES[k]; CERAMIC_BASES[i.id]={hex=i.hex,id=i.id} end
local CERAMIC_PATTS = { none={hex=false,id="none"} }
for _,k in ipairs(DYE_KEYS) do local i=DYES[k]; CERAMIC_PATTS[i.id]={hex=i.hex,id=i.id} end

local function tiles_ceramic(base_hex, patt_hex)
	local base = base_hex and tint(T.ceramic, base_hex) or T.ceramic
	local faces = {base,base,base,base,base,base}
	if patt_hex then local ov=patt(patt_hex); for i=1,6 do faces[i] = "("..faces[i]..")^("..ov..")" end end
	return faces
end
local function name_cer(b,p) return ("%s:ceramic__b_%s__p_%s"):format(modname,b,p) end
local CERAMIC_BASE_NAME = name_cer("none","none")

for b_id,b in pairs(CERAMIC_BASES) do
	for p_id,p in pairs(CERAMIC_PATTS) do
		minetest.register_node(name_cer(b_id,p_id), {
			description=S("Ceramic"),
			tiles=tiles_ceramic(b.hex, p.hex),
			paramtype2="facedir",
			groups={cracky=2,stone=1,ceramic=1, not_in_creative_inventory=(b_id~="none" or p_id~="none") and 1 or nil},
			drop=modname..":ceramic",
			sounds=default.node_sound_stone_defaults(),
			on_rightclick=function(pos,node,clicker,itemstack)
				local d=dyeinfo(itemstack:get_name()); if not d then return itemstack end
				local set_base=is_sneak(clicker)
				local nb, np = b_id, p_id
				if set_base then nb=d.id else if np==d.id then nb=d.id else np=d.id end end
				local target=name_cer(nb,np)
				if minetest.registered_nodes[target] then
					minetest.swap_node(pos,{name=target,param2=node.param2})
					consume_one(itemstack,clicker); play(pos,"default_glass_footstep",0.25)
				end
				return itemstack
			end,
		})
	end
end
minetest.register_alias(modname..":ceramic", CERAMIC_BASE_NAME)

----------------------------------------------------------------
-- Ceramic Tiles (BASE COLOR ONLY) — frame on all faces
----------------------------------------------------------------
local function tiles_tile(base_hex)
	local base = base_hex and tint(T.ceramic, base_hex) or T.ceramic
	local faces = {base,base,base,base,base,base}
	for i=1,6 do faces[i] = "("..faces[i]..")^("..T.frame..")" end
	return faces
end
local function name_tile(b) return ("%s:ceramic_tile__b_%s"):format(modname,b) end
local TILE_BASE_NAME = name_tile("none")

for b_id,b in pairs(CERAMIC_BASES) do
	minetest.register_node(name_tile(b_id), {
		description=S("Ceramic Tiles"),
		tiles=tiles_tile(b.hex),
		paramtype2="facedir",
		groups={cracky=2,stone=1,ceramic=1, not_in_creative_inventory=b_id~="none" and 1 or nil},
		drop=modname..":ceramic_tile",
		sounds=default.node_sound_stone_defaults(),
		on_rightclick=function(pos,node,clicker,itemstack)
			local d=dyeinfo(itemstack:get_name()); if not d then return itemstack end
			local target=name_tile(d.id)
			if minetest.registered_nodes[target] then
				minetest.swap_node(pos,{name=target,param2=node.param2})
				consume_one(itemstack,clicker); play(pos,"default_glass_footstep",0.25)
			end
			return itemstack
		end,
	})
end
minetest.register_alias(modname..":ceramic_tile", TILE_BASE_NAME)

----------------------------------------------------------------
-- Flowerpot (SLAB) — dyeable sides; pot flowers on top (no GUI)
----------------------------------------------------------------
-- Potted flower entity (renders the flower item sitting on slab)
minetest.register_entity(modname..":potted_flower", {
	initial_properties = {
		visual="wielditem", visual_size={x=0.7,y=0.7}, collisionbox={0,0,0,0,0,0},
		physical=false, pointable=false, static_save=true,
	},
	flower="",
	anchor=nil,
	on_activate=function(self, staticdata)
		local data=minetest.deserialize(staticdata or "") or {}
		if data.flower then self.flower=data.flower end
		self.anchor = data.anchor or self.object:get_pos()
		self.object:set_properties({textures={self.flower}})
	end,
	get_staticdata=function(self) return minetest.serialize({flower=self.flower, anchor=self.anchor}) end,
})

local function flower_entity_pos(pos) return {x=pos.x, y=pos.y+0.18, z=pos.z} end
local function clear_potted_flower_entities(pos)
	for _,obj in ipairs(minetest.get_objects_inside_radius(pos, 0.6)) do
		local lua = obj:get_luaentity()
		if lua and lua.name == modname..":potted_flower" then obj:remove() end
	end
end
local function respawn_potted_flower(pos, flower_name)
	clear_potted_flower_entities(pos)
	if not flower_name or flower_name=="" then return end
	local obj=minetest.add_entity(flower_entity_pos(pos), modname..":potted_flower")
	if obj then
		local lua=obj:get_luaentity()
		lua.flower=flower_name
		lua.anchor=vector.new(pos)
		obj:set_properties({textures={flower_name}})
	end
end

local function tiles_flowerpot_side(hex)
	local side = hex and tint(T.ceramic, hex) or T.ceramic
	return { T.dirt, side, side, side, side, side }
end
local function name_flower(color) return ("%s:pottery_flowerpot__side_%s"):format(modname,color) end
local FLOWER_BASE = name_flower("none")

local function flower_on_construct(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext","Flowerpot")
	meta:set_string("potted","") -- stored flower item name
end
local function flower_after_place_node(pos, placer, itemstack)
	-- re-spawn any stored flower (schematic/rollback safety)
	local flower = minetest.get_meta(pos):get_string("potted")
	if flower~="" then respawn_potted_flower(pos, flower) end
end
local function flower_after_dig_node(pos, oldnode, oldmeta, digger)
	-- drop stored flower if present
	local f = oldmeta and oldmeta.fields and oldmeta.fields.potted or ""
	if f and f~="" then minetest.add_item(pos, f) end
	clear_potted_flower_entities(pos)
end
local function try_pot_flower(pos, node, clicker, itemstack, pointed)
	if face_from_pointed(pointed) ~= "top" then return false end
	local name = itemstack:get_name()
	if minetest.get_item_group(name,"flower") <= 0 then return false end
	local meta = minetest.get_meta(pos)
	local current = meta:get_string("potted")
	if current and current~="" then
		-- replace existing: drop it
		minetest.add_item(pos, current)
	end
	meta:set_string("potted", name)
	respawn_potted_flower(pos, name)
	consume_one(itemstack, clicker); play(pos,"default_place_node_hard",0.3)
	return true
end

minetest.register_node(FLOWER_BASE, {
	description = S("Ceramic Flowerpot"),
	drawtype="nodebox",
	node_box={type="fixed", fixed={-0.5,-0.5,-0.5, 0.5,0,0.5}},
	tiles = tiles_flowerpot_side(false),
	groups={crumbly=3, flowerpot=1},
	sounds = default.node_sound_stone_defaults(),
	on_construct = flower_on_construct,
	after_place_node = flower_after_place_node,
	after_dig_node = flower_after_dig_node,
	on_rightclick = function(pos, node, clicker, itemstack, pointed)
		-- try potting flowers on TOP
		if try_pot_flower(pos, node, clicker, itemstack, pointed) then return itemstack end
		-- else dye sides only (ignore top)
		local d = dyeinfo(itemstack:get_name()); if not d then return itemstack end
		if face_from_pointed(pointed) == "top" then return itemstack end
		local target = name_flower(d.id)
		if minetest.registered_nodes[target] then
			minetest.swap_node(pos, {name=target, param2=node.param2})
			consume_one(itemstack, clicker); play(pos,"default_glass_footstep",0.25)
		end
		return itemstack
	end,
})
for _,k in ipairs(DYE_KEYS) do
	local d = DYES[k]
	minetest.register_node(name_flower(d.id), {
		description = S("Ceramic Flowerpot"),
		drawtype="nodebox",
		node_box={type="fixed", fixed={-0.5,-0.5,-0.5, 0.5,0,0.5}},
		tiles = tiles_flowerpot_side(d.hex),
		groups={crumbly=3, flowerpot=1, not_in_creative_inventory=1},
		drop = FLOWER_BASE,
		sounds = default.node_sound_stone_defaults(),
		on_construct = flower_on_construct,
		after_place_node = flower_after_place_node,
		after_dig_node = flower_after_dig_node,
		on_rightclick = function(pos, node, clicker, itemstack, pointed)
			if try_pot_flower(pos, node, clicker, itemstack, pointed) then return itemstack end
			local di = dyeinfo(itemstack:get_name()); if not di then return itemstack end
			if face_from_pointed(pointed) == "top" then return itemstack end
			local target = name_flower(di.id)
			minetest.swap_node(pos, {name=target, param2=node.param2})
			consume_one(itemstack, clicker); play(pos,"default_glass_footstep",0.25)
			return itemstack
		end,
	})
end
minetest.register_craft({
	output = FLOWER_BASE,
	recipe = { {"default:clay_lump","","default:clay_lump"}, {"","default:clay_lump",""} }
})

----------------------------------------------------------------
-- Full-block Pots: Unfired & Fired + inventory GUI on fired & variants
----------------------------------------------------------------
local function tiles_pot_top(top_hex)
	local top = T.pot_top
	if top_hex then top = "("..top..")^[colorize:"..top_hex..":55" end
	return top
end
local function tiles_pot_pattern(side_hex, top_hex)
	local side = "("..T.ceramic..")^("..patt(side_hex)..")"
	return { tiles_pot_top(top_hex), side, side, side, side, side }
end
local function tiles_pot_solid(hex)
	local side = tint(T.ceramic, hex)
	return { tiles_pot_top(hex), side, side, side, side, side }
end
local POT_UNFIRED = modname..":pottery_pot_unfired"
local POT_FIRED   = modname..":pottery_pot"
local function nm_pot_patt(id)  return ("%s:pottery_pot_patt__%s"):format(modname,id) end
local function nm_pot_solid(id) return ("%s:pottery_pot_solid__%s"):format(modname,id) end

-- Pot GUI helpers
local function pot_formspec(pos)
	local p = ("%d,%d,%d"):format(pos.x,pos.y,pos.z)
	return "size[6,5]"..
	       "label[0.3,0.3;Ceramic Pot]"..
	       "list[nodemeta:"..p..";pot;2.5,1;1,1;]"..
	       "list[current_player;main;1,2.5;8,4;]"..
	       "listring[nodemeta:"..p..";pot]"..
	       "listring[current_player;main]"
end
local function pot_on_construct(pos)
	local meta=minetest.get_meta(pos); local inv=meta:get_inventory()
	inv:set_size("pot",1); meta:set_string("infotext","Ceramic Pot"); meta:set_string("formspec", pot_formspec(pos))
end
local function pot_after_dig_node(pos, oldnode, oldmeta, digger)
	local inv = oldmeta and oldmeta.inventory
	if inv and inv.pot and inv.pot[1] then
		minetest.add_item(pos, ItemStack(inv.pot[1]))
	end
end
local function pot_allow_put(pos, listname, index, stack, player)
	return (listname=="pot") and stack:get_count() or 0
end
local function pot_allow_take(pos, listname, index, stack, player) return stack:get_count() end
local function pot_open_or_dye(pos, node, clicker, itemstack, dye_handler)
	-- If wielded is dye: execute dye handler; else open GUI
	local name = itemstack:get_name()
	if is_dye(name) then
		return dye_handler(pos, node, clicker, itemstack)
	else
		minetest.show_formspec(clicker:get_player_name(), modname..":pot@"..minetest.pos_to_string(pos), pot_formspec(pos))
		return itemstack
	end
end

minetest.register_node(POT_UNFIRED, {
	description = S("Unfired Ceramic Pot"),
	tiles = { tiles_pot_top(nil), T.clay, T.clay, T.clay, T.clay, T.clay },
	groups = {cracky=1, oddly_breakable_by_hand=1, store=1, falling_node=1},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_craft({ type="cooking", recipe=POT_UNFIRED, output=POT_FIRED, cooktime=12 })
minetest.register_craft({ type="shapeless", output=POT_UNFIRED, recipe={"default:clay","default:stick"} })

-- Fired pot (base state): GUI + dye-to-pattern
minetest.register_node(POT_FIRED, {
	description = S("Ceramic Pot"),
	tiles = { tiles_pot_top(nil), T.ceramic, T.ceramic, T.ceramic, T.ceramic, T.ceramic },
	groups = {cracky=2, oddly_breakable_by_hand=1, store=1},
	sounds = default.node_sound_glass_defaults(),
	on_construct = pot_on_construct,
	after_dig_node = pot_after_dig_node,
	allow_metadata_inventory_put = pot_allow_put,
	allow_metadata_inventory_take = pot_allow_take,
	on_rightclick = function(pos, node, clicker, itemstack)
		return pot_open_or_dye(pos, node, clicker, itemstack, function(p,n,c,st)
			local d = dyeinfo(st:get_name()); if not d then return st end
			minetest.swap_node(p, {name=nm_pot_patt(d.id), param2=n.param2})
			consume_one(st, c); play(p,"default_glass_footstep",0.25); return st
		end)
	end,
})

-- Patterned and Solid variants per dye (inherit GUI & inventory)
for _,k in ipairs(DYE_KEYS) do
	local d = DYES[k]
	minetest.register_node(nm_pot_patt(d.id), {
		description = S("Ceramic Pot"),
		tiles = tiles_pot_pattern(d.hex, d.hex),
		groups = {cracky=2, oddly_breakable_by_hand=1, store=1, not_in_creative_inventory=1},
		drop = POT_FIRED,
		sounds = default.node_sound_glass_defaults(),
		on_construct = pot_on_construct,
		after_dig_node = pot_after_dig_node,
		allow_metadata_inventory_put = pot_allow_put,
		allow_metadata_inventory_take = pot_allow_take,
		on_rightclick = function(pos, node, clicker, itemstack)
			return pot_open_or_dye(pos, node, clicker, itemstack, function(p,n,c,st)
				local di=dyeinfo(st:get_name()); if not di then return st end
				if di.id == d.id then
					minetest.swap_node(p, {name=nm_pot_solid(di.id), param2=n.param2})
				else
					minetest.swap_node(p, {name=nm_pot_patt(di.id), param2=n.param2})
				end
				consume_one(st,c); play(p,"default_glass_footstep",0.25); return st
			end)
		end,
	})
	minetest.register_node(nm_pot_solid(d.id), {
		description = S("Ceramic Pot"),
		tiles = tiles_pot_solid(d.hex),
		groups = {cracky=2, oddly_breakable_by_hand=1, store=1, not_in_creative_inventory=1},
		drop = POT_FIRED,
		sounds = default.node_sound_glass_defaults(),
		on_construct = pot_on_construct,
		after_dig_node = pot_after_dig_node,
		allow_metadata_inventory_put = pot_allow_put,
		allow_metadata_inventory_take = pot_allow_take,
		on_rightclick = function(pos, node, clicker, itemstack)
			return pot_open_or_dye(pos, node, clicker, itemstack, function(p,n,c,st)
				local di=dyeinfo(st:get_name()); if not di then return st end
				minetest.swap_node(p, {name=nm_pot_solid(di.id), param2=n.param2})
				consume_one(st,c); play(p,"default_glass_footstep",0.25); return st
			end)
		end,
	})
end

----------------------------------------------------------------
-- Waterpot (node + wieldable item with internal tank) — unchanged logic
----------------------------------------------------------------
local WATERPOT = modname..":pottery_waterpot"
local function nm_waterpot_top(color) return ("%s:pottery_waterpot_top__%s"):format(modname,color) end
local WATER_MAX = 9
local function set_water_node(pos, n)
	n = math.max(0, math.min(WATER_MAX, n))
	local m=minetest.get_meta(pos); m:set_int("water", n); m:set_string("infotext", ("Waterpot (%d/%d)"):format(n, WATER_MAX))
end
local function get_water_node(pos) return minetest.get_meta(pos):get_int("water") end
local function get_item_water(stack) local m=stack:get_meta(); return tonumber(m:get_string("water") or "0") or 0 end
local function set_item_water(stack, n) n=math.max(0,math.min(WATER_MAX,n)); local m=stack:get_meta(); m:set_string("water",tostring(n)); m:set_string("description", ("%s (%d/%d)"):format(S("Ceramic Waterpot"), n, WATER_MAX)); return stack end
local function tiles_waterpot(top_hex) return { tiles_pot_top(top_hex), T.ceramic,T.ceramic,T.ceramic,T.ceramic,T.ceramic } end
local function is_any_water_bucket(name) return name:sub(1,14)=="bucket:bucket_" and name:find("water") end
local function empty_bucket_name_for(name) if name:find("_stone") then return "bucket:bucket_empty_stone" end return "bucket:bucket_empty" end
local function try_increment_waterpot_item(player)
	if not (player and player:is_player()) then return end
	local inv=player:get_inventory(); if not inv then return end
	local idx,st=find_in_inv(inv, WATERPOT)
	if idx and not st:is_empty() then local cur=get_item_water(st); if cur<WATER_MAX then set_item_water(st,cur+1); inv:set_stack("main",idx,st) end end
end

minetest.register_node(WATERPOT, {
	description=S("Ceramic Waterpot"),
	tiles=tiles_waterpot(nil),
	groups={cracky=2, storebox=1, waterpot=1},
	sounds=default.node_sound_glass_defaults(),
	stack_max=1,
	on_place=function(itemstack, placer, pointed)
		local ret=minetest.item_place(itemstack, placer, pointed); if not ret then return itemstack end
		if ret:get_name()==WATERPOT then return ret end
		local pos=pointed and pointed.above; if pos then set_water_node(pos, get_item_water(itemstack)) end
		return ret
	end,
	on_construct=function(pos) set_water_node(pos,0) end,
	on_rightclick=function(pos,node,clicker,itemstack)
		local name=itemstack:get_name()
		if is_any_water_bucket(name) then
			local have=get_water_node(pos); if have<WATER_MAX then
				set_water_node(pos,have+1); try_increment_waterpot_item(clicker)
				local empty=empty_bucket_name_for(name); itemstack:take_item(1)
				if minetest.registered_items[empty] then local inv=clicker and clicker:get_inventory()
					if inv and inv:room_for_item("main", empty) then inv:add_item("main", empty) else minetest.add_item(pos, empty) end
				end
				if clicker then clicker:set_wielded_item(itemstack) end
				play(pos,"default_place_node_hard",0.3)
			end; return itemstack
		end
		local d=dyeinfo(name); if d then local target=nm_waterpot_top(d.id)
			if minetest.registered_nodes[target] then local amt=get_water_node(pos); minetest.swap_node(pos,{name=target,param2=node.param2}); set_water_node(pos,amt); consume_one(itemstack,clicker); play(pos,"default_glass_footstep",0.25) end
			return itemstack
		end
		return itemstack
	end,
	after_dig_node=function(pos, oldnode, oldmeta, digger)
		local cnt=math.random(1,8); minetest.add_item(pos, modname..":chip "..cnt)
		local have=tonumber(oldmeta and oldmeta.fields and oldmeta.fields.water) or 0
		if have>0 then minetest.set_node(pos,{name="default:water_source"}) end
	end,
	on_use=function(itemstack,user,pointed)
		if not (user and user:is_player()) then return itemstack end
		local amt=get_item_water(itemstack); if amt<=0 then return itemstack end
		if pointed and pointed.type=="node" then local pos=pointed.above; local nn=minetest.get_node(pos).name; local def=minetest.registered_nodes[nn]
			if nn=="air" or (def and def.buildable_to) then minetest.set_node(pos,{name="default:water_source"}); itemstack=set_item_water(itemstack, amt-1); play(pos,"default_cool_lava",0.2); return itemstack end
		end
		return itemstack
	end,
})
for _,k in ipairs(DYE_KEYS) do
	local d=DYES[k]; local nm=nm_waterpot_top(d.id)
	minetest.register_node(nm,{
		description=S("Ceramic Waterpot"),
		tiles=tiles_waterpot(d.hex),
		groups={cracky=2, storebox=1, waterpot=1, not_in_creative_inventory=1},
		drop=WATERPOT,
		sounds=default.node_sound_glass_defaults(),
		stack_max=1,
		on_construct=function(pos) set_water_node(pos,0) end,
		on_rightclick=function(pos,node,clicker,itemstack)
			local water=get_water_node(pos); minetest.swap_node(pos,{name=WATERPOT,param2=node.param2})
			minetest.registered_nodes[WATERPOT].on_rightclick(pos,{name=WATERPOT,param2=node.param2},clicker,itemstack)
			local cur=minetest.get_node(pos); if cur.name==WATERPOT then minetest.swap_node(pos,{name=nm,param2=cur.param2}); set_water_node(pos,water) end
			return itemstack
		end,
		after_dig_node=function(pos, oldnode, oldmeta, digger) minetest.registered_nodes[WATERPOT].after_dig_node(pos, oldnode, oldmeta, digger) end,
		on_use=function(itemstack,user,pointed) return minetest.registered_nodes[WATERPOT].on_use(itemstack,user,pointed) end,
	})
end

-- Heat detection + steam system (unchanged from last fix)
local HEAT_NAMES = { "default:torch","fire:basic_flame","default:lava_source","default:lava_flowing" }
local function heat_source_nearby(pos)
	local r=3; local p1={x=pos.x-r,y=pos.y-1,z=pos.z-r}; local p2={x=pos.x+r,y=pos.y+1,z=pos.z+r}
	local hits=minetest.find_nodes_in_area(p1,p2,{"group:torch","group:fire","group:lava"}); if hits and #hits>0 then return true end
	local hits2=minetest.find_nodes_in_area(p1,p2,HEAT_NAMES); return hits2 and #hits2>0
end
local HAS_STEAM = minetest.registered_nodes["default:steam"]~=nil
local HAS_CSTEAM = minetest.registered_nodes["default:compressed_steam"]~=nil
local function find_next_steam_position(pos)
	local up=vec_add(pos,{x=0,y=1,z=0}); if minetest.get_node(up).name=="air" then return up end
	for dx=-1,1 do local p={x=pos.x+dx,y=pos.y,z=pos.z}; if minetest.get_node(p).name=="air" then return p end end
	for dz=-1,1 do local p={x=pos.x,y=pos.y,z=pos.z+dz}; if minetest.get_node(p).name=="air" then return p end end
	return nil
end
local function move_steam(pos, t0)
	if minetest.get_node(pos).name~="default:steam" then return end
	local elapsed=minetest.get_us_time()-t0; local above=vec_add(pos,{x=0,y=1,z=0}); local blocked=minetest.get_node(above).name~="air"
	if elapsed>=10000000 and not blocked then minetest.remove_node(pos); return end
	local nextp=find_next_steam_position(pos)
	if nextp then minetest.remove_node(pos); minetest.set_node(nextp,{name="default:steam"}); minetest.after(3.0,function() move_steam(nextp,t0) end)
	else minetest.after(3.0,function() move_steam(pos,t0) end) end
end
local function cube_is_all_csteam(center)
	for dx=-1,1 do for dy=-1,1 do for dz=-1,1 do
		if minetest.get_node({x=center.x+dx,y=center.y+dy,z=center.z+dz}).name~="default:compressed_steam" then return false end
	end end end
	return true
end
local function trigger_csteam_explosion(center)
	for dx=-1,1 do for dy=-1,1 do for dz=-1,1 do minetest.remove_node({x=center.x+dx,y=center.y+dy,z=center.z+dz}) end end end
	minetest.sound_play("tnt_explode",{pos=center,gain=1.5,max_hear_distance=50})
	minetest.add_particlespawner({amount=100,time=0.5,minpos={x=center.x-1,y=center.y-1,z=center.z-1},maxpos={x=center.x+1,y=center.y+1,z=center.z+1},
		minvel={x=-10,y=-10,z=-10},maxvel={x=10,y=10,z=10},minacc={x=0,y=-10,z=0},maxacc={x=0,y=-10,z=0},
		minexptime=0.1,maxexptime=1.0,minsize=4,maxsize=8,texture="tnt_smoke.png"})
end
local function move_csteam(pos, t0)
	if not HAS_CSTEAM or minetest.get_node(pos).name~="default:compressed_steam" then return end
	local elapsed=minetest.get_us_time()-t0; local above=vec_add(pos,{x=0,y=1,z=0}); local na=minetest.get_node(above).name; local blocked=na~="air"
	if elapsed>=10000000 and not blocked then minetest.remove_node(pos); return end
	if cube_is_all_csteam(pos) then trigger_csteam_explosion(pos); return end
	if na=="default:steam" then minetest.swap_node(above,{name="default:compressed_steam"}); minetest.set_node(pos,{name="default:steam"}); minetest.after(3.0,function() move_csteam(above,t0) end); return end
	local nextp=find_next_steam_position(pos)
	if nextp then minetest.remove_node(pos); minetest.set_node(nextp,{name="default:compressed_steam"}); minetest.after(3.0,function() move_csteam(nextp,t0) end)
	else minetest.after(3.0,function() move_csteam(pos,t0) end) end
end
local function spawn_steam_like(pos)
	if not HAS_STEAM then
		minetest.add_particlespawner({amount=16,time=0.2,minpos=pos,maxpos=pos,minvel={x=0,y=0.5,z=0},maxvel={x=0.2,y=1.0,z=0.2},minacc={x=0,y=0,z=0},maxacc={x=0,y=0.1,z=0},minsize=2,maxsize=4,texture="default_smoke.png",glow=1})
		return false
	end
	minetest.set_node(pos,{name="default:steam"}); minetest.sound_play("default_furnace_active",{pos=pos,max_hear_distance=10,gain=0.5})
	local t0=minetest.get_us_time(); minetest.after(1.0,function() move_steam(pos,t0) end); return true
end
local function upgrade_to_csteam(pos)
	if not HAS_CSTEAM then return false end
	minetest.set_node(pos,{name="default:compressed_steam"}); minetest.sound_play("default_furnace_active",{pos=pos,max_hear_distance=10,gain=0.7})
	local t0=minetest.get_us_time(); minetest.after(1.0,function() move_csteam(pos,t0) end); return true
end
local function emit_waterpot_steam(pos)
	local above=vec_add(pos,{x=0,y=1,z=0}); local nn=minetest.get_node(above).name
	if nn=="air" then return spawn_steam_like(above)
	elseif nn=="default:steam" then return upgrade_to_csteam(above)
	else return false end
end
minetest.register_abm({
	label="Waterpot upkeep (hydrate)", nodenames={"group:waterpot"}, interval=10, chance=1,
	action=function(pos)
		local have=get_water_node(pos); if have<=0 then return end
		local r=3; local p1={x=pos.x-r,y=pos.y-1,z=pos.z-r}; local p2={x=pos.x+r,y=pos.y+1,z=pos.z+r}
		local list=minetest.find_nodes_in_area(p1,p2,{"farming:soil"}); for _,fp in ipairs(list) do if have<=0 then break end minetest.set_node(fp,{name="farming:soil_wet"}); have=have-1 end
		if have~=get_water_node(pos) then set_water_node(pos,have) end
	end
})
minetest.register_abm({
	label="Waterpot steam", nodenames={"group:waterpot"}, interval=30, chance=1,
	action=function(pos) local have=get_water_node(pos); if have>0 and heat_source_nearby(pos) then if emit_waterpot_steam(pos) then set_water_node(pos,have-1) end end end
})

----------------------------------------------------------------
-- Craft: Waterpot from Ceramic Pot + stone empty bucket
----------------------------------------------------------------
minetest.register_craft({ type="shapeless", output=WATERPOT, recipe={ POT_FIRED, "bucket:bucket_empty_stone" } })

----------------------------------------------------------------
-- Public aliases
----------------------------------------------------------------
minetest.register_alias(modname..":ceramic_item", modname..":ceramic")
minetest.register_alias(modname..":ceramic_tile_item", modname..":ceramic_tile")
minetest.register_alias(modname..":pottery_flowerpot", FLOWER_BASE)

-- wc_pottery × awards — achievements (no unsupported triggers; pure runtime hooks)
-- Safe on awards versions without 'cooked' support.

local MOD = minetest.get_current_modname() or "wc_pottery"
if not minetest.global_exists("awards") then
	minetest.log("action", "["..MOD.."] awards integration: 'awards' mod not found; skipping.")
	return
end

-- Canonical names used below
local N = {
	chip           = MOD..":chip",
	ceramic        = MOD..":ceramic",
	ceramic_tile   = MOD..":ceramic_tile",
	pot_unfired    = MOD..":pottery_pot_unfired",
	pot_fired      = MOD..":pottery_pot",
	waterpot       = MOD..":pottery_waterpot",
	-- base flowerpot (variants share group:flowerpot)
}

----------------------------------------------------------------------
-- 1) Register awards (NO trigger tables; we unlock them via hooks)
----------------------------------------------------------------------
awards.register_award(MOD..":ceramic_age", {
	title = "The Ceramic Age",
	description = "Forge a chip in a furnace.",
	icon = "wc_pottery_ceramic.png",
})

awards.register_award(MOD..":ceramic_solutions", {
	title = "Ceramic Solutions",
	description = "Make a waterpot.",
	icon = "bucket.png",
})

awards.register_award(MOD..":personal_touch", {
	title = "A Personal Touch",
	description = "Use any dye on a ceramic or piece of pottery.",
	icon = "dye_red.png",
})

awards.register_award(MOD..":safe_and_sound", {
	title = "Safe and Sound",
	description = "Hide something inside a ceramic pot.",
	icon = "default_chest_front.png",
})

awards.register_award(MOD..":hobbyist", {
	title = "Hobbyist",
	description = "Put a flower into a flowerpot.",
	icon = "default_flower_rose.png",
})

awards.register_award(MOD..":professional_potter", {
	title = "Professional Potter",
	description = "Make every ceramic variant.",
	icon = "wc_pottery_ceramic.png",
})

----------------------------------------------------------------------
-- 2) “Ceramic Age”: detect when the player takes a chip from a furnace
--    Works without 'cooked' by watching inventory actions on node furnaces.
----------------------------------------------------------------------
if minetest.register_on_player_inventory_action then
	minetest.register_on_player_inventory_action(function(player, action, inv, info)
		if not player or not player:is_player() then return end
		if action ~= "take" and action ~= "move" then return end
		if not info or not info.stack then return end
		if info.stack:get_name() ~= N.chip then return end

		-- Was this taken from a furnace output list?
		local loc = inv and inv:get_location() or {}
		if loc.type ~= "node" or not loc.pos then return end
		local nodename = minetest.get_node(loc.pos).name or ""
		if (nodename:find("furnace") or nodename:find("smelter")) and (info.from_list == "dst" or info.listname == "dst") then
			awards.unlock(player:get_player_name(), MOD..":ceramic_age")
		end
	end)
end

-- Extra fallback: if some mod crafts the chip, still award it.
minetest.register_on_craft(function(stack, player)
	if player and stack:get_name() == N.chip then
		awards.unlock(player:get_player_name(), MOD..":ceramic_age")
	end
end)

----------------------------------------------------------------------
-- 3) “Ceramic Solutions”: unlock when the Waterpot is crafted.
----------------------------------------------------------------------
minetest.register_on_craft(function(itemstack, player)
	if player and itemstack:get_name() == N.waterpot then
		awards.unlock(player:get_player_name(), MOD..":ceramic_solutions")
	end
end)

----------------------------------------------------------------------
-- 4) “A Personal Touch”: unlock when a dye is used on any wc_pottery node.
----------------------------------------------------------------------
local function is_dye(name) return type(name)=="string" and name:sub(1,4)=="dye:" end

for nodename, def in pairs(minetest.registered_nodes) do
	if nodename:sub(1, #MOD+1) == (MOD..":") then
		local orig = def.on_rightclick
		minetest.override_item(nodename, {
			on_rightclick = function(pos, node, clicker, itemstack, pointed)
				if clicker and clicker:is_player() and itemstack and is_dye(itemstack:get_name()) then
					awards.unlock(clicker:get_player_name(), MOD..":personal_touch")
				end
				if orig then
					return orig(pos, node, clicker, itemstack, pointed)
				end
				return itemstack
			end
		})
	end
end

----------------------------------------------------------------------
-- 5) “Safe and Sound” + “Hobbyist”: detect inserts into flowerpot GUI.
--    We wrap allow_metadata_inventory_put on all nodes in group:flowerpot.
----------------------------------------------------------------------
local function wrap_flowerpot_put(nodename)
	local def = minetest.registered_nodes[nodename]; if not def then return end
	local orig = def.allow_metadata_inventory_put
	minetest.override_item(nodename, {
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			local allowed = stack and stack:get_count() or 0
			if orig then allowed = orig(pos, listname, index, stack, player) or 0 end
			if listname == "pot" and allowed > 0 and player and player:is_player() then
				local pn = player:get_player_name()
				awards.unlock(pn, MOD..":safe_and_sound")
				if minetest.get_item_group(stack:get_name(), "flower") > 0 then
					awards.unlock(pn, MOD..":hobbyist")
				end
			end
			return allowed
		end
	})
end

for nn, def in pairs(minetest.registered_nodes) do
	if def and def.groups and def.groups.flowerpot == 1 then
		wrap_flowerpot_put(nn)
	end
end

----------------------------------------------------------------------
-- 6) “Professional Potter”: track categories across sessions (meta).
--    Categories must each be crafted or placed at least once.
----------------------------------------------------------------------
local CATS = {
	ceramic      = { items = { N.ceramic },      nodes = { N.ceramic } },
	tiles        = { items = { N.ceramic_tile }, nodes = { N.ceramic_tile } },
	unfired_pot  = { items = { N.pot_unfired },  nodes = { N.pot_unfired } },
	fired_pot    = { items = { N.pot_fired },    nodes = { N.pot_fired } },
	waterpot     = { items = { N.waterpot },     nodes = { N.waterpot } },
	flowerpot    = { items = { },                nodes = { }, group = "flowerpot" },
}

local function mark_progress(playername, catkey)
	local player = minetest.get_player_by_name(playername); if not player then return end
	local meta = player:get_meta()
	local key = "wc_pottery_prof_"..catkey
	if meta:get_int(key) ~= 1 then meta:set_int(key, 1) end

	-- Completed?
	for k,_ in pairs(CATS) do
		if meta:get_int("wc_pottery_prof_"..k) ~= 1 then return end
	end
	awards.unlock(playername, MOD..":professional_potter")
end

-- On craft: mark categories by crafted item
minetest.register_on_craft(function(itemstack, player)
	if not player or not player:is_player() then return end
	local name = itemstack:get_name()
	for catkey, spec in pairs(CATS) do
		for _, it in ipairs(spec.items) do
			if it ~= "" and name == it then
				mark_progress(player:get_player_name(), catkey)
				return
			end
		end
	end
end)

-- On place: mark categories by placed node (and by group for flowerpot)
minetest.register_on_placenode(function(pos, newnode, placer)
	if not placer or not placer:is_player() then return end
	local pname = placer:get_player_name()
	local nn = newnode.name
	local def = minetest.registered_nodes[nn]

	-- Group-based flowerpot detection
	if def and def.groups and def.groups.flowerpot == 1 then
		mark_progress(pname, "flowerpot"); return
	end

	-- Exact-node categories
	for catkey, spec in pairs(CATS) do
		for _, n in ipairs(spec.nodes) do
			if n ~= "" and nn == n then
				mark_progress(pname, catkey); return
			end
		end
	end
end)


