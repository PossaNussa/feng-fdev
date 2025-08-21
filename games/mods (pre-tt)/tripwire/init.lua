
-- Enregistrement du nœud "tripwire:felt"
minetest.register_node("tripwire:felt", {
    description = "Thread",
    tiles = {"tripwire_felt.png"}, -- Textures du nœud (Thread) 
    groups = {dig_immediate = 2, choppy = 3, meta_is_privatizable = 1}, -- Groupes du nœud
    drawtype = "nodebox", -- Type de dessin du nœud (boîte de collision)
    sunlight_propagates = true, -- La lumière traverse le nœud
    walkable = false, -- Le joueur ne peut pas marcher sur le nœud
    pointable = true, -- Le nœud peut être pointé
    drop = "tripwire:felt",
    node_box = { -- Boîte de collision    
        type = "fixed", -- Type de boîte de collision
        fixed = { -- Boîte de collision
            {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},  -- Boîte de collision
        },
    },
})

-- Enregistrement du nœud "tripwire:tripwire"
minetest.register_node("tripwire:tripwire", {
    description = "Tripwire",
    tiles = {"tripwire_tripwire.png"},
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(0.25)
    end,
    on_timer = function(pos, elapsed)
        mesecon.receptor_off(pos, mesecon.rules.alldirs)

        for _, dir in ipairs({"x", "y", "z"}) do
            for _, sign in ipairs({1, -1}) do
                local offset = {x = 0, y = 0, z = 0}
                offset[dir] = sign
                local p = vector.add(pos, offset)
                if minetest.get_node(p).name == "tripwire:felt" then
                    if is_felt(pos, offset) then
                        local connected_pos = find_connected_tripwire(pos, offset)
                        tripwire_on(pos, connected_pos)
                    end
                end
            end
        end
        minetest.get_node_timer(pos):start(0.25)
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- casse le block et le drop
        minetest.node_dig(pos, node, clicker)
        --drop le block
        minetest.add_item(pos, "tripwire:tripwire")
    end,
})

-- Fonction pour vérifier si un Tripwire est connecté à un autre via un ou plusieurs Thread
function is_felt(pos, dir)
    local node = minetest.get_node(pos)
    if node.name == "tripwire:tripwire" then
        pos = vector.add(pos, dir)
        local limit = 0
        while minetest.get_node(pos).name == "tripwire:felt" do
            pos = vector.add(pos, dir)
            limit = limit + 1
            if limit > 20 then
                return false
            end
        end
        return minetest.get_node(pos).name == "tripwire:tripwire"
    end
    return false
end

-- Fonction pour trouver le Tripwire connecté
function find_connected_tripwire(pos, dir)
    pos = vector.add(pos, dir)
    while minetest.get_node(pos).name == "tripwire:felt" do
        pos = vector.add(pos, dir)
    end
    return pos
end

-- Fonction pour remplacer un tripwire par un tripwire allumé avec la position du block connecté
function tripwire_on(pos, pos2)
    minetest.set_node(pos, {name = "tripwire:tripwire_on"})
    minetest.set_node(pos2, {name = "tripwire:tripwire_on"})
    local meta = minetest.get_meta(pos)
    meta:set_string("connected", minetest.write_json(pos2))
    meta = minetest.get_meta(pos2)
    meta:set_string("connected", minetest.write_json(pos))
end

-- Enregistrement du nœud "tripwire:tripwire_on"
minetest.register_node("tripwire:tripwire_on", {
    description = "Tripwire allumé",
    tiles = {"tripwire_tripwire_on.png"},
    groups = {not_in_creative_inventory = 1},
    drop = "tripwire:tripwire",
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("connected", minetest.write_json({x = 0, y = 0, z = 0}))
        minetest.get_node_timer(pos):start(0.25)
    end,
    on_timer = function(pos, elapsed)
        mesecon.receptor_off(pos, mesecon.rules.alldirs)
        local meta = minetest.get_meta(pos)
        local connected = minetest.parse_json(meta:get_string("connected"))
        
        if minetest.get_node(connected).name ~= "tripwire:tripwire_on" then
            minetest.set_node(pos, {name = "tripwire:tripwire"})
            mesecon.receptor_off(pos, mesecon.rules.alldirs)
        else
            detect_entities_and_activate(pos, connected)
        end
        minetest.get_node_timer(pos):start(0.25)
    end,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- casse le block et le drop
        minetest.node_dig(pos, node, clicker)
        --drop le block
        minetest.add_item(pos, "tripwire:tripwire")
    end,
})

-- Fonction pour détecter les entités et activer le récepteur
function detect_entities_and_activate(pos, connected)
    local distance = vector.distance(pos, connected)
    local objs = minetest.get_objects_inside_radius(pos, distance)
    for _, obj in ipairs(objs) do
        local obj_pos = obj:get_pos()
        if is_entity_between(pos, connected, obj_pos) then
            mesecon.receptor_on(pos, mesecon.rules.alldirs)
        end
    end
end

-- Fonction pour vérifier si une entité se trouve entre deux positions
function is_entity_between(pos1, pos2, entity_pos)
    local x_within = (math.min(pos1.x, pos2.x) - 0.5 <= entity_pos.x) and (entity_pos.x <= math.max(pos1.x, pos2.x) + 0.5)
    local y_within = (math.min(pos1.y, pos2.y) - 1.5 <= entity_pos.y) and (entity_pos.y <= math.max(pos1.y, pos2.y) + 0.5)
    local z_within = (math.min(pos1.z, pos2.z) - 0.5 <= entity_pos.z) and (entity_pos.z <= math.max(pos1.z, pos2.z) + 0.5)
    return x_within and y_within and z_within
end



--enregistrement de la recette du fil
minetest.register_craft({
    output = "tripwire:felt 12",
    recipe = {
        {"group:wool"},
        {"group:wool"},
        {"group:wool"},
    }
})

--craft inverser -- 4 felt en cube pour 1 laine
--minetest.register_craft({
--    --laine blanche
--    output = ""
--    recipe = {
--        {"tripwire:felt", "tripwire:felt"},
--        {"tripwire:felt", "tripwire:felt"},
--    }
--})

--enregistrement de la recette du tirpwire
minetest.register_craft({
    output = "tripwire:tripwire 2",
    -- du bois et du fil et de la redstone
    recipe = {
        {"group:wood", "tripwire:felt", "group:wood"},
        {"group:wood", "tripwire:felt", "group:wood"},
        {"group:wood", "tripwire:felt", "group:wood"},
    }
})

