-- Update simplecoins:coins stack size
minetest.override_item("simplecoins:coins", {
    stack_max = 100,
})

-- Function to update the bag's description based on the number of coins inside
local function update_bag_description(itemstack)
    local meta = itemstack:get_meta()
    local coins = meta:get_int("coins") or 0
    meta:set_string("description", coins > 0 and "Money Bag (" .. coins .. " coins)" or "Empty Money Bag")
end

-- Function to update the bag's description and image based on the number of coins inside
-- Function to update the bag's description and image based on the number of coins inside
local function update_bag(itemstack)
    if itemstack:is_empty() then
        return itemstack
    end

    local meta = itemstack:get_meta()
    local coins = meta:get_int("coins") or 0

    -- Update description
    meta:set_string("description", coins > 0 and "Money Bag (" .. coins .. " coins)" or "Empty Money Bag")

    -- Update image based on the number of coins
    if coins == 0 then
        itemstack:set_name("moneybag:bolsa_dinero_2")  -- Use bolsa_de_tesoro2.png for empty bags
    else
        itemstack:set_name("moneybag:bolsa_dinero_1")  -- Use bolsa_de_tesoro.png for bags with coins
    end

    return itemstack
end

-- Register Money Bags
minetest.register_craftitem("moneybag:bolsa_dinero_1", {
    description = "Money Bag",
    inventory_image = "bolsa_de_tesoro.png",
    stack_max = 1,  -- Only one money bag can be held at a time to track the coins inside
    on_use = function(itemstack, user, pointed_thing)
        -- Show the number of coins in chat instead of returning coins
        update_bag(itemstack)
        minetest.chat_send_player(user:get_player_name(), itemstack:get_meta():get_string("description"))
        return itemstack  -- Ensure the bag isn't turned into a stack of coins
    end,
    on_place = function(itemstack, placer, pointed_thing)
        update_bag(itemstack)
        return itemstack  -- Ensure the bag isn't turned into a stack of coins
    end,
    on_metadata_inventory_take = function(inv, listname, index, stack, player)
        update_bag(stack)  -- Update the bag after a trade or take operation
        inv:set_stack(listname, index, stack)
    end,
})

minetest.register_craftitem("moneybag:bolsa_dinero_2", {
    description = "Money Bag",
    inventory_image = "bolsa_de_tesoro2.png",
    stack_max = 1,  -- Same here to allow coin tracking
    on_use = function(itemstack, user, pointed_thing)
        -- Show the number of coins in chat instead of returning coins
        update_bag(itemstack)
        minetest.chat_send_player(user:get_player_name(), itemstack:get_meta():get_string("description"))
        return itemstack  -- Ensure the bag isn't turned into a stack of coins
    end,
    on_place = function(itemstack, placer, pointed_thing)
        update_bag(itemstack)
        return itemstack  -- Ensure the bag isn't turned into a stack of coins
    end,
    on_metadata_inventory_take = function(inv, listname, index, stack, player)
        update_bag(stack)  -- Update the bag after a trade or take operation
        inv:set_stack(listname, index, stack)
    end,
})

-- Register /moneybag Command
minetest.register_chatcommand("moneybag", {
    params = "<fill|empty> <amount>",
    description = "Fill or empty the money bag.",
    func = function(player_name, param)
        local params = param:split(" ")
        if #params < 2 then return false, "Usage: /moneybag <fill|empty> <amount>" end
        local player = minetest.get_player_by_name(player_name)
        local itemstack = player:get_wielded_item()
        local itemname = itemstack:get_name()

        if itemname ~= "moneybag:bolsa_dinero_1" and itemname ~= "moneybag:bolsa_dinero_2" then
            return false, "You must hold a money bag to use this command."
        end

        local meta = itemstack:get_meta()
        local coins = meta:get_int("coins") or 0

        if params[1] == "fill" then
            local amount = tonumber(params[2])
            if not amount or amount <= 0 then return false, "Invalid amount." end
            if coins + amount > 1000 then return false, "Money bag can't hold more than 1000 coins." end
            local inv = player:get_inventory()
            local stack = ItemStack("simplecoins:coins " .. amount)
            if inv:contains_item("main", stack) then
                inv:remove_item("main", stack)
                coins = coins + amount
                meta:set_int("coins", coins)
                update_bag(itemstack)
                player:set_wielded_item(itemstack)
                return true, "Added " .. amount .. " coins to the money bag. It now contains " .. coins .. " coins."
            else
                return false, "Not enough coins in inventory."
            end
        elseif params[1] == "empty" then
            local amount = tonumber(params[2])
            if not amount or amount <= 0 then return false, "Invalid amount." end
            if coins == 0 then return false, "The money bag is empty." end
            if amount > coins then return false, "The money bag doesn't have that many coins." end
            local inv = player:get_inventory()
            local add_stack = ItemStack("simplecoins:coins " .. amount)
            if inv:room_for_item("main", add_stack) then
                inv:add_item("main", add_stack)
                coins = coins - amount
                meta:set_int("coins", coins)
                update_bag(itemstack)
                player:set_wielded_item(itemstack)
                return true, "Removed " .. amount .. " coins from the money bag. It now contains " .. coins .. " coins."
            else
                return false, "Not enough room in your inventory."
            end
        else
            return false, "Invalid command. Usage: /moneybag <fill|empty> <amount>"
        end
    end
})


-- Register Craft Recipes
minetest.register_craft({
    output = "moneybag:bolsa_dinero_2 10",
    recipe = {
        {"farming:string", "farming:string", "farming:string"},
        {"wool:white", "wool:white", "wool:white"},
        {"", "", ""},
    },
})  

minetest.register_craft({
    output = "moneybag:bolsa_dinero_1 5",
    recipe = {
        {"", "", ""},
        {"moneybag:bolsa_dinero_2", "default:gold_ingot", ""},
        {"", "", ""},
    },
})
