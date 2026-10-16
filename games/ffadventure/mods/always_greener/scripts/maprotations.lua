
-- Random param2 here is a *rotation* trick from before this world's grass,
-- ferns, flowers and leaves existed. Several of those nodes have since been
-- given `paramtype2 = "color"` (luscious paints tall grass and leaves; seasons
-- paints canopies), and for a colour node param2 is the palette index, not a
-- rotation -- overwriting it with math.random repaints the node a random
-- colour.
--
-- This is a mapgen SCRIPT, so under climate_zones_v7's `nodecorations` it only
-- ever meets tall grass in the ~16-node emerged margin that laps into
-- already-decorated neighbours (the decorations themselves are placed later, in
-- the main env, by biomegen.place_all_decos). Randomising param2 there painted a
-- lattice of miscoloured grass strips along every chunk boundary -- the same
-- failure mapcolors.lua was moved to the main env to escape. Tall grass is now
-- coloured there instead (see mapcolors.lua).
--
-- So grass and leaves -- every node another mod has turned into a colour node --
-- are dropped from the list outright: mapcolors.lua colours grass, seasons and
-- luscious colour leaves, and none of them want a random param2. What is left is
-- plain plantlike flowers and ferns, whose param2 the engine ignores, so a
-- random value there is a harmless no-op kept for the original variety intent.
--
-- The paramtype2 guard below is belt-and-suspenders: should any of these ever
-- gain a colour palette too, it stops the random param2 from repainting them.
local candidates = {
	'default:fern_1', 'default:fern_2', 'default:fern_3',
	'flowers:geranium', 'flowers:chrysanthemum_green',
	'flowers:dandelion_yellow', 'flowers:dandelion_white',
	'flowers:viola', 'flowers:tulip', 'flowers:tulip_black',
	'flowers:rose', 'flowers:waterlily', 'flowers:waterlily_waving'
}

local grassnodes = {}
for _, name in ipairs(candidates) do
	local def = minetest.registered_nodes[name]
	local p2 = def and def.paramtype2 or ''
	-- Skip every colour paramtype2 (color, colorfacedir, colorwallmounted,
	-- colordegrotate): their param2 carries the palette index.
	if def and p2:sub(1, 5) ~= 'color' then
		grassnodes[minetest.get_content_id(name)] = true
	end
end

minetest.register_on_generated(function(vm, minp, maxp, blockseed)
	local dat = vm: get_data()
	local p2dat = vm: get_param2_data()
	
	local min, max = vm: get_emerged_area()
	local area = VoxelArea(min, max)
	
	for index in area: iterp(min, max) do
		if grassnodes[dat[index]] then
			p2dat[index] = math.random(0, 239)
		end
	end
	
	vm: set_data(dat)
	vm: set_param2_data(p2dat)
end)
