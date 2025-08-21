local internal_api = ...

local function load_houses(path)
	local houses = {}

	for _, file in pairs(core.get_dir_list(path, false)) do
		if file:sub(-4) == ".mts" then
			local schem_lua = core.serialize_schematic(path .. "/" .. file, "lua", {
				lua_use_comments = false,
				lua_num_indent_spaces = 0,
			}) .. " return schematic"

			table.insert(houses, schem_lua)
		end
	end

	return houses
end

-- This doesn't cache so that new schemas can be used without restarting the server
-- Might prove to be a bad idea if people go crazy
function internal_api.load_houses()
	local houses = load_houses(core.get_worldpath() .. "/alone_houses/")
	if #houses == 0 then houses = load_houses(internal_api.mod_data_path .. "/houses/") end
	return houses
end

function internal_api.default_spawn_house(player, pos)
	local houses = internal_api.load_houses()

	if #houses == 0 then return false end

	local pr = PcgRandom(os.time())
	local schem_lua = houses[pr:next(1, #houses)]
	local schematic = loadstring(schem_lua)()

	pos = vector.offset(pos, 0, 1, 0)

	core.place_schematic(pos, schematic, "random", {}, true, {
		place_center_x = true,
		place_center_y = false,
		place_center_z = true,
	})

	return 1, true
end

function internal_api.get_rand(player)
	local seed = os.time()

	if core.settings:get_bool("alone_predictable_spawns") then
		seed = tonumber(core.sha1(player:get_player_name()), 16) + core.get_mapgen_setting("seed")
	end

	return PcgRandom(seed)
end
