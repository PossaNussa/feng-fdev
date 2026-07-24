-- Texture colorize tints applied on top of each mod's cooked textures.
-- Using the cooked texture as a base keeps the silhouette recognisable while
-- giving everything a unified dark reddish-brown "jerky" appearance.
local MEAT_TINT    = "^[colorize:#5C2800:160"  -- dark reddish-brown (jerky)
local FISH_TINT    = "^[colorize:#4A3010:150"  -- dark amber-brown
local LEATHER_TINT = "^[colorize:#7B4010:190"  -- warm brown (cured hide)

local BASE = drying_rack.BASE_DRYING_TIME

-- -----------------------------------------------------------------------
-- Helper: register a dried item and record its recipe entry.
--
-- def fields:
--   source_mod  (string|nil) – optional_depends gate; nil = always register
--   input       (string)     – item that goes into the rack
--   name        (string)     – suffix for "drying_rack:<name>"
--   desc        (string)     – human-readable description
--   texture     (string)     – inventory_image (may include modifiers)
--   heal        (int)        – HP restored on eat (omit for is_leather items)
--   is_leather  (bool)       – register as a craft material, not food
--   time        (int)        – override drying time in seconds
-- -----------------------------------------------------------------------
local function register_dried(def)
    if def.source_mod and not minetest.get_modpath(def.source_mod) then return end

    local fullname = "drying_rack:" .. def.name

    if def.is_leather then
        minetest.register_craftitem(fullname, {
            description   = def.desc,
            inventory_image = def.texture,
            wield_image   = def.texture,
            groups        = {leather = 1, flammable = 1},
        })
    else
        minetest.register_craftitem(fullname, {
            description   = def.desc,
            inventory_image = def.texture,
            wield_image   = def.texture,
            on_use        = minetest.item_eat(def.heal),
            groups        = {food = 2, meat = 1, food_meat = 1, flammable = 2},
        })
    end

    drying_rack.recipes[def.input] = {
        output = fullname,
        time   = def.time or BASE,
    }
end

-- ======================================================================
-- DRYING RACK (craft recipe)
-- ======================================================================
minetest.register_craft({
    output = "drying_rack:drying_rack",
    recipe = {
        {"default:stick", "default:stick", "default:stick"},
        {"default:stick", "",              "default:stick"},
        {"",              "",              ""},
    },
})

-- ======================================================================
-- ANIMALIA
-- ======================================================================
register_dried({
    source_mod = "animalia",
    input   = "animalia:beef_raw",
    name    = "dried_beef",
    desc    = "Dried Beef",
    texture = "animalia_beef_cooked.png" .. MEAT_TINT,
    heal    = 10,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:mutton_raw",
    name    = "dried_mutton",
    desc    = "Dried Mutton",
    texture = "animalia_mutton_cooked.png" .. MEAT_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:rat_raw",
    name    = "dried_rat",
    desc    = "Dried Rat",
    texture = "animalia_rat_cooked.png" .. MEAT_TINT,
    heal    = 3,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:porkchop_raw",
    name    = "dried_porkchop",
    desc    = "Dried Porkchop",
    texture = "animalia_porkchop_cooked.png" .. MEAT_TINT,
    heal    = 9,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:poultry_raw",
    name    = "dried_poultry",
    desc    = "Dried Poultry",
    texture = "animalia_poultry_cooked.png" .. MEAT_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:venison_raw",
    name    = "dried_venison",
    desc    = "Dried Venison",
    texture = "animalia_venison_cooked.png" .. MEAT_TINT,
    heal    = 12,
})

-- ======================================================================
-- ANIMALWORLD
-- ======================================================================
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:rawfish",
    name    = "dried_carp",
    desc    = "Dried Carp",
    texture = "animalworld_cookedfish.png" .. FISH_TINT,
    heal    = 6,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:rawmollusk",
    name    = "dried_mollusk",
    desc    = "Dried Mollusk",
    texture = "animalworld_cookedmollusk.png" .. FISH_TINT,
    heal    = 6,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:whalemeat_raw",
    name    = "dried_whalemeat",
    desc    = "Dried Whale Meat",
    texture = "animalworld_whalemeat_cooked.png" .. MEAT_TINT,
    heal    = 12,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:rabbit_raw",
    name    = "dried_rabbit",
    desc    = "Dried Rabbit",
    texture = "animalworld_rabbit_cooked.png" .. MEAT_TINT,
    heal    = 6,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:pork_raw",
    name    = "dried_boar_pork",
    desc    = "Dried Boar Pork",
    texture = "animalworld_pork_cooked.png" .. MEAT_TINT,
    heal    = 9,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:chicken_raw",
    name    = "dried_birdmeat",
    desc    = "Dried Birdmeat",
    texture = "animalworld_chicken_cooked.png" .. MEAT_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:raw_athropod",
    name    = "dried_arthropod",
    desc    = "Dried Arthropod",
    texture = "animalworld_cooked_athropod.png" .. MEAT_TINT,
    heal    = 4,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:anteggs_raw",
    name    = "dried_anteggs",
    desc    = "Dried Ant Eggs",
    texture = "animalworld_anteggs_cooked.png" .. MEAT_TINT,
    heal    = 4,
})

-- ======================================================================
-- MOBS (base mobs_redo)
-- ======================================================================
register_dried({
    source_mod = "mobs",
    input   = "mobs:meat_raw",
    name    = "dried_meat",
    desc    = "Dried Meat",
    texture = "mobs_meat.png" .. MEAT_TINT,
    heal    = 10,
})

-- ======================================================================
-- MOBS_ANIMAL
-- ======================================================================
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:chicken_raw",
    name    = "dried_mobs_chicken",
    desc    = "Dried Chicken",
    texture = "mobs_chicken_cooked.png" .. MEAT_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:mutton_raw",
    name    = "dried_mobs_mutton",
    desc    = "Dried Mutton",
    texture = "mobs_mutton_cooked.png" .. MEAT_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:pork_raw",
    name    = "dried_mobs_pork",
    desc    = "Dried Pork",
    texture = "mobs_pork_cooked.png" .. MEAT_TINT,
    heal    = 9,
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:rabbit_raw",
    name    = "dried_mobs_rabbit",
    desc    = "Dried Rabbit",
    texture = "mobs_rabbit_cooked.png" .. MEAT_TINT,
    heal    = 7,
})

-- ======================================================================
-- ZOMBIES — rotten flesh → leather; salmon; clownfish
-- ======================================================================
-- Zombie flesh cures into leather (not food).
register_dried({
    source_mod  = "zombies",
    input       = "zombies:rotten_flesh",
    name        = "cured_leather",
    desc        = "Cured Leather",
    texture     = "mobs_leather.png" .. LEATHER_TINT,
    is_leather  = true,
})
register_dried({
    source_mod = "zombies",
    input   = "zombies:salmon_raw",
    name    = "dried_salmon",
    desc    = "Dried Salmon",
    texture = "mcl_fishing_salmon_cooked.png" .. FISH_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "zombies",
    input   = "zombies:clownfish_raw",
    name    = "dried_clownfish",
    desc    = "Dried Clownfish",
    texture = "mcl_fishing_clownfish_raw.png" .. FISH_TINT,
    heal    = 3,
})

-- ======================================================================
-- DEFAULT FISH (mud.lua — always present)
-- ======================================================================
register_dried({
    input   = "default:fish_item",
    name    = "dried_speckfish",
    desc    = "Dried Speckfish",
    texture = "fish.png" .. FISH_TINT,
    heal    = 4,
})
register_dried({
    input   = "default:trout_item",
    name    = "dried_cod",
    desc    = "Dried Cod",
    texture = "trout.png" .. FISH_TINT,
    heal    = 4,
})

-- ======================================================================
-- FISHING_ROD
-- ======================================================================
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_shrimp",
    name    = "dried_shrimp",
    desc    = "Dried Shrimp",
    texture = "fish_shrimp_cooked.png" .. FISH_TINT,
    heal    = 5,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_flying_fish",
    name    = "dried_flying_fish",
    desc    = "Dried Flying Fish",
    texture = "fish_flying_fish_cooked.png" .. FISH_TINT,
    heal    = 5,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_frog",
    name    = "dried_frog_legs",
    desc    = "Dried Frog Legs",
    texture = "fish_frog_cooked.png" .. FISH_TINT,
    heal    = 5,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_anglerfish",
    name    = "dried_anglerfish",
    desc    = "Dried Anglerfish",
    texture = "fish_anglerfish_cooked.png" .. FISH_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_nautilus",
    name    = "dried_nautilus",
    desc    = "Dried Nautilus",
    texture = "fish_nautilus_cooked.png" .. FISH_TINT,
    heal    = 8,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_lava_eel",
    name    = "dried_lava_eel",
    desc    = "Dried Lava Eel",
    texture = "fish_lava_eel_cooked.png" .. FISH_TINT,
    heal    = 10,
})

-- ======================================================================
-- DEFAULT — tilding dries into a mud brick
-- ======================================================================
drying_rack.recipes["default:tilding"] = {
    output = "default:mud_brick_item",
    time   = BASE,
}

-- ======================================================================
-- HARDCORE_FARMING — dried locust
-- ======================================================================
if minetest.get_modpath("hardcore_farming") then
    drying_rack.recipes["hardcore_farming:locust"] = {
        output = "hardcore_farming:locust_roasted",
        time   = BASE / 2,
    }
end
