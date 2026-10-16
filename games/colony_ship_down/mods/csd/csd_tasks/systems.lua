-- Ship systems. Each is a 0-100 condition that wears down while crew are
-- aboard; tasks and repairs bring it back up. Other mods react through
-- csd_tasks.register_on_system_change (e.g. csd_ship dims lights on low power).

local S = csd_tasks.S
local storage = core.get_mod_storage()

csd_tasks.systems = {}
csd_tasks.system_order = {}

function csd_tasks.register_system(id, def)
	def.id = id
	csd_tasks.systems[id] = def
	table.insert(csd_tasks.system_order, id)
end

csd_tasks.register_system("power",        {title = S("Power"),        color = "#ffcc33"})
csd_tasks.register_system("life_support", {title = S("Life Support"), color = "#66ddff"})
csd_tasks.register_system("navigation",   {title = S("Navigation"),   color = "#88aaff"})
csd_tasks.register_system("hull",         {title = S("Hull"),         color = "#cccccc"})
csd_tasks.register_system("comms",        {title = S("Comms"),        color = "#cc88ff"})
csd_tasks.register_system("hydroponics",  {title = S("Hydroponics"),  color = "#77dd66"})
csd_tasks.register_system("morale",       {title = S("Morale"),       color = "#ffaa77"})

local levels = core.deserialize(storage:get_string("systems")) or {}
for _, id in ipairs(csd_tasks.system_order) do
	levels[id] = levels[id] or 80
end

local change_callbacks = {}
function csd_tasks.register_on_system_change(func)
	table.insert(change_callbacks, func)
end

local function save()
	storage:set_string("systems", core.serialize(levels))
end

function csd_tasks.get_system(id)
	return levels[id] or 0
end

function csd_tasks.set_system(id, value)
	if not csd_tasks.systems[id] then return end
	value = math.max(0, math.min(100, value))
	local old = levels[id]
	if old == value then return end
	levels[id] = value
	save()
	for _, func in ipairs(change_callbacks) do
		func(id, value, old)
	end
end

function csd_tasks.add_system(id, amount)
	csd_tasks.set_system(id, csd_tasks.get_system(id) + amount)
end

-- Wear: every minute each system loses DECAY points, scaled by how many
-- people are aboard (a lone player isn't swamped, a full ship keeps busy).
local DECAY = tonumber(core.settings:get("csd_system_decay")) or 1.5
csd_tasks.decay_multiplier = {} -- system id -> multiplier, set by events

local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 60 then return end
	timer = 0
	local players = #core.get_connected_players()
	if players == 0 then return end
	local load = math.max(0.4, math.min(2.0, players / 3))
	for _, id in ipairs(csd_tasks.system_order) do
		local mult = csd_tasks.decay_multiplier[id] or 1
		csd_tasks.add_system(id, -DECAY * load * mult * (0.6 + math.random() * 0.8))
	end
end)

core.register_chatcommand("ship", {
	description = S("Show the condition of the ship's systems"),
	func = function()
		local out = {}
		for _, id in ipairs(csd_tasks.system_order) do
			out[#out + 1] = ("%s %d%%"):format(csd_tasks.systems[id].title, math.floor(levels[id] + 0.5))
		end
		return true, table.concat(out, " | ")
	end,
})

core.register_chatcommand("setsystem", {
	params = S("<system> <0-100>"),
	description = S("Set a ship system's condition"),
	privs = {server = true},
	func = function(_, param)
		local id, value = param:match("^(%S+)%s+(%d+)$")
		if not id or not csd_tasks.systems[id] then
			return false, S("Systems: @1", table.concat(csd_tasks.system_order, ", "))
		end
		csd_tasks.set_system(id, tonumber(value))
		return true
	end,
})
