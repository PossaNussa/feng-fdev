minetest.register_craft({
    output = "default:diamond",
    recipe = {
        {"dye:blue","birthstones:diamond"}
    }
})


local function registerblockrecipe(name, blockname)
    minetest.register_craft({
        output = blockname,
        recipe = {{name, name, name},
            {name, name, name},
            {name, name, name}
            }
    })
    minetest.register_craft({
        output = name..' 9',
        recipe = {
            {blockname},
        }
    })
end

registerblockrecipe('birthstones:alexandrite', 'birthstones:alexandriteblock')
registerblockrecipe('birthstones:aquamarine', 'birthstones:aquamarineblock')
registerblockrecipe('birthstones:diamond', 'birthstones:diamondblock')
registerblockrecipe('birthstones:topaz', 'birthstones:topazblock')
registerblockrecipe('birthstones:zircon', 'birthstones:zirconblock')
