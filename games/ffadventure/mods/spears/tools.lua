-- Javelin: throwable, smaller inventory icon, vertical recipe
function spears_register_spear(spear_type, desc, base_damage, toughness, material)
    minetest.register_tool("spears:spear_" .. spear_type, {
        description = desc .. " Javelin",
        wield_image = "spears_spear_" .. spear_type .. ".png^[transform4",
        inventory_image = "spears_spear_" .. spear_type .. ".png^[resize:12x12",
        wield_scale = {x = 1.5, y = 1.5, z = 1.5},
        on_secondary_use = function(itemstack, user, pointed_thing)
            spears_throw(itemstack, user, pointed_thing)
            if not minetest.settings:get_bool("creative_mode") then
                itemstack:take_item()
            end
            return itemstack
        end,
        on_place = function(itemstack, user, pointed_thing)
            spears_throw(itemstack, user, pointed_thing)
            if not minetest.settings:get_bool("creative_mode") then
                itemstack:take_item()
            end
            return itemstack
        end,
        tool_capabilities = {
            full_punch_interval = 1.5,
            max_drop_level = 1,
            groupcaps = {
                cracky = {times={[3]=2}, uses=toughness, maxlevel=1},
            },
            damage_groups = {fleshy=base_damage},
        },
        sound = {breaks = "default_tool_breaks"},
        groups = {flammable = 1}
    })

	local SPEAR_ENTITY = spears_set_entity(spear_type, base_damage, toughness)

	minetest.register_entity("spears:spear_" .. spear_type .. "_entity", SPEAR_ENTITY)

	-- Javelin recipe: horizontal (stick + stick + material)
	minetest.register_craft({
		output = 'spears:spear_' .. spear_type,
		recipe = {
			{"group:stick", "group:stick", material}
		}
	})
end

-- Real spear: melee only, +2 reach, diagonal recipe (the old javelin recipe)
function spears_register_real_spear(spear_type, desc, base_damage, toughness, material)
	minetest.register_tool("spears:real_spear_" .. spear_type, {
		description = desc .. " Spear",
		wield_image = "spears_spear_" .. spear_type .. ".png^[transform4",
		inventory_image = "spears_spear_" .. spear_type .. ".png",
		wield_scale = {x = 1.5, y = 1.5, z = 1.5},
		range = 6,
		tool_capabilities = {
			full_punch_interval = 1.2,
			max_drop_level = 1,
			groupcaps = {
				cracky = {times={[3]=2}, uses=toughness, maxlevel=1},
			},
			damage_groups = {fleshy=base_damage},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {flammable = 1}
	})

	minetest.register_craft({
		output = "spears:real_spear_" .. spear_type,
		recipe = {
			{"", "", material},
			{"", "group:stick", ""},
			{"group:stick", "", ""}
		}
	})

	minetest.register_craft({
		output = "spears:real_spear_" .. spear_type,
		recipe = {
			{material, "", ""},
			{"", "group:stick", ""},
			{"", "", "group:stick"}
		}
	})
end

if not DISABLE_STONE_SPEAR then
	-- Damage reference: wood sword=2, stone sword=4, bronze sword=6, steel sword=7
	-- Spears match sword damage at same tier. Javelins do slightly less (throwable).
	-- Real spears: slower (1.2s) but +2 reach. Javelins: slowest (1.5s) but throwable.
	spears_register_spear('flint', 'Flint', 3, 5, 'default:flint')
	spears_register_real_spear('flint', 'Flint', 4, 5, 'default:flint')
	spears_register_spear('wood', 'Wood', 2, 10, 'group:wood')
	spears_register_real_spear('wood', 'Wood', 2, 10, 'group:wood')
	spears_register_spear('bone', 'Bone', 3, 14, 'bonemeal:bone')
	spears_register_real_spear('bone', 'Bone', 4, 14, 'bonemeal:bone')
	spears_register_spear('stone', 'Stone', 4, 20, 'group:stone')
	spears_register_real_spear('stone', 'Stone', 5, 20, 'group:stone')
	spears_register_spear('iron', 'Iron', 5, 30, 'default:ironbar')
	spears_register_real_spear('iron', 'Iron', 6, 30, 'default:ironbar')
end
if minetest.get_modpath("pigiron") then
	if not DISABLE_IRON_SPEAR then
		spears_register_spear('iron', 'Iron', 5, 30, 'default:ironbar')
		spears_register_real_spear('iron', 'Iron', 6, 30, 'default:ironbar')
	end
	if not DISABLE_STEEL_SPEAR then
		spears_register_spear('steel', 'Steel', 5, 35, 'default:steel_ingot')
		spears_register_real_spear('steel', 'Steel', 6, 35, 'default:steel_ingot')
		spears_register_spear('csteel', 'Cobalt Steel', 5, 45, 'default:cobaltsteelbar')
		spears_register_real_spear('csteel', 'Cobalt Steel', 6, 45, 'default:cobaltsteelbar')
	end
	if not DISABLE_COPPER_SPEAR then
		spears_register_spear('copper', 'Copper', 4, 30, 'default:copper_ingot')
		spears_register_real_spear('copper', 'Copper', 5, 30, 'default:copper_ingot')
	end
	if not DISABLE_BRONZE_SPEAR then
		spears_register_spear('bronze', 'Bronze', 5, 35, 'default:bronze_ingot')
		spears_register_real_spear('bronze', 'Bronze', 6, 35, 'default:bronze_ingot')
		spears_register_spear('iron', 'Iron', 5, 35, 'default:ironbar')
		spears_register_real_spear('iron', 'Iron', 6, 35, 'default:ironbar')
	end
else
	if not DISABLE_STEEL_SPEAR then
		spears_register_spear('steel', 'Steel', 5, 30, 'default:steel_ingot')
		spears_register_real_spear('steel', 'Steel', 6, 30, 'default:steel_ingot')
		spears_register_spear('iron', 'Iron', 5, 30, 'default:ironbar')
		spears_register_real_spear('iron', 'Iron', 6, 30, 'default:ironbar')
		spears_register_spear('csteel', 'Cobalt Steel', 5, 45, 'default:cobaltsteelbar')
		spears_register_real_spear('csteel', 'Cobalt Steel', 6, 45, 'default:cobaltsteelbar')
	end
	if not DISABLE_COPPER_SPEAR then
		spears_register_spear('copper', 'Copper', 4, 30, 'default:copper_ingot')
		spears_register_real_spear('copper', 'Copper', 5, 30, 'default:copper_ingot')
	end
	if not DISABLE_BRONZE_SPEAR then
		spears_register_spear('bronze', 'Bronze', 5, 35, 'default:bronze_ingot')
		spears_register_real_spear('bronze', 'Bronze', 6, 35, 'default:bronze_ingot')
	end
end

if not DISABLE_OBSIDIAN_SPEAR then
	spears_register_spear('obsidian', 'Obsidian', 7, 30, 'default:obsidian')
	spears_register_real_spear('obsidian', 'Obsidian', 8, 30, 'default:obsidian')
end

if not DISABLE_DIAMOND_SPEAR then
	spears_register_spear('diamond', 'Titanium', 7, 40, 'default:titaniumbar')
	spears_register_real_spear('diamond', 'Titanium', 8, 40, 'default:titaniumbar')
end

if not DISABLE_GOLD_SPEAR then
	spears_register_spear('gold', 'Golden', 4, 40, 'default:gold_ingot')
	spears_register_real_spear('gold', 'Golden', 5, 40, 'default:gold_ingot')
end
