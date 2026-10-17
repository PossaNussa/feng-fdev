-- Colony Ship Down core rules.
--
-- * Crew can place things but can't damage the ship; builders (the `builder`
--   privilege, which also grants creative/fly/fast/noclip) can change anything.
-- * Crew pick a job; it tags their chat lines and nametag and weights which
--   tasks they get (see csd_tasks).
-- * The ship generator (csd_ship) sets the spawn point; players respawn there.
--
-- Nothing here assumes the CSD map, so the mod also works in ffadventure.

csd_core = {}

local S = core.get_translator("csd_core")
local storage = core.get_mod_storage()

------------------------------------------------------------------------------
-- Builder privilege and the no-build rule
------------------------------------------------------------------------------

core.register_privilege("builder", {
	description = S("Can build and dig anywhere (ship crew can only use things)"),
	give_to_singleplayer = true, -- singleplayer is the one building the ship
	give_to_admin = true,
})

-- Privileges that come with `builder`. Revoking `builder` takes them back.
csd_core.builder_bundle = {"creative", "fly", "fast", "noclip"}

function csd_core.is_builder(name)
	return name ~= nil and name ~= "" and core.check_player_privs(name, {builder = true})
end

local function set_bundle(name, on)
	local privs = core.get_player_privs(name)
	for _, p in ipairs(csd_core.builder_bundle) do
		if core.registered_privileges[p] then
			privs[p] = on or nil
		end
	end
	core.set_player_privs(name, privs)
end

core.register_on_priv_grant(function(name, _, priv)
	if priv == "builder" then
		core.after(0, set_bundle, name, true)
	end
end)

core.register_on_priv_revoke(function(name, _, priv)
	if priv == "builder" then
		core.after(0, set_bundle, name, false)
	end
end)

-- Building rules for crew:
-- * Anyone may place things (crew just don't get much to place).
-- * The ship itself can't be damaged: crew can only dig nodes a player placed
--   (placed nodes are tagged with node meta "csd_placer").
-- * Other mods add checks (claimed rooms) with csd_core.register_protection_check.
local protection_checks = {}

-- func(pos, name) -> true (protected), false (allowed) or nil (no opinion)
function csd_core.register_protection_check(func)
	table.insert(protection_checks, func)
end

function csd_core.placed_by_player(pos)
	return core.get_meta(pos):get_string("csd_placer") ~= ""
end

local old_is_protected = core.is_protected
function core.is_protected(pos, name)
	if csd_core.is_builder(name) then
		return old_is_protected(pos, name)
	end
	for _, check in ipairs(protection_checks) do
		local r = check(pos, name)
		if r ~= nil then return r end
	end
	local node = core.get_node_or_nil(pos)
	if node then
		local def = core.registered_nodes[node.name]
		-- Placing into air/vacuum/replaceable space is fine; digging the ship is not.
		local replaceable = node.name == "air" or (def and def.buildable_to)
		if not replaceable and not csd_core.placed_by_player(pos) then
			return true
		end
	end
	return old_is_protected(pos, name)
end

core.register_on_placenode(function(pos, _, placer)
	if placer and placer:is_player() and not csd_core.is_builder(placer:get_player_name()) then
		core.get_meta(pos):set_string("csd_placer", placer:get_player_name())
	end
end)

local last_warning = {}
local old_violation = core.record_protection_violation
function core.record_protection_violation(pos, name)
	if not csd_core.is_builder(name) then
		local now = core.get_us_time()
		if not last_warning[name] or now - last_warning[name] > 3e6 then
			last_warning[name] = now
			core.chat_send_player(name, core.colorize("#ffb347",
				S("That's part of the ship - you can't take it apart. (Use things with right-click.)")))
		end
		return
	end
	return old_violation(pos, name)
end

------------------------------------------------------------------------------
-- Jobs
------------------------------------------------------------------------------

csd_core.jobs = {}
csd_core.job_order = {}

-- def: {title = "Engineer", color = "#ffaa33", description = "..."}
function csd_core.register_job(id, def)
	def.id = id
	csd_core.jobs[id] = def
	table.insert(csd_core.job_order, id)
end

csd_core.register_job("engineer",  {title = S("Engineer"),  color = "#ffaa33", description = S("Reactor, power and machinery")})
csd_core.register_job("botanist",  {title = S("Botanist"),  color = "#66dd66", description = S("Hydroponics and oxygen gardens")})
csd_core.register_job("medic",     {title = S("Medic"),     color = "#ff6688", description = S("Medbay and crew health")})
csd_core.register_job("navigator", {title = S("Navigator"), color = "#66bbff", description = S("Bridge, navigation and shields")})
csd_core.register_job("security",  {title = S("Security"),  color = "#ff5544", description = S("Patrols, cameras and the brig")})
csd_core.register_job("custodian", {title = S("Custodian"), color = "#c8b88a", description = S("Waste, filters and keeping things clean")})
csd_core.register_job("cook",      {title = S("Cook"),      color = "#ffdd66", description = S("Galley and mess hall")})
csd_core.register_job("scientist", {title = S("Scientist"), color = "#cc88ff", description = S("Labs, samples and sensors")})

function csd_core.get_job(name)
	local player = core.get_player_by_name(name)
	if not player then return nil end
	local id = player:get_meta():get_string("csd_core:job")
	return csd_core.jobs[id] and id or nil
end

local job_callbacks = {}
function csd_core.register_on_job_change(func)
	table.insert(job_callbacks, func)
end

local function update_nametag(player)
	local job = csd_core.jobs[csd_core.get_job(player:get_player_name()) or ""]
	player:set_nametag_attributes({
		text = player:get_player_name() .. (job and ("\n" .. job.title) or ""),
		color = job and job.color or "#ffffff",
	})
end

function csd_core.set_job(name, id)
	local player = core.get_player_by_name(name)
	if not player or not csd_core.jobs[id] then return false end
	local old = csd_core.get_job(name)
	player:get_meta():set_string("csd_core:job", id)
	update_nametag(player)
	for _, func in ipairs(job_callbacks) do
		func(player, id, old)
	end
	return true
end

local function job_formspec(name)
	local current = csd_core.get_job(name)
	local fs = {
		"formspec_version[6]size[11,", 2.3 + math.ceil(#csd_core.job_order / 2) * 1.5, "]",
		"bgcolor[#0a0f1cee;true]",
		"label[0.5,0.6;", core.formspec_escape(S("Choose your job aboard the colony ship")), "]",
		"label[0.5,1.1;", core.colorize("#9aa7c0", core.formspec_escape(
			S("It decides which tasks you're given. You can change it later with /job."))), "]",
	}
	for i, id in ipairs(csd_core.job_order) do
		local job = csd_core.jobs[id]
		local x = (i - 1) % 2 == 0 and 0.5 or 5.6
		local y = 1.7 + math.floor((i - 1) / 2) * 1.5
		fs[#fs + 1] = ("style[job_%s;bgcolor=%s;textcolor=#ffffff]"):format(id, id == current and job.color or "#22304a")
		fs[#fs + 1] = ("button[%f,%f;4.9,1.3;job_%s;%s]"):format(x, y, id,
			core.formspec_escape(job.title .. "\n" .. job.description))
	end
	return table.concat(fs)
end

function csd_core.show_job_picker(name)
	core.show_formspec(name, "csd_core:job", job_formspec(name))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "csd_core:job" then return end
	local name = player:get_player_name()
	for field in pairs(fields) do
		local id = field:match("^job_(.+)$")
		if id and csd_core.jobs[id] then
			csd_core.set_job(name, id)
			core.close_formspec(name, formname)
			core.chat_send_player(name, S("You are now the ship's @1.", csd_core.jobs[id].title))
			return true
		end
	end
	if fields.quit and not csd_core.get_job(name) then
		-- Closing the picker without choosing: pick something so tasks work.
		local id = csd_core.job_order[math.random(#csd_core.job_order)]
		csd_core.set_job(name, id)
		core.chat_send_player(name, S("You were assigned as @1. Use /job to change.", csd_core.jobs[id].title))
	end
	return true
end)

core.register_chatcommand("job", {
	params = S("[job]"),
	description = S("Choose your crew job"),
	func = function(name, param)
		param = param:trim():lower()
		if param == "" then
			csd_core.show_job_picker(name)
			return true
		end
		for id, job in pairs(csd_core.jobs) do
			if id == param or job.title:lower() == param then
				csd_core.set_job(name, id)
				return true, S("You are now the ship's @1.", job.title)
			end
		end
		return false, S("Unknown job. Jobs: @1", table.concat(csd_core.job_order, ", "))
	end,
})

------------------------------------------------------------------------------
-- Chat: "[Engineer] name: message", job tag coloured
------------------------------------------------------------------------------

local old_format = core.format_chat_message
function core.format_chat_message(name, message)
	local job = csd_core.jobs[csd_core.get_job(name) or ""]
	local text = old_format(name, message)
	if job then
		text = core.colorize(job.color, "[" .. job.title .. "]") .. " " .. text
	end
	return text
end

------------------------------------------------------------------------------
-- Spawn
------------------------------------------------------------------------------

function csd_core.get_spawn()
	local s = storage:get_string("spawn")
	return s ~= "" and core.string_to_pos(s) or nil
end

function csd_core.set_spawn(pos)
	storage:set_string("spawn", core.pos_to_string(vector.round(pos)))
end

function csd_core.send_to_spawn(player)
	local spawn = csd_core.get_spawn()
	if spawn then
		-- Cancel any fall speed first, or a rescue from deep space ends in fall damage.
		player:add_velocity(vector.multiply(player:get_velocity(), -1))
		player:set_pos(vector.offset(spawn, 0, 0.5, 0))
		return true
	end
	return false
end

core.register_on_newplayer(function(player)
	core.after(0.5, function()
		if player:is_player() then
			csd_core.send_to_spawn(player)
		end
	end)
end)

-- Personal respawn points (cryopods, beds): func(player) -> pos or nil.
local home_providers = {}
function csd_core.register_home_provider(func)
	table.insert(home_providers, func)
end

function csd_core.get_home(player)
	for _, func in ipairs(home_providers) do
		local pos = func(player)
		if pos then return pos end
	end
end

core.register_on_respawnplayer(function(player)
	local home = csd_core.get_home(player)
	if home then
		player:set_pos(home)
		return true
	end
	return csd_core.send_to_spawn(player)
end)

core.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	update_nametag(player)
	-- Builders get their bundle even if `builder` came from give_to_admin.
	if csd_core.is_builder(name) then
		set_bundle(name, true)
	end
	if not csd_core.get_job(name) then
		core.after(1.5, function()
			if core.get_player_by_name(name) then
				csd_core.show_job_picker(name)
			end
		end)
	end
end)

core.register_on_leaveplayer(function(player)
	last_warning[player:get_player_name()] = nil
end)

core.register_chatcommand("spawn", {
	description = S("Go back to the arrivals lounge"),
	func = function(name)
		local player = core.get_player_by_name(name)
		if player and csd_core.send_to_spawn(player) then
			return true
		end
		return false, S("The ship has no spawn point yet.")
	end,
})

core.register_chatcommand("setshipspawn", {
	description = S("Set the crew spawn point to where you stand"),
	privs = {builder = true},
	func = function(name)
		local player = core.get_player_by_name(name)
		if not player then return false end
		csd_core.set_spawn(player:get_pos())
		return true, S("Spawn point set.")
	end,
})
dofile(core.get_modpath("csd_core") .. "/seats.lua")
if core.global_exists("player_api") then
	dofile(core.get_modpath("csd_core") .. "/crawl.lua")
end

------------------------------------------------------------------------------
-- Particle preference (decorative particles: star drift, haze, sparks...)
------------------------------------------------------------------------------

local PARTICLE_LEVELS = {full = 1, low = 0.35, off = 0}

-- 1 = full, 0.35 = low, 0 = off. Multiply decorative particle amounts by this.
function csd_core.particle_level(name)
	local player = core.get_player_by_name(name)
	if not player then return 0 end
	local v = player:get_meta():get_string("csd_core:particles")
	return PARTICLE_LEVELS[v] or 1
end

core.register_chatcommand("particles", {
	params = "full | low | off",
	description = S("How many decorative particles you see (star drift, haze, sparks)"),
	func = function(name, param)
		param = param:trim():lower()
		local player = core.get_player_by_name(name)
		if not player then return false end
		if not PARTICLE_LEVELS[param] then
			local cur = player:get_meta():get_string("csd_core:particles")
			return true, S("Particles: @1. Use /particles full, low or off.", cur ~= "" and cur or "full")
		end
		player:get_meta():set_string("csd_core:particles", param)
		return true, S("Particles set to @1.", param)
	end,
})
