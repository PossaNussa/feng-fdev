-- Texture colorize tints applied on top of each mod's cooked textures.
-- Using the cooked texture as a base keeps the silhouette recognisable while
-- giving everything a unified dark reddish-brown "jerky" appearance.
local MEAT_TINT     = "^[colorize:#5C2800:160"  -- dark reddish-brown (jerky)
local FISH_TINT     = "^[colorize:#4A3010:150"  -- dark amber-brown
local LEATHER_TINT  = "^[colorize:#7B4010:190"  -- warm brown (cured hide)
local FRUIT_TINT    = "^[colorize:#5A3010:110"  -- warm shrivelled brown
local MUSHROOM_TINT = "^[colorize:#3A2408:130"  -- deep shrivelled earth-brown

local BASE = drying_rack.BASE_DRYING_TIME

-- -----------------------------------------------------------------------
-- Dried-food HP.
--
-- Every dried food heals 1.5x its raw ingredient (rounded, min 1). Drying is a
-- preservation method, not a cooking upgrade: it makes the raw item shelf-stable
-- and a little more nourishing, while cooking remains the way to a big HP meal.
-- The raw heal is read from default.get_food_heal() (see default/init.lua), which
-- records the value passed to minetest.item_eat at registration time. Falls back
-- to FALLBACK_RAW for the rare food registered via a custom on_use.
-- -----------------------------------------------------------------------
local FALLBACK_RAW = 2

local function raw_heal(input)
    local h = default and default.get_food_heal and default.get_food_heal(input)
    return h or FALLBACK_RAW
end

local function dried_heal(input)
    return math.max(1, math.floor(raw_heal(input) * 1.5 + 0.5))
end

-- Best-effort texture for an item, used to derive a dried texture when a recipe
-- doesn't spell one out (handles craftitems and nodes).
local function item_texture(def)
    if not def then return nil end
    if def.inventory_image and def.inventory_image ~= "" then return def.inventory_image end
    if def.wield_image and def.wield_image ~= "" then return def.wield_image end
    local tiles = def.tiles or def.tile_images
    if type(tiles) == "table" and tiles[1] then
        if type(tiles[1]) == "string" then return tiles[1] end
        if type(tiles[1]) == "table" and tiles[1].name then return tiles[1].name end
    end
    return nil
end

local MEAT_GROUPS     = {food = 2, meat = 1, food_meat = 1, flammable = 2}
local FRUIT_GROUPS    = {food = 2, food_dried_fruit = 1, flammable = 2}
local MUSHROOM_GROUPS = {food = 2, food_mushroom = 1, flammable = 2}

-- kind -> (groups, tint). Anything unlisted (incl. nil) is treated as meat.
local KIND_GROUPS = {fruit = FRUIT_GROUPS, mushroom = MUSHROOM_GROUPS}
local KIND_TINT   = {fruit = FRUIT_TINT,   mushroom = MUSHROOM_TINT}

-- -----------------------------------------------------------------------
-- Register a dried food item and record its drying-rack recipe.
--
-- def fields:
--   source_mod (string|nil) – optional_depends gate; nil = always register
--   input      (string)     – item that goes into the rack
--   name       (string)     – suffix for "drying_rack:<name>"
--   desc       (string)     – human-readable description
--   texture    (string|nil) – inventory_image; derived from the input if omitted
--   kind       (string|nil) – "fruit"/"mushroom" use their groups; else meat
--   time       (int|nil)    – override drying time in seconds
-- -----------------------------------------------------------------------
local function register_dried(def)
    if def.source_mod and not minetest.get_modpath(def.source_mod) then return end

    local fullname = "drying_rack:" .. def.name
    local groups   = KIND_GROUPS[def.kind] or MEAT_GROUPS
    local tint     = KIND_TINT[def.kind]   or MEAT_TINT

    local texture = def.texture
    if not texture then
        local base = item_texture(minetest.registered_items[def.input])
        texture = base and (base .. tint) or "unknown_item.png"
    end

    minetest.register_craftitem(fullname, {
        description     = def.desc,
        inventory_image = texture,
        wield_image     = texture,
        on_use          = minetest.item_eat(dried_heal(def.input)),
        groups          = table.copy(groups),
    })

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
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:mutton_raw",
    name    = "dried_mutton",
    desc    = "Dried Mutton",
    texture = "animalia_mutton_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:rat_raw",
    name    = "dried_rat",
    desc    = "Dried Rat",
    texture = "animalia_rat_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:porkchop_raw",
    name    = "dried_porkchop",
    desc    = "Dried Porkchop",
    texture = "animalia_porkchop_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:poultry_raw",
    name    = "dried_poultry",
    desc    = "Dried Poultry",
    texture = "animalia_poultry_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalia",
    input   = "animalia:venison_raw",
    name    = "dried_venison",
    desc    = "Dried Venison",
    texture = "animalia_venison_cooked.png" .. MEAT_TINT,
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
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:rawmollusk",
    name    = "dried_mollusk",
    desc    = "Dried Mollusk",
    texture = "animalworld_cookedmollusk.png" .. FISH_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:whalemeat_raw",
    name    = "dried_whalemeat",
    desc    = "Dried Whale Meat",
    texture = "animalworld_whalemeat_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:rabbit_raw",
    name    = "dried_rabbit",
    desc    = "Dried Rabbit",
    texture = "animalworld_rabbit_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:pork_raw",
    name    = "dried_boar_pork",
    desc    = "Dried Boar Pork",
    texture = "animalworld_pork_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:chicken_raw",
    name    = "dried_birdmeat",
    desc    = "Dried Birdmeat",
    texture = "animalworld_chicken_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:raw_athropod",
    name    = "dried_arthropod",
    desc    = "Dried Arthropod",
    texture = "animalworld_cooked_athropod.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "animalworld",
    input   = "animalworld:anteggs_raw",
    name    = "dried_anteggs",
    desc    = "Dried Ant Eggs",
    texture = "animalworld_anteggs_cooked.png" .. MEAT_TINT,
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
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:mutton_raw",
    name    = "dried_mobs_mutton",
    desc    = "Dried Mutton",
    texture = "mobs_mutton_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:pork_raw",
    name    = "dried_mobs_pork",
    desc    = "Dried Pork",
    texture = "mobs_pork_cooked.png" .. MEAT_TINT,
})
register_dried({
    source_mod = "mobs_animal",
    input   = "mobs:rabbit_raw",
    name    = "dried_mobs_rabbit",
    desc    = "Dried Rabbit",
    texture = "mobs_rabbit_cooked.png" .. MEAT_TINT,
})

-- ======================================================================
-- ZOMBIES — salmon & clownfish (rotten flesh → leather handled below)
-- ======================================================================
register_dried({
    source_mod = "zombies",
    input   = "zombies:salmon_raw",
    name    = "dried_salmon",
    desc    = "Dried Salmon",
    texture = "mcl_fishing_salmon_cooked.png" .. FISH_TINT,
})
register_dried({
    source_mod = "zombies",
    input   = "zombies:clownfish_raw",
    name    = "dried_clownfish",
    desc    = "Dried Clownfish",
    texture = "mcl_fishing_clownfish_raw.png" .. FISH_TINT,
})

-- ======================================================================
-- DEFAULT FISH (mud.lua — always present)
-- ======================================================================
register_dried({
    input   = "default:fish_item",
    name    = "dried_speckfish",
    desc    = "Dried Speckfish",
    texture = "fish.png" .. FISH_TINT,
})
register_dried({
    input   = "default:trout_item",
    name    = "dried_cod",
    desc    = "Dried Cod",
    texture = "trout.png" .. FISH_TINT,
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
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_flying_fish",
    name    = "dried_flying_fish",
    desc    = "Dried Flying Fish",
    texture = "fish_flying_fish_cooked.png" .. FISH_TINT,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_frog",
    name    = "dried_frog_legs",
    desc    = "Dried Frog Legs",
    texture = "fish_frog_cooked.png" .. FISH_TINT,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_anglerfish",
    name    = "dried_anglerfish",
    desc    = "Dried Anglerfish",
    texture = "fish_anglerfish_cooked.png" .. FISH_TINT,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_nautilus",
    name    = "dried_nautilus",
    desc    = "Dried Nautilus",
    texture = "fish_nautilus_cooked.png" .. FISH_TINT,
})
register_dried({
    source_mod = "fishing_rod",
    input   = "fishing_rod:fish_lava_eel",
    name    = "dried_lava_eel",
    desc    = "Dried Lava Eel",
    texture = "fish_lava_eel_cooked.png" .. FISH_TINT,
})

-- ======================================================================
-- WORM_FARM — worms dry into a preserved snack / trail ration
-- ======================================================================
register_dried({
    source_mod = "worm_farm",
    input   = "worm_farm:worm",
    name    = "dried_worm",
    desc    = "Dried Worm",
    -- texture derived from the worm image + jerky tint
})

-- ======================================================================
-- NATURALBIOMES — wild berries, fruit and nuts.
-- These carry no food_* fruit group, so the auto fruit scan below can't see
-- them; list them explicitly. Textures are derived from each item's own image
-- with the shrivel tint.
-- ======================================================================
for _, nb in ipairs({
    {input = "naturalbiomes:cowberry",      name = "dried_cowberry",   desc = "Dried Cowberries"},
    {input = "naturalbiomes:blackberry",    name = "dried_blackberry", desc = "Dried Blackberries"},
    {input = "naturalbiomes:banana",        name = "dried_banana",     desc = "Dried Banana"},
    {input = "naturalbiomes:coconut_slice", name = "dried_coconut",    desc = "Dried Coconut"},
    {input = "naturalbiomes:olives",        name = "dried_olives",     desc = "Dried Olives"},
    {input = "naturalbiomes:hazelnut",      name = "dried_hazelnut",   desc = "Dried Hazelnuts"},
}) do
    register_dried({
        source_mod = "naturalbiomes",
        input   = nb.input,
        name    = nb.name,
        desc    = nb.desc,
        kind    = "fruit",
    })
end

-- ======================================================================
-- FLOWERS — the edible brown mushroom dries into a preserved cap. The red
-- mushroom is poisonous (item_eat(-5)), so only the brown one goes on the rack.
-- ======================================================================
register_dried({
    source_mod = "flowers",
    input   = "flowers:mushroom_brown",
    name    = "dried_mushroom",
    desc    = "Dried Mushroom",
    kind    = "mushroom",
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

-- ======================================================================
-- HIDES & LEATHER → CURED LEATHER
--
-- The drying rack is the first stage of leatherworking: hang a raw hide (any
-- item in group leather or pelt — animalia leather, petz furs/hides, mobs
-- leather, …) and it slowly dries into *cured* leather. The tanning_rack then
-- takes that cured leather and works it into finished tanned leather, which the
-- rewritten crafting recipes require. When tanning_rack is absent, cured leather
-- is simply a stand-alone preserved hide. The `cured_leather` group is how the
-- tanning rack recognises its one valid input without a hard mod reference.
-- ======================================================================
minetest.register_craftitem("drying_rack:cured_leather", {
    description     = "Cured Leather",
    inventory_image = "mobs_leather.png" .. LEATHER_TINT,
    wield_image     = "mobs_leather.png" .. LEATHER_TINT,
    groups          = {leather = 1, flammable = 1, cured_leather = 1},
})

local LEATHER_OUT  = "drying_rack:cured_leather"
local LEATHER_TIME = BASE * 1.5  -- curing a hide takes a while

-- Zombie rotten flesh cures into leather rather than food.
if minetest.get_modpath("zombies") then
    drying_rack.recipes["zombies:rotten_flesh"] = {output = LEATHER_OUT, time = LEATHER_TIME}
end

do
    local leather_inputs = {}
    for name, def in pairs(minetest.registered_items) do
        if name ~= ""
           and name:sub(1, 12) ~= "drying_rack:"
           and name:sub(1, 13) ~= "tanning_rack:"
           and drying_rack.recipes[name] == nil then
            local g = def.groups or {}
            if (g.leather or 0) > 0 or (g.pelt or 0) > 0 then
                leather_inputs[#leather_inputs + 1] = name
            end
        end
    end
    for _, name in ipairs(leather_inputs) do
        drying_rack.recipes[name] = {output = LEATHER_OUT, time = LEATHER_TIME}
    end
end

-- ======================================================================
-- FRUIT → DRIED FRUIT (auto-generated)
--
-- Any edible item carrying a recognised fruit group becomes dryable. We reuse
-- the fruit's own inventory image with a shrivel tint so each dried fruit stays
-- recognisable, and generate a "drying_rack:dried_<item>" craftitem for it. This
-- covers apples and every fruit from any installed farming mod without a
-- hand-written list. Runs at load time, so fruit-providing mods must load first
-- (see optional_depends in mod.conf); a fruit from a mod that loads later just
-- isn't dryable, with no error. Dried fruit heals 1.5x the fresh fruit.
-- ======================================================================
local FRUIT_GROUP_SET = {}
for _, g in ipairs({
    "food_apple", "food_banana", "food_orange", "food_lemon", "food_lime",
    "food_cherry", "food_cherries", "food_grape", "food_grapes",
    "food_berry", "food_berries", "food_blueberry", "food_blueberries",
    "food_strawberry", "food_strawberries", "food_raspberry", "food_raspberries",
    "food_blackberry", "food_blackberries", "food_currant", "food_gooseberry",
    "food_pineapple", "food_coconut", "food_melon", "food_watermelon",
    "food_peach", "food_pear", "food_plum", "food_apricot", "food_fig",
    "food_date", "food_kiwi", "food_mango", "food_papaya", "food_guava",
    "food_pomegranate", "food_persimmon", "food_fruit",
}) do
    FRUIT_GROUP_SET[g] = true
end

local function is_fruit(def)
    if not def.on_use then return false end  -- must be eatable (item_eat installs on_use)
    local g = def.groups
    if not g then return false end
    for name, v in pairs(g) do
        if v and v ~= 0 and FRUIT_GROUP_SET[name] then return true end
    end
    return false
end

-- Collect first — registering new items while iterating registered_items is unsafe.
local fruit_inputs = {}
for name, def in pairs(minetest.registered_items) do
    if name ~= "" and name:sub(1, 12) ~= "drying_rack:"
       and drying_rack.recipes[name] == nil and is_fruit(def) then
        local tex = item_texture(def)
        if tex then
            fruit_inputs[#fruit_inputs + 1] = {name = name, def = def, tex = tex}
        end
    end
end

for _, f in ipairs(fruit_inputs) do
    local out  = "drying_rack:dried_" .. f.name:gsub("[^%w]", "_")
    -- description may be a translated / multi-line string; keep the first line
    local desc = tostring(f.def.description or f.name):match("^[^\n]*") or f.name
    minetest.register_craftitem(out, {
        description     = "Dried " .. desc,
        inventory_image = f.tex .. FRUIT_TINT,
        wield_image     = f.tex .. FRUIT_TINT,
        on_use          = minetest.item_eat(dried_heal(f.name)),
        groups          = {food = 2, food_dried_fruit = 1, flammable = 2},
    })
    drying_rack.recipes[f.name] = {output = out, time = BASE}
end
