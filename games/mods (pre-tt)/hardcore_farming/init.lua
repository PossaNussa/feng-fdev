
local dpath = minetest.get_modpath("hardcore_farming") .. "/"

hardcore_farming = {
    replace_rate = tonumber(minetest.settings:get("eat_crops_delay")) or 15,
    interval = tonumber(minetest.settings:get("spawn_pests_delay")) or 50,
    chance = tonumber(minetest.settings:get("spawn_pests_probability")) or 10,
 }

function getNodesByGroup(group)
    --local nodes = {}
    for name, def in pairs(minetest.registered_nodes) do
        if def.groups and def.groups[group] then
           -- table.insert(nodes, name)
		   minetest.log("ToChat:", "group:" ..group .. " nodename:".. name)
        end
    end
    return nodes
end
local function addGroupToNode(modname, nodename, groupname)

    if minetest.get_modpath(modname) then
        local node_def = minetest.registered_nodes[modname .. ":" .. nodename]

        if node_def then
            node_def.groups[groupname] = 1
            minetest.override_item(modname .. ":" .. nodename, { groups = node_def.groups })
			--*********Log info about groups node belongs to. COMMENT THIS OUT **********
			-- minetest.log("nodeinfo:", "nodeinfo:" .. nodename)
			-- for group, value in pairs(node_def.groups) do
			-- -- Log each item using minetest.log()
			-- minetest.log("groups:", "group: " .. group .. ", value: " .. value)
			-- end
			--*********************************************************  
        end

	end
end
addGroupToNode("wool","orange", "pumpkin")  --needed to make scarecrow head
if minetest.get_modpath("crops") then
    addGroupToNode("crops","pumpkin", "pumpkin")
    for i=1, 2 do
        addGroupToNode("crops", "corn_base_"..i, "crop")
    end


    for i=1, 3 do
        addGroupToNode("crops", "corn_top_"..i, "crop")
    end

    for i=1, 4 do
        addGroupToNode("crops", "potato_plant_"..i, "crop")    
    end

    for i=1, 5 do
        addGroupToNode("crops", "tomato_plant_"..i, "crop") 
        addGroupToNode("crops", "pumpkin_plant_"..i, "crop")
        addGroupToNode("crops", "melon_plant_"..i, "crop")
    end
    addGroupToNode("crops", "corn_base_seed", "crop")
    addGroupToNode("crops", "pumpkin_plant_5_attached", "crop")
    addGroupToNode("crops", "melon_plant_5_attached", "crop")
    addGroupToNode("crops", "pumpkin", "crop")
    addGroupToNode("crops", "melon", "crop")
end

    addGroupToNode("farming", "pumpkin_8", "pumpkin")

for i=1, 8 do
    addGroupToNode("farming", "wheat_"..i, "crop")
    addGroupToNode("farming", "barley_"..i, "crop")
    addGroupToNode("farming", "carrot_"..i, "crop")
    addGroupToNode("farming", "chili_"..i, "crop")
    addGroupToNode("farming", "corn_"..i, "crop") 
    addGroupToNode("farming", "melon_"..i, "crop")
    addGroupToNode("farming", "hemp_"..i, "crop")
    addGroupToNode("farming", "pineapple_"..i, "crop")
    addGroupToNode("farming", "pumpkin_"..i, "crop")
    addGroupToNode("farming", "oat_"..i, "crop")
    addGroupToNode("farming", "rice_"..i, "crop")
    addGroupToNode("farming", "rye_"..i, "crop")
    addGroupToNode("farming", "sunflower_"..i, "crop")
    addGroupToNode("farming", "tomato_"..i, "crop")
    addGroupToNode("farming", "vanilla_"..i, "crop")
end

for i=1, 7 do
    addGroupToNode("farming", "pepper_"..i, "crop")
    addGroupToNode("farming", "soy_"..i, "crop")
end

for i=1, 6 do
    addGroupToNode("farming", "cabbage_"..i, "crop")
end

for i=1, 5 do
    addGroupToNode("farming", "artichoke_"..i, "crop")
    addGroupToNode("farming", "asparagus_"..i, "crop")
    addGroupToNode("farming", "beanpole_"..i, "crop")
    addGroupToNode("farming", "beetroot_"..i, "crop")
    addGroupToNode("farming", "garlic_"..i, "crop")
    addGroupToNode("farming", "lettuce_"..i, "crop")    
    addGroupToNode("farming", "pea_"..i, "crop")
    addGroupToNode("farming", "onion_"..i, "crop")
end
for i=1, 4 do
    addGroupToNode("farming", "blackberry_"..i, "crop")
    addGroupToNode("farming", "blueberry_"..i, "crop")
    addGroupToNode("farming", "cucumber_"..i, "crop")
    addGroupToNode("farming", "eggplant_"..i, "crop")
    addGroupToNode("farming", "ginger_"..i, "crop")
    addGroupToNode("farming", "mint_"..i, "crop")
    addGroupToNode("farming", "raspberry_"..i, "crop")
    addGroupToNode("farming", "potato_"..i, "crop")
    addGroupToNode("farming", "rhubarb_"..i, "crop")
    addGroupToNode("farming", "spinach_"..i, "crop")
end
for i=1, 3 do
    addGroupToNode("farming", "parsley_"..i, "crop")
end 

if minetest.get_modpath("x_farming") then
    addGroupToNode("x_farming", "pumpkin_8", "pumpkin")
    for i=1, 8 do
        addGroupToNode("farming", "wheat_"..i, "crop")
        addGroupToNode("x_farming", "corn_"..i, "crop")
        addGroupToNode("x_farming", "melon_"..i, "crop")
        addGroupToNode("x_farming", "barley_"..i, "crop")
        addGroupToNode("x_farming", "carrot_"..i, "crop")
        addGroupToNode("x_farming", "coffee_"..i, "crop")
        addGroupToNode("x_farming", "pumpkin_"..i, "crop")
        addGroupToNode("x_farming", "soybean_"..i, "crop")
        addGroupToNode("x_farming", "beetroot_"..i, "crop")
        addGroupToNode("x_farming", "strawberry_"..i, "crop")
        addGroupToNode("x_farming", "stevia_"..i, "crop")
        addGroupToNode("x_farming", "potato_"..i, "crop")
        addGroupToNode("x_farming", "rice_"..i, "crop")
    end
    addGroupToNode("x_farming", "melon_fruit", "crop")
    addGroupToNode("x_farming", "corn"..9, "crop")
    addGroupToNode("x_farming", "corn"..10, "crop")
end


--getNodesByGroup("crop")
dofile(dpath .. "locust.lua")
dofile(dpath .. "rat.lua")
dofile(dpath .. "crow.lua")
dofile(dpath .. "rat_trap.lua")
dofile(dpath .. "crafting.lua")
dofile(dpath .. "nodes.lua")

