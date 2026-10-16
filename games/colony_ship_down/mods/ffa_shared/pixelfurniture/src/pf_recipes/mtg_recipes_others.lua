-- CURTINAS RECEITA:
local function curtains_recipes_mtg(output_item,curtain_recipe,dye_recipe)
core.register_craft{
  type = "shapeless",
  output = output_item,
  recipe = {curtain_recipe,dye_recipe},
}
end

curtains_recipes_mtg("pixelfurniture:curtain","group:curtains","dye:red")
curtains_recipes_mtg("pixelfurniture:curtain_white","group:curtains","dye:white")
curtains_recipes_mtg("pixelfurniture:curtain_grey","group:curtains","dye:grey")
curtains_recipes_mtg("pixelfurniture:curtain_dark_grey","group:curtains","dye:dark_grey")
curtains_recipes_mtg("pixelfurniture:curtain_black","group:curtains","dye:black")
curtains_recipes_mtg("pixelfurniture:curtain_violet","group:curtains","dye:violet")
curtains_recipes_mtg("pixelfurniture:curtain_blue","group:curtains","dye:blue")
curtains_recipes_mtg("pixelfurniture:curtain_cyan","group:curtains","dye:cyan")
curtains_recipes_mtg("pixelfurniture:curtain_dark_green","group:curtains","dye:dark_green")
curtains_recipes_mtg("pixelfurniture:curtain_green","group:curtains","dye:green")
curtains_recipes_mtg("pixelfurniture:curtain_yellow","group:curtains","dye:yellow")
curtains_recipes_mtg("pixelfurniture:curtain_brown","group:curtains","dye:brown")
curtains_recipes_mtg("pixelfurniture:curtain_orange","group:curtains","dye:orange")
curtains_recipes_mtg("pixelfurniture:curtain_magenta","group:curtains","dye:magenta")
curtains_recipes_mtg("pixelfurniture:curtain_pink","group:curtains","dye:pink")

-- Upholstered RECEITA:
local function upholstered_recipes_mtg(output_item,upholstered_recipe,dye_recipe)
core.register_craft{
  type = "shapeless",
  output = output_item,
  recipe = {upholstered_recipe,dye_recipe},
}
end

upholstered_recipes_mtg("pixelfurniture:upholstered_chair_red","group:upholstered_chair","dye:red")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_white","group:upholstered_chair","dye:white")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_grey","group:upholstered_chair","dye:grey")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_dark_grey","group:upholstered_chair","dye:dark_grey")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_black","group:upholstered_chair","dye:black")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_violet","group:upholstered_chair","dye:violet")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_blue","group:upholstered_chair","dye:blue")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_cyan","group:upholstered_chair","dye:cyan")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_dark_green","group:upholstered_chair","dye:dark_green")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_green","group:upholstered_chair","dye:green")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_yellow","group:upholstered_chair","dye:yellow")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_brown","group:upholstered_chair","dye:brown")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_orange","group:upholstered_chair","dye:orange")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_magenta","group:upholstered_chair","dye:magenta")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_pink","group:upholstered_chair","dye:pink")
