-- Crawling: hold Aux1 (Ctrl in the Colony Ship Down launcher, E by default
-- elsewhere) to drop low and fit through one-node gaps - the air ducts.
-- You stay down while something is over your head, and you're pulled down
-- automatically when you climb up into a duct hatch.

local crawling = {} -- name -> true

local CRAWL_BOX = {-0.35, 0.0, -0.35, 0.35, 0.7, 0.35}

-- A "crawl" animation on every player model that can lie down: the lying pose
-- with a short collision box, so player_api swaps the box and eye height.
core.register_on_mods_loaded(function()
	for name, model in pairs(player_api.registered_models) do
		local lay = model.animations and model.animations.lay
		if lay and not model.animations.crawl then
			model.animations.crawl = {x = lay.x, y = lay.y, eye_height = 0.5, override_local = true,
				collisionbox = CRAWL_BOX}
			player_api.register_model(name, model) -- re-sort the property classes
		end
	end
end)

local function solid(pos)
	local def = core.registered_nodes[core.get_node(pos).name]
	return def == nil or def.walkable
end

local function climbable(pos)
	local def = core.registered_nodes[core.get_node(pos).name]
	return def and def.climbable
end

-- Something over a crawling player's head (or about to be, on a hatch ladder)?
local function low_ceiling(pos)
	local feet = vector.round(pos)
	if solid(vector.offset(pos, 0, 1.2, 0)) then return true end
	if solid(vector.offset(pos, 0, 1.75, 0)) then return true end
	return climbable(feet) and solid(vector.offset(feet, 0, 2, 0))
end

local function start(player)
	local name = player:get_player_name()
	crawling[name] = true
	player_api.player_attached[name] = true -- keep player_api off the animation
	player_api.set_animation(player, "crawl", 15)
	player:set_physics_override({speed = 0.45, jump = 0})
end

local function stop(player)
	local name = player:get_player_name()
	crawling[name] = nil
	player_api.player_attached[name] = false
	player_api.set_animation(player, "stand")
	player:set_physics_override({speed = 1, jump = 1})
end

function csd_core.is_crawling(name) return crawling[name] == true end

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 0.1 then return end
	timer = 0
	for _, player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		local pos = player:get_pos()
		local want = player:get_player_control().aux1
		if crawling[name] then
			if not want and not low_ceiling(pos) then stop(player) end
		elseif not player_api.player_attached[name] and not player:get_attach()
				and (want or low_ceiling(pos)) then
			start(player)
		end
	end
end)

core.register_on_leaveplayer(function(player)
	crawling[player:get_player_name()] = nil
end)

core.register_on_dieplayer(function(player)
	if crawling[player:get_player_name()] then stop(player) end
end)
