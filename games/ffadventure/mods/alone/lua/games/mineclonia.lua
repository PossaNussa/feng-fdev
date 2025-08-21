local internal_api = ...

-- Yoinked from Mineclonia
local function init_nodes(p1, p2, _, _, pr)
	for _, n in pairs(core.find_nodes_in_area(p1, p2, {"group:wall"})) do
		mcl_walls.update_wall(n)
	end

	mcl_structures.construct_nodes(p1, p2, {
		"mcl_itemframes:item_frame",
		"mcl_itemframes:glow_item_frame",
		"mcl_furnaces:furnace",
		"mcl_anvils:anvil",
		"mcl_books:bookshelf",
		"mcl_armor_stand:armor_stand",
	})

	--[[ support for custom job sites was removed
	-- Support mods with custom job sites
	local job_sites = core.find_nodes_in_area(p1, p2, mobs_mc.jobsites)
	for _, v in pairs(job_sites) do mcl_structures.init_node_construct(v) end
	]]

	local nodes = mcl_structures.construct_nodes(p1, p2, {
		"mcl_chests:chest_small",
		"mcl_chests:chest",
	}) or {}
	for p = 1, #nodes do mcl_villages.fill_chest(nodes[p], pr) end
end
-- End Yoink

function internal_api.spawn_house(player, pos)
	local pr = PcgRandom(os.time())

	local houses = internal_api.load_houses()

	if #houses == 0 then
		for _, building_info in ipairs(mcl_villages.schematic_houses) do
			if building_info["num_beds"] and building_info["num_beds"] >= 1 then
				table.insert(houses, building_info["schem_lua"])
			end
		end
	end

	if #houses > 0 then
		local house = houses[pr:next(1, #houses)]

		local schem = mcl_villages.substitute_materials(pos, house, pr)
		local schematic = loadstring(schem)()
		local size = schematic.size

		mcl_util.create_ground_turnip(pos, size.x - 2, size.z - 2)

		local clearance = math.floor((size.x / 2) + 0.5) + 2
		local clear_y = size.y + 5

		local pos1 = vector.offset(pos, -clearance, 1, -clearance)
		local pos2 = vector.offset(pos, clearance, clear_y, clearance)
		mcl_util.bulk_set_node_vm(pos1, pos2, "air")

		pos = vector.offset(pos, 0, 1, 0)

		core.place_schematic(pos, schematic, "random", {
			["mcl_core:dirt_with_grass"] = schematic.surface_mat or "mcl_core:dirt",
			["mcl_villages:no_paths"] = "air",
			["mcl_villages:path_endpoint"] = "air",
		}, true, {place_center_x = true, place_center_y = false, place_center_z = true})

		local x_adj = math.ceil(size.x / 2)
		local z_adj = math.ceil(size.z / 2)
		local minp = vector.offset(pos, -x_adj, 0, -z_adj)
		local maxp = vector.offset(pos, x_adj, size.y, z_adj)
		init_nodes(minp, maxp, size, nil, pr)
		return 2, true
	end

	return 0, false
end

function internal_api.game_respawn(player)
	local pos, in_bed = mcl_spawn.get_player_spawn_pos(player)
	if in_bed then
		player:set_pos(pos)
		return true
	end

	return false
end
