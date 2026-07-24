-- spirit_world/init.lua
-- A test dimension: flat infinite ocean, black skybox.

local c_water = minetest.get_content_id("default:water_source")
local c_air   = minetest.get_content_id("air")

-- Water fills y <= 0, air above. Player spawns at y=1 (standing on the surface).
local WATER_LEVEL = 0
local SPAWN_Y     = 1

-------------------------------------------------------------------------------
-- Dimension registration
-------------------------------------------------------------------------------
dimensions.register("spirit_world", {
	description = "Spirit World",

	on_generated = function(minp, maxp, seed)
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
		local data = vm:get_data()

		for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local vi   = area:index(minp.x, y, z)
			local fill = (y <= WATER_LEVEL) and c_water or c_air
			for x = minp.x, maxp.x do
				data[vi] = fill
				vi = vi + 1
			end
		end
		end

		vm:set_data(data)
		vm:set_lighting({day = 7, night = 7})
		vm:write_to_map()
	end,

	on_enter = function(player)
		player:set_sky({
			base_color = "#000000",
			type       = "plain",
			clouds     = false,
		})
		player:set_sun({visible = false, sunrise_visible = false})
		player:set_moon({visible = false})
		player:set_stars({visible = false})
		player:set_clouds({density = 0})
	end,

	on_leave = function(player)
		player:set_sky({type = "regular"})
		player:set_sun({visible = true, sunrise_visible = true})
		player:set_moon({visible = true})
		player:set_stars({visible = true})
		player:set_clouds({density = 0.4})
	end,
})

-------------------------------------------------------------------------------
-- Chat command for testing
-------------------------------------------------------------------------------
minetest.register_chatcommand("spiritworld", {
	description = "Toggle between the Spirit World and the main world.",
	privs = {server = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found."
		end

		local target = param ~= "" and minetest.get_player_by_name(param)
		local pname  = target and param or name
		player       = target or player

		if minetest.get_player_dimension(pname) == "spirit_world" then
			local spawn = minetest.get_spawn_level(0, 0) or 5
			dimensions.send_player(player, "", {x = 0, y = spawn, z = 0})
			return true, "Returned to the main world."
		else
			dimensions.send_player(player, "spirit_world",
				{x = 0, y = SPAWN_Y, z = 0})
			return true, "Entered the Spirit World."
		end
	end,
})

-------------------------------------------------------------------------------
-- Portal (optional, requires nether mod)
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Ghost spawning
-------------------------------------------------------------------------------
if minetest.registered_entities["ghosts:ghost"] then
	local GHOST_MAX        = 15   -- max ghosts tracked per player
	local SPAWN_RADIUS_MIN = 8
	local SPAWN_RADIUS_MAX = 24
	local SPAWN_INTERVAL   = 3    -- seconds between spawn attempts

	local timer = 0
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < SPAWN_INTERVAL then return end
		timer = 0

		for _, player in ipairs(minetest.get_connected_players()) do
			if minetest.get_player_dimension(player:get_player_name()) == "spirit_world" then
				local pos = player:get_pos()

				-- Count nearby ghosts
				local count = 0
				for _, obj in ipairs(minetest.get_objects_inside_radius(pos, SPAWN_RADIUS_MAX + 5)) do
					local ent = obj:get_luaentity()
					if ent and ent.name == "ghosts:ghost" then
						count = count + 1
					end
				end

				if count < GHOST_MAX then
					local angle    = math.random() * math.pi * 2
					local dist     = math.random(SPAWN_RADIUS_MIN, SPAWN_RADIUS_MAX)
					local spawn_y  = math.max(SPAWN_Y + 1, pos.y + math.random(-2, 6))
					local spawn_pos = {
						x = pos.x + math.cos(angle) * dist,
						y = spawn_y,
						z = pos.z + math.sin(angle) * dist,
					}

					if minetest.get_node(spawn_pos).name == "air" then
						minetest.add_entity(spawn_pos, "ghosts:ghost")
					end
				end
			end
		end
	end)
end

-------------------------------------------------------------------------------
-- Portal (optional, requires nether mod)
-------------------------------------------------------------------------------
if nether and nether.register_portal and minetest.registered_nodes["startest:space_crystal_ore"] then
	dimensions.register_portal("spirit_world", {
		name             = "spirit_world",
		title            = "Spirit World Portal",
		frame_node       = "startest:space_crystal_ore",
		wormhole_color   = 7,  -- white/pale
		particle_texture = "nether_particle_anim.png",

		find_dim_anchorpos = function(pos, player_name)
			return {x = pos.x, y = SPAWN_Y, z = pos.z}
		end,
	})
end
