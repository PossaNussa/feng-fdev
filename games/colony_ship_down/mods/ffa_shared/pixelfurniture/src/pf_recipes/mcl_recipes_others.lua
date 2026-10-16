-- CURTINAS RECEITA:
local function curtains_recipes_mtg(output_item,curtain_recipe,mcl_dyes_recipe)
core.register_craft{
  type = "shapeless",
  output = output_item,
  recipe = {curtain_recipe,mcl_dyes_recipe},
}
end

curtains_recipes_mtg("pixelfurniture:curtain","group:curtains","mcl_dyes:red")
curtains_recipes_mtg("pixelfurniture:curtain_white","group:curtains","mcl_dyes:white")
curtains_recipes_mtg("pixelfurniture:curtain_grey","group:curtains","mcl_dyes:grey")
curtains_recipes_mtg("pixelfurniture:curtain_dark_grey","group:curtains","mcl_dyes:dark_grey")
curtains_recipes_mtg("pixelfurniture:curtain_black","group:curtains","mcl_dyes:black")
curtains_recipes_mtg("pixelfurniture:curtain_violet","group:curtains","mcl_dyes:violet")
curtains_recipes_mtg("pixelfurniture:curtain_blue","group:curtains","mcl_dyes:blue")
curtains_recipes_mtg("pixelfurniture:curtain_cyan","group:curtains","mcl_dyes:cyan")
curtains_recipes_mtg("pixelfurniture:curtain_dark_green","group:curtains","mcl_dyes:dark_green")
curtains_recipes_mtg("pixelfurniture:curtain_green","group:curtains","mcl_dyes:green")
curtains_recipes_mtg("pixelfurniture:curtain_yellow","group:curtains","mcl_dyes:yellow")
curtains_recipes_mtg("pixelfurniture:curtain_brown","group:curtains","mcl_dyes:brown")
curtains_recipes_mtg("pixelfurniture:curtain_orange","group:curtains","mcl_dyes:orange")
curtains_recipes_mtg("pixelfurniture:curtain_magenta","group:curtains","mcl_dyes:magenta")
curtains_recipes_mtg("pixelfurniture:curtain_pink","group:curtains","mcl_dyes:pink")

-- Upholstered RECEITA:
local function upholstered_recipes_mtg(output_item,upholstered_recipe,mcl_dyes_recipe)
core.register_craft{
  type = "shapeless",
  output = output_item,
  recipe = {upholstered_recipe,mcl_dyes_recipe},
}
end

upholstered_recipes_mtg("pixelfurniture:upholstered_chair_red","group:upholstered","mcl_dyes:red")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_white","group:upholstered","mcl_dyes:white")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_grey","group:upholstered","mcl_dyes:grey")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_dark_grey","group:upholstered","mcl_dyes:dark_grey")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_black","group:upholstered","mcl_dyes:black")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_violet","group:upholstered","mcl_dyes:violet")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_blue","group:upholstered","mcl_dyes:blue")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_cyan","group:upholstered","mcl_dyes:cyan")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_dark_green","group:upholstered","mcl_dyes:dark_green")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_green","group:upholstered","mcl_dyes:green")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_yellow","group:upholstered","mcl_dyes:yellow")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_brown","group:upholstered","mcl_dyes:brown")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_orange","group:upholstered","mcl_dyes:orange")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_magenta","group:upholstered","mcl_dyes:magenta")
upholstered_recipes_mtg("pixelfurniture:upholstered_chair_pink","group:upholstered","mcl_dyes:pink")

