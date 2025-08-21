--MCmobs v0.4
--maikerumine
--made for MC like Survival game
--License for code WTFPL and otherwise stated in readmes
mobs_mc = {}

local pr = PseudoRandom(os.time()*5)

local offsets = {}
for x=-2, 2 do
	for z=-2, 2 do
		table.insert(offsets, {x=x, y=0, z=z})
	end
end


-- Animals
local path = minetest.get_modpath("mobs_mc")
--dofile(path .. "/axolotl.lua") -- Mesh and animation by JoeEnderman, Textures by Nova Wustra, modified by JoeEnderman
--dofile(path .. "/bat.lua") -- Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/rabbit.lua") -- Mesh and animation byExeterDad
--dofile(path .. "/chicken.lua") -- Mesh and animation by Pavel_S
--dofile(path .. "/cow+mooshroom.lua") -- Mesh by Morn76 Animation by Pavel_S
--dofile(path .. "/horse.lua") -- KrupnoPavel; Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/llama.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/ocelot.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/parrot.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/pig.lua") -- Mesh and animation by Pavel_S
--dofile(path .. "/polar_bear.lua") --  Mesh and animation by toby109tt  / https://github.com/22i
--dofile(path .. "/sheep.lua") -- Mesh and animation by Pavel_S
--dofile(path .. "/wolf.lua") -- KrupnoPavel
--dofile(path .. "/squid.lua") -- Animation, sound and egg texture by daufinsyd

-- NPCs
dofile(path .. "/villager.lua") -- KrupnoPavel Mesh and animation by toby109tt  / https://github.com/22i
