local tools = {
    pick = {
        title = 'Pickaxe',
    },
    axe = {
        title = 'Axe',
    },
    shovel = {
        title = 'Shovel',
    },
    sword = {
        title = 'Sword',
        light_source = 0,
    },
    hammer = {
        title = 'Hammer',
        only_materials = { flint = true },
    },
}

local materials = {
    flint = {
        texture = 'flint_obj.png',
        title = 'Flint',
        replacement = {
            pick = 'default:pick_stone',
            sword = 'default:sword_stone',
            axe = 'default:axe_stone',
            shovel = 'default:shovel_stone',
            hammer = 'default:hammer_flint',
        }
    },
    obsidian = {
        texture = 'default_obsidian.png',
        title = 'Flint',
        tool_capabilities = {
            pick = {
                full_punch_interval = 1.1,
                max_drop_level = 3,
                groupcaps = {
                    cracky = { times = { [1] = 2.2, [2] = 1.1, [3] = 0.55 }, uses = 60, maxlevel = 3 },
                },
                damage_groups = { fleshy = 6 },
            },
            sword = {
                full_punch_interval = 0.9,
                max_drop_level = 1,
                light_source = 0,
                groupcaps = {
                    snappy = { times = { [1] = 1.95, [2] = 0.95, [3] = 0.32 }, uses = 80, maxlevel = 3 },
                },
                damage_groups = { fleshy = 9 },
            },
            axe = {
                full_punch_interval = 1.1,
                max_drop_level = 1,
                groupcaps = {
                    choppy = { times = { [1] = 2.15, [2] = 0.95, [3] = 0.55 }, uses = 60, maxlevel = 3 },
                },
                damage_groups = { fleshy = 8 },
            },
            shovel = {
                full_punch_interval = 1.2,
                max_drop_level = 1,
                groupcaps = {
                    crumbly = { times = { [1] = 1.15, [2] = 0.55, [3] = 0.30 }, uses = 60, maxlevel = 3 },
                },
                damage_groups = { fleshy = 5 },
            }
        }
    },
}

if core.global_exists('stoneage') then
    materials.flint = nil
end

-- Maps head item name → tool item name for wear transfer
local head_to_tool = {}

for name, def in pairs(tools) do
    for material, props in pairs(materials) do
        if def.only_materials and not def.only_materials[material] then goto continue end
        local item_name = "knapping_mtg:" .. material .. "_" .. name .. "_head"
        core.register_tool(item_name, {
            description = "Knapped " .. props.title .. ' ' .. def.title .. " Head",
            inventory_image = material .. "_" .. name .. "_head.png",
            groups = { knapped_head = 1, not_in_creative_inventory = 0 },
        })

        knapping.register_recipe({
            input = "default:" .. material,
            output = item_name,
            recipe = knapping.default_recipes[name],
            texture = props.texture
        })

        local tool_name = ''

        if props.replacement and props.replacement[name] then
            tool_name = props.replacement[name]

            core.clear_craft({
                output = props.replacement[name]
            })

            core.override_item(tool_name, {
                inventory_image = material .. "_" .. name .. ".png",
                description = props.title .. " " .. def.title,
                wield_image = name == 'shovel' and (material .. "_" .. name .. ".png^[transformR90") or (material .. "_" .. name .. ".png"),
            })
        else
            tool_name = 'knapping_mtg:' .. name .. '_' .. material

            core.register_tool(tool_name, {
                description = "Knapped " .. props.title .. ' ' .. def.title,
                inventory_image = material .. "_" .. name .. ".png",
                wield_image = name == 'shovel' and (material .. "_" .. name .. ".png^[transformR90") or (material .. "_" .. name .. ".png"),
                tool_capabilities = props.tool_capabilities,
                sound = { breaks = "default_tool_breaks" },
            })
        end

        core.register_craft({
            output = tool_name,
            type = 'shaped',
            recipe = {
                { item_name },
                { 'group:stick' }
            }
        })

        head_to_tool[item_name] = tool_name
        ::continue::
    end
end

-- Transfer wear from knapped head to finished tool
local function find_head_in_craft(items)
    for _, item in ipairs(items) do
        if head_to_tool[item:get_name()] then
            return item
        end
    end
end

core.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
    if itemstack:is_empty() then return end
    local head = find_head_in_craft(old_craft_grid)
    if head and head:get_wear() > 0 then
        itemstack:set_wear(head:get_wear())
        return itemstack
    end
end)

core.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    local head = find_head_in_craft(old_craft_grid)
    if head and head:get_wear() > 0 then
        itemstack:set_wear(head:get_wear())
    end
end)
