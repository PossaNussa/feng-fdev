
-- meat_blocks (Minetest Game version, no why_init, no MCL APIs)
-- Features:
--  - Burnt variants for selected COOKED foods (list is configurable)
--  - Burnt items are 80% black and heal 0.5 hearts (1 HP)
--  - Cooked items can be cooked again -> burnt variants
--  - Auto-burn: cooked items sitting in furnace output ("dst") for 60s turn into burnt
--  - Meatballs (raw/cooked/burnt) included
--  - Meat blocks for several meats (raw/cooked/burnt) with crafting and cooking
--  - Compatible aliases for some MCL item names (no MCL dependency required)
--  - Optional integration with awards (if the 'awards' mod is installed)

local modname = minetest.get_current_modname()
local S = minetest.get_translator and minetest.get_translator(modname) or function(s) return s end

meat_blocks = rawget(_G, "meat_blocks") or {}
meat_blocks.burn_map = meat_blocks.burn_map or {}    -- cooked_itemstring -> burnt_itemstring
meat_blocks.burn_list = meat_blocks.burn_list or {}  -- list (array) of cooked itemstrings to auto-register burnt
meat_blocks.meat_defs = meat_blocks.meat_defs or {}  -- map of meat id -> {raw=..., cooked=...}

-- ==========================================================
-- Helpers
-- ==========================================================

local function titlecase(s)
  return (s:gsub("^%l", string.upper))
end

local BLACK_80 = 204 -- 0.8 * 255, for ^[colorize:#000000:ALPHA

local function recolor_80_black(img)
  img = img or ""
  -- If the source has no inventory image, we still return a modifier that won't crash.
  return img .. "^[colorize:#000000:" .. BLACK_80
end

local function item_exists(name)
  return minetest.registered_items[name] ~= nil
end

-- Safe description fallback
local function desc_or_item(name)
  local def = minetest.registered_items[name]
  if def and def.description and def.description ~= "" then
    return def.description
  end
  -- turn "mod:item" into "mod item"
  return name:gsub(":", " ")
end

-- Derive a stable node/item suffix from any itemstring (e.g., "mod:item" -> "mod_item")
local function id_suffix_from_itemstring(name)
  return (name:gsub(":", "_"):gsub("[^%w_]", "_"))
end

-- ==========================================================
-- Burnt item registration API
-- ==========================================================
-- Register a burnt variant for a COOKED item, recolorizing its inventory image
-- and setting on_use to heal 1 HP.
-- Returns the burnt itemstring.
function meat_blocks.register_burnt_for(cooked_item, def)
  if not item_exists(cooked_item) then
    minetest.log("warning", "[meat_blocks] Tried to register burnt for unknown item: " .. cooked_item)
    return nil
  end

  local suffix = id_suffix_from_itemstring(cooked_item)
  local burnt_item = (def and def.name) or ("meat_blocks:burnt_" .. suffix)

  if item_exists(burnt_item) then
    -- Already provided elsewhere
    meat_blocks.burn_map[cooked_item] = burnt_item
    return burnt_item
  end

  local base = minetest.registered_items[cooked_item]
  local img = base and base.inventory_image or ""
  local recolored = recolor_80_black(img)

  local desc_base = (def and def.description) or ("Burnt " .. desc_or_item(cooked_item))
  minetest.register_craftitem(burnt_item, {
    description   = desc_base,
    inventory_image = recolored,
    wield_image   = recolored,
    -- 0.5 hearts = 1 HP
    on_use        = minetest.item_eat(1),
    groups        = {food = 1, eatable = 1, burnt_meat = 1, not_in_creative_inventory = 0},
  })

  -- Allow furnace "re-cook" of cooked -> burnt
  minetest.register_craft({
    type = "cooking",
    output = burnt_item,
    recipe = cooked_item,
    cooktime = (def and def.cooktime) or 10,
  })

  meat_blocks.burn_map[cooked_item] = burnt_item
  return burnt_item
end

-- Convenience to bulk-register from meat_blocks.burn_list (array of cooked itemstrings)
local function register_all_burn_list()
  for _, cooked in ipairs(meat_blocks.burn_list) do
    meat_blocks.register_burnt_for(cooked)
  end
end

-- ==========================================================
-- Meatballs (always provided by this mod)
-- ==========================================================

minetest.register_craftitem("meat_blocks:meatball", {
  description     = S("Raw Meatball"),
  inventory_image = "meat_blocks_meatball.png",
  wield_image     = "meat_blocks_meatball.png",
  on_use          = minetest.item_eat(3), -- 1.5 hearts
  groups          = {food = 1, eatable = 3},
})

minetest.register_craftitem("meat_blocks:cooked_meatball", {
  description     = S("Cooked Meatball"),
  inventory_image = "meat_blocks_meatball_cooked.png",
  wield_image     = "meat_blocks_meatball_cooked.png",
  on_use          = minetest.item_eat(8), -- 4 hearts
  groups          = {food = 1, eatable = 8},
})

minetest.register_craft({
  type = "cooking",
  output = "meat_blocks:cooked_meatball",
  recipe = "meat_blocks:meatball",
  cooktime = 10,
})

-- Optionally, a simple shapeless craft to make meatballs from any 2 raw meats (comment out if unwanted)
 minetest.register_craft({
   type = "shapeless",
   output = "meat_blocks:meatball 2",
   recipe = {"group:food_meat_raw", "group:food_meat_raw"},
 })

-- Provide burnt for cooked meatball
local BURNT_MEATBALL = meat_blocks.register_burnt_for("meat_blocks:cooked_meatball", {name = "meat_blocks:burnt_meatball", description = S("Burnt Meatball")})

-- ==========================================================
-- Sausage (lightweight items so MCL aliases have something to point at)
-- ==========================================================
minetest.register_craftitem("meat_blocks:sausage", {
  description     = S("Raw Sausage"),
  inventory_image = "meat_blocks_sausage.png",
  wield_image     = "meat_blocks_sausage.png",
  on_use          = minetest.item_eat(3),
  groups          = {food = 1, eatable = 3},
})

minetest.register_craftitem("meat_blocks:cooked_sausage", {
  description     = S("Cooked Sausage"),
  inventory_image = "meat_blocks_sausage_cooked.png",
  wield_image     = "meat_blocks_sausage_cooked.png",
  on_use          = minetest.item_eat(6),
  groups          = {food = 1, eatable = 6},
})

minetest.register_craft({
  type = "cooking",
  output = "meat_blocks:cooked_sausage",
  recipe = "meat_blocks:sausage",
  cooktime = 8,
})

local BURNT_SAUSAGE = meat_blocks.register_burnt_for("meat_blocks:cooked_sausage", {name = "meat_blocks:burnt_sausage", description = S("Burnt Sausage")})

-- ==========================================================
-- Aliases (compatibility; harmless if those items exist elsewhere)
-- These help worlds/machines that reference MCL itemstrings still work here.
-- ==========================================================
minetest.register_alias("mcl_mobitems:meatball",         "meat_blocks:meatball")
minetest.register_alias("mcl_mobitems:cooked_meatball",  "meat_blocks:cooked_meatball")
minetest.register_alias("mcl_mobitems:sausage",          "meat_blocks:sausage")
minetest.register_alias("mcl_mobitems:cooked_sausage",   "meat_blocks:cooked_sausage")

-- If you want to keep some of your prior mappings, you can add more here, e.g.:
 minetest.register_alias("mcl_mobitems:rabbit_raw",   "animalworld:rabbit_raw")
 minetest.register_alias("mcl_mobitems:rabbit_cooked","animalworld:rabbit_cooked")
 minetest.register_alias("mcl_fishing:fish_raw",      "default:trout_item")
 minetest.register_alias("mcl_fishing:salmon_raw",    "zombies:salmon_raw")
 minetest.register_alias("mcl_fishing:fish_cooked",   "zombies:salmon_cooked")

-- ==========================================================
-- Configurable meats for blocks (raw/cooked/then burnt)
-- Fill this with whichever meats exist in your game. The mod
-- will only register blocks if both items exist.
-- ==========================================================
meat_blocks.meat_defs = {
  -- key = shown name on blocks/recipes
  meatball = { raw = "meat_blocks:meatball",           cooked = "meat_blocks:cooked_meatball" },
  sausage  = { raw = "meat_blocks:sausage",            cooked = "meat_blocks:cooked_sausage"  },

  -- Examples that rely on other mods; uncomment/adjust to your world:
   fish     = { raw = "default:trout_item",            cooked = "zombies:salmon_cooked" },
   speckfish = { raw = "default:fish_item",	       cooked = "zombies:salmon_cooked" },
   salmon   = { raw = "zombies:salmon_raw",            cooked = "zombies:salmon_cooked" },
   rabbit   = { raw = "animalworld:rabbit_raw",        cooked = "animalworld:rabbit_cooked" },
   chicken  = { raw = "animalia:poultry_raw",	       cooked = "animalia:poultry_cooked" },
   exotic   = { raw = "animalia:venison_raw",	       cooked = "animalia:venison_cooked" },
   beef	    = { raw = "animalia:beef_raw",	       cooked = "animalia:beef_cooked" },
   mutton   = { raw = "animalia:mutton_raw",		cooked = "animalia:mutton_cooked" },
   porkchop = { raw = "animalia:porkchop_raw",		cooked = "animalia:porkchop_cooked" },
-- in meat_blocks.meat_defs
   crocodile = { raw = "nssm:crocodile_tail", cooked = "nssm:roasted_crocodile_tail" },
}

-- Pre-fill burn_list from meats we know (their cooked variants)
meat_blocks.burn_list = {
  "meat_blocks:cooked_meatball",
  "meat_blocks:cooked_sausage",
  "zombies:fish_cooked",
  "zombies:salmon_cooked",
  "animalworld:rabbit_cooked",
  "animalia:beef_cooked",
  "animalia:mutton_cooked",
  "animalia:rat_cooked",
  "animalia:porkchop_cooked",
  "animalia:poultry_cooked",
  "animalia:venison_cooked",
  "worm_farm:cooked_animal",
  "zombies:clownfish_cooked",
  "default:bread",
  "x_farming:bread",
  "farming:bread",
  "moretrees:date_nut_cake",
  "nssm:roasted_crocodile_tail",
  -- Add additional cooked foods here, e.g. "animalworld:rabbit_cooked"
}

-- Register burnt items for all listed cooked foods
register_all_burn_list()

-- ==========================================================
-- Meat Blocks (raw/cooked/burnt) + recipes
-- ==========================================================
local function register_meat_blocks(meatkey, def)
  local raw_item    = def.raw
  local cooked_item = def.cooked
  if not (item_exists(raw_item) and item_exists(cooked_item)) then
    minetest.log("action", "[meat_blocks] Skipping meat '"..meatkey.."' (missing items): "..raw_item.." / "..cooked_item)
    return
  end

  -- Ensure there is a burnt item registered for this cooked item
  local burnt_item = meat_blocks.burn_map[cooked_item]
  if not burnt_item then
    burnt_item = meat_blocks.register_burnt_for(cooked_item)
  end

  local nice = titlecase(meatkey)

  -- ----------------------------------------------------------
  -- Texture overrides
  -- ----------------------------------------------------------
  local raw_tex   = "meat_blocks_meat_block_raw_"   .. meatkey .. ".png"
  local cooked_tex= "meat_blocks_meat_block_cooked_".. meatkey .. ".png"

  -- All fish use salmon block textures
  if meatkey == "fish" or meatkey == "speckfish" then
    raw_tex    = "meat_blocks_meat_block_raw_salmon.png"
    cooked_tex = "meat_blocks_meat_block_cooked_salmon.png"
  end

  -- Exotic uses porkchop block textures
  if meatkey == "exotic" then
    raw_tex    = "meat_blocks_meat_block_raw_porkchop.png"
    cooked_tex = "meat_blocks_meat_block_cooked_porkchop.png"
  end

  -- Crocodile uses meatball block textures, tinted green
  if meatkey == "crocodile" then
    -- 20% green raw, 10% green cooked (alpha 51 and 26 respectively)
    raw_tex    = "meat_blocks_meat_block_raw_meatball.png^[colorize:#00ff00:51"
    cooked_tex = "meat_blocks_meat_block_cooked_meatball.png^[colorize:#00ff00:26"
  end

  -- Raw Block
  local raw_block = "meat_blocks:raw_block_"..meatkey
  minetest.register_node(raw_block, {
    description = S("Raw @1 Block", nice),
    tiles = {raw_tex},
    groups = {choppy = 2, oddly_breakable_by_hand = 1, handy = 1, food = 1},
    on_use = minetest.item_eat(9), -- 4.5 hearts
    sounds = default and default.node_sound_defaults() or nil,
  })

  -- Cooked Block
  local cooked_block = "meat_blocks:cooked_block_"..meatkey
  minetest.register_node(cooked_block, {
    description = S("Cooked @1 Block", nice),
    tiles = {cooked_tex},
    groups = {choppy = 2, oddly_breakable_by_hand = 1, handy = 1, food = 1},
    on_use = minetest.item_eat(18), -- 9 hearts
    sounds = default and default.node_sound_defaults() or nil,
  })

  -- Burnt Block (generic burnt texture)
  local burnt_block = "meat_blocks:burnt_block_"..meatkey
  minetest.register_node(burnt_block, {
    description = S("Burnt @1 Block", nice),
    tiles = {"meat_blocks_meat_block_burnt.png"},
    groups = {choppy = 2, oddly_breakable_by_hand = 1, handy = 1, food = 1},
    on_use = minetest.item_eat(9), -- 4.5 hearts
    sounds = default and default.node_sound_defaults() or nil,
  })

  -- 9x raw -> raw block
  minetest.register_craft({
    output = raw_block,
    recipe = {
      {raw_item, raw_item, raw_item},
      {raw_item, raw_item, raw_item},
      {raw_item, raw_item, raw_item},
    }
  })
  -- raw block -> 9 raw (shapeless)
  minetest.register_craft({
    type = "shapeless",
    output = raw_item .. " 9",
    recipe = {raw_block},
  })

  -- 9x cooked -> cooked block
  minetest.register_craft({
    output = cooked_block,
    recipe = {
      {cooked_item, cooked_item, cooked_item},
      {cooked_item, cooked_item, cooked_item},
      {cooked_item, cooked_item, cooked_item},
    }
  })
  -- cooked block -> 9 cooked
  minetest.register_craft({
    type = "shapeless",
    output = cooked_item .. " 9",
    recipe = {cooked_block},
  })

  -- 9x burnt -> burnt block
  minetest.register_craft({
    output = burnt_block,
    recipe = {
      {burnt_item, burnt_item, burnt_item},
      {burnt_item, burnt_item, burnt_item},
      {burnt_item, burnt_item, burnt_item},
    }
  })
  -- burnt block -> 9 burnt
  minetest.register_craft({
    type = "shapeless",
    output = burnt_item .. " 9",
    recipe = {burnt_block},
  })

  -- Smelting steps
  minetest.register_craft({
    type = "cooking",
    output = cooked_block,
    recipe = raw_block,
    cooktime = 10,
  })
  minetest.register_craft({
    type = "cooking",
    output = burnt_block,
    recipe = cooked_block,
    cooktime = 10,
  })
end



-- ==========================================================
-- Auto-burn cooked items left in furnace output for 60 seconds
-- (Works for default:furnace and default:furnace_active)
-- ==========================================================

-- Replace the previous ABM with this version
local function is_burn_candidate(itemname)
  return meat_blocks.burn_map[itemname] ~= nil
end

minetest.register_abm({
  label = "meat_blocks furnace auto-burn",
  nodenames = {"default:kiln_active", "default:furnace_active"},
  interval = 5,
  chance = 1,
  action = function(pos, node)
    local meta = minetest.get_meta(pos)
    local inv = meta and meta:get_inventory()
    if not inv then return end

    local size = inv:get_size("dst") or 0
    if size <= 0 then return end

    for i = 1, size do
      local stack = inv:get_stack("dst", i)
      local key_name = "mb_dst_name_" .. i
      local key_ts   = "mb_dst_ts_" .. i

      if stack:is_empty() then
        -- Clear tracking when slot is empty
        meta:set_string(key_name, "")
        meta:set_int(key_ts, 0)
      else
        local name = stack:get_name()

        -- If this output isn't something we burn, stop tracking
        if not is_burn_candidate(name) then
          meta:set_string(key_name, "")
          meta:set_int(key_ts, 0)
        else
          local last_name = meta:get_string(key_name)
          if last_name ~= name or last_name == "" then
            -- New item appeared in output: start timer (ignore count changes)
            meta:set_string(key_name, name)
            meta:set_int(key_ts, os.time())
          else
            -- Same item name; check age
            local ts = meta:get_int(key_ts)
            if ts ~= 0 and (os.time() - ts) >= 30 then
              local burnt = meat_blocks.burn_map[name]
              if burnt and minetest.registered_items[burnt] then
                inv:set_stack("dst", i, ItemStack(burnt .. " " .. stack:get_count()))
                -- Clear tracking (burnt items are not further candidates)
                meta:set_string(key_name, "")
                meta:set_int(key_ts, 0)
              end
            end
          end
        end
      end
    end
  end
})

minetest.register_alias("lottmobs:meat", "animalia:venison_cooked")
minetest.register_alias("lottmobs:meat_raw", "animalia:venison_raw")
local overrides = {
	-- ["itemname"] = stack_max,
	["default:trout_item"] = 4,
	["default:fish_item"] = 8,
	["zombies:salmon_raw"] = 4,
	["zombies:salmon_cooked"] = 5,
	["animalworld:rabbit_raw"] = 4,
	["animalworld:rabbit_cooked"] = 4,
	["animalia:venison_raw"] = 8,
	["animalia:poultry_raw"] = 8,
	["animalia:beef_raw"] = 12,
	["animalia:venison_cooked"] = 8,
	["animalia:poultry_cooked"] = 8,
	["animalia:beef_cooked"] = 12,
	["animalia:mutton_raw"] = 6,
	["animalia:rat_raw"] = 12,
	["animalia:porkchop_raw"] = 8,
	["animalia:mutton_cooked"] = 6,
	["animalia:rat_cooked"] = 12,
	["animalia:porkchop_cooked"] = 8,
	["nssm:crocodile_tail"] = 6,
	["nssm:roasted_crocodile_tail"] = 6,
	["zombies:clownfish"] = 16,
	["zombies:clownfish_cooked"] = 16,
	["farming:bread"] = 32,
	["x_farming:bread"] = 32, 
	["default:ironbar"] = 9,
	["default:cobaltbar"] = 9,
	["deault:steelbar"] = 9,
	["deault:chromebar"] = 9,
	["deault:fgoldbar"] = 9,
	["deault:nickelbar"] = 9,
	["deault:platinumbar"] = 9,
	["deault:silverbar"] = 9,
	["deault:titaniumbar"] = 9,
	["deault:zbar"] = 9,
	
	-- Example: ["mcl_core:iron_ingot"] = 64
}

local function apply_stack_size(itemname, size)
	if not minetest.registered_items[itemname] then
		minetest.log("warning", "[stack_size_tweaks] Item not registered, cannot override: " .. itemname)
		return
	end
	minetest.override_item(itemname, { stack_max = size })
end

local function run()
	-- Apply explicit overrides
	for item, size in pairs(overrides) do
		apply_stack_size(item, size)
	end

	-- Apply default ingot rule
	for itemname, def in pairs(minetest.registered_items) do
		if itemname:find("ingot", 1, true) and overrides[itemname] == nil then
			if def and def.stack_max ~= 9 then
				apply_stack_size(itemname, 9)
			end
		end
	end

	minetest.log("action", "[stack_size_tweaks] Stack size tweaks applied.")
end

-- ==========================================================
-- Notes for server owners / modders:
-- 1) Add more cooked foods to burn by inserting itemstrings into meat_blocks.burn_list
--    or call meat_blocks.register_burnt_for(\"mod:cooked_food\").
-- 2) Add more meats for block support by extending meat_blocks.meat_defs with {raw=..., cooked=...}.
-- 3) Textures expected (fall back to unknown if missing):
--      - meat_blocks_meat_block_raw_<meat>.png
--      - meat_blocks_meat_block_cooked_<meat>.png
--      - meat_blocks_meat_block_burnt.png
--      - meat_blocks_meatball.png, meat_blocks_meatball_cooked.png
--      - meat_blocks_sausage.png, meat_blocks_sausage_cooked.png
-- 4) No MCL calls, no why_init. Pure Minetest Game APIs.
-- ==========================================================
