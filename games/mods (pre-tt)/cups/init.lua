local S = minetest.get_translator("cups")
local has_default = minetest.get_modpath("default") ~= nil
local has_moreores = minetest.get_modpath("moreores") ~= nil
local cups = {}

local cupnodebox = {
	type = "fixed",
	fixed = {
	{-0.3*0.8,-0.6*0.8,-0.3*0.8,0.3*0.8,-0.5*0.8,0.3*0.8}, -- stand
	{-0.1*0.8,-0.5*0.8,-0.1*0.8,0.1*0.8,-0.1*0.8,0.1*0.8}, -- handle
	{-0.3*0.8,-0.1*0.8,-0.3*0.8,0.3*0.8,0.0*0.8,0.3*0.8}, -- cup (lower part)
	-- the 4 sides of the upper part
	{-0.2*0.8,-0.1*0.8,-0.3*0.8,0.2*0.8,0.4*0.8,-0.2*0.8},
	{-0.2*0.8,-0.1*0.8,0.2*0.8,0.2*0.8,0.4*0.8,0.3*0.8},
	{-0.3*0.8,-0.1*0.8,-0.3*0.8,-0.2*0.8,0.4*0.8,0.3*0.8},
	{0.2*0.8,-0.1*0.8,-0.3*0.8,0.3*0.8,0.4*0.8,0.3*0.8},
	}
}

local cupselbox = {
	type = "fixed",
	fixed = {
	{-0.3*0.8,-0.6*0.8,-0.3*0.8,0.3*0.8,-0.5*0.8,0.3*0.8}, -- stand
	{-0.1*0.8,-0.5*0.8,-0.1*0.8,0.1*0.8,-0.1*0.8,0.1*0.8}, -- handle
	{-0.3*0.8,-0.1*0.8,-0.3*0.8,0.3*0.8,0.4*0.8,0.3*0.8}, -- upper part
	}
}

-- API
cups.register_cup = function(subname, description, tiles, craftitem, craft_count, extra_groups, extra_sounds)
	local groups = { dig_immediate=3, falling_node=1, }
	if extra_groups then
		for k,v in pairs(extra_groups) do
			groups[k] = v
		end
	end
	local sounds
	if has_default then
		if default.node_sound_metal_defaults then
			sounds = default.node_sound_defaults({
				footstep = { name = "default_metal_footstep", gain = 0.3 },
			})
		else
			sounds = default.node_sound_defaults({
				footstep = { name = "default_hard_footstep", gain = 0.3 },
			})
		end
	end
	if extra_sounds then
		for k,v in pairs(extra_sounds) do
			sounds[k] = v
		end
	end
	local itemstring = "cups:cup_"..subname
	minetest.register_node(itemstring, {
		description = description,
		_doc_items_longdesc = S("A decorative item which can be placed."),
		tiles = tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = cupnodebox,
		is_ground_content = false,
		selection_box = cupselbox,
		groups = groups,
		sounds = sounds,
	})

	if craftitem ~= nil then
		if craft_count == nil then craft_count = 1 end

		if has_default then
			minetest.register_craft({
				output = "cups:cup_"..subname.." "..craft_count,
				recipe = {
					{craftitem, "", craftitem},
					{"", craftitem, ""},
					{"", craftitem, ""},
				}
			})
		end
	end
end

-- Register cups
local sound_hard
if has_default then
	sound_hard = default.node_sound_defaults({ footstep = { name = "default_hard_footstep", gain = 0.3 }})
end
cups.register_cup("bronze", S("Bronze Chalice"), { "cups_bronze.png" }, "default:bronze_ingot", 2)
cups.register_cup("gold", S("Golden Chalice"), { "cups_gold.png" }, "default:gold_ingot", 2)
cups.register_cup("diamond", S("Diamond Chalice"), { "cups_diamond.png" }, "default:diamond", 1, nil, sound_hard)
	cups.register_cup("silver", S("Silver Chalice"), { "cups_silver.png" }, "default:silverbar", 2)
	cups.register_cup("tin", S("Tin Cup"), { "default_tin_block.png" }, "default:tin_ingot", 2)
	cups.register_cup("brass", S("Brass Chalice"), { "basic_materials_brass_block.png" }, "basic_materials:brass_ingot", 2)
cups.register_cup("nickel", S("Nickel Cup"), {"nickelblock.png"}, "default:nickelbar")
cups.register_cup("fgold", S("Suspicious Golden Cup"), {"fgoldblock.png"}, "default:fgoldbar")
cups.register_cup("chrome", S("Chrome Cup"), {"chromeblock.png"}, "default:chromiumbar")
cups.register_cup("csteel", S("Cobalt Steel Cup"), {"cobaltsteelblock.png"}, "default:cobalt_steelbar")
cups.register_cup("platinum", S("Platinum Cup"), {"platinumblock.png"}, "default:platinumbar")
cups.register_cup("titanium", S("Titanium Cup"), {"titaniumblock.png"}, "default:titaniumbar")
cups.register_cup("zinc", S("Zinc Cup"), {"zblock.png"}, "default:zincbar")

cups.register_cup("wood", S("Wood Cup"), { "default_wood.png" }, "group:wood", 2)
cups.register_cup("limestone", S("Limestone Cup"), { "default_limestone.png" }, "default:limestone", 2)
cups.register_cup("sandstone", S("Sandstone Cup"), { "default_sandstone.png" }, "default:sandstone", 2)
cups.register_cup("schist", S("Schist Cup"), { "default_schist.png" }, "default:schist", 2)
cups.register_cup("shale", S("Shale Cup"), { "default_shale.png" }, "default:shale", 2)
cups.register_cup("slate", S("Slate Cup"), { "default_slate.png" }, "default:slate", 2)
cups.register_cup("granite", S("Granite Cup"), { "default_granite.png" }, "default:granite", 2)
cups.register_cup("quartz", S("Quartz Cup"), { "quartz.png" }, "default:quartz", 2)
cups.register_cup("onyx", S("Onyx Cup"), { "onyx.png" }, "default:onyx", 2)
cups.register_cup("marble", S("Marble Cup"), { "default_marble.png" }, "default:marble", 2)
cups.register_cup("gneiss", S("Gneiss Cup"), { "default_gneiss.png" }, "default:gneiss", 2)
cups.register_cup("basalt", S("Basalt Cup"), { "default_obsidian.png" }, "default:obsidian", 2)
cups.register_cup("mantle", S("Mantle Cup"), { "mantle.png" }, "default:mantle", 2)
cups.register_cup("copper", S("Copper Cup"), { "cups_bronze.png^[colorize:sienna:175^[colorize:red:40" }, "default:copper_ingot", 2)
cups.register_cup("iron", S("Iron Cup"), { "default_steel_block.png^[colorize:grey:40" }, "default:ironbar", 2)
cups.register_cup("peridot", S("Peridot Cup"), { "peridotblock.png^[opacity:27" }, "default:peridot", 2)
cups.register_cup("opal", S("Opal Cup"), { "opalblock.png^[opacity:27" }, "default:opal", 2)
cups.register_cup("ruby", S("Ruby Cup"), { "rubyblock.png^[opacity:27" }, "default:ruby", 2)
cups.register_cup("amethyst", S("Amethyst Cup"), { "default_mineral_amethyst.png^[opacity:27" }, "default:amethyst", 2)
cups.register_cup("sapphire", S("Sapphire Cup"), { "sapphireblock.png^[opacity:27" }, "default:sapphire", 2)
cups.register_cup("fopal", S("Fire Opal Cup"), { "fopalblock.png^[opacity:27" }, "default:fopal", 2)

-- Legacy aliases
minetest.register_alias("mtg_plus:cup_bronze", "cups:cup_bronze")
minetest.register_alias("mtg_plus:cup_gold", "cups:cup_gold")
minetest.register_alias("mtg_plus:cup_diamond", "cups:cup_diamond")
