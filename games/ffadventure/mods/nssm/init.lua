local path = minetest.get_modpath("nssm")

-- translation
local S
if minetest.get_translator then
	S = minetest.get_translator("nssm") -- 5.x translation function
else -- boilerplate function
	S = function(str, ...)
		local args = {...}
		return str:gsub("@%d+", function(match)
			return args[tonumber(match:sub(2))]
		end)
	end
end

nssm = {
	mymapgenis = tonumber(minetest.settings:get("nssm.mymapgenis")) or 7,
	multimobs = tonumber(minetest.settings:get("nssm.multimobs")) or 1000,
	spiders_litter_web = minetest.settings:get_bool("nssm.spiders_litter_web", true),
	classic_rainbow_staff = minetest.settings:get_bool("nssm.classic_rainbow_staff", false),
	S = S
}


-- Mobs
dofile(path .. "/mobs/crocodile.lua")
dofile(path .. "/mobs/giant_sandworm.lua")
dofile(path .. "/mobs/sandworm.lua")

-- Final Boss
-- Others
dofile(path .. "/darts.lua")
dofile(path .. "/nssm_materials.lua")
dofile(path .. "/nssm_api.lua")


if minetest.get_modpath("3d_armor") then
	dofile(path .. "/nssm_armor.lua")
end

-- Spawn settings
dofile(path .. "/spawn.lua")


print("[MOD] NSSM loaded")
