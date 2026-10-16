Register blocks, stairs and slabs :



    pixelfurniture.register_node ("pf_stone",{

    description = "Pf Stone",

    tiles = {"default_stone.png"},

    groups = {cracky = 3, stone = 1},

    })



Register Fences : 


    pixelfurniture.register_fence ("pixelfurniture:pf_stone",{

    description = "Pf Stone Fence",

    tiles = {"default_stone.png"},

    groups = {cracky = 3, stone = 1},

    })


---
If you want to create your own decorative items such as tables, chairs, lanterns and more, check out these examples [here.](https://codeberg.org/pixelzone/pixelfurniture/src/branch/main/pfunitures.lua
)
