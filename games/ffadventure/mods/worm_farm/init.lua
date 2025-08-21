--------------------------------------------------------------
--       _ _ _                  _____                       --
--      | | | |___ ___ _____   |   __|___ ___ _____         --
--      | | | | . |  _|     |  |   __|_.||  _|     |        --
--      |_____|___|_| |_|_|_|  |__|  |__||_| |_|_|_|        --
--------------------------------------------------------------
--                     Worm Farm                            --
--------------------------------------------------------------
--     https://patorjk.com/software/taag - Rectangles       --
--------------------------------------------------------------
-----------------
-- Basic Setup --
-----------------
-- modname and path
local m_name = minetest.get_current_modname()
local m_path = minetest.get_modpath(m_name)

-- setup mod global table/sub tables
worm_farm = {}
worm_farm.nodes = {}
worm_farm.textures = {}
worm_farm.sounds = {}
worm_farm.worm_foods = {}
worm_farm.worm_foods.ind = {}
worm_farm.worm_foods.grp = {}
worm_farm.worm_hydrate = {}
worm_farm.worm_hydrate.ind = {}
worm_farm.worm_hydrate.grp = {}

-- worm farm settings
worm_farm.water_max = 400  -- storage max in farm
worm_farm.water_use =   1  -- water used to create 1 worm
worm_farm.water_bonus = 2  -- number of seconds removed for having water
worm_farm.worm_tea =  198  -- Number of worms produced to get 1x worm tea
worm_farm.dirt =      297  -- Number of worms produced to get 1x dirt
worm_farm.pop_crit  =  30  -- worm population density critical limit - less than or equal
worm_farm.pop_crit_b =  4  -- worm density critical time penalty
worm_farm.pop_med =   120  -- worm population density medium limit - greater than or equal
worm_farm.pop_med_b =   1  -- worm density medium time bonus
worm_farm.pop_high =  175  -- worm population density high limit - greater than or equal
worm_farm.pop_high_b =  1  -- worm density high output bonus worm, bonus tea/dirt count (player also gets medium bonus x2)
worm_farm.pop_max =   200  -- worm population density max
worm_farm.pop_min =     2  -- worm population density min
worm_farm.food_pop =   10  -- Any food with a value above this will prevent population growth (worms hate food)
worm_farm.food_pop_d = 20  -- Any food with a value above this will cause population to decline (toxic to worms)

-- translation
worm_farm.translate = minetest.get_translator(m_name)

-- conditional mods
worm_farm.is_default  = minetest.get_modpath("default")
worm_farm.is_ethereal = minetest.get_modpath("ethereal")
worm_farm.is_bonemeal = minetest.get_modpath("bonemeal")
worm_farm.is_vessels  = minetest.get_modpath("vessels")
worm_farm.is_farming  = minetest.get_modpath("farming")
worm_farm.is_bucket_wooden = minetest.get_modpath("bucket_wooden")

-- farming_redo check
if worm_farm.is_farming and farming.mod then
		worm_farm.is_farming_redo = minetest.get_modpath("farming")
		worm_farm.is_farming = nil
end

----------------------------
-- Int/Ext Resource Setup --
----------------------------
-- worm_farm internal fallbacks
	-- Nodes/Items
	worm_farm.nodes.worm = "worm_farm:worm"
	worm_farm.nodes.dirt = "mapgen_stone"
	worm_farm.nodes.soil = "group:crumbly"
	worm_farm.nodes.wood = "group:choppy"
	worm_farm.nodes.bottle = ""
	
	-- Textures
	worm_farm.textures.worm   = "worm_farm_worm.png"
	worm_farm.textures.dirt   = "worm_farm_dirt.png"
	worm_farm.textures.bottle = ""
	
	-- Sounds
	worm_farm.sounds.sound_wood = {}
	
-- external mod integration
if worm_farm.is_default then
	-- Nodes/Items
	worm_farm.nodes.dirt = "default:dirt"
	worm_farm.nodes.soil = "group:soil"
	worm_farm.nodes.wood = "group:wood"
	
	-- Textures
	worm_farm.textures.dirt   = "default_dirt.png"
	
	-- Sounds
	worm_farm.sounds.sound_wood = default.node_sound_wood_defaults()	
end
minetest.register_craftitem("worm_farm:worm", {
    description = ("Worm"),
    inventory_image = worm_farm.textures.worm,
    groups = { worm = 1, bait = 1, food = 1, meat = 1 },
    
    on_use = minetest.item_eat(1), -- Define any groups if necessary
})

minetest.register_craftitem("worm_farm:fried_worm", {
    description = ("Fried Worm"),
    inventory_image = worm_farm.textures.worm .. "^[colorize:brown:150", -- Colorize texture to appear fried
    groups = { worm = 1, meat = 1 },
    on_use = minetest.item_eat(2), -- 1 HP
})
minetest.register_craftitem("worm_farm:burnt_worm", {
    description = ("Burnt Worm"),
    inventory_image = worm_farm.textures.worm .. "^[colorize:black:200", -- Colorize texture to appear burnt
    groups = { worm = 1, meat = 1 },
    on_use = minetest.item_eat(1), -- 0.5 HP
})

-- Custom cooking handler for worm cooking
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    local input_item = old_craft_grid[1]:get_name() -- Assuming worm is the first item
    local cook_result

    if input_item == "worm_farm:worm" then
        -- Determine if the worm should burn instead of fry (30% chance)
        if math.random() <= 0.3 then
            cook_result = "worm_farm:burnt_worm"
        else
            cook_result = "worm_farm:fried_worm"
        end

        -- Replace the worm with the cooked result
        craft_inv:remove_item("craft", input_item)
        craft_inv:add_item("craft", cook_result)
        return
    end
end)

-- Recipe to cook worm into fried or burnt worm
minetest.register_craft({
    type = "cooking",
    output = "worm_farm:fried_worm",
    recipe = "worm_farm:worm",
    cooktime = 1, -- Very fast cooking time
})

-- Recipe to burn fried worm into burnt worm
minetest.register_craft({
    type = "cooking",
    output = "worm_farm:burnt_worm",
    recipe = "worm_farm:fried_worm",
    cooktime = 1, -- Very fast cooking time
})

-- Register the cooked apple item
minetest.register_craftitem("worm_farm:cooked_apple", {
    description = "Cooked Apple",
    inventory_image = "default_apple.png^[colorize:brown:180", -- Colorized brown
    on_use = minetest.item_eat(5), -- 2.5 HP in Minetest (each HP is 2 points)
    groups = {food = 1, edible = 1},
})

-- Register the cooking recipe for the cooked apple
minetest.register_craft({
    type = "cooking",
    output = "worm_farm:cooked_apple",
    recipe = "default:apple",
    cooktime = 5, -- Adjust cook time as desired
})
-- Helper function to check if an item is edible (has `item_eat` in on_use)
local function is_food(item_def)
    return item_def.on_use and string.find(tostring(item_def.on_use), "item_eat")
end

-- Helper function to create a burnt variant
local function create_burnt_variant(item_name, item_def)
    local burnt_name = item_name .. "_burnt"
    local burnt_desc = (item_def.description or item_name) .. " (Burnt)"
    local burnt_texture = (item_def.inventory_image or "") .. "^[colorize:black:150"

    -- Register the burnt variant
    minetest.register_craftitem(burnt_name, {
        description = burnt_desc,
        inventory_image = burnt_texture,
        groups = item_def.groups or {},
        on_use = minetest.item_eat(1), -- Typically less nutritious, adjust as needed
    })
end

-- Iterate over all registered items to identify food and create burnt variants
for item_name, item_def in pairs(minetest.registered_items) do
    if is_food(item_def) then
        create_burnt_variant(item_name, item_def)
    end
end

-- ABM to detect cooking and burn food items with a 15% chance
minetest.register_abm({
    label = "Burn food during cooking",
    nodenames = {"default:furnace_active"}, -- Assuming you are using the default furnace
    interval = 1.0, -- Check every second
    chance = 1, -- Ensure the ABM checks every interval
    action = function(pos, node)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local cooked_stack = inv:get_stack("dst", 1) -- Get the cooked item from the destination slot

        if not cooked_stack:is_empty() then
            local cooked_name = cooked_stack:get_name()
            local burnt_name = cooked_name .. "_burnt"

            if minetest.registered_items[burnt_name] then
                -- 15% chance to burn the food
                if math.random() <= 0.15 then
                    -- Replace the cooked food with its burnt version
                    inv:set_stack("dst", 1, ItemStack(burnt_name))
                end
            end
        end
    end,
})



if worm_farm.is_vessels then
	-- Nodes/Items
	worm_farm.nodes.bottle = "vessels:glass_bottle"
	
	-- Textures
	worm_farm.textures.bottle = "vessels_glass_bottle.png"
	
end


dofile(m_path .. "/i_functions.lua")
dofile(m_path .. "/i_add_worms_dirt.lua")
dofile(m_path .. "/i_add_worm_food_water.lua")
dofile(m_path .. "/i_nodes_items.lua")
