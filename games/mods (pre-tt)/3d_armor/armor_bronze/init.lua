--- Registered armors.
--
--  @topic armor

-- support for i18n
local S = armor.get_translator

--- Iron
--
--  Requires setting `armor_material_iron`.
--
--  @section iron

if armor.materials.iron then
	--- Iron Helmet
	--
	--  @helmet 3d_armor:helmet_iron
	--  @img 3d_armor_inv_helmet_iron.png
	--  @grp armor_head 1
	--  @grp armor_heal 4
	--  @grp armor_use 600
	--  @grp physics_speed -0.01
	--  @grp physics_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:helmet_iron", {
		description = S("Iron Helmet"),
		inventory_image = "3d_armor_inv_helmet_steel.png^[colorize:#B0B0B0:80",
		groups = {armor_head=1, armor_heal=4, armor_use=600,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Iron Chestplate
	--
	--  @chestplate 3d_armor:chestplate_iron
	--  @img 3d_armor_inv_chestplate_iron.png
	--  @grp armor_torso 1
	--  @grp armor_heal 4
	--  @grp armor_use 600
	--  @grp physics_speed -0.04
	--  @grp physics_gravity 0.04
	--  @armorgrp fleshy 15
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:chestplate_iron", {
		description = S("Iron Chestplate"),
		inventory_image = "3d_armor_inv_chestplate_steel.png^[colorize:#B0B0B0:80",
		groups = {armor_torso=1, armor_heal=4, armor_use=600,
			physics_speed=-0.04, physics_gravity=0.04},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Iron Leggings
	--
	--  @leggings 3d_armor:leggings_iron
	--  @img 3d_armor_inv_leggings_iron.png
	--  @grp armor_legs 1
	--  @grp armor_heal 4
	--  @grp armor_use 600
	--  @grp physics_speed -0.03
	--  @grp physics_gravity 0.03
	--  @armorgrp fleshy 15
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:leggings_iron", {
		description = S("Iron Leggings"),
		inventory_image = "3d_armor_inv_leggings_steel.png^[colorize:#B0B0B0:80",
		groups = {armor_legs=1, armor_heal=4, armor_use=600,
			physics_speed=-0.03, physics_gravity=0.03},
		armor_groups = {fleshy=15},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})
	--- Iron Boots
	--
	--  @boots 3d_armor:boots_iron
	--  @img 3d_armor_inv_boots_iron.png
	--  @grp armor_feet 1
	--  @grp armor_heal 4
	--  @grp armor_use 600
	--  @grp physics_speed -0.01
	--  @grp physics_gravity 0.01
	--  @armorgrp fleshy 10
	--  @damagegrp cracky 2
	--  @damagegrp snappy 3
	--  @damagegrp choppy 2
	--  @damagegrp crumbly 1
	--  @damagegrp level 2
	armor:register_armor(":3d_armor:boots_iron", {
		description = S("Iron Boots"),
		inventory_image = "3d_armor_inv_boots_steel.png^[colorize:#B0B0B0:80",
		groups = {armor_feet=1, armor_heal=4, armor_use=600,
			physics_speed=-0.01, physics_gravity=0.01},
		armor_groups = {fleshy=10},
		damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
	})

	--- Crafting
	--
	--  @section craft

	local s = "iron"
	local m = "default:iron_ingot" -- Corrected crafting material
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
