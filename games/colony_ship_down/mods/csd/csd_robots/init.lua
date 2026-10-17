-- The robot crew: service robots that stroll the corridors.
--
-- Punch (prod) one and it squeaks and complains. Right-click to talk: ask
-- who it is, how the ship is doing (it'll suggest a task), where a room is
-- (it marks the way), whether a room is free to claim, or for a joke.
-- Their skins are also offered to players through skinsdb.
--
-- Builders: /robots respawn puts the whole robot crew back at their posts.

csd_robots = {}
local S = core.get_translator("csd_robots")
local has_ship = core.get_modpath("csd_ship") ~= nil
local has_tasks = core.get_modpath("csd_tasks") ~= nil

------------------------------------------------------------------------------
-- The crew
------------------------------------------------------------------------------

-- deck: which deck it patrols; x: where it starts in the corridor
csd_robots.crew = {
	{id = "b0b", name = "B-0B", role = S("Greeter"), skin = 1, deck = 2, x = -120,
		about = S("I'm B-0B, the Arrivals greeter. I've welcomed 4,109 colonists. Most of them are asleep in cryo. Rude."),
		hello = {S("Welcome aboard!"), S("Hello, colonist!"), S("Need directions? Just ask.")},
		ow = {S("Ow! I mean... beep."), S("Please do not prod the greeter."), S("That's going in my report.")}},
	{id = "mop3", name = "MOP-3", role = S("Custodian"), skin = 2, deck = 2, x = -40,
		about = S("MOP-3, custodial unit. I clean. You walk on what I clean. That is our relationship."),
		hello = {S("Mind the wet floor."), S("Wipe your boots."), S("*whirr*")},
		ow = {S("I just polished that dent!"), S("Hey!"), S("My mop has feelings too.")}},
	{id = "volt", name = "VOLT", role = S("Maintenance"), skin = 3, deck = 4, x = -100,
		about = S("VOLT, maintenance drone. If it sparks, I fix it. If it doesn't spark, I make it spark, then fix it."),
		hello = {S("Watch the cables."), S("Everything's fine. Probably."), S("Have you checked the capacitor?")},
		ow = {S("Zzzt! Don't do that."), S("You'll void my warranty!"), S("Ouch. Recalibrating...")}},
	{id = "nurse", name = "NURSE-7", role = S("Medical"), skin = 4, deck = 2, x = 30,
		about = S("NURSE-7, medical assistant. Please report to the Medbay for your scan. Everyone is overdue."),
		hello = {S("Stay hydrated."), S("Have you had your scan?"), S("You look pale. Space-pale.")},
		ow = {S("Assault on medical staff noted."), S("Ow! Do you need a scan?"), S("I can see you have no manners.")}},
	{id = "chef", name = "CHEF-BOT", role = S("Galley"), skin = 5, deck = 2, x = -70,
		about = S("CHEF-BOT. I make algae paste in forty-one flavours. They all taste like algae paste."),
		hello = {S("Lunch is algae."), S("Today's special: also algae."), S("Hungry?")},
		ow = {S("Do not poke the chef!"), S("You'll spill the soup!"), S("Hmph.")}},
	{id = "nav", name = "ASTRA", role = S("Navigation"), skin = 6, deck = 1, x = 40,
		about = S("ASTRA, navigation assistant. We are 212 years from the colony world. Approximately. Give or take."),
		hello = {S("Course nominal."), S("Stars look nice tonight. Every night."), S("212 years to go!")},
		ow = {S("You knocked my gyroscope."), S("Course correction... on my face."), S("Hey!")}},
	{id = "sprout", name = "SPROUT", role = S("Hydroponics"), skin = 7, deck = 3, x = -50,
		about = S("SPROUT, gardening unit. I talk to the plants. They don't talk back, but they listen."),
		hello = {S("The ferns say hi."), S("Have you watered anything today?"), S("Photosynthesis!")},
		ow = {S("Careful, I'm full of fertiliser."), S("Oof."), S("The plants saw that.")}},
	{id = "cargo", name = "HAUL-9", role = S("Cargo"), skin = 8, deck = 4, x = -50,
		about = S("HAUL-9, cargo loader. I lift crates. Some crates have snacks. I'm not allowed to tell you which."),
		hello = {S("Heavy lifting!"), S("Crates restock every couple of hours."), S("Mind your toes.")},
		ow = {S("I could lift you, you know."), S("Rude."), S("*clank*")}},
}
csd_robots.by_id = {}
for _, r in ipairs(csd_robots.crew) do csd_robots.by_id[r.id] = r end

local JOKES = {
	S("Why did the robot go on holiday? It needed to recharge."),
	S("I'd tell you a UDP joke, but you might not get it."),
	S("What's a robot's favourite music? Heavy metal."),
	S("The airlock and I have a lot in common. We both let people go."),
	S("How many robots does it take to change a light? None, we just upgrade your eyes."),
	S("I asked the reactor how it was doing. It said it was a little unstable. Same."),
}

------------------------------------------------------------------------------
-- Skins for players (skinsdb)
------------------------------------------------------------------------------

if core.global_exists("skins") and skins.new then
	for _, r in ipairs(csd_robots.crew) do
		local skin = skins.new("csd_robot_" .. r.id)
		skin:set_texture("csd_robots_skin_" .. r.skin .. ".png")
		skin:set_meta("format", "1.0")
		skin:set_meta("name", S("Robot: @1", r.name))
		skin:set_meta("author", "Colony Ship Down")
		skin:set_meta("license", "CC0")
		skin:set_meta("_sort_id", 4000 + r.skin)
		skin:set_hand_from_texture()
	end
end

------------------------------------------------------------------------------
-- Speech
------------------------------------------------------------------------------

local function say(self, text)
	local def = csd_robots.by_id[self._id]
	if not def then return end
	local pos = self.object:get_pos()
	self.object:set_nametag_attributes({text = def.name .. "\n\"" .. text .. "\"", color = "#9fe8ff"})
	self._speech_until = core.get_us_time() + 4e6
	if core.global_exists("proxchat") and proxchat.speak then
		proxchat.speak(pos, def.name, text)
	end
	core.sound_play("csd_robots_beep" .. math.random(1, 3), {pos = pos, gain = 0.6, max_hear_distance = 16,
		pitch = 0.9 + math.random() * 0.3}, true)
end

local function pick(list) return list[math.random(#list)] end

------------------------------------------------------------------------------
-- Dialogue
------------------------------------------------------------------------------

local talking = {} -- player name -> robot luaentity
local waypoints = {} -- player name -> hud id

local KEY_ROOMS = {
	S("Arrivals Lounge"), S("Medbay"), S("Mess Hall"), S("Hydroponics"), S("Reactor Room"),
	S("Bridge"), S("Shuttle Bay"), S("Machine Shop"), S("Observation Deck"), S("Electrical"),
	S("Aquarium"), S("Petting Zoo"),
}

-- Room names are translatable strings from csd_ship, ours are from
-- csd_robots: compare the plain English text.
local function plain(s) return core.get_translated_string("en", s) end

local function find_room(name)
	local data = has_ship and csd_ship.get_ship_data()
	local want = plain(name)
	for _, r in ipairs(data and data.rooms or {}) do
		if plain(r.name) == want then return r end
	end
end

local function room_center(r)
	return vector.new(math.floor((r.minp.x + r.maxp.x) / 2), r.minp.y, math.floor((r.minp.z + r.maxp.z) / 2))
end

local function mark(player, pos, label)
	local name = player:get_player_name()
	if waypoints[name] then player:hud_remove(waypoints[name]) end
	waypoints[name] = player:hud_add({
		type = "waypoint", name = label, text = "m", precision = 1, number = 0x9fe8ff,
		world_pos = vector.offset(pos, 0, 1, 0), z_index = 6,
	})
	local id = waypoints[name]
	core.after(120, function()
		local p = core.get_player_by_name(name)
		if p and waypoints[name] == id then
			p:hud_remove(id)
			waypoints[name] = nil
		end
	end)
end

local function directions(from, to)
	local parts = {}
	local fdeck = has_ship and csd_ship.deck_at(from)
	local tdeck = has_ship and csd_ship.deck_at(to)
	if fdeck and tdeck and fdeck ~= tdeck then
		parts[#parts + 1] = S("take a gravity lift @1 to deck @2", tdeck < fdeck and S("up") or S("down"), tdeck)
	end
	local dx = to.x - from.x
	if math.abs(dx) > 8 then
		parts[#parts + 1] = S("head @1 about @2 metres", dx > 0 and S("forward (towards the bow)") or S("aft (towards the engines)"),
			math.floor(math.abs(dx)))
	end
	if #parts == 0 then return S("It's right around here!") end
	return table.concat(parts, S(", then ")) .. "."
end

local function talk_formspec(robot, text, buttons)
	local def = csd_robots.by_id[robot._id]
	local fs = {
		"formspec_version[6]size[11,8.4]no_prepend[]bgcolor[#00000099;true]",
		"background9[0,0;11,8.4;csd_tasks_panel.png;true;8]",
		"image[0.4,0.4;1.6,3.2;csd_robots_portrait_", def.skin, ".png]",
		"label[2.3,0.7;", core.colorize("#9fe8ff", core.formspec_escape(def.name .. " - " .. def.role)), "]",
		"textarea[2.3,1.1;8.3,2.6;;;", core.formspec_escape(text), "]",
	}
	for i, b in ipairs(buttons) do
		local x = (i - 1) % 2 == 0 and 0.4 or 5.6
		local y = 4.0 + math.floor((i - 1) / 2) * 0.95
		fs[#fs + 1] = ("button[%f,%f;5,0.8;%s;%s]"):format(x, y, b[1], core.formspec_escape(b[2]))
	end
	return table.concat(fs)
end

local MAIN_MENU = {
	{"who", S("Who are you?")}, {"ship", S("How's the ship doing?")},
	{"where", S("Where is...?")}, {"room", S("Is there a free room?")},
	{"joke", S("Tell me a joke.")}, {"bye", S("Bye!")},
}

local function show_main(player, robot, text)
	talking[player:get_player_name()] = robot
	core.show_formspec(player:get_player_name(), "csd_robots:talk", talk_formspec(robot, text, MAIN_MENU))
end

local function ship_report()
	if not has_tasks then return S("All systems... I don't know, honestly.") end
	local worst, wv = nil, 101
	for _, id in ipairs(csd_tasks.system_order) do
		local v = csd_tasks.get_system(id)
		if v < wv then worst, wv = id, v end
	end
	local title = csd_tasks.systems[worst].title
	if wv >= 70 then
		return S("Everything's looking good! Lowest is @1 at @2%.", title, math.floor(wv))
	end
	local suggestion
	for _, t in pairs(csd_tasks.tasks) do
		if t.system == worst then suggestion = t.title break end
	end
	return S("@1 is down to @2%. Someone should @3 - any station helps, even if it isn't on your list.",
		title, math.floor(wv), suggestion and suggestion:lower() or S("look into it"))
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "csd_robots:talk" then return end
	local name = player:get_player_name()
	local robot = talking[name]
	if not robot or not robot.object:get_pos() or fields.quit or fields.bye then
		if robot and robot.object:get_pos() and fields.bye then say(robot, S("Bye!")) end
		talking[name] = nil
		if fields.bye then core.close_formspec(name, formname) end
		return true
	end
	local def = csd_robots.by_id[robot._id]
	if fields.who then
		show_main(player, robot, def.about)
	elseif fields.ship then
		show_main(player, robot, ship_report())
	elseif fields.joke then
		show_main(player, robot, pick(JOKES))
	elseif fields.room then
		local data = has_ship and csd_ship.get_ship_data()
		local best, bd
		for _, r in ipairs(data and data.rooms or {}) do
			if r.claimable and not csd_ship.claim_owner(r) then
				local d = vector.distance(player:get_pos(), room_center(r))
				if not bd or d < bd then best, bd = r, d end
			end
		end
		if best then
			mark(player, room_center(best), best.name)
			show_main(player, robot, S("@1 is free. I've marked it for you - go there and type /claim. To get there, @2",
				best.name, directions(player:get_pos(), room_center(best))))
		else
			show_main(player, robot, S("Every room is taken! It's cosy aboard."))
		end
	elseif fields.where then
		local buttons = {}
		for i, room in ipairs(KEY_ROOMS) do buttons[#buttons + 1] = {"go" .. i, room} end
		buttons[#buttons + 1] = {"back", S("Never mind")}
		core.show_formspec(name, formname, talk_formspec(robot, S("Where to?"), buttons))
	elseif fields.back then
		show_main(player, robot, pick(def.hello))
	else
		for i, room in ipairs(KEY_ROOMS) do
			if fields["go" .. i] then
				local r = find_room(room)
				if r then
					mark(player, room_center(r), room)
					show_main(player, robot, S("@1 is on deck @2. I've marked it - @3", room, r.deck,
						directions(player:get_pos(), room_center(r))))
				else
					show_main(player, robot, S("Hmm, I don't think this ship has one of those."))
				end
			end
		end
	end
	return true
end)

core.register_on_leaveplayer(function(player)
	talking[player:get_player_name()] = nil
	waypoints[player:get_player_name()] = nil
end)

------------------------------------------------------------------------------
-- The robot entity
------------------------------------------------------------------------------

local SPEED = 1.1
local ANIM = player_api.registered_models["character.b3d"].animations

------------------------------------------------------------------------------
-- Health: guns (and fists) damage robots. At 0 HP a robot shuts down where it
-- stands, sparking, until someone patches it up (right-click with a Robot
-- Repair Kit, scrap metal or a steel ingot) - or it reboots itself after a
-- long while.
------------------------------------------------------------------------------

local MAX_HP = 40
local REBOOT_TIME = 15 * 60
local REPAIRS = {
	["csd_robots:repair_kit"] = MAX_HP,
	["csd_tasks:scrap_metal"] = 10,
	["default:steel_ingot"] = 10,
}

core.register_craftitem("csd_robots:repair_kit", {
	description = S("Robot Repair Kit") .. "\n" .. core.colorize("#9aa7c0", S("Right-click a damaged robot to fix it")),
	inventory_image = "csd_robots_repair_kit.png",
})
core.register_craft({
	output = "csd_robots:repair_kit",
	recipe = {
		{"csd_tasks:scrap_metal", "default:copper_ingot", "csd_tasks:scrap_metal"},
		{"", "csd_tasks:scrap_metal", ""},
	},
})

local function robot_sparks(pos, amount)
	core.add_particlespawner({
		amount = amount, time = 0.5, pos = {min = vector.offset(pos, -0.3, 0.3, -0.3), max = vector.offset(pos, 0.3, 1.4, 0.3)},
		vel = {min = vector.new(-2, 0, -2), max = vector.new(2, 3, 2)}, acc = vector.new(0, -9, 0),
		exptime = {min = 0.3, max = 0.8}, size = {min = 0.5, max = 1.2}, glow = 14,
		texture = "csd_ship_spark.png",
	})
end

local function corridor_range(deck)
	-- Stay out of the two-deck reactor hall (no corridor floor on deck 3 there).
	local lo = (deck == 3) and -158 or -198
	return lo, 168
end

core.register_entity("csd_robots:robot", {
	initial_properties = {
		visual = "mesh", mesh = "character.b3d", textures = {"csd_robots_skin_1.png"},
		visual_size = {x = 1, y = 1},
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		physical = true, collide_with_objects = true, stepheight = 0.6,
		makes_footstep_sound = true, static_save = true,
		nametag_color = "#9fe8ff",
	},
	on_activate = function(self, staticdata)
		local data = core.deserialize(staticdata or "") or {}
		self._id = data.id or "b0b"
		self._deck = data.deck or 2
		self._z = data.z or 0
		self._hp = data.hp or MAX_HP
		self._down_since = data.down
		local def = csd_robots.by_id[self._id] or csd_robots.crew[1]
		self.object:set_properties({textures = {"csd_robots_skin_" .. def.skin .. ".png"}})
		self.object:set_nametag_attributes({text = def.name, color = "#9fe8ff"})
		self.object:set_armor_groups({immortal = 1})
		self.object:set_acceleration({x = 0, y = -9.81, z = 0})
		self._anim = nil
		self._target = nil
		self._pause = math.random() * 4
		self._greeted = {}
		if self._hp <= 0 or self._down_since then self:shut_down(true) end
	end,
	get_staticdata = function(self)
		return core.serialize({id = self._id, deck = self._deck, z = self._z, hp = self._hp, down = self._down_since})
	end,
	set_anim = function(self, anim)
		if self._anim ~= anim then
			self._anim = anim
			self.object:set_animation(ANIM[anim], anim == "walk" and 20 or 30, 0, true)
		end
	end,
	shut_down = function(self, quiet)
		if not quiet then self._hp = 0 end
		self._down_since = self._down_since or os.time()
		self._target = nil
		self.object:set_velocity({x = 0, y = 0, z = 0})
		self.object:set_animation(ANIM.lay, 30, 0, true)
		self._anim = "lay"
		self.object:set_nametag_attributes({text = csd_robots.by_id[self._id].name .. " " .. S("(OFFLINE)"), color = "#ff6040"})
		if not quiet then
			robot_sparks(self.object:get_pos(), 60)
			core.sound_play("csd_events_impact", {pos = self.object:get_pos(), gain = 0.6, pitch = 1.4, max_hear_distance = 20}, true)
		end
	end,
	boot_up = function(self)
		self._hp = MAX_HP
		self._down_since = nil
		self._anim = nil
		self._pause = 2
		self.object:set_nametag_attributes({text = csd_robots.by_id[self._id].name, color = "#9fe8ff"})
		say(self, S("Rebooting... Systems nominal. Thank you!"))
	end,
	on_punch = function(self, puncher, _, tool_capabilities)
		if self._down_since then return true end
		local dmg = 0
		for _, v in pairs(tool_capabilities and tool_capabilities.damage_groups or {}) do
			if type(v) == "number" then dmg = dmg + v end
		end
		self._hp = self._hp - math.max(1, math.floor(dmg + 0.5))
		robot_sparks(self.object:get_pos(), 8)
		if self._hp <= 0 then
			self:shut_down()
			return true
		end
		if puncher and puncher:is_player() then
			local def = csd_robots.by_id[self._id]
			say(self, pick(def.ow))
			local dir = vector.direction(puncher:get_pos(), self.object:get_pos())
			self.object:add_velocity({x = dir.x * 2, y = 2.5, z = dir.z * 2})
			self._pause = 2
		end
		return true -- damage is our own HP, not the engine's
	end,
	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then return end
		local stack = clicker:get_wielded_item()
		local heal = REPAIRS[stack:get_name()]
		if heal and self._hp < MAX_HP then
			local was_down = self._down_since ~= nil
			self._hp = math.min(MAX_HP, math.max(self._hp, 0) + heal)
			if not core.is_creative_enabled(clicker:get_player_name()) then
				stack:take_item()
				clicker:set_wielded_item(stack)
			end
			core.sound_play("csd_tasks_click", {pos = self.object:get_pos(), gain = 0.6}, true)
			if was_down and self._hp >= MAX_HP / 2 then
				self:boot_up()
			elseif was_down then
				core.chat_send_player(clicker:get_player_name(),
					S("Repairs: @1/@2. It needs @3 more to reboot.", self._hp, MAX_HP, MAX_HP / 2 - self._hp))
			else
				say(self, S("Repairs: @1/@2. Much better.", self._hp, MAX_HP))
			end
			return
		end
		if self._down_since then
			core.chat_send_player(clicker:get_player_name(),
				S("This robot is offline. Fix it with a Robot Repair Kit, scrap metal or steel ingots."))
			return
		end
		self._pause = 30
		self.object:set_yaw(core.dir_to_yaw(vector.direction(self.object:get_pos(), clicker:get_pos())))
		self:set_anim("stand")
		show_main(clicker, self, pick(csd_robots.by_id[self._id].hello))
	end,
	on_step = function(self, dtime)
		local obj = self.object
		local pos = obj:get_pos()
		local vel = obj:get_velocity()
		if self._down_since then
			obj:set_velocity({x = 0, y = vel.y, z = 0})
			if math.random() < dtime * 0.4 then robot_sparks(pos, 5) end
			if self._down_since and os.time() - self._down_since > REBOOT_TIME then self:boot_up() end
			return
		end
		if self._speech_until and core.get_us_time() > self._speech_until then
			self._speech_until = nil
			obj:set_nametag_attributes({text = csd_robots.by_id[self._id].name, color = "#9fe8ff"})
		end
		-- Someone nearby? Stop, face them, maybe say hello.
		for _, p in ipairs(core.get_connected_players()) do
			local d = vector.distance(p:get_pos(), pos)
			if d < 3.5 then
				self._pause = math.max(self._pause, 1.5)
				obj:set_yaw(core.dir_to_yaw(vector.direction(pos, p:get_pos())))
				local n = p:get_player_name()
				if not self._greeted[n] or core.get_us_time() - self._greeted[n] > 120e6 then
					self._greeted[n] = core.get_us_time()
					say(self, pick(csd_robots.by_id[self._id].hello))
				end
				break
			end
		end
		if self._pause > 0 then
			self._pause = self._pause - dtime
			obj:set_velocity({x = 0, y = vel.y, z = 0})
			self:set_anim("stand")
			return
		end
		if not self._target then
			local lo, hi = corridor_range(self._deck)
			local O = has_ship and csd_ship.layout.origin or vector.zero()
			self._target = O.x + math.random(lo, hi)
			self._stuck, self._last_x = 0, pos.x
		end
		local dx = self._target - pos.x
		if math.abs(dx) < 0.5 then
			self._target = nil
			self._pause = 3 + math.random() * 6
			return
		end
		local dirx = dx > 0 and 1 or -1
		local O = has_ship and csd_ship.layout.origin or vector.zero()
		local vz = ((O.z + self._z) - pos.z) * 0.8
		obj:set_velocity({x = dirx * SPEED, y = vel.y, z = vz})
		obj:set_yaw(core.dir_to_yaw({x = dirx, y = 0, z = 0}))
		self:set_anim("walk")
		-- Give up on targets we can't reach.
		self._stuck = (self._stuck or 0) + dtime
		if self._stuck > 3 then
			if math.abs(pos.x - (self._last_x or pos.x)) < 1 then
				self._target = nil
				self._pause = 2
			end
			self._stuck, self._last_x = 0, pos.x
		end
	end,
})

------------------------------------------------------------------------------
-- Spawning
------------------------------------------------------------------------------

function csd_robots.spawn_crew()
	if not has_ship then return 0 end
	local L = csd_ship.layout
	-- Clear any robots already aboard (in loaded areas).
	for _, obj in ipairs(core.get_objects_in_area(vector.add(L.origin, vector.new(-260, -10, -60)),
			vector.add(L.origin, vector.new(260, 50, 60)))) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "csd_robots:robot" then obj:remove() end
	end
	local n = 0
	for i, r in ipairs(csd_robots.crew) do
		local z = (i % 2 == 0) and 1 or -1
		local pos = vector.add(L.origin, vector.new(r.x, L.floor_y(r.deck) + 0.5, z))
		local obj = core.add_entity(pos, "csd_robots:robot", core.serialize({id = r.id, deck = r.deck, z = z}))
		if obj then n = n + 1 end
	end
	return n
end

if has_ship then
	csd_ship.register_on_built(function()
		-- The fresh ship's blocks are loaded right after building.
		core.after(2, csd_robots.spawn_crew)
	end)
end

core.register_chatcommand("robots", {
	params = "respawn",
	description = S("Put the robot crew back at their posts"),
	privs = {builder = true},
	func = function(_, param)
		if param ~= "respawn" then return false, S("Usage: /robots respawn") end
		return true, S("@1 robots reporting for duty.", csd_robots.spawn_crew())
	end,
})
