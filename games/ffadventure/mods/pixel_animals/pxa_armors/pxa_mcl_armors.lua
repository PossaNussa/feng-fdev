mcl_armor.register_set({
	name = "crocodile",
	descriptions = {
	  torso = "Crocodile Chestplate",
	},
	durability = 700,
	enchantability = 10,
	points = {
		torso = 5,
	},
	craft_material = "pixel_animals:crocodile_scutes",
	sound_equip = "mcl_armor_equip_iron",
	sound_unequip = "mcl_armor_unequip_iron",
	groups = {},
})

--- INFELIZMENTE FOI ASSIM QUE ENCONTREI PRA TER SO A PORRA DO TORSO :S
core.override_item("pixel_animals:boots_crocodile", {
	groups = {not_in_creative_inventory = 1},		
})

core.override_item("pixel_animals:helmet_crocodile", {
	groups = {not_in_creative_inventory = 1},		
})

core.override_item("pixel_animals:leggings_crocodile", {
	groups = {not_in_creative_inventory = 1},		
})


core.clear_craft({
    output = "pixel_animals:boots_crocodile"
})

core.clear_craft({
    output = "pixel_animals:helmet_crocodile"
})

core.clear_craft({
    output = "pixel_animals:leggings_crocodile"
})
