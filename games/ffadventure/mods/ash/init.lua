--[[
              .__
_____    _____|  |__
\__  \  /  ___/  |  \
 / __ \_\___ \|   Y  \
(____  /____  >___|  /
     \/     \/     \/
--]]

local load_time_start = os.clock()
local modname = minetest.get_current_modname()

local creative_exists = minetest.global_exists("creative")

ash = {}

-- Mods can add something to this table.
ash.nodes_with_ash = {
	"default:dirt",
	"default:dirt_with_grass",
	"default:dirt_with_grass_footsteps",
	"default:dirt_with_dry_grass",
	"default:dirt_with_snow",
	"biomes_island:dirt_with_island_litter",
	"default:dirt_with_rainforest_litter",
	"group:tree",

	["default:dirt"]                        = "ash:dirt_with_ash",
	["default:dirt_with_grass"]             = "ash:dirt_with_ash",
	["default:dirt_with_grass_footsteps"]   = "ash:dirt_with_ash",
	["default:dirt_with_dry_grass"]         = "ash:dirt_with_ash",
	["default:dirt_with_snow"]              = "ash:dirt_with_ash",
	["default:dirt_with_rainforest_litter"] = "ash:dirt_with_ash",
	["biomes_island:dirt_with_island_litter"] = "ash:dirt_with_ash",
}

function ash.ash_onto_node(pos)
	pos.y = pos.y - 1
	local node = minetest.get_node(pos)
	local replacement = ash.nodes_with_ash[node.name]
	if not replacement then
		return
	end
	if replacement == "charcoal:charcoal_block" then
		minetest.swap_node(pos, {name = replacement})
	else
		node.name = replacement
		minetest.swap_node(pos, node)
	end
end

function ash.burn_node(pos, param2)
    local node = minetest.get_node(pos)
    
        -- Check if the node is part of group:tree (logs)
            if minetest.get_item_group(node.name, "tree") > 0 then
                    -- Replace tree (logs) with charcoal block
                            minetest.set_node(pos, {name = "charcoal:charcoal_block", param2 = param2})
                                else
                                        -- Otherwise, replace with ash
                                                minetest.set_node(pos, {name = "ash:ash", param2 = param2})
                                                    end
                                                    
                                                        -- Check for falling nodes (so the ash can fall if needed)
                                                            minetest.check_for_falling(pos)
                                                            end
                                                            

minetest.after(0, function()
	for name, def in pairs(minetest.registered_nodes) do
		if def.groups.flammable and not def.on_burn then
			rawset(minetest.registered_nodes[name], "on_burn", ash.burn_node)
		end
	end
end)

local step = 64 / 16 * 2 -- 2 pixels

minetest.register_node("ash:dirt_with_ash", {
	description = "Dirt with Ash",
	tiles = {"ash_ash.png", "default_dirt.png",
		{name = "default_dirt.png^ash_ash_side.png", tileable_vertical = false}},
	groups = {crumbly = 3, ashy = 1},
	drop = "default:dirt",
})

minetest.register_node("ash:ash", {
	description = "Ash",
	tiles = {"ash_ash.png"},
	inventory_image = "ash_ashball.png",
	wield_image = "ash_ashball.png",
	paramtype = "light",
	paramtype2 = "leveled",
	buildable_to = true,
	floodable = true,
	place_param2 = step,
	leveled = step, -- needed for falling nodes to stack (see minetest#8307)
	drawtype = "nodebox",
	node_box = {
		type = "leveled",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
	},
	node_placement_prediction = "",
	groups = {crumbly = 3, falling_node = 1, ashy = 1, ash_onto_node = 1},

	on_construct = ash.ash_onto_node,

	-- Give more ash because of level.
	on_dig = function(pos, node, digger)
		local level = minetest.get_node_level(pos)
		minetest.node_dig(pos, node, digger)
		if minetest.get_node(pos).name == node.name or
				not digger or
				not digger:is_player() or
				creative_exists and
				creative.is_enabled_for(digger:get_player_name()) then
			return
		end
		local remaining = ItemStack("ash:ash "..tostring(level/step-1))
		if not remaining:is_empty() then
			core.handle_node_drops(pos, {remaining}, digger)
		end
	end,

	on_place = function(itemstack, placer, pointed_thing)
		local place_to = pointed_thing.under
		local old_node = minetest.get_node(place_to)
		if old_node.name ~= "ash:ash" then
			local node_def = minetest.registered_nodes[old_node.name]
			if node_def and node_def.buildable_to then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
			place_to = pointed_thing.above
			old_node = minetest.get_node(place_to)
			if old_node.name ~= "ash:ash" then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		-- Check for protection.
		local player_name = placer and placer:is_player()
		player_name = player_name and placer:get_player_name() or ""
		if minetest.is_protected(place_to, player_name) and
				(player_name == "" or
				not minetest.check_player_privs(placer, "protection_bypass")) then
			if player_name == "" then
				return itemstack
			end
			minetest.log("action", player_name.." tried to place ash:ash at "..
				"protected position "..minetest.pos_to_string(place_to))
			minetest.record_protection_violation(place_to, player_name)
			return itemstack
		end
		-- Increase the level.
		local level = minetest.get_node_level(place_to)
		level = level + step
		if level >= 64 then
			minetest.swap_node(place_to, {name = "ash:ashblock"})
		else
			minetest.set_node_level(place_to, level)
		end
		if not (creative_exists and creative.is_enabled_for(player_name)) then
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_node("ash:ashblock", {
	description = "Ash Block",
	tiles = {"ash_ash.png"},
	groups = {crumbly = 3, falling_node=1, ashy = 1, ash_onto_node = 1},
	on_construct = ash.ash_onto_node,
})

minetest.register_abm({
	label = "put ash onto node beyond",
	nodenames = {"group:ash_onto_node"},
	neighbors = ash.nodes_with_ash,
	interval = 26,
	chance = 5,
	action = ash.ash_onto_node,
})

minetest.register_craft({
	type = "shapeless",
	output = "ash:ash 9",
	recipe = {"ash:ashblock"},
})

minetest.register_craft({
	type = "shapeless",
	output = "ash:ashblock",
	recipe = {
		"ash:ash", "ash:ash", "ash:ash",
		"ash:ash", "ash:ash", "ash:ash",
		"ash:ash", "ash:ash", "ash:ash",
	},
})

minetest.register_craft({
    type = "cooking",
    output = "charcoal:charcoal 2",
    recipe = "ash:ashblock",
    cooktime = 28,  -- Cooking time in seconds
})

local time = math.floor(tonumber(os.clock()-load_time_start)*100+0.5)/100
local msg = "["..modname.."] loaded after ca. "..time
if time > 0.05 then
	print(msg)
else
	minetest.log("info", msg)
end
