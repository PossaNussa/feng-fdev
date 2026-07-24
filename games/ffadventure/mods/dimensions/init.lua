-- dimensions/init.lua
-- High-level API for registering and managing true separate dimensions.
-- Each dimension has its own SQLite map database and EmergeManager.
--
-- Engine API used:
--   minetest.register_dimension(name, {savedir=...})
--   minetest.set_player_dimension(player_name, dim_name)   -- "" = main world
--   minetest.get_player_dimension(player_name)             -- "" = main world
--   minetest.register_on_generated(fn) receives (minp, maxp, seed, dim_name)
--   minetest.register_dim_on_generated(dim_name, fn) for per-dim callbacks
--   core.register_dim_on_generated(dim_name, fn) -- emerge-environment version

dimensions = {}

dimensions._registered = {}   -- dim_name -> def
dimensions._portals    = {}   -- dim_name -> {portal_name, ...}
local registered = dimensions._registered
local portals    = dimensions._portals

-------------------------------------------------------------------------------
-- dimensions.register(name, def)
--
-- def = {
--   savedir     = nil,       -- defaults to <worldpath>/dimensions/<name>
--   description = "",
--   -- Terrain generation callback, called from emerge thread:
--   on_generated = function(minp, maxp, seed) ... end,
--   -- Called when a player enters this dimension:
--   on_enter     = function(player) ... end,
--   -- Called when a player leaves this dimension (returns to main world):
--   on_leave     = function(player) ... end,
-- }
-------------------------------------------------------------------------------
function dimensions.register(name, def)
	assert(type(name) == "string" and name ~= "",
		"dimensions.register: name must be a non-empty string")
	assert(not registered[name],
		"dimensions.register: '" .. name .. "' already registered")

	def = def or {}
	registered[name] = def

	-- Register dimension with the engine (creates ServerMap + EmergeManager)
	local ok = minetest.register_dimension(name, {savedir = def.savedir})
	if not ok then
		error("dimensions.register: engine refused to create dimension '" .. name .. "'")
	end

	-- Register terrain generation callback in the emerge environment
	if def.on_generated then
		core.register_dim_on_generated(name, def.on_generated)
	end

	minetest.log("action", "[dimensions] registered '" .. name .. "'")
end

-------------------------------------------------------------------------------
-- dimensions.send_player(player, dim_name, pos)
--
-- Move a player to another dimension (or "" for main world).
-- pos: spawn position in that dimension (vector).
-------------------------------------------------------------------------------
function dimensions.send_player(player, dim_name, pos)
	local pname = player:get_player_name()
	local old_dim = minetest.get_player_dimension(pname)

	-- Fire on_leave callback for the old dimension
	if old_dim ~= "" and registered[old_dim] and registered[old_dim].on_leave then
		registered[old_dim].on_leave(player)
	end

	-- Teleport the player first so they load blocks from the correct map
	if pos then
		player:set_pos(pos)
	end

	-- Switch dimension (engine clears sent-block cache)
	minetest.set_player_dimension(pname, dim_name)

	-- Fire on_enter callback for the new dimension
	if dim_name ~= "" and registered[dim_name] and registered[dim_name].on_enter then
		registered[dim_name].on_enter(player)
	end

	-- Apply dimension-specific sky via skygen integration
	if dim_name ~= "" then
		dimensions._apply_sky(player, dim_name)
	else
		-- Return to normal sky (skygen will pick it up on next globalstep)
		if skygen and skygen.active_biome then
			skygen.active_biome[pname] = nil
		end
	end
end

-------------------------------------------------------------------------------
-- Sky integration with skygen
-------------------------------------------------------------------------------
function dimensions._apply_sky(player, dim_name)
	if not skygen then return end
	-- Invalidate skygen's biome cache so it re-applies on next globalstep.
	-- The dimension can also override this in on_enter with set_sky().
	skygen.active_biome[player:get_player_name()] = nil
end

-------------------------------------------------------------------------------
-- Per-player dimension query helpers
-------------------------------------------------------------------------------
function dimensions.get_dimension(player_or_name)
	local pname = type(player_or_name) == "string"
		and player_or_name
		or player_or_name:get_player_name()
	return minetest.get_player_dimension(pname)
end

function dimensions.in_main_world(player_or_name)
	return dimensions.get_dimension(player_or_name) == ""
end

-------------------------------------------------------------------------------
-- Load sub-modules
-------------------------------------------------------------------------------
local modpath = minetest.get_modpath("dimensions") .. DIR_DELIM
dofile(modpath .. "portal.lua")
