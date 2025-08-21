
--- Registered armors.
--
--  @topic armor


-- support for i18n

--- copper
--
--  Requires setting `armor_material_copper`.
--
--  @section copper

if armor.materials.copper then
	--- copper Helmet
	--
	--  @helmet 3d_armor:helmet_copper
	--  @img 3d_armor_inv_helmet_copper.png
	--  @grp armor_head 1
	--  @grp armor_heal 6
	--  @grp armor_use 400
	--  @grp physics_speed -0.01
	--  @grp physics_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:helmet_copper", {
		description = ("Copper Helmet"),
		texture = "3d_armor_helmet_copper.png",
		inventory_image = "3d_armor_inv_helmet_bronze.png^[colorize:sienna:175^[colorize:red:40",
		groups = {armor_head=1, armor_heal=3, armor_use=250},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	--- Bronze Chestplate
	--
	--  @chestplate 3d_armor:chestplate_bronze
	--  @img 3d_armor_inv_chestplate_bronze.png
	--  @grp armor_torso 1
	--  @grp armor_heal 6
	--  @grp armor_use 400
	--  @grp physics_speed -0.04
	--  @grp physics_gravity 0.04
	--  @armorgrp fleshy 15
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:chestplate_copper", {
		description = ("Copper Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_bronze.png^[colorize:sienna:175^[colorize:red:40",
		texture = "3d_armor_chestplate_copper.png",
		groups = {armor_torso=1, armor_heal=3, armor_use=250,
			physics_speed=-0.02, physics_gravity=0.02},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	--- Bronze Leggings
	--
	--  @leggings 3d_armor:leggings_bronze
	--  @img 3d_armor_inv_leggings_bronze.png
	--  @grp armor_legs 1
	--  @grp armor_heal 6
	--  @grp armor_use 400
	--  @grp physics_speed -0.03
	--  @grp physics_gravity 0.03
	--  @armorgrp fleshy 15
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:leggings_copper", {
		description = ("Copper Leggings"),
		texture = "3d_armor_leggings_copper.png",
		inventory_image = "3d_armor_inv_leggings_bronze.png^[colorize:sienna:175^[colorize:red:40",
		groups = {armor_legs=1, armor_heal=3, armor_use=250,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})
	--- Bronze Boots
	--
	--  @boots 3d_armor:boots_bronze
	--  @img 3d_armor_inv_boots_bronze.png
	--  @grp armor_feet 1
	--  @grp armor_heal 6
	--  @grp armor_use 400
	--  @grp physics_speed -0.01
	--  @grp physics_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 3
	--  @damagegrp snappy 2
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:boots_copper", {
		description = ("Copper Boots"),
		texture = "3d_armor_boots_copper.png",
		inventory_image = "3d_armor_inv_boots_bronze.png^[colorize:sienna:175^[colorize:red:40",
		groups = {armor_feet=1, armor_heal=3, armor_use=250,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=3, snappy=2, choppy=2, crumbly=1, level=2},
	})

	--- Crafting
	--
	--  @section craft

	--- Craft recipes for helmets, chestplates, leggings, boots, & shields.
	--
	--  @craft armor
	--  @usage
	--  Key:
	--  - m: material
	--    - wood:    group:wood
	--    - cactus:  default:cactus
	--    - steel:   default:steel_ingot
	--    - bronze:  default:bronze_ingot
	--    - diamond: default:diamond
	--    - gold:    default:gold_ingot
	--    - mithril: moreores:mithril_ingot
	--    - crystal: ethereal:crystal_ingot
	--    - nether:  nether:nether_ingot
	--
	--  helmet:        chestplate:    leggings:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │ m │ m │ m │  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │  │ m │   │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤  ├───┼───┼───┤
	--  │   │   │   │  │ m │ m │ m │  │ m │   │ m │
	--  └───┴───┴───┘  └───┴───┴───┘  └───┴───┴───┘
	--
	--  boots:         shield:
	--  ┌───┬───┬───┐  ┌───┬───┬───┐
	--  │   │   │   │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │ m │ m │ m │
	--  ├───┼───┼───┤  ├───┼───┼───┤
	--  │ m │   │ m │  │   │ m │   │
	--  └───┴───┴───┘  └───┴───┴───┘

	local s = "copper"
	local m = "default:copper_ingot"
	minetest.register_craft({
		output = "3d_armor:helmet_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "3d_armor:chestplate_"..s,
		recipe = {
			{m, "", m},
			{m, m, m},
			{m, m, m},
		},
	})
	minetest.register_craft({
		output = "3d_armor:leggings_"..s,
		recipe = {
			{m, m, m},
			{m, "", m},
			{m, "", m},
		},
	})
	minetest.register_craft({
		output = "3d_armor:boots_"..s,
		recipe = {
			{m, "", m},
			{m, "", m},
		},
	})
end