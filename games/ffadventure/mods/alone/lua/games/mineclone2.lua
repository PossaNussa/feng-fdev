local internal_api = ...

-- Yoinked from VoxelLibre
local function construct_node(p1, p2, name)
	local r = core.registered_nodes[name]
	if r then
		if r.on_construct then
			local nodes = core.find_nodes_in_area(p1, p2, name)
			for p = 1, #nodes do
				local pos = nodes[p]
				r.on_construct(pos)
			end
			return nodes
		end
		return
	end
end

local function init_nodes(p1, p2, size, rotation, pr)
	construct_node(p1, p2, "mcl_itemframes:frame")
	construct_node(p1, p2, "mcl_furnaces:furnace")
	construct_node(p1, p2, "mcl_anvils:anvil")

	construct_node(p1, p2, "mcl_smoker:smoker")
	construct_node(p1, p2, "mcl_barrels:barrel_closed")
	construct_node(p1, p2, "mcl_blast_furnace:blast_furnace")
	construct_node(p1, p2, "mcl_brewing:stand_000")
	local nodes = construct_node(p1, p2, "mcl_chests:chest")
	if nodes and #nodes > 0 then
		for p = 1, #nodes do
			local pos = nodes[p]
			settlements.fill_chest(pos, pr)
		end
	end
end
-- End Yoink

function internal_api.spawn_house(player, pos)
	local pr = PcgRandom(os.time())

	local houses = internal_api.load_houses()
	local schem

	if #houses == 0 then
		local schem_path = settlements.modpath .. "/schematics/"
		local house = schem_path .. "small_house.mts"
		schem = core.serialize_schematic(house, "lua",
		                                 {lua_use_comments = false, lua_num_indent_spaces = 0}) ..
			        " return schematic"
	else
		schem = houses[pr:next(1, #houses)]
	end

	local schematic = loadstring(schem)()

	local size = schematic.size

	local ppos = vector.offset(pos, 0, -2, 0)

	core.place_schematic(ppos, schematic, "random", {
		["mcl_core:dirt_with_grass"] = schematic.surface_mat or "mcl_core:dirt",
	}, true, {place_center_x = true, place_center_y = false, place_center_z = true})

	local x_adj = math.ceil(size.x / 2)
	local z_adj = math.ceil(size.z / 2)
	local minp = vector.offset(ppos, -x_adj, 0, -z_adj)
	local maxp = vector.offset(ppos, x_adj, size.y, z_adj)
	init_nodes(minp, maxp, size, nil, pr)

	return 0, true
end
