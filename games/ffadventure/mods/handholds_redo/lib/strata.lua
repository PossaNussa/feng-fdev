-- Marks every stone type used by the default strata (see default/ugrnd.lua)
-- as carveable, together with all of the ore variants that are cut into them.
-- Without this, a cliff of schist or a cavern wall of gneiss would be the only
-- rock in the game a pickaxe could not get a grip on.

local mod_default = core.get_modpath("default") ~= nil
if not mod_default then return end

-- Base stone of each stratum -> pickaxe level required to carve it
local strata = {
	["default:stone"]            = 1,
	["default:desert_stone"]     = 1,
	["default:sandstone"]        = 1,
	["default:desert_sandstone"] = 1,
	["default:silver_sandstone"] = 1,
	["default:saprolite"]        = 1,
	["default:shale"]            = 1,
	["default:limestone"]        = 1,
	["default:limestone_pillar"] = 1,
	["default:schist"]           = 1,
	["default:slate"]            = 1,
	["default:marble"]           = 1,
	["default:salt"]             = 1,
	["default:pumice"]           = 1,
	["default:pumtile"]          = 1,
	["default:prick"]            = 1,
	["default:pflag"]            = 1,
	["default:pumcobble"]        = 1,
	["default:quartz"]           = 2,
	["default:onyx"]             = 2,
	["default:granite"]          = 2,
	["default:gneiss"]           = 2,
	["default:obsidian"]         = 3,
	["default:mantle"]           = 3,
}

-- Ore nodes are named "<host>_with_<mineral>" (plus the "_dense" variants that
-- default generates on top of those). They are part of the wall as far as a
-- climber is concerned, so they inherit their host stratum's level.
local ore_prefixes = {}
for name, level in pairs(strata) do
	ore_prefixes[name .. "_with_"] = level
end

-- Hosts whose ore nodes do not share the base node's name
ore_prefixes["default:basalt_with_"] = 3      -- basalt ores, obsidian stratum
ore_prefixes["default:mantle_rock_with_"] = 3 -- mantle ores

-- Asbestos rides along in the metamorphic strata
ore_prefixes["asbestos:stone_with_"] = 1
ore_prefixes["asbestos:schist_with_"] = 1
ore_prefixes["asbestos:slate_with_"] = 1
ore_prefixes["asbestos:gneiss_with_"] = 2

core.register_on_mods_loaded(function()
	local marked = 0

	local function mark(name, level)
		local def = core.registered_nodes[name]
		if def == nil or def.groups == nil then return end
		-- if something already made this node carveable, keep whichever
		-- requirement is the more permissive of the two
		local current = def.groups.handholds
		if current ~= nil and current <= level then return end
		handholds.mark_climbable(name, level)
		marked = marked + 1
	end

	for name, level in pairs(strata) do
		mark(name, level)
	end

	for name in pairs(core.registered_nodes) do
		for prefix, level in pairs(ore_prefixes) do
			if name:sub(1, #prefix) == prefix then
				mark(name, level)
				break
			end
		end
	end

	core.log("action", "[Handholds Redo] marked " .. marked .. " strata nodes as carveable")
end)
