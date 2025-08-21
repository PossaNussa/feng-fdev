local shared = {}
shared.decalLifetime = tonumber(minetest.settings:get("blood_splatter.decalLifetime")) or 300


local function dependency_version_error(mod_title)
    error(
        '\n' ..
        'blood_splatter\n' ..
        "────────────────────────────────────────────────────────────────────────────────────────────────────\n" ..
        'You have an outdated version of the mod "' .. mod_title .. '" installed. ' ..
        'Please go to "Content" → "Browse online content" and update the mod "' .. mod_title .. '".\n' ..
        "────────────────────────────────────────────────────────────────────────────────────────────────────\n",
        0
    )
end
if not modlib.version or modlib.version < 102 then
    dependency_version_error("Modding Library")
end

-- For the largest available spray size (3×3=9 pixels), this results in 33.33 seconds.
shared.SPRAY_DURATION = 5 * 60
-- Clients send the position of their player every 0.1 seconds.
-- https://github.com/minetest/minetest/blob/5.6.1/src/client/client.h#L563
-- https://github.com/minetest/minetest/blob/5.6.1/src/client/client.cpp#L528
shared.SPRAY_STEP_INTERVAL = 0.1
shared.NUM_SPRAY_STEPS = 5

shared.MAX_SPRAY_DISTANCE = 4
shared.DESIRED_PIXEL_SIZE = 1/16
shared.TRANSPARENT = "#00000000"

shared.EPSILON = 0.0001


local basepath = minetest.get_modpath("blood_splatter")
assert(loadfile(basepath .. "/aabb.lua"))(shared)
assert(loadfile(basepath .. "/canvas.lua"))(shared)
assert(loadfile(basepath .. "/spraycast.lua"))(shared)

local function bleed_any(actor, pos, color)
	local spray_def = {size=3,color="#800000ff"}
	if color then spray_def.color = color end
	shared.MAX_SPRAY_DISTANCE = 2
	for i=1,400 do
		spray_def.size=math.ceil(math.random()*6)
		local dir = vector.new(0,0,0)
		for j=1,3 do
			dir[j] = math.random()*2-1
		end
		shared.spraycast(actor, pos, dir, spray_def) --actor was minetest.get_connected_players()[1]
		--player_lasts[player_name] = { pos = pos, dir = dir }
		
    end
    shared.after_spraycasts()
end

local blood_color = {
["mobs_monster:dirt_monster"]="#594E2E",
["mobs_monster:sand_monster"]="#c2b280",
["mobs_monster:tree_monster"]="#C0D036",
["mobs_monster:stone_monster"]=false,
["mobs_monster:lava_flan"]=false,
["mobs_monster:obsidian_flan"]=false,
["mobs_monster:fire_spirit"]=false,
["mobs_ghost_redo:ghost"]=false,
["mobs_skeletons:skeleton"]=false,
["mobs_skeletons:skeleton_archer"]=false,
["mobs_skeletons:skeleton_archer_dark"]=false,

["mobs_mc:ghast"]=false,
["mobs_mc:skeleton_horse"]=false,
["mobs_mc:skeleton"]=false,
["mobs_mc:witherskeleton"]=false,
["mobs_mc:wither"]=false,
["mobs_mc:iron_golem"]=false,
["mobs_mc:vex"]=false,
["mobs_mc:creeper"]="#C0D036",
["mobs_mc:slime_small"]="#C0D036",
["mobs_mc:slime_big"]="#C0D036",
}
local function bleed_animal(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	local mob = self.object
	local pos = mob:get_pos()
	pos.y = pos.y + 1/2
	
	--~ minetest.chat_send_player("singleplayer", mob:get_luaentity().name)
	local color = blood_color[mob:get_luaentity().name]
	if color ~= nil then
		if color == false then return end
		bleed_any(mob,pos,color)
	else
		bleed_any(mob,pos)
	end
	
	
end

local function bleed_player(player, hp_change, reason)
	if hp_change < 0 then
		local pos = player:get_pos()
		pos.y = pos.y + 1
		bleed_any(player,pos)
		--shared.set_hud_damage(player)
	end
end

local hijacked_functions = {}
minetest.register_on_mods_loaded(function()
	for k,v in pairs(minetest.registered_entities) do
		--~ for k,v in pairs(v) do
			--~ print(k,":",v)
			
		--~ end
		if v.is_mob or v._creatura_mob or v.type then --mcl, creatura, mobs
			--~ print(k)
			hijacked_functions[k] = v.on_punch
			v.on_punch = function(self, ...)
					bleed_animal(self, ...)
					return hijacked_functions[self.name](self, ...)
				end
		end
	end
end)

minetest.register_on_player_hpchange(bleed_player)