armor:register_armor("pixel_animals:chestplate_crocodile", {
 description = "Crocodile Chestplate",
 inventory_image = "pixel_animals_inv_chestplate_crocodile.png",
 groups = {armor_torso=1, armor_heal=0, armor_use=700,
 physics_speed=-0.04, physics_gravity=0.04,armor_fire=2},
 armor_groups = {fleshy=10},
 damage_groups = {cracky=2, snappy=3, choppy=2, crumbly=1, level=2},
})

core.register_craft({
  output = "pixel_animals:chestplate_crocodile",
  recipe = {
    {"pixel_animals:crocodile_scutes","","pixel_animals:crocodile_scutes"},
    {"pixel_animals:crocodile_scutes","pixel_animals:crocodile_scutes","pixel_animals:crocodile_scutes"},
    {"pixel_animals:crocodile_scutes","pixel_animals:crocodile_scutes","pixel_animals:crocodile_scutes"}
  }
})
